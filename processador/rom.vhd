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
    0 => "00" & "011" & "000" & "0000" & "11", --Carrega R3 (o registrador 3) com o valor 0                             0. MOV $R3,$[0x10]
    1 => "00" & "100" & "000" & "0000" & "11", --Carrega R4 com 0                                                       1. MOV $R4,$R0
    2 => "00" & "100" & "011" & "0000" & "00", --Soma R3 com R4 e guarda em R4                                          2. ADD $R4,$R3
    3 => "01" & "011" & "0000001" & "00", --Soma 1 em R3                                                                3. ADDI $R3,1   
    4 => "01" & "011" & "0011110" & "01", --Compara R3 com 30                                                           4. CMP $R3,30
    5 => "10" & "10" & "00" & "11111101", --Se R3<30 salta para a instrução do passo 3 *                                5. JMPR flag_neg,-3
    6 => "00" & "101" & "100" & "0000" & "11", --Copia valor de R4 para R5                                              6. MOV $R5,$R4
    7 => "01" & "111" & "1000000" & "11", --Copia o valor de 0x40 no R7                                                 7. MOV $R7, 0x40
    8 => "00" & "111" & "101" & "00" & "01" & "11", --Copia o valor de R5 para o endereço apontado pelo R7              8. MOV [$R7], $R5
    9 => "00" & "011" & "111" & "00" & "10" & "11", --Copia o valor do apontado por R7 para R3                          9. MOV $R3,[$R7]
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
  -- PROCESS (clock)
  -- BEGIN
  --   IF (rising_edge(clock)) THEN
  --     dado <= conteudo_rom(to_integer(endereco));
  --   END IF;
  -- END PROCESS;

  dado <= conteudo_rom(to_integer(endereco));

END ARCHITECTURE;