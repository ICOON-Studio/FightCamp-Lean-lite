extends SceneTree
## S308: bout win share by paper edge and by how the corner shouts, through the game's real bout (Bouts.fight_step with
## LiveRound exchanges). Lucy against Priya (OPPONENTS[1], Counter-puncher) with the rating set for each edge.
## Policies: none = say nothing all night (the plan only); seen = shout the corner's read every 30 s; seen2 = the read,
## two shouts a round; oracle = the true best call; wrong = the wrong call every time; mark = follow the shout bar's
## "coach's pick" blindly (S310: none without film study; with it the answer to her favourite game).
##   <godot.exe> --headless --path . --script res://tools/exchange_balance.gd

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const HabitFix := preload("res://scripts/rules/HabitFix.gd")
const N := 400


func _initialize() -> void:
	print("EXB population: Lucy (Data.lucy) vs Priya (Counter-puncher) rating = paper - edge, film 1, no camp, n=%d" % N)
	var lucy: Dictionary = Data.fighter_state(Data.lucy(), 20)
	print("EXB Lucy's habits %s (S309: a punished habit costs %.0f; fix = the read + the corner fixes the costliest)" % [str(lucy.get("habits", [])), HabitFix.HABIT_COST])
	print("EXB edge   none   seen  seen2 oracle  wrong    fix")
	for edge in [-10.0, -5.0, 0.0, 5.0, 10.0]:
		var row := "EXB %+5.1f" % edge
		for pol in ["none", "seen", "seen2", "oracle", "wrong", "fix"]:
			row += "  %.2f" % share(edge, pol, 1)
		print(row)
	print("EXB film 3 (the corner reads her next game), edge 0: none %.2f seen (read the clue) %.2f mark (follow the coach's pick) %.2f" % [
		share(0.0, "none", 3), share(0.0, "seen", 3), share(0.0, "mark", 3)])
	print("EXB Lucy with drops_right_after_jab (Priya punishes it), edge 0: none %.2f seen %.2f fix %.2f" % [
		share(0.0, "none", 1, ["drops_right_after_jab"]), share(0.0, "seen", 1, ["drops_right_after_jab"]), share(0.0, "fix", 1, ["drops_right_after_jab"])])
	quit(0)


## habits: Lucy's habits replaced by these (S309), null = her own.
static func share(edge: float, pol: String, film: int, habits: Variant = null) -> float:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var wins := 0
	for i in N:
		c.day = 20 + i
		var f: Dictionary = c.fighter()
		f["camp"] = {}
		if habits != null:
			f["habits"] = habits
		f["notes_seen"] = []
		var opp: Dictionary = (Data.OPPONENTS[1] as Dictionary).duplicate(true)
		var paper := BoutRules.fight_power(f["stats"], {}, film, "")
		opp["rating"] = paper - edge
		f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": film}
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		play(c, f, m, pol)
		wins += 1 if str(m.get("outcome", "")) == "win" else 0
	return float(wins) / N


## One bout with a corner that shouts by policy; the corner minute's plan is its read of the last exchange.
static func play(c: Career, f: Dictionary, m: Dictionary, pol: String) -> void:
	Bouts.fight_step(c, f, m, "start")
	while true:
		while not LiveRound.live(m).is_empty():
			Bouts.fight_step(c, f, m, "shout:" + pick(f, m, pol))
		if int(m["round"]) >= Bouts.rounds_of(f) or Bouts.stopped(m) != "":
			break
		var last: Dictionary = (m["rounds"] as Array)[-1]
		var plan := "" if pol == "none" else str(Exchanges.MODES[str(last["exchanges"][-1]["sit"])]["best"])
		# S309 "fix": the read, and the corner fixes the habit she paid for most in the round.
		var fix := ""
		if pol == "fix":
			var most := 0
			for h in LiveRound.fixes(f, last):
				if int(h["paid"]) > most:
					most = int(h["paid"])
					fix = str(h["id"])
		Bouts.fight_step(c, f, m, "corner:" + (plan if plan != "" else BoutRules.auto_corner(f["stats"])) + ("|" + fix if fix != "" else ""))
	Bouts.fight_step(c, f, m, "end")


static func pick(f: Dictionary, m: Dictionary, pol: String) -> String:
	var lv := LiveRound.live(m)
	var i := (lv["ex"] as Array).size()
	var true_sit := Exchanges.situation(str(lv["mode"]), LiveRound.her_energy(lv, i), bool(lv["her_hurt"]))
	match pol:
		"seen", "fix":
			return str(LiveRound.preview(f, m)["coach"])
		"seen2":
			return str(LiveRound.preview(f, m)["coach"]) if int(lv["shouts"]) < 2 else ""
		"mark":
			return str(LiveRound.preview(f, m)["mark"])
		"oracle":
			return str(Exchanges.MODES[true_sit]["best"])
		"wrong":
			return str(Exchanges.MODES[true_sit]["wrong"])
	return ""
