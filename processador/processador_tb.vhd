LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY processador_tb IS
END ENTITY;

ARCHITECTURE rtl OF processador_tb IS

    COMPONENT processador PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        Estado : OUT unsigned(1 DOWNTO 0);
        PC_out : OUT unsigned(6 DOWNTO 0);
        Instr : OUT unsigned(13 DOWNTO 0);
        -- Reg1 : OUT unsigned(15 DOWNTO 0);
        -- Reg2 : OUT unsigned(15 DOWNTO 0);
        ULA_out : OUT unsigned(15 DOWNTO 0)
        );
    END COMPONENT;


    signal clk  : std_logic;
    signal rst : std_logic;
    signal Estado : unsigned(1 downto 0);
    signal PC_out : unsigned(6 downto 0);
    signal Instr : unsigned(13 downto 0);
    signal ula_out_debug : unsigned(15 downto 0);

    constant period_time : time := 10 ns;
    signal finished : std_logic := '0';

    begin 

    uut : processador port map(
        rst => rst,
        clk => clk,
        Estado => Estado,
        PC_out => PC_out,
        Instr => Instr,
        ULA_out => ula_out_debug
    );

    reset_global : PROCESS
    BEGIN
        rst <= '1';
        WAIT FOR period_time * 2; -- espera 2 clocks, pra garantir
        rst <= '0';
        WAIT;
    END PROCESS;

    sim_time_proc : PROCESS
    BEGIN
        WAIT FOR 10 us; -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
        finished <= '1';
        WAIT;
    END PROCESS sim_time_proc;

    clk_proc : PROCESS
    BEGIN -- gera clock até que sim_time_proc termine
        WHILE finished /= '1' LOOP
            clk <= '0';
            WAIT FOR period_time/2;
            clk <= '1';
            WAIT FOR period_time/2;
        END LOOP;
        WAIT;
    END PROCESS clk_proc;



    end architecture;