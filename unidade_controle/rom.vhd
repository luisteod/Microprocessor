library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity rom is
  port (
        clock     : in std_logic;
        endereco  : in unsigned(6 downto 0);
        dado      : out unsigned(13 downto 0) 
  ) ;
end rom ; 

architecture arch of rom is
  type mem is array (0 to 127) of unsigned(13 downto 0);
  constant conteudo_rom : mem := (
    0 => "00000000000000",
    1 => "11010000000010",
    2 => "11110000000100", --Go to 4
    3 => "11110000000000",
    4 => "11110000000010",
    5 => "00000000000010",
    6 => "00111100000011",
    7 => "00000000000010",
    8 => "00000000000010",
    9 => "00000000000000",
    10 => "00000000000000",
    others => (others=>'0')
 );
begin
  process(clock)
    begin
      if(rising_edge(clock)) then
        dado <= conteudo_rom(to_integer(endereco));
      end if;
  end process;

end architecture ;