library ieee;
use ieee.std_logic_1164.all;

entity flopr1 is
    port (
            q : out std_logic;
            d : in std_logic;
            clk : in std_logic;
            rst : in std_logic
        );
end entity;

architecture behavior of flopr1 is
begin
    process (clk, rst) begin
        if (rst = '1') then
            q <= '0';
        elsif (clk'event and clk='1') then
            q <= d;
        end if;
    end process;
end architecture;
