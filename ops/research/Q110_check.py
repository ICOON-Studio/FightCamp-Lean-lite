"""Q110 gate (Claude, 2026-09-14). Prints `Q110_CHECK PASS` or FAIL lines. Run from the repo (or worktree) root.

The census is pinned to the unchanged reference instrument (pair_events.py's events files): the same segments, every lead
punch it found must be found again, and each event's reach and arm length are recomputed from the track's own `img`
at the detector slots the event names, with this file's code.
"""
import json
import math
import os
import random
import re
import subprocess
import sys

import numpy as np

F = "C:/Users/user/AppData/Local/Temp/FightCamp-footage"
IDS = ["-vPZqptk8jo", "2m1Ftv_l_Xc", "7pIskYcLKVw", "FCM7m6TJWUQ", "HL261oRyURE", "LfpNJ5fIYA4", "cyXGrr7YTeg", "isLkzN3d7rA",
       "vOFmsN3JROs", "yg_N42n_Jdk", "xaXXD-w45b0", "wzUWvsviqTM", "kuABaA2PY0U", "XIja1S9SXI4", "HFSZxKUUE98", "d_PSlBJheZI"]
TABLE = "research/S4A_PAIRS/footage_jab_types.json"
STRIPS = "research/S4A_PAIRS/jab_types_strips"
DIGEST = "research/Q110_FOOTAGE_JAB_TYPES.md"
CLASSES = ["feint", "partial", "full_planted", "full_stepping", "other"]
KEYS = ["t_peak_s", "frame_onset", "frame_peak", "frame_back", "thrower", "hand", "thrower_slot", "T_px", "rise_T",
        "reach_peak_T", "arm_len_T", "e", "extension_s", "return_s", "hips_out_T", "lead_ankle_out_T",
        "rear_wrist_v_nose_T", "reacted", "matched_punch", "next_0_8s", "class"]
L_SH, R_SH, L_EL, R_EL, L_WR, R_WR = 11, 12, 13, 14, 15, 16
fails = []
random.seed(110)


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def load(p):
    return json.load(open(p, encoding="utf-8"))


r = subprocess.run(["git", "diff", "--name-only", "origin/master", "--", "Tools/footage", "research/Q110_check.py"],
                   capture_output=True, text=True)
for path in r.stdout.split():
    if not path.endswith(("jab_types.py", "fold_jab_types.py", "jab_types_strips.py")):
        fail("%s differs from origin/master - not yours to edit" % path)

total_minutes = 0.0
counts = {c: 0 for c in CLASSES}
found, wanted = 0, 0
recomputed, bad_reach, bad_arm = 0, 0, 0
for vid in IDS:
    path = "%s/jab_types/%s.json" % (F, vid)
    ev_path = "%s/events/%s.json" % (F, vid)
    if not os.path.exists(path):
        fail("%s is missing (step 1)" % path)
        continue
    got, ref = load(path), load(ev_path)
    segs = [(round(s["start_s"], 6), round(s["end_s"], 6)) for s in got.get("segments", [])]
    ref_segs = [(round(s["start_s"], 6), round(s["end_s"], 6)) for s in ref["segments"]]
    if segs != ref_segs:
        fail("%s: segments differ from pair_events.py's (%d v %d) - the identity block was not copied exactly" % (vid, len(segs), len(ref_segs)))
    total_minutes += sum(e - s for s, e in ref_segs) / 60.0
    events = got.get("events", [])
    for ev in events:
        missing = [k for k in KEYS if k not in ev]
        if missing:
            fail("%s: an event lacks %s" % (vid, missing))
            break
        if ev["class"] not in CLASSES:
            fail("%s: unknown class %s" % (vid, ev["class"]))
            break
        counts[ev["class"]] += 1
        e = float(ev["e"])
        if not (0.0 < e <= 1.6) or not (0.0 < float(ev["extension_s"]) <= 0.8) or float(ev["rise_T"]) < 0.12 - 1e-9:
            fail("%s t=%.2f: e %.3f / extension_s %s / rise_T %s outside physics or the contract" % (vid, ev["t_peak_s"], e, ev["extension_s"], ev["rise_T"]))
            break
        if abs(e - float(ev["reach_peak_T"]) / float(ev["arm_len_T"])) > 0.01:
            fail("%s t=%.2f: e is not reach_peak_T / arm_len_T" % (vid, ev["t_peak_s"]))
            break
        want = ("feint" if e < 0.70 and ev["rise_T"] < 0.35 else "partial" if 0.70 <= e < 0.90 else
                "full_planted" if e >= 0.90 and ev["lead_ankle_out_T"] < 0.15 else
                "full_stepping" if e >= 0.90 else "other")
        if want != ev["class"]:
            fail("%s t=%.2f: class %s, the contract says %s" % (vid, ev["t_peak_s"], ev["class"], want))
            break
    # every lead punch the reference instrument found is found again
    for p in ref["punches"]:
        if not p.get("lead"):
            continue
        wanted += 1
        if any(ev["thrower"] == p["thrower"] and abs(ev["t_peak_s"] - p["t_peak_s"]) <= 0.1 for ev in events):
            found += 1
    # recompute reach and arm length from img at the named slots, for up to 4 random events a video
    track = np.load("%s/track/%s.npz" % (F, vid))
    img = track["img"]
    for ev in random.sample(events, min(4, len(events))):
        slots = ev["thrower_slot"]
        k = int(ev["frame_peak"])
        frames = [str(k - 1), str(k), str(k + 1)]
        if not all(f in slots for f in frames):
            fail("%s t=%.2f: thrower_slot must name frames peak-1, peak, peak+1" % (vid, ev["t_peak_s"]))
            break
        sh, el, wr = (L_SH, L_EL, L_WR) if ev["hand"] == "L" else (R_SH, R_EL, R_WR)
        T = float(ev["T_px"])
        reach = np.mean([np.linalg.norm(img[int(f), int(slots[f]), wr, :2] - img[int(f), int(slots[f]), sh, :2]) / T for f in frames])
        pose = img[k, int(slots[str(k)])]
        arm = (np.linalg.norm(pose[sh, :2] - pose[el, :2]) + np.linalg.norm(pose[el, :2] - pose[wr, :2])) / T
        recomputed += 1
        if abs(reach - float(ev["reach_peak_T"])) > 0.03:
            bad_reach += 1
            print("  reach %s t=%.2f: event %.3f, from img %.3f" % (vid, ev["t_peak_s"], ev["reach_peak_T"], reach))
        if not (0.7 * arm <= float(ev["arm_len_T"]) <= 1.3 * arm + 0.05):
            bad_arm += 1
            print("  arm %s t=%.2f: event %.3f, this frame %.3f" % (vid, ev["t_peak_s"], ev["arm_len_T"], arm))

print("Q110_CHECK reference lead punches found again: %d of %d; recomputed %d events, reach off %d, arm off %d" % (found, wanted, recomputed, bad_reach, bad_arm))
if wanted and found < 0.9 * wanted:
    fail("only %d of %d lead punches from pair_events.py were found again - the lowered detector must contain the old one" % (found, wanted))
if recomputed < 30:
    fail("only %d events could be recomputed from img" % recomputed)
elif bad_reach > 0.1 * recomputed or bad_arm > 0.2 * recomputed:
    fail("reach recomputed from img disagrees on %d of %d events, arm length on %d - the stored slots or series are not what was measured" % (bad_reach, recomputed, bad_arm))

# ---- the table ---------------------------------------------------------------------------------------------------------
if not os.path.exists(TABLE):
    fail("%s is missing (step 2)" % TABLE)
    table = {}
else:
    table = load(TABLE)
    if abs(float(table.get("minutes", -1)) - total_minutes) > 0.01:
        fail("minutes %s, the events files' segments sum to %.3f" % (table.get("minutes"), total_minutes))
    for vid in IDS:
        if vid not in table.get("population", ""):
            fail("the population string must name %s" % vid)
    hist = table.get("histogram_e", {}).get("counts", [])
    if len(hist) != 30 or sum(hist) > sum(counts.values()):
        fail("histogram_e.counts must be 30 bins covering the events (got %d bins, %s events)" % (len(hist), sum(hist) if hist else 0))
    for c in CLASSES:
        row = table.get("classes", {}).get(c)
        if row is None:
            fail("classes.%s is missing" % c)
            continue
        if int(row.get("n", -1)) != counts[c]:
            fail("classes.%s.n %s, the per-video files hold %d" % (c, row.get("n"), counts[c]))
        if counts[c] and abs(float(row["per_minute"]) * total_minutes - counts[c]) > 0.5:
            fail("classes.%s.per_minute x minutes is not n" % c)
    print("Q110_CHECK classes: " + ", ".join("%s %d" % (c, counts[c]) for c in CLASSES))

# ---- strips and digest -------------------------------------------------------------------------------------------------
for c in CLASSES[:4]:
    pngs = [p for p in (os.listdir(STRIPS) if os.path.isdir(STRIPS) else []) if p.startswith(c + "_") and p.endswith(".png")]
    need = min(3, counts[c])
    if len([p for p in pngs if os.path.getsize(os.path.join(STRIPS, p)) > 5000]) < need:
        fail("%s needs %d strips larger than 5 KB, has %d" % (c, need, len(pngs)))
if not os.path.exists(DIGEST):
    fail("%s is missing" % DIGEST)
else:
    text = open(DIGEST, encoding="utf-8").read()
    if len(text.splitlines()) > 90:
        fail("the digest has %d lines - 90 at most" % len(text.splitlines()))
    for head in ("# Q110 - the three jabs in footage", "## DECISIONS", "## Classes", "## Histogram", "## Strips", "## Population"):
        if head not in text:
            fail("the digest has no '%s'" % head)
    dec = text.split("## DECISIONS", 1)[-1].split("\n## ", 1)[0]
    for c in CLASSES[:4]:
        row = table.get("classes", {}).get(c) or {}
        if c not in dec or not re.search(r"(^|\D)%d(\D|$)" % counts[c], dec):
            fail("DECISIONS must name %s with its n %d" % (c, counts[c]))
    if table.get("population") and table["population"] not in text.split("## Population", 1)[-1]:
        fail("## Population must hold the table's population string verbatim")

print("Q110_CHECK PASS" if not fails else "Q110_CHECK FAIL (%d)" % len(fails))
sys.exit(0 if not fails else 1)
