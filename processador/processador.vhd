LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY processador IS
    PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        Estado : OUT unsigned(1 DOWNTO 0);
        PC_out : OUT signed(7 DOWNTO 0);
        Instr : OUT unsigned(13 DOWNTO 0);
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
            data_in : IN signed(7 DOWNTO 0);
            data_out : OUT signed(7 DOWNTO 0)
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

    COMPONENT controle
        PORT (
            estado : IN unsigned(1 DOWNTO 0);
            instr : IN unsigned(13 DOWNTO 0);
            pc_rom : IN signed(7 DOWNTO 0); --Liga a saída do PC na entrada da ROM
            flag_jump_zero : IN STD_LOGIC;
            flag_jump_not_zero : IN STD_LOGIC;
            flag_jump_neg : IN STD_LOGIC;
            flag_jump_not_neg : IN STD_LOGIC;
            ula_out : in unsigned(15 downto 0);
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
    END COMPONENT;

    COMPONENT flipFlop
        PORT (
            WR_EN : IN STD_LOGIC;
            D : IN STD_LOGIC; -- Data input
            CLK : IN STD_LOGIC; -- Clock input
            Q : OUT STD_LOGIC -- Output
        );
    END COMPONENT;

    SIGNAL wr_en_ula_banco_s : STD_LOGIC;
    SIGNAL wr_en_pc_s : STD_LOGIC;
    SIGNAL wr_en_instr_reg_s : STD_LOGIC;
    SIGNAL data_rom_instrReg_s : unsigned(13 DOWNTO 0); --Liga entrada do registrador de instrução na saída da ROM
    SIGNAL pc_rom_s : signed(7 DOWNTO 0); --Liga a saída do PC na entrada da ROM
    SIGNAL pc_in_s : signed(7 DOWNTO 0);
    SIGNAL instr_s : unsigned(13 DOWNTO 0); --Intruction, that is the out of Instruction Register
    SIGNAL estado_s : unsigned(1 DOWNTO 0);
    SIGNAL Reg1_s : unsigned(2 DOWNTO 0);
    SIGNAL Reg2_s : unsigned(2 DOWNTO 0);
    SIGNAL Reg3_s : unsigned(2 DOWNTO 0);
    SIGNAL const_s : unsigned(15 DOWNTO 0);
    SIGNAL ula_op_s : unsigned(1 DOWNTO 0);
    SIGNAL sel_reg_or_const_s : STD_LOGIC;
    SIGNAL ula_out_debug_s : unsigned(15 DOWNTO 0);

    SIGNAL flag_jump_zero_s : STD_LOGIC;
    SIGNAL flag_jump_not_zero_s : STD_LOGIC;
    SIGNAL flag_jump_neg_s : STD_LOGIC;
    SIGNAL flag_jump_not_neg_s : STD_LOGIC;

    SIGNAL wr_en_zero_s : STD_LOGIC;
    SIGNAL wr_en_not_zero_s : STD_LOGIC;
    SIGNAL wr_en_neg_s : STD_LOGIC;
    SIGNAL wr_en_not_neg_s : STD_LOGIC;

BEGIN
    pc_comp : pc PORT MAP(
        wr_en => wr_en_pc_s,
        clk => clk,
        rst => rst,
        data_in => pc_in_s,
        data_out => pc_rom_s
    );

    rom_comp : rom PORT MAP(
        clock => clk,
        endereco => unsigned(pc_rom_s(6 DOWNTO 0)), --Discosiderating negative numbers
        dado => data_rom_instrReg_s
    );

    --Registrador que armazena a saída da rom
    instr_reg_comp : instr_reg PORT MAP(
        rst => rst,
        clk => clk,
        wr_en => wr_en_instr_reg_s,
        data_in => data_rom_instrReg_s,
        data_out => instr_s
    );

    maq_estados_comp : maq_estados PORT MAP(
        clk => clk,
        rst => rst,
        estado => estado_s
    );

    ula_banco_comp : ula_banco PORT MAP(

        CLK => clk,
        RST => rst,
        WR_EN => wr_en_ula_banco_s,
        CONST => const_s,
        DEBUG => ula_out_debug_s,
        ULA_OP => ula_op_s,
        REG_IN_A => Reg1_s,
        REG_IN_B => Reg2_s,
        REG_IN_C => Reg3_s,
        MUX_SEL => sel_reg_or_const_s
    );

    controle_comp : controle PORT MAP(
        
        estado => estado_s,
        instr => instr_s,
        pc_rom => pc_rom_s,
        flag_jump_zero => flag_jump_zero_s,
        flag_jump_not_zero => flag_jump_not_zero_s,
        flag_jump_neg => flag_jump_neg_s,
        flag_jump_not_neg => flag_jump_not_neg_s,
        ula_out => ula_out_debug_s,
        wr_en_pc => wr_en_pc_s,
        wr_en_instr_reg => wr_en_instr_reg_s,
        wr_en_ula_banco => wr_en_ula_banco_s,
        wr_en_zero => wr_en_zero_s,
        wr_en_not_zero => wr_en_not_zero_s,
        wr_en_neg => wr_en_neg_s,
        wr_en_not_neg => wr_en_not_neg_s,
        ula_op => ula_op_s,
        sel_reg_or_const => sel_reg_or_const_s,
        addr_reg1 => Reg1_s,
        addr_reg2 => Reg2_s,
        addr_reg3 => Reg3_s,
        const => const_s,
        pc_in => pc_in_s
    );

    flipFlop_zero_comp : flipFlop PORT MAP(
        WR_EN => wr_en_zero_s,
        D => wr_en_zero_s,
        CLK => clk,
        Q => flag_jump_zero_s
    );

    flipFlop_not_zero_comp : flipFlop PORT MAP(
        WR_EN => wr_en_not_zero_s,
        D => wr_en_not_zero_s,
        CLK => clk,
        Q => flag_jump_not_zero_s
    );

    flipFlop_neg_comp : flipFlop PORT MAP(
        WR_EN => wr_en_neg_s,
        D => wr_en_neg_s,
        CLK => clk,
        Q => flag_jump_neg_s
    );

    flipFlop_not_neg_comp : flipFlop PORT MAP(
        WR_EN => wr_en_not_neg_s,
        D => wr_en_not_neg_s,
        CLK => clk,
        Q => flag_jump_not_neg_s
    );

    PC_out <= pc_rom_s;
    Instr <= instr_s;
    Estado <= estado_s;
    ULA_out <= ula_out_debug_s;

END ARCHITECTURE;