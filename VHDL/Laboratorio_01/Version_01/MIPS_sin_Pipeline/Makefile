all: run

run: MIPS_tb
	ghdl -r mips_tb --stop-time=500ns --vcd=mips.vcd

MIPS_tb: MIPS mips_tb.vhd
	ghdl -a --ieee=synopsys -fexplicit mips_tb.vhd
	ghdl -e --ieee=synopsys mips_tb

MIPS: CONTROLLER DATAPATH
	ghdl -a --ieee=synopsys -fexplicit mips.vhd

CONTROLLER:
	ghdl -a --ieee=synopsys -fexplicit aludec.vhd
	ghdl -a --ieee=synopsys -fexplicit maindec.vhd
	ghdl -a --ieee=synopsys -fexplicit controller.vhd

DATAPATH:
	ghdl -a --ieee=synopsys -fexplicit adder.vhd
	ghdl -a --ieee=synopsys -fexplicit alu.vhd
	ghdl -a --ieee=synopsys -fexplicit dmem.vhd
	ghdl -a --ieee=synopsys -fexplicit imem.vhd
	ghdl -a --ieee=synopsys -fexplicit flopr.vhd
	ghdl -a --ieee=synopsys -fexplicit mux2.vhd
	ghdl -a --ieee=synopsys -fexplicit regfile.vhd
	ghdl -a --ieee=synopsys -fexplicit signext.vhd
	ghdl -a --ieee=synopsys -fexplicit sl2.vhd
	ghdl -a --ieee=synopsys -fexplicit datapath.vhd

clean:
	rm -rf mips_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
