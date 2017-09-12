library ieee;
use ieee.std_logic_1164.all;

library work;
use work.components.all;

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

    signal AluOP_s : std_logic_vector (1 DOWNTO 0);

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
                                  AluOP => AluOP_s
                                );

    alu_dec : aludec port map ( 
                                funct => Funct,
                                aluop => AluOP_s,
                                aluControl => AluControl
                              );

end controlador;
