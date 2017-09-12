library ieee;
use ieee.std_logic_1164.all;


entity maindec is
    port (
            Op : in std_logic_vector (5 DOWNTO 0);
            MemToReg : out std_logic;
            MemWrite : out std_logic;
            Branch : out std_logic;
            AluSrc : out std_logic;
            RegDst : out std_logic;
            RegWrite : out std_logic;
            Jump : out std_logic;
            AluOp : out std_logic_vector (1 DOWNTO 0)
        );
end maindec;


architecture decodificador_B of maindec is
begin
    process (Op) begin
        case Op is
            when "000000" =>
                            RegWrite <= '1';
                            RegDst <= '1';
                            AluSrc <= '0';
                            Branch <= '0';
                            MemWrite <= '0';
                            MemToReg <= '0';
                            Jump <= '0';
                            AluOp <= "10";
            when "100011" =>
                            RegWrite <= '1';
                            RegDst <= '0';
                            AluSrc <= '1';
                            Branch <= '0';
                            MemWrite <= '0';
                            MemToReg <= '1';
                            Jump <= '0';
                            AluOp <= "00";
            when "101011" =>
                            RegWrite <= '0';
                            RegDst <= '0';
                            AluSrc <= '1';
                            Branch <= '0';
                            MemWrite <= '1';
                            MemToReg <= '0';
                            Jump <= '0';
                            AluOp <= "00";
            when "000100" =>
                            RegWrite <= '0';
                            RegDst <= '0';
                            AluSrc <= '0';
                            Branch <= '1';
                            MemWrite <= '0';
                            MemToReg <= '0';
                            Jump <= '0';
                            AluOp <= "01";
            when "001000" =>
                            RegWrite <= '1';
                            RegDst <= '0';
                            AluSrc <= '1';
                            Branch <= '0';
                            MemWrite <= '0';
                            MemToReg <= '0';
                            Jump <= '0';
                            AluOp <= "00";
            when "000010" =>
                            RegWrite <= '0';
                            RegDst <= '0';
                            AluSrc <= '0';
                            Branch <= '0';
                            MemWrite <= '0';
                            MemToReg <= '0';
                            Jump <= '1';
                            AluOp <= "00";
            when OTHERS => null;
        end case;
    end process;
end decodificador_B;

