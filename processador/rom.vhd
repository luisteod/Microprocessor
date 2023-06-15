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
    0 => "01" & "001" & "0000010" & "11", --MOVI R1, 2
    1 => "01" & "010" & "0000010" & "11", --MOVI R2, 2                                                 
    2 => "00" & "001" & "001" & "00" & "01" & "11", -- inicializa MOVI [R1], R1              
    3 => "01" & "001" & "0000001" & "00", -- ADDI R1, 1                                                       
    4 => "01" & "001" & "0100001" & "01", -- CMPI R1, 33                                                       
    5 => "10" & "10" & "00" & "11111101", -- JUMPR flag_n, inicializa                           
    6 => "01" & "001" & "0000010" & "11",-- MOVI R1, 2
    7 => "00" & "010" & "001" & "00" & "00" & "11",-- MOVR R2, R1
    8 => "00" & "010" & "001" & "00" & "00" & "00",-- ADDR R2, R1
    9 => "00" & "010" & "000" & "00" & "01" & "11", --MOV [R2], R0 
    10 => "00" & "010" & "001" & "00" & "00" & "00", --ADDR R2, R1
    11 => "01" & "010" & "0100001" & "01", -- CMPI R2, 33   
    12 => "10" & "10" & "00" & "11111101",--JUMPR flag_n, marca2
    13 => "01" & "001" & "0000001" & "00",--ADDI R1, 1    
    14 => "00" & "001" & "000" & "00" & "10" & "01", --CMPR [R1], R0
    15 => "10" & "01" & "00" & "11111000", --JUMPR flag_nz, marca
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