LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ula IS
    PORT (
        IN_A : IN signed(15 DOWNTO 0);
        IN_B : IN signed(15 DOWNTO 0);
        SEL : IN unsigned(1 DOWNTO 0);
        OUT_C : OUT signed(15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF ula IS

    SIGNAL S_IN_A : signed(15 DOWNTO 0) := "0000000000000000";
    SIGNAL S_IN_B : signed(15 DOWNTO 0) := "0000000000000000";
    SIGNAL S_OUT_C : signed(15 DOWNTO 0) := "0000000000000000";
    SIGNAL S_SEL : unsigned(1 DOWNTO 0) := "00";

    SIGNAL RES_CMP : signed(15 DOWNTO 0) := "0000000000000000";
    SIGNAL RES_MOV : signed(15 DOWNTO 0) := "0000000000000000";
    SIGNAL RES_SUB : signed(15 DOWNTO 0) := "0000000000000000";
    SIGNAL RES_ADD : signed(15 DOWNTO 0) := "0000000000000000";

BEGIN

    S_IN_A <= IN_A;
    S_IN_B <= IN_B;
    OUT_C <= S_OUT_C;
    S_SEL <= SEL;

    RES_ADD <= S_IN_A + S_IN_B;
    RES_SUB <= S_IN_A - S_IN_B;
    RES_CMP <= S_IN_A - S_IN_B;
    RES_MOV <= S_IN_B;

    S_OUT_C <= RES_ADD WHEN S_SEL = "00" ELSE --ADD
        RES_CMP WHEN S_SEL = "01" ELSE --CMP
        RES_SUB WHEN S_SEL = "10" ELSE --SUB
        RES_MOV WHEN S_SEL = "11" ELSE --MOV
        "0000000000000000";

END ARCHITECTURE rtl;