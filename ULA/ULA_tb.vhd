library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ULA_tb is
end entity;

architecture rtl of ULA_tb is

    component ULA
    port(
        IN_A  : in unsigned(15 downto 0);
        IN_B  : in unsigned(15 downto 0);
        SEL   : in unsigned(1 downto 0);
        OUT_C : out unsigned(15 downto 0) 
    );
    end component;

    signal S_IN_A, S_IN_B, S_OUT_C : unsigned(15 downto 0);
    signal S_SEL : unsigned(1 downto 0);

begin

    uut : ULA port map(
        IN_A  => S_IN_A,
        IN_B  => S_IN_B,
        SEL   => S_SEL,
        OUT_C => S_OUT_C
    );

process
begin
    --SOMA
    S_IN_A <= "0000000000000001";
    S_IN_B <= "0000000000000001";
    S_SEL  <= "00";
    wait for 50 ns;
    --MENOR
    S_IN_A <= "1000000000001101";
    S_IN_B <= "0010101011010010";
    S_SEL  <= "01";
    wait for 50 ns;
    --SUB
    S_IN_A <= "0000000000000000";
    S_IN_B <= "0010101011011011";
    S_SEL  <= "10";
    wait for 50 ns;
    --EQUAL
    S_IN_A <= "0000000000000000";
    S_IN_B <= "0000000000000001";
    S_SEL  <= "11";
    wait for 50 ns;
    wait;
end process;

end architecture;