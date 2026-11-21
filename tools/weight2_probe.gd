extends SceneTree
## S535 WEIGHTMOVE1 - WEIGHT2 greybox probe (ops/research/TASK_WEIGHTMOVE1.md, DESIGN_WEIGHT2.md section 4).
## Measures the design's SCRATCH weight model before anything is built: nothing here is in scripts/.
## Real Data people (never quick_start's one boxer), each bout through fight night's own code (BoutNight.play_out on a
## scratch Career, PlanTest's way: the dice are the fight DAY's, and every choice of one seed fights the same days).
## 10 cells = 5 boxers (puncher, volume, big chin, drained cutter, plain boxer-puncher) x 2 scales (amateur: weighed on
## the day, 3 rounds; pro: weighed the day before, 6 rounds). 4 choices: STAY, CUT harder (walk 2 kg bigger, same class),
## UP a class, DOWN a class. Each (cell, choice, seed) is a run of N bouts on a 20-rung ladder (round 2; round 1 = 875376421).
## The scratch model (every number an ESTIMATE, JOHN_WEIGHT2_ASK.md): see MODEL below and _setup().
## PASS = each lever moves the result AND no single choice is best in more than 6 of the 10 cells.
##   python ops/Tools/godot_slot.py run --who weight2 -- <godot.exe> --headless --audio-driver Dummy --path . \
##     --script res://tools/weight2_probe.gd [-- seeds=20 bouts=6 abl=5]

const Data := preload("res://scripts/state/Data.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")

## The scratch class table (kg): the design's proposed one, so every boxer has a class above and below.
const LIMITS := {"f": [54.0, 57.0, 60.0, 65.0, 70.0, 75.0, 81.0], "m": [55.0, 60.0, 65.0, 70.0, 75.0, 80.0, 86.0]}
## who = Data id; over = kilos added to the Data walking weight (the cutter has grown out of her class).
const BOXERS := [
	{"shape": "puncher", "who": "samira", "over": 0.0},
	{"shape": "volume", "who": "josh", "over": 0.0},
	{"shape": "big chin", "who": "tess", "over": 0.0},
	{"shape": "drained cutter", "who": "kira", "over": 2.5},
	{"shape": "boxer-puncher", "who": "danny", "over": 0.0},
]
const SCALES := [
	{"id": "am", "name": "amateur, weighed on the day, 3 rounds", "pro": false, "rounds": 3, "regain": 0.25, "water_ok": 2.0, "opp_regain": 0.005, "opp_off": -3.0},
	{"id": "pro", "name": "pro, weighed the day before, 6 rounds", "pro": true, "rounds": 6, "regain": 0.80, "water_ok": 4.0, "opp_regain": 0.045, "opp_off": -6.0},
]
const CHOICES := ["STAY", "CUT", "UP", "DOWN"]
const LEVERS := ["drain", "size", "diet", "miss", "rank"]
const MODEL := {
	"bulk_kg": 2.0,            # CUT harder: walks this much bigger
	"up_fill_kg": 1.0,         # UP: eats freely, fills out this much
	"diet_hold": 0.025,        # share of walking weight held off by diet (chronic), 0.05 when moving DOWN
	"diet_hold_down": 0.05,
	"kg_a_week": 0.45,         # CODE: WeekPlan CUT_DEFICIT 500 kcal a day
	"free_weeks": 2.0,         # the usual gap before a bout
	"size_power": 1.2, "size_chin": 1.0, "size_speed": 0.4, "size_cap": 8.0,          # points per 1 % ring-weight gap
	"drain_cond": 2.0, "drain_chin": 1.5, "drain_speed": 0.8, "drain_power": 0.5,   # points per 1 % dehydrated at the bell
	"drain_tank": 3.0, "tank_max": 25.0, "drain_knee": 3.0,                           # past the knee each % counts twice
	"grow": 0.33, "diet_cost": 0.12, "grow_min": 0.4,                                 # stat points a bout cycle; x (1 - cost x % held)
	"miss_slope": 0.20, "miss_max": 0.7,                                               # a % of water past the scale's line, x (1.5 - discipline / 100)
	"rung0": 10.0, "rung_move": 11.0, "rung_gap": 1.2, "rung_max": 20.0, "field_grow": 0.15,   # round 2: a move costs ONE rung
	"size_rating": 0.35,       # round 2: size reaches the exchanges - rating points the opponent is worth per 1 % he outweighs us
}
const PLANS := [
	{"arrows": [{"move": "1-2"}, {"move": "step_in"}, {"move": "cut_off"}, {"move": "tie_up"}], "combos": {"1-2": 60.0, "1-1": 45.0}},
	{"arrows": [{"move": "2-3"}, {"move": "feint"}, {"move": "pivot_out"}, {"move": "1-2"}], "combos": {"2-3": 60.0, "1-2": 50.0}},
]
const DAY0 := 50000

var L: Array = []
var t0 := 0
var n_bouts := 0


func _initialize() -> void:
	t0 = Time.get_ticks_msec()
	var seeds := 20
	var bouts := 12
	var abl := 3
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("seeds="): seeds = int(s.substr(6))
		if s.begins_with("bouts="): bouts = int(s.substr(6))
		if s.begins_with("abl="): abl = int(s.substr(4))
	abl = mini(abl, seeds)
	_say(["# WEIGHT2 probe, ROUND 2 - weight as one mechanic, measured on a greybox before any build (S535 WEIGHTMOVE1)", "",
		"Round 1 (commit 875376421) FAILED: STAY best in 10 of 10 cells. Round 2 changes: a class move costs one rung (was two); size also",
		"makes the opponent worth more or less in the exchanges (size_rating); opponents eased (opp_off) so the ladder can rise; 12 bouts on a 20-rung ladder.", "",
		"Run: " + "python ops/Tools/godot_slot.py run --who weight2 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/weight2_probe.gd -- seeds=%d bouts=%d abl=%d" % [seeds, bouts, abl], "",
		"What is real: the five boxers (Data.PROSPECTS), their opponents (Data's region sheets), and every bout (BoutNight.play_out,",
		"the game's fight night). What is scratch: the weight model below. Every number in it is an ESTIMATE waiting for John.",
		"Each run = %d bouts on a 20-rung ladder; %d seeds a cell; every choice of a seed fights the same nights (same dice)." % [bouts, seeds], "",
		"Model: " + str(MODEL), ""])
	var cells: Array = []
	for b in BOXERS:
		for sc in SCALES:
			cells.append({"b": b, "sc": sc, "id": "%s / %s" % [b["shape"], sc["id"]]})
	# Main run: every lever on.
	var main := {}      # cell id -> choice -> Array of run results (one a seed)
	for cell in cells:
		main[cell["id"]] = {}
		for ch in CHOICES:
			var runs: Array = []
			for s in seeds:
				runs.append(_run(cell, ch, s, bouts, ""))
			main[cell["id"]][ch] = runs
		print("cell %s done, %d bouts, %.0f s" % [cell["id"], n_bouts, _secs()])
	_say(["## 1. Who they are", "", "| Boxer (shape) | Class | Walks | Power | Speed | Stamina (cond.) | Chin | Discipline |", "| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |"])
	for b in BOXERS:
		var t := _person(str(b["who"]))
		_say("| %s (%s) | %.0f kg | %.1f kg | %.0f | %.0f | %.0f | %.0f | %.0f |" % [t["name"], b["shape"], _limit0(t), float(t["weight"]) + float(b["over"]),
			t["stats"]["power"], t["stats"]["speed"], t["stats"]["conditioning"], t["stats"]["chin"], t["personality"]["discipline"]])
	_say(["", "## 2. The cell table", "",
		"Win, stopped (won inside / lost inside), late = last third of the rounds won, weeks = weeks lost to the diet and to missed scales,",
		"missed = scales missed a run, place = ladder rung at the end (1 is the top; every boxer starts on 10, a class move starts on 11).", ""])
	var best_count := {}
	for ch in CHOICES:
		best_count[ch] = 0
	var summary: Array = ["| Cell | STAY | CUT | UP | DOWN | Best |", "| :--- | ---: | ---: | ---: | ---: | :--- |"]
	for cell in cells:
		var id := str(cell["id"])
		_say(["### %s (%s)" % [id, cell["sc"]["name"]], "",
			"| Choice | Class | Cut | By water | Dry at the bell | Size gap | Win | Stopped W / L | Late | Weeks | Missed | Place |",
			"| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |"])
		var agg := {}
		for ch in CHOICES:
			agg[ch] = _agg(main[id][ch])
			var su: Dictionary = _setup(cell, ch, 0.0, "")
			_say("| %s | %.0f | %.1f kg | %.1f %% | %.1f %% | %+.1f %% | %.0f %% | %.0f / %.0f %% | %.0f %% | %.1f | %.2f | %.2f |" % [ch, su["limit"], su["over"], su["water_pct"],
				su["dry"], su["gap"], agg[ch]["win"] * 100.0, agg[ch]["stop_w"] * 100.0, agg[ch]["stop_l"] * 100.0, agg[ch]["late"] * 100.0, agg[ch]["weeks"], agg[ch]["missed"], agg[ch]["rung"]])
		var best := _best(agg)
		best_count[best] += 1
		_say(["", "Best: **%s**" % best, ""])
		summary.append("| %s | %.2f | %.2f | %.2f | %.2f | %s |" % [id, agg["STAY"]["rung"], agg["CUT"]["rung"], agg["UP"]["rung"], agg["DOWN"]["rung"], best])
	_say(["## 3. Ladder place at the end, every cell (lower is better)", ""])
	_say(summary)
	var top := 0
	for ch in CHOICES:
		top = maxi(top, int(best_count[ch]))
	_say(["", "Best counts: %s. The most any one choice wins: %d of %d cells (bar: 6 or fewer)." % [str(best_count), top, cells.size()], ""])
	# Ablation: each lever off, on the first abl seeds, against the same seeds with every lever on.
	_say(["## 4. Does each lever move the result? (lever off, %d seeds, against the same seeds with it on)" % abl, "",
		"| Lever off | Mean change in win share | Biggest change in ladder place | Cells whose best choice changes | Moves it |", "| :--- | ---: | ---: | ---: | :--- |"])
	var all_move := true
	for lv in LEVERS:
		var dwin := 0.0
		var n := 0
		var drung := 0.0
		var flips := 0
		for cell in cells:
			var id := str(cell["id"])
			var on := {}
			var off := {}
			for ch in CHOICES:
				var runs: Array = []
				for s in abl:
					runs.append(_run(cell, ch, s, bouts, lv))
				off[ch] = _agg(runs)
				on[ch] = _agg((main[id][ch] as Array).slice(0, abl))
				dwin += absf(float(off[ch]["win"]) - float(on[ch]["win"]))
				n += 1
				drung = maxf(drung, absf(float(off[ch]["rung"]) - float(on[ch]["rung"])))
			if _best(on) != _best(off):
				flips += 1
		var moves := dwin / float(n) >= 0.015 or drung >= 0.3 or flips >= 1
		all_move = all_move and moves
		_say("| %s | %.1f points | %.2f rungs | %d of %d | %s |" % [lv, dwin / float(n) * 100.0, drung, flips, cells.size(), "yes" if moves else "NO"])
		print("lever %s done, %d bouts, %.0f s" % [lv, n_bouts, _secs()])
	var ok := all_move and top <= 6
	_say(["", "%d bouts played in %.0f s." % [n_bouts, _secs()], "",
		"RESULT: tools/weight2_probe.gd -> %s (levers %s; top choice best in %d of %d cells)" % ["PASS" if ok else "FAIL", "all move" if all_move else "NOT all move", top, cells.size()]])
	var fa := FileAccess.open("res://docs/WEIGHT2_PROBE.md", FileAccess.WRITE)
	if fa != null:
		fa.store_string("\n".join(L) + "\n")
		fa.close()
	print("WEIGHT2 probe done (%.0f s)" % _secs())
	quit(0)


static func _person(id: String) -> Dictionary:
	for p in Data.PROSPECTS:
		if str(p["id"]) == id:
			return (p as Dictionary).duplicate(true)
	return Data.lucy()


static func _limit0(t: Dictionary) -> float:
	return float(Data.DIVISIONS[str(t["div"])]["limit"])


## The class limit a choice boxes at: the scratch table's step up or down from the boxer's own limit.
static func _class(t: Dictionary, ch: String) -> float:
	var own := _limit0(t)
	var row: Array = LIMITS[str(t["sex"])]
	var i := 0
	for k in row.size():
		if absf(float(row[k]) - own) < absf(float(row[i]) - own):
			i = k
	if ch == "UP":
		i = mini(row.size() - 1, i + 1)
	elif ch == "DOWN":
		i = maxi(0, i - 1)
	return float(row[i])


## The weight sums of one choice. grown = stat growth is not in here; off = the lever switched off ("" none).
## {limit, walk, over (kg to lose), diet_kg, water_kg, water_pct, dry (% dehydrated at the bell), gap (% ring-weight gap),
##  weeks (lost to the diet before the first bout), held (% of body weight held off by diet), p_miss, mods {stat: points}, tank}
static func _setup(cell: Dictionary, ch: String, _unused: float, off: String) -> Dictionary:
	var t := _person(str(cell["b"]["who"]))
	var sc: Dictionary = cell["sc"]
	var limit := _class(t, ch)
	var walk := float(t["weight"]) + float(cell["b"]["over"])
	if ch == "CUT":
		walk += float(MODEL["bulk_kg"])
	elif ch == "UP":
		walk += float(MODEL["up_fill_kg"])
	var over := maxf(0.0, walk - limit)
	var hold := float(MODEL["diet_hold_down"]) if ch == "DOWN" else float(MODEL["diet_hold"])
	var diet_kg := minf(over, hold * walk)
	var water_kg := over - diet_kg
	var water_pct := water_kg / walk * 100.0
	var regain := float(sc["regain"])
	var ring := (limit + regain * water_kg) if over > 0.0 else walk
	var opp_ring := limit * (1.0 + float(sc["opp_regain"]))
	var gap := (ring - opp_ring) / opp_ring * 100.0
	var dry := water_pct * (1.0 - regain)
	var drain := dry + maxf(0.0, dry - float(MODEL["drain_knee"]))
	if off == "drain":
		drain = 0.0
	if off == "size":
		gap = 0.0
	var cap := float(MODEL["size_cap"])
	var mods := {
		"power": clampf(float(MODEL["size_power"]) * gap, -cap, cap) - float(MODEL["drain_power"]) * drain,
		"chin": clampf(float(MODEL["size_chin"]) * gap, -cap, cap) - float(MODEL["drain_chin"]) * drain,
		"speed": -clampf(float(MODEL["size_speed"]) * gap, -cap, cap) - float(MODEL["drain_speed"]) * drain,
		"conditioning": -float(MODEL["drain_cond"]) * drain,
	}
	var held := diet_kg / walk * 100.0
	var disc := float(t["personality"]["discipline"])
	var p_miss := clampf((water_pct - float(sc["water_ok"])) * float(MODEL["miss_slope"]) * (1.5 - disc / 100.0), 0.0, float(MODEL["miss_max"]))
	if off == "miss":
		p_miss = 0.0
	return {"limit": limit, "walk": walk, "over": over, "diet_kg": diet_kg, "water_kg": water_kg, "water_pct": water_pct, "dry": dry, "gap": gap,
		"weeks": ceilf(maxf(0.0, diet_kg - float(MODEL["free_weeks"]) * float(MODEL["kg_a_week"])) / float(MODEL["kg_a_week"])),
		"held": 0.0 if off == "diet" else held, "p_miss": p_miss, "mods": mods, "tank": minf(float(MODEL["tank_max"]), float(MODEL["drain_tank"]) * drain)}


## The opponents a boxer of this sex can meet: Data's region sheets, the 70+ mismatches left out.
static func _pool(sex: String) -> Array:
	var out: Array = []
	var all: Array = Data.OPPONENTS + Data.RIVALS + Data.DIVISION_RIVALS
	for o in all:
		var d := str((o as Dictionary).get("div", "wlw"))
		if str(Data.DIVISIONS[d]["sex"]) == sex and float(o["rating"]) < 68.0:
			out.append(o)
	return out


## One run: N bout slots for one boxer on one choice. Returns the counts.
func _run(cell: Dictionary, ch: String, seed_i: int, bouts: int, off: String) -> Dictionary:
	var t := _person(str(cell["b"]["who"]))
	var sc: Dictionary = cell["sc"]
	var su := _setup(cell, ch, 0.0, off)
	var pool := _pool(str(t["sex"]))
	var base := BoutRules.fight_power(t["stats"], {}, 0, "", false)
	var moved := ch == "UP" or ch == "DOWN"
	var rung := float(MODEL["rung_move"]) if (moved and off != "rank") else float(MODEL["rung0"])
	var grow_mult := clampf(1.0 - float(MODEL["diet_cost"]) * float(su["held"]), float(MODEL["grow_min"]), 1.0)
	var grown := 0.0
	var res := {"wins": 0, "fought": 0, "stop_w": 0, "stop_l": 0, "late_w": 0, "late_n": 0, "missed": 0, "weeks": float(su["weeks"]), "rung": rung}
	var rng := RandomNumberGenerator.new()
	for k in bouts:
		var day := DAY0 + seed_i * 211 + k * 7
		rng.seed = hash([str(cell["id"]), seed_i, k])
		var u := rng.randf()
		grown += float(MODEL["grow"]) * grow_mult
		if u < float(su["p_miss"]):
			res["missed"] = int(res["missed"]) + 1
			res["weeks"] = float(res["weeks"]) + 1.0
			rung = minf(float(MODEL["rung_max"]), rung + 0.5)
			continue
		var f := Data.fighter_state(t.duplicate(true), day)
		for st in ["power", "speed", "technique", "defense", "conditioning", "fight_iq"]:
			f["stats"][st] = float(f["stats"][st]) + grown
		for st in su["mods"]:
			f["stats"][st] = clampf(float(f["stats"][st]) + float(su["mods"][st]), 20.0, 95.0)
		var pl: Dictionary = PLANS[1 if bool(sc["pro"]) else 0]
		f = f.merged({"pro": bool(sc["pro"]), "morale": 60.0, "camp": {}, "week_fatigue": 20.0, "notes_seen": [], "limit": float(su["limit"]),
			"arrows": (pl["arrows"] as Array).duplicate(true), "combos": (pl["combos"] as Dictionary).duplicate()}, true)
		f.erase("last_bout_day")
		var opp: Dictionary = (pool[(seed_i * 7 + k * 3 + int(day)) % pool.size()] as Dictionary).duplicate(true)
		opp["rating"] = base + float(sc["opp_off"]) + float(MODEL["field_grow"]) * float(k) + (float(MODEL["rung0"]) - rung) * float(MODEL["rung_gap"]) - float(MODEL["size_rating"]) * float(su["gap"])
		opp.erase("height")
		opp.erase("reach")
		f["bout"] = {"opp": opp, "day": day, "weighed": true, "made": true, "done": false, "film": 1, "rounds": int(sc["rounds"]), "stale": float(su["tank"])}
		var c := Career.new()
		c.day = day
		c.seed = seed_i + 1
		c.coach = {"rating": 60.0}
		c.fighters = [f]
		var m := {"type": "fight", "fid": f["id"], "step": "tape", "round": 0, "rounds": [], "total": int(sc["rounds"])}
		BoutNight.play_out(c, f, m)
		n_bouts += 1
		var outcome := BoutNight.outcome_of(f, m)
		var stop := BoutNight.stopped(m) != ""
		res["fought"] = int(res["fought"]) + 1
		if outcome == "win":
			res["wins"] = int(res["wins"]) + 1
			rung = maxf(1.0, rung - (1.5 if stop else 1.0))
			if stop: res["stop_w"] = int(res["stop_w"]) + 1
		elif outcome == "loss":
			rung = minf(float(MODEL["rung_max"]), rung + 1.0)
			if stop: res["stop_l"] = int(res["stop_l"]) + 1
		var late_from := int(ceil(float(sc["rounds"]) * 2.0 / 3.0)) + 1
		for r in m["rounds"]:
			if int(r["n"]) >= late_from:
				res["late_n"] = int(res["late_n"]) + 1
				res["late_w"] = int(res["late_w"]) + int(bool(r["won"]))
	res["rung"] = rung
	return res


static func _agg(runs: Array) -> Dictionary:
	var w := 0.0; var fo := 0.0; var sw := 0.0; var sl := 0.0; var lw := 0.0; var ln := 0.0
	var mi := 0.0; var wk := 0.0; var ru := 0.0
	for r in runs:
		w += float(r["wins"]); fo += float(r["fought"]); sw += float(r["stop_w"]); sl += float(r["stop_l"])
		lw += float(r["late_w"]); ln += float(r["late_n"]); mi += float(r["missed"]); wk += float(r["weeks"]); ru += float(r["rung"])
	var n := maxf(1.0, float(runs.size()))
	return {"win": w / maxf(1.0, fo), "stop_w": sw / maxf(1.0, fo), "stop_l": sl / maxf(1.0, fo), "late": lw / maxf(1.0, ln),
		"missed": mi / n, "weeks": wk / n, "rung": ru / n}


## The best choice of a cell: the lowest ladder place; inside 0.1 of a rung, the higher win share.
static func _best(agg: Dictionary) -> String:
	var best := ""
	for ch in CHOICES:
		if best == "":
			best = ch
			continue
		var d := float(agg[ch]["rung"]) - float(agg[best]["rung"])
		if d < -0.1 or (absf(d) <= 0.1 and float(agg[ch]["win"]) > float(agg[best]["win"])):
			best = ch
	return best


func _secs() -> float:
	return float(Time.get_ticks_msec() - t0) / 1000.0


func _say(v: Variant) -> void:
	var lines: Array = v if v is Array else [v]
	for s in lines:
		print(s)
		L.append(s)
