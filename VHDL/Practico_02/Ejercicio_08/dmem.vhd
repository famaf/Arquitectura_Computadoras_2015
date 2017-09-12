library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Si Enable = 1 => guardo en la memoria el dato de entrada (wd)
-- Si Enable = 0 => estoy leyendo, devuelvo el valor almacenado en la ram en la dirreccion 'a'

entity dmem is
    port (
            a : in std_logic_vector (31 DOWNTO 0); -- Dirr a escribir
            wd : in std_logic_vector (31 DOWNTO 0); -- Dato a escribir
            clk : in std_logic; -- Clock
            we : in std_logic; -- Enable
            rd : out std_logic_vector (31 DOWNTO 0) -- Salida
        );
end dmem;


architecture ram_memory of dmem is

    type memoria_ram is array (63 DOWNTO 0) of std_logic_vector (31 DOWNTO 0);
    signal myram : memoria_ram;

begin

    process (clk, a) begin
        if (clk'event and clk = '1') then
            if (we = '1') then
                myram(to_integer(unsigned(a(7 DOWNTO 2)))) <= wd;
            else
                rd <= myram(to_integer(unsigned(a(7 DOWNTO 2))));
            end if;
        end if;
    end process;
end ram_memory;
