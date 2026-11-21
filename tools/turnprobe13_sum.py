"""turnprobe13_sum.py - TURNPROBE13 (S536): the JSON lines of tools/turnprobe13.gd as the tables of docs/TURNPROBE13_RESULT.md.

    python tools/turnprobe13_sum.py <jsonl> [<jsonl> ...]      # prints markdown

A copy of tools/turnprobe12_sum.py: the same pairing, pass rule and bars. Softer is gone (map v13), so bar 10 is now the
new lever's control arm: the "flat" arm is v13 with the tune-up name rule off, on the same rolls.
A ROLL is one boxer's call week (a bout's dice are the fight day's). A CELL is the gym on the day of the call (seats 48 /
56 / 64 with room, or full), pooled over the boxers and rolls; the boxer-by-boxer reading splits each cell by boxer.
THE PASS RULE (TURNPROBE11 section 5 item 3): every option is read PAIRED against the plain guarantee house on the same
roll. A beats B in a cell when A is ahead by the line on one axis (LINE_CASH of gym cash by the last week, or LINE_WINS
debut wins in 100) and not behind by the line on the other. RIGHT = beaten by nobody. THE ONE ANSWER = beats every other.
"""
import json
import math
import sys
from collections import defaultdict

LINE_CASH = 1000.0
LINE_WINS = 3.0
CELLS = ["48", "56", "64", "full"]
BASE = "guarantee no ask"


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


def opt(r):
    return "%s %s" % ("ticket" if r["house"] == "bow" else "guarantee", "no ask" if r["ask"] == "none" else r["ask"])


def cash(r):
    return r["end"]["cash"] - r["cash0"]


def won(r):
    return 100.0 if r["deb"] and r["deb"]["o"] == "win" else 0.0


def pairs(cell, a, b):
    """cell = {option: {roll: career}} -> the careers of a and b on the same rolls."""
    ra, rb = cell.get(a, {}), cell.get(b, {})
    return [(ra[k], rb[k]) for k in ra if k in rb]


def gap(cell, a, b):
    ps = pairs(cell, a, b)
    dc = [cash(x) - cash(y) for x, y in ps]
    dw = [won(x) - won(y) for x, y in ps]
    return {"n": len(ps), "cash": mean(dc), "cash_se": se(dc), "wins": mean(dw), "wins_se": se(dw)}


def beats(cell, a, b):
    g = gap(cell, a, b)
    if g["n"] == 0:
        return False
    return (g["cash"] >= LINE_CASH and g["wins"] > -LINE_WINS) or (g["wins"] >= LINE_WINS and g["cash"] > -LINE_CASH)


def verdict(cell):
    opts = sorted(cell)
    right = [a for a in opts if not any(beats(cell, b, a) for b in opts if b != a)]
    one = [a for a in opts if all(beats(cell, a, b) for b in opts if b != a)]
    return right, (one[0] if one else "")


def cells_of(car, arm, by_boxer=False):
    out = defaultdict(lambda: defaultdict(dict))
    for r in car:
        if r["arm"] != arm:
            continue
        key = (r["cell"], r["who"]) if by_boxer else (r["cell"],)
        out[key][opt(r)][(r["who"], r["k"])] = r
    return out


def stat(rs):
    deb = [r["deb"] for r in rs if r["deb"]]
    o = lambda k: 100.0 * sum(1 for d in deb if d["o"] == k) / max(1, len(deb))
    kinds = defaultdict(int)
    for r in rs:
        for k, v in r["kinds"].items():
            kinds[k] += v
    booked = max(1, sum(kinds.values()))
    return {"n": len(rs), "win": o("win"), "draw": o("draw"), "loss": o("loss"), "stop": 100.0 * sum(1 for d in deb if d["stop"]) / max(1, len(deb)),
            "sold": mean(d["sold"] for d in deb), "gym": mean(d["gym"] for d in deb), "name": mean(d.get("name", 0) for d in deb),
            "cash": mean(cash(r) for r in rs), "members": mean(r["end"]["members"] for r in rs), "rep": mean(r["end"]["rep"] for r in rs),
            "morale": mean(r["end"]["morale"] for r in rs), "loy": mean(r["end"]["loy"] for r in rs), "dur": mean(r["end"]["dur"] for r in rs),
            "pw": mean(r["end"]["pw"] for r in rs), "pl": mean(r["end"]["pl"] for r in rs),
            "ranked": 100.0 * sum(1 for r in rs if r["end"]["rank"] > 0) / max(1, len(rs)), "fans": mean(r["end"]["fans"] for r in rs),
            "step": 100.0 * kinds["above"] / booked, "tune": 100.0 * kinds["tune"] / booked, "payday": 100.0 * kinds["payday"] / booked,
            "fights": mean(r["end"]["pw"] + r["end"]["pl"] + r["end"]["pd"] for r in rs), "tw": mean(r.get("tune_wins", 0) for r in rs),
            "closed": 100.0 * sum(1 for r in rs if r["end"]["closed"]) / max(1, len(rs))}


def main():
    rows = load(sys.argv[1:])
    calls = [r for r in rows if r.get("tag") == "call"]
    first = {}
    for r in calls:   # a boxer's call week counted once: the same Saturday is the same dice
        first.setdefault((r["who"], r["day"] // 7), r["k"])
    keep = {(r["who"], r["k"]) for r in calls if first[(r["who"], r["day"] // 7)] == r["k"]}
    car = [r for r in rows if r.get("tag") == "career" and (r["who"], r["k"]) in keep]
    nights = [r for r in rows if r.get("tag") == "night"]
    bars = []   # (number, bar, reads, ok, audit)

    print("## Population\n")
    for r in rows:
        if r.get("tag") == "run" and r.get("stage") == "b":
            print("- run: boxers %s, %s seeds x %s call days, to week %s, cells %s (today's rules also in %s)" % (r["boxers"], r["seeds"], r["days"], r["weeks"], r["cells"], r["ctl"]))
    print("\n| Boxer | Rolls (call weeks) | Call days | Record at the calls | Strength (no camp) | Gym's own seats | Room for members (cap) | Loyalty |")
    print("|---|---|---|---|---|---|---|---|")
    by = defaultdict(list)
    for r in calls:
        if (r["who"], r["k"]) in keep and r in calls:
            by[(r["b"], r["who"], r["style"])].append(r)
    stage_b_calls = {(r["who"], r["k"]) for r in car}
    n_rolls = 0
    for (b, who, style), rs in sorted(by.items()):
        rs = [r for r in rs if (r["who"], r["k"]) in stage_b_calls]
        if not rs:
            continue
        n_rolls += len(rs)
        print("| %s (%s) | %d | %d .. %d | %d-%d .. %d-%d | %.1f .. %.1f | %d .. %d | %d | %d .. %d |" % (who, style, len(rs), min(r["day"] for r in rs), max(r["day"] for r in rs),
            min(r["w"] for r in rs), max(r["l"] for r in rs if r["w"] == min(x["w"] for x in rs)), max(r["w"] for r in rs), max(r["l"] for r in rs),
            min(r["night"] for r in rs), max(r["night"] for r in rs), min(r["seats_real"] for r in rs), max(r["seats_real"] for r in rs), rs[0]["cap"],
            min(r["loyalty"] for r in rs), max(r["loyalty"] for r in rs)))
    skips = [r for r in rows if r.get("tag") == "skip"]
    print("\nRolls: %d. Careers played and counted: %d (v13 %d, v13 with the tune-up rule off %d, today's rules %d). Cells skipped because one house called alone: %d." % (
        n_rolls, len(car), sum(1 for r in car if r["arm"] == "v13"), sum(1 for r in car if r["arm"] == "flat"), sum(1 for r in car if r["arm"] == "control"), len(skips)))

    if nights:
        print("\n## Stage A - the night (the same scratch nights for every row of a boxer)\n")
        print("| Rules | Option | Boxers | Card shows (mean) | Played win (mean) | lowest .. highest | Draw | Loss | Stopped losses |")
        print("|---|---|---|---|---|---|---|---|---|")
        grp = defaultdict(list)
        for r in nights:
            grp[(r["arm"], opt(r))].append(r)
        A = {}
        for (arm, o), rs in grp.items():
            w = [100.0 * r["win"] / r["n"] for r in rs]
            A[(arm, o)] = {"shown": mean(100 * r["shown"] for r in rs), "win": mean(w)}
            print("| %s | %s | %d | %.1f | %.1f | %.1f .. %.1f | %.1f | %.1f | %.1f |" % ("today" if arm == "control" else arm, o, len(rs), A[(arm, o)]["shown"], mean(w), min(w), max(w),
                mean(100.0 * r["draw"] / r["n"] for r in rs), mean(100.0 * r["loss"] / r["n"] for r in rs), mean(100.0 * r["stop_l"] / r["n"] for r in rs)))
        t, g = A.get(("v13", "ticket no ask")), A.get(("v13", "guarantee no ask"))
        if t and g:
            bars.append((3, "Played debut wins: ticket house 52 to 68 in 100, guarantee house 70 to 82", "%.1f and %.1f" % (t["win"], g["win"]), 52 <= t["win"] <= 68 and 70 <= g["win"] <= 82, False))
            bars.append((4, "The card is honest: shown within 3 of played, each house", "ticket %.1f shown, %.1f played; guarantee %.1f shown, %.1f played" % (t["shown"], t["win"], g["shown"], g["win"]),
                abs(t["shown"] - t["win"]) <= 3 and abs(g["shown"] - g["win"]) <= 3, False))
        lt, lg = A.get(("v13", "ticket later2")), A.get(("v13", "guarantee later2"))
        if t and g and lt and lg:
            card = [lt["shown"] - t["shown"], lg["shown"] - g["shown"]]
            play = [lt["win"] - t["win"], lg["win"] - g["win"]]
            bars.append((14, "Later +2: the card shows +1 to +4, the played gain is not below 0 (a calendar tool, not a fork lever)", "card %+.1f / %+.1f; played %+.1f (ticket), %+.1f (guarantee)" % (card[0], card[1], play[0], play[1]),
                all(1 <= c <= 4 for c in card) and all(p >= 0 for p in play), False))

    ctl = cells_of(car, "control")
    if ctl:
        print("\n## The mutant: today's costs ask against today's plain guarantee house (the instrument must see it)\n")
        print("| Cell | Pairs | Cash by the last week | error | Debut wins in 100 |")
        print("|---|---|---|---|---|")
        ok = True
        reads = []
        for key in sorted(ctl):
            g = gap(ctl[key], "guarantee costs", BASE)
            ok = ok and 700 <= g["cash"] <= 1100 and g["cash_se"] < 100
            reads.append("%s: %+.0f, error %.0f" % (key[0], g["cash"], g["cash_se"]))
            print("| %s | %d | %+.0f | %.0f | %+.1f |" % (key[0], g["n"], g["cash"], g["cash_se"], g["wins"]))
            t = gap(ctl[key], "ticket no ask", BASE)
            print("| %s (today's ticket house, no ask) | %d | %+.0f | %.0f | %+.1f |" % (key[0], t["n"], t["cash"], t["cash_se"], t["wins"]))
        bars.append((1, "Instrument: today's costs ask reads +$700 to +$1,100 against today's plain guarantee house, error under $100, in every cell it is played", "; ".join(reads), ok, False))

    cells = cells_of(car, "v13")
    print("\n## Stage B - map v13, cell by cell (pooled over boxers and rolls)\n")
    print("| Cell | Option | n | Debut win / draw / loss | Seats on the night | Name won on the night | Cash by the last week | Members | Reputation | Ranked | Fans | Pro wins - losses | Pro fights | Step ups / tune-ups / paydays booked | Tune-up wins | Chin ceiling | Morale | Loyalty | Gym closed |")
    print("|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|")
    for key in sorted(cells, key=lambda k: CELLS.index(k[0])):
        right, one = verdict(cells[key])
        for o in sorted(cells[key]):
            s = stat(list(cells[key][o].values()))
            print("| %s | %s%s | %d | %.0f / %.0f / %.0f | %.0f | %+.1f | %+.0f | %.0f | %.0f | %.0f%% | %+.1f | %.2f - %.2f | %.1f | %.0f / %.0f / %.0f | %.2f | %.1f | %.0f | %.0f | %.0f%% |" % (
                key[0], o, " **(the one answer)**" if o == one else (" (right)" if o in right else ""), s["n"], s["win"], s["draw"], s["loss"], s["sold"], s["name"], s["cash"],
                s["members"], s["rep"], s["ranked"], s["fans"], s["pw"], s["pl"], s["fights"], s["step"], s["tune"], s["payday"], s["tw"], s["dur"], s["morale"], s["loy"], s["closed"]))

    print("\n## The pass rule: each option against the plain guarantee house on the same roll\n")
    print("| Cell | Option | Pairs | Cash by the last week | error | Debut wins in 100 | error | Reputation | Reads |")
    print("|---|---|---|---|---|---|---|---|---|")
    errs = []
    trade = []; flip = []; ahead = []; rep_room = []
    for key in sorted(cells, key=lambda k: CELLS.index(k[0])):
        cell = cells[key]
        for o in sorted(cell):
            if o == BASE:
                continue
            g = gap(cell, o, BASE)
            dr = mean(x["end"]["rep"] - y["end"]["rep"] for x, y in pairs(cell, o, BASE))
            errs.append(g["cash_se"])
            word = "beats it" if beats(cell, o, BASE) else ("beaten by it" if beats(cell, BASE, o) else ("a trade" if (abs(g["cash"]) >= LINE_CASH or abs(g["wins"]) >= LINE_WINS) else "no measured difference"))
            print("| %s | %s | %d | %+.0f | %.0f | %+.1f | %.1f | %+.1f | %s |" % (key[0], o, g["n"], g["cash"], g["cash_se"], g["wins"], g["wins_se"], dr, word))
            if o == "ticket no ask":
                if g["cash"] >= LINE_CASH and g["wins"] <= -LINE_WINS:
                    trade.append(key[0])
                if beats(cell, BASE, o):
                    flip.append(key[0])
                if key[0] != "full":
                    rep_room.append(dr)
            if g["cash"] >= LINE_CASH or g["wins"] >= LINE_WINS:
                ahead.append(key[0])
    print("\nThe same gaps on the rolls where no option's gym closed (the bot does not run the gym; a closed gym stops its own bills):\n")
    print("| Cell | Option | Pairs | Cash by the last week | error | Debut wins in 100 |")
    print("|---|---|---|---|---|---|")
    for key in sorted(cells, key=lambda k: CELLS.index(k[0])):
        cell = cells[key]
        shut = {k for rs in cell.values() for k, r in rs.items() if r["end"]["closed"]}
        open_cell = {o: {k: r for k, r in rs.items() if k not in shut} for o, rs in cell.items()}
        for o in sorted(open_cell):
            if o != BASE:
                g = gap(open_cell, o, BASE)
                print("| %s | %s | %d | %+.0f | %.0f | %+.1f |" % (key[0], o, g["n"], g["cash"], g["cash_se"], g["wins"]))
    n_cells = len(cells)
    bars.append((2, "Instrument: the error on every option's cash gap is $250 or less in every pooled cell (a $1,000 gap is four errors)", "largest error $%.0f" % max(errs or [0]), bool(errs) and max(errs) <= 250, False))
    bars.append((5, "The fork is a trade somewhere: the ticket house, no ask, is $1,000+ ahead on cash and 3+ debut wins behind in at least one cell", "cells: %s" % (", ".join(trade) or "none"), bool(trade), False))
    bars.append((6, "The fork flips: the plain guarantee house beats the ticket house's plain offer in at least one cell", "cells: %s" % (", ".join(flip) or "none"), bool(flip), False))

    print("\n## Who is right, cell by cell\n")
    print("| Cell | Right (beaten by nobody) | The one answer |")
    print("|---|---|---|")
    ones = defaultdict(int); rights = defaultdict(int)
    for key in sorted(cells, key=lambda k: CELLS.index(k[0])):
        right, one = verdict(cells[key])
        for o in right:
            rights[o] += 1
        if one:
            ones[one] += 1
        print("| %s | %s | %s |" % (key[0], ", ".join(right) or "-", one or "-"))
    all_opts = sorted({o for c in cells.values() for o in c})
    worst = max([ones[o] for o in all_opts] or [0])
    bars.append((7, "AUDIT: no option is the one answer in more than 6 cells of 10", "; ".join("%s %d of %d" % (o, ones[o], n_cells) for o in all_opts), n_cells > 0 and worst <= 0.6 * n_cells, True))
    bars.append((8, "AUDIT: every option is right (beaten by nobody) in at least one cell", "; ".join("%s %d of %d" % (o, rights[o], n_cells) for o in all_opts), n_cells > 0 and all(rights[o] >= 1 for o in all_opts), True))
    n_ahead = len(set(ahead))
    bars.append((9, "AUDIT: best against laziest - in at least half the cells an option is ahead of the plain guarantee house by $1,000 or 3 wins in 100", "%d of %d cells (%s)" % (n_ahead, n_cells, ", ".join(sorted(set(ahead))) or "none"), n_cells > 0 and n_ahead >= 0.5 * n_cells, True))
    flat = cells_of(car, "flat")
    print("\n## The new lever's control arm: v13 with the tune-up rule off (every pro win pays 5 reputation), same rolls\n")
    print("| Cell | Pairs | Ticket house's reputation lead, v13 | the rule off | The rule adds | Ticket house's cash lead, v13 | the rule off |")
    print("|---|---|---|---|---|---|---|")
    adds = []
    for key in sorted(flat, key=lambda k: CELLS.index(k[0])):
        on, off = cells.get(key, {}), flat[key]
        ks = [k for k in on.get("ticket no ask", {}) if k in on.get(BASE, {}) and k in off.get("ticket no ask", {}) and k in off.get(BASE, {})]
        if not ks:
            continue
        lead = lambda c, f: mean(f(c["ticket no ask"][k]) - f(c[BASE][k]) for k in ks)
        r_on, r_off = lead(on, lambda r: r["end"]["rep"]), lead(off, lambda r: r["end"]["rep"])
        print("| %s | %d | %+.1f | %+.1f | %+.1f | %+.0f | %+.0f |" % (key[0], len(ks), r_on, r_off, r_on - r_off, lead(on, cash), lead(off, cash)))
        if key[0] != "full":
            adds.append((key[0], r_on - r_off))
    bars.append((10, "The lever is real: with the tune-up rule off, on the same rolls, the ticket house's reputation lead is 1+ smaller in every cell with room it is played in", "; ".join("%s: the rule adds %+.1f" % a for a in adds) or "none", bool(adds) and min(a[1] for a in adds) >= 1, False))

    bcells = cells_of(car, "v13", True)
    bones = defaultdict(int); brights = defaultdict(int)
    for key in bcells:
        right, one = verdict(bcells[key])
        for o in right:
            brights[o] += 1
        if one:
            bones[one] += 1
    nb_cells = len(bcells)
    print("\n## Boxer by boxer (a cell = boxer x gym, %d cells)\n" % nb_cells)
    print("| Option | right in | the one answer in |")
    print("|---|---|---|")
    for o in all_opts:
        print("| %s | %d of %d | %d of %d |" % (o, brights[o], nb_cells, bones[o], nb_cells))
    bars.append((11, "Boxer by boxer: no option the one answer in more than 6 cells of 10, every option right in at least 2", "; ".join("%s right %d, one answer %d of %d" % (o, brights[o], bones[o], nb_cells) for o in all_opts),
        nb_cells > 0 and max([bones[o] for o in all_opts] or [0]) <= 0.6 * nb_cells and all(brights[o] >= 2 for o in all_opts), False))

    print("\n## What a debut loss leaves at the last week (the same option, lost against won)\n")
    print("| Rules | Option | Debuts won / lost | Cash, lost less won | Ranked, won / lost | Pro wins after the debut, won / lost | Rebuilding at the last week, lost |")
    print("|---|---|---|---|---|---|---|")
    mark = {}
    for arm in ["control", "v13"]:
        grp = defaultdict(list)
        for r in car:
            if r["arm"] == arm and r["deb"] and r["ask"] != "costs":
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
    if "v13" in mark:
        m = mark["v13"]; c0 = mark.get("control", (0.0, 0.0))
        bars.append((12, "A debut loss leaves a mark at the last week: $1,000+ of cash or 20+ points of ranked share behind the same option's wins", "v13: cash %+.0f, ranked %+.0f points behind; today: cash %+.0f, ranked %+.0f" % (m[0], m[1], c0[0], c0[1]),
            m[0] <= -LINE_CASH or m[1] >= 20, False))
    allv = defaultdict(list)
    for r in car:
        if r["arm"] == "v13" and r["ask"] == "none":
            allv[r["house"]].append(r)
    if allv["bow"] and allv["hf"]:
        st, sg = stat(allv["bow"]), stat(allv["hf"])
        bars.append((13, "The roads differ: step ups are 25+ points more of the ticket house's bookings than of the guarantee house's", "ticket %.0f%% step ups, guarantee %.0f%%; ranked by the last week %.0f%% against %.0f%%" % (st["step"], sg["step"], st["ranked"], sg["ranked"]),
            st["step"] - sg["step"] >= 25, False))
    bars.append((15, "The name stays: the ticket house's plain offer ends 4+ reputation ahead of the plain guarantee house in every cell with room", ", ".join("%+.1f" % d for d in rep_room) or "none", bool(rep_room) and min(rep_room) >= 4, False))

    print("\n## The bars\n")
    print("| # | Bar | Reads | Verdict |")
    print("|---|---|---|---|")
    bars.sort()
    for n, bar, reads, ok, audit in bars:
        print("| %d | %s | %s | %s |" % (n, bar, reads, "PASS" if ok else "**FAIL**"))
    passed = sum(1 for b in bars if b[3])
    audit_ok = all(b[3] for b in bars if b[4])
    print("\nBars passed: %d of %d. Audit bars (7, 8, 9): %s. VERDICT: %s (PASS = 12 or more with every audit bar)." % (passed, len(bars), "all pass" if audit_ok else "not all pass",
        "PASS" if passed >= 12 and audit_ok and len(bars) == 15 else "FAIL"))


if __name__ == "__main__":
    main()
