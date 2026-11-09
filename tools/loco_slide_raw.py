"""LOCOSLIDE2: the walking foot slide on the source FBX - planted creep direction and magnitude.

For each loco clip's source window (ONE cycle): world-space ankle, ball and hip every frame; PLANTED = ball
within PLANT_M of lowest AND speed < SPEED_MAX; consecutive planted frames = STRETCH. Per stretch: PATH
(summed travel), NET (first-to-last), ALONG (NET along body/hip travel, + = with the walk), BODY (hip
travel), ALONG/BODY. SNAPS: >3cm jumps inside/adjacent to planted stretches only. Loop seam separate.

Run:
    "C:/Program Files/Blender Foundation/Blender 5.2/blender.exe" -b --factory-startup --python tools/loco_slide_raw.py
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
BODY_BONE = "Hips"


def find_bone(arm, name):
    low = name.lower()
    for b in arm.pose.bones:
        if b.name.split(":")[-1].lower() == low:
            return b
    return None


def to_godot(v):
    """Blender (Z-up right-hand) -> Godot (Y-up right-hand): (x, y_blender, z_blender) -> (x, z_blender, -y_blender)."""
    return Vector((v.x, v.z, -v.y))


def stretch_metrics(foot_ball, body_pos):
    """Per-stretch: PATH, NET, ALONG (foot NET along body travel), BODY, ALONG/BODY. XZ plane."""
    n = len(foot_ball)
    if n < 2:
        return {"path": 0, "net": 0, "along": 0, "body": 0, "along_body": 0}
    path = 0.0
    for i in range(1, n):
        dx = foot_ball[i].x - foot_ball[i-1].x
        dz = foot_ball[i].z - foot_ball[i-1].z
        path += math.sqrt(dx*dx + dz*dz)
    foot_net_x = foot_ball[-1].x - foot_ball[0].x
    foot_net_z = foot_ball[-1].z - foot_ball[0].z
    net = math.sqrt(foot_net_x**2 + foot_net_z**2)
    body_dx = body_pos[-1].x - body_pos[0].x
    body_dz = body_pos[-1].z - body_pos[0].z
    body_len = math.sqrt(body_dx**2 + body_dz**2)
    if body_len > 0.001:
        along = (foot_net_x * body_dx + foot_net_z * body_dz) / body_len
        along_body = along / body_len
    else:
        along = 0.0
        along_body = 0.0
    return {"path": path, "net": net, "along": along, "body": body_len, "along_body": along_body}


def detect_planted(positions, fps):
    dt = 1.0 / fps
    min_y = min(p["ball"].y for p in positions)
    planted = []
    for i, p in enumerate(positions):
        height_ok = (p["ball"].y - min_y) < PLANT_M
        speed_ok = True
        if i > 0:
            dist = (p["ball"] - positions[i-1]["ball"]).length
            speed_ok = (dist / dt) < SPEED_MAX
        planted.append(height_ok and speed_ok)
    return planted


def find_stretches(planted):
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
    return stretches


def count_snaps(positions, planted):
    """SNAPS: >3cm jumps on frames inside or adjacent to planted stretches. Loop seam separate."""
    near = set()
    for i, v in enumerate(planted):
        if v:
            for j in (i-1, i, i+1):
                if 0 <= j < len(planted):
                    near.add(j)
    snaps = 0
    for i in range(1, len(positions)):
        if i not in near:
            continue
        dist = (positions[i]["ball"] - positions[i-1]["ball"]).length
        if dist > SNAP_M:
            snaps += 1
    loop_seam = 0.0
    if len(positions) > 1:
        loop_seam = (positions[-1]["ball"] - positions[0]["ball"]).length
    return {"snaps": snaps, "loop_seam": loop_seam}


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
    body_bone = find_bone(arm, BODY_BONE)
    missing = [f"{s}.{r}" for s in bones for r, b in bones[s].items() if b is None]
    if body_bone is None:
        missing.append(BODY_BONE)
    if missing:
        print(f"LOCOSLIDE_RAW {clip['name']} FAIL missing bones: {missing}", flush=True)
        return
    positions = {"left": [], "right": []}
    body_positions = []
    for fr in range(f0, f1 + 1):
        sc.frame_set(fr)
        mw = arm.matrix_world
        for side in ("left", "right"):
            ankle = to_godot((mw @ bones[side]["ankle"].head) * unit)
            ball = to_godot((mw @ bones[side]["ball"].head) * unit)
            positions[side].append({"ankle": ankle, "ball": ball})
        body_pos = to_godot((mw @ body_bone.head) * unit)
        body_positions.append(body_pos)
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
        leg = leg_l if side == "left" else leg_r
        planted = detect_planted(positions[side], fps)
        stretches = find_stretches(planted)
        snap_data = count_snaps(positions[side], planted)
        for si, stretch in enumerate(stretches):
            first_frame = stretch[0]
            stretch_ball = [positions[side][idx]["ball"] for idx in stretch]
            stretch_body = [body_positions[idx] for idx in stretch]
            sm = stretch_metrics(stretch_ball, stretch_body)
            clip_time = first_frame / fps
            path_leg = sm["path"] / max(leg, 1e-4)
            net_leg = sm["net"] / max(leg, 1e-4)
            print(f"LOCOSLIDE_STRETCH {clip['name']} {side} SOURCE frame={first_frame} t={clip_time:.3f} "
                  f"frames={len(stretch)} path={sm['path']:.4f} net={sm['net']:.4f} along={sm['along']:.4f} "
                  f"body={sm['body']:.4f} along_body={sm['along_body']:.3f} path_leg={path_leg:.4f} net_leg={net_leg:.4f}",
                  flush=True)
        print(f"LOCOSLIDE_SNAPS {clip['name']} {side} SOURCE snaps={snap_data['snaps']} loop_seam={snap_data['loop_seam']:.4f}",
              flush=True)


base = __file__.replace("\\", "/").rsplit("/", 1)[0]
base_dir = base.rsplit("/", 1)[0]
for clip in CLIPS:
    try:
        measure(clip, base_dir)
    except Exception as e:
        print(f"LOCOSLIDE_RAW {clip['name']} FAIL: {e}", flush=True)
