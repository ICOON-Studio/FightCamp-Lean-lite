"""board_reconcile.py - S218 (operator PDFs): the ops board must not show runs that are dead.

live_runs.json is written by hand at launch and landing; sessions forget to close entries, so the board shows "running"
for agents that died hours ago. This script checks every running/waiting entry against the witnesses:

  PC runs     a live process whose command line names the run's worktree (codex/cursor/qwen/node/Godot) or the
              entry's "match" string (e.g. a queue script name), or a write to its "log" file / worktree in STALE_MIN min
  cloud runs  the branch on origin, its PR (open / merged / closed), the GitHub Actions run (gh_run), the issue state

and gives each one verdict: alive | landed (PR open or run finished - Claude collects) | merged | dead | unknown
(browser bots: Maria/Kalli/Dola/John have no witness we can read).

    python Tools/board_reconcile.py            # report only
    python Tools/board_reconcile.py --apply    # also write the verdicts into live_runs.json (status + reconciled note)

--apply never deletes a run: dead -> status "stale", landed -> "landed". S249 SELF-CLOSING: a run whose PR is closed/merged or
whose branch commits are on master (git cherry all '-' or the tip an ancestor of master, tip committed after the run started)
gets status "collected" (the master log cites the PR) or "closed", and board_sync moves it to live_runs_archive.json in the same
pass - landed/stale entries are re-checked every cycle until that happens. A branch may be a glob ("grok/nightly9-*"): its PRs
are the ones whose title/branch name the run id. The verdicts also go to AgentComms/board_reconcile.json for the board.
--apply also (S249): runs Tools/collect_ready.py (unattended fast-lane merges + the READY TO COLLECT packet), marks review
comments addressed when a master commit cites their id (media_comments.json "addressed"), and drains AgentComms/seat_queue.json
(Tools/seat_queue.py) - none of the three when `agent_comms.py start` calls it (FIGHTCAMP_FROM_START). S368: it also runs
Tools/seat_dispatch.py --act (idle Qwen/Cursor/Antigravity seats launch their queued tasks; pause = AgentComms/seat_dispatch_off.flag).
Scheduled every 30 min by the "FightCamp Board Reconcile" task (hidden PowerShell parent; git/gh with no console window).
"""
from __future__ import annotations

import fnmatch
import json
import os
import re
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RUNS = ROOT / "AgentComms" / "live_runs.json"
OUT = ROOT / "AgentComms" / "board_reconcile.json"
COMMENTS = ROOT / "AgentComms" / "media_comments.json"
NOT_COMMENT_IDS = {"C223"}  # the C223 gate's name in commit messages, never a review comment
RECHECKED = ("running", "waiting", "landed", "stale")
STALE_MIN = 45
_NO_WINDOW = getattr(subprocess, "CREATE_NO_WINDOW", 0)
BROWSER_BOTS = ("maria", "kalli", "dola", "john", "ludo")
PC_AGENTS = ("codex", "cursor", "qwen", "antigravity", "cline", "claude")
SKIP_DIRS = {".godot", ".git", "node_modules", ".import"}


def _run(args: list[str], timeout: int = 30) -> str:
    try:
        return subprocess.run(args, cwd=str(ROOT), capture_output=True, text=True, encoding="utf-8", errors="replace",
                              timeout=timeout, creationflags=_NO_WINDOW).stdout
    except Exception:
        return ""


def _gh_json(*args: str):
    out = _run(["gh", *args])
    try:
        return json.loads(out) if out.strip() else None
    except ValueError:
        return None


def process_cmdlines() -> list[str]:
    ps = ("Get-CimInstance Win32_Process | ?{ $_.Name -match 'node|codex|qwen|cursor|Godot|python|agy|antigravity|bash' } | "
          "%{ $_.CommandLine }")
    return [l.lower().replace("\\", "/") for l in _run(["powershell", "-NoProfile", "-Command", ps], 40).splitlines() if l.strip()]


def worktrees() -> dict[str, str]:
    """branch -> worktree path (forward slashes, lower case)."""
    out, path, res = _run(["git", "worktree", "list", "--porcelain"]), "", {}
    for line in out.splitlines():
        if line.startswith("worktree "):
            path = line[9:].strip().replace("\\", "/").lower()
        elif line.startswith("branch refs/heads/"):
            res[line[18:].strip()] = path
    return res


def newest_write_min(path: str, budget: int = 4000) -> float | None:
    """Minutes since the newest file write under path (bounded walk, skips caches). None = no such dir."""
    p = Path(path)
    if not p.is_dir():
        return None
    newest, seen, stack = 0.0, 0, [p]
    while stack and seen < budget:
        d = stack.pop()
        try:
            for e in d.iterdir():
                if e.name in SKIP_DIRS:
                    continue
                seen += 1
                if e.is_dir():
                    stack.append(e)
                else:
                    newest = max(newest, e.stat().st_mtime)
        except OSError:
            continue
    return (time.time() - newest) / 60.0 if newest else None


def _rc(args: list[str]) -> int:
    try:
        return subprocess.run(args, cwd=str(ROOT), capture_output=True, timeout=60, creationflags=_NO_WINDOW).returncode
    except Exception:
        return 1


def _started_epoch(started) -> float:
    try:
        return datetime.strptime(str(started)[:16], "%Y-%m-%d %H:%M").timestamp()
    except (TypeError, ValueError):
        return 0.0


def branch_on_master(ref: str, started) -> bool:
    """S249: the branch's work is on master - its tip is an ancestor of origin/main, or `git cherry` lists every commit '-'.
    Only a tip committed AFTER the run started counts, so a freshly cut branch (tip = old master) is never called collected."""
    if not ref:
        return False
    tip = _run(["git", "log", "-1", "--format=%ct", ref]).strip()
    if not tip.isdigit() or int(tip) < _started_epoch(started) - 60:
        return False
    if _rc(["git", "merge-base", "--is-ancestor", ref, "origin/main"]) == 0:
        return True
    lines = [l for l in _run(["git", "cherry", "origin/main", ref]).splitlines() if l.strip()]
    return bool(lines) and all(l.startswith("-") for l in lines)


def _names_run(run_id: str, text: str) -> bool:
    return bool(run_id) and re.search(r"(?<![A-Za-z0-9])%s(?![A-Za-z0-9])" % re.escape(run_id), text or "", re.I) is not None


def verdict_pc(run_id: str, info: dict, cmds: list[str], wts: dict[str, str]) -> tuple[str, str]:
    branch = str(info.get("branch", "") or "")
    ## S275: a LIVE process wins over the branch check - Codex FLOORTPM1 was archived "collected" 2 min after its launch
    ## (step 0 still running), so its later steps had no board row.
    match = str(info.get("match", "")).lower()
    if match and any(match in c for c in cmds):
        return "alive", "process matching %r" % match
    if branch and "*" not in branch and branch_on_master(branch, info.get("started")):
        return "merged", "branch %s commits are on master" % branch
    if info.get("log"):
        age = (time.time() - Path(str(info["log"])).stat().st_mtime) / 60.0 if Path(str(info["log"])).is_file() else None
        if age is not None and age < STALE_MIN:
            return "alive", "log written %.0f min ago" % age
    branch = str(info.get("branch", ""))
    # S351: a Lean run names its own worktree (another repo's, so it is not in this repo's worktree list).
    path = str(info.get("worktree", "")).replace("\\", "/").lower()
    if not path or not Path(path).is_dir():
        path = wts.get(branch, "")
    if not path:
        guess = "e:/fightcamp/wt/" + run_id.split("_")[0].lower()
        path = guess if Path(guess).is_dir() else ""
    if path and any(path in c for c in cmds):
        return "alive", "process in %s" % path
    age = newest_write_min(path) if path else None
    if age is not None and age < STALE_MIN:
        return "alive", "last write %.0f min ago in %s" % (age, path)
    if info.get("status") == "waiting":
        return "unknown", "waiting entry (no process expected)"
    where = path or "no worktree for branch %r" % branch
    return "dead", "no process and no write for %s min (%s)" % ("?" if age is None else "%.0f" % age, where)


def _before_start(created_utc, started_local) -> bool:
    """True when an Actions run was created more than 5 min before the run entry's local 'started' stamp."""
    try:
        created = datetime.fromisoformat(str(created_utc).replace("Z", "+00:00"))
        started = datetime.strptime(str(started_local)[:16], "%Y-%m-%d %H:%M").astimezone()
    except (TypeError, ValueError):
        return False
    return (started - created).total_seconds() > 300


def _issue_latest_run(issue) -> str | None:
    """The newest Actions run an issue-launched seat (Goose, the cloud-agent workflow) linked in the issue's comments."""
    iss = _gh_json("issue", "view", str(issue), "--json", "comments")
    if not isinstance(iss, dict):
        return None
    for c in reversed(iss.get("comments") or []):
        m = re.search(r"/actions/runs/(\d+)", str(c.get("body", "")))
        if m:
            return m.group(1)
    return None


def verdict_cloud(info: dict, prs: list, heads: dict, run_id: str = "") -> tuple[str, str]:
    branch = str(info.get("branch", "") or "")
    chat = str(info.get("chat", "") or "")
    if "arena.ai/" not in chat:
        ## S249: launches write the Arena chat into "note" ("https://arena.ai/agent/<id> ; brief ...")
        m = re.search(r"https?://arena\.ai/\S+", str(info.get("note", "") or ""))
        chat = m.group(0) if m else chat
    chat = chat.rstrip("/;,. ")
    if (not branch or "*" in branch) and "arena.ai/" in chat:
        ## S232: an Arena chat .../agent/01a144cf-...-a29e7e0e9178 pushes arena/7e0e9178-fightcamp (last 8 of the chat id)
        tail = chat.rsplit("/", 1)[-1].replace("-", "")[-8:]
        prefix = "arena/%s" % tail
        branch = next((h for h in heads if h.startswith(prefix)), "") or next(
            (str(p.get("headRefName")) for p in prs if str(p.get("headRefName", "")).startswith(prefix)), branch)
    if "*" in branch:
        ## S249: a glob ("grok/nightly9-*", one PR per test): the run's PRs are those whose title or branch names the run id
        ## (body only when no title does) - S249 start listed NIGHTLY9 as uncollected with #252/#253 both closed.
        cands = [p for p in prs if fnmatch.fnmatch(str(p.get("headRefName", "")), branch)]
        named = [p for p in cands if _names_run(run_id, "%s %s" % (p.get("title", ""), p.get("headRefName", "")))] or \
                [p for p in cands if _names_run(run_id, str(p.get("body", "")))]
        opened = [p for p in named if p.get("state") == "OPEN"]
        if opened:
            return "landed", "PR #%s open - collect it" % opened[0]["number"]
        if named:
            return "merged", "PR %s %s" % (", ".join("#%s" % p["number"] for p in named),
                                         "merged" if all(p.get("state") == "MERGED" for p in named) else "closed")
        branch = next((h for h in heads if fnmatch.fnmatch(h, branch) and _names_run(run_id, h)), "")
    if not branch and info.get("issue"):
        ## S244: an issue-labelled cloud run pushes <agent>/issue-<n>; Actions may not open PRs here, so the branch IS the landing
        ## (Cursor PLACEMENT1B was called "dead, nothing pushed" with cursor/issue-248 on origin).
        branch = next((h for h in heads if h.endswith("/issue-%s" % info["issue"])), "")
    pr = next((p for p in prs if branch and p.get("headRefName") == branch), None)
    if pr is None and info.get("issue"):
        pr = next((p for p in prs if str(p.get("headRefName", "")).endswith("issue-%s" % info["issue"])), None)
    if pr:
        state = pr.get("state")
        if state == "MERGED":
            return "merged", "PR #%s merged" % pr["number"]
        if state == "OPEN":
            return "landed", "PR #%s open - collect it" % pr["number"]
        if state == "CLOSED":
            return "merged", "PR #%s closed (merged by diff or rejected)" % pr["number"]
    if branch and branch in heads and branch_on_master(heads[branch], info.get("started")):
        return "merged", "branch %s commits are on master" % branch
    run_id = info.get("gh_run") or (_issue_latest_run(info["issue"]) if info.get("issue") else None)
    if run_id:
        gr = _gh_json("run", "view", str(run_id), "--json", "status,conclusion,updatedAt,createdAt")
        if isinstance(gr, dict) and not info.get("gh_run") and _before_start(gr.get("createdAt"), info.get("started")):
            ## S232: a relaunch's issue still links the PREVIOUS run until the new one comments - that run is not this entry's
            return "alive", "relaunched %s, waiting for the new run's link (newest linked run %s is older)" % (info.get("started"), run_id)
        if isinstance(gr, dict):
            if gr.get("status") != "completed":
                return "alive", "Actions run %s %s" % (run_id, gr.get("status"))
            if gr.get("conclusion") != "success":
                ## S232 (operator: "i see goose runing a task for 19h"): KICKREACH1's round-2 run failed at 20:07 on 10-15
                ## (push rejected) and the board said "running" for 19 h - a finished, failed run is dead, branch or not.
                return "dead", "Actions run %s finished %s at %s" % (run_id, gr.get("conclusion"), gr.get("updatedAt"))
            if branch and branch in heads:
                return "landed", "run finished (%s), branch %s pushed" % (gr.get("conclusion"), branch)
            return "dead", "Actions run %s finished %s, nothing pushed" % (run_id, gr.get("conclusion"))
    if info.get("issue"):
        iss = _gh_json("issue", "view", str(info["issue"]), "--json", "state")
        if isinstance(iss, dict) and iss.get("state") == "CLOSED":
            return "merged", "issue #%s closed" % info["issue"]
    if branch and branch in heads:
        return "alive", "branch %s on origin, no PR yet" % branch
    return "unknown", "no PR, run or branch to read yet"


def _close_as(why: str, master_log: str) -> str:
    """S249: a finished run is "collected" when its work is on master (the master log cites its PR, or its branch is merged),
    else "closed" (a PR closed without a collect). Both are archived by board_sync."""
    if "on master" in why:
        return "collected"
    nums = re.findall(r"#(\d+)", why)
    if nums and all(re.search(r"#%s(?!\d)" % n, master_log) for n in nums):
        return "collected"
    return "closed"


def load_runs() -> dict:
    return json.loads(RUNS.read_text(encoding="utf-8-sig"))  # S249: hand edits may save it with a BOM


def reconcile() -> dict:
    reg = load_runs()
    runs = reg.get("runs", {})
    cmds, wts = process_cmdlines(), worktrees()
    prs = _gh_json("pr", "list", "--repo", "ICOON-Studio/FightCamp-Lean", "--state", "all", "--limit", "150", "--json",
                   "number,headRefName,state,title,body") or []
    ## S432 (operator: "the session start ... starts to take too long"): runs collected BY DIFF (PR closed, files copied) never
    ## reach master as commits, so they sat "landed" for days, re-checked on git/GitHub at every start (18 s) and listed as
    ## COLLECT NOW. A landed/stale run whose PRs are all closed, or whose issue is closed, is finished: close it cheaply here.
    closed_issues = {str(i.get("number")) for i in (_gh_json("issue", "list", "--repo", "ICOON-Studio/FightCamp-Lean", "--state",
                                                              "closed", "--limit", "200", "--json", "number") or [])}
    master_log = _run(["git", "log", "origin/main", "-n", "800", "--format=%s %b"])
    heads = {}
    for line in _run(["git", "ls-remote", "origin", "refs/heads/arena/*", "refs/heads/goose/*", "refs/heads/qwen/*",
                      "refs/heads/grok/*", "refs/heads/opencode/*", "refs/heads/openhands/*", "refs/heads/cursor/*",
                      "refs/heads/agy/*"]).splitlines():
        sha, _, ref = line.partition("\t")
        heads[ref.replace("refs/heads/", "")] = sha
    rows = []
    for run_id, info in runs.items():
        if not isinstance(info, dict) or info.get("status") not in RECHECKED:
            continue
        agent = str(info.get("agent", "")).lower()
        own = [p for p in prs if info.get("branch") and p.get("headRefName") == info.get("branch")]
        if info.get("status") in ("landed", "stale") and own and all(p.get("state") != "OPEN" for p in own):
            v, why = "merged", "PR %s closed" % ", ".join("#%s" % p["number"] for p in own)
        elif info.get("status") in ("landed", "stale") and not own and str(info.get("issue") or "") in closed_issues:
            v, why = "merged", "issue %s closed" % info["issue"]
        elif agent in BROWSER_BOTS:
            v, why = "unknown", "browser bot - read its chat"
        elif str(info.get("where", "")).lower() == "pc" or (agent in PC_AGENTS and not info.get("gh_run") and not info.get("issue")
                                                              and not str(info.get("branch", "")).startswith(("arena/", "goose/", "grok/"))):
            v, why = verdict_pc(run_id, info, cmds, wts)
        else:
            v, why = verdict_cloud(info, prs, heads, run_id)
        if info.get("status") in ("landed", "stale") and v != "merged":
            continue  # S249: an already-marked run is only re-read for the moment its work reaches master
        row = {"id": run_id, "agent": agent, "status": info.get("status"), "verdict": v, "why": why}
        if v == "merged":
            row["close_as"] = _close_as(why, master_log)
        ## S240 fast lane: a landed run with an open PR gets Tools/auto_collect.py's verdict, so the board and the session watcher say
        ## at once whether it is a one-command collect (ELIGIBLE) or a normal review (the reasons).
        m = re.match(r"PR #(\d+) open", why)
        if v == "landed" and m:
            row["pr"] = int(m.group(1))
            try:
                import auto_collect
                info_pr = auto_collect.pr_info(row["pr"])
                reasons = auto_collect.eligibility(info_pr)
                row["fast_lane"] = "ELIGIBLE" if not reasons else "; ".join(reasons[:3])
            except Exception as exc:  # the fast-lane read never breaks the reconcile
                row["fast_lane"] = "check failed: %s" % exc
        rows.append(row)
    return {"at": datetime.now(timezone.utc).isoformat(timespec="seconds"), "rows": rows}


def apply(result: dict) -> int:
    reg = load_runs()
    runs, n = reg.get("runs", {}), 0
    stamp = datetime.now().strftime("%Y-%m-%d %H:%M")
    for row in result["rows"]:
        info = runs.get(row["id"])
        if not isinstance(info, dict):
            continue
        ## S232 (operator: "use more automation to speed up the production"): a multi-step issue task (UICARDS1: one step per
        ## cloud run) carries "auto_continue": N - a landed run re-labels its issue so the seat resumes on its branch at once,
        ## N times, instead of waiting for a Claude session. Claude collects the branch when the steps are done.
        if row["verdict"] == "landed" and int(info.get("auto_continue", 0) or 0) > 0 and info.get("issue"):
            label = str(info.get("label") or info.get("agent", ""))
            repo = ["--repo", "ICOON-Studio/FightCamp-Lean"]
            _run(["gh", "issue", "edit", str(info["issue"]), "--remove-label", label, *repo])
            time.sleep(3)
            _run(["gh", "issue", "edit", str(info["issue"]), "--add-label", label, *repo])
            info["auto_continue"] = int(info["auto_continue"]) - 1
            info["started"] = datetime.now().strftime("%Y-%m-%d %H:%M")
            info["reconciled"] = "%s board_reconcile: landed -> auto-continued (%d left)" % (stamp, info["auto_continue"])
            info["status"] = "running"
            n += 1
            continue
        new = {"dead": "stale", "landed": "landed", "merged": row.get("close_as", "closed")}.get(row["verdict"])
        if new and info.get("status") != new:
            info["status"] = new
            info["reconciled"] = "%s board_reconcile: %s" % (stamp, row["why"])
            n += 1
    if n:
        RUNS.write_text(json.dumps(reg, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
    return n


CITE_RE = re.compile(r"(?<![A-Za-z0-9])C(\d+)((?:\s*[-/,]\s*C?\d+)*)")


def cited_comment_ids(msg: str) -> set[str]:
    """Review-comment ids a commit message cites: "C106", "C100/C101", "C81-C84" (a range). A group right after a Ludo round
    tag ("Ludo r61 C3/C4", "r97 C2") is Ludo's own section numbering, not a comment."""
    found: set[str] = set()
    for m in CITE_RE.finditer(msg or ""):
        if re.search(r"(?:\br\d+[a-z]?|Ludo)\s*[:(]?\s*$", msg[max(0, m.start() - 14):m.start()], re.I):
            continue
        nums = [int(m.group(1))] + [int(n) for n in re.findall(r"\d+", m.group(2))]
        seps = re.findall(r"[-/,]", m.group(2))
        ids = {nums[0]}
        for sep, prev, cur in zip(seps, nums, nums[1:]):
            ids.update(range(prev, cur + 1) if sep == "-" and 0 < cur - prev <= 20 else {cur})
        found.update("C%d" % n for n in ids)
    return found - NOT_COMMENT_IDS


def mark_comments_addressed(write: bool = True) -> list[str]:
    """S249: a review comment (8787/review, media_comments.json) is ADDRESSED when a master commit made after it cites its id
    (C106 was fixed by d33b3048 and still read as open). Marks c["addressed"] = "<sha> <date>"; returns one line per mark."""
    try:
        data = json.loads(COMMENTS.read_text(encoding="utf-8-sig"))
    except (OSError, ValueError):
        return []
    rows = [c for c in data.get("comments", []) if isinstance(c, dict) and re.fullmatch(r"C\d+", str(c.get("id", "")))
            and not c.get("addressed") and c["id"] not in NOT_COMMENT_IDS]
    if not rows:
        return []
    commits = []
    for rec in _run(["git", "log", "main", "origin/main", "-n", "800", "--format=%h%x1f%ct%x1f%B%x1e"]).split("\x1e"):
        parts = rec.strip("\n").split("\x1f")
        if len(parts) == 3 and parts[1].isdigit():
            commits.append((parts[0], int(parts[1]), parts[2]))
    commits = [(sha, ct, cited_comment_ids(msg)) for sha, ct, msg in sorted(commits, key=lambda c: c[1])]  # oldest first
    marks = []
    for c in rows:
        try:
            at = datetime.fromisoformat(str(c.get("at", "")).replace("Z", "+00:00")).timestamp()
        except ValueError:
            continue
        hit = next((x for x in commits if x[1] >= at and c["id"] in x[2]), None)
        if hit:
            c["addressed"] = "cited by %s %s" % (hit[0], datetime.fromtimestamp(hit[1]).strftime("%Y-%m-%d"))
            marks.append("%s addressed (%s)" % (c["id"], c["addressed"]))
    if marks and write:
        tmp = COMMENTS.with_suffix(".json.tmp")
        tmp.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        os.replace(tmp, COMMENTS)
    return marks


def main() -> int:
    from_start = bool(os.environ.get("FIGHTCAMP_FROM_START"))
    if "--apply" in sys.argv and not from_start:
        ## S249: collect first - a PR merged now is archived by this same pass
        try:
            import collect_ready
            cr = collect_ready.run(apply=True)
            collect_ready.OUT.write_text(json.dumps(cr, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
            print("COLLECT_READY prs=%d merged=%d errors=%d" % (len(cr["prs"]), len(cr["merged"]), len(cr["errors"])))
        except Exception as exc:  # never breaks the reconcile
            print("COLLECT_READY failed: %s" % exc)
        ## S274: an agent branch pushed without a PR (Actions may not create PRs on this repo) gets one from the PC
        try:
            import open_agent_prs
            op = open_agent_prs.run(apply=True)
            print("OPEN_AGENT_PRS candidates=%d opened=%d errors=%d" % (len(op["candidates"]), len(op["opened"]), len(op["errors"])))
        except Exception as exc:  # never breaks the reconcile
            print("OPEN_AGENT_PRS failed: %s" % exc)
    result = reconcile()
    OUT.write_text(json.dumps(result, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
    for r in result["rows"]:
        print("%-8s %-14s %-11s %s - %s%s%s" % (r["verdict"].upper(), r["agent"], r["id"], r["status"], r["why"],
                                              (" -> %s" % r["close_as"]) if r.get("close_as") else "",
                                              (" | FAST LANE: %s" % r["fast_lane"]) if r.get("fast_lane") else ""))
    bad = [r for r in result["rows"] if r["verdict"] in ("dead", "landed", "merged")]
    print("BOARD_RECONCILE runs=%d act_on=%d" % (len(result["rows"]), len(bad)))
    if "--apply" in sys.argv:
        print("BOARD_RECONCILE applied=%d" % apply(result))
        for line in mark_comments_addressed():
            print("BOARD_RECONCILE comment " + line)
        if not from_start:
            try:
                import seat_queue
                for line in seat_queue.drain():
                    print("SEAT_QUEUE " + line)
            except Exception as exc:  # never breaks the reconcile
                print("SEAT_QUEUE failed: %s" % exc)
            ## S259: the nightly suite runs on GitHub runners - its result reaches AgentComms/nightly/ within 30 min of landing.
            try:
                import nightly_fetch
                line = nightly_fetch.fetch()
                if line:
                    print(line)
            except Exception as exc:  # never breaks the reconcile
                print("NIGHTLY_FETCH failed: %s" % exc)
            ## S264 operator ("this is happening every session, find a way this cannot happen again"): Arena clones the
            ## code-only mirror ICOON-Studio/FightCamp-lite (89 MB, 13 s) instead of the 6.7 GB repo; keep it on master
            ## and relay its PRs to arena/* PRs here (Tools/lite_mirror.py).
            ## S366: the old repo (E:\FightCamp\Game -> FightCamp-lite) is retired; only the Lean mirror below runs.
            ## S304 (operator: "I ran it" - the first --lean push - "wire the sync and launch Arena on the new game"): the
            ## same mirror + relay for E:\FightCamp\Lean -> FightCamp-Lean-lite. Own process: lite_mirror's --lean profile
            ## rewrites its module globals, so it never shares the import above.
            try:
                p = subprocess.run([sys.executable, str(Path(__file__).with_name("lite_mirror.py")), "--lean", "sync"],
                                   cwd=str(ROOT), capture_output=True, text=True, encoding="utf-8", errors="replace",
                                   timeout=1500, creationflags=_NO_WINDOW)
                for line in (p.stdout or "").splitlines():
                    print("LEAN " + line)
                if p.returncode != 0:
                    print("LEAN_MIRROR exit %s: %s" % (p.returncode, (p.stderr or "")[-300:]))
            except Exception as exc:  # never breaks the reconcile
                print("LEAN_MIRROR failed: %s" % exc)
            ## S261: the heat governor's only trigger is "at logon"; it died at 04:11 (0xC000013A) and the PC ran unguarded
            ## for 11 h. Restart it through its own task when no copy is running (CLAUDE.md s4: Start-ScheduledTask only).
            ## S305 (operator: "i think your memory fix tool is not working"): the RAM trim loop has the same logon-only
            ## trigger and died at 01:05 on 10-29 (0xC000013A); it is kept alive the same way.
            for proc, task in (("heat_governor", "FightCamp Heat Governor"), ("ram_trim_loop", "FightCamp RAM Trim")):
                try:
                    ps = subprocess.run(["powershell", "-NoProfile", "-Command",
                                         "(Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -match '%s' }).Count" % proc],
                                        capture_output=True, text=True, timeout=60, creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
                    if ps.stdout.strip() in ("", "0"):
                        subprocess.run(["powershell", "-NoProfile", "-Command", "Start-ScheduledTask -TaskName '%s'" % task],
                                       timeout=60, creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
                        print("%s was not running -> restarted via its scheduled task" % proc.upper())
                except Exception as exc:  # never breaks the reconcile
                    print("%s check failed: %s" % (proc.upper(), exc))
            ## S249 operator: "auto-retire worktrees and gate clones from now on" (E: had fallen to 11 GB free)
            try:
                import worktree_retire
                st = worktree_retire.run(apply=True)
                print("WORKTREE_RETIRE retired=%d held=%d gate_clones=%d E_free=%.1f GB" % (
                    sum(1 for r in st["worktrees"] if r.get("done")), sum(1 for r in st["worktrees"] if r["verdict"] == "held"),
                    sum(1 for g in st["gate_clones"] if g.get("done")), st["e_free_gb"]))
            except Exception as exc:  # never breaks the reconcile
                print("WORKTREE_RETIRE failed: %s" % exc)
            ## S368 (operator: "can you program other agents like cursor,qwen,arena to pick up tasks and deliver automatically"):
            ## an idle CLI seat (Qwen, Cursor, Antigravity) launches its queued task - valid contract, watchdog not RED, at most
            ## 2 PC agents, one launch a cycle; its hidden runner commits, tests, pushes, opens the PR, films + Argon for a visual
            ## brief. Merging stays off. Pause: create AgentComms/seat_dispatch_off.flag.
            try:
                if (ROOT / "AgentComms" / "seat_dispatch_off.flag").exists():
                    print("SEAT_DISPATCH paused (AgentComms/seat_dispatch_off.flag)")
                else:
                    import seat_dispatch
                    for line in seat_dispatch.dispatch(act=True):
                        print("SEAT_DISPATCH " + line)
            except Exception as exc:  # never breaks the reconcile
                print("SEAT_DISPATCH failed: %s" % exc)
        ## S232 (operator: "can you automate this board update process"): the same 30-min task keeps the board's
        ## working_now / done_recently / archive current (Tools/board_sync.py).
        import board_sync
        sys.argv = [sys.argv[0], "--apply"]
        board_sync.main()
        ## S241: the same task keeps `agent_comms.py start` fast - it measures the remote branches' research files once per
        ## tip here (Tools/research_sync.py cache, AgentComms/start_cache.json) so a session start only diffs NEW tips.
        try:
            if os.environ.get("FIGHTCAMP_FROM_START"):
                return 0  # `agent_comms.py start` fetches and warms the cache itself, in parallel
            import research_sync
            _run(["git", "fetch", "--no-write-fetch-head", "origin", "--prune"], 120)
            research_sync.warm_cache()
        except Exception as exc:  # never breaks the reconcile
            print("BOARD_RECONCILE start-cache warm failed: %s" % exc)
    return 0


if __name__ == "__main__":
    sys.exit(main())
