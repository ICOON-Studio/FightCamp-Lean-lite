"""U95 gate (written by Claude, 2026-09-14). Run from the repo root: python research/U95_check.py

Pins Cursor's body-overlap instrument to things that cannot differ:
- every seed's frame count equals the realism test's own run of the same room (19802, 19802, 19866) - the engine, not
  the meshes, decides a bout's length, so both populations must match it,
- the overlap is mutual: depth computed A-against-B equals B-against-A,
- in the static sweep depth never grows as the gap widens, and torsos do not touch at 1.60 m,
- radii are derived and human: every radius inside 0.01..0.30 m, each body's widest torso capsule wider than its hand
  spheres, every capsule built from at least one vertex,
- shares and percentiles are consistent (p50 <= p95 <= max; overlap frames <= frames).
Never edit this file to pass: fix the tool or re-run it.
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RESEARCH = os.path.join(ROOT, "research")
JSON_PATH = os.path.join(RESEARCH, "U95_body_overlap.json")
DIGEST = os.path.join(RESEARCH, "U95_BODY_OVERLAP.md")
TOOL = os.path.join(ROOT, "Godot", "tools", "measure_body_overlap.gd")
REALISM_FRAMES = {94301: 19802, 51227: 19802, 77003: 19866}
POPULATIONS = ["realism", "watch"]
CLASSES = ["torso", "head", "arm", "hand", "leg", "foot"]
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def num(obj, key, label):
    value = obj.get(key)
    if not isinstance(value, (int, float)) or isinstance(value, bool):
        fail("%s: %s missing or not a number (%r)" % (label, key, value))
        return float("nan")
    return float(value)


for path in (TOOL, JSON_PATH, DIGEST):
    if not os.path.exists(path):
        fail("missing %s" % path)
if fails:
    sys.exit(1)

data = json.load(open(JSON_PATH, encoding="utf-8"))
pop = data.get("population", {})
if sorted(pop.get("seeds", [])) != sorted(REALISM_FRAMES):
    fail("population.seeds %r, expected the realism test's %r" % (pop.get("seeds"), sorted(REALISM_FRAMES)))
for key, want in (("rounds", 3), ("fps", 30), ("threshold_m", 0.02)):
    if pop.get(key) != want:
        fail("population.%s is %r, expected %r" % (key, pop.get(key), want))
for name, want_b in (("realism", "f09_m_bare_welter"), ("watch", "f02_m_box_heavy")):
    entry = pop.get(name, {})
    if entry.get("a") != "f01_m_box_welter" or entry.get("b") != want_b:
        fail("population.%s must name a=f01_m_box_welter, b=%s (got %r)" % (name, want_b, entry))

bodies = data.get("bodies", {})
for body_name in ("f01_m_box_welter", "f09_m_bare_welter", "f02_m_box_heavy"):
    body = bodies.get(body_name)
    if not isinstance(body, dict):
        fail("bodies.%s missing" % body_name)
        continue
    capsules = body.get("capsules", [])
    if len(capsules) < 18:
        fail("bodies.%s has %d capsules/spheres, the task lists 21" % (body_name, len(capsules)))
    torso = [c for c in capsules if c.get("class") == "torso"]
    hands = [c for c in capsules if c.get("class") == "hand"]
    for capsule in capsules:
        label = "%s.%s" % (body_name, capsule.get("name"))
        if capsule.get("class") not in CLASSES:
            fail("%s: class %r not one of %s" % (label, capsule.get("class"), CLASSES))
        radius = num(capsule, "radius_m", label)
        if not 0.01 <= radius <= 0.30:
            fail("%s: radius %.4f m outside 0.01..0.30 - the vertices are in the wrong space" % (label, radius))
        if not isinstance(capsule.get("vertices"), int) or capsule["vertices"] < 1:
            fail("%s: built from %r vertices" % (label, capsule.get("vertices")))
    if torso and hands:
        if max(float(c["radius_m"]) for c in torso) <= max(float(c["radius_m"]) for c in hands):
            fail("%s: widest torso capsule is not wider than the hand spheres" % body_name)
    else:
        fail("%s: needs torso capsules and hand spheres" % body_name)

bouts = data.get("bouts", [])
seen = set()
for bout in bouts:
    label = "bout %s/%s" % (bout.get("population"), bout.get("seed"))
    seen.add((bout.get("population"), bout.get("seed")))
    seed = bout.get("seed")
    if seed in REALISM_FRAMES and bout.get("frames") != REALISM_FRAMES[seed]:
        fail("%s: frames %r, the realism test stepped %d - not the same room" % (label, bout.get("frames"), REALISM_FRAMES[seed]))
    frames = num(bout, "frames", label)
    overlap = num(bout, "overlap_frames", label)
    if not 0 <= overlap <= frames:
        fail("%s: overlap_frames %s outside 0..frames" % (label, overlap))
    if frames > 0 and abs(num(bout, "overlap_share", label) - overlap / frames) > 1e-6:
        fail("%s: overlap_share is not overlap_frames / frames" % label)
    if overlap > 0:
        p50, p95, top = num(bout, "depth_p50_m", label), num(bout, "depth_p95_m", label), num(bout, "depth_max_m", label)
        if not 0.02 <= p50 <= p95 <= top <= 1.0:
            fail("%s: depths p50 %.4f, p95 %.4f, max %.4f not ordered inside 0.02..1.0 m" % (label, p50, p95, top))
    if not isinstance(bout.get("by_class"), dict) or not isinstance(bout.get("by_takes"), list):
        fail("%s: by_class / by_takes missing" % label)
    gap = bout.get("gap", {})
    for which in ("all", "overlap"):
        g = gap.get(which, {})
        values = [g.get(k) for k in ("p5", "p50", "p95")]
        if which == "overlap" and overlap == 0:
            continue
        if not all(isinstance(v, (int, float)) for v in values) or not values[0] <= values[1] <= values[2]:
            fail("%s: gap.%s p5/p50/p95 missing or not ordered (%r)" % (label, which, g))
for population in POPULATIONS:
    for seed in REALISM_FRAMES:
        if (population, seed) not in seen:
            fail("bout %s/%d missing" % (population, seed))

if num(data, "symmetry_max_abs_diff_m", "root") > 1e-6:
    fail("symmetry_max_abs_diff_m %.3g > 1e-6 - the overlap is not computed the same both ways" % data["symmetry_max_abs_diff_m"])

sweeps = {s.get("population"): s for s in data.get("sweep", [])}
for population in POPULATIONS:
    sweep = sweeps.get(population)
    if sweep is None:
        fail("sweep %s missing" % population)
        continue
    gaps = sorted(sweep.get("gaps", []), key=lambda g: g.get("gap_m", 0))
    want = [round(0.50 + 0.05 * i, 2) for i in range(23)]
    if [round(float(g.get("gap_m", -1)), 2) for g in gaps] != want:
        fail("sweep %s: gaps must be 0.50..1.60 m in 0.05 steps" % population)
        continue
    previous = None
    for g in gaps:
        depth = num(g, "depth_m", "sweep %s gap %.2f" % (population, g["gap_m"]))
        if previous is not None and depth > previous + 0.01:
            fail("sweep %s: depth grows from %.4f to %.4f as the gap widens to %.2f m" % (population, previous, depth, g["gap_m"]))
        previous = depth
    last = gaps[-1].get("by_class", {})
    if float(last.get("torso=torso", 0.0)) > 0.0:
        fail("sweep %s: torsos overlap at 1.60 m (%.4f)" % (population, float(last.get("torso=torso", 0.0))))
    for key in ("first_touch_gap_m", "torso_touch_gap_m"):
        value = sweep.get(key)
        if value is not None and not (isinstance(value, (int, float)) and 0.5 <= float(value) <= 1.6):
            fail("sweep %s: %s %r outside 0.50..1.60 (null when never touching)" % (population, key, value))
    if isinstance(sweep.get("first_touch_gap_m"), (int, float)) and isinstance(sweep.get("torso_touch_gap_m"), (int, float)):
        if float(sweep["torso_touch_gap_m"]) > float(sweep["first_touch_gap_m"]) + 1e-9:
            fail("sweep %s: torsos touch at a wider gap than any part touches" % population)

lines = open(DIGEST, encoding="utf-8").read().splitlines()
if not lines or not lines[0].startswith("## DECISIONS"):
    fail("digest must open with '## DECISIONS'")
if len(lines) > 30:
    fail("digest is %d lines, 30 at most" % len(lines))

if fails:
    print("U95_CHECK FAIL %d" % len(fails))
    sys.exit(1)
print("U95_CHECK PASS bouts=%d sweeps=%d" % (len(bouts), len(sweeps)))
