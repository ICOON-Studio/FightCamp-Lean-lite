"""brief_contract.py - the machine-readable contract every agent brief carries (S249, the code-PR lane).

Operator S249 (asked how to stop Claude being the bottleneck on agent PRs). Decision: review moves to BRIEF time. The brief names the
files the agent may touch, the test that is red on master and must turn green, and the regression set CI runs; machines check the
merge against that (Tools/code_gate.py). A brief without this block cannot be merged unattended.

The block, anywhere in research/TASK_<id>.md (one key per line; OWNS may repeat or list several paths with commas):

    ## Contract
    OWNS: Godot/scripts/rules/FightLink.gd, Godot/tests/fight_link_test.gd
    OWNS: Godot/scripts/FightRealtime.gd:1200-1350        # optional line window (master's numbering) - edits must stay inside
    RED_TEST: tests/fight_link_test.gd -> FIGHT_LINK failures=0
    REGRESSION: fight_link_test, fight_identity_test       # run_tests.py --only substrings (each must match a test)
    VISUAL: no                                             # yes = body/animation/look/camera: never auto-merged (visual-gate)

    python Tools/brief_contract.py check [TASK_ID|path ...]   # validate (no args: every brief the `start` flag covers)
    python Tools/brief_contract.py show <TASK_ID>             # the parsed contract as JSON
    python Tools/brief_contract.py for-pr <pr>                # which brief a PR belongs to + its contract (JSON)

Rules a contract must meet: every OWNS path under Godot/ and never a gate/tooling file; RED_TEST names a Godot/tests/*_test.gd that is
in OWNS or exists on master, with its exact pass line; every REGRESSION substring matches at least one test (master or OWNS) and no
matched test loads a Git-LFS file directly (CI checks out without LFS). Stdlib only.
"""
from __future__ import annotations

import functools
import json
import os
import re
import subprocess
import sys
from pathlib import Path

## FIGHTCAMP_ROOT: CI runs a copy of these tools taken from master (/tmp/gate) against the checkout - a PR cannot swap the gate.
ROOT = Path(os.environ.get("FIGHTCAMP_ROOT") or Path(__file__).resolve().parent.parent)
RESEARCH = ROOT / "research"
TESTS = ROOT / "Godot" / "tests"
REPO = "ICOON-Studio/FightCamp-Lean"
## Briefs written from this date on must carry the block (`start` flags them); older ones are backfilled when re-used.
CONTRACT_FROM_DATE = "2026-10-18"
## Never merged by a machine, whatever a brief says: the gates themselves and the rules the gates read.
PROTECTED = ("Tools/", ".github/", ".claude/", "Godot/tools/run_tests.py", "Godot/tools/check_scripts.py", "Godot/tools/still_framing.gd",
             "CLAUDE.md", "AGENTS.md", "RTK.md", "Godot/project.godot", "Godot/export_presets.cfg")

_BLOCK_RE = re.compile(r"^##\s*Contract\b[^\n]*\n(.*?)(?=^##\s|\Z)", re.M | re.S | re.I)
_KEY_RE = re.compile(r"^\s*[-*]?\s*`?(OWNS|RED_TEST|REGRESSION|VISUAL)`?\s*:\s*(.*?)\s*$", re.M)
_WINDOW_RE = re.compile(r"^(.+?):(\d+)-(\d+)$")
_RESPATH_RE = re.compile(r"res://([A-Za-z0-9_./ -]+?\.[A-Za-z0-9]+)")
TASK_FILE_RE = re.compile(r"\bTASK_([A-Za-z0-9_]+?)\.md\b")
TASK_LINE_RE = re.compile(r"^\s*TASK:\s*`?([A-Za-z0-9_]+)`?\s*$", re.M)
TITLE_ID_RE = re.compile(r"\b([A-Z][A-Z0-9]{2,}\d[A-Z0-9]*)\b")


def _norm(path: str) -> str:
    path = path.strip().strip("`").replace("\\", "/")
    if path.startswith("res://"):
        path = "Godot/" + path[len("res://"):]
    if not path.startswith("Godot/") and path.split("/", 1)[0] in ("scripts", "tests", "research", "tools", "assets", "scenes"):
        path = "Godot/" + path
    return path


def brief_path(task: str) -> Path:
    task = task.strip()
    if task.endswith(".md") or "/" in task or "\\" in task:
        return Path(task) if Path(task).is_absolute() else ROOT / task
    return RESEARCH / f"TASK_{task.removeprefix('TASK_')}.md"


def parse(text: str) -> dict | None:
    """The `## Contract` block as {owns: [{path, windows}], red_test: {test, pass_line}, regression: [..], visual: bool} or None."""
    m = _BLOCK_RE.search(text)
    if not m:
        return None
    owns: dict[str, list[list[int]]] = {}
    red, regression, visual, seen = None, [], None, set()
    for key, value in _KEY_RE.findall(m.group(1)):
        value = re.sub(r"\s+#.*$", "", value).strip()
        seen.add(key)
        if key == "OWNS":
            for item in (v.strip() for v in value.split(",")):
                if not item:
                    continue
                item = re.sub(r"\s*\((?:new|edit|edited|append[^)]*)\)$", "", item.strip("`"), flags=re.I)
                w = _WINDOW_RE.match(item)
                path, window = (_norm(w.group(1)), [int(w.group(2)), int(w.group(3))]) if w else (_norm(item), None)
                owns.setdefault(path, [])
                if window:
                    owns[path].append(window)
        elif key == "RED_TEST":
            t, _, line = value.partition("->")
            red = {"test": _norm(t.strip().strip("`")), "pass_line": line.strip().strip("`")}
        elif key == "REGRESSION":
            regression += [s.strip().strip("`") for s in value.split(",") if s.strip().strip("`")]
        elif key == "VISUAL":
            visual = value.lower().startswith(("y", "true", "1"))
    return {"owns": [{"path": p, "windows": w} for p, w in owns.items()], "red_test": red, "regression": regression,
            "visual": visual, "keys": sorted(seen)}


@functools.lru_cache(maxsize=1)
def _master_tests() -> tuple[str, ...]:
    return tuple(sorted(p.name for p in TESTS.glob("*_test.gd")))  # S301: listed once per process (was 452 globs per `start`)


def matched_tests(substring: str, extra: list[str] = ()) -> list[str]:
    """What `run_tests.py --only <substring>` would run: every Godot/tests/*_test.gd whose name holds the substring."""
    names = set(_master_tests()) | {Path(e).name for e in extra if e.startswith("Godot/tests/") and e.endswith("_test.gd")}
    return sorted(n for n in names if substring in n)


## S301 (operator: "starting orientation went up again from 10 seconds"): one `git check-attr` per test cost ~40 ms on
## Windows and `start` checked 230 of them (8.8 s, growing with every brief). Every test's refs now go through ONE
## `git check-attr --stdin` call, cached per test for the rest of the process.
_LFS_CACHE: dict[str, list[str]] = {}


def _lfs_prime(test_names) -> None:
    refs_by_test = {}
    for name in {n for n in test_names if n not in _LFS_CACHE}:
        src = TESTS / name
        text = src.read_text(encoding="utf-8", errors="replace") if src.is_file() else ""
        refs_by_test[name] = sorted({"Godot/" + r for r in _RESPATH_RE.findall(text)})
    every = sorted({r for refs in refs_by_test.values() for r in refs})
    lfs = set()
    if every:
        ## -z: NUL-separated both ways (text mode on Windows turns "\n" into "\r\n" and git then checks "path\r")
        out = subprocess.run(["git", "check-attr", "-z", "--stdin", "filter"], cwd=ROOT,
                             input="\0".join(every).encode("utf-8") + b"\0", capture_output=True).stdout
        parts = out.decode("utf-8", errors="replace").split("\0")
        lfs = {parts[i] for i in range(0, len(parts) - 2, 3) if parts[i + 2] == "lfs"}
    for name, refs in refs_by_test.items():
        _LFS_CACHE[name] = [r for r in refs if r in lfs]


def lfs_refs(test_name: str) -> list[str]:
    """res:// files a test names directly that Git LFS stores (CI has pointers, not files). Indirect loads are caught in CI's report."""
    if test_name not in _LFS_CACHE:
        _lfs_prime([test_name])
    return _LFS_CACHE[test_name]


def validate(contract: dict | None) -> list[str]:
    if contract is None:
        return ["no '## Contract' block (OWNS / RED_TEST / REGRESSION / VISUAL)"]
    why = []
    for key in ("OWNS", "RED_TEST", "REGRESSION", "VISUAL"):
        if key not in contract["keys"]:
            why.append(f"missing {key}:")
    owned = [o["path"] for o in contract["owns"]]
    for o in contract["owns"]:
        p = o["path"]
        if not p.startswith("Godot/"):
            why.append(f"OWNS {p}: outside Godot/")
        if p.startswith(PROTECTED) or p in PROTECTED:
            why.append(f"OWNS {p}: a gate/tooling file is never merged by a machine")
        for a, b in o["windows"]:
            if a < 1 or b < a:
                why.append(f"OWNS {p}:{a}-{b}: bad line window")
    red = contract.get("red_test")
    if red:
        t = red["test"]
        if not (t.startswith("Godot/tests/") and t.endswith("_test.gd")):
            why.append(f"RED_TEST {t}: not a Godot/tests/*_test.gd")
        elif t not in owned and not (ROOT / t).is_file():
            why.append(f"RED_TEST {t}: neither in OWNS nor on master")
        if not red["pass_line"]:
            why.append("RED_TEST has no '-> <exact pass line>'")
    for sub in contract.get("regression") or []:
        if sub.lower() == "none":
            why.append("REGRESSION 'none' - name at least the systems the change touches (run_tests --only substrings)")
            continue
        hits = matched_tests(sub, owned)
        if not hits:
            why.append(f"REGRESSION '{sub}': matches no test")
        elif len(hits) > 40:
            why.append(f"REGRESSION '{sub}': matches {len(hits)} tests - too broad for one CI run (Actions budget)")
        for h in hits:
            lfs = lfs_refs(h)
            if lfs:
                why.append(f"REGRESSION '{sub}' -> {h} loads LFS files ({lfs[0]}...) - CI has no LFS; run it locally, not here")
    return why


def check_brief(task: str) -> tuple[dict | None, list[str]]:
    path = brief_path(task)
    if not path.is_file():
        return None, [f"{path.name}: no such brief"]
    contract = parse(path.read_text(encoding="utf-8", errors="replace"))
    return contract, validate(contract)


def briefs_needing_contract() -> list[str]:
    """Briefs added on/after CONTRACT_FROM_DATE (git) or not committed yet, minus cancelled/done ones - the set `start` flags."""
    out = subprocess.run(["git", "log", f"--since={CONTRACT_FROM_DATE}T00:00:00", "--diff-filter=A", "--name-only", "--format=",
                          "--", "research/TASK_*.md"], cwd=ROOT, capture_output=True, text=True).stdout.split()
    out += subprocess.run(["git", "ls-files", "--others", "--exclude-standard", "--", "research/TASK_*.md"], cwd=ROOT,
                          capture_output=True, text=True).stdout.split()
    names = {Path(p).name for p in out if (ROOT / p).is_file()}
    ## S366: the move into Lean/ops 'added' every old brief at once; the old repo's own dates decide for those (frozen list).
    try:
        moved = json.loads((RESEARCH / "_contract_moved.json").read_text(encoding="utf-8"))
        names = (names - set(moved["moved"])) | {n for n in moved["dated_on_or_after_cutoff"] if (RESEARCH / n).is_file()}
    except (OSError, ValueError, KeyError):
        pass
    names = sorted(names)
    keep = []
    for n in names:
        text = (RESEARCH / n).read_text(encoding="utf-8", errors="replace")
        if re.search(r"^Status:\s*(CANCELLED|DONE|SUPERSEDED)", text, re.M):
            continue
        if re.search(r"^Kind:\s*research\b", text, re.M):  # S259: review/research briefs carry no code, nothing to merge
            continue
        keep.append(n)
    return keep


def defects() -> list[str]:
    """For agent_comms start: one line per brief that must carry a valid contract and does not."""
    bad = []
    names = briefs_needing_contract()
    hits = set()
    for n in names:
        contract = parse((RESEARCH / n).read_text(encoding="utf-8", errors="replace"))
        if contract:
            owned = [o["path"] for o in contract["owns"]]
            for sub in contract.get("regression") or []:
                if sub.lower() != "none":
                    hits.update(matched_tests(sub, owned))
    _lfs_prime(hits)
    for n in names:
        _, why = check_brief(n[len("TASK_"):-3])
        if why:
            bad.append(f"{n} ({why[0]}{' +%d more' % (len(why) - 1) if len(why) > 1 else ''})")
    return bad


def task_for_pr(title: str, body: str, branch: str = "") -> str:
    """The brief a PR belongs to: a `TASK: <id>` line, else TASK_<id>.md named in body/title, else an id in the title/branch."""
    ids = TASK_LINE_RE.findall(body or "") + TASK_FILE_RE.findall(body or "") + TASK_FILE_RE.findall(title or "")
    ids += TITLE_ID_RE.findall(title or "") + TITLE_ID_RE.findall((branch or "").upper().replace("-", " ").replace("/", " "))
    return next((t for t in ids if brief_path(t).is_file()), "")


def main(argv: list[str]) -> int:
    cmd = argv[1] if len(argv) > 1 else ""
    if cmd == "check":
        tasks = argv[2:] or [n[len("TASK_"):-3] for n in briefs_needing_contract()]
        fails = 0
        for t in tasks:
            _, why = check_brief(t)
            name = brief_path(t).name
            if why:
                fails += 1
                print(f"CONTRACT FAIL {name}")
                for w in why:
                    print(f"  - {w}")
            else:
                print(f"CONTRACT OK   {name}")
        print(f"BRIEF_CONTRACT checked={len(tasks)} fails={fails}")
        return 1 if fails else 0
    if cmd == "show" and len(argv) > 2:
        contract, why = check_brief(argv[2])
        print(json.dumps({"contract": contract, "problems": why}, indent=2))
        return 1 if why else 0
    if cmd == "for-pr" and len(argv) > 2:
        info = json.loads(subprocess.run(["gh", "pr", "view", argv[2], "--repo", REPO, "--json", "title,body,headRefName"],
                                         cwd=ROOT, capture_output=True, text=True, check=True).stdout)
        task = task_for_pr(info["title"], info["body"], info["headRefName"])
        contract, why = check_brief(task) if task else (None, ["no brief found for the PR"])
        print(json.dumps({"task": task, "contract": contract, "problems": why}, indent=2))
        return 1 if why else 0
    print(__doc__)
    return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv))
