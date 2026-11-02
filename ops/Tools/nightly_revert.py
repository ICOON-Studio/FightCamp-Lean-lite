"""nightly_revert.py - the safety net under unattended merges (S249): a test the nightly newly sees red, touched by a commit that
Tools/code_gate.py auto-merged since the previous night, gets that commit reverted on master.

    python Tools/nightly_revert.py              # what tonight's suite says, and what it WOULD revert (always safe)
    python Tools/nightly_revert.py --apply      # revert + push + reopen the task + a line on the ops board (only when armed)
    python Tools/nightly_revert.py status       # mode, nights seen, last decisions
    python Tools/nightly_revert.py arm --operator-said "<verbatim>"   # real reverts on (needs one clean dry night first)

Run by Tools/nightly_suite.cmd right after latest.txt is written. DRY RUN FIRST (the brief): the state file
AgentComms/nightly_revert.json starts in mode "dry-run" and STAYS there (operator S249: "Push, merge off"): every night records what it
WOULD revert. It is armed only by `python Tools/nightly_revert.py arm --operator-said "<verbatim>"`, refused before one clean dry night
(both suite logs had a SUITE line, nothing crashed). `--apply` while not armed only prints.

Newly red = FAIL in tonight's suite_<date>.log, PASS (or absent) in the previous night's log that has a SUITE line (an ABORTED night is
skipped - its FAIL list is partial). Touched = the auto-merged commit (trailer `Auto-merged-by: code_gate`, between the two nights'
head_<date>.txt commits) changed the test file itself, or a file the test names (res:// path or class_name), or the test matches the
commit's `Regression:` / RED_TEST names. A revert that does not apply cleanly is NOT forced: it is reported for Claude.
"""
from __future__ import annotations

import json
import re
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
NIGHTLY = ROOT / "AgentComms" / "nightly"
STATE = ROOT / "AgentComms" / "nightly_revert.json"
ROADMAP = ROOT / "AgentComms" / "roadmap.json"
TESTS = ROOT / "Godot" / "tests"
TRAILER = "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
MERGED_TRAILER = "Auto-merged-by: code_gate"
FAIL_RE = re.compile(r"^\[\s*\d+/\d+\]\s+FAIL\s+(\S+\.gd)", re.M)


def _git(*args: str, check: bool = True) -> str:
    return subprocess.run(["git", *args], cwd=ROOT, check=check, capture_output=True, text=True, encoding="utf-8").stdout


def nights() -> list[dict]:
    """Every night with a complete suite log, newest first: {date, head, fails:set}."""
    out = []
    for log in sorted(NIGHTLY.glob("suite_*.log"), reverse=True):
        date = log.stem[len("suite_"):]
        text = log.read_text(encoding="utf-8", errors="replace")
        if not re.search(r"^SUITE total=\d+ fails=\d+", text, re.M):
            continue  # ABORTED - partial FAIL list, never a comparison point
        head_file = NIGHTLY / f"head_{date}.txt"
        head = head_file.read_text(encoding="utf-8-sig", errors="replace").strip() if head_file.is_file() else ""
        out.append({"date": date, "head": head, "fails": set(FAIL_RE.findall(text))})
    return out


def auto_merged(since: str, until: str) -> list[dict]:
    """Commits between two nightly heads that carry the code_gate trailer."""
    if not since or not until:
        return []
    raw = _git("log", "--format=%H%x1f%B%x1e", f"{since}..{until}", check=False)
    found = []
    for rec in raw.split("\x1e"):
        if MERGED_TRAILER not in rec:
            continue
        sha, _, body = rec.strip().partition("\x1f")
        files = [f for f in _git("show", "--name-only", "--format=", sha).splitlines() if f]
        meta = dict(re.findall(r"^(Task|PR|Regression):\s*(.+)$", body, re.M))
        found.append({"sha": sha, "files": files, "task": meta.get("Task", "").strip(), "pr": meta.get("PR", "").strip(),
                      "regression": [s.strip() for s in meta.get("Regression", "").split(",") if s.strip()]})
    return found


def touches(commit: dict, test: str) -> str:
    """Why this commit is implicated in this test going red ('' = it is not)."""
    path = f"Godot/tests/{test}"
    if path in commit["files"]:
        return "changed the test itself"
    if any(sub and sub in test for sub in commit["regression"]):
        return "the test is in the commit's REGRESSION set"
    src = (TESTS / test).read_text(encoding="utf-8", errors="replace") if (TESTS / test).is_file() else ""
    for f in commit["files"]:
        if not f.startswith("Godot/"):
            continue
        if "res://" + f[len("Godot/"):] in src:
            return f"the test loads {f}"
        if f.endswith(".gd"):
            text = (ROOT / f).read_text(encoding="utf-8", errors="replace") if (ROOT / f).is_file() else ""
            m = re.search(r"^class_name\s+(\w+)", text, re.M)
            if m and re.search(r"\b%s\b" % re.escape(m.group(1)), src):
                return f"the test uses class {m.group(1)} ({f})"
    return ""


def _state() -> dict:
    try:
        return json.loads(STATE.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return {"mode": "dry-run", "clean_dry_nights": 0, "nights": []}


def _board_line(title: str, ident: str) -> None:
    """One line at the top of the ops board's done_recently (the board reads roadmap.json; the file is left for the next commit)."""
    try:
        data = json.loads(ROADMAP.read_text(encoding="utf-8"))
        data.setdefault("plan", {}).setdefault("done_recently", []).insert(
            0, {"title": title, "who": "nightly_revert", "when": time.strftime("%Y-%m-%d"), "id": ident})
        ROADMAP.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    except (OSError, ValueError) as exc:
        print(f"board line not written: {exc}")


def _reopen(task: str, why: str) -> bool:
    try:
        data = json.loads(ROADMAP.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return False
    hit = False
    for row in (data.get("queue") or {}).get("tasks") or []:
        rid = str(row.get("id", ""))
        if rid and (rid == task or task.startswith(rid)):
            row["id"] = re.sub(r"^(DONE|SUPERSEDED)[ _-]*", "", rid)
            row["state"] = f"[REOPENED {time.strftime('%Y-%m-%d')} by nightly_revert: {why}] " + str(row.get("state", ""))
            hit = True
    if hit:
        ROADMAP.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    return hit


def run(apply: bool) -> int:
    st = _state()
    ns = nights()
    if len(ns) < 2:
        print(f"NIGHTLY_REVERT need two complete nights, have {len(ns)}")
        return 0
    tonight, prev = ns[0], ns[1]
    newly = sorted(tonight["fails"] - prev["fails"])
    commits = auto_merged(prev["head"], tonight["head"])
    plan = []
    for c in commits:
        hits = [(t, why) for t in newly if (why := touches(c, t))]
        if hits:
            plan.append((c, hits))
    print(f"NIGHTLY_REVERT tonight={tonight['date']}@{tonight['head']} prev={prev['date']}@{prev['head']} mode={st['mode']}")
    print(f"  newly red ({len(newly)}): {', '.join(newly) or '-'}")
    print(f"  auto-merged since the previous night ({len(commits)}): {', '.join(c['sha'][:10] + ' ' + c['task'] for c in commits) or '-'}")
    for c, hits in plan:
        print(f"  WOULD REVERT {c['sha'][:10]} (TASK {c['task'] or '?'}, PR {c['pr'] or '?'}): " +
              "; ".join(f"{t} - {why}" for t, why in hits))
    if not plan:
        print("  nothing to revert")
    armed = st["mode"] == "armed"
    done = []
    if apply and armed:
        for c, hits in plan:
            why = f"{hits[0][0]} newly red on the {tonight['date']} nightly ({hits[0][1]})"
            proc = subprocess.run(["git", "revert", "--no-edit", c["sha"]], cwd=ROOT, capture_output=True, text=True)
            if proc.returncode:
                subprocess.run(["git", "revert", "--abort"], cwd=ROOT, capture_output=True)
                print(f"  REVERT FAILED {c['sha'][:10]} (not clean - Claude): {proc.stderr.strip()[:200]}")
                _board_line(f"Nightly could not auto-revert {c['sha'][:10]} (TASK {c['task']}): {why} - Claude", f"REVERT-{c['task']}")
                continue
            msg = _git("log", "-1", "--format=%B")
            subprocess.run(["git", "commit", "--amend", "-q", "-F", "-"], cwd=ROOT, check=True, text=True,
                           input=f"{msg.strip()}\n\nnightly_revert: {why}.\n\n{TRAILER}\n")
            push = subprocess.run(["git", "push", "-q", "origin", "master"], cwd=ROOT, capture_output=True, text=True)
            print(f"  REVERTED {c['sha'][:10]} -> {_git('rev-parse', '--short', 'HEAD').strip()} push rc={push.returncode}")
            reopened = _reopen(c["task"], why) if c["task"] else False
            _board_line(f"Nightly auto-reverted TASK {c['task'] or '?'} (PR {c['pr'] or '?'}): {why}" +
                        ("" if reopened else " - task not found in the queue"), f"REVERT-{c['task']}")
            done.append(c["sha"])
    elif apply:
        print("  (not armed: dry run only - armed only on the operator's yes, after one clean dry night)")
    entry = {"date": tonight["date"], "prev": prev["date"], "newly_red": newly, "auto_merged": [c["sha"] for c in commits],
             "would_revert": [c["sha"] for c, _ in plan], "reverted": done, "mode": st["mode"], "at": time.strftime("%Y-%m-%dT%H:%M:%S")}
    if not apply:
        return 0  # a hand-run dry run never counts as a night (only the nightly's own `--apply` call does)
    if not any(n.get("date") == tonight["date"] and n.get("mode") == st["mode"] for n in st["nights"]):
        st["nights"].append(entry)
        if st["mode"] == "dry-run":
            st["clean_dry_nights"] = st.get("clean_dry_nights", 0) + 1
    st["nights"] = st["nights"][-30:]
    STATE.write_text(json.dumps(st, indent=1), encoding="utf-8")
    return 0


def main(argv: list[str]) -> int:
    if argv[1:2] == ["status"]:
        print(json.dumps(_state(), indent=1))
        return 0
    if argv[1:2] == ["arm"]:
        said = argv[argv.index("--operator-said") + 1] if "--operator-said" in argv else ""
        st = _state()
        if not said.strip() or st.get("clean_dry_nights", 0) < 1:
            print("REFUSED: arming needs one clean dry night AND --operator-said \"<his words, verbatim>\"")
            return 1
        st.update(mode="armed", armed_by=said, armed_at=time.strftime("%Y-%m-%dT%H:%M:%S"))
        STATE.write_text(json.dumps(st, indent=1), encoding="utf-8")
        _board_line(f"Nightly auto-revert ARMED (operator: \"{said}\")", "REVERT-ARMED")
        print("ARMED")
        return 0
    if argv[1:2] and argv[1] not in ("--apply",):
        print(__doc__)
        return 2
    return run("--apply" in argv)


if __name__ == "__main__":
    sys.exit(main(sys.argv))
