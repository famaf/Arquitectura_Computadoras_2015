library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
--use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;

entity imem is
    port (
            a : in std_logic_vector (5 DOWNTO 0);
            y : out std_logic_vector (31 DOWNTO 0)
         );
end imem;

architecture memory of imem is

    type memoria_rom is array (63 DOWNTO 0) of std_logic_vector(31 DOWNTO 0);
    signal myrom : memoria_rom;

begin
    process (a)
        file fd : text;
        constant datapath : string := "./ROM.txt";
        variable L : line;
        variable i : integer := 0;
        variable b : std_logic_vector(31 DOWNTO 0);
    begin
        file_open(fd, datapath, read_mode);
        while ((i <= 63) and (not endfile(fd))) loop
            readline(fd, L);
            next when L(1) = '#';
            read(L, b);
            myrom(i) <= b;
            i := i + 1;
        end loop;
        file_close(fd);
    end process;
    y <= myrom(to_integer(unsigned(a)));
 end memory;
