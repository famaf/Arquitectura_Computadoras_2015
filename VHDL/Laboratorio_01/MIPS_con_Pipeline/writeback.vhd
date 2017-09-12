library ieee;
use ieee.std_logic_1164.all;
use work.components.all;

entity writeback is
    port (
            AluOutW : in std_logic_vector(31 downto 0);
            ReadDataW : in std_logic_vector(31 downto 0);
            MemToReg : in std_logic;
            ResultW : out std_logic_vector(31 downto 0)
        );
end entity;

architecture behavior of writeback is
begin
    dut1 : mux2 port map (
                            d0 => AluOutW,
                            d1 => ReadDataW,
                            y => ResultW,
                            s => MemToReg
                        );
end architecture;
