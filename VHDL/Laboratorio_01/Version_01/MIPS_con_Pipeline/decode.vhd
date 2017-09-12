library ieee;
use ieee.std_logic_1164.all;


entity decode is
    port (
            -- ENTRADAS
            clk : in std_logic;
            RegWrite : in std_logic;
            A3 : in std_logic_vector (4 DOWNTO 0);
            InstrD : in std_logic_vector (31 DOWNTO 0);
            Wd3 : in std_logic_vector (31 DOWNTO 0);
            -- SALIDAS
            RtD : out std_logic_vector (4 DOWNTO 0);
            RdD : out std_logic_vector (4 DOWNTO 0);
            SignImmD : out std_logic_vector (31 DOWNTO 0);
            RD1D : out std_logic_vector (31 DOWNTO 0);
            RD2D : out std_logic_vector (31 DOWNTO 0);
            -- PUERTOS AUXILIARES DE IN/OUT (ES UN CABLE)
            PCPlus4D_in : in std_logic_vector (31 DOWNTO 0);
            PCPlus4D_out : out std_logic_vector (31 DOWNTO 0)
        );
end decode;


architecture DECODE of decode is

    component regfile is
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
    end component;


    component signext is
        port (
                a : in std_logic_vector (15 DOWNTO 0);
                y : out std_logic_vector (31 DOWNTO 0)
            );
    end component;

    signal InstrD_prima : std_logic_vector (31 DOWNTO 0);

begin

    registro_1 : regfile port map (
                                    clk => clk,
                                    we3 => RegWrite,
                                    ra1 => InstrD(25 DOWNTO 21),
                                    ra2 => InstrD(20 DOWNTO 16),
                                    wa3 => A3,
                                    wd3 => Wd3,
                                    rd1 => RD1D,
                                    rd2 => RD2D
                                );

    sig_next : signext port map (
                                    a => InstrD(15 DOWNTO 0),
                                    y => SignImmD
                                );

    RtD <= InstrD(20 DOWNTO 16);
    RdD <= InstrD(15 DOWNTO 11);
 -- CONEXION DEL CABLE
    PCPlus4D_out <= PCPlus4D_in;

end DECODE;
