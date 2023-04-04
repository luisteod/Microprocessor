library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ULA_tb is
end entity;

architecture rtl of ULA_tb is

    component ULA
    port(
        IN_A : in unsigned(15 downto 0);
        IN_B : in unsigned(15 downto 0);
        CTRL : in unsigned(1 downto 0);
        OUT_C : out unsigned(15 downto 0) := "0000000000000000";
        OUT_D : out unsigned(1 downto 0) := "00"
    );
    end component;

    signal WA, WB, OUT_C : unsigned(15 downto 0);
    signal CTRL, OUT_D : unsigned(1 downto 0);

begin

    uut : ULA port map(
        IN_A => WA,
        IN_B => WB,
        CTRL => CTRL,
        OUT_C => OUT_C,
        OUT_D => OUT_D
    );

process
begin
    --soma
    WA <= "0000000000000000";
    WB <= "1010101011010010";
    CTRL <= "01";
    wait for 50 ns;
    --sub
    WA <= "1000000000001101";
    WB <= "0010101011010010";
    CTRL <= "10";
    wait for 50 ns;
    --mult
    WA <= "0000000000000000";
    WB <= "0010101011011011";
    CTRL <= "00";
    wait for 50 ns;
    wait;
end process;

end architecture;