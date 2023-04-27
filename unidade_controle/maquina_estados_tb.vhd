library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity maquina_estados_tb is
end maquina_estados_tb ; 

architecture arch of maquina_estados_tb is
    component maquina_estados
    port(
        rst          : in std_logic;
        clk          : in std_logic;
        estado       : inout std_logic
    );
    end component;

    signal s_rst, s_clk, s_estado : std_logic;
begin

    uut : maquina_estados port map(
        rst  => s_rst,
        clk  => s_clk,
        estado   => s_estado
    );

    process
        begin
            s_clk <= '0';
            wait for 50 ns;
            s_clk <= '1';
            wait for 50 ns;
            s_clk <= '0';
            wait for 50 ns;
            s_clk <= '1';
            wait for 50 ns;
            s_clk <= '0';
            wait for 50 ns;
            s_clk <= '1';
            wait for 50 ns;
            s_rst <= '1';
            wait;
    end process;

end architecture ;