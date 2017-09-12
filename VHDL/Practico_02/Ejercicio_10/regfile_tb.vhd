library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity regfile_tb is
end regfile_tb;


architecture test of regfile_tb is
    component regfile is
        port (
                clk : in std_logic;
                we3 : in std_logic;
                ra1 : in std_logic_vector (4 DOWNTO 0);
                ra2 : in std_logic_vector (4 DOWNTO 0);
                wa3 : in std_logic_vector (4 DOWNTO 0);
                wd3 : in std_logic_vector (31 DOWNTO 0);
                rd1 : out std_logic_vector (31 DOWNTO 0);
                rd2 : out std_logic_vector (31 DOWNTO 0)
            );
    end component;

    signal clk_s : std_logic;
    signal we3_s : std_logic;
    signal ra1_s : std_logic_vector (4 DOWNTO 0);
    signal ra2_s : std_logic_vector (4 DOWNTO 0);
    signal wa3_s : std_logic_vector (4 DOWNTO 0);
    signal wd3_s : std_logic_vector (31 DOWNTO 0);
    signal rd1_s : std_logic_vector (31 DOWNTO 0);
    signal rd2_s : std_logic_vector (31 DOWNTO 0);

begin

    dut : regfile port map (
                             clk=>clk_s,
                             we3=>we3_s,
                             ra1=>ra1_s,
                             ra2=>ra2_s,
                             wa3=>wa3_s,
                             wd3=>wd3_s,
                             rd1=>rd1_s,
                             rd2=>rd2_s
                            );

-- Process que mañeja el clk
    process begin
        clk_s <= '0';
        wait for 5 ns;
        clk_s <= '1';
        wait for 5 ns;
    end process;


    process begin
        we3_s <= '1'; -- Enable = 1
        wa3_s <= "00001";
        wd3_s <= "11111111111111111111111111111111";
        
        wait for 10 ns;
        
        wa3_s <= "00010";
        wd3_s <= "00000111111111111111111111111111";
        
        wait for 10 ns;
        
        we3_s <= '0'; -- Enable = 0
        ra1_s <= "00001";
        ra2_s <= "00010";
        
        wait for 10 ns;
        
    end process;
end test;
