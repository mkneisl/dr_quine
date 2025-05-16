import sys

# This program will print its own source when run.

codeStr = "import sys\n\n# This program will print its own source when run.\n\ncodeStr = \"{0}\"\n\ndef main():\n    try:\n        with open(\"Grace_kid.py\", \"w\") as file:\n            file.write(str.format(str.replace('\\\\', '\\\\\\\\').replace('\"', '\\\\\"').replace('\\n', '\\\\n')))\n    except:\n        print(\"Error writing file!\")\n        sys.exit(1)\n\nif __name__ == \"__main__\":\n    main()\n"

def main():
    try:
        with open("Grace_kid.py", "w") as file:
            file.write(str.format(str.replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n')))
    except:
        print("Error writing file!")
        sys.exit(1)

if __name__ == "__main__":
    main()
