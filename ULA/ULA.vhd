library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ULA is
    port(
        IN_A : in unsigned(15 downto 0);
        IN_B : in unsigned(15 downto 0);
        CTRL : in unsigned(1 downto 0);
        OUT_C : out unsigned(15 downto 0) := "0000000000000000";
        OUT_D : out unsigned(1 downto 0) := "00"
    );
end entity;

architecture rtl of ULA is

    component multiplicador
    port(
        WORD_A, WORD_B : in unsigned(15 downto 0);
        RES_LSB, RES_MSB : out unsigned(15 downto 0) := "0000000000000000"
    );
    end component;
    
    component comparador
    port(
        WA, WB : in unsigned(15 downto 0);
        RES : out unsigned(1 downto 0) := "00"
    );
    end component;

    signal WORD_A_MULT, WORD_B_MULT : unsigned(15 downto 0); 
    signal RES_MULT : unsigned(15 downto 0);

    signal WORD_A_COMP, WORD_B_COMP : unsigned(15 downto 0);
    signal RES_COMP : unsigned(1 downto 0);

begin

    WORD_A_MULT <= IN_A;
    WORD_B_MULT <= IN_B;

    WORD_A_COMP <= IN_A; 
    WORD_B_COMP <= IN_B;


    uut0 : multiplicador port map(
        WORD_A => WORD_A_MULT,
        WORD_B => WORD_B_MULT,
        RES_LSB => RES_MULT
    );

    uut1 : comparador port map(
        WA => WORD_A_COMP,
        WB => WORD_B_COMP,
        RES => RES_COMP
    );

    OUT_C <= RES_MULT when CTRL = "00" else
        --   RES_SOMA when CTRL = "01" else
        --   RES_SUB  when CTRL = "10" else
             "0000000000000000";
    OUT_D <= RES_COMP;

end architecture rtl;