extends SceneTree
## WHYGRADE1: why a good plan reads GOOD less often since CARDFIX1 (3fd32033). The test's own _bout() setup, 540 bouts
## (days 40..579) with the GOOD plan and with no plan. Per bout and summed: for each situation the exchange had, the
## place (card) it was on, how many exchanges, which plan line fired (move id) or none, and won/lost.
## Usage: godot --headless --audio-driver Dummy --path . --script res://tools/why_fires_probe.gd [-- 1-1,feint:counter,step_back,tie_up]
## S492: an optional plan (comma list; "move:when" = a line for one situation, e.g. feint:counter) replaces GOOD; feint is drilled like the other steps.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const FightWhy := preload("res://scripts/rules/FightWhy.gd")

const GOOD := [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]
const BOUTS := 540
const START := 40


func _initialize() -> void:
	var plan_rows := {}   # sit -> {n, fired, by: {move: n}, won, lost}
	var none_rows := {}   # sit -> {n, fired, by: {move: n}, won, lost}
	var graded_good := 0
	var plan: Array = GOOD
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		plan = []
		for mv in str(args[0]).split(","):
			var bits := mv.split(":")   # "feint:counter" = the line "When she counters -> Feint" (PlanLines.set_line)
			plan.append({"move": bits[0]} if bits.size() == 1 else {"move": bits[0], "when": bits[1]})
	print("WHYFIRES plan=%s" % JSON.stringify(plan))
	for i in BOUTS:
		var day := START + i
		var plan_m := _bout(day, plan)
		var none_m := _bout(day, [])
		graded_good += int(str(FightWhy.read(plan_m["rounds"], "Lucy", "Maria")["grade"]) == "good")
		_collect(plan_m, plan_rows)
		_collect(none_m, none_rows)
	print("WHYFIRES graded_good=%d of %d" % [graded_good, BOUTS])
	print("")
	print("=== GOOD PLAN (1-1, step_back, pivot_out, tie_up) ===")
	_print_table(plan_rows)
	print("")
	print("=== NO PLAN ===")
	_print_table(none_rows)
	quit(0)


func _collect(m: Dictionary, rows: Dictionary) -> void:
	for r in m["rounds"]:
		for x in r.get("exchanges", []):
			var sit := str(x.get("psit", ""))
			if sit == "":
				continue
			var place := str(x.get("at", ""))
			var key := "%s|%s" % [sit, place]
			if not rows.has(key):
				rows[key] = {"sit": sit, "place": place, "n": 0, "fired": 0, "by": {}, "won": 0, "lost": 0}
			var row: Dictionary = rows[key]
			row["n"] += 1
			var arrow := str(x.get("arrow", ""))
			var planned := bool(x.get("planned", false))
			if planned and arrow != "":
				row["fired"] += 1
				row["by"][arrow] = int(row["by"].get(arrow, 0)) + 1
			if bool(x.get("won", false)):
				row["won"] += 1
			else:
				row["lost"] += 1


func _print_table(rows: Dictionary) -> void:
	var keys := rows.keys()
	keys.sort()
	for k in keys:
		var r: Dictionary = rows[k]
		var by_parts := []
		for move_id in r["by"]:
			by_parts.append("%s:%d" % [move_id, int(r["by"][move_id])])
		by_parts.sort()
		var won_pct := 0.0
		if int(r["n"]) > 0:
			won_pct = 100.0 * float(r["won"]) / float(r["n"])
		print("WHYFIRES sit=%-14s place=%-10s n=%-4d fired=%-4d by=%s  won=%d lost=%d (%.0f%%)" % [
			r["sit"], r["place"], int(r["n"]), int(r["fired"]),
			",".join(PackedStringArray(by_parts)) if by_parts.size() > 0 else "(none)",
			int(r["won"]), int(r["lost"]), won_pct])


func _bout(day: int, arrows: Array) -> Dictionary:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	c.day = day
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["combos"] = {"1-1": 50.0, "1-2": 50.0, "3b-3": 50.0}   # S492: the 3b-3 line drilled like 1-1
	for sid in ["step_back", "pivot_out", "tie_up", "cut_off", "herd", "feint"]:
		(f.get_or_add("steps", {}) as Dictionary)[sid] = 85.0
	f["arrows"] = arrows.duplicate(true)
	f["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false,
		"film": 0, "rounds": 3}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "sim")
	return m
