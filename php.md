# PHP #

A PHP test has been added. You can now run PHP scripts with anchor. For information on using Anchor with the C language, please visit the [web site](http://anch.org/anchor.html).

On Linux, code may be run right from the terminal without saving any files. Just copy and paste:

```
anchor <<"EOF"|php -a
for  $i = 3; $i--;
    printf  "outer loop $i\n"
    for  $x = 0;$x < 3; $x++
        printf("    inner loop $x\n");
EOF
```

The above code will also run as a perl script.

# Details #

The above is what's known as a [here document](http://tldp.org/LDP/abs/html/here-docs.html).

The same code could be run on Windows by saving the part between for... and not including EOF to a file and then running anchor on it before running php on it:

```
anchor file > file.php
php -r file.php
```