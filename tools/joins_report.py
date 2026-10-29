"""S301 joins report: reads the per-frame CSV fight3d_film.gd writes with `joins=<csv>` and measures how hard each clip
change jolts the body. For every bone (in the boxer's own frame) the per-frame velocity is taken; a jolt is the change of
velocity between two frames (m/s per frame). Frames within JOIN_FRAMES after a clip change are "join" frames, the rest are
the control (what the clips themselves do). Prints the control's 95th/99th percentile, every join above the control's
99th, and a table per transition kind (from-clip family -> to-clip family).

    python tools/joins_report.py <joins.csv> [fps=30]
"""
import csv
import math
import sys
from collections import defaultdict

JOIN_FRAMES = 6
BONES = ["LeftHand", "RightHand", "Head", "Hips", "LeftFoot", "RightFoot"]


def family(clip: str) -> str:
    c = clip.replace("pro_", "")
    for word, fam in (("hit_by", "hit"), ("idle", "guard"), ("dodge", "dodge"), ("weave", "dodge"), ("block", "block"),
                      ("advance", "walk"), ("retreat", "walk"), ("strafe", "walk"), ("knockout", "down"), ("win", "win"),
                      ("jab", "punch"), ("cross", "punch"), ("hook", "punch"), ("uppercut", "punch"), ("body", "punch"),
                      ("kidney", "punch"), ("slip", "dodge"), ("pull", "dodge")):
        if word in c:
            return fam
    return c or "none"


def pct(values, q):
    if not values:
        return 0.0
    s = sorted(values)
    return s[min(len(s) - 1, int(q * len(s)))]


def main(argv):
    path = argv[1]
    fps = 30.0
    for a in argv[2:]:
        if a.startswith("fps="):
            fps = float(a[4:])
    rows = defaultdict(list)
    with open(path, newline="") as f:
        for r in csv.DictReader(f):
            rows[int(r["who"])].append(r)
    control, joins = [], []
    by_kind = defaultdict(list)
    for who, seq in rows.items():
        last_change, last_kind = -99, ""
        prev_v = None
        for i in range(1, len(seq)):
            a, b = seq[i - 1], seq[i]
            if b["clip"] != a["clip"]:
                last_change, last_kind = i, "%s -> %s" % (family(a["clip"]), family(b["clip"]))
                change_names = "%s -> %s" % (a["clip"], b["clip"])
            v = {}
            for bone in BONES:
                v[bone] = [(float(b[bone + ax]) - float(a[bone + ax])) * fps for ax in ("_x", "_y", "_z")]
            if prev_v is not None:
                jolt = max(math.dist(v[bone], prev_v[bone]) for bone in BONES)
                worst = max(BONES, key=lambda bone: math.dist(v[bone], prev_v[bone]))
                if i - last_change < JOIN_FRAMES:
                    joins.append((jolt, who, int(b["frame"]), change_names, worst, i - last_change))
                    by_kind[last_kind].append(jolt)
                else:
                    control.append(jolt)
            prev_v = v
    c95, c99 = pct(control, 0.95), pct(control, 0.99)
    print("frames: control %d, join %d (first %d frames after a clip change)" % (len(control), len(joins), JOIN_FRAMES))
    print("control jolt (m/s per frame): p50 %.2f p95 %.2f p99 %.2f max %.2f" % (pct(control, 0.5), c95, c99, max(control or [0])))
    print("\nper transition kind: count, p95, max, share of join frames above control p99")
    for kind, vals in sorted(by_kind.items(), key=lambda kv: -max(kv[1])):
        over = sum(1 for x in vals if x > c99) / len(vals)
        print("  %-22s n=%4d p95 %.2f max %.2f over %.0f%%" % (kind, len(vals), pct(vals, 0.95), max(vals), over * 100))
    big = sorted((j for j in joins if j[0] > c99), reverse=True)
    print("\njoin frames above control p99 (%.2f): %d; worst 25:" % (c99, len(big)))
    for jolt, who, frame, names, bone, k in big[:25]:
        print("  %.2f  boxer %d frame %d (+%d)  %s  [%s]" % (jolt, who, frame, k, names, bone))


if __name__ == "__main__":
    main(sys.argv)
