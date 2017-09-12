all: run

run: regfile_tb
	ghdl -r regfile_tb --stop-time=50ns --vcd=regfile.vcd

regfile_tb: regfile regfile_tb.vhd
	ghdl -a regfile_tb.vhd
	ghdl -e regfile_tb

regfile: regfile.vhd
	ghdl -a regfile.vhd

clean: 
	rm -rf regfile_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
