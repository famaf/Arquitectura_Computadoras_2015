library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;
 
entity rom_64 is
    port (
        a : in  std_logic_vector(5 downto 0);
        data : out std_logic_vector(31 downto 0)
    );
end rom_64;
 
architecture behavioral of rom_64 is

    type memoria_rom is array (0 to 63) of std_logic_vector (31 downto 0);
    signal rom: memoria_rom;
    file f    : text open read_mode is "rom.data";

begin
    process(rom)
        variable l      : line;
        variable i      : integer:=0;
        variable result : bit_vector(31 downto 0);
    begin
        while (not endfile(f)) loop
            readline(f, l);
            read(l, result);
            rom(i) <= to_stdlogicvector(result);
            i := i + 1;
        end loop;
    end process;
    data <= rom(to_integer(unsigned(a)));
end behavioral;
