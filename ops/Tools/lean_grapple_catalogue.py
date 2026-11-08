#!/usr/bin/env python3
"""lean_grapple_catalogue.py - the GrappleMap moves the no-gi belt match plays, for the board's Grappling page (S379).

Operator S379: "i want to see the progress on animations on board, make a new one for the grappling animations".

DERIVED, NEVER COPIED (read at request time):
  - THE MOVES: every `MATCH <clock> <who> <kind> <move> odds ...` line the belt match printed in its films
    (previews/BJJ9/bjj_r*.log - BeltMatch._act on claude/bjj9base), most played first; HOLD (no move) left out.
  - WHICH GRAPPLEMAP MOVE: Lean/assets/grapplemap/graph.json. A named move matches its title (GrappleGraph.clean); an
    unnamed one ("...") is printed "To <where it lands>" (BeltMatch._cands), so it matches by its landing position.
    Several GrappleMap moves can share a name: the first is filmed, the count is on the tile.
  - ITS BELT: BjjMatch.syllabus_of(scoring_tags(move tags, landing tags)) -> BeltRoad.SYLLABUS; no syllabus tag = a
    positional move every belt uses. BjjMatch.gd is read from main, else from the claude/bjj9base branch.
  - PREVIEW + NUMBERS: previews/lean_grapple/<id>.mp4 and <id>.json (Lean/tools/grapple_orbit.gd + Tools/lean_grapple_render.py:
    the move PURE - the recorded data on our two women, no push-out / IK / grips / idle - and what it measured).
  - VERDICTS: AgentComms/clip_verdicts.json "grapple" (pass:true = VERIFIED; a frame check or a probe = in progress).

    python Tools/lean_grapple_catalogue.py          # the table
    python Tools/lean_grapple_catalogue.py --json   # what the ops board serves at /api/grappling
    python Tools/lean_grapple_catalogue.py --ids 20 # the first N GrappleMap ids (for the renderer)
"""
from __future__ import annotations

import collections
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LEAN = Path("E:/FightCamp/Lean")
GRAPH = LEAN / "assets" / "grapplemap" / "graph.json"
BELTROAD = LEAN / "scripts" / "rules" / "BeltRoad.gd"
BJJMATCH = "scripts/rules/BjjMatch.gd"
MATCH_BRANCH = "claude/bjj9base"
LOGS = ROOT / "previews" / "BJJ9"
PREVIEW_ROOT = ROOT / "previews"
PREVIEWS = PREVIEW_ROOT / "lean_grapple"
FIRST_BATCH = 20
## A tile's measured status (tools/grapple_orbit.gd numbers; S379 audit: the clean S335 film code read jerk p95 44 m/s^3 and
## 0.05 flips/s, the r10 match with its layers 1312 / 3.75; a drawn part 6 cm inside the other body is visible).
TREMBLE_JERK = 200.0
TREMBLE_FLIPS = 0.5
INSIDE_M = 0.06
POP_M = 0.10
MATCH_LINE = re.compile(r"^MATCH (\d+:\d+) (\S+) ([a-z_]+) (.+?) odds ([\d.]+) (HIT|MISS)")

sys.path.insert(0, str(Path(__file__).resolve().parent))
import lean_anim_catalogue as boxing  # noqa: E402  (verdicts + progress rule shared with the boxing page)


def _norm(t: str) -> str:
    return re.sub(r"[^a-z0-9]", "", t.lower())


def _clean(title: str) -> str:
    """GrappleGraph.clean without the capitalising (names are compared normalised)."""
    t = re.sub(r"(https?://|www\.)\S*", "", title)
    for cut in (" todo:", "todo:", " wip"):
        i = t.lower().find(cut)
        if i >= 0:
            t = t[:i]
    return t.strip()


def _match_src() -> str:
    local = LEAN / BJJMATCH
    if local.is_file():
        return local.read_text(encoding="utf-8")
    try:
        return subprocess.run(["git", "-C", str(LEAN), "show", f"{MATCH_BRANCH}:{BJJMATCH}"], capture_output=True,
                              text=True, encoding="utf-8", timeout=20).stdout
    except (OSError, subprocess.SubprocessError):
        return ""


def _syllabus() -> tuple[dict, list, dict]:
    """TAG_SYLLABUS, SUB_TAGS (BjjMatch) and syllabus move -> (belt, group) (BeltRoad)."""
    src = _match_src()
    tag_syl = dict(re.findall(r'"([a-z_]+)":\s*"([a-z_]+)"', boxing._const(src, "TAG_SYLLABUS")))
    subs = re.findall(r'"([a-z_]+)"', boxing._const(src, "SUB_TAGS"))
    belts = {}
    road = BELTROAD.read_text(encoding="utf-8")
    block = boxing._const(road, "SYLLABUS")
    for m in re.finditer(r'"(white|blue|purple|brown|black)":\s*\{(.*?)\]\]\}', block, re.S):
        for g in re.finditer(r'\["([^"]+)",\s*\[(.*?)\]\]', m.group(2) + "]]", re.S):
            for mv in re.findall(r'"([a-z_]+)"', g.group(2)):
                belts[mv] = (m.group(1), g.group(1))
    return tag_syl, subs, belts


def _scoring_tags(move_tags: list, land_tags: list, subs: list) -> list:
    entry = any(t in ("throw", "sacrifice_throw", "takedown", "trip", "sweep", "te_waza", "sutemi_waza", "ashi_waza")
                or t.endswith("_takedown") or t.endswith("_sweep") for t in move_tags)
    return [t for t in move_tags if not (t in subs and (entry or t not in land_tags))]


def _films() -> list[Path]:
    """The belt match films' logs (not the probes' reruns of the same bout)."""
    return sorted(f for f in LOGS.glob("bjj_r*.log") if not f.stem.endswith("_probe"))


def _played() -> list[dict]:
    plays: dict[str, dict] = {}
    for log in _films():
        for line in log.read_text(encoding="utf-8", errors="replace").splitlines():
            m = MATCH_LINE.match(line)
            if not m or m.group(3) == "hold":
                continue
            p = plays.setdefault(_norm(m.group(4)), {"title": m.group(4), "plays": 0, "hits": 0,
                                                     "kinds": collections.Counter(), "films": set()})
            p["plays"] += 1
            p["hits"] += m.group(6) == "HIT"
            p["kinds"][m.group(3)] += 1
            p["films"].add(log.stem)
    return sorted(plays.values(), key=lambda p: (-p["plays"], p["title"]))


def _measured(tid: int) -> dict:
    f = PREVIEWS / f"{tid}.json"
    try:
        return json.loads(f.read_text(encoding="utf-8")) if f.is_file() else {}
    except (OSError, ValueError):
        return {}


def chip(meas: dict, checks: list) -> tuple[str, str]:
    """(chip text, chip class). A frame check recorded in clip_verdicts.json speaks first: a tile is never called
    clean on numbers alone."""
    framed = [c for c in checks if c.get("frames")]
    if framed:
        c = framed[-1]
        return ("Frames checked: " + str(c.get("result", "")), "good" if c.get("clean") else "bad")
    if not meas:
        return ("Not rendered yet", "none")
    bad = []
    if float(meas.get("overlap_peak_m", 0)) > INSIDE_M:
        share = float(meas.get("overlap_deep_frames", 0)) / max(1.0, float(meas.get("measured_frames", 1)))
        bad.append("limbs inside the other body (peak %d cm, %d%% of the move)" % (
            round(float(meas["overlap_peak_m"]) * 100), round(share * 100)))
    if float(meas.get("jerk_p95", 0)) > TREMBLE_JERK or float(meas.get("flips_s", 0)) > TREMBLE_FLIPS:
        bad.append("trembles")
    if float(meas.get("spike_m", 0)) > POP_M:
        bad.append("a pop (%d cm in one frame)" % round(float(meas["spike_m"]) * 100))
    if bad:
        return ("Measured: " + ", ".join(bad), "bad")
    return ("Measured steady - frames not checked yet", "amber")


def build() -> dict:
    graph = json.loads(GRAPH.read_text(encoding="utf-8"))
    pos = {int(p["id"]): p for p in graph["positions"]}
    by_name: dict[str, list] = collections.defaultdict(list)
    for t in graph["transitions"]:
        own = _clean(str(t.get("title", "")))
        if own.rstrip(".") == "" or own.startswith("..."):
            ends = [(t.get("to"), False)] + ([(t.get("from"), True)] if t.get("bidirectional") else [])
            for land, rev in ends:
                if land is not None and int(land) in pos:
                    by_name[_norm("to " + _clean(str(pos[int(land)]["title"])))].append((t, rev))
        else:
            by_name[_norm(own)].append((t, False))
    tag_syl, subs, belts = _syllabus()
    checks, bar = boxing.verdicts("grapple")
    rows = []
    for k, p in enumerate(_played()):
        cands = by_name.get(_norm(p["title"]), [])
        row = {"title": p["title"], "plays": p["plays"], "hits": p["hits"], "films": len(p["films"]),
               "kind": p["kinds"].most_common(1)[0][0], "same_name": len(cands)}
        if not cands:
            row.update({"id": None, "belt": "", "status_text": "Not found in GrappleMap", "status_cls": "none",
                        "checks": [], "progress": "not started"})
            rows.append(row)
            continue
        t, rev = cands[0]
        land = t.get("from") if rev else t.get("to")
        land_tags = list(pos.get(int(land), {}).get("tags", [])) if land is not None else []
        syl = next((tag_syl[x] for x in _scoring_tags(list(t.get("tags", [])), land_tags, subs) if x in tag_syl), "")
        belt, group = belts.get(syl, ("", ""))
        if not belt:
            belt = ("%s - not on the belt road" % syl.replace("_", " ")) if syl else (
                "a submission not on the belt road" if row["kind"] == "sub" else "every belt (positional)")
        tid = int(t["id"])
        meas = _measured(tid)
        mine = checks.get(str(tid), [])
        text, cls = chip(meas, mine)
        row.update({"id": tid, "gm_title": str(t.get("title", "")), "keyframes": int(t.get("frames", 0)),
                    "from": _clean(str(pos.get(int(t["from"]), {}).get("title", ""))) if t.get("from") is not None else "",
                    "to": _clean(str(pos.get(int(t["to"]), {}).get("title", ""))) if t.get("to") is not None else "",
                    "reverse": rev, "syllabus": syl.replace("_", " "), "group": group,
                    "belt": belt, "measured": meas, "checks": mine,
                    "status_text": text, "status_cls": cls})
        if (PREVIEWS / f"{tid}.mp4").is_file():
            row["video"] = (PREVIEWS / f"{tid}.mp4").relative_to(PREVIEW_ROOT).as_posix()
        # S399 GRAPPLEFIX1: a verified move plays the very clip its passing check judged (the game-drawn render,
        # previews/lean_grapple_game/), not the pure preview.
        passed = [c for c in mine if c.get("pass") is True and str(c.get("source", "")).startswith("ops/previews/")]
        if passed and (ROOT / str(passed[-1]["source"])[len("ops/"):]).is_file():
            row["video"] = str(passed[-1]["source"])[len("ops/previews/"):]
        row["progress"] = "verified" if any(c.get("pass") is True for c in mine) else (
            "in progress" if row.get("video") or mine else "not started")
        rows.append(row)
    # S399 GRAPPLEFIX1 joins (operator: "what matters is the sequence blending"): belt-match SEQUENCES filmed by
    # tools/grapple_orbit.gd chain=..., one tile each; verdicts in clip_verdicts.json "grapple_seq".
    seqs, _ = boxing.verdicts("grapple_seq")
    for key, mine in seqs.items():
        last = mine[-1] if mine else {}
        passed = [c for c in mine if c.get("pass") is True]
        src = str((passed[-1] if passed else last).get("source", ""))
        text, cls = chip({}, mine)
        row = {"id": key, "title": "Sequence %s: %s" % (key, last.get("chain", "")), "kind": "sequence", "checks": mine,
               "status_text": text, "status_cls": cls, "belt": "every belt (positional)", "same_name": 1}
        if src.startswith("ops/previews/") and (ROOT / src[len("ops/"):]).is_file():
            row["video"] = src[len("ops/previews/"):]
        row["progress"] = "verified" if passed else "in progress"
        rows.append(row)
    prog = {"verified": 0, "in progress": 0, "not started": 0}
    for r in rows:
        prog[r["progress"]] += 1
    rendered = len({r["id"] for r in rows if r.get("video")})   # one GrappleMap move can be two tiles (played both ways)
    return {"rows": rows, "progress": prog, "total": len(rows), "rendered": rendered, "bar": bar,
            "films": [f.stem for f in _films()],
            "shown_rule": "Shown: the %d GrappleMap moves the no-gi belt match played in its %d films (most played first); "
                          "%d rendered, %d verified (%s)." % (len(rows), len(_films()), rendered,
                                                             prog["verified"], bar or "a recorded 100% check"),
            "rule": "S399: a VERIFIED tile plays the clip its passing check judged - the move or sequence AS THE GAME DRAWS IT "
                    "(placement, limbs, holds, IK, the match's pacing; previews/lean_grapple_game, lean_grapple_seq). Each other "
                    "preview (?all=1) is the move PURE: the GrappleMap recording on our two women, nothing laid on top (no push-out, "
                    "no wrist/ankle IK, no grips, no idle sway). In the belt match (branch claude/bjj9base, not on main) the "
                    "same moves get per-frame layers; the S379 audit measured that bout at jerk p95 1312 m/s^3 and 3.75 "
                    "direction flips a second a joint against 44 and 0.05 for the plain player - the match trembles, these "
                    "previews show the recorded motion"}


def main(argv: list[str]) -> int:
    data = build()
    if "--json" in argv:
        print(json.dumps(data, indent=1))
    elif "--ids" in argv:
        n = int(argv[argv.index("--ids") + 1]) if len(argv) > argv.index("--ids") + 1 else FIRST_BATCH
        ids = [r["id"] for r in data["rows"] if r.get("id") is not None]
        print(",".join(str(i) for i in list(dict.fromkeys(ids))[:n]))
    else:
        for r in data["rows"]:
            print(f"{r['plays']:3} {str(r.get('id')):5} {r['kind']:9} {r['belt'][:24]:24} {r['title'][:44]:44} "
                  f"x{r['same_name']} {r['status_text']}")
        print(data["progress"], data["shown_rule"])
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
