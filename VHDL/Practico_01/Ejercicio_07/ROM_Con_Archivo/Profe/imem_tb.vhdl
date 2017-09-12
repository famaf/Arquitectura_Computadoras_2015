library ieee;
use ieee.std_logic_1164.all;

entity imem_tb is
end imem_tb;
 
architecture TB of imem_tb is
    component imem is
    port (
        addr : in std_logic_vector(5 downto 0);
        data : out std_logic_vector(31 downto 0)
        );
    end component;

    signal addr_s : std_logic_vector(5 downto 0);
    signal data_s : std_logic_vector(31 downto 0);

begin
    im : imem port map (addr => addr_s, data => data_s);
    process
        type pattern_type is record
            addr : std_logic_vector(5 downto 0);
            data : std_logic_vector(31 downto 0); 
        end record;

        type pattern_array is array (natural range <>) of pattern_type;
        constant patterns : pattern_array :=(("000000", "00100000000010000000000000000000"), ("000011", "00100000000010110000000000000011"));
    begin
        for i in patterns'range loop
            addr_s <= patterns(i).addr;
            wait for 1 ns;
            assert data_s = patterns(i).data
                report "data erroneo" severity error;
        end loop;
        report "fin del test" severity note;
        wait;
    end process;
end TB;
