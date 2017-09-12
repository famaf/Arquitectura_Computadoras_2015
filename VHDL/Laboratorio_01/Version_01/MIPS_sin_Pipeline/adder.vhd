library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity adder is
    port (
            a : in std_logic_vector (31 DOWNTO 0);
            b : in std_logic_vector (31 DOWNTO 0);
            y : out std_logic_vector (31 DOWNTO 0)
         );
end adder;


architecture sumador of adder is
begin
    y <= std_logic_vector(UNSIGNED(a) + UNSIGNED(b));
end sumador;
