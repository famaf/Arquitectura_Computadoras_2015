library ieee;
use ieee.std_logic_1164.all;


entity execute is
    port (
            -- ENTRADAS
            RegDst : in std_logic;
            AluSrc : in std_logic;
            AluControl : in std_logic_vector (2 DOWNTO 0);
            RD1E : in std_logic_vector (31 DOWNTO 0);
            RD2E : in std_logic_vector (31 DOWNTO 0);
            PCPlus4E : in std_logic_vector (31 DOWNTO 0);
            RtE : in std_logic_vector (4 DOWNTO 0);
            RdE : in std_logic_vector (4 DOWNTO 0);
            SignImmE : in std_logic_vector (31 DOWNTO 0);
            -- SALIDAS
            WriteRegE : out std_logic_vector (4 DOWNTO 0);
            zeroE : out std_logic;
            AluOutE : out std_logic_vector (31 DOWNTO 0);
            WriteDataE : out std_logic_vector (31 DOWNTO 0);
            PCBranchE : out std_logic_vector (31 DOWNTO 0)
        );
end execute;


architecture behav of execute is

    component adder is
        port (
                a : in std_logic_vector (31 DOWNTO 0);
                b : in std_logic_vector (31 DOWNTO 0);
                y : out std_logic_vector (31 DOWNTO 0)
             );
    end component;

    component alu is
        port (
                a : in std_logic_vector (31 DOWNTO 0);
                b : in std_logic_vector (31 DOWNTO 0);
                alucontrol : in std_logic_vector (2 DOWNTO 0);
                zero : out std_logic;
                result : out std_logic_vector (31 DOWNTO 0)
            );
    end component;

    component sl2 is
        port (
                a : in std_logic_vector (31 DOWNTO 0);
                y : out std_logic_vector (31 DOWNTO 0)
            );
    end component;

    component mux2 is
        generic ( N : natural := 32 );
        port (
                d0 : in std_logic_vector (N-1 DOWNTO 0);
                d1 : in std_logic_vector (N-1 DOWNTO 0);
                set : in std_logic;
                y : out std_logic_vector (N-1 DOWNTO 0)
            );
    end component;

    signal sl2_out : std_logic_vector (31 DOWNTO 0);
--    signal SrcAE : std_logic_vector (31 DOWNTO 0);
    signal SrcBE : std_logic_vector (31 DOWNTO 0);

begin

    mux_1 : mux2 port map ( 
                            d0 => RD2E,
                            d1 => SignImmE,
                            set => AluSrc,
                            y => SrcBE
                        );

    mux_2 : mux2 generic map (N => 5) port map (  -- CAMBIO
                                                d0 => RtE,
                                                d1 => RdE,
                                                set => RegDst,
                                                y => WriteRegE
                                            );

    sl2_1 : sl2 port map ( 
                            a => SignImmE,
                            y => sl2_out
                        );

    add_1 : adder port map ( 
                            a => sl2_out,
                            b =>PCPlus4E,
                            y => PCBranchE
                        );

    alu_1 : alu port map ( 
                            a => RD1E,
                            b => SrcBE,
                            alucontrol => AluControl,
                            zero => zeroE,
                            result => AluOutE
                        );
--    RD1E <= SrcAE;
    WriteDataE <= RD2E;

end behav;
