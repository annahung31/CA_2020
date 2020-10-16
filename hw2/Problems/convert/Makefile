run:
	riscv64-unknown-elf-gcc -o convert convert.c convert.s
test:
	spike pk ./convert < input
clean:
	rm -f convert

