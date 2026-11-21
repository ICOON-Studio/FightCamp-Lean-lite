"""turnprobe11_sum.py - TURNPROBE11 (S534): the JSON lines of tools/turnprobe11.gd as the tables of docs/TURNPROBE11_RESULT.md.

    python tools/turnprobe11_sum.py <jsonl> [<jsonl> ...]      # prints markdown

A CELL is seats on the day of the call x gym, pooled over the boxers and the call days (each one roll of the dice).
"Right" (map v11 section 9) = an option whose pass rate is within 5 points of the cell's best.
"Best on money" (DEPTH_AUDIT_S534's line) = the option with the highest mean gym cash at the last week less the call's.
"""
import json
import sys
from collections import defaultdict

RIGHT_PTS = 5.0


def mean(xs):
    xs = list(xs)
    return sum(xs) / len(xs) if xs else 0.0


def load(paths):
    rows = []
    for p in paths:
        with open(p, encoding="utf-8") as fh:
            for line in fh:
                line = line.strip()
                if line.startswith("{"):
                    rows.append(json.loads(line))
    return rows


def opt(r):
    return "%s %s" % ("ticket" if r["house"] == "bow" else "guarantee", "no ask" if r["ask"] == "none" else r["ask"])


def stats(rs):
    n = len(rs)
    deb = [r["deb"] for r in rs if r["deb"]]
    o = lambda k: 100.0 * sum(1 for d in deb if d["o"] == k) / max(1, len(deb))
    return {
        "n": n, "pass": 100.0 * sum(1 for r in rs if r["pass"]) / max(1, n),
        "win": o("win"), "draw": o("draw"), "loss": o("loss"), "stop": 100.0 * sum(1 for d in deb if d["stop"]) / max(1, len(deb)),
        "sold": mean(d["sold"] for d in deb), "gym": mean(d["gym"] for d in deb), "her": mean(d["her"] for d in deb),
        "crowd": mean(d.get("crowd", 0) for d in deb),
        "booked": 100.0 * sum(1 for r in rs if r["second_day"] >= 0 and r["deb"] and r["second_day"] - r["deb"]["day"] <= 112) / max(1, n),
        "cash2": 100.0 * sum(1 for r in rs if r["second_day"] >= 0 and r["second_cash"] >= r["cash0"]) / max(1, n),
        "cash": mean(r["end"]["cash"] - r["cash0"] for r in rs), "members": mean(r["end"]["members"] for r in rs),
        "rep": mean(r["end"]["rep"] for r in rs), "morale": mean(r["end"]["morale"] for r in rs), "loy": mean(r["end"]["loy"] for r in rs),
        "dur": mean(r["end"]["dur"] for r in rs), "pw": mean(r["end"]["pw"] for r in rs), "pl": mean(r["end"]["pl"] for r in rs),
        "here": 100.0 * sum(1 for r in rs if r["end"]["here"] and not r["end"]["closed"]) / max(1, n),
    }


def cells_of(car, arm, by_boxer=False):
    out = defaultdict(lambda: defaultdict(list))
    for r in car:
        if r["arm"] != arm:
            continue
        key = (r["gym"], r["seats"], r["who"]) if by_boxer else (r["gym"], r["seats"])
        out[key][opt(r)].append(r)
    return out


def judge(cell, key):
    """-> {option: (value, right)} on one readout; right = within the band of the best."""
    vals = {o: stats(rs)[key] for o, rs in cell.items()}
    best = max(vals.values())
    band = RIGHT_PTS if key == "pass" else 0.0
    return {o: (v, v >= best - band - 1e-9) for o, v in vals.items()}, best


def house_of(o):
    return o.split(" ")[0]


def tally(cells, key):
    n = len(cells)
    house_right = defaultdict(int); alone = defaultdict(int); opt_right = defaultdict(int); opt_shown = defaultdict(int)
    for cell in cells.values():
        j, _ = judge(cell, key)
        hs = {house_of(o) for o, (_, ok) in j.items() if ok}
        for h in hs:
            house_right[h] += 1
        if len(hs) == 1:
            alone[next(iter(hs))] += 1
        for o, (_, ok) in j.items():
            opt_shown[o] += 1
            opt_right[o] += 1 if ok else 0
    return n, house_right, alone, opt_right, opt_shown


def p_tally(title, cells, key):
    n, hr, al, orr, osh = tally(cells, key)
    print("\n**%s** (%d cells)\n" % (title, n))
    print("| | cells where it is right / best | of the cells it shows in | alone |")
    print("|---|---|---|---|")
    for h in ["ticket", "guarantee"]:
        print("| The %s house | %d (%.0f%%) | %d | %d (%.0f%%) |" % (h, hr[h], 100.0 * hr[h] / max(1, n), n, al[h], 100.0 * al[h] / max(1, n)))
    for o in sorted(osh):
        print("| %s | %d (%.0f%%) | %d | |" % (o, orr[o], 100.0 * orr[o] / max(1, osh[o]), osh[o]))


def main():
    rows = load(sys.argv[1:])
    calls = [r for r in rows if r.get("tag") == "call"]
    # a call day counted once: the first run's later calls could land on one day (the boxer was booked), the same dice twice
    first = {}
    for r in sorted(calls, key=lambda r: r["k"]):
        first.setdefault((r["who"], r["day"]), r["k"])
    dup = {(r["who"], r["k"]) for r in calls if first[(r["who"], r["day"])] != r["k"]}
    calls = [r for r in calls if (r["who"], r["k"]) not in dup]
    car = [r for r in rows if r.get("tag") == "career" and (r["who"], r["k"]) not in dup]
    nights = [r for r in rows if r.get("tag") == "night"]
    print("## Population\n")
    for r in rows:
        if r.get("tag") == "run" and r.get("stage") == "b":
            print("- run: boxers %s, %s call days, to week %s, seats %s, gyms %s (crunch at %s)" % (r["boxers"], r["days"], r["weeks"], r["seats"], r["gyms"], r.get("cseats")))
    print("\n| Boxer | Call | Day | Record | Strength (no camp) | Gym's own seats that day | Loyalty | Wish |")
    print("|---|---|---|---|---|---|---|---|")
    seen = set()
    for r in sorted(calls, key=lambda r: (r["b"], r["k"])):
        if (r["b"], r["k"]) in seen:
            continue
        seen.add((r["b"], r["k"]))
        print("| %s (%s) | %d | %d | %d-%d | %.1f | %d | %d | %s |" % (r["who"], r["style"], r["k"], r["day"], r["w"], r["l"], r["night"], r["seats_real"], r["loyalty"],
            {"bow": "the test", "hf": "the guaranteed purse", "": "none"}[r["wish"]]))
    print("\nCareers played: %d (%s)." % (len(car), ", ".join("%s %d" % (a, sum(1 for r in car if r["arm"] == a)) for a in ["control", "v11", "mutant", "nowish"])))

    if nights:
        print("\n## Stage A - the night (same scratch nights for every row of a boxer)\n")
        print("| Boxer | Rules | Option | Debutant | Card shows | Played win / draw / loss | Stopped losses |")
        print("|---|---|---|---|---|---|---|")
        for r in nights:
            n = r["n"]
            print("| %s | %s | %s | %s, rated %.1f | %.1f | %.1f / %.1f / %.1f | %.1f |" % (r["who"], r["arm"], opt(r), r["opp"], r["rating"], 100 * r["shown"],
                100.0 * r["win"] / n, 100.0 * r["draw"] / n, 100.0 * r["loss"] / n, 100.0 * r["stop_l"] / n))
        print("\n| Rules | Option | Boxers | Card shows (mean) | Played win (mean) | lowest .. highest | Loss | Within 10 of the card |")
        print("|---|---|---|---|---|---|---|---|")
        grp = defaultdict(list)
        for r in nights:
            grp[(r["arm"], opt(r))].append(r)
        for (arm, o), rs in grp.items():
            w = [100.0 * r["win"] / r["n"] for r in rs]
            near = sum(1 for r in rs if abs(100.0 * r["win"] / r["n"] - 100 * r["plain"]) <= 10.0)
            print("| %s | %s | %d | %.1f | %.1f | %.1f .. %.1f | %.1f | %d of %d |" % (arm, o, len(rs), mean(100 * r["shown"] for r in rs), mean(w), min(w), max(w),
                mean(100.0 * r["loss"] / r["n"] for r in rs), near, len(rs)))

    for arm in ["control", "v11"]:
        cells = cells_of([r for r in car if r["gym"] in ("healthy", "crunch")], arm)
        if not cells:
            continue
        print("\n## Stage B - %s, cell by cell (pooled over boxers and call days)\n" % ("TODAY'S RULES (control)" if arm == "control" else "MAP v11"))
        print("| Gym | Seats at the call | Option | n | Pass | 2nd fight in 16 wk | cash kept at the 2nd booking | Debut win / draw / loss | Seats on the night | Gym's cut | Boxer's pay | Cash by the last week | Members | Reputation | Morale | Loyalty | Chin ceiling | Pro wins - losses | Still here |")
        print("|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|")
        for key in sorted(cells):
            jp, _ = judge(cells[key], "pass"); jc, _ = judge(cells[key], "cash")
            for o in sorted(cells[key]):
                s = stats(cells[key][o])
                print("| %s | %d | %s%s | %d | %.0f%% | %.0f%% | %.0f%% | %.0f / %.0f / %.0f | %.0f | $%.0f | $%.0f | %+.0f | %.0f | %.0f | %.0f | %.0f | %.1f | %.1f - %.1f | %.0f%% |" % (
                    key[0], key[1], o, " **(best on money)**" if jc[o][1] else "", s["n"], s["pass"], s["booked"], s["cash2"], s["win"], s["draw"], s["loss"], s["sold"],
                    s["gym"], s["her"], s["cash"], s["members"], s["rep"], s["morale"], s["loy"], s["dur"], s["pw"], s["pl"], s["here"]))
        p_tally("%s: right on the map's pass rate (within 5 points of the cell's best)" % arm, cells, "pass")
        p_tally("%s: best on money (gym cash by the last week)" % arm, cells, "cash")
        p_tally("%s: best on members" % arm, cells, "members")
        p_tally("%s: best on pro wins" % arm, cells, "pw")
        spread = []
        for cell in cells.values():
            v = [stats(rs)["cash"] for rs in cell.values()]
            spread.append(max(v) - min(v))
        print("\nBest option against the worst, gym cash: mean $%.0f a cell (smallest $%.0f, largest $%.0f)." % (mean(spread), min(spread), max(spread)))
        bcells = cells_of([r for r in car if r["gym"] in ("healthy", "crunch")], arm, True)
        p_tally("%s: best on money, boxer by boxer (a cell = boxer x seats x gym)" % arm, bcells, "cash")
        print("\n| Seats at the call | 48 | 56 | 64 | 72 |\n|---|---|---|---|---|")
        for h in ["ticket", "guarantee"]:
            line = []
            for s in [48, 56, 64, 72]:
                sub = {k: v for k, v in bcells.items() if k[1] == s}
                n, hr, _, _, _ = tally(sub, "cash") if sub else (0, {}, 0, 0, 0)
                line.append("%d of %d" % (hr.get(h, 0), n) if sub else "-")
            print("| %s house best on money | %s |" % (h, " | ".join(line)))

    # the mutant, the wish, the lean, the made cases
    v = [r for r in car if r["arm"] in ("v11", "mutant") and r["gym"] == "healthy"]
    if any(r["arm"] == "mutant" for r in v):
        print("\n## The mutant (v11 with the guarantee purse back at $1,800), healthy cells\n")
        print("| Seats | v11 guarantee no ask: cash | MUTANT guarantee no ask: cash | best v11 ticket option: cash | mutant ahead of every ticket option |")
        print("|---|---|---|---|---|")
        for s in sorted({r["seats"] for r in v}):
            g = stats([r for r in v if r["seats"] == s and r["arm"] == "v11" and opt(r) == "guarantee no ask"])["cash"]
            m = stats([r for r in v if r["seats"] == s and r["arm"] == "mutant"])["cash"]
            tb = max(stats([r for r in v if r["seats"] == s and r["arm"] == "v11" and opt(r) == o])["cash"] for o in {opt(r) for r in v if r["house"] == "bow"})
            print("| %d | %+.0f | %+.0f | %+.0f | %s |" % (s, g, m, tb, "yes" if m > tb else "no"))
    k0 = [r for r in car if r["k"] == 0 and r["ask"] == "none" and r["arm"] in ("v11", "nowish") and r["wish"] != "" or (r["arm"] == "nowish")]
    if any(r["arm"] == "nowish" for r in car):
        print("\n## The wish (call day 0, no ask; the same careers with the wish off)\n")
        print("| House signed | Wish | n | Pass | Morale by the last week | Loyalty | Cash | Pro wins |")
        print("|---|---|---|---|---|---|---|---|")
        base = [r for r in car if r["k"] == 0 and r["ask"] == "none" and r["gym"] in ("healthy", "crunch")]
        ids = {(r["who"], r["seats"], r["gym"]) for r in base if r["arm"] == "nowish"}
        for h in ["bow", "hf"]:
            for arm in ["v11", "nowish"]:
                rs = [r for r in base if r["arm"] == arm and r["house"] == h and (r["who"], r["seats"], r["gym"]) in ids]
                if rs:
                    s = stats(rs)
                    print("| %s | %s | %d | %.0f%% | %.1f | %.1f | %+.0f | %.2f |" % ("ticket" if h == "bow" else "guarantee", "on" if arm == "v11" else "off", s["n"], s["pass"], s["morale"], s["loy"], s["cash"], s["pw"]))
    print("\n## The house's lean (first six pro fights)\n")
    for arm in ["control", "v11"]:
        for h in ["bow", "hf"]:
            rs = [r for r in car if r["arm"] == arm and r["house"] == h]
            sets = sum(r["lean"][0] for r in rs); ls = sum(r["lean"][1] for r in rs); df = sum(r["lean"][2] for r in rs)
            if sets:
                print("- %s, %s house: %d sets of pro offers, the house added a row in %d (%.0f%%), the bot's pick changed in %d (%.0f%% of sets)." % (
                    arm, "ticket" if h == "bow" else "guarantee", sets, ls, 100.0 * ls / sets, df, 100.0 * df / sets))
    made = [r for r in car if r["gym"] in ("crunch52", "dayjob")]
    if made:
        print("\n## Made cases\n")
        print("| Case | Rules | Option | n | Gym's share | Pass | Gym's cut on the night | Boxer's pay | Cash by the last week | Loyalty | Morale | Still here |")
        print("|---|---|---|---|---|---|---|---|---|---|---|---|")
        grp = defaultdict(list)
        for r in made:
            grp[(r["gym"], r["arm"], opt(r))].append(r)
        for (gym, arm, o), rs in sorted(grp.items()):
            s = stats(rs)
            print("| %s | %s | %s | %d | %.0f%% | %.0f%% | $%.0f | $%.0f | %+.0f | %.0f | %.0f | %.0f%% |" % (gym, arm, o, s["n"], 100 * mean(r["share"] for r in rs), s["pass"], s["gym"], s["her"], s["cash"], s["loy"], s["morale"], s["here"]))


if __name__ == "__main__":
    main()
