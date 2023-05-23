-- D Flip-Flop
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY flipFlop IS
    PORT (
        WR_EN : IN STD_LOGIC;
        D : IN STD_LOGIC; -- Data input
        CLK : IN STD_LOGIC; -- Clock input
        Q : OUT STD_LOGIC -- Output
    );
END ENTITY;

ARCHITECTURE Behavioral OF flipFlop IS
BEGIN
    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN -- Detect rising edge of the clock signal
            IF WR_EN ='1' THEN
                Q <= D; -- Assign input data to output
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE Behavioral;