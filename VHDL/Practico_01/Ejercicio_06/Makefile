all: run

run: alu_tb
	ghdl -r alu_tb --stop-time=100ns --vcd=alu.vcd

alu_tb: alu alu_tb.vhd
	ghdl -a alu_tb.vhd
	ghdl -e alu_tb

alu: alu.vhd
	ghdl -a alu.vhd

clean: 
	rm -rf alu_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
