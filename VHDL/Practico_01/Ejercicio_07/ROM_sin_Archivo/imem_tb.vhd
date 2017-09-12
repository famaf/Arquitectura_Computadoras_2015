library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity imem_tb is
end imem_tb;


architecture test of imem_tb is

    component imem is
        port (
                a : in std_logic_vector (5 DOWNTO 0);
                y : out std_logic_vector (31 DOWNTO 0)
             );
    end component;

    signal a_s : std_logic_vector (5 DOWNTO 0);
    signal y_s : std_logic_vector (31 DOWNTO 0);

begin

    dut : imem port map (
                          a=>a_s,
                          y=>y_s
                        );

    process begin
        a_s <= "000000";
        
        wait for 5 ns;
        assert y_s = "11110000000000000000000000000000" report "Salida Erronea" severity error;
        wait for 5 ns;

        a_s <= "000001";

        wait for 5 ns;
        assert y_s = "11110000000000000000000000000001" report "Salida Erronea" severity error;
        wait for 5 ns;

        a_s <= "111111";

        wait for 5 ns;
        assert y_s = "11110000000000000000000000111111" report "Salida Erronea" severity error;

        assert false report "##### FIN DEL TEST #####" severity note;
        wait for 5 ns;
    end process;
end test;
