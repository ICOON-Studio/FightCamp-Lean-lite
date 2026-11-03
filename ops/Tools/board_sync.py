"""board_sync.py - S232 (operator: "can you automate this board update process so you do not have to lose time on that").

Runs after Tools/board_reconcile.py in the "FightCamp Board Reconcile" task (every 30 min) and keeps the ops board's
bookkeeping current without a Claude session:

  1. live_runs.json  runs whose status is collected / merged / rejected / cancelled move to live_runs_archive.json
                     (a landed run stays: it is waiting for Claude to collect it - `start` lists it under COLLECT NOW)
  2. plan.working_now  rebuilt from live_runs: every running / waiting / landed / stale run, in plain words
  3. plan.done_recently  the newest archived runs on top (max 12, no duplicates), so the board shows what finished

    python Tools/board_sync.py            # report what would change
    python Tools/board_sync.py --apply    # write it

Queue rows (roadmap queue.tasks) are judgement and stay with Claude/Paul: board answers wake Paul (opsboard
/api/answer -> pm_bot inbox) and his BOARD EDITS notes are applied by `pm_bot.py apply`.
"""
from __future__ import annotations

import json
import sys
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RUNS = ROOT / "AgentComms" / "live_runs.json"
ARCHIVE = ROOT / "AgentComms" / "live_runs_archive.json"
ROADMAP = ROOT / "AgentComms" / "roadmap.json"
FINISHED = ("collected", "merged", "rejected", "cancelled", "superseded", "done", "closed")  # S249: "closed" = PR closed without a collect
SHOWN = {"running": "", "waiting": "waiting", "landed": "LANDED - Claude collects", "stale": "STOPPED - Claude relaunches or closes"}
DONE_MAX = 12


def _load(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8-sig"))  # S249: a hand-saved live_runs.json may carry a BOM


def _save(path: Path, data: dict) -> None:
    path.write_text(json.dumps(data, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")


def sync(runs_reg: dict, archive: dict, plan: dict, stamp: str) -> list[str]:
    """Mutates the three dicts; returns one line per change."""
    changes: list[str] = []
    runs: dict = runs_reg.setdefault("runs", {})
    arch = archive.setdefault("runs", {})   # S377: since S366 the archive file keeps a LIST of runs (each with its id)
    for run_id in list(runs):
        info = runs[run_id]
        if isinstance(info, dict) and str(info.get("status", "")).lower() in FINISHED:
            info.setdefault("archived", stamp + " board_sync")
            if isinstance(arch, list):
                arch.append(dict(runs.pop(run_id), id=run_id))
            else:
                key = run_id if run_id not in arch else "%s_%s" % (run_id, stamp.replace(" ", "_").replace(":", ""))
                arch[key] = runs.pop(run_id)
            changes.append("archived %s (%s)" % (run_id, info.get("status")))
            done = {"title": str(info.get("title", run_id)), "who": str(info.get("agent", "")), "when": stamp[:10]}
            rows = [r for r in plan.get("done_recently", []) if not (isinstance(r, dict) and r.get("title") == done["title"])]
            plan["done_recently"] = ([done] + rows)[:DONE_MAX]
    working = []
    for run_id, info in runs.items():
        if not isinstance(info, dict):
            continue
        status = str(info.get("status", "")).lower()
        if status not in SHOWN:
            continue
        row = {"title": str(info.get("title", run_id)), "who": str(info.get("agent", "")), "started": str(info.get("started", "")),
               "run": run_id}
        if SHOWN[status]:
            row["state"] = SHOWN[status]
        working.append(row)
    if working != plan.get("working_now"):
        plan["working_now"] = working
        changes.append("working_now = %d runs" % len(working))
    return changes


def main() -> int:
    stamp = datetime.now().strftime("%Y-%m-%d %H:%M")
    runs_reg, archive, roadmap = _load(RUNS), _load(ARCHIVE), _load(ROADMAP)
    plan = roadmap.setdefault("plan", {})
    changes = sync(runs_reg, archive, plan, stamp)
    for line in changes:
        print("BOARD_SYNC " + line)
    if changes and "--apply" in sys.argv:
        plan["updated"] = stamp + " board_sync"
        _save(ARCHIVE, archive)
        _save(RUNS, runs_reg)
        ROADMAP.write_text(json.dumps(roadmap, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print("BOARD_SYNC changes=%d applied=%s" % (len(changes), "--apply" in sys.argv))
    return 0


if __name__ == "__main__":
    sys.exit(main())
