all: run

run:
	ghdl -a --ieee=synopsys datapath.vhd
	ghdl -a --ieee=synopsys controller.vhd
	ghdl -a --ieee=synopsys mips.vhd

clean:
	rm -rf mips_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
