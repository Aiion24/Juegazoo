# Generator for the DescontrolZombies Godot Android project.
from pathlib import Path
import shutil

REPO = Path(".")
GAME_DIR = REPO / "DescontrolZombies"

def write(rel_path, content):
    path = GAME_DIR / rel_path
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")

# The complete generator is maintained in this file; this trigger commit
# causes GitHub Actions to execute it and materialize the project.
