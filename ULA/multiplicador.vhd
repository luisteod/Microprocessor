library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multiplicador is 
    port(
        NIBBLE_A, NIBBLE_B : in unsigned(15 downto 0);
        RES_LSB, RES_MSB : out unsigned(15 downto 0) := "0000000000000000"
    );
end entity;

architecture rtl of multiplicador is
signal AUX : unsigned(31 downto 0) := "00000000000000000000000000000000";
begin
    AUX <= NIBBLE_A * NIBBLE_B;
    RES_LSB <= AUX(15 downto 0);
    RES_MSB <= AUX(31 downto 16);
end architecture;