library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity aludec is
port (
        funct : in std_logic_vector(5 downto 0);
        aluop : in std_logic_vector(1 downto 0);
        alucontrol : out std_logic_vector(2 downto 0)
    );
end entity;

architecture behavior of aludec is
begin
    process (aluop, funct) begin
        if (aluop = "00") then
            alucontrol <= "010";
        elsif (aluop = "01") then
            alucontrol <= "110";
        elsif (aluop(1) = '1' and funct = "100000") then
            alucontrol <= "010";
        elsif (aluop(1) = '1' and funct = "100010") then
            alucontrol <= "110";
        elsif (aluop(1) = '1' and funct = "100100") then
            alucontrol <= "000";
        elsif (aluop(1) = '1' and funct = "100101") then
            alucontrol <= "001";
        elsif (aluop(1) = '1' and funct = "101010") then
            alucontrol <= "111";
        end if;
    end process;
end architecture;
