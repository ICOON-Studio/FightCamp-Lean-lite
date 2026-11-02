"""nightly_fetch.py - bring the cloud nightly's result onto the PC (S259: the full suite left the PC for GitHub runners).

    python Tools/nightly_fetch.py            # fetch the newest finished master nightly if not fetched yet (quiet when nothing new)
    python Tools/nightly_fetch.py --force    # fetch it again
    python Tools/nightly_fetch.py status     # the newest nightly runs and what was fetched

The workflow .github/workflows/nightly-suite.yml (03:00 UTC, 16 shards) uploads the artifact "nightly-suite" holding the same
three files Tools/nightly_suite.cmd wrote on the PC (latest.txt, suite_<date>.log, head_<date>.txt). They are copied into
AgentComms/nightly/ (untracked), so sessions, pm_bot.py and nightly_revert.py read them exactly as before; then
nightly_revert.py --apply runs once per new night, as the PC task did (dry run until armed). Called by `agent_comms.py start`
and the 30-min board_reconcile. Never raises: a failed fetch prints one line.
"""
from __future__ import annotations

import json
import shutil
import subprocess
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
NIGHTLY = ROOT / "AgentComms" / "nightly"
STATE = NIGHTLY / "cloud_fetch.json"
WORKFLOW = "nightly-suite.yml"
REPO = "ICOON-Studio/FightCamp-Lean"
_NO_WINDOW = getattr(subprocess, "CREATE_NO_WINDOW", 0)


def _run(args: list[str], timeout: int = 120) -> subprocess.CompletedProcess:
    return subprocess.run(args, cwd=str(ROOT), capture_output=True, text=True, encoding="utf-8", errors="replace",
                          timeout=timeout, creationflags=_NO_WINDOW)


def runs(limit: int = 10) -> list[dict]:
    """Newest first. Only master nightlies (run-name ends with the tested ref) count as THE nightly."""
    p = _run(["gh", "run", "list", "--repo", REPO, "--workflow", WORKFLOW, "--limit", str(limit), "--json",
              "databaseId,status,conclusion,createdAt,updatedAt,url,displayTitle,event"], 60)
    try:
        rows = json.loads(p.stdout or "[]")
    except ValueError:
        return []
    return [r for r in rows if str(r.get("displayTitle", "")).endswith(" master")]


def _state() -> dict:
    try:
        return json.loads(STATE.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return {}


def fetch(force: bool = False) -> str:
    done = [r for r in runs() if r.get("status") == "completed"]
    if not done:
        return "NIGHTLY_FETCH no finished cloud nightly yet"
    run = done[0]
    st = _state()
    if not force and st.get("run_id") == run["databaseId"]:
        return ""
    with tempfile.TemporaryDirectory(prefix="nightly_fetch_") as tmp:
        p = _run(["gh", "run", "download", str(run["databaseId"]), "--repo", REPO, "-n", "nightly-suite", "-D", tmp], 180)
        got = sorted(Path(tmp).rglob("*.*"))
        if p.returncode != 0 or not any(f.name == "latest.txt" for f in got):
            return "NIGHTLY_FETCH run %s (%s) has no nightly-suite result: %s" % (
                run["databaseId"], run.get("conclusion"), (p.stderr or p.stdout).strip()[:200])
        NIGHTLY.mkdir(parents=True, exist_ok=True)
        for f in got:
            shutil.copy2(f, NIGHTLY / f.name)
    STATE.write_text(json.dumps({"run_id": run["databaseId"], "url": run.get("url"), "conclusion": run.get("conclusion"),
                                 "created": run.get("createdAt"),
                                 "fetched": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")}, indent=1) + "\n",
                     encoding="utf-8")
    ## The PC task ran the auto-revert right after each night (S249); it moves here with the night itself.
    rv = _run([sys.executable, str(ROOT / "Tools" / "nightly_revert.py"), "--apply"], 300)
    date = (NIGHTLY / "latest.txt").read_text(encoding="utf-8-sig", errors="replace").split(" ", 1)[0]
    (NIGHTLY / f"revert_{date}.log").write_text(rv.stdout + rv.stderr, encoding="utf-8")
    first = (NIGHTLY / "latest.txt").read_text(encoding="utf-8-sig", errors="replace").splitlines()[0]
    return "NIGHTLY_FETCH %s <- %s" % (first, run.get("url"))


def main() -> int:
    if len(sys.argv) > 1 and sys.argv[1] == "status":
        for r in runs(5):
            print("%s %-10s %-9s %s" % (r.get("createdAt"), r.get("status"), r.get("conclusion") or "-", r.get("url")))
        print("fetched:", json.dumps(_state()))
        return 0
    try:
        line = fetch(force="--force" in sys.argv)
    except Exception as exc:  # never breaks a caller
        line = "NIGHTLY_FETCH failed: %s" % exc
    if line:
        print(line)
    return 0


if __name__ == "__main__":
    sys.exit(main())
