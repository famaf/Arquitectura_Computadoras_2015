-------------------------------------------------------------------------------
--
-- Title       : imem
-- Design      : Mips
-- Author      : Eduardo Sanchez
-- Company     : Famaf
--
-------------------------------------------------------------------------------
--
-- File        : imem.vhd
--
-------------------------------------------------------------------------------
--
-- Description : Archivo con el diseño de la memoria ROM del procesador MIPS.
-- Para mantener un diseño corto, la memoria solo puede contener hasta 64 
-- instrucciones (palabras) de 32 bits(aunque podria direccionar mas memoria)
-- Inicialmente, al salir de reset, carga en la memoria el archivo MIPS_SOFT_FILE
-- con el programa a ejecutar.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity imem is -- instruction memory
    port (
            a:  in  std_logic_vector (5 DOWNTO 0);
            rd: out std_logic_vector (31 DOWNTO 0)
        );
end imem;


architecture behave of imem is

    constant MAX_BOUND: Integer := 64;

begin
    process is
        constant MIPS_SOFT_FILE: string := "./mips.dat";-- AGREGO
        file mem_file: TEXT;
        variable L: line;
        variable ch: character;
        variable index, result: integer;
        type ramtype is array (MAX_BOUND-1 DOWNTO 0) of std_logic_vector (31 DOWNTO 0);
        variable mem: ramtype;
    begin
    -- initialize memory from file
        for i in 0 to MAX_BOUND-1 loop -- set all contents low
            mem(conv_integer(i)) := CONV_STD_LOGIC_VECTOR(0, 32);
        end loop;

        index := 0; 
        FILE_OPEN(mem_file, MIPS_SOFT_FILE, READ_MODE);

        while not endfile(mem_file) loop
            readline(mem_file, L);
            result := 0;

            for i in 1 to 8 loop
                read(L, ch);
                if '0' <= ch and ch <= '9' then 
                    result := result*16 + character'pos(ch)-character'pos('0');
                elsif 'a' <= ch and ch <= 'f' then
                    result := result*16 + character'pos(ch)-character'pos('a')+10;
                else
                    report "Format error on line " & integer'image(index) severity error;
                end if;
            end loop;

            mem(index) := CONV_STD_LOGIC_VECTOR(result, 32);
            index := index + 1;
        end loop;

    -- read memory
        loop
            rd <= mem(CONV_INTEGER(a));
            wait on a;
        end loop;
    end process;

end behave;
