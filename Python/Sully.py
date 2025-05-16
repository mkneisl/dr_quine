import sys
import os

# This program will print its own source when run.

i = 5

codeStr = "import sys\nimport os\n\n# This program will print its own source when run.\n\ni = {1}\n\ncodeStr = \"{0}\"\n\ndef main():\n    global i\n    if sys.argv[0][5] == '_':\n        i = i -1\n    newFileName = f\"Sully_\" + str(i) + \".py\"\n    try:\n        with open(newFileName, \"w\") as file:\n            file.write(codeStr.format(codeStr.replace('\\\\', '\\\\\\\\').replace('\"', '\\\\\"').replace('\\n', '\\\\n'), i))\n    except:\n        print(\"Error writing file!\")\n        sys.exit(1)\n    if i == 0:\n        sys.exit(0)\n    os.system(f\"python3 \" + newFileName)\n\nif __name__ == \"__main__\":\n    main()\n"

def main():
    global i
    if sys.argv[0][5] == '_':
        i = i -1
    newFileName = f"Sully_" + str(i) + ".py"
    try:
        with open(newFileName, "w") as file:
            file.write(codeStr.format(codeStr.replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n'), i))
    except:
        print("Error writing file!")
        sys.exit(1)
    if i == 0:
        sys.exit(0)
    os.system(f"python3 " + newFileName)

if __name__ == "__main__":
    main()
