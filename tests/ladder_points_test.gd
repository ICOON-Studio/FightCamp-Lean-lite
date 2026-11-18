extends SceneTree
## S515 LADDERWIRE1 stage 1: ladder points (season ladder v6) move on every amateur bout, ours and the region's.
## Population: a quick-start club with Lucy, against the region's own named rivals. Prints LADDER_POINTS failures=N.

const LadderPoints := preload("res://scripts/state/LadderPoints.gd")
const LadderRep := preload("res://scripts/rules/LadderRep.gd")
const Data := preload("res://scripts/state/Data.gd")
const Region := preload("res://scripts/state/Region.gd")
const AskFlow := preload("res://scripts/state/AskFlow.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")

var _fails := 0


func _initialize() -> void:
	# Seeding (R10): 8 + 4 x net wins + bouts, 0..65.
	_check(LadderPoints.seed_of(0, 0) == 8 and LadderPoints.seed_of(5, 1) == 30 and LadderPoints.seed_of(0, 6) == 0
		and LadderPoints.seed_of(20, 0) == 65, "seeding: 0-0 = 8, 5-1 = 30, 0-6 = 0, 20-0 capped at 65")
	# The decision's kind from the cards.
	_check(LadderPoints.method_of(["30-27", "29-28", "30-27"], "", true) == "ud", "three cards for the winner = unanimous")
	_check(LadderPoints.method_of(["30-27", "28-29", "30-27"], "", true) == "split", "one card against = split")
	_check(LadderPoints.method_of(["30-27", "28-28", "30-27"], "", true) == "majority", "one card level = majority")
	_check(LadderPoints.method_of([], "TKO", true) == "stop", "a stoppage = stop")
	# Both sides move by the table: level 20 v 20, a unanimous win = +8 / -8.
	var a := {"rep": 20}
	var b := {"rep": 20}
	var s := LadderPoints.settle(a, b, "win", "ud")
	_check(int(s["a_delta"]) == 8 and int(s["b_delta"]) == -8 and int(a["rep"]) == 28 and int(b["rep"]) == 12, "level bout: +8 / -8")
	var lo := {"rep": 10}
	var hi := {"rep": 20}
	var u := LadderPoints.settle(lo, hi, "win", "ud")
	_check(int(u["a_delta"]) == 11 and int(u["b_delta"]) == -11, "beating a boxer 10 above pays +11 (the R3 table), the better one loses 11")
	# The region's own bout moves its rivals.
	var c := Career.quick_start()
	c.seed = 11
	c.applicant = {}
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var div := str(c.fighters[0]["div"])
	var pool: Array = c.rivals.filter(func(r): return str(r["div"]) == div)
	_check(pool.size() >= 2 and str(pool[0]["name"]) != str(pool[1]["name"]), "two different rivals in %s" % div)
	var r0 := LadderPoints.rep_of(pool[0])
	var r1 := LadderPoints.rep_of(pool[1])
	var rng := RandomNumberGenerator.new()
	rng.seed = 515
	Region._rival_bout(c, pool[0], pool[1], "a club show", rng, false)
	_check(int(pool[0]["rep"]) != r0 and int(pool[1]["rep"]) != r1, "a rivals' bout moves both (%d -> %d, %d -> %d)" % [r0, pool[0]["rep"], r1, pool[1]["rep"]])
	# Our bout, booked through the Ask and fought by the game's own sim.
	var f: Dictionary = c.fighters[0]
	var opp := str(AskFlow.sheet_name(c, f))
	var day := c.day + 10
	while not Region.is_show_day(day):
		day += 1
	_check(AskFlow.book(c, f, "sheet", opp, day), "Lucy is booked against %s" % opp)
	var before := LadderPoints.rep_of(f)
	var their := LadderPoints.rep_of(c.rival(opp))
	c.day = day
	var g := f   # the bout night itself (Bouts.fighting_today also waits on the weigh-in; that path is late_ask_test's)
	if true:
		var m := Bouts.fight_modal(g)
		Bouts.fight_step(c, g, m, "sim")
		var lp: Dictionary = m.get("ladder_pts", {})
		var won := bool(m.get("win", false))
		_check(not lp.is_empty() and int(f["rep"]) == before + int(lp["a_delta"]) and int(c.rival(opp)["rep"]) == their + int(lp["b_delta"]),
			"the bout moved both (Lucy %d -> %d, %s %d -> %d, %s)" % [before, int(f["rep"]), opp, their, int(c.rival(opp)["rep"]), "won" if won else str(m.get("outcome", ""))])
		_check((won and int(lp["a_delta"]) > 0) or (not won and int(lp["a_delta"]) <= 0), "a win gains, a loss or draw does not")
	print("LADDER_POINTS failures=%d" % _fails)
	quit(0 if _fails == 0 else 1)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
