extends SceneTree
## DayJob test: two lost mornings a week, 4-week sponsorship blocks.
## Build plan: ops/research/CLUBWEEK1_BUILD_S485.md, item 1 (DAYJOB1).
## Prints "  ok   <what>" / "  FAIL <what>" per check and ends with
##   DAY_JOB PASS fails=0 or DAY_JOB FAIL fails=<n>.

const DJ := preload("res://scripts/rules/DayJob.gd")

var failures := 0


func _initialize() -> void:
	_test_lost()
	_test_lost_days()
	_test_mornings_left()
	_test_gain_share()
	_test_blocks()
	_test_words()
	if failures == 0:
		print("DAY_JOB PASS fails=0")
	else:
		print("DAY_JOB FAIL fails=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("  ok   ", label)
	else:
		failures += 1
		print("  FAIL ", label)


func _test_lost() -> void:
	_check(DJ.lost(true) == 2, "lost(true) == 2")
	_check(DJ.lost(false) == 0, "lost(false) == 0")


func _test_lost_days() -> void:
	_check(DJ.lost_days(false) == [], "lost_days(false) == []")
	_check(DJ.lost_days(true) == [1, 3], "lost_days(true) == [1, 3]")
	_check(DJ.lost_days(true, [1]) == [2, 3], "lost_days(true, [1]) == [2, 3]")
	_check(DJ.lost_days(true, [3]) == [1, 4], "lost_days(true, [3]) == [1, 4]")
	_check(DJ.lost_days(true, [1, 2, 3]) == [4, 5], "lost_days(true, [1, 2, 3]) == [4, 5]")
	_check(DJ.lost_days(true, [0, 1, 2, 3, 4]) == [5], "lost_days(true, [0, 1, 2, 3, 4]) == [5]")


func _test_mornings_left() -> void:
	_check(DJ.mornings_left(6, true) == 4, "mornings_left(6, true) == 4")
	_check(DJ.mornings_left(1, true) == 0, "mornings_left(1, true) == 0")
	_check(DJ.mornings_left(6, false) == 6, "mornings_left(6, false) == 6")


func _test_gain_share() -> void:
	_check(abs(DJ.gain_share(6, true) - 4.0 / 6.0) < 0.001, "gain_share(6, true) == 4/6 within 0.001")
	_check(DJ.gain_share(0, true) == 1.0, "gain_share(0, true) == 1.0")


func _test_blocks() -> void:
	_check(DJ.block_cost(250) == 1000, "block_cost(250) == 1000")
	_check(DJ.block_end(10) == 38, "block_end(10) == 38")


func _test_words() -> void:
	_check(DJ.day_word(1, [1, 3]) == "Work", "day_word(1, [1, 3]) == Work")
	_check(DJ.day_word(2, [1, 3]) == "", "day_word(2, [1, 3]) == empty")
	_check(DJ.line(true) == "Works 2 mornings a week (Tue, Thu)", "line(true) == Works 2 mornings a week (Tue, Thu)")
	_check(DJ.line(false) == "", "line(false) == empty")
