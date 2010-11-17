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
%x paren comment define arra str
%s codesection

%{
#define DEBUG 0
#define debug(...) if(DEBUG)printf(__VA_ARGS__)
#define MAX_STRING 8192
    int indent=0,lastindent=0;
    char *ss,last[2],endstr[MAX_STRING]="";
    void countIndent(void){
        int i=0,spaces=0,tabs=0;
        char *s=yytext;
        while(s[i]&&(s[i]==' '||s[i]=='\t')){
            if(s[i]=='\t')tabs++;
            if(s[i]==' ')spaces++;
            i++;
        }
        indent = spaces/4+tabs;
    }
    
    /* saner strcpy wrapper prevents comment buffer overflow */
    char *scat (char *dest, const char *src){
        int destlen,srclen,max;
        if(dest){
            destlen = strlen(dest);
            srclen = strlen(src);
            /* max characters will fit into string */
            max = MAX_STRING - destlen - 1;
            if (max > 0){ /* should never be negative, but j.i.c. */
                strncat(dest, src, max);
                dest[max] = '\0';
            }
        }return dest;
    }
%}

%%
    /* Buffer comments and things so we can scan in one pass */
    /* Confusing? We can "look ahead" by looking at */
    /* what has already been read into the buffer... */
^[\t ]*"/*"           {
                debug("C1");
                BEGIN(comment);
                strcat(endstr,yytext);
                debug("C2");
                }
<comment>"*/"   {
                BEGIN(codesection);
                strcat(endstr,yytext);strcat(endstr,"\n");
                debug("C5");
                }
<comment>[^*]+  strcat(endstr,yytext);
<comment>"*"[^/] strcat(endstr,yytext);
^[\t ]*"//".*$  {
                debug("C6");
                strcat(endstr,yytext);strcat(endstr,"\n");
                debug("C7");
                }
    
    /* pipe strings through so they don't interfere */
    /* testing rule from pinfo flex A.4.3 Quoted Constructs */
L?\"([^\"\\\n]|(\\['\"?\\abfnrtv])|(\\([0123456]{1,3}))|(\\x[[:xdigit:]]+)|(\\u([[:xdigit:]]{4}))|(\\U([[:xdigit:]]{8})))*\"    ECHO;
    /* old rule here */            
    /* \"                 ECHO;BEGIN(str);
    <str>\"           ECHO;BEGIN(INITIAL);
    <str>"\\"\"     printf("\\\"");
    <str>.          ECHO; */
                
    /* defines */
[\t ]*"#"  {
                debug("D1");
                printf("%s",endstr);ECHO;BEGIN(define);strcpy(endstr,"\n");
                }
<define>.*"\\"   ECHO;
<define>.*[^\\]$ { ECHO;BEGIN(codesection);
                //printf("%s",endstr);
                debug("D2");
                }

    /* enum fun */
^[\t ]*"enum"[ \t]  {
                debug("E1");
                /* printf("%s",endstr);
                yytext[4]='{';printf("%s}",yytext);strcpy(endstr,";\n"); */
                printf("%s",endstr);strcpy(endstr,";\n");
                ECHO;printf("{");
                yyless(strstr(yytext,"enum")-yytext+5);
                /* treat the rest of the enum like an array */
                BEGIN(arra);
                }

    /* put brackets around arrays */
[\t ]+[[:alnum:]_*]+[\t ]*(\[[^\]]*\])+[\t ]*[=].*[[:alnum:]_""''], {
                debug("A1");BEGIN(arra);
                yyless(0);
                }
<arra>=          ECHO;printf("{");
<arra>=" "       printf("={");
<arra>.          ECHO;
<arra>[^=, \t]"\n"    {
                /* eat \n */
                yytext[yyleng-1]='\0';
                printf("%s}",yytext);
                BEGIN(codesection); debug("A4");
                }
    
    
    /* add parens if 2 spaces found between text */
[[:alnum:]_\)]"  "[^=, \t] {
                debug("P1");
                yytext[2]='(';
                BEGIN(paren);
                /* look at the line again */
                yyless(0);
                }
    /* look down for a place to put ) */
<paren>[, \\]$ ECHO;
<paren>.        ECHO;
<paren>[^=, \t][\n]    {
                /* eat \n */
                yytext[yyleng-1]='\0';
                printf("%s)",yytext);strcpy(endstr,";\n");
                BEGIN(codesection); debug("P2");
                }

    /* strip blanks */
[\t ]*[\n]
    /* get last char */
.$              {strcpy(last,yytext);
                if(!strpbrk(yytext,";}")){
                    if (!strcmp(yytext,":"))
                        strcpy(endstr,"\n");
                    ECHO;
                }
                }

    /* indented code found. add { } */
^([\t]|[ ]{4})*[^ \t\n] %{
    
                /* Left indent */
                BEGIN(codesection); 
                countIndent();
                if(indent<lastindent){debug("L1");
                    if(strlen(endstr)<4)printf("%s ",endstr);
                    else printf("%c\n ",endstr[0]);
                    for(int i=1;i<indent;i++) printf("    ");
                    /* if(!strpbrk(yytext,"}")) */
                    for(int i=indent;i<lastindent;i++)
                        printf("   }");
                    /* print any stored comments */
                    if(strlen(endstr)>3){
                        printf("%s",endstr+1);
                    } else {
                        /* fixme: how to skip the next line? */
                        
                        if(yytext[yyleng-1]!='}') printf("\n");
                    }
                    if(yytext[yyleng-1]=='/')unput('/');
                    debug("L2");
                }
                
                /* Right indent */
                else if(indent>lastindent){ debug("R1");
                    if (!strpbrk(last,"{"))
                        for(int i=lastindent;i<indent;i++)
                            printf("{");
                    yyless(1);printf("\n");
                    if(strlen(endstr)>3)printf("%s",endstr+2);
                    debug("R2");
                    
                /* No indent */
                }else {debug("N1");
                    if (!strpbrk(last,"/,=!@#$%^&*}")){
                        printf("%s",endstr);
                    }else {debug("N2");
                        printf("\n");
                    }
                    if(!indent)printf("%c",yytext[strlen(yytext)-1]);
                    debug("N3");
                }
                
                yyless(1);
                if(indent)printf(" ");
                lastindent=indent;strcpy(endstr,";\n");
                %}

    /* function definition detected */
<codesection>^[[:alpha:]_]+   %{debug("B1");
                /* add ; endstr usually contains ";\n" */
                if(strlen(endstr)<4)printf("%s",endstr);
                else printf("%c",endstr[0]);
                if(indent>0){
                    indent=0;BEGIN(INITIAL);
                    printf("}");
                    for(int i=indent+1;i<lastindent;i++)
                        printf("   }");
                    printf("\n");
                    lastindent=0;
                }
                /* endstr>3 is a buffered comment. print it */
                if(strlen(endstr)>3)printf("%s",endstr+1);
                ECHO;
                strcpy(endstr,";\n");debug("B2");
                %}
       /* remove final spaces */
<codesection>^[\t ]+    debug("S1");
<codesection><<EOF>>   {debug("EOF");
                printf("%s}",endstr);
                for(int i=1;i<lastindent;i++)
                        printf("   }");
                printf("\n");BEGIN(INITIAL);
                }


%%
int main(int argc, char **argv ){
    ++argv, --argc;  /* skip over program name */
    if (argc > 0) yyin = fopen( argv[0], "r" );
    else yyin = stdin;
    yylex();
}
