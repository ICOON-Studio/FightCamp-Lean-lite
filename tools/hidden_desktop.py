"""(Copied from E:/SpaceGame/tools/hidden_desktop.py.) Run a program on a separate, never-shown Windows desktop, so no window can appear on the owner's
monitors (owner ruling 2026-10-03: off-screen placement still showed on his second monitor).

The desktop "SpaceStrategyHidden" lives in the same window station but is never switched to. Windows
started there are invisible to the owner; we capture them with PrintWindow and stop the process by PID.

  python tools/hidden_desktop.py capture <exe> <out.png> [args...]   our build saves its own picture
  python tools/hidden_desktop.py run [--timeout=S] [--log=F] <exe> [args...]   run anything (Blender, a game tour)
                                                          hidden, wait for it to exit; exit code passed on

Tested 2026-10-03 (session 9): the game runs there (OpenGL on the real GPU) and its --capture= picture is
exact; Windows' PrintWindow returns a blank window there, so builds capture themselves.
"""
import ctypes
import subprocess
import sys
import time
from ctypes import wintypes
from pathlib import Path

DESKTOP = "FightCampHidden"
user32 = ctypes.WinDLL("user32", use_last_error=True)
kernel32 = ctypes.WinDLL("kernel32", use_last_error=True)
GENERIC_ALL = 0x10000000
IDLE_PRIORITY_CLASS = 0x40


class STARTUPINFO(ctypes.Structure):
    _fields_ = [("cb", wintypes.DWORD), ("lpReserved", wintypes.LPWSTR), ("lpDesktop", wintypes.LPWSTR),
                ("lpTitle", wintypes.LPWSTR), ("dwX", wintypes.DWORD), ("dwY", wintypes.DWORD),
                ("dwXSize", wintypes.DWORD), ("dwYSize", wintypes.DWORD), ("dwXCountChars", wintypes.DWORD),
                ("dwYCountChars", wintypes.DWORD), ("dwFillAttribute", wintypes.DWORD), ("dwFlags", wintypes.DWORD),
                ("wShowWindow", wintypes.WORD), ("cbReserved2", wintypes.WORD), ("lpReserved2", ctypes.c_void_p),
                ("hStdInput", wintypes.HANDLE), ("hStdOutput", wintypes.HANDLE), ("hStdError", wintypes.HANDLE)]


class PROCESS_INFORMATION(ctypes.Structure):
    _fields_ = [("hProcess", wintypes.HANDLE), ("hThread", wintypes.HANDLE),
                ("dwProcessId", wintypes.DWORD), ("dwThreadId", wintypes.DWORD)]


user32.CreateDesktopW.restype = wintypes.HANDLE
user32.CreateDesktopW.argtypes = [wintypes.LPCWSTR, wintypes.LPCWSTR, ctypes.c_void_p, wintypes.DWORD,
                                  wintypes.DWORD, ctypes.c_void_p]


def desktop():
    h = user32.CreateDesktopW(DESKTOP, None, None, 0, GENERIC_ALL, None)
    if not h:
        raise OSError(ctypes.get_last_error(), "CreateDesktop failed")
    return h


def start(cmd, cwd=None, log=None):
    """Start cmd (a list) on the hidden desktop at idle priority; returns the PID. log: a file path that
    receives the program's stdout and stderr."""
    desktop()
    si = STARTUPINFO()
    si.cb = ctypes.sizeof(si)
    si.lpDesktop = DESKTOP
    inherit = False
    if log:
        import msvcrt
        f = open(log, "wb")
        h = msvcrt.get_osfhandle(f.fileno())
        kernel32.SetHandleInformation(wintypes.HANDLE(h), 1, 1)  # HANDLE_FLAG_INHERIT
        si.dwFlags |= 0x100  # STARTF_USESTDHANDLES
        si.hStdOutput = si.hStdError = h
        inherit = True
        start._keep = f
    pi = PROCESS_INFORMATION()
    line = subprocess.list2cmdline(cmd)
    ok = kernel32.CreateProcessW(None, ctypes.create_unicode_buffer(line), None, None, inherit,
                                 IDLE_PRIORITY_CLASS, None, cwd, ctypes.byref(si), ctypes.byref(pi))
    if not ok:
        raise OSError(ctypes.get_last_error(), "CreateProcess failed")
    kernel32.CloseHandle(pi.hThread)
    kernel32.CloseHandle(pi.hProcess)
    return pi.dwProcessId


def windows_of(pid):
    h = user32.OpenDesktopW(DESKTOP, 0, False, GENERIC_ALL)
    found = []

    @ctypes.WINFUNCTYPE(wintypes.BOOL, wintypes.HWND, wintypes.LPARAM)
    def cb(hwnd, _):
        owner = wintypes.DWORD()
        user32.GetWindowThreadProcessId(hwnd, ctypes.byref(owner))
        if owner.value == pid and user32.IsWindowVisible(hwnd):
            found.append(hwnd)
        return True

    user32.EnumDesktopWindows(h, cb, 0)
    user32.CloseDesktop(h)
    return found


def stop(pid):
    subprocess.run(["taskkill", "/PID", str(pid), "/F"], capture_output=True)


if __name__ == "__main__":
    a = sys.argv[1:]
    if len(a) >= 2 and a[0] == "run":
        rest, timeout_s, log = a[1:], 900, None
        while rest and rest[0].startswith("--"):
            k, _, v = rest.pop(0).partition("=")
            if k == "--timeout":
                timeout_s = int(v)
            elif k == "--log":
                log = v
        if any(k in Path(rest[0]).name.lower() for k in ("godot", "fightcamp")):
            rest = [rest[0], "--audio-driver", "Dummy", *rest[1:]]  # owner s42: "sounds off on tests"
        pid = start(rest, cwd=str(Path.cwd()), log=log)
        SYNCHRONIZE, QUERY = 0x00100000, 0x1000
        h = kernel32.OpenProcess(SYNCHRONIZE | QUERY, False, pid)
        code = wintypes.DWORD(1)
        if kernel32.WaitForSingleObject(h, timeout_s * 1000) != 0:
            print("timeout after", timeout_s, "s: stopped PID", pid)
            stop(pid)
            sys.exit(124)
        kernel32.GetExitCodeProcess(h, ctypes.byref(code))
        kernel32.CloseHandle(h)
        sys.exit(code.value)
    elif len(a) >= 3 and a[0] == "capture":
        # Our builds save their own picture (--capture=): Windows' PrintWindow sees only a blank window on
        # a desktop that is never shown.
        exe, out, rest = a[1], str(Path(a[2]).resolve()), a[3:]
        wait_s = 30  # --wait=<seconds> (ours, not passed on): renders take longer than screen checks
        for r in [r for r in rest if r.startswith("--wait=")]:
            wait_s = int(r.split("=", 1)[1])
            rest.remove(r)
        Path(out).unlink(missing_ok=True)
        # owner s42: "sounds off on tests" - a hidden window still plays sound
        pid = start([exe, "--audio-driver", "Dummy", *rest, f"--capture={out}"], cwd=str(Path(exe).parent))
        try:
            for _ in range(wait_s * 2):
                time.sleep(0.5)
                if Path(out).exists():
                    break
            time.sleep(0.7)
            print("captured", out) if Path(out).exists() else print("no capture (does this build know --capture=?)")
        finally:
            stop(pid)
    else:
        print(__doc__)
        sys.exit(2)
