library ieee;
use ieee.std_logic_1164.all;

entity rom_tb IS
end rom_tb;

architecture behavior of rom_tb is
    --  Declaración del componente que será instanciado.
    component rom_64 is
    port (
        a    : in std_logic_vector(5 downto 0);
        data : out std_logic_vector(31 downto 0)
    );
    end component;

    signal a_s : std_logic_vector(5 downto 0);
    signal data_s: std_logic_vector(31 downto 0);

    begin
    dut: rom_64 port map(a => a_s, data => data_s);
    process
    begin
            a_s <= "000000";
            wait for 5 ns;
            a_s <= "000001";
            wait for 5 ns;
            a_s <= "000010";
            wait for 5 ns;
            a_s <= "000011";
            wait for 5 ns;
            a_s <= "000100";
            wait for 5 ns;
            wait;
        end process;
end behavior;
