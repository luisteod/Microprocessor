library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity instr_reg is
    port(
        rst : in std_logic;
        clk : in std_logic;
        wr_en : in std_logic;
        data_in : in unsigned(13 downto 0);
        data_out : out unsigned(13 downto 0)
    );
end entity;

architecture rtl of instr_reg is
signal registro : unsigned(13 downto 0) ;
begin
data_out <= registro;
    process(clk,rst)
    begin
        if rst = '1' then
            registro <= "00000000000000"; 
        elsif rising_edge(clk) then
            if wr_en = '1' then
                registro <= data_in;
            end if;
        end if;
    end process;
end architecture;
