"""auto_collect.py - the fast lane for agent PRs that only ADD a pure module and its test (S240).

Operator S240 (after the Anthropic Scion video, "review intent, merge concurrently"): "and do the rest that you suggested".
Claude stays the reviewer of INTENT (does the PR do what the brief asked); the mechanical collect - diff, guard, CI, copy the new
files onto master, commit, close the PR - is this script.

    python Tools/auto_collect.py <pr>            # dry run: says ELIGIBLE or why not, prints the PR body for the intent read
    python Tools/auto_collect.py <pr> --merge    # eligible -> new files onto master (by content, never a branch merge), commit, push, close
    python Tools/auto_collect.py <pr> --any-state  # proof dry run on a CLOSED PR (the state check is skipped; never merges)

S249 BRIEF SCOPE: the PR's task id (TASK_<id>.md named in the body, else an id in the title) finds its brief, and the brief's
'## Files you create / Owned files' list must EQUAL the PR's added files. The 30-min reconcile (Tools/collect_ready.py) merges a
PR unattended only when it is ELIGIBLE *and* its brief scope matches - that match replaces Claude's intent read for that PR.

ELIGIBLE only when ALL hold (anything else goes the normal way: check_workflow / diff + parse + test by hand):
  1. every changed file is ADDED (no modified, renamed or deleted file) and lies under Godot/scripts/rules/, Godot/tests/ or
     research/ - a new pure module, its test, its notes;
  2. at least one new Godot/tests/*_test.gd (a module without its test is not collectable here);
  3. every CI check on the PR finished SUCCESS (ci.yml "Parse gate + changed tests" parses each changed .gd and runs each changed test
     headless, LFS off) and at least one check ran;
  4. Tools/ci_arena.py guard_for(master, PR head) passes (no deleted or gutted tests);
  5. no new file is preloaded by an existing file it would silently change (new files only, so this holds by rule 1);
  6. the PR body carries `RESULT: tests/<x>_test.gd -> <exact pass line>` and that pass line is in the PR's CI log.
Stdlib only. Never `git apply -3` / never checks the branch out in the shared tree (CLAUDE.md s7).
"""
from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "Tools"))
import ci_arena  # noqa: E402

REPO = "ICOON-Studio/FightCamp-Lean"
ALLOWED = ("Godot/scripts/rules/", "Godot/tests/", "research/")
TRAILER = "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"


def _run(*args: str, check: bool = True) -> str:
    return subprocess.run(args, cwd=ROOT, check=check, capture_output=True, text=True, encoding="utf-8").stdout


def pr_info(pr: int) -> dict:
    return json.loads(_run("gh", "pr", "view", str(pr), "--repo", REPO, "--json",
                           "number,title,body,headRefName,headRefOid,files,statusCheckRollup,state,author"))


def eligibility(info: dict, any_state: bool = False) -> list[str]:
    why: list[str] = []
    if info.get("state") != "OPEN" and not any_state:
        why.append(f"PR is {info.get('state')}")
    files = info.get("files", [])
    if not files:
        why.append("no files")
    head = info["headRefOid"]
    ## S249: fetch the PR's own ref - an agent branch deleted after the PR (Arena, Grok Dev) still has refs/pull/<n>/head
    _run("git", "fetch", "-q", "origin", "main", f"refs/pull/{info['number']}/head")
    statuses = {}
    for line in _run("git", "diff", "--name-status", f"origin/main...{head}").splitlines():
        parts = line.split("\t")
        statuses[parts[-1]] = parts[0]
    for path, status in statuses.items():
        if status != "A":
            why.append(f"{path}: {status} (only ADDED files are collectable here)")
        elif not path.startswith(ALLOWED):
            why.append(f"{path}: outside {', '.join(ALLOWED)}")
    if not any(p.startswith("Godot/tests/") and p.endswith("_test.gd") for p, s in statuses.items() if s == "A"):
        why.append("no new Godot/tests/*_test.gd")
    checks = info.get("statusCheckRollup") or []
    if not checks:
        why.append("no CI check ran on the PR")
    for c in checks:
        state = c.get("conclusion") or c.get("state") or ""
        if state.upper() != "SUCCESS":
            why.append(f"CI check {c.get('name') or c.get('context')}: {state or c.get('status')}")
    base = _run("git", "merge-base", "origin/main", head).strip()
    if ci_arena.guard_for(base, head, prefix="GUARD ") != 0:
        why.append("ci_arena guard failed (deleted or gutted test)")
    why.extend(result_lines_proven(info))
    info["_added"] = sorted(p for p, s in statuses.items() if s == "A")
    return why


RESULT_RE = re.compile(r"^RESULT:\s*(\S+?\.gd)\s*->\s*(.+?)\s*$", re.M)


def result_lines_proven(info: dict) -> list[str]:
    """S240 machine-readable report: every brief asks for `RESULT: tests/<x>_test.gd -> <its exact pass line>` lines in the PR body.
    Each pass line must appear in the PR's own CI log (ci.yml runs every changed test headless) - the agent's word is not proof."""
    found = RESULT_RE.findall(info.get("body") or "")
    if not found:
        return ["no 'RESULT: tests/<x>_test.gd -> <pass line>' line in the PR body"]
    run_ids = set()
    for c in info.get("statusCheckRollup") or []:
        m = re.search(r"/actions/runs/(\d+)", str(c.get("detailsUrl") or c.get("targetUrl") or ""))
        if m:
            run_ids.add(m.group(1))
    log = "".join(_run("gh", "run", "view", rid, "--repo", REPO, "--log", check=False) for rid in sorted(run_ids))
    info["_ci_log"] = log
    # S249: CI runs changed tests through run_tests.py, which collapses a passing test to `[ 1/1] PASS   <name>.gd` - the exact
    # pass line never reaches the log (#254 was refused with CI green). The runner's own PASS (it fails a test on SCRIPT ERROR,
    # a FAIL line or no output) is machine proof too; the agent's word still is not.
    def _proven(test: str, line: str) -> bool:
        if line.strip("` ") in log:
            return True
        name = re.escape(test.replace("\\", "/").rsplit("/", 1)[-1])
        return re.search(r"\]\s+PASS\s+(?:\S*/)?" + name + r"\b", log) is not None
    missing = [f"{test}: neither the pass line nor a runner PASS in the CI log: {line[:80]}" for test, line in found if not _proven(test, line)]
    return missing


TASK_ID_RE = re.compile(r"\bTASK_([A-Za-z0-9_]+?)\.md\b")
TITLE_ID_RE = re.compile(r"\b([A-Z][A-Z0-9]{2,}\d[A-Z0-9]*)\b")


def _norm(path: str) -> str:
    path = path.strip().strip("`").replace("\\", "/")
    if not path.startswith("Godot/") and path.split("/", 1)[0] in ("scripts", "tests", "research", "tools", "assets", "scenes"):
        path = "Godot/" + path
    return path


def brief_scope(info: dict) -> dict:
    """S249: the PR's brief and whether its added files are EXACTLY the brief's owned files. {task, brief, owned, added, match, why}."""
    import agent_comms  # owned_files(): the same '## Owned files / Files you create' reader the `done` gate uses
    research = ROOT / "research"
    ids = TASK_ID_RE.findall(info.get("body") or "") + TASK_ID_RE.findall(info.get("title") or "")
    ids += [t for t in TITLE_ID_RE.findall(info.get("title") or "") if t not in ids]
    task = next((t for t in ids if (research / f"TASK_{t}.md").is_file()), "")
    added = sorted(info.get("_added") or [])
    out = {"task": task, "brief": f"research/TASK_{task}.md" if task else "", "owned": [], "added": added, "match": False}
    if not task:
        out["why"] = "no brief: no TASK_<id>.md named in the PR body/title exists (ids seen: %s)" % (", ".join(ids[:6]) or "none")
        return out
    text = (research / f"TASK_{task}.md").read_text(encoding="utf-8", errors="replace")
    ## S249 code-PR lane: a brief's `## Contract` block (Tools/brief_contract.py) is the machine-readable scope - its OWNS wins
    ## over the prose '## Files' section, and VISUAL: yes is never merged by a machine (visual-gate).
    contract = None
    try:
        import brief_contract
        contract = brief_contract.parse(text)
    except Exception:
        contract = None
    if contract and contract.get("owns"):
        owned, out["source"] = sorted({_norm(o["path"]) for o in contract["owns"]}), "## Contract OWNS"
    else:
        owned, out["source"] = sorted({_norm(p) for p in agent_comms.owned_files(text)}), "## Owned files"
    out["owned"] = owned
    extra, missing = sorted(set(added) - set(owned)), sorted(set(owned) - set(added))
    if contract and contract.get("visual"):
        out["why"] = f"brief {out['brief']} contract says VISUAL: yes - the operator closes it (visual-gate), never a machine"
    elif not owned:
        out["why"] = f"brief {out['brief']} declares no owned files"
    elif extra or missing:
        out["why"] = "added files differ from the brief's owned files: extra %s, missing %s" % (extra or "-", missing or "-")
    else:
        out["match"], out["why"] = True, f"added files == {out['brief']} {out['source']} ({len(owned)})"
    return out


def collect(info: dict) -> None:
    head = info["headRefOid"]
    for path in info["_added"]:
        target = ROOT / path
        if target.exists():
            raise SystemExit(f"REFUSED: {path} already exists on this checkout")
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(subprocess.run(["git", "show", f"{head}:{path}"], cwd=ROOT, check=True, capture_output=True).stdout)
    _run("git", "add", "--", *info["_added"])
    msg = (f"S240 auto-collect PR #{info['number']} ({info['title']}): new files only, CI green, guard green - "
           f"{', '.join(info['_added'])}\n\n{TRAILER}\n")
    ## S249: commit ONLY these paths - the checkout is shared and another session may have its own work staged
    subprocess.run(["git", "commit", "-q", "-F", "-", "--", *info["_added"]], cwd=ROOT, check=True, input=msg, text=True, encoding="utf-8")
    _run("git", "push", "-q", "origin", "main")
    _run("gh", "pr", "close", str(info["number"]), "--repo", REPO, "--comment",
         f"Collected onto master by Tools/auto_collect.py ({_run('git', 'rev-parse', '--short', 'HEAD').strip()}): new files only, CI + guard green.")


def main(argv: list[str]) -> int:
    # S263: PR bodies carry non-cp1252 characters (a check mark crashed the dry run on the Windows console).
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    if len(argv) < 2 or not argv[1].isdigit():
        print(__doc__)
        return 2
    info = pr_info(int(argv[1]))
    any_state = "--any-state" in argv
    if any_state and "--merge" in argv:
        print("REFUSED: --any-state is a dry-run proof mode; it never merges")
        return 2
    why = eligibility(info, any_state=any_state)
    scope = brief_scope(info)
    print(f"PR #{info['number']} {info['title']}" + (f"   [state {info.get('state')}, ignored for this proof]" if any_state else ""))
    print("ADDED:", ", ".join(info["_added"]) or "-")
    print("BRIEF SCOPE:", "MATCH" if scope["match"] else "NO MATCH", "-", scope["why"])
    print("--- PR body (read for INTENT against its brief) ---")
    print((info.get("body") or "").strip()[:4000])
    print("---")
    if why:
        print("NOT ELIGIBLE:")
        for w in why:
            print("  -", w)
        return 1
    print("ELIGIBLE")
    if "--merge" in argv:
        collect(info)
        print("COLLECTED + PR closed")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
