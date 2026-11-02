"""Build a collar-and-elbow clinch for two Cascy rigs and write POSE.json.

Everything is derived from the RIG'S OWN REST POSE, recovered from fighter B
(who has only been rigidly moved, never posed), so nothing here invents a
proportion the character does not have.

World: fighter A stands near the origin facing +Z; fighter B faces -Z.
Units are centimetres - Cascadeur reports Cascy's head at y = 162.3, so he is
about 1.70 m tall, and every separation below reads as a real body measurement.
"""
import json
import math
import os
import sys

# where RIG.json was dumped and POSE.json will be written
HERE = os.path.abspath(sys.argv[1]) if len(sys.argv) > 1 else os.getcwd()
CTRL = json.load(open(os.path.join(HERE, "RIG.json"), "r", encoding="utf-8"))

def _p(name, default):
    """A pose parameter, overridable from the environment so the pose can be swept
    without editing this file: `CLINCH_HIP_SEP=80 python build_clinch.py <dir>`."""
    return float(os.environ.get("CLINCH_" + name, default))


# HIP_SEP WAS 56.0 AND Q115 MEASURED THAT AS TOO TIGHT (Qwen, 2026-09-21,
# research/Q115_CLINCH_DISTANCE.md). Real footage through U112's
# `pair_world.py`: a clinch is 0.719 m hip-to-hip (p50, 57 frames) against a
# RANGE control arm of 1.050 m by the same method on the same clips - a
# 0.331 m difference, 2.2x the +/-0.15 m horizontal error bound. S30's 56 cm
# sits 0.15 m BELOW the observed clinch p10 of 0.709 m: tighter than any
# clinch frame in the footage.
#
# Q115 reports the answer as a RANGE, 0.72-0.87 m, not a point. 75 cm is
# inside it and just above the p50. THE SAMPLE IS 57 FRAMES OF 13,542 (0.4%)
# and moving the threshold +/-10 cm swings the p50 by 0.15 m, so this is an
# anchor and not a precise truth. The reach diagnostics further down are what
# decide whether the arms can still make the collar tie at it - if they
# cannot, that is a finding about the pose, not a reason to go back to 56.
HIP_SEP = _p("HIP_SEP", 75.0)      # hip-to-hip separation of the two men, cm
LEAN_DEG = _p("LEAN_DEG", 18.0)    # forward lean of each man's torso about his own hips
HIP_BACK = _p("HIP_BACK", 4.0)     # hips slide back under the lean, cm
HEAD_SIDE = _p("HEAD_SIDE", 12.0)  # each head passes on the other man's right, cm
HIP_DROP = _p("HIP_DROP", 6.0)     # knees bend, hips drop, cm
NAPE = _p("NAPE", 7.0)             # how far behind the neck controller the clasped hands sit

# Recover the rig's REST pose. Fighter B is a fresh import that has only ever
# been moved rigidly, so B = R180(rest) + (0,0,TZ) and TZ falls straight out of
# the two pelvis controllers. If the scene has already been posed this no longer
# holds, so it is CHECKED rather than assumed - a silently wrong rest pose would
# poison every number this script prints.
CT = CTRL["controllers"]
A_PELVIS = CT["pelvis_MainPoint"]
B_PELVIS = CT["character1:pelvis_MainPoint"]
B_GAP_NOW = B_PELVIS[2] + A_PELVIS[2]

rest = {}
for nm, p in CT.items():
    if not nm.startswith("character1:"):
        continue
    x, y, z = p
    rest[nm[len("character1:"):]] = [-x, y, -(z - B_GAP_NOW)]

worst, worst_nm = 0.0, ""
for nm, p in rest.items():
    if nm not in CT:
        continue
    e = math.dist(p, CT[nm])
    if e > worst:
        worst, worst_nm = e, nm
if worst > 1.0:
    raise SystemExit(
        "the two fighters are not the same un-posed rig (%s differs by %.1f cm). "
        "build_clinch.py needs a FRESH scene: open samples/Cascy.casc and "
        "File > Import > Import Scene To Current... the same file again."
        % (worst_nm, worst))
print("rest pose recovered; fighter B sits %.1f cm downrange, rigid to %.2f cm" %
      (B_GAP_NOW, worst))

PIV_Y = rest["pelvis_MainPoint"][1]
PIV_Z = rest["pelvis_MainPoint"][2]

# the rig's own arm reach, measured from the rest pose - never guessed
def d(a, b):
    return math.dist(rest[a], rest[b]) if isinstance(a, str) else math.dist(a, b)


UPPER = math.dist(rest["arm_MainPoint_l"], rest["forearm_MainPoint_l"])
FORE = math.dist(rest["forearm_MainPoint_l"], rest["hand_MainPoint_l"])
REACH = UPPER + FORE

TORSO = [
    "pelvis_MainPoint", "pelvis_AdditionalPoint",
    "stomach_MainPoint", "stomach_AdditionalPoint",
    "chest_MainPoint", "chest_AdditionalPoint",
    "neck_MainPoint", "neck_AdditionalPoint",
    "head_MainPoint", "head_AdditionalPoint", "head_DirectionPoint",
    "clavicle_MainPoint_l", "clavicle_MainPoint_r",
    "clavicle_AdditionalPoint_l", "clavicle_AdditionalPoint_r",
    "arm_MainPoint_l", "arm_MainPoint_r",
    "thigh_MainPoint_l", "thigh_MainPoint_r",
]
HAND_GROUP = {s: ["hand_MainPoint_" + s, "hand_DirectionPoint_" + s,
                  "hand_AdditionalPoint_" + s] for s in "lr"}
FOOT_GROUP = {s: ["foot_MainPoint_" + s, "foot_Self0Point_" + s, "toe_MainPoint_" + s,
                  "toe_DirectionPoint_" + s, "toe_AdditionalPoint_" + s,
                  "calf_LimbDir_" + s] for s in "lr"}
SIDE_SHARE = {"head": 1.0, "neck": 0.55, "chest": 0.15}


def lean(p):
    t = math.radians(LEAN_DEG)
    dy, dz = p[1] - PIV_Y, p[2] - PIV_Z
    return [p[0],
            PIV_Y + dy * math.cos(t) - dz * math.sin(t) - HIP_DROP,
            PIV_Z + dy * math.sin(t) + dz * math.cos(t) - HIP_BACK]


def side_share(nm):
    for k, v in SIDE_SHARE.items():
        if nm.startswith(k):
            return v
    return 0.0


def torso_of(head_side):
    out = {}
    for nm in TORSO:
        p = lean(rest[nm])
        p[0] += head_side * side_share(nm)
        out[nm] = p
    for nm in ("forearm_LimbDir_l", "forearm_LimbDir_r"):
        out[nm] = lean(rest[nm])
    return out


def add_hands(out, hand_l, hand_r):
    for s, tgt in (("l", hand_l), ("r", hand_r)):
        base = rest["hand_MainPoint_" + s]
        dd = [tgt[i] - base[i] for i in range(3)]
        for nm in HAND_GROUP[s]:
            out[nm] = [rest[nm][i] + dd[i] for i in range(3)]


def add_feet(out, dl, dr):
    for s, dd in (("l", dl), ("r", dr)):
        for nm in FOOT_GROUP[s]:
            out[nm] = [rest[nm][i] + dd[i] for i in range(3)]


# ---- A is posed first, in world -------------------------------------------
A = torso_of(HEAD_SIDE)
A_PZ = A["pelvis_MainPoint"][2]
TZ = 2.0 * A_PZ + HIP_SEP          # B = R180(local) + (0,0,TZ)


def toB(p):
    return [-p[0], p[1], TZ - p[2]]


B_local = torso_of(HEAD_SIDE)
B_neck_w = toB(B_local["neck_MainPoint"])
B_head_w = toB(B_local["head_MainPoint"])

# A clasps both hands at the nape of B's neck (behind him = +z in world)
clasp = [B_neck_w[1] + 2.0, B_neck_w[2] + NAPE]
A_hand_l = [B_neck_w[0] + 2.5, clasp[0], clasp[1]]
A_hand_r = [B_neck_w[0] - 2.5, clasp[0], clasp[1]]
add_hands(A, A_hand_l, A_hand_r)
add_feet(A, [1.0, 0.0, 5.0], [-3.0, 0.0, -10.0])

# B grips A's upper arms, a hand's width outboard and below each shoulder
A_arm_l = A["arm_MainPoint_l"]
A_arm_r = A["arm_MainPoint_r"]
grip_on_A_l = [A_arm_l[0] + 4.0, A_arm_l[1] - 6.0, A_arm_l[2] + 6.0]
grip_on_A_r = [A_arm_r[0] - 4.0, A_arm_r[1] - 6.0, A_arm_r[2] + 6.0]
add_hands(B_local, toB(grip_on_A_r), toB(grip_on_A_l))   # B's left hand takes A's right arm
add_feet(B_local, [1.0, 0.0, 5.0], [-3.0, 0.0, -10.0])

targets = {nm: [round(v, 3) for v in p] for nm, p in A.items()}
for nm, p in B_local.items():
    targets["character1:" + nm] = [round(v, 3) for v in toB(p)]

# ---- diagnostics: is this pose reachable, and how close is it? -------------
def sep(a, b):
    return math.dist(targets[a], targets[b])


print("rig reach: upper %.1f + fore %.1f = %.1f cm" % (UPPER, FORE, REACH))
for tag, sh, hd in (("A", "arm_MainPoint_l", "hand_MainPoint_l"),
                    ("A", "arm_MainPoint_r", "hand_MainPoint_r"),
                    ("B", "character1:arm_MainPoint_l", "character1:hand_MainPoint_l"),
                    ("B", "character1:arm_MainPoint_r", "character1:hand_MainPoint_r")):
    dd = sep(sh, hd)
    print("  %s %-34s -> hand %6.1f cm  %s" % (tag, sh, dd, "OK" if dd < REACH - 1 else "TOO FAR"))

print()
print("hip   sep %6.1f cm" % sep("pelvis_MainPoint", "character1:pelvis_MainPoint"))
print("chest sep %6.1f cm" % sep("chest_MainPoint", "character1:chest_MainPoint"))
print("head  sep %6.1f cm" % sep("head_MainPoint", "character1:head_MainPoint"))
print("A left hand  -> B nape   %6.1f cm" % sep("hand_MainPoint_l", "character1:neck_MainPoint"))
print("B left hand  -> A r.arm  %6.1f cm" % sep("character1:hand_MainPoint_l", "arm_MainPoint_r"))
print("B right hand -> A l.arm  %6.1f cm" % sep("character1:hand_MainPoint_r", "arm_MainPoint_l"))

spec = {"label": "collar-and-elbow clinch", "hip_sep_cm": HIP_SEP,
        "lean_deg": LEAN_DEG, "hip_drop_cm": HIP_DROP, "head_side_cm": HEAD_SIDE, "targets": targets}
json.dump(spec, open(os.path.join(HERE, "POSE.json"), "w", encoding="utf-8"), indent=1)
print()
print("wrote POSE.json with", len(targets), "controller targets")
