extends SceneTree
## S434 NOCAMP1 round 1 (the review: "Probe on 400 amateur bouts before and after"; "no fighter worse off than today on a
## normal week"; fight_why and exchanges measured on 3x their samples with a control arm). Measure only - it changes
## nothing. Runs on any tree (the branch, or main's code swapped in) so both arms use this one harness.
## Sections (args after --):
##   why [n]      fight_why_test's bout (Lucy vs Maria, no camp, days 40..) on n bouts: a GOOD plan graded good, a BAD
##                plan graded good (the test's bars: >= 90 % and <= 10 %)
##   exch [n]     exchanges_test's even fight (Lucy vs Priya at her paper, film 1) on n bouts: none and wrong (bar: wrong
##                <= none - 0.15). Each bout starts rested (tiredness 20, no results, no last bout), as tools/exchange_balance.
##   record <file> [nights] [dice]  THE GAME'S AMATEUR WEEK: careers of Lucy + Data.PROSPECTS (signed with
##                Roster.sign_fighter, Luke Reid hired) stepped by Sim.step_day; every even offer taken (Bouts.accept), no
##                camp ever started, the diet set to cut on booking (the player's move: no camp cuts for her), the weigh-in
##                the day before (Bouts.weigh), an injury before a bout pulls her out; at
##                each fight night the state (fighter, results, day) is saved to <file> and played `dice` times on scratch
##                careers (the dice moved by whole weeks of days: c.day, the results and her bout day shifted together),
##                then the bout is fought once for real ("sim") and the career goes on. Stops at `nights` fight nights.
##   replay <file> [dice]  the same saved fight nights played `dice` times on THIS tree (the control arm).
## Population: printed with each section. Run: godot --headless --path . --script res://tools/nocamp_probe.gd -- why 180

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const FightWhy := preload("res://scripts/rules/FightWhy.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const XB := preload("res://tools/exchange_balance.gd")

const GOOD := [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]
const BAD := [{"move": "cut_off"}, {"move": "3b-3"}, {"move": "herd"}, {"move": "3b-3@inside"}]
const SHIFT := 7000   # days a dice step moves a scratch fight night (whole weeks: the weekday is kept)
const MAX_DAYS := 196


func _initialize() -> void:
	var a := OS.get_cmdline_user_args()
	var what := str(a[0]) if a.size() > 0 else "why"
	match what:
		"why":
			_why(int(a[1]) if a.size() > 1 else 180, int(a[2]) if a.size() > 2 else 40)
		"exch":
			_exch(int(a[1]) if a.size() > 1 else 1200)
		"record":
			_record(str(a[1]), int(a[2]) if a.size() > 2 else 400, int(a[3]) if a.size() > 3 else 10)
		"replay":
			_replay(str(a[1]), int(a[2]) if a.size() > 2 else 10)
	quit(0)


## S439: `why n start` reads days start..start+n-1 (fight_why_test's window is start 40); other windows are other seeds.
func _why(n: int, start := 40) -> void:
	var gg := 0
	var bg := 0
	for i in n:
		gg += int(str(FightWhy.read(_why_bout(start + i, GOOD)["rounds"], "Lucy", "Maria")["grade"]) == "good")
		bg += int(str(FightWhy.read(_why_bout(start + i, BAD)["rounds"], "Lucy", "Maria")["grade"]) == "good")
	print("NOCAMP_PROBE why: Lucy (Data.lucy) vs Maria (OPPONENTS[0]), no camp, days %d..%d: good plan graded good %d of %d (%.3f), bad plan graded good %d (%.3f)" % [
		start, start + n - 1, gg, n, float(gg) / n, bg, float(bg) / n])


## fight_why_test._bout, unchanged.
func _why_bout(day: int, arrows: Array) -> Dictionary:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	c.day = day
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["combos"] = {"1-1": 50.0, "1-2": 50.0}
	f["arrows"] = arrows.duplicate(true)
	f["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false,
		"film": 0, "rounds": 3}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "sim")
	return m


func _exch(n: int) -> void:
	var none := _share("none", n)
	var wrong := _share("wrong", n)
	print("NOCAMP_PROBE exch: Lucy vs Priya (OPPONENTS[1]) at her paper, film 1, no camp, days 20..%d: none %.4f, wrong %.4f, gap %.4f" % [
		19 + n, none, wrong, none - wrong])


## exchange_balance.share at edge 0, film 1, rested each bout (the same loop on every tree).
func _share(pol: String, n: int) -> float:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var wins := 0
	for i in n:
		c.day = 20 + i
		var f: Dictionary = c.fighter()
		f["camp"] = {}
		f["morale"] = 60.0
		f["week_fatigue"] = 20.0
		c.results.clear()
		f.erase("last_bout_day")
		f["notes_seen"] = []
		var opp: Dictionary = (Data.OPPONENTS[1] as Dictionary).duplicate(true)
		opp["rating"] = BoutRules.fight_power(f["stats"], {}, 0, "")
		f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		XB.play(c, f, m, pol)
		wins += 1 if str(m.get("outcome", "")) == "win" else 0
	return float(wins) / n


func _record(path: String, nights: int, dice: int) -> void:
	var saved: Array = []
	var k := 0
	var missed := 0
	while saved.size() < nights and k < 40:
		var c := Career.quick_start()
		c.seed = 4340 + k
		seed(4340 + k)
		c.coach = Data.coach("reid").duplicate(true)
		for raw in [Data.lucy()] + Data.PROSPECTS:
			Roster.sign_fighter(c, (raw as Dictionary).duplicate(true), [])
		var d0 := c.day
		while c.day - d0 < MAX_DAYS and saved.size() < nights:
			c.cash = 1000000
			for f in c.fighters:
				if Injuries.pending(f):
					Injuries.pull_out(c, f)
				for o in f.get("offers", []):
					if not bool(o["answered"]) and not bool(o["mismatch"]) and not bool(f.get("pro", false)):
						Bouts.accept(c, str(o["id"]))
						f["diet"] = "cut"   # the player's one move on booking: make the weight (no camp cuts for her)
						break
				if Bouts.weigh_in_today(c, f):
					missed += int(not Bouts.weigh(c, f))
			for f in c.fighters:
				if Bouts.fight_day(c, f) and saved.size() < nights:
					var snap := {"f": f.duplicate(true), "results": c.results.duplicate(true), "day": c.day}
					saved.append(snap)
					var m := {"fid": f["id"], "step": "tape", "total": 3}
					Bouts.fight_step(c, f, m, "sim")
					Bouts.after_fight(c, f)
			Sim.step_day(c)
		k += 1
	var fh := FileAccess.open(path, FileAccess.WRITE)
	fh.store_var(saved, false)
	fh.close()
	print("NOCAMP_PROBE record: %d fight nights from %d careers (Lucy + Data.PROSPECTS, Luke Reid, every even offer, diet cut on booking, no camp); %d missed weight" % [saved.size(), k, missed])
	_report(saved, dice)


func _replay(path: String, dice: int) -> void:
	var fh := FileAccess.open(path, FileAccess.READ)
	var saved: Array = fh.get_var(false)
	fh.close()
	print("NOCAMP_PROBE replay: %d saved fight nights" % saved.size())
	_report(saved, dice)


## Plays every saved fight night `dice` times; prints the win share in all, on a normal week (tiredness 50 or less, no
## bout of her own in 14 days), tired (over 50) and after a recent bout, plus the tiredness and Tank seen.
func _report(saved: Array, dice: int) -> void:
	var rows := {"all": [0, 0], "normal": [0, 0], "tired": [0, 0], "recent": [0, 0]}
	var fat_sum := 0.0
	var tank_sum := 0.0
	var per: Array = []
	for s in saved:
		var f0: Dictionary = s["f"]
		var fat := float(f0.get("week_fatigue", 20.0))
		var days := _days_since(s["results"], str(f0["id"]), int(s["day"]))
		var keys := ["all", "tired" if fat > BoutRules.FRESH_FATIGUE else "normal"]
		if days >= 0 and days <= 14:
			keys = ["all", "recent"] if fat <= BoutRules.FRESH_FATIGUE else ["all", "tired", "recent"]
		fat_sum += fat
		var w := 0
		for j in dice:
			var won := _play(s, j)
			w += int(won)
			if j == 0:
				tank_sum += float(_last_stale)
		for key in keys:
			rows[key][0] += w
			rows[key][1] += dice
		per.append("%s|%d|%.1f|%d|%d" % [str(f0["id"]), int(s["day"]), fat, days, w])
	print("  tiredness at the bell: mean %.1f over %d nights; the Tank off (this tree's rule) mean %.2f" % [fat_sum / maxf(1.0, saved.size()),
		saved.size(), tank_sum / maxf(1.0, saved.size())])
	for key in ["all", "normal", "tired", "recent"]:
		var r: Array = rows[key]
		print("  %-7s %5d bouts (%4d nights): wins %.4f" % [key, int(r[1]), int(r[1]) / maxi(1, dice), float(r[0]) / maxf(1.0, float(r[1]))])
	print("  PER " + ";".join(per))


var _last_stale := 0.0


func _play(s: Dictionary, j: int) -> bool:
	var shift := SHIFT * (j + 1)
	var sc := Career.new()
	sc.day = int(s["day"]) + shift
	sc.seed = 387
	sc.coach = Data.coach("reid").duplicate(true)
	sc.results = []
	for r in s["results"]:
		var rr: Dictionary = (r as Dictionary).duplicate(true)
		rr["d"] = int(rr.get("d", 0)) + shift
		sc.results.append(rr)
	var sf: Dictionary = (s["f"] as Dictionary).duplicate(true)
	sf["bout"]["day"] = int(sf["bout"]["day"]) + shift
	if sf.has("last_bout_day"):
		sf["last_bout_day"] = int(sf["last_bout_day"]) + shift
	if sf.has("injury") and not (sf["injury"] as Dictionary).is_empty():
		sf["injury"]["until_day"] = int(sf["injury"].get("until_day", 0)) + shift
	sc.fighters = [sf]
	var m := BoutNight.fight_modal(sf)
	BoutNight.play_out(sc, sf, m)
	_last_stale = float(sf["bout"].get("stale", 0.0))
	return BoutNight.outcome_of(sf, m) == "win"


func _days_since(results: Array, fid: String, day: int) -> int:
	var last := -1
	for r in results:
		if str((r as Dictionary).get("fid", "")) == fid:
			last = maxi(last, int(r.get("d", -1)))
	return day - last if last >= 0 else -1
