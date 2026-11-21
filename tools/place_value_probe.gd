extends SceneTree
## STEPPAY1 (S533, phase 1 of ops/research/STEPS_PAYOFF_SCOPE_S533.md): what is each ring place worth today? For each of
## the 8 places (PlanLines.PLACES) the exchange is forced to START there: before every exchange after a round's first, the
## probe sets lv["at"] - the key LiveRound.exchange reads at L235-238 - and fights it through the game's own calls
## (BoutNight.fight_step "start" / "shout:", BoutNight._open for the next round; the same order as the "sim" path's _box_out).
## Nothing is reimplemented: the round, the duel and RingDuel.settle run as the game runs them. Exchange 0 of each round
## is the game's own (LiveRound.open builds lv fresh, at "" -> PlanFight.GAME_CARD) and is never counted.
## Population: TREEVALUE1's 60 generated boxers (tools/treevalue_probe.gd factory, seeds 7100..7159, TREEVALUE's plan, moves
## and steps at 45) against one shipped opponent per style (StepValue.STYLES) at the TREEVALUE3 calibrated rating.
## Arms: 8 forced places + CONTROL (at left to the game). Cell = 400 counted exchanges x 3 seed sets.
## Controls: CONTROL arm == Bouts.fight_step "sim" exchange for exchange (the game's own share); the comparator must read a
## broken arm (forced corner) as a mismatch; every forced exchange records rec["at"] == the place; the same seed twice is equal.
## Usage: godot --headless --audio-driver Dummy --path . --script res://tools/place_value_probe.gd   [-- n=400]

const TV := preload("res://tools/treevalue_probe.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const TowelWire := preload("res://scripts/state/TowelWire.gd")
const CrackWire := preload("res://scripts/state/CrackWire.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const StepValue := preload("res://scripts/rules/StepValue.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlaceEdge := preload("res://scripts/rules/PlaceEdge.gd")
const StepWire := preload("res://scripts/state/StepWire.gd")

## docs/TREEVALUE3_RESULT.txt: each style's rating so TREEVALUE's base plan wins about half its bouts.
const RATING := {"Maria Ortega": 52.89, "Jade Cooper": 55.95, "Holly Price": 54.24, "Priya Nair": 53.29,
	"Erin Doyle": 53.02, "Dana Whitfield": 52.64}
const SEED_SETS := [0, 10000, 20000]
const RANGE_MOVES := ["step_out", "step_back", "pivot_out"]
## The opponent's card when ours is this one (the ring seen from the other corner).
const MIRROR := {"own_ropes": "opp_ropes", "opp_ropes": "own_ropes", "corner": "own_ropes"}
var tv: Object
var n_ex := 400


func _bout(off: int, opp: Dictionary) -> Array:
	var c := Career.quick_start()
	c.fighters.append(tv.call("_make_fighter", int(TV.SEED_START) + (off % int(TV.N_FIGHTERS))))
	c.day = 40 + off
	var f: Dictionary = c.fighter()
	var base: Dictionary = tv.call("_base_dict")
	f["camp"] = {}
	f["morale"] = 60.0
	f["moves"] = (base["moves"] as Dictionary).duplicate()
	f["steps"] = (base["steps"] as Dictionary).duplicate()
	f["combos"] = (base["combos"] as Dictionary).duplicate()
	f["arrows"] = (TV.PLAN as Array).duplicate(true)
	c.coach = {}
	f["bout"] = {"opp": opp.duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 0, "rounds": 3}
	return [c, f, {"fid": f["id"], "step": "tape", "total": 3}]


## Every exchange after a round's first: {won, la, lb, at, arrow, planned, mode}. place "" = the game decides;
## "GAME" = Bouts.fight_step "sim" itself (no probe hand in the loop).
func _play(off: int, opp: Dictionary, place: String) -> Array:
	var b := _bout(off, opp)
	var c: Career = b[0]
	var f: Dictionary = b[1]
	var m: Dictionary = b[2]
	if place == "GAME":
		Bouts.fight_step(c, f, m, "sim")
	else:
		BoutNight.fight_step(c, f, m, "start")   # opens round 1 and fights its first exchange (the game's own)
		_rest(c, f, m, place)
		while int(m["round"]) < BoutNight.rounds_of(f) and BoutNight.stopped(m) == "" and not TowelWire.coach_pull(c, f, m) \
				and not CrackWire.bell(c, f, m, BoutNight.rounds_of(f)):
			BoutNight._open(c, f, m, BoutRules.auto_corner(f["stats"]))
			_rest(c, f, m, place)
	var out: Array = []
	for r in m["rounds"]:
		for x in (r as Dictionary)["exchanges"]:
			var xd: Dictionary = x
			if int(xd["i"]) == 0:
				continue
			var ld: Array = xd["landed"]
			out.append({"won": bool(xd["won"]), "la": int(ld[0]), "lb": int(ld[1]), "at": str(xd.get("rode_from", xd.get("at", ""))),   # the card it STARTED on (a step that rode a punch moved it, STEPPAY2 phase 3)
				"arrow": PlanFight.base_id(str(xd.get("arrow", ""))), "planned": bool(xd.get("planned", false)), "mode": str(xd["mode"])})
	return out


## The open round's other exchanges, each through fight_step "shout:" (the shout bar's say-nothing), at forced first.
func _rest(c: Career, f: Dictionary, m: Dictionary, place: String) -> void:
	while not LiveRound.live(m).is_empty():
		if place != "":
			LiveRound.live(m)["at"] = place
			# S533 STEPPAY2: the game sets the card in RingDuel.settle, where a trapped opponent loses her range game; a
			# forced card gets the same rule (no change with the rule off).
			LiveRound.live(m)["mode"] = PlaceEdge.mode_at(place, str(LiveRound.live(m)["mode"]))
		BoutNight.fight_step(c, f, m, "shout:")


## n counted exchanges from seed_base on (bouts in seed order; the cell stops at n).
func _cell(seed_base: int, opp: Dictionary, place: String, n: int) -> Array:
	var rows: Array = []
	var k := 0
	while rows.size() < n:
		rows.append_array(_play(seed_base + k, opp, place))
		k += 1
	return rows.slice(0, n)


func _sum(rows: Array) -> Dictionary:
	var s := {"n": rows.size(), "won": 0, "la": 0, "lb": 0, "planned": 0, "range": 0, "off_at": 0, "lines": {}}
	for r in rows:
		var rd: Dictionary = r
		s["won"] = int(s["won"]) + (1 if bool(rd["won"]) else 0)
		s["la"] = int(s["la"]) + int(rd["la"])
		s["lb"] = int(s["lb"]) + int(rd["lb"])
		s["range"] = int(s["range"]) + (1 if str(rd["mode"]) == "range" else 0)
		var key := str(rd["arrow"]) + ("" if bool(rd["planned"]) else "*")
		(s["lines"] as Dictionary)[key] = int((s["lines"] as Dictionary).get(key, 0)) + 1
		if bool(rd["planned"]):
			s["planned"] = int(s["planned"]) + 1
	return s


## Exchanges that differ: won and landed both ways (and the card too when with_at).
func _differ(a: Array, b: Array, with_at := true) -> int:
	var d := absi(a.size() - b.size())
	for i in mini(a.size(), b.size()):
		var x: Dictionary = a[i]
		var y: Dictionary = b[i]
		if bool(x["won"]) != bool(y["won"]) or int(x["la"]) != int(y["la"]) or int(x["lb"]) != int(y["lb"]) \
				or (with_at and str(x["at"]) != str(y["at"])):
			d += 1
	return d


func _opp(style: String) -> Dictionary:
	var o: Dictionary = tv.call("_find_opp", str(TV.STYLE_OPP[style]))
	o["rating"] = float(RATING[str(o["name"])])
	return o


func _top(lines: Dictionary, k: int) -> String:
	var keys: Array = lines.keys()
	keys.sort_custom(func(a, b): return int(lines[a]) > int(lines[b]))
	var parts: PackedStringArray = []
	for i in mini(k, keys.size()):
		parts.append("%s %d" % [str(keys[i]), int(lines[keys[i]])])
	return ", ".join(parts)


func _avail(place: String) -> String:
	var card := str(MIRROR.get(place, place))
	var have: PackedStringArray = []
	for mv in StrikeMap.outs(card):
		if RANGE_MOVES.has(str((mv as Dictionary)["id"])):
			have.append(str((mv as Dictionary)["id"]))
	return card + ":" + ("none" if have.is_empty() else "/".join(have))


func _initialize() -> void:
	var t0 := Time.get_ticks_msec()
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("n="):
			n_ex = int(str(a).substr(2))
		if str(a) == "place=off":   # S533 STEPPAY2 control arm: the game before PlaceEdge (STEPPAY1's table)
			PlaceEdge.on = false
		if str(a) == "ride=off":   # S533 STEPPAY2 phase 3 control arm: every step costs its exchange
			StepWire.ride_on = false
		if str(a).begins_with("edge="):   # measurement only: another ROPES size
			PlaceEdge.probe_size = float(str(a).substr(5))
	print("PlaceEdge: on=%s ropes=%+.1f corner=%+.1f own_ropes=%+.1f" % [str(PlaceEdge.on), PlaceEdge.edge("opp_ropes"), PlaceEdge.edge("corner"), PlaceEdge.edge("own_ropes")])
	tv = TV.new()
	print("PLACE_VALUE (STEPPAY1): exchange win share for your boxer by the place the exchange starts at")
	print("Population: TREEVALUE1's %d generated boxers (seeds %d..%d, plan = TREEVALUE PLAN, moves/steps/combos %.0f) vs one shipped opponent per style at the TREEVALUE3 calibrated rating: %s" % [
		int(TV.N_FIGHTERS), int(TV.SEED_START), int(TV.SEED_START) + int(TV.N_FIGHTERS) - 1, float(TV.BASE_VAL), str(RATING)])
	print("Cell: %d exchanges (each after a round's first) x seed sets %s; places %s" % [n_ex, str(SEED_SETS), str(PlanLines.PLACES)])
	var ok_ctrl := true
	var ok_det := true
	# CONTROL 1: the probe's own driver with at left alone == the game's "sim", exchange for exchange.
	var game_share := {}
	for style in StepValue.STYLES:
		var s := str(style)
		var g := _cell(0, _opp(s), "GAME", n_ex)
		var mine := _cell(0, _opp(s), "", n_ex)
		var d := _differ(g, mine)
		game_share[s] = 100.0 * float(_sum(g)["won"]) / float(n_ex)
		print("CONTROL vs game sim %s: %d of %d exchanges differ, game share %.1f" % [s, d, n_ex, float(game_share[s])])
		if d != 0:
			ok_ctrl = false
	# CONTROL 2: the comparator reads a broken arm (corner forced) as different from the game - a green control can read worse.
	var broken := _differ(_cell(0, _opp("Pressure fighter"), "GAME", n_ex), _cell(0, _opp("Pressure fighter"), "corner", n_ex), false)
	print("CONTROL self-test: broken arm (corner forced) differs from the game in result or landed on %d of %d exchanges (must be > 0)" % [broken, n_ex])
	if broken == 0:
		ok_ctrl = false
	# DETERMINISM: the same seed twice.
	var d1 := _cell(0, _opp("Out-boxer"), "opp_ropes", n_ex)
	var d2 := _cell(0, _opp("Out-boxer"), "opp_ropes", n_ex)
	var dd := _differ(d1, d2)
	print("DETERMINISM opp_ropes vs Out-boxer twice: %d differ" % dd)
	if dd != 0:
		ok_det = false
	# SWEEP: 8 places + the control arm x 6 styles x 3 seed sets.
	var arms: Array = PlanLines.PLACES.duplicate()
	arms.append("")
	for place in arms:
		var p := str(place)
		var label := p if p != "" else "CONTROL"
		for style in StepValue.STYLES:
			var s := str(style)
			var shares: Array = []
			var all_rows: Array = []
			for sb in SEED_SETS:
				var rows := _cell(int(sb), _opp(s), p, n_ex)
				shares.append(100.0 * float(_sum(rows)["won"]) / float(n_ex))
				all_rows.append_array(rows)
			var t := _sum(all_rows)
			for r in all_rows:   # CONTROL 3: every counted exchange of a forced arm was fought on its place
				if p != "" and str((r as Dictionary)["at"]) != p:
					t["off_at"] = int(t["off_at"]) + 1
			if int(t["off_at"]) != 0:
				ok_ctrl = false
			var lo := 100.0
			var hi := 0.0
			var mean := 0.0
			for v in shares:
				lo = minf(lo, float(v))
				hi = maxf(hi, float(v))
				mean += float(v) / float(shares.size())
			var nn := float(t["n"])
			print("CELL place=%s style=%s share=%.1f seeds=%.1f..%.1f landed_a=%.2f landed_b=%.2f planned=%.0f%% opp_range=%.0f%% off_at=%d opp_range_moves=%s lines=%s" % [
				label, s, mean, lo, hi, float(t["la"]) / nn, float(t["lb"]) / nn, 100.0 * float(t["planned"]) / nn,
				100.0 * float(t["range"]) / nn, int(t["off_at"]), _avail(p) if p != "" else "-", _top(t["lines"], 4)])
	tv.free()
	print("Elapsed %.0f s" % (float(Time.get_ticks_msec() - t0) / 1000.0))
	print("PLACE_VALUE done control=%s determinism=%s" % ["ok" if ok_ctrl else "FAIL", "ok" if ok_det else "FAIL"])
	quit(0 if ok_ctrl and ok_det else 1)
