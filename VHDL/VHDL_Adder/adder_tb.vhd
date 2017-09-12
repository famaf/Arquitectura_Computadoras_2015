library ieee;
use ieee.std_logic_1164.all;

--  Un testbench no tiene puertos.
entity adder_tb is
end adder_tb;
 
architecture behav of adder_tb is
    --  Declaración del componente que será instanciado.
    component adder is
    port (a, b : in std_logic;
          ci : in std_logic;
          s : out std_logic;
          co : out std_logic);
    end component;

    --  Especificamos que entidad está ligada con el componente.
    for adder_0: adder use entity work.adder;
    signal a_s, b_s, ci_s, s_s, co_s : std_logic;

    begin
      --  Instanciamos el componente.
      adder_0: adder port map (a => a_s, b => b_s, ci => ci_s, s => s_s, co => co_s);   
      --  Este process hace realmente el trabajo.
     process
         type pattern_type is record
           a, b, ci,s, co : std_logic;
         end record;
 
       --  Los patrones a aplicar.
         type pattern_array is array (natural range <>) of pattern_type;
         constant patterns : pattern_array :=(('0', '0', '0', '0', '0'), ('0', '0', '1', '1', '0'), ('0', '1', '0', '1', '0'), ('0', '1', '1', '0', '1'), ('1', '0', '0', '1', '0'),('1', '0', '1', '0', '1'), ('1', '1', '0', '0', '1'), ('1', '1', '1', '1', '1'));
         begin
             --  Chequeamos cada patrón.
             for i in patterns'range loop
                  --  Seteamos las entradas.
                    a_s <= patterns(i).a;
                    b_s <= patterns(i).b;
                    ci_s <= patterns(i).ci;
                    --  Esperamos por los resultados.
                    wait for 1 ns;
                    --  Chequeamos las salidas.
                    assert s_s = patterns(i).s
                        report "resultado de la suma erróneo" severity error;
                   assert co_s = patterns(i).co
                        report "acarreo de salida erróneo" severity error;
              end loop;
              assert false report "fin del test" severity note;
              --  Esperamos por siempre; esto terminará la simulación.
              wait;
       end process;
  end behav;
