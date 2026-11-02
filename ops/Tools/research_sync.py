#!/usr/bin/env python3
"""research_sync.py - EVERY piece of research reaches master, and the index says so.

Operator rule 2026-09-25 ("full access to all researches for everyone"), made a
gate on 2026-09-27 ("make sure all research done so far is always available to
all agents"). S101 found 24 research documents that existed ONLY on agent
branches that were never merged (Q199's digest among them, cited by S99's), and
RESEARCH_INDEX.md generated weeks of commits ago. An agent reads master and the
index; anything else it cannot find.

    python Tools/research_sync.py --check   # list what is off master or unindexed; rc 1 if any
    python Tools/research_sync.py           # bring branch-only research onto master's disk, regenerate the index

It copies DOCUMENTS ONLY (research/**.md and their .json/.csv/.txt data)
that exist on an origin branch and NOT on master. It never takes code from a
branch, and never overwrites a file master already has. The caller commits.
"""
from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RESEARCH = "research"
DOC_EXT = (".md", ".json", ".csv", ".txt")


def git(*args: str) -> str:
    return subprocess.run(["git", *args], cwd=ROOT, capture_output=True, text=True,
                          encoding="utf-8", errors="replace").stdout


CACHE = ROOT / "AgentComms" / "start_cache.json"
## Tip sha -> research files that branch ADDED relative to master when it was measured. A tip is immutable, so the entry
## never goes stale for that sha; the only drift is master later landing some of those files, and the exists-on-disk
## filter below drops exactly those. Entries are re-measured after MAX_AGE_H so a file master later deleted cannot linger.
## S241: `start` waited 93 s on one `git diff` per remote ref (~850 refs); now only new tips cost a diff, and the
## 30-min "FightCamp Board Reconcile" task (board_reconcile.py -> warm_cache) keeps the file warm.
MAX_AGE_H = 6.0


def _load_cache() -> dict:
    try:
        data = json.loads(CACHE.read_text(encoding="utf-8"))
        return data if isinstance(data, dict) else {}
    except (OSError, ValueError):
        return {}


def _save_cache(data: dict) -> None:
    try:
        tmp = CACHE.with_name(CACHE.name + ".tmp")
        tmp.write_text(json.dumps(data, ensure_ascii=False), encoding="utf-8")
        os.replace(tmp, CACHE)
    except OSError:
        pass


def _added_on(ref: str) -> list[str]:
    added = git("diff", "--name-only", "--diff-filter=A", f"origin/master...{ref}", "--", RESEARCH)
    return [p.strip() for p in added.splitlines() if p.strip()]


def _research_refs() -> list[tuple[str, str]]:
    """(tip sha, short ref name) for every remote ref that can carry research."""
    refs = []
    for line in git("branch", "-r", "--format=%(objectname) %(refname:short)").splitlines():
        parts = line.split(None, 1)
        if len(parts) != 2:
            continue
        tip, ref = parts[0], parts[1].strip()
        if ref.endswith("/HEAD") or ref == "origin/master" or ref == "origin":
            continue
        refs.append((tip, ref))
    return refs


def warm_cache(max_age_h: float = MAX_AGE_H, workers: int = 4) -> dict:
    """Measure every tip that is missing or older than max_age_h (threads), prune tips that are gone, save. Returns the
    tips map. Safe to call from the scheduled task and from `--check`."""
    from concurrent.futures import ThreadPoolExecutor
    refs = _research_refs()
    cache = _load_cache()
    tips = cache.get("tips", {}) if isinstance(cache.get("tips"), dict) else {}
    now = time.time()
    todo = [(tip, ref) for tip, ref in dict.fromkeys(refs) if not (isinstance(tips.get(tip), dict)
            and now - float(tips[tip].get("at", 0)) < max_age_h * 3600)]
    if todo:
        with ThreadPoolExecutor(max_workers=workers) as pool:
            for (tip, _ref), added in zip(todo, pool.map(lambda item: _added_on(item[0]), todo)):
                tips[tip] = {"at": now, "added": added}
    live = {tip for tip, _ref in refs}
    tips = {tip: row for tip, row in tips.items() if tip in live}
    if todo or len(tips) != len(cache.get("tips", {})):
        cache["tips"] = tips
        _save_cache(cache)
    return tips


def branch_only_research() -> list[tuple[str, str]]:
    """(branch, path) for every research document on an origin branch that master lacks on disk."""
    found: dict[str, str] = {}
    tips = warm_cache(max_age_h=48.0)
    for tip, ref in _research_refs():
        for path in tips.get(tip, {}).get("added", []):
            if not path.endswith(DOC_EXT) or path in found:
                continue
            if not (ROOT / path).exists():
                found[path] = ref
    return sorted(((b, p) for p, b in found.items()), key=lambda x: x[1])


def untracked_research() -> list[str]:
    out = git("status", "--porcelain", "--untracked-files=all", "--", RESEARCH)
    return [l[3:] for l in out.splitlines() if l.startswith("??") and l.endswith(DOC_EXT)]


def index_stale() -> bool:
    index = ROOT / "RESEARCH_INDEX.md"
    if not index.exists():
        return True
    text = index.read_text(encoding="utf-8", errors="replace")
    base = ROOT / RESEARCH
    for path in base.rglob("*.md"):
        ## The index lists a task by its id (TASK_X.md -> `X`) and a
        ## sub-folder document by its path under research.
        key = path.name[5:-3] if path.name.startswith("TASK_") and path.parent == base else             path.relative_to(base).as_posix()
        if f"`{key}`" not in text:
            return True
    return False


def check() -> int:
    off = branch_only_research()
    loose = untracked_research()
    stale = index_stale()
    for branch, path in off:
        print(f"  OFF MASTER  {path}   (only on {branch})")
    for path in loose:
        print(f"  UNCOMMITTED {path}")
    if stale:
        print("  RESEARCH_INDEX.md does not list every research document - run python Tools/research_sync.py")
    if not off and not loose and not stale:
        print("  research: every document is on master and in RESEARCH_INDEX.md")
        return 0
    return 1


def sync() -> int:
    off = branch_only_research()
    for branch, path in off:
        blob = subprocess.run(["git", "show", f"{branch}:{path}"], cwd=ROOT, capture_output=True).stdout
        dest = ROOT / path
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_bytes(blob)
        print(f"  BROUGHT     {path}   (from {branch})")
    subprocess.run([sys.executable, str(ROOT / "Tools" / "gen_index.py")], cwd=ROOT, check=False)
    print(f"  {len(off)} document(s) brought onto master's disk; index regenerated. Commit them:")
    print("    git add -- research RESEARCH_INDEX.md")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--check", action="store_true")
    args = ap.parse_args()
    return check() if args.check else sync()


if __name__ == "__main__":
    raise SystemExit(main())
