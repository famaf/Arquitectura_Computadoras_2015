library ieee;
use ieee.std_logic_1164.all;

--library work;
--use work.componentes.all;

entity controller is
port (
        Op,Funct : in std_logic_vector(5 downto 0);
        AluControl : out std_logic_vector(2 downto 0);
        MemToReg : out std_logic;
        MemWrite : out std_logic;
        Branch : out std_logic;
        AluSrc : out std_logic;
        RegDst : out std_logic;
        RegWrite : out std_logic;
        Jump :out std_logic
     );
end entity;

architecture cont of controller is

    signal q_Op,q_Funct :std_logic_vector(5 downto 0);
    signal q_AluControl :std_logic_vector(2 downto 0);
    signal q_MemToReg,q_MemWrite,q_Branch,q_AluSrc,q_RegDst,q_RegWrite,q_Jump :std_logic;
    signal aluopwire: std_logic_vector(1 downto 0);

    component aludec
        port(   
                funct   :in std_logic_vector(5 downto 0);
                aluop   :in std_logic_vector(1 downto 0);
                alucontrol  :out std_logic_vector(2 downto 0)
            );
    end component;

    component maindec
        port(    
                Op  :in std_logic_vector(5 downto 0);
                MemToReg,MemWrite,Branch,AluSrc,RegDst,RegWrite,Jump    :out std_logic;
                AluOp   :out std_logic_vector(1 downto 0)
             );
    end component;


begin

    dut: maindec port map (Op => q_Op, MemToReg => q_MemToReg,
                           MemWrite=>q_MemWrite, Branch=>q_Branch,
                           AluSrc=> q_AluSrc, RegDst=>q_RegDst,
                           RegWrite=>q_RegWrite, Jump=>q_Jump,
                           AluOp=>aluopwire);

    dut1: aludec port map(funct=>funct, aluOp=>aluopwire,
                        alucontrol=>q_AluControl);
    q_Op <= Op;
    MemToReg<=q_MemToReg;
    MemWrite<=q_MemWrite;
    Branch<=q_Branch;
    AluSrc<= q_AluSrc;
    RegDst<=q_RegDst;
    RegWrite<=q_RegWrite;
    Jump<=q_Jump;
    aluControl<=q_AluControl;


end architecture;
