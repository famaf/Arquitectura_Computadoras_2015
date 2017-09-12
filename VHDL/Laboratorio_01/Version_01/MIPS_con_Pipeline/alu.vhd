library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity alu is
    port (
            a : in std_logic_vector (31 DOWNTO 0);
            b : in std_logic_vector (31 DOWNTO 0);
            alucontrol : in std_logic_vector (2 DOWNTO 0);
            zero : out std_logic;
            result : out std_logic_vector (31 DOWNTO 0)
        );
end alu;


architecture unidad_aritmetica_logica of alu is

    signal result_tmp : std_logic_vector (31 DOWNTO 0);

begin

    process (a, b, alucontrol) begin
        case alucontrol is
            when "000" =>
                        result_tmp <= a and b;
            when "001" =>
                        result_tmp <= a or b;
            when "010" =>
                        result_tmp <= (std_logic_vector(UNSIGNED(a) + UNSIGNED(b)));
            when "011" => null;
            when "100" =>
                        result_tmp <= a and not(b);
            when "101" =>
                        result_tmp <= a or not(b);
            when "110" =>
                        result_tmp <= (std_logic_vector(UNSIGNED(a) - UNSIGNED(b)));
            when "111" =>
                        if (UNSIGNED(a) < UNSIGNED(b)) then
                            result_tmp <= "11111111111111111111111111111111";
                        else
                            result_tmp <= "00000000000000000000000000000000";
                        end if;
            when OTHERS => null;
        end case;
-- NOSE PORQUE DA ERROR  "port "result" cannot be read" Falta eso nomas => SOLUCIONADO con result_tmp
        if (result_tmp = "00000000000000000000000000000000") then
            zero <= '1';
        else
            zero <= '0';
        end if;

        result <= result_tmp;
    end process;
end unidad_aritmetica_logica;

