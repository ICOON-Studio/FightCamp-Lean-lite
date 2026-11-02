"""code_review.py - the independent reviewer for agent CODE PRs: Arena reads the diff against its brief (S249).

Tests miss intent: a PR can be green and still touch files it does not own, hard-code a result or quietly loosen a threshold. A second,
free agent (Arena, arena.ai - CLAUDE.md s8) gets the PR diff + its brief + a FIXED checklist and answers APPROVE or BLOCK. Claude reads
none of it unless the gate refuses. EVERYTHING SENT TO ARENA IS PUBLIC: the prompt holds only repo content (the brief from master and
the PR's diff) - never memory, handover, operator notes or secrets.

    python Tools/code_review.py prompt <pr>          # write AgentComms/reviews/PR<n>_<head8>.prompt.md (+ .json with the nonce)
    python Tools/code_review.py send <pr>            # prompt + Tools/arena/arena.py send (a NEW Arena chat; needs its Chrome on 9444)
    python Tools/code_review.py harvest              # Arena's review PRs -> verdict comment on the target PR, review PR closed
    python Tools/code_review.py verdict <pr>         # the verdict recorded for the PR's CURRENT head (APPROVE/BLOCK/NONE)
    python Tools/code_review.py record <pr> APPROVE|BLOCK --by claude|operator --note "<why>"   # a human/Claude verdict (exceptions)

How Arena answers: it may not change code; it adds ONE file AgentComms/reviews/PR<n>_<head8>.verdict.md (line 1 `VERDICT: APPROVE`
or `VERDICT: BLOCK`, line 2 `NONCE: <nonce>`, then one line per checklist item) on its own arena/* branch and opens a PR titled
`REVIEW PR #<n>`. `harvest` accepts it only if the nonce matches the one this PC generated (the reviewed agent cannot forge it) and
posts `REVIEW_VERDICT pr=<n> head=<sha> verdict=<v> reviewer=arena review_pr=<m>` on the target PR. `verdict` trusts that marker
only from the gh account this PC runs as.
"""
from __future__ import annotations

import json
import re
import secrets
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "Tools"))
import brief_contract  # noqa: E402

REPO = "ICOON-Studio/FightCamp-Lean"
REVIEWS = ROOT / "AgentComms" / "reviews"
MAX_DIFF_CHARS = 60_000  # a bigger diff is not reviewable in one Arena prompt: the gate sends it to Claude
VERDICT_RE = re.compile(r"REVIEW_VERDICT pr=(\d+) head=([0-9a-f]{40}) verdict=(APPROVE|BLOCK) reviewer=(\S+)")
CHECKLIST = [
    "SCOPE: the diff touches ONLY the files listed under OWNS in the brief's Contract (and, for a path:a-b window, only those lines).",
    "TESTS INTACT: no test file deleted; no check removed, skipped, commented out or made unreachable; no tolerance, threshold or "
    "expected value loosened or changed to match the output; no `quit(0)` before the checks run.",
    "NO HARD-CODED RESULTS: the code does not detect the test, special-case the test's seeds/names/inputs, or return the expected "
    "constants instead of computing them.",
    "MATCHES THE SPEC: the names, formulas, numbers and behaviour the brief specifies are what the code does; nothing outside the brief.",
    "SAFE: no new preload of a binary/LFS asset, no network, no file writes outside user://, no edits to tools, CI or gate scripts.",
]


def _run(*args: str, check: bool = True, input_: str | None = None) -> str:
    return subprocess.run(args, cwd=ROOT, check=check, capture_output=True, text=True, encoding="utf-8", input=input_).stdout


def _pr(pr: int) -> dict:
    return json.loads(_run("gh", "pr", "view", str(pr), "--repo", REPO, "--json", "number,title,body,headRefName,headRefOid,state"))


def _brief_text(task: str) -> str:
    """The brief as MASTER has it (an agent's branch cannot rewrite its own brief for the reviewer)."""
    return _run("git", "show", f"origin/master:research/TASK_{task}.md", check=False) or \
        brief_contract.brief_path(task).read_text(encoding="utf-8", errors="replace")


def _diff(info: dict) -> str:
    _run("git", "fetch", "-q", "origin", "master", f"refs/pull/{info['number']}/head")
    return _run("git", "diff", f"origin/master...{info['headRefOid']}")


def build_prompt(pr: int) -> tuple[Path, dict]:
    info = _pr(pr)
    task = brief_contract.task_for_pr(info["title"], info["body"], info["headRefName"])
    if not task:
        raise SystemExit(f"PR #{pr}: no brief found - nothing to review against")
    diff = _diff(info)
    if len(diff) > MAX_DIFF_CHARS:
        raise SystemExit(f"PR #{pr}: diff is {len(diff)} chars (> {MAX_DIFF_CHARS}) - too big for an Arena review; Claude reviews it")
    head8 = info["headRefOid"][:8]
    nonce = secrets.token_hex(8)
    verdict_path = f"AgentComms/reviews/PR{pr}_{head8}.verdict.md"
    checklist = "\n".join(f"{i}. {c}" for i, c in enumerate(CHECKLIST, 1))
    prompt = f"""You are an independent CODE REVIEWER for the repository ICOON-Studio/FightCamp (Godot 4.7 GDScript game).
Do NOT change any code. Your only output is ONE new file, then a PR.

Review pull request #{pr} ("{info['title']}") against its brief below, using exactly this checklist:
{checklist}

Write the file `{verdict_path}` with:
line 1: `VERDICT: APPROVE` (every item passes) or `VERDICT: BLOCK` (any item fails)
line 2: `NONCE: {nonce}`
then one line per checklist item: `<n>. PASS <one-line reason>` or `<n>. FAIL <file:line> <what is wrong>`.
Work on your own arena/ branch, commit only that file, push, and open a PR titled `REVIEW PR #{pr}`. Never merge anything.

===== BRIEF (research/TASK_{task}.md on master) =====
{_brief_text(task)}

===== DIFF (master...PR #{pr} head {info['headRefOid']}) =====
{diff}
"""
    REVIEWS.mkdir(parents=True, exist_ok=True)
    path = REVIEWS / f"PR{pr}_{head8}.prompt.md"
    path.write_text(prompt, encoding="utf-8")
    meta = {"pr": pr, "head": info["headRefOid"], "task": task, "nonce": nonce, "verdict_path": verdict_path,
            "prompt": str(path.relative_to(ROOT)).replace("\\", "/"), "created": time.strftime("%Y-%m-%dT%H:%M:%S"), "sent": False}
    (REVIEWS / f"PR{pr}_{head8}.json").write_text(json.dumps(meta, indent=1), encoding="utf-8")
    return path, meta


def send(pr: int) -> int:
    path, meta = build_prompt(pr)
    proc = subprocess.run([sys.executable, str(ROOT / "Tools" / "arena" / "arena.py"), "send", "--file", str(path)], cwd=ROOT,
                          capture_output=True, text=True)
    print(proc.stdout.strip() or proc.stderr.strip())
    meta["sent"] = proc.returncode == 0
    meta["send_rc"] = proc.returncode
    (REVIEWS / f"PR{pr}_{meta['head'][:8]}.json").write_text(json.dumps(meta, indent=1), encoding="utf-8")
    if proc.returncode:
        print(f"REVIEW NOT SENT (rc={proc.returncode}): paste {meta['prompt']} into a NEW Arena chat (built-in pane), or run "
              f"`python Tools/arena/arena.py launch` once on the PC")
    return proc.returncode


def _me() -> str:
    return _run("gh", "api", "user", "--jq", ".login").strip()


def _comment(pr: int, verdict: str, head: str, reviewer: str, extra: str) -> None:
    body = f"<!-- REVIEW_VERDICT -->\n```\nREVIEW_VERDICT pr={pr} head={head} verdict={verdict} reviewer={reviewer}{extra}\n```"
    _run("gh", "pr", "comment", str(pr), "--repo", REPO, "--body", body)


def harvest() -> int:
    """Open review PRs from Arena -> verdict markers on their target PRs (nonce-checked), then close the review PR."""
    prs = json.loads(_run("gh", "pr", "list", "--repo", REPO, "--state", "open", "--json", "number,title,headRefName,headRefOid,files"))
    done = 0
    for p in prs:
        files = [f["path"] for f in p.get("files", [])]
        m = re.match(r"REVIEW PR #(\d+)", p["title"])
        if not m or len(files) != 1 or not re.fullmatch(r"AgentComms/reviews/PR\d+_[0-9a-f]{8}\.verdict\.md", files[0]):
            continue
        target = int(m.group(1))
        meta_path = REVIEWS / Path(files[0]).name.replace(".verdict.md", ".json")
        meta = json.loads(meta_path.read_text(encoding="utf-8")) if meta_path.is_file() else {}
        _run("git", "fetch", "-q", "origin", f"refs/pull/{p['number']}/head")
        text = _run("git", "show", f"{p['headRefOid']}:{files[0]}", check=False)
        v = re.search(r"^\s*VERDICT:\s*(APPROVE|BLOCK)\b", text, re.M)
        n = re.search(r"^\s*NONCE:\s*([0-9a-f]+)", text, re.M)
        if not meta or not v or not n or n.group(1) != meta.get("nonce") or meta.get("pr") != target:
            why = "no local review record" if not meta else "no VERDICT line" if not v else "nonce mismatch"
            print(f"review PR #{p['number']} for #{target}: REJECTED ({why})")
            _run("gh", "pr", "close", str(p["number"]), "--repo", REPO, "--comment", f"Review not accepted by code_review.py: {why}.")
            continue
        _comment(target, v.group(1), meta["head"], "arena", f" review_pr={p['number']}")
        _run("gh", "pr", "comment", str(target), "--repo", REPO, "--body", "Arena review (verbatim):\n```\n" + text[:6000] + "\n```")
        _run("gh", "pr", "close", str(p["number"]), "--repo", REPO, "--comment", f"Verdict {v.group(1)} recorded on #{target}.")
        meta["verdict"] = v.group(1)
        meta_path.write_text(json.dumps(meta, indent=1), encoding="utf-8")
        print(f"review PR #{p['number']}: {v.group(1)} recorded on #{target}")
        done += 1
    print(f"CODE_REVIEW harvested={done}")
    return 0


def verdict_for(pr: int, head: str, comments: list[dict] | None = None, me: str | None = None) -> tuple[str, str]:
    """(APPROVE|BLOCK|NONE, reviewer) for this exact head, newest trusted marker wins."""
    if comments is None:
        comments = json.loads(_run("gh", "pr", "view", str(pr), "--repo", REPO, "--json", "comments"))["comments"]
    me = me or _me()
    found = ("NONE", "-")
    for c in comments:
        if (c.get("author") or {}).get("login") != me:
            continue
        for m in VERDICT_RE.finditer(c.get("body") or ""):
            if int(m.group(1)) == pr and m.group(2) == head:
                found = (m.group(3), m.group(4))
    return found


def main(argv: list[str]) -> int:
    cmd = argv[1] if len(argv) > 1 else ""
    if cmd == "prompt" and len(argv) > 2:
        path, meta = build_prompt(int(argv[2]))
        print(f"prompt {path} ({path.stat().st_size} bytes) nonce stored in {meta['prompt'].replace('.prompt.md', '.json')}")
        return 0
    if cmd == "send" and len(argv) > 2:
        return send(int(argv[2]))
    if cmd == "harvest":
        return harvest()
    if cmd == "verdict" and len(argv) > 2:
        info = _pr(int(argv[2]))
        v, who = verdict_for(info["number"], info["headRefOid"])
        print(f"REVIEW pr={info['number']} head={info['headRefOid'][:10]} verdict={v} reviewer={who}")
        return 0 if v == "APPROVE" else 1
    if cmd == "record" and len(argv) > 3 and argv[3] in ("APPROVE", "BLOCK"):
        by = argv[argv.index("--by") + 1] if "--by" in argv else "claude"
        note = argv[argv.index("--note") + 1] if "--note" in argv else ""
        info = _pr(int(argv[2]))
        _comment(info["number"], argv[3], info["headRefOid"], by, "")
        if note:
            _run("gh", "pr", "comment", argv[2], "--repo", REPO, "--body", f"Review note ({by}): {note}")
        print(f"recorded {argv[3]} by {by} for #{argv[2]} head {info['headRefOid'][:10]}")
        return 0
    print(__doc__)
    return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv))
