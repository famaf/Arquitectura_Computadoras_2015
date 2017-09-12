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

-- UNIDAD DE CONTROL
component controller is
    port (
            -- ENTRADAS
            Op : in std_logic_vector (5 DOWNTO 0);
            Funct : in std_logic_vector (5 DOWNTO 0);
            -- SALIDAS
            MemToReg : out std_logic;
            MemWrite : out std_logic;
            Branch : out std_logic;
            AluSrc : out std_logic;
            RegDst : out std_logic;
            RegWrite : out std_logic;
            Jump : out std_logic;
            AluControl : out std_logic_vector (2 DOWNTO 0)
         );
end component;
--------------------

-- PANELES ENCARGADOS DEL PIPELINE
    component fetch_to_dec is
        port (
                -- ENTRADAS
                clk : in std_logic;
                Instr_in : in std_logic_vector (31 downto 0);
                PCPlus4_in : in std_logic_vector (31 downto 0);
                -- SALIDAS
                Instr_out : out std_logic_vector (31 downto 0);
                PCPlus4_out : out std_logic_vector (31 downto 0)
            );
    end component;

    component dec_to_ex is
        port (
                -- ENTRADAS
                clk : in std_logic;
                RD1_in : in std_logic_vector (31 DOWNTO 0);
                RD2_in : in std_logic_vector (31 DOWNTO 0);
                Rt_in : in std_logic_vector (4 DOWNTO 0);
                Rd_in : in std_logic_vector (4 DOWNTO 0);
                SignImm_in : in std_logic_vector (31 DOWNTO 0);
                PCPlus4_in : in std_logic_vector (31 DOWNTO 0);
                -- SALIDAS
                RD1_out : out std_logic_vector (31 DOWNTO 0);
                RD2_out : out std_logic_vector (31 DOWNTO 0);
                Rt_out : out std_logic_vector (4 DOWNTO 0);
                Rd_out : out std_logic_vector (4 DOWNTO 0);
                SignImm_out : out std_logic_vector (31 DOWNTO 0);
                PCPlus4_out : out std_logic_vector (31 DOWNTO 0);
                -- EXTENSION DEL PIPELINE -> ENTRADAS
                RegWrite_in : in std_logic;
                MemtoReg_in : in std_logic;
                MemWrite_in : in std_logic;
                Jump_in : in std_logic;
                Branch_in : in std_logic;
                ALUControl_in : in std_logic_vector (2 DOWNTO 0);
                ALUSrc_in : in std_logic;
                RegDst_in : in std_logic;
                -- EXTENSION DEL PIPELINE -> SALIDAS
                RegWrite_out : out std_logic;
                MemtoReg_out : out std_logic;
                MemWrite_out : out std_logic;
                Jump_out : out std_logic;
                Branch_out : out std_logic;
                ALUControl_out : out std_logic_vector (2 DOWNTO 0);
                ALUSrc_out : out std_logic;
                RegDst_out : out std_logic
            );
    end component;

    component ex_to_mem is
        port (
                -- ENTRADAS
                clk : in std_logic;
                Zero_in : in std_logic;
                AluOut_in : in std_logic_vector (31 DOWNTO 0);
                WriteData_in : in std_logic_vector (31 DOWNTO 0);
                PCBranch_in : in std_logic_vector (31 DOWNTO 0);
                WriteReg_in : in std_logic_vector (4 DOWNTO 0);
                -- SALIDAS
                Zero_out : out std_logic;
                AluOut_out : out std_logic_vector (31 DOWNTO 0);
                WriteData_out : out std_logic_vector (31 DOWNTO 0);
                WriteReg_out : out std_logic_vector (4 DOWNTO 0);
                PCBranch_out : out std_logic_vector (31 DOWNTO 0);
                -- EXTENSION DEL PIPELINE -> ENTRADAS
                RegWrite_in : in std_logic;
                MemtoReg_in : in std_logic;
                MemWrite_in : in std_logic;
                Jump_in : in std_logic;
                Branch_in : in std_logic;
                -- EXTENSION DEL PIPELINE -> ENTRADAS
                RegWrite_out : out std_logic;
                MemtoReg_out : out std_logic;
                MemWrite_out : out std_logic;
                Jump_out : out std_logic;
                Branch_out : out std_logic
            );
    end component;

    component mem_to_wb is
        port (
                -- ENTRADAS
                clk : in std_logic;
                AluOut_in : in std_logic_vector (31 DOWNTO 0);
                ReadData_in : in std_logic_vector (31 DOWNTO 0);
                WriteReg_in : in std_logic_vector (4 DOWNTO 0);
                -- SALIDAS
                AluOut_out : out std_logic_vector (31 DOWNTO 0);
                ReadData_out : out std_logic_vector (31 DOWNTO 0);
                WriteReg_out : out std_logic_vector (4 DOWNTO 0);
                -- EXTENSION DEL PIPELINE -> ENTRADAS
                RegWrite_in : in std_logic;
                MemtoReg_in : in std_logic;
                -- EXTENSION DEL PIPELINE -> SALIDAS
                RegWrite_out : out std_logic;
                MemtoReg_out : out std_logic
            );
    end component;
-------------------------------------

-- COMPONENTES DEL PIPELINE
    component fetch is
        port (
                -- ENTRADAS
                clk : in std_logic;
                reset : in std_logic;
                Jump : in std_logic;
                PcSrcM : in std_logic;
                PcBranchM : in std_logic_vector (31 DOWNTO 0);
                -- SALIDAS
                InstrF : out std_logic_vector (31 DOWNTO 0);
                PCF : out std_logic_vector (31 DOWNTO 0);
                PCPLus4F : out std_logic_vector (31 DOWNTO 0)
            );
    end component;

    component decode is
        port (
                -- ENTRADAS
                clk : in std_logic;
                RegWrite : in std_logic;
                A3 : in std_logic_vector (4 DOWNTO 0);
                InstrD : in std_logic_vector (31 DOWNTO 0);
                Wd3 : in std_logic_vector (31 DOWNTO 0);
                -- SALIDAS
                RtD : out std_logic_vector (4 DOWNTO 0);
                RdD : out std_logic_vector (4 DOWNTO 0);
                SignImmD : out std_logic_vector (31 DOWNTO 0);
                RD1D : out std_logic_vector (31 DOWNTO 0);
                RD2D : out std_logic_vector (31 DOWNTO 0);
                -- PUERTOS AUXILIARES DE IN/OUT (ES UN CABLE)
                PCPlus4D_in : in std_logic_vector (31 DOWNTO 0);
                PCPlus4D_out : out std_logic_vector (31 DOWNTO 0)
            );
    end component;

    component execute is
        port (
                -- ENTRADAS
                RegDst : in std_logic;
                AluSrc : in std_logic;
                AluControl : in std_logic_vector (2 DOWNTO 0);
                RD1E : in std_logic_vector (31 DOWNTO 0);
                RD2E : in std_logic_vector (31 DOWNTO 0);
                PCPlus4E : in std_logic_vector (31 DOWNTO 0);
                RtE : in std_logic_vector (4 DOWNTO 0);
                RdE : in std_logic_vector (4 DOWNTO 0);
                SignImmE : in std_logic_vector (31 DOWNTO 0);
                -- SALIDAS
                WriteRegE : out std_logic_vector (4 DOWNTO 0);
                zeroE : out std_logic;
                AluOutE : out std_logic_vector (31 DOWNTO 0);
                WriteDataE : out std_logic_vector (31 DOWNTO 0);
                PCBranchE : out std_logic_vector (31 DOWNTO 0)
            );
    end component;

    component memory is
        port (
                -- ENTRADAS
                clk : in std_logic;
                dump : in std_logic;
                MemWrite : in std_logic;
                Branch : in std_logic;
                AluOutM : in std_logic_vector (31 DOWNTO 0);
                ZeroM : in std_logic;
                WriteDataM : in std_logic_vector (31 DOWNTO 0);
                -- SALIDAS
                ReadDataM : out std_logic_vector (31 DOWNTO 0);
                PCSrcM : out std_logic;
                -- PUERTOS AUXILIARES DE IN/OUT (ES UN CABLE)
                WriteRegM_in : in std_logic_vector (4 DOWNTO 0);
                WriteRegM_out : out std_logic_vector (4 DOWNTO 0)
            );
    end component;

    component writeback is
        port (
                -- ENTRADAS
                MemToReg : in std_logic;
                AluOutW : in std_logic_vector (31 DOWNTO 0);
                ReadDataW : in std_logic_vector (31 DOWNTO 0);
                -- SALIDAS
                ResultW : out std_logic_vector (31 DOWNTO 0)
            );
    end component;
--------------------------------

------------------------------------------
------------- SIGNAL A USAR -------------
------------------------------------------
-- IN DEL FETCH - DECODE
signal InstrF_s : std_logic_vector (31 downto 0);
signal PCPlus4F_s : std_logic_vector (31 downto 0);
-- OUT DEL FETCH - DECODE
signal InstrD_s : std_logic_vector (31 downto 0);
signal PCPlus4D_s : std_logic_vector (31 downto 0);
-- IN DEL DECODE - EXECUTE
signal RD1D_s : std_logic_vector (31 DOWNTO 0);
signal RD2D_s : std_logic_vector (31 DOWNTO 0);
signal RtD_s : std_logic_vector (4 DOWNTO 0);
signal RdD_s : std_logic_vector (4 DOWNTO 0);
signal SignImmD_s : std_logic_vector (31 DOWNTO 0);
signal wire1 : std_logic_vector (31 DOWNTO 0);
-- OUT DEL DECODE - EXECUTE
signal RD1E_s : std_logic_vector (31 DOWNTO 0);
signal RD2E_s : std_logic_vector (31 DOWNTO 0);
signal RtE_s : std_logic_vector (4 DOWNTO 0);
signal RdE_s : std_logic_vector (4 DOWNTO 0);
signal SignImmE_s : std_logic_vector (31 DOWNTO 0);
signal wire2 : std_logic_vector (31 DOWNTO 0);
-- IN DEL EXECUTE - MEMORY
signal ZeroE_s : std_logic;
signal ALUOutE_s : std_logic_vector (31 DOWNTO 0);
signal WriteDataE_s : std_logic_vector (31 DOWNTO 0);
signal WriteRegE_s : std_logic_vector (4 DOWNTO 0);
signal PCBranchE_s : std_logic_vector (31 DOWNTO 0);
-- OUT DEL EXECUTE - MEMORY
signal ZeroM_s : std_logic;
signal ALUOutM_s : std_logic_vector (31 DOWNTO 0);
signal WriteDataM_s : std_logic_vector (31 DOWNTO 0);
signal WriteRegM_s : std_logic_vector (4 DOWNTO 0);
signal PCBranchM_s : std_logic_vector (31 DOWNTO 0);
-- IN DEL MEMORY - WRITEBACK
signal ReadDataM_s : std_logic_vector (31 DOWNTO 0);
signal wire3 : std_logic_vector (4 DOWNTO 0);
-- OUT DEL MEMORY - WRITEBACK
signal ALUOutW_s : std_logic_vector (31 DOWNTO 0);
signal ReadDataW_s : std_logic_vector (31 DOWNTO 0);
signal wire4 : std_logic_vector (4 DOWNTO 0);
-- SIGNAL DEL RESULTW DEL DIAGRAMA
signal Result_s : std_logic_vector (31 DOWNTO 0);

-- OUT DEL CONTROLLER
signal RegWriteD_s : std_logic;
signal MemToRegD_s : std_logic;
signal MemWriteD_s : std_logic;
signal JumpD_s : std_logic;
signal BranchD_s : std_logic;
signal AluControlD_s : std_logic_vector (2 DOWNTO 0);
signal AluSrcD_s : std_logic;
signal RegDstD_s : std_logic;

-- SIGNAL DE PIPELINE DEL EXECUTE
signal RegWriteE_s : std_logic;
signal MemToRegE_s : std_logic;
signal MemWriteE_s : std_logic;
signal JumpE_s : std_logic;
signal BranchE_s : std_logic;
signal AluControlE_s : std_logic_vector (2 DOWNTO 0);
signal AluSrcE_s : std_logic;
signal RegDstE_s : std_logic;

-- SIGNAL DE PIPELINE DEL MEMORY
signal RegWriteM_s : std_logic;
signal MemToRegM_s : std_logic;
signal MemWriteM_s : std_logic;
signal JumpM_s : std_logic;
signal BranchM_s : std_logic;

-- SIGNAL DE PIPELINE DEL WRITEBACK
signal RegWriteW_s : std_logic;
signal MemToRegW_s : std_logic;

-- OTRAS SIGNAL
signal PCSrcM_s : std_logic;

-- DEL COMPONENTE MIPS
signal clk_s : std_logic;
signal reset_s : std_logic;
signal dump_s : std_logic;
signal pc_s : std_logic_vector (31 DOWNTO 0);
------------------------------------------

begin

    I_FETCH : fetch port map (
                            -- ENTRADAS
                            clk => clk,
                            reset => reset,
                            Jump => JumpM_s,
                            PcSrcM => PCSrcM_s,
                            PcBranchM => PCBranchM_s,
                            -- SALIDAS
                            InstrF => InstrF_s,
                            PCF => pc_s,
                            PCPLus4F => PCPlus4F_s
                        );

    F_D : fetch_to_dec port map (
                                    -- ENTRADAS
                                    clk => clk,
                                    Instr_in => InstrF_s,
                                    PCPlus4_in => PCPlus4F_s,
                                    -- SALIDAS
                                    Instr_out => InstrD_s,
                                    PCPlus4_out => PCPlus4D_s
                                );


    I_DECODE : decode port map (
                                -- ENTRADAS
                                clk => clk,
                                RegWrite => RegWriteW_s,
                                A3 => wire4,
                                InstrD => InstrD_s,
                                Wd3 => Result_s,
                                -- SALIDAS
                                RtD => RtD_s,
                                RdD => RdD_s,
                                SignImmD => SignImmD_s,
                                RD1D => RD1D_s,
                                RD2D => RD2D_s,
                                -- PUERTOS AUXILIARES DE IN/OUT (ES UN CABLE)
                                PCPlus4D_in => PCPlus4D_s,
                                PCPlus4D_out => wire1
                            );

    D_E : dec_to_ex port map (
                                -- ENTRADAS
                                clk => clk,
                                RD1_in => RD1D_s,
                                RD2_in => RD2D_s,
                                Rt_in => RtD_s,
                                Rd_in => RdD_s,
                                SignImm_in => SignImmD_s,
                                PCPlus4_in => wire1,
                                -- SALIDAS
                                RD1_out => RD1E_s,
                                RD2_out => RD2E_s,
                                Rt_out => RtE_s,
                                Rd_out => RdE_s,
                                SignImm_out => SignImmE_s,
                                PCPlus4_out => wire2,
                                -- EXTENSION DEL PIPELINE -> ENTRADAS
                                RegWrite_in => RegWriteD_s,
                                MemtoReg_in => MemToRegD_s,
                                MemWrite_in => MemWriteD_s,
                                Jump_in => JumpD_s,
                                Branch_in => BranchD_s,
                                ALUControl_in => AluControlD_s,
                                ALUSrc_in => AluSrcD_s,
                                RegDst_in => RegDstD_s,
                                -- EXTENSION DEL PIPELINE -> SALIDAS
                                RegWrite_out => RegWriteE_s,
                                MemtoReg_out => MemToRegE_s,
                                MemWrite_out => MemWriteE_s,
                                Jump_out => JumpE_s,
                                Branch_out => BranchE_s,
                                ALUControl_out => AluControlE_s,
                                ALUSrc_out => AluSrcE_s,
                                RegDst_out => RegDstE_s
                            );

    I_EXECUTE : execute port map (
                                -- ENTRADAS
                                RegDst => RegDstE_s,
                                AluSrc => AluSrcE_s,
                                AluControl => AluControlE_s,
                                RD1E => RD1E_s,
                                RD2E => RD2E_s,
                                PCPlus4E => wire2,
                                RtE => RtE_s,
                                RdE => RdE_s,
                                SignImmE => SignImmE_s,
                                -- SALIDAS
                                WriteRegE => WriteRegE_s,
                                zeroE => ZeroE_s,
                                AluOutE => ALUOutE_s,
                                WriteDataE => WriteDataE_s,
                                PCBranchE => PCBranchE_s
                            );

    E_M : ex_to_mem port map (
                                -- ENTRADAS
                                clk => clk,
                                Zero_in => ZeroE_s,
                                AluOut_in => ALUOutE_s,
                                WriteData_in => WriteDataE_s,
                                PCBranch_in => PCBranchE_s,
                                WriteReg_in => WriteRegE_s,
                                -- SALIDAS
                                Zero_out => ZeroM_s,
                                AluOut_out => ALUOutM_s,
                                WriteData_out => WriteDataM_s,
                                WriteReg_out => WriteRegM_s,
                                PCBranch_out => PCBranchM_s,
                                -- EXTENSION DEL PIPELINE -> ENTRADAS
                                RegWrite_in => RegWriteE_s,
                                MemtoReg_in => MemToRegE_s,
                                MemWrite_in => MemWriteE_s,
                                Jump_in => JumpE_s,
                                Branch_in => BranchE_s,
                                -- EXTENSION DEL PIPELINE -> ENTRADAS
                                RegWrite_out => RegWriteM_s,
                                MemtoReg_out => MemToRegM_s,
                                MemWrite_out => MemWriteM_s,
                                Jump_out => JumpM_s,
                                Branch_out => BranchM_s
                            );

    I_MEMORY : memory port map (
                                -- ENTRADAS
                                clk => clk,
                                dump => dump,
                                MemWrite => MemWriteM_s,
                                Branch => BranchM_s,
                                AluOutM => ALUOutM_s,
                                ZeroM => ZeroM_s,
                                WriteDataM => WriteDataM_s,
                                -- SALIDAS
                                ReadDataM => ReadDataM_s,
                                PCSrcM => PCSrcM_s,
                                -- PUERTOS AUXILIARES DE IN/OUT (ES UN CABLE)
                                WriteRegM_in => WriteRegM_s,
                                WriteRegM_out => wire3
                            );

    M_W : mem_to_wb port map (
                                -- ENTRADAS
                                clk => clk,
                                AluOut_in => ALUOutM_s, --mmmmmmm
                                ReadData_in => ReadDataM_s,
                                WriteReg_in => wire3,
                                -- SALIDAS
                                AluOut_out => ALUOutW_s,
                                ReadData_out => ReadDataW_s,
                                WriteReg_out => wire4,
                                -- EXTENSION DEL PIPELINE -> ENTRADAS
                                RegWrite_in => RegWriteM_s,
                                MemtoReg_in => MemToRegM_s,
                                -- EXTENSION DEL PIPELINE -> SALIDAS
                                RegWrite_out => RegWriteW_s,
                                MemtoReg_out => MemToRegW_s
                            );

    I_WRITEBACK : writeback port map (
                                    -- ENTRADAS
                                    MemToReg => MemToRegW_s,
                                    AluOutW => ALUOutW_s,
                                    ReadDataW => ReadDataW_s,
                                    -- SALIDAS
                                    ResultW => Result_s
                                );

    CONTROLARDOR : controller port map (
                                            -- ENTRADAS
                                            Op => InstrD_s(31 DOWNTO 26),
                                            Funct => InstrD_s(5 DOWNTO 0),
                                            -- SALIDAS
                                            MemToReg => MemToRegD_s,
                                            MemWrite => MemWriteD_s,
                                            Branch => BranchD_s,
                                            AluSrc => AluSrcD_s,
                                            RegDst => RegDstD_s,
                                            RegWrite => RegWriteD_s,
                                            Jump => JumpD_s,
                                            AluControl => AluControlD_s
                                        );

--    clk <= clk_s;
    instr <= InstrD_s;
    pc <= pc_s;

end micro;
