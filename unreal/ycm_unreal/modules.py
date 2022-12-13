# FindModule starts from a given file and finds the module root.
# It does it by searching for a Build.cs file.
def FindModule(filename):
    # Go over searching the parent.
    # If we found the same directory twice in a row, it means that we are at the file system root.
    last = filename
    d = filename
    while True:
      d = os.path.dirname(d)
      if d == last:
        break
      last = d

    # Search directory for Build.cs file.
    for f in os.listdir(d):
        basename = os.path.basename(f)
        if "Build.cs" in basename:
          return Module(d)
    raise Exception("cannot find module for {}".format(filename))

# Module represents a single Unreal module, which is defined by any source directory within Unreal
# codebase that contains a *.Build.cs file.
class Module:
    def __init__(self, root):
      self.root = root

    # FindPCHs returns an array with al the paths containing a Pre-Compiled Header.
    # TODO(cdc): Should be added with a -include flag).
    def FindPCHs(self):
      pchs = []
      for (dirpath, dirnames, filenames) in os.walk(self.root):
          for f in filenames:
              if f.endswith("PCH.h"):
                  pch = os.path.join(dirpath, f)
                  pchs.append(pch)
      return pchs

    # FindPublicIncludes returns an array with all the Public directories/paths that should be
    # included for using this module.
    # TODO(cdc): Should be added with a -I flag).
    def FindPublicIncludes(self):
        includes = []
        for d in os.listdir(self.root):
            if d == "Public":
                include = os.path.join(root, d)
                includes.append(include)
        return includes

    # FindPrivateIncludes returns an array with all the Private directories/paths that should be
    # included for a file contained within the module.
    # TODO(cdc): Should be added with a -I flag, but only within that module.
    def FindPrivateIncludes(root):
        includes = []
        for d in os.listdir(root):
            if d == "Private":
                include = os.path.join(root, d)
                includes.append(include)
        return includes



