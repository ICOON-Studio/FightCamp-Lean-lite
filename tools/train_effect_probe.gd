extends SceneTree
## S388 does the better-trained fighter win? (operator: "better trained fighter wins"). Same boxer, same opponent, the same days as dice, every
## attribute moved by the same amount, with and without a good plan. Prints bouts won.
## Usage: godot --headless --script res://tools/train_effect_probe.gd -- [bouts]

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")

const GOOD := [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]


func _initialize() -> void:
	var n := 200
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		n = int(args[0])
	print("Opponent rating %.1f, boxer stats %s" % [float(Data.OPPONENTS[0]["rating"]), Data.lucy().get("stats", {})])
	for add in [-10, -5, 0, 3, 5, 10, 15]:
		print("stats %+3d   no plan %5.1f%%   good plan %5.1f%%" % [add, _won(add, [], n), _won(add, GOOD, n)])
	quit(0)


func _won(add: int, arrows: Array, n: int) -> float:
	var won := 0
	for i in n:
		var c := Career.quick_start()
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
		c.day = 40 + i
		var f: Dictionary = c.fighter()
		for k in f["stats"]:
			f["stats"][k] = float(f["stats"][k]) + add
		f["camp"] = {}
		f["combos"] = {"1-1": 50.0, "1-2": 50.0}
		f["arrows"] = arrows.duplicate(true)
		f["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false,
			"film": 0, "rounds": 3}
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		Bouts.fight_step(c, f, m, "sim")
		won += int(str(m.get("outcome", "")) == "win")
	return 100.0 * won / maxf(1, n)
