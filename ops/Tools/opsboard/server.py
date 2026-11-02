#!/usr/bin/env python3
"""FightCamp Ops Board — local web dashboard for who is working, on what, and how long.

Stdlib only. Bind 0.0.0.0 so Safari on an iPhone can reach it over the LAN.

  python Tools/opsboard/server.py [--port 8787]
  python Tools/opsboard/server.py --selftest
"""
from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import socket
import statistics
import subprocess
import sys
import tempfile
import threading
import traceback
from datetime import datetime, timedelta, timezone
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from typing import Any
from urllib.parse import urlparse

def _resolve_paths() -> tuple[Path, Path]:
	"""Where the page lives and where the repo lives, as a script OR as an .exe.

	Frozen, `__file__` points inside PyInstaller's temp extraction dir, so the
	repo can never be derived from it: `index.html` rides INSIDE the exe
	(`sys._MEIPASS`) and the repo is found by walking up from the exe itself,
	then from the working directory, looking for the two things this board
	actually reads. `FIGHTCAMP_ROOT` overrides both. Run from a checkout as a
	script the first candidate IS the old `HERE.parent.parent`, so nothing
	about the script path changes.
	"""
	if getattr(sys, "frozen", False):
		here = Path(getattr(sys, "_MEIPASS", "") or Path(sys.executable).resolve().parent)
		starts = [Path(sys.executable).resolve().parent, Path.cwd()]
	else:
		here = Path(__file__).resolve().parent
		starts = [here.parent.parent, Path.cwd()]
	env = os.environ.get("FIGHTCAMP_ROOT", "").strip()
	if env:
		starts.insert(0, Path(env))
	for start in starts:
		for cand in [start, *start.parents]:
			if (cand / "AgentComms").is_dir() and (cand / "HANDOFF.md").is_file():
				return here, cand
	return here, starts[0]


HERE, ROOT = _resolve_paths()
# R138 (operator decision 2026-09-12): THE CHECKOUT WINS OVER THE BUNDLE.
#
# Frozen, `HERE` is PyInstaller's temp extraction dir, so `HERE / "index.html"`
# is the copy baked into the exe at build time. That copy DRIFTS: the exe served
# a 16 KB page for a day while the checkout held 28 KB, so U63's roadmap
# sections and the collapsible Attention/History were on disk and unreachable.
# Rebuilding the exe would only reset the clock on the same defect - it is the
# ninth instance of a bundled copy drifting from its source found on one day.
#
# `ROOT` is already discovered honestly (walk up for `AgentComms/` and
# `HANDOFF.md`), so prefer the checkout's page whenever there is a checkout, and
# fall back to the bundled copy only for an exe run somewhere without one. The
# exe stays standalone; from a checkout it can no longer serve a stale page.
_REPO_PAGE = ROOT / "Tools" / "opsboard" / "index.html"
PAGE = _REPO_PAGE if _REPO_PAGE.is_file() else (HERE / "index.html")
## S130: the Animations page (operator 2026-09-30: "a list of the animations for movement and boxing ... which are
## ready or not ... watch the animations from the opsboard"). Status comes from Tools/anim_catalogue.py; previews are
## served read-only from previews and nowhere else.
ANIM_PAGE = ROOT / "Tools" / "opsboard" / "animations.html"
## S157: the main page is the plain roadmap (operator: "tidy up the opsboard ... i want to know clearly a detailed
## roadmap showing what is being worked, what is next, who agents are scheduled for what and who are running").
## It reads roadmap.json `plan` + live_runs.json; the old detailed board stays at /old.
ROADMAP_PAGE = ROOT / "Tools" / "opsboard" / "roadmap.html"
MEDIA_ROOT = (ROOT / "previews").resolve()
MEDIA_TYPES = {".mp4": "video/mp4", ".png": "image/png", ".jpg": "image/jpeg", ".jpeg": "image/jpeg"}


## S133: the live Agents page (operator 2026-09-30: "i have no clue how to use visual studio for live monitoring").
## Per shell agent: its roster note, whether its CLI process is alive, its worktree branch / last commit / files it is
## changing right now (git status, newest first), and the tail of its output file. Read-only; refreshed by the page.
AGENTS_PAGE = ROOT / "Tools" / "opsboard" / "agents.html"
AGENT_MARKS = {"codex": ["codex.js\" exec", "codex.exe exec"], "cursor": ["cursor-agent"],
               "qwen": ["qwen-code", "qwen.cmd"], "grok": ["grok.exe"]}
_PROC_CACHE: dict[str, Any] = {"t": 0.0, "text": ""}


def _process_text() -> str:
    import time as _t
    if _t.time() - float(_PROC_CACHE["t"]) < 4.0:
        return str(_PROC_CACHE["text"])
    try:
        out = subprocess.run(["powershell", "-NoProfile", "-Command",
                              "Get-CimInstance Win32_Process | ForEach-Object { $_.Name + ' ' + $_.CommandLine }"],
                             capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=20).stdout
    except Exception:
        out = ""
    _PROC_CACHE.update({"t": _t.time(), "text": out})
    return out


def _git(worktree: str, *args: str) -> str:
    try:
        return subprocess.run(["git", "-C", worktree, *args], capture_output=True, text=True, encoding="utf-8",
                              errors="replace", timeout=15).stdout.strip()
    except Exception:
        return ""


## S157 (operator: "update the opsboard/agents make it to check on the agents, distinct who are working on cloud
## currently"): a LIVE check of every cloud run in live_runs.json - GitHub is the witness, not our notes. Per run: its
## branch on origin (exists? last commit when?), its PR (open/draft/merged + CI), and for the GitHub-Actions agents
## (OpenCode/Goose) the workflow run itself. Cached 60 s; gh/git run with no console window.
CLOUD_AGENTS = ("arena", "openhands", "opencode", "goose", "qwen", "cursor", "grok", "codex")
_CLOUD_CACHE: dict[str, Any] = {"t": 0.0, "data": None}
_NO_WINDOW = getattr(subprocess, "CREATE_NO_WINDOW", 0)


def _gh_json(*args: str) -> Any:
    try:
        out = subprocess.run(["gh", *args], cwd=str(ROOT), capture_output=True, text=True, encoding="utf-8",
                             errors="replace", timeout=25, creationflags=_NO_WINDOW).stdout
        return json.loads(out) if out.strip() else None
    except Exception:
        return None


## S158 (operator: "put the usage/limits for each agent on the opsboard with their reset day"; "go inside each client
## and check the usage"): AgentComms/agent_limits.json is the registry; the rows marked `live` are re-read here. Each
## reader returns a short status string or "" (unknown) - never raises. Cached 10 min (the GitHub billing API is slow).
_LIMITS_CACHE: dict[str, Any] = {"t": 0.0, "data": None}


## S212 (operator: "you also need to check the github actions and my budget pool"; "can you show the github meters on
## opsboard"): minutes are the org's (ICOON-Studio since S178), shared with its other repos.
## S260 (operator: "can you add the actions github meter on opsboard real-time sync please"): S259 moved billing to the paid
## ENTERPRISE icoon-studio (50,000 Actions min/month included). Two readers, merged:
##   BILLED - enterprises/<ent>/settings/billing/usage (falls back to the org's) in HOURLY buckets that lag 1-3 h; cached 2 min.
##   LIVE   - the org repos' own workflow jobs (GitHub's billing unit: each job rounded UP to a whole minute, Linux x1): jobs
##            finished after the last billed hour + jobs running now (minutes so far). Cached 20 s and only read while a page
##            asks, so an unopened board makes no calls; a finished run's minutes are kept for good (one jobs call per run).
## used_min = billed + not-yet-billed (the live month); free_min = the included pool (kept names: roadmap.html, agent_meters.py).
GH_ORG = "ICOON-Studio"
GH_ENTERPRISE = "icoon-studio"
GH_FREE_MIN = 50000
_GH_CACHE: dict[str, Any] = {"t": 0.0, "data": None}
_GH_LIVE_CACHE: dict[str, Any] = {"t": 0.0, "data": None}
_GH_REPOS: dict[str, Any] = {"t": 0.0, "names": []}
_GH_RUN_MIN: dict[int, list] = {}  # finished run id -> [[completed_at iso, billable minutes], ...] per job


def _iso_dt(text: str) -> datetime | None:
    try:
        return datetime.fromisoformat(str(text).replace("Z", "+00:00"))
    except Exception:
        return None


def _gh_billed() -> dict[str, Any]:
    import time as _t
    if _GH_CACHE["data"] is not None and _t.time() - float(_GH_CACHE["t"]) < 120.0:
        return _GH_CACHE["data"]
    now = datetime.now(timezone.utc)
    q = "settings/billing/usage?year=%d&month=%d" % (now.year, now.month)
    scope = "enterprise " + GH_ENTERPRISE
    usage = _gh_json("api", "enterprises/%s/%s" % (GH_ENTERPRISE, q))
    if not isinstance(usage, dict) or "usageItems" not in usage:
        scope = "org " + GH_ORG
        usage = _gh_json("api", "organizations/%s/%s" % (GH_ORG, q))
    if not isinstance(usage, dict):
        return {"ok": False, "why": "gh billing read failed (gh auth needs the billing scope)"}
    items = [i for i in usage.get("usageItems", []) if str(i.get("product", "")).lower() == "actions"]
    minutes = [i for i in items if str(i.get("unitType", "")).lower() == "minutes"]
    today = now.strftime("%Y-%m-%d")
    by_repo: dict[str, float] = {}
    last_bucket = None
    for i in minutes:
        name = str(i.get("repositoryName") or "?")
        by_repo[name] = by_repo.get(name, 0.0) + float(i.get("quantity", 0))
        d = _iso_dt(str(i.get("date", "")))
        if d is not None and (last_bucket is None or d > last_bucket):
            last_bucket = d
    budget, hard_stop = None, False
    budgets = _gh_json("api", "organizations/%s/settings/billing/budgets" % GH_ORG)
    for b in (budgets or {}).get("budgets", []) if isinstance(budgets, dict) else []:
        if str(b.get("budget_product_sku", "")).lower() == "actions":
            budget = float(b.get("budget_amount", 0))
            hard_stop = bool(b.get("prevent_further_usage"))
    data = {"ok": True, "scope": scope, "billed_min": sum(float(i.get("quantity", 0)) for i in minutes),
            "billed_today_min": sum(float(i.get("quantity", 0)) for i in minutes if str(i.get("date", "")).startswith(today)),
            "paid_usd": round(sum(float(i.get("netAmount", 0)) for i in items), 2), "budget_usd": budget, "hard_stop": hard_stop,
            "by_repo": by_repo,
            ## an hourly bucket covers [date, date + 1 h): a job finished after the newest bucket's end is not billed yet
            "billed_through": (last_bucket.timestamp() + 3600.0) if last_bucket is not None else None,
            "billed_at": now.strftime("%H:%M:%S UTC")}
    _GH_CACHE.update({"t": _t.time(), "data": data})
    return data


def _job_minutes(job: dict, now: datetime) -> tuple[float, bool]:
    """(billable minutes, running) for one job: whole minutes rounded up when finished, exact minutes so far while running."""
    import math
    start = _iso_dt(str(job.get("started_at") or ""))
    if start is None or str(job.get("status")) in ("queued", "waiting", "pending"):
        return 0.0, False
    done = _iso_dt(str(job.get("completed_at") or "")) if job.get("completed_at") else None
    if done is None:
        return max(0.0, (now - start).total_seconds() / 60.0), True
    secs = max(0.0, (done - start).total_seconds())
    return (float(math.ceil(secs / 60.0)) if secs > 0 else 0.0), False


def _gh_live(billed_through: float | None) -> dict[str, Any]:
    import time as _t
    if _GH_LIVE_CACHE["data"] is not None and _t.time() - float(_GH_LIVE_CACHE["t"]) < 20.0:
        return _GH_LIVE_CACHE["data"]
    now = datetime.now(timezone.utc)
    if _t.time() - float(_GH_REPOS["t"]) > 3600.0 or not _GH_REPOS["names"]:
        names = _gh_json("api", "orgs/%s/repos?per_page=100" % GH_ORG)
        _GH_REPOS.update({"t": _t.time(), "names": [str(r.get("name")) for r in names] if isinstance(names, list) else ["FightCamp"]})
    day0 = now.replace(hour=0, minute=0, second=0, microsecond=0)
    since = datetime.fromtimestamp(billed_through, timezone.utc) if billed_through else day0
    since_day = min(since, day0).strftime("%Y-%m-%d")
    unbilled, running_min, running_jobs, queued_jobs = 0.0, 0.0, 0, 0
    today_live: dict[str, float] = {}
    runs_now: list[dict] = []
    for repo in _GH_REPOS["names"]:
        runs = _gh_json("api", "repos/%s/%s/actions/runs?created=%%3E%%3D%s&per_page=100" % (GH_ORG, repo, since_day))
        for run in (runs or {}).get("workflow_runs", []) if isinstance(runs, dict) else []:
            rid = int(run.get("id", 0))
            status = str(run.get("status", ""))
            if status in ("queued", "waiting", "pending", "requested"):
                ## no runner yet: nothing to bill, no jobs call
                queued_jobs += 1
                runs_now.append({"repo": repo, "name": str(run.get("display_title") or run.get("name") or ""),
                                 "workflow": str(run.get("name") or ""), "status": status,
                                 "url": str(run.get("html_url") or ""), "started": str(run.get("run_started_at") or "")})
                continue
            if status == "completed" and rid in _GH_RUN_MIN:
                jobs_min = _GH_RUN_MIN[rid]
            else:
                jd = _gh_json("api", "repos/%s/%s/actions/runs/%d/jobs?per_page=100" % (GH_ORG, repo, rid))
                jobs_min = []
                for job in (jd or {}).get("jobs", []) if isinstance(jd, dict) else []:
                    m, is_running = _job_minutes(job, now)
                    if is_running:
                        running_min += m
                        running_jobs += 1
                        today_live[repo] = today_live.get(repo, 0.0) + m
                    elif str(job.get("status")) in ("queued", "waiting", "pending"):
                        queued_jobs += 1
                    elif job.get("completed_at"):
                        jobs_min.append([str(job["completed_at"]), m])
                if status == "completed" and isinstance(jd, dict):
                    _GH_RUN_MIN[rid] = jobs_min
                elif status != "completed":
                    runs_now.append({"repo": repo, "name": str(run.get("display_title") or run.get("name") or ""),
                                     "workflow": str(run.get("name") or ""), "status": status,
                                     "url": str(run.get("html_url") or ""), "started": str(run.get("run_started_at") or "")})
            for done_iso, m in jobs_min:
                d = _iso_dt(done_iso)
                if d is None:
                    continue
                if billed_through is None or d.timestamp() >= billed_through:
                    unbilled += float(m)
                if d >= day0:
                    today_live[repo] = today_live.get(repo, 0.0) + float(m)
    data = {"unbilled_min": unbilled + running_min, "running_min": running_min, "running_jobs": running_jobs,
            "queued_jobs": queued_jobs, "runs_now": runs_now[:8], "today_jobs_min": round(sum(today_live.values())),
            "today_by_repo": {k: round(v) for k, v in sorted(today_live.items(), key=lambda kv: -kv[1])},
            "live_at": now.strftime("%H:%M:%S UTC")}
    _GH_LIVE_CACHE.update({"t": _t.time(), "data": data})
    return data


_GH_METER: dict[str, Any] = {"t": 0.0, "data": None}
_GH_METER_LOCK = threading.Lock()


def _gh_meter_refresh() -> None:
    import time as _t
    if not _GH_METER_LOCK.acquire(blocking=False):
        return
    try:
        _GH_METER.update({"t": _t.time(), "data": _github_actions_compute()})
    except Exception as exc:
        _GH_METER.update({"t": _t.time(), "data": {"ok": False, "why": "meter read failed: %s" % exc}})
    finally:
        _GH_METER_LOCK.release()


## The board's read (S260 real-time): answers at once with the last reading and refreshes it in the background once it is
## older than 20 s - the page never waits on GitHub. `wait` (scripts: agent_meters.py, the agent-limits reader) blocks for
## the very first reading instead of answering "reading".
def github_actions_meter(wait: bool = True) -> dict[str, Any]:
    import time as _t
    if _GH_METER["data"] is None:
        if wait:
            _gh_meter_refresh()
            return _GH_METER["data"] or {"ok": False, "why": "reading GitHub Actions"}
        threading.Thread(target=_gh_meter_refresh, name="gh-meter", daemon=True).start()
        return {"ok": False, "why": "reading GitHub Actions (first read ~1 min)"}
    if _t.time() - float(_GH_METER["t"]) > 20.0:
        threading.Thread(target=_gh_meter_refresh, name="gh-meter", daemon=True).start()
    out = dict(_GH_METER["data"])
    out["age_s"] = round(_t.time() - float(_GH_METER["t"]))
    return out


def _github_actions_compute() -> dict[str, Any]:
    billed = _gh_billed()
    if not billed.get("ok"):
        return billed
    live = _gh_live(billed.get("billed_through"))
    now = datetime.now(timezone.utc)
    through = billed.get("billed_through")
    return {"ok": True, "org": GH_ORG, "scope": billed["scope"], "month": now.strftime("%B"),
            "used_min": round(billed["billed_min"] + live["unbilled_min"]), "free_min": GH_FREE_MIN,
            "billed_min": round(billed["billed_min"]), "unbilled_min": round(live["unbilled_min"], 1),
            "today_min": live["today_jobs_min"], "running_min": round(live["running_min"], 1),
            "running_jobs": live["running_jobs"], "queued_jobs": live["queued_jobs"], "runs_now": live["runs_now"],
            "paid_usd": billed["paid_usd"], "budget_usd": billed["budget_usd"], "hard_stop": billed["hard_stop"],
            "by_repo": {k: round(v) for k, v in sorted(billed["by_repo"].items(), key=lambda kv: -kv[1])},
            "today_by_repo": live["today_by_repo"],
            "billed_through": datetime.fromtimestamp(through, timezone.utc).strftime("%H:%M UTC") if through else None,
            "at": live["live_at"], "billed_at": billed["billed_at"]}


def _live_github_actions() -> str:
    d = github_actions_meter()
    if not d.get("ok"):
        return ""
    budget = "$%.0f budget%s" % (d["budget_usd"], " (hard stop)" if d["hard_stop"] else "") if d["budget_usd"] is not None else "no budget set"
    return "%d of %d included minutes used in %s (%d%%) · paid $%.2f of the %s · org %s" % (
        d["used_min"], d["free_min"], d["month"], round(100 * d["used_min"] / float(d["free_min"])), d["paid_usd"], budget, d["org"])


def _live_codex_log() -> str:
    files = sorted(Path.home().glob(".codex/sessions/*/*/*/*.jsonl"), key=lambda p: p.stat().st_mtime, reverse=True)
    for f in files[:3]:
        try:
            text = f.read_text(encoding="utf-8", errors="replace")
        except OSError:
            continue
        hits = re.findall(r'"rate_limits":(\{.*?"plan_type":"[^"]*"[^}]*\})', text)
        if hits:
            try:
                rl = json.loads(hits[-1])
            except ValueError:
                continue
            p = rl.get("primary") or {}
            when = datetime.fromtimestamp(f.stat().st_mtime, timezone.utc).strftime("%m-%d %H:%M UTC")
            return "%s%% of the weekly window used (as of its last run, %s) · plan %s" % (
                p.get("used_percent", "?"), when, rl.get("plan_type", "?"))
    return ""


def _live_openrouter() -> str:
    key_file = Path.home() / ".fightcamp" / "openrouter_key.txt"
    if not key_file.is_file():
        return ""
    try:
        import urllib.request
        req = urllib.request.Request("https://openrouter.ai/api/v1/key",
                                     headers={"Authorization": "Bearer " + key_file.read_text().strip()})
        d = json.load(urllib.request.urlopen(req, timeout=20)).get("data", {})
    except Exception:
        return ""
    tier = "FREE tier: 50 free-model requests/day" if d.get("is_free_tier") else "1,000 free-model requests/day"
    return "%s · spent $%.2f today, $%.2f this month" % (tier, float(d.get("usage_daily") or 0), float(d.get("usage_monthly") or 0))


def _live_openhands_count() -> str:
    try:
        runs = json.loads((ROOT / "AgentComms" / "live_runs.json").read_text(encoding="utf-8")).get("runs", {})
    except (OSError, ValueError):
        return ""
    today = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    n = sum(1 for r in runs.values() if isinstance(r, dict) and r.get("agent") == "openhands" and str(r.get("started", "")).startswith(today))
    return "%d of 10 conversations started today (our launches)" % n


def limits_live() -> dict[str, Any]:
    import time as _t
    if _LIMITS_CACHE["data"] is not None and _t.time() - float(_LIMITS_CACHE["t"]) < 600.0:
        return _LIMITS_CACHE["data"]
    try:
        reg = json.loads((ROOT / "AgentComms" / "agent_limits.json").read_text(encoding="utf-8"))
    except (OSError, ValueError):
        reg = {"agents": []}
    readers = {"github_actions": _live_github_actions, "codex_log": _live_codex_log, "openrouter": _live_openrouter,
               "openhands_count": _live_openhands_count}
    rows = []
    for a in reg.get("agents", []):
        row = dict(a)
        fn = readers.get(str(a.get("live") or ""))
        if fn is not None:
            try:
                got = fn()
            except Exception:
                got = ""
            row["status"] = got or (str(a.get("status", "")) + " (live read failed)").strip()
            row["is_live"] = bool(got)
        rows.append(row)
    data = {"at": datetime.now(timezone.utc).isoformat(timespec="seconds"), "updated": reg.get("updated", ""), "agents": rows}
    _LIMITS_CACHE.update({"t": _t.time(), "data": data})
    return data


def cloud_live() -> dict[str, Any]:
    import time as _t
    if _CLOUD_CACHE["data"] is not None and _t.time() - float(_CLOUD_CACHE["t"]) < 60.0:
        return _CLOUD_CACHE["data"]
    try:
        registry = json.loads((ROOT / "AgentComms" / "live_runs.json").read_text(encoding="utf-8"))
    except (OSError, ValueError):
        registry = {}
    runs = registry.get("runs", {}) if isinstance(registry.get("runs", {}), dict) else {}
    try:
        titles = json.loads((ROOT / "AgentComms" / "roadmap.json").read_text(encoding="utf-8")).get("plan", {}).get("titles", {})
    except (OSError, ValueError):
        titles = {}
    heads: dict[str, str] = {}
    try:
        ls = subprocess.run(["git", "ls-remote", "origin", "refs/heads/arena/*", "refs/heads/openhands/*",
                             "refs/heads/goose/*", "refs/heads/opencode/*"], cwd=str(ROOT), capture_output=True,
                            text=True, timeout=25, creationflags=_NO_WINDOW).stdout
        for line in ls.splitlines():
            sha, _, ref = line.partition("\t")
            heads[ref.replace("refs/heads/", "")] = sha
    except Exception:
        pass
    prs = _gh_json("pr", "list", "--state", "all", "--limit", "40", "--json",
                   "number,headRefName,state,isDraft,url,title,statusCheckRollup") or []
    rows = []
    busy = set()
    for run_id, info in runs.items():
        if not isinstance(info, dict) or info.get("status") != "running" or info.get("agent") not in CLOUD_AGENTS:
            continue
        agent = str(info["agent"])
        busy.add(agent)
        branch = str(info.get("branch", ""))
        if not branch and agent == "opencode":
            branch = next((b for b in heads if b.startswith("opencode/") and ("issue%s" % info.get("issue", "?")) in b.replace("-", "")), "")
        row: dict[str, Any] = {"id": run_id, "agent": agent, "title": str(titles.get(run_id) or info.get("title", "")),
                               "started": info.get("started", ""), "eta": info.get("eta", ""), "link": info.get("chat", ""),
                               "branch": branch, "branch_exists": branch in heads}
        if branch in heads:
            ## A branch the agent made but never committed on points at a master commit: that is "nothing pushed".
            try:
                own = subprocess.run(["git", "merge-base", "--is-ancestor", heads[branch], "origin/main"], cwd=str(ROOT),
                                     capture_output=True, timeout=15, creationflags=_NO_WINDOW).returncode != 0
            except Exception:
                own = True
            row["branch_exists"] = own
        if branch in heads and row["branch_exists"]:
            commit = _gh_json("api", "repos/{owner}/{repo}/commits/" + heads[branch], "--jq",
                              "{date: .commit.committer.date, msg: (.commit.message | split(\"\\n\")[0])}")
            if isinstance(commit, dict):
                row["last_commit"] = commit
        pr = next((p for p in prs if p.get("headRefName") == branch), None) if branch else None
        if pr is None and info.get("issue"):
            pr = next((p for p in prs if ("#%s" % info["issue"]) in str(p.get("title", "")) or
                       str(p.get("headRefName", "")).endswith("-%s" % info["issue"])), None)
        if pr:
            checks = [c.get("conclusion") or c.get("status") for c in (pr.get("statusCheckRollup") or [])]
            row["pr"] = {"number": pr["number"], "state": pr["state"], "draft": pr.get("isDraft", False), "url": pr["url"],
                         "ci": "failed" if "FAILURE" in checks else ("running" if any(c in ("IN_PROGRESS", "QUEUED", "PENDING") for c in checks)
                                                                    else ("passed" if checks else "none"))}
        if info.get("gh_run"):
            gr = _gh_json("run", "view", str(info["gh_run"]), "--json", "status,conclusion,updatedAt,url")
            if isinstance(gr, dict):
                row["gh_run"] = gr
        ## One plain verdict the operator reads.
        if row.get("pr", {}).get("state") == "MERGED":
            row["verdict"] = "merged - mark it done"
        elif row.get("pr", {}).get("state") == "OPEN":
            row["verdict"] = "PR open - Claude reviews" + (" (draft)" if row["pr"]["draft"] else "")
        elif row.get("gh_run", {}).get("status") == "completed":
            row["verdict"] = "finished (%s), no PR yet" % row["gh_run"].get("conclusion", "?")
        elif row.get("gh_run", {}).get("status") in ("in_progress", "queued"):
            row["verdict"] = "working on GitHub's machine"
        elif row["branch_exists"]:
            row["verdict"] = "working - has pushed commits"
        else:
            row["verdict"] = "working - nothing pushed yet"
        rows.append(row)
    idle = [a for a in CLOUD_AGENTS if a not in busy]
    data = {"at": datetime.now(timezone.utc).isoformat(timespec="seconds"), "runs": rows, "idle": idle}
    _CLOUD_CACHE.update({"t": _t.time(), "data": data})
    return data


def agents_live() -> dict[str, Any]:
    import time as _t
    roster = load_roster()
    proc_text = _process_text()
    procs = proc_text.lower()
    ## S144 (operator: "why i do not see anywhere in real time which agents are working ?"): one row per agent TYPE
    ## with task/worktree parsed from the roster NOTE showed three Codex runs as one row with a blank task. The live
    ## truth is each CLI process's own command line: Codex `exec ... -C <worktree> -o <prompts>/<ID>_rN_out.txt`,
    ## Grok `-p "...prompts\<ID>_rN.txt..." --cwd "<worktree>"`. One row per RUNNING process, then idle agents.
    live: list[tuple[str, str, str, str]] = []
    for line in proc_text.splitlines():
        low = line.lower()
        if low.startswith("codex.exe ") and " exec " in low:
            wt_m = re.search(r" -C (\S+)", line)
            out_m = re.search(r" -o (\S+)", line)
            out = out_m.group(1) if out_m else ""
            task_m = re.search(r"([A-Za-z0-9]+)_r?\d*_?out\.txt$", out.replace("\\", "/").split("/")[-1]) if out else None
            live.append(("codex", wt_m.group(1) if wt_m else "", (task_m.group(1) if task_m else ""), out))
        elif low.startswith("grok.exe "):
            wt_m = re.search(r'--cwd "?([^"]+)"?', line)
            pr_m = re.search(r"prompts[\\/]([A-Za-z0-9]+)(_r\d+)?\.txt", line)
            task = pr_m.group(1) if pr_m else ""
            out = str(ROOT / "AgentComms" / "prompts" / ((task + (pr_m.group(2) or "") + "_out.txt") if pr_m else ""))
            live.append(("grok", wt_m.group(1).strip() if wt_m else "", task, out))
    rows = []
    seen_types = set()
    plan: list[tuple[str, str, str, str, bool]] = [(n, w, t, o, True) for n, w, t, o in live]
    for name in ("codex", "cursor", "qwen", "grok"):
        if not any(n == name for n, _w, _t, _o in live):
            plan.append((name, "", "", "", any(m.lower() in procs for m in AGENT_MARKS[name])))
    for name, wt_live, task_live, out_live, alive in plan:
        entry = roster.get(name, {}) if isinstance(roster.get(name, {}), dict) else {}
        note = str(entry.get("note", ""))
        row: dict[str, Any] = {"name": name, "note": note, "alive": bool(alive and task_live) or (alive and not wt_live and name not in seen_types),
                               "in_rotation": bool(entry.get("in_rotation", False)),
                               "task": task_live, "worktree": wt_live.replace("\\", "/")}
        seen_types.add(name)
        wt = row["worktree"]
        if wt and Path(wt).is_dir():
            row["branch"] = _git(wt, "rev-parse", "--abbrev-ref", "HEAD")
            row["last_commit"] = _git(wt, "log", "-1", "--format=%h %cr - %s")
            changed = []
            for line in _git(wt, "status", "--porcelain", "--untracked-files=all").splitlines()[:400]:
                rel = line[3:].strip().strip('"')
                if rel.startswith("Godot/.godot") or rel.endswith(".import") or rel.endswith(".uid"):
                    continue
                full = Path(wt) / rel
                try:
                    mtime = full.stat().st_mtime
                except OSError:
                    mtime = 0.0
                changed.append((mtime, line[:2].strip() or "?", rel))
            changed.sort(reverse=True)
            row["changed"] = [{"status": st, "path": rel, "ago_s": int(_t.time() - mt) if mt else None}
                              for mt, st, rel in changed[:12]]
            row["changed_count"] = len(changed)
        tail = ""
        if row["task"]:
            for cand in ((Path(out_live) if out_live else None), ROOT / "AgentComms" / "prompts" / (row["task"] + "_out.txt"),
                         Path(wt) / "AgentComms" / "prompts" / (row["task"] + "_out.txt") if wt else None):
                if cand is not None and cand.is_file():
                    try:
                        text = cand.read_text(encoding="utf-8", errors="replace")
                        row["out_age_s"] = int(_t.time() - cand.stat().st_mtime)
                        tail = chr(10).join(text.splitlines()[-18:])
                    except OSError:
                        pass
                    break
        row["out_tail"] = tail
        row["out_live"] = out_live
        rows.append(row)
    ## S144: the run registry Claude writes at each launch (title in plain words, started, ETA, waiting queue).
    registry: dict[str, Any] = {}
    try:
        registry = json.loads((ROOT / "AgentComms" / "live_runs.json").read_text(encoding="utf-8"))
    except (OSError, ValueError):
        registry = {}
    runs = registry.get("runs", {}) if isinstance(registry.get("runs", {}), dict) else {}
    for row in rows:
        info = runs.get(row.get("task", ""), {})
        ## S222: "TECHSTAGE1_fix5b_out.txt" parsed to task "fix5b" and the row had no title/timer - match the registry key the
        ## output file NAME starts with (longest key wins), then the worktree folder name.
        if not info:
            out_name = Path(str(row.get("out_live", "") or "")).name.upper()
            wt_name = Path(str(row.get("worktree", "") or "")).name.upper()
            keys = sorted((k for k in runs if isinstance(k, str)), key=len, reverse=True)
            hit = next((k for k in keys if out_name.startswith(k.upper())), "") or next((k for k in keys if wt_name == k.upper()), "")
            if hit:
                row["task"] = hit
                info = runs.get(hit, {})
        if isinstance(info, dict):
            row["title"] = str(info.get("title", ""))
            row["started"] = str(info.get("started", ""))
            row["eta"] = str(info.get("eta", ""))
    ## S259: the nightly suite runs on GitHub runners - RUNNING NOW shows it from GitHub itself while it is queued or running.
    nightly = nightly_cloud_run()
    if nightly:
        runs = dict(runs)
        runs["NIGHTLY"] = nightly
    return {"at": datetime.now(timezone.utc).isoformat(timespec="seconds"), "agents": rows,
            "seats": int(registry.get("seats", 0) or 0), "runs": runs}


## S259 (operator saw two 'Godot (headless test)' processes at 05:30, "how is that possible" - the PC nightly was never on the
## board): the nightly is the workflow nightly-suite.yml now; its newest run, read live from GitHub (cached 60 s), is a
## live_runs-shaped row while queued/in progress. `started` is local time like every live_runs row (the page reads it as local).
_NIGHTLY_CACHE: dict[str, Any] = {"t": 0.0, "data": None}


def nightly_cloud_run() -> dict[str, Any] | None:
    import time as _t
    if _t.time() - float(_NIGHTLY_CACHE["t"]) < 60.0:
        return _NIGHTLY_CACHE["data"]
    rows = _gh_json("run", "list", "--workflow", "nightly-suite.yml", "--limit", "1", "--json",
                    "databaseId,status,conclusion,createdAt,url,displayTitle")
    row = None
    r = rows[0] if isinstance(rows, list) and rows else None
    if isinstance(r, dict) and r.get("status") != "completed":
        try:
            started = datetime.fromisoformat(str(r["createdAt"]).replace("Z", "+00:00")).astimezone()
            started_s, eta_s = started.strftime("%Y-%m-%d %H:%M"), (started + timedelta(minutes=60)).strftime("%Y-%m-%d %H:%M")
        except (KeyError, ValueError):
            started_s, eta_s = "", ""
        row = {"agent": "github", "where": "cloud", "status": "running" if r.get("status") == "in_progress" else "started - waiting for GitHub runners",
               "title": "Nightly full test suite on GitHub runners (16 shards) - result lands in AgentComms/nightly/latest.txt",
               "started": started_s, "eta": eta_s, "url": r.get("url", ""), "gh_run": str(r.get("databaseId", ""))}
    _NIGHTLY_CACHE.update({"t": _t.time(), "data": row})
    return row


def anim_catalogue() -> dict[str, Any]:
    sys.path.insert(0, str(ROOT / "Tools"))
    try:
        import importlib
        import lean_anim_catalogue as catalogue  # type: ignore  # S365: what the Lean game's fight plays (was the old repo's)
        importlib.reload(catalogue)
        return catalogue.build()
    finally:
        sys.path.pop(0)


def media_file(rel: str) -> Path | None:
    """A preview file under previews (or a sent file, "_sent/..."), or None (no traversal, known types only)."""
    import media_review
    MEDIA_TYPES.update(media_review.MEDIA_TYPES)
    if rel.startswith(media_review.SENT_PREFIX):
        return media_review.resolve(MEDIA_ROOT, rel)
    try:
        target = (MEDIA_ROOT / rel).resolve()
    except (OSError, ValueError):
        return None
    if MEDIA_ROOT not in target.parents or target.suffix.lower() not in MEDIA_TYPES or not target.is_file():
        return None
    return target


def _python_exe() -> str:
	"""The interpreter that runs `agent_comms.py`.

	Frozen, `sys.executable` is THIS exe, so passing it a script path makes the
	board re-invoke itself and argparse rejects the arguments - the board then
	renders zero rows with no obvious cause. Find a real interpreter instead.
	"""
	if not getattr(sys, "frozen", False):
		return sys.executable
	for name in ("python", "python3", "py"):
		found = shutil.which(name)
		if found:
			return found
	for guess in Path("C:/").glob("Python3*/python.exe"):
		return str(guess)
	return "python"


PYTHON = _python_exe()
ROSTER_PATH = ROOT / "AgentComms" / "roster.json"
QUESTIONS_PATH = ROOT / "AgentComms" / "questions.json"
## Operator ask 2026-09-15: "add on opsboard a trigger to run the Claude app in
## the pc". The board is a scheduled task with a five-minute self-healing
## trigger, so it is up when the desktop app is not - which makes it the one
## thing on this PC a phone can still reach once the app has crashed.
LAUNCH_PATH = ROOT / "AgentComms" / "launch_targets.json"
## What this SERVER is, as opposed to what the page is. The exe serves the
## checkout's index.html (R138) while its own code stays frozen, so the two
## drift apart by design and the board had no way to say so. The page prints
## both in its footer.
SERVER_BUILD = "2026-09-29 cli-agents"
ROADMAP_PATH = ROOT / "AgentComms" / "roadmap.json"

## OPERATOR 2026-10-02: "put those meters somewhere that you can watch them when you
## are assigning tasks ... and on the ops board. I do not want the temperature to go
## above 80". The PC Watchdog scheduled task rewrites pc_health.txt every minute; the
## board only parses it, so the board and `pc_watchdog.ps1 -Once` can never disagree.
PC_HEALTH_PATH = ROOT / "AgentComms" / "pc_health.txt"


def pc_health() -> dict:
    import re
    import time
    if not PC_HEALTH_PATH.is_file():
        return {"ok": False, "why": "no pc_health.txt - is the FightCamp PC Watchdog task running?"}
    text = PC_HEALTH_PATH.read_text(encoding="utf-8-sig", errors="replace")
    lines = [ln.rstrip() for ln in text.splitlines() if ln.strip()]
    head = lines[0] if lines else ""
    def num(key: str):
        m = re.search(key + r"=([0-9.]+)", head)
        return float(m.group(1)) if m else None
    state = re.search(r" (GREEN|AMBER|RED) ", head)
    top = head.split(" top: ", 1)[1] if " top: " in head else ""
    return {
        "ok": True,
        "state": state.group(1) if state else "?",
        "stamp": head[:19],
        "age_s": int(time.time() - PC_HEALTH_PATH.stat().st_mtime),
        "temp_c": num("TEMP"), "cpu_pct": num("CPU"), "ram_pct": num("RAM"), "c_free_gb": num("C_free"), "e_free_gb": num("E_free"),
        "temp_src": (re.search(r"TEMP=[0-9.]+C\(([^)]+)\)", head) or [None, ""])[1],
        "top": top,
        "problems": [ln.strip() for ln in lines[1:]],
    }


## OPERATOR S205: "i want the heat meter on opsboard to be in real time". pc_health.txt is rewritten once a minute;
## this reads LibreHardwareMonitor's own web server (the same sensor the watchdog uses) on every call - one local
## HTTP GET, no subprocess, so a 2 s poll costs nothing and flashes no window. Amber/red decisions stay the watchdog's.
## S227 (operator: "can you show in the board what is making the heat rising"): the processes burning CPU right now, each
## named in plain words - a Godot run says WHICH agent run (its worktree -> live_runs.json) or that it is Claude's own test on
## master. One hidden PowerShell read of the per-process CPU counter, cached 5 s (the page polls every 10 s).
_HEAT_CACHE: dict = {"t": 0.0, "data": None}
_HEAT_PS = (
    "$n=[Environment]::ProcessorCount;"
    "$p=Get-CimInstance Win32_PerfFormattedData_PerfProc_Process | Where-Object { $_.Name -ne '_Total' -and $_.Name -ne 'Idle' -and $_.PercentProcessorTime -gt 0 } | "
    "Sort-Object PercentProcessorTime -Descending | Select-Object -First 12;"
    "$c=@{}; Get-CimInstance Win32_Process | ForEach-Object { $c[[int]$_.ProcessId]=$_.CommandLine };"
    "$p | ForEach-Object { [pscustomobject]@{pid=[int]$_.IDProcess; name=$_.Name; cpu=[math]::Round($_.PercentProcessorTime/$n,1); mb=[math]::Round($_.WorkingSetPrivate/1MB,0); cmd=[string]$c[[int]$_.IDProcess]} } | ConvertTo-Json -Compress"
)


def _heat_label(name: str, cmd: str, worktrees: dict) -> str:
    low = (cmd or "").replace("\\", "/").lower()
    n = (name or "").lower()
    for wt, title in worktrees.items():
        if wt and wt.lower() in low:
            kind = "Godot test" if "godot" in n and "--headless" in low else ("Godot render" if "godot" in n else n)
            return "%s - %s" % (kind, title)
    if "godot" in n:
        if "/chatgpt/game/" in low or "onedrive/documents/chatgpt/game" in low:
            return "Godot (Claude, master checkout)%s" % (" test" if "--headless" in low else " render/still")
        return "Godot (%s)" % ("headless test" if "--headless" in low else "window")
    if n.startswith("codex"):
        return "Codex agent CLI"
    if n.startswith(("brave", "firefox", "chrome", "msedge")):
        return "Browser (%s)" % name
    if n.startswith("claude"):
        return "Claude app"
    if n.startswith("python") and "opsboard" in low:
        return "Ops board server"
    if n.startswith("powershell") and "perfproc" in low:
        return "Ops board heat read (this meter)"
    if n.startswith("powershell") and "pc_watchdog" in low:
        return "PC watchdog"
    if n.startswith("powershell") and "heat_governor" in low:
        return "Heat governor"
    friendly = {"onedrive": "OneDrive sync", "msmpeng": "Windows Defender scan", "wmiprvse": "Windows WMI (sensor reads)",
                "powershell": "PowerShell (watchdog / scripts)", "searchindexer": "Windows search indexing", "dwm": "Windows desktop",
                "librehardwaremonitor": "LibreHardwareMonitor", "node": "Node (agent CLI)", "cascadeur": "Cascadeur (animation)",
                "blender": "Blender"}
    for key, label in friendly.items():
        if n.startswith(key):
            return label
    return name.split("#")[0]


def pc_heat() -> dict:
    import time
    if time.time() - float(_HEAT_CACHE["t"]) < 14.0 and _HEAT_CACHE["data"] is not None:  # the read itself costs ~1 core-second
        return _HEAT_CACHE["data"]
    try:
        out = subprocess.run(["powershell", "-NoProfile", "-Command", _HEAT_PS], capture_output=True, text=True,
                             encoding="utf-8", errors="replace", timeout=25, creationflags=_NO_WINDOW).stdout
        rows = json.loads(out) if out.strip() else []
        rows = rows if isinstance(rows, list) else [rows]
    except Exception as exc:
        return {"ok": False, "why": "process read failed (%s)" % exc}
    worktrees: dict = {}
    try:
        runs = json.loads((ROOT / "AgentComms" / "live_runs.json").read_text(encoding="utf-8")).get("runs", {})
        for rid, r in runs.items():
            if isinstance(r, dict) and r.get("status") == "running" and r.get("worktree"):
                worktrees[str(r["worktree"]).replace("\\", "/").rstrip("/")] = "%s (%s)" % (rid, r.get("agent", ""))
    except Exception:
        pass
    top = []
    for r in rows:
        cpu = float(r.get("cpu") or 0.0)
        if cpu < 1.0:
            continue
        ## "cores": the share of the 16 threads as busy threads - 5.8% = 0.9 core = one core flat out at full boost, which is what
        ## drives this 7800X3D's Tctl into the 80s (operator S227: "how is that generating so much heat ?").
        what = _heat_label(str(r.get("name", "")), str(r.get("cmd", "")), worktrees)
        task = what.split(" - ", 1)[1] if " - " in what else ("Claude (this session)" if "Claude, master" in what else what)
        top.append({"pid": r.get("pid"), "name": r.get("name"), "cpu": cpu, "task": task, "cores": round(cpu * float(os.cpu_count() or 16) / 100.0, 1), "mb": r.get("mb"),
                    "what": _heat_label(str(r.get("name", "")), str(r.get("cmd", "")), worktrees)})
    data = {"ok": True, "at": time.strftime("%H:%M:%S"), "top": top[:8]}
    _HEAT_CACHE.update({"t": time.time(), "data": data})
    return data


## S227 (operator: "can you make a better real time graph with the cores and what they are running" / "show the flow from the task to
## core"): per-thread load (16), per-core power + effective clock (8) and the die temps from LibreHardwareMonitor, read live.
def pc_cores() -> dict:
    import time
    import urllib.request
    try:
        with urllib.request.urlopen("http://127.0.0.1:8085/data.json", timeout=2) as r:
            data = json.loads(r.read().decode("utf-8", errors="replace"))
    except Exception as exc:
        return {"ok": False, "why": "LibreHardwareMonitor not answering on 8085 (%s)" % exc}
    def val(text: str):
        m = re.search(r"([0-9]+(?:[.,][0-9]+)?)", text or "")
        return round(float(m.group(1).replace(",", ".")), 1) if m else None
    threads: dict = {}
    power: dict = {}
    eff: dict = {}
    out: dict = {"ok": True, "at": time.strftime("%H:%M:%S"), "tctl": None, "ccd": None, "package_w": None, "total": None}
    stack = [data]
    while stack:
        n = stack.pop()
        sid, t, v = str(n.get("SensorId", "")), str(n.get("Text", "")), n.get("Value", "")
        if sid.startswith("/amdcpu/") or sid.startswith("/intelcpu/"):
            m = re.match(r"CPU Core #(\d+)$", t)
            if "/load/" in sid and m:
                threads[int(m.group(1))] = val(v)
            elif "/load/" in sid and t == "CPU Total":
                out["total"] = val(v)
            elif "/power/" in sid:
                mc = re.match(r"Core #(\d+)", t)
                if mc:
                    power[int(mc.group(1))] = val(v)
                elif t.startswith("Package"):
                    out["package_w"] = val(v)
            elif "/clock/" in sid:
                mc = re.match(r"Core #(\d+) \(Effective\)", t)
                if mc:
                    eff[int(mc.group(1))] = val(v)
            elif "/temperature/" in sid:
                if "Tctl" in t:
                    out["tctl"] = val(v)
                elif "CCD" in t:
                    out["ccd"] = val(v)
        stack.extend(n.get("Children", []))
    out["threads"] = [threads[k] for k in sorted(threads)]
    out["cores"] = [{"core": k, "w": power.get(k), "eff_mhz": eff.get(k)} for k in sorted(set(power) | set(eff))]
    return out


def pc_live() -> dict:
    import time
    import urllib.request
    try:
        with urllib.request.urlopen("http://127.0.0.1:8085/data.json", timeout=2) as r:
            data = json.loads(r.read().decode("utf-8", errors="replace"))
    except Exception as exc:
        return {"ok": False, "why": "LibreHardwareMonitor not answering on 8085 (%s)" % exc}
    out: dict[str, Any] = {"ok": True, "temp_c": None, "cpu_pct": None, "at": time.strftime("%H:%M:%S")}
    def val(text: str):
        m = re.search(r"([0-9]+(?:[.,][0-9]+)?)", text or "")
        return round(float(m.group(1).replace(",", ".")), 1) if m else None
    stack = [data]
    while stack:
        n = stack.pop()
        t = n.get("Text", "")
        sid = str(n.get("SensorId", ""))
        ## S227 (operator: "there is 10C different on the live value between our board and this"): this Ryzen reports
        ## "Core (Tctl/Tdie)" AND "CCD1 (Tdie)" (~6-10 C cooler); the first match was CCD1. The watchdog gate (pc_watchdog.ps1
        ## Get-LhmTempC) and the Thermal Horizon board take the HOTTEST - so does this.
        if "/temperature/" in sid and re.search(r"Tctl|Tdie|CPU Package", t):
            v = val(n.get("Value", ""))
            if v is not None and (out["temp_c"] is None or v > out["temp_c"]):
                out["temp_c"] = v
        elif "/load/" in sid and t == "CPU Total":
            out["cpu_pct"] = val(n.get("Value", ""))
        stack.extend(n.get("Children", []))
    return out

HANDOFF = ROOT / "HANDOFF.md"
HANDOFF_ARCHIVE = ROOT / "HANDOFF_ARCHIVE.md"
RESEARCH = ROOT / "research"
DEFAULT_PORT = 8787
## Every agent the roster carries. `load_roster` / `save_roster` iterate THIS
## tuple and rebuild from `default_roster()`, so a name missing here is silently
## DROPPED from `roster.json` the next time a switch is flipped on the board -
## which is what happened when kalli/john/maria were first added to the file
## without being added here. Keep the two in step.
## kalli, john and maria are the Grok Bot agents (2026-09-10): no process to
## detect, same as grok, and reached through `Tools/grokbots/grokbots.py`.
## dola (2026-09-24, operator: "can you dola on the board too ?"): driven by
## Tools/cici/cici.py on port 9333, no process to detect, like the grokbots.
## kimi (2026-09-29, S122, operator: "i dont see kimi on opsboard"): Kimi Code CLI via Tools/kimi_task.ps1.
## Deliberately NOT in PROCESS_NAMES: the Kimi desktop app is also kimi.exe and would read as "working".
AGENTS = ("claude", "qwen", "grok", "codex", "cursor", "kalli", "john", "maria", "dola", "kimi")
## S124 (operator: "update opsboard so it shows grok it's a cli now"): grok and kimi are CLI agents whose desktop apps
## share the image name (Grok Desktop / Kimi.exe), so they are matched by the CLI's INSTALL PATH, never the name alone.
CLI_PATHS = {
    "grok": ("grok.exe", r"C:\Tools\grok\bin"),
    "kimi": ("kimi.exe", r"C:\Tools\kimi-code"),
    ## cursor-agent runs as node.exe from its own install dir - the image-name list never saw it (S124: the card said
    ## "no process" while U198 ran).
    "cursor": ("node.exe", str(Path.home() / "AppData" / "Local" / "cursor-agent")),
}
PROCESS_NAMES = {
    "qwen": ("qwen", "qwen.exe"),
    "codex": ("codex", "codex.exe", "codex.cmd"),
    "cursor": ("cursor-agent", "cursor-agent.exe", "Cursor Agent", "cursor.exe"),
}
_SNAPSHOT_CACHE: dict[str, Any] = {"at": 0.0, "data": None}
SNAPSHOT_DISK = ROOT / "AgentComms" / ".opsboard_snapshot.json"
## A 4-SECOND CACHE ON A 32-SECOND COMPUTATION IS NOT A CACHE.
##
## `collect_snapshot` shells out to `agent_comms.py board` (17 s on this repo)
## and `triage --no-fetch` (7 s), and the whole call measures 31-33 s. With the
## TTL at 4.0 every entry was already stale before it was written, so the page -
## which polls every 5 s - rebuilt the snapshot from scratch on EVERY request
## and got an answer so late it never painted. That is what put a dash in
## SUITE STATUS, ROADMAP, SESSIONS and every other panel on 2026-09-21 while
## `/api/launch` beside them answered instantly.
##
## The TTL has to be longer than the build, not shorter. 60 s is well clear of
## the 33 s worst case and is far finer than anything on this board moves: who
## is working, what shipped and the suite count do not change second to second.
## S144 (2026-10-02): 60 s became a HEAT SOURCE. With agents running `board` takes 51-90 s (S143), so a
## 60 s TTL rebuilt back to back and held one core at 100% for as long as the page was open - measured: the
## triage child at 100% of a core, Tctl 80-82 C at 6-20% total CPU (operator limit 80 C). 300 s: the panels
## lag at most 5 min; the PC meters (/api/pc) do not use this snapshot and stay live.
_SNAPSHOT_TTL_S = 300.0
BOARD_ROW_RE = re.compile(
    r"^(?P<id>[A-Z]{1,2}\d+[A-Z]?)\s+(?P<agent>\w+)\s+(?P<status>\S+)\s+"
    r"(?P<gate>\S*)\s+(?P<title>.+)$"
)
UNREAD_RE = re.compile(r"UNREAD:\s*(.+)$", re.M)
SUITE_RE = re.compile(r"SUITE\s+total=(?P<total>\d+)\s+fails=(?P<fails>\d+)")
COMPLETE_HDR_RE = re.compile(
    r"^###\s+(?P<label>[A-Z]+)\s+-\s+(?P<id>[A-Z]\d+[A-Z]?):\s+"
    r"(?P<title>.+?)\s*\(COMPLETE(?:\??)\s+(?P<when>[^,)]+)(?:,\s*`(?P<hash>[0-9a-f]+)`)?\)\s*$",
    re.M,
)
ASSIGNED_RE = re.compile(r"Assigned\s+(\d{4}-\d{2}-\d{2})", re.I)
TOKENS_USED_RE = re.compile(r"tokens\s+used[:\s]+([0-9][0-9,]*)", re.I)
ISO_Z_RE = re.compile(r"^\d{4}-\d{2}-\d{2}T")


def utc_now() -> datetime:
    return datetime.now(timezone.utc)


def to_iso(dt: datetime | None) -> str | None:
    if dt is None:
        return None
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=timezone.utc)
    return dt.astimezone(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def parse_isoish(value: str | None) -> datetime | None:
    if not value:
        return None
    text = value.strip()
    try:
        if text.endswith("Z"):
            return datetime.fromisoformat(text.replace("Z", "+00:00"))
        if "T" in text:
            dt = datetime.fromisoformat(text)
            if dt.tzinfo is None:
                dt = dt.replace(tzinfo=timezone.utc)
            return dt
        if re.match(r"^\d{4}-\d{2}-\d{2}$", text):
            return datetime.fromisoformat(text + "T00:00:00+00:00")
    except ValueError:
        return None
    return None


## S143: `subprocess.run(timeout=)` kills only the CHILD on Windows; a grandchild it spawned (git, inside
## `agent_comms.py triage`) keeps the pipes open, so the post-kill `communicate()` never returned. The snapshot
## rebuild thread hung inside it with the refresh lock held - the board served one 13:06 snapshot for 45+ min
## (faulthandler trace: server.py collect_snapshot -> run_cmd -> communicate). Kill the whole tree, then read
## what is left with a bounded wait.
def run_cmd(args: list[str], cwd: Path | None = None, timeout: int = 60) -> tuple[int, str, str]:
    try:
        proc = subprocess.Popen(
            args,
            cwd=str(cwd or ROOT),
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            encoding="utf-8",
            errors="replace",
            shell=False,
        )
    except FileNotFoundError as exc:
        return 127, "", str(exc)
    try:
        out, err = proc.communicate(timeout=timeout)
        return proc.returncode, out or "", err or ""
    except subprocess.TimeoutExpired:
        if os.name == "nt":
            subprocess.run(["taskkill", "/T", "/F", "/PID", str(proc.pid)],
                           capture_output=True, timeout=30)
        else:
            proc.kill()
        try:
            proc.communicate(timeout=10)
        except subprocess.TimeoutExpired:
            pass
        return 124, "", "timeout"


## ---------------------------------------------------------------------
## LAUNCHING SOMETHING ON THIS PC
##
## The resolver and the launcher live in `Tools/launch_target.py`, imported
## rather than copied: this project has already lost a day to a whitelist copy
## that silently dropped a key (`FightClipBinding.metadata_for` and
## `native_speed_mps`), and `agent_comms.py` needs the same answers.
##
## THE REQUEST NEVER CARRIES A PATH OR A COMMAND - see that module's header.

try:
    sys.path.insert(0, str(ROOT / "Tools"))
    import launch_target as _launch
except Exception:  # a board that cannot import this still serves everything else
    _launch = None


def load_launch_targets() -> list[dict[str, Any]]:
    return [] if _launch is None else _launch.load_targets(ROOT)


def resolve_launch_target(target: dict[str, Any]) -> dict[str, Any]:
    return {} if _launch is None else _launch.resolve(target)


def launch_target(target_id: str) -> dict[str, Any]:
    if _launch is None:
        return {"ok": False, "id": target_id,
                "error": "Tools/launch_target.py could not be imported from this checkout"}
    return _launch.launch(ROOT, target_id)


def lan_ip() -> str:
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        sock.connect(("8.8.8.8", 80))
        return sock.getsockname()[0]
    except OSError:
        try:
            return socket.gethostbyname(socket.gethostname())
        except OSError:
            return "127.0.0.1"
    finally:
        sock.close()


def default_roster() -> dict[str, Any]:
    now = to_iso(utc_now())
    return {
        name: {"in_rotation": True, "note": "", "changed": now}
        for name in AGENTS
    }


NOTE_MAX = 4000  # a roster note holds an agent's launch line and its history; 200 amputated it


def load_roster() -> dict[str, Any]:
    if not ROSTER_PATH.is_file():
        data = default_roster()
        ROSTER_PATH.parent.mkdir(parents=True, exist_ok=True)
        ROSTER_PATH.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
        return data
    raw = json.loads(ROSTER_PATH.read_text(encoding="utf-8"))
    out = default_roster()
    if isinstance(raw, dict):
        for name in AGENTS:
            row = raw.get(name)
            if isinstance(row, dict):
                out[name] = {
                    "in_rotation": bool(row.get("in_rotation", True)),
                    "note": str(row.get("note", "") or ""),
                    "changed": str(row.get("changed") or out[name]["changed"]),
                }
    return out


def load_roadmap() -> dict[str, Any]:
    """Read AgentComms/roadmap.json. Never invent content when it fails.

    The board renders whatever this returns. A missing or broken file must not
    take down the rest of the page — callers get ok=False and an error string.
    """
    if not ROADMAP_PATH.is_file():
        return {
            "ok": False,
            "error": "AgentComms/roadmap.json is missing",
            "data": None,
            "source": "AgentComms/roadmap.json",
        }
    try:
        raw = json.loads(ROADMAP_PATH.read_text(encoding="utf-8"))
    except (OSError, UnicodeDecodeError) as exc:
        return {
            "ok": False,
            "error": f"could not read AgentComms/roadmap.json: {exc}",
            "data": None,
            "source": "AgentComms/roadmap.json",
        }
    except json.JSONDecodeError as exc:
        return {
            "ok": False,
            "error": f"AgentComms/roadmap.json is unparseable: {exc}",
            "data": None,
            "source": "AgentComms/roadmap.json",
        }
    if not isinstance(raw, dict):
        return {
            "ok": False,
            "error": "AgentComms/roadmap.json root must be an object",
            "data": None,
            "source": "AgentComms/roadmap.json",
        }
    return {
        "ok": True,
        "error": None,
        "data": raw,
        "source": "AgentComms/roadmap.json",
    }


def _patch_now_with_roster(cached: dict[str, Any], roster: dict[str, Any]) -> None:
    ## S142: `cached["now"]` (build_now()'s rows) bakes in_rotation/roster_note/
    ## roster_changed/idle_failure in at the time of the last FULL rebuild - a
    ## separate copy of what `roster` holds. Patching `roster` alone (S120) left
    ## this array stale until `_rebuild_snapshot_async()` finishes (17-32 s), so a
    ## toggle - or a roster.json edit outside the board - looked reverted on the
    ## very next page refresh. Call this wherever `cached["roster"]` is patched.
    now_rows = cached.get("now")
    if not isinstance(now_rows, list):
        return
    for row in now_rows:
        if not isinstance(row, dict):
            continue
        agent = row.get("agent")
        entry = roster.get(agent) if isinstance(agent, str) else None
        if not isinstance(entry, dict):
            continue
        row["in_rotation"] = bool(entry.get("in_rotation", True))
        row["roster_note"] = entry.get("note", "")
        row["roster_changed"] = entry.get("changed")
        row["idle_failure"] = (not row.get("open_tasks")) and row["in_rotation"]


def save_roster(data: dict[str, Any]) -> dict[str, Any]:
    cleaned = default_roster()
    for name in AGENTS:
        row = data.get(name) if isinstance(data, dict) else None
        if isinstance(row, dict):
            cleaned[name] = {
                "in_rotation": bool(row.get("in_rotation", True)),
                # NEVER truncate here (2026-09-13): this rewrites EVERY agent, so a
                # cap on save cut all the long handover notes the moment one switch
                # was flipped. Only a note TYPED on the phone is capped (POST handler).
                "note": str(row.get("note", "") or ""),
                "changed": str(row.get("changed") or to_iso(utc_now())),
            }
    ROSTER_PATH.parent.mkdir(parents=True, exist_ok=True)
    ROSTER_PATH.write_text(json.dumps(cleaned, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    ## S120: NEVER null the cache here. Nulling it made the page's refresh after a
    ## toggle wait out the whole 80 s cold build, so the operator's click on Codex
    ## "did nothing". Patch the roster into the served snapshot and rebuild behind.
    ##
    ## S142: patching `roster` alone was not enough. The toggle cards render from
    ## `cached["now"]` (built_now()'s rows), which bakes in_rotation/roster_note/
    ## roster_changed/idle_failure in at the LAST FULL REBUILD - a separate copy
    ## that `_rebuild_snapshot_async()` only refreshes in the background, 17-32 s
    ## later. The page's own `refresh()` call right after the toggle re-rendered
    ## the cards from that still-stale `now` array immediately, so the button
    ## flipped once (the click handler's own optimistic class toggle) and then
    ## reverted a moment later - looking exactly like "the toggle does nothing"
    ## (operator, 2026-10-02). Patch `now` in the same place, same way.
    cached = _SNAPSHOT_CACHE.get("data")
    if isinstance(cached, dict):
        cached["roster"] = cleaned
        _patch_now_with_roster(cached, cleaned)
    _SNAPSHOT_CACHE["at"] = 0.0
    _rebuild_snapshot_async()
    return cleaned


def _atomic_json(path: Path, data: Any) -> None:
	path.parent.mkdir(parents=True, exist_ok=True)
	fd, temp_name = tempfile.mkstemp(prefix=path.name + ".", suffix=".tmp", dir=str(path.parent))
	try:
		with os.fdopen(fd, "w", encoding="utf-8", newline="\n") as stream:
			json.dump(data, stream, indent=2, ensure_ascii=False)
			stream.write("\n")
		os.replace(temp_name, path)
	except BaseException:
		try:
			os.unlink(temp_name)
		except OSError:
			pass
		raise


## S231 operator: "also add duration on tasks, running pids on board". The work processes on this PC (Godot, Python
## tools/tests, agent CLIs, node), each with PID, how long it has run and its CPU seconds. One hidden PowerShell read,
## cached 15 s so a refreshing page never spawns more than four reads a minute.
_PROCS_CACHE: dict[str, Any] = {"at": 0.0, "rows": []}
_PROC_NAMES = ("Godot%", "python%", "node%", "codex%", "qwen%", "cursor-agent%", "goose%", "gh.exe", "blender%", "Cascadeur%")


def _work_processes() -> dict[str, Any]:
    import time
    now = time.time()
    if now - float(_PROCS_CACHE["at"]) < 15.0:
        return {"rows": _PROCS_CACHE["rows"], "cached": True}
    where = " or ".join("Name like '%s'" % n for n in _PROC_NAMES)
    script = ('Get-CimInstance Win32_Process -Filter "%s" | ForEach-Object { $c=[string]$_.CommandLine; '
              "[pscustomobject]@{pid=$_.ProcessId; name=$_.Name; started=$(if($_.CreationDate){$_.CreationDate.ToString('yyyy-MM-dd HH:mm:ss')}else{''}); "
              "cpu=[math]::Round(($_.UserModeTime+$_.KernelModeTime)/1e7,0); mem_mb=[math]::Round($_.WorkingSetSize/1MB,0); "
              "cmd=$c.Substring(0,[math]::Min(220,$c.Length))} } | ConvertTo-Json -Compress") % where
    rows: list[dict[str, Any]] = []
    try:
        out = subprocess.run(["powershell", "-NoProfile", "-NonInteractive", "-Command", script], capture_output=True, text=True,
                             timeout=25, creationflags=0x08000000 if os.name == "nt" else 0).stdout.strip()
        data = json.loads(out) if out else []
        rows = data if isinstance(data, list) else [data]
    except (subprocess.SubprocessError, OSError, ValueError):
        rows = []
    me = os.getpid()
    rows = [r for r in rows if int(r.get("pid", 0)) != me]
    rows.sort(key=lambda r: str(r.get("started", "")))
    _PROCS_CACHE.update(at=now, rows=rows)
    return {"rows": rows, "cached": False}


def _load_questions() -> dict[str, Any]:
	try:
		data = json.loads(QUESTIONS_PATH.read_text(encoding="utf-8"))
	except (OSError, UnicodeDecodeError, json.JSONDecodeError):
		return {"questions": []}
	return data if isinstance(data, dict) else {"questions": []}


def parse_board(text: str) -> dict[str, Any]:
    rows: list[dict[str, str]] = []
    for line in text.splitlines():
        if line.startswith("TASK ") or line.startswith("UNREAD:") or line.startswith("STRANDED") or line.startswith("WARNING"):
            continue
        m = BOARD_ROW_RE.match(line.strip())
        if not m:
            continue
        rows.append({
            "id": m.group("id"),
            "agent": m.group("agent").lower(),
            "status": m.group("status"),
            "gate": "" if m.group("gate") in ("", "-") else m.group("gate"),
            "title": m.group("title").strip(),
        })
    unread: dict[str, int] = {}
    um = UNREAD_RE.search(text)
    if um:
        for part in um.group(1).split(","):
            part = part.strip()
            if "=" not in part:
                continue
            name, count = part.split("=", 1)
            try:
                unread[name.strip().lower()] = int(count.strip())
            except ValueError:
                continue
    warnings = [ln.strip() for ln in text.splitlines() if ln.startswith("WARNING")]
    return {"rows": rows, "unread": unread, "warnings": warnings, "raw_lines": len(text.splitlines())}


def parse_triage(text: str) -> dict[str, Any]:
    sections = {
        "unmerged_branches": [],
        "orphan_digests": [],
        "ungateable": [],
        "blockers": [],
        "findings": 0,
    }
    current = None
    for line in text.splitlines():
        if line.startswith("== unmerged"):
            current = "unmerged_branches"
            continue
        if line.startswith("== digests"):
            current = "orphan_digests"
            continue
        if line.startswith("== open tasks whose gate"):
            current = "ungateable"
            continue
        if line.startswith("== open blockers"):
            current = "blockers"
            continue
        if line.startswith("TRIAGE "):
            m = re.search(r"TRIAGE\s+(\d+)", line)
            if m:
                sections["findings"] = int(m.group(1))
            continue
        if current is None:
            continue
        stripped = line.strip()
        if not stripped or stripped == "none":
            continue
        if stripped.startswith("`done"):
            continue
        if current == "unmerged_branches":
            if stripped.startswith("BRANCH-ONLY"):
                if sections["unmerged_branches"]:
                    sections["unmerged_branches"][-1]["mail"] = stripped
            elif stripped.startswith("origin/") or stripped.startswith("  origin/"):
                sections["unmerged_branches"].append({"line": stripped.lstrip(), "mail": ""})
            else:
                sections["unmerged_branches"].append({"line": stripped, "mail": ""})
        elif current == "orphan_digests":
            for tok in re.split(r"[,\s]+", stripped):
                if tok:
                    sections["orphan_digests"].append(tok)
        elif current == "ungateable":
            for tok in re.split(r"[,\s]+", stripped):
                if tok and not tok.startswith("`"):
                    sections["ungateable"].append(tok)
        elif current == "blockers":
            sections["blockers"].append(stripped)
    return sections


def cli_pids(image: str, install_dir: str) -> list[str]:
    """PIDs of `image` whose executable lives under `install_dir` (one PowerShell call; [] on any failure)."""
    ps = ("Get-CimInstance Win32_Process -Filter \"Name='%s'\" | Where-Object { $_.ExecutablePath -and "
          "$_.ExecutablePath.ToLower().StartsWith('%s') } | ForEach-Object { $_.ProcessId }") % (image, install_dir.lower())
    rc, stdout, _ = run_cmd(["powershell", "-NoProfile", "-Command", ps], timeout=20)
    if rc != 0:
        return []
    return [line.strip() for line in stdout.splitlines() if line.strip().isdigit()]


def running_processes() -> dict[str, Any]:
    """Best-effort process check. CLI agents (grok, kimi) are matched by install path."""
    out: dict[str, Any] = {}
    rc, stdout, _ = run_cmd(["tasklist", "/FO", "CSV", "/NH"], timeout=20)
    blob = stdout.lower() if rc == 0 else ""
    for agent in AGENTS:
        if agent in CLI_PATHS:
            image, install_dir = CLI_PATHS[agent]
            cli = cli_pids(image, install_dir)
            out[agent] = {
                "running": bool(cli),
                "detectable": True,
                "kind": "cli",
                "label": "CLI running" if cli else "CLI idle",
                "pids": cli,
                "started_at": None,
            }
            continue
        if agent == "claude":
            # Claude Code / Claude sessions are not a single named process we own.
            # Detect claude.exe / Claude if present; otherwise report undetectable shell session.
            names = ("claude.exe", "claude")
        else:
            names = PROCESS_NAMES.get(agent, ())
        pids: list[str] = []
        if blob:
            for line in stdout.splitlines():
                low = line.lower()
                if any(n.lower() in low for n in names):
                    # CSV: "name","pid","session","session#","mem"
                    parts = [p.strip().strip('"') for p in line.split(",")]
                    if len(parts) >= 2 and parts[1].isdigit():
                        pids.append(parts[1])
        out[agent] = {
            "running": bool(pids),
            "detectable": True,
            "label": "running" if pids else "not running",
            "pids": pids,
            "started_at": None,
        }
    return out


def task_file_path(task_id: str) -> Path:
    return RESEARCH / f"TASK_{task_id}.md"


def task_assigned_at(task_id: str) -> datetime | None:
    path = task_file_path(task_id)
    if not path.is_file():
        return None
    text = path.read_text(encoding="utf-8", errors="replace")
    m = ASSIGNED_RE.search(text)
    if m:
        return parse_isoish(m.group(1))
    # Fall back to file birth/mtime — exact when available, else dash later.
    try:
        st = path.stat()
        ts = getattr(st, "st_ctime", None) or st.st_mtime
        return datetime.fromtimestamp(ts, tz=timezone.utc)
    except OSError:
        return None


def assignment_mail_at(task_id: str, agent: str) -> datetime | None:
    messages = ROOT / "AgentComms" / "messages"
    if not messages.is_dir():
        return None
    needle = f"_{agent}_"
    best: datetime | None = None
    for path in messages.glob(f"*_{task_id.lower()}-assigned_*.json"):
        name = path.name
        if needle not in name and f"to_{agent}_" not in name:
            # still accept any *-assigned* for this task
            pass
        stamp = name.split("_", 1)[0]
        try:
            dt = datetime.strptime(stamp, "%Y%m%dT%H%M%SZ").replace(tzinfo=timezone.utc)
        except ValueError:
            continue
        if best is None or dt < best:
            best = dt
    # Broader search if none matched the exact pattern
    if best is None:
        for path in messages.glob("*.json"):
            if f"_{task_id.lower()}-assigned_" not in path.name.lower() and f"_{task_id.lower()}_assigned_" not in path.name.lower():
                if f"-{task_id.lower()}-assigned" not in path.name.lower():
                    continue
            stamp = path.name.split("_", 1)[0]
            try:
                dt = datetime.strptime(stamp, "%Y%m%dT%H%M%SZ").replace(tzinfo=timezone.utc)
            except ValueError:
                continue
            if best is None or dt < best:
                best = dt
    return best


def git_log_lines(fmt: str, *extra: str, max_count: int = 400) -> list[str]:
    args = ["git", "log", f"--format={fmt}", f"-n{max_count}", *extra]
    rc, stdout, _ = run_cmd(args, timeout=45)
    if rc != 0:
        return []
    return [ln for ln in stdout.splitlines() if ln.strip()]


def commits_for_task(task_id: str) -> list[dict[str, Any]]:
    """Commits whose subject or body mentions the task id."""
    rc, stdout, _ = run_cmd(
        ["git", "log", "--format=%H|%cI|%s", f"--grep={task_id}", "-n", "40", "--regexp-ignore-case"],
        timeout=45,
    )
    commits: list[dict[str, Any]] = []
    if rc == 0:
        for line in stdout.splitlines():
            parts = line.split("|", 2)
            if len(parts) < 3:
                continue
            commits.append({"hash": parts[0], "when": parts[1], "subject": parts[2]})
    return commits


def numstat_for_commit(commit: str) -> dict[str, int]:
    rc, stdout, _ = run_cmd(["git", "show", "--numstat", "--format=", commit], timeout=30)
    files = 0
    added = 0
    deleted = 0
    if rc == 0:
        for line in stdout.splitlines():
            parts = line.split("\t")
            if len(parts) < 3:
                continue
            files += 1
            if parts[0].isdigit():
                added += int(parts[0])
            if parts[1].isdigit():
                deleted += int(parts[1])
    return {"files": files, "added": added, "deleted": deleted}


def tests_added_in_commit(commit: str) -> int:
    rc, stdout, _ = run_cmd(["git", "show", "--name-only", "--format=", commit], timeout=30)
    if rc != 0:
        return 0
    n = 0
    for line in stdout.splitlines():
        p = line.strip().replace("\\", "/")
        if "/tests/" in p and p.endswith(".gd"):
            # count only additions: check status
            n += 1
    # Prefer --diff-filter=A
    rc2, stdout2, _ = run_cmd(
        ["git", "show", "--name-only", "--diff-filter=A", "--format=", commit],
        timeout=30,
    )
    if rc2 == 0:
        n = 0
        for line in stdout2.splitlines():
            p = line.strip().replace("\\", "/")
            if "/tests/" in p and p.endswith(".gd"):
                n += 1
    return n


def parse_complete_blocks(text: str) -> list[dict[str, Any]]:
    items: list[dict[str, Any]] = []
    for m in COMPLETE_HDR_RE.finditer(text):
        agent = m.group("label").lower()
        # Map labels like CURSOR/QWEN/CODEX/CLAUDE/GROK
        if agent not in AGENTS:
            # john/kalli/maria etc. — keep but filter later
            pass
        items.append({
            "agent": agent,
            "id": m.group("id"),
            "title": m.group("title").strip(),
            "when_text": m.group("when").strip(),
            "hash": (m.group("hash") or "").strip() or None,
        })
    return items


def digest_suite(task_id: str) -> dict[str, Any] | None:
    path = RESEARCH / f"{task_id}_DIGEST.md"
    if not path.is_file():
        return None
    text = path.read_text(encoding="utf-8", errors="replace")
    m = SUITE_RE.search(text)
    if not m:
        return None
    return {
        "total": int(m.group("total")),
        "fails": int(m.group("fails")),
        "source": path.relative_to(ROOT).as_posix(),
    }


def latest_suite_status() -> dict[str, Any]:
    """The last real run, from AgentComms/last_suite.json, which
    run_tests.py writes on every run. Falls back to grepping digests for a
    SUITE line - which is what this used to do exclusively, and why the
    headline number sat two days stale: it was only ever as fresh as the
    last digest somebody wrote, and it never said which tree was tested."""
    live = ROOT / "AgentComms" / "last_suite.json"
    if live.is_file():
        try:
            row = json.loads(live.read_text(encoding="utf-8"))
            where = row.get("branch") or "?"
            if row.get("dirty"):
                where += " (uncommitted changes)"
            return {
                "total": int(row.get("total", 0)),
                "fails": int(row.get("fails", 0)),
                "when": row.get("when"),
                "source": "%s @ %s" % (where, row.get("commit") or "?"),
            }
        except (OSError, ValueError, TypeError):
            pass  # fall through to the digest scan
    best: dict[str, Any] | None = None
    best_mtime = -1.0
    if RESEARCH.is_dir():
        for path in RESEARCH.glob("*_DIGEST.md"):
            try:
                text = path.read_text(encoding="utf-8", errors="replace")
            except OSError:
                continue
            m = SUITE_RE.search(text)
            if not m:
                continue
            mtime = path.stat().st_mtime
            if mtime >= best_mtime:
                best_mtime = mtime
                best = {
                    "total": int(m.group("total")),
                    "fails": int(m.group("fails")),
                    "when": to_iso(datetime.fromtimestamp(mtime, tz=timezone.utc)),
                    "source": path.relative_to(ROOT).as_posix(),
                }
    # Prefer HANDOFF mentions only if newer than digests? Use git log of digests instead.
    # Also scan recent AgentComms done mail — often carries the live suite line.
    messages = ROOT / "AgentComms" / "messages"
    if messages.is_dir():
        for path in sorted(messages.glob("*.json"), key=lambda p: p.name, reverse=True)[:80]:
            try:
                payload = json.loads(path.read_text(encoding="utf-8"))
            except (OSError, json.JSONDecodeError):
                continue
            body = str(payload.get("body", ""))
            m = SUITE_RE.search(body)
            if not m:
                continue
            stamp = path.name.split("_", 1)[0]
            try:
                when_dt = datetime.strptime(stamp, "%Y%m%dT%H%M%SZ").replace(tzinfo=timezone.utc)
            except ValueError:
                when_dt = datetime.fromtimestamp(path.stat().st_mtime, tz=timezone.utc)
            if best is None or (when_dt.timestamp() >= best_mtime):
                best = {
                    "total": int(m.group("total")),
                    "fails": int(m.group("fails")),
                    "when": to_iso(when_dt),
                    "source": path.relative_to(ROOT).as_posix(),
                }
                best_mtime = when_dt.timestamp()
            break  # newest mail with a suite line is enough once sorted
    if best is None:
        return {"total": None, "fails": None, "when": None, "source": None, "ok": False}
    best["ok"] = True
    return best


def parse_codex_tokens() -> dict[str, Any]:
    """Measured Codex usage only. Prefer literal 'tokens used'; else session total_tokens."""
    home = Path.home() / ".codex"
    candidates: list[Path] = []
    sessions = home / "sessions"
    archived = home / "archived_sessions"
    if sessions.is_dir():
        candidates.extend(p for p in sessions.rglob("*.jsonl") if p.is_file())
    if archived.is_dir():
        candidates.extend(p for p in archived.glob("*.jsonl") if p.is_file())
    candidates.sort(key=lambda p: p.stat().st_mtime, reverse=True)
    candidates = candidates[:12]

    hits: list[dict[str, Any]] = []
    for path in candidates:
        try:
            if path.stat().st_size > 8_000_000:
                continue
            text = path.read_text(encoding="utf-8", errors="ignore")
        except OSError:
            continue
        for m in TOKENS_USED_RE.finditer(text):
            try:
                n = int(m.group(1).replace(",", ""))
            except ValueError:
                continue
            hits.append({
                "tokens": n,
                "source": str(path),
                "kind": "tokens_used_line",
                "mtime": path.stat().st_mtime,
            })
        if "total_tokens" in text:
            last = None
            for line in text.splitlines():
                if "total_tokens" not in line:
                    continue
                try:
                    obj = json.loads(line)
                except json.JSONDecodeError:
                    continue
                usage = (
                    obj.get("payload", {})
                    .get("info", {})
                    .get("total_token_usage", {})
                )
                if isinstance(usage, dict) and "total_tokens" in usage:
                    last = int(usage["total_tokens"])
            if last is not None:
                hits.append({
                    "tokens": last,
                    "source": str(path),
                    "kind": "session_total_tokens",
                    "mtime": path.stat().st_mtime,
                })
        if hits:
            break  # newest session with a measurable total is enough
    hits.sort(key=lambda h: h["mtime"], reverse=True)
    if not hits:
        return {
            "available": False,
            "tokens": None,
            "source": None,
            "note": "no Codex run log with a measurable token total found",
        }
    top = hits[0]
    return {
        "available": True,
        "tokens": top["tokens"],
        "source": top["source"],
        "kind": top["kind"],
        "sessions_parsed": len(hits),
        "note": "Codex measured from run logs; other agents remain UNKNOWN",
    }


def history_for_agents(limit_per_agent: int = 8) -> dict[str, list[dict[str, Any]]]:
    texts: list[str] = []
    if HANDOFF.is_file():
        texts.append(HANDOFF.read_text(encoding="utf-8", errors="replace"))
    if HANDOFF_ARCHIVE.is_file():
        try:
            data = HANDOFF_ARCHIVE.read_bytes()
            if len(data) > 750_000:
                data = data[-750_000:]
            texts.append(data.decode("utf-8", errors="replace"))
        except OSError:
            pass
    blocks: list[dict[str, Any]] = []
    for text in texts:
        blocks.extend(parse_complete_blocks(text))

    by_agent: dict[str, list[dict[str, Any]]] = {a: [] for a in AGENTS}
    seen: set[str] = set()
    # Pre-sort by declared when_text so we only git-query recent rows.
    def _block_key(b: dict[str, Any]) -> str:
        return b.get("when_text") or ""

    for block in sorted(blocks, key=_block_key, reverse=True):
        agent = block["agent"]
        if agent not in AGENTS:
            continue
        tid = block["id"]
        key = f"{agent}:{tid}"
        if key in seen:
            continue
        if len(by_agent[agent]) >= limit_per_agent:
            continue
        seen.add(key)
        commits = commits_for_task(tid)
        first = commits[-1] if commits else None
        last = commits[0] if commits else None
        duration_s = None
        landed_hash = block.get("hash") or (last["hash"][:7] if last else None)
        if first and last:
            t0 = parse_isoish(first["when"])
            t1 = parse_isoish(last["when"])
            if t0 and t1 and t1 >= t0:
                duration_s = int((t1 - t0).total_seconds())
        if commits and duration_s is None and first:
            duration_s = 0
        usage = None
        # numstat is expensive — only for the newest two finished tasks per agent
        if last and len(by_agent[agent]) < 2:
            usage = numstat_for_commit(last["hash"])
            usage["tests_added"] = tests_added_in_commit(last["hash"])
        suite = digest_suite(tid)
        assigned = assignment_mail_at(tid, agent) or task_assigned_at(tid)
        turnaround_s = None
        if assigned and first:
            t_first = parse_isoish(first["when"])
            if t_first and t_first >= assigned:
                turnaround_s = int((t_first - assigned).total_seconds())
        landed_at = None
        if last:
            landed_at = last["when"]
        elif block.get("when_text"):
            landed_at = to_iso(parse_isoish(block["when_text"]))
        by_agent[agent].append({
            "id": tid,
            "title": block["title"],
            "commit": landed_hash,
            "landed_at": landed_at,
            "duration_s": duration_s,
            "turnaround_s": turnaround_s,
            "commits": len(commits),
            "usage": usage,
            "suite": suite,
            "cost": "UNKNOWN" if agent != "codex" else None,
        })

    for agent in AGENTS:
        by_agent[agent].sort(key=lambda r: r.get("landed_at") or "", reverse=True)
        by_agent[agent] = by_agent[agent][:limit_per_agent]
    return by_agent


def agent_stats(history: list[dict[str, Any]], idle_from: datetime | None) -> dict[str, Any]:
    durations = [h["duration_s"] for h in history if isinstance(h.get("duration_s"), int)]
    median = int(statistics.median(durations)) if durations else None
    longest = max(durations) if durations else None
    idle_s = None
    if idle_from is not None:
        idle_s = max(0, int((utc_now() - idle_from).total_seconds()))
    return {
        "task_count": len(history),
        "median_duration_s": median,
        "longest_duration_s": longest,
        "idle_s": idle_s,
        "last_landed_at": history[0]["landed_at"] if history else None,
    }


def build_now(board: dict[str, Any], procs: dict[str, Any], roster: dict[str, Any],
              history: dict[str, list[dict[str, Any]]], codex_tokens: dict[str, Any]) -> list[dict[str, Any]]:
    open_by_agent: dict[str, list[dict[str, str]]] = {a: [] for a in AGENTS}
    for row in board["rows"]:
        if row["status"] not in {"OPEN", "BLOCKED", "IN PROGRESS"}:
            # Still surface COMPLETE? as attention elsewhere; NOW only open work
            if row["status"] != "OPEN" and not row["status"].startswith("OPEN"):
                continue
        if row["agent"] in open_by_agent:
            open_by_agent[row["agent"]].append(row)

    now_rows: list[dict[str, Any]] = []
    for agent in AGENTS:
        tasks = open_by_agent.get(agent, [])
        primary = tasks[0] if tasks else None
        assigned_at = None
        elapsed_s = None
        if primary:
            assigned_at = assignment_mail_at(primary["id"], agent) or task_assigned_at(primary["id"])
            if assigned_at:
                elapsed_s = max(0, int((utc_now() - assigned_at).total_seconds()))
        proc = procs.get(agent, {})
        hist = history.get(agent, [])
        last_landed = parse_isoish(hist[0]["landed_at"]) if hist and hist[0].get("landed_at") else None
        stats = agent_stats(hist, last_landed)
        cost: Any
        if agent == "codex":
            if codex_tokens.get("available"):
                cost = {
                    "value": codex_tokens["tokens"],
                    "unit": "tokens",
                    "status": "measured",
                    "source": codex_tokens.get("kind"),
                }
            else:
                cost = {"value": None, "unit": None, "status": "UNKNOWN", "source": None}
        else:
            cost = {"value": None, "unit": None, "status": "UNKNOWN", "source": None}

        now_rows.append({
            "agent": agent,
            "in_rotation": bool(roster.get(agent, {}).get("in_rotation", True)),
            "roster_note": roster.get(agent, {}).get("note", ""),
            "roster_changed": roster.get(agent, {}).get("changed"),
            "open_tasks": tasks,
            "task_id": primary["id"] if primary else None,
            "title": primary["title"] if primary else None,
            "process": proc,
            "assigned_at": to_iso(assigned_at),
            "elapsed_s": elapsed_s,
            "stats": stats,
            "cost": cost,
            "idle_failure": (not tasks) and bool(roster.get(agent, {}).get("in_rotation", True)),
        })
    return now_rows


## STALE WHILE REVALIDATE. A PLAIN TTL STILL HANGS SOMEBODY.
##
## Raising the TTL past the 32 s build stopped every request rebuilding, but it
## left one request a minute paying the whole 32 s - whichever poll happened to
## find the entry expired. On a phone that is a thirty-second freeze once a
## minute, which is barely better than never painting.
##
## So a cached snapshot is ALWAYS returned immediately, however old, and an
## expired one additionally kicks off ONE background rebuild. Only the very
## first call, with nothing cached at all, waits - and `serve` warms that off
## the critical path before anyone asks.
_SNAPSHOT_REFRESHING = threading.Lock()


def _rebuild_snapshot_async() -> None:
    ## `acquire(blocking=False)` is the whole guard: if a rebuild is already in
    ## flight the next caller does nothing rather than queueing a second 32 s
    ## run behind the first.
    if not _SNAPSHOT_REFRESHING.acquire(blocking=False):
        return

    def _run() -> None:
        try:
            collect_snapshot(force=True)
        except Exception as exc:  # noqa: BLE001
            print("ops board: snapshot refresh failed (%s)" % exc, flush=True)
        finally:
            _SNAPSHOT_REFRESHING.release()

    threading.Thread(target=_run, name="snapshot-refresh", daemon=True).start()


def collect_snapshot(force: bool = False) -> dict[str, Any]:
    import time as _time
    now_m = _time.monotonic()
    cached = _SNAPSHOT_CACHE.get("data")
    if not force and cached is None and SNAPSHOT_DISK.is_file():
        ## S120: a cold server answered nothing for 80 s. Serve the last snapshot
        ## written to disk (stale, marked) and build the fresh one behind it.
        try:
            cached = json.loads(SNAPSHOT_DISK.read_text(encoding="utf-8"))
            cached.setdefault("errors", []).append("stale snapshot from disk; refreshing")
            fresh_roster = load_roster()
            cached["roster"] = fresh_roster
            ## S142: same gap as save_roster() - the disk snapshot's `now` array was
            ## built at its own last-save time, so a roster change since (a toggle, or
            ## an edit to roster.json) would show reverted until the background
            ## rebuild below finishes. Patch it the same way on this cold-start path.
            _patch_now_with_roster(cached, fresh_roster)
            _SNAPSHOT_CACHE["data"] = cached
            _SNAPSHOT_CACHE["at"] = 0.0
        except (OSError, ValueError):
            cached = None
    if not force and cached is not None:
        if (now_m - float(_SNAPSHOT_CACHE.get("at") or 0.0)) >= _SNAPSHOT_TTL_S:
            _rebuild_snapshot_async()
        return cached

    errors: list[str] = []
    rc, board_out, board_err = run_cmd([PYTHON, "Tools/agent_comms.py", "board"], timeout=240)  # S143: 51 s idle, >90 s with 4 agents running
    if rc != 0:
        errors.append(f"board rc={rc}: {board_err.strip() or board_out.strip()}")
        board = {"rows": [], "unread": {}, "warnings": [], "raw_lines": 0}
    else:
        board = parse_board(board_out)

    # triage --no-fetch to keep the page responsive
    rc, triage_out, triage_err = run_cmd(
        [PYTHON, "Tools/agent_comms.py", "triage", "--no-fetch"],
        timeout=240,
    )
    if rc != 0:
        errors.append(f"triage rc={rc}: {triage_err.strip() or triage_out.strip()}")
        triage = {
            "unmerged_branches": [],
            "orphan_digests": [],
            "ungateable": [],
            "blockers": [],
            "findings": 0,
        }
    else:
        triage = parse_triage(triage_out)

    roster = load_roster()
    procs = running_processes()
    history = history_for_agents()
    codex_tokens = parse_codex_tokens()
    suite = latest_suite_status()
    now = build_now(board, procs, roster, history, codex_tokens)
    roadmap = load_roadmap()

    attention = {
        "unread": board.get("unread", {}),
        "warnings": board.get("warnings", []),
        "unmerged_branches": triage.get("unmerged_branches", []),
        "orphan_digests": triage.get("orphan_digests", []),
        "ungateable": triage.get("ungateable", []),
        "blockers": triage.get("blockers", []),
        "findings": triage.get("findings", 0),
        "idle_in_rotation": [
            row["agent"] for row in now if row.get("idle_failure")
        ],
    }

    snap = {
        "generated_at": to_iso(utc_now()),
        "repo": str(ROOT),
        "agents": list(AGENTS),
        "cost_policy": {
            "measured": ["codex tokens (from run logs)"],
            "unknown": ["qwen", "grok", "cursor", "claude"],
            "honest_proxies": ["task count", "wall-clock duration", "commits landed", "files touched"],
            "note": (
                "Cost figures are shown only when measured. Codex tokens come from "
                "captured run logs. Qwen, Grok, Cursor and Claude have no per-task "
                "cost signal — those cells are UNKNOWN, never estimated."
            ),
        },
        "now": now,
        "history": history,
        "suite": suite,
        "attention": attention,
        "roster": roster,
        "codex_tokens": codex_tokens,
        "roadmap": roadmap,
        "board_row_count": len(board.get("rows", [])),
        "errors": errors,
    }
    _SNAPSHOT_CACHE["at"] = now_m
    _SNAPSHOT_CACHE["data"] = snap
    try:
        SNAPSHOT_DISK.write_text(json.dumps(snap, ensure_ascii=False), encoding="utf-8")
    except OSError:
        pass
    return snap


def selftest() -> int:
    print("OPSBOARD selftest")
    failed = 0

    def section(name: str, count: int, ok: bool, detail: str = "") -> None:
        nonlocal failed
        status = "ok" if ok else "FAIL"
        if not ok:
            failed += 1
        extra = f"  {detail}" if detail else ""
        print(f"  {name}: {count}{extra}  [{status}]")

    try:
        snap = collect_snapshot(force=True)
    except Exception as exc:
        print(f"  collect: FAIL  {exc}")
        traceback.print_exc()
        return 1

    section("board_rows", snap.get("board_row_count", 0), snap.get("board_row_count", 0) > 0)
    section("now_agents", len(snap.get("now", [])), len(snap.get("now", [])) == len(AGENTS))
    hist_count = sum(len(v) for v in snap.get("history", {}).values())
    section("history_rows", hist_count, hist_count > 0)
    suite = snap.get("suite") or {}
    section(
        "suite",
        1 if suite.get("ok") else 0,
        bool(suite.get("ok")),
        f"total={suite.get('total')} fails={suite.get('fails')} src={suite.get('source')}",
    )
    att = snap.get("attention") or {}
    att_n = (
        len(att.get("unmerged_branches", []))
        + len(att.get("orphan_digests", []))
        + len(att.get("ungateable", []))
        + len(att.get("blockers", []))
        + len(att.get("unread", {}))
    )
    section("attention_fields", att_n, True, f"findings={att.get('findings')}")
    roster = snap.get("roster") or {}
    section("roster_agents", len(roster), len(roster) == len(AGENTS) and ROSTER_PATH.is_file())
    rm = snap.get("roadmap") or {}
    # Roadmap is optional for page survival; selftest still reports load state.
    section(
        "roadmap",
        1 if rm.get("ok") else 0,
        True,
        (rm.get("error") or rm.get("source") or "ok") if isinstance(rm, dict) else "missing",
    )
    if not PAGE.is_file():
        section("index.html", 0, False, "missing")
    else:
        section("index.html", 1, True, f"{PAGE.stat().st_size} bytes")

    # Required sources must parse
    if snap.get("errors"):
        for err in snap["errors"]:
            print(f"  source_error: {err}  [FAIL]")
            failed += 1

    print(f"SELFTEST {'PASS' if failed == 0 else 'FAIL'} fails={failed}")
    return 0 if failed == 0 else 1


PM_REPLY_RE = re.compile(r"^\s*\**(P\d+)\**\s*[:.\-]\s*(.*)$")


def pm_replies(pm_dir: Path) -> dict[str, tuple[str, str]]:
    """Paul's answer to each operator message: {"P5": (text, review file)} from section 0 ("0 TO THE OPERATOR") of his
    reviews, newest file first, so a later answer wins. A paragraph runs until the next "P<n>:" line or section 1."""
    files = sorted(pm_dir.glob("PM_REVIEW_*.md"), key=lambda p: p.stat().st_mtime, reverse=True)
    latest = pm_dir / "latest.md"
    if latest.is_file():
        files.insert(0, latest)
    found: dict[str, tuple[str, str]] = {}
    for path in files:
        try:
            lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
        except OSError:
            continue
        in_zero, current, buf = False, "", []
        for line in lines + ["1 STATUS"]:
            head = line.strip().upper()
            if head.startswith("0 TO THE OPERATOR") or head.startswith("## 0"):
                in_zero = True
                continue
            if in_zero and (re.match(r"^(#+\s*)?1[\s.]", head) or head == "1 STATUS"):
                if current and current not in found:
                    found[current] = ("\n".join(buf).strip(), path.name)
                break
            if not in_zero:
                continue
            m = PM_REPLY_RE.match(line)
            if m:
                if current and current not in found:
                    found[current] = ("\n".join(buf).strip(), path.name)
                current, buf = m.group(1), [m.group(2)]
            elif current:
                buf.append(line)
    return found


class Handler(BaseHTTPRequestHandler):
    server_version = "FightCampOpsBoard/1.0"

    def log_message(self, fmt: str, *args: Any) -> None:
        sys.stderr.write("%s - %s\n" % (self.address_string(), fmt % args))

    def _send(self, code: int, body: bytes, content_type: str) -> None:
        self.send_response(code)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)

    def _markup_save(self) -> None:
        ## S205: a Markup Board save from the ops board -> Feedback/<date-nn>/ (README.md + marks.json + marked.png), and one
        ## line in media_comments.json so `start` prints it beside the stills comments.
        import importlib.util
        import media_review
        length = int(self.headers.get("Content-Length", "0") or "0")
        if length > 60 * 1024 * 1024:
            self._json(413, {"error": "image too large"})
            return
        try:
            payload = json.loads(self.rfile.read(length).decode("utf-8"))
            spec = importlib.util.spec_from_file_location("markup_serve", ROOT / "Tools" / "markup" / "serve.py")
            mod = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(mod)  # type: ignore[union-attr]
            qid = str(payload.get("qid", ""))[:40]
            if qid and not str(payload.get("source", "")).strip():
                payload["source"] = "ops board question " + qid
            result = mod.save_feedback(payload)
        except Exception as exc:  # report to the page, keep serving
            self._json(400, {"error": str(exc)})
            return
        rel = Path(result["folder"]).relative_to(ROOT).as_posix()
        data = media_review.load_comments(ROOT)
        key = str(payload.get("image_key", "")) or "?"
        data["comments"].append({"id": "C%d" % (len(data["comments"]) + 1), "path": key,
                                 "text": "MARKUP%s: %d marks -> %s/README.md" % ((" for " + qid) if qid else "", result["marks"], rel),
                                 "at": to_iso(utc_now()), "seen_by_claude": False})
        media_review._save(media_review.comments_path(ROOT), data)
        self._json(200, {"id": result["id"], "folder": rel, "marks": result["marks"]})

    def _send_media(self, target: Path) -> None:
        """Whole file, or one `Range: bytes=a-b` slice (a video element seeks with ranges)."""
        size = target.stat().st_size
        ctype = MEDIA_TYPES[target.suffix.lower()]
        rng = self.headers.get("Range", "")
        m = re.match(r"bytes=(\d*)-(\d*)$", rng.strip())
        with target.open("rb") as fh:
            if m and (m.group(1) or m.group(2)):
                if m.group(1):
                    start = int(m.group(1))
                    end = int(m.group(2)) if m.group(2) else size - 1
                else:
                    start = max(0, size - int(m.group(2)))
                    end = size - 1
                end = min(end, size - 1)
                if start > end:
                    self.send_response(416)
                    self.send_header("Content-Range", f"bytes */{size}")
                    self.end_headers()
                    return
                fh.seek(start)
                body = fh.read(end - start + 1)
                self.send_response(206)
                self.send_header("Content-Range", f"bytes {start}-{end}/{size}")
            else:
                body = fh.read()
                self.send_response(200)
        self.send_header("Content-Type", ctype)
        self.send_header("Accept-Ranges", "bytes")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)

    def _json(self, code: int, payload: Any) -> None:
        body = (json.dumps(payload, ensure_ascii=False, indent=2) + "\n").encode("utf-8")
        self._send(code, body, "application/json; charset=utf-8")

    def do_GET(self) -> None:  # noqa: N802
        path = urlparse(self.path).path
        if path in ("/", "/roadmap") and ROADMAP_PAGE.is_file():
            self._send(200, ROADMAP_PAGE.read_bytes(), "text/html; charset=utf-8")
            return
        if path in ("/", "/old", "/index.html"):
            if not PAGE.is_file():
                self._send(500, b"index.html missing\n", "text/plain; charset=utf-8")
                return
            data = PAGE.read_bytes()
            self._send(200, data, "text/html; charset=utf-8")
            return
        if path in ("/animations", "/animations.html"):
            if not ANIM_PAGE.is_file():
                self._send(500, b"animations.html missing\n", "text/plain; charset=utf-8")
                return
            self._send(200, ANIM_PAGE.read_bytes(), "text/html; charset=utf-8")
            return
        if path in ("/review", "/review.html"):
            ## S192 operator: "i want to be able to see those [stills and videos] on the opsboard to make comments".
            page = ROOT / "Tools" / "opsboard" / "review.html"
            self._send(200 if page.is_file() else 500, page.read_bytes() if page.is_file() else b"review.html missing",
                       "text/html; charset=utf-8")
            return
        if path == "/api/media":
            import media_review
            from urllib.parse import parse_qs
            folder = parse_qs(urlparse(self.path).query).get("folder", [""])[0]
            try:
                if folder:
                    self._json(200, {"folder": folder, "files": media_review.folder_files(ROOT, MEDIA_ROOT, folder)})
                else:
                    self._json(200, {"sent": media_review.sent_posts(ROOT), "removed": media_review.removed_posts(ROOT),
                                     "folders": media_review.preview_folders(MEDIA_ROOT)})
            except Exception as exc:
                self._json(500, {"error": str(exc), "trace": traceback.format_exc()})
            return
        if path in ("/agents", "/agents.html"):
            if not AGENTS_PAGE.is_file():
                self._send(500, b"agents.html missing", "text/plain; charset=utf-8")
                return
            self._send(200, AGENTS_PAGE.read_bytes(), "text/html; charset=utf-8")
            return
        if path == "/api/meters":
            # S214: numeric meters (Claude via the usage-meter mod, Codex log, GitHub $, OpenRouter) + the router's picks.
            try:
                sys.path.insert(0, str(ROOT / "Tools"))
                import agent_meters, agent_router  # noqa: E401
                meters = agent_meters.all_meters()
                running = agent_router.busy()
                pc = agent_router.watchdog()
                picks = {k: agent_router.decide("", k, meters, running, pc) for k in ("pure", "code", "ui", "animation", "research", "design")}
                self._json(200, {"meters": meters, "picks": picks, "pc": pc})
            except Exception as exc:
                self._json(500, {"error": str(exc), "trace": traceback.format_exc()})
            return
        if path == "/api/limits":
            try:
                self._json(200, limits_live())
            except Exception as exc:
                self._json(500, {"error": str(exc), "trace": traceback.format_exc()})
            return
        if path == "/api/cloud":
            try:
                self._json(200, cloud_live())
            except Exception as exc:
                self._json(500, {"error": str(exc), "trace": traceback.format_exc()})
            return
        if path == "/api/agents":
            try:
                self._json(200, agents_live())
            except Exception as exc:
                self._json(500, {"error": str(exc), "trace": traceback.format_exc()})
            return
        if path == "/api/animations":
            try:
                self._json(200, anim_catalogue())
            except Exception as exc:
                self._json(500, {"error": str(exc), "trace": traceback.format_exc()})
            return
        if path.startswith("/media/"):
            from urllib.parse import unquote
            target = media_file(unquote(path[len("/media/"):]))
            if target is None:
                self._send(404, b"not found\n", "text/plain; charset=utf-8")
                return
            self._send_media(target)
            return
        if path == "/api/snapshot":
            try:
                self._json(200, collect_snapshot())
            except Exception as exc:
                self._json(500, {"error": str(exc), "trace": traceback.format_exc()})
            return
        if path == "/markup":
            ## S205 operator: "add a link on opsboard for the tool that marks areas in the picture when i have to approve something".
            ## The Markup Board page (Tools/markup) served from the board itself: pictures come from /attach (question attachments)
            ## or /media (review page keys, "media:<key>"), saves go to /markup/save.
            page = (ROOT / "Tools" / "markup" / "markup_board.html").read_text(encoding="utf-8")
            page = page.replace("fetch('/save'", "fetch('/markup/save'")
            page = page.replace("fetch('/img/' + name)", "fetch(name.startsWith('media:') ? '/media/' + name.slice(6).split('/').map(encodeURIComponent).join('/') : '/attach?path=' + encodeURIComponent(name))")
            page = page.replace("const payload = {title: $('#title').value.trim(),", "const payload = {qid: new URLSearchParams(location.search).get('qid') || '', image_key: queue[qi] || '', title: $('#title').value.trim(),")
            self._send(200, page.encode("utf-8"), "text/html; charset=utf-8")
            return
        if path == "/api/github":
            try:
                self._json(200, github_actions_meter(wait=False))
            except Exception as exc:
                self._json(500, {"ok": False, "why": str(exc)})
            return
        if path == "/api/pc/live":
            self._json(200, pc_live())
            return
        if path == "/api/pc/heat":
            self._json(200, pc_heat())
            return
        if path == "/api/pc/cores":
            self._json(200, pc_cores())
            return
        if path == "/api/pc":
            try:
                self._json(200, pc_health())
            except Exception as exc:
                self._json(500, {"ok": False, "why": str(exc)})
            return
        if path == "/api/roadmap":
            self._json(200, load_roadmap())
            return
        if path == "/api/roster":
            self._json(200, load_roster())
            return
        if path in ("/attach", "/api/attach"):
            ## S191: what a question asks him to approve, readable on the board (Tools/opsboard/attach_view.py).
            import attach_view
            from urllib.parse import parse_qs
            rel = parse_qs(urlparse(self.path).query).get("path", [""])[0]
            status, body, ctype = attach_view.render(ROOT, rel, as_page=(path == "/attach"))
            self._send(status, body, ctype)
            return
        if path == "/api/questions":
            self._json(200, _load_questions())
            return
        if path == "/api/procs":
            ## S231 operator: "also add duration on tasks, running pids on board".
            self._json(200, _work_processes())
            return
        if path == "/api/pm":
            ## S231: Paul's inbox + when his newest review landed (the main page's chat box reads this).
            sys.path.insert(0, str(ROOT / "Tools"))
            import pm_bot
            import time
            latest = ROOT / "AgentComms" / "pm" / "latest.md"
            ## S233 operator: "i still have no clue how to read pauls responses he does not appear anywhere" - each message
            ## carries Paul's own answer (his "P<n>:" paragraph from section 0 of the newest review that has one).
            messages = [dict(m) for m in pm_bot.load_inbox().get("messages", [])[-20:]]
            replies = pm_replies(ROOT / "AgentComms" / "pm")
            for m in messages:
                if str(m.get("id", "")) in replies:
                    m["reply"], m["reply_file"] = replies[str(m["id"])]
            self._json(200, {"messages": messages,
                             "review_at": time.strftime("%Y-%m-%d %H:%M", time.localtime(latest.stat().st_mtime)) if latest.is_file() else "",
                             "thinking": (ROOT / "AgentComms" / "pm" / "asking.lock").is_file()})
            return
        if path == "/api/availability":
            try:
                roster = json.loads(ROSTER_PATH.read_text(encoding="utf-8"))
            except (OSError, UnicodeDecodeError, json.JSONDecodeError):
                self._json(500, {"error": "roster unavailable"})
                return
            self._json(200, roster if isinstance(roster, dict) else {})
            return
        if path == "/api/launch":
            ## GET reports what each button WILL do before it is pressed, so a
            ## target that has moved shows as not-ready on the phone instead of
            ## failing only when it is tapped.
            self._json(200, {
                "build": SERVER_BUILD,
                "windows": os.name == "nt",
                "targets": [resolve_launch_target(t) for t in load_launch_targets()],
            })
            return
        self._send(404, b"not found\n", "text/plain; charset=utf-8")

    def do_POST(self) -> None:  # noqa: N802
        path = urlparse(self.path).path
        if path == "/api/pm_message":
            ## S231 operator: "where can i communicate with paul ?" - his message is queued and Paul is woken, hidden.
            length = int(self.headers.get("Content-Length", "0") or "0")
            if length > 8_000:
                self._json(413, {"error": "body too large"})
                return
            try:
                payload = json.loads((self.rfile.read(length) if length else b"{}").decode("utf-8"))
            except (UnicodeDecodeError, json.JSONDecodeError):
                self._json(400, {"error": "invalid json"})
                return
            text = str(payload.get("text", "")).strip() if isinstance(payload, dict) else ""
            if not text:
                self._json(400, {"error": "empty message"})
                return
            sys.path.insert(0, str(ROOT / "Tools"))
            import pm_bot
            row = pm_bot.add_message(text)
            import subprocess
            flags = 0x08000000 | 0x00000008 if os.name == "nt" else 0  # CREATE_NO_WINDOW | DETACHED_PROCESS
            python = sys.executable.replace("pythonw.exe", "python.exe")
            subprocess.Popen([python, str(ROOT / "Tools" / "pm_bot.py"), "ask", "--wait"], cwd=str(ROOT), creationflags=flags,
                             stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            self._json(200, {"ok": True, "message": row})
            return
        if path == "/markup/save":
            self._markup_save()
            return
        if path in ("/api/media_remove", "/api/media_restore", "/api/media_remove_older"):
            ## S223 operator: "add option for me to remove the old pictures from the opsboard" - moves, never deletes.
            import media_review
            length = int(self.headers.get("Content-Length", "0") or "0")
            if length > 4_000:
                self._json(413, {"error": "body too large"})
                return
            try:
                payload = json.loads((self.rfile.read(length) if length else b"{}").decode("utf-8"))
            except (UnicodeDecodeError, json.JSONDecodeError):
                self._json(400, {"error": "invalid json"})
                return
            if not isinstance(payload, dict):
                self._json(400, {"error": "expected object"})
                return
            try:
                if path == "/api/media_remove_older":
                    code, row = media_review.remove_older_versions()
                elif path == "/api/media_remove":
                    code, row = media_review.remove_media(payload)
                else:
                    code, row = media_review.restore_media(payload)
            except OSError as exc:
                code, row = 500, {"error": str(exc)}
            self._json(code, row)
            return
        if path == "/api/media_comment":
            import media_review
            length = int(self.headers.get("Content-Length", "0") or "0")
            if length > 4_000:
                self._json(413, {"error": "body too large"})
                return
            try:
                payload = json.loads((self.rfile.read(length) if length else b"{}").decode("utf-8"))
            except (UnicodeDecodeError, json.JSONDecodeError):
                self._json(400, {"error": "invalid json"})
                return
            if not isinstance(payload, dict):
                self._json(400, {"error": "expected object"})
                return
            code, row = media_review.add_comment(ROOT, MEDIA_ROOT, payload)
            self._json(code, row)
            return
        if path in ("/api/answer", "/api/availability"):
            length = int(self.headers.get("Content-Length", "0") or "0")
            limit = 4_000 if path == "/api/answer" else 4_000
            if length > limit:
                self._json(413, {"error": "body too large"})
                return
            raw = self.rfile.read(length) if length else b"{}"
            try:
                payload = json.loads(raw.decode("utf-8"))
            except (UnicodeDecodeError, json.JSONDecodeError):
                self._json(400, {"error": "invalid json"})
                return
            if not isinstance(payload, dict):
                self._json(400, {"error": "expected object"})
                return
            if path == "/api/answer":
                question_id = str(payload.get("id", ""))
                answer = payload.get("answer")
                note = payload.get("note")
                if not isinstance(answer, str):
                    self._json(400, {"error": "answer must be text"})
                    return
                if note is not None and (not isinstance(note, str) or len(note) > 8000):
                    self._json(400, {"error": "note must be at most 8000 characters"})
                    return
                questions = _load_questions()
                rows = questions.get("questions", [])
                row = next((q for q in rows if isinstance(q, dict) and q.get("id") == question_id), None)
                if row is None:
                    self._json(404, {"error": "unknown question"})
                    return
                options = row.get("options") or []
                ## S188 operator: "i want to be able to not pick and answer, just comment" - a text that is not one of
                ## the options is a free comment (same 8000-char cap), flagged so `start` quotes it as a comment.
                if not answer.strip():
                    self._json(400, {"error": "answer is empty"})
                    return
                if len(answer) > 8000:
                    self._json(400, {"error": "answer must be at most 8000 characters"})
                    return
                row["comment_only"] = bool(options) and answer not in options
                row["answer"] = answer
                row["note"] = note
                row["answered_at"] = to_iso(utc_now())
                row["seen_by_claude"] = False
                _atomic_json(QUESTIONS_PATH, questions)
                ## S232 operator: "can you automate this board update process [...] use our agents": an answer wakes Paul
                ## (hidden), who turns it into BOARD EDITS in his next review - only for the live board's own questions file.
                if Path(QUESTIONS_PATH).resolve().is_relative_to(ROOT.resolve()):
                    try:
                        sys.path.insert(0, str(ROOT / "Tools"))
                        import pm_bot
                        pm_bot.add_message("BOARD ANSWER %s - question: %s | answer: %s%s | turn it into BOARD EDITS (park/close/"
                                           "owner/notes) for the rows it names" % (question_id, str(row.get("text", ""))[:600],
                                           answer[:1500], (" | note: " + note[:800]) if note else ""), sender="board")
                        import subprocess
                        flags = 0x08000000 | 0x00000008 if os.name == "nt" else 0  # CREATE_NO_WINDOW | DETACHED_PROCESS
                        python = sys.executable.replace("pythonw.exe", "python.exe")
                        subprocess.Popen([python, str(ROOT / "Tools" / "pm_bot.py"), "ask", "--wait"], cwd=str(ROOT),
                                         creationflags=flags, stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL,
                                         stderr=subprocess.DEVNULL)
                    except Exception as exc:  # the answer is saved either way
                        print("answer -> Paul wake failed: %s" % exc, file=sys.stderr)
                self._json(200, row)
                return
            agent_name = str(payload.get("agent", "")).lower().strip()
            available = payload.get("available")
            if not isinstance(available, bool):
                self._json(400, {"error": "available must be boolean"})
                return
            try:
                roster = json.loads(ROSTER_PATH.read_text(encoding="utf-8"))
            except (OSError, UnicodeDecodeError, json.JSONDecodeError):
                self._json(500, {"error": "roster unavailable"})
                return
            row = roster.get(agent_name) if isinstance(roster, dict) else None
            if not isinstance(row, dict):
                self._json(404, {"error": "unknown agent"})
                return
            row["in_rotation"] = available
            date = utc_now().date().isoformat()
            line = "%s operator via board: %s" % (date, "available" if available else "not available")
            old_note = str(row.get("note", "") or "")
            separator = "" if not old_note or old_note.endswith("\n") else "\n"
            row["note"] = old_note + separator + line
            _atomic_json(ROSTER_PATH, roster)
            self._json(200, {"agent": agent_name, "available": available, "saved": True})
            return
        if path == "/api/launch":
            length = int(self.headers.get("Content-Length", "0") or "0")
            if length > 2_000:
                self._json(413, {"error": "body too large"})
                return
            raw = self.rfile.read(length) if length else b"{}"
            try:
                payload = json.loads(raw.decode("utf-8"))
            except (UnicodeDecodeError, json.JSONDecodeError):
                self._json(400, {"error": "invalid json"})
                return
            if not isinstance(payload, dict):
                self._json(400, {"error": "expected object"})
                return
            ## ONLY the id is read. No path, no arguments, no command - see the
            ## note on `launch_target`.
            result = launch_target(str(payload.get("target", "")).strip())
            self._json(200 if result.get("ok") else 400, result)
            return
        if path != "/api/roster":
            self._send(404, b"not found\n", "text/plain; charset=utf-8")
            return
        length = int(self.headers.get("Content-Length", "0") or "0")
        if length > 32_000:
            self._json(413, {"error": "body too large"})
            return
        raw = self.rfile.read(length) if length else b"{}"
        try:
            payload = json.loads(raw.decode("utf-8"))
        except (UnicodeDecodeError, json.JSONDecodeError):
            self._json(400, {"error": "invalid json"})
            return
        if not isinstance(payload, dict):
            self._json(400, {"error": "expected object"})
            return
        agent = str(payload.get("agent", "")).lower().strip()
        if agent not in AGENTS:
            self._json(400, {"error": "unknown agent"})
            return
        roster = load_roster()
        row = roster[agent]
        if "in_rotation" in payload:
            row["in_rotation"] = bool(payload["in_rotation"])
        if "note" in payload:
            # A TOGGLE IS NOT AN EDIT OF THE NOTE. The page posts the note it is currently
            # showing alongside every in_rotation flip, and this used to store it as
            # str(...)[:200] - so each toggle silently amputated the note to 200 characters and
            # the loss compounded. That is how every agent's launch line, watch-list and
            # capacity history was destroyed between 2026-09-12 and 2026-09-15; a session on
            # 2026-09-20 found all eight notes sitting at exactly 200 bytes.
            # Two guards, because the page in a phone's cache may be old for a long time:
            #   1. a note that is a PREFIX of the stored one is a truncated echo, never an edit;
            #   2. the cap is long enough to hold a real note.
            incoming = str(payload.get("note") or "")
            stored = str(row.get("note") or "")
            if stored and incoming and incoming != stored and stored.startswith(incoming):
                pass  # truncated echo of what we already hold - keep the full note
            else:
                row["note"] = incoming[:NOTE_MAX]
        row["changed"] = to_iso(utc_now())
        roster[agent] = row
        saved = save_roster(roster)
        self._json(200, saved)


def serve(port: int) -> int:
    # Ensure roster exists before the page loads
    load_roster()
    if not PAGE.is_file():
        print("ERROR: index.html missing next to server.py", file=sys.stderr)
        return 1
    host = "0.0.0.0"
    httpd = ThreadingHTTPServer((host, port), Handler)

    ## WARM THE CACHE OFF THE CRITICAL PATH, so the first page load is not the
    ## one that pays the 32 s. It cannot be done before `serve_forever` because
    ## the scheduled task probes the port within 20 s and would tear the board
    ## down as failed; and it must never be fatal, because a board that is UP is
    ## worth more than a board with a warm cache.
    def _warm() -> None:
        try:
            collect_snapshot(force=True)
        except Exception as exc:  # noqa: BLE001
            print("ops board: snapshot warm-up failed (%s)" % exc, flush=True)

    threading.Thread(target=_warm, name="snapshot-warm", daemon=True).start()
    ip = lan_ip()
    print(f"FightCamp Ops Board", flush=True)
    print(f"  local:  http://127.0.0.1:{port}/", flush=True)
    print(f"  phone:  http://{ip}:{port}/", flush=True)
    print(f"  bind:   {host}:{port}", flush=True)
    print(f"  stop:   Ctrl+C", flush=True)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nstopped")
    finally:
        httpd.server_close()
    return 0


def main() -> int:
    for stream in (sys.stdout, sys.stderr):
        try:
            stream.reconfigure(encoding="utf-8")
        except Exception:
            pass
    parser = argparse.ArgumentParser(description="FightCamp Ops Board")
    parser.add_argument("--port", type=int, default=DEFAULT_PORT)
    parser.add_argument("--selftest", action="store_true")
    ## `--log` EXISTS SO THE SCHEDULED TASK NEEDS NEITHER pythonw NOR cmd.
    ##
    ## Both of the obvious ways to run this from Task Scheduler are broken, and
    ## each failed differently on 2026-09-21:
    ##
    ##   pythonw.exe  - the GUI-subsystem build has NO console, so once this
    ##                  server has written enough to stdout the write BLOCKS
    ##                  FOREVER. The socket stays open and every connection is
    ##                  accepted and then dropped: a board that is listening and
    ##                  does not serve, which is the worst shape a fault can take
    ##                  because it looks alive from outside.
    ##   cmd.exe /c   - wrapping `"python" -u "server.py" --port N >> "log" 2>&1`
    ##                  in the outer quotes `/c` needs makes cmd mis-parse the
    ##                  nested ones. The task returned 0x1 instantly and wrote
    ##                  nothing at all, so there was not even an error to read.
    ##
    ## Handing the path in and reopening the streams here is the version with no
    ## shell in it and nothing to quote.
    parser.add_argument("--log", default="",
                        help="append stdout and stderr to this file instead of the console")
    args = parser.parse_args()
    if args.log:
        try:
            path = Path(args.log).expanduser()
            path.parent.mkdir(parents=True, exist_ok=True)
            handle = open(path, "a", encoding="utf-8", buffering=1)
            sys.stdout = handle
            sys.stderr = handle
        except OSError as exc:
            ## A log that cannot be opened must not take the board down with it -
            ## the board being UP is the whole point of the scheduled task.
            print("ops board: could not open --log %s (%s); staying on stdout"
                  % (args.log, exc))
    if args.selftest:
        return selftest()
    return serve(args.port)


if __name__ == "__main__":
    raise SystemExit(main())
