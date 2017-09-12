library ieee;
use ieee.std_logic_1164.all;


entity mips is
    port (
            clk : in std_logic;
            reset : in std_logic;
            dump : in std_logic;
            instr : out std_logic_vector (31 DOWNTO 0);
            pc : out std_logic_vector (31 DOWNTO 0)
        );
end mips;


architecture micro of mips is

    component controller is
        port (
                Op : in std_logic_vector(5 downto 0);
                Funct : in std_logic_vector(5 downto 0);
                AluControl : out std_logic_vector(2 downto 0);
                MemToReg : out std_logic;
                MemWrite : out std_logic;
                Branch : out std_logic;
                AluSrc : out std_logic;
                RegDst : out std_logic;
                RegWrite : out std_logic;
                Jump : out std_logic
             );
    end component;

    component datapath is
        port (
                clk : in std_logic;
                reset : in std_logic;
                MemToReg : in std_logic;
                MemWrite : in std_logic;
                Branch : in std_logic;
                AluSrc : in std_logic;
                RegDst : in std_logic;
                RegWrite : in std_logic;
                Jump : in std_logic;
                AluControl : in std_logic_vector (2 DOWNTO 0);
                dump : in std_logic;
                pc : out std_logic_vector (31 DOWNTO 0);
                instr : out std_logic_vector (31 DOWNTO 0)
            );
    end component;

    signal Op_s : std_logic_vector(5 downto 0);
    signal Funct_s : std_logic_vector(5 downto 0);
    signal AluControl_s : std_logic_vector(2 downto 0);
    signal MemToReg_s : std_logic;
    signal MemWrite_s : std_logic;
    signal Branch_s : std_logic;
    signal AluSrc_s : std_logic;
    signal RegDst_s : std_logic;
    signal RegWrite_s : std_logic;
    signal Jump_s : std_logic;
    signal instr_s : std_logic_vector (31 DOWNTO 0);

begin

    controller_comp : controller port map (
                                            Op => instr_s(31 DOWNTO 26),
                                            Funct => instr_s(5 DOWNTO 0),
                                            AluControl => AluControl_s,
                                            MemToReg => MemToReg_s,
                                            MemWrite => MemWrite_s,
                                            Branch => Branch_s,
                                            AluSrc => AluSrc_s,
                                            RegDst => RegDst_s,
                                            RegWrite => RegWrite_s,
                                            Jump => Jump_s
                                        );

    datapath_comp : datapath port map (
                                        clk => clk,
                                        reset => reset,
                                        MemToReg => MemToReg_s,
                                        MemWrite => MemWrite_s,
                                        Branch => Branch_s,
                                        AluSrc => AluSrc_s,
                                        RegDst => RegDst_s,
                                        RegWrite => RegWrite_s,
                                        Jump => Jump_s,
                                        AluControl => AluControl_s,
                                        dump => dump,
                                        pc => pc,
                                        instr => instr_s
                                    );

end micro;
