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
begin
    process (funct, aluop) begin
        if (aluop = "00") then 
            alucontrol <= "010";
        elsif (aluop = "01") then
            alucontrol <= "110";
        elsif ((funct = "100000") and (aluop(1) = '1')) then
            alucontrol <= "010";
        elsif ((funct = "100010") and (aluop(1) = '1')) then
            alucontrol <= "110";
        elsif ((funct = "100100") and (aluop(1) = '1')) then
            alucontrol <= "000";
        elsif ((funct = "100101") and (aluop(1) = '1')) then
            alucontrol <= "001";
        elsif ((funct = "101010") and (aluop(1) = '1')) then
            alucontrol <= "111";
        end if;
    end process;
end decodificador_A;
