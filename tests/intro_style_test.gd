extends SceneTree
## S436 the fight intro's plan and clock, pure (no stage). Two bars the seat rounds failed:
## 1. the two corners never show the same clip in the same segment, nor the same name call (IntroStyle);
## 2. the camera is on the boxer whose name is being called, and on the tape while the tape is up (FightIntro's ONE
##    clock: the seat's round had the shots 4.5 s ahead of the cues).
##   <godot.exe> --headless --audio-driver Dummy --path . --script res://tests/intro_style_test.gd

const IntroStyle := preload("res://scripts/fight3d/IntroStyle.gd")
const FightIntro := preload("res://scripts/fight3d/FightIntro.gd")
const VersusLive := preload("res://scripts/ui/VersusLive.gd")

## The clips a boxer really has (tools: the stage's AnimationPlayer, S436) and their lengths.
const LEN := {"pro_win_v1": 7.90, "pro_win_v2": 4.87, "pro_win_v3": 4.93, "pro_win_v4": 6.87, "pro_win_v5": 7.33, "pro_win_v6": 5.30,
	"pro_win_v7": 7.53, "mc_win": 8.27, "rk_shadowboxing_a": 11.87, "rk_shadowboxing_b": 5.80, "rk_boxing": 15.47, "cmu_13_17": 40.30,
	"cmu_13_18": 24.97, "cmu_14_01": 46.60, "cmu_14_02": 45.17, "ow_bounce_idle": 2.20, "pro_idle_fidget_v1": 5.13,
	"pro_idle_fidget_v8": 11.27, "mc_fidget": 5.50, "pro_idle_fidget_v4": 2.47, "pro_idle_fidget_v3": 1.80, "pro_idle": 1.60}
const PEOPLE := {
	"showman": {"confidence": 80.0, "discipline": 50.0, "temper": 50.0},
	"worker": {"confidence": 55.0, "discipline": 75.0, "temper": 40.0},
	"nervous": {"confidence": 30.0, "discipline": 50.0, "temper": 40.0},
	"default": {"confidence": 55.0, "discipline": 50.0, "temper": 50.0},
}

var failures := 0
var checks := 0


func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		print("FAIL " + what)


func _has(c: String) -> bool:
	return LEN.has(c)


func _len(c: String) -> float:
	return float(LEN.get(c, 0.0))


func _initialize() -> void:
	for style in PEOPLE:
		_check(IntroStyle.classify(PEOPLE[style]) == style, "classify %s" % style)
	_check(IntroStyle.classify({}) == "default", "no personality = default")
	_check(IntroStyle.from_name("Liam Doherty") == IntroStyle.from_name("Liam Doherty"), "an opponent's made personality repeats")
	# 1. every pair of styles, 40 bouts each: never the same clip at the same time, never the same name call
	var pairs := 0
	var styles_seen := {}
	for a in PEOPLE:
		for b in PEOPLE:
			for seed in 40:
				var pl: Array = IntroStyle.plan_pair(PEOPLE[a], PEOPLE[b], seed * 7919 + 13, _has, _len, 5)
				pairs += 1
				_check(IntroStyle.same_clip_s(pl[0], pl[1]) == 0.0, "%s v %s seed %d: the same clip at the same time" % [a, b, seed])
				for p in pl:
					var plan: Dictionary = p
					_check((plan["warm"] as Array).size() == 5, "%s v %s seed %d: a warm-up segment is empty" % [a, b, seed])
					for w in plan["warm"]:
						_check(_has(str(w["clip"])) and float(w["to"]) > float(w["from"]) and float(w["to"]) <= _len(str(w["clip"])) + 0.001,
							"%s seed %d: a window outside its clip (%s)" % [a, seed, str(w)])
					styles_seen[str(plan["style"])] = true
	_check(styles_seen.size() == 4, "all four styles planned")
	# what each style is FOR: a showman celebrates (warm-up and name call), a worker shadow-boxes and raises a glove
	var show: Dictionary = IntroStyle.plan(PEOPLE["showman"], 5, _has, _len)
	_check(str(show["warm"][0]["kind"]) == "win" and str(show["name"]["clip"]).contains("win"), "a showman celebrates")
	var work: Dictionary = IntroStyle.plan(PEOPLE["worker"], 5, _has, _len)
	_check(str(work["warm"][0]["kind"]) == "shadow" and str(work["name"]["clip"]) == "" and float(work["name"]["raise_s"]) > 2.0, "a worker shadow-boxes, one glove up")
	var nerv: Dictionary = IntroStyle.plan(PEOPLE["nervous"], 5, _has, _len)
	_check(float(nerv["name"]["raise_s"]) < 1.5, "a nervous boxer's glove is up only a moment")
	# the control arm: with ONE clip in the world the two cannot differ, and the ruler must say so
	var one := func(c: String) -> bool: return c == "ow_bounce_idle"
	var same: Array = IntroStyle.plan_pair(PEOPLE["default"], PEOPLE["default"], 3, one, _len, 3)
	_check((same[1]["warm"] as Array).is_empty() or IntroStyle.same_clip_s(same[0], same[1]) == 0.0, "one clip in the world: blue takes none rather than red's")
	var forced := {"warm": [{"clip": "x"}], "name": {"clip": "w"}}
	_check(IntroStyle.same_clip_s(forced, forced) == IntroStyle.SEG_S + IntroStyle.NAME_S, "the ruler reads a shared clip")
	# the tape's two live figures (VersusLive): never the same take, whatever the bout
	for k in 200:
		_check(VersusLive.take_for(false, k * 7919 - 400000) != VersusLive.take_for(true, k * 104729 - 400000), "tape figures on the same take (key %d)" % k)
	for tk in VersusLive.TAKES_LEFT:
		_check(not VersusLive.TAKES_RIGHT.has(tk), "take %s is in both sides' lists" % tk)
	# 2. ONE clock: where the camera is when each cue fires
	_check(_shot_at(_cue("name_red")) == "red" and _shot_at(_cue("lower_red") - 0.01) == "red", "the red name call is filmed on red")
	_check(_shot_at(_cue("name_blue")) == "blue" and _shot_at(_cue("lower_blue") - 0.01) == "blue", "the blue name call is filmed on blue")
	_check(_shot_at(_cue("tape")) == "tape" and _shot_at(_cue("untape")) == "tape", "the tape is up on the tape shot")
	_check(_shot_at(_cue("walk") + 0.01) == "broadcast" and _shot_at(_cue("touch")) == "two_shot", "the walk on the wide lens, the touch on the two-shot")
	_check(_cue("lower_red") - _cue("raise_red") >= 2.0 and _cue("lower_blue") - _cue("raise_blue") >= 2.0, "each name call holds 2 s or more")
	_check(_cue("tape") >= 6.0, "6 s or more of warm-up before the tape")
	var shots: Array = FightIntro.SHOTS
	for i in shots.size() - 1:
		_check(float(shots[i + 1][0]) - float(shots[i][0]) >= 2.0, "shot %s is under 2 s" % str(shots[i][1]))
	var cues: Array = FightIntro.CUES
	for i in cues.size() - 1:
		_check(float(cues[i + 1][0]) >= float(cues[i][0]), "cue %s is out of order" % str(cues[i + 1][1]))
	_check(float(cues[cues.size() - 1][0]) < FightIntro.LENGTH_S, "the bell rings before the intro ends")
	print("INTRO_STYLE pairs=%d checks=%d failures=%d" % [pairs, checks, failures])
	quit(0 if failures == 0 else 1)


func _cue(nm: String) -> float:
	for c in FightIntro.CUES:
		if str(c[1]) == nm:
			return float(c[0])
	_check(false, "no cue " + nm)
	return -1.0


func _shot_at(t: float) -> String:
	var due := ""
	for s in FightIntro.SHOTS:
		if float(s[0]) <= t:
			due = str(s[1])
	return due
