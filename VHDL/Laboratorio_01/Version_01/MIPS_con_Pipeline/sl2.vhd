library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity sl2 is
    port (
            a : in std_logic_vector (31 DOWNTO 0);
            y : out std_logic_vector (31 DOWNTO 0)
        );
end sl2;


architecture shift_register of sl2 is
begin
    process (a) begin
        y <= std_logic_vector(unsigned(a) sll 2);
    end process;
end shift_register;

