"""PLANIMPACT2 tables (S550). python tools/planimpact2_sum.py <stage> <jsonl...>
stages: ctl (strength-0 arms v PLANIMPACT1's lever-off arms, bout for bout) | ident (arms with identical strings) |
raised (share of the reader's commands raised, per arm and opponent style) | bars (the table and bars 1-3, 5, 6) | x (bar 4).
Raw under E:/FightCamp/tmp/planimpact2/. Wins in 100; +- 2 SE paired (same cells, same dice)."""
import json, math, sys, collections, glob

OLD = sorted(glob.glob("E:/FightCamp/tmp/planimpact1/cb_L[36]*.jsonl"))
STYLES = ["Pressure fighter", "Counter-puncher", "Volume puncher", "Boxer-puncher", "Out-boxer", "Slugger"]


def rows(paths, tag=None):
    for p in paths:
        for line in open(p, encoding="utf-8"):
            line = line.strip()
            if line.startswith("{"):
                r = json.loads(line)
                if tag is None or r.get("tag") == tag:
                    yield r


def win(s):
    return [1.0 if c == "w" else 0.0 for c in s]


def diff(a, b):
    d = [x - y for x, y in zip(a, b)]
    n = len(d)
    if n < 2:
        return 0.0, 0.0
    m = sum(d) / n
    v = sum((x - m) ** 2 for x in d) / (n - 1)
    return 100 * m, 200 * math.sqrt(v / n)


def fmt(t):
    return "%+.1f +-%.1f" % t


def pct(v):
    return "%.1f" % (100 * sum(v) / max(1, len(v))) if v else "-"


def ctl(paths):
    old = {}
    for r in rows(OLD, "cb"):
        old[(r["L"], r["cell"], r["boxer"], r["arm"])] = r["s"]
    tot = collections.defaultdict(lambda: [0, 0, 0])
    for r in rows(paths, "cb"):
        c, p, s = r["arm"].split(":")
        if float(s) != 0.0:
            continue
        o = old.get((r["L"], r["cell"], r["boxer"], "%s:%s:0:0:0" % (c, p)))
        t = tot[(r["L"], r["arm"])]
        if o is None:
            t[2] += 1
            continue
        t[0] += sum(1 for x, y in zip(o, r["s"]) if x == y)
        t[1] += sum(1 for x, y in zip(o, r["s"]) if x != y)
    for k in sorted(tot):
        print("control L%d %s: %d identical, %d differ, %d rows with no PLANIMPACT1 twin" % (k[0], k[1], *tot[k]))


def ident(paths):
    by = collections.defaultdict(dict)
    for r in rows(paths, "cb"):
        by[r["arm"]][(r["L"], r["cell"], r["boxer"])] = r["s"]
    arms = sorted(by)
    for i, a in enumerate(arms):
        for b in arms[i + 1:]:
            ks = set(by[a]) & set(by[b])
            if ks and all(by[a][k] == by[b][k] for k in ks):
                print("IDENTICAL over %d rows: %s = %s" % (len(ks), a, b))


def raised(paths):
    e = collections.defaultdict(lambda: [0, 0])
    for r in rows(paths, "cb"):
        if r["arm"].startswith("reader"):
            for k in (r["style"], "ALL"):
                t = e[(r["L"], r["arm"], k)]
                t[0] += r["cmds"]; t[1] += r["up"]
    for L in sorted({k[0] for k in e}):
        arms = sorted({k[1] for k in e if k[0] == L})
        sty = [s for s in STYLES if any((L, a, s) in e for a in arms)] + ["ALL"]
        print("\n## Share of the reader's commands raised, %d rounds\n\n| arm | %s |\n|---|%s" % (L, " | ".join(sty), "---|" * len(sty)))
        for a in arms:
            print("| %s | %s |" % (a, " | ".join("%.0f%%" % (100.0 * e[(L, a, s)][1] / max(1, e[(L, a, s)][0])) if (L, a, s) in e else "-" for s in sty)))


def table(paths):
    d = collections.defaultdict(lambda: collections.defaultdict(list))
    for r in rows(paths, "cb"):
        d[(r["L"], r["boxer"])][r["arm"]] += win(r["s"])
    return d


def bars(paths):
    d = table(paths)
    verdict = collections.defaultdict(list)
    for L in sorted({k[0] for k in d}):
        bx = sorted(k[1] for k in d if k[0] == L)
        arms = sorted({a for b in bx for a in d[(L, b)]})
        tot = collections.defaultdict(list)
        for b in bx:
            for a in arms:
                tot[a] += d[(L, b)][a]
        print("\n## %d rounds: wins in 100\n\n| arm | %s | ALL |\n|---|%s---|" % (L, " | ".join(b.split(" (")[0] for b in bx), "---|" * len(bx)))
        for a in arms:
            print("| %s | %s | %s |" % (a, " | ".join(pct(d[(L, b)][a]) for b in bx), pct(tot[a])))
        best = {}
        for b in bx:
            c, k = d[(L, b)]["reader:C:1"], d[(L, b)]["reader:K2:1"]
            best[b] = "C" if sum(c) >= sum(k) else "K2"
        bv = lambda b, s="1", corner="reader": d[(L, b)]["%s:%s:%s" % (corner, best[b], s)]
        allbest = [x for b in bx for x in bv(b)]
        pairs = [("best", "E"), ("best", "coach"), ("E", "coach"), ("D2", "coach")]
        print("\n| boxer (best plan) | best-E on | best-coach on | E-coach on | D2-coach on | best on-off | C-E on | K2-E on | C-coach on | K2-coach on |\n|---|---|---|---|---|---|---|---|---|---|")
        cnt = collections.Counter()
        trap = 0
        for b in bx:
            g = lambda arm: d[(L, b)][arm]
            r1 = diff(bv(b), g("reader:E:1")); r2 = diff(bv(b), g("reader:coach:1"))
            r5 = diff(g("reader:E:1"), g("reader:coach:1")); r6 = diff(g("reader:D2:1"), g("reader:coach:1"))
            cnt["b1"] += r1[0] >= 6; cnt["b2"] += r2[0] >= 6
            trap += r6[0] + r6[1] < -2
            print("| %s (%s) | %s | %s | %s | %s | %s | %s | %s | %s | %s |" % (b.split(" (")[0], best[b], fmt(r1), fmt(r2), fmt(r5), fmt(r6), fmt(diff(bv(b), bv(b, "0"))),
                fmt(diff(g("reader:C:1"), g("reader:E:1"))), fmt(diff(g("reader:K2:1"), g("reader:E:1"))), fmt(diff(g("reader:C:1"), g("reader:coach:1"))), fmt(diff(g("reader:K2:1"), g("reader:coach:1")))))
        allE = tot["reader:E:1"]; allco = tot["reader:coach:1"]
        print("| ALL | %s | %s | %s | %s | %s | %s | %s | %s | %s |" % (fmt(diff(allbest, allE)), fmt(diff(allbest, allco)), fmt(diff(allE, allco)), fmt(diff(tot["reader:D2:1"], allco)),
            fmt(diff(allbest, [x for b in bx for x in bv(b, "0")])), fmt(diff(tot["reader:C:1"], allE)), fmt(diff(tot["reader:K2:1"], allE)), fmt(diff(tot["reader:C:1"], allco)), fmt(diff(tot["reader:K2:1"], allco))))
        fam = "C" if sum(tot["reader:C:1"]) >= sum(tot["reader:K2:1"]) else "K2"
        b3 = diff(tot["reader:%s:1" % fam], tot["file:%s:0" % fam])
        b3today = diff(tot["reader:coach:0"], tot["file:coach:0"])
        b5 = diff(allE, allco); b6 = diff(tot["reader:D2:1"], allco)
        print("\nBar 1 (best-E >= 6): %d of %d boxers -> %s" % (cnt["b1"], len(bx), "pass" if cnt["b1"] >= 3 else "FAIL"))
        print("Bar 2 (best-coach >= 6): %d of %d boxers -> %s" % (cnt["b2"], len(bx), "pass" if cnt["b2"] >= 3 else "FAIL"))
        print("Bar 3 (reader-file, %s, rule on, in +6..+15): %s -> %s (today, coach's plan, rule off: %s)" % (fam, fmt(b3), "pass" if 6 <= b3[0] <= 15 else "FAIL", fmt(b3today)))
        print("Bar 5 (E-coach <= -3): %s -> %s" % (fmt(b5), "pass" if b5[0] <= -3 else "FAIL"))
        print("Bar 6 (D2-coach >= -2, no boxer under beyond 2 SE): %s, %d boxers under -> %s" % (fmt(b6), trap, "pass" if b6[0] >= -2 and trap == 0 else "FAIL"))
        print("Half strength (best plan, 0.5 - 0): %s; rule on - off, coach's plan: %s; E on - off: %s" % (
            fmt(diff([x for b in bx for x in bv(b, "0.5")], [x for b in bx for x in bv(b, "0")])), fmt(diff(allco, tot["reader:coach:0"])), fmt(diff(allE, tot["reader:E:0"]))))
        print("Lever-off reference: C-E %s, C-coach %s; reader:C - file:C %s" % (fmt(diff(tot["reader:C:0"], tot["reader:E:0"])), fmt(diff(tot["reader:C:0"], tot["reader:coach:0"])), fmt(diff(tot["reader:C:0"], tot["file:C:0"]))))


def xbar(paths):
    w = collections.defaultdict(list)
    plan = {}
    for r in rows(paths):
        if r.get("tag") not in ("cb", "cbx") or "@" not in r["arm"]:
            continue
        c, pk, s = r["arm"].split(":")
        fam, sj = pk.split("@")
        w[(fam, r["boxer"], r["style"], int(sj))] += win(r["s"])
        plan[(fam, r["boxer"], int(sj))] = tuple(sorted(str(l["move"]) for l in r["fought"]))
    for fam in sorted({k[0] for k in w}):
        print("\n## Bar 4, family %s: each style's plan v each style cell (3 rounds)" % fam)
        passed = 0
        boxers = sorted({k[1] for k in w if k[0] == fam})
        for b in boxers:
            best = collections.Counter()
            for st in STYLES:
                sc = {sj: 100 * sum(w[(fam, b, st, sj)]) / max(1, len(w[(fam, b, st, sj)])) for sj in range(6) if w[(fam, b, st, sj)]}
                if not sc:
                    continue
                top = max(sc.values())
                for p in {plan[(fam, b, sj)] for sj in sc if sc[sj] == top}:
                    best[p] += 1
            p, n = best.most_common(1)[0]
            passed += n <= 3
            print("- %s: %d distinct plans; most often best: %s in %d of 6 cells" % (b.split(" (")[0], len({plan[(fam, b, sj)] for sj in range(6) if (fam, b, sj) in plan}), "+".join(p), n))
        print("Bar 4 %s: %d of %d boxers pass (no plan best in more than 3 of 6) -> %s" % (fam, passed, len(boxers), "pass" if passed >= 3 else "FAIL"))


if __name__ == "__main__":
    st, ps = sys.argv[1], sys.argv[2:]
    {"ctl": ctl, "ident": ident, "raised": raised, "bars": bars, "x": xbar}[st](ps)
