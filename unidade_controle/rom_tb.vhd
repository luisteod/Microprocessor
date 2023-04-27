library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity rom_tb is
end rom_tb ; 

architecture arch of rom_tb is
    component rom
    port(
        clock     : in std_logic;
        endereco  : in unsigned(6 downto 0);
        dado      : out unsigned(13 downto 0)
    );
    end component;

    signal s_clock : std_logic;
    signal s_endereco : unsigned(6 downto 0);
    signal s_dado : unsigned(13 downto 0);

begin
    uut : rom port map(
        clock  => s_clock,
        endereco  => s_endereco,
        dado   => s_dado
    );

    process
        begin
            s_endereco <= "0000001";
            s_clock <= '0';
            wait for 50 ns;
            s_clock <= '1';
            wait for 50 ns;
            s_endereco <= "0000011";
            s_clock <= '0';
            wait for 50 ns;
            s_clock <= '1';
            wait for 50 ns;
            s_endereco <= "0000101";
            s_clock <= '0';
            wait for 50 ns;
            s_clock <= '1';
            wait for 50 ns;
            wait;
    end process;

end architecture ;