"""where_we_are.py - the "P0 Where we are" map: DONE (earlier / this session) / NOW / NEXT, one card per item (S385).

Operator S385 (on Blacktop Dynasty's P0 board): "i want a map similar to this for this project, needs to be updated on
every session end or start". The cards live in AgentComms/roadmap.json `plan.map`; NOW also shows every unattended seat
run that is running or queued (AgentComms/live_runs.json), so the agents' work is never stale. Miro is drawn from
`json` (or `svg`, when where_we_are_svg.py exists) by the session: one canvas_update_from_svg call.

    python Tools/where_we_are.py roll S386          # session START: this session's DONE cards move to Earlier
    python Tools/where_we_are.py done "Training screen merged" [--who claude|agent|operator]
    python Tools/where_we_are.py now  "DEFFLOW2 round 3" [--who claude]     # a NOW card (the session's own work)
    python Tools/where_we_are.py next "Wire the owned takes" [--who claude]
    python Tools/where_we_are.py drop "<text>"       # take a card off NOW / NEXT (it is done or no longer planned)
    python Tools/where_we_are.py show | json | svg

Card text <= 34 characters (the Miro card width); `who` colours it: claude purple, agent blue, operator orange.
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

OPS = Path(__file__).resolve().parent.parent
ROADMAP = OPS / "AgentComms" / "roadmap.json"
RUNS = OPS / "AgentComms" / "live_runs.json"
EARLIER_MAX = 14
TEXT_MAX = 34
SEATS = {"antigravity": "agy", "cursor": "Cursor", "qwen": "Qwen", "ziva": "Ziva", "cline": "Cline", "arena": "Arena"}


def _load() -> dict:
    return json.loads(ROADMAP.read_text(encoding="utf-8"))


def _save(d: dict) -> None:
    ROADMAP.write_text(json.dumps(d, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")


def _map(d: dict) -> dict:
    m = d.setdefault("plan", {}).setdefault("map", {})
    for k in ("done_earlier", "done_session", "now", "next"):
        m.setdefault(k, [])
    m.setdefault("session", "")
    return m


def _card(text: str, who: str) -> dict:
    t = " ".join(text.split())
    if len(t) > TEXT_MAX:
        raise SystemExit(f"card text over {TEXT_MAX} characters ({len(t)}): {t!r}")
    return {"text": t, "who": who if who in ("claude", "agent", "operator") else "claude"}


def seat_cards() -> list[dict]:
    """Unattended seat runs running or queued now (live_runs.json), as NOW cards."""
    try:
        runs = json.loads(RUNS.read_text(encoding="utf-8")).get("runs", {})
    except (OSError, ValueError):
        return []
    out = []
    for task, r in runs.items():
        state = str(r.get("state") or r.get("status") or "")
        if state in ("running", "queued", "launching"):
            seat = SEATS.get(str(r.get("agent", "")), str(r.get("agent", "")))
            out.append({"text": f"{task} ({seat}{', queued' if state == 'queued' else ''})"[:TEXT_MAX], "who": "agent"})
    return out


def cards() -> dict:
    d = _load()
    m = _map(d)
    return {"session": m["session"], "done_earlier": m["done_earlier"][:EARLIER_MAX], "done_session": m["done_session"],
            "now": m["now"] + [c for c in seat_cards() if c["text"] not in {x["text"] for x in m["now"]}],
            "next": m["next"]}


def main(argv: list[str]) -> int:
    if not argv or argv[0] in ("-h", "--help"):
        print(__doc__)
        return 0
    cmd, rest = argv[0], argv[1:]
    who = "claude"
    if "--who" in rest:
        i = rest.index("--who")
        who = rest[i + 1]
        rest = rest[:i] + rest[i + 2:]
    if cmd in ("show", "json", "svg"):
        c = cards()
        if cmd == "json":
            print(json.dumps(c, indent=1, ensure_ascii=False))
        elif cmd == "svg":
            try:
                import where_we_are_svg  # noqa: PLC0415 (written by the Miro build, S385)
            except ImportError:
                print("where_we_are_svg.py not built yet - draw from `json`")
                return 1
            print(where_we_are_svg.render(c))
        else:
            print(f"P0 WHERE WE ARE ({c['session'] or 'no session'})")
            for k, title in (("done_session", "DONE this session"), ("done_earlier", "DONE earlier"), ("now", "NOW"), ("next", "NEXT")):
                print(f"  {title}:")
                for x in c[k]:
                    print(f"    [{x['who'][0]}] {x['text']}")
        return 0
    d = _load()
    m = _map(d)
    if cmd == "roll":
        if rest:
            m["done_earlier"] = (m["done_session"] + m["done_earlier"])[:EARLIER_MAX]
            m["done_session"] = []
            m["session"] = rest[0]
    elif cmd in ("done", "now", "next"):
        c = _card(" ".join(rest), who)
        key = "done_session" if cmd == "done" else cmd
        if cmd == "done":   # a done card leaves NOW / NEXT
            for k in ("now", "next"):
                m[k] = [x for x in m[k] if x["text"] != c["text"]]
        if c["text"] not in {x["text"] for x in m[key]}:
            m[key].append(c)
    elif cmd == "drop":
        t = " ".join(" ".join(rest).split())
        for k in ("now", "next"):
            m[k] = [x for x in m[k] if x["text"] != t]
    else:
        print(f"unknown command {cmd!r}")
        return 2
    _save(d)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
