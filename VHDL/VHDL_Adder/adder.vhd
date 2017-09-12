library ieee;
use ieee.std_logic_1164.all;

entity adder is
    port (a, b : in std_logic;
          ci : in std_logic; 
          s : out std_logic; 
          co : out std_logic);
end adder;
 
architecture rtl of adder is
    begin
    s <= a xor b xor ci;
    co <= (a and b) or (a and ci) or (b and ci);
end rtl;
