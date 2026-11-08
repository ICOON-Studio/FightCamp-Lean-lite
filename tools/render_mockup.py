"""Renders an HTML menu mockup to a 1920x1080 PNG beside it, off screen with headless Edge (S403).
Usage: python tools/render_mockup.py docs/mockups/s403/home.html [more.html ...]  Each file gets its own browser profile, so
several agents can render at once. Nothing opens on a monitor."""
import ctypes
import msvcrt
import os
import pathlib
import shutil
import subprocess
import sys
import tempfile
import time

EDGE = next(p for p in (r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe", r"C:\Program Files\Microsoft\Edge\Application\msedge.exe") if os.path.exists(p))


MIN_COMMIT_GB = 2.5


def render(html: pathlib.Path) -> pathlib.Path:
    html = html.resolve()
    png = html.with_suffix(".png")
    tmp = html.with_suffix(".rendering.png")   # the old picture stays until the new one exists
    tmp.unlink(missing_ok=True)
    err = ""
    for mode in ("--headless", "--headless=new"):
        profile = tempfile.mkdtemp(prefix="edge_mockup_")
        try:
            r = subprocess.run([EDGE, mode, "--disable-gpu", "--no-first-run", "--hide-scrollbars", "--force-device-scale-factor=1", "--allow-file-access-from-files",
                                f"--user-data-dir={profile}", "--window-size=1920,1080", "--virtual-time-budget=3000", f"--screenshot={tmp}", html.as_uri()],
                               timeout=120, capture_output=True, text=True)
            err = f"rc {r.returncode} {r.stderr[-300:]}"
            # Edge's launcher exits 0 while its child is still writing the file.
            for _ in range(60):
                if tmp.exists() and tmp.stat().st_size > 0:
                    time.sleep(1.0)
                    tmp.replace(png)
                    return png
                time.sleep(1.0)
        finally:
            shutil.rmtree(profile, ignore_errors=True)
    raise SystemExit(f"no PNG for {html}: {err}")


def commit_free_gb() -> float:
    """Free commit memory (RAM + page file), the number the PC watchdog reads."""
    class Status(ctypes.Structure):
        _fields_ = [("len", ctypes.c_ulong), ("load", ctypes.c_ulong)] + [(n, ctypes.c_ulonglong) for n in ("tp", "ap", "tf", "af", "tv", "av", "ae")]
    s = Status()
    s.len = ctypes.sizeof(Status)
    ctypes.windll.kernel32.GlobalMemoryStatusEx(ctypes.byref(s))
    return s.af / 2**30


def wait_for_turn(lock):
    """One Edge at a time across every agent, and none while the PC is short of memory (S403: seven designers at once beside a game)."""
    deadline = time.time() + 900
    while time.time() < deadline:
        try:
            msvcrt.locking(lock.fileno(), msvcrt.LK_NBLCK, 1)
        except OSError:
            time.sleep(1.0)
            continue
        if commit_free_gb() >= MIN_COMMIT_GB:
            return
        msvcrt.locking(lock.fileno(), msvcrt.LK_UNLCK, 1)
        time.sleep(5.0)
    raise SystemExit(f"waited 15 min: another render is stuck or the PC has under {MIN_COMMIT_GB} GB of commit memory free. Say so in your report.")


if __name__ == "__main__":
    with open(pathlib.Path(tempfile.gettempdir()) / "fightcamp_render_mockup.lock", "a+b") as lock:
        for a in sys.argv[1:]:
            wait_for_turn(lock)
            print(render(pathlib.Path(a)))
            msvcrt.locking(lock.fileno(), msvcrt.LK_UNLCK, 1)
