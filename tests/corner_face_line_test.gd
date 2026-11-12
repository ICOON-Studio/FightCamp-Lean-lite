extends SceneTree
## DEFECTS1 (S439 audit trap): the corner card's line under her figure says what her face shows. An AMATEUR corner said
## "No cut, no swollen eye: the cutman waits." even with a cut and a swollen eye (no cutman jobs when not pro, so the
## empty-jobs branch always ran). An amateur corner has no cutman: it states the marks and nothing else.
## Builds the real CornerOverlay with two different boxers' maps and reads the labels it draws.
##   godot --headless --audio-driver Dummy --path . --script res://tests/corner_face_line_test.gd

const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const BandWords := preload("res://scripts/rules/BandWords.gd")
const CornerOverlay := preload("res://scripts/fight3d/CornerOverlay.gd")

var _fails := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
	print("%s %s" % ["ok  " if ok else "FAIL", what])


func _texts(n: Node) -> Array:
	var out: Array = []
	for c in n.find_children("*", "Label", true, false):
		out.append(str((c as Label).text))
	for c in n.find_children("*", "Button", true, false):
		out.append(str((c as Button).text))
	return out


func _card(map: Dictionary, pro: bool) -> Array:
	var co: Control = CornerOverlay.new()
	root.add_child(co)
	co.build({"worked": "", "hurt": "", "why": "", "call": "", "pro": pro, "body_map": map}, ["Lucy", "Mara"])
	var t := _texts(co)
	root.remove_child(co)
	co.queue_free()
	return t


func _initialize() -> void:
	# Her: a cut over the left eye (31) and a swollen right eye (50). Her opponent's map differs (one sore nose).
	var cut := BodyMap.fresh()
	cut["a"]["places"] = {"head": 60.0, "left_eye": 31.0, "right_eye": 50.0, "nose": 80.0, "left_ribs": 70.0, "right_ribs": 66.0}
	cut["a"]["cuts"] = {"left_eye": true}
	cut["b"]["places"] = {"head": 75.0, "left_eye": 90.0, "right_eye": 85.0, "nose": 49.0, "left_ribs": 92.0, "right_ribs": 60.0}
	var clean := BodyMap.fresh()
	clean["a"]["places"] = {"head": 70.0, "left_eye": 90.0, "right_eye": 88.0, "nose": 76.0, "left_ribs": 58.0, "right_ribs": 61.0}
	clean["b"]["places"] = {"head": 64.0, "left_eye": 52.0, "right_eye": 95.0, "nose": 90.0, "left_ribs": 80.0, "right_ribs": 72.0}

	var am := _card(cut, false)
	var am_line := "\n".join(am)
	print("AMATEUR CUT: ", am.filter(func(s): return str(s).find("cut") >= 0 or str(s).find("eye") >= 0))
	_check(am_line.find("No cut, no swollen eye") < 0, "an amateur corner with a cut does not say 'No cut, no swollen eye'")
	_check(am_line.find("cutman") < 0, "an amateur corner names no cutman (there is none)")
	_check(am_line.to_lower().find("left eye " + BandWords.word(31.0)) >= 0, "it says the left eye is %s" % BandWords.word(31.0))
	_check(am_line.to_lower().find("cut over the left eye") >= 0, "it says where the cut is")
	_check(am_line.find("right eye " + BandWords.word(50.0)) >= 0, "it says the right eye is %s" % BandWords.word(50.0))
	_check(not am.has("CUTMAN"), "no CUTMAN heading in an amateur corner")

	var am_clean := "\n".join(_card(clean, false))
	_check(am_clean.find("No cut, no swollen eye.") >= 0, "a clean amateur face says so")
	_check(am_clean.find("cutman") < 0, "a clean amateur corner names no cutman either")

	var pro := _card(cut, true)
	_check(pro.has("CUTMAN") and pro.has("Close the cut"), "a pro corner with a cut offers the cutman's jobs")
	_check("\n".join(pro).find("No cut, no swollen eye") < 0, "a pro corner with a cut never says 'no cut'")
	var pro_clean := "\n".join(_card(clean, true))
	_check(pro_clean.find("No cut, no swollen eye: the cutman waits.") >= 0, "a clean pro face: the cutman waits")
	print("CORNER_FACE_LINE failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)
