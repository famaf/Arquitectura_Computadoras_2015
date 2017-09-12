all: run

run: dmem_tb
	ghdl -r dmem_tb --stop-time=50ns --vcd=dmem.vcd

dmem_tb: dmem dmem_tb.vhd
	ghdl -a dmem_tb.vhd
	ghdl -e dmem_tb

dmem: dmem.vhd
	ghdl -a dmem.vhd

clean: 
	rm -rf dmem_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
