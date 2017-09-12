library ieee;
use ieee.std_logic_1164.all;

package components is
---------------------------------------------------------
------Components Principales Mips
---------------------------------------------------------
    component controller is
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
    end component;

---------------------------------------------------------
------Paneles del Pipeline
---------------------------------------------------------
    component fetch_to_decode is
        port (
                clk : in std_logic;
                reset : in std_logic;
                PCPlus4F : in std_logic_vector(31 downto 0);
                instrF  : in std_logic_vector(31 downto 0);
                instrD  : out std_logic_vector(31 downto 0);
                PCPlus4D : out std_logic_vector(31 downto 0)
            );
    end component;

    component decode_to_execute is
        port (
                clk : in std_logic;
                reset : in std_logic;
                RegWriteD : in std_logic;
                MemToRegD : in std_logic;
                MemWriteD : in std_logic;
                JumpD : in std_logic;
                BranchD : in std_logic;
                AlucontrolD : in std_logic_vector(2 downto 0);
                ALUSrcD : in std_logic;
                RegDstD : in std_logic;
                rd1D : in std_logic_vector(31 downto 0);
                rd2D : in std_logic_vector(31 downto 0);
                RtD : in std_logic_vector(4 downto 0);
                RdD : in std_logic_vector(4 downto 0);
                SignimmD : in std_logic_vector(31 downto 0);
                PCPlus4D : in std_logic_vector(31 downto 0);

                RegWriteE : out std_logic;
                MemToRegE : out std_logic;
                MemWriteE : out std_logic;
                JumpE : out std_logic;
                BranchE : out std_logic;
                AlucontrolE : out std_logic_vector(2 downto 0);
                ALUSrcE : out std_logic;
                RegDstE : out std_logic;
                rd1E : out std_logic_vector(31 downto 0);
                rd2E : out std_logic_vector(31 downto 0);
                RtE : out std_logic_vector(4 downto 0);
                RdE : out std_logic_vector(4 downto 0);
                SignimmE : out std_logic_vector(31 downto 0);
                PCPlus4E : out std_logic_vector(31 downto 0)
        );
    end component;

    component execute_to_memory is
        port (
                clk : in std_logic;
                reset : in std_logic;
                RegWriteE : in std_logic;
                MemToRegE : in std_logic;
                MemWriteE : in std_logic;
                JumpE : in std_logic;
                BranchE : in std_logic;
                ZeroE : in std_logic;
                AluOutE : in std_logic_vector(31 downto 0);
                WriteDataE : in std_logic_vector(31 downto 0);
                WriteRegE : in std_logic_vector(4 downto 0);
                PCBranchE : in std_logic_vector(31 downto 0);

                RegWriteM : out std_logic;
                MemToRegM : out std_logic;
                MemWriteM : out std_logic;
                JumpM : out std_logic;
                BranchM : out std_logic;
                ZeroM : out std_logic;
                AluOutM : out std_logic_vector(31 downto 0);
                WriteDataM : out std_logic_vector(31 downto 0);
                WriteRegM : out std_logic_vector(4 downto 0);
                PCBranchM : out std_logic_vector(31 downto 0)
            );
    end component;

    component memory_to_writeback is
        port (
                clk : in std_logic;
                reset : in std_logic;
                RegWriteM : in std_logic;
                MemtoRegM : in std_logic;
                AluOutM : in std_logic_vector(31 downto 0);
                ReadDataM : in std_logic_vector(31 downto 0);
                WriteRegM : in std_logic_vector(4 downto 0);

                RegWriteW : out std_logic;
                MemtoRegW : out std_logic;
                AluOutW : out std_logic_vector(31 downto 0);
                ReadDataW : out std_logic_vector(31 downto 0);
                WriteRegW : out std_logic_vector(4 downto 0)
            );
    end component;

---------------------------------------------------------
------Componentes o Etapas del Pipeline
---------------------------------------------------------
    component fetch is
        port (
                Jump : in std_logic;
                PCSrcM : in std_logic;
                PCBranchM : in std_logic_vector(31 downto 0);
                clk : in std_logic;
                reset : in std_logic;
                InstrF : out std_logic_vector(31 downto 0);
                PCF : out std_logic_vector(31 downto 0);
                PCPlus4F : out std_logic_vector(31 downto 0)
            );
    end component;

    component decode is
        port (
                A3 : in std_logic_vector(4 downto 0);
                InstrD : in std_logic_vector(31 downto 0);
                WD3 : in std_logic_vector(31 downto 0);
                RegWrite : in std_logic;
                clk : in std_logic;
                RtD : out std_logic_vector(4 downto 0);
                RdD : out std_logic_vector(4 downto 0);
                SignImmD : out std_logic_vector(31 downto 0);
                RD1D : out std_logic_vector(31 downto 0);
                RD2D : out std_logic_vector(31 downto 0)
            );
    end component;

    component execute is
        port (
                RD1E : in std_logic_vector(31 downto 0);
                RD2E : in std_logic_vector(31 downto 0);
                PCPlus4E : in std_logic_vector(31 downto 0);
                SignImmE : in std_logic_vector(31 downto 0);
                RtE : in std_logic_vector(4 downto 0);
                RdE : in std_logic_vector(4 downto 0);
                AluControl : in std_logic_vector(2 downto 0);
                RegDst : in std_logic;
                AluSrc : in std_logic;
                WriteRegE : out std_logic_vector(4 downto 0);
                AluOutE : out std_logic_vector(31 downto 0);
                WriteDataE : out std_logic_vector(31 downto 0);
                PcBranchE : out std_logic_vector(31 downto 0);
                ZeroE : out std_logic
            );
    end component;

    component memory is 
        port (
                AluOutM : in std_logic_vector(31 downto 0);
                zeroM  : in std_logic;
                WriteDataM : in std_logic_vector(31 downto 0);
                clk : in std_logic;
                dump : in std_logic;
                MemWrite : in std_logic;
                Branch : in std_logic;
                ReadDat : out std_logic_vector(31 downto 0);
                PCSrcM : out std_logic
            );
    end component;

    component writeback is
        port (
                AluOutW : in std_logic_vector(31 downto 0);
                ReadDataW : in std_logic_vector(31 downto 0);
                MemToReg : in std_logic;
                ResultW : out std_logic_vector(31 downto 0)
            );
    end component;

---------------------------------------------------------
------Componentes Basicos (adder, flopr, etc)
---------------------------------------------------------
    component adder is
        port (
                a : in std_logic_vector(31 downto 0);
                b : in std_logic_vector(31 downto 0);
                y : out std_logic_vector(31 downto 0)
            );
    end component;

    component flopr is
        generic (n : integer := 32);
        port (
                q : out std_logic_vector(n-1 downto 0);
                d : in std_logic_vector(n-1 downto 0);
                clk : in std_logic;
                rst : in std_logic
            );
    end component;

    component flopr1 is
        port (
                q : out std_logic;
                d : in std_logic;
                clk : in std_logic;
                rst : in std_logic
            );
    end component;

    component flopr3 is
        port (
                q : out std_logic_vector(2 downto 0);
                d : in std_logic_vector(2 downto 0);
                clk : in std_logic;
                rst : in std_logic
            );
    end component;

    component flopr5 is
        port (
                q : out std_logic_vector(4 downto 0);
                d : in std_logic_vector(4 downto 0);
                clk : in std_logic;
                rst : in std_logic
            );
    end component;

    component regfile is
        port (
                ra1 : in std_logic_vector(4 downto 0);
                ra2 : in std_logic_vector(4 downto 0);
                wa3 : in std_logic_vector(4 downto 0);
                wd3 : in std_logic_vector(31 downto 0);
                we3 : in std_logic;
                clk : in std_logic;
                rd1 : out std_logic_vector(31 downto 0);
                rd2 : out std_logic_vector(31 downto 0)
            );
    end component;

    component mux2_5b is
        port (
                d0 : in std_logic_vector(4 downto 0);
                d1 : in std_logic_vector(4 downto 0);
                y : out std_logic_vector(4 downto 0);
                s : in std_logic
            );
    end component;


    component mux2 is
        port (
                d0 : in std_logic_vector(31 downto 0);
                d1 : in std_logic_vector(31 downto 0);
                y : out std_logic_vector(31 downto 0);
                s : in std_logic
            );
    end component;

    component signext is
        port (
                a : in std_logic_vector(15 downto 0);
                y : out std_logic_vector(31 downto 0)
            );
    end component;

    component sl2 is
        port (
                a : in std_logic_vector(31 downto 0);
                y : out std_logic_vector(31 downto 0)
            );
    end component;

    component alu is
        port (
                a : in std_logic_vector(31 downto 0);
                b : in std_logic_vector(31 downto 0);
                alucontrol : in std_logic_vector(2 downto 0);
                result : out std_logic_vector(31 downto 0);
                zero : out std_logic
            );
    end component;

    component dmem is
        port (
                clk : in std_logic;
                we : in std_logic;
                a : in std_logic_vector(31 downto 0);
                wd : in std_logic_vector(31 downto 0);
                rd : out std_logic_vector(31 downto 0);
                dump : in std_logic
            );
    end component;

    component imem is
        port (
                a : in std_logic_vector(5 downto 0);
                rd : out std_logic_vector(31 downto 0)
            );
    end component;

    component aludec is
        port (
                funct :in std_logic_vector(5 downto 0);
                aluop : in std_logic_vector(1 downto 0);
                alucontrol : out std_logic_vector(2 downto 0)
            );
    end component;


    component maindec is
        port(
                Op : in std_logic_vector(5 downto 0);
                MemToReg : out std_logic;
                MemWrite : out std_logic;
                Branch : out std_logic;
                AluSrc : out std_logic;
                RegDst : out std_logic;
                RegWrite : out std_logic;
                Jump : out std_logic;
                AluOp : out std_logic_vector(1 downto 0)
            );
    end component;

end components;
