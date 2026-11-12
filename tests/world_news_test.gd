extends SceneTree
## WORLD_NEWS (R85NEWS1): the year's end becomes news lines - who retired, who arrived, who was crowned.
## RED ON MAIN before S443: WorldNews.gd did not exist, so the preload failed. Rewritten at the S443 collect
## (ops/research/R85NEWS1_REVIEW_S443.md): every expected line is written out here from the boxers built here; the last block
## runs the real WorldGen.generate + WorldSim.year_end and checks every retiree, arrival and crowned entry is in the news.

const WN := preload("res://scripts/world/WorldNews.gd")
const WG := preload("res://scripts/world/WorldGen.gd")
const WS := preload("res://scripts/world/WorldSim.gd")

var failures := 0
var _pronoun := RegEx.new()


func _init() -> void:
	_pronoun.compile("\\b(she|he|her|his|him|they|them|their)\\b")
	var divisions := _make_divisions()
	var before := WN.snapshot(divisions)
	_check_snapshot(before, divisions)
	var result := _year_end(divisions)
	var after := WN.snapshot(divisions)
	_check(not after.has(103) and not after.has(5) and after.has(201), "a snapshot holds nobody retired and every arrival")
	_check_lines(before, result, divisions)
	_check_follow_and_cap()
	_check_marks(result)
	_check_no_mutation(before, result, divisions)
	_check(WN.lines(WN.snapshot(_make_divisions()), {"retired": [], "arrived": [], "crowned": []}, _make_divisions(), []).is_empty(),
		"an empty result gives no lines")
	_check(WN.level_of("IBF_national") == "national" and WN.level_of("") == "" and WN.level_of("WBC_x_world") == "world", "level_of")
	_check_real_world()
	print("WORLD_NEWS failures=%d" % failures)
	quit(failures)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("FAIL %s" % label)


func _bx(id: int, name: String, age: int, div: String, rating: float, w: int, l: int, rank: int, belt: String, club: String) -> Dictionary:
	return {"id": id, "name": name, "first": name.get_slice(" ", 0), "last": name.get_slice(" ", 1), "sex": "women" if div.begins_with("w") else "men",
		"club": club, "region": "North", "age": age, "div": div, "rating": rating, "w": w, "l": l, "d": 0, "ko": w / 3,
		"retired": false, "rank": rank, "belt": belt}


func _make_divisions() -> Dictionary:
	return {
		"w_lw": {"info": {"id": "w_lw", "name": "Women's Lightweight", "sex": "women", "weight_class": "lightweight"},
			"belt_orgs": {"area": "BBBofE", "national": "ABC", "continental": "WBC", "world": "IBF"}, "boxers": [
			_bx(1, "Ama Boateng", 28, "w_lw", 78.0, 15, 2, 1, "IBF_world", "Hull ABC"),
			_bx(2, "Leah Torres", 25, "w_lw", 74.0, 12, 3, 2, "WBC_continental", "Sheffield Gym"),
			_bx(3, "Mia Chen", 33, "w_lw", 70.0, 9, 2, 3, "", "London Boxing"),
			_bx(4, "Zara Khan", 30, "w_lw", 66.0, 11, 5, 4, "", "Manchester ABC"),
			_bx(5, "Eva Novak", 35, "w_lw", 62.0, 18, 8, 5, "", "Birmingham BC"),
			_bx(6, "Nina Petrov", 22, "w_lw", 58.0, 6, 2, 6, "", "Leeds ABC"),
			_bx(7, "Rosa Diaz", 36, "w_lw", 54.0, 8, 6, 0, "", "Liverpool BC"),
			_bx(8, "Isla Murray", 34, "w_lw", 50.0, 5, 4, 0, "", "Glasgow ABC")]},
		"m_mw": {"info": {"id": "m_mw", "name": "Men's Middleweight", "sex": "men", "weight_class": "middleweight"},
			"belt_orgs": {"area": "BBBofE", "national": "IBF", "continental": "WBC", "world": "WBA"}, "boxers": [
			_bx(101, "Jack Wilson", 30, "m_mw", 80.0, 20, 1, 1, "WBA_world", "Hull ABC"),
			_bx(102, "Tom Harris", 27, "m_mw", 76.0, 16, 3, 2, "WBC_continental", "Leeds ABC"),
			_bx(103, "Dan Brown", 33, "m_mw", 72.0, 22, 6, 3, "IBF_national", "Chicago BC"),
			_bx(104, "Sam Green", 26, "m_mw", 68.0, 10, 2, 4, "", "Houston ABC"),
			_bx(105, "Mike Jones", 38, "m_mw", 64.0, 28, 12, 5, "", "Boston Gym"),
			_bx(106, "Alex White", 24, "m_mw", 60.0, 7, 3, 6, "", "Seattle BC"),
			_bx(107, "Chris Black", 31, "m_mw", 56.0, 14, 9, 0, "", "Denver Gym"),
			_bx(108, "Pat Gray", 29, "m_mw", 52.0, 9, 7, 0, "", "Miami ABC")]},
	}


func _find(divisions: Dictionary, id: int) -> Dictionary:
	for d in divisions:
		for b in divisions[d]["boxers"]:
			if int(b["id"]) == id:
				return b
	return {}


## What year_end does to the dictionaries: age, retire (belt cleared), arrivals appended, a vacant belt filled.
func _year_end(divisions: Dictionary) -> Dictionary:
	var result := {"retired": [], "arrived": [], "crowned": []}
	for id in [103, 3, 5, 7, 8]:
		var b := _find(divisions, id)
		b["age"] = int(b["age"]) + 1
		b["retired"] = true
		b["belt"] = ""
		b["rank"] = 0
		result["retired"].append(b)
	_find(divisions, 104)["belt"] = "IBF_national"
	result["crowned"].append({"level": "national", "name": "Sam Green", "id": 104})
	for a in [_bx(201, "Priya Shah", 20, "w_lw", 56.0, 0, 0, 0, "", "Nottingham ABC"),
			_bx(202, "Yuki Tanaka", 21, "w_lw", 54.0, 0, 0, 0, "", "Cardiff ABC"),
			_bx(203, "Aisha Okafor", 19, "w_lw", 58.0, 0, 0, 0, "", "Newcastle Gym")]:
		divisions["w_lw"]["boxers"].append(a)
		result["arrived"].append(a)
	return result


func _check_snapshot(before: Dictionary, divisions: Dictionary) -> void:
	_check(before.size() == 16, "snapshot holds all 16 boxers: %d" % before.size())
	for d in divisions:
		for b in divisions[d]["boxers"]:
			var s: Dictionary = before.get(int(b["id"]), {})
			_check(int(s.get("rank", -1)) == int(b["rank"]) and str(s.get("belt", "?")) == str(b["belt"]) and str(s.get("div", "")) == d,
				"snapshot keeps rank, belt and division of %s" % b["name"])


func _texts(ls: Array) -> Array:
	return ls.map(func(l): return str(l["t"]))


func _check_lines(before: Dictionary, result: Dictionary, divisions: Dictionary) -> void:
	var ls := WN.lines(before, result, divisions, ["w_lw", "m_mw"])
	var want := [
		"Mia Chen retires at 34 after 9-2, ranked 3 at Women's Lightweight.",
		"Eva Novak retires at 36 after 18-8, ranked 5 at Women's Lightweight.",
		"2 more boxers retired in Women's Lightweight.",
		"New face in Women's Lightweight: Aisha Okafor, 19, from Newcastle Gym. (3 new this year)",
		"Sam Green wins the vacant national title (Men's Middleweight).",
		"Dan Brown retires at 34, 22-6, the national champion of Men's Middleweight.",
	]
	_check(_texts(ls) == want, "the lines, in order:\n  got  %s\n  want %s" % [str(_texts(ls)), str(want)])
	var kinds := ls.map(func(l): return str(l["kind"]))
	_check(kinds == ["retired_ranked", "retired_ranked", "retired_more", "arrived", "crowned", "retired_champ"], "kinds: %s" % str(kinds))
	_check(int(ls[5]["id"]) == 103 and str(ls[5]["div"]) == "m_mw" and int(ls[3]["id"]) == 203, "ids and divisions on the lines")
	for l in ls:
		_check(str(l["t"]).length() < 110 and _pronoun.search(str(l["t"]).to_lower()) == null, "short, no pronoun: %s" % l["t"])
	# One retiree in a division reads "1 more boxer".
	var one := {"retired": [_find(divisions, 108)], "arrived": [], "crowned": []}
	var b2 := before.duplicate(true)
	b2[108] = {"name": "Pat Gray", "div": "m_mw", "rank": 0, "belt": "", "w": 9, "l": 7, "age": 29}
	_check(_texts(WN.lines(b2, one, divisions, [])) == ["1 more boxer retired in Men's Middleweight."], "one more boxer")
	# A long name falls back to the weight class.
	var long := {"retired": [], "arrived": [], "crowned": [{"level": "continental", "id": 1,
		"name": "Anastasia Wilhelmina Konstantinopoulou-Featherstonehaugh"}]}
	var t: String = str(WN.lines(before, long, divisions, [])[0]["t"])
	_check(t == "Anastasia Wilhelmina Konstantinopoulou-Featherstonehaugh wins the vacant continental title (Lightweight).",
		"long line shortened to the weight class: %s (%d)" % [t, t.length()])


## Four divisions: the followed one first; the other three can give 15 lines, 6 kept, every crowned/champion line among them.
func _check_follow_and_cap() -> void:
	var divs := {}
	var before := {}
	var result := {"retired": [], "arrived": [], "crowned": []}
	var n := 0
	for d in ["w_fw", "m_fw", "m_lw", "w_mw"]:
		var boxers: Array = []
		for k in 6:
			n += 1
			var b := _bx(n, "Boxer%d Name%d" % [n, n * 7], 20 + n % 17, d, 50.0 + n, n, n % 5, k + 1, "IBF_area" if k == 0 else "", "Club %d" % n)
			boxers.append(b)
		divs[d] = {"info": {"id": d, "name": "Division %s" % d, "weight_class": d}, "boxers": boxers}
	for d in divs:
		before.merge(WN.snapshot({d: divs[d]}))
	for d in divs:
		var bs: Array = divs[d]["boxers"]
		result["retired"].append_array([bs[0], bs[2], bs[5]])   # the champion, ranked 3, ranked 6
		result["crowned"].append({"level": "area", "name": bs[1]["name"], "id": int(bs[1]["id"])})
		result["arrived"].append(_bx(500 + bs.size() + n, "New%s Face" % d, 18, d, 60.0, 0, 0, 0, "", "Club X"))
		n += 1
	# per division: crowned, champion, ranked 3, ranked 6, arrived = 5 lines; three other divisions = 15 possible.
	var ls := WN.lines(before, result, divs, ["m_lw"])
	var other := ls.filter(func(l): return str(l["div"]) != "m_lw")
	var first_other := ls.find(other[0]) if not other.is_empty() else -1
	_check(ls.slice(0, 5).all(func(l): return str(l["div"]) == "m_lw"), "the followed division's 5 lines come first")
	_check(first_other == 5 and other.size() == 6, "6 other lines kept: %d" % other.size())
	_check(other.all(func(l): return str(l["kind"]) == "crowned" or str(l["kind"]) == "retired_champ"),
		"the 6 kept are the 3 crowned and 3 champion lines: %s" % str(other.map(func(l): return l["kind"])))


func _check_marks(result: Dictionary) -> void:
	var day := 1000
	var m := WN.marks(result, day)
	_check(WN.mark_of(m, 201, day + 364) == "new face" and WN.mark_of(m, 201, day + 365) == "", "new face for a year")
	_check(WN.mark_of(m, 103, day + 10000) == "retired" and WN.mark_of(m, 99999, day) == "", "retired for ever, unknown ''")


func _check_no_mutation(before: Dictionary, result: Dictionary, divisions: Dictionary) -> void:
	var b := var_to_str(before)
	var r := var_to_str(result)
	var d := var_to_str(divisions)
	WN.lines(before, result, divisions, ["m_mw"])
	WN.marks(result, 5)
	_check(var_to_str(before) == b and var_to_str(result) == r and var_to_str(divisions) == d, "lines() and marks() change nothing")


## The real world: ten year ends; every crowned, every named retiree and every arrival division is in the news, the
## unnamed retirees add up to the "more" counts.
func _check_real_world() -> void:
	var world := WG.generate(4242)
	var divs: Dictionary = world["divisions"]
	var rng := RandomNumberGenerator.new()
	rng.seed = 4242
	var seen := {"retired": 0, "crowned": 0, "arrived": 0}
	for year in 10:
		var before := WN.snapshot(divs)
		var res: Dictionary = WS.year_end(divs, rng)
		var ls := WN.lines(before, res, divs, divs.keys())
		var ids := {}
		var more := 0
		for l in ls:
			ids[int(l["id"])] = str(l["kind"])
			_check(str(l["t"]).length() < 110 and _pronoun.search(str(l["t"]).to_lower()) == null, "real line: %s" % l["t"])
			if str(l["kind"]) == "retired_more":
				more += int(str(l["t"]).get_slice(" ", 0))
		var unnamed := 0
		for r in res["retired"]:
			var was: Dictionary = before.get(int(r["id"]), {})
			if str(was.get("belt", "")) != "":
				_check(ids.get(int(r["id"]), "") == "retired_champ", "year %d: champion %s has a line" % [year, r["name"]])
			elif int(was.get("rank", 0)) >= 1 and int(was.get("rank", 0)) <= 10:
				_check(ids.get(int(r["id"]), "") == "retired_ranked", "year %d: ranked %s has a line" % [year, r["name"]])
			else:
				unnamed += 1
		_check(more == unnamed, "year %d: the 'more' counts add up: %d vs %d" % [year, more, unnamed])
		for c in res["crowned"]:
			_check(ids.get(int(c["id"]), "") == "crowned" or ls.any(func(l): return str(l["kind"]) == "crowned" and str(l["t"]).begins_with(str(c["name"]))),
				"year %d: %s crowned has a line" % [year, c["name"]])
		var arr_divs := {}
		for a in res["arrived"]:
			arr_divs[str(a["div"])] = true
		_check(ls.filter(func(l): return str(l["kind"]) == "arrived").size() == arr_divs.size(), "year %d: one arrival line a division" % year)
		seen["retired"] += res["retired"].size()
		seen["crowned"] += res["crowned"].size()
		seen["arrived"] += res["arrived"].size()
	_check(seen["retired"] > 0 and seen["arrived"] > 0, "the real world retired and brought in boxers: %s" % str(seen))
	print("WORLD_NEWS real world over 10 years: %s" % str(seen))
