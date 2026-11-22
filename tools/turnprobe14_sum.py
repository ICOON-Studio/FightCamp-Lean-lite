"""turnprobe14_sum.py - TURNPROBE14 (S537): the JSON lines of tools/turnprobe14.gd as the tables of docs/TURNPROBE14_RESULT.md.

    python tools/turnprobe14_sum.py <jsonl> [<jsonl> ...]      # prints markdown

The population, pairing and house pass rule are probe 13's. New in 14: an OPTION is house x debutant x road bot, so there
are three decisions to read, each with its own pass rule (the lines are fixed here, before the run):
  THE HOUSE   every option against the plain guarantee house (its own debutant, the keeper road) on the same roll.
              Axes: gym cash by the last week (LINE_CASH) and debut wins in 100 (LINE_WINS).
  THE ROAD    inside one house and cell, the three road bots (name / win / keeper) with the house's own debutant.
              Axes: gym cash (LINE_CASH), the name = reputation at the last week (LINE_NAME), the record = pro wins less
              pro losses (LINE_REC).
  THE NIGHT   inside one house and cell, the two debutants (test / build) on the keeper road.
              Axes: gym cash (LINE_CASH), debut wins in 100 (LINE_WINS), the name (LINE_NAME).
A beats B when A is ahead by the line on one axis and not behind by the line on any other. RIGHT = beaten by nobody.
THE ONE ANSWER = beats every other. A ROLL is one boxer's call week (a bout's dice are the fight day's).
"""
import json
import math
import sys
from collections import defaultdict

LINE_CASH = 1000.0
LINE_WINS = 3.0
LINE_NAME = 3.0
LINE_REC = 1.0
FAV_CASH = 500.0     # stage F: the favour's rules on against off
FAV_REC = 0.5
CELLS = ["48", "56", "64", "full"]
HOUSES = [("bow", "ticket"), ("hf", "guarantee")]
OWN = {"bow": "test", "hf": "build"}
BASE = "guarantee build keeper"
TICKET = "ticket test keeper"
BOTS = ["name", "win", "keeper"]
N_BARS = 17
PASS_AT = 14


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
                    rows.append(json.loads(line))
    return rows


def hname(r):
    return "ticket" if r["house"] == "bow" else "guarantee"


def opt(r):
    if r["arm"] == "control":
        return "%s %s" % (hname(r), "no ask" if r["ask"] == "none" else r["ask"])
    return "%s %s %s" % (hname(r), r["pick"], r["bot"])


def cash(r):
    return r["end"]["cash"] - r["cash0"]


def won(r):
    return 100.0 if r["deb"] and r["deb"]["o"] == "win" else 0.0


def rep(r):
    return float(r["end"]["rep"])


def rec(r):
    return float(r["end"]["pw"] - r["end"]["pl"])


AX = {"cash": (cash, LINE_CASH), "wins": (won, LINE_WINS), "name": (rep, LINE_NAME), "rec": (rec, LINE_REC)}
HOUSE_AX = ["cash", "wins"]
ROAD_AX = ["cash", "name", "rec"]
NIGHT_AX = ["cash", "wins", "name"]


def pairs(cell, a, b):
    ra, rb = cell.get(a, {}), cell.get(b, {})
    return [(ra[k], rb[k]) for k in ra if k in rb]


def gap(cell, a, b, axes):
    ps = pairs(cell, a, b)
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
    if g["n"] == 0:
        return False
    return any(ahead(g, ax) for ax in axes) and not any(behind(g, ax) for ax in axes)


def differ(cell, a, b, axes):
    g = gap(cell, a, b, axes)
    return g["n"] > 0 and any(ahead(g, ax) or behind(g, ax) for ax in axes)


def verdict(cell, opts, axes):
    opts = [o for o in opts if o in cell]
    right = [a for a in opts if not any(beats(cell, b, a, axes) for b in opts if b != a)]
    one = [a for a in opts if len(opts) > 1 and all(beats(cell, a, b, axes) for b in opts if b != a)]
    return right, (one[0] if one else "")


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
    return {"n": len(rs), "win": o("win"), "draw": o("draw"), "loss": o("loss"),
            "sold": mean(d["sold"] for d in deb), "name": mean(d.get("name", 0) for d in deb),
            "cash": mean(cash(r) for r in rs), "members": mean(r["end"]["members"] for r in rs), "rep": mean(rep(r) for r in rs),
            "pw": mean(r["end"]["pw"] for r in rs), "pl": mean(r["end"]["pl"] for r in rs),
            "ranked": 100.0 * sum(1 for r in rs if r["end"]["rank"] > 0) / max(1, len(rs)), "fans": mean(r["end"]["fans"] for r in rs),
            "step": 100.0 * (kinds["above"] + kinds["title"]) / booked, "tune": 100.0 * kinds["tune"] / booked, "rebuild": 100.0 * kinds["rebuild"] / booked,
            "payday": 100.0 * kinds["payday"] / booked, "title": 100.0 * kinds["title"] / booked,
            "fights": mean(r["end"]["pw"] + r["end"]["pl"] + r["end"]["pd"] for r in rs), "tw": mean(r.get("tune_wins", 0) for r in rs),
            "fav": mean(r.get("fav", 5) for r in rs), "morale": mean(r["end"]["morale"] for r in rs), "loy": mean(r["end"]["loy"] for r in rs),
            "closed": 100.0 * sum(1 for r in rs if r["end"]["closed"]) / max(1, len(rs))}


def main():
    rows = load(sys.argv[1:])
    calls = [r for r in rows if r.get("tag") == "call"]
    first = {}
    for r in calls:   # a boxer's call week counted once: the same Saturday is the same dice
        first.setdefault((r["who"], r["day"] // 7), r["k"])
    keep = {(r["who"], r["k"]) for r in calls if first[(r["who"], r["day"] // 7)] == r["k"]}
    car_all = [r for r in rows if r.get("tag") == "career" and (r["who"], r["k"]) in keep]
    car = [r for r in car_all if r.get("stage", "b") == "b"]
    carf = [r for r in car_all if r.get("stage", "b") == "f"]
    nights = [r for r in rows if r.get("tag") == "night"]
    bars = []   # (number, bar, reads, ok, audit)

    print("## Population\n")
    for r in rows:
        if r.get("tag") == "run" and r.get("stage") in ("b", "f"):
            print("- run (stage %s): boxers %s, %s seeds x %s call days, to week %s, cells %s (today's rules and the flat arm also in %s)" % (r["stage"], r["boxers"], r["seeds"], r["days"], r["weeks"], r["cells"], r["ctl"]))
    print("\n| Boxer | Rolls (call weeks) | Call days | Record at the calls | Strength (no camp) | Gym's own seats | Room for members (cap) | Loyalty |")
    print("|---|---|---|---|---|---|---|---|")
    by = defaultdict(dict)
    for r in calls:
        if (r["who"], r["k"]) in keep:
            by[(r["b"], r["who"], r["style"])][r["k"]] = r
    stage_b_calls = {(r["who"], r["k"]) for r in car}
    n_rolls = 0
    for (b, who, style), d in sorted(by.items()):
        rs = [r for r in d.values() if (r["who"], r["k"]) in stage_b_calls]
        if not rs:
            continue
        n_rolls += len(rs)
        lo = min(rs, key=lambda r: r["day"]); hi = max(rs, key=lambda r: r["day"])
        print("| %s (%s) | %d | %d .. %d | %d-%d .. %d-%d | %.1f .. %.1f | %d .. %d | %d | %d .. %d |" % (who, style, len(rs), lo["day"], hi["day"],
            lo["w"], lo["l"], hi["w"], hi["l"], min(r["night"] for r in rs), max(r["night"] for r in rs),
            min(r["seats_real"] for r in rs), max(r["seats_real"] for r in rs), rs[0]["cap"], min(r["loyalty"] for r in rs), max(r["loyalty"] for r in rs)))
    skips = [r for r in rows if r.get("tag") == "skip"]
    n_arm = lambda a: sum(1 for r in car if r["arm"] == a)
    print("\nRolls: %d. Careers played and counted, stage B: %d (v14 %d, v14 with the tune-up rule off %d, today's rules %d). Stage F (the favour, 80 weeks): %d careers on %d rolls. Cells skipped because one house called alone: %d." % (
        n_rolls, len(car), n_arm("v14"), n_arm("flat"), n_arm("control"), len(carf), len({(r["who"], r["k"]) for r in carf}), len(skips)))

    # ---------------------------------------------------------------- stage A
    if nights:
        print("\n## Stage A - the night (the same scratch nights for every row of a boxer)\n")
        print("| Rules | House | Debutant | Ask | Boxers | Card shows (mean) | Played win (mean) | lowest .. highest | Draw | Loss | Stopped losses | Worst boxer: card less played |")
        print("|---|---|---|---|---|---|---|---|---|---|---|---|")
        grp = defaultdict(list)
        for r in nights:
            grp[(r["arm"], hname(r), r.get("pick", ""), r["ask"])].append(r)
        A = {}
        for key in sorted(grp):
            rs = grp[key]
            w = [100.0 * r["win"] / r["n"] for r in rs]
            off = [100 * r["shown"] - 100.0 * r["win"] / r["n"] for r in rs]
            worst = max(off, key=abs)
            A[key] = {"shown": mean(100 * r["shown"] for r in rs), "win": mean(w), "worst": worst}
            print("| %s | %s | %s | %s | %d | %.1f | %.1f | %.1f .. %.1f | %.1f | %.1f | %.1f | %+.1f |" % ("today" if key[0] == "control" else key[0], key[1], key[2] or "-", key[3], len(rs),
                A[key]["shown"], mean(w), min(w), max(w), mean(100.0 * r["draw"] / r["n"] for r in rs), mean(100.0 * r["loss"] / r["n"] for r in rs),
                mean(100.0 * r["stop_l"] / r["n"] for r in rs), worst))
        four = [("v14", "ticket", "test", "none"), ("v14", "ticket", "build", "none"), ("v14", "guarantee", "build", "none"), ("v14", "guarantee", "test", "none")]
        bands = [(52, 68), (62, 78), (70, 82), (60, 76)]
        if all(k in A for k in four):
            bars.append((3, "Played debut wins in 100: ticket test 52 to 68, ticket build 62 to 78, guarantee build 70 to 82, guarantee test 60 to 76",
                ", ".join("%.1f" % A[k]["win"] for k in four), all(lo <= A[k]["win"] <= hi for k, (lo, hi) in zip(four, bands)), False))
            bars.append((4, "The card is honest: each of the four debutants shown within 3 of played on the mean, and no boxer's card more than 8 from that boxer's own nights",
                "; ".join("%s %s %.1f shown, %.1f played, worst boxer %+.1f" % (k[1], k[2], A[k]["shown"], A[k]["win"], A[k]["worst"]) for k in four),
                all(abs(A[k]["shown"] - A[k]["win"]) <= 3 and abs(A[k]["worst"]) <= 8 for k in four), False))
        t, g = A.get(four[0]), A.get(four[2])
        lt, lg = A.get(("v14", "ticket", "test", "later2")), A.get(("v14", "guarantee", "build", "later2"))
        if t and g and lt and lg:
            cardd = [lt["shown"] - t["shown"], lg["shown"] - g["shown"]]
            play = [lt["win"] - t["win"], lg["win"] - g["win"]]
            bars.append((14, "Later +2: the card shows +1 to +4, the played gain is not below 0 (a calendar tool; the card's part is the card's own formula)", "card %+.1f / %+.1f; played %+.1f (ticket), %+.1f (guarantee)" % (cardd[0], cardd[1], play[0], play[1]),
                all(1 <= c <= 4 for c in cardd) and all(p >= 0 for p in play), False))

    # ---------------------------------------------------------------- the mutant
    ctl = cells_of(car, "control")
    if ctl:
        print("\n## The mutant: today's costs ask against today's plain guarantee house (the instrument must see it)\n")
        print("| Cell | Pairs | Cash by the last week | error | Debut wins in 100 |")
        print("|---|---|---|---|---|")
        ok = True
        reads = []
        for key in sorted(ctl, key=ckey):
            g = gap(ctl[key], "guarantee costs", "guarantee no ask", HOUSE_AX)
            ok = ok and 700 <= g["cash"] <= 1100 and g["cash_se"] < 100
            reads.append("%s: %+.0f, error %.0f" % (key[0], g["cash"], g["cash_se"]))
            print("| %s | %d | %+.0f | %.0f | %+.1f |" % (key[0], g["n"], g["cash"], g["cash_se"], g["wins"]))
            t = gap(ctl[key], "ticket no ask", "guarantee no ask", HOUSE_AX)
            print("| %s (today's ticket house, no ask) | %d | %+.0f | %.0f | %+.1f |" % (key[0], t["n"], t["cash"], t["cash_se"], t["wins"]))
        bars.append((1, "Instrument: today's costs ask reads +$700 to +$1,100 against today's plain guarantee house, error under $100, in every cell it is played", "; ".join(reads), ok, False))

    # ---------------------------------------------------------------- stage B
    cells = cells_of(car, "v14")
    print("\n## Stage B - map v14, cell by cell (pooled over boxers and rolls). An option = house, debutant, road bot\n")
    print("| Cell | Option | n | Debut win / draw / loss | Seats on the night | Name won on the night | Cash by the last week | Members | Reputation | Ranked | Fans | Pro wins - losses | Pro fights | Booked: step ups / tune-ups / rebuild / paydays (title shots) | Tune-up wins | Favour at the end | Morale | Loyalty | Gym closed |")
    print("|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|")
    for key in sorted(cells, key=ckey):
        for o in sorted(cells[key]):
            s = stat(list(cells[key][o].values()))
            print("| %s | %s | %d | %.0f / %.0f / %.0f | %.0f | %+.1f | %+.0f | %.0f | %.1f | %.0f%% | %+.1f | %.2f - %.2f | %.1f | %.0f / %.0f / %.0f / %.0f (%.1f) | %.2f | %.1f | %.0f | %.0f | %.0f%% |" % (
                key[0], o, s["n"], s["win"], s["draw"], s["loss"], s["sold"], s["name"], s["cash"], s["members"], s["rep"], s["ranked"], s["fans"], s["pw"], s["pl"],
                s["fights"], s["step"], s["tune"], s["rebuild"], s["payday"], s["title"], s["tw"], s["fav"], s["morale"], s["loy"], s["closed"]))

    print("\n## The house: every option against the plain guarantee house (its own debutant, the keeper road) on the same roll\n")
    print("| Cell | Option | Pairs | Cash by the last week | error | Debut wins in 100 | error | Reputation | Pro wins less losses | Reads (cash and debut wins) |")
    print("|---|---|---|---|---|---|---|---|---|---|")
    errs = []
    trade = []; flip = []; ahead_cells = []
    for key in sorted(cells, key=ckey):
        cell = cells[key]
        for o in sorted(cell):
            if o == BASE:
                continue
            g = gap(cell, o, BASE, ["cash", "wins", "name", "rec"])
            errs.append(g["cash_se"])
            word = "beats it" if beats(cell, o, BASE, HOUSE_AX) else ("beaten by it" if beats(cell, BASE, o, HOUSE_AX) else ("a trade" if differ(cell, o, BASE, HOUSE_AX) else "no measured difference"))
            print("| %s | %s | %d | %+.0f | %.0f | %+.1f | %.1f | %+.1f | %+.2f | %s |" % (key[0], o, g["n"], g["cash"], g["cash_se"], g["wins"], g["wins_se"], g["name"], g["rec"], word))
            if o == TICKET:
                if ahead(g, "cash") and behind(g, "wins"):
                    trade.append(key[0])
                if beats(cell, BASE, o, HOUSE_AX):
                    flip.append(key[0])
            if ahead(g, "cash") or ahead(g, "wins"):
                ahead_cells.append(key[0])
    n_cells = len(cells)
    bars.append((2, "Instrument: the error on every option's cash gap is $250 or less in every pooled cell (a $1,000 gap is four errors)", "largest error $%.0f" % max(errs or [0]), bool(errs) and max(errs) <= 250, False))
    bars.append((5, "The house is a trade somewhere: the ticket house (its test debutant, the keeper road) is $1,000+ ahead on cash and 3+ debut wins behind the plain guarantee house in at least one cell", "cells: %s" % (", ".join(trade) or "none"), bool(trade), False))
    bars.append((6, "The house flips: the plain guarantee house beats that ticket-house option in at least one cell", "cells: %s" % (", ".join(flip) or "none"), bool(flip), False))
    n_ahead = len(set(ahead_cells))
    bars.append((9, "AUDIT: best against laziest - in at least half the cells an option is ahead of the plain guarantee house by $1,000 or 3 debut wins in 100", "%d of %d cells (%s)" % (n_ahead, n_cells, ", ".join(sorted(set(ahead_cells), key=lambda c: CELLS.index(c))) or "none"), n_cells > 0 and n_ahead >= 0.5 * n_cells, True))

    # ---------------------------------------------------------------- the road
    def road_block(cellmap, title):
        print("\n## %s\n" % title)
        if title.startswith("The road, house by house"):
            print("| Cell | House | Road | n | Cash by the last week | Reputation | Pro wins less losses | Ranked | Step ups of bookings | Right | The one answer |")
            print("|---|---|---|---|---|---|---|---|---|---|---|")
        ones = defaultdict(int); rights = defaultdict(int); n_hc = 0; n_diff = 0; trades = defaultdict(list)
        for key in sorted(cellmap, key=lambda k: (ckey(k),) + tuple(k[1:])):
            cell = cellmap[key]
            for hk, hn in HOUSES:
                opts = ["%s %s %s" % (hn, OWN[hk], b) for b in BOTS]
                if not all(o in cell for o in opts):
                    continue
                n_hc += 1
                right, one = verdict(cell, opts, ROAD_AX)
                if any(differ(cell, a, b, ROAD_AX) for a in opts for b in opts if a < b):
                    n_diff += 1
                gnw = gap(cell, opts[0], opts[1], ROAD_AX)
                trades[hn].append((key[0], gnw))
                for o, b in zip(opts, BOTS):
                    if o in right:
                        rights[b] += 1
                    if o == one:
                        ones[b] += 1
                    if title.startswith("The road, house by house"):
                        s = stat(list(cell[o].values()))
                        print("| %s | %s | %s | %d | %+.0f | %.1f | %+.2f | %.0f%% | %.0f%% | %s | %s |" % (key[0], hn, b, s["n"], s["cash"], s["rep"], s["pw"] - s["pl"], s["ranked"], s["step"],
                            "yes" if o in right else "-", "yes" if o == one else "-"))
        return ones, rights, n_hc, n_diff, trades

    ones, rights, n_hc, n_diff, trades = road_block(cells, "The road, house by house (the house's own debutant; a cell here = house x gym)")
    print("\nThe name-chaser against the win-chaser, same house, same rolls:\n")
    print("| Cell | House | Pairs | Cash | error | Reputation | error | Pro wins less losses | error |")
    print("|---|---|---|---|---|---|---|---|---|")
    name_lead = []
    for hn in trades:
        for cname, g in trades[hn]:
            print("| %s | %s | %d | %+.0f | %.0f | %+.1f | %.1f | %+.2f | %.2f |" % (cname, hn, g["n"], g["cash"], g["cash_se"], g["name"], g["name_se"], g["rec"], g["rec_se"]))
            if cname != "full":
                name_lead.append((hn, cname, g["name"]))
    bars.append((7, "AUDIT (the kind): inside a house no road is the one answer in more than 6 of 10 house x gym cells", "; ".join("%s %d of %d" % (b, ones[b], n_hc) for b in BOTS), n_hc > 0 and max(ones[b] for b in BOTS) <= 0.6 * n_hc, True))
    bars.append((8, "AUDIT (the kind): every road is right in at least one house x gym cell, and in at least half of them two roads differ by a line on some axis ($1,000, 3 reputation, 1 win less loss)",
        "; ".join("%s right %d of %d" % (b, rights[b], n_hc) for b in BOTS) + "; two roads differ in %d of %d" % (n_diff, n_hc), n_hc > 0 and all(rights[b] >= 1 for b in BOTS) and n_diff >= 0.5 * n_hc, True))

    # the tune-up rule's control arm, merged with the name lead (probe 13's bars 10 and 15 were one fact)
    flat = cells_of(car, "flat")
    print("\n## The tune-up rule's control arm: the win-chaser with the rule off (every pro win pays 5 reputation), same rolls\n")
    print("| Cell | House | Pairs | Win-chaser's reputation, rule on | rule off | The rule takes |")
    print("|---|---|---|---|---|---|")
    takes = []
    for key in sorted(flat, key=ckey):
        for hk, hn in HOUSES:
            o = "%s %s win" % (hn, OWN[hk])
            on, off = cells.get(key, {}).get(o, {}), flat[key].get(o, {})
            ks = [k for k in on if k in off]
            if not ks:
                continue
            r_on, r_off = mean(rep(on[k]) for k in ks), mean(rep(off[k]) for k in ks)
            print("| %s | %s | %d | %.1f | %.1f | %.1f |" % (key[0], hn, len(ks), r_on, r_off, r_off - r_on))
            if key[0] != "full":
                takes.append((key[0], hn, r_off - r_on))
    bars.append((10, "The name is the kind's (probe 13's bars 10 and 15, one fact): with the tune-up rule off the win-chaser ends 1+ reputation higher in every cell with room it is played in, and with it on the name-chaser ends 3+ reputation ahead of the win-chaser in the same house in every cell with room",
        "the rule takes %s; the name-chaser's lead %s" % (", ".join("%.1f (%s, %s)" % (t[2], t[1], t[0]) for t in takes) or "none", ", ".join("%+.1f (%s, %s)" % (n[2], n[0], n[1]) for n in name_lead) or "none"),
        bool(takes) and min(t[2] for t in takes) >= 1 and bool(name_lead) and min(n[2] for n in name_lead) >= LINE_NAME, False))

    bcells = cells_of(car, "v14", True)
    bones, brights, nb_hc, _nd, _t = road_block(bcells, "Boxer by boxer (a cell = boxer x house x gym)")
    print("| Road | right in | the one answer in |")
    print("|---|---|---|")
    for b in BOTS:
        print("| %s | %d of %d | %d of %d |" % (b, brights[b], nb_hc, bones[b], nb_hc))
    bars.append((11, "Boxer by boxer (boxer x house x gym): no road the one answer in more than 6 cells of 10, every road right in at least 2", "; ".join("%s right %d, one answer %d of %d" % (b, brights[b], bones[b], nb_hc) for b in BOTS),
        nb_hc > 0 and max(bones[b] for b in BOTS) <= 0.6 * nb_hc and all(brights[b] >= 2 for b in BOTS), False))

    # kinds booked and what was on the table
    print("\n## What the bots booked, and what was on the table (stage B, all cells)\n")
    print("| House | Road | Careers | Sets | Step ups (title shots in them) | Tune-ups | Rebuild fights | Paydays | Road sets with both kinds on the table | Sets the house took the kind back | Favour at the end | Careers that reached favour 8 |")
    print("|---|---|---|---|---|---|---|---|---|---|---|---|")
    share = {}; both_share = {}
    for hk, hn in HOUSES:
        tot_open = 0; tot_both = 0
        for b in BOTS:
            rs = [r for r in car if r["arm"] == "v14" and r["house"] == hk and r["pick"] == OWN[hk] and r["bot"] == b]
            if not rs:
                continue
            s = stat(rs)
            op = sum(r.get("open_sets", 0) for r in rs); bo = sum(r.get("both", 0) for r in rs)
            tot_open += op; tot_both += bo
            share[(hn, b)] = s["step"]
            print("| %s | %s | %d | %d | %.0f%% (%.1f%%) | %.0f%% | %.0f%% | %.0f%% | %.0f%% | %.1f%% | %.1f | %.0f%% |" % (hn, b, len(rs), sum(r["sets"] for r in rs), s["step"], s["title"], s["tune"], s["rebuild"], s["payday"],
                100.0 * bo / max(1, op), 100.0 * sum(r.get("forced", 0) for r in rs) / max(1, sum(r["sets"] for r in rs)), s["fav"],
                100.0 * sum(1 for r in rs if max(r.get("fav_peak", 0), r.get("fav", 0)) >= 8) / len(rs)))
        both_share[hn] = 100.0 * tot_both / max(1, tot_open)
    if share:
        d = {hn: share.get((hn, "name"), 0) - share.get((hn, "win"), 0) for _hk, hn in HOUSES}
        bars.append((13, "Inside one house two bots book different kinds: step ups are 25+ points more of the name-chaser's bookings than of the win-chaser's, at each house", "; ".join("%s %+.0f points" % (hn, d[hn]) for hn in d), all(v >= 25 for v in d.values()), False))
        bars.append((17, "Both kinds are on the table: 80%+ of the road's sets that are not rebuild sets carry a tune-up and a step up, at each house", "; ".join("%s %.0f%%" % (hn, both_share[hn]) for hn in both_share), all(v >= 80 for v in both_share.values()), False))

    # ---------------------------------------------------------------- the night (debut pick)
    print("\n## The debut night: the test debutant against the build debutant, same house, the keeper road, same rolls\n")
    print("| Cell | House | Pairs | Debut wins in 100 | error | Cash by the last week | error | Reputation | error | Reads |")
    print("|---|---|---|---|---|---|---|---|---|---|")
    n_night = 0; night_trade = []; night_one = defaultdict(int)
    for key in sorted(cells, key=ckey):
        cell = cells[key]
        for hk, hn in HOUSES:
            a, b = "%s test keeper" % hn, "%s build keeper" % hn
            if a not in cell or b not in cell:
                continue
            n_night += 1
            g = gap(cell, a, b, NIGHT_AX)
            if beats(cell, a, b, NIGHT_AX):
                word = "test beats build"; night_one["test"] += 1
            elif beats(cell, b, a, NIGHT_AX):
                word = "build beats test"; night_one["build"] += 1
            elif differ(cell, a, b, NIGHT_AX):
                word = "a trade"
            else:
                word = "no measured difference"
            if behind(g, "wins") and (ahead(g, "name") or ahead(g, "cash")):
                night_trade.append("%s %s" % (hn, key[0]))
            print("| %s | %s | %d | %+.1f | %.1f | %+.0f | %.0f | %+.1f | %.1f | %s |" % (key[0], hn, g["n"], g["wins"], g["wins_se"], g["cash"], g["cash_se"], g["name"], g["name_se"], word))
    bars.append((16, "The debut night is a trade: in at least one house x gym cell the test debutant is 3+ debut wins behind and 3+ reputation or $1,000 ahead, and neither debutant is the one answer in more than 6 of 10 of them",
        "a trade in: %s; test the one answer %d, build %d of %d" % (", ".join(night_trade) or "none", night_one["test"], night_one["build"], n_night),
        bool(night_trade) and max(night_one["test"], night_one["build"]) <= 0.6 * n_night, False))

    # ---------------------------------------------------------------- a debut loss (not paired)
    print("\n## What a debut loss leaves at the last week (the same option, lost against won; NOT paired - the boxers who lose are the weaker ones)\n")
    print("| Rules | Option | Debuts won / lost | Cash, lost less won | Ranked, won / lost | Pro wins after the debut, won / lost | Rebuilding at the last week, lost |")
    print("|---|---|---|---|---|---|---|")
    mark = {}
    for arm in ["control", "v14"]:
        grp = defaultdict(list)
        for r in car:
            if r["arm"] == arm and r["deb"] and r["ask"] != "costs" and (arm == "control" or r["bot"] == "keeper"):
                grp[opt(r)].append(r)
        tot_w, tot_l = [], []
        for o, rs in sorted(grp.items()):
            w = [r for r in rs if r["deb"]["o"] == "win"]; l = [r for r in rs if r["deb"]["o"] == "loss"]
            tot_w += w; tot_l += l
            if not w or not l:
                continue
            print("| %s | %s | %d / %d | %+.0f | %.0f%% / %.0f%% | %.2f / %.2f | %.0f%% |" % ("today" if arm == "control" else arm, o, len(w), len(l), mean(cash(r) for r in l) - mean(cash(r) for r in w),
                100.0 * mean(1 if r["end"]["rank"] > 0 else 0 for r in w), 100.0 * mean(1 if r["end"]["rank"] > 0 else 0 for r in l),
                mean(r["end"]["pw"] - 1 for r in w), mean(r["end"]["pw"] for r in l), 100.0 * mean(1 if r["end"]["rebuild"] else 0 for r in l)))
        if tot_w and tot_l:
            mark[arm] = (mean(cash(r) for r in tot_l) - mean(cash(r) for r in tot_w), 100.0 * (mean(1 if r["end"]["rank"] > 0 else 0 for r in tot_w) - mean(1 if r["end"]["rank"] > 0 else 0 for r in tot_l)))
    if "v14" in mark:
        m = mark["v14"]; c0 = mark.get("control", (0.0, 0.0))
        bars.append((12, "A debut loss leaves a mark at the last week: $1,000+ of cash or 20+ points of ranked share behind the same option's wins (not paired: a reading, not a cost)", "v14: cash %+.0f, ranked %+.0f points behind; today: cash %+.0f, ranked %+.0f" % (m[0], m[1], c0[0], c0[1]),
            m[0] <= -LINE_CASH or m[1] >= 20, False))

    # ---------------------------------------------------------------- stage F, the favour
    if carf:
        fon, foff = cells_of(carf, "v14", stage="f"), cells_of(carf, "nofav", stage="f")
        print("\n## Stage F - the favour: its rules on against off, same rolls, same bookings wanted (to the last week of the longer run)\n")
        print("| Cell | Option | Pairs | Cash, on less off | error | Reputation | error | Pro wins less losses | error | Favour at the end | Careers at favour 8+ at some set | Purse bonus paid a career | Title shots a career (won) | Sets the house took the kind back | Holds an area belt, on / off |")
        print("|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|")
        moved = {"keeper": [], "rebel": []}
        for key in sorted(fon, key=ckey):
            for o in sorted(fon[key]):
                on, off = fon[key][o], foff.get(key, {}).get(o, {})
                ks = [k for k in on if k in off]
                if not ks:
                    continue
                d = lambda f: [f(on[k]) - f(off[k]) for k in ks]
                dc, dr, dw = d(cash), d(rep), d(rec)
                rs = [on[k] for k in ks]
                kind = "keeper" if o.endswith("keeper") else "rebel"
                print("| %s | %s (%s) | %d | %+.0f | %.0f | %+.1f | %.1f | %+.2f | %.2f | %.1f | %.0f%% | $%.0f | %.2f (%.2f) | %.1f%% | %.0f%% / %.0f%% |" % (key[0], o, kind, len(ks), mean(dc), se(dc), mean(dr), se(dr), mean(dw), se(dw),
                    mean(r.get("fav", 5) for r in rs), 100.0 * sum(1 for r in rs if r.get("high_sets", 0) > 0) / len(rs), mean(r.get("bonus", 0) for r in rs),
                    mean(r["kinds"].get("title", 0) for r in rs), mean(r.get("title_wins", 0) for r in rs),
                    100.0 * sum(r.get("forced", 0) for r in rs) / max(1, sum(r["sets"] for r in rs)),
                    100.0 * sum(1 for r in rs if r.get("belt", "") != "") / len(rs), 100.0 * sum(1 for k in ks if off[k].get("belt", "") != "") / len(ks)))
                if abs(mean(dc)) >= FAV_CASH or abs(mean(dr)) >= LINE_NAME or abs(mean(dw)) >= FAV_REC:
                    moved[kind].append(o)
        bars.append((15, "The favour moves the result (stage F, the favour's rules on against off on the same rolls): a line on some axis ($500 of gym cash, 3 reputation, 0.5 of a win less loss) for a keeper in at least one house AND for a full rebel in at least one house",
            "keeper moved: %s; rebel moved: %s" % (", ".join(moved["keeper"]) or "none", ", ".join(moved["rebel"]) or "none"), bool(moved["keeper"]) and bool(moved["rebel"]), False))

    print("\n## The bars\n")
    print("| # | Bar | Reads | Verdict |")
    print("|---|---|---|---|")
    bars.sort()
    for n, bar, reads, ok, audit in bars:
        print("| %d | %s | %s | %s |" % (n, bar, reads, "PASS" if ok else "**FAIL**"))
    passed = sum(1 for b in bars if b[3])
    audit_ok = all(b[3] for b in bars if b[4])
    print("\nBars passed: %d of %d (%d bars read; %d are defined). Audit bars (7, 8, 9): %s. VERDICT: %s (PASS = %d or more of %d with every audit bar)." % (passed, N_BARS, len(bars), N_BARS,
        "all pass" if audit_ok else "not all pass", "PASS" if passed >= PASS_AT and audit_ok and len(bars) == N_BARS else "FAIL", PASS_AT, N_BARS))


if __name__ == "__main__":
    main()
