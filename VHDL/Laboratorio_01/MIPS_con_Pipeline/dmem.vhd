-------------------------------------------------------------------------------
--
-- Title       : dmem
-- Design      : Mips
-- Author      : Eduardo Sanchez
-- Company     : Famaf
--
-------------------------------------------------------------------------------
--
-- File        : dmem.vhd
--
-------------------------------------------------------------------------------
--
-- Description : Archivo con el diseño de la memoria RAM del procesador MIPS.
-- Para mantener un diseño corto, la memoria solo contiene 64 palabras de 
-- 32 bits c/u (aunque podria direccionar mas memoria)
-- dump: si esta señal esta activa (1), se copia le contenido de la memoria
-- en el archivo de salida DUMP (para su posterior revision).
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_signed.all;


entity dmem is -- data memory
    port (
            clk : in std_logic;
            we : in std_logic;
            a : in std_logic_vector (31 DOWNTO 0);
            wd : in std_logic_vector (31 DOWNTO 0);
            dump : in std_logic;
            rd : out std_logic_vector (31 DOWNTO 0)
        );
end dmem;


architecture behave of dmem is

    constant MAX_BOUND: Integer := 64;
    type ramtype is array (MAX_BOUND-1 DOWNTO 0) of std_logic_vector (31 DOWNTO 0);
    signal mem: ramtype;

    procedure memDump is
        constant MEMORY_DUMP_FILE : string := "./DUMP_FILE.txt";
        file dumpfile : text open write_mode is MEMORY_DUMP_FILE;
        variable dumpline : line;
        variable i : natural := 0;
    begin
        write(dumpline, string'("Memoria RAM de Mips:"));
        writeline(dumpfile,dumpline);
        write(dumpline, string'("Address Data"));
        writeline(dumpfile,dumpline);

        while (i <= MAX_BOUND-1) loop
            write(dumpline, i);
            write(dumpline, string'(" "));
            write(dumpline, conv_integer(mem(i)));
            writeline(dumpfile,dumpline);
            i := i + 1;
        end loop;

    end procedure memDump;

begin

    process (clk, a, mem) begin
        if clk'event and clk = '1' and we = '1' then
            mem(conv_integer("0" & a(7 DOWNTO 2))) <= wd;
        end if;

        rd <= mem(conv_integer("0" & a(7 DOWNTO 2))); -- word aligned
    end process;

    process (dump) begin
        if dump = '1' then
            memDump;
        end if;
    end process;

end behave;
