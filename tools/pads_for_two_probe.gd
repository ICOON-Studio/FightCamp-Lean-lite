extends SceneTree
## S425 R55 "two fighters, one coach: who gets the pads" - measured BEFORE the design map (S406's lesson).
## 1) What a boxer's drill cards do over a camp with the coach's hands on every pad night, on half of them, on none
##    (PadWeek.project, the function the week itself runs), for each camp load.
## 2) What a combination's mastery is worth on fight night (the game's own bout, same days as dice).
## Usage: godot --headless --script res://tools/pads_for_two_probe.gd -- [bouts]

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")

const GOOD := [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]
const WEEKS := 6


func _initialize() -> void:
	var n := 300
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		n = int(args[0])
	print("POPULATION: Lucy (Data.lucy), quick start, coaches Data.COACHES; opponent Data.OPPONENTS[0]; %d bouts a cell" % n)
	if not args.has("fight_only"):
		for protocol in [0, 1, 2, 3]:
			_drill(protocol)
	print("--- a combination's mastery on fight night (good plan, both her combinations at the same mastery)")
	for m in [20.0, 30.0, 40.0, 50.0, 60.0, 70.0]:
		print("combos at %2.0f   won %5.1f%%" % [m, _won(m, n)])
	print("--- one plan answer missing on fight night (her combinations usable at 40): what the card the plan needs is worth")
	print("all four answers   won %5.1f%%" % _won(40.0, n))
	for i in GOOD.size():
		var plan := GOOD.duplicate(true)
		var gone: Dictionary = plan.pop_at(i)
		print("without %-10s won %5.1f%%" % [gone["move"], _won(40.0, n, plan)])
	print("no plan            won %5.1f%%" % _won(40.0, n, []))
	quit(0)


## protocol 0 = between fights (her Standard week), 1..3 = a Light / Standard / Hard camp.
func _drill(protocol: int) -> void:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	f["camp"] = {} if protocol == 0 else {"protocol": protocol}
	var inp := DrillWeek.inputs(c, f)
	var nights: Dictionary = inp["nights"]
	print("--- %s: pad nights %s, sparring %s, learning %s / %s" % ["between fights" if protocol == 0 else "camp %d" % protocol,
		nights.get("pads", []), nights.get("spar", []), f.get("learning", ""), f.get("combo_learning", "")])
	for row in [["no coach", 0.0], ["Reid on half the nights (37)", 37.0], ["Hale every night (58)", 58.0], ["Reid every night (74)", 74.0]]:
		var p := PadWeek.project(f, nights, inp["week"], float(row[1]), PadWeek.STATION_TIER, WEEKS, inp["mults"], inp["carded"])
		var bits: Array = []
		for card in p:
			var path: Array = p[card]["path"]
			if path.is_empty():
				continue
			var at := {}
			for step in path:
				at[int(step[0])] = float(step[2])
			bits.append("%s w2 %.1f w4 %.1f w6 %.1f usable wk %d" % [card, float(at.get(1, 0.0)), float(at.get(3, 0.0)),
				float(at.get(5, 0.0)), int(p[card]["weeks30"])])
		print("  %-30s %s" % [row[0], " | ".join(bits)])


func _won(m: float, n: int, arrows: Array = GOOD) -> float:
	var won := 0
	for i in n:
		var c := Career.quick_start()
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
		c.day = 40 + i
		var f: Dictionary = c.fighter()
		f["camp"] = {}
		f["combos"] = {"1-1": m, "1-2": m}
		f["arrows"] = arrows.duplicate(true)
		f["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false,
			"film": 0, "rounds": 3}
		var match_state := {"fid": f["id"], "step": "tape", "total": 3}
		Bouts.fight_step(c, f, match_state, "sim")
		won += int(str(match_state.get("outcome", "")) == "win")
	return 100.0 * won / maxf(1, n)
