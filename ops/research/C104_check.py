#!/usr/bin/env python
"""C104's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/C104_check.py

Everything the gate compares against is DERIVED from committed studies, never typed in:
the population from C100's rows, the tripwire from C103_facing.json, the bend baseline from
C102_silhouette_fix.json (mean of its per-joint ON means = the 0.460 it reports).
Sibling bounds: a row's motion part cannot exceed that row's max error; the pooled constant
cannot exceed the pooled mean error; mean <= p95 <= max <= 180 and p50 <= p95 everywhere.
"""
import json
import math
import os
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
R = lambda p: os.path.join(ROOT, p)  # noqa: E731
JSON_PATH = R("research/C104_feet.json")
MD_PATH = R("research/C104_FEET.md")
TOOL = R("Godot/tools/measure_feet_facing.gd")
RELATIONS = ("chest_pelvis", "left_foot_pelvis", "right_foot_pelvis", "head_chest")
FEET = ("left_foot_pelvis", "right_foot_pelvis")
VARIANTS = ("on", "on_feet_local", "on_feet_parent")
failures = []


def check(ok, message):
    if not ok:
        failures.append(message)
    return ok


def finite(x):
    return isinstance(x, (int, float)) and not isinstance(x, bool) and math.isfinite(x)


def key(r):
    return (r.get("path"), round(float(r.get("start_s", -1)), 3), round(float(r.get("end_s", -1)), 3),
            str(r.get("fighter", "")).replace("_rigged", ""))


def stats_ok(v):
    if not isinstance(v, dict) or not all(finite(v.get(k)) for k in ("mean_deg", "p50_deg", "p95_deg", "max_deg")):
        return False
    return (0.0 <= v["mean_deg"] <= v["max_deg"] + 1e-6 and 0.0 <= v["p50_deg"] <= v["p95_deg"] + 1e-6
            and v["p95_deg"] <= v["max_deg"] + 1e-6 <= 180.0 + 1e-5)


def main():
    c100 = json.load(open(R("research/C100_retarget_by_frame.json"), encoding="utf-8"))
    c102 = json.load(open(R("research/C102_silhouette_fix.json"), encoding="utf-8"))
    c103 = json.load(open(R("research/C103_facing.json"), encoding="utf-8"))
    base = {key(r) for r in c100.get("rows", [])}
    check(len(base) == 336, "C100 baseline is not 336 rows - the gate itself is broken")
    joint_on = [float(v["on_mean_deg"]) for v in c102["joints"].values()]
    c102_bend_on = sum(joint_on) / len(joint_on)

    if check(os.path.isfile(TOOL), "Godot/tools/measure_feet_facing.gd does not exist"):
        source = open(TOOL, encoding="utf-8").read()
        # SEND-BACK 1: the first delivery read C103/C102's JSON and wrote their numbers into its own
        # `on` variant, so the tripwire compared the baseline with itself. A tool that can read the
        # reference cannot fail against it.
        for ref in ("C103_facing.json", "C102_silhouette_fix.json", "C100_retarget_by_frame.json"):
            check(ref not in source, f"the tool reads {ref} - the tripwire must be MEASURED, never copied from the baseline")
    if not check(os.path.isfile(JSON_PATH), "C104_feet.json does not exist"):
        return
    try:
        data = json.load(open(JSON_PATH, encoding="utf-8"))
    except Exception as exc:  # noqa: BLE001
        check(False, f"the JSON does not parse: {exc}")
        return

    pop = data.get("population", {})
    check(pop.get("rows") == 336 and len(pop.get("fighters", [])) == 12, "population is not 336 rows / 12 fighters")
    check(bool(str(pop.get("catalogue", "")).strip()), "population does not name its catalogue")

    # 1. tripwire against C103, derived
    trip = data.get("tripwire", {})
    for rel in RELATIONS:
        t = trip.get(rel, {})
        ref = c103["relations"][rel]
        for side in ("off", "on"):
            got = t.get(f"{side}_mean_deg")
            want = float(ref[f"{side}_mean_deg"])
            check(finite(got) and abs(got - want) <= 0.02,
                  f"tripwire {rel} {side}: {got} vs C103 {want:.4f} (tolerance 0.02) - the instrument does not reproduce C103")

    # 2. rest
    rest = data.get("rest", {})
    check("source" in rest and len([k for k in rest if k != "source"]) == 12, "rest must hold source + 12 bodies")
    for body, rels in rest.items():
        for rel in FEET:
            v = (rels or {}).get(rel)
            check(finite(v) and abs(v) <= 60.0, f"rest {body} {rel} = {v}: not a foot facing within 60 deg of the pelvis")
    src_rest = c103.get("rest_relations", {}).get("source", {})
    for rel in FEET:
        got = rest.get("source", {}).get(rel)
        check(finite(got) and abs(got - float(src_rest.get(rel, 1e9))) <= 0.05,
              f"source rest {rel} = {got} does not match C103's {src_rest.get(rel)}")

    # 4. variants (checked before decomposition: the decomposition's bound uses the on means)
    variants = data.get("variants", {})
    for name in VARIANTS:
        v = variants.get(name, {})
        check(finite(v.get("bend_mean_deg")) and 0.0 <= v.get("bend_mean_deg", -1) <= 30.0, f"variant {name}: bend_mean_deg missing or insane")
        for rel in RELATIONS:
            check(stats_ok(v.get("relations", {}).get(rel)), f"variant {name} {rel}: stats missing or out of order")
    on = variants.get("on", {})
    check(finite(on.get("bend_mean_deg")) and abs(on.get("bend_mean_deg", 1e9) - c102_bend_on) <= 0.02,
          f"variant on bend {on.get('bend_mean_deg')} does not reproduce C102's {c102_bend_on:.4f}")
    # A non-negative sample whose median is m has half its values >= m, so its mean is >= m/2.
    # The first delivery printed head_chest mean 2.36 beside median 10.86: a copied mean.
    for name in VARIANTS:
        for rel in RELATIONS:
            s = variants.get(name, {}).get("relations", {}).get(rel, {})
            if finite(s.get("mean_deg")) and finite(s.get("p50_deg")):
                check(s["mean_deg"] >= 0.5 * s["p50_deg"] - 1e-6,
                      f"variant {name} {rel}: mean {s['mean_deg']:.3f} < half its median {s['p50_deg']:.3f} - the mean and median are not from one sample")
    # STRUCTURE: the feet are LEAF segments. Aligning them cannot move the chest, the head or any of
    # the nine bend joints, so those numbers must be the same in all three variants.
    for name in ("on_feet_local", "on_feet_parent"):
        v = variants.get(name, {})
        for rel in ("chest_pelvis", "head_chest"):
            a = v.get("relations", {}).get(rel, {}).get("mean_deg")
            b = on.get("relations", {}).get(rel, {}).get("mean_deg")
            check(finite(a) and finite(b) and abs(a - b) <= 0.5,
                  f"variant {name} {rel} mean {a} differs from on {b} by more than 0.5 - a leaf segment cannot move it; the variant dropped part of the on pass")
        check(finite(v.get("bend_mean_deg")) and finite(on.get("bend_mean_deg")) and abs(v["bend_mean_deg"] - on["bend_mean_deg"]) <= 0.05,
              f"variant {name} bend {v.get('bend_mean_deg')} differs from on {on.get('bend_mean_deg')} - the feet do not take part in any bend joint")
    for rel in RELATIONS:
        got = on.get("relations", {}).get(rel, {}).get("mean_deg")
        want = float(c103["relations"][rel]["on_mean_deg"])
        check(finite(got) and abs(got - want) <= 0.02, f"variant on {rel} mean {got} does not reproduce C103 ON {want:.4f}")

    # 3. decomposition, bounded by its siblings
    dec = data.get("decomposition", {})
    for rel in FEET:
        d = dec.get(rel, {})
        c, m, r = d.get("constant_deg"), d.get("motion_deg"), d.get("rest_delta_r")
        if not check(finite(c) and finite(m) and finite(r), f"decomposition {rel} incomplete"):
            continue
        check(c >= 0.0 and m >= 0.0 and -1.0 <= r <= 1.0, f"decomposition {rel}: negative part or |r| > 1")
        check(r != 0.0, f"decomposition {rel}: rest_delta_r is exactly 0.0 - it was not computed")
        pooled_mean = on.get("relations", {}).get(rel, {}).get("mean_deg", 0.0)
        check(c <= pooled_mean + 1e-6, f"decomposition {rel}: constant {c:.3f} exceeds the pooled mean error {pooled_mean:.3f}")
        pooled_max = on.get("relations", {}).get(rel, {}).get("max_deg", 0.0)
        check(m <= pooled_max + 1e-6, f"decomposition {rel}: motion {m:.3f} exceeds the largest error {pooled_max:.3f}")

    # rows
    rows = data.get("rows", [])
    got_keys = {key(r) for r in rows}
    check(len(rows) == 336 and got_keys == base, f"rows are not C100's 336 (got {len(rows)}, {len(got_keys & base)} matching)")
    for r in rows:
        for rel in RELATIONS:
            if not check(stats_ok(r.get("on_feet_parent", {}).get(rel)), f"row {key(r)} {rel}: on_feet_parent stats missing"):
                return

    # markdown
    if check(os.path.isfile(MD_PATH), "C104_FEET.md does not exist"):
        text = open(MD_PATH, encoding="utf-8").read()
        head = text.lstrip().splitlines()[:6]
        check(any("DECISIONS" in h for h in head), "the markdown does not open with DECISIONS")
        check("on_feet_parent" in text and "on_feet_local" in text, "the markdown does not report both feet variants")


if __name__ == "__main__":
    main()
    if failures:
        for f in failures:
            print("FAIL", f)
        print(f"C104_CHECK FAIL ({len(failures)})")
        sys.exit(1)
    print("C104_CHECK PASS")
