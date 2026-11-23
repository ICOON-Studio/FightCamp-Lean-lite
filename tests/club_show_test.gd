extends SceneTree
## S541 HOSTLIGHT1 (owner Q-S294-318 "Yes, light night"): the club show as a light money night. ClubShow's two halls as a
## READ (Community 250 / Town 400, reach on the club part, full / half-empty reputation), the expected-night read with
## "Close - your call", two standby reserves against the game's own pull-out rate, the night's sheet. Prints CLUB_SHOW failures=<n>.

const ClubShow := preload("res://scripts/rules/ClubShow.gd")
const FightWeekEvents := preload("res://scripts/rules/FightWeekEvents.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	if ok:
		print("  ok: ", what)
	else:
		failures += 1
		print("  FAIL: ", what)


func _initialize() -> void:
	_halls()
	_read()
	_reserves()
	_night()
	print("CLUB_SHOW failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _halls() -> void:
	_check(ClubShow.seats("community") == 250 and ClubShow.seats("town") == 400, "two halls: 250 and 400 seats")
	_check(ClubShow.cost("community") == 1000 + 1500 + 80 and ClubShow.cost("town") == 2000 + 1500 + 80, "rent + the fixed night + two reserves at $40")
	_check(ClubShow.COST == ClubShow.cost("community"), "COST is the cheapest hall booked")
	_check(is_equal_approx(ClubShow.reach("town", 0), 0.6) and is_equal_approx(ClubShow.reach("town", 30), 0.9)
		and is_equal_approx(ClubShow.reach("town", 200), 1.25) and ClubShow.reach("community", 90) == 1.0, "Town's reach 0.6 + 0.01 a rep point, 0.6-1.25; Community x1.0")
	# reach scales only the club part: the home boxers' followers come whatever the hall
	var club_only := ClubShow.demand("town", 50, 10, 0, 0)
	var with_boxer := ClubShow.demand("town", 50, 10, 0, 1)
	_check(is_equal_approx(with_boxer - club_only, ClubShow.PER_HOME_BOXER), "a home boxer's followers are not scaled by the hall")
	_check(ClubShow.seat_rep("community", 213) == 4 and ClubShow.seat_rep("community", 212) == 0 and ClubShow.seat_rep("community", 124) == -3
		and ClubShow.seat_rep("town", 340) == 6 and ClubShow.seat_rep("town", 199) == -4, "full 85%+ +4 / +6, half-empty under 50% -3 / -4")


func _read() -> void:
	var small := ClubShow.read(60, 10, 0, 1)
	var grown := ClubShow.read(200, 70, 0, 4)
	_check(str(small["hall"]) == "community" and not bool(small["close"]), "a rep-10 club is read Community: %s" % small["line"])
	_check(str(grown["hall"]) == "town" and not bool(grown["close"]), "a rep-70 grown club is read Town: %s" % grown["line"])
	_check(str(small["line"]).begins_with("Your club ") and str(small["line"]).contains("Town hall would") and str(small["line"]).contains("likely "),
		"the line names the hall that pays and what the other would do: %s" % small["line"])
	var lk: Dictionary = small["likely"]
	_check(int(lk["community"]["net"]) > int(lk["town"]["net"]), "the named hall pays more on the expected night (%d v %d)" % [int(lk["community"]["net"]), int(lk["town"]["net"])])
	# find a club the read calls close, scanning members at a fixed reputation
	var close := {}
	for m in range(40, 400, 2):
		var r := ClubShow.read(m, 40, 0, 2)
		if bool(r["close"]):
			close = r
			break
	_check(not close.is_empty() and str(close["line"]).begins_with("Close - your call")
		and absf(float(close["likely"]["community"]["v"]) - float(close["likely"]["town"]["v"])) < ClubShow.READ_CLOSE,
		"within $300 the read says Close - your call: %s" % str(close.get("line", "none found")))
	_check(str(small["short"]).begins_with("Community hall: ") and str(small["short"]).contains(". Town: ") and str(small["short"]).length() <= 92,
		"the row's short read fits two lines: %s" % small["short"])
	_check(str(close.get("short", "")).begins_with("Close - your call. Community hall: "), "the short read says close too: %s" % str(close.get("short", "")))
	_check(ClubShow._money(2340) == "+$2,300" and ClubShow._money(-870) == "-$900" and ClubShow._money(20) == "+$0", "money rounds to $100, signed")


func _reserves() -> void:
	_check(is_equal_approx(ClubShow.PULL_OUT, FightWeekEvents.PULL_OUT_CHANCE), "the reserves stand against the game's own pull-out rate")
	var two := ClubShow.card("community", 2)
	_check(int(two["boxed"]) == 9 and int(two["reserves_used"]) == 2 and not bool(two["short"]), "two pull-outs: both reserves box, the full card")
	var one := ClubShow.card("community", 1)
	_check(int(one["boxed"]) == 9 and int(one["reserves_used"]) == 1, "one pull-out: one reserve boxes")
	# never a short card while a reserve is unused
	var ok := true
	for hall in ClubShow.HALL_ORDER:
		for k in int(ClubShow.HALLS[hall]["card"]) + 1:
			var c := ClubShow.card(hall, k)
			if int(c["boxed"]) < int(c["card"]) and int(c["reserves_used"]) < ClubShow.RESERVES:
				ok = false
	_check(ok, "no bout is lost while a reserve stands unused")
	var five := ClubShow.card("community", 5)
	_check(int(five["boxed"]) == 6 and not bool(five["short"]) and bool(ClubShow.card("community", 6)["short"]), "short night under two-thirds boxed")
	var p := ClubShow.short_chance("community")
	_check(p > 0.0 and p < 0.15, "with two reserves a short night is rare (%.3f)" % p)


func _night() -> void:
	var n := ClubShow.night_in("community", 200, 60, 0, 3, 1.15, 1000, 3)
	_check(int(n["sold"]) == 250 and bool(n["full"]) and int(n["rep"]) == 4 and int(n["net"]) == 250 * 25 + 1000 - ClubShow.cost("community"),
		"a full Community night: 250 sold, +4 reputation, the net after the hall")
	_check(int(n["members"]) == ClubShow.MEMBER_SEATS / ClubShow.TICKETS_PER_MEMBER, "members a show brings: %d" % int(n["members"]))
	var t := ClubShow.night_in("town", 400, 100, 0, 4, 1.15, 1000, 0)
	_check(int(t["sold"]) == 400 and int(t["rep"]) == 6 and int(t["members"]) <= int(n["members"]),
		"Town full: +6 rep, but no more members than Community's cap (%d <= %d)" % [int(t["members"]), int(n["members"])])
	var thin := ClubShow.night_in("town", 40, 5, 0, 0, 0.7, 600, 0)
	_check(bool(thin["half"]) and int(thin["rep"]) == -4 and int(thin["net"]) < 0 and int(thin["members"]) == 0, "half-empty Town: -4 rep, a loss, no members")
	var short := ClubShow.night_in("community", 100, 20, 0, 1, 1.0, 1000, 7)
	_check(bool(short["short"]) and int(short["rep"]) <= ClubShow.SHORT_REP, "a short card costs reputation")
	var sh := ClubShow.sheet(ClubShow.night_in("community", 200, 60, 0, 3, 1.15, 1000, 3))
	_check(sh.begins_with("Community hall: 250 sold (a full house)") and sh.contains("3 pulled out, both reserves boxed, 8 of 9") and sh.contains("reputation +4"),
		"the sheet: %s" % sh)
