## NoGi - the gym's no-gi athletes between belts (S362, operator Q-S294-80 "Yes, build both": the belt road in the Record
## tab, drawn in docs/mockups/S355_record_bjj.png). BeltRoad holds the IBJJF floor and the syllabus; this is the week and
## the opens:
## - THE WEEK: CLASSES_PER_WEEK classes on the mat; the class drills the syllabus move she is closest to owning. White ->
##   blue at 3 a week is 200 classes = ~15 months, inside the belt guides' 1-2 years (BeltRoad). A class drills a technique
##   for about half an hour before the rolls: 3 x 0.5 h at the pads rate (MoveMastery GAIN_PER_HOUR pads 2.1) = DRILL_GAIN a week.
## - STRIPES: the professor gives them; one is due each quarter of the way to ready (BeltRoad.stripes_for).
## - THE OPENS: an open every OPEN_EVERY days on a Saturday, BRACKET entrants at her belt, single elimination. Her odds
##   against a same-belt field come from how far along her belt she is (a white belt near blue beats fresh white belts):
##   WIN_BASE + WIN_SLOPE x share, clamped. A third of the matches end by submission (SUB_SHARE, game value; coach
##   judgement for white-belt brackets). Points come from BeltRoad.POINTS.
## Pure static; preloads BeltRoad only.

const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")

const CLASSES_PER_WEEK := 3
## S365 teaching the beginners' class takes one of her evenings (mirrors BjjSide.TEACH_CLASSES; NoGi preloads no BjjSide).
const TEACH_CLASSES := 1
const DRILL_GAIN := 3.2
## S369 (operator "Yes, train them"): the classes train her body too - the rolls after the drilling are interval work
## against a resisting body. A week of CLASSES_PER_WEEK classes adds BODY_GAIN x (1 - value / BODY_CEIL) (the closer to
## her ceiling the slower, like MoveMastery): cardio 58 -> ~67 and strength 52 -> ~58 in a year at 3 classes (coach
## judgement, game values; the belt match reads them - BjjMatch: strength in takedowns/passes/escapes/mount, cardio =
## how fast she gasses). One fewer class while she teaches = less gain.
const BODY_GAIN := {"cardio": 0.6, "strength": 0.3}
const BODY_CEIL := 90.0
const BODY_START := 50.0
const OPEN_FIRST := 33   # Sat 7 Feb 2026 (day 0 = Mon 5 Jan)
const OPEN_EVERY := 35
const BRACKET := 8
const OPENS := [["Regional No-Gi Open", 95], ["Spring Open (Union rules)", 110], ["London No-Gi Open", 95],
	["Summer Open (Union rules)", 110], ["Autumn No-Gi Open", 95], ["Winter Open (Union rules)", 110]]
const WIN_BASE := 0.35
const WIN_SLOPE := 0.30
const WIN_RANGE := Vector2(0.2, 0.8)
## S363 (StripeCall): morale and loyalty start here; morale moves her match odds by (morale - start) / MORALE_SPAN (100 =
## +0.10, 20 = -0.10); a held stripe drills HUNGRY harder; a tough bracket (early stripes) costs TOUGH a match. Her results
## move morale: a win +WIN_MORALE, a loss on points -LOSS_MORALE, tapped -TAP_MORALE (Kalli K-BELTROAD1 part 3).
## S364 (Kalli K-BELTROAD1 parts 2-3) WHAT THE CLASSES DRILL: f["drill"] = "coach" (default: the move closest to owned),
## "open" (for the next open: the least-owned move of the group it leans on, finished before the next; all owned = the best
## of them toward a signature) or "fav" (her best owned move, pushed to a SIGNATURE).
## Each open LEANS on one syllabus group (which game its field brings): her own in that group moves her odds by
## LEAN_W x (own - 0.5) (game value, +-0.25: a field of wrestlers against a guard player decides a lot), and a signature
## move in it adds SIGNATURE_BONUS. Measured S364: at +-0.06, and at +-0.15 with Kalli's "weakest group" plan (it wandered
## between groups and finished nothing), drilling for the open lost to the coach's pick IN that open - one more owned move
## lifts the belt share 1/14 x 0.30 = 0.021. At +-0.25 five weeks for the next open beat the coach's pick there, and cost
## time on the belt road. The favourite pays where its group decides. Chance in words: under LONG_SHOT / over FAVOURITE.
const DRILLS := ["coach", "open", "fav"]
const SIGNATURE := 50.0
const SIGNATURE_BONUS := 0.05
const LEAN_W := 0.50
const LONG_SHOT := 0.40
const FAVOURITE := 0.60
const MORALE_START := 60
const MORALE_SPAN := 400.0
const HUNGRY := 1.15
const TOUGH := 0.05
const WIN_MORALE := 4
const LOSS_MORALE := 3
const TAP_MORALE := 6
const SUB_SHARE := 0.35
const SUBS := ["armbar_guard", "kimura", "americana", "rear_naked_choke", "guillotine", "triangle", "straight_ankle_lock",
	"darce", "outside_heel_hook", "kneebar", "toe_hold", "anaconda", "north_south_choke", "back_triangle", "inside_heel_hook",
	"calf_slicer", "clock_choke"]
const NAMES := {"shrimp_bridge": "Shrimp and bridge", "frame_recover_guard": "Frame and recover guard",
	"posture_closed_guard": "Posture in closed guard", "armbar_guard": "Armbar from guard", "darce": "D'arce",
	"single_leg_x": "Single leg X", "k_guard": "K guard"}
const OPP_FIRST := ["Kim", "Jo", "Sam", "Lea", "Mia", "Ines", "Tara", "Beth", "Nadia", "Rosa", "Yuki", "Hana", "Cleo", "Fern"]
const OPP_LAST := ["Patel", "Reyes", "Okafor", "Novak", "Grant", "Costa", "Byrne", "Silva", "Moreau", "Lund", "Ito", "Hale"]


## The gym's first no-gi athlete (the approved mockup's Ana Ribeiro): white belt, 2 stripes given, 4-2 in opens.
static func athlete() -> Dictionary:
	return {"id": "ana", "name": "Ana Ribeiro", "first": "Ana", "age": 22, "wc": "Featherweight (no-gi)", "sport": "bjj",
		"belt": "white", "belt_day": -301, "stripes": 2, "mat_classes": 130, "mat_debt": 0, "world_champ": false,
		"bjj": {"shrimp_bridge": 44.0, "frame_recover_guard": 36.0, "seatbelt_escape": 22.0, "posture_closed_guard": 33.0,
			"bullfighter_pass": 31.0, "knee_cut_pass": 15.0, "scissor_sweep": 34.0, "hip_bump_sweep": 32.0, "double_leg": 31.0,
			"armbar_guard": 28.0, "kimura": 35.0, "americana": 30.0, "rear_naked_choke": 12.0, "guillotine": 9.0},
		# S369 BJJMATCH1 (Miro card 3: odds from technique, strength, cardio and fatigue): her body, 0-100 like a boxer's.
		# S397 BJJREAL: the rest of the grappler's body and mind (BjjBody), a white belt's calm.
		"stats": {"strength": 52.0, "cardio": 58.0, "flexibility": 56.0, "explosiveness": 50.0, "composure": 45.0, "aggression": 52.0},
		"w": 4, "l": 2, "entered": [], "morale": MORALE_START, "loyalty": MORALE_START,
		"opens": [
			{"d": -16, "open": "London No-Gi Open", "win": true, "opp": "Kim Patel", "how": "submission (armbar from guard) 3:12"},
			{"d": -16, "open": "London No-Gi Open", "win": true, "opp": "Jo Reyes", "how": "points 6-2"},
			{"d": -23, "open": "Winter Open", "win": false, "opp": "Sam Okafor", "how": "submission (rear naked choke) 4:40"},
			{"d": -23, "open": "Winter Open", "win": true, "opp": "Lea Novak", "how": "points 4-0"},
			{"d": -58, "open": "Autumn Open", "win": true, "opp": "Mia Grant", "how": "submission (kimura) 2:05"},
			{"d": -58, "open": "Autumn Open", "win": false, "opp": "Ines Costa", "how": "points 0-2"}],
		"belt_log": [{"d": -301, "t": "White belt", "note": "joined"}, {"d": -160, "t": "Stripe 1", "note": ""},
			{"d": -56, "t": "Stripe 2", "note": "after the Autumn Open"}]}


static func move_name(id: String) -> String:
	if NAMES.has(id):
		return str(NAMES[id])
	var s := id.replace("_", " ")
	return s.left(1).to_upper() + s.substr(1)


## The move the week's classes drill: the syllabus move she is closest to owning, until she owns it (a coach finishes a
## move before starting the next); "" when she owns them all.
## S364 the player may pick another plan (f["drill"]); a plan with nothing left to drill falls back to the coach's pick.
static func drilling(f: Dictionary, day: int = 0) -> String:
	return drilling_for(f, str(f.get("drill", "coach")), day)


static func drilling_for(f: Dictionary, plan: String, day: int = 0) -> String:
	var bjj: Dictionary = f.get("bjj", {})
	var best := ""
	# S375 the player's own pick (PLAYBOOK > her mat, Drill it): that move until it is a signature.
	if plan.begins_with("move:"):
		var mv := plan.trim_prefix("move:")
		if BeltRoad.moves_for(str(f.get("belt", "white"))).has(mv) and float(bjj.get(mv, 0.0)) < SIGNATURE:
			return mv
	match plan:
		"open":
			var g: Array = lean_group(f, opens_after(day + 1, 1)[0])
			var moves: Array = g[1] if not g.is_empty() else []
			var on := str(f.get("drill_on", ""))
			if moves.has(on) and float(bjj.get(on, 0.0)) < BeltRoad.OWNED_AT:
				return on
			var low := 1e9
			for m in moves:
				var v := float(bjj.get(m, 0.0))
				if v < BeltRoad.OWNED_AT and v < low:
					low = v
					best = m
			if best == "":
				var top := -1.0
				for m in moves:
					var v := float(bjj.get(m, 0.0))
					if v < SIGNATURE and v > top:
						top = v
						best = m
		"fav":
			var top := -1.0
			for m in BeltRoad.moves_for(str(f.get("belt", "white"))):
				var v := float(bjj.get(m, 0.0))
				if v >= BeltRoad.OWNED_AT and v < SIGNATURE and v > top:
					top = v
					best = m
	if best != "":
		return best
	var top2 := -1.0
	for m in BeltRoad.moves_for(str(f.get("belt", "white"))):
		var v := float(bjj.get(m, 0.0))
		if v < BeltRoad.OWNED_AT and v > top2:
			top2 = v
			best = m
	return best


## How much of a syllabus group she owns, 0..1 (each move counts up to the weapon level).
static func group_own(f: Dictionary, moves: Array) -> float:
	var s := 0.0
	for m in moves:
		s += minf(float((f.get("bjj", {}) as Dictionary).get(m, 0.0)), BeltRoad.OWNED_AT) / BeltRoad.OWNED_AT
	return s / maxf(1.0, moves.size())


static func groups_of(f: Dictionary) -> Array:
	return (BeltRoad.SYLLABUS.get(str(f.get("belt", "white")), {}) as Dictionary).get("groups", [])


## The group an open leans on at her belt: [name, moves] or [] (an open without a lean, or black belt).
static func lean_group(f: Dictionary, o: Dictionary) -> Array:
	var gs := groups_of(f)
	if gs.is_empty() or not o.has("lean"):
		return []
	return gs[int(o["lean"]) % gs.size()]


## Her edge in an open's lean: LEAN_W x (own - 0.5), plus SIGNATURE_BONUS for a signature move in the group.
static func lean_edge(f: Dictionary, o: Dictionary) -> float:
	var g := lean_group(f, o)
	if g.is_empty():
		return 0.0
	var sig := (g[1] as Array).any(func(m): return float((f.get("bjj", {}) as Dictionary).get(m, 0.0)) >= SIGNATURE)
	return LEAN_W * (group_own(f, g[1]) - 0.5) + (SIGNATURE_BONUS if sig else 0.0)


static func chance_word(p: float) -> String:
	return "LONG SHOT" if p < LONG_SHOT else ("FAVOURITE" if p > FAVOURITE else "EVEN")


## A week on the mat: the classes count, the drilled move gains. Returns the move drilled.
static func week(f: Dictionary, day: int = 0) -> String:
	f["mat_classes"] = int(f.get("mat_classes", 0)) + classes_of(f)
	train_body(f)
	var m := drilling(f, day)
	f["drill_on"] = m
	if m != "":
		var bjj: Dictionary = f.get_or_add("bjj", {})
		bjj[m] = minf(100.0, float(bjj.get(m, 0.0)) + gain_of(f) * (HUNGRY if int(f.get("held", 0)) > 0 else 1.0))
	return m


## The week's classes on her body (S389: both the coach's plan and a tree plan call this).
static func train_body(f: Dictionary) -> void:
	var stats: Dictionary = f.get_or_add("stats", {})
	for k in BODY_GAIN:
		stats[k] = minf(BODY_CEIL, float(stats.get(k, BODY_START)) + body_gain(f, k))


## This week's gain to her `key` (cardio / strength) from her own classes.
static func body_gain(f: Dictionary, key: String) -> float:
	var v := float((f.get("stats", {}) as Dictionary).get(key, BODY_START))
	return float(BODY_GAIN.get(key, 0.0)) * float(classes_of(f)) / CLASSES_PER_WEEK * maxf(0.0, 1.0 - v / BODY_CEIL)


## S365 her own classes a week: one fewer while she teaches the beginners' class (BjjSide.TEACH_CLASSES).
static func classes_of(f: Dictionary) -> int:
	return CLASSES_PER_WEEK - (TEACH_CLASSES if bool(f.get("teaches", false)) else 0)


## The drilled move's gain a week, in proportion to her own classes.
static func gain_of(f: Dictionary) -> float:
	return DRILL_GAIN * float(classes_of(f)) / CLASSES_PER_WEEK


## Stripes due now that the professor has not given yet (0 at black or at 4).
static func stripes_due(f: Dictionary, today: int) -> int:
	if BeltRoad.next_belt(str(f.get("belt", "white"))) == "":
		return 0
	return maxi(0, int(BeltRoad.readiness(f, f.get("bjj", {}), today)["stripes"]) - int(f.get("stripes", 0)))


## Weeks to ready at this plan: the slower of the mat time and the syllabus (each move drilled in turn to OWNED_AT).
static func weeks_to_ready(f: Dictionary, today: int) -> int:
	var r := BeltRoad.readiness(f, f.get("bjj", {}), today)
	var cls_weeks := ceili(float(int(r["mat"][1]) - int(r["mat"][0])) / classes_of(f))
	var move_weeks := 0
	for m in BeltRoad.moves_for(str(f.get("belt", "white"))):
		move_weeks += ceili(maxf(0.0, BeltRoad.OWNED_AT - float((f.get("bjj", {}) as Dictionary).get(m, 0.0))) / gain_of(f))
	return maxi(maxi(cls_weeks, move_weeks), ceili(int(r["days_left"]) / 7.0))


## The syllabus group she is best at (the coach's "Ana's escapes are solid").
static func best_group(f: Dictionary) -> String:
	var best := ""
	var top := -1.0
	for g in (BeltRoad.SYLLABUS.get(str(f.get("belt", "white")), {}) as Dictionary).get("groups", []):
		var own := 0.0
		for m in g[1]:
			own += float((f.get("bjj", {}) as Dictionary).get(m, 0.0))
		own /= maxf(1.0, (g[1] as Array).size())
		if own > top:
			top = own
			best = str(g[0])
	return best


## The opens from `day` on: [{"d", "name", "fee"}], the next `n`.
static func opens_after(day: int, n: int = 2) -> Array:
	var k := maxi(0, ceili(float(day - OPEN_FIRST) / OPEN_EVERY))
	var out: Array = []
	for i in n:
		var o: Array = OPENS[(k + i) % OPENS.size()]
		out.append({"d": OPEN_FIRST + (k + i) * OPEN_EVERY, "name": str(o[0]), "fee": int(o[1]), "lean": (k + i) % 3})
	return out


static func open_on(day: int) -> Dictionary:
	for o in opens_after(day, 1):
		if int(o["d"]) == day:
			return o
	return {}


## Her chance to win one match against her own belt's field.
static func win_chance(f: Dictionary, today: int, o: Dictionary = {}) -> float:
	var share := float(BeltRoad.readiness(f, f.get("bjj", {}), today)["share"])
	var mood := (float(f.get("morale", MORALE_START)) - MORALE_START) / MORALE_SPAN - (TOUGH if bool(f.get("tough_next", false)) else 0.0)
	return clampf(WIN_BASE + WIN_SLOPE * share + mood + lean_edge(f, o), WIN_RANGE.x, WIN_RANGE.y)


## One open, single elimination: she fights until she loses or wins the final. Returns {"matches": [record rows],
## "wins", "medal": "gold" | "silver" | "bronze" | ""}.
static func run_open(f: Dictionary, o: Dictionary, today: int, rng: RandomNumberGenerator) -> Dictionary:
	var p := win_chance(f, today, o)
	var rounds := int(round(log(float(BRACKET)) / log(2.0)))
	var mins := BeltRoad.match_minutes(str(f.get("belt", "white")))
	var owned_subs := SUBS.filter(func(s): return float((f.get("bjj", {}) as Dictionary).get(s, 0.0)) >= BeltRoad.OWNED_AT)
	var matches: Array = []
	var wins := 0
	for r in rounds:
		var won := rng.randf() < p
		var opp := "%s %s" % [OPP_FIRST[rng.randi() % OPP_FIRST.size()], OPP_LAST[rng.randi() % OPP_LAST.size()]]
		var how := ""
		if rng.randf() < SUB_SHARE and (not won or not owned_subs.is_empty()):
			var sub := str(owned_subs[rng.randi() % owned_subs.size()]) if won else str(SUBS[rng.randi() % 5])
			var secs := rng.randi_range(40, mins * 60 - 5)
			how = "submission (%s) %d:%02d" % [move_name(sub).to_lower(), secs / 60, secs % 60]
		else:
			var hi := _points(rng, rng.randi_range(1, 3))
			var lo := mini(hi - 2, _points(rng, rng.randi_range(0, 1)))
			how = "points %d-%d" % ([hi, maxi(0, lo)] if won else [maxi(0, lo), hi])
		matches.append({"d": today, "open": str(o["name"]), "win": won, "opp": opp, "how": how})
		if not won:
			break
		wins += 1
	var medal := "gold" if wins == rounds else ("silver" if wins == rounds - 1 else ("bronze" if wins == rounds - 2 else ""))
	return {"matches": matches, "wins": wins, "medal": medal}


static func _points(rng: RandomNumberGenerator, events: int) -> int:
	var kinds: Array = BeltRoad.POINTS.values()
	var s := 0
	for i in events:
		s += int(kinds[rng.randi() % kinds.size()])
	return s
