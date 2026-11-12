extends SceneTree
## DEFECTS1 (S439 audit: "five word sets for the same bands"): every screen that names a BodyMap band reads ONE table,
## scripts/rules/BandWords.gd. The hover tip, the close-up line, the damage tile, the pinned result cards, the face
## summary and the holo's legend say the same word for the same place at the same value.
##   godot --headless --audio-driver Dummy --path . --script res://tests/band_words_test.gd

const BandWords := preload("res://scripts/rules/BandWords.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const BodyTip := preload("res://scripts/ui/BodyTip.gd")
const CalloutLine := preload("res://scripts/ui/CalloutLine.gd")
const ResultMarks := preload("res://scripts/ui/ResultMarks.gd")
const BodyCallouts := preload("res://scripts/ui/BodyCallouts.gd")
const FaceMark3D := preload("res://scripts/rules/FaceMark3D.gd")
const Aftermath := preload("res://scripts/rules/Aftermath.gd")

## The files that named bands with their own dictionaries before DEFECTS1.
const READERS := ["res://scripts/ui/BodyTip.gd", "res://scripts/ui/CalloutLine.gd", "res://scripts/rules/Aftermath.gd",
	"res://scripts/ui/ResultMarks.gd", "res://scripts/rules/FaceMark3D.gd", "res://scripts/fight3d/BodyPanels.gd"]

const ONE_JAB := {"n": 1, "kinds": {"jab": 1}, "big": 0}
const ONE_HOOK := {"n": 1, "kinds": {"body_hook": 1}, "big": 0}

var _fails := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
	print("%s %s" % ["ok  " if ok else "FAIL", what])


func _initialize() -> void:
	# The table itself: four bands, the result page's words, the doctor only during a fight.
	_check(BandWords.word(80.0) == "fine" and BandWords.word(50.0) == "sore" and BandWords.word(30.0) == "badly hurt"
		and BandWords.word(10.0) == "badly hurt", "after a fight: fine, sore, badly hurt, badly hurt")
	_check(BandWords.live(50.0) == BandWords.word(50.0) and BandWords.live(30.0) == BandWords.word(30.0)
		and BandWords.live(10.0) == "doctor may stop it", "in a fight the same words, and the doctor at the last band")
	# Every reader, the same value, the same word. Values on both sides of each boundary (55 / 35 / 15).
	for v in [100.0, 56.0, 55.0, 36.0, 35.0, 16.0, 15.0, 0.0]:
		var tip := BodyTip.text("left_eye", v, {}).get_slice("\n", 0)
		_check(tip == "Left eye: %s (%d/100)" % [BandWords.live(v), int(round(v))], "hover tip at %.0f: '%s'" % [v, tip])
		var head_line := CalloutLine.line("HEAD", v, ONE_JAB, false)
		_check(head_line.ends_with(BandWords.live(v)), "head close-up at %.0f ends with '%s': '%s'" % [v, BandWords.live(v), head_line])
		var rib_line := CalloutLine.line("LIVER", v, ONE_HOOK, true)
		_check(rib_line.ends_with(BandWords.body(v)), "liver close-up at %.0f ends with '%s': '%s'" % [v, BandWords.body(v), rib_line])
		var map := BodyMap.fresh()
		map["a"]["places"]["right_ribs"] = v
		map["b"]["places"]["nose"] = minf(v + 7.0, 100.0)
		var card := ResultMarks.line(map, "a", BodyCallouts.SPOTS[1])
		_check(card.ends_with(BandWords.word(v)), "result card at %.0f ends with '%s': '%s'" % [v, BandWords.word(v), card])
		if BodyMap.band(v) != "fine":
			var face := FaceMark3D.summary({"left_eye": v}, {})
			_check(face == "Left eye " + BandWords.word(v), "face summary at %.0f: '%s'" % [v, face])
	# One table: no reader keeps its own band dictionary or band legend.
	for path in READERS:
		var src := FileAccess.get_file_as_string(path)
		var own := false
		for b in ["fine", "hurt", "critical", "doctor"]:
			if src.find('"%s": "' % b) >= 0:
				own = true
		_check(not own, "%s keeps no band word dictionary of its own" % path.get_file())
		_check(src.find("Critical: badly hurt") < 0, "%s has no legend in the code's band names" % path.get_file())
	print("BAND_WORDS failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)
