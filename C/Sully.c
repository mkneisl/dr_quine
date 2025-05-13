#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>
#define FT(x) int main(int argc, char** argv) { (void)argc; char fileName[] = "Sully_x.c"; char execName[] = "Sully_x"; if (argv[0][5] != '_') i++; fileName[6] = '0' + i - 1; execName[6] = '0' + i - 1; FILE* f = fopen(fileName, "w"); if (f == 0) return 1; fprintf(f, "%s%s\n#define STR(x) #x\n#define EXPAND(x) STR(x)\n\n/*\n This program will print its own source when run.\n*/\n\nint i = %i;\n\nFT(EXPAND(FT(x)))\n", "#include <fcntl.h>\n#include <stdio.h>\n#include <unistd.h>\n#include <stdlib.h>\n#include <sys/wait.h>\n#define FT(x) ", x, i - 1); fclose(f); if (!(i - 1)) return 0; int pid = fork(); if (pid == 0) { execl("/usr/bin/clang", "/usr/bin/clang", "-Werror", "-Wall", "-Wextra", fileName, "-o", execName, (void*)0); exit(0);} int status = 0; if (waitpid(pid, &status, 0) != pid || status) { return 1; } execl(execName, execName, (void*)0); return 0; }
#define STR(x) #x
#define EXPAND(x) STR(x)

/*
 This program will print its own source when run.
*/

int i = 5;

FT(EXPAND(FT(x)))
