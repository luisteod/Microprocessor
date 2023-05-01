library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity maquina_estados is
    port(
        rst : in std_logic;
        clk : in std_logic;
        estado : inout std_logic := '0'
    );
end entity;

architecture rtl of maquina_estados is
begin
    process(clk)
    begin
        if rst = '1' then
            estado <= '0'; 
        elsif rising_edge(clk) then
            estado <= not estado;
        end if;
    end process;
end architecture;

