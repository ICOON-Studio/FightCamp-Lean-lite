"""raw_fbx_window.py - S399 ROKOKO2: the RAW Rokoko take on its own Mixamo skeleton (Blender, no retarget), measured per
WINDOW the way tools/rokoko_feet_probe.gd measures our port on the drawn pose, so the two numbers compare like for like:
  slide_m   a foot (ball = toe-base head) is planted while within PLANT_M of its lowest point IN THE WINDOW; slide = how far
            it travels on the floor while planted
  leg_snaps clip_feet_probe.gd's definition on the leg bones: the turn of a bone's parent-relative rotation from one sample
            to the next; a snap = that turn changing by more than SNAP_DEG from the turn before
  hips_xz   how far the hips wander on the floor in the window (max distance from their first position)
Sampled at FPS (30 = the game's probe rate; Blender evaluates the take's own curves between its 24 fps keys).
    blender -b --factory-startup --python tools/raw_fbx_window.py -- <fbx>@<start_s>-<end_s> [...] [fps=30]
Prints RAWWIN <take>@<start>-<end> slide_m= leg_snaps= worst_deg= hips_xz_m= stance_m=
"""
import math
import sys

import bpy

PLANT_M = 0.03
SNAP_DEG = 6.0
LEG_KEYS = ("upleg", "leg", "foot", "toe")


def load(path):
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.import_scene.fbx(filepath=path, automatic_bone_orientation=False)
    arm = next(o for o in bpy.context.scene.objects if o.type == "ARMATURE")
    return arm


def find(arm, *names):
    low = {b.name.lower().replace("mixamorig:", "").replace("mixamorig_", ""): b.name for b in arm.pose.bones}
    return next((low[n] for n in names if n in low), None)


def measure(arm, take, t0, t1, fps):
    sc = bpy.context.scene
    act = arm.animation_data.action
    f0 = act.frame_range[0]
    src_fps = sc.render.fps / sc.render.fps_base
    unit = 0.01 if max(arm.dimensions) > 20 else 1.0
    feet = [find(arm, "lefttoebase"), find(arm, "righttoebase")]
    hips = find(arm, "hips")
    legs = [b.name for b in arm.pose.bones if any(k in b.name.lower().split(":")[-1] for k in LEG_KEYS)
            and "hand" not in b.name.lower() and "arm" not in b.name.lower()]
    n = int(round((t1 - t0) * fps)) + 1
    pos = {f: [] for f in feet}
    rot = {b: [] for b in legs}
    hp = []
    for i in range(n):
        fr = f0 + (t0 + i / fps) * src_fps
        sc.frame_set(int(math.floor(fr)), subframe=fr - math.floor(fr))
        mw = arm.matrix_world
        for f in feet:
            pos[f].append((mw @ arm.pose.bones[f].head) * unit)
        for b in legs:
            pb = arm.pose.bones[b]
            m = pb.matrix if pb.parent is None else pb.parent.matrix.inverted() @ pb.matrix
            rot[b].append(m.to_quaternion())
        hp.append((mw @ arm.pose.bones[hips].head) * unit)
    slide = 0.0
    for ps in pos.values():
        low = min(p.z for p in ps)
        for a, b in zip(ps, ps[1:]):
            if a.z - low < PLANT_M and b.z - low < PLANT_M:
                slide += math.hypot(b.x - a.x, b.y - a.y)
    snaps, worst = 0, 0.0
    for qs in rot.values():
        prev = None
        for a, b in zip(qs, qs[1:]):
            turn = b @ a.inverted()
            if prev is not None:
                d = math.degrees(prev.rotation_difference(turn).angle)
                d = min(d, 360.0 - d)
                if d > SNAP_DEG:
                    snaps += 1
                worst = max(worst, d)
            prev = turn
    wander = max(math.hypot(p.x - hp[0].x, p.y - hp[0].y) for p in hp)
    stance = sum(math.hypot(a.x - b.x, a.y - b.y) for a, b in zip(pos[feet[0]], pos[feet[1]])) / n
    print(f"RAWWIN {take}@{t0:.2f}-{t1:.2f} fps={fps} slide_m={slide:.3f} leg_snaps={snaps} worst_deg={worst:.1f} "
          f"hips_xz_m={wander:.3f} stance_m={stance:.3f} src_fps={src_fps:.0f} legs={len(legs)}", flush=True)


args = sys.argv[sys.argv.index("--") + 1:]
fps = 30.0
for a in args:
    if a.startswith("fps="):
        fps = float(a[4:])
loaded = {}
for a in args:
    if "@" not in a:
        continue
    path, win = a.rsplit("@", 1)
    t0, t1 = (float(x) for x in win.split("-"))
    take = path.replace("\\", "/").split("/")[-1].replace("_mixamo.fbx", "")
    try:
        arm = load(path)
        measure(arm, take, t0, t1, fps)
    except Exception as e:  # noqa: BLE001
        print(f"RAWWIN {a} failed: {e}", flush=True)
