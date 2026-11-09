"""LOCOSLIDE1: the walking foot slide on the source FBX, same maths as tools/foot_slide_probe.gd.

For each loco clip's source FBX and time window: world-space ankle and ball every frame; a foot is PLANTED when its ball
sits within PLANT_M of the lowest height it reaches in the clip AND moves under SPEED_MAX m/s; consecutive planted frames
form a STRETCH whose slide is the frame-to-frame ball travel summed; SNAPS counts frames where the ball jumps > SNAP_M.

Run:
    "C:/Program Files/Blender Foundation/Blender 5.2/blender.exe" -b --factory-startup --python tools/loco_slide_raw.py

Blender is Z-up right-handed; the script converts to Godot Y-down world space (x, z, -y) -> (x, y, z) so the planted
height is the Godot Y and the floor travel is the XZ plane.  The unit conversion (cm FBX vs m) follows raw_fbx_feet.py.
"""
import math
import sys

import bpy
from mathutils import Vector

PLANT_M = 0.03
SPEED_MAX = 0.25
SNAP_M = 0.03

CLIPS = [
    {"name": "rk_loc_in",  "file": "assets/anim/rokoko_combat/Boxing_mixamo.fbx",          "start_s": 0.20, "end_s": 1.80,  "mirror": True},
    {"name": "rk_loc_back","file": "assets/anim/mixamo_walk/Walking_Backwards.fbx",         "start_s": 0.0,  "end_s": 0.85,  "mirror": False},
    {"name": "rk_loc_left","file": "assets/anim/mixamo_walk/Boxing_Left_Side_Step_Walk.fbx","start_s": 0.0,  "end_s": 1.033, "mirror": False},
    {"name": "rk_loc_right","file":"assets/anim/mixamo_walk/Boxing_Side_Step_Walk.fbx",      "start_s": 0.0,  "end_s": 1.033, "mirror": False},
]

BONES = {
    "left":  {"hip": "LeftUpLeg",   "knee": "LeftLeg",      "ankle": "LeftFoot",    "ball": "LeftToeBase"},
    "right": {"hip": "RightUpLeg",  "knee": "RightLeg",     "ankle": "RightFoot",   "ball": "RightToeBase"},
}


def find_bone(arm, name):
    low = name.lower()
    for b in arm.pose.bones:
        if b.name.split(":")[-1].lower() == low:
            return b
    return None


def to_godot(v):
    """Blender (Z-up right-hand) -> Godot (Y-up right-hand): (x, y_blender, z_blender) -> (x, z_blender, -y_blender)."""
    return Vector((v.x, v.z, -v.y))


def compute_metrics(positions, fps):
    if not positions:
        return {"planted_share": 0, "slide_mean": 0, "slide_worst": 0, "snaps": 0,
                "planted_frames": 0, "total_frames": 0, "stretches": 0}
    dt = 1.0 / fps
    min_y = min(p["ball"].y for p in positions)
    planted = []
    for i, p in enumerate(positions):
        height_ok = (p["ball"].y - min_y) < PLANT_M
        speed_ok = True
        if i > 0:
            dist = (p["ball"] - positions[i - 1]["ball"]).length
            speed_ok = (dist / dt) < SPEED_MAX
        planted.append(height_ok and speed_ok)
    stretches = []
    cur = []
    for i, v in enumerate(planted):
        if v:
            cur.append(i)
        else:
            if cur:
                stretches.append(list(cur))
                cur = []
    if cur:
        stretches.append(list(cur))
    slides = []
    for stretch in stretches:
        slide = 0.0
        for j in range(1, len(stretch)):
            slide += (positions[stretch[j]]["ball"] - positions[stretch[j - 1]]["ball"]).length
        slides.append(slide)
    snaps = 0
    for i in range(1, len(positions)):
        if (positions[i]["ball"] - positions[i - 1]["ball"]).length > SNAP_M:
            snaps += 1
    planted_count = sum(1 for v in planted if v)
    slide_mean = sum(slides) / len(slides) if slides else 0.0
    slide_worst = max(slides) if slides else 0.0
    return {"planted_share": planted_count / len(positions), "slide_mean": slide_mean,
            "slide_worst": slide_worst, "snaps": snaps, "planted_frames": planted_count,
            "total_frames": len(positions), "stretches": len(slides)}


def measure(clip, base_dir):
    path = base_dir + "/" + clip["file"]
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.import_scene.fbx(filepath=path, automatic_bone_orientation=False)
    arm = next(o for o in bpy.context.scene.objects if o.type == "ARMATURE")
    sc = bpy.context.scene
    fps = sc.render.fps
    f0 = max(1, int(clip["start_s"] * fps))
    f1 = int(clip["end_s"] * fps)
    unit = 0.01 if max(arm.dimensions) > 20 else 1.0
    bones = {}
    for side, names in BONES.items():
        bones[side] = {}
        for role, name in names.items():
            bones[side][role] = find_bone(arm, name)
    missing = [f"{s}.{r}" for s in bones for r, b in bones[s].items() if b is None]
    if missing:
        print(f"LOCOSLIDE_RAW {clip['name']} FAIL missing bones: {missing}", flush=True)
        return
    positions = {"left": [], "right": []}
    for fr in range(f0, f1 + 1):
        sc.frame_set(fr)
        mw = arm.matrix_world
        for side in ("left", "right"):
            ankle = to_godot((mw @ bones[side]["ankle"].head) * unit)
            ball = to_godot((mw @ bones[side]["ball"].head) * unit)
            positions[side].append({"ankle": ankle, "ball": ball})
    hip_l = find_bone(arm, BONES["left"]["hip"])
    knee_l = find_bone(arm, BONES["left"]["knee"])
    ankle_l = find_bone(arm, BONES["left"]["ankle"])
    hip_r = find_bone(arm, BONES["right"]["hip"])
    knee_r = find_bone(arm, BONES["right"]["knee"])
    ankle_r = find_bone(arm, BONES["right"]["ankle"])
    mw = arm.matrix_world
    leg_l = ((mw @ hip_l.head - mw @ knee_l.head).length + (mw @ knee_l.head - mw @ ankle_l.head).length) * unit
    leg_r = ((mw @ hip_r.head - mw @ knee_r.head).length + (mw @ knee_r.head - mw @ ankle_r.head).length) * unit
    print(f"LOCOSLIDE_RAW_LEG {clip['name']} left={leg_l:.4f} right={leg_r:.4f}", flush=True)
    for side in ("left", "right"):
        m = compute_metrics(positions[side], fps)
        print(f"LOCOSLIDE_RAW {clip['name']} {side} clip={clip['name']} frames={m['total_frames']} "
              f"planted={m['planted_frames']}/{m['total_frames']} share={m['planted_share']:.3f} "
              f"slide_mean={m['slide_mean']:.4f} slide_worst={m['slide_worst']:.4f} "
              f"snaps={m['snaps']} stretches={m['stretches']}", flush=True)


base = __file__.replace("\\", "/").rsplit("/", 1)[0]
base_dir = base.rsplit("/", 1)[0]
for clip in CLIPS:
    try:
        measure(clip, base_dir)
    except Exception as e:
        print(f"LOCOSLIDE_RAW {clip['name']} FAIL: {e}", flush=True)
