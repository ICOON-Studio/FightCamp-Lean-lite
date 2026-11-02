"""collect_ready.py - S249 (operator: remove the human bottlenecks): agent PRs keep flowing between Claude sessions.

Run by the 30-min "FightCamp Board Reconcile" task (Tools/board_reconcile.py --apply). For every OPEN PR on the repo:

  1. Tools/auto_collect.py eligibility (fast lane: only ADDED files under scripts/rules, tests, ops/research + a new test, every CI
     check SUCCESS, RESULT lines proven by the CI log, ci_arena guard) AND brief_scope (its TASK_<id>.md owned files == the
     added files). Both green -> merged UNATTENDED through the same collect() path `auto_collect.py <pr> --merge` runs
     (new files by content, commit of those paths only, push, PR closed). The brief match replaces Claude's intent read.
     ARMED ONLY (operator S249, "Push, merge off"): until `python Tools/code_gate.py arm --operator-said "<his words>"` writes
     AgentComms/code_gate_armed.json (one switch for this lane and the code-PR lane), such a PR is only recorded as WOULD MERGE.
  2. Anything else -> a review packet in AgentComms/collect_ready.json (PR, task, diff stat, CI pass lines, brief-scope match,
     why not eligible). `python Tools/agent_comms.py start` prints it as READY TO COLLECT with one command per PR.

Unattended merges only run on a checkout that is on main, not behind origin/main, with no merge/rebase in progress and none
of the PR's paths present or dirty - otherwise the PR waits in the packet ("checkout not safe: ...") for the next cycle.
Every merge and refusal-to-merge is logged in AgentComms/auto_collect.log.

    python Tools/collect_ready.py                  # dry run: write the packet, merge nothing
    python Tools/collect_ready.py --apply          # also merge the PRs that pass every check (what the 30-min task runs)
    python Tools/collect_ready.py --pr 254 --any-state   # proof on one PR, even a CLOSED one (never merges)
"""
from __future__ import annotations

import json
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "Tools"))
import auto_collect  # noqa: E402

OUT = ROOT / "AgentComms" / "collect_ready.json"
LOG = ROOT / "AgentComms" / "auto_collect.log"
_NO_WINDOW = getattr(subprocess, "CREATE_NO_WINDOW", 0)
PASS_RE = re.compile(r"(\]\s+PASS\s+\S+\.gd|SUITE total=\d+ fails=\d+|\S+ failures=0\b)")


def _git(*args: str) -> str:
    r = subprocess.run(["git", *args], cwd=auto_collect.GAME, capture_output=True, text=True, encoding="utf-8", errors="replace",
                       creationflags=_NO_WINDOW)
    return r.stdout


def log(line: str) -> None:
    stamp = datetime.now().strftime("%Y-%m-%d %H:%M")
    with LOG.open("a", encoding="utf-8") as fh:
        fh.write(f"{stamp} {line}\n")


def checkout_unsafe(paths: list[str]) -> str:
    """Why an unattended merge must not touch this shared checkout now ("" = safe)."""
    if _git("rev-parse", "--abbrev-ref", "HEAD").strip() != "main":
        return "checkout is not on main"
    gitdir = auto_collect.GAME / ".git"  # S368: the repo root's .git (ops/ has none)
    for marker in ("MERGE_HEAD", "REBASE_HEAD", "CHERRY_PICK_HEAD", "rebase-merge", "rebase-apply", "index.lock"):
        if (gitdir / marker).exists():
            return f"git {marker} present"
    behind = _git("rev-list", "--count", "HEAD..origin/main").strip()
    if behind not in ("", "0"):
        return f"local main is {behind} commit(s) behind origin/main (a session pulls first)"
    dirty = _git("status", "--porcelain", "--", *paths).strip()
    if dirty:
        return "PR paths dirty in the checkout: " + dirty.replace("\n", "; ")[:200]
    present = [p for p in paths if (auto_collect.GAME / p).exists()]
    if present:
        return "already on this checkout: " + ", ".join(present)
    return ""


def merging_armed() -> bool:
    """S249 operator ("Push, merge off", to the code-PR lane): machines merge nothing until he arms it. The fast lane reads the same
    switch as Tools/code_gate.py (AgentComms/code_gate_armed.json, written only by `code_gate.py arm --operator-said`)."""
    try:
        import code_gate
        return bool(code_gate.merge_armed())
    except Exception:
        return False


def packet(info: dict, why: list[str], scope: dict) -> dict:
    head = info.get("headRefOid", "")
    stat = _git("diff", "--shortstat", f"origin/main...{head}").strip() if head else ""
    names = _git("diff", "--name-status", f"origin/main...{head}").strip().splitlines() if head else []
    passes = sorted({m.group(1).strip() for m in PASS_RE.finditer(info.get("_ci_log") or "")})[:12]
    checks = [{"name": c.get("name") or c.get("context"), "state": c.get("conclusion") or c.get("state") or c.get("status")}
              for c in info.get("statusCheckRollup") or []]
    n = info["number"]
    fast = not why
    if fast and scope.get("match"):
        cmd = (f"python Tools/auto_collect.py {n} --merge   # all machine checks + brief scope green"
               + ("; the next 30-min cycle merges it" if merging_armed() else "; unattended merging is off - a session runs this"))
    elif fast:
        cmd = f"python Tools/auto_collect.py {n}   # fast lane, brief scope NO MATCH: read the body against the brief, then --merge"
    else:
        ## not check_workflow branch here: it runs a full editor import (88 C, CLAUDE.md s4) - the session picks that for a non-pure PR
        cmd = f"git fetch origin refs/pull/{n}/head && git diff --stat origin/main...FETCH_HEAD   # normal route: diff + parse + test (CLAUDE.md s7)"
    return {"pr": n, "title": info.get("title", ""), "branch": info.get("headRefName", ""), "author": (info.get("author") or {}).get("login", ""),
            "task": scope.get("task", ""), "brief": scope.get("brief", ""), "brief_match": bool(scope.get("match")),
            "brief_why": scope.get("why", ""), "diff_stat": stat, "files": names[:40], "ci": checks, "ci_pass_lines": passes,
            "fast_lane": fast, "why_not": why, "command": cmd}


def run(apply: bool = False, only: int | None = None, any_state: bool = False) -> dict:
    if only is not None:
        numbers = [only]
    else:
        listed = auto_collect._run("gh", "pr", "list", "--repo", auto_collect.REPO, "--state", "open", "--limit", "50",
                                   "--json", "number", check=False)
        numbers = [p["number"] for p in (json.loads(listed) if listed.strip() else [])]
    result = {"at": datetime.now(timezone.utc).isoformat(timespec="seconds"), "prs": [], "merged": [], "errors": []}
    for n in numbers:
        try:
            info = auto_collect.pr_info(n)
            why = auto_collect.eligibility(info, any_state=any_state)
            scope = auto_collect.brief_scope(info)
        except Exception as exc:  # one broken PR never stops the others
            result["errors"].append(f"#{n}: {exc}")
            continue
        row = packet(info, why, scope)
        if not why and scope["match"]:
            unsafe = checkout_unsafe(info["_added"])
            if any_state or info.get("state") != "OPEN":
                row["merge"] = "proof mode: would merge unattended (state %s)" % info.get("state")
            elif not apply:
                row["merge"] = "dry run: would merge unattended"
            elif not merging_armed():
                row["merge"] = ("WOULD MERGE - unattended merging is OFF (operator S249: \"Push, merge off\"); one switch for both lanes: "
                                "python Tools/code_gate.py arm --operator-said \"<his words>\"")
                log(f"WOULD #{n} {scope['task']}: every check + brief scope green, merging off")
            elif unsafe:
                row["merge"] = "waiting: checkout not safe: " + unsafe
                log(f"WAIT  #{n} {scope['task']}: {unsafe}")
            else:
                try:
                    auto_collect.collect(info)
                    sha = _git("rev-parse", "--short", "HEAD").strip()
                    row["merge"] = f"MERGED unattended {sha}"
                    result["merged"].append({"pr": n, "task": scope["task"], "commit": sha, "files": info["_added"]})
                    log(f"MERGE #{n} {scope['task']} -> {sha}: {', '.join(info['_added'])} (CI green, RESULT proven, guard green, brief match)")
                    continue  # merged PRs leave the packet
                except Exception as exc:
                    row["merge"] = f"merge FAILED: {exc}"
                    log(f"FAIL  #{n} {scope['task']}: {exc}")
        result["prs"].append(row)
    return result


def main(argv: list[str]) -> int:
    only = int(argv[argv.index("--pr") + 1]) if "--pr" in argv else None
    any_state = "--any-state" in argv
    result = run(apply="--apply" in argv and not any_state, only=only, any_state=any_state)
    if only is None:  # a one-PR proof never overwrites the packet the board and `start` read
        OUT.write_text(json.dumps(result, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
    for row in result["prs"]:
        print(f"#{row['pr']} {row['title'][:80]}")
        print(f"   task {row['task'] or '-'} | brief scope {'MATCH' if row['brief_match'] else 'NO MATCH'}: {row['brief_why']}")
        print(f"   {row['diff_stat'] or '-'} | fast lane {'yes' if row['fast_lane'] else 'no'}" + (f" | {row['merge']}" if row.get("merge") else ""))
        for w in row["why_not"][:6]:
            print(f"   - {w[:200]}")
        print(f"   -> {row['command']}")
    for m in result["merged"]:
        print(f"MERGED #{m['pr']} {m['task']} {m['commit']}")
    for e in result["errors"]:
        print(f"ERROR {e}")
    print("COLLECT_READY prs=%d merged=%d errors=%d" % (len(result["prs"]), len(result["merged"]), len(result["errors"])))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
