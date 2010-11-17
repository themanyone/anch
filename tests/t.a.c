#!/usr/local/bin/anch -run
/* This will run as a bash script if TCC and Anchor is installed */

#include <stdio.h>
/* Print command line arguments and exit. */
int main  int c, char **v
    while  c--
        printf  "Argument %i is \"%s\"\n",c,v[c]
    return 0
