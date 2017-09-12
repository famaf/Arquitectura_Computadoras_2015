library ieee;
use ieee.std_logic_1164.all;
use work.components.all;

entity decode is
    port (
            A3 : in std_logic_vector(4 downto 0);
            InstrD : in std_logic_vector(31 downto 0);
            WD3 : in std_logic_vector(31 downto 0);
            RegWrite : in std_logic;
            clk : in std_logic;
            RtD : out std_logic_vector(4 downto 0);
            RdD : out std_logic_vector(4 downto 0);
            SignImmD : out std_logic_vector(31 downto 0);
            RD1D : out std_logic_vector(31 downto 0);
            RD2D : out std_logic_vector(31 downto 0)
        );
end entity;

architecture behavior of decode is
begin
    dut1 : regfile port map (
                                    ra1 => InstrD(25 downto 21),
                                    ra2 => InstrD(20 downto 16),
                                    wa3 => A3,
                                    wd3 => WD3,
                                    we3 => RegWrite,
                                    clk => clk,
                                    rd1 => RD1D,
                                    rd2 => RD2D
                                );

    dut2 : signext port map (
                                    a => InstrD(15 downto 0),
                                    y => SignImmD
                                );

    RdD <= InstrD(15 downto 11);
    RtD <= InstrD(20 downto 16);
end architecture;
