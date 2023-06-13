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
        ula_out : IN signed(15 DOWNTO 0);
        wr_en_update_jumpr_flag : OUT STD_LOGIC;
        wr_en_pc : OUT STD_LOGIC;
        wr_en_instr_reg : OUT STD_LOGIC;
        wr_en_ula_banco : OUT STD_LOGIC;
        wr_en_ram : OUT STD_LOGIC;
        rd_en_ram : OUT STD_LOGIC;
        is_zero : OUT STD_LOGIC;
        is_not_zero : OUT STD_LOGIC;
        is_neg : OUT STD_LOGIC;
        is_not_neg : OUT STD_LOGIC;
        ula_op : OUT unsigned(1 DOWNTO 0);
        sel_reg_or_const : OUT STD_LOGIC;
        addr_reg1 : OUT unsigned(2 DOWNTO 0);
        addr_reg2 : OUT unsigned(2 DOWNTO 0);
        addr_reg3 : OUT unsigned(2 DOWNTO 0);
        const : OUT signed(15 DOWNTO 0);
        pc_in : OUT signed(7 DOWNTO 0)
    );
END controle;
ARCHITECTURE arch OF controle IS

    SIGNAL opcode : unsigned(1 DOWNTO 0);
    SIGNAL jump_addr : signed(7 DOWNTO 0);
    SIGNAL jump_en : STD_LOGIC;
    SIGNAL flag_decode : unsigned(1 DOWNTO 0);
    SIGNAL func : unsigned(1 DOWNTO 0);

    SIGNAL flag_ram : unsigned(1 downto 0);
    CONSTANT flag_no_ram : unsigned(1 downto 0) :="00";
    CONSTANT flag_to_ram : unsigned(1 downto 0) :="01";
    CONSTANT flag_from_ram : unsigned(1 downto 0) := "10";

    SIGNAL is_zero_s : STD_LOGIC;
    SIGNAL is_neg_s : STD_LOGIC;

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
    jump_addr <= signed(instr(7 DOWNTO 0)) WHEN opcode = "11" ELSE --jumpa
        signed(instr(7 DOWNTO 0)) + pc_rom; --jumpr

    flag_decode <= instr(11 DOWNTO 10); --jumpr only

    jump_en <= '1' WHEN opcode = "11" OR (opcode = "10" AND ((flag_decode = "00" AND flag_jump_zero = '1') OR (flag_decode = "01" AND flag_jump_not_zero = '1')
        OR (flag_decode = "10" AND flag_jump_neg = '1') OR (flag_decode = "11" AND flag_jump_not_neg = '1'))) ELSE --Jumps is enable when opcode is "11"
        '0';

    --R AND I DECODE
    func <= instr(1 DOWNTO 0);
    flag_ram <= instr(3 DOWNTO 2); --flag that indicates ir R operations is between registers or register RAM
    addr_reg2 <= instr(8 DOWNTO 6);
    addr_reg3 <= instr(11 DOWNTO 9); --Reg1 = Reg3(Registrador de gravação do resultado)
    addr_reg1 <= instr(11 DOWNTO 9);
    const <= signed("000000000" & instr(8 DOWNTO 2)); --Concatenate to form 16 bit word for Register

    ula_op <= func;

    sel_reg_or_const <= R_mux_sel WHEN opcode = "00" ELSE --Tells when ULA have to catch a Reg or Constant at second operand, basically if is of R type o I type instruction
        I_mux_sel;

    --EXECUTE---------------------------------------------------------------------------------------

    --R AND I EXECUTE
    wr_en_ula_banco <= '1' WHEN estado = execute_state AND (opcode = "01" OR (opcode = "00" AND flag_ram /= flag_to_ram)) AND func /= "01" ELSE --If func=CMP, didn't write in register bank
        '0';

    wr_en_ram <= '1' WHEN estado = execute_state AND (opcode = "00" AND flag_ram = flag_to_ram) AND func /= "01" ELSE
        '0';
    rd_en_ram <= '1' WHEN estado = execute_state AND (opcode = "00" AND flag_ram = flag_from_ram) ELSE
        '0';

    --setting condition flags for relative jump:  
    is_zero <= '1' WHEN ula_out = "0000000000000000" ELSE
        '0';
    is_not_zero <= NOT is_zero_s;

    is_neg <= '1' WHEN ula_out(15) = '1' ELSE
        '0';
    is_not_neg <= NOT is_neg_s;

    --flag that verifies if it's ula instruction for update the conditional flags used in jumpr instr.
    wr_en_update_jumpr_flag <= '1' WHEN estado(1) = '1' AND (instr(13 DOWNTO 12) = "00" OR instr(13 DOWNTO 12) = "01")
        ELSE
        '0';

    --JUMPA AND JUMPR EXECUTE
    pc_in <= "11111111" WHEN pc_rom = "01111111" ELSE --When PC achieves the maximum
        jump_addr WHEN jump_en = '1' ELSE
        pc_rom + "00000001";

END ARCHITECTURE;