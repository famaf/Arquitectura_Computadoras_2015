library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity dec_to_ex is
    port (
            -- ENTRADAS
            clk : in std_logic;
            RD1_in : in std_logic_vector (31 DOWNTO 0);
            RD2_in : in std_logic_vector (31 DOWNTO 0);
            Rt_in : in std_logic_vector (4 DOWNTO 0);
            Rd_in : in std_logic_vector (4 DOWNTO 0);
            SignImm_in : in std_logic_vector (31 DOWNTO 0);
            PCPlus4_in : in std_logic_vector (31 DOWNTO 0);
            -- SALIDAS
            RD1_out : out std_logic_vector (31 DOWNTO 0);
            RD2_out : out std_logic_vector (31 DOWNTO 0);
            Rt_out : out std_logic_vector (4 DOWNTO 0);
            Rd_out : out std_logic_vector (4 DOWNTO 0);
            SignImm_out : out std_logic_vector (31 DOWNTO 0);
            PCPlus4_out : out std_logic_vector (31 DOWNTO 0);
            -- EXTENSION DEL PIPELINE -> ENTRADAS
            RegWrite_in : in std_logic;
            MemtoReg_in : in std_logic;
            MemWrite_in : in std_logic;
            Jump_in : in std_logic;
            Branch_in : in std_logic;
            ALUControl_in : in std_logic_vector (2 DOWNTO 0);
            ALUSrc_in : in std_logic;
            RegDst_in : in std_logic;
            -- EXTENSION DEL PIPELINE -> SALIDAS
            RegWrite_out : out std_logic;
            MemtoReg_out : out std_logic;
            MemWrite_out : out std_logic;
            Jump_out : out std_logic;
            Branch_out : out std_logic;
            ALUControl_out : out std_logic_vector (2 DOWNTO 0);
            ALUSrc_out : out std_logic;
            RegDst_out : out std_logic
        );
end dec_to_ex;


architecture behavior of dec_to_ex is
begin
    process(clk) begin
        if (clk'event and clk = '1') then
            RD1_out <= RD1_in;
            RD2_out <= RD2_in;
            Rt_out <= Rt_in;
            Rd_out <= Rd_in;
            SignImm_out <= SignImm_in;
            PCPlus4_out <= PCPlus4_in;
            -- EXTENSION DEL PIPELINE
            RegWrite_out <= RegWrite_in;
            MemtoReg_out <= MemtoReg_in;
            MemWrite_out <= MemWrite_in;
            Jump_out <= Jump_in;
            Branch_out <= Branch_in;
            ALUControl_out <= ALUControl_in;
            ALUSrc_out <= ALUSrc_in;
            RegDst_out <= RegDst_in;
        end if;
    end process;
end behavior;
