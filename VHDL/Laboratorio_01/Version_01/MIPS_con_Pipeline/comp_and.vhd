library ieee;
use ieee.std_logic_1164.all;


entity comp_and is
    port (
            input_1 : in std_logic;
            input_2 : in std_logic;
            output_and : out std_logic
        );
end comp_and;


architecture COMPUERTA of comp_and is
begin
    output_and <= input_1 and input_2;

end COMPUERTA;