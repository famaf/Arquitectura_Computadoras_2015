all: run

run: mux2_tb
	ghdl -r mux2_tb --stop-time=50ns --vcd=mux2.vcd

mux2_tb: mux2 mux2_tb.vhd
	ghdl -a mux2_tb.vhd
	ghdl -e mux2_tb

mux2: mux2.vhd
	ghdl -a mux2.vhd

clean: 
	rm -rf mux2_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
