"""STYLEPLACE1 tables (S551). python tools/styleplace1_sum.py <stage> <jsonl...>
stages: ctl (cfg off v PLANIMPACT2's lever-off arms, bout for bout) | ident (configs with identical bouts) | loops (the scope's
feedback loops + bar 6 places) | bars (bars 1, 2, 4, 5 from cb rows; bar 3 from cbx rows) | pw (the ten types, corner off) |
film (bar 7) | play (bar 8 from cplan rows + film rows). Raw under E:/FightCamp/tmp/styleplace1/. Wins in 100; +- 2 SE paired."""
import json, math, sys, collections, glob

P2 = "E:/FightCamp/tmp/planimpact2/full_L3.jsonl"
STYLES = ["Pressure fighter", "Counter-puncher", "Volume puncher", "Boxer-puncher", "Out-boxer", "Slugger"]
CELL_STYLE = {"presser": 0, "counter": 1, "fader": 2, "slow": 3, "mover": 4, "loader": 5}
PLACES = ["mid", "long", "outside", "inside", "own_ropes", "opp_ropes"]
CFGS = ["off", "L1", "L1h", "L2", "L2h", "L12"]


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
    for r in rows([P2], "cb"):
        old[(r["L"], r["cell"], r["boxer"], r["arm"])] = r["s"]
    tot = collections.defaultdict(lambda: [0, 0, 0])
    for r in rows(paths, "cb"):
        if r["cfg"] != "off":
            continue
        c, p = r["arm"].split(":")[:2]
        p = "C" if p == "C0" else p
        o = old.get((r["L"], r["cell"], r["boxer"], "%s:%s:0" % (c, p)))
        t = tot[r["arm"]]
        if o is None:
            t[2] += 1
            continue
        o = o[r["k0"]:r["k0"] + len(r["s"])]
        t[0] += sum(1 for x, y in zip(o, r["s"]) if x == y)
        t[1] += sum(1 for x, y in zip(o, r["s"]) if x != y)
    for k in sorted(tot):
        print("control %s: %d identical, %d differ, %d rows with no PLANIMPACT2 twin" % (k, *tot[k]))


def ident(paths):
    by = collections.defaultdict(dict)
    for r in rows(paths, "cb"):
        by[r["cfg"]][(r["L"], r["cell"], r["boxer"], r["arm"], r["k0"])] = r["s"]
    cf = sorted(by)
    for i, a in enumerate(cf):
        for b in cf[i + 1:]:
            ks = set(by[a]) & set(by[b])
            same = sum(1 for k in ks if by[a][k] == by[b][k])
            nb = sum(len(by[a][k]) for k in ks)
            db = sum(sum(1 for x, y in zip(by[a][k], by[b][k]) if x != y) for k in ks)
            print("%s v %s: %d of %d rows identical; %d of %d bouts differ%s" % (a, b, same, len(ks), db, nb, "   <- IDENTICAL" if ks and same == len(ks) else ""))


def loops(paths, tag="cb"):
    pc = collections.defaultdict(collections.Counter)
    n = collections.Counter()
    climb = collections.Counter()
    over = collections.Counter()
    top = collections.Counter()
    for r in rows(paths, tag):
        for key in ((r["cfg"], r["style"]), (r["cfg"], "ALL")):
            for c, v in r.get("pc", {}).items():
                pc[key][c] += v
            n[key] += len(r["s"])
            climb[key] += r.get("climb", 0)
            over[key] += r.get("over70", 0)
            top[key] += r.get("topsum", 0.0)
    for cfg in [c for c in CFGS if (c, "ALL") in n]:
        print("\n### %s: share of exchanges by place (bar 6: each >= 5%% over ALL; loop 1: own_ropes <= 50%%; loop 2: climb <= 50%%)" % cfg)
        print("| style | " + " | ".join(PLACES) + " | other | top place a bout (mean) | bouts one place > 70% | inside climbs every round |")
        print("|---|" + "---|" * (len(PLACES) + 4))
        for s in STYLES + ["ALL"]:
            k = (cfg, s)
            if k not in n:
                continue
            t = sum(pc[k].values())
            oth = sum(v for c, v in pc[k].items() if c not in PLACES)
            print("| %s | %s | %.0f%% | %.2f | %.0f%% | %.0f%% |" % (s, " | ".join("%.1f%%" % (100.0 * pc[k][c] / max(1, t)) for c in PLACES),
                100.0 * oth / max(1, t), top[k] / max(1, n[k]), 100.0 * over[k] / max(1, n[k]), 100.0 * climb[k] / max(1, n[k])))


def table(paths, tag="cb"):
    d = collections.defaultdict(lambda: collections.defaultdict(list))
    for r in rows(paths, tag):
        d[(r["cfg"], r["boxer"])][r["arm"]] += win(r["s"])
    return d


def bars(paths, xpaths=(), npaths=()):
    d = table(paths)
    for cfg in [c for c in CFGS if any(k[0] == c for k in d)]:
        bx = sorted(k[1] for k in d if k[0] == cfg)
        arms = sorted({a for b in bx for a in d[(cfg, b)]})
        tot = collections.defaultdict(list)
        for b in bx:
            for a in arms:
                tot[a] += d[(cfg, b)][a]
        print("\n## %s: wins in 100 (3 rounds)\n\n| arm | %s | ALL |\n|---|%s---|" % (cfg, " | ".join(b.split(" (")[0] for b in bx), "---|" * len(bx)))
        for a in arms:
            print("| %s | %s | %s |" % (a, " | ".join(pct(d[(cfg, b)][a]) for b in bx), pct(tot[a])))
        if "reader:C" not in arms:
            continue
        best = {b: ("C" if sum(d[(cfg, b)]["reader:C"]) >= sum(d[(cfg, b)]["reader:K2"]) else "K2") for b in bx}
        print("\n| boxer (best) | 1 best-careless | 2 best-coach | 4 careless-coach |\n|---|---|---|---|")
        c1 = c2 = 0
        allb, alle, allc = [], [], []
        for b in bx:
            g = lambda a: d[(cfg, b)][a]
            bv = g("reader:" + best[b])
            r1, r2, r4 = diff(bv, g("reader:E")), diff(bv, g("reader:coach")), diff(g("reader:E"), g("reader:coach"))
            c1 += r1[0] >= 6; c2 += r2[0] >= 6
            allb += bv; alle += g("reader:E"); allc += g("reader:coach")
            print("| %s (%s) | %s | %s | %s |" % (b.split(" (")[0], best[b], fmt(r1), fmt(r2), fmt(r4)))
        print("| ALL | %s | %s | %s |" % (fmt(diff(allb, alle)), fmt(diff(allb, allc)), fmt(diff(alle, allc))))
        print("BARS %s: 1 %d of %d %s | 2 %d of %d %s | 4 %s %s" % (cfg, c1, len(bx), "pass" if c1 >= 3 else "FAIL", c2, len(bx), "pass" if c2 >= 3 else "FAIL",
            fmt(diff(alle, allc)), "pass" if diff(alle, allc)[0] <= -3 else "FAIL"))
    if xpaths:
        bar3(xpaths)
    if npaths:
        bar5(npaths)


def bar3(paths):
    w = collections.defaultdict(lambda: collections.defaultdict(list))
    pl = {}
    for r in rows(paths, "cbx"):
        fam, sj = r["arm"].split(":")[1].split("@")
        w[(r["cfg"], fam, r["boxer"])][(int(sj), CELL_STYLE[r["cell"]])] = win(r["s"])
        pl[(r["cfg"], fam, r["boxer"], int(sj))] = tuple(sorted(r["plan"]))
    for cfg in [c for c in CFGS if any(k[0] == c for k in w)]:
        for fam in ("C", "K2"):
            bx = sorted({k[2] for k in w if k[0] == cfg and k[1] == fam})
            ok = 0
            out = []
            for b in bx:
                t = w[(cfg, fam, b)]
                count = collections.Counter()
                for si in range(6):
                    sc = {sj: sum(t.get((sj, si), [])) for sj in range(6)}
                    m = max(sc.values())
                    for p in {pl[(cfg, fam, b, sj)] for sj in range(6) if sc[sj] == m}:
                        count[p] += 1
                distinct = len({pl[(cfg, fam, b, sj)] for sj in range(6)})
                worst = max(count.values())
                ok += worst <= 3
                out.append("%s: %d distinct plans, %d of them best v a style, the most-best plan best v %d of 6" % (b.split(" (")[0], distinct, len(count), worst))
            print("BAR3 %s %s: %d of %d boxers pass (%s)  [%s]" % (cfg, fam, ok, len(bx), "pass" if ok >= 3 else "FAIL", "; ".join(out)))


def bar5(paths):
    d = collections.defaultdict(dict)
    for r in rows(paths, "cb"):
        if r["arm"] == "reader:none":
            d[r["cfg"]][(r["boxer"], r["cell"])] = win(r["s"])
    base = d.get("off", {})
    for cfg in [c for c in CFGS if c in d and c != "off"]:
        fails, walls, ad = [], [], []
        for k, v in d[cfg].items():
            if k not in base:
                continue
            m, se = diff(v, base[k])
            ad.append(abs(m))
            if abs(m) > 3 and abs(m) > se:
                fails.append("%s v %s %+.1f +-%.1f" % (k[0].split(" (")[0], k[1], m, se))
            nw, ow = 100 * sum(v) / len(v), 100 * sum(base[k]) / len(base[k])
            if (nw < 25 or nw > 85) and not (ow < 25 or ow > 85):
                walls.append("%s v %s %.0f (was %.0f)" % (k[0].split(" (")[0], k[1], nw, ow))
        print("BAR5 %s: %d of %d cells moved beyond 3 and 2 SE; mean |change| %.1f; new walls / free wins: %d  %s" % (cfg, len(fails), len(ad),
            sum(ad) / max(1, len(ad)), len(walls), "pass" if not fails and not walls else "FAIL"))
        for f in fails + walls:
            print("   ", f)


def film(paths):
    for r in rows(paths, "film"):
        print("BAR7 %s %-16s truth %-9s right %3d of %d (%.0f%%)  said %s  ModeTells one film -> %s  line: %s" % (r["cfg"], r["style"], r["truth"],
            r["right"], r["films"], 100.0 * r["right"] / r["films"], r["said"], r["modetells_one_film"], r["line"]))


def play(paths):
    pc = collections.defaultdict(dict)
    for r in rows(paths, "cplan"):
        pc[(r["cfg"], r["ti"], r["type"])][r["si"]] = tuple(sorted(l["move"] for l in r["plan"]))
    for k in sorted(pc, key=lambda k: (CFGS.index(k[0]), k[1])):
        print("BAR8 %s %-32s distinct plans over the six styles: %d" % (k[0], k[2], len(set(pc[k].values()))))


def pw(paths):
    d = collections.defaultdict(lambda: collections.defaultdict(list))
    cells = collections.defaultdict(lambda: collections.defaultdict(list))
    for r in rows(paths, "pw"):
        d[(r["cfg"], r["type"])][r["arm"]] += win(r["s"])
        cells[(r["cfg"], r["type"], r["style"])][r["arm"]] += win(r["s"])
    for cfg in [c for c in CFGS if any(k[0] == c for k in d)]:
        ty = sorted(k[1] for k in d if k[0] == cfg)
        arms = sorted({a for t in ty for a in d[(cfg, t)]})
        print("\n## PW %s (ten types, corner off, 4 rounds): wins in 100\n\n| type | %s | C-E | C-B58 | E-B58 |\n|---|%s---|---|---|" % (cfg, " | ".join(arms), "---|" * len(arms)))
        c1 = c2 = 0
        ae, ac, ab = [], [], []
        for t in ty:
            g = d[(cfg, t)]
            r1 = diff(g["C"], g["E"]) if "C" in g and "E" in g else (0, 0)
            r2 = diff(g["C"], g["B58"]) if "C" in g and "B58" in g else (0, 0)
            r4 = diff(g["E"], g["B58"]) if "E" in g and "B58" in g else (0, 0)
            c1 += r1[0] >= 6; c2 += r2[0] >= 6
            ae += g.get("E", []); ac += g.get("C", []); ab += g.get("B58", [])
            print("| %s | %s | %s | %s | %s |" % (t, " | ".join(pct(g[a]) for a in arms), fmt(r1), fmt(r2), fmt(r4)))
        if ac and ae and ab:
            print("PWBARS %s: 1 %d of %d %s | 2 %d of %d %s | 4 %s %s" % (cfg, c1, len(ty), "pass" if c1 >= 6 else "FAIL", c2, len(ty), "pass" if c2 >= 6 else "FAIL",
                fmt(diff(ae, ab)), "pass" if diff(ae, ab)[0] <= -3 else "FAIL"))
        if cfg != "off":
            fails, ad = [], []
            for k in cells:
                if k[0] != cfg or "A" not in cells[k] or ("off", k[1], k[2]) not in cells:
                    continue
                m, se = diff(cells[k]["A"], cells[("off", k[1], k[2])]["A"])
                ad.append(abs(m))
                if abs(m) > 3 and abs(m) > se:
                    fails.append("%s v %s %+.1f +-%.1f" % (k[1], k[2], m, se))
            if ad:
                print("PWBAR5 %s: %d of %d type x style cells moved beyond 3 and 2 SE (no plan, no coach); mean |change| %.1f" % (cfg, len(fails), len(ad), sum(ad) / len(ad)))
                for f in fails:
                    print("   ", f)


if __name__ == "__main__":
    st = sys.argv[1]
    ps = [p for a in sys.argv[2:] for p in sorted(glob.glob(a))]
    if st == "bars":
        x = [p for p in ps if "cbx" in p]
        nn = [p for p in ps if "none" in p]
        bars([p for p in ps if p not in x and p not in nn], x, nn)
    else:
        {"ctl": ctl, "ident": ident, "loops": loops, "film": film, "play": play, "pw": pw}[st](ps)
