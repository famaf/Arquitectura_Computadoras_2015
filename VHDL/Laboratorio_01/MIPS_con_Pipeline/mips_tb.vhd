library ieee;
use ieee.std_logic_1164.all;

entity mips_tb is
end entity;

architecture TB of mips_tb is

component mips is 
    port (
            reset : in std_logic;
            clock : in std_logic;
            dump : in std_logic;
            instr : out std_logic_vector(31 downto 0);
            pc : out std_logic_vector(31 downto 0)
        );
end component;

    signal reset : std_logic;
    signal clock : std_logic;
    signal dump : std_logic;
    signal instr : std_logic_vector(31 downto 0);
    signal pc : std_logic_vector(31 downto 0);

begin
    dut1 : mips port map (
                            reset => reset,
                            clock => clock,
                            dump => dump,
                            instr => instr,
                            pc => pc
                        );

    process begin
        clock <= '1';
        wait for 5 ns;
        clock <= '0';
        wait for 5 ns;
    end process;

    process begin
        dump <= '0';
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 210 ns;
        dump <= '1';
        wait for 150 ns;
    end process;

end architecture;
