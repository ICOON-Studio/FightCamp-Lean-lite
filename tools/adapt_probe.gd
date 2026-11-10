extends SceneTree
## S423 R25 groundwork: does an opponent who ADAPTS between rounds change bouts, and can the corner win it back?
## Through the game's real bout (Bouts.fight_step with LiveRound exchanges), no game code touched: the adaptation is the
## bout's own `mode_bias` hook (RingDuel.mode_bias reads f.bout.mode_bias). After each round the opponent's corner counts,
## per game she played (mode), the exchanges she won and lost; next round she plays her worst game x0.4 and her best x1.6.
## Corners: none = the plan only, no shouts; seen2 = the corner's read, two shouts a round (two instructions a minute get
## through, J55); seen = the read every 30 s. "re" = the corner sees the change and sets the round's plan to the answer to
## her new best game (what an "adapted" note would tell the player). Lucy vs each Data.OPPONENTS style, rating = paper.
##   <godot.exe> --headless --path . --audio-driver Dummy --script res://tools/adapt_probe.gd

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")
const N := 300
const WORST := 0.4
const BEST := 1.6


func _initialize() -> void:
	print("ADAPT population: Lucy (Data.lucy) vs Data.OPPONENTS 0-2 (three styles), rating = Lucy's paper, film 1, n=%d per cell" % N)
	print("ADAPT opp                 corner   fixed  adapts  adapts+re")
	for oi in 3:
		for pol in ["none", "seen2", "seen"]:
			var a := share(oi, pol, false, false)
			var b := share(oi, pol, true, false)
			var r := share(oi, pol, true, true)
			print("ADAPT %-20s %-6s   %.3f   %.3f   %.3f" % [str((Data.OPPONENTS[oi] as Dictionary)["style"]), pol, a, b, r])
	quit(0)


static func share(oi: int, pol: String, adapt: bool, re: bool) -> float:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var wins := 0
	for i in N:
		c.day = 20 + i
		var f: Dictionary = c.fighter()
		f["camp"] = {}
		f["morale"] = 60.0
		f["notes_seen"] = []
		var opp: Dictionary = (Data.OPPONENTS[oi] as Dictionary).duplicate(true)
		opp["rating"] = BoutRules.fight_power(f["stats"], {}, 0, "")
		f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		play(c, f, m, pol, adapt, re)
		wins += 1 if str(m.get("outcome", "")) == "win" else 0
	return float(wins) / N


static func play(c: Career, f: Dictionary, m: Dictionary, pol: String, adapt: bool, re: bool) -> void:
	Bouts.fight_step(c, f, m, "start")
	var base: Dictionary = {}
	while true:
		while not LiveRound.live(m).is_empty():
			if base.is_empty():
				base = (RingDuel.mode_bias(f, f["bout"]["opp"]) as Dictionary).duplicate()
			Bouts.fight_step(c, f, m, "shout:" + pick(f, m, pol))
		if int(m["round"]) >= Bouts.rounds_of(f) or Bouts.stopped(m) != "":
			break
		var tally := {}   # mode -> her net exchanges (she won minus she lost) over the rounds so far
		for ro in m["rounds"]:
			for x in ro["exchanges"]:
				var md := str(x["mode"])
				if md in ["hurt", "tiring"]:
					continue
				tally[md] = int(tally.get(md, 0)) + (-1 if bool(x["won"]) else 1)
		var best_m := ""
		var worst_m := ""
		for md in tally:
			if best_m == "" or int(tally[md]) > int(tally[best_m]):
				best_m = md
			if worst_m == "" or int(tally[md]) < int(tally[worst_m]):
				worst_m = md
		if adapt and best_m != "" and best_m != worst_m:
			var bias := base.duplicate()
			bias[worst_m] = float(bias.get(worst_m, 1.0)) * WORST
			bias[best_m] = float(bias.get(best_m, 1.0)) * BEST
			f["bout"]["mode_bias"] = bias
		var last: Dictionary = (m["rounds"] as Array)[-1]
		var plan := "" if pol == "none" else str(Exchanges.MODES[str(last["exchanges"][-1]["sit"])]["best"])
		if re and best_m != "":
			plan = str(Exchanges.MODES[best_m]["best"])
		Bouts.fight_step(c, f, m, "corner:" + (plan if plan != "" else BoutRules.auto_corner(f["stats"])))
	Bouts.fight_step(c, f, m, "end")


static func pick(f: Dictionary, m: Dictionary, pol: String) -> String:
	var lv := LiveRound.live(m)
	match pol:
		"seen":
			return str(LiveRound.preview(f, m)["coach"])
		"seen2":
			return str(LiveRound.preview(f, m)["coach"]) if int(lv["shouts"]) < 2 else ""
	return ""
