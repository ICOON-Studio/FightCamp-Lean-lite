"""worktree_retire.py - S249 (operator: "have the collector session auto-retire worktrees and gate clones from now on").

E: fell to 11 GB free: 116 GB sat in agent worktrees under E:\\FightCamp\\wt (each seeded with a 4-8 GB import cache, never removed
after collection) and 23 GB in leftover check_workflow branch-gate clones (E:\\FightCamp\\tmp\\fightcamp-branch-gate-*). The 30-min
reconcile (Tools/board_reconcile.py --apply) now runs this with --apply.

A git worktree under E:\\FightCamp\\wt is RETIRED only when ALL hold:
  - no running process names it in its command line or exe path;
  - no live_runs.json run with status running/waiting points at it (its worktree path or its branch);
  - `git status --porcelain --untracked-files=no` is empty (no dirty tracked file);
  - HEAD has no commit missing from origin (`git rev-list HEAD --not --remotes=origin` empty - pushed to its branch or on master);
  - nothing in it was written for 24 h (1 h when HEAD is already on origin's default branch - merged work, S358).
S358: the Lean repo's worktrees (E:\\FightCamp\\Lean, its agents' LEAN_* folders under the same wt root) are assessed too - E: sat
at 8.5 GB with 19 Lean worktrees this script never saw. ZIVA_LEAN is protected like ZIVA.
Before removal its untracked non-ignored files (`git ls-files --others --exclude-standard`, minus *_baseline/ copies and .godot/)
are copied to E:\\FightCamp\\wt_salvage\\<name>\\. Removal is Remove-Item -Recurse -Force (git worktree remove dies on read-only pack
files here), then `git worktree prune`. NEVER: E:\\FightCamp\\wt\\ZIVA, the main checkout, anything outside E:\\FightCamp\\wt, a worktree with
dirty tracked files or unpushed commits - those are HELD and listed ("held: <name> - N dirty / M unpushed").
Gate clones: every E:\\FightCamp\\tmp\\fightcamp-branch-gate-* older than 6 h that no process uses is deleted (check_workflow.py now
deletes its own clone in a finally block; this is the backstop).
Every retire/delete is logged with the GB freed in AgentComms/retire.log; AgentComms/retire_state.json holds the last pass for `start`.

    python Tools/worktree_retire.py              # dry run (the default): what it would retire / hold / delete
    python Tools/worktree_retire.py --apply      # do it (the 30-min task)
"""
from __future__ import annotations

import json
import os
import shutil
import stat
import subprocess
import sys
import time
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WT_ROOT = Path(os.environ.get("FIGHTCAMP_WT_ROOT", "E:/FightCamp/wt"))
SALVAGE = Path(os.environ.get("FIGHTCAMP_WT_SALVAGE", "E:/FightCamp/wt_salvage"))
GATE_TMP = Path(os.environ.get("FIGHTCAMP_GATE_TMP", "E:/FightCamp/tmp"))
LOG = ROOT / "AgentComms" / "retire.log"
STATE = ROOT / "AgentComms" / "retire_state.json"
RUNS = ROOT / "AgentComms" / "live_runs.json"
REPOS = [ROOT, Path(os.environ.get("FIGHTCAMP_LEAN_ROOT", "E:/FightCamp/Lean"))]
PROTECTED = {"ziva", "ziva_lean"}  # operator S237/S248: the Ziva playtest worktrees stay
IDLE_H, MERGED_IDLE_H, GATE_IDLE_H = 24, 1, 6
SKIP_WALK = {".git", ".godot", ".import", "node_modules"}
_NO_WINDOW = getattr(subprocess, "CREATE_NO_WINDOW", 0)


def _norm(p) -> str:
    return str(p).replace("\\", "/").rstrip("/").lower()


def _uses(key: str, text: str) -> bool:
    """`key` (a normalised path) appears in `text` as a whole path, not as the prefix of a longer folder name."""
    i = text.find(key)
    while i >= 0:
        end = text[i + len(key):i + len(key) + 1]
        if end in ("", "/", " ", '"', "'", ";", ","):
            return True
        i = text.find(key, i + 1)
    return False


def git(*args: str, cwd: Path = ROOT) -> subprocess.CompletedProcess:
    return subprocess.run(["git", *args], cwd=str(cwd), capture_output=True, text=True, encoding="utf-8", errors="replace",
                          creationflags=_NO_WINDOW, timeout=300)


def worktrees() -> list[dict]:
    rows, cur = [], {}
    lines = []
    for repo in REPOS:
        if repo.is_dir():
            lines += [(repo, l) for l in git("worktree", "list", "--porcelain", cwd=repo).stdout.splitlines()]
    for repo, line in lines:
        if line.startswith("worktree "):
            cur = {"path": Path(line[9:].strip()), "repo": repo}
            rows.append(cur)
        elif line.startswith("branch refs/heads/"):
            cur["branch"] = line[18:].strip()
        elif line.startswith("HEAD "):
            cur["head"] = line[5:].strip()
        elif line.strip() == "locked" or line.startswith("locked"):
            cur["locked"] = True
    return rows


def process_paths() -> list[str]:
    ps = "Get-CimInstance Win32_Process | %{ ($_.ExecutablePath, $_.CommandLine) -join ' ' }"
    try:
        out = subprocess.run(["powershell", "-NoProfile", "-Command", ps], capture_output=True, text=True, encoding="utf-8",
                             errors="replace", timeout=60, creationflags=_NO_WINDOW).stdout
    except (OSError, subprocess.SubprocessError):
        return ["<process list unreadable>"]  # unreadable = assume in use: nothing is removed this pass
    return [_norm(l) for l in out.splitlines() if l.strip()]


def running_runs() -> list[dict]:
    try:
        runs = json.loads(RUNS.read_text(encoding="utf-8-sig")).get("runs", {})
    except (OSError, ValueError):
        return [{"_unreadable": True}]
    return [r for r in runs.values() if isinstance(r, dict) and str(r.get("status", "")).lower() in ("running", "waiting")]


def newest_write_h(path: Path, extra: list[Path], budget: int = 30000) -> float:
    """Hours since the newest write: the worktree's git index/HEAD log, its untracked files, and a bounded walk (caches skipped)."""
    newest = 0.0
    for p in extra:
        try:
            newest = max(newest, p.stat().st_mtime)
        except OSError:
            pass
    stack, seen = [path], 0
    while stack and seen < budget:
        d = stack.pop()
        try:
            for e in os.scandir(d):
                if e.name in SKIP_WALK:
                    continue
                seen += 1
                try:
                    if e.is_dir(follow_symlinks=False):
                        stack.append(Path(e.path))
                    else:
                        newest = max(newest, e.stat(follow_symlinks=False).st_mtime)
                except OSError:
                    continue
        except OSError:
            continue
    return (time.time() - newest) / 3600.0 if newest else 1e9


def size_gb(path: Path) -> float:
    total, stack = 0, [path]
    while stack:
        d = stack.pop()
        try:
            for e in os.scandir(d):
                try:
                    if e.is_dir(follow_symlinks=False):
                        stack.append(Path(e.path))
                    else:
                        total += e.stat(follow_symlinks=False).st_size
                except OSError:
                    continue
        except OSError:
            continue
    return total / 1024 ** 3


def _force_rmtree(path: Path) -> None:
    def _retry(func, target, _exc):
        try:
            os.chmod(target, stat.S_IWRITE)
            func(target)
        except OSError:
            pass
    shutil.rmtree(path, onexc=_retry) if sys.version_info >= (3, 12) else shutil.rmtree(path, onerror=_retry)


def remove_tree(path: Path) -> None:
    """Remove-Item -Recurse -Force (operator's route: git worktree remove fails on read-only packs), then a chmod-retry rmtree."""
    lit = str(path).replace("'", "''")
    subprocess.run(["powershell", "-NoProfile", "-Command", f"Remove-Item -LiteralPath '{lit}' -Recurse -Force -ErrorAction SilentlyContinue"],
                   capture_output=True, timeout=1800, creationflags=_NO_WINDOW)
    if path.exists():
        _force_rmtree(path)


def salvage(wt: Path, name: str, apply: bool) -> list[str]:
    files = [f for f in git("ls-files", "--others", "--exclude-standard", "-z", cwd=wt).stdout.split("\0") if f.strip()]
    keep = [f for f in files if not any(part.endswith("_baseline") or part == ".godot" for part in Path(f).parts)]
    if apply:
        for f in keep:
            src, dst = wt / f, SALVAGE / name / f
            try:
                dst.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(src, dst)
            except OSError:
                continue
    return keep


def assess(wt: dict, procs: list[str], runs: list[dict]) -> dict:
    path, name = wt["path"], wt["path"].name
    row = {"name": name, "path": str(path), "branch": wt.get("branch", ""), "verdict": "retire", "why": ""}
    if any(_norm(path) == _norm(r) for r in REPOS) or not _norm(path).startswith(_norm(WT_ROOT) + "/"):
        row.update(verdict="skip", why="not under %s" % WT_ROOT)
        return row
    if name.lower() in PROTECTED or wt.get("locked"):
        row.update(verdict="skip", why="protected (ZIVA)" if name.lower() in PROTECTED else "locked worktree")
        return row
    if not path.is_dir():
        row.update(verdict="prune", why="folder already gone - git worktree prune")
        return row
    key = _norm(path)
    if any(_uses(key, p) for p in procs) or procs == ["<process list unreadable>"]:
        row.update(verdict="busy", why="a running process uses it")
        return row
    for r in runs:
        if r.get("_unreadable"):
            row.update(verdict="busy", why="live_runs.json unreadable")
            return row
        if _uses(key, _norm(json.dumps(r, ensure_ascii=False).replace("\\\\", "/"))) or (row["branch"] and r.get("branch") == row["branch"]):
            row.update(verdict="busy", why="live run %s is running on it" % r.get("title", "?")[:60])
            return row
    dirty = len([l for l in git("status", "--porcelain", "--untracked-files=no", cwd=path).stdout.splitlines() if l.strip()])
    unpushed_out = git("rev-list", "--count", "HEAD", "--not", "--remotes=origin", cwd=path)
    unpushed = int(unpushed_out.stdout.strip()) if unpushed_out.returncode == 0 and unpushed_out.stdout.strip().isdigit() else -1
    row.update(dirty=dirty, unpushed=unpushed)
    if dirty or unpushed:
        row.update(verdict="held", why="held: %s - %d dirty / %s unpushed" % (name, dirty, "?" if unpushed < 0 else unpushed))
        return row
    gitdir = Path(git("rev-parse", "--absolute-git-dir", cwd=path).stdout.strip() or path / ".git")
    idle = newest_write_h(path, [gitdir / "index", gitdir / "logs" / "HEAD", gitdir / "HEAD"])
    row["idle_h"] = round(idle, 1)
    merged = git("merge-base", "--is-ancestor", "HEAD", "refs/remotes/origin/HEAD", cwd=path).returncode == 0
    limit = MERGED_IDLE_H if merged else IDLE_H
    if idle < limit:
        row.update(verdict="recent", why="written %.1f h ago (< %d h%s)" % (idle, limit, ", merged" if merged else ""))
        return row
    row["why"] = "clean, pushed%s, idle %.0f h" % (", merged" if merged else "", idle)
    return row


def gate_clones(procs: list[str]) -> list[dict]:
    rows = []
    if not GATE_TMP.is_dir():
        return rows
    for d in sorted(GATE_TMP.glob("fightcamp-branch-gate-*")):
        if not d.is_dir():
            continue
        age = (time.time() - d.stat().st_mtime) / 3600.0
        busy = any(_uses(_norm(d), p) for p in procs) or procs == ["<process list unreadable>"]
        rows.append({"name": d.name, "path": str(d), "age_h": round(age, 1),
                     "verdict": "busy" if busy else ("delete" if age >= GATE_IDLE_H else "recent")})
    return rows


def _log(line: str) -> None:
    with LOG.open("a", encoding="utf-8") as fh:
        fh.write("%s %s\n" % (datetime.now().strftime("%Y-%m-%d %H:%M"), line))


def e_free_gb() -> float:
    try:
        return shutil.disk_usage(str(WT_ROOT.anchor or "E:/")).free / 1024 ** 3
    except OSError:
        return -1.0


def run(apply: bool) -> dict:
    procs, runs = process_paths(), running_runs()
    rows = [assess(w, procs, runs) for w in worktrees()]
    gates = gate_clones(procs)
    pruned = False
    for r in rows:
        if r["verdict"] == "retire":
            r["size_gb"] = round(size_gb(Path(r["path"])), 2)
            r["salvage"] = len(salvage(Path(r["path"]), r["name"], apply))
            if apply:
                remove_tree(Path(r["path"]))
                gone = not Path(r["path"]).exists()
                r["done"] = gone
                pruned = True
                _log("RETIRE %s (%s) %s freed %.2f GB, salvaged %d file(s) -> %s" % (
                    r["name"], r["branch"], "ok" if gone else "PARTIAL (folder still there)", r["size_gb"], r["salvage"], SALVAGE / r["name"]))
        elif r["verdict"] == "prune":
            pruned = pruned or apply
    for g in gates:
        if g["verdict"] == "delete":
            g["size_gb"] = round(size_gb(Path(g["path"])), 2)
            if apply:
                remove_tree(Path(g["path"]))
                g["done"] = not Path(g["path"]).exists()
                _log("DELETE gate clone %s (%.0f h old) %s freed %.2f GB" % (g["name"], g["age_h"], "ok" if g["done"] else "PARTIAL", g["size_gb"]))
    if pruned:
        for repo in REPOS:
            if repo.is_dir():
                git("worktree", "prune", cwd=repo)
    state = {"at": datetime.now().strftime("%Y-%m-%d %H:%M"), "applied": apply, "e_free_gb": round(e_free_gb(), 1),
             "worktrees": rows, "gate_clones": gates}
    if apply:
        try:
            old = json.loads(STATE.read_text(encoding="utf-8"))
            state["start_seen"] = old.get("start_seen", "")
        except (OSError, ValueError):
            pass
        STATE.write_text(json.dumps(state, indent=1) + "\n", encoding="utf-8")
    return state


def since_last_start(mark: bool = True) -> tuple[float, list[str], list[str]]:
    """For `start`: (E: free GB now, retire.log lines since the last start, held lines from the last pass); marks them seen."""
    try:
        state = json.loads(STATE.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        state = {}
    seen = state.get("start_seen", "")
    try:
        lines = [l.rstrip() for l in LOG.read_text(encoding="utf-8").splitlines() if l.strip() and l[:16] > seen]
    except OSError:
        lines = []
    held = [r["why"] for r in state.get("worktrees", []) if r.get("verdict") == "held"]
    if mark and STATE.exists():
        state["start_seen"] = datetime.now().strftime("%Y-%m-%d %H:%M")
        STATE.write_text(json.dumps(state, indent=1) + "\n", encoding="utf-8")
    return round(e_free_gb(), 1), lines, held


def main(argv: list[str]) -> int:
    apply = "--apply" in argv
    state = run(apply)
    tag = "" if apply else "WOULD "
    for r in state["worktrees"]:
        if r["verdict"] == "retire":
            print("%sRETIRE %-14s %s (%s, %.2f GB, salvage %d untracked file(s))" % (tag, r["name"], r["branch"], r["why"], r.get("size_gb", 0), r.get("salvage", 0)))
        elif r["verdict"] == "held":
            print("HELD   %s" % r["why"])
        else:
            print("%-6s %-14s %s" % (r["verdict"].upper(), r["name"], r["why"]))
    for g in state["gate_clones"]:
        print("%sGATE  %s %s (%.0f h old%s)" % (tag if g["verdict"] == "delete" else "", g["verdict"].upper(), g["name"], g["age_h"],
                                               (", %.2f GB" % g["size_gb"]) if "size_gb" in g else ""))
    n = sum(1 for r in state["worktrees"] if r["verdict"] == "retire")
    gb = sum(r.get("size_gb", 0) for r in state["worktrees"] if r["verdict"] == "retire") + sum(g.get("size_gb", 0) for g in state["gate_clones"] if g["verdict"] == "delete")
    print("WORKTREE_RETIRE %s retire=%d held=%d gate_clones=%d freed%s=%.1f GB E_free=%.1f GB" % (
        "applied" if apply else "dry-run", n, sum(1 for r in state["worktrees"] if r["verdict"] == "held"),
        sum(1 for g in state["gate_clones"] if g["verdict"] == "delete"), "" if apply else "_would", gb, state["e_free_gb"]))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
