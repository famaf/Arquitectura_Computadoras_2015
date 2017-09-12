library ieee;
use ieee.std_logic_1164.all;
use work.components.all;

entity fetch is
    port (
            Jump : in std_logic;
            PCSrcM : in std_logic;
            PCBranchM : in std_logic_vector(31 downto 0);
            clk : in std_logic;
            reset : in std_logic;
            InstrF : out std_logic_vector(31 downto 0);
            PCF : out std_logic_vector(31 downto 0);
            PCPlus4F : out std_logic_vector(31 downto 0)
        );
end entity;

architecture behavior of fetch is

    signal PCJump: std_logic_vector(31 downto 0);
    signal mux0_s: std_logic_vector(31 downto 0);
    signal PC_s : std_logic_vector(31 downto 0);
    signal PCF_s : std_logic_vector(31 downto 0);
    signal PCPlus4F_s : std_logic_vector(31 downto 0);
    signal InstrF_s : std_logic_vector(31 downto 0);

begin
    PCJump <= PCPlus4F_s(31 downto 28) & InstrF_s(25 downto 0) & "00";

    dut1 : mux2 port map (
                            d0 => PCPlus4F_s,
                            d1 => PCBranchM,
                            y => mux0_s,
                            s => PCSrcM
                        );

    dut2 : mux2 port map (
                            d0 => mux0_s,
                            d1 => PCJUMP,
                            y => PC_s,
                            s => Jump
                        );

    dut3 : flopr port map (
                                q => PCF_s,
                                d => PC_s,
                                clk => clk,
                                rst => reset
                            );

    dut4 : imem port map (
                            a => PCF_s(7 downto 2),
                            rd => InstrF_s
                        );

    dut5 : adder port map (
                                a => PCF_s,
                                b => "00000000000000000000000000000100",
                                y => PCPlus4F_s
                            );

    PCF <= PCF_s;
    PCPlus4F <= PCPlus4F_s;
    InstrF <= InstrF_s;
end architecture;
