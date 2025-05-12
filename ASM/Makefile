NAME = Colleen Grace

OS_NAME = $(shell uname -s)

all: $(NAME)

%: %.s
ifeq ($(OS_NAME), Darwin)
	nasm -f macho64 $< -o $@
else ifeq ($(OS_NAME), Linux)
	nasm -f elf64 $< -o $@.o
else
	@echo "[ERROR]: Unsupported OS!"
	@exit 1
endif
	ld -e main -o $@ $@.o
	rm -f $@.o
$(NAME):

test:


clean:

fclean:
	rm -f $(NAME)

re: fclean $(NAME)
