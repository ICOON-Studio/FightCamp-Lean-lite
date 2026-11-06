extends RefCounted
## BjjMatch - a no-gi belt match played on the GrappleMap move graph, the player calling her moves (S369 BJJMATCH1, the
## Miro frame "BJJ belt match - you call the next move", operator "ok go-ahead" S368; Argon's checks shaped it):
## - THE CLOCK: BeltRoad.match_minutes(belt) (white 5 min). Points as BeltRoad.POINTS (IBJJF no-gi: takedown 2, sweep 2,
##   pass 3, knee on belly 2, mount 4, back 4); a submission ends it; level points at the bell = a draw (no referee call).
## - WHO MOVES: whoever has the initiative picks a move out of the position. A move she makes that fails hands the
##   initiative over (and costs gas); one the other woman makes the same. Her default pick is her game plan (best expected
##   points); the player overrides it with a CALL.
## - CALLS: CALLS_PER_MATCH a match, offered only on a heavy settle (guard, half guard, side control, mount, back - never
##   mid-scramble, standing or turtle) held SETTLE_S, while she has the initiative and gas to act on it (Argon: "only on
##   heavy settles"; "corner shouts"; "tunnel vision when gassed").
## - THE OFFER: 2-3 moves out of where she is - her OWNED syllabus moves (BeltRoad.OWNED_AT) and the plain positional ones
##   (no technique name), never a syllabus move she has not drilled - each with its odds AND the cost of a miss.
## Pure: positions come in as GrappleMap tag lists and moves as candidate dictionaries (the browser builds them).

const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")

const CALLS_PER_MATCH := 3
## S371 round 9: 1.0 -> 0.4 - the chained hand-overs (a move every ~2.5 s with a 0.5 s settle) never accumulated a
## full second, so can_call never fired and the belt match lost its whole interactive layer (a probe run came back
## "calls used 0"). 0.4 still needs a held settle, just a shorter one.
const SETTLE_S := 0.4
const OFFER_MAX := 3
## The positions a call may come on (heavy settles).
const SETTLES := ["guard", "half_guard", "side_control", "mount", "back"]
## Base odds by what the move does (coach judgement, as GroundRules' tables; G75: no published shares).
const KIND_BASE := {"takedown": 0.40, "sweep": 0.35, "pass": 0.35, "mount": 0.40, "back": 0.32, "knee_on_belly": 0.45,
	"sub": 0.22, "escape": 0.40, "advance": 0.55}
## Her mastery of the move lifts or cuts the base: x (MASTERY_FLOOR + m / MASTERY_SPAN) - owned (30) = x1.0, 60 = x1.4.
const MASTERY_FLOOR := 0.6
const MASTERY_SPAN := 75.0
## A positional move (no technique name) reads at this mastery.
const PLAIN_MASTERY := 30.0
## Skill gap: (her skill - theirs) / SKILL_SPAN added to the odds.
const SKILL_SPAN := 200.0
## Gas 1.0 = fresh. Every move costs MOVE_GAS, a miss MISS_GAS more; below TIRED_GAS she gets no calls (tunnel vision)
## and her odds scale with gas.
const MOVE_GAS := 0.02
const MISS_GAS := 0.06
const TIRED_GAS := 0.35
const ODDS_RANGE := Vector2(0.05, 0.90)
## S369 (the Miro card 3: odds "from her technique, strength, cardio and fatigue"): STRENGTH lifts the moves that drive
## through a body - takedowns, passes, escapes, mount - by (hers - theirs) / STRENGTH_SPAN; CARDIO sets how fast her gas
## goes (a move costs MOVE_GAS x (CARDIO_K - cardio / 100): cardio 50 = x1.0, 80 = x0.7). 0-100 like the boxers' stats;
## a woman without them reads STAT_DEFAULT.
const STRENGTH_SPAN := 250.0
const STRENGTH_KINDS := ["takedown", "pass", "escape", "mount"]
const CARDIO_K := 1.5
const STAT_DEFAULT := 50.0
## The corner's other call on a settle: HOLD - keep the position and breathe (gas back HOLD_GAS), no move, no score; the
## initiative stays hers. Always offered on a call, so the player always has a choice.
const HOLD_GAS := 0.06
const HOLD := {"i": -1, "title": "Hold and breathe", "kind": "hold", "syllabus": "", "odds": 1.0, "pts": 0,
	"miss": "nothing to miss - the clock runs", "ev": 0.0}
## GrappleMap move tag -> her syllabus move (BeltRoad.SYLLABUS ids).
const TAG_SYLLABUS := {"knee_slice": "knee_cut_pass", "butterfly_sweep": "butterfly_sweep", "kimura": "kimura",
	"rear_naked_choke": "rear_naked_choke", "armbar": "armbar_guard", "triangle": "triangle", "guillotine": "guillotine",
	"darce": "darce", "double_leg_takedown": "double_leg", "arm_drag": "arm_drag_back", "body_lock": "body_lock_pass",
	"knee_bar": "kneebar", "deep_half": "deep_half", "pass_around": "bullfighter_pass", "arm_triangle": "anaconda",
	"omoplata": "omoplata"}
const SUB_TAGS := ["kimura", "rear_naked_choke", "armbar", "triangle", "guillotine", "darce", "arm_triangle", "knee_bar",
	"omoplata", "monoplata", "arm_choke", "americana", "straight_ankle_lock", "heel_hook"]
## S389 a finish reads by its submission, never by GrappleMap's step name ("Bottom Leg Freed", "To Side" were on screen as finishes).
const SUB_NAMES := {"kimura": "Kimura", "rear_naked_choke": "Rear naked choke", "armbar": "Armbar", "triangle": "Triangle",
	"guillotine": "Guillotine", "darce": "D'Arce choke", "arm_triangle": "Arm triangle", "knee_bar": "Kneebar", "omoplata": "Omoplata",
	"monoplata": "Monoplata", "arm_choke": "Arm choke", "americana": "Americana", "straight_ankle_lock": "Ankle lock",
	"heel_hook": "Heel hook"}
## What a miss costs, in words beside the odds.
## S376: no she/her on screen (tests/no_pronoun_test.gd on main).
const MISS_WORDS := {"sub": "a missed submission gives up the grips and the initiative",
	"sweep": "stays underneath, the initiative goes over", "pass": "stays in the guard, the initiative goes over",
	"takedown": "a stuffed shot: the initiative goes to the opponent", "mount": "stays put, the initiative goes over",
	"back": "stays put, the initiative goes over", "knee_on_belly": "stays put, the initiative goes over",
	"escape": "stays pinned", "advance": "the initiative goes to the opponent"}
## S376 BJJMENU1 (BJJ DOJO's move menu on the itch scan: each move with chance %, risk, stamina cost, IBJJF points): how
## much a miss loses, by what the move does - a missed submission gives up the grips AND the initiative, a stuffed shot
## leaves her under the other woman's attack, a missed sweep or pass only stays put. Risk = miss chance x this.
const LOSS := {"sub": 1.0, "takedown": 0.8, "advance": 0.6, "sweep": 0.5, "pass": 0.5, "mount": 0.5, "back": 0.5,
	"knee_on_belly": 0.5, "escape": 0.4, "hold": 0.0}
const RISK_AT := Vector2(0.2, 0.4)   # under x Low, under y Medium, else High


## A position's class from its GrappleMap tags. Open guards carry no guard tag in GrappleMap (bottom on her back, top
## kneeling or in combat base: 88 + 60 of the 213 untagged positions); quarter guard and deep half are half guard;
## north-south is a pin like side control.
static func classify(tags: Array) -> String:
	for c in ["back", "mount", "side_control", "half_guard", "turtle"]:
		if tags.has(c):
			return c
	if tags.has("north_south"):
		return "side_control"
	if tags.has("quarter_guard") or tags.has("deep_half"):
		return "half_guard"
	if tags.has("full_guard") or tags.has("closed_guard") or tags.has("butterfly") or tags.has("rubber_guard") 		or tags.has("lockdown") or tags.has("open_guard") or tags.has("spiderweb"):
		return "guard"
	if tags.has("standing"):
		return "standing"
	if tags.has("bottom_supine") and (tags.has("top_kneeling") or tags.has("combat_base") or tags.has("top_seated")):
		return "guard"
	return "other"


## The tags a move scores by: a submission tag counts only when the move lands on that submission (its finish) and is
## not a throw, takedown or sweep that uses the grip (GrappleMap's "throw" with a kimura grip is a throw).
static func scoring_tags(move_tags: Array, land_tags: Array) -> Array:
	var entry := false
	for t in move_tags:
		if str(t) in ["throw", "sacrifice_throw", "takedown", "trip", "sweep", "te_waza", "sutemi_waza", "ashi_waza"] 			or str(t).ends_with("_takedown") or str(t).ends_with("_sweep"):
			entry = true
	var out: Array = []
	for t in move_tags:
		if SUB_TAGS.has(t) and (entry or not land_tags.has(t)):
			continue
		out.append(t)
	return out


## On the ground the woman on top is the one whose core is higher; standing nobody is.
static func top_of(core_y: Array, pos_class: String) -> int:
	if pos_class == "standing" or core_y.size() < 2:
		return -1
	return 0 if float(core_y[0]) >= float(core_y[1]) else 1


## What a move did, from the side of woman `me`: by its tags first (a submission), else by the classes and who is on top
## before and after. "" = nothing that scores or advances (a grip, an adjustment).
static func kind_of(tags: Array, from_c: String, to_c: String, top_before: int, top_after: int, me: int) -> String:
	for t in tags:
		if SUB_TAGS.has(t):
			return "sub"
	if from_c == "standing" and to_c != "standing":
		return "takedown" if top_after == me else ""
	if top_before != me and top_after == me and from_c in ["guard", "half_guard", "turtle", "other"]:
		return "sweep" if to_c != "back" else "back"
	if top_after != me:
		return "escape" if top_before != me and to_c in ["guard", "half_guard", "standing"] and from_c in ["side_control", "mount", "back"] else ""
	if to_c == "back" and from_c != "back":
		return "back"
	if to_c == "mount" and from_c != "mount":
		return "mount"
	if to_c == "side_control" and from_c in ["guard", "half_guard"]:
		return "pass"
	if to_c != from_c:
		return "advance"
	return ""


static func sub_name(tags: Array) -> String:
	for t in tags:
		if SUB_NAMES.has(t):
			return str(SUB_NAMES[t])
	return "Submission"


static func points(kind: String) -> int:
	return int(BeltRoad.POINTS.get(kind, 0))


static func syllabus_of(tags: Array) -> String:
	for t in tags:
		if TAG_SYLLABUS.has(t):
			return str(TAG_SYLLABUS[t])
	return ""


## Her odds on a move of `kind` she knows at mastery `m`, against an opponent of `opp_skill`, at `gas`.
static func odds(kind: String, m: float, skill: float, opp_skill: float, gas: float, strength: float = STAT_DEFAULT,
		opp_strength: float = STAT_DEFAULT) -> float:
	var p := float(KIND_BASE.get(kind, 0.3)) * (MASTERY_FLOOR + m / MASTERY_SPAN) + (skill - opp_skill) / SKILL_SPAN
	if STRENGTH_KINDS.has(kind):
		p += (strength - opp_strength) / STRENGTH_SPAN
	p *= lerpf(0.6, 1.0, clampf(gas, 0.0, 1.0))
	return clampf(p, ODDS_RANGE.x, ODDS_RANGE.y)


## Her skill for the gap: the mean of her syllabus mastery.
static func skill_of(f: Dictionary) -> float:
	var bjj: Dictionary = f.get("bjj", {})
	if bjj.is_empty():
		return 30.0
	var s := 0.0
	for k in bjj:
		s += float(bjj[k])
	return s / bjj.size()


static func start(f: Dictionary, opp: Dictionary) -> Dictionary:
	return {"t": 0.0, "limit_s": float(BeltRoad.match_minutes(str(f.get("belt", "white")))) * 60.0, "pts": [0, 0],
		"calls": CALLS_PER_MATCH, "gas": [1.0, 1.0], "init": 0, "over": false, "winner": -1, "how": "", "settle_s": 0.0,
		"skill": [skill_of(f), float(opp.get("skill", 30.0))], "log": [],
		"strength": [stat(f, "strength"), stat(opp, "strength")], "cardio": [stat(f, "cardio"), stat(opp, "cardio")]}


static func stat(who: Dictionary, key: String) -> float:
	return float((who.get("stats", {}) as Dictionary).get(key, who.get(key, STAT_DEFAULT)))


## Can the player call now? Her initiative, a heavy settle held SETTLE_S, calls left, gas above TIRED_GAS.
static func can_call(st: Dictionary, pos_class: String) -> bool:
	return not bool(st["over"]) and int(st["init"]) == 0 and int(st["calls"]) > 0 and SETTLES.has(pos_class) \
		and float(st["settle_s"]) >= SETTLE_S and float(st["gas"][0]) >= TIRED_GAS


## The moves woman `me` may make out of here, each with odds, points and the cost of a miss, best expected points first.
## `cands`: [{i, title, tags, to_c, top_after}] - every move out of the position as the browser laid it on the pair.
## Woman 0 is ours (her owned syllabus moves + plain positional ones); woman 1 uses every move at PLAIN_MASTERY.
static func offers(st: Dictionary, f: Dictionary, me: int, from_c: String, top_now: int, cands: Array) -> Array:
	var bjj: Dictionary = f.get("bjj", {})
	var out: Array = []
	for c in cands:
		var tags: Array = c["tags"]
		var kind := kind_of(tags, from_c, str(c["to_c"]), top_now, int(c["top_after"]), me)
		if kind == "":
			continue
		# S371 BJJ9 round 5 (Argon round 4, the top defect: "Kim wins by mounted arm triangle while pinned on her
		# back underneath Ana"): a submission finish is only worth attempting by the fighter the data puts ON TOP of
		# its landing - a bottom fighter "hitting" a choke move showed the top fighter applying it, and the verdict
		# named the wrong winner.
		if kind == "sub" and int(c["top_after"]) != me:
			continue
		var syl := syllabus_of(tags)
		var m := PLAIN_MASTERY
		# S389: both women fight with what they have drilled (Ana made 0 submission attempts in 8 matches, Kim 18, because only
		# Ana was held to her syllabus). A rival with no list (the bare `match=1` Kim) stays on the plain moves.
		if syl != "" and (me == 0 or not bjj.is_empty()):
			m = float(bjj.get(syl, 0.0))
			if m < BeltRoad.OWNED_AT:
				continue   # never a technique she has not drilled
		var p := odds(kind, m, float(st["skill"][me]), float(st["skill"][1 - me]), float(st["gas"][me]),
			float(st["strength"][me]), float(st["strength"][1 - me]))
		var pts := points(kind)
		var ev := p * (10.0 if kind == "sub" else float(pts) + 0.5) - (1.0 - p) * (1.5 if kind == "sub" else 0.5)
		out.append({"i": c["i"], "title": sub_name(tags) if kind == "sub" else str(c["title"]), "kind": kind, "syllabus": syl, "m": m, "odds": p, "pts": pts,
			"miss": str(MISS_WORDS.get(kind, "")), "ev": ev})
	out.sort_custom(func(a, b): return float(a["ev"]) > float(b["ev"]))
	return out.slice(0, OFFER_MAX)


## A call's choices: the moves (best first, her plan) and HOLD last.
static func call_offers(offers: Array) -> Array:
	return offers.slice(0, OFFER_MAX - 1) + [HOLD.duplicate()]


## S376 BJJMENU1: the gas a move takes out of woman `me`'s tank, in tank points (100 = full): x on a hit, y on a miss
## (resolve's MOVE_GAS, + MISS_GAS on a miss, x her cardio drain); a hold gives HOLD_GAS back (negative).
static func gas_cost(st: Dictionary, me: int, o: Dictionary) -> Vector2:
	if str(o["kind"]) == "hold":
		return Vector2(-HOLD_GAS, -HOLD_GAS) * 100.0
	var drain := CARDIO_K - float(st["cardio"][me]) / 100.0
	return Vector2(MOVE_GAS * drain, (MOVE_GAS + MISS_GAS) * drain) * 100.0


## S376 BJJMENU1: how risky a call is - {"word": Low|Medium|High|None, "chip": UI chip colour, "share": miss x LOSS}.
static func risk(o: Dictionary) -> Dictionary:
	var share := (1.0 - float(o["odds"])) * float(LOSS.get(str(o["kind"]), 0.5))
	if str(o["kind"]) == "hold":
		return {"word": "None", "chip": "", "share": 0.0}
	if share < RISK_AT.x:
		return {"word": "Low", "chip": "green", "share": share}
	return {"word": "Medium", "chip": "amber", "share": share} if share < RISK_AT.y else {"word": "High", "chip": "red", "share": share}


## Resolve a move `o` by woman `me` with a roll in [0, 1): a hit scores (a submission ends the match), a miss costs gas
## and hands the initiative over. `called` = the player's call (spends one). Returns true on a hit.
static func resolve(st: Dictionary, me: int, o: Dictionary, roll: float, called: bool = false) -> bool:
	if called:
		st["calls"] = int(st["calls"]) - 1
	if str(o["kind"]) == "hold":
		st["gas"][me] = minf(1.0, float(st["gas"][me]) + HOLD_GAS)
		st["settle_s"] = 0.0
		(st["log"] as Array).append({"t": st["t"], "who": me, "title": o["title"], "kind": "hold", "hit": true, "called": called})
		return true
	var drain := CARDIO_K - float(st["cardio"][me]) / 100.0
	st["gas"][me] = maxf(0.0, float(st["gas"][me]) - MOVE_GAS * drain)
	st["settle_s"] = 0.0
	var hit := roll < float(o["odds"])
	if hit:
		if str(o["kind"]) == "sub":
			st["over"] = true
			st["winner"] = me
			st["how"] = "submission (%s) %s" % [str(o["title"]).to_lower(), clock(float(st["t"]))]
		else:
			st["pts"][me] = int(st["pts"][me]) + int(o["pts"])
	else:
		st["gas"][me] = maxf(0.0, float(st["gas"][me]) - MISS_GAS * drain)
		st["init"] = 1 - me
	(st["log"] as Array).append({"t": st["t"], "who": me, "title": o["title"], "kind": o["kind"], "hit": hit, "called": called})
	return hit


## Time passes: the clock, the settle timer, and the bell (points decide; level = a draw).
static func tick(st: Dictionary, delta: float, settled: bool) -> void:
	if bool(st["over"]):
		return
	st["t"] = float(st["t"]) + delta
	st["settle_s"] = float(st["settle_s"]) + delta if settled else 0.0
	if float(st["t"]) >= float(st["limit_s"]):
		st["t"] = st["limit_s"]
		st["over"] = true
		var a := int(st["pts"][0])
		var b := int(st["pts"][1])
		st["winner"] = 0 if a > b else (1 if b > a else -1)
		st["how"] = "points %d-%d" % [maxi(a, b), mini(a, b)] if a != b else "draw %d-%d" % [a, b]


static func clock(t: float) -> String:
	return "%d:%02d" % [int(t) / 60, int(t) % 60]
