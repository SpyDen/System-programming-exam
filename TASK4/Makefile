main: main.o
	ld -m elf_i386 -s -o main main.o
main.o: main.asm
	nasm -f elf main.asm
clean:
	rm *.o main