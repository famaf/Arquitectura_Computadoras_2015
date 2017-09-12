library ieee;
use ieee.std_logic_1164.all;

entity mux2_5b is
    port (
            d0 : in std_logic_vector(4 downto 0);
            d1 : in std_logic_vector(4 downto 0);
            y : out std_logic_vector(4 downto 0);
            s : in std_logic
        );
end entity;

architecture behavior of mux2_5b is
begin
    process (s, d0, d1) begin
        if ((s'event and s='0') or (d0'event and s='0')) then
            y <= d0;
        elsif ((s'event and s='1') or (d1'event and s='1')) then
            y <= d1;
        end if;
    end process;
end architecture;
