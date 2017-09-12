library ieee;
use ieee.std_logic_1164.all;

package components is

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


    component aludec is
        port (
                funct : in std_logic_vector (5 DOWNTO 0);
                aluop : in std_logic_vector (1 DOWNTO 0);
                alucontrol : out std_logic_vector (2 DOWNTO 0)
            );
    end component;

end package;