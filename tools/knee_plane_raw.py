"""S408: the guard knee on the source take, same maths as tools/knee_plane_probe.gd.

The knee's distance out of the plane through hip, ankle and foot direction. + = towards the actor's own midline.
A straight leg in a wide stance reads 0.

Run: blender -b --factory-startup --python tools/knee_plane_raw.py -- <fbx> [start=<s>] [end=<s>]
Blender is Z-up, right-handed; facing +Y the actor's right is +X.
LOCOKNEE1: start=<s> end=<s> restricts measurement to frames within that time window.
"""
import math
import sys

import bpy
from mathutils import Vector

UP = Vector((0, 0, 1))


def off_plane(hip, knee, ankle, ball, is_left):
    foot = ball - ankle
    foot.z = 0.0
    if foot.length < 1e-5:
        return 0.0
    foot.normalize()
    n = (ankle - hip).normalized().cross(foot).normalized()
    right = foot.cross(UP).normalized()
    medial = right if is_left else -right
    if n.dot(medial) < 0.0:
        n = -n
    return (knee - hip).dot(n)


def selftest():
    v = Vector
    ok = True
    h, a, b = v((-0.1, 0, 1)), v((-0.1, 0, 0)), v((-0.1, 0.15, 0))
    ok &= abs(off_plane(h, v((-0.1, 0, 0.5)), a, b, True)) < 1e-4  # straight
    ok &= abs(off_plane(h, v((-0.1, 0.1, 0.5)), a, b, True)) < 1e-4  # bent over the toes
    ok &= off_plane(h, v((-0.05, 0, 0.5)), a, b, True) > 0.04  # left knee in
    ok &= off_plane(h, v((-0.15, 0, 0.5)), a, b, True) < -0.04  # left knee out
    hr, ar, br = v((0.1, 0, 1)), v((0.1, 0, 0)), v((0.1, 0.15, 0))
    ok &= off_plane(hr, v((0.05, 0, 0.5)), ar, br, False) > 0.04  # right knee in
    wa, wb = v((-0.4, 0, 0)), v((-0.4, 0.15, 0))
    ok &= abs(off_plane(h, v((-0.25, 0, 0.5)), wa, wb, True)) < 1e-4  # straight leg, wide stance
    print("KNEEPLANE_RAW_SIGN", "ok" if ok else "FAIL", flush=True)
    return ok


def bone(arm, name):
    for b in arm.pose.bones:
        if b.name.split(":")[-1].lower() == name.lower():
            return b
    return None


def stats(xs):
    return sum(xs) / len(xs), min(xs), max(xs)


def measure(path, start_s=None, end_s=None):
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.import_scene.fbx(filepath=path, automatic_bone_orientation=False)
    arm = next(o for o in bpy.context.scene.objects if o.type == "ARMATURE")
    act = arm.animation_data.action if arm.animation_data else None
    f0, f1 = (int(act.frame_range[0]), int(act.frame_range[1])) if act else (1, 1)
    fps = bpy.context.scene.render.fps
    if start_s is not None:
        f0 = max(f0, int(start_s * fps))
    if end_s is not None:
        f1 = min(f1, int(end_s * fps))
    sc = bpy.context.scene
    names = {"left": ["LeftUpLeg", "LeftLeg", "LeftFoot", "LeftToeBase"], "right": ["RightUpLeg", "RightLeg", "RightFoot", "RightToeBase"]}
    bones = {k: [bone(arm, n) for n in v] for k, v in names.items()}
    rows = {"left": {"off": [], "norm": [], "flex": []}, "right": {"off": [], "norm": [], "flex": []}}
    ahead = {"left": 0.0, "right": 0.0}
    unit = 0.01 if max(arm.dimensions) > 20 else 1.0
    used = 0
    for fr in range(f0, f1 + 1):
        sc.frame_set(fr)
        if fr - f0 < 0:
            continue
        used += 1
        mw = arm.matrix_world
        pts = {k: [(mw @ b.head) * unit for b in v] for k, v in bones.items()}
        for side, p in pts.items():
            hip, knee, ankle, ball = p
            value = off_plane(hip, knee, ankle, ball.copy(), side == "left")
            leg = (hip - ankle).length
            rows[side]["off"].append(value)
            rows[side]["norm"].append(value / max(leg, 1e-4))
            t = hip - knee
            s = ankle - knee
            rows[side]["flex"].append(180.0 - math.degrees(t.angle(s)))
        # which foot leads: along the line from the right hip to the left hip turned to her front
        hips = (pts["left"][0] + pts["right"][0]) * 0.5
        toes = (pts["left"][3] - pts["left"][2]) + (pts["right"][3] - pts["right"][2])
        toes.z = 0.0
        if toes.length > 1e-5:
            front = toes.normalized()
            for side in pts:
                ahead[side] += (pts[side][2] - hips).dot(front) / 1.0
    lead = "left" if ahead["left"] > ahead["right"] else "right"
    name = path.replace("\\", "/").split("/")[-1]
    print(f"KNEEPLANE RAW {name} frames={used} leading_foot={lead}", flush=True)
    for side, r in rows.items():
        o = stats(r["off"])
        n = stats(r["norm"])
        print(
            f"KNEEPLANE RAW {side} ({'lead' if side == lead else 'rear'}) "
            f"off={o[0]:.4f}({o[1]:.4f}..{o[2]:.4f}) norm={n[0]:.4f}({n[1]:.4f}..{n[2]:.4f}) flex={stats(r['flex'])[0]:.1f}",
            flush=True,
        )


if not selftest():
    sys.exit(1)
if "--" in sys.argv:
    args = sys.argv[sys.argv.index("--") + 1:]
    start_s = None
    end_s = None
    paths = []
    for a in args:
        if a.startswith("start="):
            start_s = float(a[6:])
        elif a.startswith("end="):
            end_s = float(a[4:])
        else:
            paths.append(a)
    for p in paths:
        measure(p, start_s, end_s)
