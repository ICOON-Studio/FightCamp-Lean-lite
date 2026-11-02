"""U108 independent probe (Claude, 2026-09-14). Run by U108_check.py - never by the census tool.

usage: blender --background --factory-startup --python research/U108_probe_blender.py -- <request.json> <out.json>

request: {"clips": [{"file": <abs path>, "joints": {role: name}, "indices": [sample index, ...]}, ...]}
For each clip: a FRESH factory scene, import the FBX, then for every requested 30 Hz sample index read each role's world
position (metres, Blender Z up), plus the action's own keyframe values, from which keys_digest and keys_vary follow.
A role name is looked up as a pose bone of the first armature, else as an object (an EMPTY, or the armature object itself
when the FBX root bone became the object).
"""
import hashlib
import json
import sys

import bpy

args = sys.argv[sys.argv.index("--") + 1:]
req = json.load(open(args[0], encoding="utf-8"))
out = {"clips": []}


def fcurves_of(action):
    curves = []
    if hasattr(action, "layers"):
        for layer in action.layers:
            for strip in layer.strips:
                for bag in getattr(strip, "channelbags", []):
                    curves.extend(bag.fcurves)
    if not curves and hasattr(action, "fcurves"):
        curves.extend(action.fcurves)
    return curves


for c in req["clips"]:
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.import_scene.fbx(filepath=c["file"])
    scene = bpy.context.scene
    actions = sorted(bpy.data.actions, key=lambda a: a.name)
    row = {"file": c["file"], "n_actions": len(actions)}
    if not actions:
        out["clips"].append(row)
        continue
    f0 = min(a.frame_range[0] for a in actions)
    f1 = max(a.frame_range[1] for a in actions)
    fps = scene.render.fps / scene.render.fps_base
    row.update({"frame_start": f0, "frame_end": f1, "fps": fps, "length_s": (f1 - f0) / fps})
    h = hashlib.sha1()
    vary = False
    for a in actions:
        for fc in sorted(fcurves_of(a), key=lambda f: (f.data_path, f.array_index)):
            vals = [kp.co[1] for kp in fc.keyframe_points]
            if vals and max(vals) - min(vals) > 1e-4:
                vary = True
            h.update(("%s|%s|%d|" % (a.name.split("|")[0], fc.data_path, fc.array_index)).encode())
            h.update(",".join("%.5f" % v for v in vals).encode())
    row["keys_digest"] = h.hexdigest()
    row["keys_vary"] = vary
    arm = next((o for o in scene.objects if o.type == "ARMATURE"), None)
    pos = {}
    for idx in c["indices"]:
        frame = f0 + (idx / 30.0) * fps
        whole = int(frame // 1)
        scene.frame_set(whole, subframe=frame - whole)
        roles = {}
        for role, name in c["joints"].items():
            if arm is not None and name in arm.pose.bones:
                p = arm.matrix_world @ arm.pose.bones[name].head
            elif name in scene.objects:
                p = scene.objects[name].matrix_world.translation
            else:
                p = None
            roles[role] = None if p is None else [float(p[0]), float(p[1]), float(p[2])]
        pos[str(idx)] = roles
    row["positions"] = pos
    out["clips"].append(row)

json.dump(out, open(args[1], "w", encoding="utf-8"), indent=1)
print("U108_PROBE wrote %d clips" % len(out["clips"]))
