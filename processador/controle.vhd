LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY controle IS
    PORT (
        estado : IN unsigned(1 DOWNTO 0);
        instr : IN unsigned(13 DOWNTO 0);
        pc_rom : IN signed(7 DOWNTO 0); --Liga a saída do PC na entrada da ROM
        flag_jump_zero : IN STD_LOGIC;
        flag_jump_not_zero : IN STD_LOGIC;
        flag_jump_neg : IN STD_LOGIC;
        flag_jump_not_neg : IN STD_LOGIC;
        ula_out : IN unsigned(15 DOWNTO 0);
        wr_en_pc : OUT STD_LOGIC;
        wr_en_instr_reg : OUT STD_LOGIC;
        wr_en_ula_banco : OUT STD_LOGIC;
        wr_en_zero : OUT STD_LOGIC;
        wr_en_not_zero : OUT STD_LOGIC;
        wr_en_neg : OUT STD_LOGIC;
        wr_en_not_neg : OUT STD_LOGIC;
        ula_op : OUT unsigned(1 DOWNTO 0);
        sel_reg_or_const : OUT STD_LOGIC;
        addr_reg1 : OUT unsigned(2 DOWNTO 0);
        addr_reg2 : OUT unsigned(2 DOWNTO 0);
        addr_reg3 : OUT unsigned(2 DOWNTO 0);
        const : OUT unsigned(15 DOWNTO 0);
        pc_in : OUT signed(7 DOWNTO 0)
    );
END controle;
ARCHITECTURE arch OF controle IS

    SIGNAL opcode : unsigned(1 DOWNTO 0);
    SIGNAL jump_addr : signed(7 DOWNTO 0);
    SIGNAL jump_en : STD_LOGIC;
    SIGNAL func : unsigned(1 DOWNTO 0);

    signal wr_en_zero_s : std_logic;
    signal wr_en_neg_s : std_logic;

    CONSTANT R_mux_sel : STD_LOGIC := '1';
    CONSTANT I_mux_sel : STD_LOGIC := '0';

    CONSTANT fetch_state : unsigned(1 DOWNTO 0) := "00"; --Constante que define o estado de fetch
    CONSTANT decode_state : unsigned(1 DOWNTO 0) := "01"; --Constant that defines the decode state
    CONSTANT execute_state : unsigned(1 DOWNTO 0) := "10"; --Constant that defines the execute state
BEGIN
    --FETCH-----------------------------------------------------------------------------------------
    wr_en_pc <= '1' WHEN estado = fetch_state ELSE
        '0';
    --DECODE----------------------------------------------------------------------------------------
    wr_en_instr_reg <= '1' WHEN estado = decode_state ELSE
        '0';

    --OPCODE DECODE (JUMP, R, I)
    opcode <= instr(13 DOWNTO 12); --Catch the opcode from instruction

    --JUMP DECODE
    jump_addr <= signed("0" & instr(6 DOWNTO 0)) WHEN opcode = "11" ELSE
        signed(instr(7 DOWNTO 0)) + pc_rom; --jumpa or jumpr

    jump_en <= '1' WHEN opcode = "11" OR (opcode = "10" AND (flag_jump_zero = '1' OR flag_jump_not_zero = '1' OR flag_jump_neg = '1' OR flag_jump_not_neg = '1')) ELSE --Jumps is enable when opcode is "11"
        '0';

    --R AND I DECODE
    func <= instr(1 DOWNTO 0);
    addr_reg1 <= instr(11 DOWNTO 9);
    addr_reg2 <= instr(8 DOWNTO 6);
    const <= "000000000000" & instr(8 DOWNTO 5); --Concatenate to form 16 bit word for Register
    addr_reg3 <= instr(4 DOWNTO 2);

    ula_op <= func;

    sel_reg_or_const <= R_mux_sel WHEN opcode = "00" ELSE --Tells when ULA have to catch a Reg or Constant at second operand, basically if is of R type o I type instruction
        I_mux_sel;

    --EXECUTE---------------------------------------------------------------------------------------

    --R AND I EXECUTE
    wr_en_ula_banco <= '1' WHEN estado = execute_state AND (opcode = "00" OR opcode = "01") ELSE
        '0';

    --Setting condition flags for relative jump:  
    wr_en_zero <= '1' WHEN estado = execute_state AND (opcode = "00" OR opcode = "01") AND ula_out = "0000000000000000" ELSE
        '0';
    wr_en_not_zero <= NOT wr_en_zero_s;

    wr_en_neg <= '1' WHEN estado = execute_state AND (opcode = "00" OR opcode = "01") AND ula_out(15) = '1' ELSE
        '0';
    wr_en_not_neg <= NOT wr_en_neg_s;

    --JUMP EXECUTE
    pc_in <= "11111111" WHEN pc_rom = "01111111" ELSE --When PC achieves the maximum
        jump_addr WHEN jump_en = '1' ELSE
        pc_rom + "00000001";

END ARCHITECTURE;