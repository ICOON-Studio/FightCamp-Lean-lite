#!/usr/bin/env python3
"""Stop hook: Claude may not go idle mid-stage, and no shell agent may sit idle.

Operator 2026-09-30 (S133), verbatim: "why you are idle right now ?" / "why all agents are fucking idle ?" /
"make sure this idleness cannot happen again".

A turn may END only when one of these holds:
  1. this session has shipped its stage (`python Tools/agent_comms.py ship` - Tools/stage_gate.has_shipped), or
  2. Claude wrote `AgentComms/.stop_ok` in the last 10 minutes with a reason: a question only the operator can
     answer (money, taste, scope) - `python ops/Tools/idle_guard.py ok "<reason>"`.
Otherwise the stop is refused and Claude is told to keep working, naming every in-rotation shell agent (codex,
cursor, qwen, grok in AgentComms/roster.json) that has no process running - brief and launch it.

Never wedges a session: after MAX_BLOCKS consecutive refusals inside BLOCK_WINDOW_S the stop is allowed and the
count is reported. Any unexpected error allows the stop.
"""

import json
import os
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
STOP_OK = ROOT / "AgentComms" / ".stop_ok"
COUNTER = ROOT / "AgentComms" / ".idle_guard_blocks"
STOP_OK_TTL_S = 600
MAX_BLOCKS = 6
BLOCK_WINDOW_S = 1800
SHELL_AGENTS = {
    "codex": ["codex.js\" exec", "codex.exe exec"],  # the CLI job, not the Codex desktop app
    "cursor": ["cursor-agent"],
    "qwen": ["qwen-code", "qwen.cmd"],
    "grok": ["grok.exe"],
}


def allow(msg: str = "") -> None:
    if msg:
        print(msg, file=sys.stderr)
    sys.exit(0)


def block(reason: str) -> None:
    print(json.dumps({"decision": "block", "reason": reason}))
    sys.exit(0)


def idle_agents() -> list[str]:
    try:
        roster = json.loads((ROOT / "AgentComms" / "roster.json").read_text(encoding="utf-8"))
    except Exception:
        return []
    try:
        out = subprocess.run(
            ["powershell", "-NoProfile", "-Command",
             "Get-CimInstance Win32_Process | ForEach-Object { $_.Name + ' ' + $_.CommandLine }"],
            capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=25).stdout
    except Exception:
        return []
    idle = []
    for name, marks in SHELL_AGENTS.items():
        entry = roster.get(name, {})
        if not isinstance(entry, dict) or not entry.get("in_rotation", False):
            continue
        if not any(m.lower() in out.lower() for m in marks):
            idle.append(name)
    return idle


def main() -> None:
    if len(sys.argv) >= 3 and sys.argv[1] == "ok":
        STOP_OK.write_text("%d %s\n" % (int(time.time()), " ".join(sys.argv[2:])), encoding="utf-8")
        print("stop allowed for %d s: %s" % (STOP_OK_TTL_S, " ".join(sys.argv[2:])))
        return
    try:
        payload = json.load(sys.stdin)
    except Exception:
        allow()
    cwd = str(payload.get("cwd", ""))
    # S366: the workflow moved into the Lean repo (ops/); the old "ChatGPT"/"Game" check made this guard a no-op since S138
    if "FightCamp" not in cwd or "Lean" not in cwd:
        allow()
    sys.path.insert(0, str(ROOT / "Tools"))
    try:
        import stage_gate
        if stage_gate.has_shipped():
            allow()
    except Exception:
        allow()
    try:
        stamp = int(STOP_OK.read_text(encoding="utf-8").split()[0])
        if time.time() - stamp < STOP_OK_TTL_S:
            allow()
    except Exception:
        pass
    now = time.time()
    blocks: list[float] = []
    try:
        blocks = [float(x) for x in COUNTER.read_text(encoding="utf-8").split() if now - float(x) < BLOCK_WINDOW_S]
    except Exception:
        pass
    if len(blocks) >= MAX_BLOCKS:
        COUNTER.write_text("", encoding="utf-8")
        allow("idle_guard: allowed after %d refusals in %d min" % (len(blocks), BLOCK_WINDOW_S // 60))
    blocks.append(now)
    COUNTER.write_text(" ".join(str(b) for b in blocks), encoding="utf-8")
    idle = idle_agents()
    reason = ("IDLE GUARD (operator 2026-09-30: 'make sure this idleness cannot happen again'): the stage is not "
              "shipped - do not end the turn to report. Take the next item of roadmap `now` / your queue and keep "
              "working; report only at the stage end.")
    if idle:
        reason += " IDLE SHELL AGENTS: %s - brief and launch each on demo-path work now (watchdog GREEN first)." % ", ".join(idle)
    reason += (" Only if you need an answer only the operator can give (money, taste, scope): "
               "`python ops/Tools/idle_guard.py ok \"<reason>\"` then ask.")
    block(reason)


if __name__ == "__main__":
    try:
        main()
    except SystemExit:
        raise
    except Exception:
        sys.exit(0)
