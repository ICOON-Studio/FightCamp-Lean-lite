extends SceneTree
## S461 INTEGRATE1 #4: the towel (Towel.gd) reaches fight night through TowelWire. Each check has a control arm that cannot
## share the bug (the same bout without the answer).
##   1. After round 1 the bout carries the corner minute's towel card (risk, words, line); after the last round it carries none.
##   2. Pull: the bout ends retired ("RTD") with no round 2, the result is a loss, 14 days out, morale down, loyalty logged.
##      Control: the same corner without the towel boxes round 2.
##   3. Box safe: round 2 opens on "hands" at Save pace. Control: One more round keeps her call and pace.
##   4. Nobody answers (SKIP BOUT): the coach pulls at the line by himself. Control: below the line the bout goes on.
##   6. Fight prep: the line row marks the fighter's line; picking Brave moves the card's line (TowelWire.line_of).
##   5. Shown: the strip builds in both looks (2D UI, 3D TV) and its buttons answer; the 3D overlay sends "|towel=<kind>".

const Data := preload("res://scripts/state/Data.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const TowelStrip := preload("res://scripts/ui/TowelStrip.gd")
const TV := preload("res://scripts/ui/TV.gd")
const CornerOverlay := preload("res://scripts/fight3d/CornerOverlay.gd")
const FightPrep := preload("res://scripts/ui/FightPrep.gd")
const TowelWire := preload("res://scripts/state/TowelWire.gd")

var failures := 0


func _initialize() -> void:
	_card()
	_pull()
	_safe()
	_coach()
	_shown()
	_prep()
	print("TOWEL_WIRE failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _bout(k: int = 0) -> Array:
	var sc := Career.new()
	sc.day = 61000 + k * 7
	sc.seed = 461
	sc.coach = {"rating": 60.0}
	var sf: Dictionary = Data.fighter_state(Data.lucy(), sc.day)
	var opp: Dictionary = (Data.OPPONENTS[k % Data.OPPONENTS.size()] as Dictionary).duplicate(true)
	sf["bout"] = {"opp": opp, "day": sc.day, "weighed": true, "made": true, "done": false, "film": 1}
	sc.fighters = [sf]
	var m: Dictionary = BoutNight.fight_modal(sf)
	BoutNight.fight_step(sc, sf, m, "start")
	BoutNight.fight_step(sc, sf, m, "round_out")
	return [sc, sf, m]


func _card() -> void:
	var b := _bout()
	var m: Dictionary = b[2]
	var tc: Dictionary = m.get("towel", {})
	_check(tc.has("risk") and str(tc.get("words", "")).begins_with("Stopped next round:") and str(tc.get("line", "")) == "normal",
		"1 a card after round 1 (%s)" % str(tc))
	BoutNight.fight_step(b[0], b[1], m, "rest")
	_check((m.get("towel", {}) as Dictionary).is_empty() or BoutNight.stopped(m) != "", "1 no card after the last round")


func _pull() -> void:
	var b := _bout(1)
	var sf: Dictionary = b[1]
	var m: Dictionary = b[2]
	var morale := float(sf.get("morale", 60.0))
	BoutNight.fight_step(b[0], sf, m, "corner:hands|towel=pull")
	_check(BoutNight.stopped(m) == "RTD" and (m["rounds"] as Array).size() == 1, "2 pulled: RTD after round 1 (%s, %d rounds)" % [
		BoutNight.stopped(m), (m["rounds"] as Array).size()])
	BoutNight.fight_step(b[0], sf, m, "end")
	_check(str(m.get("outcome", "")) == "loss", "2 a retirement is a loss (%s)" % str(m.get("outcome", "")))
	_check(int((sf.get("injury", {}) as Dictionary).get("days_out", 0)) == 14, "2 14 days out (%s)" % str(sf.get("injury", {})))
	_check(float(sf.get("morale", 60.0)) < morale, "2 morale down (%.1f -> %.1f)" % [morale, float(sf.get("morale", 60.0))])
	_check(Loyalty.log_of(sf).any(func(e): return str(e.get("why", "")).begins_with("towel")), "2 loyalty logged")
	var c := _bout(1)
	BoutNight.fight_step(c[0], c[1], c[2], "corner:hands")
	_check(BoutNight.stopped(c[2]) == "" and int(c[2]["round"]) == 2, "2 control: no towel, round 2 boxes")
	var e := _bout(1)
	BoutNight.fight_step(e[0], e[1], e[2], "corner:")   # S461 trap: an empty call (the plan's default) must still open the round
	_check(BoutNight.stopped(e[2]) == "" and int(e[2]["round"]) == 2, "2 an empty corner call opens round 2")


func _safe() -> void:
	var b := _bout(2)
	BoutNight.fight_step(b[0], b[1], b[2], "corner:long|towel=box_safe")
	BoutNight.fight_step(b[0], b[1], b[2], "round_out")
	var r2: Dictionary = (b[2]["rounds"] as Array)[1]
	var x0: Dictionary = (r2.get("exchanges", []) as Array)[0]
	_check(str(r2["corner"]) == "hands" and str(x0.get("pace", "")) == "save", "3 box safe: hands at save (%s, %s)" % [
		str(r2["corner"]), str(x0.get("pace", ""))])
	var c := _bout(2)
	BoutNight.fight_step(c[0], c[1], c[2], "corner:long|towel=one_more")
	BoutNight.fight_step(c[0], c[1], c[2], "round_out")
	var c2: Dictionary = (c[2]["rounds"] as Array)[1]
	var y0: Dictionary = (c2.get("exchanges", []) as Array)[0]
	_check(str(c2["corner"]) == "long" and str(y0.get("pace", "")) != "save", "3 control: one more keeps the call (%s, %s)" % [
		str(c2["corner"]), str(y0.get("pace", ""))])


func _coach() -> void:
	var b := _bout(3)
	(b[2]["towel"] as Dictionary)["coach_pulls"] = true
	BoutNight.fight_step(b[0], b[1], b[2], "rest")
	_check(BoutNight.stopped(b[2]) == "RTD" and str(b[2].get("outcome", "")) == "loss", "4 the coach pulls on SKIP BOUT (%s)" % BoutNight.stopped(b[2]))
	var c := _bout(3)
	(c[2]["towel"] as Dictionary)["coach_pulls"] = false
	BoutNight.fight_step(c[0], c[1], c[2], "rest")
	_check(BoutNight.stopped(c[2]) != "RTD" and (c[2]["rounds"] as Array).size() >= 2, "4 control: below the line it goes on")


func _shown() -> void:
	var tc := {"comes": true, "reasons": [{"id": "count", "words": "a count in the round just gone"}],
		"words": "Stopped next round: 24 in 100 (Box safe: 11 in 100). Your line: 20.", "coach_pulls": true}
	for look in [null, TV]:
		var got := []
		var strip: Control = TowelStrip.build(tc, func(k: String): got.append(k)) if look == null else TowelStrip.build(tc, func(k: String): got.append(k), look)
		for kind in ["pull", "box_safe", "one_more"]:
			var b := strip.find_child("Towel_" + kind, true, false) as Button
			if b != null:
				b.pressed.emit()
		_check(got == ["pull", "box_safe", "one_more"], "5 the strip's buttons answer (%s)" % str(got))
		strip.free()
	var ov: Control = CornerOverlay.new()
	ov.towel = "box_safe"
	_check(ov.jobs_suffix() == "|towel=box_safe", "5 the 3D corner sends the answer (%s)" % ov.jobs_suffix())
	ov.free()



func _prep() -> void:
	var f: Dictionary = Data.fighter_state(Data.lucy(), 1)
	var stub := GDScript.new()
	stub.source_code = "extends Node
var got := []
func act(n: String, a: String = \"\") -> void:
	got.append(n + \":\" + a)
"
	stub.reload()
	var main: Node = stub.new()
	var row: HBoxContainer = FightPrep.towel_row(main, f)
	var normal := row.find_child("Towel_normal", true, false) as Button
	_check(normal != null and normal.theme_type_variation == "BtnSolid" and row.get_child_count() == 4, "6 the row marks Normal")
	(row.find_child("Towel_brave", true, false) as Button).pressed.emit()
	_check(main.got == ["towelline:%s|brave" % str(f["id"])], "6 Brave sends its act (%s)" % str(main.got))
	row.free()
	main.free()
	f["towel_line"] = "brave"
	_check(TowelWire.line_of(f) == "brave", "6 the fighter's line reaches the card")
	f["bout"] = {"towel_line": "careful"}
	_check(TowelWire.line_of(f) == "careful", "6 a bout's own line wins")


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)
