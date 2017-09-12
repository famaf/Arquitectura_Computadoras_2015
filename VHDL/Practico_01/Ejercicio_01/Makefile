all: run

run: adder_tb
	ghdl -r adder_tb --stop-time=50ns --vcd=adder.vcd

adder_tb: adder adder_tb.vhd
	ghdl -a adder_tb.vhd
	ghdl -e adder_tb

adder: adder.vhd
	ghdl -a adder.vhd

clean: 
	rm -rf adder_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
