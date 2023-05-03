library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity controle_tb is
end controle_tb ; 

architecture arch of controle_tb is
    component controle
    port(
        wr_en : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        data : OUT unsigned(13 DOWNTO 0) --Saida da Rom (instructions)
    );
    end component;

    signal wr_en_s, clk_s, rst_s : std_logic;
    signal dado_s : unsigned(13 downto 0);
    constant period_time : time := 10 ns;
    signal finished : std_logic := '0';

begin

    uut: controle port map(
        wr_en => wr_en_s,
        clk => clk_s,
        rst => rst_s,
        data => dado_s
    );  


    reset_global : PROCESS
    BEGIN
        rst_s <= '1';
        WAIT FOR period_time * 2; -- espera 2 clocks, pra garantir
        rst_s <= '0';
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
            clk_s <= '0';
            WAIT FOR period_time/2;
            clk_s <= '1';
            WAIT FOR period_time/2;
        END LOOP;
        WAIT;
    END PROCESS clk_proc;  
end architecture ;