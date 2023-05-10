LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ula_banco_tb IS
END ENTITY;

ARCHITECTURE rtl OF ula_banco_tb IS

    COMPONENT ula_banco
        PORT (
            CLK : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            WR_EN : IN STD_LOGIC;
            CONST : IN unsigned(15 DOWNTO 0);

            DEBUG : OUT unsigned(15 DOWNTO 0);
            ULA_OP : IN unsigned(1 DOWNTO 0);
            REG_IN_A : IN unsigned(2 DOWNTO 0);
            REG_IN_B : IN unsigned(2 DOWNTO 0);
            REG_IN_C : IN unsigned(2 DOWNTO 0);
            MUX_SEL : IN STD_LOGIC
        );
    END COMPONENT;

    SIGNAL clk, rst, wr_en : STD_LOGIC;
    SIGNAL const : unsigned(15 DOWNTO 0);
    SIGNAL ula_out : unsigned(15 DOWNTO 0);
    SIGNAL ula_op : unsigned(1 DOWNTO 0);
    SIGNAL reg_in_a : unsigned(2 DOWNTO 0);
    SIGNAL reg_in_b : unsigned(2 DOWNTO 0);
    SIGNAL reg_in_c : unsigned(2 DOWNTO 0);
    SIGNAL mux_sel : STD_LOGIC;

    CONSTANT period_time : TIME := 100 ns;
    SIGNAL finished : STD_LOGIC := '0';

BEGIN

    uut : ula_banco PORT MAP(
        CLK => clk,
        RST => rst,
        WR_EN => wr_en,
        CONST => const,

        DEBUG => ula_out,
        ULA_OP => ula_op,
        REG_IN_A => reg_in_a,
        REG_IN_B => reg_in_b,
        REG_IN_C => reg_in_c,
        MUX_SEL => mux_sel
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

    PROCESS
    BEGIN
        wr_en <= '0';
        ula_op <= "00";
        reg_in_a <= "001";
        reg_in_b <= "000";
        reg_in_c <= "001";
        mux_sel <= '0';
        const <= "0000000000000001";
        WAIT FOR 200 ns;
        wr_en <= '1';
        ula_op <= "00";
        reg_in_a <= "001";
        reg_in_b <= "000";
        reg_in_c <= "001";
        mux_sel <= '0';
        const <= "0000000000000001";
        WAIT FOR 200 ns;
        wr_en <= '0';
        WAIT FOR 50 ns;
        WAIT;
    END PROCESS;

END ARCHITECTURE;