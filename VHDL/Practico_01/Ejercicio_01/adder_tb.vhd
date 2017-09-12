library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_tb is
end adder_tb;

architecture test of adder_tb is

    component adder is
        port (
                a : in std_logic_vector (31 DOWNTO 0);
                b : in std_logic_vector (31 DOWNTO 0);
                y : out std_logic_vector (31 DOWNTO 0)
             );
    end component;

    signal a_s : std_logic_vector (31 DOWNTO 0);
    signal b_s : std_logic_vector (31 DOWNTO 0);
    signal y_s : std_logic_vector (31 DOWNTO 0);

begin -- Inicio Arq

    dut : adder port map ( a=>a_s,
                           b => b_s,
                           y => y_s
                        );

    process begin
        a_s <= "00000000000000000000000000001010";
        b_s <= "00000000000000000000000000000001";

        wait for 5 ns;
        assert y_s = "00000000000000000000000000001011" report "Salida Erronea" severity error;

        assert false report "##### FIN DEL TEST #####" severity note;
        wait for 5 ns;
    end process;
end test; -- Fin Arq
