-------------------------------------------------------------------------------
--
-- Title       : dmem
-- Design      : Mips
-- Author      : Eduardo Sanchez
-- Company     : Famaf
--
-------------------------------------------------------------------------------
--
-- File        : dmem.vhdl
--
-------------------------------------------------------------------------------
--
-- Description : Archivo con el diseño de la memoria RAM del procesador MIPS.
-- Para mantener un diseño corto, la memoria solo contiene 64 palabras de
-- 32 bits c/u (aunque podria direccionar mas memoria)
-- dump: si esta señal esta activa (1), se copia el contenido de la memoria
-- en el archivo de salida DUMP (para su posterior revision).
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_signed.all; -- Para que CONV_INTEGER no de error

entity dmem is -- data memory
    port(
    a, wd: in std_logic_vector(31 downto 0);
    clk, we, dump: in std_logic;
    rd: out std_logic_vector(31 downto 0)
    );
end dmem;

architecture behav of dmem is
    constant MEMORY_DUMP_FILE: string := "output.dump";
    constant MAX_BOUND: integer := 64;

    type ramtype is array(MAX_BOUND-1 downto 0) of std_logic_vector(31 downto 0);
    signal mem: ramtype;

    procedure memDump is
        file dumpfile: text open write_mode is MEMORY_DUMP_FILE;
        variable dumpline: line;
        variable i: integer := 0;
    begin
        write(dumpline, string'("Memoria RAM de Mips:"));
        writeline(dumpfile,dumpline);
        write(dumpline, string'("Address Data"));
        writeline(dumpfile,dumpline);

        while i <= MAX_BOUND-1 loop
            write(dumpline, i);
            write(dumpline, string'(" "));
            write(dumpline, conv_integer(mem(i)));
            writeline(dumpfile,dumpline);
            i:=i+1;
        end loop;
    end memDump;

begin
    process (clk, a, mem)
        variable addr: integer;
    begin
        addr := conv_integer(a(7 downto 2));
        if clk'event and clk = '1' and we = '1' then
            mem(addr) <= wd;
        end if;
        rd <= mem(addr); -- word aligned
    end process;

    process (dump)
    begin
        if dump = '1' then
            memDump;
        end if;
    end process;
end behav;
