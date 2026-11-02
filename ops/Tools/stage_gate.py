#!/usr/bin/env python3
"""THE STAGE GATE — one session, one stage, enforced rather than requested.

CLAUDE.md has said "One session per stage. The moment a stage ships (commit
pushed, digest written), end the session" since 2026-09-03. On 2026-09-19 a
single session shipped FIVE stages and fifteen commits, and the operator's
verdict on the result was that it was obstructing the project. Every rule that
session broke was one with no mechanical gate behind it; not one gated rule was
broken. So this is the gate.

HOW IT WORKS, and the design constraint that shapes it: the check must tell
"THIS session already shipped" apart from "SOME session shipped today",
because a fresh session on the same day is exactly the thing we WANT and a
naive date check would refuse it.

  * `agent_comms.py start` mints a session id into `AgentComms/.session`.
  * `agent_comms.py ship` appends that id to `AgentComms/.shipped`.
  * The build tools call `enforce()`. If the CURRENT id is already shipped,
    they refuse.

Both files are untracked and per-checkout, so a fresh session mints a fresh id
and is never blocked by the last one's work.

THE OVERRIDE IS DELIBERATE AND NAMED: `FIGHTCAMP_STAGE_GATE=off`. A gate with
no override is a gate someone rips out the first time it is wrong at 2am. It
prints loudly when used, so the override cannot be silent.
"""
from __future__ import annotations

import os
import sys
import uuid
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SESSION_FILE = ROOT / "AgentComms" / ".session"
SHIPPED_FILE = ROOT / "AgentComms" / ".shipped"
OVERRIDE_ENV = "FIGHTCAMP_STAGE_GATE"


def begin_session() -> str:
    """Mint a fresh id for this session. Called by `agent_comms.py start`."""
    session_id = uuid.uuid4().hex[:12]
    SESSION_FILE.parent.mkdir(parents=True, exist_ok=True)
    SESSION_FILE.write_text(session_id + "\n", encoding="utf-8")
    return session_id


def current_session() -> str:
    try:
        return SESSION_FILE.read_text(encoding="utf-8").strip()
    except OSError:
        return ""


def _shipped() -> set[str]:
    try:
        return {line.strip() for line in SHIPPED_FILE.read_text(encoding="utf-8").splitlines() if line.strip()}
    except OSError:
        return set()


def mark_shipped() -> str:
    """Record that THIS session has shipped its stage."""
    session_id = current_session()
    if not session_id:
        session_id = begin_session()
    if session_id not in _shipped():
        SHIPPED_FILE.parent.mkdir(parents=True, exist_ok=True)
        with open(SHIPPED_FILE, "a", encoding="utf-8") as handle:
            handle.write(session_id + "\n")
    return session_id


def has_shipped() -> bool:
    session_id = current_session()
    return bool(session_id) and session_id in _shipped()


def enforce(what: str) -> None:
    """Refuse build work in a session that has already shipped its stage.

    NOT a silent no-op when the gate is off, and NOT a bare exit when it
    fires: a refusal that does not say what to do instead is a refusal
    someone works around.
    """
    if not has_shipped():
        return
    if os.environ.get(OVERRIDE_ENV, "").lower() in ("off", "0", "false"):
        print("!! STAGE GATE OVERRIDDEN (%s=off) - %s proceeding in a session that already shipped."
              % (OVERRIDE_ENV, what), file=sys.stderr)
        return
    sys.stderr.write(
        "\n"
        "==============================================================================\n"
        "  STAGE GATE: THIS SESSION HAS ALREADY SHIPPED ITS STAGE. STOP HERE.\n"
        "==============================================================================\n"
        "  Refusing: %s\n"
        "\n"
        "  CLAUDE.md: \"One session per stage. The moment a stage ships (commit\n"
        "  pushed, digest written), end the session with the report and start a\n"
        "  fresh one; never compact or continue into the next stage.\"\n"
        "\n"
        "  On 2026-09-19 one session shipped FIVE stages and fifteen commits. Every\n"
        "  rule it broke was one with no gate behind it - unsigned commits, handover\n"
        "  notes written to a key `start` never prints, a decision filed as a\n"
        "  question so the NEXT session opened by asking what to build. The operator\n"
        "  called it obstructing the project, and they were right. This is the gate.\n"
        "\n"
        "  WHAT TO DO NOW:\n"
        "    * Report to the operator and hand over the block. You are finished.\n"
        "    * Work that is genuinely part of the SHIPPED stage - a review comment,\n"
        "      a red test you caused - is finished with %s=off, said out loud.\n"
        "    * A NEW stage is a NEW session. Tell the operator to clear.\n"
        "==============================================================================\n"
        % (what, OVERRIDE_ENV)
    )
    raise SystemExit(3)


if __name__ == "__main__":
    action = sys.argv[1] if len(sys.argv) > 1 else "status"
    if action == "begin":
        print(begin_session())
    elif action == "ship":
        print(mark_shipped())
    elif action == "check":
        enforce("stage_gate.py check")
        print("stage gate: clear (session %s has not shipped)" % (current_session() or "<none>"))
    else:
        print("session=%s shipped=%s" % (current_session() or "<none>", has_shipped()))
