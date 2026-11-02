"""Run a Python file INSIDE a live Cascadeur session and print what it printed.

Cascadeur 2026.2 ships an in-app script server. Turn it on once per launch from
the GUI: Scripts > MCP > Start script server. It then listens on
127.0.0.1:8765 and `POST /run {"code": ...}` executes the code in the running
app with `scene`, `csc` and `app` already in scope, on the next scene_idle.
The install documents it in
  C:/Program Files/Cascadeur/resources/scripts/python/scripts/mcp/script_server/README.md

Usage:
    python Tools/cascadeur/csend.py <file.py> [workdir]
    python Tools/cascadeur/csend.py -c "print(app.current_scene().name())"

`workdir` (default: the current directory) is injected into the script as the
global WORKDIR, so a script can read and write its JSON beside the caller
rather than carrying an absolute path.

THE TRAP THE README NAMES AND IT IS REAL: scene.modify*/pyscene.edit return
False when the callback raised, while the HTTP response still says ok. Always
print the return value, and on False read the tail of
  %LOCALAPPDATA%/Nekki Limited/Cascadeur/logs/cascadeur_log.log
"""
import json
import os
import sys
import urllib.error
import urllib.request

URL = "http://127.0.0.1:8765/run"
HEALTH = "http://127.0.0.1:8765/health"


def health():
    try:
        with urllib.request.urlopen(HEALTH, timeout=5) as r:
            return json.loads(r.read().decode("utf-8"))
    except Exception:
        return None


def run(code, timeout=600):
    req = urllib.request.Request(
        URL,
        data=json.dumps({"code": code}).encode("utf-8"),
        headers={"Content-Type": "application/json"},
    )
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return json.loads(r.read().decode("utf-8"))


def main():
    args = sys.argv[1:]
    if not args:
        print(__doc__)
        return 2
    if args[0] == "-c":
        code = args[1]
        workdir = args[2] if len(args) > 2 else os.getcwd()
    else:
        with open(args[0], "r", encoding="utf-8") as fh:
            code = fh.read()
        workdir = args[1] if len(args) > 1 else os.path.dirname(os.path.abspath(args[0]))

    if health() is None:
        print("no script server on 127.0.0.1:8765 - in Cascadeur run "
              "Scripts > MCP > Start script server")
        return 3

    code = "WORKDIR = r'''%s'''\n" % os.path.abspath(workdir) + code
    try:
        out = run(code)
    except urllib.error.URLError as e:
        print("script server unreachable:", e)
        return 3

    for m in out.get("messages", []):
        lvl = m.get("level", "?")
        txt = m.get("text", "")
        print(txt if lvl == "Info" else "[%s] %s" % (lvl, txt))
    if not out.get("ok"):
        print("!! SCRIPT FAILED")
        print(out.get("error", "")[:4000])
        return 1
    if out.get("value"):
        print("VALUE:", out["value"])
    return 0


if __name__ == "__main__":
    sys.exit(main())
