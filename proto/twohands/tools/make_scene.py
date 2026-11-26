"""make_scene.py - scene.html: the boxing page (order.html) with the famous exchanges on it (S567).

Owner S567: "find few clips of famous fights breakdowns and try to breakdown their actions with our game switches and
play it like the real clip next to the one with our player". scene.html is order.html plus two scripts: scenes.js (the
exchanges as switches) and scene_ui.js (a bar that plays one). The rules are order.html's, untouched.

    python proto/twohands/tools/make_scene.py

order.html is never written. Run again after order.html changes (as make_punch.py and make_wait.py).
"""
import io
from pathlib import Path

HERE = Path(__file__).resolve().parent
s = io.open(HERE.parent / "order.html", encoding="utf-8", newline="").read()
TAG = '<script src="version.js" defer></script>'
assert s.count(TAG) == 1, "make_scene: the version.js script tag was not found exactly once"
s = s.replace(TAG, TAG + '<script src="scenes.js" defer></script><script src="scene_ui.js" defer></script>')
io.open(HERE.parent / "scene.html", "w", encoding="utf-8", newline="").write(s)
print("scene.html written")
