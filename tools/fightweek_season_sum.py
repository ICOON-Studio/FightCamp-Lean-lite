"""S451 FIGHTWEEKPROBE3 summary: career_harness `week=<stop>` runs, one output file per arm, paired by career index.

    python tools/fightweek_season_sum.py <dir with rest.out tick.out through.out coach.out>

Per arm: careers, bouts, win share (this season's bouts only, c.results), bout injuries/suspensions, training injuries, final
stat total. Then each arm against the coach's pick on the SAME careers (paired seeds): wins in 100 bouts and stat points.
A two-sided 95 % band on the paired gap comes from the per-career differences.
"""
import json
import math
import os
import sys

ARMS = ["rest", "tick", "through", "coach"]
NAMES = {"rest": "always Rest up", "tick": "always Tick over", "through": "always Train through", "coach": "the coach's pick"}


def load(path):
    rows = {}
    for line in open(path, encoding="utf-8", errors="replace"):
        if line.startswith("CAREERJSON "):
            r = json.loads(line[len("CAREERJSON "):])
            rows[r["i"]] = r
    return rows


def stats(rows):
    bouts = sum(len(r["res"]) for r in rows.values())
    wins = sum(sum(1 for x in r["res"] if x[0]) for r in rows.values())
    return {
        "n": len(rows), "bouts": bouts, "win": 100.0 * wins / max(1, bouts),
        "inj_bout": sum(r["inj_bout"] for r in rows.values()), "inj_train": sum(r["inj_train"] for r in rows.values()),
        "stat": sum(r["stat_sum"] for r in rows.values()) / max(1, len(rows)),
        "closed": sum(1 for r in rows.values() if r["closed"]),
    }


def paired(a, b, key):
    common = sorted(set(a) & set(b))
    d = [key(a[i]) - key(b[i]) for i in common]
    if len(d) < 2:
        return 0.0, 0.0, len(d)
    m = sum(d) / len(d)
    sd = math.sqrt(sum((x - m) ** 2 for x in d) / (len(d) - 1))
    return m, 1.96 * sd / math.sqrt(len(d)), len(d)


def main():
    root = sys.argv[1]
    data = {a: load(os.path.join(root, a + ".out")) for a in ARMS if os.path.exists(os.path.join(root, a + ".out"))}
    print("FIGHTWEEKPROBE3 - a 52-week season, the sensible player, fight-week stop by habit")
    print("%-22s %5s %6s %7s %9s %9s %8s %6s" % ("arm", "n", "bouts", "win %", "inj bout", "inj train", "stat end", "closed"))
    for a, rows in data.items():
        s = stats(rows)
        print("%-22s %5d %6d %7.1f %9d %9d %8.1f %6d" % (NAMES[a], s["n"], s["bouts"], s["win"], s["inj_bout"], s["inj_train"], s["stat"], s["closed"]))
    if "coach" not in data:
        return
    print("\nPAIRED against the coach's pick (same careers): wins per career, win share per career, stat points")
    for a in [x for x in ARMS if x in data and x != "coach"]:
        w, wb, n = paired(data[a], data["coach"], lambda r: sum(1 for x in r["res"] if x[0]))
        ws, wsb, _ = paired(data[a], data["coach"], lambda r: 100.0 * sum(1 for x in r["res"] if x[0]) / max(1, len(r["res"])))
        st, stb, _ = paired(data[a], data["coach"], lambda r: r["stat_sum"])
        print("  %-22s n=%d  wins %+.2f +-%.2f a season | win share %+.1f +-%.1f in 100 | stats %+.1f +-%.1f" % (NAMES[a], n, w, wb, ws, wsb, st, stb))


if __name__ == "__main__":
    main()
