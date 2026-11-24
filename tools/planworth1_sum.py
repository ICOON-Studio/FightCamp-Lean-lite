"""PLANWORTH1 tables (S544): reads tools/planworth1_probe.gd stage=full jsonl files, prints the per-type tables and bars.
python tools/planworth1_sum.py E:/FightCamp/tmp/planworth1/full_a.jsonl E:/FightCamp/tmp/planworth1/full_b.jsonl
"""
import json
import math
import sys
from collections import defaultdict, Counter

ARMS = ["A", "B40", "B58", "B74", "C", "C2", "D", "E", "F"]
DIFFS = [("C", "B58"), ("C", "B74"), ("C2", "C"), ("E", "B58"), ("F", "A"), ("D", "B58"), ("C", "A"), ("C2", "B58")]


def load(paths):
    rows, plans, types, b58 = [], {}, {}, {}
    for p in paths:
        for line in open(p, encoding="utf-8"):
            d = json.loads(line)
            if d["tag"] == "file":
                rows.append(d)
            elif d["tag"] == "style_plans":
                plans[(d["ti"], d["style"])] = d
            elif d["tag"] == "type":
                types[d["ti"]] = d
            elif d["tag"] == "b58":
                b58[(d["ti"], d["style"], d["threat"], d["weak"])] = d
    for r in rows:   # run a's B58 arm was played with no coach (the probe's empty-plan guard); its b58 replay replaces it
        k = (r["ti"], r["style"], r["threat"], r["weak"])
        if k in b58:
            r["read"]["B58"] = b58[k]["read"]
            r["bout"]["B58"] = b58[k]["bout"]
            r["b58_replayed"] = True
    return rows, plans, types


def win(s):
    return [1.0 if ch == "w" else 0.0 for ch in s]


def mean_se(rows, a, b=None):
    """Mean wins in 100 (or the paired difference a-b) and its SE, bouts paired by file and dice."""
    xs = []
    for r in rows:
        wa = win(r["bout"][a])
        if b is None:
            xs += wa
        else:
            wb = win(r["bout"][b])
            xs += [x - y for x, y in zip(wa, wb)]
    n = len(xs)
    m = sum(xs) / n
    var = sum((x - m) ** 2 for x in xs) / max(1, n - 1)
    return 100.0 * m, 100.0 * math.sqrt(var / n)


def read_mean(rows, a):
    return sum(r["read"][a] for r in rows) / len(rows)


def pkey(plan):
    return tuple(sorted("%s@%s" % (l["move"], l.get("when", "")) for l in plan))


def main(paths):
    rows, plans, types = load(paths)
    by_t = defaultdict(list)
    for r in rows:
        by_t[r["ti"]].append(r)
    order = sorted(by_t)
    out = []
    pr = out.append
    pr("## Population: %d types, %d files, %d bouts a file-arm" % (len(order), len(rows), rows[0]["n"]))
    pr("")
    pr("### Wins in 100, real bouts (read beside it), per type")
    pr("")
    pr("| Type | limit | " + " | ".join(ARMS) + " |")
    pr("|---|---|" + "---|" * len(ARMS))
    flags = []
    for ti in order + ["all"]:
        rs = rows if ti == "all" else by_t[ti]
        name = "ALL" if ti == "all" else rs[0]["type"]
        cells = []
        for a in ARMS:
            m, _ = mean_se(rs, a)
            rd = read_mean(rs, a)
            cells.append("%.1f (%.1f)" % (m, rd))
            if abs(m - rd) > 3.0:
                flags.append((name, a, round(m, 1), round(rd, 1)))
        lim = "" if ti == "all" else str(types[ti]["limit"])
        pr("| %s | %s | %s |" % (name, lim, " | ".join(cells)))
    pr("")
    pr("### Differences, real bouts, points of wins in 100 +- 2 SE (the read's difference in brackets)")
    pr("")
    pr("| Type | " + " | ".join("%s-%s" % d for d in DIFFS) + " |")
    pr("|---|" + "---|" * len(DIFFS))
    per = {}
    for ti in order + ["all"]:
        rs = rows if ti == "all" else by_t[ti]
        name = "ALL" if ti == "all" else rs[0]["type"]
        cells = []
        per[ti] = {}
        for a, b in DIFFS:
            m, se = mean_se(rs, a, b)
            rd = read_mean(rs, a) - read_mean(rs, b)
            per[ti]["%s-%s" % (a, b)] = (m, se, rd)
            cells.append("%+.1f +-%.1f (%+.1f)" % (m, 2 * se, rd))
        pr("| %s | %s |" % (name, " | ".join(cells)))
    pr("")
    # bars
    b1 = [ti for ti in order if per[ti]["C-B58"][0] >= 5.0 and per[ti]["C-B74"][0] >= 3.0]
    b2 = [ti for ti in order if per[ti]["C2-C"][0] >= 3.0]
    b3 = [ti for ti in order if per[ti]["E-B58"][0] < 0.0]
    b6 = [ti for ti in order if per[ti]["D-B58"][0] < -2.0]
    # bar 4: drop one line
    pr("### Where the worth sits (arm C minus one line, real bouts): each line's share of C's gain over no plan (C - A)")
    pr("")
    pr("| Type | opponent style | C's lines | C - A | each line's share (C - C-minus-i) / (C - A) | top share |")
    pr("|---|---|---|---|---|---|")
    one_line = {}
    for ti in order:
        hits = 0
        tot = 0
        for st in sorted(set(r["style"] for r in by_t[ti])):
            rs = [r for r in by_t[ti] if r["style"] == st]
            plan = plans[(ti, st)]["C"]
            g, _ = mean_se(rs, "C", "A")
            shares = []
            for i in range(len(plan)):
                d, _ = mean_se(rs, "C", "C-%d" % i)
                shares.append(d / g if abs(g) > 1e-9 else float("nan"))
            top = max(shares) if shares else float("nan")
            if g > 0:
                tot += 1
                hits += int(top > 0.6)
            pr("| %s | %s | %s | %+.1f | %s | %.0f%% |" % (rs[0]["type"], st, ", ".join(l["move"] for l in plan), g,
                ", ".join("%s %.0f%%" % (l["move"], 100 * s) for l, s in zip(plan, shares)), 100 * top))
        one_line[ti] = (hits, tot)
    pr("")
    b4 = [ti for ti in order if one_line[ti][1] > 0 and one_line[ti][0] * 2 > one_line[ti][1]]
    # bar 5
    pr("### Does the best plan differ (arm C2, one plan a file)")
    pr("")
    pr("| Type | files | different C2 plans | most common plan: files | share |")
    pr("|---|---|---|---|---|")
    b5 = []
    for ti in order:
        c = Counter(pkey(r["C2"]) for r in by_t[ti])
        top, k = c.most_common(1)[0]
        share = k / len(by_t[ti])
        if share > 0.5:
            b5.append(ti)
        pr("| %s | %d | %d | %s: %d | %.0f%% |" % (by_t[ti][0]["type"], len(by_t[ti]), len(c), " + ".join(top), k, 100 * share))
    pr("")
    pr("### Arm C's plans (style only, one per opponent style) and arm E (careless)")
    pr("")
    for ti in order:
        for st in sorted(set(r["style"] for r in by_t[ti])):
            p = plans[(ti, st)]
            pr("- %s vs %s: C = %s | B58 = %s | B74 = %s | E = %s" % (by_t[ti][0]["type"], st,
                ", ".join(l["move"] for l in p["C"]) or "(none)", ", ".join(l["move"] for l in p["B58"]) or "(none)",
                ", ".join(l["move"] for l in p["B74"]) or "(none)", ", ".join(l["move"] for l in p["E"])))
    pr("")
    nm = lambda ts: ", ".join(by_t[t][0]["type"] for t in ts) or "none"
    pr("### Bars")
    pr("")
    pr("- (1) PLANNING PAYS (C-B58 >= 5 and C-B74 >= 3, 6 of 10 types): %d of %d -> %s [%s]" % (len(b1), len(order), "PASS" if len(b1) >= 6 else "FAIL", nm(b1)))
    pr("- (2) THE TAPE PAYS (C2-C >= 3, 6 of 10): %d of %d -> %s [%s]" % (len(b2), len(order), "PASS" if len(b2) >= 6 else "FAIL", nm(b2)))
    pr("- (3) A CARELESS PLAN COSTS (E < B58, 6 of 10): %d of %d -> %s [%s]" % (len(b3), len(order), "PASS" if len(b3) >= 6 else "FAIL", nm(b3)))
    pr("- (4) NOT ONE LINE (one line > 60%% of C's gain in most styles, for no more than half the types): %d of %d types one-line -> %s [%s]" % (len(b4), len(order), "PASS" if len(b4) * 2 <= len(order) else "FAIL", nm(b4)))
    pr("- (5) NOT ONE PLAN (no type with one C2 plan on > half its files): %d types with one plan -> %s [%s]" % (len(b5), "PASS" if not b5 else "FAIL", nm(b5)))
    pr("- (6) NO TRAP (D not below B58 by more than 2): %d types below -> %s [%s]" % (len(b6), "PASS" if not b6 else "FAIL", nm(b6)))
    pr("")
    pr("### Read vs bout: arms where the mean read and the mean bout differ by more than 3 points")
    pr("")
    for f in flags:
        pr("- %s %s: bout %.1f, read %.1f" % f)
    print("\n".join(out))


if __name__ == "__main__":
    main(sys.argv[1:])
