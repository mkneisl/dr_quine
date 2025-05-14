#include <unistd.h>
#include <sys/syscall.h>

#define CODE(x) "#include <unistd.h>\n\n#define CODE(x) " x "\n#define STR(x) #x\n#define EXPAND(x) STR(x)\n\n/*\n This program will print its own source when run.\n*/\n\nvoid ft_putstr_fd(int fd, const char* str)\n{\n    int strLen;\n\n    for (strLen = 0; str[strLen]; strLen++);\n    write(fd, str, strLen);\n}\n\nint main()\n{\n    /*\n     Basic libft function\n    */\n    ft_putstr_fd(1, CODE(EXPAND(CODE(x))));\n    return  0;\n}\n"
#define STR(x) #x
#define EXPAND(x) STR(x)

/*
 This program will print its own source when run.
*/
#include <sys/wait.h>

void ft_putstr_fd(int fd, const char* str)
{
    int strLen;

    for (strLen = 0; str[strLen]; strLen++);
    write(fd, str, strLen);
}

struct t_siginfo
{
    int si_signo;
    int si_errno;
    int si_code;

};

int main()
{
    /*
     Basic libft function
    */
    siginfo_t a;

    printf("pid offset: %x\n", a.si_pid);

 //   ft_putstr_fd(1, CODE(EXPAND(CODE(x))));
    return  0;
}
