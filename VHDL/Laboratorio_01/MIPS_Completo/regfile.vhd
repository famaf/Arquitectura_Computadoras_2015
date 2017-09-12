library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfile is
    port (
            ra1 : in std_logic_vector(4 downto 0);
            ra2 : in std_logic_vector(4 downto 0);
            wa3 : in std_logic_vector(4 downto 0);
            wd3 : in std_logic_vector(31 downto 0);
            we3 : in std_logic;
            clk : in std_logic;
            rd1 : out std_logic_vector(31 downto 0);
            rd2 : out std_logic_vector(31 downto 0)
        );
end entity;

architecture behavior of regfile is

    type mem is array(63 downto 0) of std_logic_vector(31 downto 0);
    signal memory : mem := ((OTHERS => (OTHERS => '0')));

begin
    process(clk, wa3, wd3) begin
        if (clk'event and clk = '1'and we3 = '1' and wa3 /= "000000") then
            memory(to_integer(unsigned(wa3))) <= wd3;
        end if;
    end process;

    rd1 <= memory(to_integer(unsigned(ra1)));
    rd2 <= memory(to_integer(unsigned(ra2)));
end architecture;
