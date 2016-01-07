# Enum Declaration #

There is nothing special about declaring enums. The file, tests/test.anch shows several examples that work.

```
/* This enum will have brackets {} put around it */
enum food bacon, cheese, bread,
lettuce, onions
/* like this one */
enum iLike {food,drink};
/* declare variable of type enum iLike */
enum iLike asdf = drink

```

## As Typedef ##

The preferred way to declare an enum is with a typedef. Here we declare a type, "do\_what" that we use to pass methods to AppClass. This is the functional class pattern of object-oriented C that the author uses in some projects.

```
typedef enum app_func
    INIT,
    QUIT
do_what

static int AppClass(do_what func)
    switch  func
        case INIT:
            puts  "Init called.\n"
            break
        case QUIT:
            puts  "Quit called.\n"
            break

int main  int argc, char **argv
    AppClass  INIT
    AppClass  QUIT
    return 0
```