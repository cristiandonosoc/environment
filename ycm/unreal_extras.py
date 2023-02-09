# This is a holder for old functions that might be useful in the future.

def FindAllModules(current_dir):
    modules = []
    subdirs = []

    for f in os.listdir(current_dir):
        if "Build.cs" in os.path.basename(f):
            return [current_dir]

        dirname = os.path.join(current_dir, f)
        if os.path.isdir(dirname):
            subdirs.append(dirname)

    # Recursively search.
    for subdir in subdirs:
        submodules = FindAllModules(subdir)
        modules += submodules

    return modules


# FindModuleRoots finds all the flags for all the modules associated with the system.
# This occurs because modules that have Client/Server/Test suffixes are part of the system and we
# have to find the includes in the correct order.
def FindModuleRoots(filename):
    root = FindModuleRoot(filename)
    roots = [root]

    # See if there are alternatives that we should care about. Order matters.
    current = root
    suffixes = ["Test", "Server", "Client"]
    for suffix in suffixes:
        if suffix in current:
            current = current.removesuffix(suffix)
            if os.path.exists(current):
                roots.append(current)
    return roots


# SearchForUnrealSourceFile searches for the equivalent .h/.cpp for a given file, taking into
# consideration the module structure.
def SearchForUnrealSourceFile(moduleroot, filename):
    rel = os.path.relpath(filename, moduleroot)
    target = os.path.join(moduleroot, SwapModuleBase(SwapBasename(rel)))
    if os.path.exists(target):
        print("CHANGED SOURCE FILE TO:", target)
        return target
    return filename


def FindEditorPCHIncludes():
    includes = []
    editorpch = os.path.join(
        INTERMEDIATE_FOLDER,
        "Build",
        "Win64",
        "UnrealEditor",
        "Development",
        "HvnEditor",
        "PCH.HvnEditor.h",
    )
    if os.path.exists(editorpch):
        print("FOUND EDITOR PCH:", editorpch)
        includes.append("-include=" + editorpch)
    return includes


# SwapBasename switches the extension between C++ header and cc.
def SwapBasename(filename):
    base, ext = os.path.splitext(filename)
    newext = ext
    if ext == ".h":
        newext = ".cpp"
    elif ext == ".cpp":
        newext = ".h"
    return base + newext


def SwapModuleBase(path):
    if "Private" in path:
        return path.replace("Private", "Public", 1)
    elif "Public" in path:
        return path.replace("Public", "Private", 1)
    else:
        return path


# # PostProcessFlags gets the flags from the compilation database and
# def PostProcessFlags(compilerflags, extra_flags):
#     # Flags are in this format of "<FLAGS> -- <TRANSLATION UNIT FILE>"
#     # We search for the "--" token, since we want to inject some flags of our own before adding the
#     # final file as translation unit.
#     is_before = True
#     beforeflags = []
#     afterflags = []

#     beforeflags += ["-x", "c++", "-std=c++17"]

#     # Mark this build as one managed by vim/ycm.
#     beforeflags.append("-DHVN_VIM_YCM_UNREAL_SETUP")

#     # Some warnings we don't care about.
#     beforeflags += [
#         # Complains about using floats integer division.
#         "-Wno-bugprone-integer-division",
#         "-Wno-inconsistent-dllimport",
#         "-Wno-inconsistent-missing-override",
#         "-Wno-macro-redefined",
#         "-Wno-format",
#     ]

#     # Append the extra flags.
#     beforeflags += extra_flags

#     # Add the generated headers.
#     incdir = os.path.join(INTERMEDIATE_FOLDER, "Build", "Win64", "UnrealEditor", "Inc")
#     dirs = os.listdir(incdir)
#     for p in dirs:
#         path = os.path.join(incdir, p)
#         if not os.path.isdir(path):
#             continue
#         include = "-I" + path
#         beforeflags.append(include)

#     # Bear in mind that compilation_info.compiler_flags_ does NOT return a
#     # python list, but a "list-like" StringVec object.
#     for flag in compilerflags:
#         # Compilation database is using clang-cl format, but we want to send direct clang, because
#         # otherwise clangd (for some reason starts using gcc as the backend, which otherwise means
#         # a lot of errors).
#         if flag.startswith("/"):
#             continue
#         if ".exe" in flag:
#             continue
#         if "driver-mode" in flag:
#             continue
#         beforeflags.append(flag)

#     # # Append the unreal remover.
#     # unrealdefs = os.path.join(THIS_DIR, "tools", "vim", "unreal_defs.h")
#     # beforeflags.append("-include="+unrealdefs)

#     # Finally put it all together and return the final invocation.
#     return beforeflags + afterflags
