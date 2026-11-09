"""raw_hand_census.py - REARHAND4 (S415): census of every hook take across all packs.

Measures the punching hand's lowest height above the Hips during wind-up (low_h)
and the hand's height at the strike, as a share of body height, for every FBX
whose file name contains "hook" and is a punch (hit-by-hook reactions excluded).

Controls first: pro_left_jab must read 0.284 and pro_right_cross 0.273 within 0.01.

Run: blender -b --factory-startup --python tools/raw_hand_census.py --
Output: RAWCENS rows, one per take, sorted by low_h highest first.
"""
import os
import sys
import time

import bpy

TOOLS_DIR = os.path.dirname(os.path.abspath(__file__))
if TOOLS_DIR not in sys.path:
    sys.path.insert(0, TOOLS_DIR)

from raw_hand_path import (
    load_clip_data,
    analyse_clip,
    get_forward_from_jab,
    find_bone,
    converted,
)

PACKS_DIR = r"E:\FightCamp\packs"
TARGET_FPS = 30
SKIP_SECONDS = 120

PRO_JAB = os.path.join(
    PACKS_DIR, "mocaponline_punch_pro", "Boxing_01_v2", "FBX", "Box1_M3_Left_Jab.fbx"
)
PRO_CROSS = os.path.join(
    PACKS_DIR, "mocaponline_punch_pro", "Boxing_01_v2", "FBX", "Box1_M3_Right_Cross.fbx"
)

EXPECTED = {"pro_left_jab": 0.284, "pro_right_cross": 0.273}
TOL = 0.01


def discover_hooks(packs_dir):
    """Find every FBX whose name contains 'hook' and is not a hit-by-hook reaction."""
    hooks = []
    packs_norm = os.path.normpath(packs_dir)
    for root, _dirs, files in os.walk(packs_dir):
        for f in files:
            if "hook" not in f.lower() or not f.lower().endswith(".fbx"):
                continue
            if "hit_by" in f.lower():
                continue
            full = os.path.join(root, f)
            rel = os.path.relpath(full, packs_norm)
            pack = rel.split(os.sep)[0]
            hooks.append((pack, full, f))
    return hooks


def hand_total_move(data, hand_key):
    """Sum of frame-to-frame distances for one hand across all frames."""
    total = 0.0
    for i in range(1, len(data)):
        diff = data[i][hand_key] - data[i - 1][hand_key]
        total += diff.length
    return total


def detect_punch_hand(data):
    """Return 'left' or 'right' from whichever hand moves further."""
    left_move = hand_total_move(data, "lh")
    right_move = hand_total_move(data, "rh")
    return "left" if left_move > right_move else "right"


def punch_hand_from_name(filename):
    """Return 'left', 'right', or None from the file name."""
    low = filename.lower()
    has_left = "left" in low
    has_right = "right" in low
    if has_left and not has_right:
        return "left"
    if has_right and not has_left:
        return "right"
    return None


def find_pack_jab(pack_dir):
    """Find a jab FBX in the same pack directory tree."""
    for root, _dirs, files in os.walk(pack_dir):
        for f in files:
            if "jab" in f.lower() and f.lower().endswith(".fbx"):
                return os.path.join(root, f)
    return None


def get_forward_for_pack(pack_dir):
    """Derive the forward direction from a jab in the same pack (or PRO fallback)."""
    jab_path = find_pack_jab(pack_dir)
    if jab_path and os.path.exists(jab_path):
        jab_result = load_clip_data(jab_path, "jab_ref")
        if jab_result:
            return get_forward_from_jab(jab_result["data"])
    if os.path.exists(PRO_JAB):
        jab_result = load_clip_data(PRO_JAB, "jab_ref")
        if jab_result:
            return get_forward_from_jab(jab_result["data"])
    from mathutils import Vector
    return Vector((0, 0, 1))


def main():
    print("RAWCENS === control check ===", flush=True)
    jab_result = load_clip_data(PRO_JAB, "pro_left_jab")
    if not jab_result:
        print("RAWCENS STOP cannot load control jab", flush=True)
        sys.exit(1)
    forward = get_forward_from_jab(jab_result["data"])
    print(
        f"RAWCENS forward={forward.x:.4f},{forward.y:.4f},{forward.z:.4f} "
        f"body_height={jab_result['body_height']:.3f}",
        flush=True,
    )

    jab_analysis = analyse_clip(
        jab_result["data"], jab_result["body_height"],
        jab_result["arm_length"], forward, "pro_left_jab",
    )
    jab_low = jab_analysis["low_h"]
    print(f"RAWCENS control pro_left_jab low_h={jab_low:.3f} (expect 0.284)", flush=True)
    if abs(jab_low - 0.284) > TOL:
        print(f"RAWCENS STOP pro_left_jab low_h {jab_low:.3f} != 0.284", flush=True)
        sys.exit(1)

    cross_result = load_clip_data(PRO_CROSS, "pro_right_cross")
    if not cross_result:
        print("RAWCENS STOP cannot load control cross", flush=True)
        sys.exit(1)
    cross_analysis = analyse_clip(
        cross_result["data"], cross_result["body_height"],
        cross_result["arm_length"], forward, "pro_right_cross",
    )
    cross_low = cross_analysis["low_h"]
    print(f"RAWCENS control pro_right_cross low_h={cross_low:.3f} (expect 0.273)", flush=True)
    if abs(cross_low - 0.273) > TOL:
        print(f"RAWCENS STOP pro_right_cross low_h {cross_low:.3f} != 0.273", flush=True)
        sys.exit(1)

    print("RAWCENS controls pass", flush=True)
    print("", flush=True)

    hooks = discover_hooks(PACKS_DIR)
    print(f"RAWCENS found {len(hooks)} hook files (excluding hit-by-hook reactions)", flush=True)
    print("", flush=True)

    rows = []
    for pack, path, filename in hooks:
        label = f"{pack}/{filename}"
        t0 = time.time()
        try:
            clip_result = load_clip_data(path, label)
            if not clip_result:
                rows.append({
                    "pack": pack, "file": filename, "hand": "?",
                    "low_h": None, "strike_h": None, "frames": 0,
                    "fail": "load failed",
                })
                continue
            elapsed = time.time() - t0
            if elapsed > SKIP_SECONDS:
                rows.append({
                    "pack": pack, "file": filename, "hand": "?",
                    "low_h": None, "strike_h": None, "frames": 0,
                    "fail": "skipped (timeout)",
                })
                continue

            hand = punch_hand_from_name(filename)
            if hand is None:
                hand = detect_punch_hand(clip_result["data"])

            analysis = analyse_clip(
                clip_result["data"], clip_result["body_height"],
                clip_result["arm_length"], forward, label,
            )
            rows.append({
                "pack": pack, "file": filename, "hand": hand,
                "low_h": analysis["low_h"],
                "strike_h": analysis["strike_h"],
                "frames": analysis["n"],
                "fail": None,
            })
            print(
                f"RAWCENS {pack}/{filename} hand={hand} frames={analysis['n']} "
                f"low_h={analysis['low_h']:.3f} strike_h={analysis['strike_h']:.3f}",
                flush=True,
            )
        except Exception as e:
            rows.append({
                "pack": pack, "file": filename, "hand": "?",
                "low_h": None, "strike_h": None, "frames": 0,
                "fail": str(e),
            })
            print(f"RAWCENS {label} FAIL {e}", flush=True)

    rows.sort(key=lambda r: r["low_h"] if r["low_h"] is not None else -999, reverse=True)

    print("", flush=True)
    print("RAWCENS === table (sorted by low_h highest first) ===", flush=True)
    for r in rows:
        if r["fail"]:
            print(
                f"RAWCENS {r['pack']}/{r['file']} hand={r['hand']} "
                f"frames={r['frames']} FAIL {r['fail']}",
                flush=True,
            )
        else:
            print(
                f"RAWCENS {r['pack']}/{r['file']} hand={r['hand']} "
                f"low_h={r['low_h']:.3f} strike_h={r['strike_h']:.3f} "
                f"frames={r['frames']}",
                flush=True,
            )

    right_hooks = [r for r in rows if r["hand"] == "right" and r["low_h"] is not None]
    above_15 = [r for r in right_hooks if r["low_h"] > 0.15]
    above_20 = [r for r in right_hooks if r["low_h"] > 0.20]

    print("", flush=True)
    print("RAWCENS === summary ===", flush=True)
    print(
        f"RAWCENS {len(above_15)} right hooks with low_h > 0.15:",
        flush=True,
    )
    for r in above_15:
        print(f"RAWCENS   {r['pack']}/{r['file']} low_h={r['low_h']:.3f}", flush=True)
    print(
        f"RAWCENS {len(above_20)} right hooks with low_h > 0.20:",
        flush=True,
    )
    for r in above_20:
        print(f"RAWCENS   {r['pack']}/{r['file']} low_h={r['low_h']:.3f}", flush=True)


if __name__ == "__main__":
    main()
