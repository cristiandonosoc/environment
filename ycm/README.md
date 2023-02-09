# YouCompleteMe Setup

This is a ycm setup, mostly geared for using it on Unreal projects on Windows.

## Prerequisites

You are going to need the following requisites:

- MSVC
- LLVM/Clang
  - The easiest way to get it is installing via the Visual Studio installer (sadly).
	- TODO(cdc): Find out if there an non MSVC install.


## Installation (for Unreal projects).

Put the `.ycm_extra_conf.py` in the base directory for _your project_ (next to the `Source` dir).

You're going to need UBT to generate a compile database for clang.
You can do that by calling UBT with the following (you can add more targets as needed):

```
<ENGINE_PATH>\Engine\Build\BatchFiles\Build.bat -Project=<PATH_TO_UPROJECT_FILE> \
	-Compiler=Clang \
	-Target="<PROJECt>Game Win64 Development" -Target="<PROJECT>Editor Win64 Development"
```

## Usage

The script requires two environment variables to be set:

- CDC_YCM_HELPERS_MODULE_PATH: Path to where the helper python scripts are. These are the other files
                               in this directory. They will be sourced by the .ycm conf file.
- CDC_YCM_COMPILATION_DATABASE_PATH: The path to where the compilation database is.
