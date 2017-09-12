all: imem imem_tb

imem: imem.vhd
	ghdl -a --ieee=synopsys imem.vhd

imem_tb: imem_tb.vhd
	ghdl -a imem_tb.vhd
	ghdl -e --ieee=synopsys imem_tb
	ghdl -r imem_tb --stop-time=50ns --vcd=imem.vcd

clean:
	rm -f *_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
