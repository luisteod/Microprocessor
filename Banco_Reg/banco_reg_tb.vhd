library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity banco_reg_tb is
end entity;

architecture rtl of banco_reg_tb is

    component banco_reg
    port(
        IN_REG_A   : in  unsigned(2 downto 0);
        IN_REG_B   : in  unsigned(2 downto 0);
        IN_REG_C   : in  unsigned(2 downto 0);
        WR_EN      : in  std_logic;
        CLK        : in  std_logic;
        RST        : in  std_logic;
        DATA_IN    : in  unsigned (15 downto 0);
        OUT_REG_A  : out unsigned(15 downto 0);
        OUT_REG_B  : out unsigned(15 downto 0)
    );
    end component;

    signal IN_REG_A, IN_REG_B, IN_REG_C     : unsigned(2 downto 0) := "000";
    signal WR_EN, CLK, RST                  : std_logic := '0';
    signal DATA_IN, OUT_REG_A, OUT_REG_B    : unsigned(15 downto 0) :="0000000000000000";

begin

    uut: banco_reg port map(
        IN_REG_A    =>  IN_REG_A,
        IN_REG_B    =>  IN_REG_B,
        IN_REG_C    =>  IN_REG_C,
        WR_EN       =>  WR_EN,
        CLK         =>  CLK,
        RST         =>  RST,
        DATA_IN     =>  DATA_IN,
        OUT_REG_A   =>  OUT_REG_A,
        OUT_REG_B   =>  OUT_REG_B
    );

    process
    begin
        IN_REG_A    <= "001";
        IN_REG_B    <= "010";
        IN_REG_C    <= "100";
        DATA_IN     <= "1100000000000000";
        WR_EN       <= '1'; 
        wait for 5 ns; 
        CLK         <= '1';
        wait for 50 ns;
        CLK         <= '0';
        IN_REG_A    <= "100";
        IN_REG_B    <= "011";
        IN_REG_C    <= "101";
        DATA_IN     <= "0000001100000000"; 
        WR_EN       <= '0';
        wait for 5 ns;
        CLK         <= '1';
        wait for 50 ns;
        CLK         <= '0';
        IN_REG_A    <= "101";
        IN_REG_B    <= "100";
        IN_REG_C    <= "111";
        WR_EN       <= '1';
        wait for 10 ns;
        CLK         <= '1';
        wait for 50 ns;
        wait;
    end process;

end architecture;



