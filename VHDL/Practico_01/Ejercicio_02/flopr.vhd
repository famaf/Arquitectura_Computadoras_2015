library ieee;
use ieee.std_logic_1164.all;


entity flopr is
    generic ( N : natural := 16 ); -- Generalizacion para N bits

    port (
            clk : in std_logic;
            reset : in std_logic;
            d : in std_logic_vector (N-1 DOWNTO 0);
            q : out std_logic_vector (N-1 DOWNTO 0)
        );
end flopr;


architecture asincrono of flopr is
begin
    process (clk, reset) is begin
        if (reset = '1') then
            q <= (OTHERS => '0');
        elsif (clk = '1') and clk'event then
            q <= d;
        end if;
    end process;
end asincrono;

