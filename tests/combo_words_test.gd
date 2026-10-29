extends SceneTree
## S303 ComboWords: Kalli's bank loads, every Combos.BOOK id has all four kinds, the energy bands, and the ring captions
## (signature run that lands whole, a cut run, never over a caption, once per side and kind).

const W := preload("res://scripts/rules/ComboWords.gd")
const C := preload("res://scripts/rules/Combos.gd")

var _fails := 0


func _initialize() -> void:
	for row in C.BOOK:
		var id := str(row["id"])
		for kind in ["coach_learning", "coach_signature", "ring_lands", "ring_tired"]:
			_check(W.line(id, kind, "Maria", 3) != "", "bank: %s has %s" % [id, kind])
	_check(W.line("1-2", "ring_lands", "Maria", 0).contains("Maria"), "line: {name} filled")
	_check(W.band(100.0) == "fresh" and W.band(70.0) == "fresh", "band: fresh at >= 70")
	_check(W.band(69.0) == "tiring" and W.band(20.0) == "tiring", "band: tiring 20 .. 70")
	_check(W.band(19.0) == "empty", "band: empty under 20")
	_check(W.energy_line(10.0, "Maria", 1) != "", "energy_line: empty band has lines")
	# A signature 1-2 that lands whole -> ring_lands on its last beat; a second one gets none (once a round).
	var beats := [_b("a", "1-2", "lands"), _b("a", "1-2", "lands"), _b("b", "", "blocked"), _b("a", "1-2", "lands"),
		_b("a", "1-2", "lands")]
	W.caption(beats, {"a": {"1-2": 90.0}}, ["Maria", "Lucy"], 7)
	_check(str(beats[0]["caption"]) == "" and str(beats[1]["caption"]) != "", "caption: signature run captioned on its last beat")
	_check(str(beats[4]["caption"]) == "", "caption: once per side a round")
	# Not signature -> nothing; a run that does not land whole -> nothing.
	var b2 := [_b("a", "1-2", "lands"), _b("a", "1-2", "lands")]
	W.caption(b2, {"a": {"1-2": 70.0}}, ["Maria", "Lucy"], 7)
	_check(str(b2[1]["caption"]) == "", "caption: SHARP run gets no line")
	var b3 := [_b("a", "1-2", "lands"), _b("a", "1-2", "blocked")]
	W.caption(b3, {"a": {"1-2": 95.0}}, ["Maria", "Lucy"], 7)
	_check(str(b3[1]["caption"]) == "", "caption: half-landed run gets no line")
	# A cut run -> ring_tired with her name, for either side; an existing caption is kept.
	var b4 := [_b("b", "1-2-3", "lands"), _b("b", "1-2-3", "blocked")]
	b4[1]["combo_cut"] = true
	W.caption(b4, {}, ["Maria", "Lucy"], 2)
	_check(str(b4[1]["caption"]).contains("Lucy"), "caption: cut run -> ring_tired line for the opponent")
	var b5 := [_b("a", "1-2", "lands"), _b("a", "1-2", "lands")]
	b5[1]["caption"] = "kept"
	W.caption(b5, {"a": {"1-2": 99.0}}, ["Maria", "Lucy"], 7)
	_check(str(b5[1]["caption"]) == "kept", "caption: never over a caption already there")
	print("COMBO_WORDS %s fails=%d" % ["PASS" if _fails == 0 else "FAIL", _fails])
	quit(1 if _fails > 0 else 0)


func _b(who: String, cid: String, result: String) -> Dictionary:
	var d := {"t": 0.0, "who": who, "move": "jab", "result": result, "caption": ""}
	if cid != "":
		d["combo_id"] = cid
	return d


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
		print("FAIL ", what)
