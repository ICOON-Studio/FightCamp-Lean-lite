extends SceneTree
## S381 G1 (gym idea 5): the night lines the camp cards' threshold bars mark, and the bar's window. Population: the rule's
## own numbers (BoutRules.CORNER_BODY_POWER 60, CORNER_LONG_TECHNIQUE 61, FADE_STAMINA 60) and Lucy-like stat blocks. S433 CARDIO1: the fade's line is Stamina's.
## S434 CARDIO1: the line moved 64 -> 60 (FADESHARE at fight time, 1,030 bouts: main fades 64.6%, Stamina 60 63.6%;
## Attrs.from_stats starts Stamina 5 under the old mean, and Stamina trains faster than the mean after signing) and the fade is a slope (BoutRules.own_fade), so item 3 reads own_fade, not a flat 1.0.
##   1. night_line: power / technique / stamina have a line at the rule's number; defence and hand speed have none.
##   2. clears_night_line: power and technique strictly past (60.0 no, 60.01 yes), stamina at it or past (63.99 no, 64 yes).
##   3. The fight agrees: fight_power's body / jab-and-move call is strong exactly when the line is cleared, and round 3
##      fades exactly when stamina is not (the bar and the night can never disagree).
##   4. The captions.   5. NightBar.window spans now, the forecast and the tick on whole points; frac stays in 0..1.

const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const NightBar := preload("res://scripts/ui/NightBar.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	# 1.
	_check(float(BoutRules.night_line("power")["at"]) == BoutRules.CORNER_BODY_POWER
		and float(BoutRules.night_line("technique")["at"]) == BoutRules.CORNER_LONG_TECHNIQUE
		and float(BoutRules.night_line("stamina")["at"]) == BoutRules.FADE_STAMINA and BoutRules.FADE_STAMINA == 60.0, "lines at 60 / 61 / 60")
	_check(BoutRules.night_line("defense").is_empty() and BoutRules.night_line("speed").is_empty(), "no line for defence or speed")
	_check(not BoutRules.clears_night_line("defense", 99.0), "a stat with no line never clears")
	# 2.
	_check(not BoutRules.clears_night_line("power", 60.0) and BoutRules.clears_night_line("power", 60.01), "power: past 60")
	_check(not BoutRules.clears_night_line("technique", 61.0) and BoutRules.clears_night_line("technique", 61.2), "technique: past 61")
	_check(not BoutRules.clears_night_line("stamina", 59.99) and BoutRules.clears_night_line("stamina", 60.0),
		"stamina: at 60")
	# 3.
	var base := {"power": 58.0, "speed": 60.0, "technique": 60.0, "defense": 58.0, "conditioning": 62.0, "stamina": 62.0, "fight_iq": 58.0}
	var camp := {"protocol": 2}
	for pw in [59.9, 60.0, 60.1, 62.0]:
		var s := base.duplicate()
		s["power"] = pw
		var strong := BoutRules.fight_power(s, camp, 0, "body") - BoutRules.fight_power(s, camp, 0, "")
		_check(is_equal_approx(strong, BoutRules.CORNER_STRONG if BoutRules.clears_night_line("power", pw) else BoutRules.CORNER_WEAK),
			"body call at power %.1f: +%.1f" % [pw, strong])
	for te in [60.9, 61.0, 61.1]:
		var s := base.duplicate()
		s["technique"] = te
		var strong := BoutRules.fight_power(s, camp, 0, "long") - BoutRules.fight_power(s, camp, 0, "")
		_check(is_equal_approx(strong, BoutRules.CORNER_STRONG if BoutRules.clears_night_line("technique", te) else BoutRules.CORNER_WEAK),
			"jab and move at technique %.1f: +%.1f" % [te, strong])
	var opp := {"rating": 60.0}
	for co in [59.9, 60.0, 60.5, 58.0]:
		var s := base.duplicate()
		s["stamina"] = co
		var fade := float(BoutRules.play_round(2, s, camp, 0, "", opp, 0.5, 0.5)["mine"]) \
			- float(BoutRules.play_round(3, s, camp, 0, "", opp, 0.5, 0.5)["mine"])
		_check(is_equal_approx(fade, BoutRules.own_fade(co)) and (fade > 0.0) == (not BoutRules.clears_night_line("stamina", co)),
			"round-3 fade at stamina %.1f: %.3f (fades exactly when under the line)" % [co, fade])
	# 4.
	_check(BoutRules.night_line_words("power") == "past 60: body call", BoutRules.night_line_words("power"))
	_check(BoutRules.night_line_words("technique") == "past 61: jab and move", BoutRules.night_line_words("technique"))
	_check(BoutRules.night_line_words("stamina") == "Stamina 60: no fade from round 3", BoutRules.night_line_words("stamina"))
	# S434 round 2 (the skeptic: "fade 0.65 of what?"): the words say what the number does - every stat counts that much lower.
	_check(BoutRules.fade_words(58.0) == "tires from round 3, every stat 0.50 lower; no fade from Stamina 60"
		and BoutRules.fade_words(61.0) == "no fade from round 3 (Stamina 60 or more)",
		"the Stamina row's words: %s / %s" % [BoutRules.fade_words(58.0), BoutRules.fade_words(61.0)])
	_check(BoutRules.night_line_words("speed") == "", "no caption for speed")
	# 5.
	var w := NightBar.window(58.8, 60.4, 60.0)
	_check(w == Vector2(57.0, 62.0), "window 58.8 -> 60.4, line 60: %s" % str(w))
	_check(NightBar.frac(60.0, w) > NightBar.frac(58.8, w) and NightBar.frac(60.4, w) > NightBar.frac(60.0, w),
		"now < tick < forecast along the bar")
	w = NightBar.window(66.2, 67.0, 64.0)
	_check(w.x <= 63.0 and w.y >= 68.0, "the line under today still shows: %s" % str(w))
	w = NightBar.window(57.3, 58.3, -1.0)
	_check(w == Vector2(56.0, 60.0), "no line: now -> forecast only %s" % str(w))
	_check(NightBar.frac(10.0, w) == 0.0 and NightBar.frac(99.0, w) == 1.0, "frac clamps")
	print("NIGHT_LINE checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		print("  FAIL: %s" % label)
