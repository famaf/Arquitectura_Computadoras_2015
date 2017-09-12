library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 

entity alu_tb is
end alu_tb;


architecture test of alu_tb is

    component alu is
        port (
                a : in std_logic_vector (31 DOWNTO 0);
                b : in std_logic_vector (31 DOWNTO 0);
                alucontrol : in std_logic_vector (2 DOWNTO 0);
                zero : out std_logic;
                result : out std_logic_vector (31 DOWNTO 0)
            );
    end component;

    signal a_s, b_s, result_s : std_logic_vector (31 DOWNTO 0);
    signal alucontrol_s : std_logic_vector (2 DOWNTO 0);
    signal zero_s : std_logic;

begin

    dut : alu port map (
                         a=>a_s,
                         b=>b_s,
                         alucontrol=>alucontrol_s,
                         zero=>zero_s,
                         result=>result_s
                       );

    process begin
        a_s <= "00000000000000000000000000000010"; -- 2
        b_s <= "00000000000000000000000000000001"; -- 1
        --   a_s    = 00000000000000000000000000000010
        -- not(b_s) = 11111111111111111111111111111110 = FFFFFFFE
        alucontrol_s <= "000"; -- result = 00000000000000000000000000000000 = 0

        wait for 5 ns;
        assert result_s = "00000000000000000000000000000000" report "Salida 'Result' (AC = 000) Erronea" severity error;

        assert zero_s = '1' report "Salida 'Zero' Erronea" severity error;
        wait for 10 ns;

        alucontrol_s <= "001"; -- result = 00000000000000000000000000000011 = 3

        wait for 5 ns;
        assert result_s = "00000000000000000000000000000011" report "Salida 'Result' (AC = 001) Erronea" severity error;
        wait for 10 ns;

        alucontrol_s <= "010"; -- result = 3

        wait for 5 ns;
        assert result_s = "00000000000000000000000000000011" report "Salida 'Result' (AC = 010) Erronea" severity error;
        wait for 10 ns;

        alucontrol_s <= "011"; -- result = NULL

        wait for 5 ns;
        assert result_s = "00000000000000000000000000000011" report "Salida 'Result' (AC = 011) Erronea" severity error;
        wait for 10 ns;

        alucontrol_s <= "100"; -- result = 00000000000000000000000000000010 = 2

        wait for 5 ns;
        assert result_s = "00000000000000000000000000000010" report "Salida 'Result' (AC = 100) Erronea" severity error;
        wait for 10 ns;

        alucontrol_s <= "101"; -- result = 11111111111111111111111111111110 = FFFFFFFE

        wait for 5 ns;
        assert result_s = "11111111111111111111111111111110" report "Salida 'Result' (AC = 101) Erronea" severity error;
        wait for 10 ns;

        alucontrol_s <= "110"; -- result = 00000000000000000000000000000001 = 1

        wait for 5 ns;
        assert result_s = "00000000000000000000000000000001" report "Salida 'Result' (AC = 110) Erronea" severity error;
        wait for 10 ns;

        alucontrol_s <= "111"; -- result = STL = 0 xq a>b

        wait for 5 ns;
        assert result_s = "00000000000000000000000000000000" report "Salida 'Result' (AC = 111) Erronea" severity error;

        assert false report "##### FIN DEL TEST #####" severity note;
        wait for 10 ns;
    end process;
end test;
