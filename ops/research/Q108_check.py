"""Q108 check (Claude, 2026-09-14) - footage batch 3 measured, folded with batch 2, the digest true to the JSON, the videos
deleted. NEVER EDIT THIS FILE. Run from the repo root: python research/Q108_check.py
Prints FAIL lines, then `Q108_CHECK READY_TO_DELETE` (everything but the deletion passes) or `Q108_CHECK PASS`."""
import glob
import hashlib
import json
import os
import re
import subprocess
import sys
import tempfile

import numpy as np

REPO = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
FOOT = "C:/Users/user/AppData/Local/Temp/FightCamp-footage"
PAIRS = os.path.join(REPO, "research", "S4A_PAIRS")
B3_JSON = os.path.join(PAIRS, "footage_batch3_two_men.json")
POOL_JSON = os.path.join(PAIRS, "footage_two_men.json")
B2_JSON = os.path.join(PAIRS, "footage_batch2_two_men.json")
DIGEST = os.path.join(REPO, "research", "Q108_FOOTAGE_BATCH3.md")
FOLD = os.path.join(REPO, "Tools", "footage", "fold_footage.py")
EVENTS = os.path.join(REPO, "Tools", "footage", "pair_events.py")
MEASURE = os.path.join(REPO, "Tools", "measure_pair.py")
PAIR_FILES = ["Godot/assets/anim/pairs/BOX_JAB_HEAD_LAND_F01_F09.pair.json", "Godot/assets/anim/pairs/BOX_JAB_HEAD_LAND_F09_F01.pair.json"]
# frame counts read with OpenCV from the downloaded files before tracking (Claude, 2026-09-14)
B3 = {"xaXXD-w45b0": 49449, "wzUWvsviqTM": 33651, "kuABaA2PY0U": 5505, "XIja1S9SXI4": 8024, "HFSZxKUUE98": 14032, "d_PSlBJheZI": 33705}
SLOW = "HFSZxKUUE98"
B2 = ["-vPZqptk8jo", "2m1Ftv_l_Xc", "7pIskYcLKVw", "FCM7m6TJWUQ", "HL261oRyURE", "LfpNJ5fIYA4", "cyXGrr7YTeg", "isLkzN3d7rA",
      "vOFmsN3JROs", "yg_N42n_Jdk"]
JAB_KEYS = ["gap_T_before", "gap_T_peak", "gap_T_after", "feet_T_before", "feet_T_peak", "feet_T_after", "thrower_hips_out_T",
            "thrower_lead_ankle_out_T", "thrower_rear_ankle_out_T", "extension_s", "return_s",
            "receiver_nose_away_T_peak_plus_0.1s", "receiver_nose_away_T_peak_plus_0.2s", "receiver_nose_away_T_peak_plus_0.3s",
            "receiver_hips_away_T_peak_plus_0.2s", "receiver_nose_moves_s_from_peak",
            "thrower_hips_drop_T", "thrower_hips_drop_s_from_peak", "thrower_nose_drop_T"]
TRANSITIONS = ["lead->lead", "lead->rear", "rear->lead", "rear->rear"]
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def load(path):
    try:
        with open(path, encoding="utf-8") as fh:
            return json.load(fh)
    except Exception as exc:  # noqa: BLE001
        fail("cannot read %s: %s" % (path, exc))
        return None


def cell(block):
    if block is None or block.get("n", 0) == 0 or block.get("p50") is None:
        return "- (0)"
    return "%.2f / %.2f / %.2f (%d)" % (block["p10"], block["p50"], block["p90"], block["n"])


def run(args):
    return subprocess.run([sys.executable] + args, capture_output=True, text=True, cwd=REPO)


# 1. tracks and events, untouched ------------------------------------------------------------------------------------
for vid, frames in B3.items():
    npz = os.path.join(FOOT, "track", vid + ".npz")
    ev_path = os.path.join(FOOT, "events", vid + ".json")
    if not os.path.exists(npz):
        fail("no track %s" % npz)
        continue
    n = len(np.load(npz)["t"])
    if abs(n - frames) > max(3, 0.01 * frames):
        fail("%s: the track holds %d frames, the video %d - a partial track" % (vid, n, frames))
    ev = load(ev_path) if os.path.exists(ev_path) else None
    if ev is None:
        fail("no events %s" % ev_path)
        continue
    with tempfile.TemporaryDirectory() as tmp:
        fresh_path = os.path.join(tmp, vid + ".json")
        r = run([EVENTS, npz, fresh_path, ev.get("label", "")])
        fresh = load(fresh_path) if r.returncode == 0 else None
    if fresh is None or json.dumps(fresh["punches"], sort_keys=True) != json.dumps(ev["punches"], sort_keys=True):
        fail("%s: events/%s.json is not what pair_events.py makes from its track" % (vid, vid))

# 2. the two folds are the tool's output -----------------------------------------------------------------------------
b3 = load(B3_JSON)
pool = load(POOL_JSON)
b2 = load(B2_JSON)
b3_sources = ["3:%s/events/%s.json" % (FOOT, v) for v in B3]
b2_sources = ["2:%s/events/%s.json" % (FOOT, v) for v in B2]
if b3 is not None and pool is not None:
    for name, data, sources in (("batch 3", b3, b3_sources), ("pooled", pool, b2_sources + b3_sources)):
        pop = str(data.get("population", ""))
        for word in ("MediaPipe", SLOW, "T ="):
            if word not in pop:
                fail("%s population does not name %r" % (name, word))
        with tempfile.TemporaryDirectory() as tmp:
            out = os.path.join(tmp, "fold.json")
            r = run([FOLD, "--out", out, "--population", pop, "--slow", SLOW] + sources)
            if r.returncode != 0:
                fail("%s: fold_footage.py failed: %s" % (name, r.stderr[-400:]))
                continue
            with open(out, "rb") as fh:
                fresh = fh.read()
        target = B3_JSON if name == "batch 3" else POOL_JSON
        with open(target, "rb") as fh:
            ## a Windows checkout (autocrlf) writes the committed LF file with CRLF - compare the content, not the line ends
            if hashlib.sha256(fh.read().replace(b"\r\n", b"\n")).hexdigest() != hashlib.sha256(fresh.replace(b"\r\n", b"\n")).hexdigest():
                fail("%s: %s is not byte-identical to fold_footage.py's output for the named sources" % (name, os.path.basename(target)))
    if b2 is not None:
        for key, block in b2["jabs_head_height"].items():
            if key == "definition":
                continue
            with tempfile.TemporaryDirectory() as tmp:
                pass
        ref = subprocess.run([sys.executable, FOLD, "--out", os.path.join(tempfile.gettempdir(), "q108_b2.json"), "--population", "b2",
                              "--slow", SLOW] + b2_sources, capture_output=True, text=True, cwd=REPO)
        b2_fold = load(os.path.join(tempfile.gettempdir(), "q108_b2.json")) if ref.returncode == 0 else None
        if b2_fold is not None:
            for key, block in b2["jabs_head_height"].items():
                if key == "definition":
                    continue
                mine = b2_fold["jabs_head_height"][key]
                if mine["n"] != block["n"] or any(abs(mine[x] - block[x]) > 1e-9 for x in ("p10", "p50", "p90")):
                    fail("the fold no longer reproduces batch 2's jabs_head_height %s: %s v %s" % (key, mine, block))
    slow_rows = [p for p in pool.get("punches", []) if p.get("video") == SLOW]
    if pool.get("videos", {}).get(SLOW, {}).get("slow_motion") is not True:
        fail("pooled: %s is not marked slow_motion" % SLOW)
    if sorted(pool.get("videos", {}).keys()) != sorted(B2 + list(B3)):
        fail("pooled: the video list is not batch 2 + batch 3")

# 3. the digest says what the JSON says --------------------------------------------------------------------------------
text = open(DIGEST, encoding="utf-8").read() if os.path.exists(DIGEST) else ""
if not text:
    fail("no digest %s" % DIGEST)
else:
    lines = text.splitlines()
    if len(lines) > 90:
        fail("digest is %d lines (90 at most)" % len(lines))
    for head in ("## DECISIONS", "## Per video", "## Jabs to the head", "## The next exchanges", "## Combinations",
                 "## measure_pair", "## Population"):
        if head not in text:
            fail("digest has no %r section" % head)
    if b3 is not None and pool is not None:
        rows = {}
        for line in lines:
            if line.startswith("|"):
                cells = [c.strip() for c in line.strip().strip("|").split("|")]
                if cells:
                    rows[cells[0].strip("`")] = cells
        for vid in B3:
            v = b3["videos"].get(vid, {})
            jabs = sum(1 for p in b3["punches"] if p["video"] == vid and p["lead"] and p.get("wrist_vs_receiver_nose_T") is not None
                       and abs(p["wrist_vs_receiver_nose_T"]) <= 0.4)
            want = [vid, "%.0f" % v.get("fps", 0), str(v.get("frames")), str(v.get("segments")), "%.1f" % v.get("both_tracked_s", 0),
                    str(v.get("punches")), str(jabs), "yes" if v.get("slow_motion") else "no"]
            got = rows.get(vid)
            if got is None or [c for c in got[:8]] != want:
                fail("per-video row for %s must be | %s | ... got %s" % (vid, " | ".join(want), got))
        b2j = b2["jabs_head_height"] if b2 else {}
        moved = []
        for key in JAB_KEYS:
            want = [key, cell(b2j.get(key)) if key in b2j else "-", cell(b3["jabs_head_height"][key]), cell(pool["jabs_head_height"][key])]
            got = rows.get(key)
            if got is None or got[:4] != want:
                fail("jab row for %s must be | %s | got %s" % (key, " | ".join(want), got))
            if key in b2j and b2j[key].get("p50") is not None and pool["jabs_head_height"][key]["p50"] is not None \
                    and abs(pool["jabs_head_height"][key]["p50"] - b2j[key]["p50"]) >= 0.05:
                moved.append(key)
        decisions = text.split("## DECISIONS", 1)[1].split("\n## ", 1)[0] if "## DECISIONS" in text else ""
        if len([l for l in decisions.splitlines() if l.strip()]) > 12:
            fail("DECISIONS is longer than 12 lines")
        for key in moved:
            if key not in decisions:
                fail("DECISIONS does not name %s, whose pooled p50 moved >= 0.05 from batch 2" % key)
        combos = pool.get("combinations", {})
        for name, blk in [("all", combos.get("all", {}))] + [(t, combos.get("by_transition", {}).get(t, {})) for t in TRANSITIONS]:
            share = blk.get("returned_share")
            want = [name, str(blk.get("n")), cell(blk.get("peak_to_onset_s")), cell(blk.get("peak_to_peak_s")),
                    "-" if share is None else "%.2f" % share]
            got = rows.get(name)
            if got is None or got[:5] != want:
                fail("combinations row for %s must be | %s | got %s" % (name, " | ".join(want), got))
        if "thrower_hips_drop_T" not in decisions or "peak_to_onset_s" not in decisions:
            fail("DECISIONS must state the pooled thrower_hips_drop_T and the combinations' peak_to_onset_s")
        for group in ("rear_head_height", "lead_body", "rear_body"):
            g = pool[group]
            want = ["%s" % group, str(g["punches"]), cell(g["gap_T_before"]), cell(g["gap_T_peak"]), cell(g["thrower_hips_out_T"]),
                    cell(g["extension_s"])]
            got = rows.get(group)
            if got is None or got[:6] != want:
                fail("next-exchange row for %s must be | %s | got %s" % (group, " | ".join(want), got))
    blocks = re.findall(r"```(?:text)?\n(.*?)```", text, re.S)
    for pair in PAIR_FILES:
        r = run([MEASURE, pair, "--footage", "research/S4A_PAIRS/footage_two_men.json"])
        fresh = [l.rstrip() for l in r.stdout.strip().splitlines()]
        if r.returncode != 0 or not any([l.rstrip() for l in b.strip().splitlines()] == fresh for b in blocks):
            fail("the digest has no fenced block equal to `python Tools/measure_pair.py %s --footage research/S4A_PAIRS/footage_two_men.json`" % pair)
    if pool is not None and ("Population" in text) and str(pool.get("population", "")) not in text:
        fail("the Population section does not carry the pooled JSON's population string verbatim")

# 4. the videos are deleted ---------------------------------------------------------------------------------------------
left = glob.glob(os.path.join(FOOT, "batch3", "*.mp4"))
if fails:
    print("Q108_CHECK FAIL (%d)" % len(fails))
    sys.exit(1)
if left:
    print("Q108_CHECK READY_TO_DELETE (%d videos still in %s/batch3)" % (len(left), FOOT))
    sys.exit(2)
print("Q108_CHECK PASS")
