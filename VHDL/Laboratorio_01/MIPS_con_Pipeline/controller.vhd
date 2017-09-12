library ieee;
use ieee.std_logic_1164.all;
use work.components.all;

entity controller is
    port (
            op : in std_logic_vector(5 downto 0);
            funct : in std_logic_vector(5 downto 0);
            MemToReg : out std_logic;
            MemWrite : out std_logic;
            Branch : out std_logic;
            AluSrc : out std_logic;
            RegDst : out std_logic;
            RegWrite : out std_logic;
            Jump : out std_logic;
            AluControl : out std_logic_vector(2 downto 0)
        );
end entity;

architecture behavior of controller is

    signal AluOp_s : std_logic_vector(1 downto 0);

begin
    dut1 : maindec port map (
                                    op,
                                    MemToReg,
                                    MemWrite,
                                    Branch,
                                    AluSrc,
                                    RegDst,
                                    RegWrite,
                                    Jump,
                                    AluOp_s
                                );

    dut2 : aludec port map (
                                funct,
                                AluOp_s,
                                AluControl
                            );
end architecture;
