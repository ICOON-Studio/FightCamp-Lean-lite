#!/usr/bin/env python
"""C101's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/C101_check.py

DERIVES the population (FightClipBinding.gd's RamsterZ windows, the twelve bodies, R108's
joints) and checks the signed statistics against C100's committed unsigned ones: a joint's
pooled |signed mean| can never exceed its pooled unsigned mean, and sqrt(mean^2 + std^2) - the
RMS - can never fall below it.
"""
import glob
import json
import math
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
JSON_PATH = os.path.join(ROOT, "research/C101_offset_or_motion.json")
MD_PATH = os.path.join(ROOT, "research/C101_OFFSET_OR_MOTION.md")
TOOL = os.path.join(ROOT, "Godot/tools/measure_retarget_offsets.gd")
C100_JSON = os.path.join(ROOT, "research/C100_retarget_by_frame.json")
BINDING = os.path.join(ROOT, "Godot/scripts/FightClipBinding.gd")
R108 = os.path.join(ROOT, "Godot/tools/measure_r108_retarget.gd")
FIGHTERS = os.path.join(ROOT, "Godot/assets/models/fighters/f??_*_rigged.glb")
failures = []


def check(ok, message):
    if not ok:
        failures.append(message)
    return ok


def finite(x):
    return isinstance(x, (int, float)) and not isinstance(x, bool) and math.isfinite(x)


def derived():
    text = open(BINDING, encoding="utf-8").read()
    block = text[text.find("const BINDINGS"):text.find("const PAIRED_REFERENCE")]
    hits = list(re.finditer(r'"path":\s*"(res://assets/anim/audition/ramsterz_h2h/[^"]+)"', block))
    windows = set()
    for i, m in enumerate(hits):
        chunk = block[m.end():hits[i + 1].start() if i + 1 < len(hits) else len(block)]
        s = re.search(r'"start_s":\s*([0-9.]+)', chunk)
        e = re.search(r'"end_s":\s*([0-9.]+)', chunk)
        windows.add((m.group(1), round(float(s.group(1)), 3), round(float(e.group(1)), 3)))
    jt = re.search(r"const JOINTS := \{(.*?)\n\}", open(R108, encoding="utf-8").read(), re.S)
    joints = set(re.findall(r'"([a-z_]+)":\s*\[', jt.group(1))) if jt else set()
    fighters = {os.path.basename(p)[:-len("_rigged.glb")] for p in glob.glob(FIGHTERS)}
    return windows, joints, fighters


def main():
    windows, joints, fighters = derived()
    check(len(windows) >= 10 and len(joints) >= 6 and len(fighters) == 12,
          f"derivation broke: {len(windows)} windows, {len(joints)} joints, {len(fighters)} fighters")
    check(os.path.isfile(TOOL), "Godot/tools/measure_retarget_offsets.gd does not exist")
    if not check(os.path.isfile(JSON_PATH), "C101_offset_or_motion.json does not exist"):
        return
    try:
        data = json.load(open(JSON_PATH, encoding="utf-8"))
        c100 = json.load(open(C100_JSON, encoding="utf-8"))
    except Exception as exc:  # noqa: BLE001
        check(False, f"a JSON does not parse: {exc}")
        return

    trip = data.get("tripwire", {})
    check(finite(trip.get("fixed_mean_deg")) and abs(trip["fixed_mean_deg"] - 7.21) <= 0.05, "tripwire mean does not reproduce R108's 7.21")
    check(finite(trip.get("fixed_max_deg")) and abs(trip["fixed_max_deg"] - 19.64) <= 0.05, "tripwire max does not reproduce R108's 19.64")

    rests = {(r.get("fighter"), r.get("joint")): r for r in data.get("rest_offsets", [])}
    for f in fighters:
        for j in joints:
            r = rests.get((f, j))
            check(r is not None and finite(r.get("rest_offset_deg")), f"rest_offsets lacks a finite value for {f} {j}")

    rows = data.get("rows", [])
    index = {}
    for r in rows:
        key = (r.get("path"), round(float(r.get("start_s", -1)), 3), round(float(r.get("end_s", -1)), 3), r.get("fighter"), r.get("joint"))
        check(key not in index, f"duplicate row {key}")
        index[key] = r
    check(len(rows) == len(windows) * len(fighters) * len(joints),
          f"{len(rows)} rows; expected {len(windows)} windows x {len(fighters)} fighters x {len(joints)} joints = {len(windows) * len(fighters) * len(joints)}")
    for r in rows:
        if not check(all(finite(r.get(k)) for k in ("signed_mean_deg", "signed_std_deg")) and int(r.get("frames", 0)) >= 2,
                     f"row {r.get('path')} {r.get('fighter')} {r.get('joint')}: bad numbers or frames"):
            continue
        check(r["signed_std_deg"] >= 0.0, f"row {os.path.basename(str(r.get('path')))} {r.get('fighter')} {r.get('joint')}: negative std")

    split = {(s.get("fighter"), s.get("joint")): s for s in data.get("split", [])}
    for f in fighters:
        for j in joints:
            s = split.get((f, j))
            if not check(s is not None, f"split lacks {f} {j}"):
                continue
            nums = ("constant_part_deg", "motion_part_deg", "offset_share")
            if not check(all(finite(s.get(k)) for k in nums), f"split {f} {j}: non-finite"):
                continue
            c, m = s["constant_part_deg"], s["motion_part_deg"]
            check(c >= 0 and m >= 0 and 0.0 <= s["offset_share"] <= 1.0, f"split {f} {j}: out of range")
            if c * c + m * m > 1e-9:
                check(abs(s["offset_share"] - c * c / (c * c + m * m)) <= 1e-3, f"split {f} {j}: offset_share != c^2/(c^2+m^2)")

    # Against C100: per joint, pooled over everything, frame-weighted.
    agg = {}
    for r in rows:
        j, n = r.get("joint"), int(r.get("frames", 0))
        if j in joints and n > 0 and finite(r.get("signed_mean_deg")) and finite(r.get("signed_std_deg")):
            a = agg.setdefault(j, [0, 0.0, 0.0])
            a[0] += n
            a[1] += n * r["signed_mean_deg"]
            a[2] += n * (r["signed_std_deg"] ** 2 + r["signed_mean_deg"] ** 2)
    c100_joints = c100.get("joints", {})
    for j, (n, s1, s2) in agg.items():
        if j not in c100_joints or n == 0:
            continue
        unsigned_mean = c100_joints[j]["mean_deg"]
        abs_signed_mean = abs(s1 / n)
        rms = math.sqrt(max(0.0, s2 / n))
        check(abs_signed_mean <= unsigned_mean + 0.05,
              f"{j}: pooled |signed mean| {abs_signed_mean:.2f} exceeds C100's unsigned mean {unsigned_mean:.2f} - impossible")
        check(rms + 0.05 >= unsigned_mean,
              f"{j}: pooled RMS {rms:.2f} is below C100's unsigned mean {unsigned_mean:.2f} - impossible")
        # 2026-09-13: the first delivery measured a signed angle ABOUT AN AXIS, whose sign flips when two
        # segments are nearly collinear - knees showed an 18 deg 'motion part' against C100's 8-11 deg max.
        # No spread of errors can exceed the largest error, so the RMS is bounded by C100's max.
        check(rms <= c100_joints[j]["max_deg"] + 0.05,
              f"{j}: pooled RMS {rms:.2f} exceeds C100's largest error for that joint ({c100_joints[j]['max_deg']:.2f}) - not the same angle as C100")

    c100_rows = {}
    for r in c100.get("rows", []):
        c100_rows[(r.get("path"), round(float(r.get("start_s", -1)), 3), round(float(r.get("end_s", -1)), 3), r.get("fighter"))] = r
    over = 0
    example = ""
    for r in rows:
        key = (r.get("path"), round(float(r.get("start_s", -1)), 3), round(float(r.get("end_s", -1)), 3), r.get("fighter"))
        base = c100_rows.get(key)
        if base is None or not all(finite(r.get(k)) for k in ("signed_mean_deg", "signed_std_deg")):
            continue
        if math.sqrt(r["signed_mean_deg"] ** 2 + r["signed_std_deg"] ** 2) > base["angle_max_deg"] + 0.05:
            over += 1
            if not example:
                example = f"{os.path.basename(str(r.get('path')))} {r.get('fighter')} {r.get('joint')}"
    check(over == 0, f"{over} rows have an RMS above C100's largest error for that clip and body (first: {example}) - the signed error is not C100's angle")

    if check(os.path.isfile(MD_PATH), "C101_OFFSET_OR_MOTION.md does not exist"):
        md = open(MD_PATH, encoding="utf-8").read()
        head = "\n".join(md.splitlines()[:50])
        check(re.search(r"^#+\s*DECISIONS", head, re.M | re.I) is not None, "the markdown does not open with DECISIONS")
        for j in joints:
            check(j in head, f"DECISIONS does not give a verdict for {j}")


main()
if failures:
    print(f"C101_CHECK FAIL ({len(failures)})")
    for f in failures[:40]:
        print("  - " + f)
    sys.exit(1)
print("C101_CHECK PASS")
