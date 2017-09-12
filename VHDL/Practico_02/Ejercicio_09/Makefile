all: run

run: aludec_tb
	ghdl -r aludec_tb --stop-time=80ns --vcd=aludec.vcd

aludec_tb: aludec aludec_tb.vhd
	ghdl -a aludec_tb.vhd
	ghdl -e aludec_tb

aludec: aludec.vhd
	ghdl -a aludec.vhd

clean: 
	rm -rf aludec_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
