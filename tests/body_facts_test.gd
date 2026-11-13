extends SceneTree
## BODYFACTS1: our fighters get a height and a reach. The generator (AttrGen.body) already gives opponents theirs;
## BodyFacts.fill seeds the rng from the fighter's name so the same name always measures the same body.

const Data := preload("res://scripts/state/Data.gd")
const BodyFacts := preload("res://scripts/rules/BodyFacts.gd")
const Duels := preload("res://scripts/rules/Duels.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")
const Sim := preload("res://scripts/state/Sim.gd")

var failures := 0


func _initialize() -> void:
	_fighter_state_gets_body()
	_stable()
	_preserves_existing()
	_men_taller_than_women()
	_reach_edge_not_zero()
	_career_round_trip()
	print("BODY_FACTS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, label: String) -> void:
	if ok:
		print("  ok: " + label)
	else:
		failures += 1
		print("  FAIL: " + label)


func _fighter_state_gets_body() -> void:
	var raw := Data.lucy()
	var f := Data.fighter_state(raw, 20)
	_check(f.has("height") and f.has("reach"), "fighter_state returns height and reach")
	var h := int(f["height"])
	var r := int(f["reach"])
	_check(h >= 150 and h <= 185, "height in 150-185 for women's lightweight (got %d)" % h)
	_check(r >= h - 6 and r <= h + 12, "reach within height-6..height+12 (h=%d r=%d)" % [h, r])


func _stable() -> void:
	var a := Data.fighter_state(Data.lucy(), 20)
	var b := Data.fighter_state(Data.lucy(), 20)
	_check(int(a["height"]) == int(b["height"]) and int(a["reach"]) == int(b["reach"]),
		"same raw dict twice gives the same height and reach")


func _preserves_existing() -> void:
	var raw := Data.lucy()
	raw["height"] = 171
	raw["reach"] = 175
	var f := Data.fighter_state(raw, 20)
	_check(int(f["height"]) == 171 and int(f["reach"]) == 175, "existing height 171 / reach 175 kept")


func _men_taller_than_women() -> void:
	var w_sum := 0
	var m_sum := 0
	var n := 50
	for i in n:
		var wf := {"name": "W%d" % i, "sex": "f", "div": "wlw", "limit": 60.0,
			"stats": {"power": 50, "speed": 50, "technique": 50, "defense": 50, "conditioning": 50, "fight_iq": 50, "chin": 50}}
		var mf := {"name": "M%d" % i, "sex": "m", "div": "mww", "limit": 70.0,
			"stats": {"power": 50, "speed": 50, "technique": 50, "defense": 50, "conditioning": 50, "fight_iq": 50, "chin": 50}}
		w_sum += int(Data.fighter_state(wf, 20)["height"])
		m_sum += int(Data.fighter_state(mf, 20)["height"])
	var w_avg := float(w_sum) / float(n)
	var m_avg := float(m_sum) / float(n)
	_check(m_avg - w_avg >= 5.0, "men's welterweight mean (%.1f) at least 5 cm above women's lightweight mean (%.1f)" % [m_avg, w_avg])


func _reach_edge_not_zero() -> void:
	var f := Data.fighter_state(Data.lucy(), 20)
	var opp: Dictionary = Data.OPPONENTS[0]
	_check(opp.has("reach"), "opponent has reach (precondition)")
	var facts := Duels.facts(f, opp)
	_check(float(facts["reach"]) != 0.0, "Duels.facts reach is not 0 for our fighter vs opponent")


func _career_round_trip() -> void:
	var c := Career.quick_start("BodyFacts Gym", "London")
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	_check(not c.fighters.is_empty(), "Career has a signed fighter")
	var f: Dictionary = c.fighters[0]
	_check(f.has("height") and f.has("reach"), "signed fighter has height and reach")
	f.erase("height")
	f.erase("reach")
	var d := SaveGame.to_dict(c)
	var loaded := SaveGame.from_dict(d)
	var lf: Dictionary = loaded.fighters[0]
	_check(lf.has("height") and lf.has("reach"), "after erase + round trip, height and reach are back")
