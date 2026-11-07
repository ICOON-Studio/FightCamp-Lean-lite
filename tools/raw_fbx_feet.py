"""raw_fbx_feet.py - S399: the PURCHASED clip on its OWN skeleton (Blender, no retarget), measured like clip_feet_probe.gd:
planted-foot slide (a foot within PLANT_M of its lowest point is planted; slide = how far it travels on the floor while
planted) and snaps (frames where a leg bone's turn changes by more than SNAP_DEG from the frame before). Compare with the
same clip baked on our MetaHuman boxer (clip_feet_probe) to see whether the pack or our pipeline makes the legs tremble.
    blender -b --factory-startup --python tools/raw_fbx_feet.py -- <fbx> [<fbx> ...]
Prints RAWFEET <name> frames= slide_m= snaps= worst_deg= root_travel_m=
"""
import math
import sys

import bpy

PLANT_M = 0.03
SNAP_DEG = 6.0


def bone_names(arm):
    names = [b.name for b in arm.pose.bones]
    low = {n.lower(): n for n in names}
    pick = lambda *c: next((low[x] for x in c if x in low), None)  # noqa: E731
    feet = [pick("ball_l", "foot_l", "leftfoot", "lefttoebase"), pick("ball_r", "foot_r", "rightfoot", "righttoebase")]
    legs = [n for n in names if any(k in n.lower() for k in ("calf", "thigh", "foot", "leg"))]
    root = pick("pelvis", "hips", "root")
    return feet, legs, root


def measure(path):
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.import_scene.fbx(filepath=path, automatic_bone_orientation=False)
    arm = next(o for o in bpy.context.scene.objects if o.type == "ARMATURE")
    act = arm.animation_data.action if arm.animation_data else None
    f0, f1 = (int(act.frame_range[0]), int(act.frame_range[1])) if act else (1, 1)
    feet, legs, root = bone_names(arm)
    sc = bpy.context.scene
    pos = {f: [] for f in feet if f}
    rot = {b: [] for b in legs}
    rootp = []
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
    slide = 0.0
    for f, ps in pos.items():
        up = 2 if abs(ps[0].z) > 1e-9 or True else 1
        low = min(p.z for p in ps)
        for a, b in zip(ps, ps[1:]):
            if a.z - low < PLANT_M and b.z - low < PLANT_M:
                slide += math.hypot(b.x - a.x, b.y - a.y)
    snaps, worst = 0, 0.0
    for b, qs in rot.items():
        for i in range(2, len(qs)):
            w = lambda a: min(a, 2 * math.pi - a)  # noqa: E731 - a quaternion turn of 359 deg is 1 deg
            d1 = w(qs[i - 1].rotation_difference(qs[i]).angle)
            d0 = w(qs[i - 2].rotation_difference(qs[i - 1]).angle)
            dd = math.degrees(abs(d1 - d0))
            if dd > SNAP_DEG:
                snaps += 1
                worst = max(worst, dd)
    travel = math.hypot(rootp[-1].x - rootp[0].x, rootp[-1].y - rootp[0].y) if len(rootp) > 1 else 0.0
    name = path.replace("\\", "/").split("/")[-1]
    print(f"RAWFEET {name} frames={f1 - f0 + 1} fps={sc.render.fps} slide_m={slide:.3f} snaps={snaps} worst_deg={worst:.1f} "
          f"root_travel_m={travel:.3f} feet={feet}", flush=True)


for p in sys.argv[sys.argv.index("--") + 1:]:
    try:
        measure(p)
    except Exception as e:  # noqa: BLE001
        print(f"RAWFEET {p} failed: {e}", flush=True)
