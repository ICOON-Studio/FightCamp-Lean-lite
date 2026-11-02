"""open_agent_prs.py - open the PR an agent branch is missing (S274).

Operator S274: "anything else we can do to speed up process ?". Measured the same day: every Cursor run ended with
"cursor pushed cursor/issue-<n> but the PR could not be opened" - the repo's Actions workflow permissions are read-only and
GitHub Actions may not create pull requests (repo setting, the operator's), so each landing needed a hand fetch + diff.
This opens the PR from the PC's gh login instead: for every OPEN issue labelled cursor / goose / qwen / grok / cline whose
branch `<label>/issue-<n>` exists on origin with commits not on master and has no PR, `gh pr create` (base master,
"Closes #<n>", the issue title). Nothing is merged here - the normal collect (fast lane / diff + tests) follows.

    python Tools/open_agent_prs.py            # dry run: what it would open
    python Tools/open_agent_prs.py --apply    # open them (the 30-min board_reconcile --apply runs this)
Stdlib + gh.
"""
from __future__ import annotations
import datetime
import json
import subprocess
import sys

REPO = "ICOON-Studio/FightCamp-Lean"
LABELS = ("cursor", "goose", "qwen", "grok", "cline")
## Only LIVE runs: the issues AgentComms/live_runs.json lists as running (S274 dry run without this found 14, mostly old runs
## already collected by hand whose issues were never closed).
FRESH_DAYS = 3
LIVE_RUNS = __import__("pathlib").Path(__file__).resolve().parent.parent / "AgentComms" / "live_runs.json"


def live_issues() -> set[int]:
    try:
        runs = json.loads(LIVE_RUNS.read_text(encoding="utf-8-sig")).get("runs", {})
    except (OSError, ValueError):
        return set()
    return {int(r["issue"]) for r in runs.values() if isinstance(r, dict) and r.get("issue") and r.get("status") == "running"}


def _gh(args: list[str]) -> str:
    out = subprocess.run(["gh", *args], capture_output=True, text=True, encoding="utf-8", timeout=120)
    if out.returncode != 0:
        raise RuntimeError(out.stderr.strip()[:300])
    return out.stdout


def candidates() -> list[dict]:
    found: list[dict] = []
    live = live_issues()
    for label in LABELS:
        issues = json.loads(_gh(["issue", "list", "--repo", REPO, "--label", label, "--state", "open", "--limit", "50",
                                 "--json", "number,title,updatedAt"]))
        cutoff = datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(days=FRESH_DAYS)
        for issue in issues:
            updated = datetime.datetime.fromisoformat(str(issue["updatedAt"]).replace("Z", "+00:00"))
            if updated < cutoff or int(issue["number"]) not in live:
                continue
            branch = "%s/issue-%d" % (label, int(issue["number"]))
            try:
                _gh(["api", "repos/%s/branches/%s" % (REPO, branch), "--jq", ".name"])
            except RuntimeError:
                continue  # not pushed yet
            prs = json.loads(_gh(["pr", "list", "--repo", REPO, "--head", branch, "--state", "all", "--json", "number"]))
            if prs:
                continue
            ahead = json.loads(_gh(["api", "repos/%s/compare/master...%s" % (REPO, branch), "--jq",
                                    "{ahead: .ahead_by}"]))
            if int(ahead.get("ahead", 0)) <= 0:
                continue
            found.append({"label": label, "issue": int(issue["number"]), "title": str(issue["title"]), "branch": branch})
    return found


def run(apply: bool) -> dict:
    opened: list[str] = []
    errors: list[str] = []
    todo = candidates()
    for c in todo:
        if not apply:
            continue
        try:
            url = _gh(["pr", "create", "--repo", REPO, "--base", "main", "--head", c["branch"],
                       "--title", c["title"][:200],
                       "--body", "Closes #%d\n\nOpened by Tools/open_agent_prs.py (S274): the %s run pushed this branch but "
                                 "Actions may not create PRs on this repo. Brief and RESULT lines: see the issue." % (c["issue"], c["label"])]).strip()
            opened.append(url)
        except RuntimeError as exc:
            errors.append("%s: %s" % (c["branch"], exc))
    return {"candidates": todo, "opened": opened, "errors": errors}


def main() -> int:
    result = run("--apply" in sys.argv)
    for c in result["candidates"]:
        print("AGENT_PR %s #%d %s" % ("OPEN" if "--apply" in sys.argv else "WOULD OPEN", c["issue"], c["branch"]))
    for e in result["errors"]:
        print("AGENT_PR ERROR %s" % e)
    print("OPEN_AGENT_PRS candidates=%d opened=%d errors=%d" % (len(result["candidates"]), len(result["opened"]), len(result["errors"])))
    return 0


if __name__ == "__main__":
    sys.exit(main())
