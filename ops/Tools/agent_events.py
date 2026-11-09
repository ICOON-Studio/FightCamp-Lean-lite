"""agent_events.py - stream agent events straight from GitHub, one flushed line per event (S281).

Operator S281, after five finished runs sat uncollected for hours: "the watcher missed them - this happens too often, read a tutorial
how to setup watchers". Why agent_watch.py missed them: it judged runs from AgentComms/live_runs.json 'started' stamps (hand-typed,
later than the real launch -> every real run looked "older than the relaunch" and stayed "alive"), its prints were block-buffered
(no output at all while it ran), and runs already finished when it started were skipped instead of reported.

This watcher reads GitHub only (no local stamps) and follows the Monitor rules: every terminal state emits (success, failure,
cancelled, timed_out), every line is flushed, a gh hiccup never kills the loop, and the FIRST pass reports what is already waiting
(agent branches ahead of master with no PR, open PRs) so nothing that landed before the watch began stays silent.

    python Tools/agent_events.py            # poll every 60 s forever (run it under the Monitor tool, re-arm on expiry)
    python Tools/agent_events.py 90 once    # one pass: print the waiting list and exit (no loop)
    python Tools/agent_events.py 60 quiet   # re-arm: events only, no WAITING list

Events (one line each):
    RUN_DONE <workflow> <conclusion> "<issue title>" <url>
    PUSH <branch> <short sha> "<commit subject>"
    PR_OPEN <repo>#<n> <branch> "<title>"     PR_CLOSED <repo>#<n> "<title>"
    WAITING <branch> ahead of master, no PR: "<last commit subject>"
    GH_ERROR <what> (once per failure streak)
"""
from __future__ import annotations

import json
import re
import subprocess
import sys
import time

REPO = "ICOON-Studio/FightCamp-Lean"
LITE = "ICOON-Studio/FightCamp-lite"
AGENT_PREFIXES = ("cursor/", "qwen/", "goose/", "grok/", "arena/", "ziva/", "cline/", "opencode/", "openhands/", "codex/",
                  "agy/")  # S368: Antigravity branches pushed by Tools/seat_dispatch.py
AGENT_WORKFLOWS = ("cloud-agent", "goose", "opencode", "xai-research")


def emit(line: str) -> None:
    print(line, flush=True)


def gh_json(args: list[str]) -> list | dict:
    out = subprocess.run(["gh"] + args, capture_output=True, text=True, timeout=60, encoding="utf-8")
    if out.returncode != 0:
        raise RuntimeError(out.stderr.strip()[:200])
    return json.loads(out.stdout or "[]")


def agent_heads() -> dict:
    out = subprocess.run(["git", "ls-remote", "--heads", "origin"], capture_output=True, text=True, timeout=60)
    if out.returncode != 0:
        raise RuntimeError(out.stderr.strip()[:200])
    heads = {}
    for row in out.stdout.splitlines():
        sha, _, ref = row.partition("\t")
        name = ref.replace("refs/heads/", "")
        if name.startswith(AGENT_PREFIXES):
            heads[name] = sha
    return heads


def finished_runs() -> dict:
    rows = gh_json(["run", "list", "--repo", REPO, "--limit", "40", "--json",
                    "databaseId,name,status,conclusion,displayTitle,event,url"])
    return {r["databaseId"]: r for r in rows if r.get("name") in AGENT_WORKFLOWS and r.get("conclusion") != "skipped"}


def open_prs() -> dict:
    out = {}
    for repo in (REPO, LITE):
        for pr in gh_json(["pr", "list", "--repo", repo, "--state", "open", "--json", "number,title,headRefName"]):
            out["%s#%s" % (repo.split("/")[1], pr["number"])] = pr
    return out


def subject(sha: str) -> str:
    out = subprocess.run(["git", "log", "-1", "--format=%s", sha], capture_output=True, text=True, timeout=30)
    return out.stdout.strip()[:90] if out.returncode == 0 else "?"


def open_issue_numbers() -> set:
    return {int(i["number"]) for i in gh_json(["issue", "list", "--repo", REPO, "--state", "open", "--limit", "300", "--json", "number"])}


def waiting(heads: dict, prs: dict) -> None:
    """Agent branches whose ISSUE is still open (an issue is closed when its work is collected by diff or superseded)."""
    subprocess.run(["git", "fetch", "--no-write-fetch-head", "-q", "origin", "main"], capture_output=True, timeout=120)
    pr_branches = {p["headRefName"] for p in prs.values()}
    try:
        open_issues = open_issue_numbers()
    except Exception as exc:
        emit("GH_ERROR issues: %s" % exc)
        open_issues = None
    for branch, sha in sorted(heads.items()):
        if branch in pr_branches:
            continue
        m = re.search(r"/issue-(\d+)", branch)
        if open_issues is not None and m and int(m.group(1)) not in open_issues:
            continue  # its issue is closed: collected by diff or superseded
        # S287: fetch only a head the checkout lacks - fetching all ~600 agent branches one by one ran at the 2026-10-22 freeze
        if subprocess.run(["git", "cat-file", "-e", sha + "^{commit}"], capture_output=True).returncode != 0:
            subprocess.run(["git", "fetch", "--no-write-fetch-head", "-q", "origin", branch], capture_output=True, timeout=120)
        ahead = subprocess.run(["git", "rev-list", "--count", "origin/main..%s" % sha], capture_output=True, text=True, timeout=30)
        age = subprocess.run(["git", "log", "-1", "--format=%ct", sha], capture_output=True, text=True, timeout=30)
        recent = age.returncode == 0 and age.stdout.strip().isdigit() and time.time() - int(age.stdout.strip()) < 3 * 86400
        if ahead.returncode == 0 and ahead.stdout.strip() not in ("", "0") and recent:
            emit('WAITING %s ahead of master by %s, no PR: "%s"' % (branch, ahead.stdout.strip(), subject(sha)))
    for key, pr in sorted(prs.items()):
        emit('PR_OPEN %s %s "%s"' % (key, pr["headRefName"], pr["title"][:80]))


def main(argv: list[str]) -> int:
    interval = int(argv[1]) if len(argv) > 1 else 60
    once = len(argv) > 2 and argv[2] == "once"
    quiet = len(argv) > 2 and argv[2] == "quiet"  # re-arm: skip the WAITING list already reported
    erred = set()
    state = {"heads": None, "runs": None, "prs": None}
    first = True
    while True:
        for what, fn in (("heads", agent_heads), ("runs", finished_runs), ("prs", open_prs)):
            try:
                new = fn()
            except Exception as exc:  # a gh / git hiccup is reported once, never fatal
                if what not in erred:
                    emit("GH_ERROR %s: %s" % (what, exc))
                    erred.add(what)
                continue
            erred.discard(what)
            old = state[what]
            state[what] = new
            if old is None:
                continue
            if what == "heads":
                for branch, sha in new.items():
                    if old.get(branch) != sha:
                        subprocess.run(["git", "fetch", "--no-write-fetch-head", "-q", "origin", branch], capture_output=True, timeout=120)
                        emit('PUSH %s %s "%s"' % (branch, sha[:8], subject(sha)))
            elif what == "runs":
                for rid, r in new.items():
                    if r.get("status") == "completed" and (rid not in old or old[rid].get("status") != "completed"):
                        emit('RUN_DONE %s %s "%s" %s' % (r["name"], r.get("conclusion"), r.get("displayTitle", "")[:70], r.get("url", "")))
            else:
                for key, pr in new.items():
                    if key not in old:
                        emit('PR_OPEN %s %s "%s"' % (key, pr["headRefName"], pr["title"][:80]))
                for key, pr in old.items():
                    if key not in new:
                        emit('PR_CLOSED %s "%s"' % (key, pr["title"][:80]))
        if first:
            first = False
            if not quiet and state["heads"] is not None and state["prs"] is not None:
                waiting(state["heads"], state["prs"])
            emit("WATCHING %d agent branches, %d agent runs, %d open PRs (every %d s)" % (
                len(state["heads"] or {}), len(state["runs"] or {}), len(state["prs"] or {}), interval))
            if once:
                return 0
        time.sleep(interval)


if __name__ == "__main__":
    sys.exit(main(sys.argv))
