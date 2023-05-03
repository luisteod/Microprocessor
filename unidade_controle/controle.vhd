LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY controle IS
    PORT (
        wr_en : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        data : OUT unsigned(13 DOWNTO 0) --Saida da Rom (instructions)
    );
END controle;
ARCHITECTURE arch OF controle IS

    SIGNAL data_in_pc : unsigned(6 DOWNTO 0); --PC entry
    SIGNAL data_out_pc : unsigned(6 DOWNTO 0) := "0000000"; --PC output
    SIGNAL opcode : unsigned(3 DOWNTO 0);
    SIGNAL jump_addr : unsigned(6 DOWNTO 0);
    SIGNAL jump_en : STD_LOGIC;
    signal data_out_rom : unsigned(13 downto 0);

    COMPONENT pc
        PORT (
            wr_en : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            data_in : IN unsigned(6 DOWNTO 0);
            data_out : OUT unsigned(6 DOWNTO 0) := "0000000"
        );
    END COMPONENT;

    --Declarando rom
    COMPONENT rom
        PORT (
            clock : IN STD_LOGIC;
            endereco : IN unsigned(6 DOWNTO 0);
            dado : OUT unsigned(13 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT maquina_estados
        PORT (
            rst : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            estado : INOUT STD_LOGIC := '0'
        );
    END COMPONENT;

    SIGNAL estado_s : STD_LOGIC; -- out of state mach
    SIGNAL clk_pc_s : STD_LOGIC;

BEGIN
    uut : pc PORT MAP(
        wr_en => estado_s,
        clk => clk_pc_s, -- clk of PC is on the rising edge of top-level clk  
        rst => rst,
        data_in => data_in_pc,
        data_out => data_out_pc
    );

    uup : rom PORT MAP(
        clock => clk,
        endereco => data_out_pc,
        dado => data_out_rom
    );

    maq_est : maquina_estados
    PORT MAP(
        rst => rst,
        clk => clk,
        estado => estado_s
    );

    data <= data_out_rom;

    clk_pc_s <= estado_s; --Clock for incrementing PC is dependent of the state generate by state machine     

    opcode <= data_out_rom(13 DOWNTO 10); --Catch the opcode from instruction
    jump_addr <= data_out_rom(6 DOWNTO 0); --Catch the addr for jump in the instruction

    jump_en <= '1' WHEN opcode = "1111" ELSE
        '0'; --Jumps is enable when opcode is "1111"

    data_in_pc <= "0000000" WHEN data_out_pc = "1111111" ELSE --When PC achieves the maximum
                   jump_addr WHEN jump_en = '1' ELSE
                   data_out_pc + "0000001";

END ARCHITECTURE;