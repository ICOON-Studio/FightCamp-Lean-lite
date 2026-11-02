"""U109 gate (Claude, 2026-09-15). Prints `U109_CHECK PASS` or FAIL lines. Run from the repo root.

    python research/U109_check.py [FOOTAGE_DIR]

FOOTAGE_DIR defaults to C:/Users/user/AppData/Local/Temp/FightCamp-footage and must hold `track/` and `events/`.

WHAT THIS GATE IS FOR. A rate is a number over a denominator, and the denominator is where this project's footage work
has gone wrong most: a UFC broadcast round tracks 126.8 s of its 300 s because the cameras cut, and `HFSZxKUUE98` is
slow motion so its npz fps is not its real fps. So the gate does not take the digest's word for any per-minute figure -
it RECOMPUTES every one of them from the delivered event files, and it pins the denominator to the events file's own
segments, which U109 does not author.
"""
import json
import os
import re
import subprocess
import sys

FOOTAGE = sys.argv[1] if len(sys.argv) > 1 else "C:/Users/user/AppData/Local/Temp/FightCamp-footage"
FOLD = "research/S4E_BETWEEN/footage_between.json"
DIGEST = "research/U109_FOOTAGE_BETWEEN_RATES.md"
KINDS = ["lead_foot_crossings", "direction_changes", "resets", "level_changes", "head_moves"]
## S4e (4) added the facing yaw rate. It is a RATE per frame, not an event, so it is checked separately from KINDS
## below - a _per_min figure would be meaningless for it.
RATES = ["turn_yaw_deg_s"]
BOXING_IDS = [
    "-vPZqptk8jo", "2m1Ftv_l_Xc", "7pIskYcLKVw", "FCM7m6TJWUQ", "HL261oRyURE",
    "LfpNJ5fIYA4", "cyXGrr7YTeg", "isLkzN3d7rA", "vOFmsN3JROs", "yg_N42n_Jdk",
    "xaXXD-w45b0", "wzUWvsviqTM", "kuABaA2PY0U", "XIja1S9SXI4", "HFSZxKUUE98", "d_PSlBJheZI",
]
UFC_ID = "_mkFV2H2oCk_r1"
## The kept UFC round-1 track is 126.8 s of a 300 s round (the broadcast cuts between cameras). Usable time is what is
## left after the punch windows come out, so it can only be LESS. This is the physics pin.
UFC_TRACKED_S = 126.8

fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


for path in ["Godot/scripts", "Godot/tests", "Godot/assets", "research/U109_check.py"]:
    r = subprocess.run(["git", "diff", "--quiet", "HEAD", "--", path])
    if r.returncode != 0:
        fail("%s has uncommitted changes - U109 owns only its tools, its JSON and its digest" % path)

for path in ["Tools/footage/between_events.py", "Tools/footage/fold_between.py", FOLD, DIGEST]:
    if not os.path.exists(path):
        fail("%s is missing" % path)
if fails:
    print("U109_CHECK FAIL (%d)" % len(fails))
    sys.exit(1)

# The reference instrument must not have been edited to make the numbers work.
r = subprocess.run(["git", "diff", "--quiet", "HEAD", "--", "Tools/footage/pair_events.py"])
if r.returncode != 0:
    fail("Tools/footage/pair_events.py was modified - it is the reference instrument and U109 does not own it")

fold = json.load(open(FOLD, encoding="utf-8"))
per_video = fold.get("videos", {})
if not isinstance(per_video, dict) or not per_video:
    fail("%s has no `videos` object keyed by video id" % FOLD)
    print("U109_CHECK FAIL (%d)" % len(fails))
    sys.exit(1)

missing = [v for v in BOXING_IDS if v not in per_video]
if missing and len(missing) == len(BOXING_IDS):
    fail("none of the 16 boxing/sparring ids is in the fold - was FOOTAGE_DIR wrong?")
elif missing:
    # A track that is genuinely absent is allowed, but it has to be NAMED in the digest rather than silently dropped.
    text_early = open(DIGEST, encoding="utf-8").read()
    for vid in missing:
        if vid not in text_early:
            fail("video %s is not in the fold and is not named in the digest as skipped" % vid)

seen_ufc = UFC_ID in per_video
if not seen_ufc:
    fail("the kept UFC round (%s) is not in the fold - it is a separate population and is required" % UFC_ID)

empty_videos = []

# --- every rate is recomputed, none is taken on trust ---------------------------------------------------------------
for vid, row in per_video.items():
    usable = float(row.get("usable_seconds", 0.0))
    if usable <= 0.0:
        # A VIDEO WITH NO TWO-MAN SEGMENTS IS NOT A FAILURE, IT IS AN EMPTY POPULATION.
        # pair_events.py found no stretch where both men are usable at once in six of the
        # sixteen boxing videos (2m1Ftv_l_Xc, 7pIskYcLKVw, HFSZxKUUE98, LfpNJ5fIYA4,
        # cyXGrr7YTeg, isLkzN3d7rA - all segs=0, punches=0). Demanding a denominator from them
        # fails the run for something the footage simply does not contain. What IS required is
        # that the digest NAMES them, so nobody later reads the table as sixteen videos.
        ev_path_e = os.path.join(FOOTAGE, "events", vid + ".json")
        segs = []
        if os.path.exists(ev_path_e):
            try:
                segs = json.load(open(ev_path_e, encoding="utf-8")).get("segments", [])
            except (ValueError, OSError):
                segs = []
        if segs:
            fail("%s: usable_seconds is %.3f but its events file has %d two-man segment(s) - "
                 "a rate needs a denominator" % (vid, usable, len(segs)))
        else:
            empty_videos.append(vid)
        continue
    if vid == UFC_ID and usable > UFC_TRACKED_S + 0.05:
        fail("%s: usable_seconds %.2f exceeds the %.1f s that round actually tracks - the denominator is the whole "
             "round, not the tracked segments" % (vid, usable, UFC_TRACKED_S))
    fps = float(row.get("fps", 0.0))
    if fps <= 0.0:
        fail("%s: no fps recorded" % vid)
    ev_path = os.path.join(FOOTAGE, "events", vid + ".json")
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
            fail("%s: usable_seconds %.2f exceeds the segment seconds %.2f - punch windows must come OUT, not in"
                 % (vid, usable, seg_s))
    for kind in KINDS:
        n = row.get(kind + "_n")
        rate = row.get(kind + "_per_min")
        if n is None or rate is None:
            fail("%s: %s is missing its _n or its _per_min" % (vid, kind))
            continue
        want = float(n) * 60.0 / usable
        if abs(float(rate) - want) > 0.02:
            fail("%s: %s_per_min is %.3f but %d events over %.2f usable seconds is %.3f"
                 % (vid, kind, float(rate), int(n), usable, want))

text_yaw = open(DIGEST, encoding="utf-8").read()
# --- the facing yaw rate, which S4e (4)'s turn rate is waiting on ------------------------------------------------
for vid, row in per_video.items():
    for rate in RATES:
        have = [k for k in ("%s_p50" % rate, "%s_p90" % rate, "%s_max" % rate) if k in row]
        if len(have) < 3:
            fail("%s: %s needs _p50, _p90 and _max (the engine's turn rate is tuned to nothing without them)"
                 % (vid, rate))
            continue
        p50, p90, mx = (float(row["%s_p50" % rate]), float(row["%s_p90" % rate]), float(row["%s_max" % rate]))
        if not (0.0 <= p50 <= p90 <= mx):
            fail("%s: %s is not ordered p50 <= p90 <= max (%.1f / %.1f / %.1f)" % (vid, rate, p50, p90, mx))
        # GATE THE p90, NOT THE MAX (Claude, 2026-09-20). The original check failed a video
        # whose MAXIMUM exceeded 2000 deg/s. That was the wrong statistic: the max of a
        # per-frame numerical derivative taken off a monocular 2D tracker is an extremum of
        # the noise, not a property of the fighter, and gating it invites the fix that was
        # actually submitted - a `continue` on any step above 1200 deg/s, which discards
        # samples by their own value and reports a maximum one hair under the threshold.
        # A GATE THAT CAN ONLY BE PASSED BY DISCARDING THE EVIDENCE IS NOT A GATE.
        # The p90 is robust to isolated label swaps and is a real physical claim: a human
        # turns fast, but a 90th percentile above 1000 deg/s means the signal is broken.
        if p90 > 1000.0:
            fail("%s: %s p90 is %.0f deg/s - the ninth decile of a human's turn rate is not that; "
                 "the facing signal is broken, do not cap the samples to hide it" % (vid, rate, p90))
        low_yaw = text_yaw.lower()
        if mx > 2000.0 and "label swap" not in low_yaw and "label-swap" not in low_yaw:
            fail("%s: %s max is %.0f deg/s, which is tracker artefact rather than measurement - that is "
                 "ALLOWED, but the digest must say so in ## METHOD or ## Open (the words 'label swap'). "
                 "Do not cap the samples instead." % (vid, rate, mx))

# --- the two populations are never averaged into one ------------------------------------------------------------
pooled = fold.get("pooled", {})
ufc_pooled = fold.get("ufc_pooled", {})
if not pooled or not ufc_pooled:
    fail("the fold must carry `pooled` (the 16 boxing/sparring videos) and `ufc_pooled` SEPARATELY - they are "
         "different populations and must never be averaged into one number")
else:
    for kind in KINDS:
        if kind + "_per_min" not in pooled or kind + "_per_min" not in ufc_pooled:
            fail("%s is missing from one of the two pooled tables" % kind)
    if UFC_ID in [v for v in pooled.get("videos", [])]:
        fail("the UFC round is inside the boxing/sparring pool")

# --- the digest ---------------------------------------------------------------------------------------------------
text = open(DIGEST, encoding="utf-8").read()
lines = text.splitlines()
if len(lines) > 100:
    fail("the digest has %d lines - 100 at most" % len(lines))
for head in ("# U109 - what fighters do between punches, measured", "## POPULATION", "## RATES", "## METHOD", "## Open"):
    if head not in text:
        fail("the digest has no '%s'" % head)


def section(name):
    part = text.split(name, 1)[-1] if name in text else ""
    return part.split("\n## ", 1)[0]


pop = section("## POPULATION")
for vid in per_video:
    if vid not in pop:
        fail("## POPULATION does not name %s" % vid)
if not re.search(r"(side-on|three-quarter|behind)", pop):
    fail("## POPULATION names no camera for any video - a rate from a camera that cannot see the feet is not the "
         "same measurement")

rates = section("## RATES")
for kind in KINDS:
    row = next((l for l in rates.splitlines() if l.startswith("|") and kind in l), None)
    if row is None:
        fail("## RATES has no row for %s" % kind)
    elif "MEASURED" not in row:
        fail("the %s row carries no MEASURED label" % kind)

method = section("## METHOD")
for vid in per_video:
    if vid not in method:
        fail("## METHOD does not print the fps used for %s" % vid)
if "torso" not in text.lower():
    fail("the digest never says torso lengths - every length in this task is in T, never pixels and never invented cm")

if len([l for l in section("## Open").splitlines() if l.strip()]) > 8:
    fail("## Open is longer than 8 lines")

# --- a video that contributed nothing must be NAMED, or the table reads as sixteen -----------------------------
if empty_videos:
    missing_names = [v for v in empty_videos if v not in text]
    if missing_names:
        fail("the digest does not name the video(s) that contributed NO two-man footage and were "
             "excluded: %s - a measurement must name its population" % ", ".join(sorted(missing_names)))
    else:
        print("U109_CHECK excluded %d video(s) with no two-man segments, all named in the digest: %s"
              % (len(empty_videos), ", ".join(sorted(empty_videos))))

# --- a rate built on a handful of events is not a rate ---------------------------------------------------------
# `resets` came back with THREE events pooled across eleven videos and a LABEL of
# MEASURED (footage), which reads in a table exactly like the 539-event row beside it.
# A rule bound to n=3 is bound to noise. The row may stand - it is honestly derived -
# but the digest has to say the n is too small to bind a rule to.
POOLED_MIN_N = 10
pooled_row = fold.get("pooled", {})
for kind in KINDS:
    n_pooled = int(pooled_row.get(kind + "_n", 0))
    if 0 < n_pooled < POOLED_MIN_N:
        low = text.lower()
        if "too small" not in low and "too few" not in low:
            fail("%s has only %d events pooled across every video and is still labelled a measured rate - "
                 "say in the digest that the n is too small to bind a rule to (the words 'too small' or "
                 "'too few')" % (kind, n_pooled))
    if n_pooled == 0:
        fail("%s has NO events pooled - a definition that never fires is not a measurement of zero; "
             "say so in ## Open" % kind)

print("U109_CHECK videos %d, kinds %d, every per-minute figure recomputed from its own events" % (
    len(per_video), len(KINDS)))
print("U109_CHECK PASS" if not fails else "U109_CHECK FAIL (%d)" % len(fails))
sys.exit(0 if not fails else 1)
