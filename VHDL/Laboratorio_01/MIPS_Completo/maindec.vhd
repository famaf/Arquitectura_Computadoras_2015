library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maindec is
    port (
            op : in std_logic_vector(5 downto 0);
            MemToReg : out std_logic;
            MemWrite : out std_logic;
            Branch : out std_logic;
            AluSrc : out std_logic;
            RegDst : out std_logic;
            RegWrite : out std_logic;
            Jump : out std_logic;
            AluOp : out std_logic_vector(1 downto 0)
        );
end entity;

architecture behavior of maindec is
begin
    process(op) is begin
        case op is
            when "000000" =>
                RegWrite <= '1';
                RegDst <= '1';
                AluSrc <= '0';
                Branch <= '0';
                MemWrite <= '0';
                MemToReg <= '0';
                Jump <= '0';
                Aluop <= "10";
            when "100011" =>
                RegWrite <= '1';
                RegDst <= '0';
                AluSrc <= '1';
                Branch <= '0';
                MemWrite <= '0';
                MemToReg <= '1';
                Jump <= '0';
                Aluop <= "00";
            when "101011" =>
                RegWrite <= '0';
                RegDst <= '0';
                AluSrc <= '1';
                Branch <= '0';
                MemWrite <= '1';
                MemToReg <= '0';
                Jump <= '0';
                Aluop <= "00";
            when "000100" =>
                RegWrite <= '0';
                RegDst <= '0';
                AluSrc <= '0';
                Branch <= '1';
                MemWrite <= '0';
                MemToReg <= '0';
                Jump <= '0';
                Aluop <= "01";
            when "001000" =>
                RegWrite <= '1';
                RegDst <= '0';
                AluSrc <= '1';
                Branch <= '0';
                MemWrite <= '0';
                MemToReg <= '0';
                Jump <= '0';
                Aluop <= "00";
            when "000010" =>
                RegWrite <= '0';
                RegDst <= '0';
                AluSrc <= '0';
                Branch <= '0';
                MemWrite <= '0';
                MemToReg <= '0';
                Jump <= '1';
                Aluop <= "00";
            when others =>
                RegWrite <= '0';
                RegDst <= '0';
                AluSrc <= '0';
                Branch <= '0';
                MemWrite <= '0';
                MemToReg <= '0';
                Jump <= '0';
                Aluop <= "00";
        end case;
    end process;
end architecture;
