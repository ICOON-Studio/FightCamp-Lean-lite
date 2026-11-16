"""knee_ruler.py - the knee numbers of one filmed fight round (S498 ZIVAKNEE1).

The animator critic of the filmed bout (FIGHT MOTION WEEK, S496) scored point 7 "knee jitter": knee shake 4.4-5.6 deg
RMS (second difference of the knee angle, 30 fps) and 2.7-3.8 deg with the foot planted, 223-328 jerks over 8 deg in a
75 s round - about 4 a second per knee, "the footwork IK is fighting the clip" - and a median knee bend of 122-125 deg
where a boxing stance sits at 140-150. This tool is that critic's ruler, so a fix can be read before and after on the
same bout.

Reads the shown.csv tools/human_fight_film.gd writes: one row per drawn frame per boxer, positions in metres, y up, the
LowerLeg point BEING the knee. Columns are addressed by name, never by position, so a column added to the film cannot
shift the knee under the ruler.

    python tools/knee_ruler.py <shown.csv> [--fps 30] [--json out.json]
    python tools/knee_ruler.py --compare <before.csv> <after.csv> [--labels before,after]
    python tools/knee_ruler.py --selftest

Per boxer and per knee (Left/Right):
  angle    interior angle hip-knee-ankle per frame (180 = straight), its median, and the share under 130 deg;
  shake    RMS of the angle's second difference, over all frames, over frames inside one clip, and over planted
           frames only (the ankle under 0.15 m/s across the three frames the difference spans);
  jerks    frames whose angle moves more than 8 deg from the frame before - count, rate a second, and how many of
           the over-8-deg steps sat at a clip change (printed, never counted as jerks);
  worst 10 frame, clip, clip_t, phase and whether that foot was planted.

A second difference, a jerk and a foot speed are only taken between consecutive drawn frames of the SAME clip: a clip
change is a cut, not a wobble, and counting cuts would let the ruler be bought by cutting clips less often. The
all-frames figure is printed beside the inside-a-clip one so the reader sees the cut's share of the number.
"""
import csv
import json
import math
import statistics
import sys

FPS = 30.0
PLANT_MPS = 0.15      # a foot slower than this is planted (the critic's and S383's bar)
JERK_DEG = 8.0        # one frame's knee-angle change over this is a jerk
DEEP_DEG = 130.0      # a knee under this is a squat, not a boxing stance
SIDES = ("Left", "Right")
WORST = 10
BONES = {"hip": "UpperLeg", "knee": "LowerLeg", "ankle": "Foot"}


def _v(r, bone):
    return (float(r[bone + "_x"]), float(r[bone + "_y"]), float(r[bone + "_z"]))


def _sub(a, b):
    return tuple(x - y for x, y in zip(a, b))


def _dot(a, b):
    return sum(x * y for x, y in zip(a, b))


def _dist(a, b):
    return math.dist(a, b)


def _unit(a):
    n = math.sqrt(_dot(a, a))
    return tuple(x / n for x in a) if n > 1e-9 else None


def _rms(xs):
    return math.sqrt(sum(x * x for x in xs) / len(xs)) if xs else 0.0


def knee_angle(r, side):
    """Interior angle at the knee (hip-knee-ankle) in degrees; None on a degenerate leg."""
    hip = _v(r, side + BONES["hip"])
    knee = _v(r, side + BONES["knee"])
    ankle = _v(r, side + BONES["ankle"])
    u, w = _unit(_sub(hip, knee)), _unit(_sub(ankle, knee))
    if u is None or w is None:
        return None
    return math.degrees(math.acos(max(-1.0, min(1.0, _dot(u, w)))))


def load(path):
    """{who: [row, ...]} in frame order."""
    by_who = {}
    with open(path, newline="") as f:
        for r in csv.DictReader(f):
            by_who.setdefault(r["who"], []).append(r)
    for rows in by_who.values():
        rows.sort(key=lambda x: int(x["frame"]))
    return by_who


def knee_stats(rows, side, fps=FPS):
    """Every knee number for one leg of one boxer over one film."""
    pts = []
    for r in rows:
        pts.append({"frame": int(r["frame"]), "clip": str(r.get("clip", "")),
                    "clip_t": float(r.get("clip_t", 0.0) or 0.0), "phase": str(r.get("phase", "")),
                    "ang": knee_angle(r, side), "ankle": _v(r, side + BONES["ankle"])})
    n = len(pts)
    step = [False] * n      # consecutive drawn frames (a clip change may sit between them)
    link = [False] * n      # consecutive drawn frames INSIDE one clip
    for i in range(1, n):
        step[i] = pts[i]["frame"] == pts[i - 1]["frame"] + 1
        link[i] = step[i] and pts[i]["clip"] == pts[i - 1]["clip"]
    speed = [None] * n
    for i in range(1, n):
        if step[i]:
            speed[i] = _dist(pts[i]["ankle"], pts[i - 1]["ankle"]) * fps
    planted = [s is not None and s <= PLANT_MPS for s in speed]

    angs = [p["ang"] for p in pts if p["ang"] is not None]
    d2_all, d2_clip, d2_plant, d2_plant_hold = [], [], [], []
    for i in range(1, n - 1):
        a, b, c = pts[i - 1]["ang"], pts[i]["ang"], pts[i + 1]["ang"]
        if a is None or b is None or c is None or not step[i] or not step[i + 1]:
            continue
        d = c - 2.0 * b + a
        d2_all.append(d)
        if link[i] and link[i + 1]:
            d2_clip.append(d)
            if planted[i]:
                d2_plant.append(d)                                     # the foot is planted on this very frame
            if planted[i - 1] and planted[i] and planted[i + 1]:
                d2_plant_hold.append(d)                                # planted across the whole wobble

    jerks, jerks_cut, worst = 0, 0, []
    for i in range(1, n):
        a, b = pts[i - 1]["ang"], pts[i]["ang"]
        if a is None or b is None or not step[i]:
            continue
        d = b - a
        if abs(d) <= JERK_DEG:
            continue
        if link[i]:
            jerks += 1
            worst.append((abs(d), d, pts[i]["frame"], pts[i]["clip"], pts[i]["clip_t"], pts[i]["phase"], planted[i]))
        else:
            jerks_cut += 1
    worst.sort(key=lambda x: -x[0])
    secs = len(rows) / fps
    return {
        "frames": len(rows), "seconds": round(secs, 1),
        "angle_median": round(statistics.median(angs), 1) if angs else 0.0,
        "angle_p10": round(sorted(angs)[int(0.10 * (len(angs) - 1))], 1) if angs else 0.0,
        "angle_p90": round(sorted(angs)[int(0.90 * (len(angs) - 1))], 1) if angs else 0.0,
        "under130_pct": round(100.0 * sum(1 for a in angs if a < DEEP_DEG) / len(angs), 1) if angs else 0.0,
        "shake_all": round(_rms(d2_all), 2),
        "shake_clip": round(_rms(d2_clip), 2),
        "shake_planted": round(_rms(d2_plant), 2),
        "shake_planted_hold": round(_rms(d2_plant_hold), 2),
        "planted_frames": sum(1 for p in planted if p),
        "jerks": jerks,
        "jerks_per_s": round(jerks / secs, 2) if secs > 0 else 0.0,
        "jerks_at_cut": jerks_cut,
        "worst": [(round(d, 1), round(dd, 1), f, c, round(t, 2), ph, bool(pl)) for d, dd, f, c, t, ph, pl in worst[:WORST]],
    }


def measure(path, fps=FPS):
    out = {"file": path, "fps": fps, "knees": {}}
    for who, rows in load(path).items():
        for side in SIDES:
            out["knees"]["%s/%s" % (who, side)] = knee_stats(rows, side, fps)
    keys = sorted(out["knees"])
    out["total_jerks"] = sum(out["knees"][k]["jerks"] for k in keys)
    out["total_jerks_at_cut"] = sum(out["knees"][k]["jerks_at_cut"] for k in keys)
    out["shake_all_median"] = round(statistics.median([out["knees"][k]["shake_all"] for k in keys]), 2) if keys else 0.0
    out["shake_planted_median"] = round(statistics.median([out["knees"][k]["shake_planted"] for k in keys]), 2) if keys else 0.0
    out["angle_median_median"] = round(statistics.median([out["knees"][k]["angle_median"] for k in keys]), 1) if keys else 0.0
    return out


COLS = [("angle_median", "knee angle median (deg)"), ("angle_p10", "  p10 (deepest)"), ("angle_p90", "  p90 (most open)"),
        ("under130_pct", "under 130 deg (%)"), ("shake_all", "shake all frames (deg RMS)"),
        ("shake_clip", "  inside one clip"), ("shake_planted", "  planted"),
        ("shake_planted_hold", "  planted across the wobble"),
        ("planted_frames", "planted frames"), ("jerks", "jerks > 8 deg"), ("jerks_per_s", "  a second"),
        ("jerks_at_cut", "  over 8 deg at a clip cut (not a jerk)")]


def report(m):
    lines = ["KNEE RULER  %s   (%d fps, planted < %.2f m/s, jerk > %.0f deg)"
             % (m["file"], int(m["fps"]), PLANT_MPS, JERK_DEG)]
    lines.append("  %-6s %-6s %8s %8s %8s %8s %8s %8s %6s %6s %6s %7s"
                 % ("boxer", "knee", "med deg", "under130", "shakeAll", "shakeClip", "plant", "plantHold", "planted", "jerks", "a sec", "at cut"))
    for k in sorted(m["knees"]):
        s = m["knees"][k]
        lines.append("  %-6s %-6s %8.1f %8.1f %8.2f %8.2f %8.2f %8.2f %6d %6d %6.2f %7d"
                     % (k.split("/")[0], k.split("/")[1], s["angle_median"], s["under130_pct"], s["shake_all"],
                        s["shake_clip"], s["shake_planted"], s["shake_planted_hold"], s["planted_frames"],
                        s["jerks"], s["jerks_per_s"], s["jerks_at_cut"]))
    lines.append("  ALL KNEES  jerks %d   at a cut %d   shake all (median) %.2f   planted (median) %.2f   angle median %.1f"
                 % (m["total_jerks"], m["total_jerks_at_cut"], m["shake_all_median"], m["shake_planted_median"], m["angle_median_median"]))
    for k in sorted(m["knees"]):
        w = m["knees"][k]["worst"]
        if not w:
            continue
        lines.append("  worst jerks %s (deg | step, frame, clip, clip_t, phase, planted):" % k)
        lines += ["    %6.1f %7.1f %6d %-22s %6.2f %-12s %s" % j for j in w]
    return "\n".join(lines)


def compare(a, b, labels=("before", "after")):
    lines = ["KNEE RULER COMPARE   %s: %s   %s: %s" % (labels[0], a["file"], labels[1], b["file"])]
    keys = sorted(set(a["knees"]) | set(b["knees"]))
    lines.append("  %-9s %-6s %-30s %9s %9s" % ("boxer", "knee", "ruler", labels[0], labels[1]))
    for k in keys:
        sa, sb = a["knees"].get(k, {}), b["knees"].get(k, {})
        for key, label in COLS:
            lines.append("  %-9s %-6s %-30s %9s %9s" % (k.split("/")[0], k.split("/")[1], label,
                                                        sa.get(key, "-"), sb.get(key, "-")))
    for key, label in [("total_jerks", "ALL KNEES jerks > 8 deg"), ("total_jerks_at_cut", "  at a clip cut"),
                       ("shake_all_median", "ALL KNEES shake median"), ("shake_planted_median", "  planted median"),
                       ("angle_median_median", "ALL KNEES angle median")]:
        lines.append("  %-47s %9s %9s" % (label, a.get(key, "-"), b.get(key, "-")))
    return "\n".join(lines)


# ------------------------------------------------------------------------------------------------------------- selftest

def _synth(angles, clips=None):
    """Row dicts for one left leg whose knee angle follows `angles` (deg), 30 fps, hip and knee held still."""
    hip, knee = (0.0, 1.00, 0.0), (0.0, 0.50, 0.0)
    rows = []
    for i, a in enumerate(angles):
        t = math.radians(a)
        ankle = (knee[0], knee[1] + 0.45 * math.cos(t), knee[2] + 0.45 * math.sin(t))
        r = {"frame": str(i), "who": "0", "clip": (clips[i] if clips else "pro_idle"),
             "clip_t": "%.3f" % (i / 30.0), "phase": "guard"}
        for bone, p in (("LeftUpperLeg", hip), ("LeftLowerLeg", knee), ("LeftFoot", ankle)):
            for ax in range(3):
                r["%s_%s" % (bone, "xyz"[ax])] = "%.4f" % p[ax]
        rows.append(r)
    return rows


def selftest():
    """A steady knee must read 0 jerks and 0 shake; one 12 deg pop must read 1 jerk and shake past the 1.5 deg target;
    a clip cut must never be counted as a jerk. Cheap synthetic rows, no film and no Godot."""
    bad = []
    checks = []

    def check(ok, why):
        checks.append(ok)
        if not ok:
            bad.append(why)

    steady = knee_stats(_synth([150.0] * 40), "Left")
    check(steady["jerks"] == 0, "a steady knee read %d jerks, not 0" % steady["jerks"])
    check(steady["shake_all"] == 0.0 and steady["shake_planted"] == 0.0,
          "a steady knee read shake %s / %s, not 0" % (steady["shake_all"], steady["shake_planted"]))
    check(steady["angle_median"] == 150.0, "a steady knee read a median of %s, not 150" % steady["angle_median"])
    check(steady["planted_frames"] >= 38, "a still foot read %d planted frames of 40" % steady["planted_frames"])

    pop = knee_stats(_synth([150.0] * 20 + [162.0] * 20), "Left")
    check(pop["jerks"] == 1, "one 12 deg pop read %d jerks, not 1" % pop["jerks"])
    check(pop["shake_all"] > 1.5, "one 12 deg pop read shake %s, under the 1.5 deg target" % pop["shake_all"])

    deep = knee_stats(_synth([150.0] * 10 + [120.0] * 10), "Left")
    check(deep["under130_pct"] == 50.0, "half a squat read under-130 %s %%, not 50" % deep["under130_pct"])

    cut = knee_stats(_synth([150.0] * 20 + [180.0] * 20, ["pro_idle"] * 20 + ["jab"] * 20), "Left")
    check(cut["jerks"] == 0 and cut["jerks_at_cut"] == 1,
          "a 30 deg clip cut read %d jerks and %d cuts, not 0 and 1" % (cut["jerks"], cut["jerks_at_cut"]))

    for b in bad:
        print("KNEE_RULER SELFTEST FAIL: " + b)
    print("KNEE_RULER SELFTEST %s (%d checks)" % ("failures=%d" % len(bad) if bad else "failures=0", len(checks)))
    return 1 if bad else 0


def _arg(flag, default):
    return sys.argv[sys.argv.index(flag) + 1] if flag in sys.argv else default


def main():
    if "--selftest" in sys.argv:
        return selftest()
    fps = float(_arg("--fps", FPS))
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
