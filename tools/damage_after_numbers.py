"""DAMAGE AFTER THE FIGHT: every number table in ops/research/DAMAGE_AFTER_MAP_S438.md comes from here.

Stdlib only, deterministic (fixed seeds), prints markdown, and ASSERTS the map's own caps and rules.
Run:  python tools/damage_after_numbers.py
Nothing here is game code: it is the design's arithmetic. The game's pure module (PlaceCare.gd) copies the
constants block and its unit test checks the same rows.
Round 2: per-place care with four answers (Train / Protect / Spare / Rest), worked days heal at half, the opponent's body
share and the Elbows-in plan line in the bout model, a carried place's round cap, a medical fail costs its remaining
injury days, the physio session adds +0.5 (clinic slots), standing orders, situation tables, ceil days, T8 re-checked.
"""
import math
import random
import sys

ASSERTS = 0
SOFT = '--soft' in sys.argv   # explore: print failed asserts and go on


def check(cond, what):
    global ASSERTS
    ASSERTS += 1
    if not cond:
        print("ASSERT FAILED: " + what)
        if not SOFT:
            sys.exit(1)


# ---------------------------------------------------------------- constants (TUNE ranges in the map, section 6)
FINE_AT, SORE_AT, HURT_AT = 90.0, 56.0, 36.0     # 90-100 fine, 56-89 sore, 36-55 hurt, 0-35 injured (settled 55/35)
FACE_MED = 65.0          # the weigh-in doctor fails an eye or the nose under 65 (visibly swollen); ribs only when injured
PLACES = ["left_eye", "right_eye", "nose", "left_ribs", "right_ribs"]   # head: StandDown, no care choice
KIND = {"left_eye": "eye", "right_eye": "eye", "nose": "nose", "left_ribs": "ribs", "right_ribs": "ribs"}
RATE = {"eye": 2.0, "nose": 2.4, "ribs": 1.4}
LIGHT = {"eye": 1.6, "nose": 1.3, "ribs": 1.4}
SERIOUS = {"eye": 0.75, "nose": 0.5, "ribs": 0.4}
NAMES = {"eye": ("Swollen eye", "Cut eye"), "nose": ("Bloodied nose", "Broken nose"), "ribs": ("Bruised ribs", "Cracked rib")}
REAL_DAYS = {("eye", "light"): (5, 10), ("eye", "serious"): (14, 21), ("nose", "light"): (5, 10),
             ("nose", "serious"): (21, 35), ("ribs", "light"): (10, 21), ("ribs", "serious"): (42, 56)}
SERIOUS_CHANCE = {"critical": 0.30, "doctor": 0.70}
REST_MULT = 1.5
MULT_CAP = 2.0
PHYSIO_HIRED = 1.0 / 0.75   # built: StaffRoles PHYSIO_DAYS 0.75
GYM_PLAN = 1.11             # built S409
SESSION_ADD = 0.5           # one outside physio session ($60): +0.5 on one place's rate for 7 days, ON TOP of the cap
SESSION_PRICE = 50.0
CLINIC_SLOTS = 2            # the clinic sees the club twice a week: two sessions shared by every boxer
WORKED_HEAL = 0.4           # a sore or hurt place heals at 40% on a day a session works it (was 0)
PROTECT_HEAL = 0.75         # ... and at 75% on a day it is worked under Protect
WEEK_BASE = {0: ["pads"], 1: ["bag"], 2: ["pads"], 3: ["spar"], 4: ["pads"], 5: ["bag"], 6: []}
WEEK_FIGHT = {0: ["pads"], 1: ["bag"], 2: ["pads"], 3: [], 4: [], 5: [], 6: []}
LOADS = {"eye": {"spar"}, "nose": {"spar"}, "ribs": {"spar", "pads", "bag"}}
GAIN = {"bag": 1.0, "pads": 1.5, "spar": 1.5}
WEEK_UNITS = 12.0
SPARE_KEEP = {"bag": 0.7, "pads": 0.7, "spar": 0.3}   # roadwork, shadow and footwork, technical bag rounds
PROTECT_KEEP = 0.85         # Protect: pads to the head mitts, bag to roadwork-and-shadow half, sparring in the body protector
PROTECT_KNOCK = 0.25        # knock odds x0.25 under Protect (needs the $75 body protector, Club > Money, bought once)
BODY_SPAR_KEEP = 0.6        # a sore face spars body-only (the coach's fixed rule, no card): keeps 60% of sparring
REST_KEEP = 0.25
KNOCK = {"sore": {"spar": 0.02, "pads": 0.005, "bag": 0.005}, "hurt": {"spar": 0.08, "pads": 0.02, "bag": 0.02}}
KNOCK_DROP = 25.0
DAY_UNITS = WEEK_UNITS / 7.0
HEADROOM = 0.8              # a typical stat's headroom factor: lost gain units -> stat points (pace 1.0 per focused week)
DOLLARS_PER_DAY = 50.0
INJURY_DAY = 1.0
WIN_COST = 0.04
DELAY_PER_DAY = 0.3
PULL_OUT = 300.0
BOUT_VALUE = 6.0
MOVE_YES = 0.6
MOVE_DAYS = 14
OPP_GAIN = 1.0
GOAL = {"none": 0.6, "on track": 1.0, "at risk": 1.6}   # what a training day is worth: her goal chip
GOAL_W = [0.3, 0.4, 0.3]
NEXT_BOUT_W = 0.5           # no bout booked: the place is priced at half a bout vs a mixed opponent at day 14
OVERRULE = 1.0              # overruling her wish: morale -5 (built), counted as one day-equivalent
WISH = {"fight": 0.30, "rest": 0.20, "none": 0.50}   # Heart 65+ wants to fight; low Composure wants rest
BOXERS, BOUT_GAP_DAYS = 3, 18
SHOW_GAP = 1.0              # the card opens only when the worst answer costs a day-equivalent more than the best
CONTESTED = 0.70            # a situation is the player's only when no answer is best in more than 70% of its cases
MOVE_RISK = 0.15            # Fight prep opens Keep / Ask to move / Pull out when the night's risk is 1 in 5+ (or a medical fail)
MOVE_ASK = 1.5
LOOK_PRICE = 60.0
LOOK_RIGHT = {"nose": 0.75, "ribs": 0.6}
XRAY_PRICE = 250.0
XRAY_RIGHT = {"eye": 1.0, "nose": 1.0, "ribs": 0.9}
# Bout model (the fight half's interface). OPP = the share of her landed punches that go to the body.
OPP = {"jabber": 0.10, "mixed": 0.22, "body": 0.45}
OPP_WORD = {"jabber": "head hunter", "mixed": "mixed", "body": "body puncher"}
FACE_HIT, HEAD_HIT, RIB_HIT, BIG_SHARE, BIG_MULT = 1.1, 0.55, 3.0, 0.15, 2.0
CAP_EXCHANGE, CAP_ROUND, GIVE_BACK = 10.0, 25.0, 0.15
CARRIED_CAP_ROUND = 15.0    # a place that STARTS low loses less a round: 25 from 100, 15 from 60 (she guards it, the corner greases it)
AIM_SHARE = 0.20            # Aim the hurt place (plan line): 20% of face punches go to it first
ELBOWS_MOVE = 0.3           # Elbows in from round 1 (plan line): 3 in 10 body punches go to the head instead
ELBOWS_COST = 1.5           # ... and her own body work drops: about 3 in 100 less chance to win (fight half to measure)
CUT_AT = 35.0
RIB_MORNING = 0.10          # ribs get back 10% of what THIS bout took
EYE_MORNING = 0.25          # an eye loses a further 25% of what THIS bout took
RIB_CRACK = 0.10
HEAD_HAND_PER_100 = 6.0 * (37 + 18) / 100.0


def carried_cap(start):
    return max(CARRIED_CAP_ROUND, min(CAP_ROUND, CARRIED_CAP_ROUND + (start - 60.0) / 4.0))


def state(v, flagged=False):
    if flagged and v < SORE_AT:
        return "injured"
    if v >= FINE_AT:
        return "fine"
    if v >= SORE_AT:
        return "sore"
    if v >= HURT_AT:
        return "hurt"
    return "injured"


def rate(kind, sev, mult, add=0.0):
    r = RATE[kind] * (LIGHT[kind] if sev == "light" else SERIOUS[kind] if sev == "serious" else 1.0)
    return r * (min(mult, MULT_CAP) + add)


def days_to(v, target, kind, sev="", mult=1.0):
    """Whole days until the place first reads `target` (ceil: the date shown is the first day it is true)."""
    return max(0, math.ceil((target - v) / rate(kind, sev, mult) - 1e-9))


def risk_words(p):
    for lim, w in ((0.07, "1 in 20"), (0.15, "1 in 10"), (0.25, "1 in 5"), (0.40, "1 in 3"), (0.60, "1 in 2"),
                   (0.85, "3 in 4")):
        if p < lim:
            return w
    return "9 in 10"


# ---------------------------------------------------------------- 1. the bout
def bout(rng, landed, opp, start=None, elbows=False, aim=None):
    """One 3x3 amateur bout. `start` = places carried in under 100; `aim` = a face place the other corner aims (60%
    of face punches). Returns (places, cuts, worst exchange loss, worst round loss)."""
    body_share = OPP[opp] * (1.0 - (ELBOWS_MOVE if elbows else 0.0))
    v = {p: 100.0 for p in PLACES + ["head"]}
    v.update(start or {})
    v0 = dict(v)
    worst_ex = worst_rd = 0.0
    per_ex = [0] * 18
    for _ in range(landed):
        per_ex[rng.randrange(18)] += 1
    for rnd in range(3):
        lost_rd = {p: 0.0 for p in v}
        for ex in range(rnd * 6, rnd * 6 + 6):
            lost_ex = {p: 0.0 for p in v}
            for _ in range(per_ex[ex]):
                big = BIG_MULT if rng.random() < BIG_SHARE else 1.0
                if rng.random() < body_share:
                    p = "right_ribs" if rng.random() < 0.6 else "left_ribs"   # the lead hook finds her liver side
                    hits = [(p, RIB_HIT * big)]
                else:
                    hook = 1.5 if rng.random() < 0.4 else 1.0
                    if aim and rng.random() < AIM_SHARE:
                        f = aim
                    else:
                        f = "nose" if rng.random() < 0.45 else ("right_eye" if rng.random() < 0.65 else "left_eye")
                    hits = [(f, FACE_HIT * hook * big), ("head", HEAD_HIT * big)]
                for p, d in hits:
                    cap_rd = carried_cap(v0[p])
                    d = max(0.0, min(d, CAP_EXCHANGE - lost_ex[p], cap_rd - lost_rd[p]))
                    lost_ex[p] += d
                    lost_rd[p] += d
                    v[p] = max(0.0, v[p] - d)
            worst_ex = max(worst_ex, max(lost_ex.values()))
        worst_rd = max(worst_rd, max(lost_rd.values()))
        if rnd < 2:
            for p in ("left_ribs", "right_ribs"):
                v[p] = min(100.0, v[p] + GIVE_BACK * lost_rd[p])
    cuts = {p: v[p] <= CUT_AT for p in ("left_eye", "right_eye", "nose")}
    return v, v0, cuts, worst_ex, worst_rd


def after_bell(rng, v, v0, cuts):
    out = {}
    for p in PLACES:
        kind = KIND[p]
        x = v[p]
        took = max(0.0, v0[p] - x)
        if kind == "ribs":
            x = min(100.0, x + RIB_MORNING * took)
        elif kind == "eye":
            x = max(0.0, x - EYE_MORNING * took)
        s = state(x)
        if kind == "ribs" and s == "hurt" and rng.random() < RIB_CRACK * (SORE_AT - x) / 20.0:
            x, s = min(x, 30.0), "injured"
        sev = ""
        if s == "injured":
            band = "doctor" if x <= 15 else "critical"
            serious = (kind == "eye" and cuts.get(p)) or rng.random() < SERIOUS_CHANCE[band]
            sev = "serious" if serious else "light"
        out[p] = {"v": x, "bell": v[p], "state": s, "sev": sev}
    return out


def draw_bout(rng):
    level = rng.choices([36, 63, 90], weights=[0.35, 0.40, 0.25])[0]
    landed = max(10, int(round(level * rng.uniform(0.85, 1.15))))
    opp = rng.choices(["jabber", "mixed", "body"], weights=[0.35, 0.40, 0.25])[0]
    return level, landed, opp


REP = {"eye": "right_eye", "nose": "nose", "ribs": "right_ribs"}
STARTS = [100, 90, 80, 70, 60, 50, 40]
_ST = {}


def start_table():
    """(kind, opp, elbows, start) -> (injured share, mean injury days), the bout model played from that start."""
    if _ST:
        return _ST
    for kind, place in REP.items():
        for opp in OPP:
            for elbows in (False, True):
                for st in STARTS:
                    rng = random.Random(1000 + st)
                    days, inj = 0.0, 0
                    for _ in range(600):
                        _, landed, _ = draw_bout(rng)
                        v, v0, cuts, _, _ = bout(rng, landed, opp, {place: float(st)}, elbows)
                        a = after_bell(rng, v, v0, cuts)[place]
                        if a["state"] == "injured":
                            inj += 1
                            days += days_to(a["v"], SORE_AT, kind, a["sev"])
                    _ST[(kind, opp, elbows, st)] = (inj / 600.0, days / 600.0)
    return _ST


def interp(kind, opp, elbows, v, col):
    t = start_table()
    v = max(40.0, min(100.0, v))
    hi = min(x for x in STARTS if x >= v)
    lo = max(x for x in STARTS if x <= v)
    a, b = t[(kind, opp, elbows, lo)][col], t[(kind, opp, elbows, hi)][col]
    return a if hi == lo else a + (b - a) * (v - lo) / (hi - lo)


def start_cost(kind, v, opp, elbows=False):
    base = start_table()[(kind, opp, False, 100)][1]
    return (interp(kind, opp, elbows, v, 1) - base) * INJURY_DAY + max(0.0, FINE_AT - v) * WIN_COST


def elbows_face_cost(opp):
    """Elbows in moves body punches to the head: the face places (at 100) pay for it."""
    t = start_table()
    return sum(t[(k, opp, True, 100)][1] - t[(k, opp, False, 100)][1] for k in ("eye", "eye", "nose"))


def sample_bouts(n, seed):
    rng = random.Random(seed)
    rows = []
    for _ in range(n):
        level, landed, opp = draw_bout(rng)
        v, v0, cuts, wex, wrd = bout(rng, landed, opp)
        rows.append((level, opp, v, cuts, wex, wrd, after_bell(rng, v, v0, cuts)))
    return rows


# ---------------------------------------------------------------- 2. the weeks after, day by day, PER PLACE
def carried_of(after):
    return [{"place": p, "kind": KIND[p], "v": after[p]["v"], "v0": after[p]["v"], "sev": after[p]["sev"],
             "flag": after[p]["state"] == "injured"}
            for p in PLACES if after[p]["state"] != "fine"]


def rib_places(carried):
    return [c["place"] for c in carried if c["kind"] == "ribs"]


def plans_for(carried):
    """Every care plan the card offers: Rest (whole fighter), or one of Train / Protect / Spare per carried rib place
    (an injured rib is always spared). Faces follow the coach's fixed rule (body-only sparring), no card row."""
    ribs = [c for c in carried if c["kind"] == "ribs"]
    plans = [{"rest": True}]
    combos = [{}]
    for c in ribs:
        opts = ["spare"] if c["flag"] else ["train", "protect", "spare"]
        combos = [dict(x, **{c["place"]: o}) for x in combos for o in opts]
    for x in combos:
        plans.append({"rest": False, "per": x})
    return plans


def plan_name(plan, carried):
    if plan["rest"]:
        return "rest"
    ribs = [c for c in carried if c["kind"] == "ribs"]
    if not ribs:
        return "train"
    worst = min(ribs, key=lambda c: c["v"] - (100 if c["flag"] else 0))
    return plan["per"][worst["place"]]


def run_weeks(rng, carried, plan, days, bout_day, session_place=None, hired=False):
    """Returns (places after, gain units lost, knocks)."""
    pl = [dict(c) for c in carried]
    lost, knocks = 0.0, 0
    for d in range(days):
        fight_week = bout_day is not None and bout_day - d <= 7
        sessions = (WEEK_FIGHT if fight_week else WEEK_BASE)[d % 7]
        resting = plan["rest"] and d < 7
        per = plan.get("per", {})
        spared, protected = set(), set()
        face_sore = any(c["kind"] != "ribs" and state(c["v"]) != "fine" for c in pl)
        if resting:
            lost += (sum(GAIN[s] for s in sessions) + 4.0 / 7.0) * (1.0 - REST_KEEP)
            spared = set(sessions)
        else:
            for c in pl:
                if c["kind"] != "ribs" or state(c["v"], c["flag"]) == "fine":
                    continue
                o = "spare" if (c["flag"] or plan["rest"]) else per.get(c["place"], "train")
                if o == "spare":
                    spared |= set(sessions) & LOADS["ribs"]
                elif o == "protect":
                    protected |= set(sessions) & LOADS["ribs"]
            protected -= spared
            for s in sessions:
                if s in spared:
                    lost += GAIN[s] * (1.0 - SPARE_KEEP[s])
                else:
                    keep = PROTECT_KEEP if s in protected else 1.0
                    if s == "spar" and face_sore:
                        keep *= BODY_SPAR_KEEP
                    lost += GAIN[s] * (1.0 - keep)
        for c in pl:
            mult = (PHYSIO_HIRED if hired else 1.0) * (REST_MULT if resting else 1.0)
            add = SESSION_ADD if (session_place == c["place"] and d < 7) else 0.0
            loads = LOADS[c["kind"]] if c["kind"] == "ribs" else (set() if face_sore else LOADS[c["kind"]])
            worked = (set(sessions) & loads) - spared
            st = state(c["v"], c["flag"])
            heal = 1.0
            if worked and st in KNOCK:
                heal = PROTECT_HEAL if worked <= protected else WORKED_HEAL
                for s in worked:
                    k = KNOCK[st][s] * (PROTECT_KNOCK if s in protected else 1.0)
                    if rng.random() < k:
                        knocks += 1
                        c["v"] = max(0.0, c["v"] - KNOCK_DROP)
                        if c["v"] < SORE_AT:
                            c["flag"], c["sev"] = True, c["sev"] or "light"
            c["v"] = min(100.0, c["v"] + heal * rate(c["kind"], c["sev"] if c["flag"] else "", mult, add))
            if c["flag"] and c["v"] >= SORE_AT:
                c["flag"], c["sev"] = False, ""
    return pl, lost, knocks


def medical_fails(c):
    return c["flag"] or (c["kind"] in ("eye", "nose") and c["v"] < FACE_MED)


def remaining_days(c):
    """A failed medical: the days still to come until she could box (injured -> 56, a swollen face -> 65)."""
    if c["flag"]:
        return days_to(c["v"], SORE_AT, c["kind"], c["sev"]) + 0.0
    if c["kind"] in ("eye", "nose") and c["v"] < FACE_MED:
        return days_to(c["v"], FACE_MED, c["kind"]) + 0.0
    return 0.0


def places_cost(pl, bout_on, opp, elbows_ok=True):
    if bout_on:
        if any(medical_fails(c) for c in pl):
            return PULL_OUT / DOLLARS_PER_DAY + BOUT_VALUE + max(remaining_days(c) for c in pl) * INJURY_DAY
        plain = sum(start_cost(c["kind"], c["v"], opp) for c in pl)
        if not elbows_ok or not any(c["kind"] == "ribs" for c in pl):
            return plain
        elb = sum(start_cost(c["kind"], c["v"], opp, c["kind"] == "ribs") for c in pl) + elbows_face_cost(opp) + ELBOWS_COST
        return min(plain, elb)
    return sum(NEXT_BOUT_W * start_cost(c["kind"], c["v"], "mixed") + remaining_days(c) * INJURY_DAY for c in pl)


def wish_cost(name, wish):
    if wish == "fight" and name in ("spare", "rest"):
        return OVERRULE
    if wish == "rest" and name in ("train", "protect"):
        return OVERRULE
    return 0.0


def care_cost(carried, plan, bout_in, opp, wish="none", session_place=None, runs=40, seed=1, hired=False, goal="on track"):
    rng = random.Random(seed)
    horizon = bout_in if bout_in else 14
    tot = 0.0
    for _ in range(runs):
        pl, lost, _ = run_weeks(rng, carried, plan, horizon, bout_in, session_place, hired)
        tot += lost / DAY_UNITS * GOAL[goal] + (SESSION_PRICE / DOLLARS_PER_DAY if session_place else 0.0) + places_cost(pl, bout_in, opp)
    return tot / runs + wish_cost(plan_name(plan, carried), wish)


def best_by_name(carried, bout_in, opp, wish, seed, runs=40, goal="on track"):
    """Cheapest plan for each answer the worst rib place can get (train / protect / spare / rest)."""
    out = {}
    for plan in plans_for(carried):
        nm = plan_name(plan, carried)
        c = care_cost(carried, plan, bout_in, opp, wish, None, runs, seed, False, goal)
        if nm not in out or c < out[nm][0]:
            out[nm] = (c, plan)
    return out


def forecast(carried, days):
    plan = {"rest": False, "per": {p: "spare" for p in rib_places(carried)}}
    pl, _, _ = run_weeks(random.Random(0), carried, plan, days, days)
    return pl


def worst_rib(carried):
    ribs = [c for c in carried if c["kind"] == "ribs"]
    return min(ribs, key=lambda c: c["v"] - (100 if c["flag"] else 0)) if ribs else None


def md(headers, rows):
    out = ["| " + " | ".join(headers) + " |", "|" + "---|" * len(headers)]
    for r in rows:
        out.append("| " + " | ".join(str(x) for x in r) + " |")
    return "\n".join(out)


def gap_band(bout_in):
    return "none" if bout_in is None else ("7-10" if bout_in <= 10 else str(bout_in))


def main():
    print("# damage_after_numbers.py output\n")
    # ------------------------------------------------ T1 ladder
    print("## T1 The ladder (one word per level, on the place's number)")
    print(md(["Word", "Place number", "After the last bell"], [
        ["fine", "%d-100" % FINE_AT, "nothing to decide (fine is not zero risk: T3b start 90)"],
        ["sore", "%d-%d" % (SORE_AT, FINE_AT - 1), "heals by itself (at 40% on a day a session works it); can be knocked"],
        ["hurt", "%d-%d" % (HURT_AT, SORE_AT - 1), "the same, knocked four times as easily"],
        ["injured", "0-%d" % (HURT_AT - 1), "a named injury, light or serious; fails the medical until back at %d" % SORE_AT]]))
    print("The weigh-in doctor also fails an eye or the nose under %d (visibly swollen)." % FACE_MED)
    check(FINE_AT > SORE_AT > HURT_AT, "ladder ordered")
    check(SORE_AT - 1 == 55 and HURT_AT - 1 == 35, "the ladder keeps the settled 55/35 bands")
    # ------------------------------------------------ T2 healing
    print("\n## T2 Healing (whole days, rounded UP: the date shown is the first day the place reads the word)")
    rows = []
    for kind in ("eye", "nose", "ribs"):
        l25 = days_to(25, SORE_AT, kind, "light")
        s25 = days_to(25, SORE_AT, kind, "serious")
        rows.append([kind, "%.1f" % RATE[kind], days_to(75, FINE_AT, kind), days_to(60, FINE_AT, kind),
                     "%s %d (real %d-%d)" % (NAMES[kind][0], l25, *REAL_DAYS[(kind, "light")]),
                     "%s %d (real %d-%d)" % (NAMES[kind][1], s25, *REAL_DAYS[(kind, "serious")])])
        for sev, dd in (("light", l25), ("serious", s25)):
            lo, hi = REAL_DAYS[(kind, sev)]
            check(lo <= dd <= hi, "%s %s from 25 heals in the real range (%d)" % (kind, sev, dd))
        v = 75.0
        for day in range(1, 40):
            v += rate(kind, "", 1.0)
            if v >= FINE_AT:
                check(day == days_to(75, FINE_AT, kind), "%s: the date shown is the first fine day" % kind)
                break
    print(md(["Place", "Points a day", "Sore 75 -> fine, days", "Sore 60 -> fine, days", "Light injury 25 -> fit (56)",
              "Serious injury 25 -> fit (56)"], rows))
    print("Multipliers: physio hired x%.2f, gym plan x%.2f, a rest week x%.1f, together capped at x%.1f; an outside physio "
          "session then ADDS +%.1f for 7 days (not capped). A sore or hurt place heals at %d%% on a day a session works it."
          % (PHYSIO_HIRED, GYM_PLAN, REST_MULT, MULT_CAP, SESSION_ADD, 100 * WORKED_HEAL))
    # ------------------------------------------------ T3 bouts
    bouts = sample_bouts(4000, 438)
    print("\n## T3 What a 3x3 amateur bout leaves (4,000 bouts; landed on her 36/63/90 at 35/40/25%%; opponent head hunter / "
          "mixed / body puncher at 35/40/25%%, body share %d / %d / %d%%)" % tuple(round(100 * OPP[o]) for o in OPP))
    check(all(b[4] <= CAP_EXCHANGE + 1e-9 for b in bouts), "no place loses more than 10 in an exchange")
    check(all(b[5] <= CAP_ROUND + 1e-9 for b in bouts), "no place loses more than 25 in a round")
    rows = []
    inj_rate = 0.0
    for lvl in (36, 63, 90, "all"):
        sel = [b for b in bouts if lvl == "all" or b[0] == lvl]
        n = len(sel)
        hurt = sum(1 for b in sel if any(b[6][p]["state"] in ("hurt", "injured") for p in PLACES))
        inj = sum(1 for b in sel if any(b[6][p]["state"] == "injured" for p in PLACES))
        rib = sum(1 for b in sel if min(b[6]["left_ribs"]["v"], b[6]["right_ribs"]["v"]) < FINE_AT)
        face = sum(1 for b in sel if min(b[6]["left_eye"]["v"], b[6]["right_eye"]["v"], b[6]["nose"]["v"]) < FINE_AT)
        rows.append([lvl, n, "%d%%" % round(100 * rib / n), "%d%%" % round(100 * face / n), "%d%%" % round(100 * hurt / n),
                     "%.1f" % (100.0 * inj / n)])
        if lvl == "all":
            check(0.015 <= inj / n <= 0.04, "place injuries 1.5-4 per 100 boxer-bouts (%.3f)" % (inj / n))
            tot = 100.0 * inj / n + HEAD_HAND_PER_100
            check(4.0 <= tot <= 8.0, "all bout injuries 4-8 per 100 (real ~6, Alevras 2022) (%.1f)" % tot)
            inj_rate = inj / n
    by_place = {}
    for b in bouts:
        for p in PLACES:
            if b[6][p]["state"] == "injured":
                by_place[KIND[p]] = by_place.get(KIND[p], 0) + 1
    print("Injuries by place per 100 bouts: " + ", ".join("%s %.1f" % (k, 100.0 * by_place.get(k, 0) / len(bouts))
                                                         for k in ("eye", "nose", "ribs")) +
          "; head knock + hand (InjuryRoll, not places) %.1f." % HEAD_HAND_PER_100)
    for k in ("eye", "nose", "ribs"):
        check(by_place.get(k, 0) > 0, "%s injuries happen" % k)
    print(md(["Landed on her", "Bouts", "Ribs sore or worse", "Face sore or worse", "A place hurt or worse",
              "Injured per 100"], rows))
    # ------------------------------------------------ T3b
    print("\n## T3b The price of a carried place: the next bout played from that start (600 bouts a cell; injured at the "
          "last bell / mean injury days). A place that starts low loses less a round: %d from 100, %d from 60." % (CAP_ROUND, CARRIED_CAP_ROUND))
    t = start_table()
    rows = []
    for kind, opp, elb, label in (("eye", "mixed", False, "eye (vs mixed)"), ("nose", "mixed", False, "nose (vs mixed)"),
                                  ("ribs", "jabber", False, "ribs vs a head hunter"), ("ribs", "mixed", False, "ribs vs mixed"),
                                  ("ribs", "body", False, "ribs vs a body puncher"),
                                  ("ribs", "body", True, "ribs vs a body puncher, Elbows in")):
        rows.append([label] + ["%d%% / %.1f" % (round(100 * t[(kind, opp, elb, st)][0]), t[(kind, opp, elb, st)][1])
                               for st in STARTS])
        for x, y in zip(STARTS, STARTS[1:]):
            check(t[(kind, opp, elb, y)][1] >= t[(kind, opp, elb, x)][1] - 0.15, "%s %s: lower start never cheaper" % (kind, opp))
    print(md(["Place"] + ["start %d" % st for st in STARTS], rows))
    print("Elbows in also costs the face: +%.1f injury days a bout across eyes and nose vs a body puncher (+%.1f vs mixed)."
          % (elbows_face_cost("body"), elbows_face_cost("mixed")))
    e70 = t[("eye", "mixed", False, 70)][0]
    check(0.15 <= e70 <= 0.45, "an eye at 70 (passes the medical) is a real risk, not a certainty (%.2f)" % e70)
    r70 = [t[("ribs", o, False, 70)][0] for o in ("jabber", "mixed", "body")]
    check(r70[2] >= 1.6 * r70[0], "the opponent's body share changes the rib price (%s)" % r70)
    check(t[("ribs", "body", True, 60)][0] < t[("ribs", "body", False, 60)][0], "Elbows in protects a carried rib")
    print("In words on screen (rib start: head hunter / mixed / body puncher): " + "; ".join(
        "%d: %s / %s / %s" % ((st,) + tuple(risk_words(t[("ribs", o, False, st)][0]) for o in ("jabber", "mixed", "body")))
        for st in (90, 80, 70, 60)) + ".")
    # ------------------------------------------------ T4 worked example
    print("\n## T4 Worked example: one bout, one recovery, two opponents")
    ex = next(b for b in bouts if b[0] == 63 and b[6]["right_ribs"]["state"] == "hurt" and b[6]["left_ribs"]["state"] == "sore")
    print("Morning after: " + ", ".join("%s %d %s" % (p.replace("_", " "), round(ex[6][p]["v"]), ex[6][p]["state"])
                                        for p in PLACES) + ". The next show is in 14 days (a BASE week, then the fight week).")
    carried = carried_of(ex[6])
    wr = worst_rib(carried)["place"]
    rows, t4 = [], {}
    for plan in plans_for(carried):
        nm = plan_name(plan, carried)
        other = [v for k, v in plan.get("per", {}).items() if k != wr]
        if other and other[0] != nm:
            continue       # T4 shows the same answer on both ribs
        for sess in (None, wr):
            r = random.Random(5)
            ends, knocks, lost = {}, 0, 0.0
            for _ in range(2000):
                pl, l, k = run_weeks(r, carried, plan, 14, 14, sess)
                for c in pl:
                    ends[c["place"]] = ends.get(c["place"], 0.0) + c["v"] / 2000
                knocks += 1 if k else 0
                lost += l / 2000
            cb = care_cost(carried, plan, 14, "body", "none", sess, runs=600, seed=5)
            cj = care_cost(carried, plan, 14, "jabber", "none", sess, runs=600, seed=5)
            t4[(nm, sess)] = (cb, cj)
            rr = ends[wr]
            rows.append([nm + (" + physio session ($%d)" % SESSION_PRICE if sess else ""),
                         ", ".join("%s %d" % (p.replace("_", " "), round(ends[p])) for p in ("left_ribs", "right_ribs")),
                         "%s / %s" % (risk_words(interp("ribs", "jabber", False, rr, 0)),
                                      risk_words(interp("ribs", "body", False, rr, 0))),
                         "%d in 100" % round(100 * knocks / 2000),
                         "%.1f" % (lost / WEEK_UNITS * HEADROOM), "%.1f" % cb, "%.1f" % cj])
    print(md(["Her two weeks", "Ribs on fight night (mean)", "Right ribs injured on the night: head hunter / body puncher",
              "A training knock", "Focus stat points lost", "Cost vs body puncher", "Cost vs head hunter"], rows))
    bb = min(t4, key=lambda k: t4[k][0])
    bj = min(t4, key=lambda k: t4[k][1])
    gb_ = sorted(v[0] for v in t4.values())
    gj_ = sorted(v[1] for v in t4.values())
    print("Best vs a body puncher: %s%s (next %.1f higher); vs a head hunter: %s%s (next %.1f higher)."
          % (bb[0], " + session" if bb[1] else "", gb_[1] - gb_[0], bj[0], " + session" if bj[1] else "", gj_[1] - gj_[0]))
    check(bb[0] != bj[0], "T4: the opponent flips the answer")
    # ------------------------------------------------ T5 the care card
    rng = random.Random(77)
    dec = [b for b in bouts if any(b[6][p]["state"] != "fine" for p in ("left_ribs", "right_ribs"))]
    face_only = sum(1 for b in bouts if not any(b[6][p]["state"] != "fine" for p in ("left_ribs", "right_ribs"))
                    and any(b[6][p]["state"] != "fine" for p in PLACES)) / len(bouts)
    cases = []
    for i, b in enumerate(dec[:110]):
        carried = carried_of(b[6])
        wish = rng.choices(list(WISH), weights=list(WISH.values()))[0]
        goal = rng.choices(list(GOAL), weights=GOAL_W)[0]
        for bout_in in (None, 7, 10, 14, 21):
            for opp in (("mixed",) if bout_in is None else ("jabber", "mixed", "body")):
                costs = best_by_name(carried, bout_in, opp, wish, seed=i, runs=24, goal=goal)
                vals = sorted(x[0] for x in costs.values())
                best = min(costs, key=lambda k: costs[k][0])
                wrb = worst_rib(carried)
                key = (state(wrb["v"], wrb["flag"]), gap_band(bout_in), opp)
                cases.append({"b": b, "carried": carried, "bout_in": bout_in, "opp": opp, "wish": wish, "costs": costs,
                              "best": best, "gap": vals[-1] - vals[0], "key": key, "i": i,
                              "goal": goal})
    cells = {}
    for c in cases:
        if c["gap"] >= SHOW_GAP:
            cells.setdefault(c["key"], {}).setdefault(c["best"], 0)
            cells[c["key"]][c["best"]] += 1
    contested = {k for k, d in cells.items() if max(d.values()) / sum(d.values()) <= CONTESTED}
    order = {k: max(d, key=d.get) for k, d in cells.items()}
    card = [c for c in cases if c["gap"] >= SHOW_GAP and c["key"] in contested]
    ordered = [c for c in cases if c["gap"] >= SHOW_GAP and c["key"] not in contested]
    print("\n## T5 The Monday care card (per rib place: Train / Protect / Spare, or Rest the week)")
    print("%d situations from %d bouts that leave a rib not fine (x the next bout none / 7 / 10 / 14 / 21 days x the "
          "opponent x her wish). Face-only carries (%d%% of bouts) open no card: the face clears alone and spars body-only."
          % (len(cases), len(dec[:110]), round(100 * face_only)))
    print("Gap under %.0f day-equivalent: the coach picks (%d). A situation (rib word x days to the bout x opponent) where "
          "one answer is best in over %d%% of its cases is a STANDING ORDER, pre-filled, editable (%d). The card opens "
          "for the rest (%d)." % (SHOW_GAP, sum(1 for c in cases if c["gap"] < SHOW_GAP), round(100 * CONTESTED), len(ordered), len(card)))
    wins, regret = {}, {}
    for c in card:
        wins[c["best"]] = wins.get(c["best"], 0) + 1
        for o, x in c["costs"].items():
            if o != c["best"]:
                regret.setdefault(o, []).append(x[0] - c["costs"][c["best"]][0])
    rows = []
    for o in ("train", "protect", "spare", "rest"):
        share = wins.get(o, 0) / max(1, len(card))
        rg = regret.get(o, [0.0])
        rows.append([o.capitalize(), "%d%%" % round(100 * share), "%.1f" % (sum(rg) / len(rg))])
        check(share <= 0.70, "card answer %s not best in more than 70%% of card cases (%.2f)" % (o, share))
        check(share >= 0.08, "card answer %s best in at least 8%% of card cases (%.2f)" % (o, share))
    print(md(["Answer (on the worst rib)", "Least cost in (card cases)", "Mean extra cost when not the best"], rows))
    print("\n### T5b By situation the player can see (cases where the best two differ by a day+: usual best, its share, n)")
    srows = []
    for word in ("sore", "hurt", "injured"):
        for gb in ("none", "7-10", "14", "21"):
            cellrow = []
            for opp in ("jabber", "mixed", "body"):
                d = cells.get((word, gb, opp))
                if not d:
                    cellrow.append("-")
                    continue
                n = sum(d.values())
                top = max(d, key=d.get)
                cellrow.append("%s %d%% (%d)%s" % (top, round(100 * d[top] / n), n, "" if (word, gb, opp) in contested else " ORDER"))
            if any(x != "-" for x in cellrow):
                srows.append([word, gb] + cellrow)
    print(md(["Worst rib", "Days to the bout", "vs head hunter (none: unknown)", "vs mixed", "vs body puncher"], srows))
    check(len(card) >= 0.25 * len(cases), "at least a quarter of situations reach the card (%d of %d)" % (len(card), len(cases)))
    pair = {}
    for c in cases:
        if c["bout_in"] is not None:
            pair.setdefault((c["i"], c["bout_in"]), {})[c["opp"]] = c["best"]
    pairs = [d for d in pair.values() if "jabber" in d and "body" in d]
    flip = sum(1 for d in pairs if d["jabber"] != d["body"]) / len(pairs)
    reg = [c["costs"][order[c["key"]]][0] - c["costs"][c["best"]][0] for c in ordered if order[c["key"]] in c["costs"]]
    print("Same fighter, same days to the bout: the best answer vs a head hunter differs from the best vs a body puncher in "
          "%d%% of %d cases. A standing order costs %.2f day-equivalents a time on average against the best answer "
          "(it is wrong in %d%% of its cases)." % (round(100 * flip), len(pairs), sum(reg) / len(reg),
                                                   round(100 * sum(1 for x in reg if x > 0.01) / len(reg))))
    check(flip >= 0.30, "the opponent changes the best care answer for the same fighter (%.2f)" % flip)
    # physio session
    ph_yes = ph_n = hired_rest = 0
    for c in card[:80]:
        plan = c["costs"][c["best"]][1]
        base = c["costs"][c["best"]][0]
        withs = care_cost(c["carried"], plan, c["bout_in"], c["opp"], c["wish"], worst_rib(c["carried"])["place"], 24, c["i"],
                          False, c["goal"])
        ph_n += 1
        ph_yes += 1 if withs < base else 0
    hr_n = min(40, len(card))
    for c in card[:40]:
        rp, wp = {"rest": True}, worst_rib(c["carried"])["place"]
        a = run_weeks(random.Random(3), c["carried"], rp, 5, None, None, True)[0]
        b2 = run_weeks(random.Random(3), c["carried"], rp, 5, None, wp, True)[0]
        va = next(x["v"] for x in a if x["place"] == wp)
        vb = next(x["v"] for x in b2 if x["place"] == wp)
        hired_rest += 1 if vb > va or va >= 100 else 0
    print("\nA physio session ($%d, +%.1f for 7 days) on the worst rib, on top of the best answer: worth it in %d%% of %d "
          "card cases. With the physio hired, under Rest, it still heals in %d of %d (the cap no longer eats it). "
          "%d sessions a week for the whole club." % (SESSION_PRICE, SESSION_ADD, round(100 * ph_yes / ph_n), ph_n, hired_rest, hr_n, CLINIC_SLOTS))
    check(0.15 <= ph_yes / ph_n <= 0.80, "the physio session is a real choice (%.2f)" % (ph_yes / ph_n))
    check(hired_rest == hr_n, "the session always heals, hired physio or not")
    # ------------------------------------------------ T6 the next bout
    print("\n## T6 The next bout: an offer (Accept / Pass) and a booked bout (Keep / Ask to move / Pull out)")
    acc, kmp = {}, {}
    after_no = {"keep": 0, "pull": 0}
    r6 = random.Random(66)
    for i, b in enumerate(dec[:90]):
        carried = carried_of(b[6])
        wish = r6.choices(list(WISH), weights=list(WISH.values()))[0]
        for bout_in in (7, 10, 14):
            fc = forecast(carried, bout_in)
            wrf = worst_rib(fc)
            if wrf is None or wrf["v"] >= FINE_AT:
                continue
            word = state(wrf["v"], wrf["flag"])
            later = min(x[0] for x in best_by_name(carried, bout_in + MOVE_DAYS, "mixed", "none", i, 16).values())
            pas = DELAY_PER_DAY * MOVE_DAYS + later
            pull = PULL_OUT / DOLLARS_PER_DAY + DELAY_PER_DAY * MOVE_DAYS + later
            keep_no = min(x[0] for x in best_by_name(carried, bout_in, "body", "none", i, 16).values())
            for opp in OPP:
                keep = min(x[0] for x in best_by_name(carried, bout_in, opp, "none", i, 16).values())
                acc.setdefault((word, opp), [0, 0])
                acc[(word, opp)][0] += 1 if keep < pas else 0
                acc[(word, opp)][1] += 1
                if interp("ribs", opp, False, wrf["v"], 0) >= MOVE_RISK or any(medical_fails(c) for c in fc):
                    # a NO: their corner hears; she now goes to the body
                    move = MOVE_ASK + MOVE_YES * (later + DELAY_PER_DAY * MOVE_DAYS + OPP_GAIN) + (1 - MOVE_YES) * min(keep_no, pull)
                    move += OVERRULE if wish == "fight" else 0.0      # Heart 65+: she wants this bout
                    keep += OVERRULE if wish == "rest" else 0.0       # low Composure: she wants it moved
                    kmp.setdefault(opp, {"keep": 0, "move": 0})
                    kmp[opp]["keep" if keep <= move else "move"] += 1
                    after_no["keep" if keep_no <= pull else "pull"] += 1
    rows = []
    for word in ("sore", "hurt"):
        for opp in OPP:
            a = acc.get((word, opp))
            if a and a[1]:
                rows.append(["worst rib %s, %s" % (word, OPP_WORD[opp]), "%d%% of %d" % (round(100 * a[0] / a[1]), a[1])])
    print(md(["Offer with a carried rib (forecast word)", "Accept is best in"], rows))
    for word in ("sore", "hurt"):
        sh = [acc[(word, o)][0] / acc[(word, o)][1] for o in OPP if acc.get((word, o)) and acc[(word, o)][1] >= 20]
        if len(sh) == 3:
            check(max(sh) - min(sh) >= 0.25, "the opponent moves Accept vs Pass for a %s rib (%s)" % (word, sh))
    tot_a = sum(a[0] for a in acc.values()) / sum(a[1] for a in acc.values())
    check(0.30 <= tot_a <= 0.70, "Accept vs Pass overall (%.2f)" % tot_a)
    n6 = sum(sum(d.values()) for d in kmp.values())
    rows = [["Keep vs %s" % OPP_WORD[o], "%d%% of %d" % (round(100 * kmp[o]["keep"] / sum(kmp[o].values())), sum(kmp[o].values()))]
            for o in OPP if o in kmp]
    rows += [["After a NO (she now goes to the body): keep", "%d%%" % round(100 * after_no["keep"] / n6)],
             ["After a NO: pull out ($300)", "%d%%" % round(100 * after_no["pull"] / n6)]]
    print(md(["Fight prep (opens at a night's risk of 1 in 5 or worse, or a medical fail)", "Best in"], rows))
    kshare = sum(d["keep"] for d in kmp.values()) / n6
    check(0.25 <= kshare <= 0.75, "Keep vs Ask to move overall (%.2f)" % kshare)
    for k in after_no:
        check(0.10 <= after_no[k] / n6 <= 0.90, "after a NO, %s is sometimes right (%.2f)" % (k, after_no[k] / n6))
    # T6b the opponent's carried place
    print("\n### T6b Her opponent carries a place too (seen on tape of her last bout): Aim it")
    rows = []
    for st in (85, 75, 65):
        r1, r2 = random.Random(9), random.Random(9)
        own = aim = 0
        for _ in range(1500):
            _, landed, _ = draw_bout(r1)
            v, v0, cuts, _, _ = bout(r1, landed, "mixed", {"right_eye": float(st)})
            own += 1 if after_bell(r1, v, v0, cuts)["right_eye"]["state"] == "injured" else 0
            _, landed, _ = draw_bout(r2)
            v, v0, cuts, _, _ = bout(r2, landed, "mixed", {"right_eye": float(st)}, aim="right_eye")
            aim += 1 if after_bell(r2, v, v0, cuts)["right_eye"]["state"] == "injured" else 0
        rows.append(["her right eye starts %d" % st, "%d in 100" % round(100 * own / 1500), "%d in 100" % round(100 * aim / 1500)])
        if st == 75:
            check(aim > own * 1.5, "aiming a carried eye matters")
    rb = t[("ribs", "body", False, 70)][0]
    rm = t[("ribs", "mixed", False, 70)][0]
    rows.append(["her ribs start 70: our Own game vs Aim Body (body share %d%% -> %d%%)" % (100 * OPP["mixed"], 100 * OPP["body"]),
                 "%d in 100" % round(100 * rm), "%d in 100" % round(100 * rb)])
    print(md(["The opponent", "Injured at the last bell, our own game", "Aim the place (plan line)"], rows))
    # ------------------------------------------------ T7 the check
    print("\n## T7 The check on an injured nose or rib, by the club's cash")
    ck = {}
    for kind in ("nose", "ribs"):
        for p_serious in (0.3, 0.5, 0.7):
            for booked in (None, 14, 21, 28, 35, 49):
                for dpd in (20.0, 50.0, 120.0):
                    fl = days_to(25, SORE_AT, kind, "light")
                    fs = days_to(25, SORE_AT, kind, "serious")

                    def cost_known(truth, said):
                        told = fl if said == "light" else fs
                        true = fl if truth == "light" else fs
                        c = DELAY_PER_DAY * max(0.0, told - true)
                        if booked is not None:
                            if told <= booked < true:
                                c += PULL_OUT / dpd + BOUT_VALUE + (true - booked) * INJURY_DAY
                            elif booked < told:
                                c += PULL_OUT / dpd
                        elif said == "light" and truth == "serious":
                            c += DELAY_PER_DAY * 10
                        return c
                    ps = p_serious
                    guess = (1 - ps) * cost_known("light", "serious") + ps * cost_known("serious", "serious")
                    lr = LOOK_RIGHT[kind]
                    look = LOOK_PRICE / dpd + sum(
                        pt * (lr * cost_known(tt, tt) + (1 - lr) * cost_known(tt, "serious" if tt == "light" else "light"))
                        for tt, pt in (("light", 1 - ps), ("serious", ps)))
                    xr = XRAY_RIGHT[kind]
                    xray = XRAY_PRICE / dpd + sum(
                        pt * (xr * cost_known(tt, tt) + (1 - xr) * cost_known(tt, "light")) for tt, pt in (("light", 1 - ps), ("serious", ps)))
                    best = min((guess, "guess"), (look, "look"), (xray, "xray"))[1]
                    ck.setdefault(dpd, {"guess": 0, "look": 0, "xray": 0})[best] += 1
    rows = []
    for dpd, label in ((20.0, "tight ($20 a day-equivalent)"), (50.0, "normal ($50)"), (120.0, "comfortable ($120)")):
        n = sum(ck[dpd].values())
        rows.append([label] + ["%d%%" % round(100 * ck[dpd][k] / n) for k in ("guess", "look", "xray")])
    print(md(["Club cash", "The coach's guess (free)", "Physio's look ($60)", "X-ray ($250)"], rows))
    allk = {k: sum(ck[d][k] for d in ck) for k in ("guess", "look", "xray")}
    n7 = sum(allk.values())
    for k in allk:
        check(0.10 <= allk[k] / n7 <= 0.70, "check %s is right in 10-70%% overall (%.2f)" % (k, allk[k] / n7))
    # ------------------------------------------------ T8 how often, Monday by Monday
    print("\n## T8 How often it meets the player in 26 weeks (each Monday re-checked from that day's places)")
    bouts26 = BOXERS * 26 * 7 / BOUT_GAP_DAYS
    r8 = random.Random(88)
    cards = orders = knocks = offers = prep = 0
    sample = bouts[:150]
    for i, b in enumerate(sample):
        carried = carried_of(b[6])
        if not rib_places(carried):
            continue
        fc = forecast(carried, 14)
        offers += 1 if worst_rib(fc) is not None and worst_rib(fc)["v"] < FINE_AT else 0
        bout_in = r8.choice([None, 7, 10, 14, 21])
        opp = r8.choices(list(OPP), weights=[0.35, 0.40, 0.25])[0] if bout_in else "mixed"
        wish = r8.choices(list(WISH), weights=list(WISH.values()))[0]
        goal = r8.choices(list(GOAL), weights=GOAL_W)[0]
        if bout_in:
            fcb = forecast(carried, bout_in)
            wb = worst_rib(fcb)
            prep += 1 if any(medical_fails(c) for c in fcb) or (wb and interp("ribs", opp, False, wb["v"], 0) >= MOVE_RISK) else 0
        cur, left = carried, bout_in
        for monday in range(3):
            wrb = worst_rib(cur) if cur else None
            if wrb is None or state(wrb["v"], wrb["flag"]) == "fine" or (left is not None and left <= 0):
                break
            costs = best_by_name(cur, left, opp, wish, seed=i, runs=16, goal=goal)
            vals = sorted(x[0] for x in costs.values())
            best = min(costs, key=lambda k: costs[k][0])
            key = (state(wrb["v"], wrb["flag"]), gap_band(left), opp)
            if vals[-1] - vals[0] >= SHOW_GAP:
                if key in contested:
                    cards += 1
                else:
                    orders += 1
            pl, _, k = run_weeks(r8, cur, costs[best][1], 7, left)
            knocks += k
            cur = [c for c in pl if state(c["v"], c["flag"]) != "fine"]
            left = None if left is None else left - 7
    per = 1.0 / len(sample)
    rows = [["The Monday care card (Train / Protect / Spare / Rest, the physio)", "%.0f" % (bouts26 * cards * per),
             "contested situations only, gap re-checked each Monday"],
            ["A standing order acts instead (the week review says what it did)", "%.0f" % (bouts26 * orders * per),
             "editable on the Coach card"],
            ["The offer shows a carried rib with its risk (Accept / Pass)", "%.0f" % (bouts26 * offers * per),
             "an offer 14 days out while a rib is not fine"],
            ["Fight prep opens Keep / Ask to move / Pull out", "%.0f" % (bouts26 * prep * per), "a booked bout at 1 in 5 or worse"],
            ["An injured place: the check", "%.1f" % (bouts26 * inj_rate), "%.1f per 100 bouts" % (100 * inj_rate)],
            ["Training rib knocks under the chosen answers", "%.1f" % (bouts26 * knocks * per), "the KNOCK table, not InjuryRoll"]]
    print(md(["Decision", "Times in 26 weeks (%d boxers, a bout every %d days = %.0f bouts)" % (BOXERS, BOUT_GAP_DAYS, bouts26), "Why"], rows))
    check(bouts26 * cards * per >= 8, "the card meets the player 8+ times in 26 weeks (%.1f)" % (bouts26 * cards * per))
    check(bouts26 * cards * per <= BOXERS * 26, "never more cards than boxer-Mondays")
    print("\nCONSTANTS: FINE %d, SORE %d, HURT %d, FACE_MED %d; rates eye %.1f nose %.1f ribs %.1f; knock drop %d; $%d a day-eq."
          % (FINE_AT, SORE_AT, HURT_AT, FACE_MED, RATE["eye"], RATE["nose"], RATE["ribs"], KNOCK_DROP, DOLLARS_PER_DAY))
    print("ASSERTS: %d passed" % ASSERTS)


if __name__ == "__main__":
    main()
