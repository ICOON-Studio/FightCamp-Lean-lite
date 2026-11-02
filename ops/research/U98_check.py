"""U98 gate (written by Claude, 2026-09-14). Run from the repo root: python research/U98_check.py

Pins Cursor's clip measurements to things its own numbers cannot fake:
- every hand-strike take of both meshes is measured (the take count per mesh >= 5, each role that has takes appears),
- T is a human torso (0.40-0.65 m) and the same within 0.03 m for every take of one mesh,
- each take's PEAK lies within 3 frames (0.1 s) of the player's own contact frame (`contact_s`, farthest reach) - a
  reading of the rest pose cannot do that - and onset <= peak <= back,
- the arm is really extended at a straight's peak (jab/cross elbow >= 120 deg) and its reach rose >= 0.3 T,
- physics bounds: travels within +-1.5 T, elbow in [30, 180], times inside the take,
- the digest opens with DECISIONS and names each measured role.
Never edit this file to pass."""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
R = os.path.join(ROOT, "research")
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


for name in ("U98_clip_punches.json", "U98_CLIPS_VS_VIDEO.md"):
    if not os.path.exists(os.path.join(R, name)):
        fail("missing research/" + name)
if fails:
    print("U98_CHECK FAIL %d" % len(fails))
    sys.exit(1)

data = json.load(open(os.path.join(R, "U98_clip_punches.json"), encoding="utf-8"))
takes = data.get("takes", [])
by_mesh = {}
for row in takes:
    by_mesh.setdefault(row.get("mesh"), []).append(row)
for mesh in ("f01_m_box_welter", "f09_m_bare_welter"):
    rows = by_mesh.get(mesh, [])
    if len(rows) < 5:
        fail("%s: only %d takes measured" % (mesh, len(rows)))
        continue
    ts = [float(r.get("T_m", 0)) for r in rows]
    if not all(0.40 <= t <= 0.65 for t in ts):
        fail("%s: T %r is not a human torso" % (mesh, ts[:3]))
    if max(ts) - min(ts) > 0.03:
        fail("%s: T varies %.3f..%.3f m between takes" % (mesh, min(ts), max(ts)))
    for r in rows:
        label = "%s %s" % (mesh, r.get("take"))
        for key in ("onset_s", "peak_s", "contact_s", "onset_to_peak_s", "reach_rise_T", "elbow_deg_peak",
                    "hip_to_peak_T", "head_to_peak_T", "front_ankle_to_peak_T", "rear_ankle_to_peak_T"):
            if not isinstance(r.get(key), (int, float)) or isinstance(r.get(key), bool):
                fail("%s: %s is not a number (%r)" % (label, key, r.get(key)))
        if fails and fails[-1].startswith(label):
            continue
        if abs(float(r["peak_s"]) - float(r["contact_s"])) > 0.1 + 1e-6:
            fail("%s: peak %.3f s is not within 3 frames of the player's contact %.3f s" % (label, r["peak_s"], r["contact_s"]))
        back = r.get("back_s")
        if float(r["onset_s"]) > float(r["peak_s"]) or (isinstance(back, (int, float)) and float(back) < float(r["peak_s"])):
            fail("%s: onset %.3f / peak %.3f / back %r out of order" % (label, r["onset_s"], r["peak_s"], back))
        if abs(float(r["onset_to_peak_s"]) - (float(r["peak_s"]) - float(r["onset_s"]))) > 0.02:
            fail("%s: onset_to_peak_s disagrees with its own onset and peak" % label)
        if str(r.get("role")) in ("jab", "cross", "jab_lead", "cross_lead"):
            if float(r["elbow_deg_peak"]) < 120.0:
                fail("%s: a straight's elbow at its peak is %.0f deg - that is not an extended punch" % (label, r["elbow_deg_peak"]))
            if float(r["reach_rise_T"]) < 0.3:
                fail("%s: reach rose only %.2f T" % (label, r["reach_rise_T"]))
        if not 30.0 <= float(r["elbow_deg_peak"]) <= 180.0:
            fail("%s: elbow %.1f deg" % (label, r["elbow_deg_peak"]))
        for key in ("hip_to_peak_T", "head_to_peak_T", "front_ankle_to_peak_T", "rear_ankle_to_peak_T"):
            if abs(float(r[key])) > 1.5:
                fail("%s: %s %.2f T is not a punch" % (label, key, r[key]))
digest = open(os.path.join(R, "U98_CLIPS_VS_VIDEO.md"), encoding="utf-8").read()
lines = digest.splitlines()
if not lines or not lines[0].startswith("## DECISIONS"):
    fail("digest must open with '## DECISIONS'")
if len(lines) > 25:
    fail("digest is %d lines, 25 at most" % len(lines))
for role in sorted({str(r.get("role")) for r in takes}):
    if role not in digest:
        fail("digest never names role %s" % role)
if fails:
    print("U98_CHECK FAIL %d" % len(fails))
    sys.exit(1)
print("U98_CHECK PASS takes=%d" % len(takes))
