library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula is
    port(
        IN_A    : in unsigned(15 downto 0);
        IN_B    : in unsigned(15 downto 0);
        SEL     : in unsigned(1 downto 0);
        OUT_C   : out unsigned(15 downto 0)
    );
end entity;

architecture rtl of ula is

    signal S_IN_A   : unsigned(15 downto 0) := "0000000000000000"; 
    signal S_IN_B   : unsigned(15 downto 0) := "0000000000000000"; 
    signal S_OUT_C  : unsigned(15 downto 0) := "0000000000000000";
    signal S_SEL    : unsigned(1 downto 0)  := "00"; 

    signal RES_MAIOR  : unsigned(15 downto 0) := "0000000000000000"; 
    signal RES_EQUAL  : unsigned(15 downto 0) := "0000000000000000"; 
    signal RES_SUB    : unsigned(15 downto 0) := "0000000000000000";
    signal RES_SOMA   : unsigned(15 downto 0) := "0000000000000000";

begin

    S_IN_A  <= IN_A;
    S_IN_B  <= IN_B;
    OUT_C   <= S_OUT_C;
    S_SEL   <= SEL;

    RES_SOMA  <= S_IN_A + S_IN_B ;
    RES_SUB   <= S_IN_A - S_IN_B ;
    RES_MAIOR <= "0000000000000001" when S_IN_A > S_IN_B else
                 "0000000000000000";
    RES_EQUAL <= "0000000000000001" when S_IN_A = S_IN_B else
                 "0000000000000000";
    

    S_OUT_C <= RES_SOMA  when S_SEL = "00" else  --SOMA
               RES_MAIOR when S_SEL = "01" else  --MAIOR
               RES_SUB when S_SEL = "10" else  --SUB
               RES_EQUAL when S_SEL = "11" else  --IGUAL
               "0000000000000000";

end architecture rtl;