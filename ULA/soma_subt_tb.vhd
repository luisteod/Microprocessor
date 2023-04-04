library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity soma_subt_tb is
end entity ; 

architecture a_soma_subt_tb of soma_subt_tb is
    component soma_subt
        port  ( x,y : in unsigned(15 downto 0);
        switch: in std_logic;
        saida: out unsigned(15 downto 0)
        );
    end component;
    signal x,y,saida: unsigned(15 downto 0);
    signal switch: std_logic;

    begin
        -- uut significa Unit Under Test
        uut: soma_subt port map(x => x,
                                y => y,
                                switch => switch,
                                saida => saida);

        process
        begin
            switch <= '1';
            x <= "0000000000011111";
            y <= "0000000000000001";
            wait for 50 ns;
            switch <= '0';
            x <= "0000000000001111";
            y <= "0000000000000010";
            wait for 50 ns;
            wait;
        end process;
end architecture a_soma_subt_tb;