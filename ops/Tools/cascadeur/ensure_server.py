#!/usr/bin/env python3
"""Bring Cascadeur up WITH its script server, with no human click. Idempotent.

    python Tools/cascadeur/ensure_server.py

UNTIL 2026-09-22 THIS NEEDED A MENU CLICK AND THAT PUT THE OPERATOR IN THE LOOP.
Cascadeur's own README says *"Run `MCP.Start script server` from the commands
menu"*, and every session here has repeated it, so an agent could not reach
Cascadeur on its own - which is exactly the relay seat the 2026-09-09
direct-reach ruling exists to remove.

**MEASURED HERE, END TO END:** `cascadeur.exe --run-python-code <code>` executes
INSIDE THE LIVE APP - the pid it prints is the running instance's, not a
throwaway - so the server can be started over the same channel it serves. Proof
of each step, in order:

  1. `--run-python-code` writing a file            -> the file appeared
  2. the same code printing `os.getpid()`          -> 69972, the LIVE app's pid
  3. `from ... import start; start()`              -> TypeError, needs a scene
  4. `start(app.get_scene_manager().current_scene())` -> no exception
  5. `Get-NetTCPConnection -LocalPort 8765`        -> LISTENING, owner 69972
  6. `GET /health`                                 -> `{"ok": true, ...}`
  7. `csend.py -c "print(app.current_scene().name())"` -> `untitled.casc`

**STEP 3 IS THE ONE THAT WASTES A SESSION IF YOU GUESS.** `start` is
`start(scene, host, port)` - the bare `start()` every obvious attempt makes
raises `TypeError: missing 1 required positional argument: 'scene'`, and the
`--run-python-code` channel SWALLOWS THE TRACEBACK: the launcher still prints
`Application finished with exit code 0`. Write the traceback to a file and read
it, or you will conclude the channel does not work when it does.

**AND CASCADEUR IS SINGLE-INSTANCE.** A leftover process swallows every
`Start-Process` and you get `MainWindowHandle = 0` for ever. If this script
reports a window that never appears, kill every `cascadeur` process and re-run -
the squatter is the cause, not the launch.
"""

from __future__ import annotations

import subprocess
import argparse
import json
import textwrap
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path

EXE = Path(r"C:\Program Files\Cascadeur\cascadeur.exe")
HEALTH = "http://127.0.0.1:8765/health"

## Run inside the live app. `app` is NOT in scope here - that name is injected
## by the MCP server's own `/run`, which is the thing we are trying to start -
## so the application handle is fetched through `csc` instead.
START_CODE = (
    "import traceback\n"
    "try:\n"
    "    import csc\n"
    "    from scripts.mcp.script_server import start\n"
    "    _app = csc.app.get_application()\n"
    "    start(_app.get_scene_manager().current_scene())\n"
    "except Exception:\n"
    "    open(r'{log}', 'w').write(traceback.format_exc())\n"
)


def healthy(timeout: float = 5.0) -> bool:
    try:
        with urllib.request.urlopen(HEALTH, timeout=timeout) as r:
            return b'"ok": true' in r.read()
    except (urllib.error.URLError, OSError, ValueError):
        return False


def running() -> bool:
    try:
        out = subprocess.run(
            ["powershell", "-NoProfile", "-Command",
             "(Get-Process cascadeur -ErrorAction SilentlyContinue "
             "| Measure-Object).Count"],
            capture_output=True, text=True, timeout=60)
        return int((out.stdout or "0").strip() or 0) > 0
    except (OSError, ValueError, subprocess.SubprocessError):
        return False


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--hidden', action='store_true')
    args = parser.parse_args()
    if args.hidden:
        return ensure_hidden()
    if not EXE.exists():
        print("FAIL: Cascadeur is not installed at %s" % EXE)
        return 2

    if healthy():
        print("Cascadeur script server already up on 127.0.0.1:8765")
        return 0

    if not running():
        print("launching Cascadeur ...")
        subprocess.Popen([str(EXE)], close_fds=True)
        ## The window has to exist before the app will accept forwarded code.
        for _ in range(36):
            time.sleep(5)
            if running():
                break
        else:
            print("FAIL: Cascadeur did not start. It is SINGLE-INSTANCE - kill"
                  " every leftover `cascadeur` process and re-run.")
            return 1
        ## The process exists well before its Python is warm.
        time.sleep(20)

    log = Path(__file__).resolve().parent / "_start_server_error.txt"
    if log.exists():
        log.unlink()
    code = START_CODE.format(log=str(log))
    subprocess.run([str(EXE), "--run-python-code", code],
                   capture_output=True, text=True, timeout=180)

    for _ in range(12):
        if healthy():
            print("Cascadeur script server UP on 127.0.0.1:8765")
            print("  verify: python Tools/cascadeur/csend.py -c"
                  " \"print(app.current_scene().name())\"")
            return 0
        time.sleep(5)

    ## THE CHANNEL SWALLOWS TRACEBACKS, so the only honest failure report is the
    ## one the injected code wrote down for us.
    if log.exists():
        print("FAIL: the server did not start. Cascadeur's own traceback:")
        print(log.read_text(encoding="utf-8", errors="replace"))
    else:
        print("FAIL: no server on 8765 and Cascadeur raised nothing.")
        print("  `--run-python-code` prints `exit code 0` even when the code"
              " raised, so a clean launcher log means NOTHING here.")
        print("  Check the app's own event log:")
        print(r"  %LOCALAPPDATA%\Nekki Limited\Cascadeur\logs\cascadeur_log.log")
    return 1


def ensure_hidden():
    if not EXE.exists():
        print('FAIL: Cascadeur executable missing')
        return 2
    work = Path(__file__).resolve().parent / 'animsource1'
    work.mkdir(exist_ok=True)
    evidence = work / '_hidden_desktop.json'
    if healthy():
        from csend import run
        result = run("import ctypes; u=ctypes.WinDLL('user32'); k=ctypes.WinDLL('kernel32'); u.GetThreadDesktop.restype=ctypes.c_void_p; u.GetUserObjectInformationW.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p,ctypes.c_ulong,ctypes.c_void_p]; b=ctypes.create_unicode_buffer(256); n=ctypes.c_ulong(); assert u.GetUserObjectInformationW(u.GetThreadDesktop(k.GetCurrentThreadId()),2,b,ctypes.sizeof(b),ctypes.byref(n)); assert b.value=='FightCampCascadeur'; print('verified hidden desktop:',b.value)")
        print(result)
        return 0 if result.get('ok') else 2
    if running():
        print('FAIL: existing Cascadeur lacks a verified server; do not forward to an unknown instance')
        return 2
    log = work / '_hidden_start_error.txt'
    bootstrap = work / '_hidden_bootstrap.py'
    if log.exists():
        log.unlink()
    if evidence.exists():
        evidence.unlink()
    probe = (
        "import ctypes, os, json\n"
        "u=ctypes.WinDLL('user32'); k=ctypes.WinDLL('kernel32')\n"
        "u.GetThreadDesktop.restype=ctypes.c_void_p\n"
        "u.GetUserObjectInformationW.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p,ctypes.c_ulong,ctypes.c_void_p]\n"
        "b=ctypes.create_unicode_buffer(256); n=ctypes.c_ulong()\n"
        "assert u.GetUserObjectInformationW(u.GetThreadDesktop(k.GetCurrentThreadId()),2,b,ctypes.sizeof(b),ctypes.byref(n))\n"
        "assert b.value=='FightCampCascadeur', b.value\n"
        f"open({str(evidence)!r},'w').write(json.dumps(dict(pid=os.getpid(),desktop=b.value)))\n"
    )
    guarded_probe = ('import traceback\ntry:\n' + textwrap.indent(probe, '    ')
        + f'except Exception:\n    open({str(log)!r}, "w").write(traceback.format_exc())\n    raise\n')
    bootstrap.write_text(guarded_probe + START_CODE.format(log=str(log)), encoding='utf-8')
    launcher = Path(__file__).resolve().parents[1] / 'cascadeur_hidden.ps1'
    with (work / '_hidden_launcher.log').open('w') as output:
        subprocess.Popen(['powershell', '-NoProfile', '-ExecutionPolicy', 'Bypass',
            '-File', str(launcher)],
            stdout=output, stderr=subprocess.STDOUT,
            creationflags=subprocess.CREATE_NO_WINDOW, close_fds=True)
    time.sleep(20)
    if not running():
        print('FAIL: hidden GUI exited during startup')
        return 2
    with (work / '_hidden_forward.log').open('w') as output:
        subprocess.Popen(['powershell', '-NoProfile', '-ExecutionPolicy', 'Bypass',
            '-File', str(launcher), '-CodeFile', str(bootstrap)],
            stdout=output, stderr=subprocess.STDOUT,
            creationflags=subprocess.CREATE_NO_WINDOW, close_fds=True)
    for _ in range(60):
        if healthy():
            if evidence.exists() and json.loads(evidence.read_text())['desktop'] == 'FightCampCascadeur':
                print('Hidden Cascadeur server UP, in-app desktop evidence:', evidence.read_text())
                return 0
            print('FAIL: missing in-app desktop verification')
            return 2
        if log.exists():
            print(log.read_text(encoding='utf-8'))
            return 1
        # A cold application can discard the first forwarded request while
        # warming its Python/licence runtime. Retry on the SAME hidden desktop.
        if _ > 0 and _ % 10 == 0:
            with (work / '_hidden_forward.log').open('a') as output:
                subprocess.Popen(['powershell', '-NoProfile', '-ExecutionPolicy', 'Bypass',
                    '-File', str(launcher), '-CodeFile', str(bootstrap)],
                    stdout=output, stderr=subprocess.STDOUT,
                    creationflags=subprocess.CREATE_NO_WINDOW, close_fds=True)
        time.sleep(2)
    print('FAIL: hidden launch timeout; see', work / '_hidden_launcher.log')
    return 1


if __name__ == "__main__":
    sys.exit(main())
