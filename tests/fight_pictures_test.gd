extends SceneTree
## PICS2D2 (S540): the fight in pictures. Red first: before the full set the body hook showed as the head hook (PICS2D1's
## known wrong picture) and blocked punches had no picture. Checks (1) every punch the ring can throw (FightLog.PUNCH) has
## its own picture for both corners x landed / blocked / missed in both sets, plus guard, clinch, knockdown x3, corner;
## (2) the renders' own numbers: a landed glove ON its target, a missed one clearly off it on the picture; (3) shows() picks
## per exchange (first, winner's best landed, a stopped one), names the right family (a body hook is the body hook), adds
## the clinch, the knockdown and the stool; (4) the view plays through and closes.

const FP := preload("res://scripts/ui/FightPictures.gd")
const FightLog := preload("res://scripts/rules/FightLog.gd")
const LAND_MAX_M := 0.07     # glove front to the target point on a landed picture
const BODY_ON_M := 0.01      # S545 BODYCROSS2: a landed body cross is read against his body SURFACE as drawn: on it or in it ...
const BODY_SUNK_MAX_M := 0.09   # ... and never deeper than this (a glove through a body)
const MISS_MIN_PX := 50.0    # glove to head on a missed picture, in the 768 px picture (~0.17 m)

var failures := 0


func _initialize() -> void:
	_set_complete()
	_contacts()
	_shows()
	await _player()
	print("FIGHT_PICTURES failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
	print("%s %s" % ["ok  " if ok else "FAIL", label])


func _set_complete() -> void:
	for mv in FightLog.PUNCH:
		_check(mv in FP.FAMILIES, "the ring's %s has a picture family" % mv)
	for s in ["w", "m"]:
		var missing: Array = []
		var names: Array = ["guard", "clinch"]
		for c in ["red", "blue"]:
			for fam in FP.FAMILIES:
				for r in ["landed", "blocked", "missed"]:
					names.append("%s_%s_%s" % [c, fam, r])
			for k in 3:
				names.append("%s_knockdown_%d" % [c, k + 1])
			names.append("%s_corner" % c)
		for n in names:
			if not ResourceLoader.exists(FP.DIR + s + "/" + n + ".png"):
				missing.append(n)
		_check(missing.is_empty(), "set %s: all %d pictures there (missing %s)" % [s, names.size(), missing])


func _contacts() -> void:
	for s in ["w", "m"]:
		var path: String = FP.DIR + s + "/contacts.json"
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path)) if FileAccess.file_exists(path) else null
		var cj: Dictionary = parsed if parsed is Dictionary else {}
		var far: Array = []
		var near: Array = []
		var body: Array = []
		for n in cj:
			var c: Dictionary = cj[n]
			if not c.has("glove"):
				continue
			var gap := Vector2(c["glove"][0], c["glove"][1]).distance_to(Vector2(c["target"][0], c["target"][1]))
			if str(c["result"]) == "landed" and float(c["hit_m"]) > LAND_MAX_M:
				far.append("%s %.2f m" % [n, float(c["hit_m"])])
			if str(n).ends_with("body_cross_landed") and (not c.has("sunk_m") or float(c["hit_m"]) > BODY_ON_M or float(c["sunk_m"]) > BODY_SUNK_MAX_M):
				body.append("%s hit %.3f sunk %s" % [n, float(c["hit_m"]), str(c.get("sunk_m", "none"))])
			if str(c["result"]) == "missed" and gap < MISS_MIN_PX:
				near.append("%s %.0f px" % [n, gap])
		_check(cj.size() >= 50, "set %s: contacts for %d pictures" % [s, cj.size()])
		_check(far.is_empty(), "set %s: every landed glove on its target (off: %s)" % [s, far])
		_check(near.is_empty(), "set %s: every missed glove clearly off the head (on: %s)" % [s, near])
		_check(body.is_empty(), "set %s: a landed body cross is on or in his body as drawn, never through it (off: %s)" % [s, body])


func _b(t: float, who: String, move: String, result: String, big := false) -> Dictionary:
	return {"t": t, "who": who, "move": move, "result": result, "big": big}


func _shows() -> void:
	var tape := [
		{"i": 0, "won": true, "beats": [_b(2.0, "a", "jab", "lands"), _b(5.0, "b", "cross", "misses"), _b(9.0, "a", "body_hook", "lands", true), _b(12.0, "a", "jab", "lands")]},
		{"i": 1, "won": false, "beats": [_b(3.0, "b", "rear_uppercut", "blocked"), _b(8.0, "b", "lead_hook", "lands")]},
		{"i": 2, "won": false, "beats": []},
	]
	var r := {"exchanges": [{"won": true, "verdict": "Her jab found the gap."}, {"won": false, "clinch": true}, {}]}
	var s: Array = FP.shows(tape, r)
	var pics: Array = s.map(func(x): return str(x["pic"]))
	_check(pics.slice(0, 3) == ["red_jab_landed", "blue_cross_missed", "red_body_hook_landed"], "exchange 1: first, the stopped one, the winner's big body hook: %s" % [pics.slice(0, 3)])
	_check(not pics.has("red_lead_hook_landed"), "a body hook is never shown as the head hook")
	_check(pics.slice(3, 6) == ["blue_rear_uppercut_blocked", "clinch", "blue_lead_hook_landed"], "exchange 2: a blocked uppercut, the clinch, the landed hook: %s" % [pics.slice(3, 6)])
	_check(pics[6] == "guard" and pics[-1] == "red_corner", "a quiet exchange is the guard; the bell sends her to the stool")
	_check(str(s[0]["line"]) == "Her jab found the gap.", "the exchange's verdict goes beside its pictures")
	var ko: Array = FP.shows(tape, r.merged({"counts": 1, "down": "b"}))
	_check(ko.slice(-3).map(func(x): return str(x["pic"])) == ["blue_knockdown_1", "blue_knockdown_2", "blue_knockdown_3"], "a count shows the knockdown in three frames")
	_check(FP.pic_of(_b(0, "a", "say", "none")) == "" and FP.pic_of(_b(0, "b", "body_cross", "blocked")) == "blue_body_cross_blocked", "pic_of: words are not pictures; a body cross has its own")
	_check(is_equal_approx(FP.pop(0.0), 0.90) and is_equal_approx(FP.pop(FP.POP_S), 1.0) and FP.pop(FP.POP_S * 0.5) > 1.03, "the pop: 0.90 -> 1.035 -> 1.0")


func _player() -> void:
	var host := Control.new()
	root.add_child(host)
	var tape := [{"i": 0, "won": true, "beats": [_b(2.0, "a", "jab", "lands"), _b(5.0, "b", "body_hook", "blocked")]}]
	var v: Control = FP.open(host, {"names": ["Lucy Jackson", "Priya Nair"], "set": "w", "round": 1, "shows": FP.shows(tape, {"exchanges": [{"won": true}]})})
	await process_frame
	_check(v.get_node("Picture").texture != null and str(v.get_node("What").text) == "Your boxer lands the jab", "the first picture drawn, its words in roles: " + str(v.get_node("What").text))
	for i in 3:
		v._process(FP.PIC_S + 0.01)
	_check(int(v.at) == 2 and not bool(v.playing), "it plays through to the stool and stops")
	(v.find_child("PicsClose", true, false) as Button).emit_signal("pressed")
	await process_frame
	_check(host.get_node_or_null("FightPictures") == null, "Back to the corner closes it")
