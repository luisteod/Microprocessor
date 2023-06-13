LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ula_banco_ram IS
    PORT (
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        WR_EN : IN STD_LOGIC;
        CONST : IN signed(15 DOWNTO 0); --Immediate constant
        DEBUG : OUT signed(15 DOWNTO 0); --Out of ULA
        ULA_OP : IN unsigned(1 DOWNTO 0);
        REG_IN_A : IN unsigned(2 DOWNTO 0);
        REG_IN_B : IN unsigned(2 DOWNTO 0);
        REG_IN_C : IN unsigned(2 DOWNTO 0);
        MUX_SEL : IN STD_LOGIC;
        WR_EN_RAM : IN STD_LOGIC;
        RD_EN_RAM : IN STD_LOGIC
    );
END ENTITY;

ARCHITECTURE rtl OF ula_banco_ram IS

    COMPONENT ula
        PORT (
            IN_A : IN signed(15 DOWNTO 0);
            IN_B : IN signed(15 DOWNTO 0);
            SEL : IN unsigned(1 DOWNTO 0);
            OUT_C : OUT signed(15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT banco_reg
        PORT (
            IN_REG_A : IN unsigned(2 DOWNTO 0);
            IN_REG_B : IN unsigned(2 DOWNTO 0);
            IN_REG_C : IN unsigned(2 DOWNTO 0);
            WR_EN : IN STD_LOGIC;
            CLK : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            DATA_IN : IN signed (15 DOWNTO 0);
            OUT_REG_A : OUT signed(15 DOWNTO 0);
            OUT_REG_B : OUT signed(15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT mux2to1
        PORT (
            IN_A : IN signed(15 DOWNTO 0);
            IN_B : IN signed(15 DOWNTO 0);
            SEL : IN STD_LOGIC;
            OUT_C : OUT signed(15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT ram
        PORT (
            clk : IN STD_LOGIC;
            endereco : IN unsigned(6 DOWNTO 0);
            wr_en : IN STD_LOGIC;
            dado_in : IN signed(15 DOWNTO 0);
            dado_out : OUT signed(15 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL ULA_IN_A : signed(15 DOWNTO 0);
    SIGNAL ULA_IN_B : signed(15 DOWNTO 0);
    SIGNAL ULA_OUT : signed(15 DOWNTO 0);
    SIGNAL ULA_SEL : unsigned(1 DOWNTO 0);

    SIGNAL BANCO_IN_REG_A : unsigned(2 DOWNTO 0);
    SIGNAL BANCO_IN_REG_B : unsigned(2 DOWNTO 0);
    SIGNAL BANCO_IN_REG_C : unsigned(2 DOWNTO 0);
    SIGNAL BANCO_DATA_IN : signed(15 DOWNTO 0);
    SIGNAL BANCO_OUT_REG_A : signed(15 DOWNTO 0);
    SIGNAL BANCO_OUT_REG_B : signed(15 DOWNTO 0);
    SIGNAL BANCO_WR_EN : STD_LOGIC;
    SIGNAL BANCO_CLK : STD_LOGIC;
    SIGNAL BANCO_RST : STD_LOGIC;

    SIGNAL RAM_ADD : unsigned(6 DOWNTO 0);
    SIGNAL RAM_IN : signed(15 DOWNTO 0);
    SIGNAL RAM_OUT : signed(15 DOWNTO 0);

    SIGNAL MUX_IN_A : signed(15 DOWNTO 0);
    SIGNAL MUX_IN_B : signed(15 DOWNTO 0);
    SIGNAL MUX_SEL_S : STD_LOGIC;
    SIGNAL MUX_OUT_C : signed(15 DOWNTO 0);

BEGIN

    ula_comp : ula PORT MAP(
        IN_A => ULA_IN_A,
        IN_B => ULA_IN_B, --Adicionar metodo para entrar valor da RAM aqui 
        SEL => ULA_SEL,
        OUT_C => ULA_OUT
    );

    banco_comp : banco_reg PORT MAP(
        IN_REG_A => BANCO_IN_REG_A,
        IN_REG_B => BANCO_IN_REG_B,
        IN_REG_C => BANCO_IN_REG_C,
        WR_EN => BANCO_WR_EN,
        CLK => BANCO_CLK,
        RST => BANCO_RST,
        DATA_IN => BANCO_DATA_IN,
        OUT_REG_A => BANCO_OUT_REG_A,
        OUT_REG_B => BANCO_OUT_REG_B
    );

    mux_comp : mux2to1 PORT MAP(
        IN_A => MUX_IN_A,
        IN_B => MUX_IN_B,
        SEL => MUX_SEL_S,
        OUT_C => MUX_OUT_C
    );

    ram_comp : ram PORT MAP(
        clk => CLK,
        endereco => RAM_ADD,
        wr_en => WR_EN_RAM,
        dado_in => RAM_IN,
        dado_out => RAM_OUT
    );

    --ENDEREÇO DA RAM É O CONTEUDO DO REG B OU DO REG A DEPENDENDO DA OPERAÇÃO
    RAM_ADD <= unsigned(BANCO_OUT_REG_B(6 DOWNTO 0)) WHEN RD_EN_RAM = '1' ELSE
        unsigned(BANCO_OUT_REG_A(6 DOWNTO 0));

    --SAIDA DA ULA NO BANCO
    BANCO_DATA_IN <= ULA_OUT;
    --SAIDA DA ULA NA RAM
    RAM_IN <= ULA_OUT;

    --SAIDA A DO BANCO NA ULA A
    ULA_IN_A <= BANCO_OUT_REG_A;

    --ENTADA A DO MUX RECEBE SAIDA B DO BANCO OU SAIDA DA RAM
    MUX_IN_A <= RAM_OUT WHEN RD_EN_RAM = '1' ELSE
        BANCO_OUT_REG_B;
    --ENTADA B DO MUX RECEBE CONSTANTE
    MUX_IN_B <= CONST;
    --SAIDA DO MUX NA ULA B
    ULA_IN_B <= MUX_OUT_C;

    --PINOS CLK, RST E WR_EN
    BANCO_CLK <= CLK;
    BANCO_RST <= RST;
    BANCO_WR_EN <= WR_EN;
    --DEBUGGER
    DEBUG <= ULA_OUT;
    ULA_SEL <= ULA_OP;
    BANCO_IN_REG_A <= REG_IN_A;
    BANCO_IN_REG_B <= REG_IN_B;
    BANCO_IN_REG_C <= REG_IN_C;
    MUX_SEL_S <= MUX_SEL;

END ARCHITECTURE;