library ieee;
use ieee.std_logic_1164.all;


entity fetch is
    port (
            -- ENTRADAS
            clk : in std_logic;
            reset : in std_logic;
            Jump : in std_logic;
            PcSrcM : in std_logic;
            PcBranchM : in std_logic_vector (31 DOWNTO 0);
            -- SALIDAS
            InstrF : out std_logic_vector (31 DOWNTO 0);
            PCF : out std_logic_vector (31 DOWNTO 0);
            PCPLus4F : out std_logic_vector (31 DOWNTO 0)
        );
end fetch;


architecture FETCH of fetch is

    component adder is
        port (
                a : in std_logic_vector (31 DOWNTO 0);
                b : in std_logic_vector (31 DOWNTO 0);
                y : out std_logic_vector (31 DOWNTO 0)
             );
    end component;


    component flopr is
        generic ( N : natural := 32 );
        port (
                clk : in std_logic;
                reset : in std_logic;
                d : in std_logic_vector (N-1 DOWNTO 0);
                q : out std_logic_vector (N-1 DOWNTO 0)
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

    component imem is
        port(
                a:  in  std_logic_vector (5 DOWNTO 0);
                rd: out std_logic_vector (31 DOWNTO 0)
            );
    end component;

    signal m1_to_m2 : std_logic_vector (31 DOWNTO 0);
    signal PC_prima : std_logic_vector (31 DOWNTO 0);
    signal PCF_prima : std_logic_vector (31 DOWNTO 0);
    signal PCPLus4F_prima : std_logic_vector (31 DOWNTO 0);
    signal PCJump : std_logic_vector (31 DOWNTO 0);
    signal InstrF_prima : std_logic_vector (31 DOWNTO 0);

begin

    mux_1 : mux2 port map ( 
                            d0 => PCPLus4F_prima,
                            d1 => PCBranchM,
                            set => PcSrcM,
                            y => m1_to_m2
                        );

    mux_2 : mux2 port map ( 
                            d0 => m1_to_m2,
                            d1 => PCJump, -- DUDA
                            set => Jump,
                            y => PC_prima
                        );

    flip_flop : flopr port map (
                                    clk => clk,
                                    reset => reset,
                                    d => PC_prima,
                                    q => PCF_prima
                                );

    rom_imem : imem port map (
                                a => PCF_prima(7 DOWNTO 2),
                                rd => InstrF_prima
                            );

    adder_1 : adder port map (
                                a => PCF_prima,
                                b => X"00000004", -- 4
                                y => PCPLus4F_prima
                        );

    PCJump <= PCPLus4F_prima(31 DOWNTO 28) & InstrF_prima(25 DOWNTO 0) & "00";
    InstrF <= InstrF_prima;
    PCF <= PCF_prima;
    PCPLus4F <= PCPLus4F_prima;

end FETCH;

