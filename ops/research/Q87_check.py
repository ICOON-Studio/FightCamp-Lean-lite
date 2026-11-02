#!/usr/bin/env python
"""Q87's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/Q87_check.py

Derived, never an expected winner:
  - population = C100's 336 rows; the four variants present on every row;
  - pooled numbers are recomputed from the rows (floor_min = min of row floor_min; knockdown end = mean
    of that clip's row end_hips over the bodies) - a pooled figure that is not its rows' is refused;
  - TRIPWIRE `none`: with no carry the Hips never move, so each knockdown row ends at that body's own rest
    Hips height (bodies.rest_hips_m) within 1 mm - the instrument reads the pose it wrote;
  - TRIPWIRE the source: the source T-pose pelvis is U83's 0.9675 m (read from U83's JSON, not typed);
  - `unscaled` and each scaled variant must move a knockdown's end Hips by exactly the carried delta:
    end_hips = rest_hips + (source_end - 0.9675) x scale, with source_end from U83's JSON (the pelvis
    height at the window's last frame) and scale 1 / rest_hips/0.9675 / rest_leg/source_leg - 1 cm;
  - physics on the rows: a lowest foot cannot sit more than 1 m above a standing body's floor, nor a
    Hips above 2 m; every number finite.
"""
import json
import math
import os
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
R = lambda p: os.path.join(ROOT, p)  # noqa: E731
JSON_PATH = R("research/Q87_hip_carry.json")
MD_PATH = R("research/Q87_HIP_CARRY.md")
TOOL = R("Godot/tools/measure_hip_carry.gd")
VARIANTS = ("none", "unscaled", "hip_ratio", "leg_ratio")
KNOCKDOWNS = ("H2H_KnockDown01.FBX", "H2H_KnockDown02.FBX")
failures = []


def check(ok, message):
    if not ok:
        failures.append(message)
    return ok


def finite(x):
    return isinstance(x, (int, float)) and not isinstance(x, bool) and math.isfinite(x)


def key(r):
    return (str(r.get("path")), round(float(r.get("start_s", -1)), 3), round(float(r.get("end_s", -1)), 3),
            str(r.get("fighter", "")).replace("_rigged", ""))


def main():
    c100 = json.load(open(R("research/C100_retarget_by_frame.json"), encoding="utf-8"))
    u83 = json.load(open(R("research/U83_pelvis_by_tree.json"), encoding="utf-8"))
    base = {key(r) for r in c100.get("rows", [])}
    check(len(base) == 336, "C100 baseline is not 336 rows - the gate itself is broken")
    tpose = float(u83["tpose"]["pelvis_y_m"])
    source_end = {os.path.basename(r["path"]): float(r["pelvis_y_final_m"]) for r in u83["rows"]
                  if os.path.basename(r["path"]) in KNOCKDOWNS}
    check(len(source_end) == 2, "U83 does not carry both knockdowns - the gate itself is broken")

    check(os.path.isfile(TOOL), "Godot/tools/measure_hip_carry.gd does not exist")
    if not check(os.path.isfile(JSON_PATH), "Q87_hip_carry.json does not exist"):
        return
    try:
        data = json.load(open(JSON_PATH, encoding="utf-8"))
    except Exception as exc:  # noqa: BLE001
        check(False, f"the JSON does not parse: {exc}")
        return

    check(finite(data.get("source_tpose_pelvis_m")) and abs(data["source_tpose_pelvis_m"] - tpose) <= 0.001,
          f"source_tpose_pelvis_m {data.get('source_tpose_pelvis_m')} is not U83's {tpose:.4f}")
    bodies = data.get("bodies", {})
    check(len(bodies) == 12 and all(finite(b.get("rest_hips_m")) and finite(b.get("rest_leg_m")) and 0.3 < b["rest_leg_m"] < 1.5
                                    for b in bodies.values()), "bodies must give 12 rest_hips_m and plausible rest_leg_m")
    # SEND-BACK 1: heights are ABOVE EACH BODY'S FLOOR. Anatomy: hips sit 0.95-1.40 x the hip-to-ankle leg
    # above the floor (the source: 0.9675 / 0.828 = 1.17). A skeleton-space y reads ~0.1 and fails here.
    for name, b in bodies.items():
        if finite(b.get("rest_hips_m")) and finite(b.get("rest_leg_m")) and b["rest_leg_m"] > 0:
            ratio = b["rest_hips_m"] / b["rest_leg_m"]
            check(0.95 <= ratio <= 1.40, f"{name}: rest hips {b['rest_hips_m']:.3f} / leg {b['rest_leg_m']:.3f} = {ratio:.2f} - not a height above the floor")
    source_leg = data.get("source_leg_m")
    check(finite(source_leg) and 0.5 < source_leg < 1.2, f"source_leg_m {source_leg} missing or not a leg")

    rows = data.get("rows", [])
    got = {key(r): r for r in rows}
    check(len(rows) == 336 and set(got) == base, f"rows are not C100's 336 (got {len(rows)}, {len(set(got) & base)} matching)")

    pooled_floor = {v: [] for v in VARIANTS}
    kd_end = {v: {k: [] for k in KNOCKDOWNS} for v in VARIANTS}
    for k, r in got.items():
        name = os.path.basename(k[0])
        body = bodies.get(k[3], {})
        for v in VARIANTS:
            s = r.get(v, {})
            if not check(finite(s.get("floor_min_m")), f"{name} {k[3]} {v}: floor_min_m missing"):
                continue
            pooled_floor[v].append(s["floor_min_m"])
            if bool(r.get("standing")) and finite(s.get("float_mean_m")):
                check(-1.0 <= s["float_mean_m"] <= 1.0, f"{name} {k[3]} {v}: a standing lowest foot {s['float_mean_m']:.2f} m from its floor")
            if name in KNOCKDOWNS and check(finite(s.get("end_hips_m")), f"{name} {k[3]} {v}: end_hips_m missing"):
                check(s["end_hips_m"] <= 2.0, f"{name} {k[3]} {v}: Hips {s['end_hips_m']:.2f} m up")
                kd_end[v][name].append(s["end_hips_m"])
                rest = body.get("rest_hips_m")
                if finite(rest) and finite(source_leg) and finite(body.get("rest_leg_m")):
                    scale = {"none": None, "unscaled": 1.0, "hip_ratio": rest / tpose, "leg_ratio": body["rest_leg_m"] / source_leg}[v]
                    want = rest if scale is None else rest + (source_end[name] - tpose) * scale
                    tol = 0.001 if scale is None else 0.01
                    check(abs(s["end_hips_m"] - want) <= tol,
                          f"{name} {k[3]} {v}: end Hips {s['end_hips_m']:.3f} m, the carry predicts {want:.3f} m (rest {rest:.3f}, source end {source_end[name]:.3f}, scale {scale})")

    variants = data.get("variants", {})
    for v in VARIANTS:
        vb = variants.get(v, {})
        if pooled_floor[v]:
            check(finite(vb.get("floor_min_m")) and abs(vb["floor_min_m"] - min(pooled_floor[v])) <= 1e-4,
                  f"variant {v}: floor_min_m {vb.get('floor_min_m')} is not the min of its rows {min(pooled_floor[v]):.4f}")
        ends = vb.get("knockdown_end_hips_m", [])
        if check(isinstance(ends, list) and len(ends) == 2, f"variant {v}: knockdown_end_hips_m must hold two values"):
            for i, clip in enumerate(KNOCKDOWNS):
                vals = kd_end[v][clip]
                if vals and finite(ends[i]):
                    check(abs(ends[i] - sum(vals) / len(vals)) <= 1e-3, f"variant {v}: {clip} pooled end {ends[i]:.3f} is not its rows' mean")
        for f in ("float_mean_m", "float_p95_m"):
            check(finite(vb.get(f)), f"variant {v}: {f} missing")

    # The choice is physics on the delivery's own pooled numbers: feet out of the floor and both knockdowns on it.
    def ok_variant(v):
        vb = variants.get(v, {})
        ends = vb.get("knockdown_end_hips_m", [])
        return (finite(vb.get("floor_min_m")) and vb["floor_min_m"] >= -0.05 and isinstance(ends, list) and len(ends) == 2
                and all(finite(e) and 0.05 <= e <= 0.35 for e in ends))
    passing = [v for v in VARIANTS if ok_variant(v)]
    chosen = data.get("chosen")
    if chosen == "none_of_them":
        check(not passing, f"chosen is none_of_them but {passing} keep the feet out of the floor and lay both knockdowns on it")
    else:
        check(chosen in VARIANTS and chosen in passing,
              f"chosen {chosen!r} does not keep feet >= -0.05 m and both knockdown ends within 0.05-0.35 m (passing: {passing})")

    if check(os.path.isfile(MD_PATH), "Q87_HIP_CARRY.md does not exist"):
        text = open(MD_PATH, encoding="utf-8").read()
        check(any("DECISIONS" in h for h in text.lstrip().splitlines()[:6]), "the markdown does not open with DECISIONS")


if __name__ == "__main__":
    main()
    if failures:
        for f in failures[:40]:
            print("FAIL", f)
        print(f"Q87_CHECK FAIL ({len(failures)})")
        sys.exit(1)
    print("Q87_CHECK PASS")
