"""Q109 gate (Claude, 2026-09-14). Prints `Q109_CHECK PASS` or FAIL lines. Run from the repo (or worktree) root.

Independent of the subject: every posture value is RECOMPUTED here from the raw MediaPipe tracks (`img[frame, slot]`)
and, for the authored pairs, straight from the pair file's joints - never from the series the tool wrote. The old
footage numbers are pinned to the committed master tables (identity, windows and T must not move).
"""
import json
import math
import os
import re
import subprocess
import sys

import numpy as np

F = "C:/Users/user/AppData/Local/Temp/FightCamp-footage"
POOLED = "research/S4A_PAIRS/footage_two_men.json"
BATCH3 = "research/S4A_PAIRS/footage_batch3_two_men.json"
DIGEST = "research/Q109_FOOTAGE_POSTURE.md"
PAIRS = ["BOX_JAB_HEAD_LAND_F01_F09", "BOX_JAB_HEAD_LAND_F09_F01"]
NEW_KEYS = ["thrower_hips_dips_05T", "thrower_hips_dips_10T", "thrower_pitch_onset_deg", "thrower_pitch_peak_deg",
            "thrower_pitch_max_deg", "thrower_pitch_forward_change_deg", "thrower_lead_knee_onset_deg",
            "thrower_lead_knee_min_deg", "thrower_lead_knee_bend_deg", "thrower_rear_knee_onset_deg",
            "thrower_rear_knee_min_deg", "thrower_rear_knee_bend_deg", "receiver_pitch_onset_deg",
            "receiver_pitch_back_change_deg", "receiver_hips_dips_05T"]
POSTURE_OF = {"thrower_hips_dips_05T": "hips_dips_05T", "thrower_hips_dips_10T": "hips_dips_10T",
              "thrower_pitch_onset_deg": "pitch_onset_deg", "thrower_pitch_peak_deg": "pitch_peak_deg",
              "thrower_pitch_max_deg": "pitch_max_deg", "thrower_pitch_forward_change_deg": "pitch_forward_change_deg",
              "thrower_lead_knee_onset_deg": "lead_knee_onset_deg", "thrower_lead_knee_min_deg": "lead_knee_min_deg",
              "thrower_lead_knee_bend_deg": "lead_knee_bend_deg", "thrower_rear_knee_onset_deg": "rear_knee_onset_deg",
              "thrower_rear_knee_min_deg": "rear_knee_min_deg", "thrower_rear_knee_bend_deg": "rear_knee_bend_deg",
              "receiver_pitch_onset_deg": "receiver_pitch_onset_deg",
              "receiver_pitch_back_change_deg": "receiver_pitch_back_change_deg",
              "receiver_hips_dips_05T": "receiver_hips_dips_05T"}
DECISION_KEYS = ["thrower_pitch_onset_deg", "thrower_pitch_forward_change_deg", "thrower_lead_knee_bend_deg",
                 "thrower_rear_knee_bend_deg", "thrower_hips_dips_05T_counts"]
NOSE, L_SH, R_SH, L_HIP, R_HIP, L_KNEE, R_KNEE, L_ANK, R_ANK = 0, 11, 12, 23, 24, 25, 26, 27, 28
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def load(path):
    return json.load(open(path, encoding="utf-8"))


def master(path):
    out = subprocess.run(["git", "show", "origin/master:" + path], capture_output=True, text=True, encoding="utf-8")
    return json.loads(out.stdout) if out.returncode == 0 else None


def smooth(a, k):
    a = np.asarray(a, dtype=float)
    if len(a) < k:
        return a
    return np.convolve(np.pad(a, (k // 2, k // 2), mode="edge"), np.ones(k) / k, mode="valid")


def dips(h, prom):
    count, where = 0, []
    for i in range(1, len(h) - 1):
        if not (h[i] < h[i - 1] and h[i] <= h[i + 1]):
            continue
        lh = -math.inf
        for j in range(i - 1, -1, -1):
            if h[j] < h[i]:
                break
            lh = max(lh, h[j])
        rh = -math.inf
        for j in range(i + 1, len(h)):
            if h[j] < h[i]:
                break
            rh = max(rh, h[j])
        if min(lh, rh) - h[i] >= prom:
            count += 1
            where.append(i)
    return count, where


def angle(a, b, c):
    u, v = a - b, c - b
    d = float(np.linalg.norm(u) * np.linalg.norm(v))
    return None if d == 0 else math.degrees(math.acos(max(-1.0, min(1.0, float(np.dot(u, v)) / d))))


def posture_from(frames_xy, recv_xy, T, Tr, toward, onset_i, peak_i, fps, knees_vis=None):
    """frames_xy: (W, 33, 2) thrower, recv_xy: (W, 33, 2) receiver. Indices local to W."""
    k = 3 if fps < 40 else 5
    hh = [((p[L_ANK, 1] + p[R_ANK, 1]) / 2 - (p[L_HIP, 1] + p[R_HIP, 1]) / 2) / T for p in frames_xy]

    def pitch(p, d):
        sh, hp = (p[L_SH] + p[R_SH]) / 2, (p[L_HIP] + p[R_HIP]) / 2
        return math.degrees(math.atan2((sh[0] - hp[0]) * d, hp[1] - sh[1]))

    tp = [pitch(p, toward) for p in frames_xy]
    rp = [pitch(p, -toward) for p in recv_xy]
    hs, ts, rs = smooth(hh, k), smooth(tp, k), smooth(rp, k)
    out = {"_raw": {"thrower_hip_h": hh, "thrower_pitch": tp, "receiver_pitch": rp}}
    out["hips_dips_05T"], w05 = dips(hs, 0.05)
    out["hips_dips_10T"], _ = dips(hs, 0.10)
    out["_dip_i"] = w05
    out["pitch_onset_deg"], out["pitch_peak_deg"] = float(ts[onset_i]), float(ts[peak_i])
    out["pitch_max_deg"], out["pitch_min_deg"] = float(np.max(ts)), float(np.min(ts))
    out["_pitch_argmax"] = int(np.argmax(ts))
    out["pitch_forward_change_deg"] = float(np.max(ts[peak_i:])) - float(ts[onset_i])
    lead_left = frames_xy[onset_i, L_ANK, 0] * toward > frames_xy[onset_i, R_ANK, 0] * toward
    for tag, side in (("lead", "L" if lead_left else "R"), ("rear", "R" if lead_left else "L")):
        hip, knee, ank = (L_HIP, L_KNEE, L_ANK) if side == "L" else (R_HIP, R_KNEE, R_ANK)
        vis_ok = knees_vis is None or all(v > 0.5 for v in knees_vis[side])
        if not vis_ok:
            out[tag + "_knee_onset_deg"] = out[tag + "_knee_min_deg"] = out[tag + "_knee_bend_deg"] = None
            continue
        ks = smooth([angle(p[hip], p[knee], p[ank]) for p in frames_xy], k)
        out[tag + "_knee_onset_deg"], out[tag + "_knee_min_deg"] = float(ks[onset_i]), float(np.min(ks))
        out[tag + "_knee_bend_deg"] = float(ks[onset_i]) - float(np.min(ks))
    rh = [((p[L_ANK, 1] + p[R_ANK, 1]) / 2 - (p[L_HIP, 1] + p[R_HIP, 1]) / 2) / Tr for p in recv_xy]
    out["receiver_hips_dips_05T"], _ = dips(smooth(rh, k), 0.05)
    out["receiver_pitch_onset_deg"] = float(rs[onset_i])
    out["receiver_pitch_min_after_peak_deg"] = float(np.min(rs[peak_i:]))
    out["receiver_pitch_back_change_deg"] = float(rs[onset_i]) - float(np.min(rs[peak_i:]))
    return out


def close(a, b, tol):
    if a is None or b is None:
        return a is None and b is None
    return abs(float(a) - float(b)) <= tol


def pct(vals):
    vals = [float(v) for v in vals if v is not None]
    if not vals:
        return {"n": 0, "p10": None, "p50": None, "p90": None}
    a = np.array(vals)
    return {"n": len(vals), **{q: round(float(np.percentile(a, n)), 2) for q, n in (("p10", 10), ("p50", 50), ("p90", 90))}}


def jab(p):
    w = p.get("wrist_vs_receiver_nose_T")
    return bool(p["lead"]) and w is not None and abs(float(w)) <= 0.4


# ---- 0. the contract files are untouched ----------------------------------------------------------------------------
for path in ["research/Q109_check.py", "Tools/footage/rig_landmarks.json", "Tools/footage/track_pairs.py", "Tools/measure_pair.py"]:
    diff = subprocess.run(["git", "diff", "--quiet", "origin/master", "--", path])
    if diff.returncode != 0:
        fail("%s differs from origin/master - it is not yours to edit" % path)

# ---- 1. the old numbers survived -----------------------------------------------------------------------------------
for path in (BATCH3, POOLED):
    old, new = master(path), load(path) if os.path.exists(path) else None
    if old is None or new is None:
        fail("cannot compare %s with origin/master" % path)
        continue
    for group, block in old.items():
        if group in ("population", "videos"):
            if new.get(group) != block:
                fail("%s: '%s' changed" % (path, group))
            continue
        if group == "punches":
            if len(new.get("punches", [])) != len(block):
                fail("%s: %d punch rows, master has %d" % (path, len(new.get("punches", [])), len(block)))
                continue
            for i, (o, n) in enumerate(zip(block, new["punches"])):
                moved = [k for k in o if n.get(k) != o[k]]
                if moved:
                    fail("%s: punch row %d changed %s" % (path, i, moved[:4]))
                    break
            continue
        if not isinstance(block, dict):
            continue
        for key, val in block.items():
            if key == "rows" or (new.get(group) or {}).get(key) == val:
                continue
            fail("%s: %s.%s moved from master (%s -> %s)" % (path, group, key, str(val)[:60], str((new.get(group) or {}).get(key))[:60]))
if fails:
    print("Q109_CHECK STAGE1 FAIL - the old footage numbers moved; fix pair_events.py/fold_footage.py before anything else")
    sys.exit(1)
print("Q109_CHECK STAGE1 old numbers intact")

# ---- 2. + 3. every posture value, recomputed from the raw tracks ----------------------------------------------------
pooled = load(POOLED)
rows = [p for p in pooled["punches"] if not p.get("slow_motion")]
missing = [i for i, p in enumerate(rows) if not isinstance(p.get("posture"), dict)]
if missing:
    fail("%d pooled punches have no posture block (first rows %s)" % (len(missing), missing[:5]))
sample = [p for i, p in enumerate(rows) if isinstance(p.get("posture"), dict) and (i % 5 == 0 or (jab(p) and i % 3 == 0))]
tracks, events = {}, {}
checked, sign_mismatch = 0, 0
for p in sample:
    vid, po = p["video"], p["posture"]
    if vid not in tracks:
        tracks[vid] = np.load("%s/track/%s.npz" % (F, vid))["img"]
        events[vid] = load("%s/events/%s.json" % (F, vid))
    img, fps = tracks[vid], float(p["fps"])
    w0, w1 = int(po.get("w0_frame", -1)), int(po.get("w1_frame", -1))
    ts, rs = po.get("thrower_slot") or [], po.get("receiver_slot") or []
    if w1 < w0 or len(ts) != w1 - w0 + 1 or len(rs) != len(ts):
        fail("%s f%d: window/slots malformed (w0 %s w1 %s, %d slots)" % (vid, p["frame"], w0, w1, len(ts)))
        continue
    seg = next((s for s in events[vid]["segments"] if s["start_s"] - 1e-6 <= p["t_peak_s"] <= s["end_s"] + 1e-6), None)
    if seg is None:
        fail("%s f%d: no segment holds this punch in the events file" % (vid, p["frame"]))
        continue
    T, Tr = float(seg["T_px"][p["thrower"]]), float(seg["T_px"]["B" if p["thrower"] == "A" else "A"])
    thr = np.array([img[w0 + j, ts[j], :, :2] for j in range(len(ts))], dtype=float)
    rec = np.array([img[w0 + j, rs[j], :, :2] for j in range(len(rs))], dtype=float)
    vis = {"L": [float(img[w0 + j, ts[j], L_KNEE, 3]) for j in range(len(ts))],
           "R": [float(img[w0 + j, ts[j], R_KNEE, 3]) for j in range(len(ts))]}
    jumps = np.linalg.norm(np.diff((thr[:, L_HIP] + thr[:, R_HIP]) / 2, axis=0), axis=1) / T if len(thr) > 1 else np.zeros(1)
    if float(np.max(jumps)) > 1.0:
        fail("%s f%d: the thrower's slots jump %.2f T in one frame - identity is not carried" % (vid, p["frame"], float(np.max(jumps))))
    mid = p["frame"] - w0
    toward = 1.0 if (rec[mid, L_HIP, 0] + rec[mid, R_HIP, 0]) > (thr[mid, L_HIP, 0] + thr[mid, R_HIP, 0]) else -1.0
    best = None
    for d in (toward, -toward):
        mine = posture_from(thr, rec, T, Tr, d, p["onset_frame"] - w0, p["frame"] - w0, fps, vis)
        bad = [k for k in ("hips_dips_05T", "hips_dips_10T", "pitch_onset_deg", "pitch_peak_deg", "pitch_max_deg",
                           "pitch_min_deg", "pitch_forward_change_deg", "lead_knee_onset_deg", "lead_knee_min_deg",
                           "lead_knee_bend_deg", "rear_knee_onset_deg", "rear_knee_min_deg", "rear_knee_bend_deg",
                           "receiver_pitch_onset_deg", "receiver_pitch_min_after_peak_deg", "receiver_pitch_back_change_deg",
                           "receiver_hips_dips_05T") if not close(po.get(k), mine[k], 1e-3)]
        raw = po.get("series") or {}
        for key in ("thrower_hip_h", "thrower_pitch", "receiver_pitch"):
            got = raw.get(key) or []
            if len(got) != len(mine["_raw"][key]) or any(abs(float(a) - float(b)) > 2e-4 for a, b in zip(got, mine["_raw"][key])):
                bad.append("series." + key)
        want_dip_s = [round((i + w0 - p["frame"]) / fps, 4) for i in mine["_dip_i"]]
        if [round(float(x), 4) for x in (po.get("dip_s_from_peak_05T") or [])] != want_dip_s:
            bad.append("dip_s_from_peak_05T")
        if not close(po.get("pitch_max_s_from_peak"), (mine["_pitch_argmax"] + w0 - p["frame"]) / fps, 1e-3):
            bad.append("pitch_max_s_from_peak")
        if best is None or len(bad) < len(best[1]):
            best = (d, bad)
    checked += 1
    if best[0] != toward:
        sign_mismatch += 1
    if best[1]:
        fail("%s f%d (%s %s): recomputed from the track, these disagree: %s" % (vid, p["frame"], p["thrower"], p["hand"], best[1][:6]))
print("Q109_CHECK recomputed %d punches from the raw tracks (%d with the segment's toward opposite to the window's)" % (checked, sign_mismatch))
if checked < 40:
    fail("only %d punches could be recomputed - expected at least 40" % checked)
if sign_mismatch > max(2, checked // 10):
    fail("%d of %d punches read pitch with the opposite sign - `dir` must be the punch's own toward" % (sign_mismatch, checked))

# ---- 4. the folded tables -------------------------------------------------------------------------------------------
GROUP_SEL = {"jabs_head_height": jab, "all_punches": lambda p: True}
tables = {"pooled": rows, "batch 2": [p for p in rows if int(p["batch"]) == 2], "batch 3": [p for p in rows if int(p["batch"]) == 3]}
want = {}
for group, sel in GROUP_SEL.items():
    block = pooled.get(group) or {}
    grp = [p for p in rows if sel(p)]
    for key in NEW_KEYS:
        mine = pct([(p.get("posture") or {}).get(POSTURE_OF[key]) for p in grp])
        if block.get(key) != mine:
            fail("%s: %s.%s is %s, the punch rows give %s" % (POOLED, group, key, block.get(key), mine))
    counts = {"0": 0, "1": 0, "2": 0, "3+": 0}
    for p in grp:
        v = (p.get("posture") or {}).get("hips_dips_05T")
        if v is not None:
            counts["3+" if int(v) >= 3 else str(int(v))] += 1
    if block.get("thrower_hips_dips_05T_counts") != counts:
        fail("%s: %s.thrower_hips_dips_05T_counts is %s, the rows give %s" % (POOLED, group, block.get("thrower_hips_dips_05T_counts"), counts))
jn = pooled["jabs_head_height"]
for key in NEW_KEYS:
    floor = 30 if "knee" in key else 95
    if (jn.get(key) or {}).get("n", 0) < floor:
        fail("jabs_head_height.%s has n=%s - expected at least %d of 104" % (key, (jn.get(key) or {}).get("n"), floor))
for name, sel_rows in tables.items():
    grp = [p for p in sel_rows if jab(p)]
    want[name] = {key: pct([(p.get("posture") or {}).get(POSTURE_OF[key]) for p in grp]) for key in NEW_KEYS}
    c = {"0": 0, "1": 0, "2": 0, "3+": 0}
    for p in grp:
        v = (p.get("posture") or {}).get("hips_dips_05T")
        if v is not None:
            c["3+" if int(v) >= 3 else str(int(v))] += 1
    want[name]["_counts"] = c

# ---- 5. the authored pairs, from the pair files' own joints ---------------------------------------------------------
rig = load("Tools/footage/rig_landmarks.json")
PX, YT, NUP = float(rig["px_per_m"]), float(rig["y_top_m"]), float(rig["nose_up_T"])
pair_verdicts = {}
for pid in PAIRS:
    d = load("Godot/assets/anim/pairs/%s.pair.json" % pid)
    gap, fps = float(d["pair"]["start_gap_m"]), float(d["fps"])
    names = {r: [b["name"] for b in d["roles"][r]["bones"]] for r in ("thrower", "receiver")}

    def joint(role, bone, k):
        r = d["roles"][role]
        i = names[role].index(bone)
        o = np.array(r["take"]["pose"][k][12 * i + 9:12 * i + 12], dtype=float) * float(r["world_scale"])
        line = -gap / 2 + o[2] if role == "thrower" else gap / 2 - o[2]
        return np.array([line * PX, (YT - o[1]) * PX])

    nframes = len(d["roles"]["thrower"]["take"]["pose"])
    bones = rig["map"]

    def pose(role, k):
        p = np.zeros((33, 2))
        for idx, bone in bones.items():
            p[int(idx)] = joint(role, bone, k)
        return p

    Tm = {r: float(np.linalg.norm((joint(r, "LeftUpperArm", 0) + joint(r, "RightUpperArm", 0)) / 2
                                   - (joint(r, "LeftUpperLeg", 0) + joint(r, "RightUpperLeg", 0)) / 2)) for r in ("thrower", "receiver")}
    npz_path = "%s/pair_%s.npz" % (F, pid)
    if not os.path.exists(npz_path):
        fail("%s: %s is missing (step 5)" % (pid, npz_path))
        continue
    img = np.load(npz_path)["img"]
    if img.shape[0] != nframes or img.shape[1] != 2:
        fail("%s: npz img shape %s, the pair has %d frames and two men" % (pid, img.shape, nframes))
        continue
    contact = int(d["timeline_frames"]["contact"])
    for k in (0, contact, nframes - 1):
        for role, slot in (("thrower", 0), ("receiver", 1)):
            mine = pose(role, k)
            for idx in (11, 15, 16, 23, 25, 27):
                if np.max(np.abs(img[k, slot, idx, :2] - mine[idx])) > 0.5:
                    fail("%s f%d %s landmark %d: npz %s, the pair file gives %s" % (pid, k, role, idx, img[k, slot, idx, :2].round(2), mine[idx].round(2)))
            nose = joint(role, "Head", k) - np.array([0.0, NUP * Tm[role]])
            if np.max(np.abs(img[k, slot, NOSE, :2] - nose)) > 0.5:
                fail("%s f%d %s nose: npz %s, want the Head joint raised %.2f T = %s" % (pid, k, role, img[k, slot, NOSE, :2].round(2), NUP, nose.round(2)))
    ev_path = "research/S4A_PAIRS/pair_%s_events.json" % pid
    fold_path = "research/S4A_PAIRS/pair_%s_fold.json" % pid
    if not (os.path.exists(ev_path) and os.path.exists(fold_path)):
        fail("%s: %s or %s is missing" % (pid, ev_path, fold_path))
        continue
    ev = load(ev_path)
    jabs = [p for p in ev.get("punches", []) if p["thrower"] == "A" and bool(p["lead"]) and abs(int(p["frame"]) - contact) <= 4]
    if len(jabs) != 1:
        fail("%s: pair_events found %d lead punches by the thrower within 4 frames of contact f%d (all: %s)" % (
            pid, len(jabs), contact, [(p["thrower"], p["hand"], p["frame"]) for p in ev.get("punches", [])]))
        continue
    p = jabs[0]
    po = p.get("posture") or {}
    w0, w1 = int(po.get("w0_frame", 0)), int(po.get("w1_frame", -1))
    seg = ev["segments"][0]
    thr = np.array([pose("thrower", k) for k in range(w0, w1 + 1)])
    rec = np.array([pose("receiver", k) for k in range(w0, w1 + 1)])
    T = float(np.median([np.linalg.norm((pose("thrower", k)[L_SH] + pose("thrower", k)[R_SH]) / 2 - (pose("thrower", k)[L_HIP] + pose("thrower", k)[R_HIP]) / 2) for k in range(nframes)]))
    Tr = float(np.median([np.linalg.norm((pose("receiver", k)[L_SH] + pose("receiver", k)[R_SH]) / 2 - (pose("receiver", k)[L_HIP] + pose("receiver", k)[R_HIP]) / 2) for k in range(nframes)]))
    if not close(seg["T_px"]["A"], T, 0.05) or not close(seg["T_px"]["B"], Tr, 0.05):
        fail("%s: segment T_px %s, the pair's joints give A %.3f B %.3f" % (pid, seg["T_px"], T, Tr))
    mine = posture_from(thr, rec, T, Tr, 1.0, int(p["onset_frame"]) - w0, int(p["frame"]) - w0, fps)
    for key in ("hips_dips_05T", "hips_dips_10T", "pitch_onset_deg", "pitch_forward_change_deg", "lead_knee_bend_deg",
                "rear_knee_bend_deg", "receiver_pitch_back_change_deg"):
        if not close(po.get(key), mine[key], 1e-3):
            fail("%s: posture.%s is %s, the pair file's joints give %.4f" % (pid, key, po.get(key), mine[key]))
    pair_verdicts[pid] = {}
    for key in DECISION_KEYS[:-1]:
        s = jn.get(key) or {}
        v = mine[POSTURE_OF[key]]
        pair_verdicts[pid][key] = "-" if not s.get("n") else ("inside" if s["p10"] <= round(v, 2) <= s["p90"] else "OUTSIDE")
    if jab({"lead": True, "wrist_vs_receiver_nose_T": p.get("wrist_vs_receiver_nose_T")}) is False:
        print("WARN %s: the authored jab's wrist is %.2f T from the receiver's nose height - not head height by the footage rule" % (pid, float(p["wrist_vs_receiver_nose_T"])))

# ---- 6. the digest ---------------------------------------------------------------------------------------------------
if not os.path.exists(DIGEST):
    fail("%s is missing" % DIGEST)
else:
    text = open(DIGEST, encoding="utf-8").read()
    lines = text.splitlines()
    if len(lines) > 90:
        fail("the digest has %d lines - 90 at most" % len(lines))
    for head in ("# Q109 - the fold, measured", "## DECISIONS", "## Jabs to the head: posture", "## The authored pairs", "## Population"):
        if head not in text:
            fail("the digest has no '%s'" % head)
    dec = text.split("## DECISIONS", 1)[-1].split("\n## ", 1)[0]
    for key in DECISION_KEYS:
        if key not in dec:
            fail("DECISIONS does not name `%s`" % key)
    for pid in PAIRS:
        if pid not in dec:
            fail("DECISIONS does not name the pair %s" % pid)

    def cell(s):
        return "- (0)" if not s.get("n") else "%.2f / %.2f / %.2f (%d)" % (s["p10"], s["p50"], s["p90"], s["n"])

    for key in NEW_KEYS:
        row = next((l for l in lines if l.startswith("| %s |" % key)), None)
        exp = "| %s | %s | %s | %s |" % (key, cell(want["batch 2"][key]), cell(want["batch 3"][key]), cell(want["pooled"][key]))
        if row is None or not row.startswith(exp):
            fail("posture row for %s: want it to start `%s`, found `%s`" % (key, exp, row))

    def cnt(c):
        return "0:%d 1:%d 2:%d 3+:%d" % (c["0"], c["1"], c["2"], c["3+"])

    exp = "| dips_05T counts | %s | %s | %s |" % (cnt(want["batch 2"]["_counts"]), cnt(want["batch 3"]["_counts"]), cnt(want["pooled"]["_counts"]))
    if not any(l.startswith(exp) for l in lines):
        fail("the dips counts row must start `%s`" % exp)
    fences = re.findall(r"```text\n(.*?)```", text.split("## The authored pairs", 1)[-1], flags=re.S)
    if len(fences) < 2:
        fail("## The authored pairs needs both compare_to_footage.py outputs, each in its own ```text fence")
    for pid, fence in zip(PAIRS, fences):
        for key, verdict in pair_verdicts.get(pid, {}).items():
            line = next((l for l in fence.splitlines() if re.search(r"(^|[^A-Za-z0-9_])%s([^A-Za-z0-9_]|$)" % re.escape(key), l)), None)
            if line is None or verdict not in line:
                fail("%s's compare output: `%s` should read %s (found `%s`)" % (pid, key, verdict, line))
    if pooled["population"] not in text.split("## Population", 1)[-1]:
        fail("## Population must hold the pooled JSON's population string verbatim")

print("Q109_CHECK PASS" if not fails else "Q109_CHECK FAIL (%d)" % len(fails))
sys.exit(0 if not fails else 1)
