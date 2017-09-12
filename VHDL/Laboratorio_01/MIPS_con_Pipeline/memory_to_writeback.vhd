library ieee;
use ieee.std_logic_1164.all;
use work.components.all;

entity memory_to_writeback is
    port (
            clk : in std_logic;
            reset : in std_logic;
            RegWriteM : in std_logic;
            MemtoRegM : in std_logic;
            AluOutM : in std_logic_vector(31 downto 0);
            ReadDataM : in std_logic_vector(31 downto 0);
            WriteRegM : in std_logic_vector(4 downto 0);

            RegWriteW : out std_logic;
            MemtoRegW : out std_logic;
            AluOutW : out std_logic_vector(31 downto 0);
            ReadDataW : out std_logic_vector(31 downto 0);
            WriteRegW : out std_logic_vector(4 downto 0)
        );
end entity;

architecture behavior of memory_to_writeback is
begin
    dut1 : flopr1 port map (
                                    q => RegWriteW,
                                    d => RegWriteM,
                                    clk => clk,
                                    rst => reset
                                );

    dut2 : flopr1 port map (
                                    q => MemToRegW,
                                    d => MemToRegM,
                                    clk => clk,
                                    rst => reset
                                );

    dut3 : flopr port map (
                                q => AluOutW,
                                d => AluOutM,
                                clk => clk,
                                rst => reset
                            );

    dut4 : flopr port map (
                                    q => ReadDataW,
                                    d => ReadDataM,
                                    clk => clk,
                                    rst => reset
                            );

    dut5 : flopr5 port map (
                                    q => WriteRegW,
                                    d => WriteRegM,
                                    clk => clk,
                                    rst => reset
                                );
end architecture;
