extends SceneTree
## S519 club week v11 3.5: half the gym sponsorship ($125, 1 work morning - Tue) between the full stipend (0 lost) and
## a day job (2 lost, his Q-243). Test club boxers (Lucy, Kira - different stats and classes): the work mornings, the
## stat gain share (5/6), the salary, the loyalty moves (+3 up from nothing, -4 down from full), the act, and the Training
## model's WORK tile. Prints HALF_SPONSOR failures=N.

const DayJob := preload("res://scripts/rules/DayJob.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const TestClub := preload("res://scripts/state/TestClub.gd")
const ClubWeek := preload("res://scripts/state/ClubWeek.gd")

var _fails := 0


func _initialize() -> void:
	_check(DayJob.lost_days(true, [], 1) == [1], "half: Tuesday only")
	_check(DayJob.lost_days(true, [1], 1) == [2], "half on a Tuesday rest: Wednesday")
	_check(DayJob.lost_days(true) == [1, 3], "a day job: Tuesday and Thursday as before")
	_check(DayJob.count_of({"day_job": true, "half_job": true}) == 1 and DayJob.count_of({"day_job": true}) == 2 and DayJob.count_of({"day_job": true, "pro": true}) == 0, "count_of: 1 / 2 / pro 0")
	var c := Career.quick_start()
	c.seed = 7
	TestClub.make(c)
	var lucy: Dictionary = c.fighters[0]
	var kira: Dictionary = c.fighters[1]
	GymSpend.set_stipend(c, lucy, true)
	GymSpend.set_stipend(c, kira, false)
	var l0 := Loyalty.value(lucy)
	var k0 := Loyalty.value(kira)
	var g_full := GymSpend.gain(c, "power", lucy)
	_check(GymSpend.set_half(c, lucy) == "" and bool(lucy["half_job"]) and bool(lucy["day_job"]), "Lucy full -> half")
	_check(int(lucy["weekly_salary"]) == 125, "half pays $125: %d" % int(lucy["weekly_salary"]))
	_check(Loyalty.value(lucy) == l0 - 4, "down from full: -4 loyalty (%d -> %d)" % [l0, Loyalty.value(lucy)])
	_check(is_equal_approx(GymSpend.gain(c, "power", lucy), g_full * 5.0 / 6.0), "gain share 5/6")
	_check(GymSpend.set_half(c, lucy) == "already so", "half twice: already so")
	main_act_half(c, kira)
	_check(bool(kira.get("half_job", false)) and Loyalty.value(kira) == k0 + 3, "Kira day job -> half by the act: +3 loyalty (%d -> %d)" % [k0, Loyalty.value(kira)])
	if posmod(c.day, 7) < 5:
		var m := ClubWeek.model(c, str(lucy["id"]), 0)
		var works: Array = []
		for d in m["days"]:
			if bool((d["am"] as Dictionary).get("work", false)):
				works.append(int(d["dow"]))
		_check(works.size() == 1, "the Training week shows one WORK morning: %s" % [works])
	GymSpend.set_stipend(c, lucy, true)
	_check(not lucy.has("half_job") and not bool(lucy["day_job"]) and int(lucy["weekly_salary"]) == 250, "back to the full stipend clears half")
	GymSpend.set_stipend(c, kira, false)
	_check(not kira.has("half_job") and DayJob.count_of(kira) == 2, "half -> stop = a day job, 2 mornings")
	print("HALF_SPONSOR failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)


func main_act_half(c: Career, f: Dictionary) -> void:
	GymSpend.set_half(c, f)


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
		print("FAIL ", what)
	else:
		print("ok   ", what)
