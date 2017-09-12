all: run

run: MIPS_TB
	ghdl -r mips_tb --stop-time=360ns --vcd=mips.vcd

MIPS_TB: MIPS
	ghdl -a --ieee=synopsys mips_tb.vhd 
	ghdl -e --ieee=synopsys mips_tb

MIPS: ETAPAS REGISTROS
	ghdl -a --ieee=synopsys mips.vhd

ETAPAS: COMPONENTES
	ghdl -a --ieee=synopsys fetch.vhd
	ghdl -a --ieee=synopsys decode.vhd
	ghdl -a --ieee=synopsys execute.vhd
	ghdl -a --ieee=synopsys memory.vhd
	ghdl -a --ieee=synopsys writeback.vhd

REGISTROS:
	ghdl -a --ieee=synopsys fetch_to_decode.vhd
	ghdl -a --ieee=synopsys decode_to_execute.vhd
	ghdl -a --ieee=synopsys execute_to_memory.vhd
	ghdl -a --ieee=synopsys memory_to_writeback.vhd

COMPONENTES: PAQUETE
	ghdl -a --ieee=synopsys adder.vhd
	ghdl -a --ieee=synopsys flopr.vhd
	ghdl -a --ieee=synopsys flopr1.vhd
	ghdl -a --ieee=synopsys flopr3.vhd
	ghdl -a --ieee=synopsys flopr5.vhd
	ghdl -a --ieee=synopsys mux2.vhd
	ghdl -a --ieee=synopsys mux2_5b.vhd
	ghdl -a --ieee=synopsys sl2.vhd
	ghdl -a --ieee=synopsys signext.vhd
	ghdl -a --ieee=synopsys alu.vhd
	ghdl -a --ieee=synopsys imem.vhd
	ghdl -a --ieee=synopsys dmem.vhd
	ghdl -a --ieee=synopsys aludec.vhd
	ghdl -a --ieee=synopsys regfile.vhd
	ghdl -a --ieee=synopsys maindec.vhd
	ghdl -a --ieee=synopsys controller.vhd

PAQUETE:
	ghdl -a components.vhd

clean: 
	rm -f *_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
	rm -rf DUMP_FILE.txt

signal:
	gtkwave mips.vcd
