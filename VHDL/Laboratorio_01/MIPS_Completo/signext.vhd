library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signext is
    port (
            a : in std_logic_vector(15 downto 0);
            y : out std_logic_vector(31 downto 0)
        );
end entity;

architecture behavior of signext is
begin
    process (a) begin
        if (a(15) = '1') then
            y <= "1111111111111111" & a;
        elsif (a(15) = '0') then
            y <= "0000000000000000" & a;
        end if;
    end process;
end architecture;
