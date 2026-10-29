extends SceneTree
## Blind contract: the words must describe the beats, not an independently imagined fight.

const RoundScript := preload("res://scripts/rules/RoundScript.gd")
const CornerCard := preload("res://scripts/rules/CornerCard.gd")
const ComboWords := preload("res://scripts/rules/ComboWords.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const Data := preload("res://scripts/state/Data.gd")
const Combos := preload("res://scripts/rules/Combos.gd")

const SEEDS := 300
const SECONDS := 40.0
const EXPECTED := {"close": [4, 3], "clear": [5, 2], "dominant": [6, 1]}
const CALLS := {"long": [["jab", "lands"], ["jab", "blocked"]],
	"body": [["lead_hook", "lands"], ["cross", "blocked"]],
	"calm": [["step_out", "none"], ["jab", "lands"]]}
const CALL_TEXT := {"long": "Stay long: she starts behind the jab.", "body": "Go to the body: she digs one in early.",
	"calm": "Calm, breathe: she resets and jabs."}
# Observed production discrepancies, not waivers. S305: the three Arena found are fixed (CornerCard.WORD, RoundScript._left)
# and are hard checks again; keep this empty.
const FINDINGS := []
const PUNCHES := ["jab", "cross", "lead_hook", "rear_hook", "body_hook", "lead_uppercut", "rear_uppercut"]
const HOOKS := ["lead_hook", "rear_hook", "body_hook"]

var failures := 0
var violations := {}
var samples := {}
var landed_captions := 0
var tired_captions := 0
var mix := {"pressure": {"total": 0, "hooks": 0, "jabs": 0}, "out": {"total": 0, "hooks": 0, "jabs": 0}}


func _initialize() -> void:
	var fighters: Array = _fighters()
	print("POPULATION fighters=2 opponents=%d rounds=1-3 winners=a,b margins=close,clear,dominant seeds=%d per case total=%d calls=long,body,calm" % [Data.OPPONENTS.size(), SEEDS, 2 * Data.OPPONENTS.size() * 3 * 2 * 3 * SEEDS])
	_check(fighters[0]["stats"] != fighters[1]["stats"] and fighters[0]["moves"] != fighters[1]["moves"] and fighters[0]["combos"] != fighters[1]["combos"], "two distinct fighters")
	for fighter in fighters:
		for opp in Data.OPPONENTS:
			for n in range(1, 4):
				for won in [true, false]:
					for margin_name in EXPECTED:
						for seed_value in SEEDS:
							_play(fighter, opp, n, won, margin_name, seed_value)
	for label in ["margin landed counts", "dominant knockback", "winner lands last", "beat time order", "bell clearance", "corner call opening", "card landed totals", "card landed moves", "card top punch", "landed combo caption whole", "tired combo caption cut", "caption kind and preservation"]:
		_report(label)
	_check(landed_captions > 0, "observed landed combo captions (n=%d)" % landed_captions)
	_check(tired_captions > 0, "observed tired combo captions (n=%d)" % tired_captions)
	_check_style()
	print("WORDSCONTRACT failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _bad(label: String, context: String) -> void:
	violations[label] = int(violations.get(label, 0)) + 1
	if not samples.has(label):
		samples[label] = context


func _report(label: String) -> void:
	var count: int = int(violations.get(label, 0))
	var details := "%s violations=%d first=%s" % [label, count, str(samples.get(label, "none"))]
	if count > 0 and label in FINDINGS:
		print("FINDING ", details)
	else:
		_check(count == 0, details)


func _fighters() -> Array:
	var a: Dictionary = Data.lucy()
	a["moves"] = {"Jab": 90.0, "Cross": 90.0, "Lead hook": 90.0, "Body hook": 88.0, "Uppercut": 87.0, "Check hook": 50.0}
	a["combos"] = {"1-1": 95.0, "1-2": 92.0, "1-2-3": 90.0}
	a["stats"]["speed"] = 72.0
	var b: Dictionary = Data.PROSPECTS[1].duplicate(true)
	b["moves"] = {"Jab": 85.0, "Cross": 88.0, "Lead hook": 92.0, "Body hook": 90.0, "Uppercut": 40.0, "Check hook": 30.0}
	b["combos"] = {"3b-3": 95.0, "2-3": 90.0, "1-2-3b": 88.0}
	b["stats"]["speed"] = 68.0
	return [a, b]


func _play(fighter: Dictionary, opp: Dictionary, n: int, won: bool, margin_name: String, seed_value: int) -> void:
	var diff: float = {"close": 1.0, "clear": 2.0, "dominant": 4.0}[margin_name]
	var call: String = ["long", "body", "calm"][seed_value % 3]
	var round_data := {"n": n, "won": won, "mine": 60.0 + (diff if won else 0.0),
		"theirs": 60.0 + (0.0 if won else diff), "corner": call, "lines": ["Opening line", "Closing line"]}
	var a: Dictionary = RoundStyle.of_fighter(fighter)
	var b: Dictionary = RoundStyle.from_opponent(opp)
	# Include fresh and weary rounds; the latter exercise the separate tired-caption contract.
	a["energy"] = 30.0 if seed_value % 2 == 0 else 100.0
	b["energy"] = 30.0 if seed_value % 2 == 0 else 100.0
	var script: Dictionary = RoundScript.build(round_data, str(fighter["style"]), str(opp["style"]), SECONDS, seed_value, {"a": a, "b": b})
	var beats: Array = script["beats"]
	var winner := "a" if won else "b"
	var loser := "b" if won else "a"
	var context := "seed=%d round=%d winner=%s margin=%s fighter=%s opponent=%s" % [seed_value, n, winner, margin_name, fighter["name"], opp["name"]]
	var counts: Dictionary = RoundScript.landed(script)
	var expected: Array = EXPECTED[margin_name]
	if RoundScript.margin(round_data) != margin_name or int(counts[winner]) != expected[0] or int(counts[loser]) != expected[1]:
		_bad("margin landed counts", context + " counts=%s" % str(counts))
	var last_lander := ""
	var knockbacks := 0
	var previous := -1.0
	var actual := {"a": {}, "b": {}}
	for beat in beats:
		var bt: Dictionary = beat
		var t: float = float(bt["t"])
		if t < previous:
			_bad("beat time order", context + " previous=%.2f t=%.2f" % [previous, t])
		previous = t
		if bool(bt.get("knockback", false)):
			knockbacks += 1
		if str(bt["result"]) == "lands":
			last_lander = str(bt["who"])
			var land: Dictionary = actual[last_lander]
			var move := str(bt["move"])
			land[move] = int(land.get(move, 0)) + 1
		_mix_beat(opp, bt)
	if margin_name == "dominant" and knockbacks != 1:
		_bad("dominant knockback", context + " knockbacks=%d" % knockbacks)
	if last_lander != winner:
		_bad("winner lands last", context + " actual=%s" % last_lander)
	if beats.is_empty() or float(beats[-1]["t"]) > SECONDS - 2.0:
		_bad("bell clearance", context + " last=%.2f" % previous)
	if n >= 2:
		var opening_ok: bool = beats.size() >= 2
		if opening_ok:
			for k in 2:
				opening_ok = opening_ok and str(beats[k]["who"]) == "a" and str(beats[k]["move"]) == CALLS[call][k][0] and str(beats[k]["result"]) == CALLS[call][k][1]
			opening_ok = opening_ok and str(beats[0].get("caption", "")) == CALL_TEXT[call]
		if not opening_ok:
			_bad("corner call opening", context + " call=%s" % call)
	_check_card(beats, counts, actual, context)
	_check_captions(beats, {"a": a["combos"], "b": b["combos"]}, [fighter["first"], opp["first"]], seed_value, context)


func _check_card(beats: Array, counts: Dictionary, actual: Dictionary, context: String) -> void:
	var summary: Dictionary = CornerCard.summarize(beats)
	for side in ["a", "b"]:
		var listed: Dictionary = summary[side]["landed"]
		var real: Dictionary = actual[side]
		var total := 0
		for move in listed:
			total += int(listed[move])
			if int(listed[move]) > int(real.get(move, 0)) or int(listed[move]) <= 0:
				_bad("card landed moves", context + " side=%s move=%s listed=%d actual=%d" % [side, move, listed[move], int(real.get(move, 0))])
		if total != int(counts[side]):
			_bad("card landed totals", context + " side=%s card=%d ring=%d card_moves=%s ring_moves=%s" % [side, total, counts[side], str(listed), str(real)])
		var top: String = CornerCard.top(listed)
		var max_real := 0
		for move in real:
			max_real = maxi(max_real, int(real[move]))
		if top == "" or int(real.get(top, 0)) != max_real:
			_bad("card top punch", context + " side=%s top=%s top_count=%d max=%d card_moves=%s ring_moves=%s" % [side, top, int(real.get(top, 0)), max_real, str(listed), str(real)])


func _check_captions(beats: Array, masteries: Dictionary, names: Array, seed_value: int, context: String) -> void:
	var before: Array = beats.duplicate(true)
	ComboWords.caption(beats, masteries, names, seed_value)
	for i in beats.size():
		var bt: Dictionary = beats[i]
		var text := str(bt.get("caption", ""))
		var old := str(before[i].get("caption", ""))
		if old != "":
			if text != old:
				_bad("caption kind and preservation", context + " beat=%d overwritten=1" % i)
			continue
		if text == "":
			continue
		var cid := str(bt.get("combo_id", ""))
		var side := str(bt["who"])
		var kind := _caption_kind(cid, text, str(names[0 if side == "a" else 1]))
		if kind == "tired":
			tired_captions += 1
			if not bool(bt.get("combo_cut", false)):
				_bad("tired combo caption cut", context + " beat=%d" % i)
		elif kind == "lands":
			landed_captions += 1
			var start := i
			while start > 0 and bool(beats[start].get("combo", false)) and str(beats[start - 1].get("combo_id", "")) == cid and str(beats[start - 1]["who"]) == side:
				start -= 1
			var moves: Array = []
			var whole := not bool(bt.get("combo_cut", false))
			if i + 1 < beats.size() and bool(beats[i + 1].get("combo", false)) and str(beats[i + 1].get("combo_id", "")) == cid and str(beats[i + 1]["who"]) == side:
				whole = false
			for j in range(start, i + 1):
				moves.append(str(beats[j]["move"]))
				whole = whole and str(beats[j]["result"]) == "lands"
			var row: Dictionary = Combos.row(cid)
			whole = whole and not row.is_empty() and moves == row.get("beats", []) and float(masteries[side].get(cid, 0.0)) >= 85.0
			if not whole:
				_bad("landed combo caption whole", context + " beat=%d start=%d actual=%s expected=%s" % [i, start, str(moves), str(row.get("beats", []))])
		else:
			_bad("caption kind and preservation", context + " beat=%d unrecognized=1" % i)


func _caption_kind(cid: String, text: String, boxer: String) -> String:
	for entry in ComboWords.bank().get("combos", []):
		if str(entry.get("id", "")) == cid:
			for kind in ["lands", "tired"]:
				for line in entry.get("ring_" + kind, []):
					if str(line).replace("{name}", boxer) == text:
						return kind
	return ""


func _mix_beat(opp: Dictionary, beat: Dictionary) -> void:
	if str(beat["who"]) != "b" or not PUNCHES.has(str(beat["move"])):
		return
	var style := str(opp.get("style", "")).to_lower()
	var group := "pressure" if style.contains("pressure") or style.contains("slugger") else ("out" if style.contains("out") else "")
	if group == "":
		return
	var tally: Dictionary = mix[group]
	tally["total"] += 1
	if HOOKS.has(str(beat["move"])):
		tally["hooks"] += 1
	if str(beat["move"]) == "jab":
		tally["jabs"] += 1


func _check_style() -> void:
	var p: Dictionary = mix["pressure"]
	var o: Dictionary = mix["out"]
	var has_out := false
	var has_pressure := false
	for opp in Data.OPPONENTS:
		var style := str(opp.get("style", "")).to_lower()
		has_out = has_out or style.contains("out")
		has_pressure = has_pressure or style.contains("pressure") or style.contains("slugger")
	if not has_out:
		print("SKIP style mix: Data.OPPONENTS has no out-boxer opponent; pressure punches=%d" % int(p["total"]))
		return
	_check(has_pressure and int(p["total"]) > 0 and int(o["total"]) > 0, "style population has pressure and out-boxer punches")
	if not has_pressure or int(p["total"]) == 0 or int(o["total"]) == 0:
		return
	var details := "pressure hooks=%d jabs=%d total=%d out hooks=%d jabs=%d total=%d" % [p["hooks"], p["jabs"], p["total"], o["hooks"], o["jabs"], o["total"]]
	_check(float(p["hooks"]) / float(p["total"]) > float(o["hooks"]) / float(o["total"]), "pressure hook share " + details)
	_check(float(o["jabs"]) / float(o["total"]) > float(p["jabs"]) / float(p["total"]), "out-boxer jab share " + details)
