extends "res://tests/rib_damage_test.gd"
## S439 re-measure (the lead's ruling: PUNCHSTART1 stays, the S318 / RIBS1 bars stay, the damage numbers move).
## Plays rib_damage_test's three arms over EIGHT disjoint 200-day windows (days 1000..2599) ONCE, keeps every bout's ring
## beats, then replays them through a copy of BodyMap.add_beats with FACE_HIT / HEAD_HIT / RIB_HIT as parameters.
## The beats do not depend on those three numbers (nothing in the fight reads the map), so one play serves the whole grid.
## The copy is checked against BodyMap.add_beats at the shipped numbers on every bout (SWEEP_COPY mismatches=0).
## Also replays body_map_test's test 5 (the unit list: RoundScript exchanges at rolled margins, 300 seeds).
## Args after --: windows=<n> (default 8), arms=<default,body,head>.
## Read-only: no file is written; prints SWEEP_* lines.

const RS := preload("res://scripts/rules/RoundScript.gd")
const BR := preload("res://scripts/rules/BoutRules.gd")

var _cur: Array = []
var _played: Dictionary = {}   ## arm -> Array of windows -> Array of {rounds: [beats], a_wins, rounds_n, map}
var _unit: Array = []          ## [{beats: [Array per exchange], south, winner}]
var _mismatch := 0


func _initialize() -> void:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), 1000))
	_base = (c.fighter() as Dictionary).duplicate(true)
	_base["camp"] = {}
	_base["arrows"] = [{"move": "step_back"}, {"move": "pivot_out"}]
	_opp = (Data.OPPONENTS[1] as Dictionary).duplicate(true)
	_header()
	var nwin := WINDOWS
	var quick := false
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("windows="):
			nwin = int(str(a).substr(8))
		elif str(a) == "quick":
			quick = true
	var arms: Array = [["default", "", ""], ["body", "body", ""]]
	if not quick:
		arms.append(["head", "", "head"])
	var t0 := Time.get_ticks_msec()
	for arm in arms:
		var wins: Array = []
		for w in nwin:
			var bouts: Array = []
			for s in SEEDS:
				var f: Dictionary = _fresh(c, 1000 + w * SEEDS + s)
				_cur = []
				var bout: Dictionary = _fight(c, f, str(arm[1]), str(arm[2]), "sweep")
				bouts.append({"rounds": _cur, "a_wins": int(bout["a_wins"]), "rounds_n": int(bout["rounds_n"]), "map": bout["map"]})
			wins.append(bouts)
			print("SWEEP_PLAYED %s window %d (days %d..%d) %d s" % [arm[0], w, 1000 + w * SEEDS, 1199 + w * SEEDS,
				(Time.get_ticks_msec() - t0) / 1000])
		_played[arm[0]] = wins
	if quick:
		_verify()
		print("SWEEP_COPY mismatches=%d" % _mismatch)
		for k in [[1.15, 0.575, 3.1], [BodyMap.FACE_HIT, BodyMap.HEAD_HIT, BodyMap.RIB_HIT]]:
			var bw: Array = []
			var dw: Array = []
			for w in nwin:
				bw.append(_window(_played["body"][w], "body", k[0], k[1], k[2]))
				dw.append(_window(_played["default"][w], "default", k[0], k[1], k[2]))
			print("SWEEP_QUICK at %.3f/%.3f/%.2f body_crit_mean=%.1f [%s] loser_mean=%.1f [%s]" % [k[0], k[1], k[2],
				_mean_of(bw, "crit"), _list(bw, "crit"), _mean_of(dw, "loser"), _list(dw, "loser")])
		quit(0)
		return
	_unit_play()
	_verify()
	print("SWEEP_COPY mismatches=%d (the copy of add_beats against BodyMap at %.3f / %.3f / %.2f)" % [_mismatch,
		BodyMap.FACE_HIT, BodyMap.HEAD_HIT, BodyMap.RIB_HIT])
	_grid(nwin)
	quit(0)


func _beats(c: Career, f: Dictionary, r: Dictionary, plan: String, won_last: bool) -> Dictionary:
	var pack: Dictionary = super._beats(c, f, r, plan, won_last)
	_cur.append(pack["beats"])
	return pack


## A copy of BodyMap._punch_hits + add_beats with the three hit sizes as parameters (both orthodox here: def_south false).
func _apply(map: Dictionary, beats: Array, south: Dictionary, fh: float, hh: float, rh: float) -> void:
	for beat in beats:
		var m: String = str(beat["move"])
		if not (m in BodyMap.PUNCHES) or str(beat["result"]) != "lands":
			continue
		var who: String = str(beat["who"])
		var def: String = "a" if who == "b" else "b"
		var att_south: bool = bool(south.get(who, false))
		var def_south: bool = bool(south.get(def, false))
		var opp_side: String = "left" if att_south else "right"
		var mult: float = BodyMap.BIG_MULT if bool(beat.get("big", false)) else 1.0
		var h: int = hash(str(beat["t"]) + str(beat["who"]) + str(beat["move"]))
		var hits: Array = []
		if m == "jab":
			hits.append(["nose" if (h % 100) < 60 else opp_side + "_eye", fh * mult])
			hits.append(["head", hh * mult])
		elif m == "cross":
			hits.append(["nose" if (h % 100) < 50 else opp_side + "_eye", fh * mult])
			hits.append(["head", hh * mult])
		elif m == "lead_hook":
			hits.append([opp_side + "_eye", fh * mult])
			hits.append(["head", hh * 1.5 * mult])
		elif m == "rear_uppercut":
			hits.append(["nose", fh * mult])
			hits.append(["head", hh * 1.5 * mult])
		elif m == "body_hook":
			var rib := str(beat.get("side", ""))
			if rib != "left" and rib != "right":
				var liver := "left" if def_south else "right"
				var other := "right" if liver == "left" else "left"
				rib = liver if absi(h) % 100 < roundi(BodyMap.LIVER_SHARE * 100.0) else other
			hits.append([rib + "_ribs", rh * mult])
		for hit in hits:
			var place: String = hit[0]
			var dmg: float = hit[1]
			var places: Dictionary = map[def]["places"]
			var cur: float = float(places[place])
			if place in BodyMap.FACE_PLACES:
				if map[def]["cuts"].has(place) and not map[def]["closed"].get(place, false):
					dmg *= BodyMap.CUT_MULT
			cur = maxf(cur - dmg, 0.0)
			places[place] = cur
			if place in BodyMap.FACE_PLACES and cur <= BodyMap.CRITICAL:
				map[def]["cuts"][place] = true


func _replay(bout: Dictionary, south: Dictionary, fh: float, hh: float, rh: float) -> Dictionary:
	var map: Dictionary = BodyMap.fresh()
	for beats in bout["rounds"]:
		_apply(map, beats, south, fh, hh, rh)
	return map


func _verify() -> void:
	for arm in _played:
		for bouts in _played[arm]:
			for bout in bouts:
				var mine: Dictionary = _replay(bout, SOUTH, BodyMap.FACE_HIT, BodyMap.HEAD_HIT, BodyMap.RIB_HIT)
				for who in ["a", "b"]:
					for p in BodyMap.PLACES:
						if absf(BodyMap.value(mine, who, p) - BodyMap.value(bout["map"], who, p)) > 0.0001:
							_mismatch += 1


func _unit_play() -> void:
	for s in 300:
		var south := {"a": s % 2 == 1, "b": false}
		var rng := RandomNumberGenerator.new()
		rng.seed = s * 7919 + 1
		var a_round_wins := 0
		var all: Array = []
		for rn in 3:
			var a_ex := 0
			for ex in 6:
				var mine: float = 63.0 + (rng.randf() - 0.5) * BR.ROUND_SPREAD
				var theirs: float = 60.0 + (rng.randf() - 0.5) * BR.ROUND_SPREAD
				var a_won: bool = mine > theirs
				if a_won:
					a_ex += 1
				var rd := {"n": rn + 1, "won": a_won, "mine": mine, "theirs": theirs, "corner": "", "lines": [], "names": ["Lucy", "Maria"]}
				all.append(RS.build(rd, "Out-boxer", "Out-boxer", 30.0, ((s * 100 + rn) * 10 + ex))["beats"])
			if a_ex * 2 >= 6:
				a_round_wins += 1
		_unit.append({"rounds": all, "south": south, "winner": "a" if a_round_wins * 2 > 3 else "b"})


## The rib_damage_test arm reads, for one window at one setting.
func _window(bouts: Array, arm: String, fh: float, hh: float, rh: float) -> Dictionary:
	var hurt := 0
	var crit := 0
	var any35 := 0
	var loser := 0
	var doc := 0
	var fine := 0
	var more := 0.0
	var tl := 0.0
	var to := 0.0
	for bout in bouts:
		var map: Dictionary = _replay(bout, SOUTH, fh, hh, rh)
		var low := 100.0
		var low_b := 100.0
		var r35 := false
		for who in ["a", "b"]:
			var rv: float = BodyMap.value(map, who, "right_ribs")
			var lv: float = BodyMap.value(map, who, "left_ribs")
			low = minf(low, minf(rv, lv))
			r35 = r35 or rv <= BodyMap.CRITICAL or lv <= BodyMap.CRITICAL
			if who == "b":
				low_b = minf(rv, lv)
				tl += rv
				to += lv
		var tracked: float = low if arm == "default" else low_b
		more += tracked
		if (tracked < BodyMap.HURT) if arm == "default" else (tracked <= BodyMap.HURT):
			hurt += 1
		if tracked <= BodyMap.CRITICAL:
			crit += 1
		if r35:
			any35 += 1
		var mk: Dictionary = _marks(map, int(bout["a_wins"]), int(bout["rounds_n"]))
		loser += int(bool(mk["hurt"]))
		doc += int(bool(mk["doc"]))
		fine += int(bool(mk["fine"]))
	var n: float = float(bouts.size())
	return {"hurt": hurt * 100.0 / n, "crit": crit * 100.0 / n, "any35": any35 * 100.0 / n, "loser": loser * 100.0 / n,
		"doc": doc * 100.0 / n, "fine": fine * 100.0 / n, "more": more / n, "tl": tl / n, "to": to / n}


func _unit_read(fh: float, hh: float, rh: float) -> Dictionary:
	var hurt := 0
	var doc := 0
	var fine := 0
	var head_low := 0
	for u in _unit:
		var map: Dictionary = BodyMap.fresh()
		for beats in u["rounds"]:
			_apply(map, beats, u["south"], fh, hh, rh)
		var w: String = u["winner"]
		var l: String = "b" if w == "a" else "a"
		var lh := false
		var dd := false
		var wf := true
		var minv := 999.0
		var minp := ""
		for p in BodyMap.PLACES:
			var lv: float = BodyMap.value(map, l, p)
			var wv: float = BodyMap.value(map, w, p)
			lh = lh or BodyMap.band(lv) != "fine"
			dd = dd or BodyMap.band(lv) == "doctor" or BodyMap.band(wv) == "doctor"
			wf = wf and BodyMap.band(wv) == "fine"
			if lv < minv:
				minv = lv
				minp = p
		hurt += int(lh)
		doc += int(dd)
		fine += int(wf)
		head_low += int(minp == "head")
	var n: float = float(_unit.size())
	return {"loser": hurt * 100.0 / n, "doc": doc * 100.0 / n, "fine": fine * 100.0 / n, "head_low": head_low * 100.0 / n}


func _mean_of(rows: Array, key: String) -> float:
	var s := 0.0
	for r in rows:
		s += float(r[key])
	return s / float(maxi(rows.size(), 1))


func _list(rows: Array, key: String) -> String:
	var out: PackedStringArray = []
	for r in rows:
		out.append("%.1f" % float(r[key]))
	return " ".join(out)


func _grid(nwin: int) -> void:
	var faces := [1.10, 1.15, 1.20, 1.25, 1.30, 1.35, 1.40]
	var ribs := [2.6, 2.7, 2.8, 2.9, 3.0, 3.05, 3.1, 3.2, 3.3]
	var heads: Array = []
	for a in OS.get_cmdline_user_args():   # faces=1.16,1.17 ribs=2.9,3.05 narrow the grid
		if str(a).begins_with("faces="):
			faces = Array(str(a).substr(6).split(",")).map(func(x): return float(x))
		elif str(a).begins_with("ribs="):
			ribs = Array(str(a).substr(5).split(",")).map(func(x): return float(x))
		elif str(a).begins_with("heads="):   # absolute HEAD_HIT values instead of face / 2
			heads = Array(str(a).substr(6).split(",")).map(func(x): return float(x))
	# Ribs alone: the body-plan rib reads depend on RIB_HIT only.
	for rh in ribs:
		var body: Array = []
		var dflt: Array = []
		var head: Array = []
		for w in nwin:
			body.append(_window(_played["body"][w], "body", BodyMap.FACE_HIT, BodyMap.HEAD_HIT, rh))
			dflt.append(_window(_played["default"][w], "default", BodyMap.FACE_HIT, BodyMap.HEAD_HIT, rh))
			head.append(_window(_played["head"][w], "head", BodyMap.FACE_HIT, BodyMap.HEAD_HIT, rh))
		print("SWEEP_RIB %.2f body_crit_mean=%.1f [%s] body_hurt_mean=%.1f [%s] default_more=%.1f default_hurt=%.1f default_any35=%.1f head_ribs=%.1f/%.1f" % [
			rh, _mean_of(body, "crit"), _list(body, "crit"), _mean_of(body, "hurt"), _list(body, "hurt"),
			_mean_of(dflt, "more"), _mean_of(dflt, "hurt"), _mean_of(dflt, "any35"), _mean_of(head, "tl"), _mean_of(head, "to")])
	# Loser hurt (default arm) across face x rib, face:head 2:1; plus the unit list.
	for fh in faces:
		for hh in (heads if not heads.is_empty() else [fh * 0.5]):
			for rh in ribs:
				var u: Dictionary = _unit_read(fh, hh, rh)
				print("SWEEP_UNIT face %.3f head %.3f rib %.2f loser=%.1f doctor=%.1f winner_fine=%.1f head_lowest=%.1f" % [fh, hh,
					rh, float(u["loser"]), float(u["doc"]), float(u["fine"]), float(u["head_low"])])
				var dflt: Array = []
				for w in nwin:
					dflt.append(_window(_played["default"][w], "default", fh, hh, rh))
				print("SWEEP_LOSER face %.3f head %.3f rib %.2f loser_mean=%.1f [%s] doctor=%.1f winner_fine=%.1f" % [fh, hh, rh,
					_mean_of(dflt, "loser"), _list(dflt, "loser"), _mean_of(dflt, "doc"), _mean_of(dflt, "fine")])
