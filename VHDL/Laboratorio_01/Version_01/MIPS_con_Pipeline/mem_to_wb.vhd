library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_to_wb is
    port (
            -- ENTRADAS
            clk : in std_logic;
            AluOut_in : in std_logic_vector (31 DOWNTO 0);
            ReadData_in : in std_logic_vector (31 DOWNTO 0);
            WriteReg_in : in std_logic_vector (4 DOWNTO 0);
            -- SALIDAS
            AluOut_out : out std_logic_vector (31 DOWNTO 0);
            ReadData_out : out std_logic_vector (31 DOWNTO 0);
            WriteReg_out : out std_logic_vector (4 DOWNTO 0);
            -- EXTENSION DEL PIPELINE -> ENTRADAS
            RegWrite_in : in std_logic;
            MemtoReg_in : in std_logic;
            -- EXTENSION DEL PIPELINE -> SALIDAS
            RegWrite_out : out std_logic;
            MemtoReg_out : out std_logic
        );
end mem_to_wb;

architecture behavior of mem_to_wb is
begin
    process(clk) begin
        if(clk'event and clk = '1') then
            AluOut_out <= AluOut_in;
            ReadData_out <= ReadData_in;
            WriteReg_out <= WriteReg_in;
            -- EXTENSION DEL PIPELINE
            RegWrite_out <= RegWrite_in;
            MemtoReg_out <= MemtoReg_in;
        end if;
    end process;
end behavior;
