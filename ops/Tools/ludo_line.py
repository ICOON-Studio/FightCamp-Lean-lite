"""ludo_line.py - S521 (owner: "whyh did you stop using ludo ?"): Ludo sat unused from S474 to S520 while its paid credits
ran down to a pause (~2026-12-11, memory project-ludo-paused-s437), because nothing at session start named it. `start` now
prints one line: credits left, the day they stop, and the last commit that used Ludo - so every session's agent sweep sees it.

    python ops/Tools/ludo_line.py        # the line alone
"""
from __future__ import annotations

import json
import shutil
import subprocess
from datetime import datetime, timezone
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
## The owner's plan (S437): paid to about 11 Dec 2026, then paused 3 months.
PAUSE_FROM = "2026-12-11"


def _run(cmd: list[str], timeout: float) -> str:
    try:
        exe = shutil.which(cmd[0]) or cmd[0]
        out = subprocess.run([exe] + cmd[1:], capture_output=True, text=True, timeout=timeout, cwd=REPO,
                             creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
        return out.stdout or ""
    except Exception:
        return ""


def line() -> str:
    raw = _run(["ludo", "account"], 15.0)
    credits = "?"
    try:
        acc = json.loads(raw.strip().splitlines()[0])
        credits = "%.0f" % float(acc["credits"]["available"])
        if acc["credits"].get("paused"):
            credits += " (PAUSED)"
    except Exception:
        pass
    last = _run(["git", "log", "-1", "-i", "--grep=ludo", "--format=%ad %h %s", "--date=short"], 10.0).strip()[:110]
    days = (datetime.fromisoformat(PAUSE_FROM).replace(tzinfo=timezone.utc) - datetime.now(timezone.utc)).days
    return ("LUDO credits %s, paid until ~%s (%d days) - give it asset work this session (painted screens, sounds, "
            "pictures; skill `ludo`). Last used: %s" % (credits, PAUSE_FROM, days, last or "never"))


if __name__ == "__main__":
    print(line())
