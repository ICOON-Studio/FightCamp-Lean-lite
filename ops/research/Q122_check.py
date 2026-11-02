"""Q122 gate  -  the CMU paired-corpus contact census, recomputed independently.

MUST EXIT 0. Run it from the repo root:

    python research/Q122_check.py

WHY THIS EXISTS. A research agent answers the question it prefers unless a gate
makes it answer the one that was asked (2026-09-14: a must-exit-0 gate took the
first-pass rate to 14/14). This script does not read Q122's prose or trust its
arithmetic: it recomputes every headline figure straight from the .asf/.amc
files with `Tools/cmu_asf_amc.py` and requires the committed CSV to agree.

IT WAS RUN AGAINST REAL INPUT BEFORE IT WAS SHIPPED, on the PC, 2026-09-21  - 
which is the thing U109_check.py and U110_check.py both skipped, and both died
with `KeyError: 0` on their first real events file.
"""
import csv
import os
import sys

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(REPO, "Tools"))

import cmu_asf_amc as C  # noqa: E402

CSV_PATH = os.path.join(REPO, "research", "Q122_CMU_CONTACT_CENSUS.csv")
MD_PATH = os.path.join(REPO, "research", "Q122_CMU_CONTACT_CENSUS.md")

# The six paired trials that load. 17_10 has no partner file in the repo and is
# deliberately absent: a census must not silently drop a trial, so if a seventh
# ever lands here the gate should be updated rather than the row ignored.
PAIRS = [
    ("18", "19", "03"),
    ("18", "19", "04"),
    ("18", "19", "05"),
    ("18", "19", "06"),
    ("22", "23", "01"),
    ("22", "23", "17"),
]

# The contact this census is named for: one man's HAND on the other man's ELBOW.
# In CMU the elbow is the distal end of the humerus, where `lradius` begins.
# Both directions count  -  either man may be the gripper.
HANDS = ("lwrist", "rwrist")
ELBOWS = ("lradius", "rradius")

GRIP_MAX_M = 0.20          # the threshold the census is reported at
TOL_M = 0.001              # 1 mm agreement between the CSV and this recomputation

REQUIRED_COLUMNS = [
    "subject_a", "subject_b", "trial", "frames",
    "min_m", "p10_m", "p50_m", "p90_m", "max_m",
    "grip_frames", "grip_share",
    "episodes", "longest_episode_frames",
    "dominant_pair", "dominant_pair_share",
]

# WHICH LIMBS ACTUALLY TOUCH, AND DOES IT SWAP. The `min` above collapses eight
# candidate contacts into one number, and that number cannot tell you which arm
# to drive. `dominant_pair` is the most frequent ARGMIN over the grip frames,
# written as `<gripper>.<hand>-><held>.<elbow>`, e.g. `A.lwrist->B.rradius`;
# `dominant_pair_share` is its share OF THE GRIP FRAMES (not of all frames).
# A share near 1.0 means one stable grip and one chain to bake. A share near
# 0.25 means the contact wanders between limbs, and THAT is a finding, not a
# failure - report it, do not tune the threshold until it goes away.

# AN EPISODE IS A MAXIMAL RUN OF CONSECUTIVE GRIP FRAMES. It is the half of this
# census that the frame share cannot tell you: 50% of frames gripped is one long
# hold or forty flickers, and a mask that chatters makes an anchor bake snap in
# and out of contact. Defined with a single threshold on purpose - if the
# episode counts come out absurdly high, that is the finding that justifies
# hysteresis, and it belongs in the memo rather than in a quietly tuned gate.


def _episodes(series, threshold):
    """(count, longest) maximal runs of consecutive frames at or inside `threshold`."""
    count = 0
    longest = 0
    run = 0
    for d in series:
        if d <= threshold:
            run += 1
            if run == 1:
                count += 1
            if run > longest:
                longest = run
        else:
            run = 0
    return count, longest


def failures():
    out = []

    if not os.path.exists(CSV_PATH):
        return ["MISSING: %s  -  the census must be committed as a CSV, not only as prose"
                % os.path.relpath(CSV_PATH, REPO)]
    if not os.path.exists(MD_PATH):
        out.append("MISSING: %s  -  the census needs a memo naming its population"
                   % os.path.relpath(MD_PATH, REPO))

    with open(CSV_PATH, newline="", encoding="utf-8") as fh:
        rows = list(csv.DictReader(fh))

    if not rows:
        return ["%s has no rows" % os.path.relpath(CSV_PATH, REPO)]

    missing_cols = [c for c in REQUIRED_COLUMNS if c not in rows[0]]
    if missing_cols:
        return ["%s is missing column(s): %s" % (os.path.relpath(CSV_PATH, REPO),
                                                 ", ".join(missing_cols))]

    by_key = {}
    for r in rows:
        by_key[(r["subject_a"].strip(), r["subject_b"].strip(), r["trial"].strip())] = r

    grip_populations = []

    for a, b, trial in PAIRS:
        key = (a, b, trial)
        if key not in by_key:
            out.append("NO ROW for %s/%s trial %s  -  every loadable pair must be "
                       "in the census, including the ones with no contact" % (a, b, trial))
            continue
        row = by_key[key]

        asf_a, asf_b, amc_a, amc_b = C.load_pair(a, b, trial)
        n = min(len(amc_a), len(amc_b))
        if len(amc_a) != len(amc_b):
            out.append("%s/%s_%s: the two .amc files disagree on frame count "
                       "(A=%d B=%d)  -  say so in the memo rather than truncating silently"
                       % (a, b, trial, len(amc_a), len(amc_b)))

        series = []
        labels = []
        for i in range(n):
            pa = C.joint_world_positions(asf_a, amc_a[i])
            pb = C.joint_world_positions(asf_b, amc_b[i])
            cands = []
            for h in HANDS:
                for e in ELBOWS:
                    if h in pa and e in pb:
                        cands.append((C.dist(pa[h], pb[e]), "A.%s->B.%s" % (h, e)))
                    if h in pb and e in pa:
                        cands.append((C.dist(pb[h], pa[e]), "B.%s->A.%s" % (h, e)))
            cands.sort()
            series.append(cands[0][0])
            labels.append(cands[0][1])

        grip = sum(1 for d in series if d <= GRIP_MAX_M)
        grip_populations.append((a, b, trial, grip, n))

        ordered = sorted(series)
        pct = C.percentiles(ordered)

        if int(row["frames"]) != n:
            out.append("%s/%s_%s: frames=%s in the CSV, %d in the capture"
                       % (a, b, trial, row["frames"], n))
        if int(row["grip_frames"]) != grip:
            out.append("%s/%s_%s: grip_frames=%s in the CSV, %d recomputed at <= %.2f m"
                       % (a, b, trial, row["grip_frames"], grip, GRIP_MAX_M))

        eps, longest = _episodes(series, GRIP_MAX_M)
        if int(row["episodes"]) != eps:
            out.append("%s/%s_%s: episodes=%s in the CSV, %d recomputed"
                       % (a, b, trial, row["episodes"], eps))
        if int(row["longest_episode_frames"]) != longest:
            out.append("%s/%s_%s: longest_episode_frames=%s in the CSV, %d recomputed"
                       % (a, b, trial, row["longest_episode_frames"], longest))
        if longest > grip:
            out.append("%s/%s_%s: longest episode %d exceeds grip_frames %d"
                       % (a, b, trial, longest, grip))

        # Which limbs touch, over the GRIP frames only.
        tally = {}
        for d, lab in zip(series, labels):
            if d <= GRIP_MAX_M:
                tally[lab] = tally.get(lab, 0) + 1
        if grip == 0:
            want_pair, want_share = "none", 0.0
        else:
            want_pair = max(sorted(tally), key=lambda k: tally[k])
            want_share = tally[want_pair] / float(grip)
        if row["dominant_pair"].strip() != want_pair:
            out.append("%s/%s_%s: dominant_pair=%r in the CSV, %r recomputed"
                       % (a, b, trial, row["dominant_pair"].strip(), want_pair))
        if abs(float(row["dominant_pair_share"]) - want_share) > 0.001:
            out.append("%s/%s_%s: dominant_pair_share=%.4f in the CSV, %.4f recomputed"
                       % (a, b, trial, float(row["dominant_pair_share"]), want_share))

        for col, point in (("min_m", 0), ("p10_m", 10), ("p50_m", 50),
                           ("p90_m", 90), ("max_m", 100)):
            claimed = float(row[col])
            real = pct[point]
            if abs(claimed - real) > TOL_M:
                out.append("%s/%s_%s: %s=%.4f in the CSV, %.4f recomputed (%.1f mm apart)"
                           % (a, b, trial, col, claimed, real,
                              abs(claimed - real) * 1000.0))

    # ---- NON-VACUITY. A census that labels every frame a grip has measured
    # nothing, and so has one that labels none. Both are real in this corpus:
    # 18/19_06 is in contact for most of its length and 18/19_04 never gets
    # inside 0.24 m at all, so the census MUST separate them.
    if grip_populations:
        with_grip = [g for g in grip_populations if g[3] > 0]
        without = [g for g in grip_populations if g[3] == 0]
        if len(with_grip) < 2:
            out.append("NON-VACUITY: fewer than two trials report any grip frame at "
                       "<= %.2f m. The census is not discriminating." % GRIP_MAX_M)
        if not without:
            out.append("NON-VACUITY: every trial reports a grip. At least one of these "
                       "captures never brings a hand within %.2f m of an elbow, so a "
                       "census that grips everywhere is measuring the threshold, not "
                       "the corpus." % GRIP_MAX_M)
        for a, b, trial, grip, n in grip_populations:
            if grip > n:
                out.append("%s/%s_%s: grip_frames %d exceeds frames %d" % (a, b, trial, grip, n))

    # ---- THE POPULATION MUST BE NAMED IN THE MEMO'S OWN OUTPUT (standing rule).
    if os.path.exists(MD_PATH):
        text = open(MD_PATH, encoding="utf-8").read()
        for token in ("18", "19", "22", "23", "lwrist", "lradius"):
            if token not in text:
                out.append("%s never names '%s'  -  a measurement must name its "
                           "population and the bones it measured"
                           % (os.path.relpath(MD_PATH, REPO), token))
        if "NEVER TEST IDENTICAL" not in text.upper() and "differ" not in text.lower():
            out.append("%s must state that the two subjects in each pair are "
                       "DIFFERENT skeletons  -  `cmu_asf_amc.skeletons_differ` "
                       "proves it and it is the fixture's whole validity"
                       % os.path.relpath(MD_PATH, REPO))

    return out


def main():
    problems = failures()
    if problems:
        print("Q122 GATE: FAIL (%d)" % len(problems))
        for p in problems:
            print("  - %s" % p)
        return 1
    print("Q122 GATE: PASS  -  census agrees with an independent recomputation "
          "on all %d paired trials, to %.0f mm." % (len(PAIRS), TOL_M * 1000))
    return 0


if __name__ == "__main__":
    sys.exit(main())
