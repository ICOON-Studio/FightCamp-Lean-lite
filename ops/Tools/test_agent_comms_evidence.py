#!/usr/bin/env python3
"""Gate for EVIDENCE-DERIVED task status in `agent_comms.py`.

Why this exists (2026-09-22). Task status was read off a HAND-WRITTEN
`### AGENT - ID: ... (COMPLETE)` header in HANDOFF.md. Nobody wrote the line
for most tasks, so work that shipped months ago still read OPEN: measured on
this tree before the change, **104 task files read OPEN and 77 of them had a
landed deliverable in git**. The board could not answer "who is idle", which
is the one question it exists for, so `status_of` now falls back to asking the
tree - see `evidence_for`.

THE WHOLE RISK OF THAT CHANGE IS THAT IT CLOSES SOMETHING STILL OPEN. A rule
that finds evidence for everything is the same as no rule at all. So the
cases below are built the other way round: most of them are fixtures where
the honest answer is NOTHING, and the gate fails if the tool invents a
completion. Case 1 alone is the one that matters - if it ever passes
vacuously, delete the rest and start again.

It also pins the two distinctions that were got wrong while writing it:

  * GIT, NOT DISK. This checkout permanently carries untracked .import, .uid,
    scratch and delivery-staging files. A deliverable sitting untracked is
    scratch, so case 2 writes one and expects OPEN.
  * AN UNCOLLECTED BRANCH BEATS A FILE. `C134_CONTINUE.md` is tracked and is
    a brief for the REST of the work, not a result; the branch was 41 commits
    ahead. Case 4 reproduces that shape. Case 5 is its mirror - a branch that
    WAS collected and only left undeleted must not hold a finished task open.

Run:  python Tools/test_agent_comms_evidence.py
"""
from __future__ import annotations

import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

SCRIPT = Path(__file__).resolve().parent / "agent_comms.py"


def run(cwd: Path, *args: str) -> str:
    proc = subprocess.run(args, cwd=cwd, capture_output=True, text=True)
    return proc.stdout + proc.stderr


def scaffold(path: Path) -> None:
    """The least a checkout needs for `tasks` to run."""
    (path / "Tools").mkdir(parents=True, exist_ok=True)
    (path / "AgentComms" / "messages").mkdir(parents=True, exist_ok=True)
    (path / "research").mkdir(parents=True, exist_ok=True)
    shutil.copy(SCRIPT, path / "Tools" / "agent_comms.py")
    (path / "HANDOFF.md").write_text("## Active claims\n\n## Direction notes\n",
                                     encoding="utf-8")


def git_init(path: Path) -> None:
    run(path, "git", "init", "-q", "-b", "master", ".")
    run(path, "git", "config", "user.email", "gate@fightcamp")
    run(path, "git", "config", "user.name", "gate")


def write_task(path: Path, task_id: str, owner: str = "codex", owned: str = "") -> None:
    body = "# TASK %s - %s - A THING TO DO\n\n**Owner:** %s.\n" % (task_id, owner, owner)
    if owned:
        body += "\n## Owned files\n\n- `%s`\n" % owned
    (path / "research" / ("TASK_%s.md" % task_id)).write_text(body, encoding="utf-8")


def commit_all(path: Path, message: str) -> None:
    run(path, "git", "add", "-A")
    run(path, "git", "commit", "-qm", message)


def tasks_out(path: Path) -> str:
    return run(path, sys.executable, "Tools/agent_comms.py", "tasks")


def expect(label: str, text: str, wanted: list[str], unwanted: list[str]) -> bool:
    bad = [w for w in wanted if w not in text] + ["(present) " + u for u in unwanted if u in text]
    print(("  PASS  " if not bad else "  FAIL  ") + label)
    for item in bad:
        print("          missing: " + item)
    if bad:
        print("        ---- output ----")
        for line in text.splitlines():
            print("        " + line)
    return not bad


def case_no_deliverable(tmp: Path) -> bool:
    """THE CASE THAT MATTERS. A task with nothing behind it stays OPEN.

    If this ever passes while reporting the task closed, the evidence rule has
    become a rubber stamp and every other case here is meaningless."""
    repo = tmp / "nothing"
    repo.mkdir()
    scaffold(repo)
    git_init(repo)
    write_task(repo, "Z1")
    commit_all(repo, "a task with no deliverable")
    return expect("a task with no deliverable stays OPEN",
                  tasks_out(repo), ["Z1"], ["Z1  CODEX  COMPLETE"])


def case_untracked_is_not_evidence(tmp: Path) -> bool:
    """A deliverable that exists on disk but is NOT in git is scratch."""
    repo = tmp / "untracked"
    repo.mkdir()
    scaffold(repo)
    git_init(repo)
    write_task(repo, "Z2")
    commit_all(repo, "task only")
    # written AFTER the commit, so git does not track it
    (repo / "research" / "Z2_RESULT.md").write_text("findings\n", encoding="utf-8")
    return expect("an UNTRACKED deliverable is not evidence",
                  tasks_out(repo), ["Z2"], ["Z2  CODEX  COMPLETE"])


def case_tracked_deliverable(tmp: Path) -> bool:
    """A tracked `<ID>_*.md` closes the task, and says which file did it."""
    repo = tmp / "tracked"
    repo.mkdir()
    scaffold(repo)
    git_init(repo)
    write_task(repo, "Z3")
    (repo / "research" / "Z3_RESULT.md").write_text("findings\n", encoding="utf-8")
    commit_all(repo, "task and its deliverable")
    out = tasks_out(repo)
    ok = expect("a TRACKED deliverable closes the task", out, [], ["Z3  CODEX  OPEN"])
    ev = run(repo, sys.executable, "Tools/agent_comms.py", "evidence")
    return ok and expect("...and the evidence report names the file",
                         ev, ["Z3", "Z3_RESULT.md"], [])


def case_uncollected_branch_beats_file(tmp: Path) -> bool:
    """C134's shape: a tracked file named after the task, and the work still
    sitting on a branch ahead of master. The branch wins."""
    repo = tmp / "inflight"
    repo.mkdir()
    scaffold(repo)
    git_init(repo)
    write_task(repo, "C77")
    (repo / "research" / "C77_CONTINUE.md").write_text("more to do\n", encoding="utf-8")
    commit_all(repo, "task and a continuation brief")
    # a remote-shaped branch, ahead of master, uncollected
    run(repo, "git", "branch", "codex/c77-the-thing")
    run(repo, "git", "checkout", "-q", "codex/c77-the-thing")
    (repo / "work.txt").write_text("unfinished\n", encoding="utf-8")
    commit_all(repo, "work in progress")
    run(repo, "git", "checkout", "-q", "master")
    run(repo, "git", "update-ref", "refs/remotes/origin/codex/c77-the-thing",
        "refs/heads/codex/c77-the-thing")
    return expect("an UNCOLLECTED branch keeps the task OPEN despite the file",
                  tasks_out(repo), ["C77"], ["C77  CODEX  COMPLETE"])


def case_collected_branch_does_not_hold_it_open(tmp: Path) -> bool:
    """The mirror. A branch tagged `collected/*` was audited onto master and
    only left undeleted; it must NOT hold a finished task open."""
    repo = tmp / "collected"
    repo.mkdir()
    scaffold(repo)
    git_init(repo)
    write_task(repo, "C88")
    (repo / "research" / "C88_RESULT.md").write_text("findings\n", encoding="utf-8")
    commit_all(repo, "task and its deliverable")
    run(repo, "git", "branch", "codex/c88-the-thing")
    run(repo, "git", "checkout", "-q", "codex/c88-the-thing")
    (repo / "work.txt").write_text("landed elsewhere\n", encoding="utf-8")
    commit_all(repo, "work")
    tip = run(repo, "git", "rev-parse", "HEAD").strip()
    run(repo, "git", "checkout", "-q", "master")
    run(repo, "git", "update-ref", "refs/remotes/origin/codex/c88-the-thing",
        "refs/heads/codex/c88-the-thing")
    run(repo, "git", "tag", "collected/c88-the-thing", tip)
    return expect("a COLLECTED branch does not hold a finished task open",
                  tasks_out(repo), [], ["C88  CODEX  OPEN"])


def case_handwritten_header_still_wins(tmp: Path) -> bool:
    """Precedence is unchanged: a human saying OPEN outranks the tree.

    Somebody who writes OPEN after a deliverable landed usually knows
    something the filesystem does not."""
    repo = tmp / "header"
    repo.mkdir()
    scaffold(repo)
    git_init(repo)
    write_task(repo, "Z4")
    (repo / "research" / "Z4_RESULT.md").write_text("findings\n", encoding="utf-8")
    (repo / "HANDOFF.md").write_text(
        "## Active claims\n\n### CODEX - Z4: a thing (OPEN).\n\n## Direction notes\n",
        encoding="utf-8")
    commit_all(repo, "task, deliverable, and a header saying OPEN")
    return expect("a hand-written OPEN header outranks the evidence",
                  tasks_out(repo), ["Z4"], ["Z4  CODEX  COMPLETE"])


CASES = [
    case_no_deliverable,
    case_untracked_is_not_evidence,
    case_tracked_deliverable,
    case_uncollected_branch_beats_file,
    case_collected_branch_does_not_hold_it_open,
    case_handwritten_header_still_wins,
]


def main() -> int:
    passed = 0
    with tempfile.TemporaryDirectory() as raw:
        tmp = Path(raw)
        print("EVIDENCE-DERIVED TASK STATUS")
        for case in CASES:
            if case(tmp):
                passed += 1
    fails = len(CASES) - passed
    print("\nSUITE total=%d fails=%d" % (len(CASES), fails))
    return 1 if fails else 0


if __name__ == "__main__":
    raise SystemExit(main())
