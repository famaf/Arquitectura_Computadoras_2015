all: run

run: sl2_tb
	ghdl -r sl2_tb --stop-time=50ns --vcd=sl2.vcd

sl2_tb: sl2 sl2_tb.vhd
	ghdl -a sl2_tb.vhd
	ghdl -e sl2_tb

sl2: sl2.vhd
	ghdl -a sl2.vhd

clean: 
	rm -rf sl2_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
