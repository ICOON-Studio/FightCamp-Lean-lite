extends SceneTree
## S535 OFFERTAPE1 (owner C449 on the tale of the tape: "maybe add streak/latest results?"): the form on the tape.
## TapeRows adds a "Last 5" row (newest first: W / L / D, a stoppage marked W(KO) / L(KO)) and a "Streak" row in words.
## Our boxer's five come from Career.results and, behind those, the bouts the boxer brought (PriorBouts, the History tab's
## list); an amateur rival's from the bout-by-bout record the game keeps (RivalPast); a pro's from the small "form" list
## written where a pro record changes (Matchmaking.apply_result). Nothing is invented: a record with no bouts on tape
## shows the record only and the row reads "?", "not on tape".

const TapeRows := preload("res://scripts/rules/TapeRows.gd")
const TapeForm := preload("res://scripts/state/TapeForm.gd")
const Matchmaking := preload("res://scripts/rules/Matchmaking.gd")
const RivalPast := preload("res://scripts/rules/RivalPast.gd")
const TapeVersus := preload("res://scripts/ui/TapeVersus.gd")

var failures := 0


func _initialize() -> void:
	_own()
	_brought()
	_rival()
	_pro()
	_unknown()
	_screens()
	print("TAPE_FORM failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _fighter() -> Dictionary:
	return {"id": "lou", "name": "Lou Blake", "first": "Lou", "w": 4, "l": 1, "age": 24, "weight": 59.4, "height": 172.0,
		"reach": 174.0, "stance": "orthodox", "style": "Out-boxer", "limit": 60.0, "joined": 0}


## Our boxer's last 5 from the results, newest first, another boxer's bouts left out.
func _own() -> void:
	var c := Career.new()
	var f := _fighter()
	c.fighters = [f]
	c.results = [
		{"d": 90, "fid": "lou", "win": true, "outcome": "win", "cards": "30-27, 29-28, 30-27"},
		{"d": 80, "fid": "ned", "win": false, "outcome": "loss", "cards": "KO round 1"},
		{"d": 70, "fid": "lou", "win": true, "outcome": "win", "cards": "TKO round 2"},
		{"d": 50, "fid": "lou", "win": false, "outcome": "loss", "cards": "28-29, 28-29, 29-28"},
		{"d": 30, "fid": "lou", "win": true, "outcome": "win", "cards": "30-27, 30-27, 30-27"},
		{"d": 10, "fid": "lou", "win": false, "outcome": "draw", "cards": "29-29, 29-29, 29-29"},
		{"d": 5, "fid": "lou", "win": true, "outcome": "win", "cards": "29-28, 29-28, 29-28"},
	]
	TapeForm.fill(c, f)
	_check(f.get("form", []) == ["W", "W(KO)", "L", "W", "D"], "our boxer's last 5 come from the results, newest first (%s)" % str(f.get("form", [])))
	var by := _by(TapeRows.rows(f, {"name": "Ned Cole", "w": 0, "l": 0}, 172.0))
	_check(by.has("Last 5") and str(by["Last 5"]["left"]) == "W W(KO) L W D", "the Last 5 row reads W W(KO) L W D (%s)" % str(by.get("Last 5", {}).get("left", "")))
	_check(by.has("Streak") and str(by["Streak"]["left"]) == "2 wins in a row", "the streak is in words: 2 wins in a row (%s)" % str(by.get("Streak", {}).get("left", "")))
	_check(str(by["Last 5"]["right"]) == "-" and str(by["Last 5"]["why"]) == "no bouts yet", "a boxer with no bouts shows a dash: no bouts yet")
	_check(TapeRows.streak(["L(KO)", "L", "W"]) == "2 losses in a row" and TapeRows.streak(["W", "L"]) == "won the last bout"
		and TapeRows.streak(["D", "W"]) == "drew the last bout" and TapeRows.streak(["L"]) == "lost the last bout" and TapeRows.streak([]) == "",
		"streak words: a run of two or more counts, one bout says which way it went")
	var labels: Array = TapeRows.rows(f, {"name": "Ned Cole", "w": 0, "l": 0}, 172.0).map(func(r): return str(r["label"]))
	_check(labels.slice(0, 3) == ["Record", "Last 5", "Streak"], "Last 5 and Streak sit under Record (%s)" % str(labels))


## Fewer than five club bouts: the bouts the boxer brought fill the rest, the History tab's own list (PriorBouts).
func _brought() -> void:
	var c := Career.new()
	var f := _fighter()   # 4-1, one club win: three wins and a loss came with the boxer
	c.fighters = [f]
	c.results = [{"d": 20, "fid": "lou", "win": true, "outcome": "win", "cards": "30-27, 30-27, 30-27"}]
	TapeForm.fill(c, f)
	var form: Array = f.get("form", [])
	_check(form.size() == 5 and str(form[0]) == "W", "one club bout and four brought bouts make the five (%s)" % str(form))
	var wins := form.filter(func(m): return str(m).begins_with("W")).size()
	var losses := form.filter(func(m): return str(m).begins_with("L")).size()
	_check(wins == 4 and losses == 1, "the five add up to the 4-1 record (%d wins, %d losses)" % [wins, losses])
	var again := _fighter()
	TapeForm.fill(c, again)
	_check(again.get("form", []) == form, "the same boxer reads the same five every time")
	var new_boy := {"id": "kid", "name": "Kid New", "w": 0, "l": 0}
	TapeForm.fill(c, new_boy)
	_check(new_boy.get("form", ["x"]) == [], "a boxer with no bouts has an empty form")


## An amateur rival: the bout-by-bout record the game already keeps (RivalPast), newest first.
func _rival() -> void:
	var r := {"name": "Priya Nair", "club": "Leicester ABC", "w": 2, "l": 1}
	RivalPast.add(r, 1, "Jess Hardy", "Repton ABC", true, "on points, 3-0")
	RivalPast.add(r, 2, "Mia Doyle", "Fitzroy Lodge ABC", false, "stopped in round 2")
	RivalPast.add(r, 3, "Lou Blake", "Anvil", false, "a draw", true)
	RivalPast.add(r, 4, "Tara Quinn", "Lynn AC", true, "TKO in round 3")
	var by := _by(TapeRows.rows(_fighter(), r, 172.0))
	_check(str(by["Last 5"]["right"]) == "W(KO) D L(KO) W", "a rival's Last 5 reads her kept record (%s)" % str(by["Last 5"]["right"]))
	_check(str(by["Streak"]["right"]) == "won the last bout" and str(by["Last 5"]["why"]) == "", "her streak in words, no missing-fact note")


## A pro bout: Matchmaking.apply_result writes both corners' form where their records move.
func _pro() -> void:
	var p := {"id": 1, "name": "Our Pro", "w": 3, "l": 0, "ko": 1, "rating": 62.0, "rank": 0, "fans": 2, "age": 24, "peak_age": 28, "log": []}
	var opp := {"id": 2, "name": "Dan Stone", "w": 8, "l": 2, "ko": 3, "rating": 60.0, "rank": 0, "fans": 2, "age": 27, "peak_age": 28}
	var boxers: Array = [p, opp]
	var by0 := _by(TapeRows.rows(_fighter(), opp, 172.0))
	_check(str(by0["Record"]["right"]) == "8-2" and str(by0["Last 5"]["right"]) == "?" and str(by0["Last 5"]["why"]) == "not on tape",
		"before the bout: the record only, Last 5 is ? - not on tape")
	Matchmaking.apply_result(p, opp, boxers, true, true)
	_check(opp.get("form", []) == ["L(KO)"] and p.get("form", []) == ["W(KO)"], "a stopped pro bout writes L(KO) and W(KO) (%s / %s)" % [str(opp.get("form")), str(p.get("form"))])
	Matchmaking.apply_result(p, opp, boxers, false, false)
	_check(opp.get("form", []) == ["W", "L(KO)"], "the next bout goes on top: W, L(KO) (%s)" % str(opp.get("form")))
	var by := _by(TapeRows.rows(_fighter(), opp, 172.0))
	_check(str(by["Last 5"]["right"]) == "W L(KO)" and str(by["Streak"]["right"]) == "won the last bout", "the tape shows the opponent's form after the pro bouts (%s)" % str(by["Last 5"]["right"]))
	for i in 7:
		TapeRows.push_form(opp, true, false)
	_check((opp["form"] as Array).size() == TapeRows.FORM_KEEP and TapeRows.streak(opp["form"]) == "5 wins in a row", "the list keeps five")
	TapeRows.push_form(opp, false, false, true)
	_check(str(opp["form"][0]) == "D", "a draw is a D")


## Nothing known: the record only. An old save's boxer (no form key, no kept bouts) loads and reads the same way.
func _unknown() -> void:
	var f := _fighter()   # no form filled: 4-1 with nothing on tape
	var old := {"name": "Old Save", "w": 12, "l": 3, "age": 30, "stance": "southpaw", "style": "Slugger", "bouts": 15}   # "bouts" as a count, not a list
	var rows: Array = TapeRows.rows(f, old, 172.0)
	var by := _by(rows)
	_check(str(by["Record"]["left"]) == "4-1" and str(by["Record"]["right"]) == "12-3", "the records still show")
	_check(str(by["Last 5"]["left"]) == "?" and str(by["Last 5"]["right"]) == "?" and str(by["Last 5"]["why"]) == "not on tape",
		"an unknown form is ? with the reason, never an invented run")
	_check(not by.has("Streak"), "no streak row when neither form is known")
	_check(str(by["Last 5"]["better"]) == "", "form names no better side")


## The screens: fight night's card and the 3D intro's bands show the row; every tape screen asks TapeRows for it.
func _screens() -> void:
	_check(TapeVersus.SHOW.has("Last 5") and TapeVersus.SHOW.has("Streak"), "fight night's tape card shows Last 5 and Streak")
	var f := _fighter()
	f["form"] = ["W", "W", "L"]
	var opp := {"name": "Dan Stone", "club": "Stone's Gym", "w": 8, "l": 2, "form": ["L(KO)", "W"], "age": 27, "stance": "orthodox", "style": "Slugger"}
	var bands: Array = TapeVersus.broadcast_rows("Anvil Street Gym", f, opp, 172.0)
	var last: Array = bands.filter(func(b): return str(b["label"]) == "LAST 5")
	_check(last.size() == 1 and str(last[0]["left"]) == "W W L" and str(last[0]["right"]) == "L(KO) W", "the 3D intro's tape has a LAST 5 band")
	for label in ["Last 5", "Streak"]:
		_check(TapeRows.ORDER.has(label), "%s is in the one order every tape screen reads" % label)


func _by(rows: Array) -> Dictionary:
	var out := {}
	for r in rows:
		out[str(r["label"])] = r
	return out


func _check(ok: bool, label: String) -> void:
	if ok:
		print("  ok: " + label)
	else:
		failures += 1
		print("  FAIL: " + label)
