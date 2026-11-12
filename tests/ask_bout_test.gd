extends SceneTree
## ASKPROBE1 / ASK2: AskBout tests (map ops/research/ASKFIGHT_MAP_S441.md v2). Two DIFFERENT fighters over one division of
## 14 rows shaped like Region.rankings (an unranked 1-0 novice, not in the table; a ranked 6-1 in it, ours = true, beside a
## teammate). Each rule is a CHECK function run on the real module and on runtime MUTANTS of its source (AskBout.gd with
## one line changed, compiled here): the real module must pass, every mutant must fail - an assert that cannot go red is
## not a test (the seat's last check was a tautology).
##   <godot.exe> --headless --audio-driver Dummy --path . --script res://tests/ask_bout_test.gd

const AskBout := preload("res://scripts/rules/AskBout.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")
const FightLearn := preload("res://scripts/rules/FightLearn.gd")
const Region := preload("res://scripts/state/Region.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Clock := preload("res://scripts/state/Clock.gd")
const SRC := "res://scripts/rules/AskBout.gd"

var failures := 0
var MIN := Region.RANK_MIN_WINS
var AFTER := Bouts.AFTER_FIGHT
var FMT := Callable(Clock, "fmt")
var _decimal := RegEx.create_from_string("\\d\\.\\d")


func _initialize() -> void:
	var real: GDScript = AskBout
	var checks := ["_check_novice", "_check_ranked", "_check_missing_row", "_check_only_sheet", "_check_open",
		"_check_show_day", "_check_card", "_check_strip"]
	for ck in checks:
		var bad: Array = call(ck, real)
		for b in bad:
			_fail("%s: %s" % [ck, b])
	# Mutants: [what, old line, new line, the check that must go red].
	var mutants := [
		["the step-up name and the sheet name allowed in the picked list", "if i == at or not_these.has(nm) or not _legal",
			"if i == at or not _legal", "_check_ranked"],
		["the unranked step up = the BEST better record, not the nearest", "return nx < ny", "return nx > ny", "_check_novice"],
		["the show lead 14 -> 7 days", "const MIN_LEAD_DAYS := AmateurBooking.LEAD_WEEKS_MIN * 7", "const MIN_LEAD_DAYS := 7",
			"_check_show_day"],
		["our own rows offered", "if r.is_empty() or bool(r.get(\"ours\", false)):", "if r.is_empty():", "_check_ranked"],
		["the booked reason opens on no day", "bd + after_fight if bd >= 0 else -1", "-1", "_check_open"],
		["the BJJ reason dropped", "if str(f.get(\"discipline\", \"boxing\")) == \"bjj\":", "if false:", "_check_open"],
		["not fit with no heal day opens today", "var heal := int(f.get(\"healed_day\", -1))",
			"var heal := int(f.get(\"healed_day\", day))", "_check_open"],
		["show_day's why without the date", "\"%s is already on %s.\" % [holder, str(fmt.call(d))]",
			"\"%s is already on that night.\" % holder", "_check_show_day"],
		["a ranked fighter found by place, not by name", "var at := RankLine._rank_of(table, me) - 1",
			"var at := int(f.get(\"rank\", 1)) - 1", "_check_missing_row"],
		["the card carries the teaching number", "\"teaches\": teach_words,", "\"teaches\": teach_words, \"learn\": 0.73,",
			"_check_card"],
		["the road loses the nationals line", "if need > 0:", "if false:", "_check_strip"],
		["S445: no first-bout lock", "if int(f.get(\"w\", 0)) + int(f.get(\"l\", 0)) + int(f.get(\"d\", 0)) == 0",
			"if false and int(f.get(\"w\", 0)) + int(f.get(\"l\", 0)) + int(f.get(\"d\", 0)) == 0", "_check_open"],
		["S445: a 14-day show called no camp", "if away > 7:", "if away > 14:", "_check_strip"],
		["S445: a scale miss leaves Ask armed", "\"ask_ok\": not risk,", "\"ask_ok\": true,", "_check_strip"],
		["S445: the road never says cannot", "if show_day >= 0 and need >", "if false and need >", "_check_strip"],
		["S445: an unranked step up still called A step up", "return \"A step up\" if fighter_ranked else",
			"return \"A step up\" if true else", "_check_card"],
	]
	for mu in mutants:
		var s := _mutant(str(mu[1]), str(mu[2]))
		if s == null:
			_fail("mutant '%s': the line to change is not in AskBout.gd (the test is stale)" % mu[0])
			continue
		var bad: Array = call(str(mu[3]), s)
		if bad.is_empty():
			_fail("mutant '%s' stayed GREEN under %s" % [mu[0], mu[3]])
		else:
			print("  mutant red: %s (%s: %s)" % [mu[0], mu[3], str(bad[0])])
	print("ASK_BOUT failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _fail(what: String) -> void:
	failures += 1
	print("  FAIL: " + what)


func _mutant(old: String, new: String) -> GDScript:
	var src := FileAccess.get_file_as_string(SRC)
	if not src.contains(old):
		return null
	var g := GDScript.new()
	g.source_code = src.replace(old, new)
	if g.reload() != OK:
		return null
	return g


## The division: the seat's 12 rows, an open boxer past the novice limit, and our two (Region.rankings: ours = true,
## rating 0). Our unranked novice is NOT in it (Region.rankings lists ours from RANK_MIN_WINS wins).
func _rows() -> Array:
	return [
		{"name": "Open Olsen", "club": "Repton", "w": 12, "l": 4, "rating": 72.0, "style": "Boxer-puncher", "ours": false},
		{"name": "Alpha", "club": "North", "w": 8, "l": 1, "rating": 70.0, "style": "Pressure fighter", "ours": false},
		{"name": "Beta", "club": "East", "w": 7, "l": 2, "rating": 65.0, "style": "Out-boxer", "ours": false},
		{"name": "Mate", "club": "Our Gym", "w": 7, "l": 2, "rating": 0.0, "style": "", "ours": true},
		{"name": "Our Six", "club": "Our Gym", "w": 6, "l": 1, "rating": 0.0, "style": "", "ours": true},
		{"name": "Gamma", "club": "South", "w": 6, "l": 2, "rating": 62.0, "style": "Counter-puncher", "ours": false},
		{"name": "Delta", "club": "West", "w": 6, "l": 3, "rating": 60.0, "style": "Pressure fighter", "ours": false},
		{"name": "Epsilon", "club": "North", "w": 5, "l": 3, "rating": 58.0, "style": "Out-boxer", "ours": false},
		{"name": "Zeta", "club": "East", "w": 5, "l": 4, "rating": 55.0, "style": "Counter-puncher", "ours": false},
		{"name": "Eta", "club": "South", "w": 4, "l": 3, "rating": 52.0, "style": "Pressure fighter", "ours": false},
		{"name": "Theta", "club": "West", "w": 4, "l": 4, "rating": 50.0, "style": "Out-boxer", "ours": false},
		{"name": "Iota", "club": "North", "w": 3, "l": 2, "rating": 48.0, "style": "Counter-puncher", "ours": false},
		{"name": "Kappa", "club": "East", "w": 2, "l": 2, "rating": 45.0, "style": "Pressure fighter", "ours": false},
		{"name": "Lambda", "club": "South", "w": 1, "l": 1, "rating": 42.0, "style": "Out-boxer", "ours": false},
	]


func _kinds(ans: Array) -> Array:
	var out: Array = []
	for a in ans:
		out.append(str(a["kind"]))
	return out


func _names(ans: Array, kind: String) -> Array:
	for a in ans:
		if str(a["kind"]) == kind:
			return a["names"]
	return []


## 1-0 novice: the sheet; the step up = the NEAREST better record inside the novice rule (Epsilon 5-3, net 2 - not Alpha,
## net 7, the best); no picked name (not on the ladder); nobody past 10 bouts, nobody of ours.
func _check_novice(S: GDScript) -> Array:
	var bad: Array = []
	var f := {"name": "Our Novice", "w": 1, "l": 0}
	var ans: Array = S.call("answers", f, _rows(), "Lambda", MIN)
	var k := _kinds(ans)
	if k != ["sheet", "step_up"]:
		bad.append("kinds %s, want [sheet, step_up]" % str(k))
	var step: Array = _names(ans, "step_up")
	if step != ["Epsilon"]:
		bad.append("step up %s, want the nearest better record [Epsilon]" % str(step))
	bad.append_array(_legal_and_not_ours(ans, 1))
	return bad


## 6-1, ranked 5th by name (Open, Alpha, Beta, Mate of ours, then us): the step up skips our Mate -> Beta; the picks are the
## legal names up to 4 places ABOVE (S443 Q-S294-204 "Only above or level") minus the sheet (Epsilon), the step up and ours:
## exactly Alpha (Open is past the novice limit); Gamma, Delta and Zeta sit below and are never offered.
func _check_ranked(S: GDScript) -> Array:
	var bad: Array = []
	var f := {"name": "Our Six", "w": 6, "l": 1}
	if int(S.call("place_of", _rows(), "Our Six", MIN)) != 5:
		bad.append("place %d, want 5" % int(S.call("place_of", _rows(), "Our Six", MIN)))
	var ans: Array = S.call("answers", f, _rows(), "Epsilon", MIN)
	if _kinds(ans) != ["sheet", "step_up", "name"]:
		bad.append("kinds %s" % str(_kinds(ans)))
	if _names(ans, "step_up") != ["Beta"]:
		bad.append("step up %s, want [Beta] (our Mate passed over)" % str(_names(ans, "step_up")))
	var picked: Array = _names(ans, "name")
	if picked != ["Alpha"]:
		bad.append("picked %s, want [Alpha] (above only)" % str(picked))
	for nm in ["Epsilon", "Beta", "Gamma", "Delta", "Zeta"]:
		if picked.has(nm):
			bad.append("picked holds %s (the sheet or the step-up name)" % nm)
	bad.append_array(_legal_and_not_ours(ans, 7))
	# The sheet itself never sends one of ours.
	if _kinds(S.call("answers", f, _rows(), "Mate", MIN)).has("sheet"):
		bad.append("the sheet offered our own Mate")
	return bad


func _legal_and_not_ours(ans: Array, own_bouts: int) -> Array:
	var bad: Array = []
	for a in ans:
		for nm in a["names"]:
			for r in _rows():
				if str(r["name"]) == str(nm):
					if bool(r["ours"]):
						bad.append("offered our own %s" % nm)
					if not AmateurBooking.experience_match_ok(own_bouts, AmateurBooking.bouts_of(int(r["w"]), int(r["l"]))):
						bad.append("offered %s past the novice limit" % nm)
	return bad


## A ranked record whose row is missing: no step up, no picks (never "whoever holds that place"); the sheet stays.
func _check_missing_row(S: GDScript) -> Array:
	var f := {"name": "Not In Table", "w": 6, "l": 1, "rank": 3}
	var ans: Array = S.call("answers", f, _rows(), "Epsilon", MIN)
	return [] if _kinds(ans) == ["sheet"] else ["missing row gave %s, want [sheet] only" % str(ans)]


## Only the sheet name legal: one entry (the name above IS the sheet name: shown once).
func _check_only_sheet(S: GDScript) -> Array:
	var rows := [{"name": "Only", "club": "North", "w": 5, "l": 3, "rating": 55.0, "style": "", "ours": false},
		{"name": "Us", "club": "Our Gym", "w": 5, "l": 3, "rating": 0.0, "style": "", "ours": true}]
	var ans: Array = S.call("answers", {"name": "Us", "w": 5, "l": 3}, rows, "Only", MIN)
	return [] if _kinds(ans) == ["sheet"] else ["only-sheet gave %s" % str(_kinds(ans))]


## Map s5: every closed reason with its day; the reason names the fighter.
func _check_open(S: GDScript) -> Array:
	var bad: Array = []
	var base := {"name": "Kira Shaw", "last_bout_day": 20}
	var cases := [
		["pro", {"pro": true}, false, -1],
		["bjj", {"discipline": "bjj"}, false, -1],
		["nationals", {"in_nationals": true, "nationals_end": 120}, false, 120],
		["booked", {"booked": true, "bout_day": 64}, false, 64 + AFTER],
		["offer waiting", {"offer_waiting": true, "offer_expires": 53}, false, 54],
		["hurt, heal day known", {"fit": false, "healed_day": 70}, false, 70],
		["hurt, no heal day", {"fit": false}, false, -1],
		["too soon", {"last_bout_day": 45}, false, 45 + AFTER],
		["open", {"last_bout_day": 30}, true, -1],
		["no bout fought yet", {"last_bout_day": -1}, false, -1],
		["first bout booked", {"last_bout_day": -1, "booked": true, "bout_day": 26}, false, 26 + AFTER],
	]
	for cs in cases:
		var r: Dictionary = S.call("open", base.merged(cs[1], true), 50, AFTER)
		if bool(r["open"]) != bool(cs[2]) or int(r["opens_day"]) != int(cs[3]):
			bad.append("%s: open=%s opens_day=%d, want %s / %d" % [cs[0], r["open"], int(r["opens_day"]), cs[2], int(cs[3])])
		if not bool(cs[2]) and str(r["why"]) == "":
			bad.append("%s: no reason" % cs[0])
		if not bool(cs[2]) and str(cs[0]) != "too soon" and not str(r["why"]).contains("Kira Shaw"):
			bad.append("%s: the reason does not name the fighter ('%s')" % [cs[0], r["why"]])
	return bad


## Map s3: a show 5 and 10 days out (the 7-13 band) is skipped; 14 days out held by Lucy is skipped and the why says who
## and when; the show after is offered. Unsorted input.
func _check_show_day(S: GDScript) -> Array:
	var bad: Array = []
	var r: Dictionary = S.call("show_day", 50, [78, 55, 60, 64], [{"name": "Lucy", "day": 64}], FMT)
	if int(r["day"]) != 78 or int(r["days_away"]) != 28:
		bad.append("day %d, want 78" % int(r["day"]))
	if str(r["why"]) != "Lucy is already on %s." % Clock.fmt(64):
		bad.append("why '%s'" % r["why"])
	var r2: Dictionary = S.call("show_day", 50, [60, 64], [], FMT)
	if int(r2["day"]) != 64 or str(r2["why"]) != "":
		bad.append("free calendar: day %d why '%s', want 64 and no why" % [int(r2["day"]), r2["why"]])
	return bad


## Map s4: the card's values are all words; no decimal number anywhere, under ANY key; the place comes from RankLine.
func _check_card(S: GDScript) -> Array:
	var bad: Array = []
	var opp: Dictionary = _rows()[2]
	var cd: Dictionary = S.call("card", opp, "step_up", _rows(), MIN, FightLearn.word(0.90), FightLearn.stop_word(0.05))
	bad.append_array(_card_words_only(cd))
	if str(cd["place"]) != "Number 3.":
		bad.append("place '%s', want 'Number 3.' (RankLine)" % cd["place"])
	if str(cd["teaches"]) != "teaches a lot" or str(cd["record"]) != "7-2":
		bad.append("card %s" % str(cd))
	if str(cd["label"]) != "A step up":
		bad.append("ranked step-up label '%s'" % cd["label"])
	var nov: Dictionary = S.call("card", opp, "step_up", _rows(), MIN, "", "", false)
	if str(nov["label"]) != "Nearest better record":
		bad.append("unranked step-up label '%s', want 'Nearest better record' (map v3 s2)" % nov["label"])
	if FightLearn.word(0.47) != "teaches little" or FightLearn.word(0.73) != "teaches some" or FightLearn.word(1.05) != "teaches a lot":
		bad.append("teach words do not split the probe's 0.47-1.05 range")
	var named: Dictionary = S.call("card", _rows()[1], "name", _rows(), MIN)
	if not str(named["gate"]).contains("$0"):
		bad.append("a picked name's gate words '%s'" % named["gate"])
	return bad


func _card_words_only(cd: Dictionary) -> Array:
	var bad: Array = []
	for k in cd:
		if typeof(cd[k]) != TYPE_STRING:
			bad.append("card key '%s' holds a %s, not words" % [k, type_string(typeof(cd[k]))])
		elif _decimal.search(str(cd[k])) != null:
			bad.append("card key '%s' holds a number '%s'" % [k, cd[k]])
	return bad


## Map s3: the strip and the road: what is STILL needed, the nationals first.
func _check_strip(S: GDScript) -> Array:
	var bad: Array = []
	var show := {"day": 42, "days_away": 21}
	var f := {"name": "Kira Shaw", "w": 2, "l": 0, "weight": 61.5, "limit": 60.0, "nationals_need": 3, "nationals_by": 70}
	var st: Dictionary = S.call("strip", f, show, {"day": 60.4, "limit": 60.0, "ok": false}, FMT)
	if not bool(st["camp"]) or not bool(st["weight_risk"]) or str(st["risk_words"]) != "Weight at risk":
		bad.append("strip %s" % str(st))
	if str(st["road"]) != "3 bouts still needed for the nationals by %s." % Clock.fmt(70):
		bad.append("nationals road '%s'" % st["road"])
	var roads := [
		[{"w": 6, "l": 1, "rank": 5}, "1 more win and a top-3 place (now number 5) for the pro offer."],
		[{"w": 7, "l": 1, "rank": 2}, "The pro offer is due: the wins and the place are there."],
		[{"w": 7, "l": 2, "rank": 4}, "A top-3 place (now number 4) for the pro offer, or 2 more wins."],
		[{"w": 2, "l": 0, "rank": 0}, "7 more wins for the pro offer."],
	]
	for rd in roads:
		var got: String = S.call("road", rd[0], FMT)
		if got != str(rd[1]):
			bad.append("road %s = '%s', want '%s'" % [str(rd[0]), got, rd[1]])
	if bool(st["ask_ok"]):
		bad.append("a scale miss left Ask armed on that date")
	var st2: Dictionary = S.call("strip", f, {"day": 64, "days_away": 14}, {"ok": true}, FMT)
	if not bool(st2["camp"]) or bool(st2["weight_risk"]) or not bool(st2["ask_ok"]):
		bad.append("14 days out: camp %s risk %s ask %s" % [st2["camp"], st2["weight_risk"], st2["ask_ok"]])
	if str(st2["camp_words"]) != "Two weeks: a PEAK camp, no BUILD.":
		bad.append("14 days out camp words '%s' (a 14-day show is PEAK)" % st2["camp_words"])
	var words := {28: "Camp can be set: BUILD, PEAK and fight week.", 7: "Fight week only: a light camp, no sparring.",
		5: "No camp: under a week to fight night."}
	for d in words:
		if str(S.call("camp_words", d)) != str(words[d]):
			bad.append("%d days out camp words '%s'" % [d, S.call("camp_words", d)])
	# 3 bouts by day 70 from a show on day 64: only that one bout fits -> cannot be made; 2 from day 42 (42, 56, 70) can.
	var miss: String = S.call("road", f, FMT, 64)
	if miss != "The nationals' 3 bouts by %s cannot be made from this show." % Clock.fmt(70):
		bad.append("road from a late show '%s'" % miss)
	if str(S.call("road", f, FMT, 42)) != "3 bouts still needed for the nationals by %s." % Clock.fmt(70):
		bad.append("road from day 42 '%s'" % S.call("road", f, FMT, 42))
	return bad
