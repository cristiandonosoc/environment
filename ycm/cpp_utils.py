# This file contains utils that are common operations to be done with cpp files.

import os

_h_extensions = ["h", "hpp"]
_cpp_extensions = ["cpp", "cc", "c"]

# header_change tries to find the corresponding header/cpp file for a particular file.
# It expects the extensions to be one of the defined in |_h_extensions| or |_cpp_extensions|.
def header_change(filename, force=False):
    # First check if this is an unreal header that might need to be changed.
    result = _unreal_module_header_change(filename)
    if result is not None:
        return result

    # Then we see if the matching file is in the same directory.
    return _change_extension(filename, force=force)

def _unreal_module_header_change(filepath):
    # See if this is a module.
    if (not "Public" in filepath) and (not "Private" in filepath):
        return None

    last = filepath
    d = filepath
    while True:
        # Go over searching the parent.
        # If we found the same directory twice in a row, it means that we are at the file system
        # root, so we exit the loop.
        d = os.path.dirname(d)
        if d == last:
            return "", False
        last = d

        # We change from Private <-> Public modules.
        base = os.path.basename(d)
        if base == "Public":
            other = "Private"
        elif base == "Private":
            other = "Public"
        else:
            continue

        # Find the path where the other headern should be.
        rel = os.path.relpath(filepath, d)
        target = os.path.join(os.path.dirname(d), other, rel)

        # Try to find the other header.
        return _change_extension(target)


def _change_extension(filepath, force=False):
    filename, fileext = os.path.splitext(filepath)
    extension = fileext[1:]

    new_extensions = []
    if extension in _h_extensions:
        new_extensions = _cpp_extensions
    elif extension in _cpp_extensions:
        new_extensions = _h_extensions

    # Search for a match.
    for ext in new_extensions:
        path = os.path.abspath(f"{filename}.{ext}")
        if os.path.exists(path):
            return path

    if not force:
        return ""

    # If we forced, we just return the file with the new extension.
    ext = new_extensions[0]
    return os.path.abspath(f"{filename}.{ext}")



