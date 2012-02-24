NAME=anchor
INCLUDES=-I.
DOCDIR=/usr/share/$(NAME)
INSTALLDIR=/usr/local/bin
LDFLAGS=
BUILD=anchor.o
CFLAGS=-std=c99
MINGW=/usr/bin/i686-pc-mingw32-gcc
EXE=.exe
LEX=flex

%.o : %.c clean
	$(CC) $(CFLAGS) -c $< -o "$@" $(INCLUDES)

test: $(BUILD) un$(BUILD)
	$(CC) "$(BUILD)" -o "$(NAME)$(EXT)" $(LDFLAGS)
	$(CC) "un$(BUILD)" -o "un$(NAME)$(EXT)" $(LDFLAGS)

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
	$(RM) "$(BUILD)" "un$(BUILD)" "$(NAME)" "un$(NAME)"
	$(RM) tmp.* lex* *.o
	$(RM) example

win:
	$(MAKE) CC=$(MINGW) EXT=$(EXE)

example:
	@./anchor tests/example.anch | $(CC) -xc -o example -
	@./example
	@$(RM) example

html:	     
	links -dump README.asp > README
	cp -l README.asp $(NAME).html

