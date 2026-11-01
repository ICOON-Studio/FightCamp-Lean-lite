extends SceneTree
## S333 THE READ: how many looks at an opponent's habit she needs before she reads it (Ring IQ + film study), when she
## pulls the trigger (her temperament, moved by the corner's "Wait for it" / "Take it now"), whether the counter lands
## (the read x her mastery of the counter), and the opponent dropping a habit after it is punished.

const R := preload("res://scripts/rules/TheRead.gd")

var _fails := 0


func _initialize() -> void:
	# Read speed: the expert needs about 5 looks (Milazzo 2016), the novice many more; film study shortens it.
	_check(is_equal_approx(R.looks_needed(90.0, false), R.LOOKS_EXPERT), "Ring IQ 90 reads in %.1f looks" % R.LOOKS_EXPERT)
	_check(R.looks_needed(35.0, false) >= R.LOOKS_NOVICE - 0.01, "Ring IQ 35 needs the novice's looks")
	_check(R.looks_needed(60.0, false) > R.looks_needed(75.0, false), "a higher Ring IQ reads sooner")
	_check(R.looks_needed(60.0, true) < R.looks_needed(60.0, false), "film study reads sooner")

	# The meter: an expert reads a habit inside two exchanges of it, a novice not inside one round of it.
	var st := R.start({}, "")
	R.watch(st, "press", 90.0, false)
	_check(R.read(st, "press") < 1.0, "one exchange is not enough even for an expert")
	R.watch(st, "press", 90.0, false)
	_check(R.read(st, "press") >= 1.0, "two exchanges of the same habit and the expert has it")
	var nov := R.start({}, "")
	for k in 3:
		R.watch(nov, "press", 35.0, false)
	_check(R.read(nov, "press") < 0.8, "three exchanges and the novice still guesses (%.2f)" % R.read(nov, "press"))
	_check(R.read(nov, "range") == 0.0, "a habit she has not seen is not read")

	# Film study pre-fills the opponent's main habit.
	var film := R.start({}, "counter")
	_check(is_equal_approx(R.read(film, "counter"), R.FILM_HEAD_START), "film study starts her main habit at %.2f" % R.FILM_HEAD_START)
	_check(R.read(film, "press") == 0.0, "film study shows only her main habit")

	# Temperament: discipline against temper + confidence sets the trigger.
	var patient := {"personality": {"discipline": 85.0, "temper": 30.0, "confidence": 40.0}}
	var gambler := {"personality": {"discipline": 30.0, "temper": 85.0, "confidence": 80.0}}
	_check(R.trigger(patient) > R.trigger(gambler), "the patient fighter waits for a fuller read")
	_check(R.temperament(patient) == "patient" and R.temperament(gambler) == "gambler", "the words: patient / gambler")
	_check(R.trigger(gambler) >= R.TRIGGER_MIN and R.trigger(patient) <= R.TRIGGER_MAX, "triggers stay inside their bounds")
	_check(R.temperament({}) == "steady", "no personality reads steady")

	# The corner moves the trigger: Wait for it raises it, Take it now fires at the read she has.
	var t := R.trigger(gambler)
	_check(R.called(t, "wait", 0.3) > t, "Wait for it raises her trigger")
	_check(R.fires(0.3, R.called(t, "now", 0.3)), "Take it now fires at the read she has")
	_check(not R.fires(0.3, R.called(t, "", 0.3)) or t <= 0.3, "no call: her own trigger decides")

	# Landing: a full read with a mastered counter lands far more than a guess with a raw one.
	var sure := R.land_chance(1.0, 85.0)
	var guess := R.land_chance(0.4, 30.0)
	_check(sure > 0.75 and guess < 0.35, "a read counter lands (%.2f), a guess mostly misses (%.2f)" % [sure, guess])
	_check(R.land_chance(1.0, 85.0) > R.land_chance(1.0, 40.0), "mastery of the counter matters at a full read")

	# Punished twice, she drops the habit and the read on it is gone.
	var p := R.start({}, "")
	for k in 2:
		R.watch(p, "loadup", 90.0, false)
	_check(not R.dropped(p, "loadup"), "an unpunished habit stays")
	R.punish(p, "loadup")
	_check(not R.dropped(p, "loadup"), "one counter is not enough to make her drop it")
	R.punish(p, "loadup")
	_check(R.dropped(p, "loadup") and R.read(p, "loadup") == 0.0, "two counters and she drops the habit")

	# The words for the corner card.
	var line := R.line(0.6, R.trigger(patient), "Pressing")
	_check(line.contains("60") and line.contains("Pressing"), "card line: %s" % line)

	print("THE_READ %s fails=%d" % ["PASS" if _fails == 0 else "FAIL", _fails])
	quit(1 if _fails > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
		print("FAIL ", what)
