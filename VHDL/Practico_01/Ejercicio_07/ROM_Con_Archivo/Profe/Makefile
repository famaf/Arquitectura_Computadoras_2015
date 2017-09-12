all: imem imem_tb

imem: imem.vhdl
	ghdl -a --ieee=synopsys imem.vhdl

imem_tb: imem_tb.vhdl
	ghdl -a imem_tb.vhdl
	ghdl -e --ieee=synopsys imem_tb
	ghdl -r imem_tb --stop-time=50ns --vcd=imem.vcd

clean:
	rm -f *_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
