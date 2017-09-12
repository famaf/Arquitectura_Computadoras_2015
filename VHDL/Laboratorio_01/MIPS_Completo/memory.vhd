library ieee;
use ieee.std_logic_1164.all;
use work.components.all;

entity memory is
    port (
            AluOutM : in std_logic_vector(31 downto 0);
            zeroM : in std_logic;
            WriteDataM : in std_logic_vector(31 downto 0);
            clk : in std_logic;
            dump : in std_logic;
            MemWrite : in std_logic;
            Branch : in std_logic;
            ReadDat : out std_logic_vector(31 downto 0);
            PCSrcM : out std_logic
        );
end entity;

architecture behav of memory is
begin
    PCSrcM <= Branch and zeroM;

    dut1 : dmem port map (
                                clk => clk,
                                we => MemWrite,
                                a => AluOutM,
                                wd => WriteDataM,
                                rd => ReadDat,
                                dump => dump
                            );
end architecture;

