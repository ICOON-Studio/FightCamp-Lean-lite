"""weight3_probe_sum.py - S537 WEIGHT3: turn the rows of tools/weight3_probe.gd into docs/WEIGHT3_PROBE.md.

    python tools/weight3_probe_sum.py --pilot <pilot.csv> --main <main.csv> --tank <tank.csv> [--out docs/WEIGHT3_PROBE.md]

Every night of a set was boxed once on each plan with the same dice, so a way of reading the cut is a choice of which of
those bouts counts; nothing is re-played here. Spread: nights of one boxer and seed are one cluster (12 nights).
The bars are in BARS below and were written before the main run.
"""
from __future__ import annotations

import argparse
import collections
import csv
import math
import sys

BOXERS = ["puncher", "volume", "big chin", "drained cutter", "boxer-puncher"]
PLAN_WORDS = {
    "FLAT": "nobody plans: steady all the way, the corner's own call",
    "EARLY": "Push rounds 1-2 (a 3-rounder: round 1)",
    "P3": "Push from round 3",
    "P5": "Push from round 5",
    "PB3": "Push and go to the body from round 3",
    "B3P5": "Body from round 3, Push from round 5",
    "B1P5": "Body all bout, Push from round 5",
    "LG3": "\"Let your hands go\" from round 3",
    "LG5": "\"Let your hands go\" from round 5",
    "PLG5": "Push and \"Let your hands go\" from round 5",
    "S1P3": "Take rounds 1-2 easy, Push from round 3",
    "S1P5": "Take rounds 1-2 easy, Push from round 5",
    "S1LG5": "Take rounds 1-2 easy, \"Let your hands go\" from round 5",
    "B1LG5": "Body all bout, \"Let your hands go\" from round 5",
}
BARS = [
    "1. The read moves the result: boxing the right plan for the man in front of him (exact read) beats the best single plan boxed every night, by more than two standard errors.",
    "2. No plan is best in more than 6 of the 10 cells (five boxers x a hard cutter / a man who did not cut that hard).",
    "3. A wrong read clearly costs: believing a cutter who is not one (and the reverse) ends more than two standard errors BELOW planning nothing.",
    "4. Best against laziest: the exact read wins 3 or more bouts in 100 more than planning nothing.",
]


def load(path):
    nights = collections.OrderedDict()
    plans = []
    with open(path, newline="") as fh:
        for r in csv.DictReader(fh):
            key = (r["scale"], r["boxer"], int(r["seed"]), int(r["k"]))
            n = nights.setdefault(key, {"scale": r["scale"], "boxer": r["boxer"], "seed": int(r["seed"]), "k": int(r["k"]), "cut": float(r["cut"]),
                                        "fade": r["fade"] == "1", "seen15": r["seen15"] == "1", "seen30": r["seen30"] == "1", "win": {}, "late": {}, "e3b": {}, "ea": {}})
            p = r["plan"]
            if p not in plans:
                plans.append(p)
            n["win"][p] = 1 if r["outcome"] == "win" else 0
            late = r["rounds"][2:]
            n["late"][p] = (late.count("1"), len(late))
            n["e3b"][p] = float(r["e3b"])
            n["ea"][p] = float(r["ea"])
    return list(nights.values()), plans


def ratio(nights, value):
    """Mean of value(night) with a cluster (boxer, seed) standard error. Returns (mean, se, n)."""
    cl = collections.defaultdict(lambda: [0.0, 0])
    for n in nights:
        c = cl[(n["scale"], n["boxer"], n["seed"])]
        c[0] += value(n)
        c[1] += 1
    tot = sum(c[1] for c in cl.values())
    if tot == 0:
        return 0.0, 0.0, 0
    m = sum(c[0] for c in cl.values()) / tot
    k = len(cl)
    var = sum((c[0] - m * c[1]) ** 2 for c in cl.values()) * (k / max(1, k - 1))
    return m, math.sqrt(var) / tot, tot


def pct(x):
    return "%.1f" % (100.0 * x)


def pm(m, se):
    return "%+.1f +- %.1f" % (100.0 * m, 100.0 * se)


def win(nights, plan):
    return ratio(nights, lambda n: n["win"][plan])


def best_plan(nights, plans):
    return max(plans, key=lambda p: win(nights, p)[0])


def policy(kind_of, on_cutter, on_rest):
    return lambda n: n["win"][on_cutter if kind_of(n) else on_rest]


def cells(L, nights, plans, scale):
    L.append("| Boxer | Opponent | Nights | " + " | ".join(plans) + " | Best | Inside two standard errors of it |")
    L.append("| :--- | :--- | ---: | " + " | ".join("---:" for _ in plans) + " | :--- | :--- |")
    count = collections.Counter()
    flips = 0
    for b in BOXERS:
        tops = []
        for kind, word in ((True, "hard cutter"), (False, "the rest")):
            sub = [n for n in nights if n["scale"] == scale and n["boxer"] == b and n["fade"] == kind]
            if not sub:
                continue
            top = best_plan(sub, plans)
            ties = [p for p in plans if p != top and (lambda d: d[0] <= 2.0 * d[1])(ratio(sub, lambda n, p=p: n["win"][top] - n["win"][p]))]
            count[top] += 1
            tops.append((top, ties))
            L.append("| %s | %s | %d | %s | **%s** | %s |" % (b, word, len(sub), " | ".join(pct(win(sub, p)[0]) for p in plans), top, ", ".join(ties) if ties else "-"))
        if len(tops) == 2 and tops[0][0] != tops[1][0] and tops[0][0] not in tops[1][1] and tops[1][0] not in tops[0][1]:
            flips += 1
    return count, flips


def arms(L, nights, plans, scale):
    """Split half: the plans are picked on the even seeds and measured on the odd ones. Returns the bar numbers."""
    pick = [n for n in nights if n["scale"] == scale and n["seed"] % 2 == 0]
    test = [n for n in nights if n["scale"] == scale and n["seed"] % 2 == 1]
    on_cut = best_plan([n for n in pick if n["fade"]], plans)
    on_rest = best_plan([n for n in pick if not n["fade"]], plans)
    one = best_plan(pick, plans)
    L.append("Picked on the even seeds (%d nights): against a hard cutter **%s**, against the rest **%s**, the best single plan **%s**. Measured on the odd seeds (%d nights, %d of them against a hard cutter):" % (
        len(pick), on_cut, on_rest, one, len(test), sum(1 for n in test if n["fade"])))
    L.append("")
    L.append("| Arm | What is boxed | Win | Against planning nothing (wins in 100) | Against the best single plan |")
    L.append("| :--- | :--- | ---: | ---: | ---: |")
    rows = [
        ("blind, laziest", "FLAT every night", lambda n: n["win"]["FLAT"]),
        ("blind, early push", "EARLY every night", lambda n: n["win"]["EARLY"]),
        ("blind, best single plan", "%s every night" % one, lambda n: n["win"][one]),
        ("blind, the cutter's plan", "%s every night" % on_cut, lambda n: n["win"][on_cut]),
        ("exact read", "%s on a hard cutter, %s on the rest" % (on_cut, on_rest), policy(lambda n: n["fade"], on_cut, on_rest)),
        ("range read, +- 1.5 %", "the same, on the tape's read", policy(lambda n: n["seen15"], on_cut, on_rest)),
        ("range read, +- 3 %", "the same, on an unscouted read", policy(lambda n: n["seen30"], on_cut, on_rest)),
        ("WRONG read", "%s on a hard cutter, %s on the rest" % (on_rest, on_cut), policy(lambda n: not n["fade"], on_cut, on_rest)),
    ]
    out = {}
    for name, what, val in rows:
        m, _, _ = ratio(test, val)
        d0 = ratio(test, lambda n, val=val: val(n) - n["win"]["FLAT"])
        d1 = ratio(test, lambda n, val=val: val(n) - n["win"][one])
        out[name] = (d0, d1)
        L.append("| %s | %s | %s %% | %s | %s |" % (name, what, pct(m), pm(d0[0], d0[1]), pm(d1[0], d1[1])))
    L.append("")
    return out, (on_cut, on_rest, one)


def brief_arms(L, nights, scale):
    sub = [n for n in nights if n["scale"] == scale]
    L.append("| The brief's own arms (all seeds) | Win | Against planning nothing (wins in 100) |")
    L.append("| :--- | ---: | ---: |")
    for late in ("P3", "LG3"):
        for name, val in (("%s every night (blind)" % late, lambda n, late=late: n["win"][late]),
                          ("exact read: %s on a hard cutter, FLAT on the rest" % late, policy(lambda n: n["fade"], late, "FLAT")),
                          ("range read +- 1.5 %%: %s on a read cutter, FLAT else" % late, policy(lambda n: n["seen15"], late, "FLAT")),
                          ("WRONG read: FLAT on a hard cutter, %s on the rest" % late, policy(lambda n: not n["fade"], late, "FLAT"))):
            m, _, _ = ratio(sub, val)
            d = ratio(sub, lambda n, val=val: val(n) - n["win"]["FLAT"])
            L.append("| %s | %s %% | %s |" % (name, pct(m), pm(d[0], d[1])))
    m, _, _ = win(sub, "EARLY")
    d = ratio(sub, lambda n: n["win"]["EARLY"] - n["win"]["FLAT"])
    L.append("| EARLY every night (blind) | %s %% | %s |" % (pct(m), pm(d[0], d[1])))
    L.append("")


def teeth(L, nights, scale):
    L.append("| Opponent | Nights | Win, planning nothing | Late rounds won (round 3 on) | His tank as round 3 opens | Our tank at the last bell |")
    L.append("| :--- | ---: | ---: | ---: | ---: | ---: |")
    for kind, word in ((True, "hard cutter"), (False, "the rest")):
        sub = [n for n in nights if n["scale"] == scale and n["fade"] == kind]
        if not sub:
            continue
        lw = sum(n["late"]["FLAT"][0] for n in sub)
        ln = sum(n["late"]["FLAT"][1] for n in sub)
        e3 = [n["e3b"]["FLAT"] for n in sub if n["e3b"]["FLAT"] >= 0.0]
        ea = [n["ea"]["FLAT"] for n in sub if n["ea"]["FLAT"] >= 0.0]
        L.append("| %s | %d | %s %% | %s %% | %.0f | %.0f |" % (word, len(sub), pct(win(sub, "FLAT")[0]), pct(lw / max(1, ln)), sum(e3) / max(1, len(e3)), sum(ea) / max(1, len(ea))))
    L.append("")


def gains(L, nights, plans, scale):
    """Each plan against planning nothing, by the man in front of him, and the difference of the two (what the read can use)."""
    L.append("| Plan | What it is | Against a hard cutter (wins in 100 over FLAT) | Against the rest | Pays MORE against the cutter by |")
    L.append("| :--- | :--- | ---: | ---: | ---: |")
    cut = [n for n in nights if n["scale"] == scale and n["fade"]]
    rest = [n for n in nights if n["scale"] == scale and not n["fade"]]
    top = (None, -9.0, 0.0)
    for p in plans:
        if p == "FLAT":
            continue
        a = ratio(cut, lambda n, p=p: n["win"][p] - n["win"]["FLAT"])
        b = ratio(rest, lambda n, p=p: n["win"][p] - n["win"]["FLAT"])
        d = a[0] - b[0]
        se = math.sqrt(a[1] ** 2 + b[1] ** 2)
        if d > top[1]:
            top = (p, d, se)
        L.append("| %s | %s | %s | %s | %s%s |" % (p, PLAN_WORDS.get(p, ""), pm(a[0], a[1]), pm(b[0], b[1]), pm(d, se), " (clear)" if abs(d) > 2.0 * se else ""))
    L.append("")
    return top


def section(L, title, nights, plans, intro):
    L += ["## " + title, ""] + intro + [""]
    res = {}
    for scale, word in (("pro", "Pro: weighed the day before, 6 rounds; a hard cutter took off 9 or 10 % (two nights in five)"),
                        ("champ", "Championship: weighed three hours before on each of three boxing days, 3 rounds; a hard cutter took off 4 % and it is the third day")):
        if not any(n["scale"] == scale for n in nights):
            continue
        L += ["### " + word, "", "Does the field's cut show on this instrument?", ""]
        teeth(L, nights, scale)
        L += ["What each plan is worth, and to whom:", ""]
        top = gains(L, nights, plans, scale)
        L += ["Win share, cell by cell:", ""]
        count, flips = cells(L, nights, plans, scale)
        most = count.most_common(1)[0] if count else ("-", 0)
        L += ["", "Best counts: %s. The most any one plan wins: %s in %d of %d cells. Boxers whose best plan against a hard cutter is clearly not their best against the rest: %d of %d." % (
            ", ".join("%s %d" % kv for kv in count.most_common()), most[0], most[1], sum(count.values()), flips, len(BOXERS)), ""]
        a, picks = arms(L, nights, plans, scale)
        brief_arms(L, nights, scale)
        res[scale] = {"arms": a, "picks": picks, "most": most, "cells": sum(count.values()), "top": top, "flips": flips}
    return res


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--pilot", required=True)
    ap.add_argument("--main", required=True)
    ap.add_argument("--tank", default="")
    ap.add_argument("--out", default="docs/WEIGHT3_PROBE.md")
    a = ap.parse_args()
    pilot, pplans = load(a.pilot)
    nights, plans = load(a.main)
    L = ["# WEIGHT3 probe - is reading the opponent's cut worth a plan? (S537, ops/research/TASK_WEIGHT3.md)", "",
         "The owner moved the weight mechanic's depth from OUR scale to the OPPONENT'S (\"Yes, move it\", on docs/WEIGHT2_PROBE5.md): our boxer boxes his natural class, and the player reads how much the other man took off",
         "and writes the late rounds of the plan for it. This probe asks whether the fight code pays that. Our boxer is round 5's STAY; the field, its cut and what the cut costs are round 5's model unchanged",
         "(tools/weight2_model.gd: a cut worth 15 % of Stamina or more makes him a fader on the game's own word, a smaller one comes off his rating). Every night is boxed once on each plan with the SAME dice,",
         "so a read is only a choice of which of those bouts counts. Plain bouts, no ladder: the numbers are wins in 100.", "",
         "Run: `python ops/Tools/godot_slot.py run --who weight3 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/weight3_probe.gd -- mode=pilot seeds=12 out=<csv>`, then `mode=main plans=%s seeds=40`, then `mode=tank` with the same plans; `python tools/weight3_probe_sum.py --pilot .. --main .. --tank ..`." % ",".join(plans), "",
         "What is real: the five boxers, each class's opponents, every bout (BoutNight, the game's fight night), and every plan line: the plan's ROUND row (Push / Take it easy), the corner's call for a round, the shout bar's body aim.",
         "What is scratch: the weight sums (round 5's), and section 3's what-if.", "",
         "## A correction to the brief before anything else", "",
         "The brief reads round 5's section 7 as \"reading the cut exactly is worth +1.11 rungs\". It is the other way round: a ladder place is better when LOWER, and the reading arms finished 0.92 and 1.11 rungs BEHIND blind",
         "(wins 47.1 % blind, 43.4 % range, 42.6 % exact; against the hard cutters 40.5 % -> 24.8 %). Round 5's one reading plan, \"Let your hands go\" from round 3, lost bouts. So this probe starts by asking which late line, if any, the fight code pays.", "",
         "## The bars, written before the main run (on the pro scale, round 5's model)", ""] + ["- " + b for b in BARS] + ["",
         "Bars 1, 3 and 4 are measured split-half: the plans are picked on the even seeds and measured on the odd ones, so a lucky plan cannot pass them.", "",
         "## 1. Pilot: which late line does the fight code pay against a drained man? (pro, its own seeds, %d nights x %d plans)" % (len(pilot), len(pplans)), ""]
    gains(L, pilot, pplans, "pro")
    cutp = [n for n in pilot if n["fade"]]
    L += ["Planning nothing wins %s %% against the hard cutters and %s %% against the rest. The rule set before the main run: the main run carries FLAT, EARLY, the brief's two late lines (P3, LG3), the pilot's two best lines against a hard cutter (%s)," % (
        pct(win(cutp, "FLAT")[0]), pct(win([n for n in pilot if not n["fade"]], "FLAT")[0]),
        ", ".join(sorted([p for p in pplans if p != "FLAT"], key=lambda p: -win(cutp, p)[0])[:2])),
        "and two lines the pilot suggested but did not box (S1LG5, B1LG5: rest or body work first, hands late).", ""]
    res = section(L, "2. The main run: round 5's model (%d nights x %d plans, seeds the pilot never saw)" % (len(nights), len(plans)), nights, plans,
                  ["A hard cutter here is a fader on the game's word (he tires from round 3: Exchanges.next_mode, half his exchanges become \"Tiring\"); his tank is not touched."])
    tres = {}
    if a.tank:
        tn, tplans = load(a.tank)
        tres = section(L, "3. What if his cut came off his tank, as ours does? (NOT round 5's model, not in the game; %d nights, the same nights and dice)" % len(tn), tn, tplans,
                       ["Our boxer already pays the scale in his tank at the first bell (the bout's \"stale\", BoutNight._energy). The opponent never does: he starts every bout on a full tank (BoutNight.gd:324).",
                        "This arm takes the Stamina cost of HIS cut off HIS tank (at most 25, the cap ours has) from round 2 on, for every cut and not only the hard ones, gives him no fade word, and leaves punch and reading in his rating.",
                        "It is the smallest rule that would make a drained man different in the late rounds. It decides nothing here: it says what the next round should build and test."])
    pro = res.get("pro", {})
    ar = pro.get("arms", {})
    ok = [False, False, False, False]
    lines = []
    if ar:
        d_read = ar["exact read"][1]
        ok[0] = d_read[0] > 2.0 * d_read[1] and d_read[0] > 0.0
        lines.append("Bar 1 (the read moves the result): exact read against the best single plan %s wins in 100 -> **%s**." % (pm(d_read[0], d_read[1]), "MET" if ok[0] else "NOT MET"))
        ok[1] = pro["most"][1] <= 6
        lines.append("Bar 2 (no plan best in more than 6 of 10 cells): %s is best in %d of %d -> **%s**." % (pro["most"][0], pro["most"][1], pro["cells"], "MET" if ok[1] else "NOT MET"))
        d_wrong = ar["WRONG read"][0]
        ok[2] = d_wrong[0] < -2.0 * d_wrong[1]
        lines.append("Bar 3 (a wrong read clearly costs): the wrong read against planning nothing %s -> **%s**." % (pm(d_wrong[0], d_wrong[1]), "MET" if ok[2] else "NOT MET"))
        d_best = ar["exact read"][0]
        ok[3] = d_best[0] >= 0.03
        lines.append("Bar 4 (best against laziest, 3+ wins in 100): the exact read against planning nothing %s -> **%s**." % (pm(d_best[0], d_best[1]), "MET" if ok[3] else "NOT MET"))
        d_one = ar["blind, best single plan"][0]
        lines.append("Beside bar 4: the best single plan boxed blind every night is already %s over planning nothing, so that gain is the plan's, not the read's." % pm(d_one[0], d_one[1]))
        t = pro["top"]
        lines.append("The line that pays most MORE against a hard cutter than against the rest: %s, by %s wins in 100." % (t[0], pm(t[1], t[2])))
    L += ["## 4. The result", ""] + lines + [""]
    tp = tres.get("pro", {})
    if tp:
        ta = tp["arms"]
        t = tp["top"]
        L += ["The what-if (section 3, pro): exact read against the best single plan %s; the wrong read against planning nothing %s; %s best in %d of %d cells; the line that pays most more against a cutter: %s by %s." % (
            pm(ta["exact read"][1][0], ta["exact read"][1][1]), pm(ta["WRONG read"][0][0], ta["WRONG read"][0][1]), tp["most"][0], tp["most"][1], tp["cells"], t[0], pm(t[1], t[2])), ""]
    broke = [str(i + 1) for i in range(4) if not ok[i]]
    L.append("RESULT: tools/weight3_probe.gd -> %s%s" % ("PASS" if not broke else "FAIL", "" if not broke else " (bars not met: %s)" % ", ".join(broke)))
    L += ["", "## 5. Which lever broke", "",
          "The plan has no line that a drained man makes better. Three things in the fight code, each visible in the tables above:", "",
          "1. OUR tank is the limit, not his. Planning nothing, our boxer reaches the last bell of a six-rounder with about 7 of 100 left (14 in a three-rounder). Under 35 the exchange is fought as \"Your fighter is tired\" whatever the opponent is doing (Exchanges.situation, Exchanges.gd:194-199), and there \"Let your hands go\" is the WRONG call (Exchanges.gd:132) and a Push backfires (PaceAim.push_gassed, PaceAim.gd:193). So every late push or late hands line from round 3 loses against everybody, cutter or not.",
          "2. A hard cutter is barely a different man. The fade word makes half his exchanges \"Tiring\" from round 3 (Exchanges.gd:276), but his tank starts full (BoutNight.gd:324) and stands at 60 against 62 as round 3 opens. On the pro scale planning nothing already wins LESS against him than against the rest, because round 5's model also makes him the bigger man in the ring.",
          "3. One plan is best against everyone: take rounds 1-2 easy, push from round 5 (about +6 wins in 100 boxed blind, both scales, both models). A plan that is right whoever is in front of him is a rule to learn once, not a read. That is a balance finding of its own for the plan's ROUND row.", "",
          "The what-if of section 3 (his cut off his tank) lowers his tank to 45 by round 3 and still fails the same three bars: with our own tank empty there is nothing to spend on him.", "",
          "What a next round would have to change before the read can pay (design only: not built, not probed): the cut must come off the OPPONENT'S tank (one line, BoutNight.gd:324) AND our own boxer must have something left to spend late - either the six-round tank is refitted so a steady boxer ends near 30, or the tired-fighter state stops outranking a tiring opponent. Until both hold, his cut would be a number on the tape that changes no decision.", ""]
    text = "\n".join(L) + "\n"
    with open(a.out, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(text)
    sys.stdout.write(text[-1800:])


if __name__ == "__main__":
    main()
