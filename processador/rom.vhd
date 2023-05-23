LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY rom IS
  PORT (
    clock : IN STD_LOGIC;
    endereco : IN unsigned(6 DOWNTO 0);
    dado : OUT unsigned(13 DOWNTO 0)
  );
END rom;

ARCHITECTURE arch OF rom IS
  TYPE mem IS ARRAY (0 TO 127) OF unsigned(13 DOWNTO 0);
  CONSTANT conteudo_rom : mem := (
    0 => "01" & "000" & "0000" & "011" & "00", --Carrega R3 (o registrador 3) com o valor 0
    1 => "01" & "000" & "0000" & "100" & "00", --Carrega R4 com 8
    2 => "00" & "011" & "100"& "0" & "100" & "00", --Soma R3 com R4 e guarda em R4  
    3 => "01" & "011" & "0001" & "011" & "00", --Subtrai 1 de R5 --Soma 1 em R3
    4 =>    , --Se R3<30 salta para a instrução do passo 3 *
    5 => "00000000000000",
    6 => "00000000000000",
    7 => "00000000000000",
    8 => "00000000000000",
    9 => "00000000000000",
    10 => "00000000000000",
    11 => "00000000000000",
    12 => "00000000000000",
    13 => "00000000000000",
    14 => "00000000000000",
    15 => "00000000000000",
    16 => "00000000000000",
    17 => "00000000000000",
    18 => "00000000000000",
    19 => "00000000000000",
    20 => "00000000000000",
    21 => "00000000000000",
    OTHERS => (OTHERS => '0')
  );
BEGIN
  PROCESS (clock)
  BEGIN
    IF (rising_edge(clock)) THEN
      dado <= conteudo_rom(to_integer(endereco));
    END IF;
  END PROCESS;

END ARCHITECTURE;