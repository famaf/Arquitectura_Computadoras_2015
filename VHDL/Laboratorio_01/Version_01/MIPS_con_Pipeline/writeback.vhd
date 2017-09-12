library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity writeback is
    port (
            -- ENTRADAS
            MemToReg : in std_logic;
            AluOutW : in std_logic_vector (31 DOWNTO 0);
            ReadDataW : in std_logic_vector (31 DOWNTO 0);
            -- SALIDAS
            ResultW : out std_logic_vector (31 DOWNTO 0)
        );
end writeback;


architecture behavior of writeback is

    component mux2 is
        generic ( N : natural := 32 );
        port(
                d0 : in std_logic_vector (N-1 DOWNTO 0);
                d1 : in std_logic_vector (N-1 DOWNTO 0);
                set : in std_logic;
                y : out std_logic_vector (N-1 DOWNTO 0)
            );
    end component;

begin

    mux2_comp : mux2 port map (
                                d0 => AluOutW,
                                d1 => ReadDataW,
                                set => MemToReg,
                                y => ResultW
                            );

end architecture;
