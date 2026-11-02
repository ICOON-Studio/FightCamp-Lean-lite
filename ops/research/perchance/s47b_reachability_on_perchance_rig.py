"""Run S47's reachability test on the PERCHANCE rig, read out of its own source.

Same method as Godot/tools/s47_contact_offsets.gd: sample points round a target
capsule's surface, offset outward by a hand's radius, and count how many lie
outside every OTHER capsule of the SAME body by at least that hand radius.

The rig is transcribed verbatim from the recovered rev10 source, lines 699-714.
Joints chain by their parent offsets, so world positions are accumulated here
the same way the generator does it in its own rest pose.
"""
import math

RIG = [
    # name, parent, offset, cap a, cap b, r
    ("pelvis", None,    (0, 0, 0),         (0, -0.115, 0), (0, 0.12, 0), 0.120),
    ("spine",  "pelvis", (0, 0.12, 0),     (0, 0, 0),      (0, 0.17, 0), 0.126),
    ("chest",  "spine",  (0, 0.17, 0),     (0, 0, 0),      (0, 0.20, 0), 0.130),
    ("neck",   "chest",  (0, 0.20, 0),     (0, 0, 0),      (0, 0.09, 0), 0.055),
    ("head",   "neck",   (0, 0.09, 0),     (0, 0.015, 0),  (0, 0.10, 0), 0.100),
]
for s, sg in (("L", 1), ("R", -1)):
    RIG += [
        ("clav" + s, "chest",    (0.098 * sg, 0.150, 0), None, None, None),
        ("arm" + s,  "clav" + s, (0.112 * sg, 0, 0),  (0, -0.02, 0),  (0, -0.28, 0), 0.052),
        ("fore" + s, "arm" + s,  (0, -0.28, 0),       (0, -0.015, 0), (0, -0.25, 0), 0.044),
        ("hand" + s, "fore" + s, (0, -0.25, 0),       (0, -0.012, 0), (0, -0.108, 0), 0.044),
        ("hip" + s,  "pelvis",   (0.10 * sg, -0.07, 0), (0, -0.03, 0), (0, -0.40, 0), 0.088),
        ("shin" + s, "hip" + s,  (0, -0.43, 0),       (0, -0.02, 0),  (0, -0.42, 0), 0.074),
        ("foot" + s, "shin" + s, (0, -0.42, 0),       (0, -0.045, -0.035), (0, -0.062, 0.155), 0.049),
    ]

origin = {}
for name, parent, off, _a, _b, _r in RIG:
    base = origin[parent] if parent else (0.0, 0.0, 0.0)
    origin[name] = tuple(base[i] + off[i] for i in range(3))

caps = []
for name, parent, off, a, b, r in RIG:
    if a is None:
        continue
    o = origin[name]
    p0 = tuple(o[i] + a[i] for i in range(3))
    p1 = tuple(o[i] + b[i] for i in range(3))
    caps.append({"name": name, "p0": p0, "p1": p1, "r": r})


def point_seg(p, q0, q1):
    d = [q1[i] - q0[i] for i in range(3)]
    dd = sum(x * x for x in d)
    if dd < 1e-12:
        return math.dist(p, q0)
    t = sum((p[i] - q0[i]) * d[i] for i in range(3)) / dd
    t = max(0.0, min(1.0, t))
    c = [q0[i] + d[i] * t for i in range(3)]
    return math.dist(p, c)


HAND_R = 0.044  # their own hand capsule radius - the thing that does the gripping

print("PERCHANCE rig, S47's own reachability test, hand r = %.3f m" % HAND_R)
stature = (origin["head"][1] + 0.10) - (origin["footL"][1] - 0.062)
print("stature (head top to foot): %.4f m" % stature)
print()
print("  %-9s %7s %7s %7s  %8s  %-9s %s"
      % ("capsule", "r", "len", "ratio", "exposed", "buried by", "depth"))

for target in caps:
    t0, t1, tr = target["p0"], target["p1"], target["r"]
    axis = [t1[i] - t0[i] for i in range(3)]
    alen = math.sqrt(sum(x * x for x in axis))
    if alen < 1e-9:
        d = (0.0, 1.0, 0.0)
    else:
        d = [x / alen for x in axis]
    # two perpendiculars
    ref = (1.0, 0.0, 0.0) if abs(d[0]) < 0.9 else (0.0, 0.0, 1.0)
    u = [d[1] * ref[2] - d[2] * ref[1], d[2] * ref[0] - d[0] * ref[2], d[0] * ref[1] - d[1] * ref[0]]
    un = math.sqrt(sum(x * x for x in u)) or 1.0
    u = [x / un for x in u]
    v = [d[1] * u[2] - d[2] * u[1], d[2] * u[0] - d[0] * u[2], d[0] * u[1] - d[1] * u[0]]

    exposed = total = 0
    worst_name, worst_depth = "", 0.0
    for si in range(16):
        s = si / 15.0
        spine = [t0[i] + (t1[i] - t0[i]) * s for i in range(3)]
        for ri in range(32):
            ang = 2 * math.pi * ri / 32.0
            out = [u[i] * math.cos(ang) + v[i] * math.sin(ang) for i in range(3)]
            spot = [spine[i] + out[i] * (tr + HAND_R) for i in range(3)]
            total += 1
            blocked = False
            for other in caps:
                if other["name"] == target["name"]:
                    continue
                dist = point_seg(spot, other["p0"], other["p1"])
                depth = (other["r"] + HAND_R) - dist
                if depth > 0:
                    blocked = True
                    if depth > worst_depth:
                        worst_depth, worst_name = depth, other["name"]
            if not blocked:
                exposed += 1
    print("  %-9s %7.4f %7.4f %7.3f  %7.1f%%  %-9s %.4f"
          % (target["name"], tr, alen, tr / alen if alen else float("inf"),
             100.0 * exposed / total, worst_name, worst_depth))
