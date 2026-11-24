import json, sys, math, collections
# CORNERBASE1 summary (S547, ops/research/TASK_CORNERBASE1.md). Tables (a)-(e), the share of rounds rested, wind per bell.
# python tools/cornerbase1_sum.py <jsonl> [<jsonl> ...]   (the parts of a split run, e.g. full_L3.jsonl full_L6.jsonl)
COACHES = ["plan", "file", "skill35", "skill58", "skill80"]
NAME = {"plan": "BLIND", "file": "FILE", "skill35": "FILE+SKILL 35", "skill58": "FILE+SKILL 58", "skill80": "FILE+SKILL 80",
        "reader_nr": "READER"}
READER = "reader_nr"


def load(paths):
    by, run = {}, {}
    for p in paths:
        for ln in open(p, encoding="utf-8"):
            ln = ln.strip()
            if not ln.startswith("{"):
                continue
            r = json.loads(ln)
            if r.get("tag") == "run":
                run = r
                continue
            if "agg" not in r:
                continue
            by[(r["L"], r["cell"], r["boxer"], r["pol"])] = r["agg"]
    return by, run


def score(o):
    return [1.0 if c == "2" else (0.5 if c == "1" else 0.0) for c in o]


def paired(a, b):   # b - a, wins in 100, and 2 SE of the paired difference
    sa, sb = score(a), score(b)
    n = min(len(sa), len(sb))
    if n == 0:
        return 0.0, 0.0, 0
    d = [sb[i] - sa[i] for i in range(n)]
    m = sum(d) / n
    v = sum((x - m) ** 2 for x in d) / max(1, n - 1)
    return 100 * m, 200 * math.sqrt(v / n), n


def fmt(t):
    return "%+.1f +-%.1f" % (t[0], t[1])


def main(paths):
    by, run = load(paths)
    Ls = sorted({k[0] for k in by})
    cells = []
    boxers = []
    pols = []
    for (L, c, b, p) in by:
        if c not in cells: cells.append(c)
        if b not in boxers: boxers.append(b)
        if p not in pols: pols.append(p)
    fights = [p for p in pols if p.startswith("c:")]

    def outs(L, p, bs=None, cs=None):
        return "".join(by[(L, c, b, p)]["outs"] for b in (bs or boxers) for c in (cs or cells) if (L, c, b, p) in by)

    def agg_sum(L, p, key, bs=None):
        return sum(int(by[(L, c, b, p)].get(key, 0)) for b in (bs or boxers) for c in cells if (L, c, b, p) in by)

    print("# CORNERBASE1 tables (%s)" % ", ".join(paths))
    print("bouts a boxer, cell and arm: %d; boxers: %s; cells: %s" % (len(by[(Ls[0], cells[0], boxers[0], "plan")]["outs"]), ", ".join(boxers), ", ".join(cells)))
    for L in Ls:
        print("\n## %d rounds" % L)
        print("\nWins in 100 per arm (all cells): " + "; ".join("%s %.1f" % (NAME.get(p, p), 100 * sum(score(outs(L, p))) / len(outs(L, p))) for p in COACHES + [READER] + fights))
        # (a)
        print("\n### (a) READER minus each coach (wins in 100, +- 2 SE) - the worth of the live corner over that coach")
        print("| boxer | " + " | ".join(NAME[c] for c in COACHES) + " |")
        print("|---|" + "---|" * len(COACHES))
        for b in boxers + ["ALL"]:
            bs = None if b == "ALL" else [b]
            print("| %s | %s |" % ("**all five**" if b == "ALL" else b, " | ".join(fmt(paired(outs(L, c, bs), outs(L, READER, bs))) for c in COACHES)))
        print("\nper cell, READER minus FILE+SKILL 58 / minus BLIND (all boxers): " + "; ".join("%s %s / %s" % (c, fmt(paired(outs(L, "skill58", cs=[c]), outs(L, READER, cs=[c]))), fmt(paired(outs(L, "plan", cs=[c]), outs(L, READER, cs=[c])))) for c in cells))
        # (b)
        print("\n### (b) each coach minus BLIND - what a player who sims would gain if the game's own call were that coach")
        print("| boxer | " + " | ".join(NAME[c] for c in COACHES[1:]) + " |")
        print("|---|" + "---|" * (len(COACHES) - 1))
        for b in boxers + ["ALL"]:
            bs = None if b == "ALL" else [b]
            print("| %s | %s |" % ("**all five**" if b == "ALL" else b, " | ".join(fmt(paired(outs(L, "plan", bs), outs(L, c, bs))) for c in COACHES[1:])))
        print("\nper cell, FILE minus BLIND (all boxers): " + "; ".join("%s %s" % (c, fmt(paired(outs(L, "plan", cs=[c]), outs(L, "file", cs=[c])))) for c in cells))
        # rests
        print("\n### Corners: share of between-round calls that were Reset (rest) / Hands up (hurt); file read right")
        print("| boxer | " + " | ".join(NAME[c] for c in COACHES[1:]) + " |")
        print("|---|" + "---|" * (len(COACHES) - 1))
        for b in boxers + ["ALL"]:
            bs = None if b == "ALL" else [b]
            cellsv = []
            for c in COACHES[1:]:
                n = max(1, agg_sum(L, c, "c_corners", bs))
                cellsv.append("rest %.0f%% hands %.0f%% right %.0f%%" % (100.0 * agg_sum(L, c, "c_rests", bs) / n, 100.0 * agg_sum(L, c, "c_hands", bs) / n,
                    100.0 * agg_sum(L, c, "c_right", bs) / max(1, agg_sum(L, c, "c_bouts", bs))))
            print("| %s | %s |" % ("**all five**" if b == "ALL" else b, " | ".join(cellsv)))
        # best fixed
        bestf = max(fights, key=lambda p: sum(score(outs(L, p))))
        print("\nBest fixed arm (a command held all bout, ring at Centre; the highest all-cell mean): %s; READER minus it %s; it minus FILE+SKILL 58 %s"
              % (bestf, fmt(paired(outs(L, bestf), outs(L, READER))), fmt(paired(outs(L, "skill58"), outs(L, bestf)))))
        # (c) bar 8
        for base in ("plan", "skill58"):
            b8 = []
            for c in cells:
                for p in fights:
                    d = paired(outs(L, base, cs=[c]), outs(L, p, cs=[c]))
                    b8.append((d[0], d[1], c, p))
            b8.sort(reverse=True)
            over = [x for x in b8 if x[0] > 10]
            print("\n### (c) bar 8 v %s: a command held all bout beats it by more than 10 in a cell? %s; top: %s"
                  % (NAME[base], "FAIL (%d cell-commands)" % len(over) if over else "PASS", "; ".join("%s v %s %+.1f +-%.1f" % (x[3][2:], x[2], x[0], x[1]) for x in b8[:6])))
        # (d) bar 5
        for base in ("plan", "skill58"):
            dis = []
            rowsd = []
            for p in fights:
                ds = [paired(outs(L, base, [b]), outs(L, p, [b])) for b in boxers]
                rowsd.append((p, ds))
                if any(x[0] > 1 for x in ds) and any(x[0] < -1 for x in ds):
                    dis.append(p[2:])
            print("\n### (d) bar 5 (base %s): the five boxers disagree (one over +1, one under -1) on %d commands -> %s: %s"
                  % (NAME[base], len(dis), "PASS" if len(dis) >= 4 else "FAIL", ", ".join(dis)))
            print("| command | " + " | ".join(boxers) + " |")
            print("|---|" + "---|" * len(boxers))
            for p, ds in rowsd:
                print("| %s | %s |" % (p[2:], " | ".join(fmt(x) for x in ds)))
        # (e)
        print("\n### (e) the coach's rating, when the player sims (paired: the 80 coach is right in every bout the 58 is)")
        print("| boxer | 58 - 35 | 80 - 58 | 80 - 35 |")
        print("|---|---|---|---|")
        for b in boxers + ["ALL"]:
            bs = None if b == "ALL" else [b]
            print("| %s | %s | %s | %s |" % ("**all five**" if b == "ALL" else b, fmt(paired(outs(L, "skill35", bs), outs(L, "skill58", bs))),
                fmt(paired(outs(L, "skill58", bs), outs(L, "skill80", bs))), fmt(paired(outs(L, "skill35", bs), outs(L, "skill80", bs)))))
        # wind
        print("\n### Wind at each bell (mean of the cells)")
        print("| arm | " + " | ".join(boxers) + " |")
        print("|---|" + "---|" * len(boxers))
        for p in ["plan", "file", "skill58", READER, "c:reset", "c:get_out"]:
            cs2 = []
            for b in boxers:
                ws = [by[(L, c, b, p)]["wind"] for c in cells if (L, c, b, p) in by]
                n = min(len(w) for w in ws)
                cs2.append(" ".join("%.0f" % (sum(w[j] for w in ws) / len(ws)) for j in range(n)))
            print("| %s | %s |" % (NAME.get(p, p), " | ".join(cs2)))
    pop = run.get("population", [])
    if pop:
        print("\n## Population (command grades)")
        for p in pop:
            g = p[10]
            words = [str(g[k]["word"]) for k in g]
            print("- %s (%s, %s): %s - Poor %d / OK %d / Good %d" % (p[0], p[1], p[2], ", ".join("%s %s" % (k, g[k]["word"]) for k in g),
                  words.count("Poor"), words.count("OK"), words.count("Good")))


if __name__ == "__main__":
    main(sys.argv[1:])
