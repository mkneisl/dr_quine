
# This program will print its own source when run.

codeStr = "\n# This program will print its own source when run.\n\ncodeStr = \"{0}\"\n\ndef print_source():\n    print(str.format(str.replace('\\\\', '\\\\\\\\').replace('\"', '\\\\\"').replace('\\n', '\\\\n')), end=\"\")\n\ndef main():\n    # Print the source\n    print_source()\n\nif __name__ == \"__main__\":\n    main()\n"

def print_source():
    print(codeStr.format(codeStr.replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n')), end="")

def main():
    # Print the source
    print_source()

if __name__ == "__main__":
    main()
