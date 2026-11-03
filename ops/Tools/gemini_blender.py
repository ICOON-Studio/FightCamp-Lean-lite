"""gemini_blender.py - Gemini 4 Argon writes the Blender fix for one fight clip (S368, operator: "can argon work with cascadeur
and blender ?" -> "Yes, pilot the jab"; on the board's clips: "they all need work on the footing and smoothness").

Argon watches the clip's board preview and reads its measured faults (Lean tools/clip_feet_probe.gd: planted-foot slide, body
snaps, punches), then answers JSON {"script": <bpy code>, "why": <what it changes>}. The script is SAVED, never run here:
Claude reads it, then Tools/blender_clip.py runs it on the clip glTF (Lean tools/clip_gltf.gd export), clip_gltf.gd bakes it
back and clip_feet_probe.gd + gemini_judge.py measure the result. A follow-up round passes --previous and --feedback.
    python Tools/gemini_blender.py --clip <stem> --video <preview.mp4> --facts "<CLIPFEET line>" --out <fix.py>
                                   [--task "..."] [--previous <fix.py>] [--feedback "<what the last round measured>"]
"""
from __future__ import annotations

import argparse
import json
import sys
import time
from pathlib import Path

import requests

import gemini_meter
from gemini_judge import API, MODELS, _fail, api_key, upload

TASK = ("Fix the FOOTING and the SMOOTHNESS. The game plays this clip with the hips' X/Z HELD at their first frame (a move "
        "thrown in place; only the hips' height moves), so wherever the capture stepped, a planted foot now slides under the "
        "held hips. Lock each planted foot where it lands for as long as it stays planted, with leg IK, while the hips are "
        "held, then bake. Smooth any jitter in the hips, spine, neck, head and legs without slowing the punch: the punching "
        "arm's speed and its full extension must stay as they are.")

PROMPT = """You are an animation technical director writing a Blender Python script (Blender 5.2, run headless with -b) that
fixes ONE motion-capture clip for our boxing management game. The game's boxer is a MetaHuman rig imported from glTF.

THE CLIP: {clip}, {frames} frames at 30 fps (Blender frames f0..f1 = 0..{last}), one action on the armature.
Animated bones (the game keeps only these tracks; edit only these): {bones}. Bone names are our humanoid names (Hips, Spine,
Chest, UpperChest, Neck, Head, LeftUpperLeg/LeftLowerLeg/LeftFoot/LeftToes, the same Right..., the arm chain
LeftShoulder/LeftUpperArm/LeftLowerArm/LeftHand and Right...). The glTF importer may have re-oriented bone axes, so work in
world/armature space with matrices (pose_bone.matrix, arm.matrix_world, scene.frame_set) and key the result - never assume
a bone's local axes.
MEASURED (the game's own probe, hips X/Z held as the game holds them): {facts}
slide_m = metres a planted foot travels on the floor (should be ~0); body_snaps = frames where a hips/spine/neck/head/leg
bone's turn changes by more than 6 deg from the frame before (jitter); arm_snaps are the punch's real fast stops (keep them);
punches = hand extensions (keep the count and reach_m).
The attached video is the clip's board preview: one boxer on a grid floor, a camera circling her; THE PREVIEW REPLAYS THE CLIP
(each play is the clip length + a 0.4 s pause), so a second punch in it is the same punch again, not a second one.

THE TASK: {task}
{previous}
YOUR SCRIPT runs inside Blender with these names already defined: bpy, mathutils, arm (the armature object), act (its
action), fps (30), f0, f1 (first and last frame). It must: change only the animated bones listed above; never rename, add or
delete bones; never touch meshes; remove any helper objects and constraints it adds; leave the result keyed on EVERY frame
f0..f1 in `act` (bake with visual keying, e.g. bpy.ops.nla.bake(frame_start=f0, frame_end=f1, only_selected=True,
visual_keying=True, clear_constraints=True, use_current_action=True, bake_types={{'POSE'}}) with the right bones selected in
pose mode - in Blender 5.x select pose bones with pose_bone.select, Bone.select no longer exists); import nothing but bpy, mathutils, math. No file or network access.
Answer JSON only: {{"script": "<the full Python code>", "why": "<what it changes and how, 3-6 sentences>"}}."""


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--clip", required=True)
    ap.add_argument("--video", required=True)
    ap.add_argument("--facts", required=True)
    ap.add_argument("--bones", required=True, help="comma list of the clip's animated bones")
    ap.add_argument("--frames", type=int, required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--task", default=TASK)
    ap.add_argument("--previous")
    ap.add_argument("--feedback", default="")
    ap.add_argument("--model", choices=sorted(MODELS), default="argon")
    args = ap.parse_args(argv)
    prev = ""
    if args.previous:
        prev = ("\nYOUR LAST SCRIPT (below) was run; what it measured: " + args.feedback +
                "\nFix what is still wrong; keep what worked.\n---\n" + Path(args.previous).read_text(encoding="utf-8") + "\n---\n")
    prompt = PROMPT.format(clip=args.clip, frames=args.frames, last=args.frames - 1, bones=args.bones, facts=args.facts,
                           task=args.task, previous=prev)
    key = api_key()
    t0 = time.time()
    import gemini_judge   # S372 spend brake: the clip's length at 24 fps before the upload
    gemini_meter.check(args.model, gemini_meter.video_tokens(gemini_judge.clip_seconds(Path(args.video)), 24) + len(prompt) // 3,
                       f"blender fix: {args.clip}")
    f = upload(Path(args.video), key)
    body = {"contents": [{"role": "user", "parts": [
        {"fileData": {"mimeType": "video/mp4", "fileUri": f["uri"]}, "videoMetadata": {"fps": 24}}, {"text": prompt}]}],
        "generationConfig": {"responseMimeType": "application/json"}}
    try:
        r = requests.post(f"{API}/v1beta/models/{MODELS[args.model]}:generateContent", json=body, timeout=900,
                          headers={"x-goog-api-key": key})
        if not r.ok:
            _fail(r, "generateContent")
        data = r.json()
    finally:
        requests.delete(f"{API}/v1beta/{f['name']}", headers={"x-goog-api-key": key}, timeout=60)
    parts = (data.get("candidates") or [{}])[0].get("content", {}).get("parts", [])
    text = "\n".join(p.get("text", "") for p in parts if not p.get("thought")).strip()
    try:
        ans = json.loads(text)
    except ValueError:
        raise SystemExit(f"ARGON answered no JSON:\n{text[:2000]}")
    usage = data.get("usageMetadata", {})
    tin = int(usage.get("promptTokenCount", 0))
    tout = int(usage.get("candidatesTokenCount", 0)) + int(usage.get("thoughtsTokenCount", 0))
    row = gemini_meter.add(args.model, tin, tout, f"blender fix: {args.clip}")
    out = Path(args.out)
    out.write_text("# Argon (" + MODELS[args.model] + ") for " + args.clip + " - NOT RUN until Claude has read it.\n# why: " +
                   str(ans.get("why", "")).replace("\n", "\n# ") + "\n" + str(ans.get("script", "")) + "\n", encoding="utf-8")
    print(f"GEMINI_BLENDER {MODELS[args.model]} in={tin} out={tout} usd={row['usd']:.4f} {time.time() - t0:.0f}s -> {out}")
    print("WHY:", ans.get("why", ""))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
