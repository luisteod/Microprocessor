LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY controle IS
    PORT (
        estado : IN unsigned(1 DOWNTO 0);
        instr : IN unsigned(13 DOWNTO 0);
        pc_rom : IN signed(7 DOWNTO 0); --Liga a saída do PC na entrada da ROM
        wr_en_pc : OUT STD_LOGIC;
        wr_en_instr_reg : OUT STD_LOGIC;
        wr_en_ula_banco : OUT STD_LOGIC;
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
    SIGNAL jump_addr : unsigned(6 DOWNTO 0);
    SIGNAL jump_en : STD_LOGIC;
    SIGNAL func : unsigned(1 DOWNTO 0);

    CONSTANT R_mux_sel : STD_LOGIC := '1';
    CONSTANT I_mux_sel : STD_LOGIC := '0';

    CONSTANT fetch_state : unsigned(1 DOWNTO 0) := "00"; --Constante que define o estado de fetch
    CONSTANT decode_state : unsigned(1 DOWNTO 0) := "01"; --Constant that defines the decode state
    CONSTANT execute_state : unsigned(1 DOWNTO 0) := "10"; --Constant that defines the execute state

BEGIN

    --FETCH-------------------------
    wr_en_pc <= '1' WHEN estado = fetch_state ELSE
        '0';
    --DECODE------------------------
    wr_en_instr_reg <= '1' WHEN estado = decode_state ELSE
        '0';

    --General decode (jump, R, I)
    opcode <= instr(13 DOWNTO 12); --Catch the opcode from instruction

    --Jump decode
    jump_addr <= instr(6 DOWNTO 0); --Catch the addr for jump in the instruction
    jump_en <= '1' WHEN opcode = "11" ELSE
        '0'; --Jumps is enable when opcode is "11"

    --R and I decode
    func <= instr(1 DOWNTO 0);
    addr_reg1 <= instr(11 DOWNTO 9);
    addr_reg2 <= instr(8 DOWNTO 6);
    const <= "000000000000" & instr(8 DOWNTO 5); --Concatenate to form 16 bit word for Register
    addr_reg3 <= instr(4 DOWNTO 2);

    ula_op <= func;

    sel_reg_or_const <= R_mux_sel WHEN opcode = "00" ELSE
        I_mux_sel; --Tells when ULA have to catch a Reg or Constant at second operand, basically if is of R type o I type instruction

    wr_en_ula_banco <= '1' WHEN estado = execute_state AND (opcode = "00" OR opcode = "01") ELSE
        '0';

    pc_in <= "11111111" WHEN pc_rom = "01111111" ELSE --When PC achieves the maximum
        signed("0" & jump_addr) WHEN jump_en = '1' ELSE
        pc_rom + "00000001";

END ARCHITECTURE;