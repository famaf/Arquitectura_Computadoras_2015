library ieee;
use ieee.std_logic_1164.all;


entity signext is
    port (
            a : in std_logic_vector (15 DOWNTO 0);
            y : out std_logic_vector (31 DOWNTO 0)
        );
end signext;


architecture morebit of signext is

    signal tmp : std_logic_vector (31 DOWNTO 0);

begin
-- para imprimir : report std_logic'image(tmp(0))
    process (a) begin
        if (a(15) = '0') then
            y <= "0000000000000000" & a;
        elsif (a(15) = '1') then
            y <= "1111111111111111" & a;
        end if;
    end process;
end morebit;
