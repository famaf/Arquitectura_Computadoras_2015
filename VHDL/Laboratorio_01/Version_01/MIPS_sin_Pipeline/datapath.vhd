library ieee;
use ieee.std_logic_1164.all;


entity datapath is
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
end datapath;


architecture DATA_PATH of datapath is

-- DECLARACION DE LOS COMPONENTES A USAR --
    component adder is
        port (
                a : in std_logic_vector (31 DOWNTO 0);
                b : in std_logic_vector (31 DOWNTO 0);
                y : out std_logic_vector (31 DOWNTO 0)
             );
    end component;


    component flopr is
        generic ( N : natural := 32 );
        port (
                clk : in std_logic;
                reset : in std_logic;
                d : in std_logic_vector (N-1 DOWNTO 0);
                q : out std_logic_vector (N-1 DOWNTO 0)
            );
    end component;


    component imem is
        port(
                a : in  std_logic_vector(31 downto 0);
                rd : out std_logic_vector(31 downto 0)
            );
    end component;


    component alu is
        port (
                a : in std_logic_vector (31 DOWNTO 0);
                b : in std_logic_vector (31 DOWNTO 0);
                alucontrol : in std_logic_vector (2 DOWNTO 0);
                zero : out std_logic;
                result : out std_logic_vector (31 DOWNTO 0)
            );
    end component;


    component dmem is
        port(
                clk : in STD_LOGIC;
                we : in STD_LOGIC;
                a : in std_logic_vector(31 downto 0);
                wd : in std_logic_vector(31 downto 0);
                dump: in STD_LOGIC;
                rd : out std_logic_vector(31 downto 0)
             );
    end component;


    component mux2 is
        generic ( N : natural := 32 );
        port (
                d0 : in std_logic_vector (N-1 DOWNTO 0);
                d1 : in std_logic_vector (N-1 DOWNTO 0);
                set : in std_logic;
                y : out std_logic_vector (N-1 DOWNTO 0)
            );
    end component;


    component regfile is
        port (
                clk : in std_logic;
                we3 : in std_logic;
                ra1 : in std_logic_vector (4 DOWNTO 0);
                ra2 : in std_logic_vector (4 DOWNTO 0);
                wa3 : in std_logic_vector (4 DOWNTO 0);
                wd3 : in std_logic_vector (31 DOWNTO 0);
                rd1 : out std_logic_vector (31 DOWNTO 0);
                rd2 : out std_logic_vector (31 DOWNTO 0)
            );
    end component;


    component signext is
        port (
                a : in std_logic_vector (15 DOWNTO 0);
                y : out std_logic_vector (31 DOWNTO 0)
            );
    end component;


    component sl2 is
        port (
                a : in std_logic_vector (31 DOWNTO 0);
                y : out std_logic_vector (31 DOWNTO 0)
            );  
    end component;
    -------------------------------------------

-------------- CABLES A USAR --------------
    signal PCNext : std_logic_vector (31 DOWNTO 0);
    signal PCPlus4 : std_logic_vector (31 DOWNTO 0);
    signal Zero : std_logic;
    signal instr_prima : std_logic_vector (31 DOWNTO 0);
    signal PC_output : std_logic_vector (31 DOWNTO 0);
    signal PCJump : std_logic_vector (31 DOWNTO 0) := PCPlus4(31 DOWNTO 28) & instr_prima(25 DOWNTO 0) & "00";
    signal PCSrc : std_logic := Branch and Zero;
    signal PCBranch : std_logic_vector (31 DOWNTO 0);
    signal PC_prima : std_logic_vector (31 DOWNTO 0);
    signal WriteReg : std_logic_vector (4 DOWNTO 0);
    signal Signimm : std_logic_vector (31 DOWNTO 0);
    signal WriteData : std_logic_vector (31 DOWNTO 0);
    signal ALUResult : std_logic_vector (31 DOWNTO 0);
    signal SrcA : std_logic_vector (31 DOWNTO 0);
    signal SrcB : std_logic_vector (31 DOWNTO 0);
    signal ReadData : std_logic_vector (31 DOWNTO 0);
    signal Result : std_logic_vector (31 DOWNTO 0);
    signal Shifter_Adder : std_logic_vector (31 DOWNTO 0);
-------------------------------------------

begin

    mux_1 : mux2 port map ( 
                            d0 => PCPlus4,
                            d1 => PCBranch,
                            set => PCSrc,
                            y => PCNext
                        );

    mux_2 : mux2 port map ( 
                            d0 => PCNext,
                            d1 => PCJump,
                            set => Jump,
                            y => PC_prima -- DUDA
                        );

    flip_flop : flopr port map (
                                    clk => clk,
                                    reset => reset,
                                    d => PC_prima,
                                    q => PC_output
                                );

    rom_imem : imem port map (
                                a => PC_output,
                                rd => instr_prima
                            );

    adder_1 : adder port map (
                                a => PC_output,
                                b => "00000000000000000000000000000100", -- 4
                                y => PCPlus4
                            );

    registro_1 : regfile port map (
                                    clk => clk,
                                    we3 => RegWrite,
                                    ra1 => instr_prima(25 DOWNTO 21),
                                    ra2 => instr_prima(20 DOWNTO 16),
                                    wa3 => WriteReg,
                                    wd3 => Result,
                                    rd1 => SrcA,
                                    rd2 => WriteData
                                );

    sig_next : signext port map (
                                    a => instr_prima(15 DOWNTO 0),
                                    y => Signimm
                                );

    mux_3 : mux2 generic map ( N => 5 ) port map ( 
                                                    d0 => instr_prima(20 DOWNTO 16),
                                                    d1 => instr_prima(15 DOWNTO 11),
                                                    set => RegDst,
                                                    y => WriteReg
                                                );

    mux_4 : mux2 port map ( 
                            d0 => WriteData,
                            d1 => Signimm,
                            set => AluSrc,
                            y => SrcB
                        );

    shifter : sl2 port map (
                                a => Signimm,
                                y => Shifter_Adder
                        );

    adder_2 : adder port map (
                                a => Shifter_Adder,
                                b => PCPlus4,
                                y => PCBranch
                        );

    ALU_control : alu port map (
                                    a => SrcA,
                                    b => SrcB,
                                    alucontrol => AluControl,
                                    zero => Zero,
                                    result => ALUResult
                                );

    ram_dmem : dmem port map (
                                clk => clk,
                                we => MemWrite,
                                a => ALUResult,
                                wd => WriteData,
                                dump => dump,
                                rd => ReadData
                             );

    mux_5 : mux2 port map ( 
                            d0 => ALUResult,
                            d1 => ReadData,
                            set => MemToReg,
                            y => Result
                        );

    pc <= PC_output;
    instr <= instr_prima;

end DATA_PATH;