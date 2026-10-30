extends SceneTree
## S310 the corner minute's jobs (CornerJobs, Q-S294-20): recover points, a combination set-up with its NOW, the talk.
## Rules, the corner action's parsing, the live round, and bounded balance (never exact counts).

const CJ := preload("res://scripts/rules/CornerJobs.gd")
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const X := preload("res://scripts/rules/Exchanges.gd")
const XB := preload("res://tools/exchange_balance.gd")
const CornerJobsRow := preload("res://scripts/ui/CornerJobsRow.gd")

var failures := 0


func _initialize() -> void:
	# 1. Recover: 3 points at most, water worth more when she is tired, ice gives body hits back, head clears hurt.
	var r := CJ.recover({"water": 5, "ice": 2, "head": 1}, 30.0, 9, true)
	_check(int(r["used"]) == 3 and not bool(r["hurt"]) and int(r["body"]) == 6 and float(r["energy"]) == 0.0, "3 points: head first, then ice, water gets none")
	_check(float(CJ.recover({"water": 3}, 30.0, 0, false)["energy"]) > float(CJ.recover({"water": 3}, 80.0, 0, false)["energy"]), "water gives more to a tired fighter")
	_check(bool(CJ.recover({"water": 3}, 80.0, 0, true)["hurt"]), "not cleared: she starts the round hurt")
	_check(CJ.recover_options(80.0, 0, false).size() == 2 and CJ.recover_options(80.0, 0, true).size() == 3, "clear her head is offered only when she is hurt")
	# 2. Set-up: her learned combinations only; the gaps are the opponent's main games + tiring.
	_check(CJ.setups({"1-2": 60.0, "1-1": 10.0}, 30.0) == ["1-2"], "only combinations she has learned")
	var g := CJ.gaps(X.STYLE_MODES["Counter-puncher"])
	_check(g[0] == "counter" and g.has("tiring") and g.size() == 3, "gaps: her favourite games and tiring (%s)" % str(g))
	_check(CJ.setup_edge(true, 80.0, 80.0) > CJ.setup_edge(true, 30.0, 80.0) and CJ.setup_edge(false, 80.0, 80.0) < 0.0 and CJ.setup_edge(true, 80.0, 20.0) < CJ.setup_edge(true, 80.0, 80.0),
		"set-up: mastery adds, a wrong gap costs, a weary fighter lands less")
	# 3. Talk reads her personality: calm suits a hothead, firing up a hothead risks her.
	var hot := {"temper": 80.0, "confidence": 55.0, "discipline": 50.0}
	_check(float(CJ.talk("calm", hot)["edge"]) > float(CJ.talk("fire", hot)["edge"]) and float(CJ.talk("fire", hot)["hurt"]) > 1.3, "a hothead: calm helps, fire makes her wild")
	_check(float(CJ.talk("truth", {"discipline": 70.0, "confidence": 60.0})["edge"]) > 0.0 and float(CJ.talk("truth", {"discipline": 40.0, "confidence": 30.0})["edge"]) < 0.0, "the truth: a disciplined fighter uses it, a fragile one sinks")
	# 4. The corner action: labelled parts parse; the old "call|habit" still works.
	_check(CJ.fits("press", "press") and CJ.fits("press", "hurt") and not CJ.fits("press", "range"),
		"S313: a set-up fires in its gap, and into a hurt opponent whatever its gap")
	var j := Bouts.corner_jobs("long|fix=slow_starter|setup=1-2@press|talk=calm|rec=water:2,ice:1".split("|"))
	_check(str(j["fix"]) == "slow_starter" and str(j["setup"]["combo"]) == "1-2" and str(j["setup"]["gap"]) == "press" and str(j["talk"]) == "calm"
		and int(j["rec"]["water"]) == 2 and int(j["rec"]["ice"]) == 1, "corner action parts parse")
	_check(str(Bouts.corner_jobs("long|slow_starter".split("|"))["fix"]) == "slow_starter", "the S309 call|habit form still works")
	var sel := {"rec": {"water": 2, "ice": 1, "head": 0}, "setup": {"combo": "1-2", "gap": "counter"}, "talk": "truth"}
	_check(CornerJobsRow.suffix(sel) == "|setup=1-2@counter|talk=truth|rec=water:2,ice:1", "the card builds the same parts (%s)" % CornerJobsRow.suffix(sel))
	# 5. A live fight: the NOW offer shows only when the corner sees the gap; fired, it is used once; landed, it is damage.
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["combos"] = {"1-2": 70.0}
	var opp: Dictionary = (Data.OPPONENTS[1] as Dictionary).duplicate(true)
	f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 3}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "start")
	while not LiveRound.live(m).is_empty():
		Bouts.fight_step(c, f, m, "shout:")
	Bouts.fight_step(c, f, m, "corner:lead|setup=1-2@counter|talk=calm|rec=water:3")
	var lv := LiveRound.live(m)
	_check(str(lv["setup"]["combo"]) == "1-2" and str(lv["talk_kind"]) == "calm", "round 2 opens with the set-up and the talk")
	var offered := 0
	var fired := ""
	var shown_right := true
	while not LiveRound.live(m).is_empty():
		var pv := LiveRound.preview(f, m)
		var now: Dictionary = pv["now"]
		if not now.is_empty():
			offered += 1
			shown_right = shown_right and str(pv["sit"]) == "counter"
			Bouts.fight_step(c, f, m, "shout:now")
			fired = str((m["rounds"] as Array)[-1]["exchanges"][-1]["setup"]) if LiveRound.live(m).is_empty() else str(LiveRound.live(m)["ex"][-1]["setup"])
		else:
			Bouts.fight_step(c, f, m, "shout:")
	_check(shown_right and offered <= 1, "NOW shows only on the gap, once (%d offered)" % offered)
	if offered == 1:
		_check(fired in ["landed", "missed"], "fired: the exchange records it (%s)" % fired)
		if fired == "landed":
			_check(float(m.get("damage", {}).get("b", 0.0)) >= CJ.SETUP_DAMAGE, "a landed set-up is head damage on her")
	var no_combo := CJ.setups({}, 30.0)
	_check(no_combo.is_empty(), "no combination learned: no set-up (drill one on the pads)")
	# 6. Balance (Lucy vs Priya, film study, 400 bouts each): the set-up fired at the gap helps, the talks stay small,
	# stoppages stay near the amateur rate (J-KDRATES1: 5-12 stopped in 100).
	var st0 := {}
	var st1 := {}
	var base := XB.share(0.0, "seen", 3, null, st0)
	var setup := XB.share(0.0, "setup", 3, null, st1)
	var truth := XB.share(0.0, "talk_truth", 3)
	print("  seen %.2f (stops %.3f), set-up %.2f (stops %.3f), truth %.2f" % [base, float(st0.get("stops", 0)) / XB.N, setup, float(st1.get("stops", 0)) / XB.N, truth])
	_check(setup >= base + 0.02, "a set-up fired at the gap wins more")
	_check(float(st1.get("stops", 0)) >= float(st0.get("stops", 0)) and float(st1.get("stops", 0)) / XB.N <= 0.15, "set-ups stop more fights, within amateur rates")
	_check(truth <= base + 0.06, "one talk is a nudge, not a win button")
	print("CORNERJOBS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
