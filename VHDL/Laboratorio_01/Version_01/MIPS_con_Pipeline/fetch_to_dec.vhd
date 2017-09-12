library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity fetch_to_dec is
    port (
            -- ENTRADAS
            clk : in std_logic;
            Instr_in : in std_logic_vector (31 downto 0);
            PCPlus4_in : in std_logic_vector (31 downto 0);
            -- SALIDAS
            Instr_out : out std_logic_vector (31 downto 0);
            PCPlus4_out : out std_logic_vector (31 downto 0)
        );
end fetch_to_dec;


architecture behavior of fetch_to_dec is
begin
    process(clk) begin
        if(clk'event and clk = '1') then
            Instr_out <= Instr_in;
            PCPlus4_out <= PCPlus4_in;
        end if;
    end process;
end behavior;
