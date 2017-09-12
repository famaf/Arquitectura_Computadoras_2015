-------------------------------------------------------------------------------
--
-- Title       : imem
-- Design      : Mips
-- Author      : Eduardo Sanchez
-- Company     : Famaf
--
-------------------------------------------------------------------------------
--
-- File        : imem.vhdl
--
-------------------------------------------------------------------------------
--
-- Description : Archivo con el diseño de la memoria ROM del procesador MIPS.
-- Para mantener un diseño corto, la memoria solo puede contener hasta 64
-- instrucciones (palabras) de 32 bits (aunque podria direccionar mas memoria)
-- Inicialmente, al salir de reset, carga en la memoria el archivo MIPS_SOFT_FILE
-- con el programa a ejecutar.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity imem is -- instruction memory
    port(
    a: in  std_logic_vector(31 downto 0);
    rd: out std_logic_vector(31 downto 0)
    );
end imem;

architecture behav of imem is
    constant MAX_BOUND: integer := 64;
    constant MIPS_SOFT_FILE: string := "mips.dat";
begin
    process
        file mem_file: text;
        variable ln: line;
        variable ch: character;
        variable index, result: integer;
        type ramtype is array(MAX_BOUND-1 downto 0) of
            std_logic_vector(31 downto 0);
        variable mem: ramtype;
        variable addr: integer;
    begin
        -- Initialize memory from file
        for i in 0 to MAX_BOUND-1 loop -- set all contents low
            mem(i) := conv_std_logic_vector(0, 32);
        end loop;

        index := 0;
        file_open(mem_file, MIPS_SOFT_FILE, READ_MODE);
        while not endfile(mem_file) loop
            readline(mem_file, ln);

            result := 0;
            for i in 1 to 8 loop
                read(ln, ch);
                if '0' <= ch and ch <= '9' then
                    result := result*16 + character'pos(ch)-character'pos('0');
                elsif 'a' <= ch and ch <= 'f' then
                    result := result*16 + character'pos(ch)-character'pos('a')+10;
                else report "Format error on line " & integer'image(index)
                    severity error;
                end if;
            end loop;

            mem(index) := conv_std_logic_vector(result, 32);
            index := index + 1;
        end loop;

        -- Read memory
        loop
            addr := conv_integer(a(7 downto 2));
            rd <= mem(addr);
            wait on a;
        end loop;
  end process;
end behav;
