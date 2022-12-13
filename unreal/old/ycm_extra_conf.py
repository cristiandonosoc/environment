# Copyright 2020 Google Inc.
# Python 3 file.

import os
import pathlib
import sys
import ycm_core

# Overall Paths ------------------------------------------------------------------------------------

# The path of this file.
YCM_FILEPATH = pathlib.Path(os.path.dirname(os.path.abspath(__file__)))

# The path to the engine.
UNREAL_ENGINE_PATH = pathlib.Path(os.environ["UNREAL_ENGINE_PATH"])
UNREAL_ENGINE_BUILD_PATH = UNREAL_ENGINE_PATH / "Engine/Intermediate/Build"

# Import the YCM utils.
sys.path.append(str(UNREAL_ENGINE_PATH))
from unreal_ycm import *

(GAME_PATH, GAME_BUILD_PATH) = GetGamePaths(YCM_FILEPATH, UNREAL_ENGINE_PATH)

Print("YCM File: ", YCM_FILEPATH)
Print("UE4 Path: ", UNREAL_ENGINE_PATH)
Print("UE4 Build Path: ", UNREAL_ENGINE_BUILD_PATH)
Print("GAME PATH: ", GAME_PATH)
Print("GAME BUILD PATH: ", GAME_BUILD_PATH)

# Attemp to load the local file that will have the correct path for this machine.
local_flags = []
try:
    sys.path.append(os.getcwd())
    import ycm_extra_conf_local
    local_flags = ycm_extra_conf_local.GetYCMLocalFlags()
except Exception as err:
    print(err)

# Default Flags ------------------------------------------------------------------------------------
#
# This default flags will be used when we do not find any suitable entries in the database.
# This will be the case for standalone headers.

COMPILATION_DATABASE = LoadCompilationDatabase(YCM_FILEPATH, GAME_PATH, UNREAL_ENGINE_PATH)
COMPILATION_DEFINES = LoadDefaultDefines(COMPILATION_DATABASE, UNREAL_ENGINE_PATH)

GAME_FLAGS = GetGameIncludeDirectories(GAME_BUILD_PATH)
UNREAL_ENGINE_FLAGS = GetUnrealEngineIncludeDirectories(UNREAL_ENGINE_BUILD_PATH)
UNREAL_ENGINE_PUBLIC_FLAGS = GetUnrealEnginePublicDirectories(UNREAL_ENGINE_PATH)

COMMON_FLAGS = [
    "-x", "c++", "-std=c++14",
    "-D", "__INTELLISENSE__",
    "-Wno-switch",
    "-Wno-gnu-string-literal-operator-template",
]

DEFAULT_FLAGS = []
DEFAULT_FLAGS += local_flags
DEFAULT_FLAGS += COMMON_FLAGS
DEFAULT_FLAGS += GAME_FLAGS
DEFAULT_FLAGS += UNREAL_ENGINE_FLAGS
DEFAULT_FLAGS += UNREAL_ENGINE_PUBLIC_FLAGS

def FlagsForFile(filename, **kwargs):
    Print("Getting compilation info for ", filename)
    if not COMPILATION_DATABASE:
        print("No compilation database!")
        return {}

    file_flags = DEFAULT_FLAGS
    db_flags = GetInfoForFile(filename, COMPILATION_DATABASE)
    if db_flags:
        file_flags += db_flags
    else:
        # If we didn't find any flags, we add the default defines we obtained and hope for the best.
        Print("No compilation entry found for ", filename)
        file_flags += COMPILATION_DEFINES

    return { "flags": file_flags, "do_cache": True }
