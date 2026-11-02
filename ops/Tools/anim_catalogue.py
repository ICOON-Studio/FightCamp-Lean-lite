#!/usr/bin/env python3
"""anim_catalogue.py - every boxing-demo animation, its status, its evidence and its preview (S130).

Operator, 2026-09-30: "can you make a list of the animations for movement and boxing that we will include on the
game to see which are ready or not and if possible to watch the animations from the opsboard".

DERIVED, NEVER COPIED. Each status is read from the files that decide it:
  - CERTIFIED     the id is in Godot/assets/data/certified_moves.json (the D27 palette; certified_palette_test
                  re-derives every id from its certificate files), or it is the certified guard idle.
  - IN GAME       a bound clip plays in the demo but no C223 gate judges it (walks, reactions, knockdown).
  - NO CLIP       the id is bound to the guard idle - the engine slides the body (U183: no walk clip passed
                  the foot/knee clearance), so nothing of its own is shown.
  - NOT READY     a boxing strike outside the palette; the newest C223 report that measured it is quoted
                  (file, rigs with no mechanical failure, the failure rows), plus a dated note when a session
                  learned something the report cannot say.
Previews: previews/anim/<id>.mp4 when rendered (gate `video` mode), else the newest contact sheet.

    python Tools/anim_catalogue.py            # prints the table
    python Tools/anim_catalogue.py --json     # the JSON the ops board serves at /api/animations
"""
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GODOT = ROOT / "Godot"
BINDING = GODOT / "scripts" / "FightClipBinding.gd"
CERTIFIED = GODOT / "assets" / "data" / "certified_moves.json"
C223 = GODOT / "docs" / "previews" / "c223"
ANIM = GODOT / "docs" / "previews" / "anim"
PREVIEW_ROOT = GODOT / "docs" / "previews"

REACTIONS = ["react_head", "react_body", "react_leg", "knockdown", "getup"]
DEFENCE = ["boxing_slip", "boxing_pull", "boxing_catch", "block"]

## What a report cannot say. Dated, sourced to the session that learned it; the status itself stays derived.
NOTES = {
    "boxing_rear_hook": "S130: every rear-hook source clipped KNEE TO KNEE on the centre line (both lead knees within 4 cm of it). With the fighters stood ~10 cm off-line (gate lateral=0.16) it passes every measured row 4/4 - but the rear foot lifts off the floor mid-punch (needs a rear-foot plant). Stance offset awaits the operator.",
    "boxing_rear_hook_body": "S130: same as the rear hook - passes 4/4 with the ~10 cm stance offset; rear foot lifts mid-punch.",
    "boxing_shovel_hook": "S130: lead knee drives into his lead knee (2.7-5.8 cm) even with the stance offset.",
    "boxing_inside_uppercut": "S125-S129: held - not certified on the final gate.",
    "boxing_one_two_hook": "A chain: waits on its hook part.",
    "boxing_liver_combo": "A chain: waits on its hook part.",
    "boxing_six_punch_combo": "A chain: waits on the rear hook.",
    "boxing_counter_combination": "A chain: waits on its hook part.",
    "boxing_jab_body_head": "A chain of certified parts, not yet run through the sequence gate.",
    "boxing_check_hook_pivot": "The pivot variant; boxing_check_hook (certified) is what the demo throws.",
}

LABELS = {
    "guard_idle": "Guard (stance idle)",
    "loc_advance": "Walk forward", "loc_retreat": "Walk back", "loc_strafe_left": "Step left",
    "loc_strafe_right": "Step right", "loc_advance_left": "Walk forward-left", "loc_advance_right": "Walk forward-right",
    "loc_retreat_left": "Walk back-left", "loc_retreat_right": "Walk back-right",
    "react_head": "Hit to the head", "react_body": "Hit to the body", "react_leg": "Hit to the leg",
    "knockdown": "Knockdown", "getup": "Get up", "block": "Block (generic)",
}


def _bindings() -> dict[str, str]:
    """BINDINGS id -> clip path, read from the GDScript literal (top-level keys only)."""
    text = BINDING.read_text(encoding="utf-8")
    start = text.index("const BINDINGS := {")
    end = text.index("\n}\n", start)
    out: dict[str, str] = {}
    current = None
    for line in text[start:end].splitlines():
        m = re.match(r'^\t"([a-z0-9_]+)": \{', line)
        if m:
            current = m.group(1)
            out.setdefault(current, "")
            continue
        p = re.search(r'"path":\s*"([^"]+)"', line)
        if p and current and not out[current]:
            out[current] = p.group(1)
    return out


def _idle_path() -> str:
    text = BINDING.read_text(encoding="utf-8")
    block = text[text.index("const RULESET_IDLE_BINDINGS"):text.index("const BINDINGS")]
    m = re.search(r'"path":\s*"([^"]+)"', block)
    return m.group(1) if m else ""


def _footwork() -> list[str]:
    text = BINDING.read_text(encoding="utf-8")
    return re.findall(r'"(boxing_[a-z_]+)": \{"pair": "idle", "why": "footwork"\}', text)


def _locomotion() -> list[str]:
    text = BINDING.read_text(encoding="utf-8")
    m = re.search(r"const LOCOMOTION_ORDER := \[([^\]]+)\]", text)
    return re.findall(r'"([a-z_]+)"', m.group(1)) if m else []


def _certified() -> set[str]:
    data = json.loads(CERTIFIED.read_text(encoding="utf-8"))
    boxing = data.get("boxing", {})
    return set(boxing.get("strikes", [])) | set(boxing.get("guards", []))


def _latest_evidence(move: str, cache: dict) -> dict:
    """The newest C223 report with rows for `move`: rigs clean / total and the failure rows."""
    if "files" not in cache:
        rows_by_move: dict[str, list] = {}
        for f in sorted(C223.glob("*.json"), key=lambda p: p.stat().st_mtime):
            try:
                d = json.loads(f.read_text(encoding="utf-8"))
            except (OSError, ValueError):
                continue
            rows = d.get("rows") if isinstance(d, dict) else None
            if not isinstance(rows, list):
                continue
            for r in rows:
                if not isinstance(r, dict):
                    continue
                key = r.get("move") or r.get("sequence")
                if key:
                    rows_by_move.setdefault(key, []).append((f, r))
        cache["files"] = rows_by_move
    hits = cache["files"].get(move, [])
    if not hits:
        return {}
    newest = hits[-1][0]
    rows = [r for f, r in hits if f == newest]
    clean = 0
    fails: dict[str, int] = {}
    for r in rows:
        mf = r.get("mechanical_failures", r.get("failures", [])) or []
        if isinstance(mf, list) and not mf:
            clean += 1
        for x in (mf if isinstance(mf, list) else []):
            fails[str(x)] = fails.get(str(x), 0) + 1
    lateral = max(float(r.get("fixture_lateral_m", 0.0) or 0.0) for r in rows)
    probe = lateral > 0.0 or newest.name.startswith(("s130_hooks_lat", "s130_mrh_lat"))
    return {"report": newest.name, "candidate": str(rows[0].get("candidate", "")), "rigs_clean": clean,
            "rigs": len(rows), "failures": fails, "probe": probe}


def _preview(ids: list[str]) -> dict:
    for i in ids:
        mp4 = ANIM / f"{i}.mp4"
        if mp4.is_file():
            return {"video": mp4.relative_to(PREVIEW_ROOT).as_posix()}
    ## S226 operator: "remove all animations with old models and i want only with MH" - the generator-body contact sheets are
    ## old models: no fallback to them (the S130-S135 videos moved to anim/_old_models_s226/). A row shows a preview again
    ## only when a MetaHuman render lands in anim/<id>.mp4.
    return {}
    best = None
    for i in ids:
        for png in C223.glob(f"*{i}_generator_welter_a.png"):
            if "side_" in png.name:
                continue
            if best is None or png.stat().st_mtime > best.stat().st_mtime:
                best = png
    return {"still": best.relative_to(PREVIEW_ROOT).as_posix()} if best else {}


def build() -> dict:
    binds = _bindings()
    certified = _certified()
    cache: dict = {}
    groups = []

    def row(i: str, status: str, source: str, extra: dict | None = None, alias: list[str] | None = None) -> dict:
        r = {"id": i, "label": LABELS.get(i, i.replace("boxing_", "").replace("_", " ").capitalize()),
             "status": status, "source": Path(source).name if source else ""}
        if extra:
            r.update(extra)
        if i in NOTES:
            r["note"] = NOTES[i]
        r.update(_preview([i] + (alias or [])))
        return r

    groups.append({"group": "Stance", "rows": [row("guard_idle", "CERTIFIED", _idle_path(),
                   {"why": "the base of every C223 certificate"}, ["boxing_stance_guard", "guard_idle"])]})
    move_rows = [row(i, "IN GAME" if binds.get(i) else "MISSING", binds.get(i, ""),
                     {"why": "plays when the engine moves him; no C223 gate judges walks"}) for i in _locomotion()]
    move_rows += [row(i, "NO CLIP", "", {"why": "plays the guard idle while the engine slides the body (U183: no walk clip passed foot/knee clearance)"})
                  for i in _footwork()]
    groups.append({"group": "Movement", "rows": move_rows})
    strike_ids = sorted(k for k in binds if k.startswith("boxing_") and k not in DEFENCE)
    for c in sorted(certified):
        if c not in strike_ids and c not in DEFENCE:
            strike_ids.append(c)
    strikes = []
    for i in strike_ids:
        if i in certified:
            strikes.append(row(i, "CERTIFIED", binds.get(i, ""), {"why": "in the demo palette (certified_moves.json)"}))
        else:
            strikes.append(row(i, "NOT READY", binds.get(i, ""), {"evidence": _latest_evidence(i, cache)}))
    strikes.sort(key=lambda r: (r["status"] != "CERTIFIED", r["id"]))
    groups.append({"group": "Punches and combinations", "rows": strikes})
    groups.append({"group": "Defence", "rows": [
        row(i, "CERTIFIED" if i in certified else ("IN GAME" if binds.get(i) else "MISSING"), binds.get(i, ""))
        for i in DEFENCE]})
    groups.append({"group": "Being hit", "rows": [
        row(i, "IN GAME" if binds.get(i) else "MISSING", binds.get(i, ""), {"why": "the receiver's reaction; not C223-gated"})
        for i in REACTIONS]})
    live = []
    for mp4 in sorted(ANIM.glob("live_*.mp4")):
        live.append({"id": mp4.stem, "label": mp4.stem.replace("live_", "Real fight: ").replace("_", " "),
                     "status": "IN GAME", "source": "tools/record_room.gd as_game",
                     "why": "the live fight room with the game's switches on - punches, reactions and footwork together, as the .exe plays them",
                     "video": mp4.relative_to(PREVIEW_ROOT).as_posix()})
    if live:
        groups.insert(0, {"group": "Real fight (game room)", "rows": live})
    ## S270 operator: "remove the old clips from the board and put the 2 new" (after "videos are perfect" on the Rokoko orbit
    ## renders). The new real-mocap takes go first; every older group stays in the data (counts, status) but the page hides it.
    ## S270 operator: "can you upload there all the animations we currently have from rokoko" - every whole Rokoko take
    ## (anim_compare/rk_<Take>.mp4), boxing first; single punches cut from them (rk_<Take>@<s>-<e>.mp4) follow.
    new_rows = []
    order = ["Boxing", "ShadowBoxing", "FightingIdle", "KnockOut_Winner", "KnockOut_Loser"]
    takes = sorted((p.stem for p in (PREVIEW_ROOT / "anim_compare").glob("rk_*.mp4")),
                   key=lambda st: (order.index(st[3:]) if st[3:] in order else 99, st))
    for stem in takes:
        mp4 = PREVIEW_ROOT / "anim_compare" / f"{stem}.mp4"
        name = stem[3:]
        label = "Rokoko mocap: " + (name.replace("@", " - punch at ").replace("_", " ") if "@" in name
                                     else re.sub(r"(?<!^)(?=[A-Z])", " ", name.replace("_", " ")).replace("  ", " "))
        punch_labels = GODOT / "assets" / "anim" / "rokoko_combat" / "punch_labels.json"
        if "@" in name and punch_labels.is_file():
            label = "Rokoko punch: " + json.loads(punch_labels.read_text(encoding="utf-8")).get(stem, name)
        if mp4.is_file():
            new_rows.append({"id": stem, "label": label, "status": "NEW SOURCE", "source": f"{name.split('@')[0]}_mixamo.fbx",
                             "why": "real boxing motion capture (Rokoko, free for games) on our MetaHuman - single punches get cut from it",
                             "video": mp4.relative_to(PREVIEW_ROOT).as_posix()})
    if new_rows:
        for g in groups:
            g["hidden"] = True
        groups.insert(0, {"group": "New mocap source (Rokoko)", "rows": new_rows})
    counts: dict[str, int] = {}
    for g in groups:
        if g["group"].startswith("Real fight") or g["group"].startswith("New mocap"):
            continue  # recordings, not animations
        for r in g["rows"]:
            counts[r["status"]] = counts.get(r["status"], 0) + 1
    return {"groups": groups, "counts": counts,
            "rule": "CERTIFIED = every C223 row passes on the four generated legal pairs incl. G147 clipping, stills from the game camera and the side"}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--json", action="store_true")
    a = ap.parse_args()
    data = build()
    if a.json:
        print(json.dumps(data, indent=1))
        return 0
    for g in data["groups"]:
        print(f"== {g['group']}")
        for r in g["rows"]:
            ev = r.get("evidence") or {}
            evs = f" [{ev.get('report')} {ev.get('candidate')}{' PROBE' if ev.get('probe') else ''}: {ev.get('rigs_clean')}/{ev.get('rigs')} clean {ev.get('failures')}]" if ev else ""
            media = r.get("video") or r.get("still") or "-"
            print(f"  {r['status']:<10} {r['id']:<28} {r['source']:<34} {media}{evs}")
    print(data["counts"])
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
