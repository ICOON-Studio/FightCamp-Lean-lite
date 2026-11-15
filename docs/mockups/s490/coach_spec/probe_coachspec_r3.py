"""COACHSPEC1 round 3 probe (S492): John's SQ182 faults 1-5 measured. Pure Python, reuses probe_coachspec.py's rules.

New rules checked here (all (P) = proposed, not built):
  R1 better-of   an S&C morning is rated max(his area, the programme's area): a hire never lowers a morning.
  R2 group       x1.15 only when 2+ fighters train that S&C morning (cap 6); one fighter alone x1.00.
  R3 overlap     a morning you or the boxing coach coach on an S&C day is run by that coach (x1.25 / x1.40 weak), never
                 the group bonus too. The deal takes it only where it adds more than the group morning.
  R4 your night  holding one fighter's whole pad night yourself costs 2 of your 4 and at most 1 a week.
  R5 mobility    a mobility morning on an S&C day: injury risk x0.6 that week (overreached x3 -> x2) AND half its
                 Stamina gain. Its worth = injury weeks avoided; a BUILD or FIGHT week injury pulls the boxer from
                 the bout (FightWeekEvents), so it is priced by the bout it saves there.
  R7 two boxing coaches: pad capacity 3 x 75 min each, the programme takes the better rating per area.

Code numbers: TRAIN_BASE_10H 0.013 a week, SPIKE_MULT 3.0 (InjuryRoll.gd:8,11); TRAIN_TYPES 7-28 days (InjuryRoll.gd:21).
Run: python docs/mockups/s490/coach_spec/probe_coachspec_r3.py
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import probe_coachspec as p  # noqa: E402

GROUP_CAP = 6


def week(route, stats, pots, you_mornings=4):
    """probe_coachspec.week with R1-R3. you_mornings = what is left of your 4 after a held pad night."""
    coach, sc = route["coach"], route["sc"]
    slots = [(fid, dow, sess, it) for fid in stats for dow, (sess, it) in enumerate(p.BASE_WEEK) if sess]

    def g(fid, sess, it, r, mult):
        return 0.2 * p.GAIN[it] * p.cf(r) * p.headroom(pots[fid], stats[fid][p.STAT[sess]]) * mult

    on_day = {}
    for fid, dow, sess, it in slots:
        if sc and dow in sc["days"] and p.AREA[sess] in sc["areas"]:
            on_day[dow] = on_day.get(dow, 0) + 1
    plan = {}
    for s in slots:
        fid, dow, sess, it = s
        area = p.AREA[sess]
        if sc and dow in sc["days"] and area in sc["areas"]:
            r = max(sc["areas"][area], coach[area])                                        # R1
            plan[s] = ("sc", r, p.SHARED if 2 <= on_day[dow] <= GROUP_CAP else 1.0)        # R2
        else:
            plan[s] = ("unattended", coach[area], 1.0)
    for who, areas, n in [("you", p.HEAD, you_mornings), ("coach", coach, route["owned"])]:
        for _ in range(n):
            best, best_add = None, 0.0
            for s in slots:
                if plan[s][0] in ("you", "coach"):
                    continue                                                                # R3: one runner, no stacking
                fid, dow, sess, it = s
                m = p.SOLO_WEAK if p.weak_spot(stats[fid]) == p.STAT[sess] else p.SOLO
                add = g(fid, sess, it, areas[p.AREA[sess]], m) - g(fid, sess, it, *plan[s][1:])
                if add > best_add:
                    best, best_add = s, add
            if best is None:
                break
            fid, dow, sess, it = best
            plan[best] = (who, areas[p.AREA[sess]], p.SOLO_WEAK if p.weak_spot(stats[fid]) == p.STAT[sess] else p.SOLO)
    out = {fid: {} for fid in stats}
    for (fid, dow, sess, it), (who, r, mult) in plan.items():
        out[fid][p.STAT[sess]] = out[fid].get(p.STAT[sess], 0.0) + g(fid, sess, it, r, mult)
    return out


def run(route, weeks=12, you_mornings=4):
    stats = {f: dict(v[1]) for f, v in p.FIGHTERS.items()}
    pots = {f: v[0] for f, v in p.FIGHTERS.items()}
    for _ in range(weeks):
        for fid, gg in week(route, stats, pots, you_mornings).items():
            for st, v in gg.items():
                stats[fid][st] += v
    return sum(stats[f][a] - p.FIGHTERS[f][1][a] for f in stats for a in p.ABIL)


# Pads over 12 weeks: three boxers, pads Mon / Wed / Fri (PadWeek Standard), one drilled move each from a stand-in 12.
CAPS = {f: 40 + 0.4 * st["technique"] + 0.2 * st["fight_iq"] for f, (pot, st) in p.FIGHTERS.items()}   # MoveMastery.cap


def pads12(coaches, you_nights_per_week=0, weeks=12):
    """coaches = list of pad ratings (one per boxing coach, each 75 min a night). You hold one fighter's whole night
    you_nights_per_week times (75 min at HEAD pads); that fighter leaves the coaches' split that night.
    Returns (total mastery gained, fighter-moves that reached Sharp 60, the week of the first Sharp)."""
    m = {f: 12.0 for f in p.FIGHTERS}
    first = None
    fids = list(p.FIGHTERS)
    for w in range(weeks):
        for night in range(3):
            held = fids[(w + night) % 3] if night < you_nights_per_week else None
            if held:
                m[held] = p.pad_night(m[held], 75, p.HEAD["pads"], CAPS[held])
            rest = [f for f in fids if f != held]
            mins = 75.0 * len(coaches) / len(rest)
            r = max(coaches) if coaches else 100.0 / 7.0
            for f in rest:
                m[f] = p.pad_night(m[f], mins, r, CAPS[f])
        if first is None and any(v >= 60 for v in m.values()):
            first = w + 1
    return sum(v - 12.0 for v in m.values()), sum(1 for v in m.values() if v >= 60), first


ROUTES = {
    "Reid alone": {"coach": p.REID, "owned": 2, "sc": None, "wage": 450, "pads": [74]},
    "Reid + S&C A": {"coach": p.REID, "owned": 2, "sc": p.SC_A, "wage": 550, "pads": [74]},
    "Reid + S&C B": {"coach": p.REID, "owned": 2, "sc": p.SC_B, "wage": 650, "pads": [74]},
    "Hale": {"coach": p.HALE, "owned": 3, "sc": None, "wage": 1090, "pads": [58]},
    "Hale + S&C A": {"coach": p.HALE, "owned": 3, "sc": p.SC_A, "wage": 1190, "pads": [58]},
    "Hale + S&C B": {"coach": p.HALE, "owned": 3, "sc": p.SC_B, "wage": 1290, "pads": [58]},
    "Reid + Price (2 coaches)": {"coach": {k: max(p.REID[k], v) for k, v in
                                           {"pads": 60, "bag": 56, "sparring": 55, "conditioning": 50, "strength": 44}.items()},
                                 "owned": 4, "sc": None, "wage": 830, "pads": [74, 60]},
}

if __name__ == "__main__":
    print("COACHSPEC1 round 3: rules R1-R3 on; test club, base week, 12 weeks\n")
    print("%-26s %6s %8s %8s %9s %7s %9s" % ("route", "$/wk", "stats", "+vs Reid", "pads m", "Sharp", "1st Shrp"))
    base = run(ROUTES["Reid alone"])
    for name, r in ROUTES.items():
        t = run(r)
        mast, usable, first = pads12(r["pads"])
        print("%-26s %6d %8.2f %+8.2f %9.1f %7d %9s" % (name, r["wage"], t, t - base, mast, usable, first))
    print("\n(Price = CoachMarket.gd:12-14, $380, pads 60; two coaches = 150 pad minutes a night.)")

    print("\nR4 - your 4: four coached mornings, or one held pad night (costs 2) + two mornings; Reid route, 12 weeks")
    for label, nights, mornings in [("4 mornings", 0, 4), ("1 night + 2 mornings", 1, 2), ("(no cost) 1 night + 3", 1, 3)]:
        st = run(ROUTES["Reid alone"], you_mornings=mornings)
        mast, usable, first = pads12([74], nights)
        print("  %-24s stats %.2f  pads mastery %.1f  moves Sharp %d  first Sharp week %s" % (label, st, mast, usable, first))

    print("\nR5 - mobility: one fighter-week (Reid + S&C A), injury 1.3%/wk, overreached x3, injury 7-28 days (mean 17.5)")
    weekly = base / 12 / 3
    for phase, reach in [("base week", 1.0), ("base, overreached", 3.0), ("BUILD/FIGHT week", 1.0), ("BUILD, overreached", 3.0)]:
        risk = 0.013 * reach
        cut = 0.6 if reach == 1.0 else 2.0 / 3.0
        saved_p = risk * (1 - cut)
        lost_stats = 17.5 / 7 * weekly * 0.75
        bout = phase.startswith("BUILD")
        cost = 0.5 * 0.2 * p.cf(66) * p.headroom(84, 61.6) * 1.15   # half a Stamina morning, Lucy
        print("  %-20s risk %.1f%% -> saved %.2f pp | stat worth saved %.3f%s vs cost %.3f" %
              (phase, risk * 100, saved_p * 100, saved_p * lost_stats,
               " + %.1f%% of a bout" % (saved_p * 100) if bout else "", cost))
