#include <fcntl.h>
#include <stdio.h>
#define FT(x) int main() { FILE* f = fopen("Grace_kid.c", "w"); if (f == 0) return 1; fputs("#include <fcntl.h>\n#include <stdio.h>\n#define FT(x) "x"\n#define STR(x) #x\n#define EXPAND(x) STR(x)\n\n/*\n This program will print its own source when run.\n*/\n\nFT(EXPAND(FT(x)))\n", f); fclose(f); return 0; }
#define STR(x) #x
#define EXPAND(x) STR(x)

/*
 This program will print its own source when run.
*/

FT(EXPAND(FT(x)))
