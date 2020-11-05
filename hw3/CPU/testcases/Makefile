run:
	riscv64-unknown-elf-g++ -o generate generate.cpp generate.s

test:  
	spike pk generate

clean:
	rm -f generate
