"""PLANIMPACT1 tables (S548). python tools/planimpact1_sum.py <stage> <jsonl...>
stages: ctl | l1 | x | cb | cbx. Raw under E:/FightCamp/tmp/planimpact1/. Wins in 100; +- 2 SE paired (same files, same dice)."""
import json, math, sys, collections

PW = "E:/FightCamp/tmp/planworth1/"
CB = "E:/FightCamp/tmp/cornerbase1/"
STYLES = ["Pressure fighter", "Counter-puncher", "Volume puncher", "Boxer-puncher", "Out-boxer", "Slugger"]


def rows(paths):
    for p in paths:
        for line in open(p, encoding="utf-8"):
            line = line.strip()
            if line.startswith("{"):
                yield json.loads(line)


def win(s):
    return [1.0 if c == "w" else 0.0 for c in s]


def pw1_strings():
    """PLANWORTH1's bout strings: {(ti, style, threat, weak): {arm: s}} (B58 of types 0-4 from its b58 replay)."""
    out = collections.defaultdict(dict)
    for r in rows([PW + "full_a.jsonl", PW + "full_b.jsonl"]):
        if r.get("tag") == "file":
            out[(r["ti"], r["style"], r["threat"], r["weak"])].update(r["bout"])
    for r in rows([PW + "b58_a.jsonl"]):
        if r.get("tag") == "b58":
            out[(r["ti"], r["style"], r["threat"], r["weak"])]["B58"] = r["bout"]
    return out


def diff(a, b):
    """paired mean(a - b) in points and 2 SE."""
    d = [x - y for x, y in zip(a, b)]
    n = len(d)
    if n < 2:
        return 0.0, 0.0
    m = sum(d) / n
    v = sum((x - m) ** 2 for x in d) / (n - 1)
    return 100 * m, 200 * math.sqrt(v / n)


def fmt(t):
    return "%+.1f +-%.1f" % t


def ctl(paths):
    old = pw1_strings()
    same = diffs = 0
    for r in rows(paths):
        if r.get("tag") == "pw":
            o = old.get((r["ti"], r["style"], r["threat"], r["weak"]), {}).get(r["arm"])
            if o is None:
                continue
            for x, y in zip(o, r["s"]):
                same += x == y
                diffs += x != y
    print("PW control: %d bouts identical, %d differ" % (same, diffs))
    cbold = {}
    for r in rows([CB + "full_L3.jsonl"]):
        if r.get("tag") == "full" and r["cell"] == "presser" and r["pol"] in ("reader_nr", "skill58"):
            cbold[(r["boxer"], r["pol"])] = r["agg"]["outs"]
    for r in rows(paths):
        if r.get("tag") == "ctlcb":
            pol = "reader_nr" if r["arm"].startswith("reader") else "skill58"
            o = cbold.get((r["boxer"], pol), "")
            s = "".join("2" if c == "w" else ("1" if c == "d" else "0") for c in r["s"])
            print("CB control %s %s: identical %s (%d of %d)" % (r["boxer"], pol, o == s, sum(1 for x, y in zip(o, s) if x == y), len(s)))


def l1_table(paths, reuse=True):
    """per type: arms' win vectors aligned by (file, dice)."""
    old = pw1_strings() if reuse else {}
    new = collections.defaultdict(dict)
    cc = collections.defaultdict(lambda: [0, 0])
    names = {}
    for r in rows(paths):
        if r.get("tag") == "pw":
            new[(r["ti"], r["style"], r["threat"], r["weak"])][r["arm"]] = r["s"]
            cc[r["arm"]][0] += r["pl"]
            cc[r["arm"]][1] += r["ct"]
            names[r["ti"]] = r["type"]
    by = collections.defaultdict(lambda: collections.defaultdict(list))   # (ti, style) -> arm -> wins
    for key, arms in new.items():
        allarms = dict(old.get(key, {}))
        allarms.update(arms)
        for a, s in allarms.items():
            by[(key[0], key[1])][a] += win(s)
    return by, cc, names


def l1(paths):
    by, cc, names = l1_table(paths)
    print("## Countered share of plan exchanges per arm")
    for a, (pl, ct) in sorted(cc.items()):
        print("- %s: %d of %d = %.1f%%" % (a, ct, pl, 100.0 * ct / max(1, pl)))
    arms = ["A", "B58", "C", "V", "Vh", "Coff", "Voff", "D", "E"]
    pt = collections.defaultdict(lambda: collections.defaultdict(list))
    for (ti, st), d in by.items():
        for a in arms:
            if a in d:
                pt[ti][a] += d[a]
    print("\n## Per type: wins in 100\n\n| Type | " + " | ".join(arms) + " |\n|---|" + "---|" * len(arms))
    allv = collections.defaultdict(list)
    for ti in sorted(pt):
        print("| %s | " % names.get(ti, ti) + " | ".join("%.1f" % (100 * sum(pt[ti][a]) / max(1, len(pt[ti][a]))) if pt[ti][a] else "-" for a in arms) + " |")
        for a in arms:
            allv[a] += pt[ti][a]
    print("| ALL | " + " | ".join("%.1f" % (100 * sum(allv[a]) / max(1, len(allv[a]))) if allv[a] else "-" for a in arms) + " |")
    pairs = [("V", "B58"), ("C", "B58"), ("V", "C"), ("Vh", "C"), ("Coff", "C"), ("Voff", "V"), ("E", "B58"), ("D", "B58")]
    print("\n## Per type: differences (+- 2 SE)\n\n| Type | " + " | ".join("%s-%s" % p for p in pairs) + " |\n|---|" + "---|" * len(pairs))
    bar1 = bar5w = 0
    for ti in sorted(pt):
        cells = []
        for a, b in pairs:
            if pt[ti][a] and pt[ti][b]:
                t = diff(pt[ti][a], pt[ti][b])
                cells.append(fmt(t))
                if (a, b) == ("V", "B58") and t[0] >= 6:
                    bar1 += 1
                if (a, b) == ("D", "B58") and t[0] + t[1] < -2:
                    bar5w += 1
            else:
                cells.append("-")
        print("| %s | " % names.get(ti, ti) + " | ".join(cells) + " |")
    print("| ALL | " + " | ".join(fmt(diff(allv[a], allv[b])) if allv[a] and allv[b] else "-" for a, b in pairs) + " |")
    print("\nBar 1 (V-B58 >= 6): %d of %d types" % (bar1, len(pt)))
    print("Bar 4 (E-B58 <= -3 over all): %s" % fmt(diff(allv["E"], allv["B58"])) if allv["E"] else "")
    print("Bar 5 (D-B58 never < -2): over all %s; types more than 2 under beyond 2 SE: %d" % (fmt(diff(allv["D"], allv["B58"])), bar5w) if allv["D"] else "")
    print("\n## Bar 6: V - C per opponent style (pooled over the types; per type x style: V better / C better)")
    for st in STYLES:
        v = []; c = []; vb = cb = 0
        for (ti, s2), d in by.items():
            if s2 == st and "V" in d and "C" in d:
                v += d["V"]; c += d["C"]
                m = diff(d["V"], d["C"])[0]
                vb += m > 0; cb += m < 0
        if v:
            print("- %s: %s (types V better %d, C better %d)" % (st, fmt(diff(v, c)), vb, cb))


def xbar(paths):
    w = collections.defaultdict(list)
    names = {}
    for r in rows(paths):
        if r.get("tag") == "x":
            w[(r["ti"], r["si"], r["sj"])] += win(r["s"])
            names[r["ti"]] = r["type"]
    print("## Bar 3: each style's plan v each style (wins in 100); the plan best in most cells")
    passed = 0
    for ti in sorted(names):
        best = collections.Counter()
        for si in range(6):
            sc = [(100 * sum(w[(ti, si, sj)]) / max(1, len(w[(ti, si, sj)])), sj) for sj in range(6)]
            best[max(sc)[1]] += 1
        top, cnt = best.most_common(1)[0]
        passed += cnt <= 3
        print("- %s: plan for %s best in %d of 6 styles; spread %s" % (names[ti], STYLES[top], cnt, dict(best)))
    print("Bar 3: %d of %d types pass (no plan best in more than 3 of 6)" % (passed, len(names)))


def cb(paths, tag="cb"):
    d = collections.defaultdict(lambda: collections.defaultdict(list))   # (L, boxer) -> arm -> wins aligned by cell
    ex = collections.defaultdict(lambda: [0, 0, 0, 0])
    plans = {}
    for r in rows(paths):
        if r.get("tag") == tag:
            d[(r["L"], r["boxer"])][r["arm"]] += win(r["s"])
            e = ex[(r["L"], r["arm"])]
            e[0] += r["cmds"]; e[1] += r["up"]; e[2] += r["pl"]; e[3] += r["ct"]
            plans[(r["boxer"], r["style"], r["arm"])] = (r.get("fought"), r.get("raised"))
    return d, ex, plans


def cbtab(paths, pairs):
    d, ex, plans = cb(paths)
    for L in sorted({k[0] for k in d}):
        print("\n## %d rounds\n" % L)
        arms = sorted({a for k in d if k[0] == L for a in d[k]})
        print("| boxer | " + " | ".join(arms) + " |\n|---|" + "---|" * len(arms))
        tot = collections.defaultdict(list)
        for k in sorted(d):
            if k[0] != L:
                continue
            print("| %s | " % k[1] + " | ".join("%.1f" % (100 * sum(d[k][a]) / max(1, len(d[k][a]))) if d[k][a] else "-" for a in arms) + " |")
            for a in arms:
                tot[a] += d[k][a]
        print("| ALL | " + " | ".join("%.1f" % (100 * sum(tot[a]) / max(1, len(tot[a]))) if tot[a] else "-" for a in arms) + " |")
        ps = [p for p in pairs if p[0] in tot and p[1] in tot]
        print("\n| boxer | " + " | ".join("%s - %s" % p for p in ps) + " |\n|---|" + "---|" * len(ps))
        for k in sorted(d):
            if k[0] == L:
                print("| %s | " % k[1] + " | ".join(fmt(diff(d[k][a], d[k][b])) for a, b in ps) + " |")
        print("| ALL | " + " | ".join(fmt(diff(tot[a], tot[b])) for a, b in ps) + " |")
        print("\ncommands raised / countered share:")
        for a in arms:
            e = ex[(L, a)]
            print("- %s: commands %d, raised %.0f%%; plan exchanges countered %.1f%%" % (a, e[0], 100.0 * e[1] / max(1, e[0]), 100.0 * e[3] / max(1, e[2])))


if __name__ == "__main__":
    st, ps = sys.argv[1], sys.argv[2:]
    if st == "ctl":
        ctl(ps)
    elif st == "l1":
        l1(ps)
    elif st == "x":
        xbar(ps)
    elif st == "cb":
        pairs = [tuple(p.split("/")) for p in (ps.pop(0).split(",") if ps and "/" in ps[0] else [])]
        cbtab(ps, pairs)
