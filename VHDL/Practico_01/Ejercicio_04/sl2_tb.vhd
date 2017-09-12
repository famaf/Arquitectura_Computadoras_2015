library ieee;
use ieee.std_logic_1164.all;


entity sl2_tb is
end sl2_tb;


architecture test of sl2_tb is

    component sl2 is
        port (
                a : in std_logic_vector (31 DOWNTO 0);
                y : out std_logic_vector (31 DOWNTO 0)
            );
    end component;

    signal a_s : std_logic_vector (31 DOWNTO 0);
    signal y_s : std_logic_vector (31 DOWNTO 0);

begin

    dut : sl2 port map (a=>a_s, y=>y_s);

    process begin
        a_s <= "11111111111111111111111111111111";

        wait for 10 ns;
        assert  y_s = "11111111111111111111111111111100" report "Salida Erronea" severity error;
        wait for 10 ns;

        a_s <= "00000000000000000000000000000001";

        wait for 10 ns;
        assert  y_s = "00000000000000000000000000000100" report "Salida Erronea" severity error;

        assert false report "##### FIN DEL TEST #####" severity note;
        wait for 10 ns; 
    end process;
end test;
