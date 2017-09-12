library ieee;
use ieee.std_logic_1164.all;


entity controller is
    port (
            Op : in std_logic_vector (5 DOWNTO 0);
            Funct : in std_logic_vector (5 DOWNTO 0);
            MemToReg : out std_logic;
            MemWrite : out std_logic;
            Branch : out std_logic;
            AluSrc : out std_logic;
            RegDst : out std_logic;
            RegWrite : out std_logic;
            Jump : out std_logic;
            AluControl : out std_logic_vector (2 DOWNTO 0)
         );
end controller;

architecture controlador of controller is

    component maindec
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

    component aludec
        port (
                funct : in std_logic_vector (5 DOWNTO 0);
                aluop : in std_logic_vector (1 DOWNTO 0);
                alucontrol : out std_logic_vector (2 DOWNTO 0)
            );
    end component;

    signal Aluop_s : std_logic_vector(1 downto 0);

begin

    main_dec : maindec port map (
                                    Op => Op,
                                    MemToReg => MemToReg,
                                    MemWrite => MemWrite,
                                    Branch => Branch,
                                    AluSrc => AluSrc,
                                    RegDst => RegDst,
                                    RegWrite => RegWrite,
                                    Jump => Jump,
                                    AluOp => Aluop_s
                                );

    alu_dec : aludec port map(
                                funct => Funct,
                                aluOp => Aluop_s,
                                alucontrol => AluControl
                            );

end controlador;
