"""HUMANFIGHT1: reads tools/human_fight_film.gd's shown.csv (every drawn frame of a real bout, both boxers as shown) and
prints the raw rulers, per boxer and per clip. No pass lines here: the numbers are what a critic gets.

  python tools/human_fight_report.py <shown.csv> [--events] [--fps 30]

Floor: absolute. The canvas is y 0 (RingSet); a body's ball and ankle joints stand at their rest-pose heights x her scale
(floor.json beside the csv, written by the film tool; without it 0.0115 / 0.084 m, the MetaHuman bodies' rest heights at
scale 1 - tools/rest_feet_probe.gd). A percentile of the film itself is NOT a floor: a boxer who hovers most of the round
would read as standing. A foot is OFF the canvas when
BOTH its ball and its ankle are over their standing height by more than OFF_M (a raised heel keeps the ball down, a raised
toe keeps the heel down: neither is flying). A boxer is AIRBORNE on a frame where both feet are off.
"""
import csv
import json
import math
import os
import sys
from collections import defaultdict

OFF_M = 0.03      # both ball and ankle this far over standing = the foot is off the canvas
HIGH_M = 0.12     # a foot this far up is a knee-high step, not a boxer's shuffle
SINK_M = 0.02
PLANT_M = 0.015   # a foot this close to standing counts as planted (for skate)
FEET = ["Left", "Right"]


def pct(vals, q):
    if not vals:
        return float("nan")
    s = sorted(vals)
    return s[min(int(len(s) * q), len(s) - 1)]


def load(path):
    rows = defaultdict(list)
    with open(path, newline="") as f:
        for r in csv.DictReader(f):
            rows[int(r["who"])].append(r)
    return rows


def runs(flags):
    """[(start, length)] of consecutive True."""
    out, start = [], None
    for i, v in enumerate(flags):
        if v and start is None:
            start = i
        if not v and start is not None:
            out.append((start, i - start))
            start = None
    if start is not None:
        out.append((start, len(flags) - start))
    return out


def analyse(rows, fps, events, floors=None, scenes=False):
    out = {}
    for who, rr in sorted(rows.items()):
        live = [r for r in rr if (r["scene"] == "1") == scenes]
        if len(live) < 30:
            print("boxer %d: only %d %s frames" % (who, len(live), "scene" if scenes else "in-round"))
            continue
        fl = {}
        for s in FEET:
            fl[s + "Toes"] = floors[who][s + "Toes"] if floors else 0.0115
            fl[s + "Foot"] = floors[who][s + "Foot"] if floors else 0.084
        n = len(live)
        clear = {s: [] for s in FEET}
        for r in live:
            for s in FEET:
                clear[s].append(min(float(r[s + "Toes_y"]) - fl[s + "Toes"], float(r[s + "Foot_y"]) - fl[s + "Foot"]))
        air = [clear["Left"][i] > OFF_M and clear["Right"][i] > OFF_M for i in range(n)]
        both = [min(clear["Left"][i], clear["Right"][i]) for i in range(n)]
        high = [max(clear["Left"][i], clear["Right"][i]) > HIGH_M for i in range(n)]
        sink = [min(clear["Left"][i], clear["Right"][i]) < -SINK_M for i in range(n)]
        by_clip_air = defaultdict(int)
        by_clip_n = defaultdict(int)
        by_clip_high = defaultdict(int)
        by_clip_peak = defaultdict(float)
        for i, r in enumerate(live):
            by_clip_n[r["clip"]] += 1
            by_clip_air[r["clip"]] += air[i]
            by_clip_high[r["clip"]] += high[i]
            by_clip_peak[r["clip"]] = max(by_clip_peak[r["clip"]], both[i])
        air_runs = runs(air)
        longest = max([l for _, l in air_runs], default=0)
        # skate: a planted foot's ball moving on the canvas (m/s), frame to frame (consecutive frames only)
        skate = []
        skate_by = defaultdict(list)
        for s in FEET:
            for i in range(1, n):
                if int(live[i]["frame"]) - int(live[i - 1]["frame"]) != 1:
                    continue
                if clear[s][i] < PLANT_M and clear[s][i - 1] < PLANT_M:
                    d = math.hypot(float(live[i][s + "Toes_x"]) - float(live[i - 1][s + "Toes_x"]),
                                   float(live[i][s + "Toes_z"]) - float(live[i - 1][s + "Toes_z"]))
                    skate.append(d * fps)
                    skate_by[live[i]["clip"]].append(d * fps)
        slide_m = sum(v / fps for v in skate if v > 0.15)
        # support slip: the STILLER of the feet standing on the canvas (ball under 3 cm) - a walking foot passes low
        # mid-swing, so one planted foot's speed alone over-reads a walk; the stiller standing foot moving is a slide
        slip, slip_by, slip_n = [], defaultdict(float), 0
        for i in range(1, n):
            if int(live[i]["frame"]) - int(live[i - 1]["frame"]) != 1:
                continue
            slip_n += 1
            vs = [math.hypot(float(live[i][s + "Toes_x"]) - float(live[i - 1][s + "Toes_x"]), float(live[i][s + "Toes_z"]) - float(live[i - 1][s + "Toes_z"]))
                  for s in FEET if float(live[i][s + "Toes_y"]) - fl[s + "Toes"] < 0.03]
            if vs:
                slip.append(min(vs) * fps)
                if min(vs) * fps > 0.15:
                    slip_by[live[i]["clip"]] += min(vs)
        slip_m = sum(slip_by.values())
        # pops: hips and head jumping in one frame (m), relative to the frame before
        hip_dy, hip_dxz, head_d = [], [], []
        pops = []
        for i in range(1, n):
            if int(live[i]["frame"]) - int(live[i - 1]["frame"]) != 1:
                continue
            dy = float(live[i]["Hips_y"]) - float(live[i - 1]["Hips_y"])
            dxz = math.hypot(float(live[i]["Hips_x"]) - float(live[i - 1]["Hips_x"]), float(live[i]["Hips_z"]) - float(live[i - 1]["Hips_z"]))
            dh = math.dist([float(live[i]["Head_" + a]) for a in "xyz"], [float(live[i - 1]["Head_" + a]) for a in "xyz"])
            hip_dy.append(abs(dy))
            hip_dxz.append(dxz)
            head_d.append(dh)
            if abs(dy) > 0.03 or dxz > 0.08:
                pops.append((live[i]["frame"], live[i]["t"], live[i - 1]["clip"], live[i]["clip"], dy, dxz))
        # knee tremble: RMS second difference of the knee's inner angle (deg), all frames and frames with a planted foot
        shake = {}
        if "LeftUpperLeg_x" in live[0]:
            for s in FEET:
                ang = []
                for r in live:
                    a = [float(r[s + "UpperLeg_" + c]) for c in "xyz"]
                    b = [float(r[s + "LowerLeg_" + c]) for c in "xyz"]
                    c3 = [float(r[s + "Foot_" + c]) for c in "xyz"]
                    u = [a[k] - b[k] for k in range(3)]
                    v = [c3[k] - b[k] for k in range(3)]
                    cs = sum(u[k] * v[k] for k in range(3)) / max(math.hypot(*u) * math.hypot(*v), 1e-9)
                    ang.append(math.degrees(math.acos(max(-1.0, min(1.0, cs)))))
                d2 = [ang[i] - 2 * ang[i - 1] + ang[i - 2] for i in range(2, n)
                      if int(live[i]["frame"]) - int(live[i - 2]["frame"]) == 2]
                d2p = [ang[i] - 2 * ang[i - 1] + ang[i - 2] for i in range(2, n)
                       if int(live[i]["frame"]) - int(live[i - 2]["frame"]) == 2 and clear[s][i] < PLANT_M]
                shake[s] = (math.sqrt(sum(x * x for x in d2) / max(len(d2), 1)), math.sqrt(sum(x * x for x in d2p) / max(len(d2p), 1)),
                            sum(1 for x in d2 if abs(x) > 8.0), pct(ang, 0.5), sum(1 for x in ang if x > 170.0) / n)
        print("BOXER %d  in-round frames %d (%.1f s)  standing: balls L %.3f R %.3f  ankles L %.3f R %.3f" % (
            who, n, n / fps, fl["LeftToes"], fl["RightToes"], fl["LeftFoot"], fl["RightFoot"]))
        print("  AIRBORNE (both feet off the canvas > %.0f cm): %d frames = %.1f %% of the round | %d separate times | longest %d frames (%.2f s) | lowest foot at its highest %.1f cm" % (
            OFF_M * 100, sum(air), 100.0 * sum(air) / n, len(air_runs), longest, longest / fps, 100 * max(both)))
        print("  ONE FOOT HIGH (> %.0f cm): %d frames = %.1f %% | highest a foot goes %.1f cm" % (
            HIGH_M * 100, sum(high), 100.0 * sum(high) / n, 100 * max(max(clear["Left"]), max(clear["Right"]))))
        print("  UNDER the canvas (> %.0f cm): %d frames | deepest %.1f cm" % (SINK_M * 100, sum(sink), -100 * min(min(clear["Left"]), min(clear["Right"]))))
        print("  PLANTED FOOT SKATE m/s: p50 %.2f p90 %.2f p99 %.2f max %.2f | slid (faster than 0.15 m/s) %.2f m in the round" % (
            pct(skate, 0.5), pct(skate, 0.9), pct(skate, 0.99), max(skate, default=0.0), slide_m))
        print("  SUPPORT-FOOT SLIP (the stiller standing foot) m/s: p50 %.2f p90 %.2f p99 %.2f | slid %.1f m in the round = %.2f m a second | frames sliding > 0.15 m/s %.1f %%" % (
            pct(slip, 0.5), pct(slip, 0.9), pct(slip, 0.99), slip_m, slip_m / (n / fps), 100.0 * sum(1 for v in slip if v > 0.15) / max(len(slip), 1)))
        print("  slip by clip [m]: " + "; ".join("%s %.1f" % (c, slip_by[c]) for c in sorted(slip_by, key=lambda c: -slip_by[c])[:10]))
        print("  HIPS per frame: up/down p99 %.1f cm max %.1f cm | along the canvas p99 %.1f cm max %.1f cm | HEAD per frame p99 %.1f cm max %.1f cm | pops (hips > 3 cm up/down or > 8 cm along in a frame) %d" % (
            100 * pct(hip_dy, 0.99), 100 * max(hip_dy, default=0), 100 * pct(hip_dxz, 0.99), 100 * max(hip_dxz, default=0), 100 * pct(head_d, 0.99), 100 * max(head_d, default=0), len(pops)))
        for s in shake:
            print("  KNEE %s: shake (RMS 2nd difference) %.2f deg, with the foot planted %.2f deg | jerks > 8 deg %d | bend p50 %.0f deg | locked > 170 deg %.1f %%" % (
                s, shake[s][0], shake[s][1], shake[s][2], shake[s][3], 100 * shake[s][4]))
        top = sorted(by_clip_n, key=lambda c: -by_clip_air[c])[:10]
        print("  airborne by clip [frames airborne / frames played, lowest foot peak cm]: " + "; ".join(
            "%s %d/%d %.0f" % (c, by_clip_air[c], by_clip_n[c], 100 * by_clip_peak[c]) for c in top if by_clip_air[c] > 0))
        tops = sorted(skate_by, key=lambda c: -sum(v / fps for v in skate_by[c] if v > 0.15))[:8]
        print("  slide by clip [m]: " + "; ".join("%s %.2f" % (c, sum(v / fps for v in skate_by[c] if v > 0.15)) for c in tops))
        share = defaultdict(int)
        for r in live:
            share[r["clip"]] += 1
        print("  clips played [share %]: " + "; ".join("%s %.0f" % (c, 100.0 * share[c] / n) for c in sorted(share, key=lambda c: -share[c])[:12]))
        if events:
            for st, ln in sorted(air_runs, key=lambda x: -x[1])[:15]:
                r = live[st]
                print("    air: frame %s t=%s for %d frames, clip %s (rig %s pure %s), peak %.1f cm" % (
                    r["frame"], r["t"], ln, r["clip"], r["rig_w"], r["pure"], 100 * max(both[st:st + ln])))
            for p in pops[:15]:
                print("    pop: frame %s t=%s %s -> %s hips dy %.3f dxz %.3f" % p)
        out[who] = {"air_frames": sum(air), "air_share": sum(air) / n, "longest": longest, "n": n}
    return out


if __name__ == "__main__":
    fps = 30.0
    if "--fps" in sys.argv:
        fps = float(sys.argv[sys.argv.index("--fps") + 1])
    fj = os.path.join(os.path.dirname(sys.argv[1]), "floor.json")
    floors = json.load(open(fj)) if os.path.exists(fj) else None
    if "--scenes" in sys.argv:
        print("SCENE FRAMES (walks, corner, counts)")
    analyse(load(sys.argv[1]), fps, "--events" in sys.argv, floors, "--scenes" in sys.argv)
