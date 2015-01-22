NAME=anchor
BUILD=anchor unanchor
DOCDIR=/usr/share/$(NAME)
INSTALLDIR=/usr/local/bin

CFLAGS=-std=c99
ifneq (,$(findstring mingw,$(CC)))
	EXT=.exe
endif
TARGETS=$(foreach a,$(BUILD),$a$(EXT))
LEX=flex

%.o : %.c clean
	$(CC) $(CFLAGS) -c $< -o "$@"

%$(EXT) : %.o
	$(CC) $< -o "$@"

test: $(TARGETS)

s:
	scite Makefile README.asp *.l&

install:
	install -D README "$(DOCDIR)/README"
	install -D COPYING "$(DOCDIR)/COPYING"
	install -D "$(NAME)" "$(INSTALLDIR)/$(NAME)"
	install -D anch "un$(NAME)" "$(INSTALLDIR)/"

uninstall:
	$(RM) "$(DOCDIR)/*"
	$(RM) "$(INSTALLDIR)/$(NAME)"
	$(RM) "$(INSTALLDIR)/anch"
	$(RM) "$(INSTALLDIR)/un$(NAME)"

clean:
	$(RM) $(BUILD) $(LINK)

example:
	@./anchor tests/example.anch | $(CC) -xc -o example -
	@./example
	@$(RM) example

html:	     
	links -dump README.asp > README
	cp -l README.asp $(NAME).html
