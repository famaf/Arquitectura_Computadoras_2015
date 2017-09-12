all: run

run: MIPS_tb
	ghdl -r mips_tb --stop-time=500ns --vcd=mips.vcd

MIPS_tb: MIPS mips_tb.vhd
	ghdl -a --ieee=synopsys -fexplicit mips_tb.vhd
	ghdl -e --ieee=synopsys -fexplicit mips_tb

MIPS: COMPONENTES REGISTROS
	ghdl -a --ieee=synopsys -fexplicit mips.vhd

REGISTROS:
	ghdl -a --ieee=synopsys -fexplicit fetch_to_dec.vhd
	ghdl -a --ieee=synopsys -fexplicit dec_to_ex.vhd
	ghdl -a --ieee=synopsys -fexplicit ex_to_mem.vhd
	ghdl -a --ieee=synopsys -fexplicit mem_to_wb.vhd

COMPONENTES: SUBCOMPONENTES
	ghdl -a --ieee=synopsys -fexplicit fetch.vhd
	ghdl -a --ieee=synopsys -fexplicit decode.vhd
	ghdl -a --ieee=synopsys -fexplicit execute.vhd
	ghdl -a --ieee=synopsys -fexplicit memory.vhd
	ghdl -a --ieee=synopsys -fexplicit writeback.vhd

SUBCOMPONENTES:
	ghdl -a --ieee=synopsys -fexplicit comp_and.vhd
	ghdl -a --ieee=synopsys -fexplicit adder.vhd
	ghdl -a --ieee=synopsys -fexplicit flopr.vhd
	ghdl -a --ieee=synopsys -fexplicit mux2.vhd
	ghdl -a --ieee=synopsys -fexplicit sl2.vhd
	ghdl -a --ieee=synopsys -fexplicit signext.vhd
	ghdl -a --ieee=synopsys -fexplicit alu.vhd
	ghdl -a --ieee=synopsys -fexplicit imem.vhd
	ghdl -a --ieee=synopsys -fexplicit dmem.vhd
	ghdl -a --ieee=synopsys -fexplicit aludec.vhd
	ghdl -a --ieee=synopsys -fexplicit regfile.vhd
	ghdl -a --ieee=synopsys -fexplicit maindec.vhd
	ghdl -a --ieee=synopsys -fexplicit controller.vhd

clean:
	rm -rf mips_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
	rm -rf DUMP_FILE.txt

wire:
	gtkwave mips.vcd