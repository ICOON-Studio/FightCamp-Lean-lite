"""Q123_check.py - the gate for TASK_Q123 (clinch ARM geometry from the paired corpus).

WHY THIS DERIVES RATHER THAN READS. A gate that learns its expected values from
the file it is judging cannot fail (recorded rule, and it has bitten this project
before). So this script does NOT trust Q123_clinch_arms.json for any headline
figure: it re-runs pair_world on the named tracks, re-selects the clinch frames
by the SAME published rule Q115 fixed (hip-midpoint 3D separation <= 0.80 m,
after the >= 0.40 m implausibility filter), recomputes every percentile from
those frames, and only then compares. The JSON is the claim; the tracks are the
evidence.

WHAT IT REFUSES, and why each one is here:
  1. A figure in the digest that is not in the JSON, or differs from it.
  2. A figure in the JSON that this script cannot reproduce from the tracks
     within 1 mm.
  3. A relative measurement with no absolute one beside it. S37's delivered
     pose reported "hip separation exactly 0.72 m" while both men were 0.596 m
     tall and one had his head below his feet - a separation is a DIFFERENCE and
     common-mode error cancels inside it. So a nose-to-ankle height per tracked
     person is mandatory, and it must be human-sized.

Y RUNS DOWN IN THIS FRAME, AND pair_world.py:41 SAYS THE OPPOSITE. Measured
2026-09-21 on -vPZqptk8jo frame 0: nose y = -1.272, left ankle y = +0.042. The
floor really is near y = 0 as documented, but "y - up" is wrong - more NEGATIVE
is higher. Anything asking "is the hand above the neck?" gets the answer
backwards if it trusts that line. This gate was written trusting it and the
absolute control below is what caught it.
  4. An unnamed population. The clip ids must be in the digest text.

Usage:  python research/Q123_check.py
Prints Q123_CHECK PASS, or one FAIL line per violation and exits 1.
"""
from __future__ import annotations

import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
TOOLS = os.path.abspath(os.path.join(HERE, "..", "..", "Tools", "footage"))
sys.path.insert(0, TOOLS)
import pair_world as pw  # noqa: E402

TRACK_DIR = r"C:\Users\user\AppData\Local\Temp\FightCamp-footage\track"
JSON_PATH = os.path.join(HERE, "Q123_clinch_arms.json")
DIGEST_PATH = os.path.join(HERE, "Q123_CLINCH_ARM_GEOMETRY.md")

# The population, fixed here so the agent cannot quietly change it.
CLIPS = ["-vPZqptk8jo", "HL261oRyURE", "FCM7m6TJWUQ"]

# Q115's published clinch rule. Not re-derived here on purpose - it is a
# SETTLED definition and this task measures arms inside it, not the threshold.
CLINCH_MAX_M = 0.80
IMPLAUSIBLE_MIN_M = 0.40

NOSE = 0
L_SH, R_SH = 11, 12
L_ELB, R_ELB = 13, 14
L_WR, R_WR = 15, 16
L_HIP, R_HIP = 23, 24
L_ANK, R_ANK = 27, 28

TOL_M = 0.001
FAILS: list[str] = []


def fail(msg: str) -> None:
    FAILS.append(msg)


def mid(j, a, b):
    return (j[:, a] + j[:, b]) / 2.0


def neck(j):
    """Neck proxy: the shoulder midpoint. MediaPipe has no neck landmark, so the
    digest must say this - it is checked below."""
    return mid(j, L_SH, R_SH)


def collect():
    """Re-derive every clinch-frame arm figure straight from the tracks."""
    rows: dict[str, list] = {
        "hand_to_opp_neck_m": [],
        "nearest_hand_to_opp_neck_m": [],
        "hand_minus_neck_height_m": [],
        "hip_sep_m": [],
        "stature_m": [],
        # The pair the Dola clinch script asserts on: one man's lead hand to
        # the OTHER man's opposite hand. Measured here so that assertion can be
        # judged against the corpus instead of against intuition.
        "hand_to_opp_hand_m": [],
    }
    per_clip: dict[str, int] = {}
    for clip in CLIPS:
        path = os.path.join(TRACK_DIR, clip + ".npz")
        if not os.path.exists(path):
            fail(f"track missing, cannot verify: {path}")
            continue
        tr = np.load(path)
        t_arr = tr["t"]
        out = pw.reconstruct_clip(
            t_arr, tr["img"], tr["world"], tr["n"], float(tr["fps"]),
            clip, float(t_arr[0]), float(t_arr[-1]),
        )
        j_all = out["joints"]
        two = out["n_fighters"] == 2
        j = j_all[two]
        if j.shape[0] == 0:
            per_clip[clip] = 0
            continue

        hm0, hm1 = mid(j[:, 0], L_HIP, R_HIP), mid(j[:, 1], L_HIP, R_HIP)
        hip_sep = np.linalg.norm(hm1 - hm0, axis=1)
        keep = (hip_sep >= IMPLAUSIBLE_MIN_M) & (hip_sep <= CLINCH_MAX_M)
        per_clip[clip] = int(keep.sum())
        if keep.sum() == 0:
            continue

        jc = j[keep]
        rows["hip_sep_m"].extend(hip_sep[keep].tolist())

        n0, n1 = neck(jc[:, 0]), neck(jc[:, 1])
        for me, opp_neck in ((0, n1), (1, n0)):
            for wr in (L_WR, R_WR):
                d = np.linalg.norm(jc[:, me, wr] - opp_neck, axis=1)
                rows["hand_to_opp_neck_m"].extend(d.tolist())
                # y RUNS DOWN in pair_world's frame - the stature control
                # below is what proved it, and it is why that control exists.
                # Positive here therefore means the hand is BELOW the neck.
                rows["hand_minus_neck_height_m"].extend(
                    (jc[:, me, wr, 1] - opp_neck[:, 1]).tolist()
                )
            best = np.minimum(
                np.linalg.norm(jc[:, me, L_WR] - opp_neck, axis=1),
                np.linalg.norm(jc[:, me, R_WR] - opp_neck, axis=1),
            )
            rows["nearest_hand_to_opp_neck_m"].extend(best.tolist())
            other = 1 - me
            for wr in (L_WR, R_WR):
                for owr in (L_WR, R_WR):
                    rows["hand_to_opp_hand_m"].extend(
                        np.linalg.norm(jc[:, me, wr] - jc[:, other, owr],
                                       axis=1).tolist()
                    )
            # absolute control: is this a human-sized person at all?
            ank = np.maximum(jc[:, me, L_ANK, 1], jc[:, me, R_ANK, 1])
            rows["stature_m"].extend((ank - jc[:, me, NOSE, 1]).tolist())
    return rows, per_clip


def pct(v, q):
    return float(np.percentile(np.asarray(v, dtype=float), q))


def main() -> int:
    if not os.path.exists(JSON_PATH):
        print(f"Q123_CHECK FAIL missing {JSON_PATH}")
        return 1
    if not os.path.exists(DIGEST_PATH):
        print(f"Q123_CHECK FAIL missing {DIGEST_PATH}")
        return 1

    claim = json.load(open(JSON_PATH, encoding="utf-8"))
    digest = open(DIGEST_PATH, encoding="utf-8").read()

    rows, per_clip = collect()
    if FAILS:
        for f in FAILS:
            print("Q123_CHECK FAIL " + f)
        return 1

    n_clinch = len(rows["hip_sep_m"])
    if n_clinch < 20:
        print(f"Q123_CHECK FAIL only {n_clinch} clinch frames found across "
              f"{len(CLIPS)} clips - too few to report percentiles")
        return 1

    # 1. every headline figure must reproduce from the tracks
    want = {}
    for key in ("hand_to_opp_neck_m", "nearest_hand_to_opp_neck_m",
                "hand_minus_neck_height_m", "hip_sep_m", "stature_m",
                "hand_to_opp_hand_m"):
        for q in (10, 50, 90):
            want[f"{key}_p{q}"] = pct(rows[key], q)

    for k, v in sorted(want.items()):
        if k not in claim:
            fail(f"JSON has no key {k}")
            continue
        got = float(claim[k])
        if abs(got - v) > TOL_M:
            fail(f"{k}: JSON says {got:.4f} m, tracks give {v:.4f} m")

    # 2. frame count must match
    if int(claim.get("clinch_frames", -1)) != n_clinch:
        fail(f"clinch_frames: JSON says {claim.get('clinch_frames')}, "
             f"tracks give {n_clinch}")

    # 3. ABSOLUTE control beside the relative one (the S37 lesson).
    # NOTE this is NOSE-TO-ANKLE, not stature: the crown sits ~0.12 m above the
    # nose and the ankle ~0.07 m above the floor, so a 1.80 m man should read
    # about 1.61 m here. The band is deliberately WIDE because the corpus reads
    # 1.31-1.37 m - about 15-20% short - which is itself a finding the digest is
    # required to carry. Narrow this only when the scale question is settled.
    st50 = want["stature_m_p50"]
    if not (1.20 <= st50 <= 1.90):
        fail(f"nose-to-ankle p50 {st50:.3f} m is not a human - the "
             f"reconstruction is wrong and every separation here is suspect")
    if st50 < 1.50 and "scale" not in digest.lower():
        fail(f"nose-to-ankle p50 is {st50:.3f} m where a 1.80 m man reads "
             f"~1.61 m, so this corpus under-reads metric scale by roughly "
             f"15-20%. The digest MUST discuss that scale caveat - every metre "
             f"figure in it, and Q115's published 0.719 m, inherits it.")

    # 4. the population must be named in the digest
    for clip in CLIPS:
        if clip not in digest:
            fail(f"digest never names clip {clip} - an unnamed population")

    # 5. the neck proxy must be disclosed, not implied
    low = digest.lower()
    if "shoulder midpoint" not in low:
        fail("digest must state that the neck is the SHOULDER MIDPOINT - "
             "MediaPipe has no neck landmark and a reader will assume one")

    # 6. every headline figure must also appear in the digest text
    for k in ("nearest_hand_to_opp_neck_m_p50", "hand_minus_neck_height_m_p50"):
        s = f"{want[k]:.3f}"
        if s not in digest and f"{want[k]:.2f}" not in digest:
            fail(f"digest never prints {k} ({s} m)")

    if FAILS:
        for f in FAILS:
            print("Q123_CHECK FAIL " + f)
        return 1

    print(f"Q123_CHECK clinch frames {n_clinch} " +
          " ".join(f"{c}={per_clip.get(c, 0)}" for c in CLIPS))
    print(f"Q123_CHECK nearest hand->opponent neck p50 "
          f"{want['nearest_hand_to_opp_neck_m_p50']:.3f} m, "
          f"hand height minus neck p50 "
          f"{want['hand_minus_neck_height_m_p50']:.3f} m, "
          f"stature p50 {st50:.3f} m")
    print("Q123_CHECK PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
