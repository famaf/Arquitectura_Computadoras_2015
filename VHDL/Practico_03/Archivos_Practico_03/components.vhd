-------------------------------------------------------------------------------
--
-- Title       : components
-- Design      : Mips
-- Author      : Eduardo Sanchez
-- Company     : Famaf
--
-------------------------------------------------------------------------------
--
-- File        : components.vhd
--
-------------------------------------------------------------------------------
--
-- Description : Archivo de definiciones y componentes comunes al diseño.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


package components is

    -- constantes:
    constant MIPS_SOFT_FILE : string := "//RUTA//mips.dat";
    constant MEMORY_DUMP_FILE : string := "mem.dump";

    component flopr1b is
        port (
                d : in std_logic;     -- up_down control for counter
                clk : in std_logic;   -- Input clock
                reset : in std_logic;
                q : out std_logic
            );
    end component;

    component fetch is
        port ( 
                clk : in std_logic;
                reset : in std_logic;
                Jump : in std_logic;
                PcSrcM : in std_logic;
                PcBranchM : in std_logic_vector (31 downto 0);
                InstrF : out std_logic_vector (31 downto 0);
                PCF : out std_logic_vector (31 downto 0);
                PCPLus4F : out std_logic_vector (31 downto 0)
            );
    end component;

    component execute is
        port (
                RegDst : in std_logic;
                AluSrc : in std_logic;
                AluControl : in std_logic_vector (2 downto 0);
                RtE : in std_logic_vector (4 downto 0);
                RdE : in std_logic_vector (4 downto 0);
                RD1E : in std_logic_vector (31 downto 0);
                RD2E : in std_logic_vector (31 downto 0);
                PCPlus4E : in std_logic_vector (31 downto 0);
                SignImmE : in std_logic_vector (31 downto 0);
                AluOutE : out std_logic_vector (31 downto 0);
                WriteDataE : out std_logic_vector (31 downto 0);
                PCBranchE : out std_logic_vector (31 downto 0);
                WriteRegE : out std_logic_vector(4 downto 0);
                zeroE : out std_logic
            );
    end component;

    component decode is
        port (
                RegWrite : in std_logic;
                clk : in std_logic;
                InstrD : in std_logic_vector (31 downto 0);
                Wd3 : in std_logic_vector (31 downto 0);
                A3 : in std_logic_vector (4 downto 0);
                SignImmD : out std_logic_vector (31 downto 0);
                RD1D : out std_logic_vector (31 downto 0);
                RD2D : out std_logic_vector (31 downto 0);
                RtD : out std_logic_vector (4 downto 0);
                RdD : out std_logic_vector (4 downto 0)
            );
    end component;

    component memory is
        port (
                clk : in std_logic;
                dump : in std_logic;
                MemWrite : in std_logic;
                Branch : in std_logic;
                zeroM : in std_logic;
                AluOutM : in std_logic_vector (31 downto 0);
                WriteDataM : in std_logic_vector (31 downto 0);
                ReadDat : out std_logic_vector (31 downto 0);
                PCSrcM : out std_logic
            );
    end component;

    component writeback is
        port (
                MemToReg : in std_logic;
                ReadDataW : in std_logic_vector (31 downto 0);
                AluOutW : in std_logic_vector (31 downto 0);
                ResultW : out std_logic_vector (31 downto 0)
            );
    end component;

    component adder is -- adder
        port (
                a : in std_logic_vector (31 downto 0);
                b : in std_logic_vector (31 downto 0);
                y : out std_logic_vector (31 downto 0)
            );
    end component;

    component aludec is -- ALU control decoder
    port (
            funct : in  std_logic_vector (5 downto 0);
            aluop : in  std_logic_vector (1 downto 0);
            alucontrol : out std_logic_vector (2 downto 0)
        );
    end component;

    component alu is -- Arithmetic/Logic unit with add/sub, AND, OR, set less than
        port (
                a : in  std_logic_vector (31 downto 0);
                b : in  std_logic_vector (31 downto 0);
                alucontrol : in std_logic_vector (2 downto 0);
                result : out std_logic_vector (31 downto 0);
                zero : out std_logic
            );
    end component;

    component controller is -- single cycle control decoder
        port (
                Op : in std_logic_vector (5 downto 0);
                Funct : in std_logic_vector (5 downto 0);
                MemToReg : out std_logic;
                MemWrite : out std_logic;
                AluSrc : out std_logic;
                RegDst : out std_logic;
                RegWrite : out std_logic;
                Jump : out std_logic;
                AluControl : out std_logic_vector (2 downto 0);
                Branch : out std_logic
            );
    end component;

    component datapath is  -- single-path Datapath
        port (
                clk : in std_logic;
                reset : in std_logic;
                MemToReg : in std_logic;
                Branch : in std_logic;
                AluSrc : in std_logic;
                RegDst : in std_logic;
                RegWrite : in std_logic;
                Jump : in std_logic;
                AluControl : in std_logic_vector (2 downto 0);
                pc : out std_logic_vector (31 downto 0);
                instr : out std_logic_vector (31 downto 0);
                MemWrite : in std_logic;
                dump : in std_logic
            );
    end component;

    component dmem is -- data memory
        port (
                clk : in std_logic;
                we : in std_logic;
                a : in std_logic_vector (31 downto 0);
                wd : in std_logic_vector (31 downto 0);
                dump : in std_logic;
                rd : out std_logic_vector (31 downto 0)
            );
    end component;

    component flopr is -- flip-flop with synchronous reset
        generic(N : integer);
        port (
                clk : in  std_logic;
                reset : in  std_logic;
                d : in  std_logic_vector (N-1 downto 0);
                q : out std_logic_vector (N-1 downto 0)
            );
    end component;

    component imem is -- instruction memory
        port (
                a : in  std_logic_vector (5 downto 0);
                rd : out std_logic_vector (31 downto 0)
            );
    end component;

    component maindec is -- main control decoder
        port (
                Op : in std_logic_vector (5 downto 0);
                MemToReg : out std_logic;
                MemWrite : out std_logic;
                Branch : out std_logic;
                AluSrc : out std_logic;
                RegDst : out std_logic;
                RegWrite : out std_logic;
                Jump : out std_logic;
                AluOp : out  std_logic_vector (1 downto 0)
            );
    end component;

    component mips is -- single cycle MIPS processor
        port (
                clk : in  std_logic;
                reset : in  std_logic;
                pc : out std_logic_vector (31 downto 0);
                instr : out  std_logic_vector (31 downto 0);
                dump : in std_logic
            );
    end component;

    component mux2 is -- two-input multiplexer
        generic(N : integer);
        port (
                d0 : in  std_logic_vector (N-1 downto 0);
                d1 : in  std_logic_vector (N-1 downto 0);
                s : in  std_logic;
                y : out std_logic_vector (N-1 downto 0)
            );
    end component;

    component regfile is
        port (
                clk : in std_logic;
                we3 : in std_logic;
                ra1 : in std_logic_vector (4 downto 0);
                ra2 : in std_logic_vector (4 downto 0);
                wa3 : in std_logic_vector (4 downto 0);
                wd3 : in std_logic_vector (31 downto 0);
                rd1 : out std_logic_vector (31 downto 0);
                rd2 : out std_logic_vector (31 downto 0)
            );
    end component;

    component signext is -- sign extender
        port (
                a : in std_logic_vector (15 downto 0);
                y : out std_logic_vector (31 downto 0)
            );
    end component;

    component sl2 is -- shift left by 2
        port (
                a : in std_logic_vector (31 downto 0);
                y : out std_logic_vector (31 downto 0)
            );
    end component;

end components;
