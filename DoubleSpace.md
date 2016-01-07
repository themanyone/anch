Parenthesis shall open and _close_ whenever **two consecutive spaces** are encountered or until the end of a line that _does not_ end in any of the characters `"/,=!@#$%^&*}\\ "`.

---

```
void myFunc{space}{space}
```
becomes
```
void myFunc () {
```

This however does not work:
```
int main void
```

There needs to be **2 spaces** between 'main' and 'void'!

This also works:
```
if  j==4  printf  "Hi!"
```
becomes
```
if (j==4)printf ("Hi!");
```

Tricks:

Using any of the characters `"/,=!@#$%^&*}\\ "` at the end of a line will cause ')' to be put further down:

```
/* before */
printf  "Hello "{space}
        "World!"
/* after */
printf ("Hello " 
        "World!");
```

If extra () are appearing in your code you probably have "double spaces in odd places."