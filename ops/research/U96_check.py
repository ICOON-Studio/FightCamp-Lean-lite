"""U96 gate (written by Claude, 2026-09-14). Run from the repo root: python research/U96_check.py

Pins Cursor's real-spacing measurement to things that cannot differ:
- the `room` band set reproduces the earlier instruments on the same code: U95's realism overlap rows (frames exact,
  overlap share within 0.002) and Q97's per-role contact counts (within 2%) and medians (within 0.03 m),
- the `real` band set actually moved the men: gap p50 inside 1.10..1.35 m, and every seed still steps the realism
  test's frame count (presentation cannot change a bout's length),
- the named glove and forearm class pairs exist, so `other` is no longer most of the overlap at `room`,
- reach_short_m is a copy of the contact summary, and the bands are the ones the task names.
Never edit this file to pass: fix the tools or re-run them.
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RESEARCH = os.path.join(ROOT, "research")
JSON_PATH = os.path.join(RESEARCH, "U96_real_spacing.json")
DIGEST = os.path.join(RESEARCH, "U96_REAL_SPACING.md")
U95_PATH = os.path.join(RESEARCH, "U95_body_overlap.json")
Q97_PATH = os.path.join(RESEARCH, "Q97_contact_miss.json")
REALISM_FRAMES = {94301: 19802, 51227: 19802, 77003: 19866}
BANDS = {"room": {"POCKET": 0.80, "MID": 0.95, "LONG": 1.10}, "real": {"POCKET": 1.07, "MID": 1.23, "LONG": 1.39}}
ROLES = ["jab", "cross", "hook_lead", "hook_rear"]
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def number(value):
    return isinstance(value, (int, float)) and not isinstance(value, bool)


for path in (JSON_PATH, DIGEST, U95_PATH, Q97_PATH):
    if not os.path.exists(path):
        fail("missing %s" % path)
if fails:
    sys.exit(1)

data = json.load(open(JSON_PATH, encoding="utf-8"))
u95 = json.load(open(U95_PATH, encoding="utf-8"))
q97 = json.load(open(Q97_PATH, encoding="utf-8"))

pop = data.get("population", {})
for name, want in BANDS.items():
    got = pop.get("bands", {}).get(name, {})
    for band, metres in want.items():
        if not number(got.get(band)) or abs(float(got[band]) - metres) > 1e-9:
            fail("population.bands.%s.%s is %r, expected %s" % (name, band, got.get(band), metres))
if "INFERENCE" not in str(pop.get("bands_source", "")):
    fail("population.bands_source must label the word-to-band mapping INFERENCE")

u95_rows = {row["seed"]: row for row in u95["bouts"] if row.get("population") == "realism"}
for name in BANDS:
    rows = data.get("overlap", {}).get(name, [])
    seeds = {row.get("seed"): row for row in rows}
    if sorted(seeds) != sorted(REALISM_FRAMES):
        fail("overlap.%s must have one row per realism seed %s" % (name, sorted(REALISM_FRAMES)))
        continue
    for seed, row in seeds.items():
        label = "overlap.%s seed %s" % (name, seed)
        if row.get("frames") != REALISM_FRAMES[seed]:
            fail("%s: frames %r, the realism test stepped %d" % (label, row.get("frames"), REALISM_FRAMES[seed]))
        gap = row.get("gap", {}).get("all", {})
        if not number(gap.get("p50")):
            fail("%s: gap.all.p50 missing" % label)
            continue
        if name == "real" and not 1.10 <= float(gap["p50"]) <= 1.35:
            fail("%s: gap p50 %.3f m - the room did not take the real bands" % (label, float(gap["p50"])))
        if name == "room":
            ref = u95_rows.get(seed)
            if ref is None:
                fail("%s: no U95 realism row to reproduce" % label)
                continue
            if not number(row.get("overlap_share")) or abs(float(row["overlap_share"]) - float(ref["overlap_share"])) > 0.002:
                fail("%s: overlap_share %r does not reproduce U95's %.4f" % (label, row.get("overlap_share"), float(ref["overlap_share"])))
            classes = row.get("by_class", {})
            for key in ("hand=hand", "arm>hand", "arm=hand"):
                if key not in classes:
                    fail("%s: by_class lacks %s" % (label, key))
            other = float(classes.get("other", {}).get("frames", 0))
            overlap_frames = float(row.get("overlap_frames", 0) or 0)
            if overlap_frames > 0 and other / overlap_frames >= 0.5:
                fail("%s: 'other' is still %.0f%% of the overlap frames - name the pairs" % (label, 100.0 * other / overlap_frames))

q97_summary = q97.get("summary", {})
contact = data.get("contact", {})
for name in BANDS:
    summary = contact.get(name, {})
    for role in ROLES:
        row = summary.get(role)
        if not isinstance(row, dict):
            fail("contact.%s.%s missing" % (name, role))
            continue
        for key in ("hand_to_target_m", "forward_m", "lateral_m", "vertical_m", "closest_m"):
            if not all(number(row.get(key, {}).get(p)) for p in ("p10", "p50", "p90")):
                fail("contact.%s.%s.%s p10/p50/p90 missing" % (name, role, key))
        if name == "room" and role in q97_summary:
            ref = q97_summary[role]
            if not number(row.get("n")) or abs(float(row["n"]) - float(ref["n"])) > max(2.0, 0.02 * float(ref["n"])):
                fail("contact.room.%s: n %r does not reproduce Q97's %d" % (role, row.get("n"), int(ref["n"])))
            for key in ("hand_to_target_m", "closest_m"):
                got = row.get(key, {}).get("p50")
                if number(got) and abs(float(got) - float(ref[key]["p50"])) > 0.03:
                    fail("contact.room.%s: %s p50 %.3f does not reproduce Q97's %.3f" % (role, key, float(got), float(ref[key]["p50"])))
    if name == "real":
        short = data.get("reach_short_m", {}).get("real", {})
        for role in ROLES:
            want = summary.get(role, {}).get("forward_m", {})
            got = short.get(role, {})
            for src, dst in (("p50", "forward_p50"), ("p90", "forward_p90")):
                if not number(got.get(dst)) or not number(want.get(src)) or abs(float(got[dst]) - float(want[src])) > 1e-9:
                    fail("reach_short_m.real.%s.%s must copy contact.real.%s.forward_m.%s" % (role, dst, role, src))

lines = open(DIGEST, encoding="utf-8").read().splitlines()
if not lines or not lines[0].startswith("## DECISIONS"):
    fail("digest must open with '## DECISIONS'")
if len(lines) > 30:
    fail("digest is %d lines, 30 at most" % len(lines))

if fails:
    print("U96_CHECK FAIL %d" % len(fails))
    sys.exit(1)
print("U96_CHECK PASS")
