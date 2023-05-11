LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY processador IS
    PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        Estado : OUT unsigned(1 DOWNTO 0);
        PC_out : OUT unsigned(6 DOWNTO 0);
        Instr : OUT unsigned(13 DOWNTO 0);
        --Reg1 : OUT unsigned(15 DOWNTO 0);
        -- Reg2 : OUT unsigned(15 DOWNTO 0);
        ULA_out : OUT unsigned(15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF processador IS

    COMPONENT instr_reg
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

    COMPONENT ula_banco
        PORT (
            CLK : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            WR_EN : IN STD_LOGIC;
            CONST : IN unsigned(15 DOWNTO 0); --Immediate constant
            DEBUG : OUT unsigned(15 DOWNTO 0); --Out of ULA
            ULA_OP : IN unsigned(1 DOWNTO 0);
            REG_IN_A : IN unsigned(2 DOWNTO 0);
            REG_IN_B : IN unsigned(2 DOWNTO 0);
            REG_IN_C : IN unsigned(2 DOWNTO 0);
            MUX_SEL : IN STD_LOGIC
        );
    END COMPONENT;

    SIGNAL wr_en_s : STD_LOGIC := '1'; --Write enable always active
    SIGNAL data_rom_instrReg_s : unsigned(13 DOWNTO 0); --Liga entrada do registrador de instrução na saída da ROM
    SIGNAL pc_rom_s : unsigned(6 DOWNTO 0); --Liga a saída do PC na entrada da ROM
    SIGNAL pc_in_s : unsigned(6 DOWNTO 0) := "0000000";
    SIGNAL opcode_s : unsigned(1 DOWNTO 0);
    SIGNAL jump_addr_s : unsigned(6 DOWNTO 0);
    SIGNAL jump_en_s : STD_LOGIC;
    SIGNAL instr_s : unsigned(13 DOWNTO 0); --Intruction, that is the out of Instruction Register
    SIGNAL clk_pc_s : STD_LOGIC;
    SIGNAL clk_instr_reg_s : STD_LOGIC;
    SIGNAL estado_s : unsigned(1 DOWNTO 0);
    SIGNAL func_s : unsigned(1 DOWNTO 0);
    SIGNAL Reg1_s : unsigned(2 DOWNTO 0);
    SIGNAL Reg2_s : unsigned(2 DOWNTO 0);
    SIGNAL Reg3_s : unsigned(2 DOWNTO 0);
    SIGNAL const_s : unsigned(15 DOWNTO 0);
    SIGNAL ula_op_s : unsigned(1 DOWNTO 0);
    SIGNAL sel_reg_or_const_s : STD_LOGIC;
    SIGNAL ula_out_debug_s : unsigned(15 DOWNTO 0);
    SIGNAL clk_ula_banco_s : STD_LOGIC;

    CONSTANT R_mux_sel : STD_LOGIC := '1';
    CONSTANT I_mux_sel : STD_LOGIC := '0';

    CONSTANT fetch_state : unsigned(1 DOWNTO 0) := "00"; --Constante que define o estado de fetch
    CONSTANT decode_state : unsigned(1 DOWNTO 0) := "01"; --Constant that defines the decode state
    CONSTANT execute_state : unsigned(1 DOWNTO 0) := "10"; --Constant that defines the execute state

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
    instr_reg_comp : instr_reg PORT MAP(
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

    ula_banco_comp : ula_banco PORT MAP(

        CLK => clk_ula_banco_s, ------------
        RST => rst,
        WR_EN => wr_en_s,
        CONST => const_s,
        DEBUG => ula_out_debug_s,
        ULA_OP => ula_op_s,
        REG_IN_A => Reg1_s,
        REG_IN_B => Reg2_s,
        REG_IN_C => Reg3_s,
        MUX_SEL => sel_reg_or_const_s
    );

    PC_out <= pc_rom_s;
    Instr <= instr_s;
    Estado <= estado_s;
    --ULA_out <= ula_out_debug_s;

    PROCESS (estado_s)
    BEGIN
        IF (rising_edge(estado_s(1))) then
            ULA_out <= ula_out_debug_s;
        END IF;
    END PROCESS;

    --FETCH-------------------------
    clk_pc_s <= '1' WHEN estado_s = fetch_state ELSE
        '0';

    --DECODE------------------------
    clk_instr_reg_s <= '1' WHEN estado_s = decode_state ELSE
        '0';

    --General decode (jump, R, I)
    opcode_s <= instr_s(13 DOWNTO 12); --Catch the opcode from instruction

    --Jump decode
    jump_addr_s <= instr_s(6 DOWNTO 0); --Catch the addr for jump in the instruction
    jump_en_s <= '1' WHEN opcode_s = "11" ELSE
        '0'; --Jumps is enable when opcode is "11"

    --R and I decode
    func_s <= instr_s(1 DOWNTO 0);
    Reg1_s <= instr_s(11 DOWNTO 9);
    Reg2_s <= instr_s(8 DOWNTO 6);
    const_s <= "000000000000" & instr_s(8 DOWNTO 5); --Concatenate to form 16 bit word for Register
    Reg3_s <= instr_s(4 DOWNTO 2);

    ula_op_s <= func_s; --Send instruction to ula
    sel_reg_or_const_s <= R_mux_sel WHEN opcode_s = "00" ELSE
        I_mux_sel; --Tells when ULA have to catch a Reg or Constant at second operand, basically if is of R type o I type instruction

    --EXECUTE-----------------------

    --R or I execute
    clk_ula_banco_s <= '1' WHEN estado_s = execute_state AND (opcode_s = "00" OR opcode_s = "01") ELSE
        '0'; --Execute only if in right state and if opcode is of R or I instruction
    --jump execute
    pc_in_s <= "0000000" WHEN pc_rom_s = "1111111" ELSE --When PC achieves the maximum
        jump_addr_s WHEN jump_en_s = '1' ELSE
        pc_rom_s + "0000001";

END ARCHITECTURE;