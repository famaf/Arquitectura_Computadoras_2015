library ieee;
use ieee.std_logic_1164.all;


entity signext_tb is
end signext_tb;


architecture test of signext_tb is

    component signext is
    port (
            a : in std_logic_vector (15 DOWNTO 0);
            y : out std_logic_vector (31 DOWNTO 0)
        );
    end component;

    signal a_s : std_logic_vector (15 DOWNTO 0);
    signal y_s : std_logic_vector (31 DOWNTO 0);

begin

    dut : signext port map (a=>a_s, y=>y_s);

    process begin
        a_s <= "1000000000000000";

        wait for 10 ns;
        assert y_s = "11111111111111111000000000000000" report "Salida Erronea" severity error;
        wait for 10 ns;

        a_s <= "0000000000000001";

        wait for 10 ns;
        assert y_s = "00000000000000000000000000000001" report "Salida Erronea" severity error;

        assert false report "##### FIN DEL TEST #####" severity note;
        wait for 10 ns;
    end process;
end test;
