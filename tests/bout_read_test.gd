extends SceneTree
## S387 MENUBOUT, BoutRead (the bout offer as a decision):
##   1. calibration: chance() against real bouts, BoutNight.play_out through fight night's own rounds, several fighters,
##   2. the band holds the true chance: the measured one at every stage, and chance() for every salt,
##   3. the band and the stat ranges narrow at every find, nested, and always hold the truth,
##   4. a stronger fighter gets a higher band, a tougher opponent a lower one (control arm),
##   5. nothing leaks: a hidden tell moves nothing, the truth does not sit at a fixed place, a find does not point at it,
##   6. mismatch, the assumed camp, rank impact.
## Population: Lucy (Data.lucy) as signed, weaker and stronger, with and without a plan; every OPPONENT + MISMATCH + RIVALS.

const Data := preload("res://scripts/state/Data.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const Region := preload("res://scripts/state/Region.gd")

const SIMS := 500
const CAMP := {"protocol": 2, "focus": "conditioning", "film": false, "partner": false, "start": 0}
const GOOD_PLAN := [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]
## How far chance() may sit from a measured share: its known misses plus the dice of SIMS bouts.
const CALIBRATED := 0.06
const NESTED := 0.01

var _fails := 0


func _initialize() -> void:
	_real_bouts()
	_every_salt()
	_narrows()
	_stronger()
	_no_leak()
	_numbers()
	_ranks()
	print("BOUT_READ %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _lucy(shift := 0.0) -> Dictionary:
	var f: Dictionary = Data.fighter_state(Data.lucy(), 0)
	for k in f["stats"]:
		f["stats"][k] = float(f["stats"][k]) + shift
	return f


func _opps() -> Array:
	var out: Array = []
	for o in Data.OPPONENTS + [Data.MISMATCH] + Data.RIVALS:
		out.append((o as Dictionary).duplicate(true))
	return out


## The share of SIMS bouts she wins, on the fight night's own rounds (PlanTest's scratch career: nothing is booked).
func _measured(f0: Dictionary, opp: Dictionary) -> float:
	var wins := 0
	for k in SIMS:
		var sc := Career.new()
		sc.day = 50000 + k * 7
		sc.seed = 387
		sc.coach = {"rating": 58.0}
		var sf: Dictionary = f0.duplicate(true)
		sf["camp"] = CAMP.duplicate(true)
		sf["bout"] = {"opp": opp.duplicate(true), "day": sc.day, "weighed": true, "made": true, "done": false, "film": 1}
		sc.fighters = [sf]
		var m := BoutNight.fight_modal(sf)
		BoutNight.play_out(sc, sf, m)
		wins += int(BoutNight.outcome_of(sf, m) == "win")
	return float(wins) / float(SIMS)


func _real_bouts() -> void:
	var planned := _lucy()
	planned["arrows"] = GOOD_PLAN.duplicate(true)
	var cases := [["Lucy", _lucy(), 0], ["Lucy", _lucy(), 1], ["Lucy", _lucy(), 2], ["Lucy", _lucy(), 3],
		["Lucy -6", _lucy(-6.0), 0], ["Lucy +6", _lucy(6.0), 2], ["Lucy +10", _lucy(10.0), 3], ["Lucy, a plan", planned, 0]]
	var all := Data.OPPONENTS + [Data.MISMATCH]
	for row in cases:
		var f: Dictionary = row[1]
		var opp: Dictionary = (all[int(row[2])] as Dictionary).duplicate(true)
		var real := _measured(f, opp)
		var est := BoutRead.chance(f, opp, CAMP)
		_check(absf(est - real) <= CALIBRATED, "%s vs %s: chance() %.3f, real bouts %.3f" % [row[0], opp["first"], est, real])
		var dice := 2.0 * sqrt(maxf(real * (1.0 - real), 0.01) / float(SIMS))
		var scouted := opp.duplicate(true)
		for found in OppFile.hidden(opp).size() + 1:
			var b := BoutRead.band(f, scouted, CAMP, 387)
			_check(real >= float(b["lo"]) - dice and real <= float(b["hi"]) + dice,
				"%s vs %s, %d found: band %.2f-%.2f holds real %.3f" % [row[0], opp["first"], found, b["lo"], b["hi"], real])
			OppFile.tape(scouted)


func _every_salt() -> void:
	var misses := 0
	var checks := 0
	for opp in _opps():
		for shift in [-6.0, 0.0, 6.0]:
			var f := _lucy(shift)
			var truth := BoutRead.chance(f, opp, CAMP)
			for salt in 12:
				var o: Dictionary = opp.duplicate(true)
				while true:
					var b := BoutRead.band(f, o, CAMP, salt)
					checks += 1
					misses += int(truth < float(b["lo"]) or truth > float(b["hi"]))
					if OppFile.tape(o) == "":
						break
	_check(misses == 0, "the band holds chance() at every stage: %d misses in %d" % [misses, checks])


func _narrows() -> void:
	var f := _lucy()
	var bad := 0
	var stats_bad := 0
	var outside := 0
	var wide := 0.0
	var tight := 1.0
	for opp in _opps():
		for salt in 12:
			var o: Dictionary = opp.duplicate(true)
			var truth := BoutRead.true_stats(o)
			var was := BoutRead.band(f, o, CAMP, salt)
			var was_st := BoutRead.stat_ranges(o, salt)
			wide = maxf(wide, float(was["hi"]) - float(was["lo"]))
			while OppFile.tape(o) != "":
				var now := BoutRead.band(f, o, CAMP, salt)
				var st := BoutRead.stat_ranges(o, salt)
				# Narrower every time; inside the last band but for NESTED (a tank threshold kinks chance() in the rating).
				if float(now["lo"]) < float(was["lo"]) - NESTED or float(now["hi"]) > float(was["hi"]) + NESTED \
						or float(now["hi"]) - float(now["lo"]) >= float(was["hi"]) - float(was["lo"]):
					print("  break: %s %s -> %s" % [o["name"], str(was), str(now)])
					bad += 1
				for k in st:
					var r: Array = st[k]
					var p: Array = was_st[k]
					if float(r[0]) < float(p[0]) - 0.0001 or float(r[1]) > float(p[1]) + 0.0001 or float(r[1]) - float(r[0]) >= float(p[1]) - float(p[0]):
						stats_bad += 1
					if float(truth[k]) < float(r[0]) or float(truth[k]) > float(r[1]):
						outside += 1
				was = now
				was_st = st
			tight = minf(tight, float(was["hi"]) - float(was["lo"]))
	_check(bad == 0, "the band narrows at every find, nested (%d breaks)" % bad)
	_check(stats_bad == 0, "every stat range narrows at every find, nested (%d breaks)" % stats_bad)
	_check(outside == 0, "every stat range holds the true stat (%d outside)" % outside)
	_check(wide > 0.3 and tight < 0.3, "wide on a stranger (%.2f at most), narrow on an open file (%.2f at least)" % [wide, tight])


func _stronger() -> void:
	var bad := 0
	for opp in _opps():
		var o: Dictionary = opp.duplicate(true)
		while true:
			var a := BoutRead.band(_lucy(), o, CAMP, 5)
			var b := BoutRead.band(_lucy(5.0), o, CAMP, 5)
			if float(b["lo"]) <= float(a["lo"]) and float(a["lo"]) > 0.011:
				bad += 1
			if float(b["hi"]) <= float(a["hi"]) and float(a["hi"]) < 0.989:
				bad += 1
			if OppFile.tape(o) == "":
				break
	_check(bad == 0, "a stronger fighter gets a higher band at every stage (%d breaks)" % bad)
	var soft: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	var hard := soft.duplicate(true)
	hard["rating"] = float(soft["rating"]) + 6.0
	_check(BoutRead.chance(_lucy(), hard, CAMP) < BoutRead.chance(_lucy(), soft, CAMP), "control: a tougher opponent lowers the chance")


func _no_leak() -> void:
	# A hidden tell moves nothing: the same opponent with other hidden words reads the same.
	var a: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	var b := a.duplicate(true)
	b["weak"] = "Leaves the chin open"
	b["threat"] = "Three-punch flurries"
	_check(BoutRead.stat_ranges(a, 9) == BoutRead.stat_ranges(b, 9), "hidden words move no stat range")
	_check(BoutRead.band(_lucy(), a, CAMP, 9) == BoutRead.band(_lucy(), b, CAMP, 9), "hidden words move no band")
	# Found, they do: the weakness is on the file now and the range says so.
	OppFile.open_all(a)
	OppFile.open_all(b)
	_check(float(BoutRead.stat_ranges(a, 9)["conditioning"][1]) < float(BoutRead.stat_ranges(a, 9)["power"][0]), "found: 'Fades' puts her conditioning under the rest")
	_check(float(BoutRead.stat_ranges(b, 9)["chin"][1]) < float(BoutRead.stat_ranges(b, 9)["power"][1]), "found: an open chin reads lower")
	# The truth has no fixed place: not the middle, and its place spreads across the range.
	var least := 1.0
	var most := 0.0
	var off := 0
	for salt in 200:
		var o: Dictionary = (Data.OPPONENTS[1] as Dictionary).duplicate(true)
		var r := BoutRead.rating_range(o, salt)
		var at := (float(o["rating"]) - float(r[0])) / (float(r[1]) - float(r[0]))
		least = minf(least, at)
		most = maxf(most, at)
		off += int(absf(at - 0.5) > 0.02)
	_check(least < 0.3 and most > 0.7 and off > 170, "the truth moves about the range (%.2f to %.2f, off centre %d of 200)" % [least, most, off])
	# Two finds in a row: a range that closed in on the truth at a fixed rate would move its middle the same way every time.
	var same := 0
	for salt in 200:
		var o: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
		var r0 := BoutRead.rating_range(o, salt)
		OppFile.tape(o)
		var r1 := BoutRead.rating_range(o, salt)
		OppFile.tape(o)
		var r2 := BoutRead.rating_range(o, salt)
		var c0 := (float(r0[0]) + float(r0[1])) / 2.0
		var c1 := (float(r1[0]) + float(r1[1])) / 2.0
		var c2 := (float(r2[0]) + float(r2[1])) / 2.0
		same += int(signf(c1 - c0) == signf(c2 - c1))
	_check(same > 40 and same < 160, "two finds move the middle the same way only some of the time (%d of 200)" % same)
	_check(BoutRead.rating_range(Data.OPPONENTS[0], 9) != BoutRead.rating_range(Data.OPPONENTS[0], 10), "another career reads her differently")


func _numbers() -> void:
	var maria: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	var dana: Dictionary = (Data.MISMATCH as Dictionary).duplicate(true)
	_check(BoutRead.mismatch(_lucy(), dana, CAMP, 3) < BoutRead.mismatch(_lucy(), maria, CAMP, 3), "the mismatch number is worse against Dana")
	_check(BoutRead.mismatch(_lucy(), dana, CAMP, 3) < -5.0, "Dana reads as a big mismatch (%.1f)" % BoutRead.mismatch(_lucy(), dana, CAMP, 3))
	var f := _lucy()
	_check(int(BoutRead.camp_for(f, 21)["protocol"]) == BoutRead.USUAL_CAMP, "3 weeks out: the usual camp assumed")
	_check(BoutRead.camp_for(f, 3).is_empty(), "3 days out: no camp")
	f["camp"] = {"protocol": 3}
	_check(int(BoutRead.camp_for(f, 3)["protocol"]) == 3, "her own camp when she has one")
	var s := BoutRead.stage(maria)
	_check(int(s["found"]) == 0 and int(s["all"]) == 4 and float(s["share"]) == 0.0, "Maria's file: 0 of 4")


func _ranks() -> void:
	var rows: Array = [{"name": "A", "w": 7, "l": 1, "rating": 66.0}, {"name": "B", "w": 6, "l": 2, "rating": 64.0},
		{"name": "Lucy Jackson", "w": 5, "l": 2, "rating": 0.0}, {"name": "C", "w": 5, "l": 3, "rating": 61.0}, {"name": "D", "w": 3, "l": 2, "rating": 60.0}]
	var f := {"name": "Lucy Jackson", "w": 5, "l": 2}
	_check(BoutRead.rank_of(rows, "C") == 4 and BoutRead.rank_of(rows, "Nobody") == 0, "the opponent's place in the table")
	var m := BoutRead.rank_move(rows, f, "B", Region.before, Region.RANK_MIN_WINS)
	_check(int(m["now"]) == 3 and int(m["win"]) == 2 and int(m["loss"]) == 4, "a win over B goes 3 -> 2, a loss 3 -> 4 (%s)" % str(m))
	var table: Array = rows.filter(func(r): return str(r["name"]) != "Lucy Jackson")
	var e := BoutRead.rank_move(table, {"name": "Lucy Jackson", "w": 3, "l": 1}, "C", Region.before, Region.RANK_MIN_WINS)
	_check(int(e["now"]) == 0 and int(e["win"]) > 0 and int(e["loss"]) == 0, "the fourth win enters the table, a loss does not (%s)" % str(e))
	var far := BoutRead.rank_move(table, {"name": "Lucy Jackson", "w": 1, "l": 0}, "C", Region.before, Region.RANK_MIN_WINS)
	_check(int(far["win"]) == 0 and int(far["need"]) == 2, "two wins short after this one (%s)" % str(far))


func _check(ok: bool, what: String) -> void:
	print(("ok   " if ok else "FAIL ") + what)
	if not ok:
		_fails += 1
