"""Measure purchased Punch PRO FBXs on their own UE4 skeleton.

The optional ``out=<json>`` argument writes the immutable reference table used by
retarget_fidelity_test.gd.  Distances are metres; jitter is deg/frame^2.

Measured like clip_feet_probe.gd:
planted-foot slide (a foot within PLANT_M of its lowest point is planted; slide = how far it travels on the floor while
planted) and snaps (frames where a leg bone's turn changes by more than SNAP_DEG from the frame before). Compare with the
same clip baked on our MetaHuman boxer (clip_feet_probe) to see whether the pack or our pipeline makes the legs tremble.
    blender -b --factory-startup --python tools/raw_fbx_feet.py -- <fbx> [...] [out=<json>]
"""
import json
import math
import os
import sys

import bpy
from mathutils import Matrix

PLANT_M = 0.03
SNAP_DEG = 6.0
SOURCE_DIR = ""
RIG = {
    "Hips": "Hips", "Spine": "Spine", "Chest": "Spine1", "UpperChest": "Spine2", "Neck": "Neck", "Head": "Head",
    "LeftShoulder": "LeftShoulder", "LeftUpperArm": "LeftArm", "LeftLowerArm": "LeftForeArm", "LeftHand": "LeftHand",
    "LeftHandEnd": "LeftHandMiddle1", "RightShoulder": "RightShoulder", "RightUpperArm": "RightArm",
    "RightLowerArm": "RightForeArm", "RightHand": "RightHand", "RightHandEnd": "RightHandMiddle1",
    "LeftUpperLeg": "LeftUpLeg", "LeftLowerLeg": "LeftLeg", "LeftFoot": "LeftFoot", "LeftToes": "LeftToeBase",
    "RightUpperLeg": "RightUpLeg", "RightLowerLeg": "RightLeg", "RightFoot": "RightFoot", "RightToes": "RightToeBase",
}
MAPPED = [name for name in RIG if not name.endswith("End")]
TRACKED = ["Hips", "LeftFoot", "RightFoot", "LeftToes", "RightToes", "Head", "LeftHand", "RightHand", "LeftUpperLeg",
           "RightUpperLeg"]


def bone_names(arm):
    names = [b.name for b in arm.pose.bones]
    # S399 fix (rokoko-back found it): Mixamo bones are "mixamorig:LeftToeBase" - strip any "prefix:" before matching, or
    # the feet are never found and slide reads 0.000 for a measurement of nothing.
    low = {n.split(":")[-1].lower(): n for n in names}
    pick = lambda *c: next((low[x] for x in c if x in low), None)  # noqa: E731
    feet = [pick("ball_l", "foot_l", "leftfoot", "lefttoebase"), pick("ball_r", "foot_r", "rightfoot", "righttoebase")]
    legs = [n for n in names if any(k in n.lower() for k in ("calf", "thigh", "foot", "leg"))]
    calves = [n for n in names if n.lower().split(":")[-1] in ("calf_l", "calf_r", "leftleg", "rightleg")]
    root = pick("pelvis", "hips", "root")
    thighs = [pick("thigh_l", "leftupleg"), pick("thigh_r", "rightupleg")]
    shins = [pick("calf_l", "leftleg"), pick("calf_r", "rightleg")]
    ankles = [pick("foot_l", "leftfoot"), pick("foot_r", "rightfoot")]
    return feet, legs, calves, root, thighs, shins, ankles


def stance_series(pts, thighs, ankles):
    """Width across the hip line and length along it, one value per frame. Metres, floor plane."""
    widths, lengths = [], []
    n = len(next(iter(pts.values()), []))
    ok = all(thighs) and all(ankles) and all(name in pts for name in thighs + ankles)
    for i in range(n):
        if not ok:
            widths.append(0.0)
            lengths.append(0.0)
            continue
        lt, rt = pts[thighs[0]][i], pts[thighs[1]][i]
        lx, ly = lt.x - rt.x, lt.y - rt.y
        norm = math.hypot(lx, ly)
        if norm < 1e-6:
            widths.append(0.0)
            lengths.append(0.0)
            continue
        lx, ly = lx / norm, ly / norm
        lf, rf = pts[ankles[0]][i], pts[ankles[1]][i]
        dx, dy = lf.x - rf.x, lf.y - rf.y
        widths.append(abs(dx * lx + dy * ly))
        lengths.append(abs(dx * -ly + dy * lx))
    return widths, lengths


def turn_delta(q0, q1):
    return q0.rotation_difference(q1)


def converted(v):
    return (v.x, v.z, -v.y)


def write_source(arm, action, f0, f1, scene, path):
    actual = {b.name.split(":")[-1]: b.name for b in arm.pose.bones}
    names = {ours: actual[source] for ours, source in RIG.items() if source in actual}
    missing = [name for name in MAPPED if name not in names]
    if missing:
        raise RuntimeError(f"source mapping missing {missing}")
    axis = Matrix(((1, 0, 0), (0, 0, 1), (0, -1, 0))).to_quaternion()
    rest_tf = {ours: arm.matrix_world @ arm.data.bones[source].matrix_local for ours, source in names.items()}
    rest = {ours: converted(tf.translation) for ours, tf in rest_tf.items()}
    frames = []
    for frame in range(f0, f1 + 1):
        scene.frame_set(frame)
        deltas = {}
        points = {}
        for ours in MAPPED:
            pose_q = (arm.matrix_world @ arm.pose.bones[names[ours]].matrix).to_quaternion()
            rest_q = rest_tf[ours].to_quaternion()
            delta = axis @ (pose_q @ rest_q.inverted()) @ axis.inverted()
            deltas[ours] = [delta.x, delta.y, delta.z, delta.w]
        for ours in TRACKED:
            point = arm.matrix_world @ arm.pose.bones[names[ours]].head
            points[ours] = converted(point)
        frames.append({"D": deltas, "P": points})
    stem = os.path.splitext(os.path.basename(path))[0]
    out = os.path.join(SOURCE_DIR, stem + ".json")
    with open(out, "w", encoding="utf-8") as handle:
        json.dump({"source": os.path.abspath(path).replace("\\", "/"), "rest": rest, "frames": frames}, handle)


def measure(path):
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.import_scene.fbx(filepath=path, automatic_bone_orientation=False)
    arm = next(o for o in bpy.context.scene.objects if o.type == "ARMATURE")
    act = arm.animation_data.action if arm.animation_data else None
    f0, f1 = (int(act.frame_range[0]), int(act.frame_range[1])) if act else (1, 1)
    feet, legs, calves, root, thighs, shins, ankles = bone_names(arm)
    if not all(feet):
        raise RuntimeError(f"feet not found ({feet}) - no measurement")
    sc = bpy.context.scene
    pos = {f: [] for f in feet if f}
    rot = {b: [] for b in legs}
    rootp = []
    stance_pts = {n: [] for n in (thighs + ankles) if n}
    unit = 0.01 if max(arm.dimensions) > 20 else 1.0   # centimetre FBX
    for fr in range(f0, f1 + 1):
        sc.frame_set(fr)
        mw = arm.matrix_world
        for f in pos:
            pos[f].append((mw @ arm.pose.bones[f].head) * unit)
        for b in legs:
            rot[b].append((mw @ arm.pose.bones[b].matrix).to_quaternion())
        if root:
            rootp.append((mw @ arm.pose.bones[root].head) * unit)
        for n in stance_pts:
            stance_pts[n].append((mw @ arm.pose.bones[n].head) * unit)
    slide = 0.0
    for f, ps in pos.items():
        low = min(p.z for p in ps)
        for a, b in zip(ps, ps[1:]):
            if a.z - low < PLANT_M and b.z - low < PLANT_M:
                slide += math.hypot(b.x - a.x, b.y - a.y)
    widths, stance_len = stance_series(stance_pts, thighs, ankles)
    # the foot line in floor space (Godot axes: x, -y), so the test can see a stance turned as a whole
    lf, rf = stance_pts[ankles[0]], stance_pts[ankles[1]]
    dx = [a.x - b.x for a, b in zip(lf, rf)]
    dz = [-(a.y - b.y) for a, b in zip(lf, rf)]
    snaps, worst = 0, 0.0
    second = {b: [] for b in legs}
    for b, qs in rot.items():
        for i in range(2, len(qs)):
            previous = min(turn_delta(qs[i - 2], qs[i - 1]).angle, math.pi * 2 - turn_delta(qs[i - 2], qs[i - 1]).angle)
            current = min(turn_delta(qs[i - 1], qs[i]).angle, math.pi * 2 - turn_delta(qs[i - 1], qs[i]).angle)
            dd = math.degrees(abs(current - previous))
            second[b].append(dd)
            if dd > SNAP_DEG:
                snaps += 1
                worst = max(worst, dd)
    calf_values = [v for b in calves for v in second.get(b, [])]
    jitter = sum(calf_values) / len(calf_values) if calf_values else 0.0
    travel = math.hypot(rootp[-1].x - rootp[0].x, rootp[-1].y - rootp[0].y) if len(rootp) > 1 else 0.0
    leg_parts = []
    mw = arm.matrix_world
    for thigh, shin, ankle in zip(thighs, shins, ankles):
        if thigh and shin and ankle:
            hip = mw @ arm.data.bones[thigh].head_local
            knee = mw @ arm.data.bones[shin].head_local
            foot = mw @ arm.data.bones[ankle].head_local
            leg_parts.append((hip - knee).length + (knee - foot).length)
    leg = sum(leg_parts) / len(leg_parts) if leg_parts else 0.0
    name = path.replace("\\", "/").split("/")[-1]
    result = {"source": os.path.abspath(path).replace("\\", "/"), "frames": f1 - f0 + 1, "fps": sc.render.fps,
              "slide_m": slide, "snaps": snaps, "worst_deg": worst, "knee_jitter": jitter,
              "root_travel_m": travel, "leg_length_m": leg,
              "width_m": [round(v, 4) for v in widths], "length_m": [round(v, 4) for v in stance_len],
              "foot_dx": [round(v, 4) for v in dx], "foot_dz": [round(v, 4) for v in dz]}
    print(f"RAWFEET {name} frames={result['frames']} fps={result['fps']} slide_m={slide:.3f} snaps={snaps} "
          f"worst_deg={worst:.1f} knee_jitter={jitter:.3f} leg_m={leg:.3f} root_travel_m={travel:.3f}", flush=True)
    if SOURCE_DIR:
        write_source(arm, act, f0, f1, sc, path)
    return result


args = sys.argv[sys.argv.index("--") + 1:]
out = next((a[4:] for a in args if a.startswith("out=")), "")
SOURCE_DIR = next((a[8:] for a in args if a.startswith("sources=")), "")
if SOURCE_DIR:
    os.makedirs(SOURCE_DIR, exist_ok=True)
results = {}
paths = []
for a in args:
    if a.startswith(("out=", "sources=")):
        continue
    if os.path.isdir(a):
        paths.extend(os.path.join(a, name) for name in sorted(os.listdir(a)) if name.lower().endswith(".fbx"))
    else:
        paths.append(a)
for p in paths:
    try:
        value = measure(p)
        results[os.path.splitext(os.path.basename(p))[0]] = value
    except Exception as e:  # noqa: BLE001
        print(f"RAWFEET {p} failed: {e}", flush=True)
if out:
    with open(out, "w", encoding="utf-8") as handle:
        json.dump({"version": 1, "plant_m": PLANT_M, "snap_deg": SNAP_DEG, "clips": results},
                  handle, indent=2, sort_keys=True)
    print(f"RAWFEET wrote {len(results)} clips -> {out}", flush=True)
