"""Q107 gate (written by Claude, 2026-09-14). Run from the repo root (or the worktree root):
    python research/Q107_check.py

Pins Qwen's mocap chain census to things its own tool cannot agree with by construction:
- PRODUCTION PATH: the tool must mount FightWorldLive.tscn and sample through FightStagePlayer._sample_global; it may
  not load an FBX, call FightClipRetarget or read Skeleton3D.get_bone_global_pose (a previous census wrote its own
  sampler and floated every body 0.9 m),
- AN INDEPENDENT RUN: Claude ran tools/probe_clip_keys.gd through the same room on master before this task was written;
  its per-1/60 s hand steps for jab, hook_lead and react_head are embedded below and Qwen's raw hand positions must
  reproduce them within 0.12 cm a step (the probe prints one decimal),
- PHYSICS: a bone does not change length - forearm, upper arm, neck and foot segments are constant across every frame,
- every derived number (peak, onset, speed peak, chain frames, orders) is recomputed here from the raw rows with the
  task's definitions,
- the digest states each strike's chain order and each reaction's response order exactly as the JSON has them.
Never edit this file to pass.
"""
import json
import math
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
JSON_PATH = os.path.join(ROOT, "research", "Q107_mocap_chain.json")
DIGEST = os.path.join(ROOT, "research", "Q107_MOCAP_CHAIN.md")
TOOL = os.path.join(ROOT, "Godot", "tools", "measure_mocap_chain.gd")
BONES = ["LeftToes", "RightToes", "LeftFoot", "RightFoot", "Hips", "Spine", "Chest", "UpperChest", "Neck", "Head",
         "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftHand", "RightHand",
         "LeftUpperLeg", "RightUpperLeg"]
## SEND-BACK 1 (2026-09-14): the twist rows are LINES between two joints, recomputed here from the raw positions -
## the first pass read a bone's basis-Z axis, which on this rig is near vertical, and reported a jab turning the chest
## 58 deg and a cross 129 deg.
LINES = {"hip_line": ("LeftUpperLeg", "RightUpperLeg"), "shoulder_line": ("LeftUpperArm", "RightUpperArm")}
STRIKES = ["jab", "cross", "hook_lead", "hook_rear", "boxing_overhand", "strike_body"]
REACTIONS = ["react_head", "react_head#1", "react_head#2", "react_head#3", "react_body", "react_body#1", "block", "slip"]
REQUIRED = ["jab", "cross", "hook_lead", "hook_rear", "react_head", "block", "slip"]
SEGMENTS = [("LeftLowerArm", "LeftHand"), ("LeftUpperArm", "LeftLowerArm"), ("RightLowerArm", "RightHand"),
            ("RightUpperArm", "RightLowerArm"), ("Neck", "Head"), ("LeftFoot", "LeftToes"), ("RightFoot", "RightToes")]
REF = {"jab/LeftHand": [0.0, 3.3, 3.3, 5.0, 4.6, 1.5, 1.3, 5.4, 5.5, 8.1, 8.1, 6.0, 5.5, 25.9, 13.5, 2.0, 2.1, 1.7, 2.0, 2.7, 2.9, 5.9, 5.2, 7.6, 6.5, 6.1, 6.1, 5.6, 6.1, 5.0, 5.2, 2.9, 2.9, 1.2, 1.2, 1.4, 1.4, 1.6, 1.6, 1.7, 1.7, 1.7, 1.6, 1.5, 1.4, 1.2, 1.1, 0.8, 0.7, 0.3, 0.3], "jab/RightHand": [0.0, 2.2, 2.2, 4.7, 4.6, 3.9, 3.7, 1.1, 1.2, 2.3, 2.8, 2.7, 3.0, 2.0, 2.1, 1.4, 1.4, 0.7, 0.7, 0.9, 0.9, 1.4, 1.4, 1.7, 1.7, 1.3, 1.3, 1.2, 1.1, 0.5, 0.5, 0.5, 0.5, 1.1, 1.1, 1.5, 1.5, 1.7, 1.7, 1.8, 1.8, 1.7, 1.7, 1.5, 1.5, 1.2, 1.2, 0.8, 0.8, 0.3, 0.3], "hook_lead/LeftHand": [0.0, 1.3, 1.2, 3.0, 2.8, 3.4, 3.1, 2.6, 2.5, 4.5, 4.5, 5.8, 5.9, 7.7, 8.3, 9.8, 10.3, 21.0, 21.6, 28.1, 25.2, 20.1, 18.0, 8.1, 7.3, 2.4, 2.4, 3.3, 3.2, 2.6, 2.6, 2.1, 2.1, 2.4, 2.4, 2.7, 2.7, 2.9, 2.9, 2.7, 2.7, 2.4, 2.5, 2.4, 2.5, 2.3, 2.4, 2.3, 2.4, 2.2, 2.3], "hook_lead/RightHand": [0.0, 0.9, 0.9, 2.1, 2.0, 2.4, 2.2, 1.7, 1.6, 2.1, 2.1, 2.3, 2.3, 2.7, 2.7, 2.7, 2.6, 2.8, 2.3, 3.7, 3.1, 2.1, 2.1, 1.7, 1.8, 1.3, 1.4, 1.4, 1.3, 1.3, 1.3, 1.1, 1.2, 1.0, 1.0, 0.9, 0.9, 1.0, 1.0, 0.8, 0.9, 0.5, 0.6, 0.6, 0.7, 1.0, 1.0, 1.1, 1.2, 1.3, 1.3], "react_head/LeftHand": [0.0, 2.2, 2.0, 2.9, 2.9, 3.5, 3.6, 2.7, 2.8, 3.1, 3.3, 6.0, 5.8, 4.3, 3.8, 2.5, 1.9, 0.6, 0.7, 2.4, 2.5, 3.0, 3.1, 3.4, 3.4, 3.7, 3.3, 3.8, 3.6, 3.1, 2.8, 2.2, 1.7, 0.9, 0.5], "react_head/RightHand": [0.0, 2.1, 2.1, 3.3, 3.6, 4.2, 4.2, 2.5, 2.4, 4.5, 5.1, 3.7, 3.5, 1.4, 1.2, 0.5, 0.4, 0.9, 1.4, 3.4, 3.6, 4.3, 4.2, 3.9, 3.7, 3.4, 2.7, 1.4, 1.3, 1.5, 1.6, 1.8, 1.5, 1.0, 0.6]}
REF_LAST_K = {"jab": 49, "hook_lead": 50, "react_head": 33}
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def close(a, b, tol):
    if a is None or b is None:
        return a is None and b is None
    return abs(float(a) - float(b)) <= tol


def dist(a, b):
    return math.sqrt(sum((a[i] - b[i]) ** 2 for i in range(3)))


def times_for(length):
    out = []
    k = 0
    while k / 60.0 < length - 1e-6:
        out.append(k / 60.0)
        k += 1
    out.append(length)
    return out


for path in (JSON_PATH, DIGEST, TOOL):
    if not os.path.exists(path):
        fail("missing %s" % path)
if fails:
    print("Q107_CHECK FAIL %d" % len(fails))
    sys.exit(1)

tool = open(TOOL, encoding="utf-8").read()
if "FightWorldLive.tscn" not in tool or "_sample_global" not in tool:
    fail("the tool must mount res://scenes/FightWorldLive.tscn and sample through _sample_global")
for banned in (".FBX", ".fbx", "FightClipRetarget", "get_bone_global_pose"):
    if banned in tool:
        fail("the tool contains %r - production only, never a substitute path" % banned)

try:
    data = json.load(open(JSON_PATH, encoding="utf-8"))
except ValueError as err:
    fail("Q107_mocap_chain.json is not valid JSON: %s" % err)
    print("Q107_CHECK FAIL %d" % len(fails))
    sys.exit(1)
if float(data.get("fps", 0)) != 60.0:
    fail("fps must be 60")
population = str(data.get("population", ""))
if "f01" not in population or "94301" not in population:
    fail("population must name fighter f01 and seed 94301: %r" % population)
takes = data.get("takes", {})
missing = data.get("missing", [])
for name in REQUIRED:
    if name not in takes:
        fail("required take %s is not in the JSON (it is bound in FightClipBinding)" % name)
for name in STRIKES + REACTIONS:
    if name not in takes and name not in missing:
        fail("take %s is neither measured nor listed under missing" % name)


def derive(raw, times):
    p0 = raw[0]
    disp = [dist(p, p0) for p in raw]
    peak = max(disp)
    t_peak = times[disp.index(peak)]
    onset = None
    if peak >= 0.02:
        for k, d in enumerate(disp):
            if d >= 0.2 * peak:
                onset = times[k]
                break
    best = -1.0
    speed_t = None
    for k in range(1, len(raw) - 1):
        s = dist(raw[k + 1], raw[k - 1]) / (times[k + 1] - times[k - 1])
        if s > best + 1e-12:
            best = s
            speed_t = times[k]
    return peak, t_peak, onset, speed_t


def frames_rel(t, zero):
    return None if t is None else int(round((t - zero) * 60.0))


def sort_order(entries, field="onset_frames"):
    indexed = list(enumerate(entries))
    indexed.sort(key=lambda it: (it[1][field] is None, it[1][field] if it[1][field] is not None else 0, it[0]))
    return [e["part"] for _, e in indexed]


def wrap(deg):
    while deg <= -180.0:
        deg += 360.0
    while deg > 180.0:
        deg -= 360.0
    return deg


def line_yaw(raw, a, b):
    """Signed degrees about +Y from the a->b line's XZ direction at t0 to its direction at each frame."""
    out = []
    x0 = raw[b][0][0] - raw[a][0][0]
    z0 = raw[b][0][2] - raw[a][0][2]
    for k in range(len(raw[a])):
        x = raw[b][k][0] - raw[a][k][0]
        z = raw[b][k][2] - raw[a][k][2]
        cross_y = z0 * x - x0 * z
        dot = x0 * x + z0 * z
        out.append(wrap(math.degrees(math.atan2(cross_y, dot))))
    return out


def yaw_derive(per, times):
    peak = max(abs(v) for v in per)
    onset = None
    speed_t = None
    if peak >= 3.0:
        for k, v in enumerate(per):
            if abs(v) >= 0.2 * peak:
                onset = times[k]
                break
        best = -1.0
        for k in range(1, len(per) - 1):
            s = abs(wrap(per[k + 1] - per[k - 1])) / (times[k + 1] - times[k - 1])
            if s > best + 1e-9:
                best = s
                speed_t = times[k]
    return peak, onset, speed_t


orders_for_digest = {}
for name, take in sorted(takes.items()):
    length = float(take.get("length_s", -1))
    times = take.get("times", [])
    want_times = times_for(length)
    if len(times) != len(want_times) or any(abs(a - b) > 1e-5 for a, b in zip(times, want_times)):
        fail("%s: times do not follow the k/60-then-length rule (%d v %d)" % (name, len(times), len(want_times)))
        continue
    raw = take.get("raw", {})
    bones = take.get("bones", {})
    derived = {}
    for bone in BONES:
        rows = raw.get(bone)
        if not isinstance(rows, list) or len(rows) != len(times):
            fail("%s: raw %s missing or wrong length" % (name, bone))
            continue
        peak, t_peak, onset, speed_t = derive(rows, times)
        derived[bone] = (peak, t_peak, onset, speed_t)
        got = bones.get(bone, {})
        if not close(got.get("peak_disp"), peak, 1e-4):
            fail("%s %s peak_disp %r, raw gives %.6f" % (name, bone, got.get("peak_disp"), peak))
        if not close(got.get("t_peak"), t_peak, 1e-4):
            fail("%s %s t_peak %r, raw gives %.4f" % (name, bone, got.get("t_peak"), t_peak))
        if not close(got.get("onset_t"), onset, 1e-4):
            fail("%s %s onset_t %r, raw gives %r" % (name, bone, got.get("onset_t"), onset))
        if not close(got.get("speed_peak_t"), speed_t, 1e-4):
            fail("%s %s speed_peak_t %r, raw gives %r" % (name, bone, got.get("speed_peak_t"), speed_t))
    for parent, child in SEGMENTS:
        if parent in raw and child in raw and len(raw[parent]) == len(times) and len(raw[child]) == len(times):
            lengths = [dist(a, b) for a, b in zip(raw[parent], raw[child])]
            if max(lengths) - min(lengths) > 1e-3:
                fail("%s: segment %s-%s changes length by %.4f - not one skeleton's pose" % (name, parent, child, max(lengths) - min(lengths)))
    yaw = take.get("yaw", {})
    yaw_onset = {}
    yaw_speed = {}
    for line_name, (ja, jb) in LINES.items():
        row = yaw.get(line_name, {})
        per = row.get("per_frame", [])
        if ja not in raw or jb not in raw or len(raw[ja]) != len(times) or len(raw[jb]) != len(times):
            fail("%s: %s needs raw %s and %s" % (name, line_name, ja, jb))
            continue
        want_per = line_yaw(raw, ja, jb)
        if len(per) != len(times):
            fail("%s: yaw %s per_frame has %d values for %d times" % (name, line_name, len(per), len(times)))
            continue
        worst = max(abs(wrap(g - w)) for g, w in zip(per, want_per))
        if worst > 0.05:
            fail("%s: yaw %s per_frame differs from the %s->%s line in raw by up to %.2f deg" % (name, line_name, ja, jb, worst))
        peak_yaw, want_onset, want_speed = yaw_derive(want_per, times)
        if not close(row.get("peak_yaw"), peak_yaw, 0.05):
            fail("%s: yaw %s peak_yaw %r, raw gives %.2f" % (name, line_name, row.get("peak_yaw"), peak_yaw))
        if not close(row.get("yaw_onset_t"), want_onset, 1.0 / 60.0 + 1e-4):
            fail("%s: yaw %s yaw_onset_t %r, raw gives %r" % (name, line_name, row.get("yaw_onset_t"), want_onset))
        if not close(row.get("yaw_speed_peak_t"), want_speed, 1.0 / 60.0 + 1e-4):
            fail("%s: yaw %s yaw_speed_peak_t %r, raw gives %r" % (name, line_name, row.get("yaw_speed_peak_t"), want_speed))
        yaw_onset[line_name] = row.get("yaw_onset_t")
        yaw_speed[line_name] = row.get("yaw_speed_peak_t")
    base = name.split("#")[0]
    for hand in ("LeftHand", "RightHand"):
        key = "%s/%s" % (name, hand)
        if key in REF and hand in raw and len(raw[hand]) == len(times):
            worst = 0.0
            for k in range(1, REF_LAST_K[name] + 1):
                step = dist(raw[hand][k], raw[hand][k - 1]) * 100.0
                worst = max(worst, abs(step - REF[key][k]))
            if worst > 0.12:
                fail("%s %s: steps differ from the production probe by up to %.2f cm - not the room's take on f01" % (name, hand, worst))
    if base in STRIKES and name in STRIKES:
        contact = take.get("contact_s")
        if not isinstance(contact, (int, float)) or contact < 0 or contact > length + 1e-6:
            fail("%s: contact_s %r is not inside the take" % (name, contact))
            continue
        if "LeftHand" not in derived or "RightHand" not in derived:
            continue
        hand = "LeftHand" if derived["LeftHand"][0] >= derived["RightHand"][0] else "RightHand"
        if take.get("strike_hand") != hand:
            fail("%s: strike_hand %r, raw says %s" % (name, take.get("strike_hand"), hand))
        side = "Left" if hand == "LeftHand" else "Right"
        foot = "RightFoot" if side == "Left" else "LeftFoot"
        parts = [foot, "Hips", "hip_line_yaw", "shoulder_line_yaw", side + "UpperArm", side + "LowerArm", side + "Hand"]
        want = []
        for part in parts:
            if part.endswith("_yaw"):
                want.append({"part": part, "onset_frames": frames_rel(yaw_onset.get(part[:-4]), contact),
                             "speed_peak_frames": frames_rel(yaw_speed.get(part[:-4]), contact)})
            else:
                d = derived.get(part)
                want.append({"part": part, "onset_frames": frames_rel(d[2], contact) if d else None,
                             "speed_peak_frames": frames_rel(d[3], contact) if d else None})
        chain = take.get("chain", [])
        if [c.get("part") for c in chain] != parts:
            fail("%s: chain parts %r, want %r" % (name, [c.get("part") for c in chain], parts))
        else:
            for got, exp in zip(chain, want):
                for field in ("onset_frames", "speed_peak_frames"):
                    g = got.get(field)
                    e = exp[field]
                    if (g is None) != (e is None) or (g is not None and abs(int(g) - int(e)) > (1 if got["part"].endswith("_yaw") else 0)):
                        fail("%s: chain %s %s = %r, raw gives %r" % (name, got["part"], field, g, e))
            order = sort_order([{"part": c["part"], "onset_frames": c.get("onset_frames")} for c in chain])
            if take.get("chain_order") != order:
                fail("%s: chain_order %r, its own chain sorts to %r" % (name, take.get("chain_order"), order))
            speed_order = sort_order([{"part": c["part"], "speed_peak_frames": c.get("speed_peak_frames")} for c in chain], "speed_peak_frames")
            if take.get("chain_order_by_speed_peak") != speed_order:
                fail("%s: chain_order_by_speed_peak %r, its own chain sorts to %r" % (name, take.get("chain_order_by_speed_peak"), speed_order))
            orders_for_digest[name] = order
            orders_for_digest[name + " (speed peaks)"] = speed_order
    if name in REACTIONS:
        parts = ["Head", "Neck", "UpperChest", "Hips", "LeftFoot", "RightFoot"]
        response = take.get("response", [])
        if [c.get("part") for c in response] != parts:
            fail("%s: response parts %r, want %r" % (name, [c.get("part") for c in response], parts))
        else:
            for got in response:
                d = derived.get(got["part"])
                if d is None:
                    continue
                for field, t in (("onset_frames", d[2]), ("speed_peak_frames", d[3])):
                    e = frames_rel(t, 0.0)
                    g = got.get(field)
                    if (g is None) != (e is None) or (g is not None and int(g) != int(e)):
                        fail("%s: response %s %s = %r, raw gives %r" % (name, got["part"], field, g, e))
            order = sort_order([{"part": c["part"], "onset_frames": c.get("onset_frames")} for c in response])
            if take.get("response_order") != order:
                fail("%s: response_order %r, its own response sorts to %r" % (name, take.get("response_order"), order))
            speed_order = sort_order([{"part": c["part"], "speed_peak_frames": c.get("speed_peak_frames")} for c in response], "speed_peak_frames")
            if take.get("response_order_by_speed_peak") != speed_order:
                fail("%s: response_order_by_speed_peak %r, its own response sorts to %r" % (name, take.get("response_order_by_speed_peak"), speed_order))
            orders_for_digest[name] = order
            orders_for_digest[name + " (speed peaks)"] = speed_order

text = open(DIGEST, encoding="utf-8").read()
lines = text.splitlines()
if not lines or not lines[0].startswith("## DECISIONS"):
    fail("digest must open with '## DECISIONS'")
if len(lines) > 60:
    fail("digest is %d lines, 60 at most" % len(lines))
for heading in ("## Table", "## Method", "## Population"):
    if heading not in text:
        fail("digest has no '%s' section" % heading)
if population and population not in text:
    fail("digest does not quote the JSON's population string")
for name, order in sorted(orders_for_digest.items()):
    if " -> ".join(order) not in text:
        fail("digest never states %s's order as the JSON has it: %s" % (name, " -> ".join(order)))

if fails:
    print("Q107_CHECK FAIL %d" % len(fails))
    sys.exit(1)
print("Q107_CHECK PASS takes=%d" % len(takes))
