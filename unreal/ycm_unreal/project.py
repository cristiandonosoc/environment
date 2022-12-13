import os

# Project represents a given Unreal project and its settings for the case of YCM.
# It tracks to main directories: And Editor one and a Project one.
class Project:
    def __init__(self, editor_root, project_root):
        self.editor_root
        self.editor_intermediate = os.path.join(editor_root, "Intermediate")

        self.project_root
        self.project_intermediate = os.path.join(project_root, "Intermediate")
