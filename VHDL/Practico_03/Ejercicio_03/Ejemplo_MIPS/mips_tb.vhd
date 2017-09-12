library ieee;
use ieee.std_logic_1164.all;


entity mips_tb is
end mips_tb;


architecture test of mips_tb is

    component mips
        port (
                clk : in std_logic;
                reset : in std_logic;
                dump : in std_logic;
                instr : out std_logic_vector (31 DOWNTO 0);
                pc : out std_logic_vector (31 DOWNTO 0)
            );
    end component;

    signal clk_s : std_logic;
    signal reset_s : std_logic;
    signal dump_s : std_logic;
    signal instr_s : std_logic_vector (31 DOWNTO 0);
    signal pc_s : std_logic_vector (31 DOWNTO 0);

begin

    dut : mips port map (
                                clk => clk_s,
                                reset => reset_s,
                                dump => dump_s,
                                instr => instr_s,
                                pc => pc_s
                            );

    process begin
        clk_s <= '1';
        wait for 10 ns;
        clk_s <= '0';
        wait for 10 ns;
    end process;

    process begin
        dump_s <= '0';
        reset_s <= '1';
        wait for 20 ns;
        reset_s <= '0';
        wait for 170 ns;
        dump_s <= '1';
        wait for 30 ns;
    end process;

end test;