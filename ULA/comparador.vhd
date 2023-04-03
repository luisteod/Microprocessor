library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity comparador is  
    port(
        WA, WB : in unsigned(15 downto 0);
        RES : out unsigned(1 downto 0) := "00" 
    );
end entity;

architecture rtl of comparador is
begin
    RES <= "11" when WA > WB else
           "00" when WA < WB else 
           "01" when WA = WB else
           "00";     
end architecture rtl;