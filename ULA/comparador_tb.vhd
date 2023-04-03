library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity comparador_tb is
end entity;

architecture rtl of comparador_tb is

    component comparador 
        port(
            WA, WB  : in unsigned(15 downto 0);
            RES : out unsigned(1 downto 0) := "00"
        );
    end component;

    signal WA,WB : unsigned(15 downto 0);
    signal RES : unsigned(1 downto 0) := "00";
    
    begin
        uut : comparador port map( WA => WA,
                                   WB => WB,
                                   RES => RES);
    process
    begin
        WA <= "1000000000000000";
        WB <= "0000000000000000";
        wait for 50 ns;
        WA <= "0000000000000000";
        WB <= "1000000000000000";
        wait for 50 ns;
        WA <= "0000000000000000";
        WB <= "0000000000000000";
        wait for 50 ns;
        wait;    
    end process;
    
end architecture rtl;