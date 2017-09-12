library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- AGREGAR ASSERT
-- para imprimir : report std_logic'image(tmp(0))

entity dmem_tb is
end dmem_tb;


architecture test of dmem_tb is

    component dmem is
        port (
                a : in std_logic_vector (31 DOWNTO 0);
                wd : in std_logic_vector (31 DOWNTO 0);
                clk : in std_logic;
                we : in std_logic;
                rd : out std_logic_vector (31 DOWNTO 0)
            );
    end component;

    signal a_s : std_logic_vector (31 DOWNTO 0);
    signal wd_s : std_logic_vector (31 DOWNTO 0);
    signal rd_s : std_logic_vector (31 DOWNTO 0);
    signal clk_s : std_logic;
    signal we_s : std_logic;

begin

    dut : dmem port map ( 
                          a=>a_s,
                          wd=>wd_s,
                          clk=>clk_s,
                          we=>we_s,
                          rd=>rd_s
                        );

    -- Process que mañeja el Clock
    process begin
        clk_s <= '0';
        wait for 5 ns;
        clk_s <= '1';
        wait for 5 ns;
    end process;

    process begin
        a_s <= "11111111111111111111111100000011"; -- pos = 0 FFFFFF03
        we_s <= '1';
        wd_s <= "11111111111111111111111111111111"; -- FFFFFFFF
        
        wait for 10 ns;
        a_s <= "00000000000000000000000011111100"; -- pos = 63 000000FC
        we_s <= '1';
        wd_s <= "11111111111100000000000111111111"; -- FFF001FF

        wait for 10 ns;
        a_s <= "11111111111111111111111100000011";
        we_s <= '0';
        
        wait for 10 ns;
        a_s <= "00000000000000000000000011111100";
        we_s <= '0';
        
        wait for 20 ns;
    end process;
end test;   
