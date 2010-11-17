NAME=anchor
#EXT=.exe
INCLUDES=-I.
DOCDIR=/usr/share/$(NAME)
INSTALLDIR=/usr/local/bin
LDFLAGS=
BUILD=anchor.o
CFLAGS=-std=c99
#CC=/usr/bin/i686-pc-mingw32-gcc
LEX=flex

%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@ $(INCLUDES)

test: $(BUILD)
	$(CC) $(BUILD) -o $(NAME)$(EXT) $(LDFLAGS)

s:
	scite Makefile README.asp *.l&
	
install:
	install -D README "$(DOCDIR)/README"
	install -D COPYING "$(DOCDIR)/COPYING"
	install -D $(NAME) "$(INSTALLDIR)/$(NAME)"
	install -D anch unanchor $(INSTALLDIR)/
	
uninstall:
	$(RM) "$(DOCDIR)/*"
	$(RM) "$(INSTALLDIR)/$(NAME)"
	$(RM) "$(INSTALLDIR)/anch"
	$(RM) "$(INSTALLDIR)/unanchor"

clean:
	$(RM) "$(BUILD)" "$(NAME)"
	$(RM) tmp.* lex* *.o
	$(RM) example

example:
	./pycc gcc tests/example.a.c -o example

html:	     
	links -dump README.asp > README
	cp -l README.asp $(NAME).html
