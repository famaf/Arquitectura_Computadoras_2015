library ieee;
use ieee.std_logic_1164.all;


entity mux2_tb is
end mux2_tb;


architecture test of mux2_tb is

    component mux2 is
        port (
                d0 : in std_logic_vector (31 DOWNTO 0);
                d1 : in std_logic_vector (31 DOWNTO 0);
                set : in std_logic;
                y : out std_logic_vector (31 DOWNTO 0)
            );
    end component;

    signal d0_s : std_logic_vector (31 DOWNTO 0); 
    signal d1_s : std_logic_vector (31 DOWNTO 0);
    signal y_s : std_logic_vector (31 DOWNTO 0);
    signal set_s : std_logic;

begin

    dut : mux2 port map (
                          d0=>d0_s,
                          d1=>d1_s,
                          set=>set_s,
                          y=>y_s
                        );

    process begin
        d0_s <= "10101010101010101010101010101010"; -- AAAAAAAA
        d1_s <= "01010101010101010101010101010101"; -- 55555555

        set_s <= '0';

        wait for 10 ns;
        assert y_s = d0_s report "Salida Erronea" severity error;
        wait for 10 ns;


        set_s <= '1';

        wait for 10 ns;
        assert y_s = d1_s report "Salida Erronea" severity error;
        wait for 10 ns;

        set_s <= '0';

        wait for 10 ns;
        assert y_s = d0_s report "Salida Erronea" severity error;
        wait for 10 ns;

        set_s <= '1';

        wait for 10 ns;
        assert y_s = d1_s report "Salida Erronea" severity error;

        assert false report "##### FIN DEL TEST #####" severity note;
        wait for 10 ns;
    end process;
end test;
