extends SceneTree
## S544 FADEREAD (TELLPLAY1, docs/TELLPLAY1_RESULT.md): a plan line "when the opponent tires" read +7 to +15 points of win
## chance on the cards while 60,000 real bouts paid +0.9. The read added the line whole in every tiring exchange
## (BoutRead._game_edge_of, PLAN_REACH x PLAN_CARRY, no fire share). Since S544 the tiring situation walks the card chain at
## its fire share like the opponent's other games (BoutRead._round_edges, PlanChain.walk).
##   1. worth: _game_edge_of(f, "tiring", n) is the same with and without a fade line (red before S544: the line sat here);
##   2. control arm: the same fighter's read still moves with the line (the chain counts it), so the line is not lost;
##   3. the cap: no fade line a boxer can throw adds 10 points or more against a fader (DESIGN bar "never a win button").
## Population: Lucy (Data.lucy) as signed and +8 on every stat, the inside combinations drilled, against a pressure fighter
## who fades after round 2, same class, a 4-round pro card; the coach's plan (Reid 58) under every arm.

const Data := preload("res://scripts/state/Data.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")
const CoachPlan := preload("res://scripts/rules/CoachPlan.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")

const CAMP := {"protocol": 2, "focus": "conditioning", "film": false, "partner": false, "start": 0}
const COACH := 58.0
const CAP := 0.10

var _fails := 0


func _initialize() -> void:
	var seen := 0
	for shift in [0.0, 8.0]:
		var f := _boxer(shift)
		var opp := DebutOpp.make(f, 0.0, 0, "fade_read")
		opp.merge({"style": "Pressure fighter", "threat": "Stops people", "weak": "Fades after round 2"}, true)
		var base: Array = CoachPlan.write(str(opp["style"]), COACH, f.get("moves", {}), f.get("combos", {}), f.get("steps", {}))
		var p0 := _chance(f, opp, base)
		for o in PlanLines.options(str(PlanFight.GAME_CARD["tiring"]), "tiring", f.get("moves", {}), f.get("combos", {})):
			if str(o["why"]) != "" or str(o["fit"]) != "best":
				continue
			seen += 1
			var line := {"move": str(o["id"]), "when": "tiring"}
			var with: Array = base + [line]
			var fa := _with(f, base)
			var fb := _with(f, with)
			var worth_a := BoutRead._game_edge_of(fa, "tiring", 3)
			var worth_b := BoutRead._game_edge_of(fb, "tiring", 3)
			_check(is_equal_approx(worth_a, worth_b), "worth of the tiring situation holds no plan line (%s, shift %d): %.3f v %.3f" % [o["id"], int(shift), worth_a, worth_b])
			var gain := _chance(f, opp, with) - p0
			_check(gain < CAP, "the fade line %s adds under %d points (shift %d): %+.1f" % [o["id"], int(CAP * 100), int(shift), 100.0 * gain])
			_check(not is_zero_approx(gain), "the fade line %s still moves the read through the chain (shift %d): %+.2f" % [o["id"], int(shift), 100.0 * gain])
	_check(seen >= 2, "at least two best fade lines were tried (%d)" % seen)
	print("FADE_READ %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


## Lucy with the inside combinations drilled to full rate, so a best answer to a tiring opponent is hers to write.
func _boxer(shift: float) -> Dictionary:
	var f: Dictionary = Data.fighter_state(Data.lucy(), 0)
	for k in f["stats"]:
		f["stats"][k] = float(f["stats"][k]) + shift
	var moves: Dictionary = f.get("moves", {})
	for id in moves.keys():
		moves[id] = 100.0
	f["moves"] = moves
	var combos: Dictionary = f.get("combos", {})
	for id in ["1-2-3", "3b-3", "1-2-3-2"]:
		combos[id] = 100.0
	f["combos"] = combos
	return f


func _with(f: Dictionary, arrows: Array) -> Dictionary:
	var g := f.duplicate()
	g["pro"] = true
	g["bout"] = {"tank_ahead": 0.0, "pro": true, "rounds": 4}
	g["arrows"] = arrows.duplicate(true)
	return g


func _chance(f: Dictionary, opp: Dictionary, arrows: Array) -> float:
	var edges := BoutRead.round_edges(_with(f, arrows), opp, CAMP, COACH)
	return float(BoutRead.CardOdds.result(edges, BoutRead.RingDuel.FORM_SD)["win"])


func _check(ok: bool, what: String) -> void:
	print(("ok   " if ok else "FAIL ") + what)
	if not ok:
		_fails += 1
