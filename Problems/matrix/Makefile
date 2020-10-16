run:
	riscv64-unknown-elf-gcc -O3 -o matrix matrix.c matrix.s
test:
	spike pk ./matrix
clean:
	rm -f matrix

