extends SceneTree
## S370 WeekCause: the week review names the sessions behind each gain.

const WeekCause := preload("res://scripts/rules/WeekCause.gd")

var failures := 0


func _initialize() -> void:
	var src := {}
	WeekCause.add(src, "power", "Heavy bag", 0.12)
	WeekCause.add(src, "power", "Heavy bag", 0.12)
	WeekCause.add(src, "power", "Strength circuit", 0.10)
	WeekCause.add(src, "power", "Heavy bag", 0.12)
	WeekCause.add(src, "speed", "Speed bag", 0.08)
	_check(WeekCause.words(src, "power") == "from Heavy bag x3, Strength circuit x1", "power names its two sessions, most first: '%s'" % WeekCause.words(src, "power"))
	_check(WeekCause.words(src, "speed") == "from Speed bag x1", "one session: '%s'" % WeekCause.words(src, "speed"))
	_check(WeekCause.words(src, "chin") == "", "a stat nothing trained says nothing")
	WeekCause.add(src, "chin", "Neck work", 0.0)
	WeekCause.add(src, "", "Neck work", 0.1)
	_check(WeekCause.words(src, "chin") == "" and not src.has(""), "a zero gain or no stat is not a cause")
	WeekCause.add(src, "power", "Pads", 0.5)
	WeekCause.add(src, "power", "Rest day", 0.01)
	var top := WeekCause.top(src, "power")
	_check(top.size() == 4 and str(top[0][0]) == "Pads" and WeekCause.words(src, "power") == "from Pads x1, Heavy bag x3",
		"the biggest points lead and only two are named: '%s'" % WeekCause.words(src, "power"))
	print("WEEK_CAUSE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("  ok: " + label)
	else:
		failures += 1
		print("  FAIL: " + label)
