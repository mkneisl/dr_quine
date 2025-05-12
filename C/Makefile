NAME = Colleen Grace

CFLAGS=-Werror -Wall -Wextra
CC=clang

all: $(NAME)

%: %.c
	$(CC) $(CFLAGS) $< -o $@

$(NAME):

clean:
	rm -f $(NAME)

fclean:
	rm -f $(NAME)

re: fclean $(NAME)
