library ieee;
use ieee.std_logic_1164.all;


entity mux2 is
    generic ( N : natural := 16 ); -- Generalizacion para N bits
    port (
            d0 : in std_logic_vector (N-1 DOWNTO 0);
            d1 : in std_logic_vector (N-1 DOWNTO 0);
            set : in std_logic;
            y : out std_logic_vector (N-1 DOWNTO 0)
        );
end mux2;


architecture multiplexor of mux2 is
begin
    process (d0, d1, set) is begin
        if (set = '0') then
            y <= d0;
        elsif (set = '1') then
            y <= d1;
        end if;
    end process;
end multiplexor;
