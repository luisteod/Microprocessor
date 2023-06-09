library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity pc is
  port (
    wr_en   :   in std_logic;
    clk     :   in std_logic;
    rst     :   in std_logic;
    data_in :   in signed(7 downto 0);
    data_out:   out signed(7 downto 0) 
  ) ;
end pc ; 

architecture arch of pc is
  signal registro : signed(7 downto 0) := "11111111";
  begin
  data_out <= registro;
      process(clk,rst)
      begin
          if rst = '1' then
              registro <= "11111111"; 
          elsif rising_edge(clk) then
              if wr_en = '1' then
                  registro <= data_in;
              end if;
          end if;
      end process;
end architecture;