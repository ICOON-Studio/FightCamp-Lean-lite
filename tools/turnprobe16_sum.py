"""turnprobe16_sum.py - TURNPROBE16 (S540): the JSON lines of tools/turnprobe16.gd as the tables of docs/TURNPROBE16_RESULT.md.

    python tools/turnprobe16_sum.py <jsonl> [<jsonl> ...]      # prints markdown

Bars: DESIGN_TURNPRO1_V16.md section 9 (written before the run). ROAD axes cash / name / RANKED (no record); five roads;
A beats B = ahead by a line on one axis, behind on none. RIGHT = beaten by nobody. ONE ANSWER = beats every other.
"""
import json
import math
import sys
from collections import defaultdict

LINE_CASH = 1000.0
LINE_WINS = 3.0
LINE_NAME = 3.0
LINE_RANK = 10.0
ERR_MAX = 400.0   # 54 rolls, not 216
FAV_CASH = 500.0
CELLS = ["48", "64", "full"]
HOUSES = [("bow", "ticket"), ("hf", "guarantee")]
OWN = {"bow": "test", "hf": "build"}
BASE = "guarantee build keeper"
TICKET = "ticket test keeper"
BOTS = ["name", "win", "keeper", "spender", "reader"]
FIXED = ["name", "win", "keeper", "spender"]
SCORED = ["3", "5", "6", "7", "8", "9", "R", "10", "11", "14", "16t", "16g", "S", "T", "F", "G"]
AUDIT = ["7", "8", "9", "R"]
PASS_AT = 13

def mean(xs):
    xs = list(xs)
    return sum(xs) / len(xs) if xs else 0.0

def se(xs):
    xs = list(xs)
    if len(xs) < 2:
        return 0.0
    m = mean(xs)
    return math.sqrt(sum((x - m) ** 2 for x in xs) / (len(xs) - 1) / len(xs))

def load(paths):
    rows = []
    for p in paths:
        with open(p, encoding="utf-8") as fh:
            for line in fh:
                line = line.strip()
                if line.startswith("{"):
                    try:
                        rows.append(json.loads(line))
                    except ValueError:
                        pass
    return rows

def hname(r):
    return "ticket" if r["house"] == "bow" else "guarantee"

def opt(r):
    if r["arm"] == "control":
        return "%s %s" % (hname(r), "no ask" if r["ask"] == "none" else r["ask"])
    if r["arm"] == "amateur":
        return "amateur"
    return "%s %s %s" % (hname(r), r["pick"], r["bot"])

def cash(r):
    return r["end"]["cash"] - r["cash0"]

def won(r):
    return 100.0 if r["deb"] and r["deb"]["o"] == "win" else 0.0

def rep(r):
    return float(r["end"]["rep"])

def rec(r):
    return float(r["end"]["pw"] - r["end"]["pl"])

def ranked(r):
    return 100.0 if r["end"]["rank"] > 0 else 0.0


AX = {"cash": (cash, LINE_CASH), "wins": (won, LINE_WINS), "name": (rep, LINE_NAME), "rank": (ranked, LINE_RANK), "rec": (rec, 1.0)}
HOUSE_AX = ["cash", "wins"]
ROAD_AX = ["cash", "name", "rank"]
NIGHT_AX = ["cash", "wins", "name"]

def gap(cell, a, b, axes):
    ra, rb = cell.get(a, {}), cell.get(b, {})
    ps = [(ra[k], rb[k]) for k in ra if k in rb]
    out = {"n": len(ps)}
    for ax in axes:
        d = [AX[ax][0](x) - AX[ax][0](y) for x, y in ps]
        out[ax] = mean(d)
        out[ax + "_se"] = se(d)
    return out

def ahead(g, ax):
    return g[ax] >= AX[ax][1]

def behind(g, ax):
    return g[ax] <= -AX[ax][1]

def beats(cell, a, b, axes):
    g = gap(cell, a, b, axes)
    return g["n"] > 0 and any(ahead(g, ax) for ax in axes) and not any(behind(g, ax) for ax in axes)

def differ(cell, a, b, axes):
    g = gap(cell, a, b, axes)
    return g["n"] > 0 and any(ahead(g, ax) or behind(g, ax) for ax in axes)

def verdict(cell, opts, axes):
    opts = [o for o in opts if o in cell]
    right = [a for a in opts if not any(beats(cell, b, a, axes) for b in opts if b != a)]
    one = [a for a in opts if len(opts) > 1 and all(beats(cell, a, b, axes) for b in opts if b != a)]
    return right, (one[0] if one else "")

def vs_word(cell, a, b, axes):
    if beats(cell, a, b, axes):
        return "A beats B"
    if beats(cell, b, a, axes):
        return "B beats A"
    return "a trade" if differ(cell, a, b, axes) else "no difference"

def cells_of(car, arm, by_boxer=False, stage="b"):
    out = defaultdict(lambda: defaultdict(dict))
    for r in car:
        if r["arm"] != arm or r.get("stage", "b") != stage:
            continue
        key = (r["cell"], r["who"]) if by_boxer else (r["cell"],)
        out[key][opt(r)][(r["who"], r["k"])] = r
    return out

def ckey(k):
    return CELLS.index(k[0]) if k[0] in CELLS else 9

def stat(rs):
    deb = [r["deb"] for r in rs if r["deb"]]
    o = lambda k: 100.0 * sum(1 for d in deb if d["o"] == k) / max(1, len(deb))
    kinds = defaultdict(int)
    for r in rs:
        for k, v in r["kinds"].items():
            kinds[k] += v
    booked = max(1, sum(kinds.values()))
    return {"n": len(rs), "win": o("win"), "draw": o("draw"), "loss": o("loss"), "name": mean(d.get("name", 0) for d in deb),
            "cash": mean(cash(r) for r in rs), "rep": mean(rep(r) for r in rs), "pw": mean(r["end"]["pw"] for r in rs), "pl": mean(r["end"]["pl"] for r in rs),
            "ranked": mean(ranked(r) for r in rs), "rank": mean(r["end"]["rank"] for r in rs if r["end"]["rank"] > 0),
            "step": 100.0 * (kinds["above"] + kinds["title"]) / booked, "tune": 100.0 * kinds["tune"] / booked, "rebuild": 100.0 * kinds["rebuild"] / booked,
            "title": mean(r["kinds"].get("title", 0) for r in rs), "spent": mean(r.get("spent", 0) for r in rs), "home": mean(r.get("home", 0) for r in rs),
            "poster": mean(r.get("poster", 0) for r in rs), "fav": mean(r.get("fav", 5) for r in rs), "belt": 100.0 * mean(1 if r.get("belt", "") else 0 for r in rs),
            "late": 100.0 * sum(r.get("forced", 0) for r in rs) / max(1, sum(r["sets"] for r in rs)),
            "closed": 100.0 * mean(1 if r["end"]["closed"] else 0 for r in rs)}

def main():
    rows = load(sys.argv[1:])
    calls = [r for r in rows if r.get("tag") == "call"]
    first = {}
    for r in calls:
        first.setdefault((r["who"], r["day"] // 7), r["k"])
    keep = {(r["who"], r["k"]) for r in calls if first[(r["who"], r["day"] // 7)] == r["k"]}
    car_all = [r for r in rows if r.get("tag") == "career" and (r["who"], r["k"]) in keep]
    car = [r for r in car_all if r.get("stage", "b") == "b"]
    carf = [r for r in car_all if r.get("stage", "b") == "f"]
    nights = [r for r in rows if r.get("tag") == "night"]
    own = [r for r in rows if r.get("tag") == "own"]
    bars = {}     # id -> (text, reads, ok)
    inst = {}
    reads = []

    print("## Population\n")
    runs = defaultdict(list)
    for r in rows:
        if r.get("tag") == "run":
            runs[r["stage"]].append(r)
    for s, rs in sorted(runs.items()):
        r = rs[0]
        print("- stage %s: boxers %s, %s call weeks a boxer, to week %s, cells %s (controls in %s)" % (s, sorted(b for x in rs for b in x["boxers"]), r["days"], r["weeks"], r["cells"], r["ctl"]))
    bcalls = [r for r in calls if (r["who"], r["k"]) in {(x["who"], x["k"]) for x in car}]
    print("\n| Boxer | Rolls | Call days | Record at the calls | Strength (no camp) | Gym's own seats at the call |")
    print("|---|---|---|---|---|---|")
    by = defaultdict(list)
    for r in bcalls:
        if (r["who"], r["k"]) in keep:
            by[(r["b"], r["who"], r["style"])].append(r)
    for (b, who, style), rs in sorted(by.items()):
        lo = min(rs, key=lambda r: r["day"]); hi = max(rs, key=lambda r: r["day"])
        print("| %s (%s) | %d | %d .. %d | %d-%d .. %d-%d | %.1f .. %.1f | %d .. %d |" % (who, style, len(rs), lo["day"], hi["day"], lo["w"], lo["l"], hi["w"], hi["l"],
            min(r["night"] for r in rs), max(r["night"] for r in rs), min(r["seats_real"] for r in rs), max(r["seats_real"] for r in rs)))
    n_arm = lambda a: sum(1 for r in car if r["arm"] == a)
    print("\nRolls: %d. Careers, stage B: %d (v16 %d, flat %d, today %d, amateur %d). Stage F: %d careers on %d rolls. Skipped (one house only): %d. Full-cell careers on a counter-call: %d." % (
        len({(r["who"], r["k"]) for r in car}), len(car), n_arm("v16"), n_arm("flat"), n_arm("control"), n_arm("amateur"), len(carf), len({(r["who"], r["k"]) for r in carf}),
        sum(1 for r in rows if r.get("tag") == "skip"), sum(1 for r in car if r.get("counter"))))
    real = [r["seats_real"] for r in calls if (r["who"], r["k"]) in keep]
    if real:
        both_today = 100.0 * sum(1 for s in real if 46 <= s <= 74) / len(real)
        big = 100.0 * sum(1 for s in real if s >= 75) / len(real)
        reads.append("Real calls (the bot's own road, no forced members, %d call weeks): %.0f%% at 46-74 seats (both houses call today), %.0f%% at 75+ (one house today; both with v16's counter-call), %.0f%% at 45 or fewer. v16 meets both houses on %.0f%% of real calls (today %.0f%%)." % (
            len(real), both_today, big, 100 - both_today - big, both_today + big, both_today))

    # ---------------------------------------------------------------- stage A
    if nights:
        print("\n## Stage A - the night (the same scratch nights for every row of a boxer)\n")
        print("| Rules | House | Debutant | Ask | Boxers | Card shows | Played win | lowest .. highest | Loss | Worst boxer: card less played |")
        print("|---|---|---|---|---|---|---|---|---|---|")
        grp = defaultdict(list)
        for r in nights:
            grp[(r["arm"], hname(r), r.get("pick", ""), r["ask"])].append(r)
        A = {}
        for key in sorted(grp):
            rs = grp[key]
            w = [100.0 * r["win"] / r["n"] for r in rs]
            off = [100 * r["shown"] - 100.0 * r["win"] / r["n"] for r in rs]
            A[key] = {"shown": mean(100 * r["shown"] for r in rs), "win": mean(w), "worst": max(off, key=abs)}
            print("| %s | %s | %s | %s | %d | %.1f | %.1f | %.1f .. %.1f | %.1f | %+.1f |" % ("today" if key[0] == "control" else key[0], key[1], key[2] or "-", key[3], len(rs),
                A[key]["shown"], mean(w), min(w), max(w), mean(100.0 * r["loss"] / r["n"] for r in rs), A[key]["worst"]))
        four = [("v16", "ticket", "test", "none"), ("v16", "ticket", "build", "none"), ("v16", "guarantee", "build", "none"), ("v16", "guarantee", "test", "none")]
        bands = [(52, 68), (62, 78), (70, 82), (60, 76)]
        if all(k in A for k in four):
            bars["3"] = ("Played debut wins in 100: ticket test 52-68, ticket build 62-78, guarantee build 70-82, guarantee test 60-76", ", ".join("%.1f" % A[k]["win"] for k in four),
                all(lo <= A[k]["win"] <= hi for k, (lo, hi) in zip(four, bands)))
            inst["I3"] = ("The card is honest (each debutant within 3 on the mean, no boxer more than 8)", "; ".join("%s %s %.1f shown / %.1f played, worst %+.1f" % (k[1], k[2], A[k]["shown"], A[k]["win"], A[k]["worst"]) for k in four),
                all(abs(A[k]["shown"] - A[k]["win"]) <= 3 and abs(A[k]["worst"]) <= 8 for k in four))
        t, gg = A.get(four[0]), A.get(four[2])
        lt, lg = A.get(("v16", "ticket", "test", "later2")), A.get(("v16", "guarantee", "build", "later2"))
        if t and gg and lt and lg:
            cardd = [lt["shown"] - t["shown"], lg["shown"] - gg["shown"]]
            play = [lt["win"] - t["win"], lg["win"] - gg["win"]]
            bars["14"] = ("Later +2: the card shows +1 to +4, the played gain is not below 0", "card %+.1f / %+.1f; played %+.1f / %+.1f" % (cardd[0], cardd[1], play[0], play[1]),
                all(1 <= c <= 4 for c in cardd) and all(p >= 0 for p in play))
    us = [r["us_bout"] for r in nights if "us_bout" in r] + [r["us_bout"] for r in own]
    if us:
        ms = mean(us) / 1000.0
        inst["I6"] = ("The card's cost: one hidden bout timed (reading)", "%.1f ms a bout (%d timings); the card's 2,000 own nights = %.0f s on one thread when the call comes; 400 nights (a band of about +/-5) = %.0f s" % (ms, len(us), 2000 * ms / 1000.0, 400 * ms / 1000.0), True)

    ctl = cells_of(car, "control")
    if ctl:
        rd = []; ok = True
        for key in sorted(ctl, key=ckey):
            g = gap(ctl[key], "guarantee costs", "guarantee no ask", HOUSE_AX)
            ok = ok and 700 <= g["cash"] <= 1100 and g["cash_se"] < 100
            rd.append("%s: %+.0f, error %.0f" % (key[0], g["cash"], g["cash_se"]))
        inst["I1"] = ("Today's costs ask reads +$700 to +$1,100 against today's plain guarantee house, error under $100", "; ".join(rd), ok)

    cells = cells_of(car, "v16")
    amat = cells_of(car, "amateur")
    print("\n## Stage B - map v16, cell by cell (pooled). An option = house, debutant, road\n")
    print("| Cell | Option | n | Debut win / draw / loss | Name on the night | Cash | Reputation | Ranked | Pro W - L | Step ups / tune-ups / rebuild of bookings | Title shots (bought) | Home nights $ | Poster losses (favour) | Favour at the end | Dated late | Holds a belt | Gym closed |")
    print("|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|")
    for key in sorted(cells, key=ckey):
        for o in sorted(cells[key]):
            s = stat(list(cells[key][o].values()))
            print("| %s | %s | %d | %.0f / %.0f / %.0f | %+.1f | %+.0f | %.1f | %.0f%% | %.2f - %.2f | %.0f / %.0f / %.0f | %.2f (%.2f) | %.0f | %.2f | %.1f | %.1f%% | %.0f%% | %.0f%% |" % (
                key[0], o, s["n"], s["win"], s["draw"], s["loss"], s["name"], s["cash"], s["rep"], s["ranked"], s["pw"], s["pl"], s["step"], s["tune"], s["rebuild"],
                s["title"], s["spent"], s["home"], s["poster"], s["fav"], s["late"], s["belt"], s["closed"]))
    if amat:
        print("\n### Against the no-pro control (the same roll, the call declined; cell 64)\n")
        print("| Cell | Option | Pairs | Cash, option less amateur | error | Reputation | Gym closed, option / amateur |")
        print("|---|---|---|---|---|---|---|")
        for key in sorted(amat, key=ckey):
            both = dict(cells.get(key, {})); both.update(ctl.get(key, {})); both.update(amat[key])
            for o in sorted(cells.get(key, {})) + ["guarantee no ask", "ticket no ask"]:
                if o not in both:
                    continue
                g = gap(both, o, "amateur", ["cash", "name"])
                ks = [k for k in both[o] if k in both["amateur"]]
                print("| %s | %s | %d | %+.0f | %.0f | %+.1f | %.0f%% / %.0f%% |" % (key[0], o, g["n"], g["cash"], g["cash_se"], g["name"],
                    100.0 * mean(1 if both[o][k]["end"]["closed"] else 0 for k in ks), 100.0 * mean(1 if both["amateur"][k]["end"]["closed"] else 0 for k in ks)))

    print("\n## The house: every option against the plain guarantee house (build, keeper) on the same roll\n")
    print("| Cell | Option | Pairs | Cash | error | Debut wins | Reputation | Ranked | Reads |")
    print("|---|---|---|---|---|---|---|---|---|")
    errs = []; trade = []; flip = []; ahead_cells = set()
    for key in sorted(cells, key=ckey):
        cell = cells[key]
        for o in sorted(cell):
            if o == BASE:
                continue
            g = gap(cell, o, BASE, ["cash", "wins", "name", "rank"])
            errs.append(g["cash_se"])
            w = vs_word(cell, o, BASE, HOUSE_AX).replace("A beats B", "beats it").replace("B beats A", "beaten by it")
            print("| %s | %s | %d | %+.0f | %.0f | %+.1f | %+.1f | %+.0f | %s |" % (key[0], o, g["n"], g["cash"], g["cash_se"], g["wins"], g["name"], g["rank"], w))
            if o == TICKET:
                if ahead(g, "cash") and behind(g, "wins"):
                    trade.append(key[0])
                if beats(cell, BASE, o, HOUSE_AX):
                    flip.append(key[0])
            if ahead(g, "cash") or ahead(g, "wins"):
                ahead_cells.add(key[0])
    for key in sorted(cells, key=ckey):
        for o in cells[key]:
            for o2 in cells[key]:
                if o < o2:
                    errs.append(gap(cells[key], o, o2, ["cash"])["cash_se"])
    inst["I2"] = ("The error on every option's cash gap is $%d or less in every pooled cell" % ERR_MAX, "largest error $%.0f" % max(errs or [0]), bool(errs) and max(errs) <= ERR_MAX)
    bars["5"] = ("The house is a trade somewhere (ticket test keeper $1,000+ ahead, 3+ debut wins behind)", "cells: %s" % (", ".join(trade) or "none"), bool(trade))
    bars["6"] = ("The house flips (the plain guarantee house beats it somewhere)", "cells: %s" % (", ".join(flip) or "none"), bool(flip))
    bars["9"] = ("AUDIT: in at least half the cells an option is ahead of the plain guarantee house by $1,000 or 3 debut wins", "%d of %d cells" % (len(ahead_cells), len(cells)), len(cells) > 0 and len(ahead_cells) >= 0.5 * len(cells))

    # G: the big gym
    if ("full",) in cells:
        cell = cells[("full",)]
        bests = {}
        for hk, hn in HOUSES:
            opts = ["%s %s %s" % (hn, OWN[hk], b) for b in BOTS if "%s %s %s" % (hn, OWN[hk], b) in cell]
            if opts:
                bests[hn] = max(opts, key=lambda o: mean(cash(r) for r in cell[o].values()))
        if len(bests) == 2:
            w = vs_word(cell, bests["ticket"], bests["guarantee"], HOUSE_AX)
            bars["G"] = ("The big gym has a choice: in the full cell neither house's best own-night road (by cash) beats the other's on cash / debut wins", "%s against %s: %s" % (bests["ticket"], bests["guarantee"], w), w in ("a trade", "no difference"))

    def road_block(cmap, printit):
        ones = defaultdict(int); rights = defaultdict(int); n_hc = 0; n_diff = 0; reader_wins = 0; spend = defaultdict(lambda: [0, 0, 0, 0]); tune_right = 0
        if printit:
            print("| Cell | House | Road | n | Cash | Reputation | Ranked | Pro W less L (not an axis) | Step ups of bookings | Right | The one answer | Reader beats it |")
            print("|---|---|---|---|---|---|---|---|---|---|---|---|")
        for key in sorted(cmap, key=lambda k: (ckey(k),) + tuple(k[1:])):
            cell = cmap[key]
            for hk, hn in HOUSES:
                opts = ["%s %s %s" % (hn, OWN[hk], b) for b in BOTS]
                if not all(o in cell for o in opts):
                    continue
                n_hc += 1
                right, one = verdict(cell, opts, ROAD_AX)
                if any(differ(cell, a, b, ROAD_AX) for a in opts for b in opts if a < b):
                    n_diff += 1
                rd = opts[4]
                rb = {b: beats(cell, rd, o, ROAD_AX) for o, b in zip(opts, BOTS) if b != "reader"}
                if all(rb.values()):
                    reader_wins += 1
                kp, sp = opts[2], opts[3]
                sv = spend[hn]
                sv[0] += 1
                sv[1] += int(differ(cell, kp, sp, ROAD_AX))
                sv[2] += int(beats(cell, kp, sp, ROAD_AX))
                sv[3] += int(beats(cell, sp, kp, ROAD_AX))
                if hk == "bow" and opts[1] in right:
                    tune_right += 1
                for o, b in zip(opts, BOTS):
                    rights[b] += int(o in right)
                    ones[b] += int(o == one)
                    if printit:
                        s = stat(list(cell[o].values()))
                        print("| %s | %s | %s | %d | %+.0f | %.1f | %.0f%% | %+.2f | %.0f%% | %s | %s | %s |" % (key[0], hn, b, s["n"], s["cash"], s["rep"], s["ranked"], s["pw"] - s["pl"], s["step"],
                            "yes" if o in right else "-", "yes" if o == one else "-", "-" if b == "reader" else ("yes" if rb.get(b) else "no")))
        return {"ones": ones, "rights": rights, "n": n_hc, "diff": n_diff, "reader": reader_wins, "spend": spend, "tune_right": tune_right}

    print("\n## The road, house by house (the house's own debutant; a cell = house x gym; axes cash / name / ranked, record printed only)\n")
    R = road_block(cells, True)
    n = R["n"]
    bars["7"] = ("AUDIT: inside a house no road is the one answer in more than 6 of 10 house x gym cells", "; ".join("%s %d of %d" % (b, R["ones"][b], n) for b in BOTS), n > 0 and max(R["ones"][b] for b in BOTS) <= 0.6 * n)
    bars["8"] = ("AUDIT: every fixed road right in at least one house x gym cell, and two roads differ by a line in half of them", "; ".join("%s right %d of %d" % (b, R["rights"][b], n) for b in BOTS) + "; differ in %d of %d" % (R["diff"], n),
        n > 0 and all(R["rights"][b] >= 1 for b in FIXED) and R["diff"] >= 0.5 * n)
    bars["R"] = ("AUDIT, the depth bar: the reader beats every fixed road by a line in at least half the house x gym cells", "%d of %d cells" % (R["reader"], n), n > 0 and R["reader"] >= 0.5 * n)
    sp = R["spend"]
    bars["S"] = ("The spend is a choice: keeper and spender differ by a line in 1+ gym cell at each house, neither beats the other in more than 6 of 10",
        "; ".join("%s: differ %d of %d, keeper beats %d, spender beats %d" % (hn, v[1], v[0], v[2], v[3]) for hn, v in sp.items()),
        len(sp) == 2 and all(v[1] >= 1 and max(v[2], v[3]) <= 0.6 * v[0] for v in sp.values()))
    bars["T"] = ("The ticket house's tune-up has a reason: the win road is right at the ticket house in 2+ of 3 gym cells (no record axis)", "%d of %d" % (R["tune_right"], sp.get("ticket", [0])[0]), R["tune_right"] >= 2)

    by_b = cells_of(car, "v16", True)
    print("\n## Boxer by boxer (a cell = boxer x house x gym)\n")
    B = road_block(by_b, False)
    print("| Road | right in | the one answer in |")
    print("|---|---|---|")
    for b in BOTS:
        print("| %s | %d of %d | %d of %d |" % (b, B["rights"][b], B["n"], B["ones"][b], B["n"]))
    print("\nThe reader beats every fixed road in %d of %d boxer cells." % (B["reader"], B["n"]))
    bars["11"] = ("Boxer by boxer: no road the one answer in more than 6 of 10, every fixed road right in 2+", "; ".join("%s right %d, one %d of %d" % (b, B["rights"][b], B["ones"][b], B["n"]) for b in BOTS),
        B["n"] > 0 and max(B["ones"][b] for b in BOTS) <= 0.6 * B["n"] and all(B["rights"][b] >= 2 for b in FIXED))

    # the tune-up rule's control arm
    flat = cells_of(car, "flat")
    takes = []
    for key in sorted(flat, key=ckey):
        for hk, hn in HOUSES:
            o = "%s %s win" % (hn, OWN[hk])
            on, off = cells.get(key, {}).get(o, {}), flat[key].get(o, {})
            ks = [k for k in on if k in off]
            if ks and key[0] != "full":
                takes.append("%.1f (%s, %s)" % (mean(rep(off[k]) - rep(on[k]) for k in ks), hn, key[0]))
                ok10 = mean(rep(off[k]) - rep(on[k]) for k in ks) >= 1
                bars["10"] = ("With the tune-up rule off the win-chaser ends 1+ reputation higher in every cell with room", "the rule takes " + ", ".join(takes), ok10 and bars.get("10", ("", "", True))[2])

    # kinds and the table
    print("\n## What the roads booked, and what was on the table (stage B, all cells, own night)\n")
    print("| House | Road | Careers | Sets | Step ups (incl. titles) | Tune-ups | Rebuild | Both kinds on the non-rebuild road sets | Spend offered (sets) | Spent | Title wins from a spend | Home nights $ | Favour at the end |")
    print("|---|---|---|---|---|---|---|---|---|---|---|---|---|")
    share = {}; both = {}
    for hk, hn in HOUSES:
        to = tb = 0
        for b in BOTS:
            rs = [r for r in car if r["arm"] == "v16" and r["house"] == hk and r["pick"] == OWN[hk] and r["bot"] == b]
            if not rs:
                continue
            s = stat(rs)
            op = sum(r.get("open_sets", 0) for r in rs); bo = sum(r.get("both", 0) for r in rs)
            to += op; tb += bo
            share[(hn, b)] = s["step"]
            print("| %s | %s | %d | %d | %.0f%% | %.0f%% | %.0f%% | %.0f%% | %.2f | %.2f | %.2f | %.0f | %.1f |" % (hn, b, len(rs), sum(r["sets"] for r in rs), s["step"], s["tune"], s["rebuild"], 100.0 * bo / max(1, op),
                mean(r.get("spend_sets", 0) for r in rs), s["spent"], mean(r.get("spend_wins", 0) for r in rs), s["home"], s["fav"]))
        both[hn] = 100.0 * tb / max(1, to)
    inst["I4"] = ("Both kinds on 80%+ of the road's non-rebuild sets, at each house", "; ".join("%s %.0f%%" % kv for kv in both.items()), bool(both) and all(v >= 80 for v in both.values()))
    d13 = {hn: share.get((hn, "name"), 0) - share.get((hn, "win"), 0) for _h, hn in HOUSES}
    inst["I5"] = ("The name-chaser books 25+ points more step ups than the win-chaser, at each house", "; ".join("%s %+.0f" % kv for kv in d13.items()), all(v >= 25 for v in d13.values()))

    # the night, per house
    print("\n## The debut night: test against build, same house, same road, same rolls (keeper; reader beside)\n")
    print("| Cell | House | Road | Pairs | Debut wins | Cash | error | Reputation | Ranked | Reads |")
    print("|---|---|---|---|---|---|---|---|---|---|")
    nt = defaultdict(list); n1 = defaultdict(lambda: defaultdict(int)); nn = defaultdict(int)
    for key in sorted(cells, key=ckey):
        cell = cells[key]
        for hk, hn in HOUSES:
            for road in ["keeper", "reader"]:
                a, b = "%s test %s" % (hn, road), "%s build %s" % (hn, road)
                if a not in cell or b not in cell:
                    continue
                g = gap(cell, a, b, NIGHT_AX + ["rank"])
                w = vs_word(cell, a, b, NIGHT_AX).replace("A beats B", "test beats build").replace("B beats A", "build beats test")
                print("| %s | %s | %s | %d | %+.1f | %+.0f | %.0f | %+.1f | %+.0f | %s |" % (key[0], hn, road, g["n"], g["wins"], g["cash"], g["cash_se"], g["name"], g["rank"], w))
                if road != "keeper":
                    continue
                nn[hn] += 1
                if w.startswith("test beats"):
                    n1[hn]["test"] += 1
                if w.startswith("build beats"):
                    n1[hn]["build"] += 1
                if behind(g, "wins") and (ahead(g, "name") or ahead(g, "cash")):
                    nt[hn].append(key[0])
    for hn, bid in [("ticket", "16t"), ("guarantee", "16g")]:
        bars[bid] = ("The night at the %s house is a trade in 1+ gym cell, neither night the one answer in more than 6 of 10" % hn,
            "trade in %s; test one answer %d, build %d of %d" % (", ".join(nt[hn]) or "none", n1[hn]["test"], n1[hn]["build"], nn[hn]),
            bool(nt[hn]) and max(n1[hn]["test"], n1[hn]["build"]) <= 0.6 * max(1, nn[hn]))

    # the debut loss (reading)
    w = [r for r in car if r["arm"] == "v16" and r["bot"] == "keeper" and r["deb"] and r["deb"]["o"] == "win"]
    l = [r for r in car if r["arm"] == "v16" and r["bot"] == "keeper" and r["deb"] and r["deb"]["o"] == "loss"]
    if w and l:
        reads.append("A debut loss (keeper roads, NOT paired): cash %+.0f, ranked %+.0f points against a debut win." % (mean(cash(r) for r in l) - mean(cash(r) for r in w), mean(ranked(r) for r in l) - mean(ranked(r) for r in w)))

    # ---------------------------------------------------------------- stage F
    if carf:
        fon, foff = cells_of(carf, "v16", stage="f"), cells_of(carf, "nofav", stage="f")
        print("\n## Stage F - the favour's rewards on against off (80 weeks, same rolls)\n")
        print("| Cell | Option | Pairs | Cash, on less off | error | Reputation | Ranked | Favour at the end | Title shots (bought) | Dated late | Holds a belt on / off |")
        print("|---|---|---|---|---|---|---|---|---|---|---|")
        strict = []
        for key in sorted(fon, key=ckey):
            for o in sorted(fon[key]):
                on, off = fon[key][o], foff.get(key, {}).get(o, {})
                ks = [k for k in on if k in off]
                if not ks:
                    continue
                dc = [cash(on[k]) - cash(off[k]) for k in ks]
                rs = [on[k] for k in ks]
                s = stat(rs)
                print("| %s | %s | %d | %+.0f | %.0f | %+.1f | %+.0f | %.1f | %.2f (%.2f) | %.1f%% | %.0f%% / %.0f%% |" % (key[0], o, len(ks), mean(dc), se(dc), mean(rep(on[k]) - rep(off[k]) for k in ks),
                    mean(ranked(on[k]) - ranked(off[k]) for k in ks), s["fav"], s["title"], s["spent"], s["late"], s["belt"], 100.0 * mean(1 if off[k].get("belt", "") else 0 for k in ks)))
                if o.endswith("keeper") and mean(dc) >= FAV_CASH:
                    strict.append("%s %s" % (o, key[0]))
        print("\n### Keeper against name-chaser, favour on and off (the verdict on cash / name / ranked)\n")
        print("| Cell | House | Favour ON | Favour OFF | Flipped |")
        print("|---|---|---|---|---|")
        flips = []
        for key in sorted(fon, key=ckey):
            for hk, hn in HOUSES:
                a, b = "%s %s keeper" % (hn, OWN[hk]), "%s %s name" % (hn, OWN[hk])
                if a in fon[key] and b in fon[key] and a in foff.get(key, {}) and b in foff.get(key, {}):
                    v_on, v_off = vs_word(fon[key], a, b, ROAD_AX), vs_word(foff[key], a, b, ROAD_AX)
                    f = v_on != v_off
                    print("| %s | %s | %s | %s | %s |" % (key[0], hn, v_on.replace("A", "keeper").replace("B", "name"), v_off.replace("A", "keeper").replace("B", "name"), "yes" if f else "-"))
                    if f and hk == "hf":
                        flips.append(key[0])
        bars["F"] = ("The favour flips the road: at the guarantee house the keeper-vs-name verdict differs between rewards on and off in 1+ gym cell", "flipped in: %s" % (", ".join(flips) or "none"), bool(flips))
        reads.append("Probe 15's bar 15 as a size: keepers gaining $500+ from the favour's rewards: %s." % (", ".join(strict) or "none"))

    # ---------------------------------------------------------------- verdict
    print("\n## Instruments (must hold; not scored)\n")
    print("| # | Instrument | Reads | Holds |")
    print("|---|---|---|---|")
    for k in sorted(inst):
        print("| %s | %s | %s | %s |" % (k, inst[k][0], inst[k][1], "yes" if inst[k][2] else "**NO**"))
    print("\n## The bars (scored)\n")
    print("| # | Bar | Reads | Verdict |")
    print("|---|---|---|---|")
    for k in SCORED:
        if k in bars:
            print("| %s | %s | %s | %s |" % (k, bars[k][0], bars[k][1], "PASS" if bars[k][2] else "**FAIL**"))
        else:
            print("| %s | (not read) | - | **FAIL** |" % k)
    print("\n## Readings\n")
    for r in reads:
        print("- " + r)
    passed = sum(1 for k in SCORED if k in bars and bars[k][2])
    audit_ok = all(k in bars and bars[k][2] for k in AUDIT)
    inst_ok = all(v[2] for v in inst.values())
    print("\nBars passed: %d of %d. Audit bars (7, 8, 9, R): %s. Instruments: %s. VERDICT: %s (PASS = %d+ of 16, every audit bar, every instrument)." % (passed, len(SCORED),
        "all pass" if audit_ok else "not all pass", "all hold" if inst_ok else "not all hold", "PASS" if passed >= PASS_AT and audit_ok and inst_ok else "FAIL", PASS_AT))

if __name__ == "__main__":
    main()
