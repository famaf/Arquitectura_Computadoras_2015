library ieee;
use ieee.std_logic_1164.all;


entity flopr_tb is
    generic ( N : natural := 16 ); -- Generalizacion para N bits
end flopr_tb;


architecture test of flopr_tb is

    component flopr is
        port (
                clk : in std_logic;
                reset : in std_logic;
                d : in std_logic_vector (N-1 DOWNTO 0);
                q : out std_logic_vector (N-1 DOWNTO 0)
            );
    end component;

    signal reset_s : std_logic;
    signal clk_s : std_logic;
    signal d_s : std_logic_vector (N-1 DOWNTO 0);
    signal q_s : std_logic_vector (N-1 DOWNTO 0);

begin

    dut : flopr port map ( 
                           clk=>clk_s,
                           reset=>reset_s,
                           d=>d_s,
                           q=>q_s
                        );

    -- Process que maneja el clk, con pulso cada 5 ns.
    process begin
        clk_s <= '0';
        wait for 10 ns;
        clk_s <= '1';
        wait for 10 ns;
    end process;

    -- Process que maneja el FF32
    process begin
        reset_s <= '1';
        d_s <= (OTHERS => '1'); 
        wait for 10 ns;
        reset_s <= '0';
        wait for 10 ns;
        reset_s <= '1';
        wait for 10 ns;
        reset_s <= '0';

        assert false report "##### FIN DEL TEST #####" severity note;
        wait for 100 ns;
    end process;
end test;
