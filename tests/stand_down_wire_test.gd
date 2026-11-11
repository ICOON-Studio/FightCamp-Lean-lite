extends SceneTree
## S434 STANDDOWN1 wiring (F6): after a bout, Injuries.after_bout sets the stand-down and PadWeek rests the sparring
## nights inside it, through the game's own day step (Sim.step_day). Control arm: the same fighter without a stand-down
## keeps her Thursday sparring. Population: Lucy (Data.lucy, base phase: one sparring night, Thursday) in a quick-start gym.

const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const StandDown := preload("res://scripts/rules/StandDown.gd")

var checks := 0
var failures := 0


func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		failures += 1
	print("%s %s" % ["PASS" if ok else "FAIL", what])


func _career(dmg: float, outcome := "win", stopped := "") -> Array:
	var c := Career.quick_start()
	c.seed = 1
	var f: Dictionary = Data.fighter_state(Data.lucy(), c.day)
	c.fighters.append(f)
	c.day = 12   # a Saturday (Clock: day 0 is a Monday): fight night
	if dmg >= 0.0:
		Injuries.after_bout(c, f, {"stopped": stopped, "outcome": outcome, "damage": {"a": dmg}, "rounds": [1, 2, 3]})
	return [c, f]


## Steps the game to the next Monday and returns that week's evenings as the game lays them.
func _next_week(c: Career, f: Dictionary) -> Array:
	Sim.step_day(c)
	while posmod(c.day, 7) != 0:
		Sim.step_day(c)
	Sim.step_day(c)   # Monday runs: WeekPhase.sync puts phase_day on this week
	return PadWeek.evenings(f)


func _initialize() -> void:
	# Control: no stand-down, the base week spars on Thursday.
	var ctl := _career(-1.0)
	var ctl_evs := _next_week(ctl[0], ctl[1])
	_check(str(ctl_evs[3]) == "sparring", "control: without a stand-down Lucy spars on Thursday (%s)" % str(ctl_evs))
	# Hurt (damage 25 -> head place 45): 10 days from Saturday day 12, open on day 23 (Friday of the next week).
	var hurt := _career(25.0)
	var c: Career = hurt[0]
	var f: Dictionary = hurt[1]
	var sd: Dictionary = f.get("stand_down", {})
	_check(str(sd.get("band", "")) == "hurt" and int(sd.get("open_day", 0)) == 23, "a 25-damage bout: hurt, sparring opens on day 23 (%s)" % str(sd))
	var said := c.news.any(func(n): return str(n["t"]).begins_with("%s: no sparring until " % f["first"]) and str(n["t"]).contains("25 damage"))
	_check(said, "the news says until when and why")
	var evs := _next_week(c, f)
	_check(str(evs[3]) == "rest", "Thursday day 17 sits in the stand-down: the night rests (%s)" % str(evs))
	var evs2 := _next_week(c, f)
	_check(str(evs2[3]) == "sparring", "the week after it opens, Thursday spars again (%s)" % str(evs2))
	# Critical (damage 40 -> head place 12): 21 days from Saturday day 12, open on day 34: Thursdays 17, 24, 31 rest, 38 spars.
	var crit := _career(40.0)
	var cc: Career = crit[0]
	var cf: Dictionary = crit[1]
	cf.erase("injury")   # the bout's own injury roll may also land; this check is the stand-down's alone
	var th: Array = []
	for _w in 4:
		th.append(str(_next_week(cc, cf)[3]))
		cf.erase("injury")
	_check(th == ["rest", "rest", "rest", "sparring"], "critical: three Thursdays rest, the fourth spars (%s)" % str(th))
	# Fine (damage 10): 5 days, open on Friday day 18, so Thursday day 17 still rests; no news line for a fine head.
	var fine := _career(10.0)
	var fc: Career = fine[0]
	var ff: Dictionary = fine[1]
	_check(not fc.news.any(func(n): return str(n["t"]).contains("no sparring until")), "a fine head makes no news")
	_check(str(_next_week(fc, ff)[3]) == "rest", "fine: Thursday day 17 is still inside the 5 days")
	# A head-stoppage loss has its suspension, not a stand-down.
	var ko := _career(40.0, "loss", "ko")
	_check((ko[1] as Dictionary).get("stand_down", {"x": 1}).is_empty(), "a head-stoppage loss sets no stand-down (the suspension covers it)")
	print("STAND_DOWN_WIRE checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)
