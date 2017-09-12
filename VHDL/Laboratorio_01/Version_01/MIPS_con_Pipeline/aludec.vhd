library ieee;
use ieee.std_logic_1164.all;


entity aludec is
    port (
            funct : in std_logic_vector (5 DOWNTO 0);
            aluop : in std_logic_vector (1 DOWNTO 0);
            alucontrol : out std_logic_vector (2 DOWNTO 0)
        );
end aludec;


architecture decodificador_A of aludec is

    signal control : std_logic_vector (2 DOWNTO 0);

begin
    process (funct, aluop) begin
        if (aluop = "00") then 
            control <= "010";
        elsif (aluop = "01") then
            control <= "110";
        else
            case funct is
                when "100000" => control <= "010";
                when "100010" => control <= "110";
                when "100100" => control <= "000";
                when "100101" => control <= "001";
                when "101010" => control <= "111";
                when OTHERS => null;
            end case;
        end if;
        alucontrol <= control;
    end process;
end decodificador_A;
