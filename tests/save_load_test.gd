extends SceneTree
## Save and load, and the region. A career saved mid-camp loads back field for field (types too), and the loaded copy and
## the original, run on for 30 more days, end identical (the game is deterministic, so a load is a true resume).
## The region: club shows every other Saturday move the rivals' records; rankings put her in from 4 wins.
## Population: Lucy Jackson (Data.lucy, 3-1) and the eleven rivals of Data (OPPONENTS + MISMATCH + RIVALS).

const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Region := preload("res://scripts/state/Region.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")
const Data := preload("res://scripts/state/Data.gd")

const PATH := "user://save_load_test.save"

var checks := 0
var failures := 0


func _initialize() -> void:
	_test_round_trip()
	_test_missing_and_bad()
	_test_region()
	_test_v1_migration()
	DirAccess.remove_absolute(ProjectSettings.globalize_path(PATH))
	print("SAVE_LOAD checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		print("  FAIL: %s" % label)


func _career_mid_camp() -> Career:
	var c := Career.quick_start("Save Test Gym", "London")
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	Sim.hire(c, "reid")
	while (c.fighter()["offers"] as Array).is_empty():
		Sim.step_day(c)
	Bouts.accept(c, str(c.fighter()["offers"][0]["id"]))
	Bouts.start_camp(c, c.fighter(), "conditioning", 2, true)
	for i in 5:
		Sim.step_day(c)
	return c


func _test_round_trip() -> void:
	var c := _career_mid_camp()
	_check(SaveGame.save(c, PATH), "the save writes")
	_check(SaveGame.exists(PATH), "the slot exists")
	var l := SaveGame.load_career(PATH)
	_check(l != null, "the save loads")
	if l == null:
		return
	var a := SaveGame.to_dict(c)["props"] as Dictionary
	var b := SaveGame.to_dict(l)["props"] as Dictionary
	_check(a.keys().size() == b.keys().size() and a.keys().size() > 20, "every career field came back (%d)" % b.keys().size())
	for k in a.keys():
		_check(var_to_str(a[k]) == var_to_str(b[k]), "field %s matches" % k)
	_check(typeof(l.fighter()["w"]) == TYPE_INT and typeof(l.fighter()["weight"]) == TYPE_FLOAT, "an int stays an int, a float a float")
	_check(not (l.fighter()["camp"] as Dictionary).is_empty() and not (l.fighter()["bout"] as Dictionary).is_empty() and l.day == c.day,
		"mid-camp on day %d: her bout and her camp are there" % l.day)
	_check(SaveGame.summary(PATH) == "Save Test Gym, %s" % Clock.fmt_long(c.day), "the title shows: %s" % SaveGame.summary(PATH))
	# Run both 30 days on: the loaded career must play out exactly like the original.
	for i in 30:
		Sim.step_day(c)
		Sim.step_day(l)
		if Bouts.weigh_in_today(c, c.fighter()):
			Bouts.weigh(c, c.fighter())
			Bouts.weigh(l, l.fighter())
	_check(var_to_str(SaveGame.to_dict(c)["props"]) == var_to_str(SaveGame.to_dict(l)["props"]),
		"30 days later the loaded career and the original are identical (day %d, cash %d / %d)" % [c.day, c.cash, l.cash])
	# Loading into a newer layout: a missing field takes its default.
	var old := SaveGame.to_dict(c)
	(old["props"] as Dictionary).erase("ledger")
	var from_old := SaveGame.from_dict(old)
	_check(from_old.ledger.is_empty() and from_old.day == c.day, "an older save without a field still loads")
	# Fight model step 1: her profile and stored morale survive a save; a save from before profiles gets one on load.
	c.fighter()["morale"] = 41.5
	c.fighter()["mood_reason"] = "Lost to Maria Ortega"
	SaveGame.save(c, PATH)
	var lp := SaveGame.load_career(PATH)
	_check(float(lp.fighter()["morale"]) == 41.5 and str(lp.fighter()["mood_reason"]) == "Lost to Maria Ortega"
		and (lp.fighter()["personality"] as Dictionary).size() == 6 and (lp.fighter()["habits"] as Array).size() == 2,
		"morale, its reason, 6 traits and 2 habits come back")
	var pre := SaveGame.to_dict(c)
	for key in ["morale", "mood_reason", "personality", "habits", "footwork", "style_dials"]:
		((pre["props"] as Dictionary)["fighters"][0] as Dictionary).erase(key)
	var from_pre := SaveGame.from_dict(pre)
	_check(float(from_pre.fighter()["morale"]) == 60.0 and from_pre.fighter().has("footwork"),
		"a save from before profiles loads with a fresh profile (morale 60)")


func _test_missing_and_bad() -> void:
	_check(SaveGame.load_career("user://no_such_save.save") == null, "no save: load returns nothing")
	_check(SaveGame.summary("user://no_such_save.save") == "", "no save: the title says no save yet")
	var f := FileAccess.open(PATH, FileAccess.WRITE)
	f.store_var("not a career")
	f.close()
	_check(SaveGame.load_career(PATH) == null, "a damaged save is refused, not loaded half-way")


func _test_region() -> void:
	_check(Region.is_show_day(12) and Region.is_show_day(26) and not Region.is_show_day(19), "shows on day 12, 26, ... (every other Saturday)")
	_check(posmod(12, 7) == 5, "show days are Saturdays")
	_check(Region.next_shows(12, 2) == [26, 40], "after day 12 the next shows are 26 and 40")
	var c := Career.quick_start()
	var lw := func(): return c.rivals.filter(func(r): return r["div"] == "wlw")
	_check(lw.call().size() == 11 and c.rivals.size() == 11 + Data.DIVISION_RIVALS.size(),
		"eleven lightweight rivals, %d in all four divisions" % c.rivals.size())
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	var before := 0
	for r in lw.call():
		before += int(r["w"]) + int(r["l"])
	for i in 28:
		Sim.step_day(c)
	var after := 0
	for r in lw.call():
		after += int(r["w"]) + int(r["l"])
	_check(after - before == 2 * 2 * Region.SHOW_BOUTS, "two shows by day 28, two lightweight bouts each: %d results" % ((after - before) / 2))
	_check(c.news.any(func(x): return str(x["t"]).contains("show") or str(x["t"]).contains("beat") or str(x["t"]).contains("stopped")),
		"the shows in her division made the news")
	var rows := Region.rankings(c, "wlw")
	_check(rows.size() == 11 and not rows.any(func(x): return bool(x["ours"])), "3-1: eleven ranked lightweights, Lucy not yet")
	_check(Region.rankings(c, "wfw").size() == 5, "the featherweights have their own table")
	var f := c.fighter()
	_check(Region.our_rank(c, f) == 0, "3-1: Lucy is not ranked yet")
	f["w"] = 4
	Region.update_rank(c, f)
	_check(int(f["rank"]) > 0 and str(c.news[0]["t"]).contains("Lucy Jackson"), "4-1: she enters at %d and the news says so" % int(f["rank"]))
	var top := rows[0] as Dictionary
	_check(int(top["w"]) - int(top["l"]) >= int(rows[rows.size() - 1]["w"]) - int(rows[rows.size() - 1]["l"]), "best net record ranks first")


## A week-3 (version 1) save: one fighter, her bout and camp on the career. It must load into the week-4 layout.
func _test_v1_migration() -> void:
	var c := _career_mid_camp()
	var d := SaveGame.to_dict(c)
	var props: Dictionary = d["props"]
	var f: Dictionary = props["fighters"][0]
	for k in SaveGame.V1_FIGHTER_FIELDS:
		props[k] = f[k]
	for k in ["div", "offers", "bout", "camp", "goal_talk", "next_offer_day", "opp_index", "rank", "week_start", "moves", "learning", "pro"]:
		f.erase(k)
	props.erase("prospects")
	var lw: Array = []
	for r in props["rivals"]:
		if r["div"] == "wlw":
			r.erase("div")
			lw.append(r)
	props["rivals"] = lw
	d["version"] = 1
	var l := SaveGame.from_dict(d)
	var lf := l.fighter()
	_check(not (lf["bout"] as Dictionary).is_empty() and not (lf["camp"] as Dictionary).is_empty(), "v1 save: her bout and camp moved onto her")
	_check((lf["moves"] as Dictionary).size() == Data.MOVES.size() and str(lf["div"]) == "wlw", "v1 save: she gets moves and her division")
	_check(l.rivals.size() == 11 + Data.DIVISION_RIVALS.size() and l.prospects.size() == Data.PROSPECTS.size(), "v1 save: the new divisions and prospects arrive")
	_check(int(lf["bout"]["day"]) == int(c.fighter()["bout"]["day"]), "v1 save: the bout is on the same day")
	var d2 := SaveGame.to_dict(c)
	d2["props"]["rivals"] = (d2["props"]["rivals"] as Array).filter(func(r): return str(r["name"]) != "Holly Price")
	var l2 := SaveGame.from_dict(d2)
	var holly: Array = l2.rivals.filter(func(r): return str(r["name"]) == "Holly Price")
	_check(holly.size() == 1 and str(holly[0]["div"]) == "wlw" and l2.rivals.size() == c.rivals.size(),
		"a save from before a rival joined the region gets her, once")
