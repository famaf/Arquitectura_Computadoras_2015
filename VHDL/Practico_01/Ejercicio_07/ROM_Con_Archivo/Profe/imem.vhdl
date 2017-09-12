library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;

entity imem is
    port (
        addr : in std_logic_vector(5 downto 0);
        data : out std_logic_vector(31 downto 0)
    );
end entity imem;

architecture behavior of imem is
    type imem_type is array (63 downto 0) of std_logic_vector(31 downto 0);
    signal imem : imem_type;
begin
    process (addr)
        FILE f : TEXT;
        constant filename : string :="./rom.txt";
        variable l : LINE;
        variable i : integer:=0;
        variable b : std_logic_vector(31 downto 0);
    begin
        file_open(f,filename,read_mode);
        while ((i<=63) and (not endfile(f))) loop
            readline(f,l);
            next when l(1)='#';
            read(l,b);
            imem(i)<=b;
            i:=i+1;
        end loop;
        file_close(f);
    end process;

    data <= imem(to_integer(unsigned(addr)));
end architecture;
