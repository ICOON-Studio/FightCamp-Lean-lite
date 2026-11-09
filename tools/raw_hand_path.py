"""raw_hand_path.py - REARHAND2 (S414): measure hand positions in source FBX files.

For each source take, per frame at 30 fps, outputs the same numbers as hand_path_probe.gd:
  - hand to Head distance
  - hand height against Hips (hand.y - hips.y)
  - hand against Hips on the actor's forward axis (dot product with forward)
Body height is the Head joint above the foot joint in the rest pose.

Forward direction is derived from the jab animation (same as hand_path_probe.gd):
the direction the left hand moves from frame 0 to full extension, projected to the ground.

Run: blender -b --factory-startup --python tools/raw_hand_path.py --
Output: RAWHAND <clip> frames=<n> low_h=<v> low_ahead=<v> strike_f=<f> strike_h=<v>
"""
import json
import math
import os
import sys

import bpy
from mathutils import Vector

SOURCE_DIR = r"E:\FightCamp\packs\mocaponline_punch_pro\Boxing_01_v2\FBX"
TARGET_FPS = 30

CLIP_MAP = {
    "pro_right_hook": "Box1_M3_Right_Hook.fbx",
    "pro_right_hook_hard": "Box1_M3_Right_Hook_Hard.fbx",
    "pro_right_hook_ft": "Box1_M3_Right_Hook_FT.fbx",
    "pro_right_hook_hard_ft": "Box1_M3_Right_Hook_Hard_FT.fbx",
    "pro_right_hook_miss": "Box1_M3_Right_Hook_Miss.fbx",
    "pro_right_hook_hurt": "Box1_M3_Right_Hook_Hurt.fbx",
    "pro_right_hook_hurt_ft": "Box1_M3_Right_Hook_Hurt_FT.fbx",
    "pro_right_hook_special": "Box1_M3_Right_Hook_Special.fbx",
    "pro_left_jab": "Box1_M3_Left_Jab.fbx",
    "pro_right_cross": "Box1_M3_Right_Cross.fbx",
    "pro_left_hook": "Box1_M3_Left_Hook.fbx",
    "pro_left_hook_hard": "Box1_M3_Left_Hook_ Hard.fbx",
    "pro_left_hook_hard_ft": "Box1_M3_Left_Hook_ Hard_FT.fbx",
    "pro_left_hook_miss": "Box1_M3_Left_Hook_ Miss.fbx",
    "pro_left_hook_ft": "Box1_M3_Left_Hook_FT.fbx",
    "pro_left_hook_hurt": "Box1_M3_Left_Hook_Hurt.fbx",
    "pro_left_hook_hurt_ft": "Box1_M3_Left_Hook_Hurt_FT.fbx",
    "pro_left_hook_special": "Box1_M3_Left_Hook_Special.fbx",
    "pro_left_hook_v2": "Box1_M3_Left_Hook_V2.fbx",
}

RIGHT_HOOKS = [
    "pro_right_hook", "pro_right_hook_hard", "pro_right_hook_ft", "pro_right_hook_hard_ft",
    "pro_right_hook_miss", "pro_right_hook_hurt", "pro_right_hook_hurt_ft", "pro_right_hook_special"
]
CONTROLS = ["pro_left_jab", "pro_right_cross", "pro_left_hook"]


def converted(v):
    return Vector((v.x, v.z, -v.y))


def find_bone(arm, *names):
    low = {b.name.split(":")[-1].lower(): b.name for b in arm.pose.bones}
    for n in names:
        if n.lower() in low:
            return arm.pose.bones[low[n.lower()]]
    return None


def load_clip_data(path, clip_name):
    """Load a clip and return (arm, data, body_height, src_fps, f0, f1)."""
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.import_scene.fbx(filepath=path, automatic_bone_orientation=False)
    arm = next((o for o in bpy.context.scene.objects if o.type == "ARMATURE"), None)
    if not arm:
        print(f"RAWHAND {clip_name} FAIL no armature", flush=True)
        return None
    act = arm.animation_data.action if arm.animation_data else None
    if not act:
        print(f"RAWHAND {clip_name} FAIL no animation", flush=True)
        return None
    f0, f1 = int(act.frame_range[0]), int(act.frame_range[1])
    src_fps = bpy.context.scene.render.fps
    head = find_bone(arm, "Head")
    left_hand = find_bone(arm, "LeftHand")
    right_hand = find_bone(arm, "RightHand")
    hips = find_bone(arm, "Hips")
    left_foot = find_bone(arm, "LeftFoot", "LeftAnkle")
    if not all([head, left_hand, right_hand, hips, left_foot]):
        print(f"RAWHAND {clip_name} FAIL missing bones", flush=True)
        return None
    unit = 0.01 if max(arm.dimensions) > 20 else 1.0
    bpy.context.scene.frame_set(f0)
    mw = arm.matrix_world
    head_rest = converted(mw @ head.head) * unit
    foot_rest = converted(mw @ left_foot.head) * unit
    body_height = (head_rest - foot_rest).length
    if body_height < 1e-5:
        print(f"RAWHAND {clip_name} FAIL body_height too small", flush=True)
        return None
    n_frames = int((f1 - f0) * TARGET_FPS / src_fps) + 1
    data = []
    for i in range(n_frames):
        fr = f0 + i * src_fps / TARGET_FPS
        bpy.context.scene.frame_set(int(math.floor(fr)), subframe=fr - math.floor(fr))
        mw = arm.matrix_world
        head_pos = converted(mw @ head.head) * unit
        lh_pos = converted(mw @ left_hand.head) * unit
        rh_pos = converted(mw @ right_hand.head) * unit
        hips_pos = converted(mw @ hips.head) * unit
        data.append({"head": head_pos, "lh": lh_pos, "rh": rh_pos, "hips": hips_pos})
    if len(data) < 2:
        print(f"RAWHAND {clip_name} FAIL not enough frames: {len(data)}", flush=True)
        return None
    return {"data": data, "body_height": body_height}


def get_forward_from_jab(jab_data):
    """Derive forward from the jab: direction the left hand moves from frame 0 to full extension."""
    hand_key = "lh"
    chin_0 = (jab_data[0][hand_key] - jab_data[0]["head"]).length
    ext_f = 0
    ext_chin = chin_0
    for f, d in enumerate(jab_data):
        chin = (d[hand_key] - d["head"]).length
        if chin > ext_chin:
            ext_chin = chin
            ext_f = f
    jab_line = jab_data[ext_f][hand_key] - jab_data[0][hand_key]
    forward = Vector((jab_line.x, 0.0, jab_line.z)).normalized()
    if forward.length < 1e-5:
        forward = Vector((0, 0, 1))
    return forward


def analyse_clip(data, body_height, forward, clip_name):
    """Analyse a clip's hand path data."""
    punch_left = clip_name.startswith("pro_left_")
    hand_key = "lh" if punch_left else "rh"
    chin_0 = (data[0][hand_key] - data[0]["head"]).length
    ext_f = 0
    ext_chin = chin_0
    for f, d in enumerate(data):
        chin = (d[hand_key] - d["head"]).length
        if chin > ext_chin:
            ext_chin = chin
            ext_f = f
    h0 = (data[0][hand_key] - data[0]["hips"]).y
    low_h = h0
    low_h_f = 0
    low_ahead = float("inf")
    low_ahead_f = 0
    for f in range(ext_f + 1):
        d = data[f]
        hand = d[hand_key]
        h = (hand - d["hips"]).y
        ahead = (hand - d["hips"]).dot(forward)
        if h < low_h:
            low_h = h
            low_h_f = f
        if ahead < low_ahead:
            low_ahead = ahead
            low_ahead_f = f
    strike_f = low_h_f
    strike_h = low_h
    strike_ahead = low_ahead
    strike_chin = (data[low_h_f][hand_key] - data[low_h_f]["head"]).length
    is_hook = "hook" in clip_name
    if is_hook and low_h_f < len(data) - 1:
        best_speed = float("-inf")
        for f in range(low_h_f + 1, len(data)):
            hand_curr = data[f][hand_key]
            hand_prev = data[f - 1][hand_key]
            speed = (hand_curr - hand_prev).dot(forward)
            if speed > best_speed:
                best_speed = speed
                strike_f = f
                strike_h = (data[f][hand_key] - data[f]["hips"]).y
                strike_ahead = (data[f][hand_key] - data[f]["hips"]).dot(forward)
                strike_chin = (data[f][hand_key] - data[f]["head"]).length
    return {
        "clip": clip_name,
        "n": len(data),
        "body_height": body_height,
        "forward": (forward.x, forward.y, forward.z),
        "low_h": low_h / body_height,
        "low_h_f": low_h_f,
        "low_ahead": low_ahead / body_height,
        "low_ahead_f": low_ahead_f,
        "strike_f": strike_f,
        "strike_h": strike_h / body_height,
        "strike_ahead": strike_ahead / body_height,
        "strike_chin": strike_chin / body_height,
        "frames_low_to_strike": strike_f - low_h_f
    }


def main():
    jab_path = os.path.join(SOURCE_DIR, CLIP_MAP["pro_left_jab"])
    jab_result = load_clip_data(jab_path, "pro_left_jab")
    if not jab_result:
        print("RAWHAND FAIL could not load jab", flush=True)
        return
    forward = get_forward_from_jab(jab_result["data"])
    print(f"RAWHAND forward={forward.x:.4f},{forward.y:.4f},{forward.z:.4f} body_height={jab_result['body_height']:.3f}", flush=True)
    clips_to_measure = CONTROLS + RIGHT_HOOKS
    args = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []
    if args:
        clips_to_measure = [a for a in args if a in CLIP_MAP]
    results = {}
    for clip in clips_to_measure:
        if clip not in CLIP_MAP:
            continue
        fbx_name = CLIP_MAP[clip]
        path = os.path.join(SOURCE_DIR, fbx_name)
        if not os.path.exists(path):
            print(f"RAWHAND {clip} FAIL file not found: {path}", flush=True)
            continue
        try:
            if clip == "pro_left_jab":
                clip_result = jab_result
            else:
                clip_result = load_clip_data(path, clip)
            if not clip_result:
                continue
            analysis = analyse_clip(clip_result["data"], clip_result["body_height"], forward, clip)
            results[clip] = analysis
            r = analysis
            print(f"RAWHAND {clip} frames={r['n']} low_h={r['low_h']:.3f} f={r['low_h_f']} "
                  f"low_ahead={r['low_ahead']:.3f} f={r['low_ahead_f']} strike_f={r['strike_f']} "
                  f"strike_h={r['strike_h']:.3f} strike_ahead={r['strike_ahead']:.3f} "
                  f"strike_chin={r['strike_chin']:.3f} gap={r['frames_low_to_strike']}", flush=True)
        except Exception as e:
            print(f"RAWHAND {clip} FAIL {e}", flush=True)
    out_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "raw_hand_path_data.json")
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(results, f, indent=2)
    print(f"RAWHAND wrote {len(results)} clips -> {out_path}", flush=True)


if __name__ == "__main__":
    main()
