library ieee;
use ieee.std_logic_1164.all;
use work.components.all;

entity execute_to_memory is
    port (
            clk : in std_logic;
            reset : in std_logic;
            RegWriteE : in std_logic;
            MemToRegE : in std_logic;
            MemWriteE : in std_logic;
            JumpE : in std_logic;
            BranchE : in std_logic;
            ZeroE : in std_logic;
            AluOutE : in std_logic_vector(31 downto 0);
            WriteDataE : in std_logic_vector(31 downto 0);
            WriteRegE : in std_logic_vector(4 downto 0);
            PCBranchE : in std_logic_vector(31 downto 0);

            RegWriteM : out std_logic;
            MemToRegM : out std_logic;
            MemWriteM : out std_logic;
            JumpM : out std_logic;
            BranchM : out std_logic;
            ZeroM : out std_logic;
            AluOutM : out std_logic_vector(31 downto 0);
            WriteDataM : out std_logic_vector(31 downto 0);
            WriteRegM : out std_logic_vector(4 downto 0);
            PCBranchM : out std_logic_vector(31 downto 0)
        );
end entity;

architecture behavior of execute_to_memory is
begin
    dut1 : flopr1 port map (
                                    q => RegWriteM,
                                    d => RegWriteE,
                                    clk => clk,
                                    rst => reset
                                );

    dut2 : flopr1 port map (
                                    q => MemToRegM,
                                    d => MemToRegE,
                                    clk => clk,
                                    rst => reset
                                );

    dut3 : flopr1 port map (
                                    q => MemWriteM,
                                    d => MemWriteE,
                                    clk => clk,
                                    rst => reset
                                );

    dut4 : flopr1 port map (
                                q => JumpM,
                                d => JumpE,
                                clk => clk,
                                rst => reset
                            );

    dut5 : flopr1 port map (
                                q => BranchM,
                                d => BranchE,
                                clk => clk,
                                rst => reset
                            );

    dut6 : flopr1 port map (
                                q => ZeroM,
                                d => ZeroE,
                                clk => clk,
                                rst => reset
                            );

    dut7 : flopr port map (
                                q => AluOutM,
                                d => AluOutE,
                                clk => clk,
                                rst => reset
                            );

    dut8 : flopr port map (
                                    q => WriteDataM,
                                    d => WriteDataE,
                                    clk => clk,
                                    rst => reset
                                );

    dut9 : flopr5 port map (
                                    q => WriteRegM,
                                    d => WriteRegE,
                                    clk => clk,
                                    rst => reset
                                );

    dut10 : flopr port map (
                                    q => PCBranchM,
                                    d => PCBranchE,
                                    clk => clk,
                                    rst => reset
                                );
end architecture;
