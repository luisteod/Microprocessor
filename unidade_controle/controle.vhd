library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity controle is
    port (
        wr_en   :   in std_logic;
        clk     :   in std_logic;
        rst     :   in std_logic;
        data_in :   inout unsigned(6 downto 0);
        data_out:   inout unsigned(6 downto 0) := "0000000";
        dado    :   out unsigned(13 downto 0) --Dado da Rom
    );
end controle ; 

architecture arch of controle is
    component pc
    port(
        wr_en       : in std_logic;
        clk         : in std_logic;
        rst         : in std_logic;
        data_in     : in unsigned(6 downto 0);
        data_out    : out unsigned(6 downto 0) := "0000000"
    );
    end component;

    --Declarando rom
    component rom
    port(
        clock     : in std_logic;
        endereco  : in unsigned(6 downto 0);
        dado      : out unsigned(13 downto 0) 
    );
    end component;

begin
    uut: pc port map(
        wr_en => wr_en,
        clk => clk,
        rst => rst,
        data_in => data_in,
        data_out => data_out
    );

    uup: rom port map(
        clock => clk,
        endereco => data_out,
        dado => dado
    );

    data_in <= "0000000" when data_out="1111111" else data_out + "0000001";

end architecture ;