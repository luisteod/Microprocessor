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
    0 => "01" & "000" & "0101" & "011" & "00", --Carrega R3 (o registrador 3) com o valor 5
    1 => "01" & "000" & "1000" & "100" & "00", --Carrega R4 com 8
    2 => "00" & "011" & "100"& "0" & "101" & "00", --Soma R3 com R4 e guarda em R5
    3 => "01" & "101" & "0001" & "101" & "10", --Subtrai 1 de R5
    4 => "11" & "00000" & "0010100", --Salta para o endereço 20
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
    20 => "00" & "000" & "101" & "0" & "011" & "00", --No endereço 20, copia R5 para R3 
    21 => "11" & "00000" & "0000011", --Salta para a terceira instrução desta lista (R5 <= R3+R4)
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