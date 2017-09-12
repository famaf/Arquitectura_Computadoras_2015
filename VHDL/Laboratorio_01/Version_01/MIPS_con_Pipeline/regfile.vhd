library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity regfile is
    port (
            clk : in std_logic;
            we3 : in std_logic;
            ra1 : in std_logic_vector (4 DOWNTO 0);
            ra2 : in std_logic_vector (4 DOWNTO 0);
            wa3 : in std_logic_vector (4 DOWNTO 0);
            wd3 : in std_logic_vector (31 DOWNTO 0);
            rd1 : out std_logic_vector (31 DOWNTO 0);
            rd2 : out std_logic_vector (31 DOWNTO 0)
        );
end regfile;

architecture double_mem of regfile is

    type memoria_ram is array (31 DOWNTO 0) of std_logic_vector (31 DOWNTO 0); -- prguntar tamaño de memoria
    signal myreg : memoria_ram;

begin

    process (clk) begin
        if (clk'event) then
            if (we3 = '1') then -- ESCIBRIMOS EL DATO wd3 en wa3
                myreg(to_integer(unsigned(wa3))) <= wd3;
            else -- LEEMOS LOS DATOS DE LOS REGISTROS ra1, ra2

                if (ra1 = "00000") then
                    rd1 <= "00000000000000000000000000000000";
                else
                    rd1 <= myreg(to_integer(unsigned(ra1)));
                end if;

                if (ra2 = "00000") then
                    rd2 <= "00000000000000000000000000000000";
                else
                    rd2 <= myreg(to_integer(unsigned(ra2)));
                end if;

            end if;
        end if;
    end process;
end double_mem;