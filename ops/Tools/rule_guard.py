"""rule_guard.py - PreToolUse hook (Bash + PowerShell): CLAUDE.md's NEVER rules enforced, not remembered (S217).

S217: the operator's PDF "The 10 SKILL Rules" - a NEVER/ALWAYS rule written as text holds most of the time; a hook holds every
time. Same session: two heavy jobs ran on a RED PC (88 C) because the watchdog rule was text. Exit 2 blocks the call and
tells Claude why (stderr). Any error inside this script lets the call through (exit 0) - a broken guard must not stop work.

Blocks:
  - `*_console.exe` Godot (Win11 hands it to Windows Terminal = a black window on the operator's monitor, S166)
  - `run_tests.py` without `--jobs 2|3|4`, or with --jobs >= 5 (operator 2026-10-02 "use jobs 2 or 3"; S336 after his cooling
    fix, "the heat fixed" + "should we use jobs 4": 4 on a GREEN PC - 6 Godot tests + 3 agents peaked 78 C that morning)
  - `run_tests.py` with no --only (full suite) or an --only filter matching > 40 tests (operator S249 "do not test mechanics we
    do not use")
  - bare `git stash` / `git reset --hard` / `git checkout .` / `git clean` / `git add -A|.` in the shared checkout (CLAUDE.md s7)
  - a Godot / test / gate / agent launch while pc_watchdog says RED (CLAUDE.md s4: RED = do not start)
"""
import json
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

HEAVY = re.compile(r"Godot_v4[^\s\"']*\.exe|godot_hidden\.ps1|(python[\d.]*|py)(\.exe)?\s+\S*run_tests\.py|c223_parallel\.py|agent_window\.ps1|"
                   r"_task\.cmd|check_workflow\.py\s+branch|record_room", re.I)
RULES = [
    (re.compile(r"_console\.exe", re.I),
     "Godot *_console.exe opens a Windows Terminal window on the operator's monitor (S166). Use Godot_v4.7.2-stable_win64.exe."),
    (re.compile(r"\bgit\s+stash(\s+(push|save))?\s*($|[;&|])", re.I),
     "bare `git stash` in the shared checkout (CLAUDE.md s7) - other sessions' work lives here. Commit explicit paths instead."),
    (re.compile(r"\bgit\s+reset\s+--hard", re.I), "`git reset --hard` in the shared checkout (CLAUDE.md s7)."),
    (re.compile(r"\bgit\s+checkout\s+(--\s+)?\.(\s|$)", re.I), "`git checkout .` in the shared checkout (CLAUDE.md s7)."),
    (re.compile(r"\bgit\s+clean\b", re.I), "`git clean` in the shared checkout (CLAUDE.md s7)."),
    (re.compile(r"\bgit\s+add\s+(-A|--all|\.)(\s|$)", re.I),
     "`git add -A/.` - stage explicit paths (`git add -- <files>`), another agent's work may be in the tree (CLAUDE.md s7)."),
]


## S235: only an INVOCATION of the runner (python ... run_tests.py) - `git add -- Godot/tools/run_tests.py`, a grep or a
## Select-String naming the file were blocked as "serial runs".
RUNNER = re.compile(r"\b(python[\d.]*|py)(\.exe)?[\"']?\s+(-\S+\s+)*[\"']?[^\s\"']*run_tests\.py", re.I)


def jobs_rule(cmd: str) -> str:
    if not RUNNER.search(cmd):
        return ""
    m = re.search(r"--jobs[ =](\d+)", cmd)
    if m is None:
        return "run_tests.py without --jobs runs SERIAL (CLAUDE.md s6): pass --jobs 4 on an idle GREEN PC, --jobs 2 beside agents."
    if int(m.group(1)) >= 5:
        return "run_tests.py --jobs >= 5 (S336: 4 is the most, on a GREEN PC; 2 beside agents)."
    return ""


## S249 operator: "do not test mechanics we do not use maybe until we actually implement them" (S238 before it: "run only the
## necessary tests"). `--only fight_` matched 185 tests (camera/anim/UI/HUD) for one engine change and ran 70+ minutes on his PC.
## A filter is a LIST of the tests the diff touches: more than ONLY_MAX matches, or no --only at all (the full suite runs
## nightly only, CLAUDE.md s6), is blocked. A shell variable ($list) cannot be read here and passes.
ONLY_MAX = 40


def only_rule(cmd: str) -> str:
    if not RUNNER.search(cmd):
        return ""
    m = re.search(r"--only[ =](\"[^\"]*\"|'[^']*'|\S+)", cmd)
    if m is None:
        return ("run_tests.py with no --only is the FULL suite - nightly only (CLAUDE.md s6). Pass --only with the tests the "
                "diff touches.")
    value = m.group(1).strip("\"'")
    if value.startswith("$"):
        return ""
    wanted = [s for s in value.split(",") if s]
    tests_dir = os.path.join(os.path.dirname(ROOT), "tests")  # ops/ lives inside the Lean game repo
    names = [n for n in os.listdir(tests_dir) if n.endswith(".gd")] if os.path.isdir(tests_dir) else []
    hits = [n for n in names if any(s in n for s in wanted)]
    if len(hits) > ONLY_MAX:
        return ("run_tests.py --only %r matches %d tests (max %d). Operator S249: 'do not test mechanics we do not use' - "
                "name the tests the diff touches (exact names, comma-separated)." % (value, len(hits), ONLY_MAX))
    return ""


def watchdog_red() -> str:
    try:
        r = subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
                            os.path.join(ROOT, "Tools", "pc_watchdog.ps1"), "-Once"],
                           capture_output=True, text=True, timeout=25)
        if r.returncode == 1:
            return (r.stdout.strip().splitlines() or ["RED"])[-1].strip()
    except Exception:
        pass
    return ""


## S288 (operator: "fix this so we do not waste so many actions on github"): 19 Oct had four hand-dispatched nightly runs
## (1,503 Actions minutes). The nightly runs on its own schedule; a hand run needs FIGHTCAMP_ALLOW_NIGHTLY=1 on the command,
## said out loud (a full night is ~565 minutes, a fast one ~175).
NIGHTLY_DISPATCH = re.compile(r"\bgh\s+workflow\s+run\s+[\"']?nightly-suite|nightly-suite\.yml/dispatches", re.I)


def nightly_rule(cmd: str) -> str:
    if NIGHTLY_DISPATCH.search(cmd) and "FIGHTCAMP_ALLOW_NIGHTLY=1" not in cmd:
        return ("a hand-dispatched nightly suite costs ~175-565 Actions minutes (S288). It runs itself at 03:00 UTC; use "
                "cloud-tests.yml with --only for a check, or prefix FIGHTCAMP_ALLOW_NIGHTLY=1 when a full night is really needed.")
    return ""


def main() -> int:
    try:
        data = json.loads(sys.stdin.read().lstrip("﻿"))  # S378: a PowerShell pipe adds a BOM
    except Exception:
        return 0
    cmd = str((data.get("tool_input") or {}).get("command") or "")
    if not cmd:
        return 0
    for rx, why in RULES:
        if rx.search(cmd):
            print("RULE_GUARD blocked: " + why, file=sys.stderr)
            return 2
    why = jobs_rule(cmd) or only_rule(cmd) or nightly_rule(cmd)
    if why:
        print("RULE_GUARD blocked: " + why, file=sys.stderr)
        return 2
    if HEAVY.search(cmd):
        red = watchdog_red()
        if red:
            print("RULE_GUARD blocked: the PC watchdog is RED (" + red + ") - no Godot/test/agent start (CLAUDE.md s4). "
                  "Wait, or pause a job with Tools/proc_pause.ps1; the heat governor resumes paused jobs on GREEN.",
                  file=sys.stderr)
            return 2
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except SystemExit:
        raise
    except Exception:
        sys.exit(0)
