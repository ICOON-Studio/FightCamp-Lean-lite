"""S409 HITREACT1: hit reaction movement on the Punch PRO source FBX.

Same maths as tools/hit_react_probe.gd:
  HEAD: max distance the Head bone moves from where it starts, relative to UpperChest (spine top), metres.
  TRUNK: max change in the angle of the line from Hips to Neck, degrees.

Blender is Z-up; the measure is coordinate-independent (distances and angles).
Run: blender -b --factory-startup --python tools/hit_react_raw.py -- <fbx> [...]
"""
import math
import sys

import bpy
from mathutils import Vector

BONES = {
    "head": "Head",
    "neck": "Neck",
    "hips": "Hips",
    "chest": "UpperChest",
}
CHEST_FALLBACKS = ["Spine2", "Spine1", "Chest"]


def bone(arm, name):
    for b in arm.pose.bones:
        if b.name.split(":")[-1].lower() == name.lower():
            return b
    return None


def trunk_angle(hips, neck):
    v = neck - hips
    if v.length < 1e-5:
        return 0.0
    up = Vector((0, 0, 1))
    return math.degrees(v.angle(up))


def head_disp(head, head0, chest, chest0):
    return ((head - chest) - (head0 - chest0)).length


def selftest():
    ok = True
    h0, c0 = Vector((0, 0, 1.1)), Vector((0, 0, 0.9))
    h1, c1 = Vector((0, 0, 1.0)), Vector((0, 0, 0.9))
    ok &= abs(head_disp(h0, h1, c0, c1) - 0.1) < 1e-4
    s = Vector((1, 0, 0))
    ok &= abs(head_disp(h0 + s, h1 + s, c0 + s, c1 + s) - 0.1) < 1e-4
    ok &= abs(trunk_angle(Vector((0, 0, 1)), Vector((0, 0, 2)))) < 0.1
    neck_tilt = Vector((0, math.sin(math.radians(20)), math.cos(math.radians(20))))
    ok &= abs(trunk_angle(Vector((0, 0, 1)), Vector((0, 0, 1)) + neck_tilt) - 20.0) < 0.5
    hips_off = Vector((5, -3, 0))
    ok &= abs(trunk_angle(hips_off, hips_off + neck_tilt) - 20.0) < 0.5
    print("HITREACT_RAW_SIGN", "ok" if ok else "FAIL", flush=True)
    return ok


def measure(path):
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.import_scene.fbx(filepath=path, automatic_bone_orientation=False)
    arm = next(o for o in bpy.context.scene.objects if o.type == "ARMATURE")
    act = arm.animation_data.action if arm.animation_data else None
    f0, f1 = (int(act.frame_range[0]), int(act.frame_range[1])) if act else (1, 1)
    fps = bpy.context.scene.render.fps

    head_b = bone(arm, BONES["head"])
    neck_b = bone(arm, BONES["neck"])
    hips_b = bone(arm, BONES["hips"])
    chest_b = bone(arm, BONES["chest"])
    if chest_b is None:
        for fb in CHEST_FALLBACKS:
            chest_b = bone(arm, fb)
            if chest_b is not None:
                break
    if not all([head_b, neck_b, hips_b, chest_b]):
        name = path.replace("\\", "/").split("/")[-1]
        print(f"HITREACT_RAW {name} MISSING_BONES", flush=True)
        return

    sc = bpy.context.scene
    unit = 0.01 if max(arm.dimensions) > 20 else 1.0
    mw = arm.matrix_world

    base_head = (mw @ head_b.head) * unit
    base_neck = (mw @ neck_b.head) * unit
    base_hips = (mw @ hips_b.head) * unit
    base_chest = (mw @ chest_b.head) * unit
    base_ta = trunk_angle(base_hips, base_neck)

    peak_head = 0.0
    peak_trunk = 0.0
    used = 0

    for fr in range(f0, f1 + 1):
        sc.frame_set(fr)
        mw = arm.matrix_world
        h = (mw @ head_b.head) * unit
        n = (mw @ neck_b.head) * unit
        hp = (mw @ hips_b.head) * unit
        c = (mw @ chest_b.head) * unit
        hd = head_disp(h, base_head, c, base_chest)
        ta = abs(trunk_angle(hp, n) - base_ta)
        peak_head = max(peak_head, hd)
        peak_trunk = max(peak_trunk, ta)
        used += 1

    name = path.replace("\\", "/").split("/")[-1]
    print(f"HITREACT_RAW {name} frames={used} head_m={peak_head:.4f} trunk_deg={peak_trunk:.1f} first_head_y={base_head.z:.3f}", flush=True)


if not selftest():
    sys.exit(1)
if "--" in sys.argv:
    paths = [a for a in sys.argv[sys.argv.index("--") + 1:] if not a.startswith("start=") and not a.startswith("end=")]
    for p in paths:
        measure(p)
