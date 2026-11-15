extends SceneTree
## S485 CLUBWEEK1: the coach's film nights in a fight week (FightWeekPlan.film_seat over FilmSeats). Two film nights a
## week with a sessional coach, first come first served across boxers fighting the same week; the third watches alone.

const FightWeekPlan := preload("res://scripts/state/FightWeekPlan.gd")
const FilmSeats := preload("res://scripts/rules/FilmSeats.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _initialize() -> void:
	var c := Career.quick_start()
	var d := c.day + 6
	var me := {"id": "me", "bout": {"day": d}}
	var a := {"id": "a", "bout": {"day": d + 2}}
	var b := {"id": "b", "bout": {"day": d - 3}}
	var far := {"id": "far", "bout": {"day": d + 14, "fw_film": c.day}}
	c.fighters = [me, a, b, far]
	_check(FightWeekPlan.coach_kind(c) == "sessional", "the club's coach is sessional: %d film nights" % FilmSeats.owned("sessional"))
	_check(FightWeekPlan.film_seat(c, me) == FilmSeats.COACHED and FightWeekPlan.film_line(c, me) == "", "no film night taken: coached, no line")
	a["bout"]["fw_film"] = c.day
	_check(FightWeekPlan.film_seat(c, me) == FilmSeats.COACHED, "one taken this week: still coached")
	b["bout"]["fw_film"] = c.day
	_check(FightWeekPlan.film_taken(c, me) == 2, "a bout two weeks off does not count (taken %d)" % FightWeekPlan.film_taken(c, me))
	_check(FightWeekPlan.film_seat(c, me) == FilmSeats.ALONE, "two taken this week: she watches alone")
	var line := FightWeekPlan.film_line(c, me)
	_check(line.contains("watches alone") and line.contains("3 boxers"), "the fight week screen says so (%s)" % line)
	c.coach["full_time"] = true
	_check(FightWeekPlan.film_seat(c, me) == FilmSeats.COACHED, "a full-time coach has a third film night")
	print("FILM_SEAT_WIRE %s fails=%d" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(0 if failures == 0 else 1)
