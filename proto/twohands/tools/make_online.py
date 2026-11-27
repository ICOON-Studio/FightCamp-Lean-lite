"""make_online.py - online.html: the boxing page (order.html) with Play online on it (S567).

Owner S567: "can you make like a server so all agents can connect and play and dd the option in the game too ?".
online.html is order.html plus one script, online_ui.js: a bar that finds an opponent on the match server
(proto/twohands/site/match_server.mjs, port 8796) and plays each beat against his real moves. The rules are order.html's.

    python proto/twohands/tools/make_online.py

order.html is never written. Run again after order.html changes (as make_punch.py, make_wait.py and make_scene.py).
"""
import io
from pathlib import Path

HERE = Path(__file__).resolve().parent
s = io.open(HERE.parent / "order.html", encoding="utf-8", newline="").read()
TAG = '<script src="version.js" defer></script>'
assert s.count(TAG) == 1, "make_online: the version.js script tag was not found exactly once"
s = s.replace(TAG, TAG + '<script src="online_ui.js" defer></script>')
io.open(HERE.parent / "online.html", "w", encoding="utf-8", newline="").write(s)
print("online.html written")
