extends SceneTree
## S519 club week v11 3.4: film watched ALONE is half a tape session (OppFile.half_tape) - never a dead end. Two
## different opponents (a pressure fighter and a counter-puncher, different records and threats): the first alone night
## opens nothing and keeps the half; the second opens the next hidden tell, in the tape order a coached night would.
## Prints HALF_TAPE failures=N.

const OppFile := preload("res://scripts/rules/OppFile.gd")

var _fails := 0


func _initialize() -> void:
	var a := {"first": "Mia", "style": "pressure", "threat": "left hook", "weak": "body", "w": 6, "l": 2, "stance": "orthodox"}
	var b := {"first": "Zoe", "style": "counter", "threat": "right hand", "weak": "jab", "w": 3, "l": 4, "stance": "southpaw"}
	for opp in [a, b]:
		var first := str(OppFile.hidden(opp)[0])
		var n0 := OppFile.found(opp).size()
		_check(OppFile.half_tape(opp) == "" and bool(opp.get("half_tape", false)) and OppFile.found(opp).size() == n0, "%s: alone once = half a read, nothing open yet" % opp["first"])
		var got := OppFile.half_tape(opp)
		_check(got == first and OppFile.known(opp, first) and not opp.has("half_tape"), "%s: alone twice opens the next tell (%s)" % [opp["first"], got])
	var done := {"first": "Ivy", "style": "pressure", "threat": "jab", "weak": "body", "w": 1, "l": 0}
	while not OppFile.hidden(done).is_empty():
		OppFile.tape(done)
	_check(OppFile.half_tape(done) == "" and not done.has("half_tape"), "nothing left to find: no half kept")
	print("HALF_TAPE failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
		print("FAIL ", what)
	else:
		print("ok   ", what)
