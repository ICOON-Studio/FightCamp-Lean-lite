import json, sys, math, collections
# CORNERCMD1 summary: paired wins in 100 with 2 SE, per cell / boxer / length, against a base arm.
def load(p):
    rows = []
    for ln in open(p, encoding="utf-8"):
        ln = ln.strip()
        if ln.startswith("{"):
            rows.append(json.loads(ln))
    return rows

def score(o):
    return [1.0 if c == "2" else (0.5 if c == "1" else 0.0) for c in o]

def paired(a, b):
    sa, sb = score(a), score(b)
    n = min(len(sa), len(sb))
    d = [sb[i] - sa[i] for i in range(n)]
    m = sum(d) / n
    v = sum((x - m) ** 2 for x in d) / max(1, n - 1)
    return 100 * m, 200 * math.sqrt(v / n)

def table(path, base="plan", tag=None):
    rows = [r for r in load(path) if r.get("tag") not in ("run",) and (tag is None or r.get("tag") == tag)]
    by = collections.defaultdict(dict)
    for r in rows:
        by[(r["L"], r["cell"], r["boxer"])][r["pol"]] = r["agg"]
    return by

def main_table():
    path = sys.argv[1]
    base = sys.argv[2] if len(sys.argv) > 2 else "plan"
    by = table(path, base)
    pols = []
    for k, v in by.items():
        for p in v:
            if p not in pols:
                pols.append(p)
    print("| L | cell | boxer | " + " | ".join(pols) + " |")
    tot = collections.defaultdict(list)
    for k in sorted(by):
        v = by[k]
        cells = []
        for p in pols:
            g = v.get(p)
            if not g:
                cells.append("")
                continue
            w = 100 * (g["w"] + 0.5 * g["d"]) / g["n"]
            if p == base:
                cells.append("%.1f" % w)
            else:
                d, se = paired(v[base]["outs"], g["outs"])
                tot[(k[0], p)].append((v[base]["outs"], g["outs"]))
                cells.append("%.1f (%+.1f +-%.1f) ce %.1f" % (w, d, se, g.get("ce_ex", 0)))
        print("| %d | %s | %s | %s |" % (k[0], k[1], k[2], " | ".join(cells)))
    for (L, p), lst in sorted(tot.items()):
        a = "".join(x[0] for x in lst); b = "".join(x[1] for x in lst)
        d, se = paired(a, b)
        print("ALL L%d %s vs %s: %+.2f +-%.2f (n=%d)" % (L, p, base, d, se, len(a)))


def pooled(by, L, cell, pol, boxers):
    o = ""
    for b in boxers:
        g = by.get((L, cell, b), {}).get(pol)
        if g:
            o += g["outs"]
    return o

def mean(o):
    s = score(o)
    return 100.0 * sum(s) / max(1, len(s))

def bars(path):
    by = collections.defaultdict(dict)
    for r in load(path):
        if r.get("tag") in ("run", "walk", None):
            continue
        k = (r["L"], r["cell"], r["boxer"], r["pol"])
        g = r["agg"]
        cur = by[(r["L"], r["cell"], r["boxer"])].get(r["pol"])
        if cur is None:
            by[(r["L"], r["cell"], r["boxer"])][r["pol"]] = json.loads(json.dumps(g))
        else:   # a later chunk: append its bouts
            cur["outs"] += g["outs"]
            for kk in ("n", "w", "d", "cmd_on", "nx", "right", "wrong", "changes", "wind_low60"):
                cur[kk] = cur.get(kk, 0) + g.get(kk, 0)
            for kk in ("picks", "sits", "fits"):
                for a, v in g.get(kk, {}).items():
                    cur[kk][a] = cur[kk].get(a, 0) + v
            for kk in ("wind", "head"):   # weighted mean of the bell means
                n0 = cur["n"] - g["n"]
                cur[kk] = [(x * n0 + y * g["n"]) / cur["n"] for x, y in zip(cur[kk], g[kk])] if len(cur[kk]) == len(g[kk]) else cur[kk]
            cur["wind_min"] = min(cur.get("wind_min", 999), g.get("wind_min", 999))
    Ls = sorted({k[0] for k in by})
    cells = []
    boxers = []
    pols = []
    for (L, c, b), v in by.items():
        if c not in cells: cells.append(c)
        if b not in boxers: boxers.append(b)
        for p in v:
            if p not in pols: pols.append(p)
    singles = [p for p in pols if p.startswith("c:") or p.startswith("r:")]
    fights = [p for p in pols if p.startswith("c:")]
    pairs = [p for p in pols if p.startswith("p:")]
    fixed = ["plan", "push45"] + singles + pairs
    out = {}
    for L in Ls:
        print("\n## %d rounds" % L)
        W = {(c, p): pooled(by, L, c, p, boxers) for c in cells for p in pols}
        nb = len(W[(cells[0], "plan")])
        print("bouts a cell and arm (both boxers): %d" % nb)
        # per-cell table
        print("| cell | plan | push45 | reader | coach40 | coach58 | coach75 | alt | best single | worst single | best pair |")
        print("|---|---|---|---|---|---|---|---|---|---|---|")
        bestfix = collections.Counter()
        b4 = 0; b6 = collections.Counter(); b7 = collections.Counter(); b8 = []
        for c in cells:
            row = {p: mean(W[(c, p)]) for p in pols}
            bs = max(singles, key=lambda p: row[p]); ws = min(singles, key=lambda p: row[p]); bp = max(pairs, key=lambda p: row[p])
            bf = max(fixed, key=lambda p: row[p]); bestfix[bf] += 1
            d4, se4 = paired(W[(c, "plan")], W[(c, ws)])
            if d4 <= -4: b4 += 1
            ring = max(["plan", "r:cut", "r:ropes"], key=lambda p: row[p]); b6[ring] += 1
            for p in ("c:let_go", "c:sit"):
                dr, _ = paired(W[(c, p)], W[(c, "reader")])
                gw = {}
                for b in boxers:
                    gr = by[(L, c, b)]
                    gw.setdefault("aw", []).append(gr[p]["wind"][-1]); gw.setdefault("rw", []).append(gr["reader"]["wind"][-1])
                    gw.setdefault("ah", []).append(gr[p]["head"][-1]); gw.setdefault("rh", []).append(gr["reader"]["head"][-1])
                worse = sum(gw["aw"]) < sum(gw["rw"]) or sum(gw["ah"]) > sum(gw["rh"])
                if dr >= 3 and worse: b7[p] += 1
            for p in singles:
                d8, _ = paired(W[(c, "plan")], W[(c, p)])
                b8.append((d8, c, p))
            def f(p):
                d, se = paired(W[(c, "plan")], W[(c, p)])
                return "%.1f (%+.1f+-%.1f)" % (row[p], d, se)
            print("| %s | %.1f | %s | %s | %s | %s | %s | %s | %s %s | %s %s | %s %s |" % (c, row["plan"], f("push45"), f("reader"), f("coach40"), f("coach58"), f("coach75"), f("alt"), bs, f(bs), ws, f(ws), bp, f(bp)))
        allo = lambda p: "".join(W[(c, p)] for c in cells)
        res = {}
        top = bestfix.most_common(1)[0]
        res["1"] = (top[1] <= 6, "most cells won by one non-reading arm: %s in %d of %d" % (top[0], top[1], len(cells)))
        bestpair = max(pairs, key=lambda p: mean(allo(p)))
        d2p, s2p = paired(allo(bestpair), allo("reader"))
        d2, s2 = paired(allo("plan"), allo("reader"))
        pc = "".join(W[(c, max(pairs, key=lambda p: mean(W[(c, p)])))] for c in cells)
        d2c, s2c = paired(pc, allo("reader"))
        res["2"] = (d2p >= 3 and d2 >= 5, "reader - best pair (%s) %+.1f+-%.1f; reader - plan %+.1f+-%.1f; (reader - each cell's best pair, post hoc: %+.1f+-%.1f)" % (bestpair, d2p, s2p, d2, s2, d2c, s2c))
        rp = collections.Counter(); on = 0
        for c in cells:
            for b in boxers:
                for k, v in by[(L, c, b)]["reader"]["picks"].items():
                    cm, rg = k.split("|")[0], k.split("|")[1]
                    if cm != "-" or rg != "-": on += v
                    if cm != "-": rp["c:" + cm] += v
                    if rg != "-": rp["r:" + rg] += v
        shares = {p: 100.0 * rp[p] / max(1, on) for p in singles}
        n5 = sum(1 for p in singles if shares[p] >= 5)
        res["3"] = (n5 >= 8, "commands the reader picks in 5%%+ of command exchanges: %d of %d (%s)" % (n5, len(singles), ", ".join("%s %.0f%%" % (p[2:], shares[p]) for p in singles)))
        res["4"] = (b4 >= 6, "cells where the worst command held all bout loses 4+ to PLAN ONLY: %d" % b4)
        dis = []
        for p in singles:
            ds = []
            for b in boxers:
                o0 = "".join(by[(L, c, b)]["plan"]["outs"] for c in cells); o1 = "".join(by[(L, c, b)][p]["outs"] for c in cells)
                ds.append(paired(o0, o1))
            if (ds[0][0] > 1 and ds[1][0] < -1) or (ds[1][0] > 1 and ds[0][0] < -1):
                dis.append("%s (%+.1f / %+.1f)" % (p[2:], ds[0][0], ds[1][0]))
        res["5"] = (len(dis) >= 4, "commands the two boxers disagree on: %d - %s" % (len(dis), "; ".join(dis)))
        res["6"] = (b6["r:cut"] >= 2 and b6["r:ropes"] >= 2, "best ring stop by cell: %s" % dict(b6))
        res["7"] = (b7["c:let_go"] >= 3 and b7["c:sit"] >= 3, "cells 3+ behind the reader with worse wind/head: let_go %d, sit %d" % (b7["c:let_go"], b7["c:sit"]))
        b8.sort(reverse=True)
        res["8"] = (b8[0][0] <= 10, "largest single-command gain over PLAN ONLY: %+.1f (%s, %s); bells at 0 wind min %.1f" % (b8[0][0], b8[0][2], b8[0][1], min(by[k][p].get("wind_min", 99) for k in by for p in by[k])))
        d75, s75 = paired(allo("reader"), allo("coach75")); d40, s40 = paired(allo("reader"), allo("coach40")); d58, s58 = paired(allo("reader"), allo("coach58"))
        res["9"] = (d75 >= -3 and d40 <= -3, "coach - reader: 75 %+.1f+-%.1f, 58 %+.1f+-%.1f, 40 %+.1f+-%.1f" % (d75, s75, d58, s58, d40, s40))
        da, sa = paired(allo("reader"), allo("alt"))
        print("\nalt (let_go / reset every other exchange) - reader: %+.1f+-%.1f" % (da, sa))
        for k in sorted(res):
            print("BAR %s %s: %s" % (k, "PASS" if res[k][0] else "FAIL", res[k][1]))
        # per boxer singles
        print("\n| command | " + " | ".join(boxers) + " |")
        print("|---|" + "---|" * len(boxers))
        for p in singles + ["push45", "reader", "alt"]:
            cs = []
            for b in boxers:
                o0 = "".join(by[(L, c, b)]["plan"]["outs"] for c in cells); o1 = "".join(by[(L, c, b)][p]["outs"] for c in cells)
                d, se = paired(o0, o1)
                cs.append("%+.1f+-%.1f" % (d, se))
            print("| %s | %s |" % (p, " | ".join(cs)))
        out[L] = res
    return out

if __name__ == "__main__" and len(sys.argv) > 2 and sys.argv[2] == "bars":
    bars(sys.argv[1])

if __name__ == "__main__" and not (len(sys.argv) > 2 and sys.argv[2] == "bars"):
    main_table()
