"""COACHSPEC1 balance probe (S490 review round). Pure Python, no Godot.

Re-implements, line for line, the game's morning gain and pad mastery rules so the proposed role numbers can be checked
before any of them reaches a screen. Sources (code wins):
  morning gain  = WeekPlan.SESSION_SHARE 0.2 (WeekPlan.gd:68) x intensity gain (WeekPlan.gd:45-49)
                  x TrainingPreview.coach_factor 0.5 + 0.007 r (TrainingPreview.gd:32-33)
                  x headroom clamp((pot - stat) / 25, 0.10, 1.25) (TrainingPreview.gd:28-29), station tier 1, condition 100
  coached morning x1.25, weak spot x1.40, shared/group x1.15, you own 4, sessional 2, full-time 3
                  (CoachedMornings.gd:14-20; built, tests only)
  pad mastery   = 2.1 /h x minutes/60 x tier 2/2 x (1 + 0.40 r/100) x (1 - m/cap)   (MoveMastery.gd:8,62-79)
                  a pad night = 240 drill minutes for the whole night (PadWeek.gd:38), shown as 75 min (WeekPlan.gd:57)
  base week     = WeekPhase.WEEKS.base (WeekPhase.gd:26-27)
  fighters      = Data.gd lucy() :60-64, PROSPECTS kira :222-225, josh :239-242 (the test club, TestClub.gd)
  coaches       = Data.COACHES :33-40 (Reid $450, Hale $1,090)
PROPOSED (P) numbers live in ROUTES / HEAD below and are what this probe checks.

Run: python docs/mockups/s490/coach_spec/probe_coachspec.py
"""

AREA = {"roadwork": "conditioning", "intervals": "conditioning", "strength": "strength", "heavy_bag": "bag",
        "speed_bag": "bag", "slip_rope": "bag", "shadow": "bag"}          # CoachAreas.gd:11-17
STAT = {"roadwork": "conditioning", "intervals": "conditioning", "strength": "power", "heavy_bag": "power",
        "speed_bag": "speed", "slip_rope": "defense", "shadow": "technique"}  # WeekPlan.gd:32-38
GAIN = {"light": 0.6, "normal": 1.0, "hard": 1.3}
BASE_WEEK = [("roadwork", "normal"), ("heavy_bag", "normal"), ("intervals", "normal"), ("speed_bag", "light"),
             ("roadwork", "normal"), ("strength", "normal"), (None, None)]   # Mon..Sun
SOLO, SOLO_WEAK, SHARED = 1.25, 1.40, 1.15
ABIL = ["power", "speed", "technique", "defense", "conditioning", "fight_iq"]

FIGHTERS = {
    "lucy": (84, {"power": 58.4, "speed": 63.2, "technique": 60.1, "defense": 57.3, "conditioning": 61.6, "fight_iq": 59.0}),
    "kira": (86, {"power": 54.0, "speed": 66.5, "technique": 59.0, "defense": 57.5, "conditioning": 58.0, "fight_iq": 57.0}),
    "josh": (79, {"power": 63.0, "speed": 56.0, "technique": 55.5, "defense": 55.0, "conditioning": 65.0, "fight_iq": 56.0}),
}
REID = {"pads": 74, "bag": 64, "sparring": 58, "conditioning": 48, "strength": 46}
HALE = {"conditioning": 90, "strength": 84, "bag": 72, "sparring": 66, "pads": 58}
NOBODY = {k: 100.0 / 7.0 for k in ["pads", "bag", "sparring", "conditioning", "strength"]}   # CoachAreas.ALONE
HEAD = {"pads": 40, "bag": 55, "sparring": 40, "conditioning": 40, "strength": 40}   # (P) Old hand: edge area bag 55

# S&C candidates (P). days = dow indexes of his group mornings.
SC_A = {"areas": {"conditioning": 66, "strength": 68}, "days": [2, 5], "wage": 100}
SC_B = {"areas": {"conditioning": 60, "strength": 60}, "days": [0, 2, 4, 5], "wage": 200}
SC_A_V1 = {"areas": {"conditioning": 80, "strength": 82}, "days": [2, 5], "wage": 100}   # the first version, for the record

ROUTES = {
    "Reid alone": {"coach": REID, "owned": 2, "sc": None, "wage": 450},
    "Reid + $100 S&C": {"coach": REID, "owned": 2, "sc": SC_A, "wage": 550},
    "Reid + $200 S&C": {"coach": REID, "owned": 2, "sc": SC_B, "wage": 650},
    "Hale": {"coach": HALE, "owned": 3, "sc": None, "wage": 1090},
    "(v1) Reid + $100 S&C at 80/82": {"coach": REID, "owned": 2, "sc": SC_A_V1, "wage": 550},
    "No coach (first hour), you at 40": {"coach": NOBODY, "owned": 0, "sc": None, "wage": 0},
}


def cf(r):
    return 0.5 + 0.007 * r


def headroom(pot, s):
    return min(1.25, max(0.10, (pot - s) / 25.0))


def weak_spot(st):
    mean = sum(st[a] for a in ABIL) / 6.0
    low = min(ABIL, key=lambda a: st[a])
    return low if mean - st[low] >= 3.0 else ""


def week(route, stats, pots):
    """One week of mornings for every boxer. Returns gains {fid: {stat: g}}."""
    coach, sc = route["coach"], route["sc"]
    slots = []   # (fid, dow, session, intensity)
    for fid in stats:
        for dow, (sess, it) in enumerate(BASE_WEEK):
            if sess:
                slots.append((fid, dow, sess, it))

    def base_gain(fid, sess, it, r, mult):
        st = STAT[sess]
        return 0.2 * GAIN[it] * cf(r) * headroom(pots[fid], stats[fid][st]) * mult

    plan = {}
    for s in slots:
        fid, dow, sess, it = s
        area = AREA[sess]
        if sc and dow in sc["days"] and area in sc["areas"]:
            plan[s] = ("sc", sc["areas"][area], SHARED)          # (P) group morning at his rating, shared x1.15
        else:
            plan[s] = ("unattended", coach[area], 1.0)           # today's rule: the hired coach's area rating
    # Deal coached mornings greedily: yours (4, at your areas) and the boxing coach's (2 or 3, at his).
    pools = [("you", HEAD, 4), ("coach", coach, route["owned"])]
    for who, areas, n in pools:
        for _ in range(n):
            best, best_add = None, 0.0
            for s in slots:
                if plan[s][0] != "unattended":
                    continue
                fid, dow, sess, it = s
                weak = weak_spot(stats[fid]) == STAT[sess]
                m = SOLO_WEAK if weak else SOLO
                add = base_gain(fid, sess, it, areas[AREA[sess]], m) - base_gain(fid, sess, it, *plan[s][1:])
                if add > best_add:
                    best, best_add = s, add
            if best is None:
                break
            fid, dow, sess, it = best
            weak = weak_spot(stats[fid]) == STAT[sess]
            plan[best] = (who, areas[AREA[sess]], SOLO_WEAK if weak else SOLO)
    out = {fid: {} for fid in stats}
    for s, (who, r, mult) in plan.items():
        fid, dow, sess, it = s
        g = base_gain(fid, sess, it, r, mult)
        out[fid][STAT[sess]] = out[fid].get(STAT[sess], 0.0) + g
    return out


def run(route, weeks=12):
    stats = {f: dict(v[1]) for f, v in FIGHTERS.items()}
    pots = {f: v[0] for f, v in FIGHTERS.items()}
    start = {f: dict(v[1]) for f, v in FIGHTERS.items()}
    for _ in range(weeks):
        g = week(route, stats, pots)
        for fid in stats:
            for st, v in g[fid].items():
                stats[fid][st] += v
    gains = {fid: {st: stats[fid][st] - start[fid][st] for st in ABIL} for fid in stats}
    return gains


def pad_night(m, minutes_shown, r, cap):
    gm = 240.0 * minutes_shown / 75.0
    return m + 2.1 * gm / 60.0 * 1.0 * (1 + 0.40 * r / 100.0) * max(0.0, 1 - m / cap)


if __name__ == "__main__":
    print("COACHSPEC1 probe: test club (Lucy, Kira, Josh), base week, 12 weeks; morning stats only\n")
    print("%-32s %6s %8s %8s %8s %8s %10s" % ("route", "$/wk", "Stamina", "Power", "Speed", "all", "$ per pt"))
    base = None
    for name, r in ROUTES.items():
        g = run(r)
        sta = sum(g[f]["conditioning"] for f in g)
        pw = sum(g[f]["power"] for f in g)
        sp = sum(g[f]["speed"] for f in g)
        tot = sum(sum(g[f].values()) for f in g)
        if base is None:
            base = tot
            extra = "-"
        else:
            extra = "%.0f" % ((r["wage"] - 450) * 12 / (tot - base)) if tot > base else "-"
        print("%-32s %6d %8.2f %8.2f %8.2f %8.2f %10s" % (name, r["wage"], sta, pw, sp, tot, extra))
    print("\n'$ per pt' = the route's extra wage over Reid alone for 12 weeks / its extra stat points over Reid alone.")
    # Pad mastery per pad hour, by who holds the pads.
    print("\nPad lift (MoveMastery x(1+0.40r/100)): Reid 74 %.3f, Hale 58 %.3f, you 40 %.3f" %
          (1 + .4 * .74, 1 + .4 * .58, 1 + .4 * .40))
    # The Wednesday pads decision (evening_plan): Lucy's uppercut, cap = MoveMastery.cap(60.1, 59) = 75.84.
    cap = 40 + 0.4 * 60.1 + 0.2 * 59.0
    m0 = 18.5   # STAND-IN: her uppercut at the start of week 7
    mon = pad_night(m0, 45, 74, cap)
    coach_wed = pad_night(mon, 45, 74, cap)
    coach_fri = pad_night(coach_wed, 30, 74, cap)
    you_wed = pad_night(mon, 75, 40, cap)
    you_fri = pad_night(you_wed, 30, 74, cap)
    print("\nUppercut (cap %.2f): start %.1f, Mon 45 min coach -> %.2f" % (cap, m0, mon))
    print("  Wed your coach 45 min -> %.2f, Fri 30 min -> %.2f" % (coach_wed, coach_fri))
    print("  Wed you 75 min        -> %.2f, Fri 30 min -> %.2f" % (you_wed, you_fri))
    # Kira's Wednesday: 30 min (split) vs the coach's whole 75 (you took Lucy): her check hook from a stand-in 12.
    capk = 40 + 0.4 * 59.0 + 0.2 * 57.0
    print("  Kira check hook 12 -> %.2f (30 min) or %.2f (75 min)" % (pad_night(12, 30, 74, capk), pad_night(12, 75, 74, capk)))
    # Per-morning numbers for the screens (Lucy, today's headroom, Normal).
    hl = headroom(84, 61.6); hp = headroom(84, 58.4)
    for lab, r, m in [("Reid unattended", 48, 1.0), ("you coached", 40, 1.25), ("Reid coached", 48, 1.25),
                      ("S&C A group", 66, 1.15), ("S&C B group", 60, 1.15), ("Hale unattended", 90, 1.0)]:
        print("  Lucy Stamina morning, %-16s %.3f" % (lab, 0.2 * cf(r) * hl * m))
    for lab, r, m in [("Reid unattended", 46, 1.0), ("S&C A group", 68, 1.15), ("S&C B group", 60, 1.15), ("Hale", 84, 1.0)]:
        print("  Lucy strength morning, %-15s %.3f" % (lab, 0.2 * cf(r) * hp * m))
    for fid, (pot, st) in FIGHTERS.items():
        h1, h2 = headroom(pot, st["conditioning"]), headroom(pot, st["power"])
        print("  %s headroom Stamina %.2f Power %.2f | Stamina Reid %.3f -> A %.3f | Power Reid %.3f -> A %.3f" %
              (fid, h1, h2, .2 * cf(48) * h1, .2 * cf(66) * h1 * 1.15, .2 * cf(46) * h2, .2 * cf(68) * h2 * 1.15))

    # Per fighter, 12 weeks: Reid + $100 S&C against Reid alone (staff_hire's last column).
    a, b = run(ROUTES["Reid + $100 S&C"]), run(ROUTES["Reid alone"])
    for fid in a:
        print("  12 weeks %s: Stamina +%.2f Power +%.2f over Reid alone" %
              (fid, a[fid]["conditioning"] - b[fid]["conditioning"], a[fid]["power"] - b[fid]["power"]))
    # Lucy's build week (evening_plan), focus Stamina: WeekPhase build = roadwork N, F(intervals) H, intervals N,
    # speed bag L, roadwork N, strength N, rest. Roles: Tue you coach, Wed + Sat S&C A group, Thu your coach coaches.
    hs = headroom(84, 63.2)
    rows = [("Mon roadwork N", "conditioning", 1.0, 48, 1.0, 48, 1.0), ("Tue intervals H", "conditioning", 1.3, 48, 1.0, 40, 1.25),
            ("Wed intervals N", "conditioning", 1.0, 48, 1.0, 66, 1.15), ("Thu speed bag L", "speed", 0.6, 64, 1.0, 64, 1.25),
            ("Fri roadwork N", "conditioning", 1.0, 48, 1.0, 48, 1.0), ("Sat strength N", "power", 1.0, 46, 1.0, 68, 1.15)]
    tot_t, tot_r = {}, {}
    for lab, st, it, rt, mt, rr, mr in rows:
        h = {"conditioning": hl, "power": hp, "speed": hs}[st]
        t, r = 0.2 * it * cf(rt) * h * mt, 0.2 * it * cf(rr) * h * mr
        tot_t[st] = tot_t.get(st, 0) + t; tot_r[st] = tot_r.get(st, 0) + r
        print("  %-16s today %.3f  roles %.3f" % (lab, t, r))
    print("  her week today", {k: round(v, 3) for k, v in tot_t.items()}, "roles", {k: round(v, 3) for k, v in tot_r.items()})
