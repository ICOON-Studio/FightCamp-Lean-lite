"""brief_contract.py - the machine-readable contract every agent brief carries (S249, the code-PR lane; Lean layout S368).

Operator S249 (asked how to stop Claude being the bottleneck on agent PRs). Decision: review moves to BRIEF time. The brief names the
files the agent may touch, the test that is red on main and must turn green, and the regression set; machines check the merge
against that (Tools/code_gate.py) and Tools/seat_dispatch.py launches a CLI seat only on a brief whose contract is valid.

The block, anywhere in ops/research/TASK_<id>.md (one key per line; a key's value may wrap onto the next lines; OWNS may list
several paths with commas; a (parenthesised note) anywhere is ignored):

    ## Contract
    OWNS: scripts/rules/FightLink.gd, tests/fight_link_test.gd      # Lean/scripts/.., res://.. and scripts/.. are the same path
    OWNS: scripts/fight3d/FightStage.gd:120-180                      # optional line window (main's numbering) - edits stay inside
    OWNS: docs/playtest/tells/                                       # a folder owns everything under it
    RED_TEST: tests/fight_link_test.gd -> FIGHT_LINK failures=0      # or a probe: tools/x_probe.gd [-- args] [-> line]
    REGRESSION: fight_link_test, golden_path_test, clinch_check      # tests/*_test.gd substrings, tools/<probe> names, run_tests.sh
    VISUAL: no                                                       # yes / a film path = body/animation/look: never auto-merged
    FILM: --resolution 1280x720 --script res://tools/ref_break_probe.gd   # optional: how seat_dispatch films before/after
    BASE: agy/fight9r1                                               # optional (S371): start from this branch, not origin/main
    LOOP: FIGHT9 9                                                   # optional (S371): queue round n+1 until Argon gives 9/10

    python ops/Tools/brief_contract.py check [TASK_ID|path ...]   # validate (no args: every brief the `start` flag covers)
    python ops/Tools/brief_contract.py show <TASK_ID>             # the parsed contract as JSON
    python ops/Tools/brief_contract.py for-pr <pr>                # which brief a PR belongs to + its contract (JSON)
    python ops/Tools/brief_contract.py selftest                   # Lean + old-path fixtures (no network)

Rules a contract must meet (S368, Lean: the game is the repo root): every OWNS path under scripts/ tests/ tools/ assets/ scenes/
docs/ and never a gate/tooling file (PROTECTED); RED_TEST names a tests/*_test.gd or a tools/*.gd probe that is in OWNS or on main
(its `-> pass line` is optional: without one the script's exit code decides, as tools/run_tests.sh does); every REGRESSION item
names run_tests.sh, a tools/<name>.gd probe, or a substring matching 1-40 tests/*_test.gd, and no matched test loads a Git-LFS
file directly. A brief moved from the archived old repo whose OWNS sit under its `Godot/` folder (plus its research/ notes) is
archived work: `start` skips it. Stdlib only.
"""
from __future__ import annotations

import functools
import json
import os
import re
import subprocess
import sys
from pathlib import Path

## FIGHTCAMP_ROOT: CI runs a copy of these tools taken from main against the checkout - a PR cannot swap the gate.
ROOT = Path(os.environ.get("FIGHTCAMP_ROOT") or Path(__file__).resolve().parent.parent)  # ops/
## S366 one repo: the game is the repo root, ops/ sits inside it.
GAME = Path(os.environ.get("FIGHTCAMP_GAME") or ROOT.parent)
RESEARCH = ROOT / "research"
TESTS = GAME / "tests"
REPO = "ICOON-Studio/FightCamp-Lean"
## Briefs written from this date on must carry the block (`start` flags them); older ones are backfilled when re-used.
CONTRACT_FROM_DATE = "2026-10-18"
## Where a contract may own files (repo-root relative).
GAME_DIRS = ("scripts/", "tests/", "tools/", "assets/", "scenes/", "docs/")
## Never merged by a machine, whatever a brief says: the gates themselves and the rules the gates read.
PROTECTED = ("ops/", ".github/", ".claude/", "addons/", "tools/run_tests.sh", "tools/export.sh", "tools/hidden_desktop.py",
             "project.godot", "export_presets.cfg", "CLAUDE.md", "AGENTS.md", "RTK.md", "NEXT_SESSION_PROMPT.md")
## The archived old repo's game folder (ICOON-Studio/FightCamp): a path under it is not in this repo.
OLD_GAME = "Godot/"

_BLOCK_RE = re.compile(r"^##\s*Contract\b[^\n]*\n(.*?)(?=^##\s|\Z)", re.M | re.S | re.I)
KEYS = ("OWNS", "RED_TEST", "REGRESSION", "VISUAL", "FILM", "BASE", "LOOP")
## S368: Lean briefs write `REGRESSION (Lean tests; ...): a, b` - a note between the key and its colon.
_KEY_RE = re.compile(r"^\s*[-*]?\s*`?(OWNS|RED_TEST|REGRESSION|VISUAL|FILM|BASE|LOOP)`?\s*(?:\([^)\n]*\))?\s*:\s*(.*?)\s*$")
_WINDOW_RE = re.compile(r"^(.+?):(\d+)-(\d+)$")
_RESPATH_RE = re.compile(r"res://([A-Za-z0-9_./ -]+?\.[A-Za-z0-9]+)")
_FILM_RE = re.compile(r"[A-Za-z0-9_./\\:-]+\.mp4\b")
_SUITE_RE = re.compile(r"(^|[\s/])run_tests\.sh\b")
TASK_FILE_RE = re.compile(r"\bTASK_([A-Za-z0-9_]+?)\.md\b")
TASK_LINE_RE = re.compile(r"^\s*TASK:\s*`?([A-Za-z0-9_]+)`?\s*$", re.M)
TITLE_ID_RE = re.compile(r"\b([A-Z][A-Z0-9]{2,}\d[A-Z0-9]*)\b")


def _norm(path: str) -> str:
    """One spelling for a game path: repo-root relative (scripts/x.gd). Lean/x, res://x, ./x and E:/FightCamp/Lean/x are x;
    a path under the archived old repo's Godot/ folder keeps its prefix (it is not in this repo)."""
    path = path.strip().strip("`'\"").replace("\\", "/")
    for prefix in ("res://", "./"):
        if path.startswith(prefix):
            path = path[len(prefix):]
    path = re.sub(r"^[A-Za-z]:/FightCamp/(?:Lean|wt/[^/]+)/", "", path)
    if path.startswith("Lean/"):
        path = path[len("Lean/"):]
    return path


def _drop_notes(text: str) -> str:
    """The value without its (parenthesised notes), nested ones included."""
    out, depth = [], 0
    for ch in text:
        if ch == "(":
            depth += 1
        elif ch == ")" and depth:
            depth -= 1
        elif not depth:
            out.append(ch)
    return re.sub(r"\s+", " ", "".join(out)).strip()


def brief_path(task: str) -> Path:
    task = task.strip()
    if task.endswith(".md") or "/" in task or "\\" in task:
        p = Path(task)
        return p if p.is_absolute() else (ROOT / task if (ROOT / task).is_file() else GAME / task)
    return RESEARCH / f"TASK_{task.removeprefix('TASK_')}.md"


def _values(block: str) -> list[tuple[str, str]]:
    """(key, value) pairs; a non-key line right under a key continues its value (Lean briefs wrap long OWNS lists)."""
    pairs: list[list[str]] = []
    for line in block.splitlines():
        m = _KEY_RE.match(line)
        if m:
            pairs.append([m.group(1), m.group(2)])
        elif line.strip() and pairs:
            pairs[-1][1] += " " + line.strip()
        elif not line.strip() and pairs:
            pairs.append(["", ""])  # a blank line ends the value
    return [(k, re.sub(r"\s+#.*$", "", v).strip()) for k, v in pairs if k]


def _red_test(value: str) -> dict:
    """`tests/x_test.gd -> LINE`, `tools/x_probe.gd -- a=1 b -> LINE` or a bare path with a (note)."""
    raw = value.strip().strip("`")
    t, arrow, line = raw.partition("->")
    t = _drop_notes(t)
    t, _, args = t.partition(" -- ")
    path = t.split()[0] if t.split() else ""
    return {"test": _norm(path), "args": args.strip().strip("`"), "pass_line": _drop_notes(line).strip("` ") if arrow else ""}


def _films(value: str) -> list[str]:
    """Film paths named in VISUAL; `dir/a.mp4 vs b.mp4` puts b beside a."""
    films, last_dir = [], ""
    for f in _FILM_RE.findall(value):
        f = _norm(f)
        if "/" not in f and last_dir:
            f = last_dir + "/" + f
        last_dir = f.rsplit("/", 1)[0] if "/" in f else last_dir
        films.append(f)
    return films


def parse(text: str) -> dict | None:
    """The `## Contract` block as {owns: [{path, windows}], red_test: {test, args, pass_line}, regression: [..], visual: bool,
    films: [..], film: str, owns_prose: [..]} or None."""
    m = _BLOCK_RE.search(text)
    if not m:
        return None
    owns: dict[str, list[list[int]]] = {}
    prose: list[str] = []
    red, regression, visual, films, film, seen = None, [], None, [], "", set()
    base, loop = "", ""
    for key, value in _values(m.group(1)):
        seen.add(key)
        if key == "OWNS":
            for item in (v.strip() for v in _drop_notes(value).split(",")):
                item = re.sub(r"^(?:and|plus)\s+", "", item.strip("`"), flags=re.I).strip("` ")
                if not item:
                    continue
                if " " in item:
                    prose.append(item)
                    continue
                w = _WINDOW_RE.match(item)
                path, window = (_norm(w.group(1)), [int(w.group(2)), int(w.group(3))]) if w else (_norm(item), None)
                owns.setdefault(path, [])
                if window:
                    owns[path].append(window)
        elif key == "RED_TEST":
            red = _red_test(value)
        elif key == "REGRESSION":
            regression += [s.strip().strip("`") for s in _drop_notes(value).split(",") if s.strip().strip("`")]
        elif key == "VISUAL":
            ## S368: Lean briefs name the film to judge (VISUAL: docs/x.mp4 ...) - a film is visual, as is `yes`.
            visual = not _drop_notes(value).lower().startswith(("no", "none", "false", "0"))
            films += _films(value)
        elif key == "FILM":
            film = value.strip().strip("`")
        elif key == "BASE":   # S371: the branch the round starts from (a judged loop chains its rounds; default origin/main)
            base = _drop_notes(value).strip("` ")
        elif key == "LOOP":   # S371: `<STEM> <target>` - seat_dispatch queues round n+1 until Argon scores the target
            loop = _drop_notes(value).strip("` ")
    return {"owns": [{"path": p, "windows": w} for p, w in owns.items()], "red_test": red, "regression": regression,
            "visual": visual, "films": films, "film": film, "owns_prose": prose, "keys": sorted(seen), "base": base, "loop": loop}


@functools.lru_cache(maxsize=1)
def _main_tests() -> tuple[str, ...]:
    return tuple(sorted(p.name for p in TESTS.glob("*_test.gd")))  # S301: listed once per process (was 452 globs per `start`)


def matched_tests(substring: str, extra: list[str] = ()) -> list[str]:
    """What `--only <substring>` would run: every tests/*_test.gd whose name holds the substring."""
    names = set(_main_tests()) | {Path(e).name for e in extra if e.startswith("tests/") and e.endswith("_test.gd")}
    return sorted(n for n in names if substring in n)


def regression_item(item: str, owned: list[str] = ()) -> dict:
    """One REGRESSION item resolved: {kind: suite|probe|tests|none, ...}. S368: Lean names tests by file, probes by name."""
    s = _norm(item.strip().strip("`"))
    if s.lower() == "none":
        return {"kind": "none", "item": item}
    if _SUITE_RE.search(s):
        return {"kind": "suite", "item": item}
    word = s.split()[0] if s.split() else s
    if word.startswith("tools/") or (not word.startswith("tests/") and not word.endswith("_test")
                                     and ((GAME / "tools" / f"{word}.gd").is_file() or f"tools/{word}.gd" in owned)):
        path = word if word.endswith(".gd") else (word if word.startswith("tools/") else f"tools/{word}") + ("" if word.endswith(".gd") else ".gd")
        return {"kind": "probe", "item": item, "path": path, "exists": (GAME / path).is_file() or path in owned}
    if word.startswith("tests/"):
        word = Path(word).stem
    return {"kind": "tests", "item": item, "substring": word, "tests": matched_tests(word, owned)}


## S301 (operator: "starting orientation went up again from 10 seconds"): one `git check-attr` per test cost ~40 ms on
## Windows and `start` checked 230 of them (8.8 s, growing with every brief). Every test's refs now go through ONE
## `git check-attr --stdin` call, cached per test for the rest of the process.
_LFS_CACHE: dict[str, list[str]] = {}


def _lfs_prime(test_names) -> None:
    refs_by_test = {}
    for name in {n for n in test_names if n not in _LFS_CACHE}:
        src = TESTS / name
        text = src.read_text(encoding="utf-8", errors="replace") if src.is_file() else ""
        refs_by_test[name] = sorted(set(_RESPATH_RE.findall(text)))
    every = sorted({r for refs in refs_by_test.values() for r in refs})
    lfs = set()
    if every:
        ## -z: NUL-separated both ways (text mode on Windows turns "\n" into "\r\n" and git then checks "path\r")
        out = subprocess.run(["git", "check-attr", "-z", "--stdin", "filter"], cwd=GAME,
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


def _on_main_or_owned(path: str, owned: list[str]) -> bool:
    return path in owned or any(o.endswith("/") and path.startswith(o) for o in owned) or (GAME / path).is_file()


def validate(contract: dict | None) -> list[str]:
    if contract is None:
        return ["no '## Contract' block (OWNS / RED_TEST / REGRESSION / VISUAL)"]
    why = []
    for key in ("OWNS", "RED_TEST", "REGRESSION", "VISUAL"):
        if key not in contract["keys"]:
            why.append(f"missing {key}:")
    owned = [o["path"] for o in contract["owns"]]
    for item in contract.get("owns_prose") or []:
        why.append(f"OWNS '{item[:60]}': not a path (name each file, or put the note in parentheses)")
    for o in contract["owns"]:
        p = o["path"]
        if p.startswith(OLD_GAME):
            why.append(f"OWNS {p}: the archived old repo's game (ICOON-Studio/FightCamp), not this repo")
        elif p.startswith(PROTECTED) or p in PROTECTED:
            why.append(f"OWNS {p}: a gate/tooling file is never merged by a machine")
        elif not p.startswith(GAME_DIRS):
            why.append(f"OWNS {p}: outside the game folders ({' '.join(GAME_DIRS)})")
        for a, b in o["windows"]:
            if a < 1 or b < a:
                why.append(f"OWNS {p}:{a}-{b}: bad line window")
    red = contract.get("red_test")
    if red:
        t = red["test"]
        if not t.endswith(".gd") or not (t.startswith("tests/") and t.endswith("_test.gd") or t.startswith("tools/")):
            why.append(f"RED_TEST {t or '-'}: not a tests/*_test.gd or a tools/*.gd probe")
        elif not _on_main_or_owned(t, owned):
            why.append(f"RED_TEST {t}: neither in OWNS nor on main")
    for sub in contract.get("regression") or []:
        r = regression_item(sub, owned)
        if r["kind"] == "none":
            why.append("REGRESSION 'none' - name at least the systems the change touches (tests, probes or run_tests.sh)")
        elif r["kind"] == "probe":
            if not r["exists"]:
                why.append(f"REGRESSION '{sub}': no {r['path']} on main or in OWNS")
        elif r["kind"] == "tests":
            hits = r["tests"]
            if not hits:
                why.append(f"REGRESSION '{sub}': matches no test")
            elif len(hits) > 40:
                why.append(f"REGRESSION '{sub}': matches {len(hits)} tests - too broad for one run (name them, or run_tests.sh)")
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


def archived(contract: dict | None) -> bool:
    """S368: a contract that owns the archived old repo's game (Godot/...) and otherwise only that repo's research/ notes -
    that work cannot land in this repo."""
    paths = [o["path"] for o in (contract or {}).get("owns", [])]
    return any(p.startswith(OLD_GAME) for p in paths) and all(p.startswith((OLD_GAME, "research/")) for p in paths)


def briefs_needing_contract(skipped: list | None = None) -> list[str]:
    """Briefs added on/after CONTRACT_FROM_DATE (git) or not committed yet, minus cancelled/done ones - the set `start` flags.
    `skipped` (a list) receives the archived old-repo briefs left out."""
    out = subprocess.run(["git", "log", f"--since={CONTRACT_FROM_DATE}T00:00:00", "--diff-filter=A", "--name-only", "--format=",
                          "--", "research/TASK_*.md"], cwd=ROOT, capture_output=True, text=True).stdout.split()
    out += subprocess.run(["git", "ls-files", "--others", "--exclude-standard", "--", "research/TASK_*.md"], cwd=ROOT,
                          capture_output=True, text=True).stdout.split()
    names = {Path(p).name for p in out if (RESEARCH / Path(p).name).is_file()}
    ## S366: the move into Lean/ops 'added' every old brief at once; the old repo's own dates decide for those (frozen list).
    moved: set[str] = set()
    try:
        frozen = json.loads((RESEARCH / "_contract_moved.json").read_text(encoding="utf-8"))
        moved = set(frozen["moved"])
        names = (names - moved) | {n for n in frozen["dated_on_or_after_cutoff"] if (RESEARCH / n).is_file()}
    except (OSError, ValueError, KeyError):
        pass
    keep = []
    for n in sorted(names):
        text = (RESEARCH / n).read_text(encoding="utf-8", errors="replace")
        if re.search(r"^Status:\s*(CANCELLED|DONE|SUPERSEDED)", text, re.M):
            continue
        if re.search(r"^Kind:\s*research\b", text, re.M):  # S259: review/research briefs carry no code, nothing to merge
            continue
        if n in moved and archived(parse(text)):  # S368: old-repo work, archived with ICOON-Studio/FightCamp
            if skipped is not None:
                skipped.append(n)
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
                hits.update(regression_item(sub, owned).get("tests") or [])
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


# ---------------------------------------------------------------- selftest (fixtures; reads main's tests/ and tools/ only)

def selftest() -> int:
    def block(*lines: str) -> str:
        return "# TASK_X\n\n## Contract\n" + "\n".join(lines) + "\n\n## Prior research\nnone\n"

    cases = [
        ("Lean/ prefix, probe RED_TEST with a note, film VISUAL", True, block(
            "OWNS: Lean/scripts/fight3d/Referee.gd, Lean/docs/agy/X_result.md",
            "RED_TEST: Lean/tools/ref_break_probe.gd (FAIL on main 553b541: worst_pen_m 0.168)",
            "REGRESSION: fight_flow_test, golden_path_test, clinch_check (six lines unchanged)",
            "VISUAL: ops/previews/S368/x_before.mp4 vs x_after.mp4 (Argon judges both)"),
         lambda c: c["owns"][0]["path"] == "scripts/fight3d/Referee.gd" and c["red_test"]["test"] == "tools/ref_break_probe.gd"
         and c["visual"] and c["films"] == ["ops/previews/S368/x_before.mp4", "ops/previews/S368/x_after.mp4"]),
        ("bare scripts/ paths, classic test RED_TEST", True, block(
            "OWNS: scripts/rules/GymBills.gd, tests/gym_bills_test.gd   (Lean repo)",
            "RED_TEST: tests/gym_bills_test.gd -> GYM_BILLS failures=0", "REGRESSION: game_money_test", "VISUAL: no"),
         lambda c: c["red_test"]["pass_line"] == "GYM_BILLS failures=0" and c["visual"] is False),
        ("wrapped OWNS, probe args, run_tests.sh, probe names", True, block(
            "OWNS: Lean/scripts/fight3d/JoinSmoother.gd, Lean/scripts/fight3d/GuardTuck.gd,",
            "Lean/scripts/fight3d/FightStage.gd (only `_start()` and `_on_finished()`)",
            "RED_TEST: tools/smooth_probe.gd -- show3d -> OURS <= 250/min",
            "REGRESSION: run_tests.sh (all), hit_gap_probe, inside_guard_probe", "VISUAL: yes (stills)"),
         lambda c: len(c["owns"]) == 3 and c["red_test"]["args"] == "show3d" and c["red_test"]["pass_line"] == "OURS <= 250/min"),
        ("res:// paths, a folder owned, note before the colon", True, block(
            "OWNS: res://scripts/fight3d/MovePlayer.gd, docs/playtest/moveplayer/",
            "RED_TEST: tests/move_book_test.gd", "REGRESSION (Lean tests): tests/move_clips_test.gd", "VISUAL: none"),
         lambda c: c["owns"][1]["path"] == "docs/playtest/moveplayer/" and c["regression"] == ["tests/move_clips_test.gd"]),
        ("FILM line parsed", True, block(
            "OWNS: scripts/fight3d/Referee.gd", "RED_TEST: tools/ref_break_probe.gd", "REGRESSION: clinch_check",
            "VISUAL: yes", "FILM: --resolution 1280x720 --script res://tools/ref_break_probe.gd"),
         lambda c: c["film"].endswith("ref_break_probe.gd")),
        ("old repo Godot/ path refused", False, block(
            "OWNS: Godot/scripts/rules/FightLink.gd", "RED_TEST: Godot/tests/fight_link_test.gd -> X failures=0",
            "REGRESSION: golden_path_test", "VISUAL: no"), lambda c: archived(c)),
        ("ops tool refused (protected)", False, block(
            "OWNS: ops/Tools/code_gate.py", "RED_TEST: tests/golden_path_test.gd", "REGRESSION: golden_path_test", "VISUAL: no"),
         None),
        ("prose OWNS item refused", False, block(
            "OWNS: scripts/ui/UI.gd, and the ui/areas files whose buttons need a reason", "RED_TEST: tests/golden_path_test.gd",
            "REGRESSION: golden_path_test", "VISUAL: yes"), None),
        ("REGRESSION none refused", False, block(
            "OWNS: scripts/rules/Knockdowns.gd", "RED_TEST: tests/knockdowns_test.gd", "REGRESSION: none (new module)",
            "VISUAL: no"), None),
        ("RED_TEST not on main nor owned", False, block(
            "OWNS: scripts/rules/Nope.gd", "RED_TEST: tests/nope_nothing_test.gd", "REGRESSION: golden_path_test", "VISUAL: no"),
         None),
        ("unknown probe refused", False, block(
            "OWNS: scripts/rules/Nope.gd", "RED_TEST: tests/golden_path_test.gd", "REGRESSION: tools/no_such_probe.gd",
            "VISUAL: no"), None),
    ]
    fails = 0
    for name, want_ok, text, extra in cases:
        c = parse(text)
        why = validate(c)
        ok = (not why) == want_ok and (extra is None or bool(extra(c)))
        fails += not ok
        print(f"{'OK  ' if ok else 'FAIL'} {name:58s} -> {'VALID' if not why else why[0]}")
    print(f"BRIEF_CONTRACT_SELFTEST cases={len(cases)} failures={fails}")
    return 1 if fails else 0


def main(argv: list[str]) -> int:
    cmd = argv[1] if len(argv) > 1 else ""
    if cmd == "selftest":
        return selftest()
    if cmd == "check":
        skipped: list[str] = []
        tasks = argv[2:] or [n[len("TASK_"):-3] for n in briefs_needing_contract(skipped)]
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
        if skipped:
            print(f"(archived: {len(skipped)} old-repo brief(s) owning only Godot/ paths are skipped)")
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
