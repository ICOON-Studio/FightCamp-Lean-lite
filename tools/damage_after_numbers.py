"""DAMAGE AFTER THE FIGHT: every number table in ops/research/DAMAGE_AFTER_MAP_S438.md comes from here.

Stdlib only, deterministic (fixed seeds), prints markdown, and ASSERTS the map's own caps and the regret bars.
Run:  python tools/damage_after_numbers.py        (--soft: print failed asserts and go on)
Nothing here is game code: it is the design's arithmetic. PlaceCare.gd copies the constants block; its unit test checks rows.
Round 3: every decision is judged by REGRET (training days lost against the best answer), never by shares. Every answer is
priced on the BOUT (win chance, the chance of being stopped or injured on that place, days and shows missed); her weapon is a
GUESS from the style word until KNOWN; four answers are four jobs per place (ribs AND face); the game's own weight, tiredness,
morale, goal and camp lines are in the price. Knocks are priced exactly (every first-knock path), not sampled. The regret bars
are GATES: a decision that fails them may not be a player decision (CARE_CARD_IS_A_DECISION, FIGHT_PREP_ASKS); three
redesigns of the Monday are re-run here so the cut is evidence, not opinion.
"""
import math
import random
import sys

ASSERTS = 0
SOFT = '--soft' in sys.argv


def check(cond, what):
    global ASSERTS
    ASSERTS += 1
    if not cond:
        print("ASSERT FAILED: " + what)
        if not SOFT:
            sys.exit(1)


# ---------------------------------------------------------------- constants (TUNE ranges in the map, section 6)
FINE_AT, SORE_AT, HURT_AT, DOCTOR_AT = 90.0, 56.0, 36.0, 15.0   # settled bands 55 / 35 / 15
FACE_MED = 65.0             # the weigh-in doctor fails an eye or the nose under 65
PLACES = ["left_eye", "right_eye", "nose", "left_ribs", "right_ribs"]
KIND = {"left_eye": "eye", "right_eye": "eye", "nose": "nose", "left_ribs": "ribs", "right_ribs": "ribs"}
RATE = {"eye": 2.0, "nose": 2.4, "ribs": 1.4}          # points a day, sore or hurt
LIGHT = {"eye": 1.6, "nose": 1.3, "ribs": 1.4}         # an INJURED place heals at RATE x this (light) ...
SERIOUS = {"eye": 0.75, "nose": 0.5, "ribs": 0.4}      # ... or x this (serious): the named injury's own pace
NAMES = {"eye": ("Swollen eye", "Cut eye"), "nose": ("Bloodied nose", "Broken nose"), "ribs": ("Bruised ribs", "Cracked rib")}
REAL_DAYS = {("eye", "light"): (5, 10), ("eye", "serious"): (14, 21), ("nose", "light"): (5, 10),
             ("nose", "serious"): (21, 35), ("ribs", "light"): (10, 21), ("ribs", "serious"): (42, 56)}
SERIOUS_CHANCE = {"critical": 0.30, "doctor": 0.70}
PHYSIO_HIRED = 1.0 / 0.75   # built: StaffRoles.PHYSIO_DAYS 0.75
REST_MULT, MULT_CAP = 1.5, 2.0
STAND_DOWN = 28             # a stoppage on a place: the amateur stand-down, days (InjuryRoll.KO_DAYS 30 is the head's)
ANSWERS = ["train", "protect", "spare", "rest"]
# the week: (evening session, gain units, kg burnt, tiredness load). Mornings add 4/7 unit, 0.04 kg, 4.0 load a day.
BASE = {0: "pads", 1: "bag", 2: "pads", 3: "spar", 4: "pads", 5: "bag", 6: None}
FIGHT = {0: "pads", 1: "bag", 2: "pads", 3: None, 4: None, 5: None, 6: None}     # S428 light fight week, no sparring
GAIN = {"pads": 1.5, "bag": 1.0, "spar": 1.5}
BURN = {"pads": 0.06, "bag": 0.05, "spar": 0.05}
LOAD = {"pads": 4.0, "bag": 3.5, "spar": 5.0}
MORN_GAIN, MORN_BURN, MORN_LOAD = 4.0 / 7.0, 0.04, 4.0
FIGHT_WEEK_SHARE = 0.5      # fight week sessions are light: half the gain, burn and load
WEEK_UNITS = 12.0
DAY_UNITS = WEEK_UNITS / 7.0
STAT_PER_UNIT = 0.9 / 12.0  # a focused full week is about +0.9 on the focus stat (pace 1.0 x headroom ~0.9)
FATIGUE_KEEP, OVERREACHED, TIRED_GAIN = 0.87, 80.0, 0.6   # WeekPlan.gd:75, :77, :78
LOADS = {"eye": {"spar"}, "nose": {"spar"}, "ribs": {"spar", "pads", "bag"}}
# the four jobs, per place kind: heal share on a worked day, knock multiplier, what each session keeps (gain, burn)
JOB = {
    "ribs": {"train": {"heal": 0.40, "knock": 1.0, "keep": {"pads": 1.0, "bag": 1.0, "spar": 1.0}},
             # Protect: the body protector in sparring, pads to the head mitts, bag at half pace
             "protect": {"heal": 0.65, "knock": 0.25, "keep": {"pads": 0.9, "bag": 0.8, "spar": 0.9}},
             # Spare: no body work at all; sparring becomes head-only rounds; combinations (pads, bag) -> shadow, roadwork
             "spare": {"heal": 1.0, "knock": 0.0, "keep": {"pads": 0.45, "bag": 0.6, "spar": 0.75}}},
    "eye": {"train": {"heal": 0.40, "knock": 1.0, "keep": {"pads": 1.0, "bag": 1.0, "spar": 1.0}},
            # Protect: body-only sparring (the partner leaves the head alone; a glove still slips)
            "protect": {"heal": 0.75, "knock": 0.25, "keep": {"pads": 1.0, "bag": 1.0, "spar": 0.6}},
            # Spare: no sparring at all (technical bag rounds instead)
            "spare": {"heal": 1.0, "knock": 0.0, "keep": {"pads": 1.0, "bag": 1.0, "spar": 0.3}}},
}
JOB["nose"] = JOB["eye"]
REST_KEEP, REST_BURN = 0.25, 0.2      # Rest the week: gains x0.25 (built, Injuries.gain_mult), burn x0.2 (a walk)
KNOCK = {"ribs": {"sore": {"spar": 0.03, "pads": 0.008, "bag": 0.008}, "hurt": {"spar": 0.10, "pads": 0.03, "bag": 0.03}},
         "eye": {"sore": {"spar": 0.04}, "hurt": {"spar": 0.12}}}
KNOCK["nose"] = KNOCK["eye"]
KNOCK_DROP = 25.0
OVER_KNOCK = 3.0            # overreached: training injury risk x3 (pack 4.1, InjuryRoll)
CHIN_KNOCK = {"low": 1.3, "mid": 1.0, "high": 0.7}   # Chin under 55 / 55-69 / 70+
# what things are worth, in TRAINING DAYS (1 = the gains of one full training day). Shown in the map's section 3.7.
DOLLARS_PER_DAY = 50.0
WIN_VALUE = 12.0            # a win instead of a loss: morale +8 vs -12, members +8 vs -1, reputation +5 vs -2, a ladder place
SHOW_VALUE = 9.0            # a show missed: the $450 ticket cut (built) and the bout
PULL_OUT = 300.0 / DOLLARS_PER_DAY + SHOW_VALUE      # Injuries.gd:11 $300 empty slot + the show = 15
MISS_WEIGHT = 300.0 / DOLLARS_PER_DAY + SHOW_VALUE   # BoutRules.gd:88 MISSED_WEIGHT_COST 300 + the show = 15
DAY_OUT = 0.75 + SHOW_VALUE / 14.0  # a day out: trains at a quarter (built) and a show every 14 days slips
STOP_REP = 1.0              # a stoppage loss: 1 more member and 2 more reputation (BoutRules.gd:98-99)
MORALE_UNIT = 0.2           # one morale point; overruling her ask is -5 (FighterProfile.gd:30) = 1.0
REST_MORALE = 4             # FighterProfile.gd:24 rest_week +4
GOAL_SWING = (10 + 20) * 0.2   # her goal met +10 morale or missed -20 (FighterGoal.gd:29, :31): 6 training days
GOAL_SLACK = {"on track": (2.0, 6.0), "at risk": (-0.5, 2.0)}   # gain units she can lose before the goal line slips
GOAL_SCALE, WEIGHT_SCALE = 0.5, 0.05   # how sharp the lines are (the forecast's own wobble)
PROTECTOR = 75.0 / DOLLARS_PER_DAY
GUARD_WIN = 0.0015          # each point under 90 on fight night: -0.15 in 100 win (she guards it; fight half to measure)
STALE_WIN = 0.004           # each point of energy lost to staleness: BoutRules.gd:34-36 (2 a point over 50, at most 20)
SHARP_WIN = 0.03            # no sparring in the base week before the fight week: -3 in 100 (timing)
PEAK_WIN = 0.04             # PEAK CAMP (PeakCamp.gd:12, +1 every stat): about +4 in 100
NO_BOUT_W = 0.5             # no bout booked: the place is priced at half a bout 14 days out against the pool
DELAY = 0.3                 # a day a bout slips in a 26-week season
MOVE_YES, MOVE_DAYS, ASK_MOVE = 0.6, 14, 0.5
OTHER_YES, ASK_OTHER = 0.4, 0.3
FILM_EVENING = GAIN["pads"] / DAY_UNITS   # Watch the tape: a pad night becomes a film night
SHOW_GAP = 1.0              # a case is a decision when the worst answer costs a training day more than the best
# opponents: body share of what she lands; the style word gives a GUESS (P of each weapon), tape makes it KNOWN
OPP = {"head": 0.10, "mixed": 0.22, "body": 0.45}
OPP_WORD = {"head": "head hunter", "mixed": "mixed puncher", "body": "body puncher"}
STYLE = {"Out-boxer": (0.70, 0.25, 0.05), "Counter-puncher": (0.55, 0.35, 0.10), "Boxer-puncher": (0.25, 0.50, 0.25),
         "Volume puncher": (0.20, 0.45, 0.35), "Pressure fighter": (0.10, 0.35, 0.55), "Slugger": (0.15, 0.40, 0.45)}
STYLE_W = [0.18, 0.14, 0.18, 0.16, 0.20, 0.14]
POOL = (0.35, 0.40, 0.25)
OTHER_KNOWN = 0.07          # known at booking without the Ex-pro coach (her weapon already on file); Ex-pro coach 25% of clubs
FILMED = 0.5                # her last bout was filmed: Watch the tape makes the weapon KNOWN
# bout model (the fight half's interface)
FACE_HIT, HEAD_HIT, RIB_HIT, BIG_SHARE, BIG_MULT = 1.1, 0.55, 3.0, 0.15, 2.0
CAP_EXCHANGE, CAP_ROUND, GIVE_BACK, CARRIED_CAP = 10.0, 25.0, 0.15, 15.0
AIM_SHARE, CUT_AT = 0.20, 35.0
RIB_MORNING, EYE_MORNING, RIB_CRACK = 0.10, 0.25, 0.10
CUTMAN_CALL = 40.0 / DOLLARS_PER_DAY
HEAD_HAND_PER_100 = 6.0 * (37 + 18) / 100.0
WORDS = ((0.02, "under 1 in 50"), (0.07, "1 in 20"), (0.15, "1 in 10"), (0.27, "1 in 5"), (0.42, "1 in 3"), (0.62, "1 in 2"),
         (0.85, "3 in 4"))


def risk_words(p):
    for lim, w in WORDS:
        if p < lim:
            return w
    return "9 in 10"


def state(v, flag=False):
    if flag or v < HURT_AT:
        return "injured"
    return "fine" if v >= FINE_AT else "sore" if v >= SORE_AT else "hurt"


def pace(kind, v, flag=False, sev=""):
    """Points a day: an injured place at its injury's pace; a HURT place at the light-injury pace (the same swelling, so a
    hurt place is never slower than an injured one); a sore place at the sore pace."""
    if flag:
        return RATE[kind] * (SERIOUS[kind] if sev == "serious" else LIGHT[kind])
    return RATE[kind] * (LIGHT[kind] if v < SORE_AT else 1.0)


def days_to(v, target, kind, sev="", mult=1.0, flag=None):
    """Whole days until the place first reads `target` (rounded UP: the date shown is the first day it is true)."""
    flag = (sev != "") if flag is None else flag
    m, t = min(mult, MULT_CAP), 0.0
    if v < SORE_AT and target > v:
        top = min(target, SORE_AT)
        t += (top - v) / (pace(kind, v, flag, sev) * m)
        v = top
    if target > v:
        t += (target - v) / (pace(kind, v) * m)
    return max(0, math.ceil(t - 1e-9))


def carried_cap(start):
    return max(CARRIED_CAP, min(CAP_ROUND, CARRIED_CAP + (start - 60.0) / 4.0))


# ---------------------------------------------------------------- 1. the bout
def bout(rng, landed, opp, start=None, aim=None):
    body_share = OPP[opp]
    v = {p: 100.0 for p in PLACES + ["head"]}
    v.update(start or {})
    v0, low = dict(v), dict(v)
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
                    hits = [("right_ribs" if rng.random() < 0.6 else "left_ribs", RIB_HIT * big)]
                else:
                    hook = 1.5 if rng.random() < 0.4 else 1.0
                    if aim and rng.random() < AIM_SHARE:
                        f = aim
                    else:
                        f = "nose" if rng.random() < 0.45 else ("right_eye" if rng.random() < 0.65 else "left_eye")
                    hits = [(f, FACE_HIT * hook * big), ("head", HEAD_HIT * big)]
                for p, d in hits:
                    d = max(0.0, min(d, CAP_EXCHANGE - lost_ex[p], carried_cap(v0[p]) - lost_rd[p]))
                    lost_ex[p] += d
                    lost_rd[p] += d
                    v[p] = max(0.0, v[p] - d)
                    low[p] = min(low[p], v[p])
            worst_ex = max(worst_ex, max(lost_ex.values()))
        worst_rd = max(worst_rd, max(lost_rd.values()))
        if rnd < 2:
            for p in ("left_ribs", "right_ribs"):
                v[p] = min(100.0, v[p] + GIVE_BACK * lost_rd[p])
    cuts = {p: v[p] <= CUT_AT for p in ("left_eye", "right_eye", "nose")}
    stopped = {p: low[p] <= DOCTOR_AT for p in PLACES}
    return v, v0, cuts, worst_ex, worst_rd, stopped


def after_bell(rng, v, v0, cuts, cutman=False):
    out = {}
    for p in PLACES:
        kind, x = KIND[p], v[p]
        took = max(0.0, v0[p] - x)
        if kind == "ribs":
            x = min(100.0, x + RIB_MORNING * took)
        elif kind == "eye" and not cutman:
            x = max(0.0, x - EYE_MORNING * took)
        s = state(x)
        if kind == "ribs" and s == "hurt" and rng.random() < RIB_CRACK * (SORE_AT - x) / 20.0:
            x, s = min(x, 30.0), "injured"
        sev = ""
        if s == "injured":
            serious = (kind == "eye" and cuts.get(p)) or rng.random() < SERIOUS_CHANCE["doctor" if x <= DOCTOR_AT else "critical"]
            sev = "serious" if serious else "light"
        out[p] = {"v": x, "took": took, "state": s, "sev": sev}
    return out


def draw_bout(rng):
    level = rng.choices([36, 63, 90], weights=[0.35, 0.40, 0.25])[0]
    return level, max(10, int(round(level * rng.uniform(0.85, 1.15))))


REP = {"eye": "right_eye", "nose": "nose", "ribs": "right_ribs"}
STARTS = [100, 90, 80, 70, 60, 50, 40]
NT = {}


def night_table():
    """(kind, weapon, start) -> (P stopped on that place, P stopped or injured, mean days out after the bout)."""
    if NT:
        return NT
    for kind, place in REP.items():
        for opp in OPP:
            for st in STARTS:
                rng = random.Random(1000 + st + 7 * len(kind))
                n, stop, bad, days = 500, 0, 0, 0.0
                for _ in range(n):
                    _, landed = draw_bout(rng)
                    v, v0, cuts, _, _, stp = bout(rng, landed, opp, {place: float(st)})
                    a = after_bell(rng, v, v0, cuts)[place]
                    out = days_to(a["v"], SORE_AT, kind, a["sev"]) if a["state"] == "injured" else 0
                    if stp[place]:
                        out = max(out, STAND_DOWN)
                    stop += 1 if stp[place] else 0
                    bad += 1 if out > 0 else 0
                    days += out
                NT[(kind, opp, st)] = (stop / n, bad / n, days / n)
    return NT


def night(kind, opp, v):
    t = night_table()
    v = max(40.0, min(100.0, v))
    hi = min(x for x in STARTS if x >= v)
    lo = max(x for x in STARTS if x <= v)
    a, b = t[(kind, opp, lo)], t[(kind, opp, hi)]
    if hi == lo:
        return a
    f = (v - lo) / (hi - lo)
    return tuple(x + (y - x) * f for x, y in zip(a, b))


# ---------------------------------------------------------------- 2. the days to the bout, one answer, exact knock paths
def run(c, ans, knock_at=None, days=None):
    """Deterministic days from Monday to the weigh-in for the case's decision place under one answer. A knock lands at
    worked session number `knock_at`. Returns the end state and the list of knock chances per worked session."""
    kind = c["kind"]
    v, flag, sev, f = c["v"], c["flag"], c["sev"], c["fatigue"]
    gl = burn = 0.0
    sparred = False
    chances, idx = [], 0
    horizon = c["bout_in"] if c["bout_in"] else 14
    mult = PHYSIO_HIRED if c["physio"] else 1.0
    for d in range(days if days else (horizon - 1 if c["bout_in"] else horizon)):
        fight_week = c["bout_in"] is not None and c["bout_in"] - d <= 7
        s = (FIGHT if fight_week else BASE)[d % 7]
        share = FIGHT_WEEK_SHARE if fight_week else 1.0
        resting = ans == "rest" and d < 7
        job = JOB[kind]["spare" if (ans == "rest" or flag) else ans]
        tired = TIRED_GAIN if f >= OVERREACHED else 1.0
        if resting:
            keep_g, keep_b, worked = REST_KEEP, REST_BURN, False
            gl += (MORN_GAIN + (GAIN[s] if s else 0.0)) * share * (1.0 - REST_KEEP * tired)
            burn += (MORN_BURN + (BURN[s] if s else 0.0)) * share * (1.0 - REST_BURN)
            load = 0.0
        else:
            keep_g = job["keep"].get(s, 1.0) if s else 1.0
            gl += MORN_GAIN * share * (1.0 - tired) + ((GAIN[s] * share * (1.0 - keep_g * tired)) if s else 0.0)
            burn += (BURN[s] * share * (1.0 - min(1.0, keep_g + 0.3))) if s else 0.0
            load = (MORN_LOAD + (LOAD[s] * keep_g if s else 0.0)) * share
            worked = s in LOADS[kind] and job["knock"] > 0 if s else False
            if s == "spar" and not fight_week and (kind == "ribs" or ans != "spare"):
                sparred = True
        f = f * FATIGUE_KEEP + load
        st = state(v, flag)
        heal = 1.0
        if worked and st in ("sore", "hurt"):
            heal = job["heal"]
            p = KNOCK[kind][st].get(s, 0.0) * job["knock"] * CHIN_KNOCK[c["chin"]] * (OVER_KNOCK if f >= OVERREACHED else 1.0)
            chances.append(min(0.9, p))
            if knock_at == idx:
                v = max(0.0, v - KNOCK_DROP)
                if v < SORE_AT:
                    flag, sev = True, sev or "light"
            idx += 1
        m = mult * (REST_MULT if resting else 1.0)
        v = min(100.0, v + heal * pace(kind, v, flag, sev) * min(m, MULT_CAP))
        if flag and v >= SORE_AT:
            flag, sev = False, ""
    return {"v": v, "flag": flag, "sev": sev, "f": f, "gl": gl, "burn": burn, "sparred": sparred}, chances


def paths(c, ans):
    """Every path with its chance: no knock, or the first knock at each worked session (a second knock is ignored)."""
    base, ch = run(c, ans)
    out, alive = [], 1.0
    for i, p in enumerate(ch):
        if p > 0:
            out.append((alive * p, run(c, ans, i)[0]))
            alive *= 1.0 - p
    out.append((alive, base))
    return out


def medical_fails(kind, e):
    return e["flag"] or (kind in ("eye", "nose") and e["v"] < FACE_MED)


def remaining(kind, e):
    """A failed weigh-in: the days until she could pass it (injured -> 56; a face also -> 65)."""
    target = FACE_MED if kind in ("eye", "nose") else SORE_AT
    if e["flag"] or e["v"] < target:
        return days_to(e["v"], target, kind, e["sev"] if e["flag"] else "", flag=e["flag"])
    return 0


def goal_miss(c, e):
    if c["goal"] == "none":
        return 0.0
    return 1.0 / (1.0 + math.exp(-(e["gl"] - c["slack"]) / GOAL_SCALE))


def miss_weight(c, e):
    if not c["cut"] or not c["bout_in"]:
        return 0.0
    x = (c["margin"] + e["burn"] - 0.05) / WEIGHT_SCALE
    return 1.0 / (1.0 + math.exp(-x))


def bout_prices(c, e, opp, p0=None):
    """The three prices on fight night: (win chance, P stopped or injured on the place, days out if it goes), and the
    cost in training days. A failed medical or a missed weight is the $300 slot and the show."""
    kind = c["kind"]
    p0 = c["p0"] if p0 is None else p0
    pm = miss_weight(c, e)
    if medical_fails(kind, e):
        return 0.0, 1.0, remaining(kind, e), PULL_OUT + remaining(kind, e) * DAY_OUT, "fails the weigh-in"
    stop, bad, days = night(kind, opp, e["v"])
    stale = min(20.0, max(0.0, e["f"] - 50.0) * 2.0)
    pw = p0 * (1.0 - stop) - max(0.0, FINE_AT - e["v"]) * GUARD_WIN - stale * STALE_WIN
    if c["bout_in"] and c["bout_in"] >= 12 and not e["sparred"]:
        pw -= SHARP_WIN
    if c["camp"] and (e["f"] >= OVERREACHED or e["gl"] > 0.25 * c["plan_units"]):
        pw -= PEAK_WIN
    pw = max(0.0, pw)
    keep = (p0 - pw) * WIN_VALUE + days * DAY_OUT + stop * STOP_REP
    cost = pm * MISS_WEIGHT + (1.0 - pm) * min(keep, PULL_OUT)
    return pw * (1.0 - pm), bad, (days / bad if bad > 1e-9 else 0.0), cost, ""


def answer_cost(c, ans):
    """Cost of one answer against each weapon (training days), plus the expected prices."""
    ps = paths(c, ans)
    by = {}
    for opp in OPP:
        tot = 0.0
        for pr, e in ps:
            train = e["gl"] / DAY_UNITS + goal_miss(c, e) * GOAL_SWING
            if c["bout_in"]:
                nightc = bout_prices(c, e, opp)[3]
            else:
                nightc = NO_BOUT_W * sum(w * bout_prices(dict(c, bout_in=None, cut=False, camp=False), e, o)[3]
                                         for w, o in zip(POOL, OPP))
            tot += pr * (train + nightc)
        if ans == "rest":
            tot -= REST_MORALE * MORALE_UNIT
        if ans == "protect" and not c["protector"]:
            tot += PROTECTOR
        if (c["wish"] == "fight" and ans in ("spare", "rest")) or (c["wish"] == "rest" and ans == "train"):
            tot += 5 * MORALE_UNIT
        by[opp] = tot
    return by, ps


def info_cost(c, by):
    if c["known"]:
        return by[c["opp"]]
    return sum(w * by[o] for w, o in zip(STYLE[c["word"]], OPP))


def price_case(c):
    c["by"], c["paths"] = {}, {}
    for a in ANSWERS:
        c["by"][a], c["paths"][a] = answer_cost(c, a)
    c["info"] = {a: info_cost(c, c["by"][a]) for a in ANSWERS}
    c["true"] = {a: c["by"][a][c["opp"]] for a in ANSWERS}
    c["best"] = min(ANSWERS, key=lambda a: c["info"][a])
    c["tbest"] = min(ANSWERS, key=lambda a: c["true"][a])
    vals = sorted(c["info"].values())
    c["gap"] = vals[-1] - vals[0]
    return c


def expected_end(c, ans):
    ps = c["paths"][ans]
    return {k: sum(pr * e[k] for pr, e in ps) for k in ("v", "f", "gl", "burn")}, sum(pr for pr, e in ps if e["flag"])


def shown_prices(c, ans, opp_dist):
    """What the card shows for one answer: win chance, risk range over the weapons she may have, days out if it goes."""
    pw = bad = days = 0.0
    lo, hi = 1.0, 0.0
    for w, o in zip(opp_dist, OPP):
        if w <= 0:
            continue
        b_o = 0.0
        for pr, e in c["paths"][ans]:
            x = bout_prices(c, e, o)
            pw += w * pr * x[0]
            b_o += pr * x[1]
            bad += w * pr * x[1]
            days += w * pr * x[1] * x[2]
        if w >= 0.1:
            lo, hi = min(lo, b_o), max(hi, b_o)
    return pw, bad, (days / bad if bad > 1e-9 else 0.0), lo, hi


# ---------------------------------------------------------------- 3. a first amateur season, Monday by Monday
def gap_band(b):
    return "none" if b is None else str(b)


def fatigue_word(f):
    return "overreached" if f >= 80 else "very tired" if f >= 70 else "tired" if f >= 50 else "fresh"


def weight_word(c):
    if not c["cut"]:
        return "not cutting"
    return "on the line" if c["margin"] > -0.25 else "0.3-0.5 kg spare" if c["margin"] > -0.5 else "0.5 kg+ spare"


def features(c):
    return {"place": "%s %s" % (c["kind"], state(c["v"], c["flag"])), "days to the bout": gap_band(c["bout_in"]),
            "her weapon (or style word)": OPP_WORD[c["opp"]] if c["known"] else c["word"] + " (guess)",
            "goal chip": c["goal"], "weight": weight_word(c), "tiredness": fatigue_word(c["fatigue"]), "her wish": c["wish"],
            "chin": c["chin"], "camp": "camp" if c["camp"] else "no camp", "physio hired": str(c["physio"]),
            "protector owned": str(c["protector"]), "place number (5s)": "%s %d" % (c["kind"], 5 * int(c["v"] // 5))}


def season_cases(seasons, seed):
    rng = random.Random(seed)
    cases, bouts, nothing = [], 0, 0
    for s in range(seasons):
        for boxer in range(3):
            day = 0
            prof = {"chin": rng.choices(["low", "mid", "high"], [0.3, 0.45, 0.25])[0], "physio": rng.random() < 0.4,
                    "protector": rng.random() < 0.5, "known_coach": rng.random() < 0.25}
            while day < 182:
                bouts += 1
                level, landed = draw_bout(rng)
                word = rng.choices(list(STYLE), STYLE_W)[0]
                opp_last = rng.choices(list(OPP), STYLE[word])[0]
                v, v0, cuts, _, _, _ = bout(rng, landed, opp_last)
                ab = after_bell(rng, v, v0, cuts)
                gap = rng.choices([14, 28, 42], [0.45, 0.40, 0.15])[0]
                lead = rng.choice([7, 14])
                nword = rng.choices(list(STYLE), STYLE_W)[0]
                nopp = rng.choices(list(OPP), STYLE[nword])[0]
                cand = [p for p in PLACES if ab[p]["state"] != "fine"]
                if not cand:
                    nothing += 1
                    day += gap
                    continue
                p = max(cand, key=lambda q: (FINE_AT - ab[q]["v"]) / RATE[KIND[q]] + (99 if ab[q]["state"] == "injured" else 0))
                c0 = {"place": p, "kind": KIND[p], "v": ab[p]["v"], "flag": ab[p]["state"] == "injured", "sev": ab[p]["sev"],
                      "took": ab[p]["took"], "fatigue": rng.uniform(35, 85), "goal": rng.choices(["none", "on track", "at risk"], [0.3, 0.4, 0.3])[0],
                      "cut": rng.random() < 0.45, "margin": rng.uniform(-0.6, -0.05), "wish": rng.choices(
                          ["fight", "rest", "none"], [0.3, 0.2, 0.5])[0], "camp": rng.random() < 0.15, "p0": rng.uniform(0.35, 0.7),
                      "word": nword, "opp": nopp, "filmed": rng.random() < FILMED, "season": s, "bout": bouts, **prof}
                c0["known"] = prof["known_coach"] or rng.random() < OTHER_KNOWN
                c0["slack"] = rng.uniform(*GOAL_SLACK[c0["goal"]]) if c0["goal"] != "none" else 99.0
                c0["plan_units"] = WEEK_UNITS * 2
                for monday in range(6):
                    md = 2 + 7 * monday
                    left = gap - md
                    if left <= 0 or state(c0["v"], c0["flag"]) == "fine":
                        break
                    c = dict(c0)
                    c["bout_in"] = left if md >= gap - lead else None
                    c["monday"] = monday
                    price_case(c)
                    cases.append(c)
                    wk, _ = run(dict(c, bout_in=None), c["best"], days=7)   # the week as played (no knock)
                    c0 = dict(c0, v=wk["v"], flag=wk["flag"], sev=wk["sev"], fatigue=wk["f"])
                day += gap
    return cases, bouts, nothing


def md(headers, rows):
    out = ["| " + " | ".join(headers) + " |", "|" + "---|" * len(headers)]
    for r in rows:
        out.append("| " + " | ".join(str(x) for x in r) + " |")
    return "\n".join(out)


def mean_se(xs):
    n = len(xs)
    m = sum(xs) / n
    sd = math.sqrt(sum((x - m) ** 2 for x in xs) / max(1, n - 1))
    return m, sd / math.sqrt(n)


BARS = {}
CARE_CARD_IS_A_DECISION = False   # set by the bars: True only if T5 passes them (it does not; the map's section 4)
FIGHT_PREP_ASKS = False           # Ask to move / Ask for another opponent: kept only if T7 passes the bars
TAPE_PAYS_FOR_DAMAGE = False      # tape study sold on the damage only if knowing the weapon changes the answer (T5b)


def card_regret(cs, cost="info", best="best", answers=None):
    answers = answers or ANSWERS
    share = {a: sum(1 for c in cs if c[best] == a) / len(cs) for a in answers}
    always = {a: mean_se([c[cost][a] - c[cost][c[best]] for c in cs]) for a in answers}
    rules = {}
    for feat in features(cs[0]):
        groups = {}
        for c in cs:
            groups.setdefault(features(c)[feat], []).append(c)
        regs = []
        for grp in groups.values():
            a = min(answers, key=lambda x: sum(c[cost][x] for c in grp))
            regs += [c[cost][a] - c[cost][c[best]] for c in grp]
        rules[feat] = mean_se(regs)
    bf = min(rules, key=lambda f: rules[f][0])
    return {"share": share, "always": always, "rules": rules, "best_rule": (bf,) + rules[bf],
            "common": max(share, key=share.get)}


def gate_line(name, g):
    f, m, se = g["best_rule"]
    cm, cse = g["always"][g["common"]]
    ok = m - 2 * se >= 2.5 and cm - 2 * cse >= 3.0 and min(g["share"].values()) >= 0.15
    print("BARS for %s: best one-thing rule (%s) %.2f +- %.2f (needs 2.5); always the most common answer (%s) %.2f +- %.2f "
          "(needs 3); every answer best in 15%%+ (lowest %d%%): %s." % (name, f, m, se, g["common"], cm, cse,
                                                                      round(100 * min(g["share"].values())),
                                                                      "MET" if ok else "NOT MET"))
    return ok


def info_dist(c):
    return tuple(1.0 if o == c["opp"] else 0.0 for o in OPP) if c["known"] else STYLE[c["word"]]


def combo_costs(c, a):
    """Care answer `a` with each bout action (Keep / Ask to move / Ask for another opponent / Pull out), on what she knows."""
    d = info_dist(c)
    ni = lambda cc, dist: sum(w * sum(pr * bout_prices(cc, e, o)[3] for pr, e in cc["paths"][a]) for w, o in zip(dist, OPP))
    keep = ni(c, d)
    later = dict(c, v=min(100.0, c["v"] + MOVE_DAYS * pace(c["kind"], c["v"], c["flag"], c["sev"])), fatigue=40.0,
                 bout_in=5, camp=False)
    later["flag"] = c["flag"] and later["v"] < SORE_AT
    later["paths"] = {a: paths(later, a)}
    # a NO: their corner hears of the place and goes to it (one weapon step toward it)
    shift = (lambda q: (0.0, q[0], q[1] + q[2])) if c["kind"] == "ribs" else (lambda q: (q[0] + q[1], q[2], 0.0))
    move = ASK_MOVE + MOVE_YES * (DELAY * MOVE_DAYS + ni(later, d)) + (1 - MOVE_YES) * ni(c, shift(d))
    other = ASK_OTHER + OTHER_YES * ni(c, POOL) + (1 - OTHER_YES) * keep
    return {"keep": keep, "move": move, "other": other, "pull": PULL_OUT}


def redesigns(cases):
    """The ways tried to make the Monday a real decision; two of them re-run the season."""
    global WIN_VALUE, SHOW_VALUE, PULL_OUT, MISS_WEIGHT, DAY_OUT, GOAL_SWING, OTHER_KNOWN
    rows = []
    booked = [c for c in cases if c["bout_in"]]
    for c in booked:
        c["combo"] = {}
        for a in ANSWERS:
            cc = combo_costs(c, a)
            for k, x in cc.items():
                c["combo"][a + " + " + k] = c["info"][a] - cc["keep"] + x
        c["cbest"] = min(c["combo"], key=c["combo"].get)
    g = card_regret(booked, "combo", "cbest", list(booked[0]["combo"]))
    rows.append(["the care answer and the bout action as ONE plan (16 plans, %d cases)" % len(booked),
                 "%s: %.2f +- %.2f" % g["best_rule"]])
    saved = (WIN_VALUE, SHOW_VALUE, PULL_OUT, MISS_WEIGHT, DAY_OUT, GOAL_SWING, OTHER_KNOWN)
    for label in ("every weapon KNOWN (tape on every opponent)", "every stake doubled (a win, a show, the goal line)"):
        if label.startswith("every weapon"):
            OTHER_KNOWN = 1.0
        else:
            WIN_VALUE, SHOW_VALUE, GOAL_SWING = 2 * WIN_VALUE, 2 * SHOW_VALUE, 2 * GOAL_SWING
            PULL_OUT = MISS_WEIGHT = 300.0 / DOLLARS_PER_DAY + SHOW_VALUE
            DAY_OUT = 0.75 + SHOW_VALUE / 14.0
        cs2, _, _ = season_cases(20, 4382)
        g = card_regret([c for c in cs2 if c["bout_in"] and c["gap"] >= SHOW_GAP])
        rows.append([label, "%s: %.2f +- %.2f" % g["best_rule"]])
        WIN_VALUE, SHOW_VALUE, PULL_OUT, MISS_WEIGHT, DAY_OUT, GOAL_SWING, OTHER_KNOWN = saved
    print("\nRedesigns tried for the Monday (the best one-thing rule's regret; the bar is 2.5):")
    print(md(["Change", "Best one-thing rule: regret a case"], rows))
    for r in rows:
        check(float(r[1].split()[-3]) < 2.5 or CARE_CARD_IS_A_DECISION, "a redesign that passes becomes the map (%s)" % r[0])


def main():
    print("# damage_after_numbers.py output\n")
    print("## T1 The ladder and the risk words")
    print(md(["Word", "Place number", "What it means after the bell"], [
        ["fine", "90-100", "nothing to decide"], ["sore", "56-89", "heals by itself; a session that works it slows that and can knock it"],
        ["hurt", "36-55", "the same, knocked three to four times as easily"],
        ["injured", "0-35 (or knocked under 56)", "a named injury; fails the weigh-in until back at 56"]]))
    print("The weigh-in doctor also fails an eye or the nose under %d. Risk words: %s, else 9 in 10." %
          (FACE_MED, ", ".join("under %d%%: %s" % (round(100 * l), w) for l, w in WORDS)))
    check(SORE_AT - 1 == 55 and HURT_AT - 1 == 35, "the ladder keeps the settled 55/35 bands")
    check(risk_words(0.0) == "under 1 in 50" and risk_words(0.05) == "1 in 20", "the risk words start below 1 in 20")
    # ------------------------------------------------ T2
    print("\n## T2 Healing (whole days, rounded UP)")
    rows = []
    for kind in ("eye", "nose", "ribs"):
        l25, s25 = days_to(25, SORE_AT, kind, "light"), days_to(25, SORE_AT, kind, "serious")
        rows.append([kind, "%.1f / %.2f" % (RATE[kind], RATE[kind] * LIGHT[kind]), days_to(75, FINE_AT, kind), days_to(60, FINE_AT, kind),
                     "%s: x%.2f = %.2f a day, %d days (real %d-%d)" % (NAMES[kind][0], LIGHT[kind], RATE[kind] * LIGHT[kind], l25,
                                                                         *REAL_DAYS[(kind, "light")]),
                     "%s: x%.2f = %.2f a day, %d days (real %d-%d)" % (NAMES[kind][1], SERIOUS[kind], RATE[kind] * SERIOUS[kind], s25,
                                                                         *REAL_DAYS[(kind, "serious")])])
        for sev, dd in (("light", l25), ("serious", s25)):
            check(REAL_DAYS[(kind, sev)][0] <= dd <= REAL_DAYS[(kind, sev)][1], "%s %s heals in the real range" % (kind, sev))
    print(md(["Place", "Points a day: sore / hurt", "Sore 75 -> fine", "Sore 60 -> fine", "Light injury 25 -> fit (56)",
              "Serious injury 25 -> fit (56)"], rows))
    print("On a day a session works the place it heals at the answer's share (Train 40%%, Protect 65%% ribs / 75%% face, Spare "
          "and Rest 100%%). Physio hired x%.2f, a rest week x%.1f, capped x%.1f." % (PHYSIO_HIRED, REST_MULT, MULT_CAP))
    # ------------------------------------------------ T3
    rng = random.Random(438)
    rows, allb, inj_n = [], [], {k: 0 for k in ("eye", "nose", "ribs")}
    for i in range(4000):
        level, landed = draw_bout(rng)
        opp = rng.choices(list(OPP), POOL)[0]
        v, v0, cuts, wex, wrd, _ = bout(rng, landed, opp)
        allb.append((level, after_bell(rng, v, v0, cuts), wex, wrd))
    check(all(b[2] <= CAP_EXCHANGE + 1e-9 and b[3] <= CAP_ROUND + 1e-9 for b in allb), "caps: 10 an exchange, 25 a round")
    for lvl in (36, 63, 90, "all"):
        sel = [b for b in allb if lvl == "all" or b[0] == lvl]
        n = len(sel)
        rib = sum(1 for b in sel if min(b[1]["left_ribs"]["v"], b[1]["right_ribs"]["v"]) < FINE_AT)
        eye80 = sum(1 for b in sel if min(b[1][p]["v"] for p in ("left_eye", "right_eye", "nose")) < 80)
        hurt = sum(1 for b in sel if any(b[1][p]["state"] in ("hurt", "injured") for p in PLACES))
        injs = sum(1 for b in sel for p in PLACES if b[1][p]["state"] == "injured")
        rows.append([lvl, n, "%d%%" % round(100 * rib / n), "%d%%" % round(100 * eye80 / n), "%d%%" % round(100 * hurt / n),
                     "%.1f" % (100.0 * injs / n)])
    for b in allb:
        for p in PLACES:
            if b[1][p]["state"] == "injured":
                inj_n[KIND[p]] += 1
    per = {k: 100.0 * x / len(allb) for k, x in inj_n.items()}
    tot = sum(per.values()) + HEAD_HAND_PER_100
    print("\n## T3 What a 3x3 amateur bout leaves (4,000 bouts; landed on her 36/63/90 at 35/40/25%; pool head hunter / mixed / "
          "body puncher 35/40/25%)")
    print(md(["Landed on her", "Bouts", "Ribs sore or worse", "Eye or nose under 80", "A place hurt or worse",
              "Place injuries per 100"], rows))
    print("Injuries per 100 bouts: eye %.1f, nose %.1f, ribs %.1f (places, counted one by one); head knock + hand (InjuryRoll) "
          "%.1f; all %.1f." % (per["eye"], per["nose"], per["ribs"], HEAD_HAND_PER_100, tot))
    check(4.0 <= tot <= 8.0, "all bout injuries 4-8 per 100 (real ~6, Alevras 2022) (%.1f)" % tot)
    # ------------------------------------------------ T3b
    t = night_table()
    print("\n## T3b The bout from a carried place (500 bouts a cell): stopped or injured on that place / days out if it goes")
    rows = []
    for kind in ("ribs", "eye"):
        for opp in OPP:
            rows.append(["%s vs a %s" % (kind, OPP_WORD[opp])] + ["%s / %.0f" % (risk_words(t[(kind, opp, st)][1]),
                         t[(kind, opp, st)][2] / max(1e-9, t[(kind, opp, st)][1]) if t[(kind, opp, st)][1] > 0 else 0)
                         for st in STARTS])
            for x, y in zip(STARTS, STARTS[1:]):
                check(t[(kind, opp, y)][2] >= t[(kind, opp, x)][2] - 0.2, "%s %s: a lower start never costs less" % (kind, opp))
    print(md(["Place"] + ["start %d" % s for s in STARTS], rows))
    check(t[("ribs", "body", 70)][1] >= 3 * max(0.01, t[("ribs", "head", 70)][1]), "the weapon prices the rib")
    check(t[("eye", "head", 80)][1] > t[("eye", "body", 80)][1], "the weapon prices the eye the other way")
    # monotone: fight night never cheaper for a lower place (the round-2 medical-fail error)
    cc = {"kind": "ribs", "p0": 0.55, "bout_in": 12, "cut": False, "camp": False}
    for kind in ("ribs", "eye"):
        cc["kind"] = kind
        for opp in OPP:
            prev = -1.0
            for v in range(100, 19, -1):
                e = {"v": float(v), "flag": v < HURT_AT, "sev": "light" if v < HURT_AT else "", "f": 40.0, "gl": 0.0,
                     "burn": 0.0, "sparred": True}
                x = bout_prices(cc, e, opp)[3]
                check(x >= prev - 1e-6, "%s vs %s: the night never costs less at %d than at %d" % (kind, opp, v, v + 1))
                prev = x
    # ------------------------------------------------ the season
    SEASONS = SEASONS_RUN[0]
    cases, nb, nothing = season_cases(SEASONS, 4381)
    per26 = 1.0 / SEASONS
    card = [c for c in cases if c["bout_in"] and c["gap"] >= SHOW_GAP]
    print("\n## T4 A first amateur season (3 boxers, 26 weeks, %d seasons): what reaches a Monday" % SEASONS)
    sit = {}
    for c in cases:
        k = (features(c)["place"], gap_band(c["bout_in"]))
        sit.setdefault(k, [0, 0])
        sit[k][0] += 1
        sit[k][1] += 1 if c["bout_in"] and c["gap"] >= SHOW_GAP else 0
    rows = []
    for pl in sorted({k[0] for k in sit}):
        cells = [sit.get((pl, b), [0, 0]) for b in ("5", "12", "none")]
        rows.append([pl] + ["%.1f (%.1f)" % (x[0] * per26, x[1] * per26) for x in cells[:2]] + ["%.1f" % (cells[2][0] * per26)])
    print(md(["Place (the worst one)", "Bout in 5 days: Mondays (decisions)", "Bout in 12 days: Mondays (decisions)",
              "No bout booked: Mondays (no decision: it heals, the next offer prices it)"], rows))
    print("Bouts %.1f a season; %.1f leave nothing to decide; Mondays with a carried place %.1f; real decisions %.1f." %
          (nb * per26, nothing * per26, len(cases) * per26, len(card) * per26))
    # ------------------------------------------------ T5 regret
    print("\n## T5 Is the Monday a lookup? Regret in training days against the best answer (%d decision cases: a bout "
          "booked, the answers a day or more apart)" % len(card))
    g = card_regret(card)
    rows = [["always " + a.capitalize(), "%d%%" % round(100 * g["share"][a]), "%.2f +- %.2f" % g["always"][a]] for a in ANSWERS]
    print(md(["Rule", "Best answer in", "Regret a case (mean +- standard error)"], rows))
    rows = sorted(([f, "%.2f +- %.2f" % x] for f, x in g["rules"].items()), key=lambda r: float(r[1].split()[0]))
    print("\nThe best ONE-THING rule per visible thing (for each value, the one answer cheapest across its cases; fitted on "
          "these very cases, so generous to the rule):")
    print(md(["Reads only", "Regret a case (mean +- se)"], rows))
    hurt = [c for c in card if state(c["v"], c["flag"]) == "hurt"]
    th = sum(1 for c in hurt if c["best"] == "train") / max(1, len(hurt))
    print("\nTrain on a HURT place is best in %d%% of %d hurt cases. Two-thing rule (place number x her weapon or style "
          "word): %.2f +- %.2f." % ((round(100 * th), len(hurt)) + rule_regret2(card, "place number (5s)", "her weapon (or style word)")))
    BARS["card"] = gate_line("the Monday care card", g)
    check(BARS["card"] or not CARE_CARD_IS_A_DECISION, "the care card is a player decision only if it passes the regret bars")
    check(len(card) >= 400 and g["best_rule"][2] < 0.1, "the regret is measured on 400+ cases with a small error")
    # T5b guess vs known
    unk = [c for c in card if not c["known"]]
    flips = sum(1 for c in unk if c["best"] != c["tbest"]) / len(unk)
    vti = mean_se([c["true"][c["best"]] - c["true"][c["tbest"]] for c in unk])
    print("\n### T5b Her weapon: GUESS from the style word, or KNOWN")
    print("Of %d decision cases %d%% are a guess. Knowing her weapon changes the best answer in %d%% of guess cases and saves "
          "%.2f +- %.2f training days a case. Watch the tape (her last bout filmed, %d%%) costs a pad night (%.2f), so for "
          "the damage alone it pays %.2f a case." % (len(card), round(100 * len(unk) / len(card)), round(100 * flips), vti[0],
                                                    vti[1], round(100 * FILMED), FILM_EVENING, vti[0] - FILM_EVENING))
    BARS["known"] = flips >= 0.20
    print("BAR (knowing changes the best answer in 20%%+ of guess cases): %s (%.1f%%)." %
          ("MET" if BARS["known"] else "NOT MET", 100 * flips))
    check(BARS["known"] or not TAPE_PAYS_FOR_DAMAGE, "tape study is sold for damage only if knowing changes the answer")
    # T5c standing orders
    keyf = lambda c: (features(c)["place"], gap_band(c["bout_in"]), features(c)["her weapon (or style word)"])
    groups = {}
    for c in card:
        groups.setdefault(keyf(c), []).append(c)
    regs_all, regs_dflt = [], []
    for grp in groups.values():
        a = min(ANSWERS, key=lambda x: sum(c["info"][x] for c in grp))
        regs_all += [c["info"][a] - c["info"][c["best"]] for c in grp]
        regs_dflt += [c["info"]["train"] - c["info"][a] for c in grp]
    oa, od = mean_se(regs_all), mean_se(regs_dflt)
    print("\n### T5c Standing orders (one per place word x days to the bout x her weapon or style word: %d situations)" % len(groups))
    print("The best order in every situation costs %.2f +- %.2f a case against the best answer case by case. Leaving the "
          "coach's 'Train' everywhere instead costs %.2f +- %.2f a case more: %.1f training days in 26 weeks. With an order "
          "in every situation the Monday board never opens; a player who clears every order meets it %.1f times in 26 weeks "
          "and gains %.1f training days a season over the orders." %
          (oa[0], oa[1], od[0], od[1], od[0] * len(card) * per26, len(card) * per26, oa[0] * len(card) * per26))
    redesigns(cases)
    # ------------------------------------------------ T6 the Monday, played
    monday_played(cases)
    # ------------------------------------------------ T7 matchmaking
    matchmaking(cases)
    # ------------------------------------------------ T8 the opponent's carried place, the cutman
    print("\n## T9 Her opponent carries a place (her last bout filmed): Aim it (fight half to measure who wins)")
    rows = []
    for st in (85, 75, 65):
        r1, r2 = random.Random(9), random.Random(9)
        own = aim = 0
        for _ in range(1500):
            _, landed = draw_bout(r1)
            v, v0, cuts, _, _, _ = bout(r1, landed, "mixed", {"right_eye": float(st)})
            own += 1 if after_bell(r1, v, v0, cuts)["right_eye"]["state"] == "injured" else 0
            _, landed = draw_bout(r2)
            v, v0, cuts, _, _, _ = bout(r2, landed, "mixed", {"right_eye": float(st)}, aim="right_eye")
            aim += 1 if after_bell(r2, v, v0, cuts)["right_eye"]["state"] == "injured" else 0
        rows.append(["her right eye starts %d" % st, "%d in 100" % round(100 * own / 1500), "%d in 100" % round(100 * aim / 1500)])
    print(md(["The opponent", "Injured at the bell, our own game", "Aim: her right eye (plan line)"], rows))
    cutman(cases)
    print("\nCONSTANTS: FINE %d SORE %d HURT %d DOCTOR %d FACE_MED %d; win %.0f, show %.0f, pull-out %.0f, day out %.2f, $%d "
          "a training day." % (FINE_AT, SORE_AT, HURT_AT, DOCTOR_AT, FACE_MED, WIN_VALUE, SHOW_VALUE, PULL_OUT, DAY_OUT,
                               DOLLARS_PER_DAY))
    print("ASSERTS: %d passed" % ASSERTS)


def rule_regret2(cs, f1, f2):
    groups = {}
    for c in cs:
        groups.setdefault((features(c)[f1], features(c)[f2]), []).append(c)
    regs = []
    for g in groups.values():
        a = min(ANSWERS, key=lambda x: sum(c["info"][x] for c in g))
        regs += [c["info"][a] - c["info"][c["best"]] for c in g]
    return mean_se(regs)


def monday_played(cases):
    base = {"place": "right_ribs", "kind": "ribs", "v": 66.0, "flag": False, "sev": "", "took": 30.0, "fatigue": 64.0,
            "goal": "on track", "cut": True, "margin": -0.3, "wish": "none", "camp": False, "p0": 0.55,
            "word": "Pressure fighter", "opp": "body", "known": False, "filmed": True, "chin": "mid", "physio": False,
            "protector": False, "bout_in": 12, "plan_units": 24.0}
    c = None
    for slack in (2.0, 3.0, 4.0, 5.0, 6.0):     # the first on-track goal line where the tape changes the answer
        c = price_case(dict(base, slack=slack))
        if min(ANSWERS, key=lambda a: c["by"][a]["body"]) != min(ANSWERS, key=lambda a: c["by"][a]["mixed"]):
            break
    print("\n## T6 A Monday, played: Ana, right ribs 66 (sore), bout in 12 days against Mensah, a Pressure fighter (weapon "
          "a GUESS: head %d / mixed %d / body %d in 100); goal 'Power +2' on track (%.1f units of slack); cutting, 0.3 kg "
          "spare; tiredness 64 (tired); no body protector yet" % (tuple(round(100 * x) for x in STYLE["Pressure fighter"]) +
                                                                  (c["slack"],)))
    rows = []
    plan = (MORN_GAIN * 11 + sum(GAIN[s] * (FIGHT_WEEK_SHARE if d >= 5 else 1.0)
                                  for d in range(11) for s in [(FIGHT if d >= 5 else BASE)[d % 7]] if s)) * STAT_PER_UNIT
    for a in ANSWERS:
        pw, bad, days, lo, hi = shown_prices(c, a, STYLE[c["word"]])
        e, _ = expected_end(c, a)
        gm = sum(pr * goal_miss(c, x) for pr, x in c["paths"][a])
        shows = max(1, math.ceil(days / 14.0))
        rows.append([a.capitalize(), "%d%%" % round(100 * pw), "%s (%s to %s)" % (risk_words(bad), risk_words(lo), risk_words(hi)),
                     "%.0f days, %d show%s" % (days, shows, "" if shows == 1 else "s"),
                     "+%.1f of +%.1f, goal missed %s" % (max(0.0, plan - e["gl"] * STAT_PER_UNIT), plan, risk_words(gm)),
                     "%.2f kg %s" % (abs(c["margin"] + e["burn"]), "OVER" if c["margin"] + e["burn"] > 0.05 else "under"),
                     fatigue_word(e["f"]), "%d %s" % (round(e["v"]), state(e["v"])), "%.1f" % c["info"][a],
                     "%.1f / %.1f / %.1f" % (c["by"][a]["head"], c["by"][a]["mixed"], c["by"][a]["body"])])
    print(md(["Answer", "Win chance", "Stopped or injured on the ribs (the guess's range)", "If it goes", "Power by fight night",
              "Weight on the day", "Tiredness on the night", "Ribs on the night", "Cost on the guess",
              "Cost if KNOWN head hunter / mixed / body puncher"], rows))
    print("Best on the guess: %s. Known: head hunter %s, mixed %s, body puncher %s." % (
        c["best"], *(min(ANSWERS, key=lambda a: c["by"][a][o]) for o in OPP)))
    check(min(ANSWERS, key=lambda a: c["by"][a]["body"]) != min(ANSWERS, key=lambda a: c["by"][a]["mixed"]),
          "the Monday played: the tape changes the answer")


ACTIONS = ["keep", "move", "other", "pull"]


def matchmaking(cases):
    """Fight prep on the last Monday (bout in 5 days): Keep / Ask to move 14 days / Ask for another opponent / Pull out."""
    print("\n## T7 Fight prep, the last Monday: Keep / Ask to move 14 days / Ask for another opponent (same show) / Pull out")
    cs = []
    for c in cases:
        if c["bout_in"] != 5:
            continue
        bad = shown_prices(c, c["best"], info_dist(c))[1]
        if bad < 0.2 and not any(medical_fails(c["kind"], e) for pr, e in c["paths"][c["best"]] if pr > 0.2):
            continue
        c["act"] = combo_costs(c, c["best"])
        c["abest"] = min(ACTIONS, key=lambda k: c["act"][k])
        cs.append(c)
    g = card_regret(cs, "act", "abest", ACTIONS)
    rows = [[k, "%d%%" % round(100 * g["share"][k]), "%.2f +- %.2f" % g["always"][k]] for k in ACTIONS]
    print("Opens when the night's risk is 1 in 5 or worse, or a weigh-in fail is likely: %.1f times in 26 weeks (%d cases)." %
          (len(cs) / SEASONS_RUN[0], len(cs)))
    print(md(["Action", "Best in", "Regret a case if always taken"], rows))
    print("Best one-thing rule: %s, %.2f +- %.2f a case." % g["best_rule"])
    BARS["prep"] = gate_line("Fight prep", g)
    check(len(cs) >= 100, "Fight prep sample 100+ (%d)" % len(cs))
    check(BARS["prep"] or not FIGHT_PREP_ASKS, "Ask to move / Ask for another opponent stay only if Fight prep passes the bars")


def cutman(cases):
    eyes = [c for c in cases if c["kind"] == "eye" and c["monday"] == 0]
    worth = {True: [0, 0], False: [0, 0]}
    for c in eyes:
        cc = price_case(dict(c, v=min(100.0, c["v"] + EYE_MORNING * c["took"])))
        k = c["bout_in"] is not None
        worth[k][1] += 1
        worth[k][0] += 1 if cc["info"][cc["best"]] + CUTMAN_CALL < c["info"][c["best"]] else 0
    print("\n## T10 The cutman the morning after ($%d a call): the eye skips its overnight swelling" % round(CUTMAN_CALL * DOLLARS_PER_DAY))
    print(md(["Eye cases (the morning after)", "Cases", "Worth its $40"], [
        ["a bout booked", worth[True][1], "%d%%" % round(100 * worth[True][0] / max(1, worth[True][1]))],
        ["no bout booked", worth[False][1], "%d%%" % round(100 * worth[False][0] / max(1, worth[False][1]))]]))


SEASONS_RUN = [40]


if __name__ == "__main__":
    main()
