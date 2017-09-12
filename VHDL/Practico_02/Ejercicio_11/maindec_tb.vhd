library ieee;
use ieee.std_logic_1164.all;


entity maindec_tb is
end maindec_tb;


architecture test of maindec_tb is

    component maindec is
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
    end component;

    signal Op_s : std_logic_vector (5 DOWNTO 0);
    signal MemToReg_s : std_logic;
    signal MemWrite_s : std_logic;
    signal Branch_s : std_logic;
    signal AluSrc_s : std_logic;
    signal RegDst_s : std_logic;
    signal RegWrite_s : std_logic;
    signal Jump_s : std_logic;
    signal AluOp_s : std_logic_vector (1 DOWNTO 0);

begin

    dut : maindec port map (
                             Op=>Op_s,
                             MemToReg=>MemToReg_s,
                             MemWrite=>MemWrite_s,
                             Branch=>Branch_s,
                             AluSrc=>AluSrc_s,
                             RegDst=>RegDst_s,
                             RegWrite=>RegWrite_s,
                             Jump=>Jump_s,
                             AluOp=>AluOp_s
                            );

    process begin
        Op_s <= "000000";

        wait for 5 ns;
        assert RegWrite_s = '1' report "Salida Erronea" severity error;
        assert RegDst_s = '1' report "Salida Erronea" severity error;
        assert AluSrc_s = '0' report "Salida Erronea" severity error;
        assert Branch_s = '0' report "Salida Erronea" severity error;
        assert MemWrite_s = '0' report "Salida Erronea" severity error;
        assert MemToReg_s = '0' report "Salida Erronea" severity error;
        assert Jump_s = '0' report "Salida Erronea" severity error;
        assert AluOp_s = "10" report "Salida Erronea" severity error;
        wait for 5 ns;

        Op_s <= "100011";

        wait for 5 ns;
        assert RegWrite_s = '1' report "Salida Erronea" severity error;
        assert RegDst_s = '0' report "Salida Erronea" severity error;
        assert AluSrc_s = '1' report "Salida Erronea" severity error;
        assert Branch_s = '0' report "Salida Erronea" severity error;
        assert MemWrite_s = '0' report "Salida Erronea" severity error;
        assert MemToReg_s = '1' report "Salida Erronea" severity error;
        assert Jump_s = '0' report "Salida Erronea" severity error;
        assert AluOp_s = "00" report "Salida Erronea" severity error;
        wait for 5 ns;

        Op_s <= "101011";

        wait for 5 ns;
        assert RegWrite_s = '0' report "Salida Erronea" severity error;
        assert RegDst_s = '0' report "Salida Erronea" severity error;
        assert AluSrc_s = '1' report "Salida Erronea" severity error;
        assert Branch_s = '0' report "Salida Erronea" severity error;
        assert MemWrite_s = '1' report "Salida Erronea" severity error;
        assert MemToReg_s = '0' report "Salida Erronea" severity error;
        assert Jump_s = '0' report "Salida Erronea" severity error;
        assert AluOp_s = "00" report "Salida Erronea" severity error;
        wait for 5 ns;

        Op_s <= "000100";

        wait for 5 ns;
        assert RegWrite_s = '0' report "Salida Erronea" severity error;
        assert RegDst_s = '0' report "Salida Erronea" severity error;
        assert AluSrc_s = '0' report "Salida Erronea" severity error;
        assert Branch_s = '1' report "Salida Erronea" severity error;
        assert MemWrite_s = '0' report "Salida Erronea" severity error;
        assert MemToReg_s = '0' report "Salida Erronea" severity error;
        assert Jump_s = '0' report "Salida Erronea" severity error;
        assert AluOp_s = "01" report "Salida Erronea" severity error;
        wait for 5 ns;

        Op_s <= "001000";

        wait for 5 ns;
        assert RegWrite_s = '1' report "Salida Erronea" severity error;
        assert RegDst_s = '0' report "Salida Erronea" severity error;
        assert AluSrc_s = '1' report "Salida Erronea" severity error;
        assert Branch_s = '0' report "Salida Erronea" severity error;
        assert MemWrite_s = '0' report "Salida Erronea" severity error;
        assert MemToReg_s = '0' report "Salida Erronea" severity error;
        assert Jump_s = '0' report "Salida Erronea" severity error;
        assert AluOp_s = "00" report "Salida Erronea" severity error;
        wait for 5 ns;

        Op_s <= "000010";

        wait for 5 ns;
        assert RegWrite_s = '0' report "Salida Erronea" severity error;
        assert RegDst_s = '0' report "Salida Erronea" severity error;
        assert AluSrc_s = '0' report "Salida Erronea" severity error;
        assert Branch_s = '0' report "Salida Erronea" severity error;
        assert MemWrite_s = '0' report "Salida Erronea" severity error;
        assert MemToReg_s = '0' report "Salida Erronea" severity error;
        assert Jump_s = '1' report "Salida Erronea" severity error;
        assert AluOp_s = "00" report "Salida Erronea" severity error;
        wait for 5 ns;

        Op_s <= "111111";
        assert false report "##### FIN DEL TEST #####" severity note;
        wait for 5 ns;
    end process;
end test;
