"""U107 gate (Claude, 2026-09-14). Prints `U107_CHECK PASS` or FAIL lines. Run from the repo (or worktree) root.

Independent of the retarget: the source joints come straight from each .npz's posed_joints (numpy, no Blender); the two
skeletons are aligned by a best rotation on row 0; every limb segment's DIRECTION is compared through the take. Every
mechanics number is recomputed from the bridge rows with this file's own code.
"""
import json
import math
import os
import re
import subprocess
import sys

import numpy as np

CLIPS = "C:/Users/user/AppData/Local/Temp/FightCamp-higgs/motion/types"
MOVES = "C:/Users/user/AppData/Local/Temp/FightCamp-moves"
OUT_BRIDGE = MOVES + "/f01_takes_t2m.json"
TAKES = {"jab_committed_t2m": "jab_committed_41", "jab_rangefinder_t2m": "jab_feint_41", "jab_feint_t2m": "jab_feint_37"}
MECH = "research/S4A_PAIRS/take_mechanics_jab_types.json"
DIGEST = "research/U107_T2M_JAB_TYPES.md"
LABELS = {"t2m_committed": (OUT_BRIDGE, "jab_committed_t2m"), "t2m_rangefinder": (OUT_BRIDGE, "jab_rangefinder_t2m"),
          "t2m_feint": (OUT_BRIDGE, "jab_feint_t2m"), "bought_jab": (MOVES + "/f01_takes.json", "jab"),
          "meshy_jab": (MOVES + "/f01_takes_meshy.json", "jab_meshy")}
COMMON = [(0, "Hips"), (14, "LeftUpperArm"), (15, "LeftLowerArm"), (16, "LeftHand"), (8, "RightUpperArm"),
          (9, "RightLowerArm"), (10, "RightHand"), (23, "LeftUpperLeg"), (24, "LeftLowerLeg"), (25, "LeftFoot"),
          (19, "RightUpperLeg"), (20, "RightLowerLeg"), (21, "RightFoot"), (6, "Head")]
SEGMENTS = [(14, 15, "LeftUpperArm", "LeftLowerArm"), (15, 16, "LeftLowerArm", "LeftHand"),
            (8, 9, "RightUpperArm", "RightLowerArm"), (9, 10, "RightLowerArm", "RightHand"),
            (23, 24, "LeftUpperLeg", "LeftLowerLeg"), (24, 25, "LeftLowerLeg", "LeftFoot"),
            (19, 20, "RightUpperLeg", "RightLowerLeg"), (20, 21, "RightLowerLeg", "RightFoot")]
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def load(p):
    return json.load(open(p, encoding="utf-8"))


for path in ["research/U107_check.py", "Tools/blender_moves/author_pair.py", "Tools/blender_moves/bridge.py",
             "Tools/blender_moves/glb_clip_to_bridge.py", "Tools/footage"]:
    if subprocess.run(["git", "diff", "--quiet", "origin/master", "--", path]).returncode != 0:
        fail("%s differs from origin/master - not yours to edit" % path)


def joints(bridge, row, name):
    names = [b["name"] for b in bridge["bones"]]
    i = names.index(name)
    return np.array(row[12 * i + 9:12 * i + 12], dtype=float)


def kabsch(src, dst):
    a, b = src - src.mean(0), dst - dst.mean(0)
    u, _, vt = np.linalg.svd(b.T @ a)
    d = np.eye(3)
    if np.linalg.det(u) * np.linalg.det(vt) < 0:
        d[2, 2] = -1
    return u @ d @ vt


if not os.path.exists(OUT_BRIDGE):
    fail("%s is missing (step 1)" % OUT_BRIDGE)
    print("U107_CHECK FAIL (%d)" % len(fails))
    sys.exit(1)
br = load(OUT_BRIDGE)
takes = br.get("takes", {})
for need in list(TAKES) + ["idle"]:
    if need not in takes:
        fail("%s must hold take %s (it holds %s)" % (OUT_BRIDGE, need, sorted(takes)))

# ---- each t2m take against its own npz ------------------------------------------------------------------------------
for take, clip in TAKES.items():
    tk = takes.get(take)
    if not tk:
        continue
    src = np.load(os.path.join(CLIPS, clip + ".npz"))["posed_joints"].astype(float)
    frames = src.shape[0]
    times = [float(x) for x in tk.get("times", [])]
    poses = tk.get("pose", [])
    want_len = (frames - 1) / 20.0
    if len(times) < 10 or any(abs((b - a) - 1.0 / 60.0) > 1e-4 for a, b in zip(times, times[1:])):
        fail("%s times must be a 60 fps grid" % take)
        continue
    if abs(float(tk.get("length_s", 0)) - want_len) > 0.02 or abs(times[-1] - want_len) > 0.02:
        fail("%s length_s %s / last time %.3f - the clip is %d frames at 20 fps (%.2f s)" % (take, tk.get("length_s"), times[-1], frames, want_len))
    reach = [float(np.linalg.norm(joints(br, r, "LeftHand") - joints(br, r, "LeftUpperArm"))) for r in poses]
    k_peak = int(np.argmax(reach))
    if abs(float(tk.get("contact_s", -1)) - times[k_peak]) > 1.0 / 60.0 + 1e-6:
        fail("%s contact_s %s is not the LeftHand reach peak (%.3f s)" % (take, tk.get("contact_s"), times[k_peak]))
    upper = [float(np.linalg.norm(joints(br, r, "LeftLowerArm") - joints(br, r, "LeftUpperArm"))) for r in poses]
    if max(upper) - min(upper) > 1e-3:
        fail("%s: the upper arm changes length by %.4f - the rows are not a posed skeleton" % (take, max(upper) - min(upper)))

    def src_at(t):
        x = min(max(t * 20.0, 0.0), frames - 1.0)
        i0 = int(math.floor(x))
        i1 = min(i0 + 1, frames - 1)
        w = x - i0
        return src[i0] * (1 - w) + src[i1] * w

    R = kabsch(np.array([src_at(0.0)[j] for j, _ in COMMON]), np.array([joints(br, poses[0], n) for _, n in COMMON]))
    bad = total = 0
    worst = 0.0
    for q in range(14):
        k = int(round(q * (len(times) - 1) / 13.0))
        s = src_at(times[k])
        for j0, j1, n0, n1 in SEGMENTS:
            vs = R @ (s[j1] - s[j0])
            vo = joints(br, poses[k], n1) - joints(br, poses[k], n0)
            ang = math.degrees(math.acos(max(-1.0, min(1.0, float(np.dot(vs, vo) / (np.linalg.norm(vs) * np.linalg.norm(vo) + 1e-12))))))
            total += 1
            bad += ang > 12.0
            worst = max(worst, ang)
    print("U107_CHECK %s limb directions: %d of %d within 12 deg of %s's own joints (worst %.1f deg)" % (take, total - bad, total, clip, worst))
    if bad > 0.1 * total:
        fail("%s: %d of %d limb-segment samples point more than 12 deg away from the npz's joints - the retarget does not carry the motion" % (take, bad, total))


# ---- the mechanics, recomputed ----------------------------------------------------------------------------------------
def mechanics(bridge, take):
    tk = bridge["takes"][take]
    rows, times = tk["pose"], [float(x) for x in tk["times"]]
    J = lambda r, n: joints(bridge, r, n)
    up = J(rows[0], "Head") - 0.5 * (J(rows[0], "LeftFoot") + J(rows[0], "RightFoot"))
    up /= np.linalg.norm(up)
    T = float(np.linalg.norm(J(rows[0], "Neck") - J(rows[0], "Hips")))
    arm = float(np.linalg.norm(J(rows[0], "LeftLowerArm") - J(rows[0], "LeftUpperArm")) + np.linalg.norm(J(rows[0], "LeftHand") - J(rows[0], "LeftLowerArm")))
    reach = np.array([np.linalg.norm(J(r, "LeftHand") - J(r, "LeftUpperArm")) for r in rows])
    peak = int(np.argmax(reach))
    guard = float(np.median([reach[i] for i, t in enumerate(times) if t <= min(0.3, 0.5 * times[peak])] or [reach[0]]))
    rise = float(reach[peak] - guard)
    onset = 0
    for r in range(peak - 1, -1, -1):
        if reach[r] < guard + 0.2 * rise:
            onset = r + 1
            break
    fwd = J(rows[peak], "LeftHand") - J(rows[peak], "LeftUpperArm")
    fwd = fwd - np.dot(fwd, up) * up
    fwd /= np.linalg.norm(fwd)
    return {"reach_share_peak": float(reach[peak] / arm), "extension_s": times[peak] - times[onset],
            "hips_out_T": float(np.dot(J(rows[peak], "Hips") - J(rows[onset], "Hips"), fwd) / T),
            "lead_ankle_out_T": float(np.dot(J(rows[peak], "LeftFoot") - J(rows[onset], "LeftFoot"), fwd) / T)}


TOL = {"reach_share_peak": 0.02, "extension_s": 1.0 / 60.0 + 1e-3, "hips_out_T": 0.03, "lead_ankle_out_T": 0.03}
if not os.path.exists(MECH):
    fail("%s is missing (step 2)" % MECH)
    mech = {}
else:
    mech = load(MECH)
    if sorted(mech.get("takes", {})) != sorted(LABELS):
        fail("%s takes must be exactly %s" % (MECH, sorted(LABELS)))
    for label, (path, take) in LABELS.items():
        got = mech.get("takes", {}).get(label)
        if not got or not os.path.exists(path) or take not in load(path).get("takes", {}):
            continue
        mine = mechanics(load(path), take)
        for key, tol in TOL.items():
            if got.get(key) is None or abs(float(got[key]) - mine[key]) > tol:
                fail("%s %s = %s, recomputed %.4f" % (label, key, got.get(key), mine[key]))
        print("U107_CHECK %-16s share %.2f extension %.3f s hips %.3f T lead ankle %.3f T" % (
            label, mine["reach_share_peak"], mine["extension_s"], mine["hips_out_T"], mine["lead_ankle_out_T"]))

# ---- the digest ------------------------------------------------------------------------------------------------------
if not os.path.exists(DIGEST):
    fail("%s is missing" % DIGEST)
else:
    text = open(DIGEST, encoding="utf-8").read()
    if len(text.splitlines()) > 70:
        fail("the digest has %d lines - 70 at most" % len(text.splitlines()))
    for head in ("# U107 - text-to-motion jab types on our fighter", "## DECISIONS", "## Mechanics", "## Bone map", "## Population"):
        if head not in text:
            fail("the digest has no '%s'" % head)
    dec = text.split("## DECISIONS", 1)[-1].split("\n## ", 1)[0]
    for label, row in mech.get("takes", {}).items():
        share = "%.2f" % float(row.get("reach_share_peak", -1))
        if label not in dec or share not in dec:
            fail("DECISIONS must name %s with its reach_share_peak %s" % (label, share))
    if mech.get("population") and mech["population"] not in text.split("## Population", 1)[-1]:
        fail("## Population must hold the JSON's population string verbatim")

print("U107_CHECK PASS" if not fails else "U107_CHECK FAIL (%d)" % len(fails))
sys.exit(0 if not fails else 1)
