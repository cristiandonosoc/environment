import json
import sys
import os

import cpp_utils
import ycm_utils

def process_gcd_file(gcd_file):
    # flags = ["--driver-mode", "cl"]
    flags = []
    with open(gcd_file, "r") as file:
        lines = file.readlines()
        for line in lines[1:]:
            l = line.replace("\n", " ").replace("\r", " ").strip()
            pieces = ycm_utils.separate_tokens(l)
            flags += pieces

    return flags


class CompDBEntry:
    @classmethod
    def from_entry(cls, entry):
        return cls(entry["file"], entry["command"], entry["directory"])

    def __init__(self, file, command, directory):
        self.file = file
        self.command = command
        self.directory = directory

        self.pieces = ycm_utils.separate_tokens(self.command)

        # The special case where we have some commands.
        flags = self.pieces
        if len(self.pieces) == 2:
            p = self.pieces[1]
            ext = os.path.splitext(p)[1]
            flags = [self.pieces[0]]
            if p.startswith("@") and ext == ".gcd":
                flags += process_gcd_file(p[1:])

        self.flags = flags

    def __str__(self):
        file = os.path.basename(self.file)
        return f"{self.file}: {self.command}"

    def get_flags_as_clang(self):
        return ["--driver-mode=cl"] + self.flags + ["-Wno-deprecated-builtins"]

# --------------------------------------------------------------------------------------------------

def load_all_compilation_database(compdb_filename):
    with open(compdb_filename, "r") as file:
        data = json.load(file)

    entries = []
    for d in data:
        try:
            entry = CompDBEntry.from_entry(d)
            entries.append(entry)
        except Exception as e:
            # print("FILE {} COULD NOT BE LOADED: {}".format(d["file"], e))
            pass

    return entries


def load_compilation_data_for_file(
    compdb_filename, target_filename, search_by_basename=False
):
    with open(compdb_filename, "r") as file:
        data = json.load(file)

    # If our file is a header, we try to find it to the corresponding cpp.
    if os.path.splitext(target_filename)[1] == ".h":
        target_filename = cpp_utils.header_change(target_filename, force=True)

    for d in data:
        if target_filename == d["file"] or os.path.basename(target_filename) == os.path.basename(d["file"]):
            return target_filename, CompDBEntry.from_entry(d)

    raise Exception(f"No entry found for {target_filename}")


if __name__ == "__main__":
    compdb_filename = sys.argv[1]
    target_filename = sys.argv[2]

    entry = load_compilation_data_for_file(
        compdb_filename, target_filename, search_by_basename=True
    )

    print(entry)
    # for flag in entry.get_flags_as_clang():
    for flag in entry.flags:
        print(flag)

    print("-----------------------------------------------------------------------")
    print("-----------------------------------------------------------------------")
    print("-----------------------------------------------------------------------")
    print("-----------------------------------------------------------------------")
    print("-----------------------------------------------------------------------")
    print("-----------------------------------------------------------------------")
    print("-----------------------------------------------------------------------")

    for flag in entry.get_flags_as_clang():
        print(flag)
