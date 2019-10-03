# Notes for making windows development from Linux

## About Paths

WSL has the windows path always mounted within "/mnt/<DRIVE>". The inverse is
also possible but it's much harder, so the correct way to think of this is that
linux has a view into windows, while windows is oblivious to it.

In the end, the compiled applications will not have (and should not have) any
knowledge that they were developed in a linux-like environment. From their point
of view, they're normal windows applications.

## GN

We're using the native (windows) toolchain, so the build tools have to be the
locals ones. For this install both gn.exe and ninja.exe (the windows binaries)
into some location.
Put that location in the linux path and put some aliases to make it easier to
call from WSL (though you can just call "gn.exe" or "ninja.exe" just fine).
GN expects to have access to python. This python is *not* the linux python that
the normal setup I recommend installs within WSL. This means that in the end
you're going to have at least 2 copies of linux: The windows and the linux one.
In practice my setup has 4: Both 2.7 and 3.7 for both OSes.

## Instructions

1. Install WSL through windows store.
2. Do the correct linux environment setup (tmux, neovim, etc).
   This is all local to linux so it doesn't differ.
3. When it comes to font management, these have to be installed within *windows*.

Now the most important thing is to actually have access to the Windows C++ tools,
aka MSVC.

### MSVC

1. Install Visual Studio Community. As of the writing of this doc, the version
was Visual Studio 2019.
2. If you not choose a special directory for the install, Visual Studio will be
installed in a path that looks like this:

"C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\"

Normally you'd use this toolchain from within Visual Studio, but here we're going
to call the tools directly. The easiest way to do this is to use the Visual
Studio shell, which comes with all the enviroment variables correctly set, so
you can call "cl.exe", "link.exe" and others just fine. What we want is to have
that enviroment present within linux.

The way to do that is calling what that Visual Studio shell does, which is a bat
script that does all the magic. That is whithin:

@call "<VISUAL STUDIO INSTALL>\VC\Auxiliary\Build\vcvars64.bat"

So an easy way to test that you can call the tooling from linux is running the
following by hand:

```
@call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat"
bash
cl.exe
```

That should've called the MSVC compiler correctly. With that you're pretty much
done! All that's left is a bit of automation to ensure this all gets done neatly
when you start working.

What I do now is:

1. Install ConEmu
2. Make that your selected profile runs a bat file at startup. I put that file
wihin my user home: C:\Users\<USER>\init.bat

The contents of the file are very easy:

```
@call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat"
bash
exit
```

The first line gives me all the environment goodness.
The second calls bash and defers all the development to there. At that point, it
should _generally_ be a normal linux development experience.
The last exit is important because otherwise you will fall down to a windows
prompt, instead of finishing the session.

## About files

An important thing is that the MSVC toolchain has *no* knowledge of the linux
filesystem, so you *cannot* put your files within it and expect cl.exe to be able
to find them. Instead what you must do is work with all your files within the
windows file system: basically, everything under "/mnt/c". Personally I use `/mnt/c/Code`.

That's not to say that every file has to go there. Anything that Windows doesn't
need to know can go within the Linux realm. Vim configs, YouCompleteMe, bash/fish
scripts, whatever all can go here and it will work just fine.

## About windows headers in YCM

The last thing that can be annoying is that YCM will be running on the linux side.
In general, if you're using the std headers, it will roughly work, though some
headers can be annoying (unistd.h and such), so some compatibility work will have to
be done.

The main problem is that you will never be able to find the Windows headers within
YCM. This is mainly important for #import <windows.h>. The code will compile just
fine, but YCM will say "I have no idea what these symbols are", as the compiling
toolchain is a different one that the one you're using for syntax checking.

The solution is to... stub the headers! I found a github project with some headers
lying around that simply define the symbols and works wonders:

```
https://github.com/ellbur/fake-windows-headers-for-ycm
```

was roughly enough for my needs, and I added some symbols that were missing some
time ago.

