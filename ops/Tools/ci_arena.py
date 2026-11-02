#!/usr/bin/env python3
"""ci_arena.py - the CI helper for worker branches (arena/**) and PRs into master (operator ruling 2026-10-03).

    python Tools/ci_arena.py base                 # print the commit this run is compared against
    python Tools/ci_arena.py changed-gd           # changed/added .gd under Godot/, project-relative, one per line
    python Tools/ci_arena.py changed-tests        # changed/added Godot/tests/*.gd names (no .gd), comma-separated
    python Tools/ci_arena.py guard                # FAIL if a test file was deleted or lost > GUARD_SHRINK of its lines

The base: a pull_request compares with its base branch; a push to arena/** with its merge-base on origin/master; a push
to master with the previous master commit (GITHUB_EVENT_BEFORE). Locally (no GitHub env) it uses origin/master.

WHY THE GUARD: Arena cannot read GitHub Actions logs, and when CI goes red it tends to delete tests until it is green
(seen on Space Strategy). A deleted test or one that lost a quarter of its lines fails CI here; Claude reads the diff.
"""
from __future__ import annotations

import os
import subprocess
import sys

GUARD_SHRINK = 0.25
ZERO = "0" * 40


def _git(*args: str) -> str:
    return subprocess.run(["git", *args], capture_output=True, text=True, check=True).stdout.strip()


def base() -> str:
    event = os.environ.get("GITHUB_EVENT_NAME", "")
    if event == "pull_request":
        return _git("merge-base", "HEAD", "origin/" + os.environ.get("GITHUB_BASE_REF", "master"))
    ref = os.environ.get("GITHUB_REF_NAME", "")
    before = os.environ.get("GITHUB_EVENT_BEFORE", "")
    if event == "push" and ref == "master" and before and before != ZERO:
        return before
    return _git("merge-base", "HEAD", "origin/master")


def _changed(filter_: str) -> list[str]:
    out = _git("diff", "--name-only", "--diff-filter=" + filter_, base(), "HEAD", "--", "Godot")
    return [line for line in out.splitlines() if line.endswith(".gd")]


def changed_gd() -> list[str]:
    return [p[len("Godot/"):] for p in _changed("AMR")]


def changed_tests() -> list[str]:
    return [os.path.basename(p)[:-3] for p in _changed("AMR") if p.startswith("Godot/tests/")]


def _lines(rev: str, path: str) -> int:
    try:
        return len(_git("show", f"{rev}:{path}").splitlines())
    except subprocess.CalledProcessError:
        return -1


def guard_for(base_rev: str, head_rev: str = "HEAD", prefix: str = "::error::",
              shrink: float = GUARD_SHRINK) -> int:
    """Check test deletions and shrinkage between two revisions.

    Shared by the branch workflow gate and this module's GitHub CLI.
    """
    fails = 0
    for path in _git("diff", "--name-only", "--diff-filter=D", base_rev, head_rev, "--", "Godot/tests").splitlines():
        if path.endswith(".gd"):
            print(f"{prefix}test deleted: {path}")
            fails += 1
    for path in _git("diff", "--name-only", "--diff-filter=AM", base_rev, head_rev, "--", "Godot/tests").splitlines():
        if not path.endswith(".gd"):
            continue
        old, new = _lines(base_rev, path), _lines(head_rev, path)
        if old > 0 and new < old * (1.0 - shrink):
            print(f"{prefix}test shrank {old} -> {new} lines (> {int(shrink * 100)}%): {path}")
            fails += 1
        else:
            print(f"test kept: {path} {old} -> {new} lines")
    print(f"CI_ARENA_GUARD base={base_rev[:10]} fails={fails}")
    return 1 if fails else 0


def guard() -> int:
    return guard_for(base())


def main(argv: list[str]) -> int:
    cmd = argv[1] if len(argv) > 1 else ""
    if cmd == "base":
        print(base())
    elif cmd == "changed-gd":
        print("\n".join(changed_gd()))
    elif cmd == "changed-tests":
        print(",".join(changed_tests()))
    elif cmd == "guard":
        return guard()
    else:
        print(__doc__)
        return 2
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
