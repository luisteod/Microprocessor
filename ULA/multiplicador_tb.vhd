library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multiplicador_tb is
end entity;

architecture rtl of multiplicador_tb is

    component multiplicador
    port(
        WORD_A, WORD_B : in unsigned(15 downto 0);
        RES_LSB, RES_MSB : out unsigned(15 downto 0) := "0000000000000000"
    );
    end component;

    signal WORD_A, WORD_B : unsigned(15 downto 0);
    signal RES_LSB, RES_MSB : unsigned(15 downto 0) := "0000000000000000";

    begin 

    uut : multiplicador port map(
        WORD_A => WORD_A,
        WORD_B => WORD_B,
        RES_LSB => RES_LSB,
        RES_MSB => RES_MSB
    );

    process
    begin
        WORD_A <= "1111111111111111";
        WORD_B <= "1111111111111111";
        wait for 50 ns;
        WORD_A <= "0000000000000000";
        WORD_B <= "0000000000000000";
        wait for 50 ns;
        wait;
    end process;

end  architecture;
    