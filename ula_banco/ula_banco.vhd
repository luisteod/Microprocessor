library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula_banco is
    port(
        CLK     : in std_logic;
        RST     : in std_logic;
        WR_EN   : in std_logic;
        CONST   : in unsigned(15 downto 0); 

        --DEBBUG
        DEBUG           : out unsigned(15 downto 0);
        ULA_OP_BUG      : in unsigned(1 downto 0);
        REG_IN_A_BUG    : in unsigned(2 downto 0);
        REG_IN_B_BUG    : in unsigned(2 downto 0);
        REG_IN_C_BUG    : in unsigned(2 downto 0);
        MUX_SEL_BUG     : in std_logic
    );
end entity;

architecture rtl of ula_banco is

    component ula
    port(
        IN_A    : in unsigned(15 downto 0);
        IN_B    : in unsigned(15 downto 0);
        SEL     : in unsigned(1 downto 0);
        OUT_C   : out unsigned(15 downto 0)
    );
    end component;

    component banco_reg
    port(
        IN_REG_A   : in unsigned(2 downto 0);
        IN_REG_B   : in unsigned(2 downto 0);
        IN_REG_C   : in unsigned(2 downto 0);
        WR_EN      : in std_logic;
        CLK        : in std_logic;
        RST        : in std_logic;
        DATA_IN    : in unsigned (15 downto 0);
        OUT_REG_A  : out unsigned(15 downto 0);
        OUT_REG_B  : out unsigned(15 downto 0)
    );
    end component;

    component mux2to1 
    port(
        IN_A  : in unsigned(15 downto 0);
        IN_B  : in unsigned(15 downto 0);
        SEL   : in std_logic;
        OUT_C : out unsigned(15 downto 0)
    );
    end component;

    signal ULA_IN_A : unsigned(15 downto 0); 
    signal ULA_IN_B : unsigned(15 downto 0); 
    signal ULA_OUT  : unsigned(15 downto 0);
    signal ULA_SEL  : unsigned(1 downto 0);

    signal BANCO_IN_REG_A   : unsigned(2 downto 0);
    signal BANCO_IN_REG_B   : unsigned(2 downto 0);
    signal BANCO_IN_REG_C   : unsigned(2 downto 0);
    signal BANCO_DATA_IN    : unsigned(15 downto 0);
    signal BANCO_OUT_REG_A  : unsigned(15 downto 0);
    signal BANCO_OUT_REG_B  : unsigned(15 downto 0);
    signal BANCO_WR_EN      : std_logic;
    signal BANCO_CLK        : std_logic;
    signal BANCO_RST        : std_logic;

    signal MUX_IN_A         : unsigned(15 downto 0);
    signal MUX_IN_B         : unsigned(15 downto 0);
    signal MUX_SEL          : std_logic;
    signal MUX_OUT_C        : unsigned(15 downto 0);

begin

    ula_comp : ula port map(
        IN_A  =>  ULA_IN_A,
        IN_B  =>  ULA_IN_B,
        SEL   =>  ULA_SEL,
        OUT_C =>  ULA_OUT
    );

    banco_comp : banco_reg port map(
        IN_REG_A  => BANCO_IN_REG_A,
        IN_REG_B  => BANCO_IN_REG_B,
        IN_REG_C  => BANCO_IN_REG_C,
        WR_EN     => BANCO_WR_EN,
        CLK       => BANCO_CLK,
        RST       => BANCO_RST,
        DATA_IN   => BANCO_DATA_IN,
        OUT_REG_A => BANCO_OUT_REG_A,
        OUT_REG_B => BANCO_OUT_REG_B
    );

    mux_comp : mux2to1 port map(
        IN_A  => MUX_IN_A,
        IN_B  => MUX_IN_B,
        SEL   => MUX_SEL,
        OUT_C => MUX_OUT_C
    );

    --SAIDA DA ULA NO BANCO
    BANCO_DATA_IN   <= ULA_OUT;
    --SAIDA A DO BANCO NA ULA A
    ULA_IN_A        <= BANCO_OUT_REG_A;
    --SAIDA B DO BANCO NO MUX
    MUX_IN_A        <= BANCO_OUT_REG_B;
    --SAIDA DO MUX NA ULA B
    ULA_IN_B        <= MUX_OUT_C;
    --CONSTANTE INTERNA
    MUX_IN_B        <= CONST;
    --PINOS CLK, RST E WR_EN
    BANCO_CLK       <= CLK;
    BANCO_RST       <= RST;
    BANCO_WR_EN     <= WR_EN;
    --DEBUGGER
    DEBUG           <= ULA_OUT;
    ULA_SEL         <= ULA_OP_BUG;
    BANCO_IN_REG_A  <= REG_IN_A_BUG;
    BANCO_IN_REG_B  <= REG_IN_B_BUG;
    BANCO_IN_REG_C  <= REG_IN_C_BUG;
    MUX_SEL         <= MUX_SEL_BUG;

end architecture;



    