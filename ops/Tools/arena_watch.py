"""Watch Arena runs on the lite repo and print ONE line when a run ends (S565).

Arena pushes to ICOON-Studio/FightCamp-Lean-lite; the relay to the main repo runs only every 30 min and sees a pull
request, not a result. This reads each run's result file on its own branch and prints when it carries the task's done
line (`<ID> DONE` / `<ID> BLOCKED`), and a STALL line when a branch has had no commit for a long time.

  python -u ops/Tools/arena_watch.py <secs> <ID>=<branch-id>[:<result path>] ...
      e.g. python -u ops/Tools/arena_watch.py 180 LONG1=cba93bd0 TELLS3M=181a4c7c
  The result path defaults to docs/<ID>_RESULT.md. Exits when every run has ended. Reads GitHub only.
"""
from __future__ import annotations

import base64
import datetime
import json
import subprocess
import sys
import time

REPO = "ICOON-Studio/FightCamp-Lean-lite"
STALL_MIN = 75


def gh(path: str):
    r = subprocess.run(["gh", "api", path], capture_output=True, text=True, encoding="utf-8", errors="replace")
    if r.returncode != 0:
        return None
    try:
        return json.loads(r.stdout)
    except ValueError:
        return None


def main() -> int:
    secs = int(sys.argv[1])
    runs = {}
    for a in sys.argv[2:]:
        tid, rest = a.split("=", 1)
        bid, _, path = rest.partition(":")
        runs[tid] = {"branch": "arena/%s-fightcamp-lean-lite" % bid, "path": path or "docs/%s_RESULT.md" % tid, "stalled": False}
    while runs:
        for tid in list(runs):
            r = runs[tid]
            got = gh("repos/%s/contents/%s?ref=%s" % (REPO, r["path"], r["branch"]))
            if isinstance(got, dict) and got.get("content"):
                text = base64.b64decode(got["content"]).decode("utf-8", "replace")
                tail = [ln.strip() for ln in text.strip().splitlines() if ln.strip()][-3:]
                for word in ("DONE", "BLOCKED"):
                    hit = [ln for ln in tail if ("%s %s" % (tid, word)) in ln]
                    if hit:
                        print("ARENA_%s %s  %s  | %s" % (word, tid, r["branch"], hit[-1][:160]), flush=True)
                        del runs[tid]
                        break
                if tid not in runs:
                    continue
            if not r["stalled"]:
                c = gh("repos/%s/commits?sha=%s&per_page=1" % (REPO, r["branch"]))
                if isinstance(c, list) and c:
                    when = datetime.datetime.fromisoformat(c[0]["commit"]["committer"]["date"].replace("Z", "+00:00"))
                    idle = (datetime.datetime.now(datetime.timezone.utc) - when).total_seconds() / 60
                    if idle > STALL_MIN:
                        r["stalled"] = True
                        print("ARENA_STALL %s  no commit for %d min (last: %s)" % (tid, idle, c[0]["commit"]["message"].splitlines()[0][:100]), flush=True)
        if runs:
            time.sleep(secs)
    print("ARENA_WATCH all runs ended", flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
