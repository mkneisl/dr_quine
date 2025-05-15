NAME = Sully Colleen Grace

OS_NAME = $(shell uname -s)

all: $(NAME)

%: %.s
ifeq ($(OS_NAME), Darwin)
	nasm -f macho64 $< -o $@.o
	ld -static -e main -o $@ $@.o
else ifeq ($(OS_NAME), Linux)
	nasm -f elf64 $< -o $@.o
	ld -e main -o $@ $@.o
else
	@echo "[ERROR]: Unsupported OS!"
	@exit 1
endif
	rm -f $@.o

$(NAME):

clean:
	rm -f $(addsuffix _*, $(NAME))

fclean: clean
	rm -f $(NAME)

re: fclean $(NAME)
