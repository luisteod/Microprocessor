LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY controle IS
    PORT (
        wr_en : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        data_in : INOUT unsigned(6 DOWNTO 0); --Entrada do contador
        data_out : INOUT unsigned(6 DOWNTO 0) := "0000000"; --Saida do contador
        dado : OUT unsigned(13 DOWNTO 0) --Saida da Rom (instructions)
    );
END controle;

ARCHITECTURE arch OF controle IS
    COMPONENT pc
        PORT (
            wr_en : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            data_in : IN unsigned(6 DOWNTO 0);
            data_out : OUT unsigned(6 DOWNTO 0) := "0000000"
        );
    END COMPONENT;

    --Declarando rom
    COMPONENT rom
        PORT (
            clock : IN STD_LOGIC;
            endereco : IN unsigned(6 DOWNTO 0);
            dado : OUT unsigned(13 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT maquina_estados
        PORT (
            rst : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            estado : INOUT STD_LOGIC := '0'
        );
    END COMPONENT;

    SIGNAL estado_s : STD_LOGIC; -- out of state mach
    SIGNAL clk_pc_s : STD_LOGIC;

BEGIN
    uut : pc PORT MAP(
        wr_en => estado_s,
        clk => clk_pc_s, -- clk of PC is on the rising edge of top-level clk  
        rst => rst,
        data_in => data_in,
        data_out => data_out
    );

    uup : rom PORT MAP(
        clock => clk,
        endereco => data_out,
        dado => dado
    );

    maq_est : maquina_estados
    PORT MAP(
        rst => rst,
        clk => clk,
        estado => estado_s
    );
    
    clk_pc_s <= estado_s; --clock for incrementing pc is dependent of the state generate by state machine     

    data_in <= "0000000" WHEN data_out = "1111111" ELSE
        data_out + "0000001";

END ARCHITECTURE;