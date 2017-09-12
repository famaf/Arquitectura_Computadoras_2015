all: run

run: controller_tb
	ghdl -r controller_tb --stop-time=110ns --vcd=controller.vcd

controller_tb: controller controller_tb.vhd
	ghdl -a controller_tb.vhd
	ghdl -e controller_tb

controller: controller.vhd maindec.vhd aludec.vhd
	ghdl -a controller.vhd
	ghdl -a maindec.vhd
	ghdl -a aludec.vhd

clean:
	rm -rf controller_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
