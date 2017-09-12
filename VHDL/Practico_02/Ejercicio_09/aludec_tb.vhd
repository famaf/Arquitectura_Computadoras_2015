library ieee;
use ieee.std_logic_1164.all;


entity aludec_tb is
end aludec_tb;


architecture test of aludec_tb is

    component aludec is
        port (
                funct : in std_logic_vector (5 DOWNTO 0);
                aluop : in std_logic_vector (1 DOWNTO 0);
                alucontrol : out std_logic_vector (2 DOWNTO 0)
            );
    end component;

    signal funct_s : std_logic_vector (5 DOWNTO 0);
    signal aluop_s : std_logic_vector (1 DOWNTO 0);
    signal alucontrol_s : std_logic_vector (2 DOWNTO 0);

begin

    dut : aludec port map (
                            funct=>funct_s,
                            aluop=>aluop_s,
                            alucontrol=>alucontrol_s
                          );

    process begin
        aluop_s <= "00";

        wait for 5 ns;
        assert alucontrol_s = "010" report "Salida Erronea" severity error;
        wait for 5 ns;

        aluop_s <= "01";

        wait for 5 ns;
        assert alucontrol_s = "110" report "Salida Erronea" severity error;
        wait for 5 ns;

        aluop_s <= "11";
        funct_s <= "100000";

        wait for 5 ns;
        assert alucontrol_s = "010" report "Salida Erronea" severity error;
        wait for 5 ns;

        aluop_s <= "10";
        funct_s <= "100010";

        wait for 5 ns;
        assert alucontrol_s = "110" report "Salida Erronea" severity error;
        wait for 5 ns;

        aluop_s <= "11";
        funct_s <= "100100";

        wait for 5 ns;
        assert alucontrol_s = "000" report "Salida Erronea" severity error;
        wait for 5 ns;


        aluop_s <= "10";
        funct_s <= "100101";

        wait for 5 ns;
        assert alucontrol_s = "001" report "Salida Erronea" severity error;
        wait for 5 ns;


        aluop_s <= "11";
        funct_s <= "101010";

        wait for 5 ns;
        assert alucontrol_s = "111" report "Salida Erronea" severity error;

        assert false report "##### FIN DEL TEST #####" severity note;
        wait for 5 ns;
    end process;
end test;
