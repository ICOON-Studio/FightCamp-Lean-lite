#!/usr/bin/env python3
"""DAMAGE FIGHT numbers (S438, round 3): every number table in ops/research/DAMAGE_FIGHT_MAP_S438.md comes from here.
Stdlib only, deterministic (fixed seeds), prints markdown, ASSERTS the caps, the rules and the REGRET bars. A small model of the fight
half: six exchanges a round (Exchanges.settle margin, 4-3 / 5-2 / 6-1 landed), a place per landed punch, places change the next
exchanges, counts at the bell and inside an exchange. The three corner-minute decisions (the Aim, the range call, ONE CHANGE) are
scored on minutes HARVESTED from simulated bouts, played on with each option on the same exchange dice, two halves of play-ons
(an option picked on one half is valued on the other, so dice luck never counts as depth). A design probe, not the game: the build
re-measures every TUNE number on the real Exchanges / Duels.  Run: python tools/damage_fight_numbers.py  (4 worker processes, about 3.5 minutes on a GREEN PC; --jobs 2 beside agents, about 6)
"""
import math, os, random, sys, time
from itertools import combinations
from multiprocessing import Pool

ASSERTS = [0]
def check(cond, what):
    ASSERTS[0] += 1; assert cond, what

# ---------------- constants (map section 6.1) ----------------
EX_SPREAD, EXCHANGES, LANDED = 66.0, 6, {"close": (4, 3), "clear": (5, 2), "dominant": (6, 1)}   # CODE Exchanges.gd:14, 10, 296
PLACES, WORDS = ["head", "left_eye", "right_eye", "nose", "left_ribs", "right_ribs"], ["fine", "sore", "hurt", "injured"]
MIDS = {"fine": 78.0, "sore": 45.0, "hurt": 25.0, "injured": 8.0}   # what the coach assumes a read word means
EYES, RIBS, CUTTABLE = ("left_eye", "right_eye"), ("left_ribs", "right_ribs"), ("left_eye", "right_eye", "nose")
SORE_AT, HURT_AT, INJURED_AT, BIG, BIG_MULT = 55, 35, 15, 0.15, 2.0   # CODE BodyMap.gd:8-10, 16
RIB_HIT, FACE_HIT, HEAD_HIT, HOOK_HEAD, CUT_MULT, REAR_MULT = 6.0, 1.0, 0.55, 1.5, 1.5, 1.25
CAP_EX, CAP_ROUND, GIVE_BACK, CARRY = 10.0, 30.0, 0.15, 70.0
SPEND, BODY_ENERGY, TIRED_FROM, TIRED_EDGE = 2.0, 1.2, 65.0, 10.0
WATER, WATER_RIB = ((40.0, 6.0), (60.0, 3.0), (999.0, 2.0)), {"fine": 0.0, "sore": 1.0, "hurt": 2.0, "injured": 2.0}
BREATH = {"fine": 1.0, "sore": 1.25, "hurt": 1.4, "injured": 1.4}
BLIND_POWER, BLIND_JAB, CUT_P, NOSE_WATER, HEADGUARD_FACE, HEADGUARD_CUT = 4.0, 2.0, 0.012, 0.75, 0.6, 0.5
WINDED_P, WINDED_EDGE, KNEE_E, STANDING_P, STEP_EDGE, STEP_E = 0.14, 16.0, 45.0, 0.35, 8.0, 3.0
HEART_WIND = ((65, 0.5), (55, 0.75), (0, 1.0))
LIVER_P, LIVER_MAX, LIVER_STAYS, ICE_LIVER = {"fine": 0.02, "sore": 0.12, "hurt": 0.22, "injured": 0.3}, 0.4, 0.5, 0.5
BASE_COUNT, HEAD_SCALE, MARGIN_F, REF_STOP = 0.05, 15.0, {"close": 0.3, "clear": 1.0, "dominant": 2.2}, 0.17
DOC_PLACE, DOC_CUT, DOC_CLOSED = 0.28, 0.08, 0.02
COVER_REAR, COVER_LEAD, COVER_BLOCK = 0.75, 0.45, 0.6     # Elbows in: hooks on the defender's rear side / lead side covered; 60% die
ELBOW_OWN, ELBOW_COST, GUARD_EDGE, ELBOW_MID, WRONG_GUARD = 0.6, 0.5, 4.0, 0.8, 3.0   # a guard met by the Aim it was set for / the wrong guard
GLOVES_FACE, GLOVES_RIB, GLOVES_BODY, GLOVES_COST = 0.5, 1.25, 0.15, 1.0   # Gloves high: -1 edge at long (no jab)
MOMENTUM, MOMENTUM_MAX = 1.5, 3.0   # an Aim kept round after round sets itself up: +1.5 edge a round kept, unless guarded
CORNER, CORNER_STEP, CORNER_MAX, THEY_WORK = {"cautious": 0.9, "stubborn": 0.05, "still": 0.0}, 0.10, 0.85, {"cautious": 0.7, "stubborn": 0.3, "still": 0.0}
HEAD_OPEN, HEAD_OPEN_ELBOWS, HEAD_EYE, HEAD_BLIND = {"fine": 0.0, "sore": 3.0, "hurt": 4.5, "injured": 4.5}, 1.0, 0.6, 2.0
WEAK_EDGE, WEAK_MULT, WEAPON = 1.0, 1.15, {"ribs": (0, 50), "middle": (1, 60), "head": (2, 60)}
READ_ACC = {1: 0.55, 2: 0.70, 3: 0.85}
RANGES, MID = ["long", "pocket", "inside"], {"long": 0.8, "pocket": 0.35, "inside": 0.25}
HEAD_MIX = {"long": (0.6, 0.4, 0.0), "pocket": (0.25, 0.35, 0.3), "inside": (0.05, 0.2, 0.45)}
AIMS = {"right_ribs": (0.45, -0.25, "Liver"), "left_ribs": (0.45, -0.25, "Left ribs"), "middle": (0.45, 0.35, "Middle"), "head": (0.08, 0.0, "Head")}
LEAD_COST, REAR_COST = {"long": 1.8, "pocket": 0.3, "inside": 0.8}, {"long": 1.4, "pocket": 0.8, "inside": 0.3}
MIDDLE_DIP = 2.0   # a straight body shot dips your head: their Head Aim gains this while you are on Middle
MID_COST, HEAD_COST, MID_DRAIN = {"long": 0.3, "pocket": 0.8, "inside": 1.3}, {"long": 0.2, "pocket": 0.6, "inside": 1.3}, 1.6
STYLES = {"out-boxer": ((0.6, 0.3, 0.1), "long", "head", -4.0), "pressure": ((0.2, 0.4, 0.4), "inside", "liver", 0.0),
          "counter": ((0.45, 0.45, 0.1), "pocket", "head", 0.0), "slugger": ((0.25, 0.45, 0.3), "pocket", "liver", 6.0)}
SKILLS = {"head-hunter": (10, 30, 85, "long"), "body puncher": (80, 50, 40, "pocket"), "inside man": (30, 85, 50, "inside"),
          "average": (45, 50, 50, None)}
HOME_EDGE, CALL_SHIFT, CALL_E = 6.0, 0.6, {"long": 0.5, "pace": 0.0, "inside": 0.8}
CALLS = {"long": "Stay long", "pace": "Their pace", "inside": "Get inside"}
MOOD = {"Fired up": 1.05, "Steady": 1.0, "Flat": 0.85, "Low": 0.7}
HABIT_AT = (0.0, 2.5, 5.0, 7.5)          # an open habit: edge lost in each exchange at ITS one range
HEAL = {"ribs": 1.4, "eye": 2.0}         # points a day, from the after map (DAMAGE_AFTER_MAP_S438 3.2)
CAPS = {"ex": 0.0, "round": 0.0, "rib_min": 100.0}

def word(v):
    v = math.floor(v + 0.5)
    return "fine" if v > SORE_AT else ("sore" if v > HURT_AT else ("hurt" if v > INJURED_AT else "injured"))
def better(w): return WORDS[max(0, WORDS.index(w) - 1)]
def win_p(d):
    x = max(-1.0, min(1.0, d / EX_SPREAD))
    return 1.0 - 0.5 * (1.0 - x) ** 2 if x >= 0 else 0.5 * (1.0 + x) ** 2
def k_edge(rounds=3):   # bout win % per edge point in one exchange at level: slope x exchange pivot (0.3125) x round pivot
    return 100.0 / EX_SPREAD * (0.5 * 20.0 / 32.0) * (math.comb(rounds - 1, (rounds - 1) // 2) / 2.0 ** (rounds - 1))

class Boxer:
    def __init__(s, south, places=None, heart=60, cardio=1.0, skills="average", habit=0.0, habit_rng="pocket", takes=0.7, mood="Steady", guard=False):
        s.south, s.e, s.heart, s.cardio, s.guard, s.habit, s.habit_rng, s.takes, s.mood = south, 100.0, heart, cardio, guard, habit, habit_rng, takes, mood
        s.hook_m, s.inside, s.acc, s.home = SKILLS[skills]; s.fix_on, s.fix_from, s.last_change = False, 99, "none"
        s.p = {k: 100.0 for k in PLACES}; s.p.update(places or {})
        s.cuts, s.closed, s.ice = set(), set(), set(); s.counts = s.rc = s.warned = 0; s.change, s.winded, s.wnext = "none", None, False
        s.hooks, s.hooks_last = {k: 0 for k in RIBS}, {k: 0 for k in RIBS}
        s.rl, s.xl, s.rl_last, s.max_x, s.max_r = {k: 0.0 for k in PLACES}, {k: 0.0 for k in PLACES}, {k: 0.0 for k in PLACES}, 0.0, 0.0
    def clone(s):
        c = Boxer.__new__(Boxer); c.__dict__.update(s.__dict__)
        for k in ("p", "hooks", "hooks_last", "rl", "xl", "rl_last"): setattr(c, k, dict(getattr(s, k)))
        for k in ("cuts", "closed", "ice"): setattr(c, k, set(getattr(s, k)))
        return c
    def band(s, k): return better(word(s.p[k])) if k in s.ice else word(s.p[k])
    def worst(s, places, raw=False): return WORDS[max(WORDS.index(word(s.p[k]) if raw else s.band(k)) for k in places)]
    def hit(s, k, pts):
        pts *= CUT_MULT if (k in s.cuts and k not in s.closed) else 1.0; pts = max(0.0, min(pts, CAP_EX - s.xl[k], CAP_ROUND - s.rl[k], s.p[k]))
        s.p[k], s.xl[k], s.rl[k] = s.p[k] - pts, s.xl[k] + pts, s.rl[k] + pts; s.max_x, s.max_r = max(s.max_x, s.xl[k]), max(s.max_r, s.rl[k])
        if k in CUTTABLE and s.p[k] <= HURT_AT: s.cuts.add(k)
    def blind(s, eye): return s.band(eye) in ("hurt", "injured") or (eye in s.cuts and eye not in s.closed)
    def penalty(s, opp_south):
        power_eye = "right_eye" if opp_south else "left_eye"
        pen = sum((BLIND_POWER if eye == power_eye else BLIND_JAB) for eye in EYES if s.blind(eye)) * (0.5 if s.change == "gloves" else 1.0)
        return pen + (TIRED_EDGE * (TIRED_FROM - s.e) / TIRED_FROM if s.e < TIRED_FROM else 0.0)

def lead_side(att): return "left_ribs" if att.south else "right_ribs"   # where the lead hook lands (orthodox: the left hook, the liver)
def aim_cost(me, aim, rng):
    if aim in RIBS:
        c = max(0.3, LEAD_COST[rng] - (me.hook_m / 40.0 if rng == "long" else 0.0)) if aim == lead_side(me) else REAR_COST[rng]
        return c + (ELBOW_COST if me.change == "elbows" else 0.0)
    if aim == "middle": return max(0.3, MID_COST[rng] - (me.inside / 100.0 if rng != "long" else 0.0))
    return max(0.0, HEAD_COST[rng] - me.acc / 100.0)
def weak(st, me, aim):
    o = st.case.get("open")
    if me is not st.A or o is None or o == "none": return False
    if not (o == aim or (o == "ribs" and aim in RIBS)): return False
    return (me.hook_m, me.inside, me.acc)[WEAPON[o][0]] >= WEAPON[o][1]
def head_open(op):   # body first opens the head: their hands drop as a rib side goes; Gloves high shuts it, Elbows in opens it more
    if op.change == "gloves": return 0.0
    return HEAD_OPEN[op.worst(RIBS)] + (HEAD_OPEN_ELBOWS if op.change == "elbows" else 0.0)
def cover_of(dfn, side): return COVER_REAR if side == ("left_ribs" if dfn.south else "right_ribs") else COVER_LEAD   # Elbows in on that side
def worse_eye(b): return min(EYES, key=lambda e: (not b.blind(e), b.p[e], e))

def hit_face(st, dfn, k, km, big, wk):
    f = (GLOVES_FACE if dfn.change == "gloves" else 1.0) * (HEADGUARD_FACE if dfn.guard else 1.0) * (WEAK_MULT if wk else 1.0)
    dfn.hit(k, FACE_HIT * km * f); dfn.hit("head", HEAD_HIT * km * f)
    if big and k not in dfn.cuts and st.r.random() < CUT_P * (HEADGUARD_CUT if dfn.guard else 1.0) * (2.0 if wk else 1.0):
        dfn.cuts.add(k); st.stats["cuts"] += 1

def land(st, att, dfn, aim, rng, pd, no_big):
    r, (body, mid, _), wk = st.r, AIMS[aim], weak(st, att, aim); big = r.random() < BIG and not no_big
    mult = BIG_MULT if big else 1.0
    if r.random() < body + (GLOVES_BODY if dfn.change == "gloves" else 0.0):
        dfn.e -= BODY_ENERGY * ((MID_DRAIN * (WEAK_MULT if wk else 1.0)) if aim == "middle" else 1.0)
        if r.random() < min(0.95, max(0.05, MID[rng] + mid)):             # down the middle: the solar plexus
            p = WINDED_P * math.exp(pd / 12.0) * (WEAK_MULT if wk and aim == "middle" else 1.0)
            return "winded" if big and r.random() < p else None
        lp = 0.85 if aim == "right_ribs" else (0.15 if aim == "left_ribs" else (0.4 if att.south else 0.6))
        left = r.random() < lp; side = "right_ribs" if left else "left_ribs"   # a left hook lands on the right ribs (the liver)
        rear = left == att.south                                         # the rear hand: more weight behind it
        dfn.hooks[side] += 1
        if dfn.change == "elbows" and r.random() < cover_of(dfn, side):
            if r.random() >= COVER_BLOCK: hit_face(st, dfn, "right_eye" if left else "left_eye", HOOK_HEAD * mult, big, False)
            return None
        step = dfn.winded == "step"
        dfn.hit(side, RIB_HIT * mult * (REAR_MULT if rear else 1.0) * (GLOVES_RIB if dfn.change == "gloves" else 1.0) * (0.5 if step else 1.0)
                * (WEAK_MULT if wk else 1.0) * (ELBOW_OWN if att.change == "elbows" else 1.0))
        if left and big and not step:
            p = min(LIVER_MAX, LIVER_P[dfn.band("right_ribs")] * math.exp(pd / 12.0)) * (ICE_LIVER if "right_ribs" in dfn.ice else 1.0)
            if r.random() < p: return "liver"
        return None
    (jab, cross, hook), x = HEAD_MIX[rng], r.random()
    kind = "jab" if x < jab else ("cross" if x < jab + cross else ("hook" if x < jab + cross + hook else "upper"))
    if aim == "head" and kind in ("jab", "cross") and r.random() < 0.5: kind = "hook" if kind == "jab" else "upper"
    lead_left = not att.south
    eye = "right_eye" if ((kind in ("jab", "hook")) == lead_left) else "left_eye"
    face = ("nose" if r.random() < (0.6 if kind == "jab" else 0.5) else eye) if kind in ("jab", "cross") else (eye if kind == "hook" else "nose")
    if aim == "head" and face != "nose" and r.random() < HEAD_EYE: face = worse_eye(dfn)   # Head works the worse eye
    hit_face(st, dfn, face, (HOOK_HEAD if kind in ("hook", "upper") else 1.0) * mult, big, wk and aim == "head")
    return None

# ---------------- corners: the coach's defaults (each decision overrides one, at one minute) ----------------
def opening(case, a):   # the plan's opening Aim (the player's pick), else the coach's: their weakness if you have the weapon, else your skills
    if case.get("plan_aim"): return case["plan_aim"]
    o, sk = case.get("open", "none"), case.get("skills", "average")
    if o != "none" and (a.hook_m, a.inside, a.acc)[WEAPON[o][0]] >= WEAPON[o][1]: return lead_side(a) if o == "ribs" else o
    return {"inside man": "middle", "head-hunter": "head"}.get(sk, lead_side(a))
def d_aim(st): return st.aim["A"]
def d_call(st): return "pace"
def elbows_cue(me, their_last):   # THE Elbows in trigger, one rule for both corners: a round of body work on him, or a rib side sore
    return their_last != "head" or me.worst(RIBS, raw=True) != "fine"
def gloves_cue(me, their_last):   # THE Gloves high trigger: a round of head work on him, a cut, or a face place sore
    return their_last == "head" or bool(me.cuts) or me.worst(CUTTABLE, raw=True) != "fine"
def d_change(st, me):   # the coach's default: a guard stays until you change it; else fix an open habit; else the cue's guard
    if me.change in ("elbows", "gloves"): return me.change
    if me.habit and not me.fix_on: return "fix"
    return "elbows" if elbows_cue(me, st.aim["B"]) else ("gloves" if gloves_cue(me, st.aim["B"]) else "none")
DEFAULT = {"aim": d_aim, "call": d_call, "change": d_change}
def their_change(st, me):   # their corner answers what hurt them last round, by its habit on the file (cautious / stubborn)
    c, last = st.case.get("corner", "stubborn"), st.aim["A"]
    if c == "still": return me.change   # the coach's forecast: their corner changes nothing
    p = min(CORNER_MAX, CORNER[c] + CORNER_STEP * max(0, max(me.hooks_last.values()) - 3))
    if elbows_cue(me, last) and st.r.random() < p: return "elbows"
    if gloves_cue(me, last) and st.r.random() < p: return "gloves"
    return "none"
def their_aim(st, you):
    w = THEY_WORK[st.case.get("corner", "stubborn")]
    if you.last_change in ("elbows", "gloves") and st.r.random() < w:   # they saw your guard last round and go round it
        return "head" if you.last_change == "elbows" else min(RIBS, key=lambda s: you.p[s])
    if (you.cuts or you.worst(CUTTABLE, raw=True) != "fine") and st.r.random() < w: return "head"
    if you.worst(RIBS, raw=True) != "fine" and st.r.random() < w: return min(RIBS, key=lambda s: you.p[s])
    return lead_side(st.B) if st.case.get("their_plan", "body") == "body" else "head"   # their file: goes to the body / hunts the head
def recover(me):   # the seconds' pick: ice the worse rib side when it reads sore or worse at energy 50+, else water
    side = min(RIBS, key=lambda s: me.p[s]); sides = [side] if word(me.p[side]) != "fine" and me.e >= 50.0 else []
    me.ice = set(sides)
    for s in sides: me.p[s] = min(100.0, me.p[s] + 0.15 * me.rl_last[s])
    per = next(w for top, w in WATER if me.e < top) - WATER_RIB[me.worst(RIBS, raw=True)]
    me.e = min(100.0, me.e + (3 - len(sides)) * max(0.0, per) * (NOSE_WATER if ("nose" in me.cuts and "nose" not in me.closed) else 1.0))
def doctor(me):
    p = DOC_PLACE if min(me.p[k] for k in ("head",) + CUTTABLE) <= INJURED_AT else 0.0
    return max([p] + [DOC_CLOSED if k in me.closed else DOC_CUT for k in me.cuts])

# ---------------- the bout ----------------
class St:
    def clone(s):
        c = St.__new__(St); c.__dict__.update(s.__dict__); c.A, c.B = s.A.clone(), s.B.clone()
        c.kept = dict(s.kept); c.won, c.ex_won, c.aim, c.stats, c.sore_by, c.force = list(s.won), list(s.ex_won), dict(s.aim), dict(s.stats), dict(s.sore_by), {}
        c.r = c.r_ex = None; return c
def new_bout(case, seed):
    st = St(); st.case, st.rounds = case, case.get("rounds", 3); st.am = st.rounds == 3
    st.A = Boxer(case.get("a_south", False), heart=case.get("heart", 60), skills=case.get("skills", "average"), habit=case.get("habit", 0.0),
                 habit_rng=case.get("habit_rng", "pocket"), takes=case.get("takes", 0.7), mood=case.get("mood", "Steady"), guard=case.get("guard", False))
    st.B = Boxer(case.get("south", False), case.get("b_start"), cardio={"low": 1.15, "mid": 1.0, "high": 0.85}[case.get("cardio", "mid")],
                 guard=case.get("guard", False))
    st.rnd, st.i, st.phase, st.won, st.ex_won, st.msum, st.mtot, st.long_left, st.call = 1, 0, "ex", [0, 0], [0, 0], 0.0, 0.0, 0, "pace"
    st.kept = {"A": 0, "B": 0}; st.aim, st.force, st.result, st.log, st.seed = {"A": opening(case, st.A), "B": None}, {}, None, None, seed
    st.aim["B"] = lead_side(st.B) if case.get("their_plan", "body") == "body" else "head"
    st.stats = {k: 0 for k in ("winded", "liver", "knee", "head_counts", "standing", "cuts", "blind", "ex", "covers", "blind_bout")}
    st.sore_by, st.chip_r, st.fresh = {}, 9, not case.get("b_start"); reseed(st, seed)
    return st
def reseed(st, seed): st.base, st.r_ex, st.r = seed, random.Random(seed * 7919 + 1), random.Random(seed * 104729 + 3)
def dice(st, k): st.r = random.Random(st.base * 100003 + st.rnd * 101 + k)   # fresh dice per exchange / bell / minute: options share them
def count(st, dfn, key): st.stats[key] += 1; dfn.counts, dfn.rc = dfn.counts + 1, dfn.rc + 1
def finish(st, a_wins, how): st.result = (a_wins, st.rnd, how)
def live(st): return abs(st.won[0] - st.won[1]) < st.rounds - st.rnd + 1
def run(st, pol, harvest=None):
    while st.result is None:
        if st.phase == "minute": minute(st, pol, harvest)
        elif st.i < EXCHANGES: exchange(st)
        else: bell(st)
    return st

def mix_for(st):
    mix = list(STYLES[st.case["style"]][0]); call = st.call
    if call != "pace":
        s, k = CALL_SHIFT * MOOD[st.A.mood], (0 if call == "long" else 2)
        mix = [m * (1.0 - s) for m in mix]; mix[k] += s
    return mix
def exchange(st):
    dice(st, st.i); A, B, r = st.A, st.B, st.r
    for x in (A, B):
        if x.winded == "new": x.winded = "fight" if x.heart >= 65 else "step"
    style = STYLES[st.case["style"]]; ra, rb, rr = st.r_ex.random(), st.r_ex.random(), st.r_ex.random(); mix = mix_for(st)
    rng = "long" if (st.rnd == 1 and st.i < 2) else ("long" if rr < mix[0] else ("pocket" if rr < mix[0] + mix[1] else "inside"))
    if "step" in (A.winded, B.winded) or st.long_left: rng, st.long_left = "long", (1 if "step" in (A.winded, B.winded) else 0)
    pen = {}
    for me, op, key in ((A, B, "A"), (B, A, "B")):
        me.xl, aim = {k: 0.0 for k in PLACES}, st.aim[key]
        p = me.penalty(op.south) + aim_cost(me, aim, rng) - (WEAK_EDGE if weak(st, me, aim) else 0.0)
        if aim == "head": p -= head_open(op) + (HEAD_BLIND if op.blind(worse_eye(op)) else 0.0)
        if op.change == "elbows" and aim in RIBS: p += GUARD_EDGE * cover_of(op, aim) / COVER_REAR
        elif op.change == "elbows" and aim == "middle": p += GUARD_EDGE * ELBOW_MID
        elif op.change == "gloves" and aim == "head": p += GUARD_EDGE
        if (op.change == "elbows" and aim == "head") or (op.change == "gloves" and aim != "head"): p -= WRONG_GUARD   # the guard left the other door open
        if aim == "head" and st.aim["A" if key == "B" else "B"] == "middle": p -= MIDDLE_DIP
        if not ((op.change == "elbows" and aim != "head") or (op.change == "gloves" and aim == "head")): p -= min(MOMENTUM_MAX, MOMENTUM * st.kept[key])
        if me.habit and rng == me.habit_rng and not (me.fix_on and st.i >= me.fix_from): p += me.habit
        if me.change == "gloves" and rng == "long": p += GLOVES_COST
        if me.winded == "fight": p += WINDED_EDGE * next(m for h, m in HEART_WIND if me.heart >= h)
        elif me.winded == "step": p, me.e = p + STEP_EDGE, me.e + STEP_E
        pen[key] = p
    pen["A"] -= HOME_EDGE if A.home == rng else 0.0; pen["B"] -= st.case.get("their_home", HOME_EDGE) if style[1] == rng else 0.0
    A.e -= CALL_E[st.call] if not (st.rnd == 1 and st.i < 2) else 0.0
    st.stats["ex"] += 1; bl = any(x.blind(e) for x in (A, B) for e in EYES); st.stats["blind"] += bl; st.stats["blind_bout"] |= bl
    margin = st.case.get("gap", 0.0) + pen["B"] - pen["A"] + (ra - rb) * EX_SPREAD; m = abs(margin)
    band = "close" if m < 0.25 * EX_SPREAD else ("dominant" if m >= 0.6 * EX_SPREAD else "clear")
    la, lb = LANDED[band] if margin >= 0 else LANDED[band][::-1]; st.ex_won[0 if margin >= 0 else 1] += 1; st.msum += margin
    for x in (A, B): x.e -= SPEND * BREATH[x.worst(RIBS)] * x.cardio
    for att, dfn, n, key, pd in ((A, B, la, "A", st.case.get("pd_a", 0.0)), (B, A, lb, "B", style[3])):
        for _ in range(n):
            ev = land(st, att, dfn, st.aim[key], rng, pd, False)
            if ev == "liver":
                count(st, dfn, "liver")
                if r.random() < LIVER_STAYS: return finish(st, att is A, "liver")
            elif ev == "winded":
                st.stats["winded"] += 1; st.chip_r = min(st.chip_r, st.rnd)
                if dfn.e < KNEE_E: count(st, dfn, "knee")
                else: dfn.wnext = True
            if dfn.rc >= 3 or dfn.counts >= 4: return finish(st, att is A, "rsc")
    loser = B if margin >= 0 else A
    if st.am and band == "dominant" and loser.winded and r.random() < STANDING_P:
        count(st, loser, "standing")
        if loser.rc >= 3 or loser.counts >= 4: return finish(st, loser is B, "rsc")
    for x in (A, B): x.winded, x.wnext = ("new" if x.wnext else None), False
    st.i += 1

def bell(st):
    dice(st, 50); A, B = st.A, st.B; a_won = st.ex_won[0] > st.ex_won[1] or (st.ex_won[0] == st.ex_won[1] and st.msum >= 0)
    loser, w_n = (B if a_won else A), max(st.ex_won); pd = st.case.get("pd_a", 0.0) if a_won else STYLES[st.case["style"]][3]
    p = min(0.85, BASE_COUNT * MARGIN_F["dominant" if w_n == 6 else ("clear" if w_n == 5 else "close")] * math.exp(pd / 12.0)
            * (1.0 + (100.0 - loser.p["head"]) / HEAD_SCALE))
    n = 0
    while n < 3 and st.r.random() < p: n, p = n + 1, p * 0.6
    st.stats["head_counts"] += n; loser.counts, loser.rc = loser.counts + n, loser.rc + n
    if n and (loser.rc >= 3 or loser.counts >= 4 or st.r.random() < min(0.9, REF_STOP * (1.0 + (100.0 - loser.p["head"]) / 60.0))):
        return finish(st, a_won, "rsc")
    st.won[0 if a_won else 1] += 1; st.mtot += st.msum
    for x in (A, B):
        CAPS["ex"], CAPS["round"] = max(CAPS["ex"], x.max_x), max(CAPS["round"], x.max_r)
        for s in RIBS: x.p[s] = min(100.0, x.p[s] + GIVE_BACK * x.rl[s])
        x.hooks_last, x.hooks, x.rl_last = x.hooks, {k: 0 for k in RIBS}, x.rl
        x.rl, x.rc, x.winded, x.wnext = {k: 0.0 for k in PLACES}, 0, None, False
    st.sore_by[st.rnd] = any(word(x.p[k]) != "fine" for x in (A, B) for k in PLACES)
    if st.sore_by[st.rnd]: st.chip_r = min(st.chip_r, st.rnd)
    if st.fresh and st.am: CAPS["rib_min"] = min([CAPS["rib_min"]] + [x.p[s] for x in (A, B) for s in RIBS])
    st.ex_won, st.msum, st.i, st.long_left = [0, 0], 0.0, 0, 0
    if st.rounds == st.rnd: return finish(st, st.won[0] > st.won[1] or (st.won[0] == st.won[1] and st.mtot >= 0), "points")
    st.rnd, st.phase = st.rnd + 1, "minute"

def read_word(rr, w, dots):   # a sign seen by the corner: right READ_ACC[dots] of the time, else one word off (at the ends: inward)
    if rr.random() < READ_ACC[dots]: return w
    i = WORDS.index(w); return WORDS[1] if i == 0 else (WORDS[2] if i == 3 else WORDS[i + rr.choice((-1, 1))])
def reads(st):   # the corner's reads of THEIR places this minute, the same whatever the player then picks
    rr, d = random.Random(st.seed * 31 + st.rnd), st.case.get("dots", 2)
    return {k: read_word(rr, word(st.B.p[k]), d) for k in PLACES}
def minute(st, pol, harvest):
    A, B = st.A, st.B
    if harvest is not None and live(st): harvest(st)
    dice(st, 70); A.last_change = A.change; A.change = st.force.pop("change", None) or pol["change"](st, A)
    A.fix_on = A.fix_on or (A.change == "fix" and st.r.random() < A.takes * MOOD[A.mood]); A.fix_from = 1 if A.change == "fix" else A.fix_from
    recover(A); B.change = their_change(st, B); st.stats["covers"] += B.change == "elbows"; old_b = st.aim["B"]; st.aim["B"] = their_aim(st, A); recover(B)
    if not st.am:   # pro: the cutman closes one cut (an eye first); amateur seconds have water and a towel
        for x in (A, B): x.closed = set(sorted(x.cuts, key=lambda k: (k == "nose", k))[:1])
    for x in (A, B):
        if st.r.random() < doctor(x): return finish(st, x is B, "doctor")
    new = st.force.pop("aim", None) or pol["aim"](st); st.kept["A"] = st.kept["A"] + 1 if new == st.aim["A"] else 0; st.aim["A"] = new
    st.kept["B"] = st.kept["B"] + 1 if st.aim["B"] == old_b else 0; st.call = st.force.pop("call", None) or pol["call"](st); st.phase = "ex"
def play(case, seed, pol=DEFAULT, harvest=None): return run(new_bout(case, seed), pol, harvest)

# ---------------- what the player sees at the minute (the rule features) ----------------
def tape(st, truth, other, k):   # a habit seen on tape: right READ_ACC[dots] of the time (the same read all bout)
    return truth if random.Random(st.seed * 13 + k).random() < READ_ACC[st.case.get("dots", 2)] else other
def features(st):
    A, B, rd = st.A, st.B, reads(st); side = min(RIBS, key=lambda s: B.p[s]); rside = max(RIBS, key=lambda s: (WORDS.index(rd[s]), s))
    habit = "none" if not A.habit or A.fix_on else "%g at %s" % (A.habit, A.habit_rng)
    return {"their style": st.case["style"], "your skills": st.case["skills"], "your stance": "southpaw" if A.south else "orthodox",
            "their stance": "southpaw" if B.south else "orthodox", "score": "ahead" if st.won[0] > st.won[1] else ("level" if st.won[0] == st.won[1] else "behind"),
            "rounds left": str(st.rounds - st.rnd + 1), "your energy": "under 50" if A.e < 50 else ("50-70" if A.e <= 70 else "over 70"),
            "your Aim": AIMS[st.aim["A"]][2], "their ribs read": "%s %s" % ("liver" if rside == "right_ribs" else "left ribs", rd[rside]),
            "read dots": str(st.case.get("dots", 2)), "their corner (tape)": tape(st, st.case.get("corner"), {"cautious": "stubborn", "stubborn": "cautious"}[st.case.get("corner")], 1),
            "their plan (tape)": tape(st, st.case.get("their_plan"), {"body": "head", "head": "body"}[st.case.get("their_plan")], 2),
            "their range game": "strong" if st.case.get("their_home", HOME_EDGE) > HOME_EDGE else "fair", "their weakness": st.case.get("open"),
            "hooks on one side": "4+" if max(B.hooks_last.values()) >= 4 else "under 4", "their face read": "cut" if B.cuts else max((rd[e] for e in EYES), key=WORDS.index),
            "your ribs": A.worst(RIBS, raw=True), "your face": "cut" if A.cuts else A.worst(CUTTABLE, raw=True), "mood": A.mood, "habit": habit,
            "takes a fix": "%d in 10" % round(10 * A.takes * MOOD[A.mood])}

def population(rounds, n, guard=False, seed0=0):   # a deterministic spread of bouts: every factor varies by seed
    out = []
    for s in range(seed0 + 1, seed0 + n + 1):
        g = random.Random(s * 977 + rounds)
        c = {"style": g.choice(list(STYLES)), "open": g.choice(("ribs", "middle", "head", "none")), "skills": g.choice(list(SKILLS)),
             "a_south": g.random() < 0.3, "south": g.random() < 0.3, "corner": g.choice(("cautious", "stubborn")), "their_plan": g.choice(("body", "head")), "their_home": g.choice((3.0, 9.0)), "plan_aim": g.choice((None, "right_ribs", "left_ribs", "middle", "head")), "mood": g.choice(list(MOOD)),
             "heart": g.choice((50, 60, 70)), "habit": g.choice(HABIT_AT), "habit_rng": g.choice(RANGES), "takes": g.choice((0.5, 0.7, 0.9)),
             "dots": g.choice((1, 2, 3)), "cardio": g.choice(("low", "mid", "high")), "rounds": rounds, "guard": guard,
             "b_start": {g.choice(RIBS): CARRY} if g.random() < 0.2 else None}
        out.append((c, s))
    return out

# ---------------- decisions: play on from each harvested minute with each option ----------------
CUT = {("change", 6)}   # a cell that failed the regret bar after honest tries: cut to the coach's pick (map 4.3)
DEC = {"aim": ("D1 The Aim at the minute", [("right_ribs", "Liver"), ("left_ribs", "Left ribs"), ("middle", "Middle"), ("head", "Head")]),
       "call": ("D2 The range call at the minute", [("long", "Stay long"), ("pace", "Their pace"), ("inside", "Get inside")]),
       "minute": ("D1+D2 The minute: Aim and range call together", [((a, c), "%s, %s" % (al, cl)) for a, al in [("right_ribs", "Liver"), ("left_ribs", "Left ribs"),
                  ("middle", "Middle"), ("head", "Head")] for c, cl in CALLS.items()]),
       "change": ("D3 ONE CHANGE", [("fix", "Fix the habit"), ("elbows", "Elbows in"), ("gloves", "Gloves high")])}
def playon(task):   # one harvested minute: every option on the same dice; returns per option the list of wins and the end state
    snap, key, opts, n, j0 = task; out = {}
    for o, _ in opts:
        wins, extra, stop = [], 0.0, 0
        for j in range(n):
            st = snap.clone(); reseed(st, j0 + 37 * j); st.force = {"aim": o[0], "call": o[1]} if key == "minute" else {key: o}; run(st, DEFAULT)
            wins.append(1 if st.result[0] else 0); stop += st.result[2] != "points" and not st.result[0]
            extra += max(0.0, min(snap.A.p[s] for s in RIBS) - min(st.A.p[s] for s in RIBS)) / HEAL["ribs"] + \
                max(0.0, min(snap.A.p[e] for e in EYES) - min(st.A.p[e] for e in EYES)) / HEAL["eye"]
        out[o] = (wins, extra / n, stop / n)
    return out

def fold(rows, opts, fit, ev, feats):   # value of rules fitted on half `fit`, measured on half `ev`; per case regret vs best play
    best = [max(opts, key=lambda o: w[fit][o]) for _, w in rows]
    val = lambda i, o: rows[i][1][ev][o]
    top = [val(i, best[i]) for i in range(len(rows))]
    common = max(opts, key=lambda o: sum(b == o for b in best))
    res = {"common": [top[i] - val(i, common) for i in range(len(rows))]}
    for fs in feats:
        groups = {}
        for i, (f, _) in enumerate(rows): groups.setdefault(tuple(f[x] for x in fs), []).append(i)
        reg = [0.0] * len(rows)
        for idx in groups.values():
            pick = max(opts, key=lambda o: sum(rows[i][1][fit][o] for i in idx))
            for i in idx: reg[i] = top[i] - val(i, pick)
        res[fs] = reg
    return res
def regret(rows, opts):
    names = list(rows[0][0]); ones, twos = [(x,) for x in names], list(combinations(names, 2))
    a, b = fold(rows, opts, 0, 1, ones + twos), fold(rows, opts, 1, 0, ones + twos)
    mean_se = lambda k: (lambda v: (sum(v) / len(v), (sum((x - sum(v) / len(v)) ** 2 for x in v) / (len(v) - 1) / len(v)) ** 0.5))(
        [(x + y) / 2 for x, y in zip(a[k], b[k])])
    one = min(ones, key=lambda k: mean_se(k)[0]); two = min(twos, key=lambda k: mean_se(k)[0])
    return {"one": (one[0],) + mean_se(one), "two": (" x ".join(two),) + mean_se(two), "common": mean_se("common"),
            "gap": sum(max(w[0][o] + w[1][o] for o in opts) / 2 - min(w[0][o] + w[1][o] for o in opts) / 2 for _, w in rows) / len(rows)}

def constants():
    rows = ("Points | rib hook %g (rear hand x%g), face punch %g, head %g; hooks and uppercuts x%g upstairs; big x%g (%d%% of punches); open cut x%g" % (
                RIB_HIT, REAR_MULT, FACE_HIT, HEAD_HIT, HOOK_HEAD, BIG_MULT, BIG * 100, CUT_MULT),
            "Caps on one place | %d an exchange, %d a round; ribs get back %d%% of the round's loss at the bell" % (CAP_EX, CAP_ROUND, GIVE_BACK * 100),
            "Aim cost long / pocket / inside | lead-hook side %s (less Body hook/40 at long); rear-hand side %s; Middle %s (less Inside fighting/100 off long); "
            "Head %s (less Accuracy/100)" % tuple("/".join("%g" % t[r] for r in RANGES) for t in (LEAD_COST, REAR_COST, MID_COST, HEAD_COST)),
            "Range | at a boxer's home range +%g (yours by skills: head-hunter long, body puncher pocket, inside man inside); theirs 3 (fair) or 9 (strong) "
            "at their style's home; a call moves %d%% of the mix x trust (Fired up 1.05 ... Low 0.7); energy %g / %g an exchange (Stay long / Get inside)" % (
                HOME_EDGE, CALL_SHIFT * 100, CALL_E["long"], CALL_E["inside"]),
            "Their guard | met by the Aim it was set for: +%g to them (rib Aims x the side's cover / %g; Middle x%g); the wrong guard: +%g to you" % (
                GUARD_EDGE, COVER_REAR, ELBOW_MID, WRONG_GUARD),
            "Elbows in | hooks covered %d%% on the rear side, %d%% on the lead side; %d%% of covered hooks die, the rest ride up to that eye; "
            "own rib hooks x%g and +%g on a rib Aim" % (COVER_REAR * 100, COVER_LEAD * 100, COVER_BLOCK * 100, ELBOW_OWN, ELBOW_COST),
            "Gloves high | face and head x%g, a blind side costs half; ribs x%g; their body share +%g; -%g at long" % (GLOVES_FACE, GLOVES_RIB, GLOVES_BODY, GLOVES_COST),
            "Kept Aim | +%g edge a round kept, at most +%g, none while their guard meets it" % (MOMENTUM, MOMENTUM_MAX),
            "Head after the body | Head +%g while their worse rib side IS sore, +%g hurt; +%g more while their elbows are in; none under Gloves high; "
            "the worse eye takes %d%% of face punches, +%g on a blind side; Middle dips your head: +%g to their Head" % (
                HEAD_OPEN["sore"], HEAD_OPEN["hurt"], HEAD_OPEN_ELBOWS, HEAD_EYE * 100, HEAD_BLIND, MIDDLE_DIP),
            "Liver drop, a big LEFT hook on the right ribs | fine %g%%, sore %g%%, hurt %g%%, injured %g%% x e^((power-durability)/12), max %d%%; ice x%g; "
            "stays down %d in 100" % tuple([LIVER_P[w] * 100 for w in WORDS] + [LIVER_MAX * 100, ICE_LIVER, LIVER_STAYS * 100]),
            "Breath | spend x%g sore, x%g hurt; each water point -%g sore, -%g hurt (a water point +6 under 40, +3 at 40-60, +2 over 60)" % (
                BREATH["sore"], BREATH["hurt"], WATER_RIB["sore"], WATER_RIB["hurt"]),
            "Their corner | guards on the cue %d in 100 (cautious) / %d (stubborn), +%d a hook past 3, max %d; goes round your guard or after your "
            "damage %d / %d in 100" % (CORNER["cautious"] * 100, CORNER["stubborn"] * 100, CORNER_STEP * 100, CORNER_MAX * 100, THEY_WORK["cautious"] * 100, THEY_WORK["stubborn"] * 100),
            "Open habit | %s edge in each exchange at its one range; the fix takes Coachability (5/7/9 in 10) x trust, from the 2nd exchange" % "/".join("%g" % h for h in HABIT_AT[1:]),
            "A read | right %d / %d / %d in 100 at 1 / 2 / 3 dots, else one word off (inward at the ends); tape habits the same" % tuple(READ_ACC[d] * 100 for d in (1, 2, 3)),
            "WINDED, counts, cuts | WINDED %d%% a big straight body punch x e^(pd/12), knee under %d energy, standing count %d%% (amateur); bell count "
            "%d%% x (0.3 / 1 / 2.2 for 4-2 / 5-1 / 6-0) x e^(pd/12) x (1 + (100 - HEAD)/%g), each extra x0.6; after a count the referee stops %g x (1 + (100 - HEAD)/60); "
            "cut %.1f%% a big punch on an eye or the nose" % (WINDED_P * 100, KNEE_E, STANDING_P * 100, BASE_COUNT * 100, HEAD_SCALE, REF_STOP, CUT_P * 100))
    print("### Constants (TUNE)\n\n| Constant | Value |\n|---|---|\n" + "\n".join("| %s |" % r for r in rows) + "\n")

def main():
    t0, jobs = time.time(), int(sys.argv[sys.argv.index("--jobs") + 1]) if "--jobs" in sys.argv else 4
    print("# DAMAGE FIGHT numbers (tools/damage_fight_numbers.py, round 3)\n")
    check(abs(win_p(0.0) - 0.5) < 1e-12, "level edge is a coin"); check(all(win_p(a) < win_p(a + 1) for a in range(-60, 60)), "edge buys exchanges")
    print("One edge point in one exchange = %.2f%% of a 3-round bout at level (100/66 x exchange pivot 0.3125 x round pivot 0.5); 4 rounds %.2f%%, 6 rounds %.2f%%.\n"
          % (k_edge(3), k_edge(4), k_edge(6)))
    constants(); c0 = population(3, 1)[0][0]; check(play(c0, 5).result == play(c0, 5).result, "deterministic")
    # ---- how often it meets the player, and the harvest of minutes ----
    cols, pops, cand = (("am", 3, False), ("women", 3, True), ("pro4", 4, False), ("pro6", 6, False)), {}, {3: [], 4: [], 6: []}
    for name, rounds, guard in cols:
        tot = {}
        for c, s in population(rounds, 2000, guard):
            keep = []
            st = play(c, s, harvest=None if guard else (lambda x: keep.append(x.clone())))
            for snap in keep: cand[rounds].append((features(snap), snap))
            for k, v in list(st.stats.items()) + [("bouts", 1), ("sore2", st.sore_by.get(1, False) or st.sore_by.get(2, False)), ("chip2", st.chip_r <= 2),
                    ("stops", st.result[2] != "points"), ("liver_end", st.result[2] == "liver"), ("doctor", st.result[2] == "doctor"),
                    ("cut_bout", st.stats["cuts"] > 0), ("liver_bout", st.stats["liver"] > 0), ("winded_bout", st.stats["winded"] > 0),
                    ("ends_sore", st.result[2] == "points" and st.A.worst(RIBS, raw=True) != "fine")]:
                tot[k] = tot.get(k, 0) + v
        pops[name] = tot
    nb = pops["am"]["bouts"]; per = lambda c, k: 100.0 * pops[c][k] / pops[c]["bouts"]
    print("### How often it meets the player (%d bouts a column; style, weakness, skills, stances, their corner, mood, Heart, habit, dots, cardio "
          "and a carried rib on their side (1 in 5) all vary by seed)\n" % nb)
    print("| Per 100 bouts | Amateur 3x3 | Amateur women (headguards) | Pro debut 4 | Pro 6 | On amateur screens |\n|---|---|---|---|---|---|")
    rows_f = (("sore2", "A place on either boxer sore or worse by the bell of round 2"), ("chip2", "A chip (sore place or WINDED) before round 3"),
              ("winded_bout", "Bouts with a WINDED"), ("knee", "... knees (WINDED under 45 energy)"), ("standing", "Standing counts"),
              ("liver_bout", "Bouts with a LIVER DROP"), ("head_counts", "Head counts at the bell"), ("cut_bout", "Bouts with a cut"),
              ("blind_bout", "Bouts with a BLIND SIDE"), ("covers", "Their corner's Elbows in (minutes)"), ("stops", "Stoppages (all kinds)"),
              ("liver_end", "... by a liver drop"), ("doctor", "... by the doctor"))
    tags = {}
    for k, label in rows_f:
        tags[k] = "shown" if per("am", k) >= 5.0 or k in ("sore2", "chip2", "covers", "stops", "liver_end", "head_counts") else "PRO ONLY (under 5)"
        print("| %s | %s | %s |" % (label, " | ".join("%.1f" % per(c, k) for c, _, _ in cols), tags[k]))
    print("| Exchanges with a BLIND SIDE open (per 100 exchanges) | %s | |" % " | ".join("%.1f" % (100.0 * pops[c]["blind"] / pops[c]["ex"]) for c, _, _ in cols))
    print("\nHand-over: %.0f%% of amateur bouts that go the distance end with your rib side sore or worse." % (100.0 * pops["am"]["ends_sore"] / nb))
    check(per("am", "chip2") >= 35.0, "a chip before round 3 in 35+ of 100 amateur bouts")
    check(5.0 <= per("am", "stops") <= 12.0, "amateur stoppages 5-12 per 100 bouts (REAL, J-KDRATES1)")
    check(per("am", "liver_bout") >= 5.0, "the liver drop is on amateur screens, so it happens in 5+ of 100 amateur bouts")
    check(CAPS["ex"] <= CAP_EX + 1e-9 and CAPS["round"] <= CAP_ROUND + 1e-9, "caps 10 an exchange, 30 a round")
    check(CAPS["rib_min"] > INJURED_AT, "a fresh rib cannot reach injured in a 3-round bout")
    print("Caps held: most off one place in one exchange %.1f (cap %d), in one round %.1f (cap %d); lowest fresh amateur rib %.0f (the floor the caps allow: 23.5)."
          % (CAPS["ex"], CAP_EX, CAPS["round"], CAP_ROUND, CAPS["rib_min"]))
    # ---- the minute decisions, per bout length ----
    quick = "--quick" in sys.argv; LENS = (3,) if quick else (3, 4, 6)
    SIZE = {"aim": (32, 240), "call": (32, 240), "minute": (48, 320), "minute 3": (96, 240), "change": (64, 400)}   # minutes harvested, play-ons per option
    pick, tasks, meta = random.Random(4383), [], []
    for rounds in LENS:
        for key, (title, opts) in DEC.items():
            if key in ("aim", "call") and rounds != 3: continue   # scored alone only to show why they are one pick
            pool = [x for x in cand[rounds] if key != "change" or (x[1].A.habit and not x[1].A.fix_on) or x[1].A.worst(RIBS + CUTTABLE, raw=True) != "fine"]
            m, n = SIZE.get("%s %d" % (key, rounds), SIZE[key])
            for f, snap in pick.sample(pool, min(m, len(pool))):
                tasks.append((snap, key, DEC[key][1], n, 700001)); meta.append((rounds, key, f, snap))
    for (rounds, key, f, snap) in [m for m in meta if m[0] == 3 and m[1] in ("minute", "change")]:   # the coach's forecast, from what the corner reads
        for k in (("aim", "call") if key == "minute" else ("change",)):
            tasks.append((belief(snap), k, DEC[k][1], 120, 900001)); meta.append((rounds, "coach " + k, f, snap))
    with Pool(jobs) as pool_: outs = pool_.map(playon, tasks, chunksize=4)
    print("\n## The decisions: regret, not shares (minutes harvested / play-ons per option on shared dice: %s; "
          "split in two halves; best play = the option best on one half, valued on the other)\n" % ", ".join("%s %d / %d" % (k, m, n) for k, (m, n) in SIZE.items()))
    print("| Decision | Bout | Gap best-worst | Best ONE-THING rule | It loses (win pts in 100, +/- SE) | Always the most common option | Best TWO-THING rule | It loses |\n"
          "|---|---|---|---|---|---|---|---|")
    def rows_of(rounds, key, opts):
        return [(f, [{o: 100.0 * sum(out[o][0][h::2]) / len(out[o][0][h::2]) for o, _ in opts} for h in (0, 1)], out, snap)
                for (r_, k_, f, snap), out in zip(meta, outs) if r_ == rounds and k_ == key]
    table = {}
    for key, (title, opts) in DEC.items():
        for rounds in LENS:
            if key in ("aim", "call") and rounds != 3: continue
            full = rows_of(rounds, key, opts); g = regret([(f, w) for f, w, _, _ in full], [o for o, _ in opts]); table[(key, rounds)] = (g, full, opts)
            print("| %s | %dx3 | %.1f | %s | %.1f +/- %.1f | %.1f +/- %.1f | %s | %.1f +/- %.1f |" % (title, rounds, g["gap"], g["one"][0], g["one"][1], g["one"][2],
                  g["common"][0], g["common"][1], g["two"][0], g["two"][1], g["two"][2]))
    for key, (title, opts) in DEC.items():
        print("\n%s, best option in (all play-ons): " % title + "; ".join("%dx3 " % r + ", ".join("%s %d" % (lab, sum(
            1 for f, w, _, _ in table[(key, r)][1] if max(opts, key=lambda oo: w[0][oo[0]] + w[1][oo[0]])[0] == o)) for o, lab in opts)
            for r in LENS if (key, r) in table))
    bars = []   # (holds, what): every regret bar on a scored cell is an assert
    for (key, rounds), (g, _, _) in table.items():
        if key in ("aim", "call") or (key, rounds) in CUT: continue
        bars += [(g["one"][1] >= 2.5, "%s %dx3: the best one-thing rule (%s) loses 2.5+ (it loses %.1f)" % (DEC[key][0], rounds, g["one"][0], g["one"][1])),
                 (g["common"][0] >= 3.0, "%s %dx3: always the most common option loses 3+ (it loses %.1f)" % (DEC[key][0], rounds, g["common"][0]))]
    fails = [w for ok, w in bars if not ok]
    for kr in sorted(CUT & set(table)):
        print("\nCUT: %s in %dx3 bouts (its best one-thing rule loses only %.1f): the screen shows the coach's pick there, not a choice." % (DEC[kr[0]][0], kr[1], table[kr][0]["one"][1]))
    print("\nREGRET BARS on the scored decisions (the minute, ONE CHANGE; one-thing rule 2.5+, always-the-most-common 3+): "
          + ("all met." if not fails else "NOT MET: " + "; ".join(fails)))
    # ---- the coach's forecast: what pressing the coach's best % costs ----
    print("\n### The coach's % (played from the corner's reads: place words at their middle value, their plan and corner as read on tape)\n")
    print("| Decision (3x3) | Minutes | Press the coach's best %: it loses (win pts in 100, +/- SE) | The coach's pick is the best play |\n|---|---|---|---|")
    est = {(k_, id(snap)): out for (r_, k_, f, snap), out in zip(meta, outs) if k_.startswith("coach ")}
    def coach_pick(key, snap):   # the best %% on each row: the Aim row (at their pace) and the range row (with the Aim kept) are forecast apart
        best = lambda k: max((o for o, _ in DEC[k][1]), key=lambda o: sum(est[("coach " + k, id(snap))][o][0]))
        return (best("aim"), best("call")) if key == "minute" else best("change")
    for key in ("minute", "change"):
        opts = [o for o, _ in DEC[key][1]]; loss, hit = [], 0
        for f, w, out, snap in table[(key, 3)][1]:
            c, l = coach_pick(key, snap), 0.0
            for fit, ev in ((0, 1), (1, 0)): l += (w[ev][max(opts, key=lambda o: w[fit][o])] - w[ev][c]) / 2
            loss.append(l); hit += c == max(opts, key=lambda o: w[0][o] + w[1][o])
        m = sum(loss) / len(loss); se = (sum((x - m) ** 2 for x in loss) / (len(loss) - 1) / len(loss)) ** 0.5
        print("| %s | %d | %.1f +/- %.1f | %d in 100 |" % (DEC[key][0], len(loss), m, se, round(100 * hit / len(loss))))
        bars.append((m >= 2.5, "%s 3x3: pressing the coach's best %% loses 2.5+ (it loses %.1f)" % (DEC[key][0], m)))
    # ---- retire, priced ----
    print("\n### Retire your boxer, priced (from the minute play-ons that keep the Aim at their pace; days = extra rib and eye points lost / the after map's healing a day)\n")
    print("| Bout | Minutes | Win if he goes on (mean) | Minutes with a win chance under 15 | ... of those, stopped anyway | Healing days saved by retiring there |\n|---|---|---|---|---|---|")
    for rounds in LENS:
        low, allw = [], []
        for f, w, out, snap in table[("minute", rounds)][1]:
            wins, days, stop = out[(snap.aim["A"], "pace")]; wr = 100.0 * sum(wins) / len(wins); allw.append(wr)
            if wr < 15.0: low.append((stop, days))
        print("| %dx3 | %d | %.0f | %d | %s | %s |" % (rounds, len(allw), sum(allw) / len(allw), len(low), "%.0f in 100" % (100 * sum(x[0] for x in low) / len(low)) if low else "-",
              "%.1f" % (sum(x[1] for x in low) / len(low)) if low else "-"))
    played(table)
    if not quick:
        for ok, what in bars: check(ok, what)
    print("\nASSERTS: %d passed. Seconds: %.0f. Not modelled: calls and modes, set-ups, plan lines, PRESSURE, the 3D, a mid-round switch, Tie up." % (ASSERTS[0], time.time() - t0))

def belief(snap):   # the corner's picture of the bout: their places as the read words' middle values, their habits as read on tape
    b, rd, f = snap.clone(), reads(snap), features(snap)
    for k in PLACES[1:]: b.B.p[k] = MIDS[rd[k]]
    b.case = dict(snap.case, corner="still", their_plan=f["their plan (tape)"]); return b   # priced as if their corner changes nothing

def played(table):   # section "A minute, played": one 3x3 minute after round 2, level at one round each
    g, full, opts = table[("minute", 3)]
    f, w, out, snap = next((x for x in full if x[3].rnd == 3 and x[3].won == [1, 1] and x[3].A.habit and not x[3].A.fix_on), full[0])
    rd, n, res = reads(snap), 1000, {}
    for key, o in [("aim", a) for a, _ in DEC["aim"][1]] + [("call", c) for c, _ in DEC["call"][1]] + [("change", c) for c, _ in DEC["change"][1]]:
        wins = 0
        for j in range(n):
            st = snap.clone(); reseed(st, 300001 + 37 * j); st.force = {key: o}; run(st, DEFAULT); wins += st.result[0]
        res[(key, o)] = 100.0 * wins / n
    print("\n### A minute, played (3x3, the minute before round 3, one round each; %d play-ons an option)\n" % n)
    print("Screen: " + "; ".join("%s: %s" % kv for kv in f.items()))
    print("Your places: " + ", ".join("%s %d %s" % (k, round(snap.A.p[k]), word(snap.A.p[k])) for k in PLACES) + "; energy %d." % round(snap.A.e))
    print("Their places as read (%d dots): " % snap.case.get("dots", 2) + ", ".join("%s %s" % (k, rd[k]) for k in PLACES[1:]) +
          ". The truth: " + ", ".join("%s %d" % (k, round(snap.B.p[k])) for k in PLACES[1:]) + "; their energy %d." % round(snap.B.e))
    keep = res[("aim", snap.aim["A"])]
    print("Win if nothing changes (keep %s, their pace, the coach's default change): %.0f." % (AIMS[snap.aim["A"]][2], keep))
    for key in ("aim", "call", "change"):
        print("- %s: " % {"aim": "Aim", "call": "Range call", "change": "ONE CHANGE"}[key] + ", ".join("%s %.0f (%+.0f)" % (lab, res[(key, o)], res[(key, o)] - keep)
              for o, lab in DEC[key][1]))
    wins, days, stop = out[(snap.aim["A"], "pace")]
    print("- Retire: win 0 (%+.0f); saves %.1f healing days on average; he is stopped anyway %.0f in 100 if he goes on." % (-keep, days, 100 * stop))

if __name__ == "__main__": main()
