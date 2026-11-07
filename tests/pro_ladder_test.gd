extends SceneTree
## S397 rank 4 wired: after her pro debut Lucy joins the WORLD1 women's lightweight table, the promoter brings offers, a
## scout narrows one and shows the matchup, the band refuses a name too high (with its reason), a booked pro bout runs
## through the real fight night and moves the table, the world fights on each month, and the save keeps it all.
## Prints PRO_LADDER failures=<n>.

const Data := preload("res://scripts/state/Data.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const MM := preload("res://scripts/rules/Matchmaking.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _fight(c: Career, f: Dictionary) -> Dictionary:
	f["bout"]["day"] = c.day
	f["bout"]["weighed"] = true
	f["bout"]["made"] = true
	var m := {"fid": f["id"], "step": "tape", "total": int(f["bout"].get("rounds", 4))}
	Bouts.fight_step(c, f, m, "sim")
	Bouts.after_fight(c, f)
	return m


func _days_until(c: Career, f: Dictionary, cond: Callable, most: int) -> int:
	for i in most:
		if cond.call():
			return i
		Sim.step_day(c)
		c.review_pending = false
	return -1


func _initialize() -> void:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	f["w"] = 9
	f["l"] = 1
	f["offers"] = []
	Roster.check_pro(c)
	_check(not c.pro_offer.is_empty(), "a promoter offers her a pro contract at 9-1")
	Roster.turn_pro(c)
	_check(c.world.is_empty(), "no world before her debut is fought")
	_fight(c, f)
	var e := ProLadder.entry(c, f)
	_check(not c.world.is_empty() and not e.is_empty(), "after the debut she is on the %s table" % ProLadder.division_for(f))
	_check(int(e.get("rank", -1)) == 0, "she starts unranked (rank %d)" % int(e.get("rank", -1)))
	_check(int(e.get("w", 0)) + int(e.get("l", 0)) + int(e.get("d", 0)) == 1, "the debut counts on her table record")
	_check(int(f.get("pro_next", 0)) >= c.day + ProLadder.PRO_GAP_DAYS - 1, "the promoter calls again in about 8 weeks")
	var other: Dictionary = ProLadder.table(c, f).filter(func(b): return int(b.get("rank", 0)) == 1)[0]
	var bouts_before := int(other["w"]) + int(other["l"])
	var waited := _days_until(c, f, func(): return not (f.get("pro_offers", []) as Array).is_empty(), 80)
	_check(waited > 0, "offers arrive %d days later" % waited)
	var rows := ProLadder.offer_rows(c, f)
	_check(rows.size() >= 2, "the promoter has %d fights on the table" % rows.size())
	var world_moved := false
	for b in ProLadder.table(c, f):
		if not b.get("player", false) and int(b.get("rank", 0)) > 0 and int(b["w"]) + int(b["l"]) > 0:
			world_moved = true
	_check(world_moved, "the world fought on while she waited")
	var cash := c.cash
	var target: Dictionary = rows[0]
	var ok := ProLadder.scout(c, f, int(target["opp"]["id"]))
	var scouted: Dictionary = ProLadder.offer_rows(c, f)[0]["offer"]
	_check(ok and cash - c.cash == MM.SCOUT_COST, "a scout costs $%d (paid %d)" % [MM.SCOUT_COST, cash - c.cash])
	_check(bool(scouted["scouted"]) and absf(float(scouted["hi"]) - float(scouted["lo"]) - MM.RANGE_SCOUTED) < 0.6,
		"the scouted read narrows to about %d points (%.1f-%.1f)" % [int(MM.RANGE_SCOUTED), float(scouted["lo"]), float(scouted["hi"])])
	_check(not ProLadder.scout(c, f, int(target["opp"]["id"])), "the same offer cannot be scouted twice")
	var asks := ProLadder.ask_rows(c, f)
	_check(not asks.is_empty() and not bool(asks[0]["answer"]["ok"]) and str(asks[0]["answer"]["reason"]).begins_with("Too high"),
		"asking for #1 unranked is refused with its reason (%s)" % (str(asks[0]["answer"]["reason"]) if not asks.is_empty() else "-"))
	_check(asks.any(func(r): return bool(r["answer"]["ok"])), "someone in the band can be asked for")
	var booked := ProLadder.book(c, f, int(target["opp"]["id"]), false)
	_check(bool(booked["ok"]) and int(f["bout"].get("ladder", 0)) == int(target["opp"]["id"]), "she books the scouted fight")
	_check(int(f["bout"]["rounds"]) >= ProLadder.ROUNDS_UNRANKED and int(f["bout"]["purse"]) >= MM.PURSE_UNRANKED,
		"a pro bout: %d rounds, purse $%d" % [int(f["bout"]["rounds"]), int(f["bout"]["purse"])])
	_check((f.get("pro_offers", []) as Array).is_empty(), "the other offers go")
	var cash_before := c.cash
	var m := _fight(c, f)
	e = ProLadder.entry(c, f)
	_check(int(e["w"]) + int(e["l"]) + int(e.get("d", 0)) == 2, "the ladder bout counts on her table record (%d-%d-%d)" % [
		int(e["w"]), int(e["l"]), int(e.get("d", 0))])
	_check(c.cash > cash_before, "the purse share is paid (%d)" % (c.cash - cash_before))
	_check(not (m.get("ladder", {}) as Dictionary).is_empty(), "fight night reports the table move (rank %d -> %d)" % [
		int(m.get("ladder", {}).get("rank_before", -1)), int(m.get("ladder", {}).get("rank_after", -1))])
	var back := SaveGame.from_dict(SaveGame.to_dict(c))
	var fb: Dictionary = back.fighter()
	_check(not ProLadder.entry(back, fb).is_empty() and int(ProLadder.entry(back, fb)["w"]) == int(e["w"]),
		"the save keeps the world and her place on it")
	_check(int(other["w"]) + int(other["l"]) >= bouts_before, "the number 1 kept fighting")
	print("PRO_LADDER failures=%d" % failures)
	quit(failures)
