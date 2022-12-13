# This file is NOT licensed under the GPLv3, which is the license for the rest
# of YouCompleteMe.
#
# Here's the license text for this file:
#
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
#
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <http://unlicense.org/>

# --------------------------------------------------------------------------------------------------

# This is the YouCompleteMe integration file for the Unreal project.
# The main usage of this is to get clangd error/autocomplete/definition data for Vim
# using the the YCM plugin: https://github.com/ycm-core/YouCompleteMe
#
# This is a best-effort script written by cdc because he is very stubborn and refuses to use Visual
# Studio and he much rather waste time scripting vim integrations that doing actual useful work.
#
# Hopefully you find it useful.
# Viva la resistance!

from distutils.sysconfig import get_python_inc
from datetime import datetime
import os
import platform
import subprocess
import ycm_core

# IMPORTANT: This file expects to be in //hvn/games/bleep
THIS_SCRIPT = os.path.abspath( os.path.dirname( __file__ ) )
SOURCE_DIR = os.path.join(THIS_SCRIPT,  "game", "Source")

# The path to the directory where the generated files
# TODO(cdc): This doesn't really cover very well different configurations/platforms (eg. Server,
#            Linux, PS5, etc.). It works for now, but it is likely that some more thought will be
#            needed here.
INTERMEDIATE_FOLDER = os.path.join(THIS_SCRIPT, "game", "Intermediate")

# Set this to the absolute path to the folder (NOT the file!) containing the
# compile_commands.json file to use that instead of 'flags'. See here for
# more details: http://clang.llvm.org/docs/JSONCompilationDatabase.html
#
# Currently we use the hazel target //games/bleep:compilation_database, which later boils down to
# a call to UBT using -Mode=GenerateClangDatabase. Sadly UBT will generate the database in a known
# static location, which is //hvn/games/bleep/unreal (the location of the Engine).
COMPILATION_DATABASE_FOLDER = os.path.join(THIS_SCRIPT, "unreal")
if os.path.exists(COMPILATION_DATABASE_FOLDER):
  database = ycm_core.CompilationDatabase(COMPILATION_DATABASE_FOLDER)
else:
  raise Exception("Compilation DB not found", COMPILATION_DATABASE_FOLDER)

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
  if kwargs[ 'language' ] == 'cfamily':

    # We go over the file and analyze it and its location for figure out if this is the one we want
    # effectively get the flags for in the compilation database and also figure out any extra flags
    # we want to inject (like -include flags for the PCH).
    filename, extraflags  = ProcessFile(kwargs[ 'filename' ])
    print("EXTRAFLAGS:")
    for ef in extraflags:
      print("- ", ef)

    # Get the flags from the compilation database for the processed file.
    compilation_info = database.GetCompilationInfoForFile(filename)
    if not compilation_info.compiler_flags_:
      return {}

    flags = PostProcessFlags(compilation_info.compiler_flags_, extraflags)

    # Uncomment if you are interesting in seeing the full invocation.
    # print("FINAL FLAGS:")
    # for f in flags:
    #   print("- ", f)

    return {
      'flags': flags,
      'include_paths_relative_to_dir': compilation_info.compiler_working_dir_,
      'override_filename': filename
    }
  return {}

# ProcessFile receives a given file that we're editing on vim and returns any extra flags needed to
# process it. It might even change the file we "should" look for in the compilation database if it
# happens to be a header and we can find the appropiate cpp file
def ProcessFile(filename):
  print("----------------------------------------------------------")
  print("PROCESSING:", filename)
  extraflags = []

  roots = FindModuleRoots(filename)
  print("FOUND ROOTS (first is main)")
  for root in roots:
    print("- "+root)

  # If it's a header file, we attempt to find the equivalent .cpp, as that will have better entries
  # in the compilation database.
  mainroot = roots[0]
  print("MAIN ROOT:", mainroot)
  targetfile = filename
  if mainroot != "" and filename.endswith(".h"):
    targetfile = SearchForUnrealSourceFile(mainroot, filename)

  # For the main root we get PCH and private includes:
  extraflags += FindPCHIncludes(mainroot)
  if "game\\Source" in mainroot:
    extraflags += FindEditorPCHIncludes()
  extraflags += FindPrivateIncludes(mainroot)

  # # For the other roots we get the public includes.
  # for root in roots:
  #   # If we found a module root, we search for any PCH and add it to our include path.
  #   extraflags += FindPublicIncludes(root)

  # We include the "Public" directory for all the other modules.
  # NOTE: This is bound to make some errors, but the correct solution would require understanding
  #       the module dependency tree.
  modules = FindAllModules(SOURCE_DIR)
  for module in modules:
    public = os.path.join(module, "Public")
    if os.path.exists(public):
      extraflags.append("-I"+public)

  return targetfile, extraflags

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
  editorpch = os.path.join(INTERMEDIATE_FOLDER, "Build", "Win64", "UnrealEditor", "Development", "HvnEditor", "PCH.HvnEditor.h")
  if os.path.exists(editorpch):
    print("FOUND EDITOR PCH:", editorpch)
    includes.append("-include="+editorpch)
  return includes


# SwapBasename switches the extension between C++ header and cc.
def SwapBasename(filename):
  base, ext = os.path.splitext(filename)
  newext = ext
  if ext == ".h":
    newext = ".cpp"
  elif ext == ".cpp":
    newext = ".h"
  return base+newext

def SwapModuleBase(path):
  if "Private" in path:
    return path.replace("Private", "Public", 1)
  elif "Public" in path:
    return path.replace("Public", "Private", 1)
  else:
    return path

# PostProcessFlags gets the flags from the compilation database and
def PostProcessFlags(compilerflags, extraflags):
  # Flags are in this format of "<FLAGS> -- <TRANSLATION UNIT FILE>"
  # We search for the "--" token, since we want to inject some flags of our own before adding the
  # final file as translation unit.
  is_before = True
  beforeflags = []
  afterflags = []

  beforeflags += ["-x", "c++", "-std=c++17"]

  # Mark this build as one managed by vim/ycm.
  beforeflags.append("-DHVN_VIM_YCM_UNREAL_SETUP")

  # Some warnings we don't care about.
  beforeflags += [
    # Complains about using floats integer division.
    "-Wno-bugprone-integer-division",
    "-Wno-inconsistent-dllimport",
    "-Wno-inconsistent-missing-override",
    "-Wno-macro-redefined",
    "-Wno-format",
  ]

  # Append the extra flags.
  beforeflags += extraflags

  # Add the generated headers.
  incdir = os.path.join(INTERMEDIATE_FOLDER, "Build", "Win64", "UnrealEditor", "Inc")
  dirs = os.listdir(incdir)
  for p in dirs:
    path = os.path.join(incdir, p)
    if not os.path.isdir(path):
      continue
    include = "-I"+path
    beforeflags.append(include)

  # Bear in mind that compilation_info.compiler_flags_ does NOT return a
  # python list, but a "list-like" StringVec object.
  for flag in compilerflags:
    # Compilation database is using clang-cl format, but we want to send direct clang, because
    # otherwise clangd (for some reason starts using gcc as the backend, which otherwise means
    # a lot of errors).
    if flag.startswith('/'):
      continue
    if ".exe" in flag:
      continue
    if "driver-mode" in flag:
      continue
    beforeflags.append(flag)

  # # Append the unreal remover.
  # unrealdefs = os.path.join(THIS_SCRIPT, "tools", "vim", "unreal_defs.h")
  # beforeflags.append("-include="+unrealdefs)

  # Finally put it all together and return the final invocation.
  return beforeflags + afterflags
