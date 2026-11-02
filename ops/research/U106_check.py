"""U106 gate (Claude, 2026-09-14). Prints `U106_CHECK PASS` or FAIL lines. Run from the repo (or worktree) root.

Independent of the retarget: this file samples the Higgsfield clip's own joints in Blender with its own script, aligns the
two rest skeletons by their joint positions (both skin the same f01 mesh), and compares every limb segment's DIRECTION
with the bridge take's joints - a retarget that copies local rotations across different bone rolls fails here.
"""
import json
import math
import os
import re
import subprocess
import sys
import tempfile

import numpy as np

BLENDER = "D:/Tools/Blender/blender-5.2.1-windows-x64/blender.exe"
CLIP = "C:/Users/user/AppData/Local/Temp/FightCamp-higgs/jab191_rigged.glb"
OUT_BRIDGE = "C:/Users/user/AppData/Local/Temp/FightCamp-moves/f01_takes_meshy.json"
U = "C:/Users/user/AppData/Local/Temp/FightCamp-moves/U106"
SPEC = "Tools/blender_moves/specs/BOX_JAB_HEAD_LAND_F01_F09_MESHY.json"
EVENTS = "research/S4A_PAIRS/pair_BOX_JAB_HEAD_LAND_F01_F09_MESHY_events.json"
FOLD = "research/S4A_PAIRS/pair_BOX_JAB_HEAD_LAND_F01_F09_MESHY_fold.json"
OLD_FOLD = "research/S4A_PAIRS/pair_BOX_JAB_HEAD_LAND_F01_F09_fold.json"
FOOTAGE = "research/S4A_PAIRS/footage_two_men.json"
DIGEST = "research/U106_HIGGSFIELD_JAB.md"
SEGMENTS = [("LeftArm", "LeftForeArm", "LeftUpperArm", "LeftLowerArm"), ("LeftForeArm", "LeftHand", "LeftLowerArm", "LeftHand"),
            ("RightArm", "RightForeArm", "RightUpperArm", "RightLowerArm"), ("RightForeArm", "RightHand", "RightLowerArm", "RightHand"),
            ("LeftUpLeg", "LeftLeg", "LeftUpperLeg", "LeftLowerLeg"), ("LeftLeg", "LeftFoot", "LeftLowerLeg", "LeftFoot"),
            ("RightUpLeg", "RightLeg", "RightUpperLeg", "RightLowerLeg"), ("RightLeg", "RightFoot", "RightLowerLeg", "RightFoot")]
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def load(p):
    return json.load(open(p, encoding="utf-8"))


for path in ["research/U106_check.py", "Tools/blender_moves/author_pair.py", "Tools/blender_moves/bridge.py", "Tools/footage"]:
    if subprocess.run(["git", "diff", "--quiet", "origin/master", "--", path]).returncode != 0:
        fail("%s differs from origin/master - not yours to edit" % path)

# ---- the bridge take ------------------------------------------------------------------------------------------------
if not os.path.exists(OUT_BRIDGE):
    fail("%s is missing (step 1)" % OUT_BRIDGE)
    print("U106_CHECK FAIL (%d)" % len(fails))
    sys.exit(1)
br = load(OUT_BRIDGE)
takes = br.get("takes", {})
if "jab_meshy" not in takes or "idle" not in takes:
    fail("the bridge must hold takes jab_meshy and idle, it holds %s" % sorted(takes))
tk = takes.get("jab_meshy", {})
times = [float(x) for x in tk.get("times", [])]
if len(times) < 60 or any(abs((b - a) - 1.0 / 60.0) > 1e-4 for a, b in zip(times, times[1:])):
    fail("jab_meshy times must be a 60 fps grid (got %d samples)" % len(times))
if not 1.70 <= float(tk.get("length_s", 0)) <= 1.85:
    fail("jab_meshy length_s %s - the clip is 43 frames at 24 fps (~1.79 s)" % tk.get("length_s"))
names = [b["name"] for b in br["bones"]]


def our_joint(row, bone):
    i = names.index(bone)
    return np.array(row[12 * i + 9:12 * i + 12], dtype=float)


poses = tk.get("pose", [])
# contact_s = the reach peak, recomputed
if poses:
    reach = [float(np.linalg.norm(our_joint(r, "LeftHand") - our_joint(r, "LeftUpperArm"))) for r in poses]
    k_peak = int(np.argmax(reach))
    if abs(float(tk.get("contact_s", -1)) - times[k_peak]) > 1.0 / 60.0 + 1e-6:
        fail("contact_s %s is not the LeftHand reach peak (%.3f s)" % (tk.get("contact_s"), times[k_peak]))
    lengths = [float(np.linalg.norm(our_joint(r, "LeftLowerArm") - our_joint(r, "LeftUpperArm"))) for r in poses]
    if max(lengths) - min(lengths) > 1e-3:
        fail("the upper arm changes length by %.4f across the take - the rows are not a posed skeleton" % (max(lengths) - min(lengths)))

# ---- the clip's own joints, sampled independently in Blender ---------------------------------------------------------
sample_times = [times[int(round(i * (len(times) - 1) / 13.0))] for i in range(14)] if times else []
tmp = tempfile.mkdtemp()
src_json = os.path.join(tmp, "src.json")
script = os.path.join(tmp, "sample.py")
open(script, "w", encoding="utf-8").write('''
import bpy, json, sys
bpy.ops.wm.read_factory_settings(use_empty=True)
bpy.ops.import_scene.gltf(filepath=r"%s")
arm = next(o for o in bpy.data.objects if o.type == "ARMATURE")
act = arm.animation_data.action if arm.animation_data and arm.animation_data.action else bpy.data.actions[0]
arm.animation_data.action = act
f0 = act.frame_range[0]
fps = bpy.context.scene.render.fps / bpy.context.scene.render.fps_base
out = {"rest": {b.name: list(arm.matrix_world @ b.head_local) for b in arm.data.bones}, "frames": []}
for t in %s:
    bpy.context.scene.frame_set(int(f0 + t * fps), subframe=(f0 + t * fps) %% 1.0)
    out["frames"].append({b.name: list(arm.matrix_world @ arm.pose.bones[b.name].head) for b in arm.data.bones})
json.dump(out, open(r"%s", "w"))
''' % (CLIP.replace("\\", "/"), json.dumps(sample_times), src_json.replace("\\", "/")))
r = subprocess.run([BLENDER, "--background", "--factory-startup", "--python", script], capture_output=True, text=True, timeout=600)
if not os.path.exists(src_json):
    fail("the independent Blender sampling failed: %s" % (r.stdout[-400:] + r.stderr[-400:]))
else:
    src = load(src_json)
    common = [("Hips", "Hips"), ("LeftArm", "LeftUpperArm"), ("LeftForeArm", "LeftLowerArm"), ("LeftHand", "LeftHand"),
              ("RightArm", "RightUpperArm"), ("RightForeArm", "RightLowerArm"), ("RightHand", "RightHand"),
              ("LeftUpLeg", "LeftUpperLeg"), ("LeftLeg", "LeftLowerLeg"), ("LeftFoot", "LeftFoot"),
              ("RightUpLeg", "RightUpperLeg"), ("RightLeg", "RightLowerLeg"), ("RightFoot", "RightFoot"), ("Head", "Head")]
    A = np.array([src["rest"][s] for s, _ in common])
    B = np.array([np.array(next(b["rest"] for b in br["bones"] if b["name"] == o)[9:12], dtype=float) for _, o in common])
    mu_a, mu_b = A.mean(0), B.mean(0)
    cov = (B - mu_b).T @ (A - mu_a) / len(A)
    u, _, vt = np.linalg.svd(cov)
    d = np.eye(3)
    if np.linalg.det(u) * np.linalg.det(vt) < 0:
        d[2, 2] = -1
    R = u @ d @ vt   # source (Blender world) directions -> our skeleton space
    bad, total, worst = 0, 0, 0.0
    for fr, t in zip(src["frames"], sample_times):
        k = min(range(len(times)), key=lambda q: abs(times[q] - t))
        for s0, s1, o0, o1 in SEGMENTS:
            vs = R @ (np.array(fr[s1]) - np.array(fr[s0]))
            vo = our_joint(poses[k], o1) - our_joint(poses[k], o0)
            ang = math.degrees(math.acos(max(-1.0, min(1.0, float(np.dot(vs, vo) / (np.linalg.norm(vs) * np.linalg.norm(vo) + 1e-12))))))
            total += 1
            worst = max(worst, ang)
            bad += ang > 12.0
    print("U106_CHECK limb directions: %d of %d samples within 12 deg of the clip's own (worst %.1f deg)" % (total - bad, total, worst))
    if total == 0 or bad > 0.1 * total:
        fail("%d of %d limb-segment samples point more than 12 deg away from the Higgsfield clip's own - the retarget does not carry the motion" % (bad, total))

# ---- the authored pair and its measurement ---------------------------------------------------------------------------
pair_files = [os.path.join(U, f) for f in os.listdir(U)] if os.path.isdir(U) else []
if not any(f.endswith(".json") and "pair" in os.path.basename(f) for f in pair_files):
    fail("no authored pair json under %s (step 2)" % U)
if not os.path.exists(SPEC) or load(SPEC).get("roles", {}).get("thrower", {}).get("move") != "jab_meshy":
    fail("%s must exist with the thrower's move jab_meshy" % SPEC)
foot = load(FOOTAGE)["jabs_head_height"]
verdicts = {}
for tag, path in (("committed", OLD_FOLD), ("meshy", FOLD)):
    if not os.path.exists(path):
        fail("%s is missing" % path)
        continue
    block = load(path)["jabs_head_height"]
    v = {}
    for key, s in block.items():
        if key in ("definition", "punches") or not isinstance(s, dict) or not s.get("n"):
            continue
        f = foot.get(key) or {}
        if not f.get("n"):
            continue
        v[key] = "inside" if f["p10"] <= s["p50"] <= f["p90"] else "OUTSIDE"
    verdicts[tag] = v
if os.path.exists(FOLD) and "Meshy" not in load(FOLD).get("population", "") and "meshy" not in load(FOLD).get("population", "").lower():
    fail("the Meshy fold's population must name the Meshy/Higgsfield source")
if not os.path.exists(EVENTS):
    fail("%s is missing" % EVENTS)

# ---- the digest ------------------------------------------------------------------------------------------------------
if not os.path.exists(DIGEST):
    fail("%s is missing" % DIGEST)
elif len(verdicts) == 2:
    text = open(DIGEST, encoding="utf-8").read()
    if len(text.splitlines()) > 70:
        fail("the digest has %d lines - 70 at most" % len(text.splitlines()))
    for head in ("# U106 - a Higgsfield jab on our fighter", "## DECISIONS", "## Bone map", "## Compare", "## Population"):
        if head not in text:
            fail("the digest has no '%s'" % head)
    dec = text.split("## DECISIONS", 1)[-1].split("\n## ", 1)[0]
    for tag in ("committed", "meshy"):
        n_in = sum(1 for x in verdicts[tag].values() if x == "inside")
        if not re.search(r"(^|\D)%d(\D|$)" % n_in, dec):
            fail("DECISIONS must state the %s pair's inside count (%d of %d keys)" % (tag, n_in, len(verdicts[tag])))
    fences = re.findall(r"```text\n(.*?)```", text.split("## Compare", 1)[-1], flags=re.S)
    if len(fences) < 2:
        fail("## Compare needs both compare_to_footage.py outputs in their own ```text fences, the committed pair first")
    else:
        for tag, fence in zip(("committed", "meshy"), fences):
            for key, verdict in verdicts[tag].items():
                line = next((l for l in fence.splitlines() if re.search(r"(^|[^A-Za-z0-9_])%s([^A-Za-z0-9_]|$)" % re.escape(key), l)), None)
                if line is None or verdict not in line:
                    fail("%s compare output: `%s` should read %s (found `%s`)" % (tag, key, verdict, line))
                    break
    if os.path.exists(FOLD) and load(FOLD).get("population", "") not in text.split("## Population", 1)[-1]:
        fail("## Population must hold the Meshy fold's population string verbatim")

print("U106_CHECK PASS" if not fails else "U106_CHECK FAIL (%d)" % len(fails))
sys.exit(0 if not fails else 1)
