#include <unistd.h>
#include <stdio.h>
#define NL "\n"

/*
 This program will print its own source when run.
*/

void doStuff();

char* str = "#include <unistd.h>" NL
"#include <stdio.h>" NL
"#define NL \"\\n\"" NL
"" NL
"/*" NL
" This program will print its own source when run." NL
"*/" NL
"" NL
"void doStuff();" NL
"" NL
"char* str = \"%s\"" NL
"" NL
"int main()" NL
"{" NL
"    doStuff();" NL
"    /*" NL
"        Print the programm" NL
"    */" NL
"    printf(str, str);" NL
"    return  0;" NL
"}" NL
"" NL
"void doStuff()" NL
"{" NL
"    int i = 0;" NL
"" NL
"    i += 2;" NL
"    if (i < 1)" NL
"        return;" NL
"    return;" NL
"}" NL;


// char* str = R"(
// #include <unistd.h>
// #include <stdio.h>

// /*
//  This program will print its own source when run.
// */

// void doStuff();

// char* str = R"%s(%s)%s";

// int main()
// {
//     doStuff();
//     /*
//         Print the programm
//     */
//     printf(str, "", str, "", '\n');
//     return  0;
// }

// void doStuff()
// {
//     int i = 0;

//     i += 2;
//     if (i < 1)
//         return;
//     return;
// }
// )";

int main()
{
    doStuff();
    /*
        Print the programm
    */
    printf(str, str);
    return  0;
}

void doStuff()
{
    int i = 0;

    i += 2;
    if (i < 1)
        return;
    return;
}
