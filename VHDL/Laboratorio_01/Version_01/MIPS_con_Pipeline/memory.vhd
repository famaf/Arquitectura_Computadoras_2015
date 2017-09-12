library ieee;
use ieee.std_logic_1164.all;


entity memory is
    port (
            -- ENTRADAS
            clk : in std_logic;
            dump : in std_logic;
            MemWrite : in std_logic;
            Branch : in std_logic;
            AluOutM : in std_logic_vector (31 DOWNTO 0);
            ZeroM : in std_logic;
            WriteDataM : in std_logic_vector (31 DOWNTO 0);
            -- SALIDAS
            ReadDataM : out std_logic_vector (31 DOWNTO 0);
            PCSrcM : out std_logic;
            -- PUERTOS AUXILIARES DE IN/OUT (ES UN CABLE)
            WriteRegM_in : in std_logic_vector (4 DOWNTO 0);
            WriteRegM_out : out std_logic_vector (4 DOWNTO 0)
        );
end memory;


architecture structure of memory is

    component comp_and is
        port (
                input_1 : in std_logic;
                input_2 : in std_logic;
                output_and : out std_logic
            );
    end component;

    component dmem is
        port(
                clk : in std_logic;
                we : in std_logic;
                a : in std_logic_vector (31 DOWNTO 0);
                wd : in std_logic_vector (31 DOWNTO 0);
                dump : in std_logic;
                rd : out std_logic_vector (31 DOWNTO 0)
            );
    end component;

begin

    dmem_0: dmem port map (
                            clk => clk,
                            we => MemWrite,
                            a => AluOutM,
                            wd => WriteDataM,
                            dump => dump,
                            rd => ReadDataM
                        );

    compuerta: comp_and port map (
                                    input_1 => Branch,
                                    input_2 => ZeroM,
                                    output_and => PCSrcM
                                );

 -- CONEXION DEL CABLE
    WriteRegM_out <= WriteRegM_in;

end structure;
