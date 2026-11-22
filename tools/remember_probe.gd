extends SceneTree
## S537 REMEMBER1 greybox (DEPTH35 change 5, "one opponent who remembers"), measured BEFORE the critics.
## The rule under test (ops/research/DESIGN_REMEMBER1.md): in an amateur REMATCH the rival gym's corner brings the read the
## pro corner brings today (ProRead: the combination fired most in her last two bouts; ProReadWire.READ_EDGE on every planned,
## fired use of it). The pick = what the player does about it before the rematch.
## Greybox: the game's own bout (Bouts.fight_step, six exchanges a round, FireLevel on) and the game's own read price
## (ProReadWire.edge reads bout["pro_read"] / ["pro_feint"]). ProReadWire.open clears the read for an amateur bout at the
## first bell, so the probe sets it right after "start": round 1's first 30 seconds are fought unread (1 exchange in 18).
## No game file is changed.
## POPULATION: 10 cells = 10 different pairs, 4 club boxers who all differ (Lucy wlw, Kira wfw, Samira www, Tess wmw) against
## rivals of their own division with different games (OppFile.main_game); each boxer her own book of two combinations.
## The tape = her first two bouts against that rival on her plain plan (dice 0 and 1); the read = ProRead.target of it.
## Usage: godot --headless --script res://tools/remember_probe.gd -- [dice]   (ends with REMEMBER_DONE)

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const ProRead := preload("res://scripts/rules/ProRead.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")

const BOOK := {"lucy": {"1-1": 52.0, "1-2": 40.0}, "kira": {"1-2": 41.0, "1-1-2": 46.0}, "samira": {"2-3": 47.0, "3b-3": 38.0},
	"tess": {"1-2-3b": 56.0, "1-1": 44.0}}
const PUNCH := {"lucy": 66.0, "kira": 63.0, "samira": 60.0, "tess": 69.0}
## [boxer, index in her division's rivals]
const CELLS := [["lucy", 0], ["lucy", 1], ["lucy", 2], ["kira", 0], ["kira", 1], ["kira", 2], ["samira", 0], ["samira", 1], ["tess", 0], ["tess", 1]]
## keep = the laziest (the same plan again). drop / swap / second / feint / both = the player's answers.
const PICKS := ["keep", "drop", "swap", "second", "feint", "both"]
const SHARP := 65.0
const NEW_LINE := 35.0   # a line learned for the rematch arrives Usable

var _dice := 150


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() > 0 and int(args[0]) > 0:
		_dice = int(args[0])
	print("POPULATION: %d cells (boxer x rival of her division, all pairs differ), books %s, %d paired dice a cell, 3 rounds, read price ProReadWire.READ_EDGE" % [CELLS.size(), BOOK, _dice])
	var t0 := Time.get_ticks_msec()
	var sum := {}
	var best_in := {}
	var half_cells := 0
	var took_sum := 0.0
	var best_back_sum := 0.0
	for ci in CELLS.size():
		var id := str(CELLS[ci][0])
		var opp: Dictionary = _opps(id)[int(CELLS[ci][1])]
		var game := OppFile.main_game(opp)
		var f := _fighter(id)
		var plan := _plan(f, opp)
		var line := _read_line(f, opp, plan)
		if line == "":
			print("CELL %d %s vs %s (%s): no combination fired on the tape - nothing to read" % [ci, id, opp["name"], game])
			continue
		var second := _second(f, plan, line, game)
		var fresh := _fresh(f, plan, game)
		var read := {"line": line, "second": "", "split": false, "count": 9}
		var split := {"line": line, "second": second, "split": true, "count": 9}
		var f2 := f.duplicate(true)           # the second weapon: her other line drilled to Sharp before the rematch
		if second != "":
			f2["combos"][second] = SHARP
		var f3 := f.duplicate(true)           # a new line learned for the rematch (Usable)
		if fresh != "":
			f3["combos"][fresh] = NEW_LINE
		var no_line: Array = plan.filter(func(a): return str(a["move"]) != line)
		var swapped: Array = no_line.duplicate(true)
		if fresh != "":
			swapped.push_front({"move": fresh})
		var feint_plan: Array = plan.duplicate(true)
		feint_plan.append({"move": "feint"})
		var w := {}
		w["unread"] = _won(f, opp, plan, {}, false)
		w["keep"] = _won(f, opp, plan, read, false)
		w["drop"] = _won(f, opp, no_line, read, false)
		w["swap"] = _won(f3, opp, swapped, read, false) if fresh != "" else float(w["drop"])
		w["second"] = _won(f2, opp, plan, split, false) if second != "" else float(w["keep"])
		w["feint"] = _won(f, opp, feint_plan, read, true)
		w["both"] = _won(f2, opp, feint_plan, split, true) if second != "" else float(w["feint"])
		w["second_unread"] = _won(f2, opp, plan, {}, false) if second != "" else float(w["unread"])
		w["feint_unread"] = _won(f, opp, feint_plan, {}, false)
		var took := float(w["unread"]) - float(w["keep"])
		var top := -1.0
		for p in PICKS:
			top = maxf(top, float(w[p]))
		var names: Array = []
		for p in PICKS:
			if float(w[p]) >= top - 0.05:
				names.append(p)
				best_in[p] = int(best_in.get(p, 0)) + 1
		var back := top - float(w["keep"])
		took_sum += took
		best_back_sum += back
		half_cells += int(took > 0.0 and back >= 0.5 * took)
		var out := "CELL %d %s vs %s (%s, %.1f): plan %s, read %s, second %s, new %s |" % [ci, id, opp["name"], game, float(opp["rating"]), plan.map(func(a): return a["move"]), line, second, fresh]
		for k in ["unread", "keep", "drop", "swap", "second", "feint", "both", "second_unread", "feint_unread"]:
			out += " %s %.1f" % [k, float(w[k])]
			sum[k] = float(sum.get(k, 0.0)) + float(w[k])
		print(out + " | read takes %.1f, best %s wins back %.1f" % [took, names, back])
	var n := float(CELLS.size())
	var mean := "MEAN |"
	for k in sum:
		mean += " %s %.2f" % [k, float(sum[k]) / n]
	print(mean)
	var took_mean := (float(sum["unread"]) - float(sum["keep"])) / n
	var best_pick := ""
	var most := 0
	for p in PICKS:
		if p != "keep" and (best_pick == "" or float(sum[p]) > float(sum[best_pick])):
			best_pick = p
		most = maxi(most, int(best_in.get(p, 0)))
	var back_one := (float(sum[best_pick]) - float(sum["keep"])) / n
	print("BAR 1 moves the result: unread - keep = %.2f wins in 100 -> %s" % [took_mean, "pass" if took_mean >= 3.0 else "FAIL"])
	print("BAR 2 no pick best in more than 6 of 10 cells: %s -> %s" % [best_in, "pass" if most <= 6 else "FAIL"])
	print("BAR 3 best vs laziest: %s - keep = %.2f wins in 100 (the best pick of each cell - keep = %.2f) -> %s" % [best_pick, back_one, best_back_sum / n, "pass" if back_one >= 3.0 else "FAIL"])
	print("BAR 4 a counter wins back half of what the read takes: one pick everywhere (%s) %.2f of %.2f; the best pick of each cell %.2f of %.2f; cells where a counter wins back half: %d of %d -> %s" % [best_pick, back_one, took_mean, best_back_sum / n, took_sum / n, half_cells, CELLS.size(), "pass" if took_mean > 0.0 and back_one >= 0.5 * took_mean else "FAIL"])
	print("VERDICT REMEMBER1 = %s" % ("PASS" if took_mean >= 3.0 and most <= 6 and back_one >= 3.0 and back_one >= 0.5 * took_mean else "FAIL"))
	print("%d s" % ((Time.get_ticks_msec() - t0) / 1000))
	print("REMEMBER_DONE")
	quit(0)


func _base(id: String) -> Dictionary:
	if id == "lucy":
		return Data.lucy()
	for p in Data.PROSPECTS:
		if str(p["id"]) == id:
			var d: Dictionary = (p as Dictionary).duplicate(true)
			for k in ["state", "trial_day", "note"]:
				d.erase(k)
			return d
	return {}


func _fighter(id: String) -> Dictionary:
	var f: Dictionary = Data.fighter_state(_base(id), 40)
	f["id"] = id
	for mv in Data.MOVES:
		f["moves"][mv] = float(PUNCH[id])
	f["combos"] = (BOOK[id] as Dictionary).duplicate(true)
	f["camp"] = {}
	f["morale"] = 60.0
	return f


func _opps(id: String) -> Array:
	var div := str(_base(id).get("div", "wlw"))
	var out: Array = []
	if div == "wlw":
		out.append_array(Data.OPPONENTS)
	else:
		for r in Data.DIVISION_RIVALS:
			if str(r["div"]) == div and float(r["rating"]) < 70.0:
				out.append(r)
	return out


## Her plain plan: every combination in her hands that does not walk into the rival's game, and two steps that do not.
func _plan(f: Dictionary, opp: Dictionary) -> Array:
	var game := OppFile.main_game(opp)
	var out: Array = []
	for cid in (f["combos"] as Dictionary).keys():
		if float(f["combos"][cid]) >= 30.0 and PlanFight.fit(str(cid), game) != "wrong":
			out.append({"move": str(cid)})
	if out.is_empty():   # her whole book walks into this game: she fights on her better line anyway
		var top := ""
		for cid in (f["combos"] as Dictionary).keys():
			if top == "" or float(f["combos"][cid]) > float(f["combos"][top]):
				top = str(cid)
		out.append({"move": top})
	var feet := 0
	for s in ["step_back", "pivot_out", "step_in"]:
		if feet < 2 and PlanFight.fit(s, game) != "wrong":
			out.append({"move": s})
			feet += 1
	return out


## The line the rival's corner brings: ProRead.target of her first two bouts against this rival (the game's own rule).
func _read_line(f: Dictionary, opp: Dictionary, plan: Array) -> String:
	var tape: Array = []
	for j in 2:
		var m := _bout(f, opp, plan, {}, false, 9000 + j)
		var fired := {}
		for ro in m.get("rounds", []):
			for x in (ro as Dictionary).get("exchanges", []):
				var arrow := str(x.get("arrow", ""))
				if bool(x.get("planned", false)) and str(StrikeMap.move(arrow).get("kind", "")) == "combo":
					fired[arrow] = int(fired.get(arrow, 0)) + 1
		tape.append({"pro": true, "fired": fired})
	var tiers := {}
	for k in (f["combos"] as Dictionary).keys():
		tiers[str(k)] = MoveMastery.word(float(f["combos"][k]))
	return str(ProRead.target(tape, tiers).get("line", ""))


## Her other plan combination (the second weapon); none in the plan = her other book line if it does not walk in.
func _second(f: Dictionary, plan: Array, line: String, game: String) -> String:
	for a in plan:
		var id := str(a["move"])
		if id != line and str(StrikeMap.move(id).get("kind", "")) == "combo":
			return id
	for cid in (f["combos"] as Dictionary).keys():
		if str(cid) != line and PlanFight.fit(str(cid), game) != "wrong":
			return str(cid)
	return ""


## A combination she does not hold that the answer table calls best (else ok) against this game: the line to learn.
func _fresh(f: Dictionary, _plan_now: Array, game: String) -> String:
	for tier in ["best", "ok"]:
		for id in (PlanFight.ANSWERS.get(game, {}) as Dictionary).get(tier, []):
			if str(StrikeMap.move(str(id)).get("kind", "")) == "combo" and not (f["combos"] as Dictionary).has(str(id)):
				return str(id)
	return ""


func _won(f: Dictionary, opp: Dictionary, plan: Array, read: Dictionary, feint: bool) -> float:
	var won := 0
	for j in _dice:
		won += int(str(_bout(f, opp, plan, read, feint, j).get("outcome", "")) == "win")
	return 100.0 * float(won) / float(_dice)


## One bout of the game's own, round by round (no shouts, the corner's own call), the read set after the first bell.
func _bout(f: Dictionary, opp: Dictionary, plan: Array, read: Dictionary, feint: bool, j: int) -> Dictionary:
	var c := Career.quick_start()
	c.fighters.append(f.duplicate(true))
	c.day = 40 + j
	c.coach = {}
	var g: Dictionary = c.fighter()
	g["arrows"] = plan.duplicate(true)
	g["bout"] = {"opp": opp.duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 0, "rounds": 3}
	var m := {"fid": g["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, g, m, "start")
	if not read.is_empty():
		g["bout"]["pro_read"] = read.duplicate(true)
		g["bout"]["pro_feint"] = feint
	while true:
		while not LiveRound.live(m).is_empty():
			Bouts.fight_step(c, g, m, "shout:")
		if int(m["round"]) >= Bouts.rounds_of(g) or Bouts.stopped(m) != "":
			break
		Bouts.fight_step(c, g, m, "corner:" + BoutRules.auto_corner(g["stats"]))
	Bouts.fight_step(c, g, m, "end")
	return m
