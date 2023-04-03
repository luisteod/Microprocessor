library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multiplicador_tb is
end entity;

architecture rtl of multiplicador_tb is

    component multiplicador
    port(
        NIBBLE_A, NIBBLE_B : in unsigned(15 downto 0);
        RES_LSB, RES_MSB : out unsigned(15 downto 0) := "0000000000000000"
    );
    end component;

    signal NIBBLE_A, NIBBLE_B : unsigned(15 downto 0);
    signal RES_LSB, RES_MSB : unsigned(15 downto 0) := "0000000000000000";

    begin 

    uut : multiplicador port map(
        NIBBLE_A => NIBBLE_A,
        NIBBLE_B => NIBBLE_B,
        RES_LSB => RES_LSB,
        RES_MSB => RES_MSB
    );

    process
    begin
        NIBBLE_A <= "1111111111111111";
        NIBBLE_B <= "1111111111111111";
        wait for 50 ns;
        NIBBLE_A <= "0000000000000000";
        NIBBLE_B <= "0000000000000000";
        wait for 50 ns;
        wait;
    end process;

end  architecture;
    