extends SceneTree
## S514 FIGHTWEEK3 favours earned: THE LATE ASK (scripts/state/LateAskWire.gd, scripts/ui/LateAskCard.gd; map
## ops/research/AMATEURWEEK1_MAP_V6_S455.md s7-8). A quick-start club with Lucy free and ready.
##   1. the ask fires only on the show week's Monday (show - 5), through the real day loop (Sim.step_day ->
##      GymSpend.day_events), for a show whose seeded dice fall under 1 in 6; it opens the red need (act lateask);
##   2. the card's header names the host and the boxer, its rows never name the boxer;
##   3. yes: the bout on that show, a fight week, short notice (never rolled for a pull-out), the host on the bout,
##      +1 favour with the host;
##   4. no: no bout, favours unchanged, and the same show never asks again;
##   5. not ready (a bout already booked) or one of ours already on the show: no ask;
##   6. the rate: over 600 shows with a ready boxer the host asks 12-22 in 100 (ASK_CHANCE 1 in 6).
## godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/late_ask_test.gd

const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const Region := preload("res://scripts/state/Region.gd")
const LateAskWire := preload("res://scripts/state/LateAskWire.gd")
const PullOutWire := preload("res://scripts/state/PullOutWire.gd")
const FightWeekEvents := preload("res://scripts/rules/FightWeekEvents.gd")
const FightWeekPlan := preload("res://scripts/state/FightWeekPlan.gd")
const LateAskCard := preload("res://scripts/ui/LateAskCard.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _club() -> Career:
	var c := Career.quick_start()
	c.seed = 11
	c.applicant = {}
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	return c


## The first show day after `from` whose dice ask (asks = true) or hold (false) for this seed.
func _show(c: Career, from: int, asks: bool) -> int:
	var d := from
	while not Region.is_show_day(d) or (LateAskWire.roll_of(c.seed, d) < FightWeekEvents.ASK_CHANCE) != asks:
		d += 1
	return d


## Steps the real day loop onto the show week's Monday.
func _to_monday(c: Career, show: int) -> void:
	c.day = FightWeekEvents.roll_day(show) - 1
	Sim.step_day(c)


func _need(c: Career) -> Dictionary:
	for n in Needs.blockers(c):
		if str(n["act"]) == "lateask":
			return n
	return {}


func _initialize() -> void:
	_asks_and_yes()
	_no_and_once()
	_not_ready()
	_rate()
	print("LATE_ASK %s fails=%d" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(1 if failures > 0 else 0)


func _asks_and_yes() -> void:
	var c := _club()
	var f: Dictionary = c.fighters[0]
	var show := _show(c, c.day + 40, true)
	c.day = FightWeekEvents.roll_day(show) - 2
	Sim.step_day(c)
	_check(not LateAskWire.is_open(f), "1a no ask the day before the Monday")
	Sim.step_day(c)
	_check(c.day == show - FightWeekEvents.ROLL_DAYS_OUT and LateAskWire.is_open(f), "1b the ask opens on the show week's Monday (day %d, show %d)" % [c.day, show])
	var n := _need(c)
	_check(bool(n.get("red", false)) and str(n.get("arg", "")) == str(f["id"]), "1c the red need lateask (%s)" % str(n.get("t", "")))
	var host := str(f["late_ask"]["host"])
	var v := LateAskCard.view(c, f)
	_check(str(v["head"]).contains(host.to_upper()) and str(v["head"]).contains(str(f["name"]).to_upper()), "2a the header names the host and the boxer")
	var named := false
	for col in v["cols"]:
		for r in col["rows"]:
			named = named or str(r["text"]).contains(str(f["first"]))
	_check(not named, "2b no row names the boxer (S448)")
	var before := FightWeekPlan.favours(c, host)
	var why := LateAskWire.answer(c, str(f["id"]), true)
	var b: Dictionary = f.get("bout", {})
	_check(why == "" and int(b.get("day", -1)) == show and bool(b.get("fight_week", false)) and bool(b.get("short_notice", false))
		and str(b.get("host", "")) == host, "3a yes: the bout on that show, a short-notice fight week at the host (%s)" % why)
	_check(FightWeekPlan.favours(c, host) == mini(before + 1, FightWeekEvents.FAVOURS_MAX), "3b +1 favour with the host (%d -> %d)" % [before, FightWeekPlan.favours(c, host)])
	_check(not PullOutWire.eligible(f) and not LateAskWire.is_open(f) and _need(c).is_empty(), "3c never rolled for a pull-out; the need is gone")


func _no_and_once() -> void:
	var c := _club()
	var f: Dictionary = c.fighters[0]
	var show := _show(c, c.day + 40, true)
	_to_monday(c, show)
	var host := str(f["late_ask"]["host"])
	var before := FightWeekPlan.favours(c, host)
	_check(LateAskWire.answer(c, str(f["id"]), false) == "" and (f.get("bout", {}) as Dictionary).get("day", -1) != show
		and FightWeekPlan.favours(c, host) == before, "4a no: no bout, favours unchanged")
	LateAskWire.monday(c)
	_check(not LateAskWire.is_open(f), "4b the same show never asks twice")


func _not_ready() -> void:
	var c := _club()
	var f: Dictionary = c.fighters[0]
	var show := _show(c, c.day + 40, true)
	f["booked_fight"] = true
	f["bout"] = {"opp": {}, "day": show + 14, "done": false}
	_to_monday(c, show)
	_check(not LateAskWire.is_open(f), "5a a boxer with a bout booked is not asked")
	var c2 := _club()
	var g: Dictionary = Data.fighter_state(Data.lucy(), c2.day)
	g["id"] = "lucy_b"
	c2.fighters.append(g)
	var show2 := _show(c2, c2.day + 40, true)
	c2.fighters[0]["bout"] = {"opp": {}, "day": show2, "done": false}
	_to_monday(c2, show2)
	_check(LateAskWire.open_for(c2).is_empty(), "5b one of ours already on the show: no ask")


func _rate() -> void:
	var c := _club()
	var asked := 0
	var shows := 0
	var d := c.day + 10
	while shows < 600:
		if Region.is_show_day(d):
			shows += 1
			if FightWeekEvents.asks(LateAskWire.roll_of(c.seed, d), true, true, false):
				asked += 1
		d += 1
	var pct := 100.0 * asked / shows
	_check(pct >= 12.0 and pct <= 22.0, "6 the host asks %.1f in 100 shows (1 in 6 = 16.7)" % pct)
