"""seat_dispatch.py - CLI agent seats pick up queued tasks and deliver with no Claude session driving them (S368).

Operator S368: "can you program other agents like cursor,qwen,arena to pick up tasks and deliver automatically". Run by the 30-min
"FightCamp Board Reconcile" task (Tools/board_reconcile.py --apply). Arena is a browser seat (its PRs are collected by
collect_ready/code_gate; launching it is not automatable) and Codex gets no tasks (S228), so the seats here are Qwen, Cursor and
Antigravity (agy).

    python ops/Tools/seat_dispatch.py                     # dry run: per seat, the queued tasks and what --act would do
    python ops/Tools/seat_dispatch.py --act               # launch (at most LAUNCHES_PER_CYCLE per call) - what the reconcile runs
    python ops/Tools/seat_dispatch.py --task <ID> --seat qwen|cursor|agy [--act]   # one brief on one seat, no queue row needed
    python ops/Tools/seat_dispatch.py queue --task <ID> --seat <seat>             # queue it for the next cycle (no roadmap edit)
    python ops/Tools/seat_dispatch.py run <ID>            # (internal) the hidden runner one launch starts
    python ops/Tools/seat_dispatch.py films <ID> [--branch B]   # film main + the branch and judge both (Argon), board post
    python ops/Tools/seat_dispatch.py selftest            # queue/seat/film-command rules, no network

THE QUEUE: roadmap.json plan.next and plan.waiting_seat rows whose `who` names a seat (qwen / cursor / antigravity|agy), plus
AgentComms/dispatch_queue.json items. A row's brief: its `brief` field, else ops/research/TASK_<id>.md, TASK_<id>1.md, or a
TASK_<x> its title names. A task launches only when ALL hold (else the dry run says why):
  brief       the brief exists, is not Status: DONE/CANCELLED, and its `## Contract` is valid (Tools/brief_contract.py)
  fresh       no live_runs/archive run with that id, no worktree wt/LEAN_<ID>, no branch <seat>/<id> (re-run: a new id)
  seat        no running live_runs entry and no live process for that seat
  pc          the watchdog is not RED (pc_watchdog.ps1 -Once), at most MAX_PC_AGENTS agents on the PC, E: has E_FREE_MIN_GB free
A launch: worktree E:\\FightCamp\\wt\\LEAN_<ID> on branch <seat>/<id> from origin/main, seed_godot_cache.ps1, the brief copied in
when origin/main lacks it, a prompt file, a live_runs.json entry (status running, match = this runner), then a hidden, detached,
idle-priority `seat_dispatch.py run <ID>` that:
  1. VISUAL brief with a film (VISUAL names an .mp4 or FILM: is set): films main BEFORE the seat starts (the worktree is still main)
  2. runs the seat through its wrapper (qwen_task.cmd / cursor_task.cmd) or agy (`-p`, file tools only, --sandbox)
  3. commits the changed OWNS files the seat left uncommitted (agy never commits: its shell is denied), never anything else
  4. runs RED_TEST + REGRESSION headless on the branch (watchdog-gated), pushes the branch, opens the PR (TASK: <ID>, RESULT lines)
  5. films the branch AFTER, `gemini_judge.py <mp4> --model argon --fps 24` on both (verdicts beside the films), posts both
     films + scores to the ops board's /review page for the operator
  6. live_runs entry -> landed (PR) or failed (why). Nothing is merged here: code_gate/collect_ready keep merging OFF (S249).
Every child runs with CREATE_NO_WINDOW; films go through tools/hidden_desktop.py (never a monitor). Log: AgentComms/seat_dispatch.log.
"""
from __future__ import annotations

import json
import os
import re
import shlex
import shutil
import subprocess
import sys
import tempfile
import time
from datetime import datetime, timedelta
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent  # ops/
GAME = ROOT.parent  # the Lean repo root
sys.path.insert(0, str(ROOT / "Tools"))
import brief_contract  # noqa: E402

REPO = "ICOON-Studio/FightCamp-Lean"
WT = Path(os.environ.get("FIGHTCAMP_WT") or "E:/FightCamp/wt")
COMMS = ROOT / "AgentComms"
RUNS, ARCHIVE, ROADMAP = COMMS / "live_runs.json", COMMS / "live_runs_archive.json", COMMS / "roadmap.json"
QUEUE, LOG = COMMS / "dispatch_queue.json", COMMS / "seat_dispatch.log"
PREVIEWS = ROOT / "previews" / "dispatch"
LOCAL = Path(os.environ.get("LOCALAPPDATA", r"C:\Users\user\AppData\Local"))
GODOT = LOCAL / "Programs" / "Godot" / "Godot_v4.7.2-stable_win64.exe"
AGY = LOCAL / "agy" / "bin" / "agy.exe"
## S370: the first scheduled agy launch (KNEETRACK1, from the 30-min reconcile) died in CreateProcess with WinError 2 while
## the same launch from a session shell worked - take the first agy.exe that exists, and the runner logs the one it used.
for _c in (AGY, Path(os.environ.get("USERPROFILE", "C:/Users/user")) / "AppData" / "Local" / "agy" / "bin" / "agy.exe",
           Path(shutil.which("agy") or "")):
    if str(_c) not in ("", ".") and _c.is_file():
        AGY = _c
        break
AGY_MODEL = "gemini-4-argon-high"   # S369 operator: "antigravity should have argon now" (agy models lists it; test call OK)
## seat -> live_runs agent name, the words a roadmap `who` uses, its model, its run cap (minutes)
SEATS = {"qwen": {"agent": "qwen", "who": ("qwen",), "model": "qwen3-coder", "minutes": 90},
         "cursor": {"agent": "cursor", "who": ("cursor",), "model": "composer-2.5", "minutes": 90},
         "agy": {"agent": "antigravity", "who": ("antigravity", "agy"), "model": AGY_MODEL, "minutes": 65}}
SEAT_PROCS = {"qwen": "qwen-code", "cursor": "cursor-agent", "agy": "agy.exe"}
PC_AGENTS = ("qwen", "cursor", "antigravity", "agy", "codex", "cline", "ziva")
MAX_PC_AGENTS = 2         # S218 (the PC hung with 3 agents + Godot tests): 2 PC agents at once
LAUNCHES_PER_CYCLE = 1    # one new agent per 30-min cycle - each launch seeds a cache and starts Godot imports
E_FREE_MIN_GB = 20
TEST_TIMEOUT_S, FILM_TIMEOUT_S = 600, 900
NO_WINDOW = getattr(subprocess, "CREATE_NO_WINDOW", 0)
IDLE, NEW_GROUP, BREAKAWAY = 0x40, 0x200, 0x01000000
SCRIPT_ERR_RE = re.compile(r"SCRIPT ERROR|Parse Error|Failed to load script")
SCORE_RE = re.compile(r"\b(\d+(?:\.\d+)?)\s*/\s*10\b")


# ---------------------------------------------------------------- small helpers

def _now() -> str:
    return datetime.now().strftime("%Y-%m-%dT%H:%M")


def log(line: str) -> str:
    with LOG.open("a", encoding="utf-8") as fh:
        fh.write(f"{datetime.now():%Y-%m-%d %H:%M:%S} {line}\n")
    return line


def sh(args: list, cwd: Path = GAME, timeout: int = 300, env: dict | None = None) -> subprocess.CompletedProcess:
    try:
        return subprocess.run([str(a) for a in args], cwd=str(cwd), capture_output=True, text=True, encoding="utf-8",
                              errors="replace", timeout=timeout, creationflags=NO_WINDOW, env=env)
    except subprocess.TimeoutExpired as exc:
        return subprocess.CompletedProcess(args, 124, (exc.stdout or "") if isinstance(exc.stdout, str) else "", "timeout")
    except OSError as exc:
        return subprocess.CompletedProcess(args, 127, "", str(exc))


def git(*args, cwd: Path = GAME, timeout: int = 120) -> str:
    return sh(["git", *args], cwd=cwd, timeout=timeout).stdout


def load(path: Path, default):
    try:
        return json.loads(path.read_text(encoding="utf-8-sig"))
    except (OSError, ValueError):
        return default


def save(path: Path, data) -> None:
    fd, tmp = tempfile.mkstemp(prefix=path.stem + ".", suffix=".tmp", dir=str(path.parent))
    with os.fdopen(fd, "w", encoding="utf-8", newline="\n") as fh:
        json.dump(data, fh, indent=1, ensure_ascii=False)
        fh.write("\n")
    os.replace(tmp, path)


def update_run(task: str, **fields) -> dict:
    """Read-modify-write ONE live_runs entry (the board and board_reconcile write the same file - keep the window short)."""
    reg = load(RUNS, {"runs": {}})
    info = reg.setdefault("runs", {}).setdefault(task, {})
    info.update(fields)
    save(RUNS, reg)
    return info


def processes() -> list[tuple[int, str]]:
    ps = ("Get-CimInstance Win32_Process | ?{ $_.Name -match 'node|qwen|cursor|agy|codex|Godot|python' } | "
          "%{ '{0}|{1}' -f $_.ProcessId, $_.CommandLine }")
    out = sh(["powershell", "-NoProfile", "-Command", ps], timeout=60).stdout
    rows = []
    for line in out.splitlines():
        pid, _, cmd = line.partition("|")
        if pid.strip().isdigit():
            rows.append((int(pid), cmd.replace("\\", "/").lower()))
    return rows


def watchdog() -> tuple[bool, str]:
    """(red, first line) from pc_watchdog.ps1 -Once - exit 1 = RED: nothing launches, films and tests wait."""
    p = sh(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", ROOT / "Tools" / "pc_watchdog.ps1", "-Once"], timeout=120)
    first = (p.stdout.strip().splitlines() or ["(no reading)"])[0].lstrip("\ufeff")
    return p.returncode == 1, first


def green(line: str) -> bool:
    return " GREEN " in f" {line} "


def render_running(procs: list) -> str:
    """A windowed Godot render/film on the PC (Lean CLAUDE.md: two windowed renders never at once)."""
    return next((f"pid {pid}" for pid, c in procs if "godot" in c and ("--write-movie" in c or "--windowed" in c)), "")


def wait_not_red(why: str, minutes: int = 30, beside_render: bool = False) -> str:
    """'' once the watchdog is not RED (and, for a headless test, GREEN or no windowed render running - S355: "a headless test or
    two may run beside a film or windowed render while the watchdog reads GREEN"); else the last reading after `minutes`."""
    for _ in range(minutes):
        red, line = watchdog()
        render = render_running(processes()) if beside_render and not red and not green(line) else ""
        if not red and not render:
            return ""
        log(f"WAIT ({why}): {'render ' + render + ' and ' if render else ''}{line}")
        time.sleep(60)
    return line


# ---------------------------------------------------------------- the queue

def seat_of(who: str) -> str:
    words = re.findall(r"[a-z]+", str(who).lower())
    return next((s for w in words for s, cfg in SEATS.items() if w in cfg["who"]), "")


def brief_for(row: dict) -> str:
    """The task id whose brief the row means ('' if none exists)."""
    rid = str(row.get("task") or row.get("id") or "").strip()
    cands = [str(row.get("brief", "")), rid, rid + "1"] + re.findall(r"\bTASK_([A-Za-z0-9_]+)", str(row.get("title", "")))
    for c in cands:
        c = Path(c).stem.removeprefix("TASK_") if c.endswith(".md") else c.removeprefix("TASK_")
        if c and (brief_contract.RESEARCH / f"TASK_{c}.md").is_file():
            return c
    return ""


def queue_rows() -> list[dict]:
    plan = load(ROADMAP, {}).get("plan", {})
    rows = [dict(r, source=f"roadmap plan.{k}") for k in ("next", "waiting_seat") for r in plan.get(k) or [] if isinstance(r, dict)]
    rows += [dict(r, source="dispatch_queue.json") for r in load(QUEUE, {}).get("items", []) if r.get("status", "queued") == "queued"]
    out = []
    for r in rows:
        seat = str(r.get("seat") or "") or seat_of(r.get("who", ""))
        if seat in SEATS:
            out.append({"row": str(r.get("id") or r.get("task")), "seat": seat, "task": brief_for(r), "title": str(r.get("title", "")),
                        "source": r["source"]})
    return out


def fresh_why(task: str, seat: str) -> str:
    runs = load(RUNS, {}).get("runs", {})
    arch = load(ARCHIVE, {}).get("runs", {})
    for reg, where in ((runs, "live_runs"), (arch, "archive")):
        for k, v in (reg.items() if isinstance(reg, dict) else []):
            if isinstance(v, dict) and str(v.get("id") or k).upper() == task.upper():
                return f"already ran ({where}: {v.get('agent')} {v.get('status')})"
    if (WT / f"LEAN_{task}").exists():
        return f"worktree {WT / f'LEAN_{task}'} exists"
    branch = f"{seat}/{task.lower()}"
    if git("rev-parse", "--verify", "-q", f"refs/heads/{branch}").strip() or git("ls-remote", "origin", f"refs/heads/{branch}").strip():
        return f"branch {branch} exists"
    return ""


def brief_why(task: str) -> str:
    if not task:
        return "no brief (ops/research/TASK_<id>.md) found for the row"
    text = brief_contract.brief_path(task).read_text(encoding="utf-8", errors="replace")
    if re.search(r"^Status:\s*(CANCELLED|DONE|SUPERSEDED)", text, re.M):
        return "brief is DONE/CANCELLED"
    _, why = brief_contract.check_brief(task)
    return f"contract: {why[0]}" + (f" (+{len(why) - 1} more)" if len(why) > 1 else "") if why else ""


def seat_busy(seat: str, procs: list) -> str:
    for k, v in load(RUNS, {}).get("runs", {}).items():
        if isinstance(v, dict) and v.get("status") == "running" and str(v.get("agent", "")).lower() in (SEATS[seat]["agent"], seat):
            return f"running {k}"
    hit = next((pid for pid, cmd in procs if SEAT_PROCS[seat] in cmd), None)
    return f"a {SEAT_PROCS[seat]} process is live (pid {hit})" if hit else ""


def pc_agents(procs: list) -> list[str]:
    """Agents on the PC now: running live_runs entries of PC seats, plus CLI agent processes no entry accounts for."""
    seen, out, names = set(), [], set()
    for k, v in load(RUNS, {}).get("runs", {}).items():
        if isinstance(v, dict) and v.get("status") == "running" and str(v.get("agent", "")).lower() in PC_AGENTS:
            out.append(f"{v.get('agent')} {k}")
            seen.add(str(v.get("worktree", "")).replace("\\", "/").lower())
    for pid, cmd in procs:
        ## the CLI seats; Codex only as `codex exec` (the operator's Codex desktop app runs codex.exe app-server all day)
        name = next((n for n in ("agy.exe", "qwen-code", "cursor-agent", "codex exec", "codex.exe exec") if n in cmd), "")
        # S369: one CLI run is a launcher plus its child node processes (qwen-code: 3 pids) - count a seat once, not per
        # process (a seat runs one task at a time: seat_busy).
        if name and name not in names and not any(w and w in cmd for w in seen) and "seat_dispatch.py" not in cmd:
            names.add(name)
            out.append(f"{name} pid {pid}")
    return out


def decide(rows: list[dict], procs: list, red: bool, red_line: str, e_free_gb: float) -> list[dict]:
    """Every queued row with its verdict: LAUNCH (the first LAUNCHES_PER_CYCLE that pass) or why it waits."""
    agents = pc_agents(procs)
    render = render_running(procs)
    launches, used = 0, set()
    out = []
    for r in rows:
        why = brief_why(r["task"]) or fresh_why(r["task"], r["seat"])
        if not why and r["seat"] in used:
            why = "seat already gets a task this cycle"
        if not why:
            why = seat_busy(r["seat"], procs)
        if not why and red:
            why = f"watchdog RED: {red_line}"
        if not why and render and not green(red_line):
            why = f"a windowed render runs ({render}) and the PC is not GREEN (S355: tests beside a render only on GREEN)"
        if not why and len(agents) + launches >= MAX_PC_AGENTS:
            why = f"{len(agents) + launches} PC agents running (max {MAX_PC_AGENTS}): {', '.join(agents)}"
        if not why and e_free_gb < E_FREE_MIN_GB:
            why = f"E: has {e_free_gb:.0f} GB free (< {E_FREE_MIN_GB})"
        if not why and launches >= LAUNCHES_PER_CYCLE:
            why = f"one launch per cycle (next cycle)"
        if not why:
            launches += 1
            used.add(r["seat"])
        out.append(dict(r, verdict="LAUNCH" if not why else "WAIT", why=why))
    return out


# ---------------------------------------------------------------- launch

def prompt_text(seat: str, task: str, wt: Path, branch: str) -> str:
    brief = wt / "ops" / "research" / f"TASK_{task}.md"
    if seat == "agy":
        return (f"Read the brief {brief.as_posix()} in full and do exactly what it says, in this worktree ({wt.as_posix()}). "
                "Use ONLY your file read and write tools - run NO shell commands, no grep. Edit only the files its '## Contract' "
                "OWNS line lists. Do not commit: the dispatcher commits your files, runs the tests and films on your branch.")
    name = {"qwen": "Qwen", "cursor": "Cursor"}[seat]
    return "\n".join([
        f"You are {name} working in the Godot 4.7.2 repo at {wt} (a git worktree of E:\\FightCamp\\Lean, branch {branch}, cut from origin/main).",
        f"Read the brief ops/research/TASK_{task}.md in that folder in full and do exactly what it says. Its '## Contract' block is binding:",
        "touch only the files OWNS lists, turn RED_TEST green, keep every REGRESSION test green, no file over 500 lines.",
        f"Run Godot only headless: \"{GODOT}\" --headless --audio-driver Dummy --path . --script res://<test>.gd (never the _console.exe).",
        "Nothing may open on the screen: do not open images, videos or apps.",
        f"Commit only the OWNS files on {branch} with explicit paths (git add -- <file>; never git add -A, stash, reset or clean). "
        "Do not push: the dispatcher pushes your branch and opens the PR.",
        "End your reply with one line per test you ran: RESULT: <test path> -> <the exact pass line you saw>.",
    ]) + "\n"


def spawn_hidden(args: list, out_path: Path, cwd: Path) -> int:
    """A detached, windowless, idle-priority child that outlives this process (the reconcile task exits in minutes)."""
    fh = open(out_path, "a", encoding="utf-8")
    for flags in (NO_WINDOW | NEW_GROUP | IDLE | BREAKAWAY, NO_WINDOW | NEW_GROUP | IDLE):
        try:
            p = subprocess.Popen([str(a) for a in args], cwd=str(cwd), stdout=fh, stderr=subprocess.STDOUT,
                                 stdin=subprocess.DEVNULL, creationflags=flags, close_fds=True)
            return p.pid
        except OSError:
            continue  # a job without breakaway rights refuses CREATE_BREAKAWAY_FROM_JOB
    raise OSError("could not start " + " ".join(map(str, args[:3])))


def launch(r: dict) -> str:
    task, seat = r["task"], r["seat"]
    wt, branch = WT / f"LEAN_{task}", f"{seat}/{task.lower()}"
    base = (brief_contract.parse(brief_contract.brief_path(task).read_text(encoding="utf-8", errors="replace")) or {}).get("base") or "main"
    git("fetch", "-q", "origin", "main", *([base] if base != "main" else []), timeout=300)
    p = sh(["git", "worktree", "add", "-b", branch, wt, f"origin/{base}"], timeout=600)
    if p.returncode != 0:
        return log(f"LAUNCH FAIL {task}: worktree add: {(p.stderr or p.stdout).strip()[:300]}")
    seed = sh(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", ROOT / "Tools" / "seed_godot_cache.ps1",
               "-Worktree", wt], timeout=1800)
    log(f"SEED {task}: {(seed.stdout.strip().splitlines() or ['?'])[-1]}")
    brief_src, brief_dst = brief_contract.brief_path(task), wt / "ops" / "research" / f"TASK_{task}.md"
    copied = not brief_dst.is_file() or brief_dst.read_bytes() != brief_src.read_bytes()
    if copied:
        shutil.copyfile(brief_src, brief_dst)  # untracked/modified there - never committed (only OWNS files are)
    prompt, out = WT / f"{task}_dispatch_prompt.txt", WT / f"{task}_dispatch_out.txt"
    prompt.write_text(prompt_text(seat, task, wt, branch), encoding="utf-8")
    runner_log = WT / f"{task}_dispatch_runner.log"
    cfg = SEATS[seat]
    title = re.sub(r"^#\s*", "", brief_src.read_text(encoding="utf-8", errors="replace").splitlines()[0]).strip()[:160]
    update_run(task, agent=cfg["agent"], id=task, title=title, status="running", started=_now(),
               eta=(datetime.now() + timedelta(minutes=cfg["minutes"] + 20)).strftime("%Y-%m-%dT%H:%M"), branch=branch,
               worktree=wt.as_posix(), wt=wt.as_posix(), brief=f"ops/research/TASK_{task}.md", repo="FightCamp-Lean", where="pc",
               log=out.as_posix(), match=f"seat_dispatch.py run {task.lower()}", model=cfg["model"],
               dispatch={"prompt": prompt.as_posix(), "out": out.as_posix(), "runner_log": runner_log.as_posix(),
                         "source": r.get("source", ""), "brief_copied": copied},
               note=f"S368 seat_dispatch: launched unattended ({r.get('source', '')}); merging stays off")
    pid = spawn_hidden([sys.executable, Path(__file__).resolve(), "run", task], runner_log, GAME)
    update_run(task, dispatch=dict(load(RUNS, {})["runs"][task]["dispatch"], runner_pid=pid))
    return log(f"LAUNCHED {task} on {seat} ({cfg['model']}) in {wt} branch {branch}, runner pid {pid}")


# ---------------------------------------------------------------- the runner (hidden, detached)

def owned(path: str, owns: list[str]) -> bool:
    return path in owns or any(o.endswith("/") and path.startswith(o) for o in owns)


def commit_owned(wt: Path, contract: dict, task: str, seat: str) -> tuple[list[str], list[str]]:
    """Commit the changed OWNS files the seat left uncommitted; return (committed, stray). Never commits anything else."""
    owns = [o["path"] for o in contract["owns"]]
    files, stray = [], []
    for line in git("status", "--porcelain", "--untracked-files=all", cwd=wt).splitlines():
        path = line[3:].split(" -> ")[-1].strip().strip('"')
        if (not path or path.startswith(".godot/") or path in ("override.cfg", f"ops/research/TASK_{task}.md")
                or path.endswith((".uid", ".import"))):
            continue
        (files if owned(path, owns) else stray).append(path)
    if files:
        git("add", "--", *files, cwd=wt)
        msg = (f"{task}: {seat} delivered {', '.join(files)[:200]} (unattended)\n\nDispatched-by: ops/Tools/seat_dispatch.py\n"
               f"Seat: {SEATS[seat]['agent']} {SEATS[seat]['model']}\n")
        subprocess.run(["git", "commit", "-q", "-F", "-", "--", *files], cwd=str(wt), input=msg, text=True, encoding="utf-8",
                       capture_output=True, creationflags=NO_WINDOW)
    return files, stray


def _literal(line: str) -> bool:
    return bool(line) and not re.search(r"<=|>=|<|>|\bAND\b|\bOR\b", line)


def run_gd(wt: Path, script: str, args: str = "", pass_line: str = "") -> dict:
    cmd = [GODOT, "--headless", "--audio-driver", "Dummy", "--path", wt, "--script", "res://" + script]
    if args:
        cmd += ["--"] + shlex.split(args)
    p = sh(cmd, cwd=wt, timeout=TEST_TIMEOUT_S)
    out = (p.stdout or "") + (p.stderr or "")
    err = SCRIPT_ERR_RE.search(out)
    found = pass_line in out if _literal(pass_line) else None
    ok = p.returncode == 0 and not err and found is not False
    tail = [l for l in out.splitlines() if l.strip()][-1:] or ["(no output)"]
    return {"script": script, "ok": ok, "rc": p.returncode, "pass_line": pass_line, "found": found,
            "why": "script error" if err else ("timeout" if p.returncode == 124 else ""), "last": tail[0][:200]}


_PARSE_RE = re.compile(r"(?:SCRIPT ERROR|ERROR): Parse Error: (.*)\n\s*at: GDScript::reload \((res://[^)]+)\)")


def compile_errors(wt: Path, contract: dict | None = None) -> list[str]:
    """S372: FIGHT9R1 wrote PackedStringArray.any() (no such method) - nothing compiled, the after-film sat 6.5 min on the
    gym screen and Argon scored a frozen menu 1/10. Import, then boot the main scene headless for 30 frames (Main.tscn
    preloads the fight view) and return each parse error as 'res://file.gd:line: message' (the cascades left out).
    S373: FIGHT9R2 broke its own RED_TEST probe (BeatClips.speed with one argument) - Main.tscn never loads a tools/ or
    tests/ script, so the contract's .gd scripts (RED_TEST, REGRESSION, OWNS under tools/ tests/) are parsed too
    (--check-only), and agy's one repair pass sees those errors as well."""
    sh([GODOT, "--headless", "--audio-driver", "Dummy", "--path", wt, "--import"], cwd=wt, timeout=900)
    outs = [sh([GODOT, "--headless", "--audio-driver", "Dummy", "--path", wt, "--quit-after", "30"], cwd=wt, timeout=300)]
    for script in _contract_scripts(wt, contract or {}):
        outs.append(sh([GODOT, "--headless", "--audio-driver", "Dummy", "--path", wt, "--check-only", "--script", "res://" + script],
                       cwd=wt, timeout=180))
    errs: list[str] = []
    for p in outs:
        for m in _PARSE_RE.finditer((p.stdout or "") + (p.stderr or "")):
            e = f"{m.group(2)}: {m.group(1).strip()}"
            if e not in errs:
                errs.append(e)
    return errs


def _contract_scripts(wt: Path, contract: dict) -> list[str]:
    """The contract's runnable .gd scripts that exist in the worktree: RED_TEST, REGRESSION, and OWNS under tools/ or tests/."""
    want = [str((contract.get("red_test") or {}).get("test") or "")]
    for r in contract.get("regression") or []:
        want.append(str(r.get("test") or r.get("path") or "") if isinstance(r, dict) else str(r))
    want += [str(o.get("path", "")) for o in contract.get("owns") or [] if str(o.get("path", "")).startswith(("tools/", "tests/"))]
    out: list[str] = []
    for w in want:
        w = w.strip().split()[0] if w.strip() else ""
        if w and "/" not in w and not w.endswith(".gd"):
            w = f"tests/{w}.gd"   # REGRESSION names a test bare ("fight_flow_test")
        if w.endswith(".gd") and (wt / w).is_file() and w not in out:
            out.append(w)
    return out


def repair_prompt(task: str, errs: list[str]) -> str:
    return (f"Your edits for TASK {task} (ops/research/TASK_{task}.md in this folder) do not compile, so the game cannot start. "
            "Godot 4.7 printed these parse errors:\n" + "\n".join("- " + e for e in errs[:12]) + "\n"
            "Fix ONLY these errors, inside the brief's OWNS files, keeping what each line was meant to do. Use only GDScript 4 "
            "methods that exist on that exact type (Array has any()/all(); PackedStringArray does not - loop instead). "
            "Do not start new work.")


def run_checks(wt: Path, contract: dict) -> list[dict]:
    """RED_TEST then every REGRESSION item, headless on the branch (imported by compile_errors); the watchdog gates each."""
    owns = [o["path"] for o in contract["owns"]]
    red = contract["red_test"]
    jobs = [("RED_TEST", red["test"], red.get("args", ""), red.get("pass_line", ""))]
    for item in contract["regression"]:
        r = brief_contract.regression_item(item, owns)
        if r["kind"] == "probe":
            jobs.append(("REGRESSION", r["path"], "", ""))
        elif r["kind"] == "tests":
            jobs += [("REGRESSION", f"tests/{t}", "", "") for t in r["tests"]]
        elif r["kind"] == "suite":
            jobs.append(("SUITE", "tools/run_tests.sh", "", ""))
    results = []
    for kind, script, args, line in jobs:
        red_line = wait_not_red(f"test {script}", 30, beside_render=True)
        if red_line:
            results.append({"kind": kind, "script": script, "ok": False, "why": "skipped: watchdog RED " + red_line})
            continue
        if kind == "SUITE":
            shx = shutil.which("sh") or r"C:\Program Files\Git\bin\sh.exe"
            p = sh([shx, "tools/run_tests.sh"], cwd=wt, timeout=3600, env=dict(os.environ, JOBS="2", GODOT_EXE=str(GODOT)))
            fails = [l for l in p.stdout.splitlines() if l.startswith("FAIL ")]
            results.append({"kind": kind, "script": script, "ok": p.returncode == 0, "rc": p.returncode,
                            "last": "; ".join(fails[:5]) or f"{p.stdout.count(chr(10) + 'PASS ') + p.stdout.startswith('PASS ')} PASS"})
            continue
        results.append(dict(run_gd(wt, script, args, line), kind=kind))
    return results


def film_args(contract: dict) -> list[str]:
    """Godot args for the brief's film: FILM: as written, else the RED_TEST probe (`--script res://tools/x.gd -- args`)."""
    if contract.get("film"):
        args = shlex.split(contract["film"])
        if args and args[0].lower().endswith(".exe"):
            args = args[1:]
        if "--path" in args:
            i = args.index("--path")
            del args[i:i + 2]
        return args
    red = contract.get("red_test") or {}
    if str(red.get("test", "")).startswith("tools/"):
        return ["--script", "res://" + red["test"]] + (["--"] + shlex.split(red["args"]) if red.get("args") else [])
    return []


def needs_film(contract: dict) -> bool:
    return bool(contract.get("visual") and (contract.get("films") or contract.get("film")))


def film(wt: Path, contract: dict, mp4: Path) -> str:
    """Record the brief's film in `wt` on the hidden desktop -> mp4. '' = done, else why not."""
    args = film_args(contract)
    if not args:
        return "no FILM: line and RED_TEST is not a tools/ probe - Claude films it"
    for _ in range(30):  # two windowed renders never at once (Lean CLAUDE.md)
        if not any("--write-movie" in c or ("godot" in c and "--windowed" in c) for _, c in processes()):
            break
        time.sleep(60)
    red_line = wait_not_red("film", 30)
    if red_line:
        return "watchdog RED: " + red_line
    mp4.parent.mkdir(parents=True, exist_ok=True)
    avi = mp4.with_suffix(".avi")
    extra = [] if "--resolution" in args else ["--resolution", "1280x720"]
    p = sh([sys.executable, GAME / "tools" / "hidden_desktop.py", "run", f"--timeout={FILM_TIMEOUT_S}", f"--log={mp4.with_suffix('.log')}",
            GODOT, "--path", wt, "--windowed", *extra, "--audio-driver", "Dummy", "--fixed-fps", "30", "--write-movie", avi, *args],
           cwd=wt, timeout=FILM_TIMEOUT_S + 120)
    if not avi.is_file():
        return f"no film written (rc {p.returncode}; log {mp4.with_suffix('.log')})"
    c = sh(["ffmpeg", "-y", "-loglevel", "error", "-i", avi, "-c:v", "libx264", "-pix_fmt", "yuv420p", "-crf", "23", "-an", mp4], timeout=900)
    if c.returncode != 0 or not mp4.is_file():
        return "ffmpeg failed: " + (c.stderr or "")[-200:]
    avi.unlink(missing_ok=True)
    return ""


def judge(mp4: Path, what: str, intent: str) -> dict:
    """Gemini 4 Argon on one film (gemini_judge.py writes <film>.gemini_argon.md beside it and logs the spend)."""
    # S379: a BJJ loop is judged on the BJJ prompt (trembling and bodies inside bodies first), never the boxing one
    kind = "bjj" if what.upper().startswith("BJJ") else "fight"
    p = sh([sys.executable, ROOT / "Tools" / "gemini_judge.py", mp4, "--model", "argon", "--fps", "24", "--what", what,
            "--intent", intent, "--kind", kind], timeout=900)
    md = mp4.with_suffix(".gemini_argon.md")
    score, line = read_verdict(md.read_text(encoding="utf-8", errors="replace") if md.is_file() else "")
    return {"film": mp4.as_posix(), "verdict_file": md.as_posix() if md.is_file() else "", "score": score, "line": line,
            "rc": p.returncode, "err": "" if md.is_file() else (p.stdout + p.stderr)[-300:]}


def read_verdict(text: str) -> tuple[str, str]:
    """(score, verdict line) from a gemini_judge verdict file. S376: the verdict's own sentence can name a target ("nowhere
    near a 9/10 broadcast standard" read as 9/10 and stopped FIGHT9 at a real 3.5) - the score is the LAST N/10 on the line
    that says "score" after the Verdict heading, else the last N/10 in that section."""
    tail = text[text.lower().rfind("verdict"):] if "verdict" in text.lower() else text
    lines = tail.splitlines()
    scored = next((l.strip(" *#->") for l in lines if "score" in l.lower() and SCORE_RE.search(l)), "")
    if not scored:
        hits = [l.strip(" *#->") for l in lines if SCORE_RE.search(l)]
        scored = hits[-1] if hits else ""
    line = next((l.strip(" *#->") for l in lines[1:] if l.strip() and "score" not in l.lower()), scored)
    found = SCORE_RE.findall(scored)
    return (found[-1] if found else "?"), line[:240]


def short_title(task: str, title: str) -> str:
    """'TASK RIVALPAST1 - QWEN - a unit test for X (Lean)' -> 'a unit test for X'."""
    t = re.sub(rf"^#?\s*TASK[_ ]{re.escape(task)}\s*-\s*(?:(?:QWEN|CURSOR|ANTIGRAVITY|AGY)\s*-\s*)?", "", title.strip(), flags=re.I)
    return re.sub(r"\s*\((?:Lean|Antigravity|Qwen|Cursor)\)\s*$", "", t, flags=re.I).strip()


def _judged_at(head: str, task: str) -> tuple[str, dict]:
    """S372 (Gemini cap hit in one night: every loop round filmed and judged its BASE again, though the round before had
    just judged that same commit as its after-film): the newest other run whose judged after-film is this commit."""
    best: tuple[str, dict] = ("", {})
    for tid, info in load(RUNS, {}).get("runs", {}).items():
        a = ((info or {}).get("films") or {}).get("after") or {}
        if tid != task and a.get("head") == head and Path(a.get("verdict_file") or "-").is_file() and Path(a.get("film") or "-").is_file():
            if str(info.get("finished", "")) >= str((best[1] or {}).get("_at", "")):
                best = (tid, dict(a, _at=str(info.get("finished", ""))))
    return best


def films(task: str, wt: Path, contract: dict, which: str) -> dict:
    mp4 = PREVIEWS / task / f"{which}.mp4"
    md = mp4.with_suffix(".gemini_argon.md")
    head = git("rev-parse", "HEAD", cwd=wt).strip()
    if which == "before" and mp4.is_file() and md.is_file():  # a re-run (S372: agy self-updated mid-launch) keeps its judged BASE film
        score, line = read_verdict(md.read_text(encoding="utf-8", errors="replace"))
        log(f"JUDGE {task} before: reused Argon {score}/10 {line[:100]}")
        return {"film": mp4.as_posix(), "verdict_file": md.as_posix(), "score": score, "line": line, "rc": 0, "err": "", "head": head}
    if which == "before":
        prev, a = _judged_at(head, task)
        if prev:   # the same commit was judged as the last round's after-film: one film per round, not two
            mp4.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(a["film"], mp4)
            shutil.copyfile(a["verdict_file"], md)
            log(f"JUDGE {task} before: {prev}'s after-film is this commit {head[:8]} - reused Argon {a.get('score')}/10, no film or judge spend")
            return {"film": mp4.as_posix(), "verdict_file": md.as_posix(), "score": a.get("score", "?"), "line": a.get("line", ""),
                    "rc": 0, "err": "", "head": head, "reused": prev}
    # S374: a BASE film made but never scored (the Gemini cap stopped FIGHT9R3's judge) is judged as it is, not filmed again.
    why = "" if (which == "before" and mp4.is_file() and mp4.stat().st_size > 100_000) else film(wt, contract, mp4)
    if why:
        log(f"FILM {task} {which}: {why}")
        return {"film": "", "why": why}
    title = brief_contract.brief_path(task).read_text(encoding="utf-8", errors="replace").splitlines()[0].lstrip("# ")
    label = "main, before the change" if which == "before" else "the agent's branch, after the change"
    j = judge(mp4, f"{task} {which}", f"Video = {label} for {title}. Judge above all what this change is about.")
    j["head"] = head
    log(f"JUDGE {task} {which}: Argon {j['score']}/10 {j['line'][:120]}")
    return j


def post_board(task: str, before: dict, after: dict, branch: str) -> str:
    files = [f"{d['film']}={label}: Argon {d.get('score', '?')}/10 - {d.get('line', '')[:150]}"
             for d, label in ((before, "main (before)"), (after, f"{branch} (after)")) if d.get("film")]
    if not files:
        return ""
    title = f"{task} before/after - Argon {before.get('score', '-')}/10 -> {after.get('score', '-')}/10 (your visual OK closes it)"
    p = sh([sys.executable, ROOT / "Tools" / "review_add.py", "--title", title, "--stage", "S368", *files], timeout=300)
    return (p.stdout or p.stderr).strip().splitlines()[-1:] and (p.stdout or p.stderr).strip().splitlines()[-1] or ""


def pr_body(task: str, info: dict, checks: list, committed: list, stray: list, before: dict, after: dict, out_tail: str) -> str:
    lines = [f"TASK: {task}", "", f"Seat: {info.get('agent')} ({info.get('model')}), launched unattended by ops/Tools/seat_dispatch.py "
             f"at {info.get('started')}; worktree {info.get('worktree')}. Brief: ops/research/TASK_{task}.md. Merging stays off (S249).",
             "", "## Checks the dispatcher ran on this branch (headless)"]
    for c in checks:
        if c.get("ok") and c["script"].startswith("tests/"):
            lines.append(f"RESULT: {c['script']} -> {c.get('pass_line') if c.get('found') else c.get('last', '')}")
        else:
            lines.append(f"- {c['kind']} {c['script']}: {'PASS' if c.get('ok') else 'FAIL'} rc={c.get('rc', '-')} "
                         f"{c.get('why', '')} | {c.get('last', '')}")
    if before or after:
        lines += ["", "## Films (VISUAL - the operator's visual OK is the last gate)"]
        for d, label in ((before, "before (main)"), (after, "after (this branch)")):
            lines.append(f"- {label}: {d.get('film') or d.get('why', '-')}  Argon {d.get('score', '-')}/10 {d.get('line', '')[:200]}")
    lines += ["", "## Files", f"- committed by the dispatcher: {', '.join(committed) or '-'}",
              f"- changed outside OWNS, NOT committed: {', '.join(stray) or '-'}", "", "## Seat output (last lines)", "```",
              ## the seat's own RESULT lines are its word, not the dispatcher's run: quoted inert so auto_collect reads only ours
              re.sub(r"(?m)^RESULT:", "seat says RESULT:", out_tail[-3000:]), "```", "",
              "Opened by ops/Tools/seat_dispatch.py (S368 unattended seats)."]
    return "\n".join(lines)


def _agy(wt: Path, prompt: str, out: Path, env: dict) -> subprocess.Popen:
    for _ in range(20):  # S372: agy replaces its own exe when it updates - FIGHT9R2 found no file for that moment and crashed
        if Path(AGY).is_file():
            break
        time.sleep(30)
    cmd =[AGY, "-p", prompt, "--model", AGY_MODEL, "--mode", "accept-edits", "--sandbox", "--print-timeout", "3600s"]   # S372: R2 timed out at 30 min mid-turn
    fh = open(out, "a", encoding="utf-8")
    return subprocess.Popen([str(c) for c in cmd], cwd=str(wt), stdout=fh, stderr=subprocess.STDOUT, stdin=subprocess.DEVNULL,
                            creationflags=NO_WINDOW, env=env)


def eyes_sheets(mp4: str, verdict_md: str, wt: Path, cap: int = 6) -> list[str]:
    """S379 (operator: "make argon have a skill like your eyes ... for all agents if possible"): agy may not run programs in
    headless mode, but it SEES images. Before the seat starts, the dispatcher runs `eyes` on the film the judge scored - one
    16-frame burst per worst-moment timestamp the verdict names (plus the opening) - into <worktree>/_eyes/, and the prompt
    tells the seat to open them. Never committed (the dispatcher commits OWNS files only). Returns the sheet paths."""
    out_dir = wt / "_eyes"
    if not mp4 or not Path(mp4).is_file():
        return []
    try:
        idx = json.loads(sh(["eyes", "index", mp4, "--json"], timeout=600).stdout or "{}")
    except (ValueError, OSError):
        return []
    ref = str(idx.get("id") or idx.get("ref") or "")
    if not ref:
        return []
    text = Path(verdict_md).read_text(encoding="utf-8", errors="replace") if verdict_md and Path(verdict_md).is_file() else ""
    worst = text[text.lower().find("worst"):] if "worst" in text.lower() else text
    times: list[int] = []
    for mm, ss in re.findall(r"\b(\d{1,2}):(\d{2})\b", worst):
        t = int(mm) * 60 + int(ss)
        if all(abs(t - u) > 2 for u in times):
            times.append(t)
    times = ([2] + times)[:cap]
    out_dir.mkdir(parents=True, exist_ok=True)
    paths: list[str] = []
    for i, t in enumerate(times):
        try:
            b = json.loads(sh(["eyes", "burst", ref, str(t), "--count", "16", "--span", "3", "--width", "1600", "--json"],
                              timeout=300).stdout or "{}")
        except (ValueError, OSError):
            continue
        src = Path(str(b.get("sheet") or b.get("path") or ""))
        if src.is_file():
            dst = out_dir / f"{i:02d}_at_{t // 60}m{t % 60:02d}s.jpg"
            shutil.copyfile(src, dst)
            paths.append(dst.as_posix())
    return paths


def run(task: str) -> int:
    info = load(RUNS, {}).get("runs", {}).get(task)
    if not info:
        print(log(f"RUN {task}: no live_runs entry"))
        return 2
    seat = next(s for s, c in SEATS.items() if c["agent"] == info["agent"])
    wt, branch = Path(info["worktree"]), info["branch"]
    out = Path(info["dispatch"]["out"])
    contract = brief_contract.parse((wt / "ops" / "research" / f"TASK_{task}.md").read_text(encoding="utf-8", errors="replace"))
    try:
        before = films(task, wt, contract, "before") if needs_film(contract) else {}
        prompt = Path(info["dispatch"]["prompt"])
        env = dict(os.environ, GODOT_EXE=str(GODOT))
        env.pop("AGENT_WINDOW", None)
        if seat == "agy":
            log(f"SEAT {task}: agy = {AGY} (exists {Path(AGY).is_file()}), cwd {wt} (exists {wt.is_dir()})")
            text = prompt.read_text(encoding="utf-8").strip()
            sheets = eyes_sheets(str((before or {}).get("film") or ""), str((before or {}).get("verdict_file") or ""), wt)
            if sheets:   # S379: the seat's eyes - it opens these images before touching code
                log(f"EYES {task}: {len(sheets)} sheet(s) in {wt / '_eyes'}")
                text += ("\n\nEYES FIRST: before you change any code, open EVERY image in " + (wt / "_eyes").as_posix()
                         + " with your file read tool - 16-frame contact sheets of the film the judge scored, one per worst "
                         "moment it named (file name = the film time). Write what you see in each (bodies inside bodies, "
                         "trembling, pops, limbs in the air) at the top of your output, then fix what you saw.")
            proc = _agy(wt, text, out, env)
        else:
            wrapper = ROOT / "Tools" / ("qwen_task.cmd" if seat == "qwen" else "cursor_task.cmd")
            proc = subprocess.Popen(["cmd", "/c", str(wrapper), str(prompt), str(wt), str(out)], cwd=str(GAME),
                                    stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                                    creationflags=NO_WINDOW, env=env)
        update_run(task, dispatch=dict(info["dispatch"], seat_pid=proc.pid, runner_pid=os.getpid()))
        log(f"SEAT {task}: {seat} pid {proc.pid} started")
        try:
            rc = proc.wait(timeout=SEATS[seat]["minutes"] * 60)
        except subprocess.TimeoutExpired:
            sh(["taskkill", "/PID", proc.pid, "/T", "/F"])
            rc = 124
        log(f"SEAT {task}: exit {rc}")
        committed, stray = commit_owned(wt, contract, task, seat)
        ahead = int((git("rev-list", "--count", f"origin/{contract.get('base') or 'main'}..HEAD", cwd=wt).strip() or "0"))
        out_tail = out.read_text(encoding="utf-8", errors="replace")[-4000:] if out.is_file() else ""
        if not ahead:
            update_run(task, status="failed", finished=_now(), note=f"S368 seat_dispatch: {seat} exit {rc}, no commit on {branch} "
                       f"(stray: {', '.join(stray) or '-'}); output {out}")
            log(f"FAILED {task}: nothing delivered (exit {rc})")
            return 1
        broken = compile_errors(wt, contract)
        if broken and seat == "agy":  # agy cannot run Godot: one repair pass on the printed errors beats a lost round
            log(f"COMPILE {task}: {len(broken)} parse error(s), agy repair pass - {broken[0][:160]}")
            fix = _agy(wt, repair_prompt(task, broken), out, env)
            try:
                fix.wait(timeout=15 * 60)
            except subprocess.TimeoutExpired:
                sh(["taskkill", "/PID", fix.pid, "/T", "/F"])
            more, stray2 = commit_owned(wt, contract, task, seat)
            committed += [f for f in more if f not in committed]
            stray += [f for f in stray2 if f not in stray]
            broken = compile_errors(wt, contract)
        if broken:
            log(f"COMPILE {task}: still {len(broken)} parse error(s) - no after-film: {broken[0][:160]}")
        checks = run_checks(wt, contract)
        push = sh(["git", "push", "-q", "-u", "origin", branch], cwd=wt, timeout=600)
        if broken:
            checks.insert(0, {"kind": "COMPILE", "script": "Main.tscn boot", "ok": False, "why": "parse error", "last": broken[0][:200]})
            after = {"film": "", "why": "does not compile: " + "; ".join(broken[:3]), "compile": broken} if needs_film(contract) else {}
        else:
            after = films(task, wt, contract, "after") if needs_film(contract) else {}
        board = post_board(task, before, after, branch) if (before.get("film") or after.get("film")) else ""
        title = f"{task}: {short_title(task, info.get('title', ''))[:100]} ({info['agent']}, unattended)"
        body = pr_body(task, info, checks, committed, stray, before, after, out_tail)
        pr = sh(["gh", "pr", "create", "--repo", REPO, "--base", "main", "--head", branch, "--title", title, "--body", body],
                cwd=wt, timeout=300) if push.returncode == 0 else push
        url = (pr.stdout.strip().splitlines() or [""])[-1]
        num = int(m.group(1)) if (m := re.search(r"/pull/(\d+)", url)) else None
        passed = sum(1 for c in checks if c.get("ok"))
        note = (f"S368 seat_dispatch: {seat} exit {rc}; {ahead} commit(s); checks {passed}/{len(checks)} PASS; "
                + (f"PR #{num}" if num else f"PR not opened: {(pr.stderr or pr.stdout).strip()[:200]}")
                + (f"; films Argon {before.get('score', '-')} -> {after.get('score', '-')}/10" if before or after else "")
                + (f"; NOT committed (outside OWNS): {', '.join(stray)}" if stray else ""))
        update_run(task, status="landed" if num else "failed", finished=_now(), pr=num, note=note,
                   checks=[{k: c.get(k) for k in ("kind", "script", "ok", "last")} for c in checks],
                   films={"before": before, "after": after, "board": board})
        log(f"DONE {task}: {note}")
        if contract.get("loop"):
            log(loop_next(task, contract, before, after, branch, passed == len(checks)))
        return 0
    except Exception as exc:  # the runner never dies silent: the board shows why
        update_run(task, status="failed", finished=_now(), note=f"S368 seat_dispatch runner crashed: {exc!r}"[:400])
        log(f"CRASH {task}: {exc!r}")
        raise


# ---------------------------------------------------------------- judged loops (S371)

LOOP_MAX_ROUNDS = 99   # S376 operator: "tell it to work on it until it is 9/10" (was 12); the money brakes are agy credits + gemini_meter
_ROUND_RE = re.compile(r"^(.*?)R(\d+)$")
_VERDICT_RE = re.compile(r"^## Last verdict\b.*?(?=^## )", re.M | re.S)


def _score(d: dict) -> float:
    try:
        return float(d.get("score", ""))
    except (TypeError, ValueError):
        return -1.0


def loop_next(task: str, contract: dict, before: dict, after: dict, branch: str, green: bool) -> str:
    """Operator S371 "let argon do all the fixes until its 9/10": a LOOP brief (`LOOP: <STEM> <target>`, task <STEM>R<n>)
    queues round n+1 on the same seat until Argon's after-film score reaches the target. A round that scored at least the
    one before it with every check green becomes the next BASE; a worse or red round is dropped (the next round starts from
    this round's BASE again and reads why). The next brief = this one with its BASE line, round number and '## Last
    verdict' section replaced. Merging stays with a session (S249)."""
    stem, _, target = contract["loop"].partition(" ")
    m = _ROUND_RE.match(task)
    n = int(m.group(2)) if m else 1
    a, b, goal = _score(after), _score(before), float(target or 9)
    if after.get("film") and not after.get("compile") and str(after.get("score", "?")) == "?":
        # S373: the judge failed (FIGHT9R2: Gemini's monthly spend cap, HTTP 429) - a film nobody scored is not a dropped
        # round; the loop holds until `seat_dispatch.py rejudge <task>` scores it.
        why = str(after.get("err") or "no verdict")[:140]
        return f"LOOP {stem}: round {n} NOT JUDGED ({why}) - loop holds; when the judge works: python Tools/seat_dispatch.py rejudge {task}"
    if a >= goal:
        return f"LOOP {stem}: round {n} scored {a:g}/10 - target {goal:g} reached, loop stops (a session collects {branch})"
    if n >= LOOP_MAX_ROUNDS:
        return f"LOOP {stem}: round {n} scored {a:g}/10 - {LOOP_MAX_ROUNDS} rounds spent, loop stops for a session to look"
    kept = green and a >= 0 and a >= b
    base = branch if kept else (contract.get("base") or "main")
    src = brief_contract.brief_path(task).read_text(encoding="utf-8", errors="replace")
    md = Path(after.get("verdict_file") or "")
    if after.get("compile"):
        verdict = ("Not filmed: your round did not compile (even after one repair pass), so the game could not start. "
                   "Godot printed:\n" + "\n".join("- " + e for e in after["compile"][:12]) + "\nYou cannot run Godot - use only "
                   "methods that exist on that exact type in Godot 4 (Array has any()/all(); PackedStringArray does not).")
    elif md.is_file():
        verdict = md.read_text(encoding="utf-8", errors="replace").strip()
    else:
        verdict = "(no verdict file: " + str(after.get("err") or after.get("why") or "?") + ")"
    head = (f"## Last verdict (round {n}: Argon {b:g} -> {a:g}/10 on {branch}; "
            + ("KEPT - this round's code is your BASE" if kept else "DROPPED - worse or a check failed; you start from the round before")
            + ")\n\n" + verdict + "\n\n")
    nxt = _VERDICT_RE.sub(lambda _m: head, src) if _VERDICT_RE.search(src) else src.replace("## Contract", head + "## Contract", 1)
    nxt = re.sub(r"^(\s*BASE\s*:).*$", lambda mm: f"{mm.group(1)} {base}", nxt, count=1, flags=re.M)
    nxt = re.sub(rf"\b{re.escape(task)}\b", f"{stem}R{n + 1}", nxt)
    new_id = f"{stem}R{n + 1}"
    brief_contract.brief_path(new_id).write_text(nxt, encoding="utf-8")
    seat = next(s for s, c in SEATS.items() if c["agent"] == load(RUNS, {}).get("runs", {}).get(task, {}).get("agent"))
    # S376 (operator: "use argon!"): AgentComms/loop_seats.json {stem: seat} moves a loop's next round to another seat
    # (FIGHT9 went to Cursor while agy's Argon allowance was spent; back on agy once Argon answers again).
    seat = str(load(COMMS / "loop_seats.json", {}).get(stem, seat))
    items = load(QUEUE, {"_doc": "Tasks for the CLI seats, drained by ops/Tools/seat_dispatch.py (30-min reconcile).", "items": []})
    items["items"].append({"task": new_id, "seat": seat, "status": "queued", "queued": _now(), "loop": stem})
    save(QUEUE, items)
    return f"LOOP {stem}: round {n} {b:g} -> {a:g}/10 ({'kept' if kept else 'dropped'}); QUEUED {new_id} for {seat} on BASE {base}"


# ---------------------------------------------------------------- entry points

def dispatch(act: bool = False, only: dict | None = None) -> list[str]:
    rows = [only] if only else queue_rows()
    if not rows:
        return ["SEAT_DISPATCH queue empty (no plan.next / waiting_seat / dispatch_queue row names qwen, cursor or antigravity)"]
    procs = processes()
    red, red_line = watchdog()
    e_free = shutil.disk_usage("E:/").free / 1e9 if Path("E:/").exists() else 999.0
    lines = [f"SEAT_DISPATCH watchdog {'RED' if red else 'ok'}: {red_line}"]
    for d in decide(rows, procs, red, red_line, e_free):
        lines.append(f"{d['verdict']:6s} {d['seat']:6s} {d['task'] or d['row']:16s} ({d['source']}) {d['why'] or 'all gates pass'}")
        if d["verdict"] == "LAUNCH":
            lines.append("  -> " + (launch(d) if act else f"dry run: --act creates {WT / ('LEAN_' + d['task'])} on "
                                                         f"{d['seat']}/{d['task'].lower()} and starts the runner"))
            if act and only is None:
                items = load(QUEUE, {"items": []})
                for it in items.get("items", []):
                    if str(it.get("task")) == d["task"] and it.get("status", "queued") == "queued":
                        it["status"], it["launched"] = "launched", _now()
                save(QUEUE, items)
    return lines


def selftest() -> int:
    contract = {"visual": True, "films": ["ops/previews/x/a.mp4"], "film": "",
                "red_test": {"test": "tools/ref_break_probe.gd", "args": "show3d seed=2", "pass_line": ""}}
    cases = [
        ("seat: antigravity+claude -> agy", seat_of("antigravity+claude") == "agy"),
        ("seat: qwen", seat_of("Qwen (pure module)") == "qwen"),
        ("seat: claude is no seat", seat_of("claude") == ""),
        ("seat: codex is no seat (S228)", seat_of("codex (after PAD1)") == ""),
        ("brief: TASK_ in the title", brief_for({"id": "REFBREAK", "title": "x (TASK_REFBREAK1)"}) == "REFBREAK1"),
        ("brief: id + 1", brief_for({"id": "REFBREAK"}) == "REFBREAK1"),
        ("film: RED_TEST probe + args", film_args(contract) == ["--script", "res://tools/ref_break_probe.gd", "--", "show3d", "seed=2"]),
        ("film: FILM line wins, --path dropped",
         film_args(dict(contract, film="godot.exe --path . --resolution 1920x1080 --script res://tools/fight3d_film.gd")) ==
         ["--resolution", "1920x1080", "--script", "res://tools/fight3d_film.gd"]),
        ("film: a test RED_TEST has no film", film_args(dict(contract, red_test={"test": "tests/x_test.gd"})) == []),
        ("film: VISUAL no -> none", not needs_film(dict(contract, visual=False))),
        ("owned: folder", owned("docs/agy/X.md", ["docs/agy/"]) and not owned("docs/x.md", ["docs/agy/"])),
        ("literal pass line", _literal("GYM_BILLS failures=0") and not _literal("OURS <= 250/min")),
        ("title: brief prefix dropped", short_title("RIVALPAST1", "TASK RIVALPAST1 - QWEN - a test for X (Lean)") == "a test for X"),
        ("title: agy brief", short_title("REFBREAK1", "# TASK_REFBREAK1 - the referee parts it (Antigravity)") == "the referee parts it"),
        ("verdict: score after the Verdict heading",
         read_verdict(chr(10).join(["x 3/10 noise", "### 5) Verdict", "Stiff but readable. 4/10"])) == ("4", "Stiff but readable. 4/10")),
    ]
    rows = [{"row": "A", "seat": "qwen", "task": "T1", "source": "t"}, {"row": "B", "seat": "agy", "task": "", "source": "t"}]
    g = globals()
    saved = {k: g[k] for k in ("brief_why", "fresh_why", "seat_busy", "pc_agents")}
    g.update(brief_why=lambda t: "" if t else "no brief", fresh_why=lambda t, s: "", seat_busy=lambda s, p: "", pc_agents=lambda p: [])
    d = decide(rows, [], True, "RED 90C", 100.0)
    cases.append(("decide: RED holds every launch", all(x["verdict"] == "WAIT" for x in d)))
    film_proc = [(1, "c:/godot.exe --path . --windowed --write-movie x.avi")]
    cases.append(("decide: AMBER + a render holds a launch", "render" in decide(rows[:1], film_proc, False, "t AMBER x", 100.0)[0]["why"]))
    cases.append(("decide: GREEN + a render may launch", "render" not in decide(rows[:1], film_proc, False, "t GREEN x", 100.0)[0]["why"]))
    cases.append(("decide: a row without a brief waits", "no brief" in d[1]["why"]))
    two = [dict(rows[0]), dict(rows[0], row="C", seat="cursor")]
    g["pc_agents"] = lambda p: ["agy pid 1"]
    d2 = decide(two, [], False, "t AMBER x", 100.0)
    cases.append(("decide: one launch per cycle, then the PC cap", d2[0]["verdict"] == "LAUNCH" and d2[1]["verdict"] == "WAIT"))
    g["pc_agents"] = lambda p: ["agy pid 1", "qwen pid 2"]
    cases.append(("decide: 2 PC agents hold a launch", "PC agents" in decide(rows[:1], [], False, "t GREEN x", 100.0)[0]["why"]))
    g.update(saved)
    fails = sum(1 for _, ok in cases if not ok)
    for name, ok in cases:
        print(f"{'OK  ' if ok else 'FAIL'} {name}")
    print(f"SEAT_DISPATCH_SELFTEST cases={len(cases)} failures={fails}")
    return 1 if fails else 0


def main(argv: list[str]) -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    args = [a for a in argv[1:]]
    opt = lambda k: args[args.index(k) + 1] if k in args and args.index(k) + 1 < len(args) else ""  # noqa: E731
    if args[:1] == ["selftest"]:
        return selftest()
    if args[:1] == ["run"] and len(args) > 1:
        return run(args[1])
    if args[:1] == ["films"] and len(args) > 1:
        task = args[1]
        contract, why = brief_contract.check_brief(task)
        branch = opt("--branch") or load(RUNS, {}).get("runs", {}).get(task, {}).get("branch", "")
        tmp = WT / f"FILM_{task}"
        res = {}
        for which, ref in (("before", "origin/main"), ("after", f"origin/{branch}")):
            git("fetch", "-q", "origin", "main", *([branch] if branch else []), timeout=300)
            sh(["git", "worktree", "add", "--detach", tmp, ref], timeout=600)
            sh(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", ROOT / "Tools" / "seed_godot_cache.ps1", "-Worktree", tmp],
               timeout=1800)
            res[which] = films(task, tmp, contract, which)
            sh(["git", "worktree", "remove", "--force", tmp], timeout=600)
        print(json.dumps(res, indent=1))
        print(post_board(task, res["before"], res["after"], branch))
        return 0
    if args[:1] == ["reloop"] and len(args) > 1:
        # S376: re-read a round's stored before/after verdicts (a parse fix, no judge spend) and step its loop again.
        task = args[1]
        info = load(RUNS, {}).get("runs", {}).get(task, {})
        contract, _why = brief_contract.check_brief(task)
        films_ = dict(info.get("films") or {})
        for which in ("before", "after"):
            md = PREVIEWS / task / f"{which}.gemini_argon.md"
            if md.is_file() and which in films_:
                score, line = read_verdict(md.read_text(encoding="utf-8", errors="replace"))
                films_[which] = dict(films_[which], score=score, line=line)
        update_run(task, films=films_)
        log(f"RELOOP {task}: before {films_.get('before', {}).get('score')}/10, after {films_.get('after', {}).get('score')}/10")
        green = all(c.get("ok") for c in info.get("checks") or [])
        if contract.get("loop") and films_.get("after", {}).get("score", "?") != "?":
            print(log(loop_next(task, contract, films_.get("before") or {}, films_["after"], str(info.get("branch", "")), green)))
        return 0
    if args[:1] == ["rejudge"] and len(args) > 1:
        # S373: score a round's kept after-film again (the judge failed) and step its loop from the stored run.
        task = args[1]
        info = load(RUNS, {}).get("runs", {}).get(task, {})
        contract, _why = brief_contract.check_brief(task)
        mp4 = PREVIEWS / task / "after.mp4"
        if not info or not mp4.is_file():
            print(f"rejudge: no run or no {mp4}")
            return 2
        title = brief_contract.brief_path(task).read_text(encoding="utf-8", errors="replace").splitlines()[0].lstrip("# ")
        after = judge(mp4, f"{task} after", f"Video = the agent's branch, after the change for {title}. Judge above all what this change is about.")
        log(f"JUDGE {task} after (rejudge): Argon {after['score']}/10 {after['line'][:120]}")
        films_ = dict(info.get("films") or {})
        films_["after"] = after
        update_run(task, films=films_)
        green = all(c.get("ok") for c in info.get("checks") or [])
        if contract.get("loop") and after["score"] != "?":
            print(log(loop_next(task, contract, films_.get("before") or {}, after, str(info.get("branch", "")), "--green" in args or green)))
        return 0 if after["score"] != "?" else 1
    if args[:1] == ["queue"]:
        task, seat = opt("--task").removeprefix("TASK_"), opt("--seat")
        if seat not in SEATS or not task:
            print("queue needs --task <ID> --seat qwen|cursor|agy")
            return 2
        items = load(QUEUE, {"_doc": "Tasks for the CLI seats, drained by ops/Tools/seat_dispatch.py (30-min reconcile).", "items": []})
        items["items"].append({"task": task, "seat": seat, "status": "queued", "queued": _now()})
        save(QUEUE, items)
        print(log(f"QUEUED {task} for {seat}"))
        return 0
    only = None
    if opt("--task"):
        seat = opt("--seat")
        if seat not in SEATS:
            print("--task needs --seat qwen|cursor|agy")
            return 2
        task = opt("--task").removeprefix("TASK_")
        only = {"row": task, "seat": seat, "task": task if brief_contract.brief_path(task).is_file() else "", "title": "",
                "source": "command line"}
    for line in dispatch(act="--act" in args, only=only):
        print(line)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
