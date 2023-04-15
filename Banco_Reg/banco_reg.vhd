library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity banco_reg is
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
end entity;

architecture rtl of banco_reg is

    component registrador
    port(
        rst         : in std_logic;
        clk         : in std_logic;
        wr_en       : in std_logic;
        data_in     : in unsigned(15 downto 0);
        data_out    : out unsigned(15 downto 0) 
    );
    end component;

    signal data_out_0, data_out_1,
           data_out_2, data_out_3, 
           data_out_4, data_out_5, 
           data_out_6, data_out_7   : unsigned(15 downto 0) := "0000000000000000"; 
    
    signal wr_0, wr_1, 
           wr_2, wr_3,
           wr_4, wr_5,
           wr_6, wr_7               : std_logic := '0';


begin 

    reg0 : registrador port map(
        rst      => RST,
        clk      => CLK,
        wr_en    => wr_0,
        data_in  => DATA_IN,
        data_out => data_out_0
    );

    reg1 : registrador port map(
        rst      => RST,
        clk      => CLK,
        wr_en    => wr_1,
        data_in  => DATA_IN,
        data_out => data_out_1
    );

    reg2 : registrador port map(
        rst      => RST,
        clk      => CLK,
        wr_en    => wr_2,
        data_in  => DATA_IN,
        data_out => data_out_2
    );
    reg3 : registrador port map(
        rst      => RST,
        clk      => CLK,
        wr_en    => wr_3,
        data_in  => DATA_IN,
        data_out => data_out_3
    );
    reg4 : registrador port map(
        rst      => RST,
        clk      => CLK,
        wr_en    => wr_4,
        data_in  => DATA_IN,
        data_out => data_out_4
    );
    reg5 : registrador port map(
        rst      => RST,
        clk      => CLK,
        wr_en    => wr_5,
        data_in  => DATA_IN,
        data_out => data_out_5
    );

    reg6 : registrador port map(
        rst      => RST,
        clk      => CLK,
        wr_en    => wr_6,
        data_in  => DATA_IN,
        data_out => data_out_6
    );

    reg7 : registrador port map(
        rst      => RST,
        clk      => CLK,
        wr_en    => wr_7,
        data_in  => DATA_IN,
        data_out => data_out_7
    );

    --LEITURA DO BARRAMENTO A
    OUT_REG_A <= data_out_0 when IN_REG_A="000" else
                 data_out_1 when IN_REG_A="001" else
                 data_out_2 when IN_REG_A="010" else
                 data_out_3 when IN_REG_A="011" else
                 data_out_4 when IN_REG_A="100" else
                 data_out_5 when IN_REG_A="101" else
                 data_out_6 when IN_REG_A="110" else
                 data_out_7 when IN_REG_A="111" else
                 "0000000000000000";
    
    --LEITURA DO BARRAMENTO B
    OUT_REG_B <= data_out_0 when IN_REG_B="000" else
                 data_out_1 when IN_REG_B="001" else
                 data_out_2 when IN_REG_B="010" else
                 data_out_3 when IN_REG_B="011" else
                 data_out_4 when IN_REG_B="100" else
                 data_out_5 when IN_REG_B="101" else
                 data_out_6 when IN_REG_B="110" else
                 data_out_7 when IN_REG_B="111" else
                 "0000000000000000";
    
    
    --ESCRITA NO BARRAMENTO C
    process(WR_EN, IN_REG_C)
    begin
        if(WR_EN = '1') then
            if(IN_REG_C = "001") then
                wr_1 <= '1';
            elsif IN_REG_C = "010" then
                wr_2 <= '1';
            elsif IN_REG_C = "011" then
                wr_3 <= '1';
            elsif IN_REG_C = "100" then
                wr_4 <= '1';               
            elsif IN_REG_C = "101" then
                wr_5 <= '1'; 
            elsif IN_REG_C = "110" then
                wr_6 <= '1';
            elsif IN_REG_C = "111" then
                wr_7 <= '1';
            end if; 
        else
            wr_1 <= '0';
            wr_2 <= '0';
            wr_3 <= '0';
            wr_4 <= '0';
            wr_5 <= '0';
            wr_6 <= '0';
            wr_7 <= '0';
        end if;
    end process;
          

end architecture;         


