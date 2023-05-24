library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux2to1 is
    port(
        IN_A  : in signed(15 downto 0);
        IN_B  : in signed(15 downto 0);
        SEL   : in std_logic;
        OUT_C : out signed(15 downto 0)
    );
end entity;

architecture rtl of mux2to1 is

begin
    
    OUT_C <= IN_A when SEL = '1' else
             IN_B when SEL = '0' else
             "0000000000000000";

end architecture;
    
