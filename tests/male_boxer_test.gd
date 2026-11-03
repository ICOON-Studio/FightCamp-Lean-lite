extends SceneTree
## S371 MALE1 (operator S370: every playthrough = a male boxer + Ana): men's boxing in the career. Population: the
## quick-start career (Lucy at reception, Ana on the mat) and Danny Osei, the scouting pool's male lightweight
## (Data.PROSPECTS, div mlw), signed after his trial; an old save made of women only.

const Data := preload("res://scripts/state/Data.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Region := preload("res://scripts/state/Region.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")

var failures := 0


func _initialize() -> void:
	_divisions()
	_career_has_men()
	_signed_man_books_men()
	_rankings_by_sex()
	_old_save()
	print("MALE_BOXER failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _rival(name: String) -> Dictionary:
	for r in Data.DIVISION_RIVALS:
		if str(r["name"]) == name:
			return r
	return {}


## Four men's divisions on England Boxing men's limits; every name they offer is a man of that division, and every
## weakness reads as one the opponent file can answer.
func _divisions() -> void:
	var men: Array = Data.divisions_for("m")
	_check(men.size() == 4 and Data.divisions_for("f").size() == 4, "four men's and four women's divisions (%d / %d)" % [men.size(), Data.divisions_for("f").size()])
	for d in men:
		var div: Dictionary = Data.DIVISIONS[d]
		_check([57.5, 60.0, 65.0, 70.0, 75.0].has(float(div["limit"])), "%s limit %.1f kg is a men's class" % [d, float(div["limit"])])
		var names: Array = (div["opponents"] as Array) + [div["mismatch"]]
		var ok := true
		for n in names:
			var r := _rival(str(n))
			ok = ok and not r.is_empty() and str(r["div"]) == d
			ok = ok and OppFile._answer(str(r.get("weak", "")), OppFile.WEAKNESS_ANSWERS)[0] != ""
		_check(ok, "%s: 3 opponents + the mismatch are its men, each weakness answerable" % d)
		_check(float(_rival(str(div["mismatch"])).get("rating", 0.0)) > float(_rival(str(div["opponents"][2])).get("rating", 99.0)), "%s mismatch outrates the even opponents" % d)


func _career_has_men() -> void:
	var c := Career.quick_start()
	var men := c.rivals.filter(func(r): return str(Data.DIVISIONS[str(r["div"])]["sex"]) == "m")
	_check(men.size() == 16, "the region holds 16 men (%d)" % men.size())
	_check(men.all(func(r): return (r.get("bouts", []) as Array).size() == int(r["w"]) + int(r["l"])), "each man has a past that matches his record")
	var ids: Array = c.prospects.map(func(p): return str(p["id"]))
	_check(ids.has("danny") and ids.has("josh"), "scouting can bring in Danny and Josh")
	_check(Data.sex_of(c.applicant) == "f" and c.grapplers.size() == 1, "Lucy at reception and Ana on the mat as before")


func _signed_man_books_men() -> void:
	var c := Career.quick_start()
	var p := Roster.prospect(c, "danny")
	p["state"] = "invited"
	var f := Roster.sign_prospect(c, "danny", ["signature"])
	_check(not f.is_empty() and str(f.get("sex", "")) == "m" and str(f["div"]) == "mlw", "Danny signs as a man in the men's lightweights")
	_check(float(f["limit"]) == 60.0, "his limit is 60 kg (%.1f)" % float(f["limit"]))
	c.day = int(f["next_offer_day"])
	Bouts.day_events(c)
	var offers: Array = f["offers"]
	var div: Dictionary = Data.DIVISIONS["mlw"]
	_check(offers.size() == 2, "two offers arrive (%d)" % offers.size())
	if offers.size() == 2:
		var a := str(offers[0]["opp"]["name"])
		var b := str(offers[1]["opp"]["name"])
		_check((div["opponents"] as Array).has(a), "the even offer is a men's lightweight (%s)" % a)
		_check(b == str(div["mismatch"]), "the mismatch is the men's lightweight mismatch (%s)" % b)


func _rankings_by_sex() -> void:
	var c := Career.quick_start()
	var rows: Array = Region.rankings(c, "mlw")
	var names: Array = rows.map(func(r): return str(r["name"]))
	_check(rows.size() == 4 and names.has("Arjun Patel") and not names.has("Lucy Jackson"), "the men's lightweight table is men only (%d)" % rows.size())
	var w := Region.rankings(c, "wlw").map(func(r): return str(r["name"]))
	_check(not w.has("Arjun Patel") and not w.has("Danny Osei"), "no man in the women's lightweights")


## A save from before S371: women only, no "sex" on the fighter, no men in the region, three prospects.
func _old_save() -> void:
	var c := Career.quick_start()
	var lucy := Data.fighter_state(Data.lucy(), c.day)
	lucy.erase("sex")
	c.fighters.append(lucy)
	c.rivals = c.rivals.filter(func(r): return str(Data.DIVISIONS[str(r["div"])]["sex"]) == "f")
	c.prospects = c.prospects.filter(func(p): return str(p.get("sex", "f")) == "f")
	var back := SaveGame.from_dict(SaveGame.to_dict(c))
	_check(Data.sex_of(back.fighters[0]) == "f", "an old save's fighter reads as a woman")
	var men := back.rivals.filter(func(r): return str(Data.DIVISIONS[str(r["div"])]["sex"]) == "m")
	_check(men.size() == 16 and back.prospects.size() == Data.PROSPECTS.size(), "the men and the male prospects arrive on load (%d, %d)" % [men.size(), back.prospects.size()])
	var again := SaveGame.from_dict(SaveGame.to_dict(back))
	_check(again.rivals.size() == back.rivals.size(), "a second load adds nobody twice")
