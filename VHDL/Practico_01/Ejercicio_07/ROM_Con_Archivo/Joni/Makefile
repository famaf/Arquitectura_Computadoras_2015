all: run

run: rom_tb
	ghdl -r rom_tb --stop-time=50ns --vcd=rom.vcd

rom_tb: rom rom_tb.vhd
	ghdl -a rom_tb.vhd
	ghdl -e rom_tb

rom: rom.vhd
	ghdl -a rom.vhd

clean: 
	rm -rf rom_tb
	rm -rf *.o
	rm -rf *.cf
	rm -rf *.vcd
