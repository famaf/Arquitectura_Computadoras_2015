library ieee;
use ieee.std_logic_1164.all;
use work.components.all;

entity execute is
    port (
            RD1E : in std_logic_vector(31 downto 0);
            RD2E : in std_logic_vector(31 downto 0);
            PCPlus4E : in std_logic_vector(31 downto 0);
            SignImmE : in std_logic_vector(31 downto 0);
            RtE : in std_logic_vector(4 downto 0);
            RdE : in std_logic_vector(4 downto 0);
            AluControl : in std_logic_vector(2 downto 0);
            RegDst : in std_logic;
            AluSrc : in std_logic;
            WriteRegE : out std_logic_vector(4 downto 0);
            AluOutE : out std_logic_vector(31 downto 0);
            WriteDataE : out std_logic_vector(31 downto 0);
            PcBranchE : out std_logic_vector(31 downto 0);
            ZeroE : out std_logic
        );
end entity;

architecture behav of execute is

signal SrcAE : std_logic_vector(31 downto 0);
signal SrcBE : std_logic_vector(31 downto 0);
signal wire : std_logic_vector(31 downto 0);

begin
    SrcAE <= RD1E;
    WriteDataE <= RD2E;

    dut1 : mux2 port map (
                                d0 => RD2E,
                                d1 => SignImmE,
                                y => SrcBE,
                                s => AluSrc
                            );

    dut2 : alu port map (
                            a => SrcAE,
                            b => SrcBE,
                            alucontrol => AluControl,
                            result => AluOutE,
                            zero => ZeroE
                        );

    dut3 : mux2_5b port map (
                                d0 => RtE,
                                d1 => RdE,
                                y => WriteRegE,
                                s => RegDst
                            );

    dut4 : sl2 port map(
                        a => SignImmE,
                        y => wire
                    );

    dut5 : adder port map (
                                a => wire,
                                b => PCPlus4E,
                                y => PcBranchE
                            );
end behav;
