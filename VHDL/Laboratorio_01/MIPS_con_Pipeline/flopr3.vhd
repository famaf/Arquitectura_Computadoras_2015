library ieee;
use ieee.std_logic_1164.all;

entity flopr3 is
    port (
            q : out std_logic_vector(2 downto 0);
            d : in std_logic_vector(2 downto 0);
            clk : in std_logic;
            rst : in std_logic
        );
end entity;

architecture behavior of flopr3 is
begin
    process (clk, rst) begin
        if (rst = '1') then
            q <= (OTHERS => '0');
        elsif (clk'event and clk='1') then
            q <= d;
        end if;
    end process;
end architecture;
