library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ex_to_mem is
    port (
            -- ENTRADAS
            clk : in std_logic;
            Zero_in : in std_logic;
            AluOut_in : in std_logic_vector (31 DOWNTO 0);
            WriteData_in : in std_logic_vector (31 DOWNTO 0);
            PCBranch_in : in std_logic_vector (31 DOWNTO 0);
            WriteReg_in : in std_logic_vector (4 DOWNTO 0);
            -- SALIDAS
            Zero_out : out std_logic;
            AluOut_out : out std_logic_vector (31 DOWNTO 0);
            WriteData_out : out std_logic_vector (31 DOWNTO 0);
            WriteReg_out : out std_logic_vector (4 DOWNTO 0);
            PCBranch_out : out std_logic_vector (31 DOWNTO 0);
            -- EXTENSION DEL PIPELINE -> ENTRADAS
            RegWrite_in : in std_logic;
            MemtoReg_in : in std_logic;
            MemWrite_in : in std_logic;
            Jump_in : in std_logic;
            Branch_in : in std_logic;
            -- EXTENSION DEL PIPELINE -> ENTRADAS
            RegWrite_out : out std_logic;
            MemtoReg_out : out std_logic;
            MemWrite_out : out std_logic;
            Jump_out : out std_logic;
            Branch_out : out std_logic
        );
end ex_to_mem;


architecture behavior of ex_to_mem is
begin
    process(clk) begin
        if(clk'event and clk = '1') then
            Zero_out <= Zero_in;
            AluOut_out <= AluOut_in;
            WriteData_out <= WriteData_in;
            WriteReg_out <= WriteReg_in;
            PCBranch_out <= PCBranch_in;
            -- EXTENSION DEL PIPELINE
            RegWrite_out <= RegWrite_in;
            MemtoReg_out <= MemtoReg_in;
            MemWrite_out <= MemWrite_in;
            Jump_out <= Jump_in;
            Branch_out <= Branch_in;
        end if;
    end process;
end behavior;
