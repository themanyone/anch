/* Anchor
 *
 * Copyright (C) 2010 by Henry Kroll III, henry@anch.org
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
%option noyywrap
%option never-interactive
%x paren comment define

%{
#include <errno.h>
#define DEBUG 0
#define debug(...) if(DEBUG)printf(__VA_ARGS__)
#define MAX_STRING 8192
    int i;
    char *p;
    /* suppress some flex warnings */
    FILE *popen(const char *command, const char *type);
    int pclose(FILE *stream);
%}

%%
    /* pipe strings through using */
    /* rule from pinfo flex A.4.3 Quoted Constructs */
L?\"([^\"\\\n]|(\\['\"?\\abfnrtv])|(\\([0123456]{1,3}))|(\\x[[:xdigit:]]+)|(\\u([[:xdigit:]]{4}))|(\\U([[:xdigit:]]{8})))*\"  {
                debug("S");
                ECHO;debug("S");
}

    /* ignore comments */
"/*"            { debug("C0");
                ECHO;BEGIN(comment);
                }
<comment>"*/"   {
                ECHO;BEGIN(INITIAL);debug("C1");
                }
<comment>[^*]+  ECHO;
<comment>"*"[^/] ECHO;
^[\t ]*"//".*$  ECHO;
    
                /* ignore defines */
^[\t ]*"#"      {
                ECHO;BEGIN(define);debug("D0");
                }
<define>.*$     {
                ECHO;BEGIN(INITIAL);debug("D2");
                }
<define>.*"\\"  {
    ECHO;debug("D1");
}

                /* strip brackets */
" {"            ;
"} "            ;
[\t ]*"}"       ;
"{"$            ;

                /* strip semicolons */
";"             ;

                /* conservatively remove parenthesis */
^[\t ]*[[:alnum:]_\) ]+"("[\t ]* { debug("P0");
                p = strchr(yytext,'(');
                for (;--p;)
                    /* remove extra spaces around '(' */
                    if (*p!=' '){
                        ++p;break;
                    }
                /* replace '(' with two spaces */
                *p = 0; printf("%s  ",yytext); *p=' ';
                BEGIN(paren);
                }
<paren>")"[\t ;{]*$ BEGIN(INITIAL);debug("P1");
<paren>.        ECHO;

%%
int main(int argc, char **argv ){
    ++argv, --argc;  /* skip over self name */
    char *s;
    if (argc > 0){ /* c allows us to read 1 past end of array */
        if ((!strcmp(argv[0],"-indent") || !strcmp(argv[0],"-i"))
            && argv[1]){
            s = malloc(strlen(argv[1])+99);
            sprintf(s,"indent \"%s\" -linux -i 4 -nut -bls -brf -cli4 -st",argv[1]);
            yyin = popen(s, "r" );free(s);
        } else if (argv[0][0]!='-') {
            yyin = fopen(argv[0],"r");
            if (!yyin) { perror("fopen");
                exit (1);
            }
        } else {
            printf("Usage: unanchor [-i | -indent] file\n");
            printf("The -indent option requires GNU indent\n");
            printf("exists somewhere in $PATH.\n");
            return 1;
        }
    }
    else yyin = stdin;
    yylex();
    if (argc > 0) pclose (yyin);
}
