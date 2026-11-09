"""S408 BOXERLEAN1: torso lean on the Punch PRO source FBX.

Same definition as tools/torso_lean_probe.gd: neck minus hips, against her facing,
in degrees, + = forward. Her facing from the toe and hip lines (toes.cross(hip_line)).
Blender is Z-up; converted to Godot Y-up (x, -y, z) -> (x, z, -y) before the lean calc.

Run: blender -b --factory-startup --python tools/torso_lean_raw.py -- <fbx>
"""
import math
import sys

import bpy
from mathutils import Vector


def converted(v):
    return Vector((v.x, v.z, -v.y))


def bone(arm, name):
    for b in arm.pose.bones:
        if b.name.split(":")[-1].lower() == name.lower():
            return b
    return None


def stats(xs):
    if not xs:
        return 0.0, 0.0, 0.0
    return sum(xs) / len(xs), min(xs), max(xs)


def measure(path):
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.import_scene.fbx(filepath=path, automatic_bone_orientation=False)
    arm = next(o for o in bpy.context.scene.objects if o.type == "ARMATURE")
    act = arm.animation_data.action if arm.animation_data else None
    f0, f1 = (int(act.frame_range[0]), int(act.frame_range[1])) if act else (1, 1)
    neck_b = bone(arm, "Neck")
    hips_b = bone(arm, "Hips")
    lt_b = bone(arm, "LeftToeBase")
    la_b = bone(arm, "LeftFoot")
    rt_b = bone(arm, "RightToeBase")
    ra_b = bone(arm, "RightFoot")
    if not all([neck_b, hips_b, lt_b, la_b, rt_b, ra_b]):
        print(f"TORSO_LEAN_RAW: missing bones", flush=True)
        return
    sc = bpy.context.scene
    unit = 0.01 if max(arm.dimensions) > 20 else 1.0
    leans = {"left": [], "right": []}
    used = 0
    for fr in range(f0, f1 + 1):
        sc.frame_set(fr)
        mw = arm.matrix_world
        neck = converted((mw @ neck_b.head) * unit)
        hips = converted((mw @ hips_b.head) * unit)
        lt = converted((mw @ lt_b.head) * unit)
        la = converted((mw @ la_b.head) * unit)
        rt = converted((mw @ rt_b.head) * unit)
        ra = converted((mw @ ra_b.head) * unit)
        tor = neck - hips
        # facing: horizontal, square to the hip line, on the side the toes point
        hl = la - ra
        hl.y = 0.0
        if hl.length < 1e-5:
            continue
        # perpendicular to hip line in the horizontal plane (rotate 90°)
        f = Vector((-hl.z, 0.0, hl.x))
        if f.length < 1e-5:
            continue
        f = f.normalized()
        # orient toward the toe side
        toes_dir = (lt - la) + (rt - ra)
        toes_dir.y = 0.0
        if f.dot(toes_dir) < 0.0:
            f = -f
        lean = math.degrees(math.atan2(tor.dot(f), tor.y))
        leans["left"].append(lean)
        leans["right"].append(lean)
        used += 1
    name = path.replace("\\", "/").split("/")[-1]
    print(f"TORSO_LEAN_RAW {name} frames={used}", flush=True)
    for side in ["left", "right"]:
        m, lo, hi = stats(leans[side])
        print(f"TORSO_LEAN_RAW {side} mean={m:.1f} min={lo:.1f} max={hi:.1f}", flush=True)


if "--" in sys.argv:
    paths = [a for a in sys.argv[sys.argv.index("--") + 1:] if not a.startswith("start=") and not a.startswith("end=")]
    for p in paths:
        measure(p)
