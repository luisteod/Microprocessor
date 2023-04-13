library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity registrador_tb is
end entity;

architecture rtl of registrador_tb is
    component registrador 
    port(
        rst : in std_logic;
        clk : in std_logic;
        wr_en : in std_logic;
        data_in : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0) 
    );
    end component;

    signal rst, clk, wr_en : std_logic := '0';
    signal data_in, data_out : unsigned(15 downto 0) := "0000000000000000";

begin
        reg : registrador port map(
            rst => rst,
            clk => clk,
            wr_en => wr_en,
            data_in => data_in,
            data_out => data_out
        );

    process
    begin
        data_in <= "0000000000000001";
        wr_en <= '1'; 
        wait for 10 ns;
        clk <= '1';
        wait for 50 ns;
        clk <= '0';
        wr_en <= '0';
        wait for 50 ns;
        data_in <= "0000010011100001";
        wr_en <= '1'; 
        wait for 10 ns;
        clk <= '1';
        wait for 50 ns;
        wait;
    end process;
end architecture;

