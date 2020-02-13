# Copyright 2020 Google Inc.
# Python 3 file.

import pathlib
import json
import sys
import time

def ProcessInclude(base_path, include_str):
    include_str = include_str.strip("\"")
    include_path = pathlib.Path(include_str)
    if not include_path.is_absolute():
        include_path = base_path / include_path
    return include_path.absolute()

def ExtractPrefix(prefix, commands, command, index):
    to_strip = " \"\'\t\r\n"
    if command.endswith(prefix):
        return (commands[index + 1].strip(to_strip), index + 1)

    # Remove the prefix for the entry.
    # This is for -I"/type/of/path" kind of entries.
    return (command[len(prefix):].strip(to_strip), index)

def ProcessCommand(base_path, command_str):
    commands = command_str.split()

    define_count = 0
    include_count = 0

    define_set = set()
    include_set = set()

    i = 1   # Skip the compiler invocation.
    while i < len(commands):
        command = commands[i]

        prefix = "-D"
        if command.startswith(prefix):
            define_count += 1
            (define_str, i) = ExtractPrefix(prefix, commands, command, i)
            define_set.add(define_str)
            i += 1
            continue

        prefix = "-I"
        if command.startswith(prefix):
            include_count += 1
            (include_str, i) = ExtractPrefix(prefix, commands, command, i)
            include_set.add(ProcessInclude(base_path, include_str))
            i += 1
            continue
        i += 1

    # print("Processes {} defines, {} unique.".format(define_count, len(define_set)))
    # print("Processed {} includes, {} unique.".format(include_count, len(include_set)))

    return (define_set, include_set)


def ProcessEntry(entry):
    base_path = pathlib.Path(entry["directory"])
    return ProcessCommand(base_path, entry["command"])

def TimeFunction(func, *args, **kwargs):
    start = time.time()

    ret_value = func(*args, **kwargs)

    end = time.time()
    print("{} took {} seconds.".format(str(func), end - start))

    return ret_value

def LoadDatabase(db_path):
    with db_path.open() as f:
        content = f.read()
        database = json.loads(content)
    return database

if __name__ == "__main__":
    db_path = pathlib.Path(sys.argv[1])

    database = TimeFunction(LoadDatabase, db_path)
    print("Loaded database with {} entries.".format(len(database)))


    start = time.time()

    entries = []
    for db_entry in database:
        (define_set, include_set) = ProcessEntry(db_entry)

        defines = []
        for define in define_set:
            defines.append(define)

        includes = []
        for include in include_set:
            includes.append(str(include))

        entry = {}
        entry["filename"] = db_entry["file"]
        entry["defines"] = defines
        entry["includes"] = includes
        entries.append(entry)


    end = time.time()

    with open("processed_db.json", "w") as f:
        json.dump(entries, f, indent=2)

    print("Took {} seconds.", end - start)















