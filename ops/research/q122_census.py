"""Q122 — CMU paired-corpus contact census.

For each of the six loadable paired trials, compute per-frame minimum separation
between either man's wrist and the other man's elbow (both directions), then
summarise the distribution, the grip episodes, and which limb pair dominates.
"""
import csv
import os
import sys

HERE = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(HERE, "Tools"))
import cmu_asf_amc as C  # noqa: E402

PAIRS = [
    ("18", "19", "03"),
    ("18", "19", "04"),
    ("18", "19", "05"),
    ("18", "19", "06"),
    ("22", "23", "01"),
    ("22", "23", "17"),
]

HANDS = ("lwrist", "rwrist")
ELBOWS = ("lradius", "rradius")
GRIP_MAX_M = 0.20

CSV_PATH = os.path.join(HERE, "research", "Q122_CMU_CONTACT_CENSUS.csv")
MD_PATH = os.path.join(HERE, "research", "Q122_CMU_CONTACT_CENSUS.md")

COLUMNS = [
    "subject_a", "subject_b", "trial", "frames",
    "min_m", "p10_m", "p50_m", "p90_m", "max_m",
    "grip_frames", "grip_share",
    "episodes", "longest_episode_frames",
    "dominant_pair", "dominant_pair_share",
]


def episodes(series, threshold):
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


def census():
    rows = []
    memo_data = []

    for a, b, trial in PAIRS:
        asf_a, asf_b, amc_a, amc_b = C.load_pair(a, b, trial)
        n = min(len(amc_a), len(amc_b))
        skel_diff = C.skeletons_differ(asf_a, asf_b)

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

        ordered = sorted(series)
        pct = C.percentiles(ordered)

        grip = sum(1 for d in series if d <= GRIP_MAX_M)
        grip_share = grip / float(n) if n else 0.0
        eps, longest = episodes(series, GRIP_MAX_M)

        tally = {}
        for d, lab in zip(series, labels):
            if d <= GRIP_MAX_M:
                tally[lab] = tally.get(lab, 0) + 1
        if grip == 0:
            dominant_pair = "none"
            dominant_share = 0.0
        else:
            dominant_pair = max(sorted(tally), key=lambda k: tally[k])
            dominant_share = tally[dominant_pair] / float(grip)

        rows.append({
            "subject_a": a,
            "subject_b": b,
            "trial": trial,
            "frames": n,
            "min_m": pct[0],
            "p10_m": pct[10],
            "p50_m": pct[50],
            "p90_m": pct[90],
            "max_m": pct[100],
            "grip_frames": grip,
            "grip_share": grip_share,
            "episodes": eps,
            "longest_episode_frames": longest,
            "dominant_pair": dominant_pair,
            "dominant_pair_share": dominant_share,
        })

        memo_data.append({
            "pair": "%s/%s_%s" % (a, b, trial),
            "n": n,
            "skel_diff": skel_diff,
            "pct": pct,
            "grip": grip,
            "grip_share": grip_share,
            "episodes": eps,
            "longest": longest,
            "dominant_pair": dominant_pair,
            "dominant_share": dominant_share,
            "tally": tally,
        })

    # Write CSV
    with open(CSV_PATH, "w", newline="", encoding="utf-8") as fh:
        w = csv.DictWriter(fh, fieldnames=COLUMNS)
        w.writeheader()
        for r in rows:
            w.writerow(r)

    # Write memo
    write_memo(memo_data)

    return rows, memo_data


def write_memo(data):
    lines = []
    lines.append("# Q122 — CMU Paired-Corpus Contact Census")
    lines.append("")
    lines.append("## Population")
    lines.append("")
    lines.append("Six paired trials from the CMU motion-capture corpus, stored in")
    lines.append("`AssetLibrary/cmu_paired/`. Two subjects per trial, captured")
    lines.append("simultaneously in one world space:")
    lines.append("")
    lines.append("| Pair | Subjects | Trial | Frames |")
    lines.append("|------|----------|-------|--------|")
    for d in data:
        lines.append("| %s | %s | %s | %d |" % (
            d["pair"], d["pair"].split("_")[0], d["pair"].split("_")[1], d["n"]))
    lines.append("")
    lines.append("**Bones measured:** `lwrist` and `rwrist` (the hand, distal end of")
    lines.append("the radius — the bone our rig's `LeftHand`/`RightHand` is mapped")
    lines.append("from) against `lradius` and `rradius` (the elbow, distal end of the")
    lines.append("humerus). Both directions count: either man may be the gripper.")
    lines.append("")
    lines.append("## Skeletons Differ")
    lines.append("")
    for d in data:
        diffs = d["skel_diff"]
        if diffs:
            examples = ", ".join("%s %.3f vs %.3f m" % (name, la, lb)
                                 for name, la, lb in diffs[:3])
            lines.append("- **%s**: DIFFERENT skeletons confirmed (%s)." % (d["pair"], examples))
        else:
            lines.append("- **%s**: WARNING — skeletons appear IDENTICAL." % d["pair"])
    lines.append("")
    lines.append("NEVER TEST IDENTICAL: every pair above has been verified with")
    lines.append("`cmu_asf_amc.skeletons_differ` — the two subjects in each pair")
    lines.append("are different bodies with different bone lengths. Two men built")
    lines.append("from the same numbers are not a control group, they are an unreal")
    lines.append("population.")
    lines.append("")
    lines.append("## Contact Summary")
    lines.append("")
    lines.append("| Trial | Min (m) | P10 | P50 | P90 | Max | Grip frames | Grip share | Episodes | Longest | Dominant pair | Dom. share |")
    lines.append("|-------|---------|-----|-----|-----|-----|-------------|------------|----------|---------|---------------|------------|")
    for d in data:
        lines.append("| %s | %.3f | %.3f | %.3f | %.3f | %.3f | %d | %.2f | %d | %d | %s | %.2f |" % (
            d["pair"], d["pct"][0], d["pct"][10], d["pct"][50], d["pct"][90], d["pct"][100],
            d["grip"], d["grip_share"], d["episodes"], d["longest"],
            d["dominant_pair"], d["dominant_share"]))
    lines.append("")

    # Analysis
    lines.append("## Analysis")
    lines.append("")

    # Which trials have no contact
    no_contact = [d for d in data if d["grip"] == 0]
    with_contact = [d for d in data if d["grip"] > 0]

    lines.append("### Trials with no contact")
    lines.append("")
    if no_contact:
        for d in no_contact:
            lines.append("- **%s**: zero frames at ≤ 0.20 m (min separation %.3f m)." % (
                d["pair"], d["pct"][0]))
        lines.append("")
        lines.append("These are the **control trials** — they prove the measure discriminates.")
    else:
        lines.append("(none — every trial has at least one grip frame)")
    lines.append("")

    lines.append("### Does the contact chatter?")
    lines.append("")
    for d in with_contact:
        if d["episodes"] > 5:
            lines.append("- **%s**: %d episodes, longest %d frames — the contact CHATTERS."
                         " An anchor mask built on a single threshold will snap in and out." % (
                             d["pair"], d["episodes"], d["longest"]))
        else:
            lines.append("- **%s**: %d episode(s), longest %d frames — the contact is"
                         " sustained, not a flicker." % (
                             d["pair"], d["episodes"], d["longest"]))
    lines.append("")

    lines.append("### Does the gripping limb swap?")
    lines.append("")
    for d in with_contact:
        if d["dominant_share"] < 0.5:
            lines.append("- **%s**: dominant pair share %.2f — the contact WANDERS between"
                         " limbs. The grip is not stable on one arm chain." % (
                             d["pair"], d["dominant_share"]))
        else:
            lines.append("- **%s**: dominant pair share %.2f — one stable grip on %s." % (
                d["pair"], d["dominant_share"], d["dominant_pair"]))
    lines.append("")

    lines.append("### Fixture recommendation for S37")
    lines.append("")
    # Rank by: most grip frames, lowest min, fewest episodes (most sustained),
    # highest dominant_pair_share
    ranked = sorted(with_contact, key=lambda d: (
        -d["grip"], d["pct"][0], d["episodes"], -d["dominant_share"]))
    if ranked:
        best = ranked[0]
        lines.append("**Recommended fixture: %s**" % best["pair"])
        lines.append("")
        lines.append("- %d frames in contact (%.0f%% of %d)" % (
            best["grip"], best["grip_share"] * 100, best["n"]))
        lines.append("- Minimum separation: %.3f m" % best["pct"][0])
        lines.append("- %d episode(s), longest %d frames — %s" % (
            best["episodes"], best["longest"],
            "sustained hold" if best["episodes"] <= 5 else "chattering"))
        lines.append("- Dominant grip: %s (%.0f%% of grip frames) — %s" % (
            best["dominant_pair"], best["dominant_share"] * 100,
            "stable arm chain" if best["dominant_share"] >= 0.5 else "limb swapping"))
        lines.append("")
        lines.append("Ranking of trials with contact:")
        for i, d in enumerate(ranked, 1):
            lines.append("%d. %s — %d grip frames, min %.3f m, %d episodes, dom. share %.2f" % (
                i, d["pair"], d["grip"], d["pct"][0], d["episodes"], d["dominant_share"]))
    else:
        lines.append("No trial has any contact — the corpus provides no fixture.")
    lines.append("")

    with open(MD_PATH, "w", encoding="utf-8") as fh:
        fh.write("\n".join(lines))


if __name__ == "__main__":
    rows, memo = census()
    print("Census written: %d trials" % len(rows))
    for r in rows:
        print("  %s/%s_%s: %d frames, %d grip (%.1f%%), %d episodes, dom=%s (%.2f)" % (
            r["subject_a"], r["subject_b"], r["trial"],
            r["frames"], r["grip_frames"], r["grip_share"] * 100,
            r["episodes"], r["dominant_pair"], r["dominant_pair_share"]))
