library ieee;
use ieee.std_logic_1164.all;
use work.components.all;

entity mips is 
port (
        reset : in std_logic;
        clock : in std_logic;
        dump : in std_logic;
        instr : out std_logic_vector(31 downto 0);
        pc : out std_logic_vector(31 downto 0)
    );
end entity;

architecture behav of mips is
--Signal of Control Unit
    signal regwriteD_s : std_logic;
    signal regwriteE_s : std_logic;
    signal regwriteM_s : std_logic;
    signal regwriteW_s : std_logic;

    signal memtoregD_s : std_logic;
    signal memtoregE_s : std_logic;
    signal memtoregM_s : std_logic;
    signal memtoregW_s : std_logic;

    signal memwriteD_s : std_logic;
    signal memwriteE_s : std_logic;
    signal memwriteM_s : std_logic;

    signal jumpD_s : std_logic;
    signal jumpE_s : std_logic;
    signal jumpM_s : std_logic;

    signal branchD_s : std_logic;
    signal branchE_s : std_logic;
    signal branchM_s : std_logic;

    signal alucontrolD_s : std_logic_vector(2 downto 0);
    signal alucontrolE_s : std_logic_vector(2 downto 0);

    signal alusrcD_s : std_logic;
    signal alusrcE_s : std_logic;

    signal regdstD_s : std_logic;
    signal regdstE_s : std_logic;

    signal instrF_s : std_logic_vector(31 downto 0);
    signal instrD_s : std_logic_vector(31 downto 0);
    signal pc_s : std_logic_vector(31 downto 0);

    signal pcplus4F_s : std_logic_vector(31 downto 0);
    signal pcplus4D_s : std_logic_vector(31 downto 0);
    signal pcplus4E_s : std_logic_vector(31 downto 0);

    signal resultW_s : std_logic_vector(31 downto 0);

    signal rtD_s : std_logic_vector(4 downto 0);
    signal rdD_s : std_logic_vector(4 downto 0);
    signal rtE_s : std_logic_vector(4 downto 0);
    signal rdE_s : std_logic_vector(4 downto 0);

    signal signimmD_s : std_logic_vector(31 downto 0);
    signal signimmE_s : std_logic_vector(31 downto 0);

    signal rd1D_s : std_logic_vector(31 downto 0);
    signal rd1E_s : std_logic_vector(31 downto 0);

    signal rd2D_s : std_logic_vector(31 downto 0);
    signal rd2E_s : std_logic_vector(31 downto 0);

    signal writeregE_s : std_logic_vector(4 downto 0);
    signal writeregM_s : std_logic_vector(4 downto 0);
    signal writeregW_s : std_logic_vector(4 downto 0);

    signal writedataE_s : std_logic_vector(31 downto 0);
    signal writedataM_s : std_logic_vector(31 downto 0);

    signal aluoutE_s : std_logic_vector(31 downto 0);
    signal aluoutM_s : std_logic_vector(31 downto 0);

    signal pcbranchE_s : std_logic_vector(31 downto 0);
    signal pcbranchM_s : std_logic_vector(31 downto 0);

    signal zeroE_s : std_logic;
    signal zeroM_s : std_logic;

    signal readdataM_s : std_logic_vector(31 downto 0);
    signal readdataW_s : std_logic_vector(31 downto 0);

    signal PCSrcM_s : std_logic;

    signal aluoutW_s : std_logic_vector(31 downto 0);

begin
    dut1 : controller port map (
                                        op => instrD_s(31 downto 26),
                                        funct => instrD_s(5 downto 0),
                                        MemToReg => memtoregD_s,
                                        MemWrite => memwriteD_s,
                                        Branch => branchD_s,
                                        AluSrc => alusrcD_s,
                                        RegDst => regdstD_s,
                                        RegWrite => regwriteD_s,
                                        Jump => jumpD_s,
                                        AluControl => alucontrolD_s
                                    );

    dut2 : fetch port map (
                                Jump => jumpM_s,
                                PCSrcM => PCSrcM_s,
                                PCBranchM => PCBranchM_s,
                                clk => clock,
                                reset => reset,
                                InstrF => instrF_s,
                                PCF => pc_s,
                                PCPlus4F => PCPlus4F_s
                            );

    dut3 : decode port map (
                                A3 => writeregW_s,
                                InstrD => instrD_s,
                                WD3 => resultW_s,
                                RegWrite => regwriteW_s,
                                clk => clock,
                                RtD => rtD_s,
                                RdD => rdD_s,
                                SignImmD => signimmD_s,
                                RD1D => rd1D_s,
                                RD2D => rd2D_s
                            );

    dut4 : execute port map (
                                    RD1E => rd1E_s,
                                    RD2E => rd2E_s,
                                    PCPlus4E => pcplus4E_s,
                                    SignImmE => signimmE_s,
                                    RtE => rtE_s,
                                    RdE => rdE_s,
                                    AluControl => alucontrolE_s,
                                    RegDst => regdstE_s,
                                    AluSrc => alusrcE_s,
                                    WriteRegE => writeregE_s,
                                    AluOutE => aluoutE_s,
                                    WriteDataE => writedataE_s,
                                    PcBranchE => pcbranchE_s,
                                    ZeroE => zeroE_s
                                );

    dut5 : memory port map (
                                AluOutM => aluoutM_s,
                                zeroM => zeroM_s,
                                WriteDataM => writedataM_s,
                                clk => clock,
                                dump => dump,
                                MemWrite => memwriteM_s,
                                Branch => branchM_s,
                                ReadDat => readdataM_s,
                                PCSrcM => PCSrcM_s
                            );

    dut6 : writeback port map (
                                        AluOutW => aluoutW_s,
                                        ReadDataW => readdataW_s,
                                        MemToReg => memtoregW_s,
                                        ResultW => resultW_s
                                    );

    dut7 : fetch_to_decode port map (
                                        clk => clock,
                                        reset => reset,
                                        PCPlus4F => pcplus4F_s,
                                        instrF => instrF_s,
                                        instrD => instrD_s,
                                        PCPlus4D => pcplus4D_s
                                     );

    dut8 : decode_to_execute port map (
                                            clk => clock,
                                            reset => reset,
                                            RegWriteD => regwriteD_s,
                                            MemToRegD => memtoregD_s,
                                            MemWriteD => memwriteD_s,
                                            JumpD => jumpD_s,
                                            BranchD => branchD_s,
                                            AluControlD => alucontrolD_s,
                                            AluSrcD => alusrcD_s,
                                            RegDstD => regdstD_s,
                                            rd1D => rd1D_s,
                                            rd2D => rd2D_s,
                                            RtD => rtD_s,
                                            RdD => rdD_s,
                                            SignimmD => signimmD_s,
                                            PCPlus4D => pcplus4D_s,
                                            RegWriteE => regwriteE_s,
                                            MemToRegE => memtoregE_s,
                                            MemWriteE => memwriteE_s,
                                            JumpE => jumpE_s,
                                            BranchE => branchE_s,
                                            AluControlE => alucontrolE_s,
                                            ALUSrcE => alusrcE_s,
                                            RegDstE => regdstE_s,
                                            rd1E => rd1E_s,
                                            rd2E => rd2E_s,
                                            RtE => rtE_s,
                                            RdE => rdE_s,
                                            SignimmE => signimmE_s,
                                            PCPlus4E => pcplus4E_s
                                        );

    dut9 : execute_to_memory port map (
                                            clk => clock,
                                            reset => reset,
                                            RegWriteE => regwriteE_s,
                                            MemToRegE => memtoregE_s,
                                            MemWriteE => memwriteE_s,
                                            JumpE => jumpE_s,
                                            BranchE => branchE_s,
                                            ZeroE => zeroE_s,
                                            AluOutE => aluoutE_s,
                                            WriteDataE => writedataE_s,
                                            WriteRegE => writeregE_s,
                                            PCBranchE => pcbranchE_s,
                                            RegWriteM => regwriteM_s,
                                            MemToRegM => memtoregM_s,
                                            MemWriteM => memwriteM_s,
                                            JumpM => jumpM_s,
                                            BranchM => branchM_s,
                                            ZeroM => zeroM_s,
                                            AluOutM => aluoutM_s,
                                            WriteDataM => writedataM_s,
                                            WriteRegM => writeregM_s,
                                            PCBranchM => pcbranchM_s
                                        );

    dut10 : memory_to_writeback port map (
                                            clk => clock,
                                            reset => reset,
                                            RegWriteM => regwriteM_s,
                                            MemToRegM => memtoregM_s,
                                            AluOutM => aluoutM_s,
                                            ReadDataM => readdataM_s,
                                            WriteRegM => writeregM_s,
                                            RegWriteW => regwriteW_s,
                                            MemToRegW => memtoregW_s,
                                            AluOutW => aluoutW_s,
                                            ReadDataW => readdataW_s,
                                            WriteRegW => writeregW_s
                                        );

    instr <= instrF_s;
    pc <= pc_s;
end architecture;

