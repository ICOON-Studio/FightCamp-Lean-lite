extends SceneTree
## S439 DAMAGESHOW1: a bout the ring did not show to the last bell still leaves its marks on the result page.
## Path: BoutNight plays the bout on the corner's calls (headless: no ring, so no live map) -> _finish -> AfterFight.book
## -> BoutMarks.build (the settled rounds through ExchangeBeats, the ring's own path) -> the DAMAGE tile.
## Population: Lucy Jackson (orthodox out-boxer, step_back / pivot_out plan) vs Priya Nair (orthodox counter-puncher),
## 3-round amateur, 12 bout days. They differ in stats, technique and plan.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const BoutMarks := preload("res://scripts/fight3d/BoutMarks.gd")
const FightStats := preload("res://scripts/rules/FightStats.gd")

var _fails := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
	print("%s %s" % ["ok  " if ok else "FAIL", what])


func _initialize() -> void:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), 1000))
	var base: Dictionary = (c.fighter() as Dictionary).duplicate(true)
	base["arrows"] = [{"move": "step_back"}, {"move": "pivot_out"}]
	var opp: Dictionary = (Data.OPPONENTS[1] as Dictionary).duplicate(true)
	var marked := 0
	var agree := 0
	var lied := 0
	var bouts := 12
	for i in bouts:
		c.day = 40 + i * 7
		c.fighters[0] = base.duplicate(true)
		var f: Dictionary = c.fighter()
		f["bout"] = {"opp": opp.duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 3, "rounds": 3}
		var m := {"fid": str(f["id"]), "step": "tape", "round": 0, "rounds": [], "total": 3, "type": "fight"}
		Bouts.fight_step(c, f, m, "start")
		Bouts.fight_step(c, f, m, "rest")
		var map: Dictionary = m.get("body_map", {})
		if i == 0:
			_check(str(m.get("step", "")) == "result" and m.has("aftermath"), "the bout reaches the result with its tiles (step %s)" % m.get("step", ""))
			_check(not map.is_empty() and map.has("a") and map.has("b"), "an unwatched bout has a body map on the result page")
			var again := BoutMarks.build(c, f, m)
			_check(str(again) == str(map), "the map is the same on a second build (no hidden roll)")
		var tile: Dictionary = (m["aftermath"] as Array)[0]
		var sore := 0
		var low := 100.0
		for p in BodyMap.PLACES:
			low = minf(low, BodyMap.value(map, "a", p))
			if BodyMap.band(BodyMap.value(map, "a", p)) != "fine":
				sore += 1
		if low < 100.0:
			marked += 1
		if int(tile.get("sore", -1)) == sore:
			agree += 1
		if sore > 0 and str(tile["big"]) == "Nothing lasting":
			lied += 1
		var took := int(FightStats.of(m["rounds"])["landed"][1])
		print("BOUT day %d %s took %d lowest %.0f sore %d tile '%s' | %s" % [c.day, m.get("outcome", ""), took, low, sore, tile["big"], tile["small"]])
	_check(marked == bouts, "every bout that was boxed marks her somewhere (%d of %d)" % [marked, bouts])
	_check(agree == bouts, "the tile counts the sore places the map has (%d of %d)" % [agree, bouts])
	_check(lied == 0, "never 'Nothing lasting' with a sore place (%d)" % lied)
	# The ring's own map is kept when it saw every round.
	var m2 := {"rounds": [{}, {}, {}], "body_map": BodyMap.fresh(), "body_bells": 3}
	_check(BoutMarks.seen_all(m2), "a map with a bell for every round is the ring's whole fight")
	m2["body_bells"] = 1
	_check(not BoutMarks.seen_all(m2) and not BoutMarks.seen_all({"rounds": [{}]}), "one bell of three, or no map: rebuilt from the rounds")
	print("BOUT_MARKS failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)
