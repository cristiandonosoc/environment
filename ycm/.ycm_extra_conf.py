# This is the YouCompleteMe integration file for the Unreal project.
# The main usage of this is to get clangd error/autocomplete/definition data for Vim
# using the the YCM plugin: https://github.com/ycm-core/YouCompleteMe
#
# This is a best-effort script written by cdc because he is very stubborn and refuses to use Visual
# Studio and he much rather waste time scripting vim integrations that doing actual useful work.
#
# You can find more documentation in
# https://github.com/cristiandonosoc/environment/blob/master/ycm/README.md
#
# Hopefully you find it useful.
# Viva la resistance!

from distutils.sysconfig import get_python_inc
from datetime import datetime
import os
import platform
import subprocess
import json

THIS_DIR = os.path.abspath(os.path.dirname(__file__))

# HELPERS_MODULE_PATH = os.environ.get("CDC_YCM_HELPERS_MODULE_PATH")
# if HELPERS_MODULE_PATH is None:
#     raise Exception("Set CDC_YCM_HELPERS_MODULE_PATH environment variable. See docs.")
HELPERS_MODULE_PATH = "C:\cdc\environment\ycm"

# COMPILATION_DATABASE_PATH = os.environ.get("CDC_YCM_COMPILATION_DATABASE_PATH")
# if COMPILATION_DATABASE_PATH is None:
#     raise Exception("Set CDC_YCM_COMPILATION_DATABASE_PATH. See docs").

COMPILATION_DATABASE_PATH = os.path.join(THIS_DIR, "compile_commands.json")

# # IMPORTANT: This file expects to be in //hvn/games/bleep
# SOURCE_DIR = os.path.join(THIS_DIR, "Source")
# if not os.path.exists(SOURCE_DIR):
#     raise Exception("Please set SOURCE_DIR correctly")

SOURCE_DIR = os.path.join(THIS_DIR, "Source")

# We import the helper script.
import sys
found=False
for path in sys.path:
    if path == HELPERS_MODULE_PATH:
        found=True
        break

if not found:
    sys.path.append(HELPERS_MODULE_PATH)
import compdb_helper


# Settings is the function that gets called by Ycm for getting invocation flags and other metadata
# for the editor integration.
def Settings(**kwargs):
    start = datetime.now()
    result = SettingsInternal(**kwargs)
    end = datetime.now()

    execms = (end - start).total_seconds() * 1000
    print("TOTAL TIME: {}ms".format(execms))

    return result


# SettingsInternal is a simple wrapper so that we can time the duration from Settings.
def SettingsInternal(**kwargs):
    if kwargs["language"] != "cfamily":
        return {}

    filename = kwargs["filename"]
    print("FILENAME: ", filename)

    entry = compdb_helper.load_compilation_data_for_file(COMPILATION_DATABASE_PATH, filename)
    flags = entry.get_flags_as_clang()

    print("LOADED FILE: ", filename)

    return {
        "flags": flags,
        "include_paths_relative_to_dir": entry.directory,
        "override_filename": filename,
    }
