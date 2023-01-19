@echo off

:: A simple wrapper of ls to always display colors.
IF "%~n0"=="ls" (
	coreutils ls --color %*
) ELSE (
	coreutils %~n0 %*
)

