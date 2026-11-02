"""U105 gate (Claude, 2026-09-14). Prints `U105_CHECK PASS` or FAIL lines. Run from the repo (or worktree) root.

The exported bodies are pinned to PHYSICS (toes on the canvas, a standing man's hip height, two men who stay apart and
move) and to the AUTHORED PAIR (the glove reaches the head on the pair's contact frame), the npz is re-projected here
from the raw .bin with this file's own code, and the folds are re-run with master's unchanged fold_footage.py.
"""
import json
import os
import re
import subprocess
import sys
import tempfile

import numpy as np

R = "C:/Users/user/AppData/Local/Temp/FightCamp-footage/room"
SEEDS = [94301, 51227, 77003]
MODES = ["on", "off"]
ORDER = [0, 11, 12, 13, 14, 15, 16, 23, 24, 25, 26, 27, 28, 31, 32]
FOLD = {m: "research/S4A_PAIRS/room_two_men_pairs_%s.json" % m for m in MODES}
FOOTAGE = "research/S4A_PAIRS/footage_two_men.json"
DIGEST = "research/U105_ROOM_AS_FOOTAGE.md"
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def load(path):
    return json.load(open(path, encoding="utf-8"))


for path in ["research/U105_check.py", "Tools/footage/rig_landmarks.json", "Tools/footage/pair_events.py",
             "Tools/footage/fold_footage.py", "Godot/scripts"]:
    if subprocess.run(["git", "diff", "--quiet", "origin/master", "--", path]).returncode != 0:
        fail("%s differs from origin/master - not yours to edit" % path)

rig = load("Tools/footage/rig_landmarks.json")
PX, YT, NUP = float(rig["px_per_m"]), float(rig["y_top_m"]), float(rig["nose_up_T"])
pairs = {}
for name in os.listdir("Godot/assets/anim/pairs"):
    if name.endswith(".pair.json"):
        d = load("Godot/assets/anim/pairs/" + name)
        pairs[d["id"]] = float(d["pair"]["contact_s"])
col = {idx: i for i, idx in enumerate(ORDER)}
runs = {}
for seed in SEEDS:
    for mode in MODES:
        base = "%s/room_%d_%s" % (R, seed, mode)
        if not (os.path.exists(base + ".json") and os.path.exists(base + ".bin") and os.path.exists(base + ".npz")):
            fail("run seed %d pairs=%s: %s.json/.bin/.npz missing" % (seed, mode, base))
            continue
        h = load(base + ".json")
        raw = np.fromfile(base + ".bin", dtype="<f4")
        if raw.size % 90:
            fail("%s.bin holds %d floats - not 90 a frame" % (base, raw.size))
            continue
        body = raw.reshape(-1, 2, 15, 3)
        tag = "seed %d pairs=%s" % (seed, mode)
        runs[(seed, mode)] = (h, body, base)
        if h.get("format") != "fightcamp.room_track" or int(h.get("seed", -1)) != seed or h.get("pairs") != mode:
            fail("%s: header format/seed/pairs wrong (%s, %s, %s)" % (tag, h.get("format"), h.get("seed"), h.get("pairs")))
        if int(h.get("fps", 0)) != 30 or int(h.get("frames", -1)) != body.shape[0]:
            fail("%s: header fps %s frames %s, the .bin holds %d frames" % (tag, h.get("fps"), h.get("frames"), body.shape[0]))
        if list(h.get("landmarks", [])) != ORDER:
            fail("%s: landmarks %s, want %s" % (tag, h.get("landmarks"), ORDER))
        for side in ("A", "B"):
            if not 0.40 <= float((h.get("torso_m") or {}).get(side, 0)) <= 0.65:
                fail("%s: torso_m %s = %s, a man's torso is 0.40-0.65 m" % (tag, side, (h.get("torso_m") or {}).get(side)))
        pop = str(h.get("population", ""))
        if str(seed) not in pop or "rig_landmarks" not in pop:
            fail("%s: the population string must name the seed and rig_landmarks.json: %s" % (tag, pop[:120]))
        if body.shape[0] < 3000:
            fail("%s: only %d frames - a 3-round bout at 30 fps is thousands" % (tag, body.shape[0]))
            continue
        # ---- physics ------------------------------------------------------------------------------------------------
        toes = np.minimum(body[:, :, col[31], 1], body[:, :, col[32], 1])
        if np.mean(toes >= -0.06) < 0.99 or np.mean(toes <= 0.30) < 0.95:
            fail("%s: the lower toe is on the canvas on %.1f%% of frames (>= -6 cm) and within 30 cm on %.1f%% - want 99%% and 95%%" % (
                tag, 100 * np.mean(toes >= -0.06), 100 * np.mean(toes <= 0.30)))
        hip_h = (body[:, :, col[23], 1] + body[:, :, col[24], 1]) / 2 - (body[:, :, col[27], 1] + body[:, :, col[28], 1]) / 2
        if not 0.55 <= float(np.median(hip_h)) <= 1.05:
            fail("%s: median hip height above the ankles %.2f m - a standing boxer is 0.55-1.05 m" % (tag, float(np.median(hip_h))))
        hip_line = (body[:, :, col[23], 0] + body[:, :, col[24], 0]) / 2
        gap = hip_line[:, 1] - hip_line[:, 0]
        if np.mean(gap > 0) < 0.99 or np.mean((gap > 0.6) & (gap < 3.0)) < 0.95:
            fail("%s: B stands ahead of A on %.1f%% of frames, 0.6-3.0 m apart on %.1f%%" % (tag, 100 * np.mean(gap > 0), 100 * np.mean((gap > 0.6) & (gap < 3.0))))
        for s, side in ((0, "A"), (1, "B")):
            if float(np.std(body[:, s, col[15], 0] - hip_line[:, s])) < 0.03:
                fail("%s: %s's left wrist barely moves relative to his hips (std %.3f m) - a posed body throws punches" % (
                    tag, side, float(np.std(body[:, s, col[15], 0] - hip_line[:, s]))))
        # ---- the npz, re-projected ----------------------------------------------------------------------------------
        z = np.load(base + ".npz")
        img = z["img"]
        if img.shape != (body.shape[0], 2, 33, 5) or not np.all(z["n"] == 2) or abs(float(z["fps"]) - 30.0) > 1e-6:
            fail("%s: npz img %s, n all 2 %s, fps %s" % (tag, img.shape, bool(np.all(z["n"] == 2)), float(z["fps"])))
            continue
        for k in np.linspace(0, body.shape[0] - 1, 40).astype(int):
            for s, side in ((0, "A"), (1, "B")):
                for idx in ORDER:
                    j = body[k, s, col[idx]]
                    up = NUP * float(h["torso_m"][side]) if idx == 0 else 0.0
                    want = np.array([PX * j[0], PX * (YT - (j[1] + up)), PX * j[2]])
                    if np.max(np.abs(img[k, s, idx, :3] - want)) > 0.05 or img[k, s, idx, 3] != 1.0:
                        fail("%s f%d %s landmark %d: npz %s vis %s, the .bin projects to %s" % (tag, k, side, idx, img[k, s, idx, :3].round(3), img[k, s, idx, 3], want.round(3)))
                        break
                for idx, near in rig["nearest"].items():
                    if np.max(np.abs(img[k, s, int(idx), :2] - img[k, s, int(near), :2])) > 1e-4 or img[k, s, int(idx), 3] != 0.0:
                        fail("%s f%d %s landmark %s should copy %s with visibility 0" % (tag, k, side, idx, near))
                        break
        # ---- the authored pair reaches the head --------------------------------------------------------------------
        side_car = h.get("frames_sidecar") or {}
        ids, ps = side_car.get("pair_id") or [], side_car.get("pair_s") or []
        if len(ids) != body.shape[0] or len(ps) != body.shape[0]:
            fail("%s: sidecar pair_id/pair_s hold %d/%d rows for %d frames" % (tag, len(ids), len(ps), body.shape[0]))
            continue
        if mode == "off":
            if any(ids):
                fail("%s: a pairs=off run shows a pair on %d frames" % (tag, sum(1 for i in ids if i)))
            continue
        reached, total = 0, 0
        k = 0
        while k < len(ids):
            if not ids[k] or ids[k] not in pairs:
                k += 1
                continue
            pid, c = ids[k], pairs[ids[k]]
            e = k
            while e + 1 < len(ids) and ids[e + 1] == pid and float(ps[e + 1]) >= float(ps[e]):
                e += 1
            hit = next((q for q in range(k, e + 1) if float(ps[q]) >= c), None)
            if hit is not None:
                takes = side_car["a_take"][hit], side_car["b_take"][hit]
                thrower = 0 if str(takes[0]).startswith("jab#pair_") else (1 if str(takes[1]).startswith("jab#pair_") else None)
                if thrower is not None:
                    total += 1
                    head = body[hit, 1 - thrower, col[0]]
                    reach = min(float(np.linalg.norm(body[hit, thrower, col[15]] - head)), float(np.linalg.norm(body[hit, thrower, col[16]] - head)))
                    if reach <= 0.35:
                        reached += 1
            k = e + 1
        played = int((h.get("pair_stats") or {}).get("played", 0))
        if played < 1 or total < 1:
            fail("%s: pair_stats played %d, pair contact frames found %d - the pairs=on bout must play at least one" % (tag, played, total))
        elif reached < 0.8 * total or total > played:
            fail("%s: a glove within 35 cm of the head on %d of %d pair contact frames (played %d) - the file is not the posed bodies" % (tag, reached, total, played))
        else:
            print("U105_CHECK %s: %d frames, %d pair contacts, glove at the head on %d" % (tag, body.shape[0], total, reached))

# ---- events and folds, re-run with master's fold_footage.py ----------------------------------------------------------
fold_src = subprocess.run(["git", "show", "origin/master:Tools/footage/fold_footage.py"], capture_output=True, text=True, encoding="utf-8").stdout
folds = {}
with tempfile.TemporaryDirectory() as tmp:
    tool = os.path.join(tmp, "fold_footage.py")
    open(tool, "w", encoding="utf-8").write(fold_src)
    for mode in MODES:
        evs = ["%s/events_room_%d_%s.json" % (R, s, mode) for s in SEEDS]
        if not all(os.path.exists(e) for e in evs) or not os.path.exists(FOLD[mode]):
            fail("pairs=%s: events files or %s missing" % (mode, FOLD[mode]))
            continue
        for e in evs:
            n = len(load(e).get("punches", []))
            if n < 30:
                fail("%s: pair_events found %d punches - a 3-round bout throws hundreds" % (e, n))
        mine = load(FOLD[mode])
        out = os.path.join(tmp, "fold_%s.json" % mode)
        subprocess.run([sys.executable, tool, "--out", out, "--population", mine.get("population", "")] + ["0:" + e for e in evs],
                       capture_output=True, text=True)
        if not os.path.exists(out) or load(out) != mine:
            fail("%s is not what master's fold_footage.py makes of the three events files" % FOLD[mode])
        for s in SEEDS:
            if str(s) not in mine.get("population", ""):
                fail("%s: population must name seed %d" % (FOLD[mode], s))
        folds[mode] = mine

# ---- the digest ------------------------------------------------------------------------------------------------------
foot = load(FOOTAGE)


def two(v):
    return "-" if v is None else "%.2f" % float(v)


def combo_cell(b):
    if not b:
        return "-"
    po, pp = b.get("peak_to_onset_s") or {}, b.get("peak_to_peak_s") or {}
    return "n=%d onset %s/%s/%s peak %s/%s/%s back %s" % (int(b.get("n", 0)), two(po.get("p10")), two(po.get("p50")), two(po.get("p90")),
                                                       two(pp.get("p10")), two(pp.get("p50")), two(pp.get("p90")), two(b.get("returned_share")))


def stat_cell(s):
    if isinstance(s, int):
        return str(s)
    return "- (0)" if not s or not s.get("n") else "%.2f / %.2f / %.2f (%d)" % (s["p10"], s["p50"], s["p90"], s["n"])


if not os.path.exists(DIGEST):
    fail("%s is missing" % DIGEST)
elif len(folds) == 2:
    text = open(DIGEST, encoding="utf-8").read()
    lines = text.splitlines()
    if len(lines) > 80:
        fail("the digest has %d lines - 80 at most" % len(lines))
    for head in ("# U105 - the live room measured like footage", "## DECISIONS", "## Combinations", "## Jabs to the head", "## Pair or clip", "## Population"):
        if head not in text:
            fail("the digest has no '%s'" % head)
    for name in ("all", "lead->lead", "lead->rear", "rear->lead", "rear->rear"):
        pick = (lambda f: f["combinations"]["all"]) if name == "all" else (lambda f, n=name: f["combinations"]["by_transition"].get(n))
        exp = "| %s | %s | %s | %s |" % (name, combo_cell(pick(folds["on"])), combo_cell(pick(folds["off"])), combo_cell(pick(foot)))
        if not any(l.startswith(exp) for l in lines):
            fail("the combinations row for %s must start `%s`" % (name, exp))
    for key, val in folds["on"]["jabs_head_height"].items():
        if key == "definition":
            continue
        exp = "| %s | %s | %s | %s |" % (key, stat_cell(val), stat_cell(folds["off"]["jabs_head_height"].get(key)), stat_cell(foot["jabs_head_height"].get(key)))
        if not any(l.startswith(exp) for l in lines):
            fail("the jabs row for %s must start `%s`" % (key, exp))
    want_rows = []
    for p in folds["on"]["punches"]:
        w = p.get("wrist_vs_receiver_nose_T")
        if not (bool(p["lead"]) and w is not None and abs(float(w)) <= 0.4):
            continue
        seed = int(re.search(r"events_room_(\d+)_on", p["video"]).group(1)) if re.search(r"events_room_(\d+)_on", p["video"]) else None
        h = runs.get((seed, "on"), (None,))[0]
        if h is None:
            fail("pair-or-clip: cannot find the run for punch video %s" % p["video"])
            continue
        take = h["frames_sidecar"]["a_take" if p["thrower"] == "A" else "b_take"][int(p["frame"])]
        want_rows.append("| %d | %.2f | %s | %s | %s |" % (seed, float(p["t_peak_s"]), p["thrower"], take, "pair" if "#pair_" in str(take) else "clip"))
    sec = text.split("## Pair or clip", 1)[-1].split("\n## ", 1)[0]
    for row in want_rows:
        if row not in sec:
            fail("## Pair or clip is missing the row `%s`" % row)
            break
    pair_n = sum(1 for r in want_rows if r.endswith("| pair |"))
    print("U105_CHECK pairs=on head jabs %d, %d inside a pair take" % (len(want_rows), pair_n))
    if folds["on"]["population"] not in text.split("## Population", 1)[-1]:
        fail("## Population must hold the pairs=on fold's population string verbatim")

print("U105_CHECK PASS" if not fails else "U105_CHECK FAIL (%d)" % len(fails))
sys.exit(0 if not fails else 1)
