NAME = Colleen Grace Sully

CFLAGS=-Werror -Wall -Wextra
CC=clang

CDIFF=diff --old-group-format='- %<' --new-group-format='+ %>' --unchanged-group-format=''

COMPARE_DIFF=- int i = 5;\n+ int i = 0;\n- int i = 3;\n+ int i = 2;

define check_diff
	@if [ ! -s $(1)_diff ]; then \
		echo "[✅] $(1) OK"; \
	else \
		echo "[⚠️ ] $(1) KO diff:"; \
		cat $(1)_diff; \
	fi
endef

all: $(NAME)

%: %.c
	$(CC) $(CFLAGS) $< -o $@

$(NAME):

Colleen_diff: Colleen
	@./Colleen > Colleen_out.c
	@-diff Colleen.c Colleen_out.c > $@

Grace_diff: Grace
	@./Grace
	@-diff Grace.c Grace_kid.c > $@

Sully_diff: Sully
	@./Sully
	@-$(CDIFF) Sully.c Sully_0.c >> Sully_idiff
	@-$(CDIFF) Sully_3.c Sully_2.c >> Sully_idiff
	@echo "$(COMPARE_DIFF)" > Sully_compare
	@-diff Sully_idiff Sully_compare > Sully_diff

test: $(addsuffix _diff, $(NAME))
	@echo "[*] Checking output..."
	$(call check_diff,Colleen)
	$(call check_diff,Grace)
	$(call check_diff,Sully)

clean:
	rm -f $(addsuffix _*, $(NAME))

fclean: clean
	rm -f $(NAME)

re: fclean $(NAME)
