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
    int i,indent=0,lastindent=0,pull=0,drop=0,tabs=0,chain=0;
    char *ss,last[2],endstr[MAX_STRING+1]="";

    /* count indents ignoring labels */
    void countIndent(void){
        int i=0,spaces=0,tabs=0,label=1;
        char *s=yytext;
        while(s[i]&&(s[i]==' '||s[i]=='\t'||label)){
            if(s[i]==' '||s[i]=='\t')label=0;
            else spaces++;
            if(s[i]=='\t')tabs++;
            if(s[i]==' ')spaces++;
            i++;
        }
        indent = spaces/4+tabs;
    }
    
    /* saner strcpy wrapper prevents comment buffer overflow */
    char *scat (char *dest, const char *src){
        int destlen,srclen,max;
        if(dest&&src){
            destlen = strlen(dest);
            srclen = strlen(src);
            /* max characters will fit into string */
            max = MAX_STRING - srclen;
            if (max > 0){
                strncat(dest, src, max);
                dest[max] = '\0';
            } else {
                fprintf(stderr,"Error: Comment length > 8K exceeded.\n");
                if (strstr(dest,"/*")){
                    dest[MAX_STRING-2]='*';
                    dest[MAX_STRING-1]='/';
                    dest[MAX_STRING] = '\0';
                }
            }
        }return dest;
    }
%}

%%
    /* Buffer comments and things so we can scan in one pass */
    /* Confusing? We can "look ahead" by looking at */
    /* what has already been read into the buffer... */
^[\t ]*"/*"     {
                debug("C1");
                BEGIN(comment);
                scat(endstr,yytext);
                debug("C2");
                }
<comment>"*/"   {
                BEGIN(codesection);
                scat(endstr,yytext);scat(endstr,"\n");
                debug("C5");
                }
<comment>[^*]+  scat(endstr,yytext);
<comment>"*"[^/] scat(endstr,yytext);
^[\t ]*"//".*$  {
                debug("C6");
                scat(endstr,yytext);scat(endstr,"\n");
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
[\t ]*"#"       {
                debug("D1");
                printf("%s",endstr);
                ECHO;
                BEGIN(define);strcpy(endstr,"\n");
                }
<define>.*"\\"   ECHO;
<define>.*[^\\]$ { ECHO;BEGIN(codesection);
                //printf("%s",endstr);
                debug("D2");
                }

    /* enum fun */
^[\t ]*"enum"[ \t]+[[:alpha:]_]  {
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
[\t ]+[[:alnum:]_*]+[\t ]*(\[[^\]]*\])+[\t ]*[=][^{;\n]*,[^{;\n]*, {
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
^([[:alnum:]]+:){0,1}[\t ]+[^ \t\n] %{
                BEGIN(codesection); 
                countIndent();
    
                /* Left indent */
                if(indent<lastindent){debug("L1");
                    if(strlen(endstr)<4)printf("%s ",endstr);
                    else printf("%c\n%s",endstr[0],tabs?"":" ");
                    if(!strpbrk(yytext,"}")||pull){
                        for(i=1;i<indent;i++) printf("%s",tabs?"\t":"    ");
                        for(i=indent;i<lastindent;i++)
                            printf("%s",tabs?"\t}":"   }");
                    }
                    /* print any stored comments */
                    if(strlen(endstr)>3){
                        printf("%s",endstr+1);
                    } else {
                        if (pull) chain = 1;
                        else printf("\n");
                    }
                    debug("L2");
                }
                
                /* Right indent */
                else if(indent>lastindent){ debug("R1");
                    if (!strpbrk(last,"{")){
                        if(drop){
                            printf("\n");
                            for(i=1;i<indent;i++)
                                printf("%s",tabs?"\t":"    ");
                        } for(i=lastindent;i<indent;i++)
                            printf("{");
                    }
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
                    if(!indent)printf("%c",yytext[yyleng-1]);
                    debug("N3");
                }
                /* pull up next line } after brace? */
                if(chain){
                    yyless(strspn(yytext,"\t "));
                    chain=0;
                } else yyless(1);
                
                if(indent)printf("%c",yytext[0]);
                lastindent=indent;strcpy(endstr,";\n");
                %}

    /* function definition detected */
<codesection>^[[:alpha:]_*]+   %{debug("B1");
                /* endstr contains ";\n" or ";\n comment \n" */
                int has_comment=(strlen(endstr)>3);
                if (has_comment) printf("%c%c",endstr[0],endstr[1]);
                else printf("%s",endstr);
                if(indent>0){
                    indent=0;
                    printf("}");
                    for(i=indent+1;i<lastindent;i++)
                        printf("%s",tabs?"\t}":"   }");
                    if((!pull)||has_comment)printf("\n");
                    else printf(" ");
                    lastindent=0;
                }
                /* print comments */
                if(has_comment) printf("%s",endstr+2);
                /* print type */
                printf("%s",yytext);
                strcpy(endstr,";\n");debug("B2");
                %}
       /* remove final spaces */
<codesection>^[\t ]+    debug("S1");
<codesection><<EOF>>   {debug("EOF");
                printf("%s}",endstr);
                for(i=1;i<lastindent;i++)
                         printf("%s",tabs?"\t}":"   }");
                printf("\n");BEGIN(INITIAL);
                }

%%
void intro(){
    fprintf (stderr,"Anchor (C) 2010 Henry Kroll www.anch.org\n");
    fprintf (stderr,"See anchor -h for help.\n\n");
}
void help(){ printf(
"Usage: anchor [options] file\n"
"-pull  | -p  Pull up code after closing brace.\n"
"-drop  | -d  Drop braces down, expanding listing.\n"
"-quiet | -q  Suppress informational messages.\n"
"-tabs  | -t  Use tabs. Does not convert spaces.\n\n"

"Other uses:\n"
"   Pipe code through anchor to a file...\n"
"   cat tests/test.a.c | anchor > test_out.c\n"
"   ...or to a compiler that supports reading from pipes:\n"
"   cat tests/test.a.c | anchor -q | tcc -run -\n\n"

"Type 'more README' for additional suggestions.\n");
}
#define HAS(a) strstr(argv[argc],#a)
int main(int argc, char **argv ){
    char *fname=NULL;
    int loud=1;
    if (argc > 1){ /* parse command line options */
        for (--argc;argc;argc--){
            if (argv[argc][0]=='-'){
                if (HAS(p)&&!HAS(drop)) pull = 1;
                if (HAS(q)) loud = 0;
                if (HAS(d)) drop = 1;
                if (HAS(t)) tabs = 1;
                if (!(pull|drop|tabs|!loud)) {
                    help();
                    return 0;
                }
            } else fname = argv[argc];
        } if (loud) intro();
        if (!fname)goto instd;
        yyin = fopen(fname,"r");
        if (!yyin) { perror("fopen");
            exit (1);
        }
    } else {
instd:  if(loud){ intro();
            fprintf (stderr,
            "No file specified. Reading stdin... Press CTRL-C to cancel.\n");
        }
        yyin = stdin;
    }
    yylex();
}
