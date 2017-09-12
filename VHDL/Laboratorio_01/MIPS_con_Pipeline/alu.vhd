library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port (
            a : in std_logic_vector(31 downto 0);
            b : in std_logic_vector(31 downto 0);
            alucontrol : in std_logic_vector(2 downto 0);
            result : out std_logic_vector(31 downto 0);
            zero : out std_logic
        );
end alu;

architecture circuits of alu is 

signal temp : std_logic_vector(31 downto 0);

begin
    process(alucontrol, a, b, temp) is begin
        case alucontrol is
            when "000" =>
                        temp <= a and b;
            when "001" =>
                        temp <= a or b;
            when "010" =>
                        temp <= std_logic_vector(unsigned(a) + unsigned(b));
            when "100" =>
                        temp <= a and not(b);
            when "101" =>
                        temp <= a or not(b);
            when "110" =>
                        temp <= std_logic_vector(unsigned(a) - unsigned(b));
            when "111" =>
                        if (unsigned(a) < unsigned(b)) then
                           temp <= "11111111111111111111111111111111";
                        else
                           temp <= "00000000000000000000000000000000";
                        end if;
            when others => temp <= "00000000000000000000000000000000";
        end case;

        result <= temp;

        if (temp = "00000000000000000000000000000000") then
            zero <= '1';
        else 
            zero <= '0';
        end if;
    end process;
end circuits;


