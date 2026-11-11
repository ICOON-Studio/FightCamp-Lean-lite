#!/usr/bin/env python3
"""lean_anim_catalogue.py - the boxer animations the Lean game's fight actually plays (S365).

Operator S365: "can you update the boxer animations, to see what we have ingame" (the /animations page still listed the old
repo's Rokoko takes and C223 gates; the restarted game in E:\\FightCamp\\Lean plays the MoCap Online Punch PRO pack).

DERIVED, NEVER COPIED: every list is read from Lean's own scripts at request time.
  - Lean/scripts/fight3d/BeatClips.gd   PUNCH (stem x plain takes x context suffixes, punch()), REACT + BIG_REACT (pick():
    every pro_ take that exists), DEFENCE (first() for block / pull; both side dodges and weaves for slip / weave),
    TIRED / WIN / DOWN / OUT (pick()), GUARD (first()).
  - Lean/scripts/fight3d/GuardLife.gd   FIDGETS (the guard's hands-up fidgets).
  - Lean/scripts/fight3d/Footwork.gd    STRIDE (the steps).
  - Lean/scripts/fight3d/FightClips.gd  PAIR (clinch) and ENTRY (ring entry); the baked clips on disk.
IN GAME = a beat can pick it. LOADED = in the body's library, but nothing in the fight picks it.
Previews: Game/previews/lean_anim/<id>.mp4 (Lean/tools/clip_orbit.gd + Tools/lean_anim_render.py).
VERIFIED (S379, operator: "on the boxing show me only what is supposed to be 100% correct"): a clip with a pass:true row in
AgentComms/clip_verdicts.json (your OK on its own video, or the Argon clip judge at 9/10+ with no defect). A clip with only
pass:false rows (a probe, a fix OK'd on stills, a lower score) is IN PROGRESS; one with no recorded check is NOT STARTED.

    python Tools/lean_anim_catalogue.py          # the table
    python Tools/lean_anim_catalogue.py --json   # what the ops board serves at /api/animations
    python Tools/lean_anim_catalogue.py --ids    # the clip ids, one per line (for the renderer)
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LEAN = Path("E:/FightCamp/Lean")
FIGHT3D = LEAN / "scripts" / "fight3d"
BAKED = LEAN / "assets" / "anim" / "baked"
PREVIEW_ROOT = ROOT / "previews"
PREVIEWS = PREVIEW_ROOT / "lean_anim"
VERDICTS = ROOT / "AgentComms" / "clip_verdicts.json"
PRO_PREFIX = "mc_Box1_M3_"
## punch() context takes, in the order the beat asks for them (big / step / miss / tired).
PUNCH_SUFFIXES = ["_special", "_hard", "_hard_ft", "_ft", "_miss", "_hurt", "_hurt_ft"]


def _const(src: str, name: str) -> str:
    """The text of `const NAME := ...` up to the next blank line or top-level statement."""
    m = re.search(r"^const %s\s*:=\s*(.*?)(?=^\S)" % re.escape(name), src + "\nEND", re.S | re.M)
    return m.group(1) if m else ""


def _names(text: str) -> list[str]:
    return re.findall(r'"([a-z0-9_]+)"', text)


def _dict_rows(text: str) -> dict[str, list[str]]:
    """{"key": [...names...]} rows of a GDScript dict of string arrays."""
    out: dict[str, list[str]] = {}
    text = re.sub(r"#[^\n]*", "", text)
    for m in re.finditer(r'"([a-z_]+)":\s*\[', text):
        end = text.index("]", m.end())
        out[m.group(1)] = _names(text[m.end():end])
    return out


def _library() -> dict[str, str]:
    """Every pro_ clip on disk: game name -> baked file name."""
    lib = {}
    for f in sorted(BAKED.glob(PRO_PREFIX + "*.res")):
        lib["pro_" + f.stem[len(PRO_PREFIX):].lower()] = f.name
    return lib


def _label(cid: str) -> str:
    s = cid.removeprefix("pro_").replace("_", " ")
    s = re.sub(r"\bv(\d)\b", r"take \1", s)
    s = s.replace(" ft", " (stepping in)").replace("slighty", "slightly").replace("hit by", "hit by a")
    return s[:1].upper() + s[1:]


def _preview(cid: str) -> dict:
    mp4 = PREVIEWS / f"{cid}.mp4"
    return {"video": mp4.relative_to(PREVIEW_ROOT).as_posix()} if mp4.is_file() else {}


def verdicts(section: str) -> tuple[dict, str]:
    """{clip id: [recorded checks]} of one section of clip_verdicts.json, and the bar a pass must meet."""
    try:
        data = json.loads(VERDICTS.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return {}, ""
    return {str(k): list(v) for k, v in (data.get(section) or {}).items()}, str(data.get("bar", ""))


def progress_of(checks: list) -> str:
    if any(c.get("pass") is True for c in checks):
        return "verified"
    return "in progress" if checks else "not started"


def build() -> dict:
    beat = (FIGHT3D / "BeatClips.gd").read_text(encoding="utf-8")
    life = (FIGHT3D / "GuardLife.gd").read_text(encoding="utf-8")
    foot = (FIGHT3D / "Footwork.gd").read_text(encoding="utf-8")
    clips = (FIGHT3D / "FightClips.gd").read_text(encoding="utf-8")
    lib = _library()
    checks, bar = verdicts("boxing")
    have = lambda n: n in lib  # noqa: E731
    used: dict[str, str] = {}   # clip -> what plays it

    def use(names, why):
        for n in names:
            used.setdefault(n, why)

    punch_rows = re.findall(r'"([a-z_]+)":\s*\["([a-z_]+)",\s*\[(.*?)\]', _const(beat, "PUNCH"))
    punches = []
    for move, stem, plain in punch_rows:
        base = "pro_" + stem
        takes = list(dict.fromkeys(t for t in [base + x for x in [""] + re.findall(r'"(_?[a-z0-9]*)"', plain)] if have(t)))
        ctx = [base + s for s in PUNCH_SUFFIXES if have(base + s)]
        if move == "body_hook" and have("pro_kidney_shot"):
            ctx.append("pro_kidney_shot")
        punches += takes + ctx
        use(takes + ctx, "the %s beat" % move.replace("_", " "))
    react = _dict_rows(_const(beat, "REACT"))
    reacts = []
    for move, names in react.items():
        got = [n for n in names if n.startswith("pro_") and have(n)]
        reacts += got
        use(got, "hit by the %s" % move.replace("_", " ") if move != "hurt" else "the knockback when hurt")
    big = [n for n in _names(_const(beat, "BIG_REACT")) if have(n)]
    use(big, "the round's big shot to the head")
    defence = _dict_rows(_const(beat, "DEFENCE"))
    guards = []
    for kind, names in defence.items():
        if kind in ("slip", "weave"):
            got = [n for n in ("pro_left_" + ("dodge" if kind == "slip" else "weave"), "pro_right_" + ("dodge" if kind == "slip" else "weave")) if have(n)]
        else:
            got = [next((n for n in names if have(n) or not n.startswith("pro_")), "")]
        got = [g for g in got if g]
        guards += got
        use(got, "the %s defence" % kind)
    lists = {k: [n for n in _names(_const(beat, k)) if n.startswith("pro_") and have(n)] for k in ("TIRED", "WIN", "DOWN", "OUT")}
    use(lists["TIRED"], "a tired beat")
    use(lists["WIN"], "the winner after a stoppage")
    use(lists["DOWN"], "a knockdown she beats the count from")
    use(lists["OUT"], "a knockout")
    guard = next((n for n in _names(_const(beat, "GUARD")) if have(n)), "pro_idle")
    fidgets = [n for n in _names(_const(life, "FIDGETS")) if have(n)]
    use([guard], "the guard between every move")
    use(fidgets, "the guard's fidgets")
    steps = list(re.findall(r'"([a-z_]+)":\s*\[', _const(foot, "STRIDE")))
    use(steps, "footwork")
    pair = _names(_const(clips, "PAIR"))
    use(pair, "the clinch (two-person, played pure)")
    entry = list(re.findall(r'"([a-z_]+)":', _const(clips, "ENTRY")))
    use(entry, "walking out: through the ropes")

    def row(cid: str) -> dict:
        r = {"id": cid, "label": _label(cid), "status": "IN GAME" if cid in used else "LOADED",
             "why": ("Plays as " + used[cid]) if cid in used else "In the library; nothing in the fight picks it.",
             "source": "MoCap Online Punch PRO" if cid.startswith("pro_") else "baked (old repo pipeline)"}
        if cid in pair:
            r["source"] = "Cascadeur pair"
        if cid in entry:
            r["source"] = "Mixamo, retargeted"
        r.update(_preview(cid))
        r["checks"] = checks.get(cid, [])
        r["progress"] = progress_of(r["checks"])
        return r

    groups = [
        ("Guard and footwork", [guard] + fidgets + steps + lists["TIRED"]),
        ("Punches", list(dict.fromkeys(punches))),
        ("Defence", list(dict.fromkeys(guards))),
        ("Getting hit", list(dict.fromkeys(reacts + big))),
        ("Knockdowns, knockouts, wins", lists["DOWN"] + lists["OUT"] + lists["WIN"]),
        ("Clinch and ring entry", pair + entry),
    ]
    # S399: the captured clips the fight plays PURE (scripts/fight3d/RkClips.gd: Rokoko via the old repo route + Mixamo walks)
    rk_path = LEAN / "scripts" / "fight3d" / "RkClips.gd"
    rk_src = rk_path.read_text(encoding="utf-8", errors="replace") if rk_path.is_file() else ""
    rk_block = rk_src.split("const CLIPS := {", 1)[1].split("\n}", 1)[0] if "const CLIPS := {" in rk_src else ""
    rk_ids = list(dict.fromkeys(re.findall(r'"(rk_[a-z_0-9]+)"\s*:', rk_block)))
    if rk_ids:
        groups.insert(0, ("Captured clips (Rokoko + Mixamo): switched off since S430", rk_ids))
    shown = {c for _, ids in groups for c in ids}
    groups.append(("In the library, never picked", [c for c in lib if c not in shown]))
    out = []
    counts: dict[str, int] = {}
    prog = {"verified": 0, "in progress": 0, "not started": 0}
    for title, ids in groups:
        rows = [row(c) for c in ids]
        if title.startswith("Captured clips"):
            for r in rows:
                # S437 (operator, on rk_jab / rk_cross tagged "In the fight"): the captured takes are OFF since his S430
                # call (RkClips.on() is false by default); a take returns alone once it passes the posture limits.
                r["status"] = "LOADED"
                r["source"] = "Rokoko / Mixamo capture, old repo route (S399)"
                r["why"] = "Captured take, switched off since S430 (the fight plays the Punch PRO clips). Not in the fight."
        for r in rows:
            counts[r["status"]] = counts.get(r["status"], 0) + 1
            prog[r["progress"]] += 1
        out.append({"group": title, "rows": rows})
    total = sum(prog.values())
    in_fight = counts.get("IN GAME", 0)
    # S421: he read "1 of 169" as "only 1 animation". The game has all 169; this list holds only the ones checked 100%
    # (his S379 rule), so the line says both, and what the others are waiting on.
    shown = ("The game has %d boxing clips (%d play in the fight). Listed here: only the %d that passed %s (your S379 rule). "
             "The other %d: %d being checked, %d not checked yet." % (
        total, in_fight, prog["verified"], bar or "a recorded 100%% check", total - prog["verified"],
        prog["in progress"], prog["not started"]))
    none = ("No boxing clip has passed a 100%% check yet. Recorded so far: %d clips with a partial check (a probe, a fix you "
            "OK'd on stills, or an Argon/Gemini score below 9/10) - see them under 'show all'." % prog["in progress"]
            if prog["verified"] == 0 else "")
    return {"groups": out, "counts": counts, "game": "lean", "progress": prog, "total": total, "shown_rule": shown,
            "none_verified": none, "bar": bar,
            "rule": "IN GAME = a beat of the Lean fight can pick it (BeatClips.gd, GuardLife.gd, Footwork.gd, FightClips.gd, read now). "
                    "Each preview is the clip alone on the game's boxer body; the live fight also blends the joins and bends the arm to the target"}


def main(argv: list[str]) -> int:
    data = build()
    if "--json" in argv:
        print(json.dumps(data, indent=1))
    elif "--ids" in argv:
        for g in data["groups"]:
            for r in g["rows"]:
                print(r["id"])
    else:
        for g in data["groups"]:
            print(f"== {g['group']} ({len(g['rows'])})")
            for r in g["rows"]:
                print(f"  {r['status']:8} {r['progress']:11} {r['id']:36} {r['why']}{'  [video]' if r.get('video') else ''}")
        print(data["counts"], data["progress"])
        print(data["shown_rule"])
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
