library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity soma_subt is
  port  ( x,y : in unsigned(15 downto 0);
          saida_soma: out unsigned(15 downto 0);
          saida_sub: out unsigned(15 downto 0)
        );
end soma_subt; 

architecture a_soma_subt of soma_subt is

begin  
  saida_soma <= x+y; 
  saida_sub  <= x-y;
           
end architecture;