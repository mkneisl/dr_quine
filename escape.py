import sys

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 escape.py <source.c/.s>")
        sys.exit(1)
    mode = "none"
    if sys.argv[1].endswith(".s"):
        mode = "asm"
    elif sys.argv[1].endswith(".c"):
        mode = "c"
    else:
        print("Usage: python3 escape.py <source.c/.s>")
    try:
        with open(sys.argv[1], 'r') as file:
            if mode == "c":
                print("\"", end="")
            for line in file:
                escaped_line = line.replace('\\', '\\\\').replace('"', '\\"').rstrip('\n')
                if mode == "c":
                    print(f'{escaped_line}\\n', end="")
                if mode == "asm":
                    print(f'"{escaped_line}", 10,', end="")
            if mode == "c":
                print("\"")
    except FileNotFoundError:
        print(f"Error: File '{sys.argv[1]}' not found.")
        sys.exit(1)
