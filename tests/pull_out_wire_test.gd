extends SceneTree
## S490 FIGHTWEEK3 piece 1: THE PULL-OUT ROLL and THE FALL-THROUGH CARD (scripts/state/PullOutWire.gd,
## scripts/ui/FallThroughCard.gd; map FIGHTWEEK_SCREEN_V1_CRITIC_DOLA section 6). A quick-start club books an amateur
## fight-week bout through Bouts.accept; the bout day is one whose seeded dice pull the opponent out.
##   1. the roll fires only on its day (bout day - 5), through the real day loop (Sim.step_day -> GymSpend.day_events), once;
##   2. the pull-out opens the red need FELL THROUGH (act fellthrough) and the flag; the card's header names the boxer and
##      the host, its rows never name the boxer;
##   3. take the replacement: a tougher opponent from the class (rating +5 at least), rep_x 2 + short_notice, same night,
##      the fight week stays;
##   4. go home: the bout is gone, mood -6;
##   5. next month: one favour spent with the host, the bout 28 days on, still a fight week at the same host, never rolled
##      again; with no favour it is refused with its why and the card greys it;
##   6. a pro bout and a home bout never roll.
## godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/pull_out_wire_test.gd

const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const PullOutWire := preload("res://scripts/state/PullOutWire.gd")
const FightWeekEvents := preload("res://scripts/rules/FightWeekEvents.gd")
const FightWeekPlan := preload("res://scripts/state/FightWeekPlan.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")
const FallThroughCard := preload("res://scripts/ui/FallThroughCard.gd")
const DarkOverview := preload("res://scripts/ui/DarkOverview.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


## A club with Lucy booked against the first legal opponent of her class on a bout day 8+ days out whose dice fall
## (falls = true) or hold (falls = false).
func _booked(falls: bool) -> Array:
	var c := Career.quick_start()
	c.seed = 7
	c.applicant = {}
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighters[0]
	var day := c.day + 8
	while FightWeekEvents.pulls_out(PullOutWire.roll_of(str(f["id"]), day)) != falls:
		day += 1
	var names: Array = Data.DIVISIONS[f["div"]]["opponents"]
	var own := AmateurBooking.bouts_of(int(f["w"]), int(f["l"]))
	var i: int = Bouts.legal_index(c, names, 0, own)
	var id := "%s:t%d" % [f["id"], c.day]
	f["offers"] = [Bouts._offer(id, c.rival(str(names[i])).duplicate(true), day, c.day + 3, own)]
	Bouts.accept(c, id)
	return [c, f]


## As _booked(true), stepped by the real day loop to the roll day.
func _fell() -> Array:
	var r := _booked(true)
	var c: Career = r[0]
	var f: Dictionary = r[1]
	c.day = FightWeekEvents.roll_day(int(f["bout"]["day"])) - 1
	Sim.step_day(c)
	return r


func _need(c: Career) -> Dictionary:
	for n in Needs.blockers(c):
		if str(n["act"]) == "fellthrough":
			return n
	return {}


func _initialize() -> void:
	_roll_day()
	_replacement()
	_go_home()
	_next_month()
	_no_favour()
	_never_rolls()
	print("PULL_OUT_WIRE %s fails=%d" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(1 if failures > 0 else 0)


func _roll_day() -> void:
	var r := _booked(true)
	var c: Career = r[0]
	var f: Dictionary = r[1]
	var b: Dictionary = f["bout"]
	_check(bool(b.get("fight_week", false)) and str(b.get("host", "")) != "", "an amateur fight-week bout at %s, %d days out" % [b.get("host", ""), int(b["day"]) - c.day])
	var rd := FightWeekEvents.roll_day(int(b["day"]))
	c.day = rd - 1
	PullOutWire.day(c)
	_check(not b.has("rolled") and not PullOutWire.is_open(f), "no roll the day before the roll day")
	Sim.step_day(c)
	b = f["bout"]
	_check(c.day == rd and bool(b.get("rolled", false)), "the day loop rolls on the roll day (bout day - 5)")
	_check(PullOutWire.is_open(f) and str(b["fell"]["host"]) == str(b["host"]) and str(b["fell"]["was"]) == str(b["opp"]["name"]),
		"the dice fall: the bout fell through (%s, was %s)" % [b.get("fell", {}).get("host", ""), b.get("fell", {}).get("was", "")])
	var n := _need(c)
	_check(not n.is_empty() and str(n["t"]).begins_with("FELL THROUGH") and str(n["arg"]) == str(f["id"]), "a red need FELL THROUGH stops the clock")
	_check(Needs.flags(c).any(func(x): return str(x["t"]) == "FELL THROUGH" and bool(x["red"])), "the top bar flags FELL THROUGH")
	_check(str(Needs.go_state(c, false)["cls"]) == "GoBlock", "CONTINUE turns into NEEDS YOU")
	var v := FallThroughCard.view(c, f)
	_check(str(v["head"]).contains(str(f["name"]).to_upper()) and str(v["head"]).contains(str(b["host"]).to_upper()), "the card's header: %s" % v["head"])
	var named := false
	for col in v["cols"]:
		for row in col["rows"]:
			named = named or str(row["text"]).contains(str(f["first"]))
	_check((v["cols"] as Array).size() == 3 and not named, "three answers; no row names the boxer")
	var news := c.news.size()
	b["fell"] = {}
	PullOutWire.day(c)
	_check(not PullOutWire.is_open(f) and c.news.size() == news and int(b.get("stops", 0)) == 1, "the roll fires once (one stop)")
	var held := _booked(false)
	var c2: Career = held[0]
	var f2: Dictionary = held[1]
	c2.day = FightWeekEvents.roll_day(int(f2["bout"]["day"]))
	PullOutWire.day(c2)
	_check(bool(f2["bout"].get("rolled", false)) and not PullOutWire.is_open(f2) and _need(c2).is_empty(), "dice that hold: rolled, no need")


func _replacement() -> void:
	var r := _fell()
	var c: Career = r[0]
	var f: Dictionary = r[1]
	var b: Dictionary = f["bout"]
	var was_name := str(b["opp"]["name"])
	var was_r := float(b["opp"]["rating"])
	var day := int(b["day"])
	var why := PullOutWire.answer(c, str(f["id"]), "take_replacement")
	b = f["bout"]
	_check(why == "", "take the replacement (%s)" % why)
	_check(str(b["opp"]["name"]) != was_name and float(b["opp"]["rating"]) >= was_r + PullOutWire.RATING_UP,
		"a tougher opponent: %s %.1f for %s %.1f" % [b["opp"]["name"], float(b["opp"]["rating"]), was_name, was_r])
	_check(str(c.rival(str(b["opp"]["name"])).get("div", "")) == str(f["div"]), "from the boxer's own class")
	_check(int(b.get("rep_x", 1)) == 2 and bool(b.get("short_notice", false)) and int(b["day"]) == day, "same night, twice the reputation on a win")
	_check(bool(b.get("fight_week", false)) and not PullOutWire.is_open(f) and _need(c).is_empty(), "the fight week stays; the need is gone")


func _go_home() -> void:
	var r := _fell()
	var c: Career = r[0]
	var f: Dictionary = r[1]
	var mood := float(f.get("morale", 60.0))
	var why := PullOutWire.answer(c, str(f["id"]), "go_home")
	_check(why == "" and (f["bout"] as Dictionary).is_empty() and not bool(f["booked_fight"]), "go home: the bout is gone (%s)" % why)
	_check(is_equal_approx(float(f["morale"]), mood + FightWeekEvents.GO_HOME_MOOD), "mood -6 (%.1f -> %.1f)" % [mood, float(f["morale"])])
	_check(_need(c).is_empty() and int(f["next_offer_day"]) > c.day, "no need left; offers come again")


func _next_month() -> void:
	var r := _fell()
	var c: Career = r[0]
	var f: Dictionary = r[1]
	var b: Dictionary = f["bout"]
	var host := str(b["host"])
	var opp := str(b["opp"]["name"])
	var day := int(b["day"])
	var fav := FightWeekPlan.favours(c, host)
	var why := PullOutWire.answer(c, str(f["id"]), "next_month")
	b = f["bout"]
	_check(why == "" and FightWeekPlan.favours(c, host) == fav - 1, "next month: a favour spent with %s (%d -> %d)" % [host, fav, FightWeekPlan.favours(c, host)])
	_check(int(b["day"]) == day + PullOutWire.NEXT_MONTH_DAYS and str(b["opp"]["name"]) == opp and str(b["host"]) == host,
		"the same opponent at the same host, 28 days on")
	_check(bool(b.get("fight_week", false)) and FightWeekPlan.is_open(f) and not PullOutWire.is_open(f), "a fight week to set again; the need is gone")
	c.day = FightWeekEvents.roll_day(int(b["day"]))
	PullOutWire.day(c)
	_check(not PullOutWire.is_open(f), "the moved bout never rolls again")


func _no_favour() -> void:
	var r := _fell()
	var c: Career = r[0]
	var f: Dictionary = r[1]
	var host := str(f["bout"]["host"])
	c.favours[host] = 0
	var why := PullOutWire.answer(c, str(f["id"]), "next_month")
	_check(why.contains("no favour") and PullOutWire.is_open(f), "no favour: next month refused - %s" % why)
	var col: Dictionary = (FallThroughCard.view(c, f)["cols"] as Array).filter(func(x): return str(x["id"]) == "next_month")[0]
	_check(not bool(col["ok"]) and str(col["why"]) != "", "the card greys it with its why")
	var s := GDScript.new()
	s.source_code = "extends Node\nvar career\nfunc act(_n: String, _a: String = \"\") -> void:\n\tpass\n"
	s.reload()
	var main: Node = s.new()
	var card: PanelContainer = FallThroughCard.fill(DarkOverview.panel(), main, c, f)
	var nm: Button = card.find_child("Btn_fell_next_month", true, false)
	var tk: Button = card.find_child("Btn_fell_take_replacement", true, false)
	_check(card.name == "FallThroughCard" and nm != null and nm.disabled and tk != null and not tk.disabled,
		"the card draws three buttons; next month is greyed")
	card.free()
	main.free()


func _never_rolls() -> void:
	var r := _booked(true)
	var c: Career = r[0]
	var f: Dictionary = r[1]
	f["bout"]["pro"] = true
	c.day = FightWeekEvents.roll_day(int(f["bout"]["day"]))
	PullOutWire.day(c)
	_check(not f["bout"].has("rolled") and not PullOutWire.is_open(f), "a pro bout never rolls")
	var h := _booked(true)
	var c2: Career = h[0]
	var f2: Dictionary = h[1]
	f2["bout"]["home"] = true
	c2.day = FightWeekEvents.roll_day(int(f2["bout"]["day"]))
	PullOutWire.day(c2)
	_check(not PullOutWire.is_open(f2), "our own show's home bout never rolls")
