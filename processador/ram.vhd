library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity ram is
  port (
    clk : in std_logic;
    endereco : in unsigned(6 downto 0);
    wr_en : in std_logic;
    dado_in : in signed(15 downto 0);
    dado_out : out signed(15 downto 0)
  ) ;
end entity; 

architecture arch of ram is
    
    type mem is array (0 to 127) of signed(15 downto 0);
    signal conteudo_ram : mem;

begin 
    process(clk,wr_en)
    begin 
        if rising_edge(clk) THEN
            if wr_en='1' THEN
                conteudo_ram(to_integer(endereco)) <= dado_in;
            end if;
        end if;
    end process;
    
    dado_out <= conteudo_ram(to_integer(endereco));

end architecture ;