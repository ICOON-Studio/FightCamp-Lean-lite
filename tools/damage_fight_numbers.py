#!/usr/bin/env python3
"""DAMAGE FIGHT numbers (S438, round 2): every number table in ops/research/DAMAGE_FIGHT_MAP_S438.md comes from here.
Stdlib only, deterministic (fixed seeds), prints markdown, ASSERTS the caps, the rules and that no decision is a lookup. A small model of
the fight half: six exchanges a round (Exchanges.settle margin, 4-3 / 5-2 / 6-1 landed), a place per landed punch, places change the next
exchanges, counts at the bell and inside an exchange. D2-D4 are scored on moments HARVESTED from simulated bouts (never hand-picked
starts), played on from that moment with each option. A design probe, not the game: the build re-measures every TUNE number on the real
Exchanges / Duels. Run: python tools/damage_fight_numbers.py   (about three and a half minutes)
"""
import copy, itertools, math, random

ASSERTS = [0]
def check(cond, what):
    ASSERTS[0] += 1; assert cond, what

# ---------------- constants (map section 6.1) ----------------
EX_SPREAD, EXCHANGES, LANDED = 66.0, 6, {"close": (4, 3), "clear": (5, 2), "dominant": (6, 1)}   # CODE Exchanges.gd:14, 10, 296
PLACES, WORDS = ["head", "left_eye", "right_eye", "nose", "left_ribs", "right_ribs"], ["fine", "sore", "hurt", "injured"]   # CODE BodyMap.gd:5
EYES, RIBS, CUTTABLE = ("left_eye", "right_eye"), ("left_ribs", "right_ribs"), ("left_eye", "right_eye", "nose")
SORE_AT, HURT_AT, INJURED_AT, BIG, BIG_MULT = 55, 35, 15, 0.15, 2.0   # CODE BodyMap.gd:8-10, 16
RIB_HIT, FACE_HIT, HEAD_HIT, HOOK_HEAD, CUT_MULT = 6.0, 1.0, 0.55, 1.5, 1.5   # TUNE rib 4-6 (code 1.5)
CAP_EX, CAP_ROUND, GIVE_BACK, CARRY_VALUE = 10.0, 30.0, 0.15, 70.0
SPEND, BODY_ENERGY, TIRED_FROM, TIRED_EDGE = 2.0, 1.2, 65.0, 10.0   # edge lost = 10 x (65 - energy) / 65 under 65
WATER, ICE_BACK = ((40.0, 6.0), (60.0, 3.0), (999.0, 2.0)), 0.15   # a water point under 40 / 40-60 / over 60; ice: 15% more of the loss back
BREATH, CEILING = {"sore": 1.25, "hurt": 1.4, "injured": 1.4}, {"sore": 95.0, "hurt": 90.0, "injured": 90.0}   # spend x; the most water brings back to
BLIND_POWER, BLIND_JAB, CUT_P, NOSE_WATER, HEADGUARD_FACE, HEADGUARD_CUT = 4.0, 2.0, 0.012, 0.75, 0.6, 0.5
WINDED_P, WINDED_EDGE, KNEE_E, STANDING_P = 0.14, 16.0, 45.0, 0.35   # standing count: amateur, a WINDED boxer loses an exchange dominantly
TIE_EDGE, WARN_P, CLINCH_DIG, STEP_EDGE, STEP_E = 9.0, 0.30, 3.0, 8.0, 3.0
HEART_WIND = ((65, 0.5), (55, 0.75), (0, 1.0))     # Fight through: WINDED x by Heart 65+ / 55-64 / under 55
LIVER_P = {"fine": 0.01, "sore": 0.05, "hurt": 0.10, "injured": 0.18}   # a big LEFT hook landing on the right ribs
LIVER_STAYS_DOWN, BASE_COUNT, REF_STOP, HEAD_SCALE, MARGIN_F = 0.5, 0.05, 0.2, 15.0, {"close": 0.3, "clear": 1.0, "dominant": 2.2}   # Knockdowns.gd:10
DOC_PLACE, DOC_CUT, DOC_CLOSED = 0.28, 0.08, 0.02
COVER_MOVE, COVER_BLOCK, COVER_DROP, COVER_OWN = 0.7, 0.6, 0.2, 1.0   # covered hooks: 60% on the elbows, the rest ride up to the head
COVER_BASE, COVER_STEP, COVER_MAX, THEY_WORK = {"rarely": 0.10, "often": 0.30}, 0.10, 0.70, 0.6   # their corner works your damage 6 in 10
GLOVES_FACE, GLOVES_RIB, GLOVES_BODY, HABITS = 0.5, 1.2, 0.15, (0.0, 0.6, 1.1, 2.2)   # a habit: edge over a mix, all of it at ITS range (/ 0.33)
OPEN_EDGE, WEAK_MULT, WEAK_WIND = 0.5, 1.1, 1.1     # the Aim at their WEAKNESS, with the weapon for it: +0.5 edge, its punches x1.1
WEAPON = {"ribs": (0, 40), "body": (1, 50), "head": (2, 50)}   # the skill that opens it: Body hook mastery 40 / Inside fighting 50 / Accuracy 50
HEAD_OPENED = {"fine": 0.0, "sore": 3.0, "hurt": 4.0, "injured": 4.0}   # Head Aim edge while their worse rib side reads that
RIBS_LEFT, REAR_HOOK, READ_ACC = 0.75, 1.0, {1: 0.55, 2: 0.70, 3: 0.85}   # a Ribs Aim throws the left (liver) hook 3 in 4; +1 when it is the rear hand
RANGES, MID = ["long", "pocket", "inside"], {"long": 0.8, "pocket": 0.35, "inside": 0.25}
HEAD_MIX = {"long": (0.6, 0.4, 0.0), "pocket": (0.25, 0.35, 0.3), "inside": (0.05, 0.2, 0.45)}
AIMS = {"own": (0.20, 0.0, "Own game"), "head": (0.08, 0.0, "Head"), "body": (0.45, 0.35, "Body"), "ribs": (0.45, -0.25, "Ribs")}
BODY_COST, RIB_COST = {"long": 0.5, "pocket": 1.5, "inside": 2.5}, {"long": 3.0, "pocket": 0.5, "inside": 0.5}
STYLES = {"out-boxer": ((0.6, 0.3, 0.1), "body", -4.0), "pressure": ((0.2, 0.4, 0.4), "ribs", 0.0),
          "counter": ((0.5, 0.4, 0.1), "own", 0.0), "slugger": ((0.25, 0.45, 0.3), "head", 6.0)}
SKILLS = {"head-hunter": (10, 30, 85), "body puncher": (80, 50, 40), "inside man": (30, 85, 50), "average": (40, 50, 50)}
CARDIO, CAPS = {"low": 1.15, "mid": 1.0, "high": 0.85}, {"ex": 0.0, "round": 0.0, "rib_min": 100.0}
DECIDING, CLEAR = 2.5, 1.5   # a moment matters at 2.5+ win points best to worst; a case is CLEAR when its best beats every other by 1.5+

def word(v):   # the shown number and its word agree: 55.4 shows 55 and reads sore
    v = math.floor(v + 0.5)
    return "fine" if v > SORE_AT else ("sore" if v > HURT_AT else ("hurt" if v > INJURED_AT else "injured"))
def better(w): return WORDS[max(0, WORDS.index(w) - 1)]
def win_p(d):   # P(win one exchange | edge d): the triangular margin of Exchanges.settle
    x = max(-1.0, min(1.0, d / EX_SPREAD))
    return 1.0 - 0.5 * (1.0 - x) ** 2 if x >= 0 else 0.5 * (1.0 + x) ** 2
def k_edge(rounds=3):   # bout win % per edge point in one exchange at level: slope x exchange pivot (0.3125) x round pivot (0.5)
    return 100.0 / EX_SPREAD * (0.5 * 20.0 / 32.0) * (math.comb(rounds - 1, (rounds - 1) // 2) / 2.0 ** (rounds - 1))

class Boxer:
    def __init__(s, south, places=None, e=100.0, heart=60, cardio=1.0, skills="average", habit=(0.0, "pocket", 0.7), guard=False):
        s.south, s.e, s.heart, s.cardio, s.guard, (s.habit, s.habit_rng, s.takes) = south, e, heart, cardio, guard, habit
        s.fix_on, (s.hook_m, s.inside, s.acc), s.p = False, SKILLS[skills], {k: 100.0 for k in PLACES}; s.p.update(places or {})
        s.cuts, s.closed, s.ice = set(), set(), set(); s.counts = s.rc = s.warned = s.pts_off = 0; s.change, s.winded, s.wnext = "none", None, False
        s.hooks, s.hooks_last = {k: 0 for k in RIBS}, {k: 0 for k in RIBS}
        s.rl, s.xl, s.max_x, s.max_r = {k: 0.0 for k in PLACES}, {k: 0.0 for k in PLACES}, 0.0, 0.0
    def band(s, k):   # the word a place's JOB reads: ice makes a rib side one word better for the round
        return better(word(s.p[k])) if k in s.ice else word(s.p[k])
    def worst(s, places, raw=False):
        return WORDS[max(WORDS.index(word(s.p[k]) if raw else s.band(k)) for k in places)]
    def hit(s, k, pts):
        pts *= CUT_MULT if (k in s.cuts and k not in s.closed) else 1.0; pts = max(0.0, min(pts, CAP_EX - s.xl[k], CAP_ROUND - s.rl[k], s.p[k]))
        s.p[k], s.xl[k], s.rl[k] = s.p[k] - pts, s.xl[k] + pts, s.rl[k] + pts; s.max_x, s.max_r = max(s.max_x, s.xl[k]), max(s.max_r, s.rl[k])
        if k in CUTTABLE and s.p[k] <= HURT_AT: s.cuts.add(k)
    def blind(s, eye):
        return s.band(eye) in ("hurt", "injured") or (eye in s.cuts and eye not in s.closed)
    def penalty(s, opp_south):   # edge lost to her own places and tiredness (WINDED answers are added in the exchange)
        power_eye = "right_eye" if opp_south else "left_eye"            # their rear hand lands on this eye
        pen = sum((BLIND_POWER if eye == power_eye else BLIND_JAB) for eye in EYES if s.blind(eye))
        return pen + (TIRED_EDGE * (TIRED_FROM - s.e) / TIRED_FROM if s.e < TIRED_FROM else 0.0)
    def breath(s): return BREATH.get(s.worst(RIBS), 1.0)

def aim_cost(me, aim, rng):   # what the Aim costs this exchange, lowered by the boxer's own skills
    if aim == "ribs": return max(0.5, RIB_COST[rng] - (me.hook_m / 40.0 if rng == "long" else 0.0)) + (REAR_HOOK if me.south else 0.0)
    if aim == "body": return max(0.5, BODY_COST[rng] - (me.inside / 50.0 if rng != "long" else 0.0))
    return max(0.0, 1.2 - me.acc / 80.0) if aim == "head" else 0.0
def weak(st, me, aim):   # your Aim goes where their file says they are open, and you have the weapon for it (their cover shuts ribs)
    if me is not st.A or aim != st.case.get("open") or (aim == "ribs" and st.B.change == "cover"): return False
    return (me.hook_m, me.inside, me.acc)[WEAPON[aim][0]] >= WEAPON[aim][1]
def read(st, w):   # the corner's read of a sign: right READ_ACC[dots] of the time, else one word off
    if st.r.random() < READ_ACC[st.case.get("dots", 2)]: return w
    return WORDS[min(3, max(0, WORDS.index(w) + st.r.choice((-1, 1))))]
def hit_face(st, dfn, k, km, big, wk):
    f = (GLOVES_FACE if dfn.change == "gloves" else 1.0) * (HEADGUARD_FACE if dfn.guard else 1.0) * (WEAK_MULT if wk else 1.0)
    dfn.hit(k, FACE_HIT * km * f); dfn.hit("head", HEAD_HIT * km * f)
    if big and k not in dfn.cuts and st.r.random() < CUT_P * (HEADGUARD_CUT if dfn.guard else 1.0) * (2.0 if wk else 1.0):
        dfn.cuts.add(k); st.stats["cuts"] += 1

def land(st, att, dfn, aim, rng, pd, no_big):   # one landed punch: returns 'liver' / 'winded' / None
    r, (body, mid, _), wk = st.r, AIMS[aim], weak(st, att, aim); big = r.random() < BIG and not no_big
    mult, lead_left = (BIG_MULT if big else 1.0), not att.south
    if r.random() < body * (COVER_OWN if att.change == "cover" else 1.0) + (GLOVES_BODY if dfn.change == "gloves" else 0.0):
        dfn.e -= BODY_ENERGY * (WEAK_WIND if wk and aim == "body" else 1.0)
        if r.random() < min(0.95, max(0.05, MID[rng] + mid)):             # down the middle: the solar plexus
            p = WINDED_P * math.exp(pd / 12.0) * (WEAK_WIND if wk and aim == "body" else 1.0)
            return "winded" if big and r.random() < p else None
        left = r.random() < (RIBS_LEFT if aim == "ribs" else (0.6 if lead_left else 0.4))   # unaimed: 60% the lead hook
        side = "right_ribs" if left else "left_ribs"                     # a left hook lands on the right ribs (the liver)
        dfn.hooks[side] += 1
        if dfn.change == "cover" and r.random() < COVER_MOVE:   # the elbows take most covered hooks; the rest ride up to the head
            if r.random() >= COVER_BLOCK: hit_face(st, dfn, "right_eye" if left else "left_eye", HOOK_HEAD * mult, big, False)   # a left hand finds the right eye
            return None
        step = dfn.winded == "step"
        dfn.hit(side, RIB_HIT * mult * (GLOVES_RIB if dfn.change == "gloves" else 1.0) * (0.5 if step else 1.0) * (WEAK_MULT if wk else 1.0))
        if left and big and not step:
            p = min(0.30, LIVER_P[dfn.band("right_ribs")] * math.exp(pd / 12.0)) * (COVER_DROP if dfn.change == "cover" else 1.0)
            if r.random() < p: return "liver"
        return None
    (jab, cross, hook), x = HEAD_MIX[rng], r.random()
    kind = "jab" if x < jab else ("cross" if x < jab + cross else ("hook" if x < jab + cross + hook else "upper"))
    if aim == "head" and kind in ("jab", "cross") and r.random() < 0.5:
        kind = "hook" if kind == "jab" else "upper"                       # Head: half the straight shots turn into hooks / uppercuts
    eye = "right_eye" if ((kind in ("jab", "hook")) == lead_left) else "left_eye"   # a left hand finds the right eye
    face = ("nose" if r.random() < (0.6 if kind == "jab" else 0.5) else eye) if kind in ("jab", "cross") else (eye if kind == "hook" else "nose")
    hit_face(st, dfn, face, (HOOK_HEAD if kind in ("hook", "upper") else 1.0) * mult, big, wk and aim == "head")
    return None

# ---------------- corners: the default (sensible) choices; each decision overrides one ----------------
def aim_default(st): return {"ribs": "ribs", "body": "body", "head": "head"}.get(st.case.get("open"), "own")
def change_default(st, me):   # ONE CHANGE: cover when 4+ hooks landed on one side and it is sore; else the habit fix when one is open
    if max(me.hooks_last.values()) >= 4 and me.worst(RIBS, raw=True) != "fine": return "cover"
    return "fix" if me.habit else "none"
def ice_default(st, me):
    side = min(RIBS, key=lambda s: me.p[s])
    return [side] if word(me.p[side]) != "fine" and me.e >= 50.0 else []
def winded_default(st, me): return "fight" if me.heart >= 65 else "step"   # the boxer's own answer (6.5)
DEFAULT = {"aim": aim_default, "change": change_default, "ice": ice_default, "winded": winded_default}
def their_change(st, me):   # their corner covers by a habit on the file, more often the more hooks it took
    p = min(COVER_MAX, COVER_BASE[st.case.get("cover", "rarely")] + COVER_STEP * max(0, max(me.hooks_last.values()) - 3))
    return "cover" if st.r.random() < p else "none"
def their_aim(st, you):   # their corner works your damage 6 times in 10 (a cut or sore face -> Head, a sore rib side -> Ribs), else their style's Aim
    if (you.cuts or you.worst(CUTTABLE, raw=True) != "fine") and st.r.random() < THEY_WORK: return "head"
    return "ribs" if you.worst(RIBS, raw=True) != "fine" and st.r.random() < THEY_WORK else STYLES[st.case["style"]][1]
def recover(me, sides):
    me.ice = set(sides)
    for s in sides: me.p[s] = min(100.0, me.p[s] + ICE_BACK * me.rl_last[s])
    per = next(w for top, w in WATER if me.e < top) * (NOSE_WATER if ("nose" in me.cuts and "nose" not in me.closed) else 1.0)
    me.e = max(me.e, min(CEILING.get(me.worst(RIBS, raw=True), 100.0), me.e + (3 - len(sides)) * per))
def cutman(st, me):   # pro only: ONE job, close a cut (an eye cut first); amateur seconds have water and a towel
    me.closed = set(sorted(me.cuts, key=lambda k: (k == "nose", k))[:1]) if not st.am else set()
def doctor(me):
    p = DOC_PLACE if min(me.p[k] for k in ("head",) + CUTTABLE) <= INJURED_AT else 0.0
    return max([p] + [DOC_CLOSED if k in me.closed else DOC_CUT for k in me.cuts])

# ---------------- the bout ----------------
class St: pass
def new_bout(case, seed, start=None):
    start, st = start or {}, St(); st.case, st.rounds = case, case.get("rounds", 3); st.am = st.rounds == 3
    st.A = Boxer(False, start.get("a"), heart=case.get("heart", 60), skills=case.get("skills", "average"),
                 habit=(case.get("habit", 0.0), case.get("habit_rng", "pocket"), case.get("takes", 0.7)), guard=case.get("guard", False))
    st.B = Boxer(case.get("south", False), case.get("b_start"), cardio=CARDIO[case.get("cardio", "mid")], guard=case.get("guard", False))
    st.rnd, st.i, st.phase, st.won, st.ex_won, st.msum, st.mtot, st.long_left = 1, 0, "ex", [0, 0], [0, 0], 0.0, 0.0, 0
    st.aim, st.force, st.result, st.log = {"A": None, "B": STYLES[case["style"]][1]}, {}, None, None
    st.stats = {k: 0 for k in ("winded", "liver", "knee", "head_counts", "standing", "cuts", "blind", "ex", "covers")}
    st.sore_by, st.chip_r, st.fresh = {}, 9, not start and not case.get("b_start")
    st.A.rl_last, st.B.rl_last = {k: 0.0 for k in PLACES}, {k: 0.0 for k in PLACES}; reseed(st, seed)
    return st
def reseed(st, seed):   # r_ex: the exchange dice and the range, the same for every option
    st.r_ex, st.r = random.Random(seed * 7919 + 1), random.Random(seed * 104729 + 3)
def snapshot(st):
    keep, (st.r, st.r_ex, st.log) = (st.r, st.r_ex, st.log), (None, None, None); s = copy.deepcopy(st); st.r, st.r_ex, st.log = keep
    return s
def note(st, text):
    if st.log is not None: st.log.append("R%d.%d %s" % (st.rnd, st.i + 1, text))
def count(st, dfn, key):
    st.stats[key] += 1; dfn.counts, dfn.rc = dfn.counts + 1, dfn.rc + 1
def finish(st, a_wins, how): st.result = (a_wins, st.rnd, how)
def live(st): return abs(st.won[0] - st.won[1]) < st.rounds - st.rnd + 1   # still winnable either way on points
def run(st, pol, harvest=None):
    if st.aim["A"] is None: st.aim["A"] = pol["aim"](st)
    while st.result is None: (minute if st.phase == "minute" else (exchange if st.i < EXCHANGES else lambda s, p, h: bell(s)))(st, pol, harvest)
    return st

def exchange(st, pol, harvest):
    A, B, r = st.A, st.B, st.r
    if A.winded == "new":
        if harvest and live(st): harvest("D3", st)
        A.winded = st.force.pop("winded", None) or pol["winded"](st, A); note(st, "you are WINDED: %s" % A.winded)
    if B.winded == "new": B.winded = winded_default(st, B)
    style = STYLES[st.case["style"]]; ra, rb, rr = st.r_ex.random(), st.r_ex.random(), st.r_ex.random()
    rng = "long" if (st.rnd == 1 and st.i < 2) else ("long" if rr < style[0][0] else ("pocket" if rr < style[0][0] + style[0][1] else "inside"))
    if "step" in (A.winded, B.winded) or st.long_left:   # stepping off takes the bout to long range for two exchanges
        rng, st.long_left = "long", (1 if "step" in (A.winded, B.winded) else 0)
    elif "tie" in (A.winded, B.winded):                # a tie-up is inside
        rng = "inside"
    pen = {}
    for me, op, key in ((A, B, "A"), (B, A, "B")):
        me.xl, aim = {k: 0.0 for k in PLACES}, st.aim[key]
        p = (me.penalty(op.south) + aim_cost(me, aim, rng) - (OPEN_EDGE if weak(st, me, aim) else 0.0)
             - (HEAD_OPENED[op.worst(RIBS)] if aim == "head" else 0.0) + (me.habit / 0.33 if (not me.fix_on and rng == me.habit_rng) else 0.0))
        if me.winded == "fight": p += WINDED_EDGE * next(m for h, m in HEART_WIND if me.heart >= h)
        elif me.winded == "tie":
            p += TIE_EDGE
            if me.worst(RIBS, raw=True) != "fine":                       # a clinch dig on the sore side
                me.hit(min(RIBS, key=lambda s: me.p[s]), CLINCH_DIG)
            if r.random() < WARN_P: me.pts_off, me.warned = me.pts_off + me.warned, 1         # the second warning is a point
        elif me.winded == "step": p, me.e = p + STEP_EDGE, me.e + STEP_E
        pen[key] = p
    st.stats["ex"] += 1; st.stats["blind"] += any(x.blind(e) for x in (A, B) for e in EYES)
    margin = st.case.get("gap", 0.0) + pen["B"] - pen["A"] + (ra - rb) * EX_SPREAD; m = abs(margin)
    band = "close" if m < 0.25 * EX_SPREAD else ("dominant" if m >= 0.6 * EX_SPREAD else "clear")
    la, lb = LANDED[band] if margin >= 0 else LANDED[band][::-1]; st.ex_won[0 if margin >= 0 else 1] += 1; st.msum += margin
    no_big = "tie" in (A.winded, B.winded)
    for x in (A, B): x.e -= SPEND * x.breath() * x.cardio
    for att, dfn, n, key, pd in ((A, B, la, "A", st.case.get("pd_a", 0.0)), (B, A, lb, "B", style[2])):
        for _ in range(n):
            ev = land(st, att, dfn, st.aim[key], rng, pd, no_big)
            if ev == "liver":                                       # the delayed drop: at the end of the exchange
                count(st, dfn, "liver"); note(st, "LIVER DROP on %s" % ("them" if dfn is B else "you"))
                if r.random() < LIVER_STAYS_DOWN: return finish(st, att is A, "liver")
            elif ev == "winded":
                st.stats["winded"] += 1; st.chip_r = min(st.chip_r, st.rnd); note(st, "%s WINDED" % ("they are" if dfn is B else "you are"))
                if dfn.e < KNEE_E: count(st, dfn, "knee")
                else: dfn.wnext = True
            if dfn.rc >= 3 or dfn.counts >= 4: return finish(st, att is A, "rsc")
    loser = B if margin >= 0 else A
    if st.am and band == "dominant" and loser.winded and r.random() < STANDING_P:   # the referee's standing count
        count(st, loser, "standing")
        if loser.rc >= 3 or loser.counts >= 4: return finish(st, loser is B, "rsc")
    for x in (A, B): x.winded, x.wnext = ("new" if x.wnext else None), False
    st.i += 1

def bell(st):
    A, B = st.A, st.B; a_won = st.ex_won[0] > st.ex_won[1] or (st.ex_won[0] == st.ex_won[1] and st.msum >= 0)
    loser, w_n = (B if a_won else A), max(st.ex_won); pd = st.case.get("pd_a", 0.0) if a_won else STYLES[st.case["style"]][2]
    p = min(0.85, BASE_COUNT * MARGIN_F["dominant" if w_n == 6 else ("clear" if w_n == 5 else "close")] * math.exp(pd / 12.0)
            * (1.0 + (100.0 - loser.p["head"]) / HEAD_SCALE))
    n = 0
    while n < 3 and st.r.random() < p: n, p = n + 1, p * 0.6
    st.stats["head_counts"] += n; loser.counts, loser.rc = loser.counts + n, loser.rc + n
    if n and (loser.rc >= 3 or loser.counts >= 4 or st.r.random() < min(0.9, REF_STOP * (1.0 + (100.0 - loser.p["head"]) / 60.0) * 0.85)):
        return finish(st, a_won, "rsc")
    st.won[0 if a_won else 1] += 1; st.mtot += st.msum
    for x in (A, B):
        CAPS["ex"], CAPS["round"] = max(CAPS["ex"], x.max_x), max(CAPS["round"], x.max_r)
        for s in RIBS: x.p[s] = min(100.0, x.p[s] + GIVE_BACK * x.rl[s])
        x.hooks_last, x.hooks, x.rl_last = x.hooks, {k: 0 for k in RIBS}, x.rl
        x.rl, x.rc, x.winded, x.wnext = {k: 0.0 for k in PLACES}, 0, None, False
    st.sore_by[st.rnd] = any(word(x.p[k]) != "fine" for x in (A, B) for k in PLACES)
    st.chip_r = min(st.chip_r, st.rnd) if st.sore_by[st.rnd] else st.chip_r
    if st.fresh and st.am: CAPS["rib_min"] = min([CAPS["rib_min"]] + [x.p[s] for x in (A, B) for s in RIBS])
    if st.log is not None: st.log.append(("bell", st.rnd, st.ex_won[:], dict(B.p), dict(A.p), round(A.e), round(B.e), st.aim["A"], A.change, B.change))
    st.ex_won, st.msum, st.i, st.long_left = [0, 0], 0.0, 0, 0
    if st.rnd == st.rounds:
        a, b = st.won[0] - A.pts_off, st.won[1] - B.pts_off
        return finish(st, a > b or (a == b and st.mtot >= 0), "points")
    st.rnd, st.phase = st.rnd + 1, "minute"

def minute(st, pol, harvest):
    A, B = st.A, st.B
    if harvest and live(st):
        if A.habit and ((max(A.hooks_last.values()) >= 4 and A.worst(RIBS, raw=True) != "fine") or A.worst(CUTTABLE, raw=True) != "fine" or A.cuts):
            harvest("D2", st)
        if A.worst(RIBS, raw=True) != "fine": harvest("D4", st)
    A.change = st.force.pop("change", None) or pol["change"](st, A)
    A.fix_on = A.change == "fix" and st.r.random() < A.takes          # the fix takes by the boxer's Coachability
    sides = st.force.pop("ice", None); recover(A, pol["ice"](st, A) if sides is None else [min(RIBS, key=lambda s: A.p[s])] * sides)
    B.change = their_change(st, B); st.aim["B"] = their_aim(st, A); st.stats["covers"] += B.change == "cover"; recover(B, ice_default(st, B))
    for x in (A, B): cutman(st, x)
    for x in (A, B):
        if st.r.random() < doctor(x): return finish(st, x is B, "doctor")
    st.aim["A"] = pol["aim"](st); note(st, "minute: your Aim %s, your change %s, their change %s" % (AIMS[st.aim["A"]][2], A.change, B.change))
    st.phase = "ex"

def play(case, seed, pol=DEFAULT, start=None, harvest=None): return run(new_bout(case, seed, start), pol, harvest)
def plan(name):   # D1: the Aim as a plan; "ribs>head" moves to the Head once the corner READS their ribs sore (never back)
    def f(st):
        if name != "ribs>head": return name
        return "head" if st.aim["A"] == "head" or (st.rnd > 1 and read(st, st.B.worst(RIBS, raw=True)) != "fine") else "ribs"
    return f
PLANS = {"own": "Own game", "head": "Head", "body": "Body", "ribs": "Ribs", "ribs>head": "Ribs, then Head on a sore read"}

# ---------------- decisions: score each case, then ask whether a simple rule explains the winners ----------------
def rule_fit(rows, fs_list, k):   # the best k-thing lookup on the clear cases: the share where its pick IS the best option
    best = (0.0, ())
    for fs in itertools.combinations(fs_list, k):
        groups = {}
        for f, w in rows: groups.setdefault(tuple(f[x] for x in fs), []).append(max(w, key=w.get))
        best = max(best, (sum(max(g.count(o) for o in set(g)) for g in groups.values()) / len(rows), fs))
    return best

def report(title, rows, names, pair=None):
    opts, top2 = list(rows[0][1]), lambda w: sorted(w.values())[-1] - sorted(w.values())[-2]; dec = [(f, w) for f, w in rows if top2(w) >= CLEAR]
    best_n, loss = {o: 0 for o in opts}, {o: [] for o in opts}
    for f, w in dec:
        b = max(opts, key=lambda o: w[o]); best_n[b] += 1
        for o in [o for o in opts if o != b]: loss[o].append(w[b] - w[o])
    print("\n%d of %d cases are clear (the best option beats every other by %.1f+ win points); average gap best to worst %.1f.\n" % (
        len(dec), len(rows), CLEAR, sum(max(w.values()) - min(w.values()) for f, w in rows) / len(rows)))
    print("| Option | Best in (clear cases) | Share | Why NOT: avg win % lost where it is not best |\n|---|---|---|---|")
    for o in opts:
        print("| %s | %d of %d | %d%% | -%.1f |" % (names[o], best_n[o], len(dec), round(100 * best_n[o] / len(dec)), sum(loss[o]) / max(1, len(loss[o]))))
    f1, f2 = rule_fit(dec, list(dec[0][0]), 1), rule_fit(dec, list(dec[0][0]), 2)
    print("\nBest one-thing rule (%s) picks the best option in %d%% of clear cases; best two-thing rule (%s) in %d%%." % (
        f1[1][0], round(100 * f1[0]), " x ".join(f2[1]), round(100 * f2[0])))
    check(len(dec) >= len(rows) // 3, "%s: fewer than a third of the cases are clear" % title)
    check(min(best_n.values()) >= 1, "%s: an option is never best" % title)
    check(max(best_n.values()) / len(dec) <= 0.60, "%s: one option is best in more than 60%% of clear cases" % title)
    check(f1[0] <= 0.75, "%s: one thing on the screen picks the best option in more than 75%% of clear cases" % title)
    if pair:
        fp = rule_fit(dec, pair, 2)[0]; print("The %s rule picks it in %d%%." % (" x ".join(pair), round(100 * fp)))
        check(fp <= 0.75, "%s: the %s rule picks the best option in more than 75%%" % (title, " x ".join(pair)))

def features(key, st):
    A, side = st.A, min(RIBS, key=lambda s: st.A.p[s])
    f = {"their style": st.case["style"], "score": "ahead" if st.won[0] > st.won[1] else ("level" if st.won[0] == st.won[1] else "behind"),
         "your energy": "under 40" if A.e < 40 else ("40-60" if A.e <= 60 else "over 60"), "rounds left": str(st.rounds - st.rnd + 1)}
    if key == "D2":
        f.update({"habit": "%.1f at %s" % (A.habit, A.habit_rng), "takes a fix": "%d in 10" % round(10 * A.takes),
                  "hooks taken": "4+" if max(A.hooks_last.values()) >= 4 else "under 4", "your worse rib": word(A.p[side]),
                  "your face": A.worst(CUTTABLE, raw=True) if not A.cuts else "cut"})
    elif key == "D3":
        f.update({"heart": "65+" if A.heart >= 65 else ("55-64" if A.heart >= 55 else "under 55"), "your worse rib": word(A.p[side]),
                  "warned": "yes" if A.warned else "no"})
    else: f.update({"worse side": "liver" if side == "right_ribs" else "left ribs", "its word": word(A.p[side])})
    return f

def harvested(title, key, keep, opts, names, n=600, scored=True):   # play on from each harvested moment with each option, the same dice for each
    rows = []
    for f, snap in keep[key]:
        w = {}
        for o, val in opts:
            wins = 0
            for j in range(n):
                st = copy.deepcopy(snap); reseed(st, 500000 + 37 * j); st.force = {{"D2": "change", "D3": "winded", "D4": "ice"}[key]: val}
                wins += run(st, DEFAULT).result[0]
            w[o] = 100.0 * wins / n
        rows.append((f, w))
    print("\n### %s (%d moments harvested from the bouts of 6.3, still winnable either way; %d play-ons per option)\n" % (title, len(rows), n))
    for f, w in rows: print("- " + ", ".join("%s %s" % kv for kv in f.items()) + ": " + ", ".join("%s %.0f" % (names[o], w[o]) for o in w))
    if scored: return report(key, rows, names)
    print("\nAverage gap best to worst %.1f win points; %d of %d moments 2.5+ apart." % (sum(max(w.values()) - min(w.values()) for f, w in rows) / len(rows),
          sum(max(w.values()) - min(w.values()) >= DECIDING for f, w in rows), len(rows)))

def frequency():
    cases = [{"style": sty, "south": so, "cover": cv, "open": o} for sty in STYLES for o in ("ribs", "body", "head", "none")
             for so in (False, True) for cv in ("rarely", "often")]
    cols, pops, keep, seen, pick, carry = ("am", "hand", "women", "pro"), {}, {"D2": [], "D3": [], "D4": []}, {}, random.Random(438), 0.0
    for col in cols:
        tot = {}
        for c in cases:
            for s in range(1, 101):
                flags = set()
                def harvest(key, st):   # a reservoir of 48 moments per decision, drawn evenly from every column
                    flags.add(key); seen[key] = seen.get(key, 0) + 1
                    if len(keep[key]) < 48: keep[key].append((features(key, st), snapshot(st)))
                    elif pick.random() < 48.0 / seen[key]: keep[key][pick.randrange(48)] = (features(key, st), snapshot(st))
                cc = dict(c, heart=(50, 60, 70)[s % 3], habit=HABITS[(s // 3) % 4], habit_rng=RANGES[(s // 7) % 3], takes=(0.5, 0.7, 0.9)[(s // 5) % 3],
                          skills=list(SKILLS)[(s // 9) % 4], rounds=6 if col == "pro" else 3, guard=col == "women")
                handed = col == "hand" and (s * 7919 % 1000) / 1000.0 < carry
                st = play(cc, s, start={"a": {("right_ribs" if s % 2 else "left_ribs"): CARRY_VALUE}} if handed else None, harvest=harvest)
                for k, v in list(st.stats.items()) + [
                        ("bouts", 1), ("sore1", st.sore_by.get(1, False)), ("sore2", st.sore_by.get(1, False) or st.sore_by.get(2, False)),
                        ("chip2", st.chip_r <= 2), ("stops", st.result[2] != "points"), ("liver_end", st.result[2] == "liver"),
                        ("doctor", st.result[2] == "doctor"), ("ends_sore", st.result[2] == "points" and st.A.worst(RIBS, raw=True) != "fine"),
                        ("D2", "D2" in flags), ("D3", "D3" in flags), ("D4", "D4" in flags), ("body", bool(flags & {"D2", "D3"}))]:
                    tot[k] = tot.get(k, 0) + v
        carry = tot["ends_sore"] / tot["bouts"] if col == "am" else carry; pops[col] = tot
    nb = pops["am"]["bouts"]
    print("\n### How often it meets the player (4 styles x 4 weaknesses x 2 stances x 2 cover habits x 100 seeds = %d bouts a column; "
          "your boxer's Heart, habit and skills vary by seed)\n\nHand-over: %d%% of fresh amateur bouts end with your rib side sore or worse; "
          "that share starts the next bout with the side at %d. Women: amateur 3x3 in headguards. Pro: 6x3 with a cutman.\n" % (nb, round(100 * carry), CARRY_VALUE))
    print("| Per 100 bouts | Amateur fresh | Amateur hand-over | Amateur women | Pro 6 rounds |\n|---|---|---|---|---|")
    for k, label in (("sore1", "A place on either boxer sore or worse at the bell of round 1"), ("sore2", "... by the bell of round 2"),
                     ("chip2", "A chip (a place sore or worse, or WINDED) before round 3"), ("winded", "WINDED (either boxer)"),
                     ("knee", "... a knee (WINDED under 45 energy)"), ("standing", "Standing counts on a WINDED boxer"), ("liver", "Liver drops"),
                     ("head_counts", "Head counts at the bell"), ("cuts", "Cuts opened by a big punch"), ("covers", "Their corner covers the ribs (minutes)"),
                     ("stops", "Stoppages (all kinds)"), ("liver_end", "... by a liver drop"), ("doctor", "... by the doctor"),
                     ("D2", "Your corner faces D2 (ONE CHANGE, a habit open and something to protect)"), ("D3", "... D3 (an answer to WINDED)"),
                     ("D4", "... D4 (points with a rib side sore or worse)"), ("body", "... D2 or D3")):
        print("| %s | %s |" % (label, " | ".join("%.1f" % (100.0 * pops[c][k] / nb) for c in cols)))
    print("| Exchanges with a BLIND SIDE open (per 100 exchanges) | %s |" % " | ".join("%.1f" % (100.0 * pops[c]["blind"] / pops[c]["ex"]) for c in cols))
    f = pops["am"]; check(100.0 * f["chip2"] / nb >= 35.0, "a chip before round 3 in 35+ of 100 fresh amateur bouts")
    check(5.0 <= 100.0 * f["stops"] / nb <= 12.0, "amateur stoppages 5-12 per 100 bouts (REAL, J-KDRATES1)")
    check((f["liver"] + f["knee"] + f["standing"]) / max(1, f["head_counts"] + f["liver"] + f["knee"] + f["standing"]) <= 0.35, "body counts a third or less")
    check(100.0 * f["body"] / nb >= 15.0 and 100.0 * pops["pro"]["body"] / nb >= 40.0, "D2 or D3 in 15+ of 100 amateur and 40+ of 100 pro bouts")
    return keep

def decisions(keep):
    print("\n## Decisions")
    grid = list(itertools.product(STYLES, ("ribs", "body", "head", "none"), ("head-hunter", "body puncher", "inside man"), ("low", "high"),
                                  (1, 3), (3, 4, 6), ("none", "70"), ("rarely", "often")))
    rows = []
    for sty, op, sk, ca, dots, rounds, carried, cov in random.Random(4380).sample(grid, 96):
        c = {"style": sty, "open": op, "skills": sk, "cardio": ca, "dots": dots, "rounds": rounds, "cover": cov,
             "b_start": {"right_ribs": CARRY_VALUE} if carried == "70" else None}
        f = {"their style": sty, "weakness": op, "your skills": sk, "their cardio": ca, "read dots": str(dots), "bout": "%dx3" % rounds,
             "carried rib": carried, "their cover": cov}
        rows.append((f, {p: 100.0 * sum(play(c, s, dict(DEFAULT, aim=plan(p))).result[0] for s in range(1, 301)) / 300 for p in PLANS}))
    print("\n### D1 Aim plan from the first bell (96 cases drawn from 4 styles x 4 weaknesses x 3 skill sets x their cardio x read dots x "
          "3, 4 or 6 rounds x a carried rib x cover habit; 300 bouts a cell)\n")
    for f, w in rows: print("- " + ", ".join(f.values()) + ": " + ", ".join("%s %.0f" % (PLANS[p], w[p]) for p in w))
    report("D1", rows, PLANS, pair=("weakness", "their style"))
    harvested("D2 ONE CHANGE, a habit open and something to protect", "D2", keep, (("fix", "fix"), ("cover", "cover"), ("gloves", "gloves")),
              {"fix": "Fix the habit", "cover": "Cover the ribs", "gloves": "Gloves high"})
    harvested("D3 The answer to WINDED (the next exchange): measured, NOT a player decision (the boxer's own answer)", "D3", keep,
              (("fight", "fight"), ("tie", "tie"), ("step", "step")), {"fight": "Fight through", "tie": "Tie up", "step": "Step off and breathe"}, n=300, scored=False)
    harvested("D4 Minute points with a rib side sore or worse: measured, NOT a player decision (the seconds' pick)", "D4", keep,
              (("water", 0), ("ice", 1)), {"water": "3 water", "ice": "Ice the worse side + 2 water"}, n=300, scored=False)

def constants():
    print("\n### Constants (TUNE: the build's probe may move them inside the range)\n\n| Constant | Value |\n|---|---|")
    for row in (
            "Place words | fine 56-100, sore 36-55, hurt 16-35, injured 0-15, on the shown (rounded) number",
            "Points | rib hook %g, face punch %g, head %g; hooks and uppercuts x%g upstairs; big x%g (%d%% of punches); open cut x%g" % (RIB_HIT, FACE_HIT, HEAD_HIT, HOOK_HEAD, BIG_MULT, BIG * 100, CUT_MULT),
            "Caps on one place | %d an exchange, %d a round; ribs get back %d%% of the round's loss at the bell" % (CAP_EX, CAP_ROUND, GIVE_BACK * 100),
            "Aim cost long/pocket/inside | Head 1.2 - Accuracy/80 at any range (floor 0); Body %s less Inside fighting/50 in the pocket and inside; Ribs %s less Body hook "
            "mastery/40 at long (floor 0.5); Ribs +%g when your left is the rear hand" % ("/".join("%g" % BODY_COST[x] for x in RANGES), "/".join("%g" % RIB_COST[x] for x in RANGES), REAR_HOOK),
            "Body share by Aim | " + ", ".join("%s %.2f" % (v[2], v[0]) for v in AIMS.values()) + "; a Ribs Aim throws the left (liver) hook %d%%" % (RIBS_LEFT * 100),
            "Their WEAKNESS | the matching Aim, if you have the weapon (Ribs: Body hook mastery 40+; Body: Inside fighting 50+; Head: Accuracy 50+): +%g edge, its "
            "punches x%g (Body: WINDED and energy x%g; Head: cuts x2); their cover shuts a ribs weakness" % (OPEN_EDGE, WEAK_MULT, WEAK_WIND),
            "Head after the body | Head Aim +%g edge while their worse rib side reads sore, +%g at hurt" % (HEAD_OPENED["sore"], HEAD_OPENED["hurt"]),
            "Breath (either rib side) | spend x%g sore, x%g hurt; the minute's water stops at %d / %d" % (BREATH["sore"], BREATH["hurt"], CEILING["sore"], CEILING["hurt"]),
            "Tired | -%g edge x (65 - energy) / 65 under 65; a water point +6 under 40, +3 at 40-60, +2 over 60 (x%g with an open nose cut)" % (TIRED_EDGE, NOSE_WATER),
            "Ice a rib side (1 point) | the side reads one word better next round (breath, liver drop) and gets back %d%% more of the round's loss" % (ICE_BACK * 100),
            "Blind side | an eye at hurt or an open cut over it: -%g edge facing their rear hand, -%g facing their jab" % (BLIND_POWER, BLIND_JAB),
            "Cuts | a big punch on an eye or the nose opens one %.1f%% of the time; headguard: cuts x%g, face points x%g" % (CUT_P * 100, HEADGUARD_CUT, HEADGUARD_FACE),
            "WINDED | %d%% a big straight body punch x e^((power-durability)/12); under %d energy a knee (a count)" % (WINDED_P * 100, KNEE_E),
            "WINDED answers | Fight through -%g x %g / %g / %g at Heart 65+ / 55-64 / under 55; Tie up -%g, inside, no big shot either way, a %g dig on a sore rib, "
            "warning %d%%, the second a point; Step off -%g, +%g energy, long range two exchanges, rib hooks on you half and no drop" % (
                WINDED_EDGE, HEART_WIND[0][1], HEART_WIND[1][1], HEART_WIND[2][1], TIE_EDGE, CLINCH_DIG, WARN_P * 100, STEP_EDGE, STEP_E),
            "Standing count (amateur) | %d%% when a WINDED boxer loses an exchange dominantly; counts toward 3 a round / 4 a bout" % (STANDING_P * 100),
            "Liver drop, a big LEFT hook on the right ribs | fine %g%%, sore %g%%, hurt %g%%, injured %g%% x e^((power-durability)/12), max 30%%; cover x%g; "
            "stays down %d in 100" % tuple([LIVER_P[w] * 100 for w in WORDS] + [COVER_DROP, LIVER_STAYS_DOWN * 100]),
            "Head count at the bell | %d%% x margin x e^((power-durability)/12) x (1 + (100 - HEAD)/%g)" % (BASE_COUNT * 100, HEAD_SCALE),
            "Doctor (end of the minute) | a face place or HEAD at 15 or under %d in 100; an open cut %d; a closed cut %d" % (DOC_PLACE * 100, DOC_CUT * 100, DOC_CLOSED * 100),
            "Cover the ribs | %d%% of the hooks at the ribs are covered: %d%% of those die on the elbows, the rest land on the eye on that side and the head; "
            "liver drop x%g; costs the ONE CHANGE slot (the habit stays open)" % (COVER_MOVE * 100, COVER_BLOCK * 100, COVER_DROP),
            "Gloves high | face and head points x%g; ribs x%g; their body share +%g" % (GLOVES_FACE, GLOVES_RIB, GLOVES_BODY),
            "Their corner | covers %d%% (rarely) / %d%% (often) +%d%% a hook past 3 on one side, max %d%%; moves its Aim to your damage %d minutes in 10" % (
                COVER_BASE["rarely"] * 100, COVER_BASE["often"] * 100, COVER_STEP * 100, COVER_MAX * 100, THEY_WORK * 10),
            "A read (signs, not numbers) | right %d / %d / %d in 100 at 1 / 2 / 3 dots, else one word off" % tuple(READ_ACC[d] * 100 for d in (1, 2, 3)),
            "Open habit | %g / %g / %g edge an exchange over a mix, all of it at its one range (x3); the fix takes 5 / 7 / 9 in 10 by Coachability; "
            "their cardio: spend x%g low, x%g high" % (HABITS[1], HABITS[2], HABITS[3], CARDIO["low"], CARDIO["high"])):
        print("| %s |" % row)

def worked():
    case = {"style": "pressure", "cover": "rarely", "open": "none", "skills": "body puncher"}
    for seed in range(11, 400):
        st = new_bout(case, seed); st.log = []; run(st, dict(DEFAULT, aim=plan("ribs>head")))
        if any("WINDED" in x for x in st.log if isinstance(x, str)) and any(x[7] == "head" for x in st.log if isinstance(x, tuple)): break
    print("\n### Worked bout: a body puncher on 'Ribs, then Head on a sore read' against an orthodox pressure fighter (the first seed from 11 "
          "with a WINDED and the switch to the Head: %d)\n" % seed)
    print("| Bell | Exchanges | Their liver / left ribs | Your liver / left ribs | Their worst eye | Energy you / them | Aim next | Changes you / them |\n" + "|---" * 8 + "|")
    for _, rnd, exw, bp, ap, ea, eb, aim, ca, cb in [x for x in st.log if isinstance(x, tuple)]:
        print("| %d | %d-%d | %d %s / %d | %d %s / %d | %d | %d / %d | %s | %s / %s |" % (rnd, exw[0], exw[1], bp["right_ribs"], word(bp["right_ribs"]),
              bp["left_ribs"], ap["right_ribs"], word(ap["right_ribs"]), ap["left_ribs"], min(bp["left_eye"], bp["right_eye"]), ea, eb, AIMS[aim][2], ca, cb))
    print("\nEvents: " + "; ".join(x for x in st.log if isinstance(x, str)) + ".\nEnds: %s in round %d, %s." % (
        st.result[2], st.result[1], "you win" if st.result[0] else "they win"))

def place_table(n_t=400):
    print("\n### Their ribs at the last bell, by your plan (3 rounds from fresh, %d bouts; orthodox, covers rarely, no weakness, average skills)\n\n"
          "| Your plan | vs | Their worse rib mean | Sore or worse | Hurt or worse | Your win %% |\n|---|---|---|---|---|---|" % n_t)
    for style, p in itertools.product(("out-boxer", "pressure"), PLANS):
        sts = [play({"style": style}, s, dict(DEFAULT, aim=plan(p))) for s in range(1, n_t + 1)]
        vals = [min(st.B.p[x] for x in RIBS) for st in sts if st.result[2] == "points"]
        print("| %s | %s | %.0f | %d%% | %d%% | %.0f |" % (PLANS[p], style, sum(vals) / len(vals), round(100 * sum(word(v) != "fine" for v in vals) / len(vals)),
              round(100 * sum(word(v) in ("hurt", "injured") for v in vals) / len(vals)), 100.0 * sum(st.result[0] for st in sts) / n_t))

def main():
    print("# DAMAGE FIGHT numbers (tools/damage_fight_numbers.py, round 2)\n")
    check(abs(win_p(0.0) - 0.5) < 1e-12, "level edge is a coin"); check(all(win_p(a) < win_p(a + 1) for a in range(-60, 60)), "edge buys exchanges")
    print("One edge point in one exchange = %.2f%% of a 3-round bout at level (exchange pivot 0.31 x round pivot 0.5).\n" % k_edge(3))
    print("| Edge | -7 | -6 | -4 | -2 | 0 | +2 | +4 |\n|---|---|---|---|---|---|---|---|")
    print("| Exchange won % | " + " | ".join("%.0f" % (100 * win_p(x)) for x in (-7, -6, -4, -2, 0, 2, 4)) + " |"); constants()
    check(play({"style": "pressure", "open": "ribs"}, 5).result == play({"style": "pressure", "open": "ribs"}, 5).result, "deterministic"); worked()
    place_table(); keep = frequency(); check(CAPS["ex"] <= CAP_EX + 1e-9 and CAPS["round"] <= CAP_ROUND + 1e-9, "caps 10 an exchange, 30 a round")
    check(CAPS["rib_min"] > INJURED_AT, "a fresh rib cannot reach injured in a 3-round bout")
    print("\nCaps held: most off one place in one exchange %.1f (cap %d), in one round %.1f (cap %d); lowest fresh amateur rib %.0f."
          % (CAPS["ex"], CAP_EX, CAPS["round"], CAP_ROUND, CAPS["rib_min"]))
    decisions(keep)
    print("\nASSERTS: %d passed. Seeds fixed; the tables above are the map's numbers.\nNot modelled: calls and modes, set-ups, plan lines, "
          "PRESSURE, the 3D, a mid-round Aim switch.\nDone." % ASSERTS[0])

if __name__ == "__main__": main()
