all: run

run: maindec_tb
	ghdl -r maindec_tb --stop-time=70ns --vcd=maindec.vcd

maindec_tb: maindec maindec_tb.vhd
	ghdl -a maindec_tb.vhd
	ghdl -e maindec_tb

maindec: maindec.vhd
	ghdl -a maindec.vhd

clean: 
	rm -rf maindec_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
