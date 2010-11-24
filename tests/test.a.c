/* #!/usr/local/bin/anch -run */
/* uncomment the above line to make "executable source" */
/* test.a.c is hereby released into the Public Domain
 *
 * This program can be compiled by anch
 * and your regular compiler like so:
 *
 * anch gcc test.a.c -o test
 
    This should be ignored by the parser.
        puts  "hi"
    while  0
 */
/* These defines shouldn't be touched  */
#include <stdio.h>
#define test_define(x) printf( \
    "x%s\n",x)
/* This enum will have brackets {} put around it */
enum bacon, cheese, bread,
lettuce, onions
/* like this one */
enum{food,drink};
int flav
/* automatically fixes missing semicolons and brackets */
struct foo
    int a
    int b;
*foo
char shifted[] = "~!@#$%^&*()_+|\":?><ABCDEFGHIJKLMNOPQRSTUVWXYZ"
/* Now automatically encloses these arrays in brackets { } */
char pig[6]= 'b','a','c','o','n',0
char fool[] ='2', '0', '1', '0', ' ', 'H', 'e', 'n', 'r', 'y', ' ', 'K', 'r', 'o', 'l', 'l',
    ' ', 'I', 'I', 'I', '\n', ' ', ' ', ' ', ' ', ' ', ' ', 'w', 'w', 'w', '.', 'T', 'h', 'e',
    'N', 'e', 'r', 'd', 'S', 'h', 'o', 'w', '.', 'c', 'o', 'm', 0
void test_func  int val
    int i,j
    struct bar
        int a;
        int b
    bar = {5,4} 
#ifndef nothing
    for  i=5;i--;
        for  j=5;j--;
            printf  "test "
        printf  "\n"
    printf  "struct test %i %i\n" 
        "be //careful {/* with *//*); \"this string\"",bar.a,bar.b
#endif
    goto inzx
    do
inzx:   printf("\n%s\n",fool);
    while  0

/* This should be ignored
 */
int main  int argc,
    char **argv
    int i
    char name[]="Anchor"
    printf  "%s is C.\n",name
    /* nice */
    for  i=5;i--;
    /* Can we put a comment inside the loop? */
        printf  "%i\n",i
    
                        /* How about here? */
    test_func  1
    printf  "done!\n"
    return 0
    /* and we're done! */
    