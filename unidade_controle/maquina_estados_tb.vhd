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
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

begin

    uut : maquina_estados port map(
        rst  => s_rst,
        clk  => s_clk,
        estado   => s_estado
    );

    reset_global : PROCESS
    BEGIN
        s_rst <= '1';
        WAIT FOR period_time * 2; -- espera 2 clocks, pra garantir
        s_rst <= '0';
        WAIT;
    END PROCESS;

    sim_time_proc : PROCESS
    BEGIN
        WAIT FOR 10 us; -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
        finished <= '1';
        WAIT;
    END PROCESS sim_time_proc;

    clk_proc : PROCESS
    BEGIN -- gera clock até que sim_time_proc termine
        WHILE finished /= '1' LOOP
            s_clk <= '0';
            WAIT FOR period_time/2;
            s_clk <= '1';
            WAIT FOR period_time/2;
        END LOOP;
        WAIT;
    END PROCESS clk_proc;       

end architecture ;