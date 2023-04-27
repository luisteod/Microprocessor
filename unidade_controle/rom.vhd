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
    0 => "00000000000010",
    1 => "00100000000000",
    2 => "00000000000000",
    3 => "00000000000011",
    4 => "00100000000000",
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