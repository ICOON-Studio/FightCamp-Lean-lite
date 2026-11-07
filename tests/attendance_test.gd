extends SceneTree
## S395 Attendance: the crowd a bout draws and the room it fills.

const Attendance := preload("res://scripts/rules/Attendance.gd")

var failures := 0


func _initialize() -> void:
	_check(Attendance.of({}) == Attendance.CLUB, "a club show draws the club crowd")
	_check(Attendance.of({"champ": 0}) < Attendance.of({"champ": 6}), "a later championship stage draws more")
	_check(Attendance.of({"champ": 99}) == Attendance.CHAMP[-1], "and never runs off the list")
	_check(Attendance.of({"pro": true, "purse": 100}) == Attendance.PRO_MIN, "a small pro purse still fills a hall")
	_check(Attendance.of({"pro": true, "purse": 99999999}) == Attendance.PRO_MAX, "and a huge one tops out")
	_check(Attendance.room(220) == "hall" and Attendance.room(1800) == "venue" and Attendance.room(9000) == "arena", "the rooms")
	_check(is_zero_approx(Attendance.share(Attendance.CLUB)), "a club crowd is the quiet end")
	_check(is_equal_approx(Attendance.share(Attendance.PRO_MAX), 1.0), "a full arena is the loud end")
	print("ATTENDANCE failures=", failures)
	quit(failures)


func _check(cond: bool, label: String) -> void:
	print(("OK  " if cond else "FAIL ") + label)
	if not cond:
		failures += 1
