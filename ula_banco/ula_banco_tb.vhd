library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula_banco_tb is
end entity;

architecture rtl of ula_banco_tb is

    component ula_banco
    port(
        CLK     : in std_logic;
        RST     : in std_logic;
        WR_EN   : in std_logic;
        CONST   : in unsigned(15 downto 0); 
        
        DEBUG           : out unsigned(15 downto 0);
        ULA_OP_BUG      : in unsigned(1 downto 0);
        REG_IN_A_BUG    : in unsigned(2 downto 0);
        REG_IN_B_BUG    : in unsigned(2 downto 0);
        REG_IN_C_BUG    : in unsigned(2 downto 0);
        MUX_SEL_BUG     : in std_logic
    );
    end component;

    signal clk, rst, wr_en : std_logic;
    signal const  : unsigned(15 downto 0);
    signal ula_out : unsigned(15 downto 0);
    signal ula_op : unsigned(1 downto 0);
    signal reg_in_a : unsigned(2 downto 0);
    signal reg_in_b : unsigned(2 downto 0);
    signal reg_in_c : unsigned(2 downto 0);
    signal mux_sel_bug : std_logic;

begin

    uut : ula_banco port map(
        CLK   => clk,    
        RST   => rst, 
        WR_EN => wr_en,  
        CONST => const,  

        DEBUG        => ula_out,  
        ULA_OP_BUG   => ula_op,   
        REG_IN_A_BUG => reg_in_a,   
        REG_IN_B_BUG => reg_in_b,  
        REG_IN_C_BUG => reg_in_c,  
        MUX_SEL_BUG  => mux_sel_bug
    );

    process
    begin
        clk         <= '0';
        wr_en       <= '0';
        rst         <= '0';
        ula_op      <= "00";
        reg_in_a    <= "000";
        reg_in_b    <= "000";
        reg_in_c    <= "001";
        mux_sel_bug <= '0';
        const       <= "0000000000000001";
        wait for 50 ns;
        clk   <= '1';
        wr_en <= '1';
        rst   <= '0';
        wait for 50 ns;
        clk   <= '0';
        wr_en <= '0';
        rst   <= '1';
        wait for 50 ns;
        wait; 
    end process;

end architecture;