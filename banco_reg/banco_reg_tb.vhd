LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY banco_reg_tb IS
END ENTITY;

ARCHITECTURE rtl OF banco_reg_tb IS

    COMPONENT banco_reg
        PORT (
            IN_REG_A : IN unsigned(2 DOWNTO 0);
            IN_REG_B : IN unsigned(2 DOWNTO 0);
            IN_REG_C : IN unsigned(2 DOWNTO 0);
            WR_EN : IN STD_LOGIC;
            CLK : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            DATA_IN : IN unsigned (15 DOWNTO 0);
            OUT_REG_A : OUT unsigned(15 DOWNTO 0);
            OUT_REG_B : OUT unsigned(15 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL IN_REG_A, IN_REG_B, IN_REG_C : unsigned(2 DOWNTO 0);
    SIGNAL WR_EN, CLK, RST : STD_LOGIC;
    SIGNAL DATA_IN, OUT_REG_A, OUT_REG_B : unsigned(15 DOWNTO 0);
    CONSTANT period_time : TIME := 100 ns;
    SIGNAL finished : STD_LOGIC := '0';

BEGIN

    uut : banco_reg PORT MAP(
        IN_REG_A => IN_REG_A,
        IN_REG_B => IN_REG_B,
        IN_REG_C => IN_REG_C,
        WR_EN => WR_EN,
        CLK => CLK,
        RST => RST,
        DATA_IN => DATA_IN,
        OUT_REG_A => OUT_REG_A,
        OUT_REG_B => OUT_REG_B
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
        WAIT FOR period_time * 3;
        IN_REG_A <= "001";
        IN_REG_B <= "010";
        IN_REG_C <= "100";
        DATA_IN <= "1100000000000000";
        WR_EN <= '1';
        WAIT FOR 200 ns;
        IN_REG_A <= "100";
        IN_REG_B <= "011";
        IN_REG_C <= "101";
        DATA_IN <= "0000001100000000";
        WR_EN <= '0';
        WAIT FOR 200 ns;
        IN_REG_A <= "101";
        IN_REG_B <= "100";
        IN_REG_C <= "111";
        WR_EN <= '1';
        WAIT FOR 200 ns;
        IN_REG_A <= "111";
        WAIT FOR 200 ns;
        WAIT;
    END PROCESS;

END ARCHITECTURE;