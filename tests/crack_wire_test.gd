extends SceneTree
## S470 LIVERRIBS1 step 4: a cracked rib reaches the corner through CrackWire. Each check has a control arm that cannot
## share the bug (the same bout without the crack or without the answer).
##   1. The card comes only when YOUR boxer's rib cracked, with three rows; control: no crack, no card.
##   2. Pull: the bout ends retired ("RTD") with no round 2, a loss, the cracked rib booked at 35 days.
##      Control: the same corner call without the answer boxes round 2.
##   3. Defend / Fight through: the answer is kept, the card does not come again, the cracked side's punches land
##      x0.5 / x0.6; the opponent's cracked side always x0.6.
##   4. The injury after the bell is the cracked rib with the choice's days (defend 63, fight 84 or 112, none = fight).
##   5. The OPPONENT cracked: over 40 bells the other corner retires its boxer some times and not others; a retirement
##      is "RTD_B" and YOUR boxer's win, even with your boxer counted in that round. Control: no crack, never.
##   6. Shown: the strip builds in both looks with three buttons that answer; the 3D corner sends "|crack=<kind>".

const Data := preload("res://scripts/state/Data.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const CrackWire := preload("res://scripts/state/CrackWire.gd")
const CrackStrip := preload("res://scripts/ui/CrackStrip.gd")
const LiverRibs := preload("res://scripts/rules/LiverRibs.gd")
const TV := preload("res://scripts/ui/TV.gd")
const CornerOverlay := preload("res://scripts/fight3d/CornerOverlay.gd")

var failures := 0


func _initialize() -> void:
	_card()
	_pull()
	_choice()
	_injury()
	_bell()
	_shown()
	print("CRACK_WIRE failures=%d" % failures)
	quit(0 if failures == 0 else 1)


## A bout with round 1 boxed. who = whose left ribs cracked in it ("" = nobody).
func _bout(k: int = 0, who: String = "a") -> Array:
	var sc := Career.new()
	sc.day = 61000 + k * 7
	sc.seed = 470
	sc.coach = {"rating": 60.0}
	var sf: Dictionary = Data.fighter_state(Data.lucy(), sc.day)
	var opp: Dictionary = (Data.OPPONENTS[k % Data.OPPONENTS.size()] as Dictionary).duplicate(true)
	sf["bout"] = {"opp": opp, "day": sc.day, "weighed": true, "made": true, "done": false, "film": 1}
	sc.fighters = [sf]
	var m: Dictionary = BoutNight.fight_modal(sf)
	BoutNight.fight_step(sc, sf, m, "start")
	BoutNight.fight_step(sc, sf, m, "round_out")
	if BoutNight.stopped(m) != "":
		return _bout(k + 11, who)   # this pair ended in round 1: take another
	if who != "":
		sf["bout"]["cracked"] = {"a": who == "a", "b": who == "b"}
	return [sc, sf, m]


func _card() -> void:
	var b := _bout()
	var total := BoutNight.rounds_of(b[1])
	var cc := CrackWire.card(b[1], b[2], total)
	var rows: Array = cc.get("rows", [])
	_check(bool(cc.get("comes", false)) and rows.size() == 3 and rows.map(func(r): return str(r["kind"])) == CrackWire.KINDS,
		"1 a card with three rows after her rib cracked (%s)" % str(cc))
	_check(str(rows[0]["words"]).contains("35 days") and str(rows[1]["words"]).contains("63 days") and str(rows[2]["words"]).contains("84 days"),
		"1 each row prints its days")
	var n := _bout(0, "")
	_check(CrackWire.card(n[1], n[2], total).is_empty(), "1 control: no crack, no card")
	var o := _bout(0, "b")
	_check(CrackWire.card(o[1], o[2], total).is_empty(), "1 the opponent's crack brings no card")


func _pull() -> void:
	var b := _bout(1)
	var sf: Dictionary = b[1]
	var m: Dictionary = b[2]
	BoutNight.fight_step(b[0], sf, m, "corner:hands|crack=pull")
	_check(BoutNight.stopped(m) == "RTD" and (m["rounds"] as Array).size() == 1, "2 pulled: RTD after round 1 (%s, %d rounds)" % [
		BoutNight.stopped(m), (m["rounds"] as Array).size()])
	BoutNight.fight_step(b[0], sf, m, "end")
	_check(str(m.get("outcome", "")) == "loss", "2 a retirement is a loss (%s)" % str(m.get("outcome", "")))
	var inj: Dictionary = sf.get("injury", {})
	_check(int(inj.get("days_out", 0)) == 35 and str(inj.get("type", "")) == "ribs" and str(inj.get("kind", "")) == "cracked",
		"2 the cracked rib at 35 days (%s)" % str(inj))
	var c := _bout(1)
	BoutNight.fight_step(c[0], c[1], c[2], "corner:hands")
	_check(BoutNight.stopped(c[2]) == "" and int(c[2]["round"]) == 2, "2 control: no answer, round 2 boxes")


func _choice() -> void:
	for kind in ["defend", "fight"]:
		var b := _bout(2)
		BoutNight.fight_step(b[0], b[1], b[2], "corner:hands|crack=" + kind)
		_check(CrackWire.choice(b[1]) == kind and BoutNight.stopped(b[2]) == "" and int(b[2]["round"]) == 2,
			"3 %s is kept and round 2 boxes (%s)" % [kind, CrackWire.choice(b[1])])
		_check(CrackWire.card(b[1], b[2], BoutNight.rounds_of(b[1])).is_empty(), "3 %s: the card does not come again" % kind)
		var want := CrackWire.DEFEND_OUTPUT if kind == "defend" else LiverRibs.CRACK_OUTPUT
		_check(is_equal_approx(CrackWire.output(b[1], "a"), want), "3 %s: her cracked side lands x%.2f (%.2f)" % [kind, want, CrackWire.output(b[1], "a")])
		_check(is_equal_approx(CrackWire.output(b[1], "b"), LiverRibs.CRACK_OUTPUT), "3 %s: the opponent's side stays x0.6" % kind)
	var b2 := _bout(2)
	BoutNight.fight_step(b2[0], b2[1], b2[2], "corner:hands|crack=nonsense")
	_check(CrackWire.choice(b2[1]) == "", "3 an unknown answer is no answer")


func _injury() -> void:
	var b := _bout(3)
	var sf: Dictionary = b[1]
	var m := {"stopped": ""}
	_check(int(CrackWire.injury(sf, m, 0.5).get("days_out", 0)) == 84, "4 nobody answered = fight through, 84 days")
	_check(int(CrackWire.injury(sf, m, 0.05).get("days_out", 0)) == 84 + LiverRibs.WORSE_DAYS, "4 fight through, 1 in 10 worse")
	sf["bout"]["crack_choice"] = "defend"
	var d := CrackWire.injury(sf, m, 0.05)
	_check(int(d.get("days_out", 0)) == 63 and str(d.get("kind", "")) == "cracked" and str(d.get("type", "")) == "ribs", "4 defend: 63 days (%s)" % str(d))
	_check(CrackWire.injury(sf, {"stopped": "RTD"}, 0.5).is_empty(), "4 a pull already booked it")
	var n := _bout(3, "")
	_check(CrackWire.injury(n[1], m, 0.5).is_empty(), "4 control: no crack, the normal roll stands")


func _bell() -> void:
	var retired := 0
	var talked := 0
	for k in 40:
		var b := _bout(20 + k, "b")
		var m: Dictionary = b[2]
		var total := BoutNight.rounds_of(b[1])
		if total < 2:
			continue
		(m["rounds"][-1] as Dictionary)["down"] = "a"   # your boxer was counted in that round: still a win if they retire
		var over := CrackWire.bell(b[0], b[1], m, total)
		_check(over == CrackWire.bell(b[0], b[1], m, total), "5 one roll a bell (bout %d)" % k)
		if over:
			retired += 1
			_check(BoutNight.stopped(m) == CrackWire.STOP_B and BoutNight.outcome_of(b[1], m) == "win", "5 retired = RTD_B and a win (%s, %s)" % [
				BoutNight.stopped(m), BoutNight.outcome_of(b[1], m)])
			BoutNight.fight_step(b[0], b[1], m, "corner:hands")
			_check((m["rounds"] as Array).size() == 1, "5 no round after the retirement")
		else:
			talked += 1
			_check(BoutNight.stopped(m) == "" and str((m["rounds"][-1]["lines"] as Array)[-1]).contains("talking about stopping"), "5 not retired: the corner read says so")
	_check(retired >= 8 and talked >= 5, "5 both happen over 40 bells (retired %d, not %d)" % [retired, talked])
	var n := _bout(20, "")
	_check(not CrackWire.bell(n[0], n[1], n[2], BoutNight.rounds_of(n[1])) and BoutNight.stopped(n[2]) == "", "5 control: no crack, no retirement")


func _shown() -> void:
	var b := _bout(4)
	var cc := CrackWire.card(b[1], b[2], BoutNight.rounds_of(b[1]))
	for look in [null, TV]:
		var got := []
		var strip: Control = CrackStrip.build(cc, func(k: String): got.append(k)) if look == null else CrackStrip.build(cc, func(k: String): got.append(k), look)
		for kind in CrackWire.KINDS:
			var btn := strip.find_child("Crack_" + kind, true, false) as Button
			if btn != null:
				btn.pressed.emit()
		_check(got == CrackWire.KINDS, "6 the strip's buttons answer (%s)" % str(got))
		strip.free()
	var ov: Control = CornerOverlay.new()
	ov.crack = "defend"
	_check(ov.jobs_suffix() == "|crack=defend", "6 the 3D corner sends the answer (%s)" % ov.jobs_suffix())
	ov.free()


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)
