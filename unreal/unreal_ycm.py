# Copyright 2020 Google Inc.
# Python 3 file.

import os
import pathlib
import sys
import ycm_core

def GetGamePaths(local_ycm_filepath, unreal_engine_path):
    if not "GAME_PATH" in os.environ:
        game_path = local_ycm_filepath
    else:
        game_path = pathlib.Path(os.environ["GAME_PATH"])

    # If our "game" is the engine, we do not try to load the game.
    if game_path == unreal_engine_path:
        return (None, None)

    game_build_path = game_path / "Intermediate/Build"
    if not game_build_path.exists() or not game_build_path.is_dir():
        return (None, None)
    return (game_path, game_build_path)

# Game Include Directories -------------------------------------------------------------------------

def GetGameIncludeDirectories(game_build_path):
    # Search for include dirs.
    game_include_dirs = []
    for inc_dir in list(game_build_path.glob("**/Inc")):
        game_include_dirs += ["-I", str(inc_dir)]

        # Iterate adding the specific include directories.
        for sub_inc_dir in inc_dir.iterdir():
            if not sub_inc_dir.is_dir():
                continue
            game_include_dirs += ["-I", str(sub_inc_dir)]
    return game_include_dirs

# Unreal Engine Include Directories ----------------------------------------------------------------

def GetUnrealEngineIncludeDirectories(unreal_build_path):
    # Path to the generated headers.
    engine_include_dirs = []
    for inc_dir in list(unreal_build_path.glob("**/UE4Editor/Inc")):
        path = str(inc_dir)
        if "Editor" not in path:
            continue

        # Add this directories and the specific sub-directories.
        engine_include_dirs += ["-isystem", path]
        for sub_inc_dir in inc_dir.iterdir():
            if not sub_inc_dir.is_dir():
                continue
            engine_include_dirs += ["-isystem", str(sub_inc_dir)]
    return engine_include_dirs

# Unreal Engine Public Directories -----------------------------------------------------------------

def GetUnrealEnginePublicDirectories(unreal_engine_path):
    # The global directories for which we want public headers.
    public_paths = [
        unreal_engine_path / "Engine/Source/Runtime",
        unreal_engine_path / "Engine/Source/Editor",
        unreal_engine_path / "Engine/Source/Developer",
    ]

    # For each one of those, we search for "Public" directories and add the to the includes.
    public_includes = []
    for public_path in public_paths:
        for public_dir in list(public_path.glob("**/Public")):
            public_includes += ["-isystem", str(public_dir)]

    # Search for the "Classes" Directories.
    for public_path in public_paths:
        for public_dir in list(public_path.glob("**/Classes")):
            public_includes += ["-isystem", str(public_dir)]
    PrintIncludes(public_includes)

    return public_includes

# Utilities ----------------------------------------------------------------------------------------

# Set to True to print debug information for this script.
DEBUG_MODE = True
VERBOSE_MODE = False

def Print(*args, **kwargs):
    if DEBUG_MODE:
        print(*args, **kwargs)

def Verbose(*args, **kwargs):
    if DEBUG_MODE and VERBOSE_MODE:
        print(*args, **kwargs)

# Expects an array of entries in the shape of "include pairs":
# ["-I", "/some/path", "-isystem", "/some/other/path", ...]
def PrintIncludes(include_list):
    i = 0
    while i < len(include_list):
        Verbose(include_list[i], include_list[i + 1])
        i += 2

# Load Database ------------------------------------------------------------------------------------

# Find a compilation entry that we know will exist and parse it in order to get the default
# defines. Not great, but not that bad either.
def LoadDefaultDefines(database, unreal_engine_path):
    if not database:
        return []

    # TODO(donosoc): This is pretty hacky, but works for now. What we really should do is obtain
    #                the first entry of the database an extract the defines from there, but ycm_core
    #                doesn't expose that.
    path = unreal_engine_path / "Engine/Source/Runtime/Core/Private/Math/Box.cpp"
    info = database.GetCompilationInfoForFile(str(path))

    defines = []
    if info.compiler_flags_:
        for entry in info.compiler_flags_:
            if not _ValidEntry(entry):
                continue
            if entry.startswith("-D"):
                defines.append(entry)
    return defines

def LoadCompilationDatabase(local_ycm_filepath, game_path, unreal_engine_path):
    # First try the local database.
    database = _LoadDB(local_ycm_filepath)
    if database:
        return database

    # Then try to load the game.
    if game_path:
        database = _LoadDB(game_path)
        if database:
            return database

    # Lastly try to load the engine database.
    return _LoadDB(unreal_engine_path)

def _LoadDB(path):
    db_path = path / "compile_commands.json"
    if not db_path.exists():
        return None
    return ycm_core.CompilationDatabase(str(path))

# Database Query -----------------------------------------------------------------------------------

_SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', '.m', '.mm' ]
_HEADER_EXTENSIONS = [ ".hpp", ".hxx", ".hh", ".h" ]

def GetInfoForFile(filename, database):
    # Query the database for a suitable entry. If none is found, we send over the default flags.
    info = _QueryDatabase(filename, database)
    if not info:
        return None

    # The engine flags from the database are included as direct sources (-I), but they should be
    # considered system includes (-isystem), so that we don't get a lot of warnings.
    file_flags = []
    for entry in info.compiler_flags_:
        if not _ValidEntry(entry):
            continue
        entry = entry.replace("-I", "-isystem")
        file_flags.append(entry)
    return file_flags

def _QueryDatabase(filename, database):
  # The compilation_commands.json file generated by CMake does not have entries for header files.
  # So we do our best by asking the database for flags for a corresponding source file, if any.
  # If one exists, the flags for that file should be good enough.
  if _IsHeaderFile(filename):
    basename = os.path.splitext(filename)[0]

    # Search for an equivalent source.
    # TODO(donosoc): This could be more clever with the Private/Public directories.
    for extension in _SOURCE_EXTENSIONS:
        replacement_file = basename + extension
        if not os.path.exists(replacement_file):
            return None
        info = database.GetCompilationInfoForFile(replacement_file)
        if info.compiler_flags_:
            return info
        return None
  return database.GetCompilationInfoForFile(filename)

def _IsHeaderFile(filename):
    extension = os.path.splitext(filename)[1]
    return extension in _HEADER_EXTENSIONS

def _ValidEntry(entry):
    if "DDPI_SHADER_PLATFORM_NAME_MAP" in entry:
        return False
    return True

