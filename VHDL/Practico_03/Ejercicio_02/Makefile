all: run

run:
	ghdl -a --ieee=synopsys mux2.vhd
	ghdl -a --ieee=synopsys flopr.vhd
	ghdl -a --ieee=synopsys imem.vhd
	ghdl -a --ieee=synopsys adder.vhd
	ghdl -a --ieee=synopsys regfile.vhd
	ghdl -a --ieee=synopsys signext.vhd
	ghdl -a --ieee=synopsys sl2.vhd
	ghdl -a --ieee=synopsys alu.vhd
	ghdl -a --ieee=synopsys dmem.vhd
	ghdl -a --ieee=synopsys datapath.vhd

clean:
	rm -rf datapath_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
