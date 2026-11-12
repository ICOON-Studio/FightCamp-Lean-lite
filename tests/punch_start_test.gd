extends SceneTree
## S433 PUNCHSTART1 (FIGHT_LINK_MAP_S432 M8, "one punch rule for both corners"), written from the contract:
##   every punch starts at max(Technique x its start share, RAW FLOOR), RAW FLOOR = 0.4 x mean(Accuracy, Timing);
##   our fighter's mastery (plans, fire shares) stays Technique x share - only the duel's punch level reads the floor;
##   an opponent starts on the same rule from its rating and grows each punch to its full level by 12 bouts (linear).
## 1. a fresh signing's uppercut is the raw floor, not 1; its mastery is untouched,
## 2. a 0-bout opponent at 58 (flat shape) has the same gaps as a new signing at Technique 58,
## 3. a 12-bout opponent's punches are at its rating (and 20 bouts the same); 6 bouts sits between; never falls with bouts;
##    S434 her shape sits on the start as well as the full level (a 0-bout hook-thrower has her hooks over her jab),
## 4. a professional is past the novice gaps; a dict with no record is read at its rating (fixtures, the level reads),
## 5. determinism,
## 6. S434 review: a punch on the raw floor follows Accuracy and Timing DOWN too (Technique -5: an old habit), while a punch
##    above the floor keeps its level (control arm); BoutRead's cached read follows the opponent's record (Maria at 0, 6 and
##    12 bouts read in one run, the 0-bout one first, must read three different chances),
## 7. S434 round 2: no opponent punch sits under its raw floor (every Data rival at 0, 6 and 12 bouts, pro marks removed):
##    our fighter's punch never does, and M8 says both corners keep one rule.
## Printed, not gated: each fresh signing's chance (BoutRead.chance, no camp) against its division's first offers.
## Population: Lucy (Data.lucy) and every PROSPECT as signed; opponents from Data's rivals by the division's offer list.

const Data := preload("res://scripts/state/Data.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")

## The contract's numbers (M8, ESTIMATE). Written here, not read from the rule, so the rule cannot pass by moving them.
const FLOOR_SHARE := 0.4
const FULL_AT := 12
const SHARE := {"jab": [0.85], "straight": [0.75], "hooks": [0.62, 0.5], "uppercuts": [0.0]}
const PUNCHES := ["jab", "straight", "hooks", "uppercuts"]

var failures := 0


func _initialize() -> void:
	_signing_floor()
	_novice_same_gaps()
	_grows_with_bouts()
	_pros_and_fixtures()
	_determinism()
	_floor_falls()
	_read_follows_record()
	_never_under_floor()
	_print_first_offers()
	print("PUNCH_START failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(ok: bool, label: String) -> void:
	if ok:
		print("OK  " + label)
	else:
		failures += 1
		print("FAIL " + label)


func _signed(tech := -1.0) -> Dictionary:
	var raw := Data.lucy()
	if tech >= 0.0:
		raw["stats"]["technique"] = tech
	return Data.fighter_state(raw, 0)


## The contract's start level for a punch: the mean over its moves of max(T x share, floor).
func _start(tech: float, fl: float, k: String) -> float:
	var s := 0.0
	for sh in SHARE[k]:
		s += maxf(snappedf(tech * float(sh), 0.1), fl)
	return s / float((SHARE[k] as Array).size())


func _flat(rating: float, w: int, l: int, extra := {}) -> Dictionary:
	var shape := {}
	for k in Attrs.ABILITIES + Attrs.PUNCHES:
		shape[k] = 0.0
	var b := {"name": "Test Novice %d-%d" % [w, l], "style": "Boxer-puncher", "rating": rating, "w": w, "l": l, "shape": shape}
	b.merge(extra, true)
	return b


func _signing_floor() -> void:
	var f := _signed()
	var tech := float(Data.lucy()["stats"]["technique"])
	var a := Attrs.of(f)
	var fl := FLOOR_SHARE * 0.5 * (float(a["accuracy"]) + float(a["timing"]))
	print("signing: technique %.1f  floor %.2f  jab %.2f  straight %.2f  hooks %.2f  uppercuts %.2f" % [tech, fl,
		float(a["jab"]), float(a["straight"]), float(a["hooks"]), float(a["uppercuts"])])
	_check(absf(float(a["uppercuts"]) - fl) <= 0.2, "a fresh signing's uppercut is the raw floor (%.2f vs %.2f), not 1" % [float(a["uppercuts"]), fl])
	_check(float(a["uppercuts"]) > 10.0, "the uppercut is a raw punch, well over 1 (%.2f)" % float(a["uppercuts"]))
	for k in PUNCHES:
		var want := _start(tech, fl, k)
		_check(absf(float(a[k]) - want) <= 0.2, "signing %s = max(T x share, floor) per move (%.2f vs %.2f)" % [k, float(a[k]), want])
	# Mastery stays as it was: plans and fire shares read it.
	var mv: Dictionary = f["moves"]
	_check(is_equal_approx(float(mv["Uppercut"]), 0.0) and is_equal_approx(float(mv["Check hook"]), 0.0),
		"mastery untouched: Uppercut %.1f, Check hook %.1f (never drilled)" % [float(mv["Uppercut"]), float(mv["Check hook"])])
	_check(is_equal_approx(float(mv["Jab"]), snappedf(tech * 0.85, 0.1)), "mastery untouched: Jab = T x 0.85 (%.1f)" % float(mv["Jab"]))
	# The floor follows the raw skill: a sharper technique lifts the never-drilled uppercut.
	var g := _signed(70.0)
	_check(float(Attrs.of(g)["uppercuts"]) > float(a["uppercuts"]) + 3.0, "a higher Technique lifts the raw uppercut (%.2f > %.2f)" % [
		float(Attrs.of(g)["uppercuts"]), float(a["uppercuts"])])


func _novice_same_gaps() -> void:
	var f := _signed(58.0)
	var mine := Attrs.of(f)
	var o := AttrGen.attrs_of(_flat(58.0, 0, 0))
	for k in PUNCHES:
		var gm := 58.0 - float(mine[k])
		var go := 58.0 - float(o[k])
		_check(absf(gm - go) <= 0.5, "0-bout opponent at 58 and a signing at Technique 58: same %s gap (%.2f vs %.2f)" % [k, go, gm])
	# A real novice (its own shape from style and words): the uppercut is far under the rating, the jab its best.
	var real: Dictionary = _first_opp("wlw").duplicate(true)
	real["w"] = 0
	real["l"] = 0
	var r := AttrGen.attrs_of(real)
	var lvl := float(real["rating"])
	_check(float(r["uppercuts"]) < lvl - 20.0, "a real 0-bout opponent's uppercut is raw (%.2f, rating %.1f)" % [float(r["uppercuts"]), lvl])
	_check(float(r["jab"]) > float(r["uppercuts"]), "its jab is over its uppercut (%.2f > %.2f)" % [float(r["jab"]), float(r["uppercuts"])])


func _grows_with_bouts() -> void:
	var b12 := AttrGen.attrs_of(_flat(58.0, 9, 3))
	var b20 := AttrGen.attrs_of(_flat(58.0, 14, 6))
	for k in PUNCHES:
		_check(absf(float(b12[k]) - 58.0) <= 0.01, "12-bout opponent: %s at its rating (%.2f)" % [k, float(b12[k])])
		_check(absf(float(b20[k]) - 58.0) <= 0.01, "20-bout opponent: %s at its rating (%.2f)" % [k, float(b20[k])])
	# Draws count as bouts too.
	var with_d := _flat(58.0, 5, 3)
	with_d["d"] = 4
	_check(absf(float(AttrGen.attrs_of(with_d)["uppercuts"]) - 58.0) <= 0.01, "8 bouts + 4 draws = 12 bouts: full rating")
	# Six bouts: halfway, and never down as the record grows.
	var b0 := AttrGen.attrs_of(_flat(58.0, 0, 0))
	var b6 := AttrGen.attrs_of(_flat(58.0, 4, 2))
	var up := float(b0["uppercuts"]) + (58.0 - float(b0["uppercuts"])) * 6.0 / float(FULL_AT)
	_check(absf(float(b6["uppercuts"]) - up) <= 0.2, "6 bouts: the uppercut halfway (%.2f vs %.2f)" % [float(b6["uppercuts"]), up])
	var ok := true
	var last := {}
	for n in range(0, 16):
		var a := AttrGen.attrs_of(_flat(58.0, n, 0))
		for k in PUNCHES:
			if last.has(k) and float(a[k]) + 0.0001 < float(last[k]):
				ok = false
			last[k] = float(a[k])
	_check(ok, "no punch falls as the record grows (0..15 bouts)")
	# A shaped opponent: its full punch (rating + shape) is the 12-bout level, a weak punch never rises past it.
	var shaped := _flat(58.0, 12, 0)
	shaped["shape"]["jab"] = -20.0
	shaped["shape"]["hooks"] = 9.0
	var s12 := AttrGen.attrs_of(shaped)
	_check(absf(float(s12["jab"]) - 38.0) <= 0.01 and absf(float(s12["hooks"]) - 67.0) <= 0.01,
		"12 bouts: each punch at rating + its shape (jab %.2f / 38, hooks %.2f / 67)" % [float(s12["jab"]), float(s12["hooks"])])
	shaped["w"] = 0
	var s0 := AttrGen.attrs_of(shaped)
	_check(float(s0["jab"]) <= 38.01, "0 bouts: a weak jab is not lifted past its full level (%.2f <= 38)" % float(s0["jab"]))
	# S434 review: her shape sits on the start too - a 0-bout hook-thrower's hooks are 9 over a flat novice's, and the weak
	# jab 20 under (a scouted weapon is her best punch from her first bout).
	var f0 := AttrGen.attrs_of(_flat(58.0, 0, 0))
	_check(absf(float(s0["hooks"]) - float(f0["hooks"]) - 9.0) <= 0.2 and absf(float(s0["jab"]) - float(f0["jab"]) + 20.0) <= 0.2,
		"0 bouts: her shape on the start (hooks %.2f vs flat %.2f, jab %.2f vs flat %.2f)" % [float(s0["hooks"]), float(f0["hooks"]), float(s0["jab"]), float(f0["jab"])])


func _pros_and_fixtures() -> void:
	var pro := AttrGen.attrs_of(_flat(58.0, 0, 0, {"pro": true}))
	_check(absf(float(pro["uppercuts"]) - 58.0) <= 0.01, "a professional (0-0 as a pro) is past the novice gaps (%.2f)" % float(pro["uppercuts"]))
	var row := AttrGen.attrs_of(_flat(58.0, 1, 0, {"peak_age": 28}))
	_check(absf(float(row["uppercuts"]) - 58.0) <= 0.01, "a pro table row (peak_age) is past the novice gaps (%.2f)" % float(row["uppercuts"]))
	var bare := _flat(58.0, 0, 0)
	bare.erase("w")
	bare.erase("l")
	_check(absf(float(AttrGen.attrs_of(bare)["uppercuts"]) - 58.0) <= 0.01, "no record on the dict: read at its rating")


func _determinism() -> void:
	var a1 := Attrs.of(_signed())
	var a2 := Attrs.of(_signed())
	var o1 := AttrGen.attrs_of(_flat(58.0, 3, 1))
	var o2 := AttrGen.attrs_of(_flat(58.0, 3, 1))
	var same := true
	for k in PUNCHES:
		same = same and is_equal_approx(float(a1[k]), float(a2[k])) and is_equal_approx(float(o1[k]), float(o2[k]))
	_check(same, "determinism: the same signing and the same opponent give the same punches")


func _floor_falls() -> void:
	var f := _signed(58.0)
	var a0: Dictionary = Attrs.of(f).duplicate()
	f["stats"]["technique"] = float(f["stats"]["technique"]) - 5.0
	var a1: Dictionary = Attrs.of(f)
	var fl := FLOOR_SHARE * 0.5 * (float(a1["accuracy"]) + float(a1["timing"]))
	_check(float(a1["accuracy"]) < float(a0["accuracy"]) - 4.0, "Technique -5 lowers Accuracy (%.2f -> %.2f)" % [float(a0["accuracy"]), float(a1["accuracy"])])
	_check(absf(float(a1["uppercuts"]) - fl) <= 0.2 and float(a1["uppercuts"]) < float(a0["uppercuts"]) - 1.0,
		"the raw uppercut follows the floor down (%.2f -> %.2f, floor %.2f)" % [float(a0["uppercuts"]), float(a1["uppercuts"]), fl])
	_check(absf(float(a1["jab"]) - float(a0["jab"])) <= 0.01, "a punch above the floor keeps its level (jab %.2f -> %.2f)" % [float(a0["jab"]), float(a1["jab"])])


func _read_follows_record() -> void:
	var lucy := _signed()
	var out: Array = []
	for rec in [[0, 0], [4, 2], [8, 4]]:
		var o: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
		o["w"] = rec[0]
		o["l"] = rec[1]
		out.append(BoutRead.chance(lucy, o, {}))
	_check(float(out[0]) > float(out[1]) + 0.02 and float(out[1]) > float(out[2]) + 0.02,
		"the bout read follows her record: Maria 0-0 %.3f > 4-2 %.3f > 8-4 %.3f" % [float(out[0]), float(out[1]), float(out[2])])


func _never_under_floor() -> void:
	var under := 0
	var n := 0
	var worst := 0.0
	var who := ""
	for r in _all_rivals():
		for rec in [[0, 0], [4, 2], [8, 4]]:
			var o: Dictionary = (r as Dictionary).duplicate(true)
			o.erase("pro")
			o.erase("peak_age")
			o["w"] = rec[0]
			o["l"] = rec[1]
			o["d"] = 0
			var a := AttrGen.attrs_of(o)
			var fl := FLOOR_SHARE * 0.5 * (float(a["accuracy"]) + float(a["timing"]))
			for k in PUNCHES:
				n += 1
				var gap := float(a[k]) - fl
				if gap < -0.05:
					under += 1
					if gap < worst:
						worst = gap
						who = "%s %s at %d bouts %.2f / floor %.2f" % [str(o.get("name", "")), k, rec[0] + rec[1], float(a[k]), fl]
	_check(under == 0, "no opponent punch under its raw floor: %d of %d (worst %.2f %s)" % [under, n, worst, who])


func _all_rivals() -> Array:
	var out: Array = []
	for r in Data.OPPONENTS + [Data.MISMATCH] + Data.RIVALS + Data.DIVISION_RIVALS:
		out.append(r)
	return out


func _rival(name: String) -> Dictionary:
	for r in _all_rivals():
		if str(r["name"]) == name:
			return r
	return {}


func _first_opp(div: String) -> Dictionary:
	return _rival(str((Data.DIVISIONS[div]["opponents"] as Array)[0]))


func _print_first_offers() -> void:
	var people: Array = [Data.lucy()]
	for p in Data.PROSPECTS:
		people.append(p)
	var all := 0.0
	var n := 0
	for raw in people:
		var f := Data.fighter_state((raw as Dictionary).duplicate(true), 0)
		var div := str(f.get("div", "wlw"))
		if not Data.DIVISIONS.has(div):
			continue
		var line := "MEASURE %-16s %s:" % [str(f["name"]), div]
		for nm in Data.DIVISIONS[div]["opponents"]:
			var o := _rival(str(nm))
			if o.is_empty():
				continue
			var ch := BoutRead.chance(f, o.duplicate(true), {})
			all += ch
			n += 1
			line += "  %s (%d-%d, %.1f) %.0f" % [str(nm), int(o.get("w", 0)), int(o.get("l", 0)), float(o["rating"]), ch * 100.0]
		print(line)
	print("MEASURE mean chance on the first offers: %.1f in 100 over %d offers" % [all / float(maxi(n, 1)) * 100.0, n])
