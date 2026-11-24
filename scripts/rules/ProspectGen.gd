extends RefCounted
## KNOWBUILD1 (S545): the names the scout brings once the five named prospects (Data.PROSPECTS) have all come through
## (map 3D: one new name every 4-6 weeks, so a two-year career sees about twenty). Pure static: a seeded copy of one of
## the named prospects' frames (their division, weight and style, valid in the ruleset) with its own name, record, stats
## and personality, drawn until the first look sits within ProspectClock.SCOUT_BAND of the level. Fictional names.
##   make(n, seed, templates, level) -> a prospect dict in Data.PROSPECTS' shape (id "scout_<n>")

const K := preload("res://scripts/rules/Knowledge.gd")
const PC := preload("res://scripts/rules/ProspectClock.gd")

const FIRST_F := ["Abi", "Jade", "Leah", "Nia", "Ruby", "Esme", "Mia", "Tia", "Freya", "Ola", "Zara", "Cara", "Hana", "Lola", "Remi"]
const FIRST_M := ["Kai", "Theo", "Rio", "Sami", "Jude", "Ollie", "Tayo", "Callum", "Reece", "Ash", "Malik", "Finn", "Jay", "Kofi", "Luca"]
const LAST := ["Adeyemi", "Barnes", "Cole", "Doherty", "Evans", "Farah", "Grant", "Hughes", "Ibe", "Jarvis", "Kane", "Lowe",
	"Mason", "Nolan", "Okafor", "Price", "Quinn", "Rowe", "Shah", "Turner", "Vance", "Walsh", "Yates", "Bello", "Clarke"]
const NOTES := ["quick feet, light hands", "heavy right, slow reset", "busy jab, thin chin", "strong, short arms",
	"sharp eye, little power", "tough, wide shots", "fast starter, fades late", "good engine, leaks the left hook"]
const TRIES := 40


static func make(n: int, seed: int, templates: Array, level: float) -> Dictionary:
	var best: Dictionary = {}
	var best_gap := 999.0
	for t in TRIES:
		var p := _draw(n, seed + t * 7919, templates)
		var gap := absf(PC.estimate(PC.ranges(_fresh(p), p)) - level)
		if gap <= PC.SCOUT_BAND:
			return p
		if gap < best_gap:
			best_gap = gap
			best = p
	return best


static func _fresh(p: Dictionary) -> Dictionary:
	var k := K.fresh(absi(hash(str(p["id"]))))
	k["ceil_hw"] = PC.CEIL_HW
	return k


static func _draw(n: int, seed: int, templates: Array) -> Dictionary:
	var r := RandomNumberGenerator.new()
	r.seed = seed
	var tp: Dictionary = (templates[r.randi() % templates.size()] as Dictionary).duplicate(true)
	var female := str(tp.get("sex", "f")) == "f"
	var first: String = (FIRST_F if female else FIRST_M)[r.randi() % (FIRST_F if female else FIRST_M).size()]
	var last: String = LAST[r.randi() % LAST.size()]
	var stats := {}
	for k in (tp["stats"] as Dictionary).keys():
		stats[k] = snappedf(clampf(float(tp["stats"][k]) + r.randf_range(-7.0, 7.0), 40.0, 80.0), 0.5)
	var pers := {}
	for k in (tp.get("personality", {}) as Dictionary).keys():
		pers[k] = clampf(float(tp["personality"][k]) + r.randf_range(-25.0, 25.0), 10.0, 95.0)
	var w := r.randi_range(0, 6)
	return {"id": "scout_%d" % n, "name": "%s %s" % [first, last], "first": first, "sex": tp.get("sex", "f"),
		"age": r.randi_range(18, 25), "wc": tp["wc"], "div": tp["div"], "weight": tp["weight"], "stance": "southpaw" if r.randf() < 0.25 else "orthodox",
		"style": tp["style"], "w": w, "l": r.randi_range(0, maxi(1, w - 1)), "pot": clampi(int(tp["pot"]) + r.randi_range(-10, 6), 66, 92),
		"note": NOTES[r.randi() % NOTES.size()], "stats": stats, "personality": pers, "scouted": true}
