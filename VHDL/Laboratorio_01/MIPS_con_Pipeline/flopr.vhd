library ieee;
use ieee.std_logic_1164.all;

entity flopr is
    generic (n : integer := 32);
    port (
            q : out std_logic_vector(n-1 downto 0);
            d : in std_logic_vector(n-1 downto 0);
            clk : in std_logic;
            rst : in std_logic
        );
end entity;

architecture behavior of flopr is
begin
    process (clk, rst) begin
        if (rst = '1') then
            q <= (OTHERS => '0');
        elsif (clk'event and clk='1') then
            q <= d;
        end if;
    end process;
end architecture;
