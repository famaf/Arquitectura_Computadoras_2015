library ieee;
use ieee.std_logic_1164.all;
use work.components.all;

entity datapath is
    port (
            memtoreg : in std_logic;
            memwrite : in std_logic;
            branch : in std_logic;
            alusrc : in std_logic;
            regdst : in std_logic;
            regwrite : in std_logic;
            jump : in std_logic;
            reset : in std_logic;
            clock : in std_logic;
            dump : in std_logic;
            alucontrol : in std_logic_vector (2 downto 0);
            instr : out std_logic_vector(31 downto 0);
            pc : out std_logic_vector(31 downto 0)
        );
end entity;

architecture behav of datapath is
--Fetch/Decode
    signal instr_s : std_logic_vector(31 downto 0);
--Decode/Execute
    signal rd1_s : std_logic_vector(31 downto 0);
    signal rd2_s : std_logic_vector(31 downto 0);
    signal pcplus4_s : std_logic_vector(31 downto 0);
    signal signimm_s : std_logic_vector(31 downto 0);
    signal rt_s, rd_s : std_logic_vector(4 downto 0);
--Execute/Memory
    signal writereg_s : std_logic_vector(4 downto 0);
    signal aluout_s : std_logic_vector(31 downto 0);
    signal writedata_s : std_logic_vector(31 downto 0);
    signal pcbranch_s : std_logic_vector(31 downto 0);
    signal zero_s : std_logic;
--Memory/Writeback
    signal readdat_s : std_logic_vector(31 downto 0);
    signal pcsrc_s : std_logic;
--Writeback/Decode
    signal result_s : std_logic_vector(31 downto 0);

begin
    dut1 : fetch port map (
                                Jump => jump,
                                PCBranchM => pcbranch_s,
                                PCSrcM => pcsrc_s,
                                InstrF => instr_s,
                                PCPLus4F => pcplus4_s,
                                PCF => pc,
                                reset => reset,
                                clk => clock
                            );

    dut2 : decode port map (
                                InstrD => instr_s,
                                A3 => writereg_s,
                                WD3 => result_s,
                                RegWrite => regwrite,
                                clk => clock,
                                Rtd => rt_s,
                                RdD => rd_s,
                                SignImmD => signimm_s,
                                RD1D => rd1_s,
                                RD2D => rd2_s
                            );

    dut3 : execute port map (
                                    RD1E => rd1_s,
                                    RD2E => rd2_s,
                                    RtE => rt_s,
                                    RdE => rd_s,
                                    SignImmE => signimm_s,
                                    PcPlus4E => pcplus4_s,
                                    RegDst => regdst,
                                    AluSrc => alusrc,
                                    AluControl => alucontrol,
                                    ZeroE => zero_s,
                                    WriteDataE => writedata_s,
                                    AluOutE => aluout_s,
                                    WriteRegE => writereg_s,
                                    PcBranchE => pcbranch_s
                                );

    dut4 : memory port map (
                                AluOutM => aluout_s,
                                zeroM => zero_s,
                                WriteDataM => writedata_s,
                                MemWrite => memwrite,
                                Branch => branch,
                                dump => dump,
                                clk => clock,
                                ReadDat => readdat_s,
                                PCSrcM => pcsrc_s
                            );

    dut5 : writeback port map (
                                        AluOutW => aluout_s,
                                        ReadDataW => readdat_s,
                                        MemToReg => memtoreg,
                                        ResultW => result_s
                                    );

    instr <= instr_s;
end architecture;
