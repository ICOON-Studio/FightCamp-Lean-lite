#!/usr/bin/env python3
"""The Cascadeur clip effort, reported at every session start - and the new
animations, listed at every session end.

OPERATOR RULE 2026-09-22, VERBATIM: *"i want a report on that task on every new
session and also display any new animations made by codex at the end of each
session"*.

WHY THIS IS A TOOL AND NOT A NOTE IN THE ROADMAP. This project's own finding,
2026-09-19: *"every rule broken was one with no mechanical gate behind it. Not
one gated rule was broken."* A standing instruction that lives as prose in a
handover is a rule a session has to remember. `agent_comms.py start` calls
`report()` below, so the report happens whether or not anyone remembers it.

AND IT REFUSES TO INVENT A NUMBER. Every figure here is either derived from
files on disk right now, or read from `AgentComms/clip_status.json` with the
commit it was measured at - and if anything that could change it has been
committed since, the figure prints **STALE** beside the command that refreshes
it. A gate that derives its own denominator from the thing it is judging cannot
fail, and a fossil presented as a measurement is worse than no measurement.

Usage:
    python Tools/clip_status.py report
    python Tools/clip_status.py new-anims [--since <git-ref>]
    python Tools/clip_status.py record --arm-error 28.4 --note "C167 landed"
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
STATUS_JSON = ROOT / "AgentComms" / "clip_status.json"

## The files whose change makes a recorded measurement stale. If any of these is
## committed after the measurement, the number on file describes a tree that no
## longer exists.
WATCHED = [
    "Godot/scripts/FightClipRetarget.gd",
    "Godot/scripts/FightClipBinding.gd",
    "Godot/assets/data/technique_catalog.json",
    "Godot/assets/anim/audition/cascadeur",
]

## Where an authored or bought animation can land. Used by `new-anims` to decide
## what counts as "a new animation" rather than guessing from a commit message.
ANIM_DIRS = [
    "Godot/assets/anim/",
    "Godot/assets/models/fighters/anim/",
]
ANIM_SUFFIXES = (".glb", ".fbx", ".anim", ".res", ".tres")
## `.import` sidecars and texture dumps ride alongside every real clip and are
## not themselves animations.
ANIM_SKIP = (".import", ".uid", ".png", ".jpg", ".jpeg", ".md5")

REFRESH_ARM = (
    "Godot_v4.7.2-stable_win64_console.exe --headless --path Godot "
    "--script tools/s31_contact_probe.gd -- mma_dirty_boxing"
)
REFRESH_CENSUS = (
    "Godot_v4.7.2-stable_win64_console.exe --headless --path Godot "
    "--script tools/q133_clip_coverage.gd"
)
RENDER_SHEETS = (
    "Godot_v4.7.2-stable_win64_console.exe --headless --path Godot "
    "--script tools/audit_clip_contact_sheets.gd"
)


def _git(*args: str) -> str:
    try:
        out = subprocess.run(
            ["git", "-C", str(ROOT), *args],
            capture_output=True, text=True, timeout=30, encoding="utf-8",
            errors="replace")
        return (out.stdout or "").strip()
    except (OSError, subprocess.SubprocessError):
        return ""


def _load() -> dict:
    try:
        return json.loads(STATUS_JSON.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return {}


def _last_touch(path: str) -> str:
    """The ISO date of the newest commit touching `path`, or ''."""
    return _git("log", "-1", "--format=%cI", "--", path)


def _stale_because() -> list:
    """Every watched path committed since the recorded measurement."""
    rec = _load()
    taken = str(rec.get("when", ""))
    if not taken:
        return ["nothing has ever been recorded"]
    out = []
    for path in WATCHED:
        touched = _last_touch(path)
        if touched and touched > taken:
            out.append("%s (committed %s)" % (path, touched[:16]))
    return out


def _task_state() -> list:
    """C167's state, read off the disk rather than off anyone's memory."""
    rows = []
    task = ROOT / "research" / "TASK_C167_THE_ARMS_MUST_ARRIVE.md"
    digest = ROOT / "research" / "C167_DIGEST.md"
    if not task.exists():
        rows.append("C167  TASK FILE MISSING - it was committed 2026-09-22; "
                    "something removed it")
    elif digest.exists():
        rows.append("C167  DIGEST ON DISK - collect it, verify the number on "
                    "our own tree, and do NOT take the report at face value")
    else:
        rows.append("C167  ASSIGNED, NO DIGEST YET - still in flight or never "
                    "launched. Check its worktree for uncommitted work before "
                    "relaunching.")
    return rows


def report(_args=None) -> int:
    """The section `agent_comms.py start` prints. Never raises."""
    rec = _load()
    print()
    print("=" * 78)
    print("CASCADEUR CLIPS - the operator asked for this report every session")
    print("=" * 78)
    print("  THE OBJECTIVE: author the missing clips in Cascadeur. The chain")
    print("  works end to end; what is NOT yet true is that the arms arrive.")
    print()

    arm = rec.get("arm_error_pct")
    arm_pair = str(rec.get("arm_pair", "att_lhand_to_vic_neck"))
    if arm is None:
        print("  arm error      NEVER MEASURED - run it before trusting any clip")
    else:
        print("  worst contact  %s = %.1f%% (gate: 30%% or better, a CEILING)"
              % (arm_pair, float(arm)))
        print("                 measured %s at %s"
              % (str(rec.get("when", "?"))[:16], str(rec.get("commit", "?"))[:8]))
    print("                 refresh: %s" % REFRESH_ARM)
    print()

    bound = rec.get("bound")
    total = rec.get("total_motion")
    if bound is None or total is None:
        print("  clip coverage  NEVER RECORDED")
    else:
        pct = (100.0 * float(bound) / float(total)) if total else 0.0
        print("  clip coverage  %s of %s motion techniques bound (%.1f%%), "
              "%s with NO clip" % (bound, total, pct, int(total) - int(bound)))
    print("                 refresh: %s" % REFRESH_CENSUS)
    print()

    for row in _task_state():
        print("  " + row)

    stale = _stale_because()
    if stale:
        print()
        print("  ** STALE ** the numbers above predate work that could move them:")
        for item in stale:
            print("     - %s" % item)
        print("     Re-measure before you quote any of them.")

    note = str(rec.get("note", ""))
    if note:
        print()
        print("  note: %s" % note)
    print()
    print("  END OF SESSION: the operator also asked to SEE any new animation.")
    print("  Run `python Tools/clip_status.py new-anims` and send what it lists")
    print("  with SendUserFile - a render, not a filename.")
    return 0


def new_anims(args) -> int:
    """Animation files added since `--since`, for the end-of-session send."""
    since = args.since or _git("log", "-1", "--format=%H",
                               "--before=1 day ago") or "HEAD~20"
    names = _git("diff", "--name-status", "--diff-filter=AM", since, "HEAD")
    found = []
    for line in names.splitlines():
        parts = line.split("\t")
        if len(parts) < 2:
            continue
        path = parts[-1]
        if not any(path.startswith(d) for d in ANIM_DIRS):
            continue
        if path.endswith(ANIM_SKIP) or not path.endswith(ANIM_SUFFIXES):
            continue
        found.append(path)

    print("NEW ANIMATIONS since %s: %d" % (since[:8], len(found)))
    for path in sorted(set(found)):
        exists = "" if (ROOT / path).exists() else "   (NOT ON DISK)"
        print("  %s%s" % (path, exists))
    if not found:
        print("  none - say so plainly rather than sending an old render.")
        return 0
    print()
    print("  RENDER THEM BEFORE SENDING. A filename is not something the")
    print("  operator can look at, and this project has shipped four clips")
    print("  nobody watched:")
    print("    %s" % RENDER_SHEETS)
    print("  THEN RECORD A VIDEO - the operator, 2026-09-24: 'i dont see any animations,")
    print("  only pictures'. Stills are for you to check; the operator is sent MOTION:")
    print(r"    powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot")
    print("      --script tools/s66_hold_video.gd --write-movie <out.avi> --fixed-fps 30")
    print("      --resolution 1280x720 --quit-after 240 -- hold=<ClosedGuard|Turtle|...>")
    print("  (Cascadeur pairs; for a single clip use its own render tool), encode to MP4 and")
    print("  send the MP4 with SendUserFile.")
    return 0


def record(args) -> int:
    """Write a measurement down, with the commit it was taken at."""
    rec = _load()
    ## S63: an arm error is the WORST contact of the run, and it is recorded
    ## WITH the pair that produced it. The old default kept printing
    ## att_lhand_to_vic_neck beside a number another pair had set, so a red
    ## 34% sat under a 15% label for days.
    if args.arm_error is not None and not args.arm_pair:
        print("REFUSED: --arm-error needs --arm-pair, the pair the probe printed as worst=")
        return 2
    if args.arm_error is not None:
        rec["arm_error_pct"] = float(args.arm_error)
    if args.arm_pair:
        rec["arm_pair"] = args.arm_pair
    if args.bound is not None:
        rec["bound"] = int(args.bound)
    if args.total_motion is not None:
        rec["total_motion"] = int(args.total_motion)
    if args.note:
        rec["note"] = args.note
    rec["when"] = _git("log", "-1", "--format=%cI") or ""
    rec["commit"] = _git("rev-parse", "HEAD")
    STATUS_JSON.parent.mkdir(parents=True, exist_ok=True)
    STATUS_JSON.write_text(json.dumps(rec, indent=2) + "\n", encoding="utf-8")
    print("wrote %s" % STATUS_JSON)
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    sub = ap.add_subparsers(dest="cmd")

    sub.add_parser("report", help="the session-start report")

    p_new = sub.add_parser("new-anims", help="animations added since a ref")
    p_new.add_argument("--since", default="", help="git ref (default: yesterday)")

    p_rec = sub.add_parser("record", help="write a measurement down")
    p_rec.add_argument("--arm-error", type=float, default=None)
    p_rec.add_argument("--arm-pair", default="")
    p_rec.add_argument("--bound", type=int, default=None)
    p_rec.add_argument("--total-motion", type=int, default=None)
    p_rec.add_argument("--note", default="")

    args = ap.parse_args()
    if args.cmd == "new-anims":
        return new_anims(args)
    if args.cmd == "record":
        return record(args)
    return report(args)


if __name__ == "__main__":
    sys.exit(main())
