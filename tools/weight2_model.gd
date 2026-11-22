extends RefCounted
## S536 WEIGHT2R5 - the scratch weight model of the WEIGHT2 greybox probe, round 5 (ops/research/TASK_WEIGHT2R5.md). Run by
## tools/weight2_probe.gd (the fit and round 4's tables) and tools/weight2_round5.gd (the policy table, frame, the field's cut).
## Nothing here is in scripts/. Real: Data's boxers and region sheets, AttrGen.body, WeighGap, every bout through BoutNight.
## Scratch: the weight sums below. Round 5 changes (the code-checked critic's items 1 to 4): water comes off first up to the
## free 2 %; the opponent keeps a height and a reach drawn from the class boxed at, from that division's own sheet; the field
## cuts and pays John's table; three scales (club show, championship, pro) instead of the amateur hybrid.

const Data := preload("res://scripts/state/Data.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const WeighGap := preload("res://scripts/rules/WeighGap.gd")

## The scratch class table (kg): the design's proposed one, so every boxer has a class above and below (men's 65 = Q-292).
const LIMITS := {"f": [54.0, 57.0, 60.0, 65.0, 70.0, 75.0, 81.0], "m": [55.0, 60.0, 65.0, 70.0, 75.0, 80.0, 86.0]}
## who = Data id; over = kilos added to the Data walking weight (the cutter has grown out of her class).
const BOXERS := [
	{"shape": "puncher", "who": "samira", "over": 0.0}, {"shape": "volume", "who": "josh", "over": 0.0}, {"shape": "big chin", "who": "tess", "over": 0.0},
	{"shape": "drained cutter", "who": "kira", "over": 2.5}, {"shape": "boxer-puncher", "who": "danny", "over": 0.0},
]
## John's numbers by scale (tags in DESIGN_WEIGHT2_V2.md section 2). regain = % of body mass an amateur has back by the bell
## (never more than he took off); a pro gets back a SHARE of the water he took off (0.9 on average, four nights in five
## 0.8125, one in five 1.25: round 4). free = the water that costs nothing; cond / power / read = % of the stat lost per 1 %
## past it (cond2 / power2: the extra past the knee); water_ok = the safe line; cap = past it he cannot make the scale;
## days = boxing days in a row, each with its own scale; miss = what a missed scale is: "gap" (club show, WeighGap: the bout
## is on when the two are still inside the gap, else re-matched one time in three, else off and $300, nothing on the record),
## "walkover" (a loss, and out of the draw), "fine" (he boxes on). opp_cut = what the field takes off, one drawn a night
## (ESTIMATE spread; pro mean 8 % x 0.9 = John's 7.2 % regain, and the 10 % cutter rings 9 % over = his "one in five 10 %").
## opp_back = the most an amateur opponent has back; opp_short = % a club-show opponent weighs under the line (ESTIMATE:
## TapeRows.opp_weight invents 0.2 to 0.8 kg under).
const SCALES := [
	{"id": "club", "name": "club show: weighed an hour before, the gap rule, 3 rounds", "pro": false, "rounds": 3, "days": 1, "regain": 0.5, "miss": "gap",
		"free": 2.0, "cond": 4.0, "power": 1.5, "read": 1.0, "knee": 99.0, "cond2": 0.0, "power2": 0.0, "water_ok": 3.0, "cap": 5.0, "miss_base": 0.01,
		"opp_cut": [0.0], "opp_back": 0.0, "opp_short": 1.0, "opp_off": -3.0},
	{"id": "champ", "name": "championship: weighed three hours before on each of three boxing days, 3 rounds", "pro": false, "rounds": 3, "days": 3, "regain": 1.9, "miss": "walkover",
		"free": 2.0, "cond": 4.0, "power": 1.5, "read": 1.0, "knee": 99.0, "cond2": 0.0, "power2": 0.0, "water_ok": 3.0, "cap": 5.0, "miss_base": 0.01,
		"opp_cut": [2.0, 3.0, 4.0], "opp_back": 1.9, "opp_short": 0.0, "opp_off": -3.0},
	{"id": "pro", "name": "pro: weighed the day before, 6 rounds", "pro": true, "rounds": 6, "days": 1, "share": 0.8125, "share_big": 1.25, "big_odds": 0.2, "share_mean": 0.9, "miss": "fine",
		"free": 2.0, "cond": 1.5, "power": 0.0, "read": 0.5, "knee": 5.0, "cond2": 1.5, "power2": 1.0, "water_ok": 8.0, "cap": 8.0, "miss_base": 0.02,
		"opp_cut": [6.0, 7.0, 8.0, 9.0, 10.0], "opp_share": 0.9, "opp_short": 0.0, "opp_off": -6.0},
]
const CHOICES := ["STAY", "CUT", "UP", "DOWN"]
const POLICIES := ["DIET", "WATER", "MIX", "UP"]
const LEVERS := ["drain", "size", "diet", "miss", "rank", "refuse", "frame", "field"]
const MODEL := {
	"cut_water": 0.04,         # CUT harder: he walks big enough that 4 % of body is left for water at his own class line (round 4)
	"up_fill": 0.015,          # UP as a class choice: eats freely, fills out this share of body (ESTIMATE)
	"diet_hold": 2.5,          # % of walking weight a Lean diet holds off (ESTIMATE), 5 % (Strip) on a move DOWN
	"diet_hold_down": 5.0,
	"diet_pace": 0.7,          # % of body a week that keeps lean mass (SOURCED, Garthe 2011)
	"size_power": 1.2, "size_chin": 1.0, "size_speed": 0.4, "size_cap": 8.0,          # points per 1 % ring-weight gap (ESTIMATE split; the total is fitted)
	"size_win": 3.0,           # John B (DERIVED, Baribeau 2023, 1,392 pros): wins in 100 per 1 % heavier at even odds
	"grow": 0.33, "diet_cost": 0.12, "grow_min": 0.4,                                 # stat points a bout cycle; x (1 - cost x % held) (ESTIMATE)
	"miss_slope": 0.20, "miss_max": 0.7,                                               # a % of water past the safe line, x (1.5 - discipline / 100) (ESTIMATE)
	"miss_push": 2,            # John C: two misses and he is moved up a class
	"rung0": 10.0, "rung_move": 11.0, "rung_gap": 1.2, "rung_max": 20.0, "field_grow": 0.15,   # round 2: a move costs ONE rung
	"refuse_up": 0.30, "refuse_down": 0.50, "refuse_conf": 0.005, "refuse_loyal": 0.006, "refuse_wish": 0.25, "refuse_wait": 3,   # Q-293 (design numbers)
	"carry": 0.74,             # the share of a cut's cost still there 24 hours on (DERIVED by me: Barley 2018, 19 % slower at 3 h, 14 % at 24 h); each boxing day adds its own
	"fade_at": 15.0,           # an opponent whose cut costs 15 % of Stamina or more "fades" on the game's own word (AttrGen: Stamina -14) instead of in his rating (ESTIMATE line)
	"opp_stat": 60.0,          # the field boxer's stat level, to turn a % cost into points (ESTIMATE)
	"read_width": 1.5,         # the tape's read of the opponent's cut: +- this many % (ESTIMATE: a "rough" Knowledge range)
	"read_hard": 9.0,          # the plan boxes him late ("Let your hands go" from round 3) when the read says he cut this much
}
const PLANS := [
	{"arrows": [{"move": "1-2"}, {"move": "step_in"}, {"move": "cut_off"}, {"move": "tie_up"}], "combos": {"1-2": 60.0, "1-1": 45.0}},
	{"arrows": [{"move": "2-3"}, {"move": "feint"}, {"move": "pivot_out"}, {"move": "1-2"}], "combos": {"2-3": 60.0, "1-2": 50.0}},
]
const DAY0 := 50000

var L: Array = []
var t0 := 0
var n_bouts := 0
var size_rating := 0.35     # fitted in step 0: rating points the opponent is worth per 1 % he outweighs us
var frame_rate := 0.0       # fitted in step 0: rating points a cm of class frame is worth on average (taken back out of a class move, so size is not counted twice)
var opp_off := {"club": -3.0, "champ": -3.0, "pro": -6.0}   # fitted in step 0: the field, so that STAY wins about half
var _pools := {}

static func person(id: String) -> Dictionary:
	for p in Data.PROSPECTS:
		if str(p["id"]) == id:
			return (p as Dictionary).duplicate(true)
	return Data.lucy()

static func limit0(t: Dictionary) -> float: return float(Data.DIVISIONS[str(t["div"])]["limit"])

## The class limit a step away from the boxer's own (step +1 up, -1 down), on the scratch table.
static func class_step(t: Dictionary, step: int) -> float:
	var own := limit0(t)
	var row: Array = LIMITS[str(t["sex"])]
	var i := 0
	for k in row.size():
		if absf(float(row[k]) - own) < absf(float(row[i]) - own):
			i = k
	return float(row[clampi(i + step, 0, row.size() - 1)])

## The mean height and reach of a class (AttrGen.body without its noise): [height, reach] in cm.
static func class_frame(sex: String, limit: float) -> Array:
	var h := 172.0 + (limit - 60.0) - (0.0 if sex == "m" else 8.0)
	return [h, h + 3.0]

## Split what he is over into diet and water: water first up to the free 2 %, the diet next up to its hold, water for the rest.
static func _split(ch: String, own: float, limit: float, walk: float, hold: float) -> Dictionary:
	var over := maxf(0.0, walk - limit) / walk * 100.0
	var w := minf(over, 2.0)
	var d := minf(over - w, hold)
	return {"ch": ch, "own": own, "limit": limit, "walk": walk, "diet": d, "water": over - d, "moved": limit != own, "carried": false}

## One of round 4's four class choices as a weight plan. CUT = walk big enough that cut_water of body is left for water at
## his own line after the Lean diet (never smaller than he is); UP = filled out by up_fill.
static func plan_choice(cell: Dictionary, ch: String) -> Dictionary:
	var t := person(str(cell["b"]["who"]))
	var own := limit0(t)
	var walk := float(t["weight"]) + float(cell["b"]["over"])
	var limit := class_step(t, 1 if ch == "UP" else (-1 if ch == "DOWN" else 0))
	if ch == "CUT":
		walk = maxf(walk, own / (1.0 - float(MODEL["diet_hold"]) / 100.0 - float(MODEL["cut_water"])))
	elif ch == "UP":
		walk *= 1.0 + float(MODEL["up_fill"])
	return _split(ch, own, limit, walk, float(MODEL["diet_hold_down"] if ch == "DOWN" else MODEL["diet_hold"]))

## Round 5: the same kilos (x % over his own line) by one of four policies. DIET = Lean covers what it can past the free
## water; WATER = Hold, all of it by water; MIX = half and half past the free water; UP = carried: at a club show he boxes
## his own class heavy when the gap rule lets him (WeighGap), else the class above with no cut.
static func plan_policy(cell: Dictionary, pol: String) -> Dictionary:
	var t := person(str(cell["b"]["who"]))
	var own := limit0(t)
	var walk := own * (1.0 + float(cell["x"]) / 100.0)
	var over := (walk - own) / walk * 100.0
	var sc: Dictionary = cell["sc"]
	var p := {"ch": pol, "own": own, "limit": own, "walk": walk, "diet": 0.0, "water": over, "moved": false, "carried": false}
	match pol:
		"DIET":
			p["diet"] = minf(maxf(0.0, over - 2.0), float(MODEL["diet_hold"]))
		"MIX":
			p["diet"] = minf(maxf(0.0, over - 2.0) / 2.0, float(MODEL["diet_hold"]))
		"UP":
			if str(sc["miss"]) == "gap" and walk - own * (1.0 - float(sc["opp_short"]) / 100.0) <= WeighGap.gap_kg(own):
				p["water"] = 0.0; p["carried"] = true
				return p
			return _split(pol, own, class_step(t, 1), walk, float(MODEL["diet_hold"]))
	p["water"] = over - float(p["diet"])
	return p

## What a cut of w % costs on this scale (% of the stat), x the boxing day's carry-over.
static func cost(sc: Dictionary, w: float, dm: float) -> Dictionary:
	var x := maxf(0.0, w - float(sc["free"]))
	var x2 := maxf(0.0, w - float(sc["knee"]))
	return {"cond": (float(sc["cond"]) * x + float(sc["cond2"]) * x2) * dm, "power": (float(sc["power"]) * x + float(sc["power2"]) * x2) * dm, "read": float(sc["read"]) * x * dm}

## The weight sums of one plan on one night. off = the lever switched off; share = the night's regain share of a pro
## (-1 = the average night); day = boxing day of the draw (0 first); cut = what the opponent took off (-1 = the field's mean).
func night(t: Dictionary, plan: Dictionary, sc: Dictionary, off: String, share: float = -1.0, day: int = 0, cut: float = -1.0) -> Dictionary:
	var limit := float(plan["limit"]); var walk := float(plan["walk"])
	var water_pct := float(plan["water"])
	var water_kg := walk * water_pct / 100.0
	var scale_w := walk * (1.0 - float(plan["diet"]) / 100.0) - water_kg
	var back := minf(water_kg, float(sc.get("regain", 0.0)) / 100.0 * limit)
	if bool(sc["pro"]):
		back = water_kg * (float(sc["share_mean"]) if share < 0.0 else share)
	var ring := scale_w + back
	var dm := 1.0
	for i in day:
		dm = 1.0 + float(MODEL["carry"]) * dm
	var cuts: Array = sc["opp_cut"]
	var c := cut
	if c < 0.0:
		c = 0.0
		for v in cuts:
			c += float(v) / float(cuts.size())
	var oc := cost(sc, c, dm)
	var fade := float(oc["cond"]) >= float(MODEL["fade_at"]) and off != "field"
	var drop := ((0.0 if fade else float(oc["cond"])) + float(oc["power"]) + 2.0 * float(oc["read"])) * float(MODEL["opp_stat"]) / 100.0 / 6.0
	if off == "field":
		drop = 0.0
	var opp_pct := (float(sc["opp_share"]) * c if bool(sc["pro"]) else minf(c, float(sc["opp_back"]))) - float(sc["opp_short"])
	var opp_ring := limit * (1.0 + opp_pct / 100.0)
	var gap := (ring - opp_ring) / opp_ring * 100.0
	var mc := cost(sc, water_pct, dm)
	if off == "drain":
		mc = {"cond": 0.0, "power": 0.0, "read": 0.0}
	if off == "size":
		gap = 0.0
	var cap := float(MODEL["size_cap"])
	var add := {"power": clampf(float(MODEL["size_power"]) * gap, -cap, cap), "chin": clampf(float(MODEL["size_chin"]) * gap, -cap, cap),
		"speed": -clampf(float(MODEL["size_speed"]) * gap, -cap, cap)}
	var mult := {"conditioning": 1.0 - float(mc["cond"]) / 100.0, "power": 1.0 - float(mc["power"]) / 100.0, "defense": 1.0 - float(mc["read"]) / 100.0, "fight_iq": 1.0 - float(mc["read"]) / 100.0}
	var held := 0.0 if off == "diet" else float(plan["diet"])
	var disc := float(t["personality"]["discipline"])
	var p_miss := 1.0
	if water_pct <= float(sc["cap"]):
		p_miss = clampf(float(sc["miss_base"]) + maxf(0.0, water_pct - float(sc["water_ok"])) * float(MODEL["miss_slope"]) * (1.5 - disc / 100.0), 0.0, float(MODEL["miss_max"]))
	if water_pct <= 0.0 or off == "miss":
		p_miss = 0.0
	return {"limit": limit, "walk": walk, "over": maxf(0.0, walk - limit), "diet": float(plan["diet"]), "water": water_pct, "scale": scale_w, "ring": ring, "gap": gap,
		"dry": (water_kg - back) / walk * 100.0, "weeks": float(plan["diet"]) / float(MODEL["diet_pace"]), "keep": clampf(1.0 - float(MODEL["diet_cost"]) * held, float(MODEL["grow_min"]), 1.0),
		"p_miss": p_miss, "add": add, "mult": mult, "cond_pct": float(mc["cond"]), "tank": minf(BoutRules.TANK_MAX, float(mc["cond"])),
		"cut": c, "drop": drop, "fade": fade, "opp_ring": opp_ring}

## The chance he says no to a class choice (Q-293): only a move can be refused; a boxer his own class is hurting wants up.
func p_refuse(cell: Dictionary, ch: String, off: String) -> float:
	if (ch != "UP" and ch != "DOWN") or off == "refuse":
		return 0.0
	var t := person(str(cell["b"]["who"]))
	var pers: Dictionary = t["personality"]
	var p := float(MODEL["refuse_up"] if ch == "UP" else MODEL["refuse_down"]) + (float(pers["confidence"]) - 60.0) * float(MODEL["refuse_conf"]) - (float(pers["loyalty"]) - 50.0) * float(MODEL["refuse_loyal"])
	if float(plan_choice(cell, "STAY")["water"]) > float(cell["sc"]["water_ok"]):
		p = 0.05 if ch == "UP" else p + float(MODEL["refuse_wish"])
	return clampf(p, 0.05, 0.9)

## The opponents of the class boxed at: the sheet of Data's division nearest that limit, the 68+ mismatches left out.
func pool_of(sex: String, limit: float) -> Array:
	var key := "%s%.0f" % [sex, limit]
	if _pools.has(key):
		return _pools[key]
	var div := ""
	for d in Data.DIVISIONS:
		if str(Data.DIVISIONS[d]["sex"]) == sex and (div == "" or absf(float(Data.DIVISIONS[d]["limit"]) - limit) < absf(float(Data.DIVISIONS[div]["limit"]) - limit)):
			div = str(d)
	var out: Array = []
	var all: Array = Data.OPPONENTS + Data.RIVALS + Data.DIVISION_RIVALS
	for o in all:
		if str((o as Dictionary).get("div", "wlw")) == div and float(o["rating"]) < 68.0:
			out.append(o)
	_pools[key] = out
	return out

## One bout on fight night's own code. ni = the night's sums (add, mult, tank, fade); body = the class the opponent's
## height and reach are drawn from (0 = erased, the frame lever off); late = "" the game's own corner (BoutNight.play_out),
## else that call from round 3 on (the plan read the opponent's cut). Returns {outcome, stop, late_w, late_n}.
func bout(t: Dictionary, sc: Dictionary, ni: Dictionary, rating: float, limit: float, body: float, seed_i: int, k: int, grown: float, late: String = "") -> Dictionary:
	var day := DAY0 + seed_i * 211 + k * 7
	var f := Data.fighter_state(t.duplicate(true), day)
	for st in ["power", "speed", "technique", "defense", "conditioning", "fight_iq"]:
		f["stats"][st] = float(f["stats"][st]) + grown
	var mult: Dictionary = ni.get("mult", {})
	var add: Dictionary = ni.get("add", {})
	for st in mult:
		f["stats"][st] = float(f["stats"][st]) * float(mult[st])
	for st in add:
		f["stats"][st] = float(f["stats"][st]) + float(add[st])
	for st in ["power", "speed", "chin", "conditioning", "defense", "fight_iq"]:
		f["stats"][st] = clampf(float(f["stats"][st]), 20.0, 95.0)
	var pl: Dictionary = PLANS[1 if bool(sc["pro"]) else 0]
	f = f.merged({"pro": bool(sc["pro"]), "morale": 60.0, "camp": {}, "week_fatigue": 20.0, "notes_seen": [], "limit": limit,
		"arrows": (pl["arrows"] as Array).duplicate(true), "combos": (pl["combos"] as Dictionary).duplicate()}, true)
	f.erase("last_bout_day")
	var pool := pool_of(str(t["sex"]), limit)
	var opp: Dictionary = (pool[(seed_i * 7 + k * 3 + int(day)) % pool.size()] as Dictionary).duplicate(true)
	opp["rating"] = rating
	opp.erase("height"); opp.erase("reach")
	if body > 0.0:
		var rng := RandomNumberGenerator.new()
		rng.seed = hash([str(opp["name"]), body])
		var bd: Dictionary = AttrGen.body(rng, "men" if str(t["sex"]) == "m" else "f", body)
		opp["height"] = bd["height"]; opp["reach"] = bd["reach"]
	if bool(ni.get("fade", false)):
		opp["weak"] = "Fades after round 2"
	f["bout"] = {"opp": opp, "day": day, "weighed": true, "made": true, "done": false, "film": 1, "rounds": int(sc["rounds"]), "stale": float(ni.get("tank", 0.0))}
	var c := Career.new()
	c.day = day; c.seed = seed_i + 1; c.coach = {"rating": 60.0}; c.fighters = [f]
	var m := {"type": "fight", "fid": f["id"], "step": "tape", "round": 0, "rounds": [], "total": int(sc["rounds"])}
	if late == "":
		BoutNight.play_out(c, f, m)
	else:   # BoutNight._box_out with one difference: the corner's call from round 3 is the plan's
		BoutNight.fight_step(c, f, m, "start")
		BoutNight._shout_out(c, f, m)
		var total := BoutNight.rounds_of(f)
		while int(m["round"]) < total and BoutNight.stopped(m) == "" and not BoutNight.TowelWire.coach_pull(c, f, m) and not BoutNight.CrackWire.bell(c, f, m, total):
			BoutNight._open(c, f, m, late if int(m["round"]) + 1 >= 3 else BoutRules.auto_corner(f["stats"]))
			BoutNight._shout_out(c, f, m)
	n_bouts += 1
	var res := {"outcome": BoutNight.outcome_of(f, m), "stop": BoutNight.stopped(m) != "", "late_w": 0, "late_n": 0}
	var late_from := int(ceil(float(sc["rounds"]) * 2.0 / 3.0)) + 1
	for r in m["rounds"]:
		if int(r["n"]) >= late_from:
			res["late_n"] = int(res["late_n"]) + 1
			res["late_w"] = int(res["late_w"]) + int(bool(r["won"]))
	return res

## One run: N bout slots for one boxer. pl = {main, fallback (boxed while he refuses), forced (after two misses), p_refuse,
## tag}. read = "" (the game's corner), "range" or "exact": the plan reads the opponent's cut off the tape. Returns the counts.
func run(cell: Dictionary, pl: Dictionary, seed_i: int, bouts: int, off: String, read: String = "") -> Dictionary:
	var t := person(str(cell["b"]["who"]))
	var sc: Dictionary = cell["sc"]
	var sid := str(sc["id"])
	var days := int(sc["days"])
	var base := BoutRules.fight_power(t["stats"], {}, 0, "", false)
	var rng := RandomNumberGenerator.new()
	var cur: Dictionary = pl["main"]
	var wait := -1
	rng.seed = hash([str(cell["id"]), seed_i, str(pl["tag"]), "refuse"])
	if rng.randf() < float(pl["p_refuse"]):
		cur = pl["fallback"]; wait = int(MODEL["refuse_wait"])
	var step := (float(MODEL["rung_move"]) - float(MODEL["rung0"])) if off != "rank" else 0.0
	var rung := float(MODEL["rung0"]) + (step if bool(cur["moved"]) else 0.0)
	var grown := 0.0; var misses := 0; var alive := true
	var res := {"wins": 0, "fought": 0, "stop_w": 0, "stop_l": 0, "late_w": 0, "late_n": 0, "missed": 0, "void": 0, "forced": 0, "refused": int(wait >= 0),
		"hard_n": 0, "hard_w": 0, "hard_lw": 0, "hard_ln": 0, "rung": rung}
	for k in bouts:
		if k == wait:
			cur = pl["main"]; rung = minf(float(MODEL["rung_max"]), rung + (step if bool(cur["moved"]) else 0.0))
		if k % days == 0:
			alive = true
		rng.seed = hash([str(cell["id"]), seed_i, k])
		var u := rng.randf()
		var share := float(sc["share_big"] if rng.randf() < float(sc["big_odds"]) else sc["share"]) if bool(sc["pro"]) else -1.0
		var cuts: Array = sc["opp_cut"]
		var cut := float(cuts[mini(cuts.size() - 1, int(rng.randf() * float(cuts.size())))])
		var short_kg := rng.randf() * 2.0 * float(sc["opp_short"]) / 100.0 * float(cur["limit"])
		var rematch := rng.randf() < WeighGap.REMATCH_CHANCE
		var seen := cut + (rng.randf() * 2.0 - 1.0) * (float(MODEL["read_width"]) if read == "range" else 0.0)
		var ni := night(t, cur, sc, off, share, k % days, cut)
		grown += float(MODEL["grow"]) * float(ni["keep"])
		if not alive:
			continue   # out of the draw: no bout on this boxing day
		var missed := u < float(ni["p_miss"])
		var on := true
		var gap := float(ni["gap"])
		if missed:
			res["missed"] = int(res["missed"]) + 1
			match str(sc["miss"]):
				"walkover":
					misses += 1; on = false; alive = false
					rung = minf(float(MODEL["rung_max"]), rung + 1.0)
				"fine":
					misses += 1
				"gap":   # he comes in over by the water past the safe line; WeighGap decides
					var over_kg := maxf(0.2, (float(ni["water"]) - float(sc["water_ok"])) / 100.0 * float(ni["walk"]))
					if over_kg + short_kg <= WeighGap.gap_kg(float(cur["limit"])):
						gap += over_kg / float(ni["opp_ring"]) * 100.0
					elif rematch:
						gap = 0.0
					else:
						on = false
			if not on:
				res["void"] = int(res["void"]) + 1
		if on:
			var body := 0.0 if off == "frame" else float(cur["limit"])
			var rating := base + float(opp_off[sid]) + float(MODEL["field_grow"]) * float(k) + (float(MODEL["rung0"]) - rung) * float(MODEL["rung_gap"]) \
				- size_rating * (0.0 if off == "size" else gap) - float(ni["drop"]) - (0.0 if off == "frame" else frame_rate * (float(cur["limit"]) - float(cur["own"])))
			var hard := cut >= float(MODEL["read_hard"])
			var late := "let_go" if read != "" and seen >= float(MODEL["read_hard"]) else ""
			var o := bout(t, sc, ni, rating, float(cur["limit"]), body, seed_i, k, grown, late)
			var stop := bool(o["stop"])
			res["fought"] = int(res["fought"]) + 1
			res["late_w"] = int(res["late_w"]) + int(o["late_w"])
			res["late_n"] = int(res["late_n"]) + int(o["late_n"])
			if hard:
				res["hard_n"] = int(res["hard_n"]) + 1
				res["hard_w"] = int(res["hard_w"]) + int(str(o["outcome"]) == "win")
				res["hard_lw"] = int(res["hard_lw"]) + int(o["late_w"])
				res["hard_ln"] = int(res["hard_ln"]) + int(o["late_n"])
			alive = str(o["outcome"]) == "win"
			if str(o["outcome"]) == "win":
				res["wins"] = int(res["wins"]) + 1
				rung = maxf(1.0, rung - (1.5 if stop else 1.0))
				if stop: res["stop_w"] = int(res["stop_w"]) + 1
			elif str(o["outcome"]) == "loss":
				rung = minf(float(MODEL["rung_max"]), rung + 1.0)
				if stop: res["stop_l"] = int(res["stop_l"]) + 1
		if missed and misses >= int(MODEL["miss_push"]) and str(cur["ch"]) != str(pl["forced"]["ch"]):
			cur = pl["forced"]
			rung = minf(float(MODEL["rung_max"]), rung + step)
			misses = 0; wait = -1; res["forced"] = 1
	res["rung"] = rung
	return res

## The three plans of a class choice: refused -> STAY while he waits; two misses -> a class up (from DOWN: back to his own).
func plans_choice(cell: Dictionary, ch: String, off: String) -> Dictionary:
	return {"main": plan_choice(cell, ch), "fallback": plan_choice(cell, "STAY"), "forced": plan_choice(cell, "STAY" if ch == "DOWN" else "UP"),
		"p_refuse": p_refuse(cell, ch, off), "tag": ch}

## The plans of a policy: nobody is asked (the same kilos are priced, not his answer); two misses -> the class above.
func plans_policy(cell: Dictionary, pol: String) -> Dictionary:
	var t := person(str(cell["b"]["who"]))
	var up := _split("UP", limit0(t), class_step(t, 1), limit0(t) * (1.0 + float(cell["x"]) / 100.0), float(MODEL["diet_hold"]))
	var main := plan_policy(cell, pol)
	return {"main": main, "fallback": main, "forced": up, "p_refuse": 0.0, "tag": pol}

static func agg(runs: Array) -> Dictionary:
	var s := {}
	for k in ["wins", "fought", "stop_w", "stop_l", "late_w", "late_n", "missed", "void", "forced", "refused", "hard_n", "hard_w", "hard_lw", "hard_ln", "rung"]:
		s[k] = 0.0
	var r2 := 0.0
	for r in runs:
		for k in s:
			s[k] = float(s[k]) + float(r[k])
		r2 += float(r["rung"]) * float(r["rung"])
	var n := maxf(1.0, float(runs.size()))
	var ru := float(s["rung"])
	var sd := sqrt(maxf(0.0, r2 / n - (ru / n) * (ru / n)) * n / maxf(1.0, n - 1.0))
	var fo := maxf(1.0, float(s["fought"]))
	return {"win": float(s["wins"]) / fo, "stop_w": float(s["stop_w"]) / fo, "stop_l": float(s["stop_l"]) / fo, "late": float(s["late_w"]) / maxf(1.0, float(s["late_n"])),
		"missed": float(s["missed"]) / n, "void": float(s["void"]) / n, "rung": ru / n, "se": sd / sqrt(n), "forced": float(s["forced"]) / n, "refused": float(s["refused"]) / n,
		"fought": float(s["fought"]) / n, "n_win": float(s["wins"]), "n_fought": float(s["fought"]), "n_stop_w": float(s["stop_w"]), "n_stop_l": float(s["stop_l"]), "sum": s}

## The best of a cell: the lowest ladder place; inside 0.1 of a rung, the higher win share (round 2's rule).
static func best(ag: Dictionary, keys: Array) -> String:
	var b := str(keys[0])
	for ch in keys:
		var d := float(ag[ch]["rung"]) - float(ag[b]["rung"])
		if d < -0.1 or (absf(d) <= 0.1 and float(ag[ch]["win"]) > float(ag[b]["win"])):
			b = ch
	return b

## Ladder place of a against b, seed by seed (the same seeds fought the same nights): [mean difference, its standard error].
static func diff(a: Array, b: Array) -> Array:
	var n := float(mini(a.size(), b.size()))
	var s := 0.0; var s2 := 0.0
	for i in int(n):
		var d := float(a[i]["rung"]) - float(b[i]["rung"])
		s += d; s2 += d * d
	var mean := s / n
	return [mean, sqrt(maxf(0.0, s2 / n - mean * mean) * n / maxf(1.0, n - 1.0)) / sqrt(n)]

## The choices inside the noise of the best: a mean difference to the best under two standard errors of it is a tie.
static func ties(by: Dictionary, b: String, keys: Array) -> Array:
	var out: Array = []
	for ch in keys:
		var d: Array = diff(by[ch], by[b])
		if ch != b and float(d[0]) <= 2.0 * float(d[1]):
			out.append(ch)
	return out

func secs() -> float: return float(Time.get_ticks_msec() - t0) / 1000.0

func say(v: Variant) -> void:
	var lines: Array = v if v is Array else [v]
	for s in lines:
		print(s); L.append(s)
