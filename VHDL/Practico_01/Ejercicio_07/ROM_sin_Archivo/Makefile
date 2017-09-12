all: run

run: imem_tb
	ghdl -r imem_tb --stop-time=100ns --vcd=imem.vcd

imem_tb: imem imem_tb.vhd
	ghdl -a imem_tb.vhd
	ghdl -e imem_tb

imem: imem.vhd
	ghdl -a imem.vhd

clean: 
	rm -rf imem_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
