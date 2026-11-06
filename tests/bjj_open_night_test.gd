extends SceneTree
## S389 BJJWIRE: an open she entered waits for the player bout by bout (Grapplers.live) and feeds her record, morale and belt.

const Grapplers := preload("res://scripts/state/Grapplers.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const BjjOpen := preload("res://scripts/rules/BjjOpen.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)


func _career() -> Career:
	var c := Career.new()
	c.seed = 11
	c.cash = 5000
	c.grapplers = [NoGi.athlete()]
	return c


func _to_open(c: Career, d: int) -> void:
	c.day = d
	Grapplers.day(c)


func _initialize() -> void:
	# The walk still plays a whole bracket.
	var rng := RandomNumberGenerator.new()
	rng.seed = 5
	var res := BjjOpen.run_open(NoGi.athlete(), NoGi.open_on(33), 33, rng)
	_check((res["matches"] as Array).size() >= 1 and int(res["wins"]) <= 3, "run_open still plays a bracket")
	_check(int(res["wins"]) == 3 or not bool((res["matches"] as Array).back()["win"]), "a run ends on a loss or the final")

	# Live: the day stops, a red need appears, nothing is decided yet.
	Grapplers.live = true
	var c := _career()
	_check(Grapplers.enter(c, "ana", 33) == "", "she enters")
	var ana: Dictionary = c.grapplers[0]
	var classes := int(ana.get("mat_classes", 0))
	var past := (ana.get("opens", []) as Array).size()
	_to_open(c, 33)
	_check(not Grapplers.open_due(c).is_empty(), "the open waits for the player")
	_check(Needs.blockers(c).any(func(n): return str(n["act"]) == "opennight"), "the open stops time as a red need")
	_check((ana.get("opens", []) as Array).size() == past, "no result before she fights")

	# A fought win, a simulated bout, a fought loss if the run is still on.
	var opp := Grapplers.next_opp(c, ana)
	_check(float(BjjOpen.match_opp(opp)["skill"]) > 0.0 and str(opp["name"]) != "", "the opponent is the bracket's")
	Grapplers.live_bout(c, ana, {"win": true, "how": "submission armbar", "landed": ["Armbar"]})
	_check(int(ana["open_run"]["wins"]) == 1 and not bool(ana["open_run"]["over"]), "a fought win moves her on")
	_check(str(Grapplers.next_opp(c, ana)["name"]) != str(opp["name"]), "round 2 is the next name in the bracket")
	Grapplers.sim_bout(c, ana)
	if not bool(ana["open_run"]["over"]):
		Grapplers.live_bout(c, ana, {"win": false, "how": "points 2-4", "landed": []})
	_check(bool(ana["open_run"]["over"]), "the run ends")
	var bouts := (ana["open_run"]["rows"] as Array).size()
	var wins := int(ana["w"])
	Grapplers.close_open(c, ana)

	_check(Grapplers.open_due(c).is_empty(), "the need clears")
	_check((ana["opens"] as Array).size() == past + bouts, "every bout is on her record")
	_check(int(ana["w"]) > wins, "wins count")
	_check(int(ana["mat_classes"]) == classes + bouts * BjjOpen.BOUT_CLASSES, "bouts count towards the belt")
	_check(int(ana["open_week"]["classes"]) == bouts * BjjOpen.BOUT_CLASSES, "the week review can say so")
	var row := {"opp": "Rosa", "style": "", "win": true, "how": "submission armbar", "landed": ["Armbar"], "path": []}
	_check(BjjOpen.path_line(row, 0).to_lower().contains("armbar"), "the fought bout's line names what landed")

	# Headless default: unchanged.
	Grapplers.live = false
	var c2 := _career()
	Grapplers.enter(c2, "ana", 33)
	_to_open(c2, 33)
	_check(Grapplers.open_due(c2).is_empty() and (c2.grapplers[0]["opens"] as Array).size() > past, "headless opens still play themselves")

	print("BJJ_OPEN_NIGHT %s failures=%d" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(1 if failures > 0 else 0)
