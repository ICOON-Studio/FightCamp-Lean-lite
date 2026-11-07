"""godot_slot.py - a first-come queue for agent Godot jobs (S398, operator: "sure" to "Build a first-come queue for agent
Godot jobs so I stop pausing sessions by hand").

Seven sessions shared one PC: every time the watchdog cleared, whichever session asked first grabbed the CPU and the rest
waited forever (Menus waited 40 min twice for a 3-min render; the main session paused everyone by hand four times). Now
every agent Godot job takes a ticket and starts in arrival order when a slot is free.

    python ops/Tools/godot_slot.py run --who menus -- "<godot.exe>" --headless --path . --script res://tests/x_test.gd
    python ops/Tools/godot_slot.py status        # the queue: running, waiting, and the slots the PC allows now

Slots come from the PC watchdog's verdict (AgentComms/pc_detail.json, written every few seconds by pc_metrics):
GREEN 3, AMBER 2, RED 0, and 0 whenever commit memory is under MIN_COMMIT_GB free. A ticket whose process died is dropped.
The job's own exit code is returned, its output is not touched (stdout/stderr pass through). The heat governor still
suspends and pins running jobs; the queue only decides who STARTS. The operator's own Godot (editor or game, no
--script/--headless) never goes through here, and rule_guard refuses a direct agent Godot launch that skips it.
"""
from __future__ import annotations

import argparse
import ctypes
import json
import os
import re
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]                 # ops/
# The watchdog file lives in the MAIN checkout (pc_metrics writes it there); a worktree's copy of this script must read that
# one, not its own ops/AgentComms (S398, anim-chain: a worktree copy fell back to "1 slot" with no RED check).
DETAIL = Path(os.environ.get("GODOT_SLOT_DETAIL", r"E:\FightCamp\Lean\ops\AgentComms\pc_detail.json"))
QUEUE = Path(os.environ.get("GODOT_SLOT_DIR", r"E:\FightCamp\tmp\godot_queue"))
LOCK = QUEUE / ".lock"
SLOTS = {"GREEN": 3, "AMBER": 2, "RED": 0}
MIN_COMMIT_GB = 4.0
POLL_S = 5.0
STALE_DETAIL_S = 120     # a verdict older than this is not trusted: one slot, so work still moves if pc_metrics is down


def _alive(pid: int) -> bool:
    if pid <= 0:
        return False
    k = ctypes.windll.kernel32
    h = k.OpenProcess(0x1000, False, pid)   # PROCESS_QUERY_LIMITED_INFORMATION
    if not h:
        return False
    code = ctypes.c_ulong()
    ok = k.GetExitCodeProcess(h, ctypes.byref(code))
    k.CloseHandle(h)
    return bool(ok) and code.value == 259     # STILL_ACTIVE


def pc_slots() -> tuple[int, str]:
    try:
        d = json.loads(DETAIL.read_text(encoding="utf-8"))
        v = d.get("verdict", {})
        line = str(v.get("line", ""))
        if time.time() - float(d.get("t", 0)) > STALE_DETAIL_S:
            return 1, "watchdog detail is stale - 1 slot"
        state = str(v.get("state", "AMBER"))
        m = re.search(r"COMMIT_free=([\d.]+)GB", line)
        commit = float(m.group(1)) if m else 99.0
        if commit < MIN_COMMIT_GB:
            return 0, f"{state}, commit {commit:.1f} GB free < {MIN_COMMIT_GB:.0f}"
        return SLOTS.get(state, 1), f"{state}, commit {commit:.1f} GB free"
    except Exception as exc:  # no detail file: one slot, never a deadlock
        return 1, f"no watchdog detail ({exc.__class__.__name__}) - 1 slot"


def tickets() -> list[dict]:
    QUEUE.mkdir(parents=True, exist_ok=True)
    out = []
    for p in sorted(QUEUE.glob("*.json")):
        try:
            t = json.loads(p.read_text(encoding="utf-8"))
        except Exception:
            continue
        if not _alive(int(t.get("pid", 0))):
            p.unlink(missing_ok=True)           # its waiter or job died: drop the ticket
            continue
        t["_path"] = p
        out.append(t)
    return out


class Lock:
    def __enter__(self):
        QUEUE.mkdir(parents=True, exist_ok=True)
        for _ in range(600):
            try:
                self.fd = os.open(str(LOCK), os.O_CREAT | os.O_EXCL | os.O_WRONLY)
                return self
            except FileExistsError:
                try:   # a lock left by a killed process
                    if time.time() - LOCK.stat().st_mtime > 30:
                        LOCK.unlink(missing_ok=True)
                except OSError:
                    pass
                time.sleep(0.1)
        raise TimeoutError("godot_slot lock")

    def __exit__(self, *a):
        os.close(self.fd)
        LOCK.unlink(missing_ok=True)


def run(who: str, cmd: list[str], max_wait: float) -> int:
    QUEUE.mkdir(parents=True, exist_ok=True)
    me = QUEUE / f"{time.time_ns()}_{os.getpid()}.json"
    me.write_text(json.dumps({"pid": os.getpid(), "who": who, "cmd": " ".join(cmd)[:300], "queued": time.time(),
                              "state": "waiting"}), encoding="utf-8")
    t0, said = time.time(), ""
    try:
        while True:
            with Lock():
                ts = tickets()
                running = [t for t in ts if t.get("state") == "running"]
                waiting = [t for t in ts if t.get("state") != "running"]
                slots, why = pc_slots()
                free = slots - len(running)
                pos = next((i for i, t in enumerate(waiting) if t["_path"] == me), 0)
                if pos < free:
                    data = json.loads(me.read_text(encoding="utf-8"))
                    data.update(state="running", started=time.time())
                    me.write_text(json.dumps(data), encoding="utf-8")
                    break
            msg = f"GODOT_SLOT waiting: place {pos + 1}, {len(running)} running, slots {slots} ({why})"
            if msg != said:
                print(msg, file=sys.stderr, flush=True)
                said = msg
            if max_wait and time.time() - t0 > max_wait:
                print(f"GODOT_SLOT gave up after {max_wait:.0f} s", file=sys.stderr, flush=True)
                return 75
            time.sleep(POLL_S)
        print(f"GODOT_SLOT start after {time.time() - t0:.0f} s ({who})", file=sys.stderr, flush=True)
        # S398: Godot_v4*.exe is a GUI-subsystem program - with inherited handles its stdout/stderr were LOST under this
        # wrapper (tests "passed" with rc 0 and no output). Capture and relay line by line instead (stderr folded into stdout).
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, stdin=subprocess.DEVNULL)
        out = sys.stdout.buffer
        for line in iter(p.stdout.readline, b""):
            out.write(line)
            out.flush()
        return p.wait()
    finally:
        me.unlink(missing_ok=True)


def status() -> int:
    slots, why = pc_slots()
    ts = tickets()
    print(f"slots {slots} ({why}); {sum(t.get('state') == 'running' for t in ts)} running, "
          f"{sum(t.get('state') != 'running' for t in ts)} waiting")
    now = time.time()
    for t in ts:
        since = now - float(t.get("started") or t.get("queued") or now)
        print(f"  {t.get('state', '?'):8} {since:6.0f}s  {t.get('who', '?'):18} {t.get('cmd', '')[:110]}")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description="first-come queue for agent Godot jobs")
    sub = ap.add_subparsers(dest="op", required=True)
    r = sub.add_parser("run")
    r.add_argument("--who", default=os.environ.get("CLAUDE_SESSION_NAME", "agent"))
    r.add_argument("--max-wait", type=float, default=0, help="seconds; 0 = wait as long as it takes")
    r.add_argument("cmd", nargs=argparse.REMAINDER)
    sub.add_parser("status")
    a = ap.parse_args()
    if a.op == "status":
        return status()
    cmd = a.cmd[1:] if a.cmd[:1] == ["--"] else a.cmd
    if not cmd:
        ap.error("run needs a command after --")
    return run(a.who, cmd, a.max_wait)


if __name__ == "__main__":
    sys.exit(main())
