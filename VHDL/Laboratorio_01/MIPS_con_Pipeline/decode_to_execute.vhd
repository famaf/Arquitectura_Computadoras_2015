library ieee;
use ieee.std_logic_1164.all;
use work.components.all;

entity decode_to_execute is
    port (
            clk : in std_logic;
            reset : in std_logic;
            RegWriteD : in std_logic;
            MemToRegD : in std_logic;
            MemWriteD : in std_logic;
            JumpD : in std_logic;
            BranchD : in std_logic;
            AlucontrolD : in std_logic_vector(2 downto 0);
            ALUSrcD : in std_logic;
            RegDstD : in std_logic;
            rd1D : in std_logic_vector(31 downto 0);
            rd2D : in std_logic_vector(31 downto 0);
            RtD : in std_logic_vector(4 downto 0);
            RdD : in std_logic_vector(4 downto 0);
            SignimmD : in std_logic_vector(31 downto 0);
            PCPlus4D : in std_logic_vector(31 downto 0);

            RegWriteE : out std_logic;
            MemToRegE : out std_logic;
            MemWriteE : out std_logic;
            JumpE : out std_logic;
            BranchE : out std_logic;
            AlucontrolE : out std_logic_vector(2 downto 0);
            ALUSrcE : out std_logic;
            RegDstE : out std_logic;
            rd1E : out std_logic_vector(31 downto 0);
            rd2E : out std_logic_vector(31 downto 0);
            RtE : out std_logic_vector(4 downto 0);
            RdE : out std_logic_vector(4 downto 0);
            SignimmE : out std_logic_vector(31 downto 0);
            PCPlus4E : out std_logic_vector(31 downto 0)
        );
end entity;

architecture behavior of decode_to_execute is
begin
    dut1 : flopr1 port map (
                                    q => RegWriteE,
                                    d => RegWriteD,
                                    clk => clk,
                                    rst => reset
                                );

    dut2 : flopr1 port map (
                                    q => MemToRegE,
                                    d => MemToRegD,
                                    clk => clk,
                                    rst => reset
                                );

    dut3 : flopr1 port map (
                                    q => MemWriteE,
                                    d => MemWriteD,
                                    clk => clk,
                                    rst => reset
                                );

    dut4 : flopr1 port map (
                                q => JumpE,
                                d => JumpD,
                                clk => clk,
                                rst => reset
                            );

    dut5 : flopr1 port map (
                                q => BranchE,
                                d => BranchD,
                                clk => clk,
                                rst => reset
                            );

    dut6 : flopr3 port map (
                                    q => AlucontrolE,
                                    d => AlucontrolD,
                                    clk => clk,
                                    rst => reset
                                );

    dut7 : flopr1 port map (
                                q => ALUSrcE,
                                d => ALUSrcD,
                                clk => clk,
                                rst => reset
                            );

    dut8 : flopr1 port map (
                                q => RegDstE,
                                d => RegDstD,
                                clk => clk,
                                rst => reset
                            );

    dut9 : flopr port map (
                            q => rd1E,
                            d => rd1D,
                            clk => clk,
                            rst => reset
                        );

    dut10 : flopr port map (
                            q => rd2E,
                            d => rd2D,
                            clk => clk,
                            rst => reset
                        );

    dut11 : flopr5 port map (
                            q => RtE,
                            d => RtD,
                            clk => clk,
                            rst => reset
                        );

    dut12 : flopr5 port map (
                            q => RdE,
                            d => RdD,
                            clk => clk,
                            rst => reset
                        );

    dut13 : flopr port map (
                                q => SignimmE,
                                d => SignimmD,
                                clk => clk,
                                rst => reset
                            );

    dut14 : flopr port map (
                                q => PCPlus4E,
                                d => PCPlus4D,
                                clk => clk,
                                rst => reset
                            );
end architecture;
