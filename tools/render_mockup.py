"""Renders an HTML menu mockup to a 1920x1080 PNG beside it, off screen with headless Edge (S403).
Usage: python tools/render_mockup.py docs/mockups/s403/home.html [more.html ...]  Each file gets its own browser profile, so
several agents can render at once. Nothing opens on a monitor."""
import os
import pathlib
import shutil
import subprocess
import sys
import tempfile
import time

EDGE = next(p for p in (r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe", r"C:\Program Files\Microsoft\Edge\Application\msedge.exe") if os.path.exists(p))


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


if __name__ == "__main__":
    for a in sys.argv[1:]:
        print(render(pathlib.Path(a)))
