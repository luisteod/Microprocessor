LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY banco_reg IS
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
END ENTITY;

ARCHITECTURE rtl OF banco_reg IS

    COMPONENT registrador
        PORT (
            rst : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            wr_en : IN STD_LOGIC;
            data_in : IN signed(15 DOWNTO 0);
            data_out : OUT signed(15 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL data_out_0, data_out_1,
    data_out_2, data_out_3,
    data_out_4, data_out_5,
    data_out_6, data_out_7 : signed(15 DOWNTO 0);
    SIGNAL wr_0, wr_1,
    wr_2, wr_3,
    wr_4, wr_5,
    wr_6, wr_7 : STD_LOGIC ;
BEGIN

    reg0 : registrador PORT MAP(
        rst => RST,
        clk => CLK,
        wr_en => wr_0,
        data_in => DATA_IN,
        data_out => data_out_0
    );

    reg1 : registrador PORT MAP(
        rst => RST,
        clk => CLK,
        wr_en => wr_1,
        data_in => DATA_IN,
        data_out => data_out_1
    );

    reg2 : registrador PORT MAP(
        rst => RST,
        clk => CLK,
        wr_en => wr_2,
        data_in => DATA_IN,
        data_out => data_out_2
    );
    reg3 : registrador PORT MAP(
        rst => RST,
        clk => CLK,
        wr_en => wr_3,
        data_in => DATA_IN,
        data_out => data_out_3
    );
    reg4 : registrador PORT MAP(
        rst => RST,
        clk => CLK,
        wr_en => wr_4,
        data_in => DATA_IN,
        data_out => data_out_4
    );
    reg5 : registrador PORT MAP(
        rst => RST,
        clk => CLK,
        wr_en => wr_5,
        data_in => DATA_IN,
        data_out => data_out_5
    );

    reg6 : registrador PORT MAP(
        rst => RST,
        clk => CLK,
        wr_en => wr_6,
        data_in => DATA_IN,
        data_out => data_out_6
    );

    reg7 : registrador PORT MAP(
        rst => RST,
        clk => CLK,
        wr_en => wr_7,
        data_in => DATA_IN,
        data_out => data_out_7
    );

    --LEITURA DO BARRAMENTO A
    OUT_REG_A <= data_out_0 WHEN IN_REG_A = "000" ELSE
        data_out_1 WHEN IN_REG_A = "001" ELSE
        data_out_2 WHEN IN_REG_A = "010" ELSE
        data_out_3 WHEN IN_REG_A = "011" ELSE
        data_out_4 WHEN IN_REG_A = "100" ELSE
        data_out_5 WHEN IN_REG_A = "101" ELSE
        data_out_6 WHEN IN_REG_A = "110" ELSE
        data_out_7 WHEN IN_REG_A = "111" ELSE
        "0000000000000000";

    --LEITURA DO BARRAMENTO B
    OUT_REG_B <= data_out_0 WHEN IN_REG_B = "000" ELSE
        data_out_1 WHEN IN_REG_B = "001" ELSE
        data_out_2 WHEN IN_REG_B = "010" ELSE
        data_out_3 WHEN IN_REG_B = "011" ELSE
        data_out_4 WHEN IN_REG_B = "100" ELSE
        data_out_5 WHEN IN_REG_B = "101" ELSE
        data_out_6 WHEN IN_REG_B = "110" ELSE
        data_out_7 WHEN IN_REG_B = "111" ELSE
        "0000000000000000";


    wr_0 <= '0'; --Registrado 0 sempre possui 0, é apenas read-only

    wr_1 <= '1' WHEN IN_REG_C = "001" AND WR_EN = '1' ELSE
        '0';
    wr_2 <= '1' WHEN IN_REG_C = "010" AND WR_EN = '1' ELSE
        '0';
    wr_3 <= '1' WHEN IN_REG_C = "011" AND WR_EN = '1' ELSE
        '0';
    wr_4 <= '1' WHEN IN_REG_C = "100" AND WR_EN = '1' ELSE
        '0';
    wr_5 <= '1' WHEN IN_REG_C = "101" AND WR_EN = '1' ELSE
        '0';
    wr_6 <= '1' WHEN IN_REG_C = "110" AND WR_EN = '1' ELSE
        '0';
    wr_7 <= '1' WHEN IN_REG_C = "111" AND WR_EN = '1' ELSE
        '0';

END ARCHITECTURE;