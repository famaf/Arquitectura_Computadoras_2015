all: run

run: flopr_tb
	ghdl -r flopr_tb --stop-time=50ns --vcd=flopr.vcd

flopr_tb: flopr flopr_tb.vhd
	ghdl -a flopr_tb.vhd
	ghdl -e flopr_tb

flopr: flopr.vhd
	ghdl -a flopr.vhd

clean: 
	rm -rf flopr_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
