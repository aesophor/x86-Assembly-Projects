ASSEMBLER=nasm
ASSEMBLER_FLAGS=-f elf64
BIN=add_two_sum
SRC=add_two_sum.asm

all:
	$(ASSEMBLER) $(ASSEMBLER_FLAGS) -o $(BIN).o $(SRC) && ld -o $(BIN) $(BIN).o

clean:
	rm $(BIN) $(BIN).o
