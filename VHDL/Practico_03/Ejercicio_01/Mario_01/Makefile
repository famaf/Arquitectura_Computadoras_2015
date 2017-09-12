all: run

run: controller_tb
	ghdl -r controller_tb --stop-time=110ns --vcd=controller.vcd

controller_tb: controller controller_tb.vhd
	ghdl -a controller_tb.vhd
	ghdl -e controller_tb

controller: comp mand alud controller.vhd
	ghdl -a controller.vhd

comp: components.vhd
	ghdl -a components.vhd

mand: maindec.vhd
	ghdl -a maindec.vhd

alud: aludec.vhd
	ghdl -a aludec.vhd

clean: 
	rm -rf controller_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
