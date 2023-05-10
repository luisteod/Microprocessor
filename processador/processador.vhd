LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY processador IS
    PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        Estado : OUT unsigned(1 DOWNTO 0);
        PC_out : OUT unsigned(6 DOWNTO 0);
        Instr : OUT unsigned(13 DOWNTO 0)
        -- Reg1 : OUT unsigned(15 DOWNTO 0);
        -- Reg2 : OUT unsigned(15 DOWNTO 0);
        -- ULA_out : OUT unsigned(15 DOWNTO 0);
    );
END ENTITY;

ARCHITECTURE rtl OF processador IS

    COMPONENT registrador
        PORT (
            rst : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            wr_en : IN STD_LOGIC;
            data_in : IN unsigned(13 DOWNTO 0);
            data_out : OUT unsigned(13 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT pc
        PORT (
            wr_en : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            data_in : IN unsigned(6 DOWNTO 0);
            data_out : OUT unsigned(6 DOWNTO 0) := "0000000"
        );
    END COMPONENT;

    COMPONENT rom
        PORT (
            clock : IN STD_LOGIC;
            endereco : IN unsigned(6 DOWNTO 0);
            dado : OUT unsigned(13 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT maq_estados
        PORT (
            clk, rst : IN STD_LOGIC;
            estado : OUT unsigned(1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL wr_en_s : STD_LOGIC := '1'; --Write enable always active
    SIGNAL data_rom_instrReg_s : unsigned(13 DOWNTO 0); --Liga entrada do registrador de instrução na saída da ROM
    SIGNAL pc_rom_s : unsigned(6 DOWNTO 0); --Liga a saída do PC na entrada da ROM
    SIGNAL pc_in_s : unsigned(6 DOWNTO 0) := "0000000";
    SIGNAL opcode_s : unsigned(3 DOWNTO 0);
    SIGNAL jump_addr_s : unsigned(6 DOWNTO 0);
    SIGNAL jump_en_s : STD_LOGIC;
    SIGNAL instr_s : unsigned(13 DOWNTO 0); --Intruction, that is the out of Instruction Register
    SIGNAL clk_pc_s : STD_LOGIC;
    SIGNAL clk_instr_reg_s : STD_LOGIC;
    SIGNAL estado_s : unsigned(1 DOWNTO 0);

    CONSTANT fetch_state : unsigned(1 DOWNTO 0) := "00"; --Constante que define o estado de fetch
    CONSTANT decode_state : unsigned(1 DOWNTO 0) := "01"; --Constant that defines the decode state

BEGIN
    pc_comp : pc PORT MAP(
        wr_en => wr_en_s,
        clk => clk_pc_s,
        rst => rst,
        data_in => pc_in_s,
        data_out => pc_rom_s
    );

    rom_comp : rom PORT MAP(
        clock => clk,
        endereco => pc_rom_s,
        dado => data_rom_instrReg_s
    );

    --Registrador que armazena a saída da rom
    instr_reg_comp : registrador PORT MAP(
        rst => rst,
        clk => clk_instr_reg_s,
        wr_en => wr_en_s,
        data_in => data_rom_instrReg_s,
        data_out => instr_s
    );

    maq_estados_comp : maq_estados PORT MAP(
        clk => clk,
        rst => rst,
        estado => estado_s
    );

    PC_out <= pc_rom_s;
    Instr <= instr_s;
    Estado <= estado_s;

    --FETCH-------------------------
    clk_pc_s <= '1' WHEN estado_s = fetch_state ELSE
        '0';

    --DECODE------------------------
    clk_instr_reg_s <= '1' WHEN estado_s = decode_state ELSE
        '0';

    opcode_s <= instr_s(13 DOWNTO 10); --Catch the opcode from instruction

    --jump decode
    jump_addr_s <= instr_s(6 DOWNTO 0); --Catch the addr for jump in the instruction
    jump_en_s <= '1' WHEN opcode_s = "1111" ELSE
        '0'; --Jumps is enable when opcode is "1111"

    --imediate decode

    --EXECUTE-----------------------

    --jump execute
    pc_in_s <= "0000000" WHEN pc_rom_s = "1111111" ELSE --When PC achieves the maximum
        jump_addr_s WHEN jump_en_s = '1' ELSE
        pc_rom_s + "0000001";

END ARCHITECTURE;