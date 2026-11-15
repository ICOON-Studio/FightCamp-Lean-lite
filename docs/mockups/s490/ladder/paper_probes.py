"""Paper probes for LADDER1 v3 + the S490 hole fixes (probe 11, probe 16, probe 3 on the drawn path).

NOT the game's probes: those need RepRules/Clock/Challenge built and the fight engine deciding bouts. This runs the v3
sums (expected = 1/(1+10^(gap/25)), 16 x (real - expected) a bout on unanimous results) with stand-in chances, so each
answer's value can be compared before any code. Every stand-in is named in STANDINS and in the README.
Run: python -I docs/mockups/s490/ladder/paper_probes.py
"""
import random

# ---- the v3 sums (DESIGN_LADDER1_V3_REVISE_KALLI_KALLI.md 1.1, 1.2) ----
def expected(you, opp):
    return 1.0 / (1.0 + 10 ** ((opp - you) / 25.0))

def ev(real, exp):                      # average reputation a bout, unanimous results only (v3 1.1)
    return 16.0 * (real - exp)

def reach(rep):                         # v3 3: the gap line, rounded down; S490: the lower line is the same width
    return 10 + rep // 5

# ---- the S490 rules ----
NOT_THIS_SHOW = -1                      # S490 new rule 1
PASS = -2                               # v3 2.2
STOP_RISK_PASS = -2                     # stopped on her own bout -> cannot make the challenger's date -> counts as a pass
TANK_14 = 0.02                          # STAND-IN: BoutRules.gd:43 LAST_BOUT 14 days ago = -4 on the tank; read here as -2 chance points (swept 0..4 below)

STANDINS = {
    "typical ask EV (a free date filled by an ask)": "U(0.6, 1.8) in probe 11; 1.2 in the drawn cases (v3 roads table: safe road +1.2)",
    "coach's read of the challenger": "expected + N(0, 0.10), clipped 0.05..0.95",
    "coach's read of her pending ask": "expected + N(0.06, 0.10)",
    "chance of being stopped on her own bout": "U(0.02, 0.08)",
    "a 14-day double costs 2 chance points": "BoutRules.gd:43 LAST_BOUT [14, 4.0] is -4 tank; the chance cost is a CHECK (swept 0-4)",
}

# A challenge is answered against the next four club shows S1..S4 (Data.gd: every 14 days). The code's cadence: after a
# bout, an ask opens 10 days later (Bouts.AFTER_FIGHT) for a show >= 14 days away (AskBout.MIN_LEAD_DAYS), so the next
# ask bout is two shows later. The challenger's date under Not this show is the show right after her bout (14 days).
def answers(ev_c, ask, typical, stop):
    """ask = None, or {'ev': .., 'free_again': k} (k = the show index the asked boxer is next free, 1-based).
    Returns the average reputation by S4 for Accept, Not this show and Pass."""
    ev_c14 = ev_c - 16 * TANK_14
    if ask is None:
        acc = ev_c + typical                                   # S1 challenger, S3 an ask
        nts = NOT_THIS_SHOW + typical + (1 - stop) * ev_c14 + stop * STOP_RISK_PASS + typical   # S1 ask, S2 challenger, S4 ask
        pas = PASS + typical + typical                         # S1 ask, S3 ask
    else:
        later = ask["ev"] if ask["free_again"] <= 4 else typical   # Accept: the asked boxer again if free by S4 (S3/S4), else any ask at S3
        acc = ev_c + max(later, typical)
        nts = NOT_THIS_SHOW + ask["ev"] + (1 - stop) * ev_c14 + stop * STOP_RISK_PASS + typical   # S1 ask, S2 challenger, S4 ask
        pas = PASS + ask["ev"] + typical                       # S1 ask, S3 ask
    return {"Accept": acc, "Not this show": nts, "Pass": pas}


def drawn_cases():
    her = 31
    out = {}
    # Case 1 (the screen): ask open to ranked 5th (33) for 20 Jun, read 57%; she is booked 4 Jul, 18 Jul, 1 Aug -> free 15 Aug.
    ev_a = ev(0.57, expected(her, 33))
    ev_c = ev(0.72, expected(her, 23))       # ranked 8th, 8 below, read 72%
    out["1 ask open, asked boxer busy to 15 Aug"] = answers(ev_c, {"ev": ev_a, "free_again": 5}, 1.2, 0.05)
    # Case 2 (no ask open): the same challenger, the same week, but she has no ask out.
    out["2 no ask open"] = answers(ev_c, None, 1.2, 0.05)
    # Case 3 (a dangerous challenger): ranked 7th (27, 4 below), a southpaw counter-puncher she has never sparred
    # (BoutRules.gd NEVER_FACED): the coach reads 40%.
    ev_c3 = ev(0.40, expected(her, 27))
    out["3 challenger beats her style"] = answers(ev_c3, None, 1.2, 0.05)
    return out, {"ev_a": ev_a, "ev_c": ev_c, "ev_c3": ev_c3}


def probe11(n=20000, seed=11):
    rng = random.Random(seed)
    best = {"Accept": 0, "Not this show": 0, "Pass": 0}
    for _ in range(n):
        her = rng.uniform(15, 55)
        gap_c = -rng.uniform(1, min(15, reach(int(her))))     # challenges come from inside the lower line (S490) and <= 15 below (v3 2.2)
        e_c = expected(her, her + gap_c)
        read_c = min(0.95, max(0.05, e_c + rng.gauss(0, 0.10)))
        ev_c = ev(read_c, e_c)
        typical = rng.uniform(0.6, 1.8)
        stop = rng.uniform(0.02, 0.08)
        ask = None
        if rng.random() < 0.5:
            gap_a = rng.uniform(-5, reach(int(her)))
            e_a = expected(her, her + gap_a)
            read_a = min(0.95, max(0.05, e_a + rng.gauss(0.06, 0.10)))
            ask = {"ev": ev(read_a, e_a), "free_again": rng.randint(2, 6)}
        r = answers(ev_c, ask, typical, stop)
        best[max(r, key=r.get)] += 1
    return {k: v / n for k, v in best.items()}


def probe16(seeds=200, weeks=52, seed=16):
    """A boxer at 55 who books only the lowest boxer she can, one bout every 4 weeks. Old rule (v3): any booking stops the
    clock. New rule (S490): a bout under her lower line is a TUNE-UP and the clock keeps running."""
    res = {}
    for rule in ("v3", "S490"):
        ends = []
        rng = random.Random(seed)
        for _ in range(seeds):
            rep = 55.0
            pool = [rng.uniform(5, 30) for _ in range(6)]     # STAND-IN: the bottom of a ladder
            free = 0
            for w in range(weeks):
                if w % 4 == 0:
                    opp = min(pool)
                    tune = (rep - opp) > reach(int(rep))
                    e = expected(rep, opp)
                    real = min(0.995, e + 0.01)
                    won = rng.random() < real
                    gain = round(16 * (1 - e)) if won else -round(16 * e)
                    rep = max(0.0, rep + gain)
                    if rule == "v3" or not tune:
                        free = 0
                        continue
                free += 1
                if free > 8 and (free - 8) % 2 == 0:
                    rep -= 1
            ends.append(rep)
        res[rule] = sum(ends) / len(ends)
    return res


def probe3_path():
    """Her drawn season (ladder_season.html): when does she pass each line? BASE0 = today's code (Roster.gd:31-33)."""
    path = [(26, 14), (54, 11), (84, -6), (110, 7), (138, 5), (149, -1), (166, 9), (180, 3), (208, 9), (236, 4), (264, 3), (320, 4)]
    rep, cross = 0, {}
    for day, d in path:
        rep += d
        for line in (45, 55):
            if rep >= line and line not in cross:
                cross[line] = day
    base0 = 180          # 9 wins on Sat 4 Jul (3-1 + wins 31 Jan, 28 Feb, 25 Apr, 23 May, 20 Jun, 4 Jul)
    return rep, cross, base0


if __name__ == "__main__":
    cases, evs = drawn_cases()
    print("EVs a bout:", {k: round(v, 2) for k, v in evs.items()})
    for k, r in cases.items():
        print("CASE", k, {a: round(v, 1) for a, v in r.items()}, "best:", max(r, key=r.get))
    print("PROBE 11 share best:", {k: round(v * 100, 1) for k, v in probe11().items()})
    keep = TANK_14
    for t in (0.0, 0.01, 0.02, 0.03, 0.04):
        globals()["TANK_14"] = t
        print("  sweep: a 14-day double costs", int(t * 100), "chance points ->", {k: round(v * 100, 1) for k, v in probe11().items()})
    globals()["TANK_14"] = keep
    print("PROBE 16 mean reputation after 52 weeks from 55:", {k: round(v, 1) for k, v in probe16().items()})
    rep, cross, base0 = probe3_path()
    print("PROBE 3 path: ends", rep, "| passes 45 on day", cross.get(45), "wk", cross.get(45, 0) // 7 + 1,
          "| passes 55 on day", cross.get(55), "wk", cross.get(55, 0) // 7 + 1, "| BASE0 day", base0, "wk", base0 // 7 + 1)
    for line, d in cross.items():
        print("  line", line, "ratio to BASE0", round((d / 7 + 1) / (base0 / 7 + 1), 2), "(probe 3 window 0.75-1.25)")
