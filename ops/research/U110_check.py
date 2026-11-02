"""U110 gate (Claude, 2026-09-15). Prints `U110_CHECK PASS` or FAIL lines. Run from the repo root.

    python research/U110_check.py [FOOTAGE_DIR]

FOOTAGE_DIR defaults to C:/Users/user/AppData/Local/Temp/FightCamp-footage and must hold `track/` and `events/`.

WHAT THIS GATE IS FOR. U110 exists to give `FightCommitment.COMMIT_S` a rear-hand and a kick figure, and the ONE number
it delivers is `away_s` = extension_s + return_s. So the gate does not take the digest's word for any of it: it
recomputes `away_s` and every percentile from the delivered per-move event files, it pins each per-minute figure to the
events file's own segments, and it refuses a p90 computed off fewer than 30 moves — a percentile off twenty samples is
a number pretending to be a measurement.

IT ALSO GUARDS COMPARABILITY. Q110's table is only worth having beside this one if `reacted` and `matched_punch` mean
the same thing in both, so `jab_types.py`, `fold_jab_types.py` and `pair_events.py` must come back unmodified — an
instrument edited to make the numbers work is the failure this project has already paid for (C117, and the check
written from its own definition that pinned that definition's bug).
"""
import json
import os
import subprocess
import sys

FOOTAGE = sys.argv[1] if len(sys.argv) > 1 else "C:/Users/user/AppData/Local/Temp/FightCamp-footage"
FOLD = "research/S4A_PAIRS/footage_limb_types.json"
DIGEST = "research/U110_FOOTAGE_COMMIT_WINDOW.md"
LIMBS = ["rear_hand", "kick"]
PERCENTILE_FLOOR = 30
BOXING_IDS = [
    "-vPZqptk8jo", "2m1Ftv_l_Xc", "7pIskYcLKVw", "FCM7m6TJWUQ", "HL261oRyURE",
    "LfpNJ5fIYA4", "cyXGrr7YTeg", "isLkzN3d7rA", "vOFmsN3JROs", "yg_N42n_Jdk",
    "xaXXD-w45b0", "wzUWvsviqTM", "kuABaA2PY0U", "XIja1S9SXI4", "HFSZxKUUE98", "d_PSlBJheZI",
]
UFC_ID = "_mkFV2H2oCk_r1"
## The kept UFC round-1 track is 126.8 s of a 300 s round (the broadcast cuts between cameras).
UFC_TRACKED_S = 126.8

fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def pct(values, q):
    """The same linear-interpolation percentile numpy gives, without importing it."""
    if not values:
        return 0.0
    ordered = sorted(values)
    if len(ordered) == 1:
        return float(ordered[0])
    pos = (len(ordered) - 1) * q
    low = int(pos)
    high = min(low + 1, len(ordered) - 1)
    return float(ordered[low] + (ordered[high] - ordered[low]) * (pos - low))


for path in ["Godot/scripts", "Godot/tests", "Godot/assets", "research/U110_check.py"]:
    r = subprocess.run(["git", "diff", "--quiet", "HEAD", "--", path])
    if r.returncode != 0:
        fail("%s has uncommitted changes - U110 owns only its tools, its JSON and its digest" % path)

for path in ["Tools/footage/limb_types.py", "Tools/footage/fold_limb_types.py", FOLD, DIGEST]:
    if not os.path.exists(path):
        fail("%s is missing" % path)
if fails:
    print("U110_CHECK FAIL (%d)" % len(fails))
    sys.exit(1)

# The reference instruments must not have been edited to make the numbers agree.
for path in ["Tools/footage/jab_types.py", "Tools/footage/fold_jab_types.py", "Tools/footage/pair_events.py"]:
    r = subprocess.run(["git", "diff", "--quiet", "HEAD", "--", path])
    if r.returncode != 0:
        fail("%s was modified - it is a reference instrument and U110 does not own it" % path)

fold = json.load(open(FOLD, encoding="utf-8"))
per_video = fold.get("videos", {})
if not isinstance(per_video, dict) or not per_video:
    fail("%s has no `videos` object keyed by video id" % FOLD)
    print("U110_CHECK FAIL (%d)" % len(fails))
    sys.exit(1)

digest_text = open(DIGEST, encoding="utf-8").read()
if len(digest_text.splitlines()) > 70:
    fail("%s is %d lines - the task caps it at 70" % (DIGEST, len(digest_text.splitlines())))

missing = [v for v in BOXING_IDS if v not in per_video]
if missing and len(missing) == len(BOXING_IDS):
    fail("none of the 16 boxing/sparring ids is in the fold - was FOOTAGE_DIR wrong?")
elif missing:
    # A genuinely absent track is allowed, but it has to be NAMED in the digest rather than silently dropped.
    for vid in missing:
        if vid not in digest_text:
            fail("video %s is not in the fold and is not named in the digest as skipped" % vid)

if UFC_ID not in per_video:
    fail("the kept UFC round (%s) is not in the fold - it is a separate population and is required" % UFC_ID)

# --- the denominator, per video, recomputed from the events file ----------------------------------------------------
for vid, row in per_video.items():
    usable = float(row.get("usable_seconds", 0.0))
    if usable <= 0.0:
        fail("%s: usable_seconds is %.3f - a rate needs a denominator" % (vid, usable))
        continue
    if vid == UFC_ID and usable > UFC_TRACKED_S + 0.05:
        fail("%s: usable_seconds %.2f exceeds the %.1f s that round actually tracks"
             % (vid, usable, UFC_TRACKED_S))
    fps = float(row.get("fps", 0.0))
    if fps <= 0.0:
        fail("%s: no fps recorded" % vid)
    ev_path = os.path.join(FOOTAGE, "events", vid + ".json")
    if not os.path.exists(ev_path):
        ev_path = os.path.join(FOOTAGE, "ufc_pilot", vid + ".json")
    if os.path.exists(ev_path):
        ev = json.load(open(ev_path, encoding="utf-8"))
        ev_fps = float(ev.get("fps", 0.0))
        if ev_fps > 0.0 and abs(ev_fps - fps) > 0.01:
            fail("%s: fps %.3f does not match the events file's %.3f - take fps from the events file"
                 % (vid, fps, ev_fps))
        # pair_events.py writes each segment as {"start_s": .., "end_s": ..} - ALREADY IN SECONDS.
        # This check was authored where the footage directory was empty, so it was never run against a
        # real events file; it assumed a [frame_a, frame_b] pair over fps and died with KeyError: 0 on
        # the first one it met (2026-09-20). The legacy pair form is kept as a fallback.
        seg_s = 0.0
        for seg in ev.get("segments", []):
            if isinstance(seg, dict):
                a, b = float(seg["start_s"]), float(seg["end_s"])
            else:
                a = float(seg[0]) / (ev_fps if ev_fps > 0.0 else 1.0)
                b = float(seg[1]) / (ev_fps if ev_fps > 0.0 else 1.0)
            seg_s += max(0.0, b - a)
        if seg_s > 0.0 and usable > seg_s + 0.05:
            fail("%s: usable_seconds %.2f exceeds the segment seconds %.2f" % (vid, usable, seg_s))

# --- every headline figure recomputed from the per-move files -------------------------------------------------------
pooled = {limb: [] for limb in LIMBS}
for vid, row in per_video.items():
    for limb in LIMBS:
        block = row.get(limb)
        if not isinstance(block, dict):
            fail("%s: no `%s` block" % (vid, limb))
            continue
        moves = block.get("moves")
        if not isinstance(moves, list):
            fail("%s/%s: the fold must carry the per-move list it folded, or nothing can be recomputed"
                 % (vid, limb))
            continue
        away = []
        for move in moves:
            ext = float(move.get("extension_s", -1.0))
            ret = float(move.get("return_s", -1.0))
            if ext < 0.0 or ret < 0.0:
                fail("%s/%s: a move is missing extension_s or return_s" % (vid, limb))
                break
            away.append(ext + ret)
        else:
            if vid != UFC_ID:
                pooled[limb].extend(away)
            n = int(block.get("n", -1))
            if n != len(moves):
                fail("%s/%s: n=%d but %d moves were delivered" % (vid, limb, n, len(moves)))
            usable = float(row.get("usable_seconds", 0.0))
            if usable > 0.0:
                want = len(moves) / (usable / 60.0)
                got = float(block.get("per_minute", -1.0))
                if abs(got - want) > 0.02:
                    fail("%s/%s: per_minute %.3f, recomputed %.3f" % (vid, limb, got, want))
            stated = block.get("away_s", {})
            for key, q in [("p10", 0.10), ("p50", 0.50), ("p90", 0.90)]:
                if key not in stated:
                    if key == "p90" and len(away) < PERCENTILE_FLOOR:
                        continue
                    fail("%s/%s: away_s has no %s" % (vid, limb, key))
                    continue
                want = pct(away, q)
                if abs(float(stated[key]) - want) > 0.002:
                    fail("%s/%s: away_s %s is %.4f, recomputed %.4f"
                         % (vid, limb, key, float(stated[key]), want))
            if len(away) < PERCENTILE_FLOOR and "p90" in stated:
                fail("%s/%s: a p90 off %d moves is not a measurement - the floor is %d"
                     % (vid, limb, len(away), PERCENTILE_FLOOR))

# --- the pooled headline, which is what the engine will read ---------------------------------------------------------
pooled_block = fold.get("pooled_boxing", {})
if not isinstance(pooled_block, dict) or not pooled_block:
    fail("the fold has no `pooled_boxing` block - the 16 sparring videos pool separately from the UFC round")
else:
    for limb in LIMBS:
        block = pooled_block.get(limb, {})
        if not isinstance(block, dict):
            fail("pooled_boxing has no `%s`" % limb)
            continue
        values = pooled[limb]
        if not values:
            fail("pooled_boxing/%s: nothing was pooled" % limb)
            continue
        want = pct(values, 0.50)
        got = float((block.get("away_s", {}) or {}).get("p50", -1.0))
        if abs(got - want) > 0.002:
            fail("pooled_boxing/%s: away_s p50 is %.4f, recomputed %.4f from %d moves"
                 % (limb, got, want, len(values)))
        if "%.3f" % want not in digest_text and "%.2f" % want not in digest_text:
            fail("pooled_boxing/%s: the headline away_s p50 (%.3f s) is not in the digest" % (limb, want))

if "0.267" not in digest_text:
    fail("the digest does not cite Q110's lead-hand 0.267 s - the whole point is the comparison")

if fails:
    print("U110_CHECK FAIL (%d)" % len(fails))
    sys.exit(1)
print("U110_CHECK PASS")
