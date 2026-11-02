"""blender_clip.py - Blender's side of the clip round trip (S368, operator: "can argon work with cascadeur and blender ?" ->
"Yes, pilot the jab"; on the board's clips: "they all need work on the footing and smoothness").

Runs INSIDE Blender (headless): imports a clip glTF written by Lean tools/clip_gltf.gd (the game's boxer + one action),
runs an optional fix script against it, and exports glTF again for clip_gltf.gd to bake back. With no script it is the
identity round trip (the check that Blender itself changes nothing).
    blender -b --factory-startup --python Tools/blender_clip.py -- in=<clip.glb> out=<fixed.glb> [script=<fix.py>]
The fix script runs with these names: bpy, mathutils, arm (the armature object), act (its action), fps, f0, f1 (first
and last frame). It edits `act` (keyframes, curves) or arm.pose and keyframes the result; it must not rename bones, add or
remove bones, or touch the meshes. Argon writes these scripts (Tools/gemini_blender.py); Claude reads each one before it runs.
"""
import sys

import bpy
import mathutils


def _args() -> dict:
    out = {}
    for a in sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []:
        if "=" in a:
            k, v = a.split("=", 1)
            out[k] = v
    return out


def main() -> int:
    a = _args()
    for o in list(bpy.data.objects):   # --factory-startup's cube, camera and light
        bpy.data.objects.remove(o, do_unlink=True)
    # The baked clips are 30 fps: at Blender's default 24 every key lands between frames and the export resamples it
    # (7 deg off on a jab's forearm in the first round trip).
    bpy.context.scene.render.fps = int(a.get("fps", 30))
    bpy.context.scene.render.fps_base = 1.0
    bpy.ops.import_scene.gltf(filepath=a["in"])
    arms = [o for o in bpy.context.scene.objects if o.type == "ARMATURE"]
    if not arms or not arms[0].animation_data or not arms[0].animation_data.action:
        print("BLENDER_CLIP FAILED: no armature with an action in", a["in"])
        return 1
    arm = arms[0]
    act = arm.animation_data.action
    f0, f1 = (int(round(x)) for x in act.frame_range)
    scene = bpy.context.scene
    scene.frame_start, scene.frame_end = f0, f1
    fps = scene.render.fps
    print("BLENDER_CLIP in %s: armature %s, %d bones, action %s, frames %d-%d at %d fps" % (
        a["in"], arm.name, len(arm.data.bones), act.name, f0, f1, fps))
    if a.get("script"):
        # A fix bakes in pose mode (bpy.ops.nla.bake): the armature must be the active, selected object.
        for o in bpy.context.scene.objects:
            o.select_set(o == arm)
        bpy.context.view_layer.objects.active = arm
        code = open(a["script"], encoding="utf-8").read()
        try:
            exec(compile(code, a["script"], "exec"), {"bpy": bpy, "mathutils": mathutils, "arm": arm, "act": act,
                                                      "fps": fps, "f0": f0, "f1": f1, "__name__": "fix"})
        except Exception:
            import traceback
            traceback.print_exc()
            print("BLENDER_CLIP FAILED in", a["script"])
            return 1
        print("BLENDER_CLIP ran", a["script"])
    bpy.ops.export_scene.gltf(filepath=a["out"], export_format="GLB", export_animations=True,
                              export_animation_mode="ACTIONS", export_force_sampling=True, export_frame_step=1)
    print("BLENDER_CLIP out", a["out"])
    return 0


if __name__ == "__main__":
    rc = main()
    sys.stdout.flush()
    if rc:
        sys.exit(rc)
