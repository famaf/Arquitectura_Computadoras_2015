library ieee;
use ieee.std_logic_1164.all;
use work.components.all;

entity mips is 
port (
        reset, clock, dump :in std_logic;
        instr, pc :out std_logic_vector(31 downto 0)
);

end entity;

architecture behav of mips is

    signal memtoreg_s : std_logic;
    signal memwrite_s : std_logic;
    signal branch_s : std_logic;
    signal alusrc_s : std_logic;
    signal regdst_s : std_logic;
    signal regwrite_s : std_logic;
    signal jump_s : std_logic;
    signal alucontrol_s : std_logic_vector(2 downto 0);

    signal instr_s : std_logic_vector(31 downto 0);
    signal pc_s : std_logic_vector(31 downto 0);

begin
    dut1 : controller port map (
                                       op => instr_s(31 downto 26),
                                       funct => instr_s(5 downto 0),
                                       MemToReg => memtoreg_s,
                                       MemWrite => memwrite_s,
                                       Branch => branch_s,
                                       AluSrc => alusrc_s,
                                       RegDst => regdst_s,
                                       RegWrite => regwrite_s,
                                       Jump => jump_s,
                                       AluControl => alucontrol_s
                                    );

    dut2 : datapath port map (
                                   memtoreg => memtoreg_s,
                                   memwrite => memwrite_s,
                                   branch => branch_s,
                                   alusrc => alusrc_s,
                                   regdst => regdst_s,
                                   regwrite => regwrite_s,
                                   jump => jump_s,
                                   reset => reset,
                                   clock => clock,
                                   dump => dump,
                                   alucontrol => alucontrol_s,
                                   instr => instr_s,
                                   pc => pc_s
                                );
            memtoreg : in std_logic;
            memwrite : in std_logic;
            branch : in std_logic;
            alusrc : in std_logic;
            regdst : in std_logic;
            regwrite : in std_logic;
            jump : in std_logic;
            reset : in std_logic;
            clock : in std_logic;
            dump : in std_logic;
            alucontrol : in std_logic_vector (2 downto 0);
            instr : out std_logic_vector(31 downto 0);
            pc : out std_logic_vector(31 downto 0)
    instr <= instr_s;
    pc <= pc_s;
end architecture;

