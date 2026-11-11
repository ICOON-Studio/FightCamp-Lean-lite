extends SceneTree
## S435 BEAT_TALLY (ANIM_AUDIT_S435 A8): the counter that says what each punch beat really got. Pure part: the kind of a
## take, the line, and the table of every move in every context with the clips that are on disk (how many fall back to
## the plain take today). The real-bout numbers come from tools/human_fight_film.gd, which prints the same line.

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const BeatTally := preload("res://scripts/fight3d/BeatTally.gd")
const BAKED := "res://assets/anim/baked"
const PRO_PREFIX := "mc_Box1_M3_"

var failures := 0


func _initialize() -> void:
	# 1. The kind of a take.
	_check(BeatTally.kind("jab", {}, "pro_left_jab_a") == "plain", "a plain jab on a plain take is plain")
	_check(BeatTally.kind("jab", {"step": true}, "pro_left_jab_ft") == "context", "a stepping jab on its stepping take is context")
	_check(BeatTally.kind("cross", {"big": true}, "pro_right_cross_b") == "fallback", "a big cross on a plain take is a fallback")
	_check(BeatTally.kind("cross", {"miss": true}, "pro_right_cross") == "fallback", "a missed cross on the stem is a fallback")
	_check(BeatTally.kind("jab", {"step": true}, "rk_jab_1") == "plain", "the captured jab is the wanted take")
	_check(BeatTally.kind("jab", {}, "jab") == "native", "the bare move name is native")
	_check(BeatTally.kind("clinch", {}, "pro_clinch") == "native", "not a punch: native")
	# 2. take() counts, and the line carries every key (a reader can rely on the columns).
	BeatTally.reset()
	BeatTally.take("jab", {}, "pro_left_jab_a")
	BeatTally.take("cross", {"big": true}, "pro_right_cross_b")
	BeatTally.take("cross", {"big": true}, "pro_right_cross_b")
	BeatTally.add("started")
	_check(BeatTally.count("asked") == 3 and BeatTally.count("take_plain") == 1 and BeatTally.count("take_fallback") == 2, "three beats: one plain, two fallbacks (%s)" % BeatTally.line())
	_check(BeatTally.fallback_line() == "BEAT_FALLBACKS cross>pro_right_cross_b x2", "the fallbacks are named: %s" % BeatTally.fallback_line())
	var line := BeatTally.line()
	for k in BeatTally.KEYS:
		_check(line.contains(" %s=" % k), "the line has %s" % k)
	BeatTally.reset()
	_check(BeatTally.count("asked") == 0 and BeatTally.fallback_line() == "BEAT_FALLBACKS none", "reset clears it")
	# 3. The table on today's disk: every move x context through the game's own BeatClips.punch.
	var have := {}   # FightClips loads every mc_Box1_M3_<Name>.res as pro_<name>, lower case
	for file in DirAccess.get_files_at(BAKED):
		var base := file.trim_suffix(".remap").trim_suffix(".res")
		if base.begins_with(PRO_PREFIX):
			have["pro_" + base.trim_prefix(PRO_PREFIX).to_lower()] = true
	_check(have.size() >= 100, "the Punch PRO takes are on disk (%d)" % have.size())
	var on_disk := func(n: String) -> bool: return have.has(n)
	var contexts := {"plain": {}, "big": {"big": true}, "miss": {"miss": true}, "tired": {"tired": true}, "step": {"step": true}}
	BeatTally.reset()
	var guessed: Array = []
	for move in BeatClips.PUNCH:
		for name in contexts:
			var ctx: Dictionary = (contexts[name] as Dictionary).duplicate()
			ctx["roll"] = 0.0
			var clip := BeatClips.punch(str(move), ctx, on_disk)
			var before := BeatTally.count("contact_guess")
			BeatTally.take(str(move), ctx, clip)
			if BeatTally.count("contact_guess") > before and not guessed.has(clip):
				guessed.append(clip)
	print("  TABLE ", BeatTally.line())
	print("  TABLE ", BeatTally.fallback_line())
	print("  TABLE contact guessed for: ", guessed)
	_check(BeatTally.count("asked") == BeatClips.PUNCH.size() * contexts.size(), "every move in every context was asked")
	_check(BeatTally.count("take_native") == 0, "no move falls to an old native clip or a bare name on disk (%d)" % BeatTally.count("take_native"))
	_check(BeatTally.count("take_plain") == BeatClips.PUNCH.size(), "each move has a plain take on disk")
	_check(BeatTally.count("take_context") + BeatTally.count("take_fallback") == BeatClips.PUNCH.size() * 4, "the 28 special cases split into context and fallback")
	# The bar: a fallback count the next task must not make WORSE. Today's number is printed above; the bound is its ceiling.
	_check(BeatTally.count("take_fallback") <= 14, "at most 14 of 28 special cases fall back to the plain take (%d)" % BeatTally.count("take_fallback"))
	print("BEAT_TALLY_TEST failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
