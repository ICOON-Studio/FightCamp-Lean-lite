"""agent_watch.py - wake the Claude session the moment an agent run lands (S240).

Operator S240: "can communications between agents improve to speed up production? is there anything on our workflow built so that is
based on human speed and not for an ai agent" - the answer was: nothing told Claude when a run finished; it polled Arena chats,
Grok threads and git by hand (an Arena run sat at "orchestrating" for an hour unseen). This loop reads the same witnesses as
Tools/board_reconcile.py (branch, PR, Actions run, issue) every INTERVAL seconds and EXITS as soon as any running/waiting run in
AgentComms/live_runs.json changes verdict to landed / merged / dead - started as a background job in a Claude session, its exit
is a notification that wakes Claude, who collects at once (fast lane first: Tools/auto_collect.py).

    python Tools/agent_watch.py                 # poll every 180 s, give up after 120 min (exit 3 = nothing landed)
    python Tools/agent_watch.py 120 90          # poll every 120 s, give up after 90 min

Read-only: it never writes live_runs.json (the 30-min "FightCamp Board Reconcile" task does --apply). Stdlib + gh.
"""
from __future__ import annotations

import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import board_reconcile  # noqa: E402

ACT = ("landed", "merged", "dead")


def main(argv: list[str]) -> int:
    interval = int(argv[1]) if len(argv) > 1 else 180
    budget_min = int(argv[2]) if len(argv) > 2 else 120
    first = {r["id"]: r["verdict"] for r in board_reconcile.reconcile()["rows"]}
    already = [k for k, v in first.items() if v in ACT]
    if already:
        print("AGENT_WATCH already landed at start:", ", ".join("%s=%s" % (k, first[k]) for k in already))
    print("AGENT_WATCH watching %d runs every %d s for %d min" % (len(first), interval, budget_min))
    deadline = time.time() + budget_min * 60
    while time.time() < deadline:
        time.sleep(interval)
        try:
            rows = board_reconcile.reconcile()["rows"]
        except Exception as exc:  # a gh hiccup is not a landing
            print("AGENT_WATCH read failed:", exc)
            continue
        changed = [r for r in rows if r["verdict"] in ACT and first.get(r["id"]) not in ACT]
        if changed:
            for r in changed:
                print("AGENT_WATCH %s %s %s - %s%s" % (r["verdict"].upper(), r["agent"], r["id"], r["why"],
                                                     (" | FAST LANE: %s" % r["fast_lane"]) if r.get("fast_lane") else ""))
            return 0
    print("AGENT_WATCH nothing landed in %d min" % budget_min)
    return 3


if __name__ == "__main__":
    sys.exit(main(sys.argv))
