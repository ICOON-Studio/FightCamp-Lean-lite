"""fight_motion_rulers.py - the fight-motion numbers of one filmed round (S496 FIGHT MOTION WEEK, TASK_MOTIONRULER1).

The owner (S496): "The fight looks terrible should we stop this project?" -> "One week code push". Two blind critics score
the whole fight before and after; these numbers are read from the same film log, so every round compares like for like.
Reads the shown.csv tools/human_fight_film.gd writes (one row per drawn frame per boxer; positions in metres, y up).

    python tools/fight_motion_rulers.py <shown.csv> [--fps 30] [--json out.json]
    python tools/fight_motion_rulers.py --compare <a.csv> <b.csv> [--labels before,after]

Rulers: 1 reaction delay (frames from a punch's contact to the hit head's furthest point), 2 reactions cut by the hit
boxer's own punch, 3 head jumps > 12 cm in one frame by cause, 4 arm left out after contact, 5 spacing, 6 steps, 7 waiting.
"""
import csv
import json
import math
import statistics
import sys

JUMP_M = 0.12            # a head moving more than this in one 30 fps frame is a jump (3.6 m/s)
REACT_WINDOW = 15        # frames after contact searched for the reaction's furthest point
REACT_LATE = 4           # a reaction whose furthest point comes later than this many frames reads unrelated to the punch
CUT_WINDOW = 6           # the hit boxer throwing within this many frames cuts his reaction off
ARM_KEEP = 0.90          # arm still "out" while its length is >= 90 % of its length at contact
HEADS_CLOSE_M = 0.25
TRUNK_CLOSE_M = 0.22
STEP_LIFT_M = 0.03
STEP_MIN_FRAMES = 3
PUNCH_WORDS = ("jab", "cross", "hook", "uppercut", "body_shot", "kidney")
REACT_PREFIX = ("pro_hit", "react_", "mc_hit")
WAIT_WORDS = ("idle", "fidget", "bounce")


def _v(r, bone):
    return (float(r[bone + "_x"]), float(r[bone + "_y"]), float(r[bone + "_z"]))


def _sub(a, b):
    return tuple(x - y for x, y in zip(a, b))


def is_punch(clip):
    return not clip.startswith(REACT_PREFIX) and any(w in clip for w in PUNCH_WORDS)


def is_react(clip):
    return clip.startswith(REACT_PREFIX)


def punch_hand(clip):
    if "kidney" in clip:
        return "RightHand"
    return "LeftHand" if ("left" in clip or "jab" in clip or "body_shot" in clip) else "RightHand"


def load(path):
    """{who: [row, ...] in frame order}, {frame: {who: row}}."""
    by_who, by_frame = {}, {}
    with open(path, newline="") as f:
        for r in csv.DictReader(f):
            r["_f"] = int(r["frame"])
            by_who.setdefault(r["who"], []).append(r)
            by_frame.setdefault(r["_f"], {})[r["who"]] = r
    for rows in by_who.values():
        rows.sort(key=lambda x: x["_f"])
    return by_who, by_frame


def _pct(xs, p):
    if not xs:
        return 0.0
    s = sorted(xs)
    return s[min(len(s) - 1, int(p * (len(s) - 1) + 0.5))]


def _seg_dist(p, a, b):
    ab, ap = _sub(b, a), _sub(p, a)
    den = sum(x * x for x in ab) or 1e-9
    t = max(0.0, min(1.0, sum(x * y for x, y in zip(ab, ap)) / den))
    return math.dist(p, tuple(a[i] + t * ab[i] for i in range(3)))


def contacts(rows):
    """Indexes into one boxer's rows where its hold goes 0 -> 1 (a punch's contact frame)."""
    return [i for i in range(1, len(rows)) if rows[i]["hold"] == "1" and rows[i - 1]["hold"] == "0"]


def measure(path, fps=30.0):
    by_who, by_frame = load(path)
    out = {"file": path, "fps": fps, "boxers": {}}
    delays, peaks, cuts, n_react = [], [], 0, 0
    arm_out = []
    jumps = {"contact": 0, "clip change": 0, "inside clip": 0}
    worst_jumps, head_steps = [], []
    react_rows = []
    for who, rows in by_who.items():
        idx = {r["_f"]: i for i, r in enumerate(rows)}
        cs = set(contacts(rows))
        # 3 head jumps
        for i in range(1, len(rows)):
            if rows[i]["_f"] != rows[i - 1]["_f"] + 1:
                continue
            d = math.dist(_v(rows[i], "Head"), _v(rows[i - 1], "Head"))
            head_steps.append(d)
            if d > JUMP_M:
                cause = "contact" if i in cs else ("clip change" if rows[i]["clip"] != rows[i - 1]["clip"] else "inside clip")
                jumps[cause] += 1
                worst_jumps.append((d, float(rows[i]["film_s"]), who, rows[i]["clip"], cause))
        for i in sorted(cs):
            r = rows[i]
            # 1 + 2: this boxer was hit
            if is_react(r["clip"]):
                n_react += 1
                rel0 = _sub(_v(r, "Head"), _v(r, "Hips"))
                best, best_k = 0.0, 0
                for k in range(1, REACT_WINDOW + 1):
                    j = idx.get(r["_f"] + k)
                    if j is None:
                        break
                    q = rows[j]
                    if q["clip"] != r["clip"]:
                        break   # the reaction ended (cut by her own punch, a new hit, guard): its peak is what it reached
                    d = math.dist(_sub(_v(q, "Head"), _v(q, "Hips")), rel0)
                    if d > best:
                        best, best_k = d, k
                delays.append(best_k)
                peaks.append(best)
                react_rows.append((float(r["film_s"]), who, r["clip"], round(best * 100, 1), best_k))
                for k in range(1, CUT_WINDOW + 1):
                    j = idx.get(r["_f"] + k)
                    if j is not None and is_punch(rows[j]["clip"]):
                        cuts += 1
                        break
            # 4: this boxer landed a punch
            if is_punch(r["clip"]):
                hand = punch_hand(r["clip"])
                l0 = math.dist(_v(r, hand), _v(r, "Head"))
                n = 0
                for k in range(1, 30):
                    j = idx.get(r["_f"] + k)
                    if j is None or math.dist(_v(rows[j], hand), _v(rows[j], "Head")) < ARM_KEEP * l0:
                        break
                    n += 1
                arm_out.append(n)
        # 6 steps + 7 waiting, per boxer
        b = {}
        steps, lift = 0, 0.0
        for foot in ("LeftFoot", "RightFoot"):
            ys = [float(q[foot + "_y"]) for q in rows]
            rest = _pct(ys, 0.05)
            run = 0
            for y in ys + [rest]:
                if y > rest + STEP_LIFT_M:
                    run += 1
                    lift = max(lift, y - rest)
                else:
                    if run >= STEP_MIN_FRAMES:
                        steps += 1
                    run = 0
        minutes = len(rows) / fps / 60.0 or 1.0
        b["steps_per_min"] = round(steps / minutes, 1)
        b["highest_lift_cm"] = round(lift * 100, 1)
        wait = [any(w in q["clip"] for w in WAIT_WORDS) for q in rows]
        longest, run = 0, 0
        for w in wait:
            run = run + 1 if w else 0
            longest = max(longest, run)
        b["waiting_pct"] = round(100.0 * sum(wait) / max(1, len(rows)), 1)
        b["longest_wait_s"] = round(longest / fps, 2)
        b["punching_pct"] = round(100.0 * sum(is_punch(q["clip"]) for q in rows) / max(1, len(rows)), 1)
        out["boxers"][who] = b
    # 5 spacing
    hips, heads_close, trunk_close, n_both = [], 0, 0, 0
    for f, d in by_frame.items():
        if "0" not in d or "1" not in d:
            continue
        n_both += 1
        a, c = d["0"], d["1"]
        ha, hc = _v(a, "Hips"), _v(c, "Hips")
        hips.append(math.dist((ha[0], ha[2]), (hc[0], hc[2])))
        if math.dist(_v(a, "Head"), _v(c, "Head")) < HEADS_CLOSE_M:
            heads_close += 1
        for p, q in ((a, c), (c, a)):
            if _seg_dist(_v(p, "Head"), _v(q, "Hips"), _v(q, "Head")) < TRUNK_CLOSE_M:
                trunk_close += 1
    worst_jumps.sort(reverse=True)
    out.update({
        "reactions": n_react,
        "react_delay_median_frames": statistics.median(delays) if delays else 0,
        "react_delay_worst_frames": max(delays) if delays else 0,
        "react_late_count": sum(1 for d in delays if d > REACT_LATE),
        "react_peak_median_cm": round(statistics.median(peaks) * 100, 1) if peaks else 0.0,
        "react_cut_count": cuts,
        "react_list": react_rows,
        "head_jumps_contact": jumps["contact"],
        "head_jumps_clip_change": jumps["clip change"],
        "head_jumps_inside_clip": jumps["inside clip"],
        "head_jumps_total": sum(jumps.values()),
        "head_jump_worst_cm": round(worst_jumps[0][0] * 100, 1) if worst_jumps else 0.0,
        "head_p99_cm": round(_pct(head_steps, 0.99) * 100, 1),
        "worst_jumps": [(round(d * 100, 1), s, w, c, why) for d, s, w, c, why in worst_jumps[:5]],
        "arm_out_median_frames": statistics.median(arm_out) if arm_out else 0,
        "arm_out_worst_frames": max(arm_out) if arm_out else 0,
        "hips_apart_p10_m": round(_pct(hips, 0.10), 2),
        "hips_apart_p50_m": round(_pct(hips, 0.50), 2),
        "hips_apart_p90_m": round(_pct(hips, 0.90), 2),
        "heads_close_pct": round(100.0 * heads_close / max(1, n_both), 2),
        "head_in_trunk_frames": trunk_close,
    })
    return out


SUMMARY = [
    ("react_delay_median_frames", "reaction: frames from contact to the hit head's furthest point (median)"),
    ("react_delay_worst_frames", "reaction: worst delay (frames)"),
    ("react_late_count", "reactions later than %d frames" % REACT_LATE),
    ("react_peak_median_cm", "reaction: how far the hit head moves (median cm)"),
    ("react_cut_count", "reactions cut by the hit boxer's own punch"),
    ("head_jumps_total", "head jumps > %d cm in one frame" % int(JUMP_M * 100)),
    ("head_jumps_contact", "  of them on the contact frame"),
    ("head_jumps_clip_change", "  of them at a clip change"),
    ("head_jumps_inside_clip", "  of them inside a clip"),
    ("head_jump_worst_cm", "worst head jump (cm)"),
    ("head_p99_cm", "head per frame p99 (cm)"),
    ("arm_out_median_frames", "arm left out after contact (median frames)"),
    ("arm_out_worst_frames", "arm left out after contact (worst frames)"),
    ("hips_apart_p50_m", "distance between the boxers p50 (m)"),
    ("heads_close_pct", "heads closer than 25 cm (% of frames)"),
    ("head_in_trunk_frames", "a head inside the other's body (frames)"),
]
PER_BOXER = [("waiting_pct", "waiting in guard (%)"), ("longest_wait_s", "longest wait (s)"),
             ("punching_pct", "punching (%)"), ("steps_per_min", "steps a minute"), ("highest_lift_cm", "highest foot lift (cm)")]


def report(m):
    lines = ["FIGHT MOTION RULERS  %s" % m["file"]]
    for k, label in SUMMARY:
        lines.append("  %-70s %s" % (label, m[k]))
    for k, label in PER_BOXER:
        lines.append("  %-70s %s" % (label + " boxer 0 / 1", " / ".join(str(m["boxers"].get(w, {}).get(k, "-")) for w in ("0", "1"))))
    lines.append("  reactions (film s, who, clip, cm, frames to peak):")
    lines += ["    %s" % (r,) for r in m["react_list"]]
    lines.append("  worst head jumps (cm, film s, who, clip, cause):")
    lines += ["    %s" % (j,) for j in m["worst_jumps"]]
    return "\n".join(lines)


def compare(a, b, labels=("before", "after")):
    lines = ["%-70s %10s %10s" % ("FIGHT MOTION COMPARE", labels[0], labels[1])]
    for k, label in SUMMARY:
        lines.append("%-70s %10s %10s" % (label, a[k], b[k]))
    for k, label in PER_BOXER:
        for w in ("0", "1"):
            lines.append("%-70s %10s %10s" % ("%s boxer %s" % (label, w), a["boxers"].get(w, {}).get(k, "-"), b["boxers"].get(w, {}).get(k, "-")))
    return "\n".join(lines)


def _arg(flag, default):
    return sys.argv[sys.argv.index(flag) + 1] if flag in sys.argv else default


def main():
    fps = float(_arg("--fps", 30))
    if "--compare" in sys.argv:
        i = sys.argv.index("--compare")
        a, b = measure(sys.argv[i + 1], fps), measure(sys.argv[i + 2], fps)
        print(compare(a, b, tuple(_arg("--labels", "before,after").split(","))))
        return 0
    if len(sys.argv) < 2:
        print(__doc__)
        return 2
    m = measure(sys.argv[1], fps)
    print(report(m))
    out = _arg("--json", "")
    if out:
        with open(out, "w") as f:
            json.dump(m, f, indent=1)
    return 0


if __name__ == "__main__":
    sys.exit(main())
