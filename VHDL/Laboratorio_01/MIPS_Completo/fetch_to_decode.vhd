library ieee;
use ieee.std_logic_1164.all;
use work.components.all;

entity fetch_to_decode is
    port (
            clk : in std_logic;
            reset : in std_logic;
            PCPlus4F : in std_logic_vector(31 downto 0);
            instrF : in std_logic_vector(31 downto 0);
            instrD : out std_logic_vector(31 downto 0);
            PCPlus4D : out std_logic_vector(31 downto 0)
        );
end entity;

architecture behavior of fetch_to_decode is
begin
    dut1 : flopr port map (
                                q => instrD,
                                d => instrF,
                                clk => clk,
                                rst => reset
                            );

    dut2 : flopr port map (
                                q => PCPlus4D,
                                d => PCPlus4F,
                                clk => clk,
                                rst => reset
                            );
end architecture;
