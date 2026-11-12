extends SceneTree
## S442 RESULTDEFECTS1 measurements for defects 3, 4 and 5 (and the side effect of fix 1 on the replayed beats). Changes
## no game code: every arm is set from outside, through the bout's own state, on the game's own fight-night steps.
##   mode=place  defect 5: how often the plan card (rec "at") and the ring ladder (rec "place") disagree, and the bout
##               under each way of making them one (base / the ladder opens every round at long / the card opens on
##               the ladder's place).
##   mode=marks  defects 3 and 4 (+ fix 1): punches landed in the beats against the records, the body map with the
##               counts matched, the head readings (StandDown v the map), the map with the old calls-only bell tanks.
## Usage: --script res://tools/resdef_probe.gd -- mode=place|marks n=<bouts> from=<first offer day>
## Population: Lucy (Data.lucy, Out-boxer) against the division's legal opponents in turn (opp_index = day % 6), the
## result-dump plan and corner policy (shouts on the 3rd and 5th exchange, the coach's read between rounds).

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const ExchangeBeats := preload("res://scripts/fight3d/ExchangeBeats.gd")
const StandDown := preload("res://scripts/rules/StandDown.gd")
const Aftermath := preload("res://scripts/rules/Aftermath.gd")

const PLAN := [{"move": "1-2"}, {"move": "step_back", "when": "press"}, {"move": "1-2-3", "when": "counter"}]
const SHOUT_AT := [2, 4]
const CARD_RUNG := {"outside": 0, "long": 0, "mid": 1, "inside": 2, "clinch": 2}
const RUNG_CARD := ["long", "mid", "inside"]


func _initialize() -> void:
	var args := {}
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=", true, 1)
		if kv.size() == 2:
			args[kv[0]] = kv[1]
	var n := int(args.get("n", "100"))
	var from := int(args.get("from", "45"))
	if str(args.get("mode", "place")) == "place":
		_place(n, from, str(args.get("arms", "base,ladder_long,card_ladder")).split(","))
	else:
		_marks(n, from)
	quit(0)


static func _setup(day: int) -> Array:
	var c := Career.quick_start()
	c.seed = 442
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighters[0]
	f["weight"] = float(f["limit"]) - 0.3
	f["opp_index"] = day % 6
	c.day = day
	f["next_offer_day"] = day
	Bouts.day_events(c)
	if (f.get("offers", []) as Array).is_empty():
		return []
	Bouts.accept(c, str(f["offers"][0]["id"]))
	c.day = int(f["bout"]["day"]) - 1
	Bouts.weigh(c, f)
	c.day = int(f["bout"]["day"])
	return [c, f]


## The result dump's fight night, with one arm: "base", "ladder_long" (every round opens at long on the ladder) or
## "card_ladder" (every round's plan card opens where the ladder is).
static func _fight(c: Career, f: Dictionary, arm: String) -> Dictionary:
	f["arrows"] = PLAN.duplicate(true)
	var m := Bouts.fight_modal(f)
	var names := [str(f["first"]), str(f["bout"]["opp"]["first"])]
	BoutNight.fight_step(c, f, m, "start")
	_arm(m, arm)
	for n in BoutNight.rounds_of(f):
		if n > 0:
			if BoutNight.stopped(m) != "":
				break
			var last: Dictionary = (m["rounds"] as Array)[-1]
			var act := "corner:" + str(Exchanges.read(last["exchanges"], names)["call"])
			var top := {}
			for h in LiveRound.fixes(f, last):
				if int(h["paid"]) > int(top.get("paid", 0)):
					top = h
			if not top.is_empty():
				act += "|fix=" + str(top["id"])
			if arm == "ladder_long":
				f["bout"]["last_place"] = 0
			BoutNight.fight_step(c, f, m, act)
			_arm(m, arm)
		while not LiveRound.live(m).is_empty():
			if arm == "card_ladder_all":   # the plan card follows the ladder before every exchange, not only the first
				_arm(m, "card_ladder")
			var pv := LiveRound.preview(f, m)
			BoutNight.fight_step(c, f, m, "shout:" + (str(pv["coach"]) if SHOUT_AT.has(int(pv["i"])) else ""))
	BoutNight.fight_step(c, f, m, "end")
	return m


static func _arm(m: Dictionary, arm: String) -> void:
	var lv := LiveRound.live(m)
	if arm == "card_ladder" and not lv.is_empty():
		lv["at"] = RUNG_CARD[int(lv.get("place", 0))]


func _place(n: int, from: int, arms: PackedStringArray) -> void:
	var tot := {}
	for arm in arms:
		tot[arm] = {"bouts": 0, "wins": 0, "rounds": 0, "rounds_won": 0, "ex": 0, "ex_won": 0, "first": 0, "first_off": 0, "all": 0, "all_off": 0}
	var day := from
	var done := 0
	while done < n:
		day += 1
		for arm in arms:
			var cf := _setup(day)
			if cf.is_empty():
				break
			var m := _fight(cf[0], cf[1], arm)
			var t: Dictionary = tot[arm]
			t["bouts"] += 1
			t["wins"] += int(str(m["outcome"]) == "win")
			for r in m["rounds"]:
				t["rounds"] += 1
				t["rounds_won"] += int(bool(r["won"]))
				var exs: Array = r["exchanges"]
				for k in exs.size():
					var x: Dictionary = exs[k]
					t["ex"] += 1
					t["ex_won"] += int(bool(x["won"]))
					if not CARD_RUNG.has(str(x["at"])):
						continue
					var off := int(CARD_RUNG[str(x["at"])]) != int(x["place"])
					t["all"] += 1
					t["all_off"] += int(off)
					if k == 0 and int(r["n"]) > 1:
						t["first"] += 1
						t["first_off"] += int(off)
			if arm == arms[-1]:
				done += 1
	for arm in arms:
		var t: Dictionary = tot[arm]
		print("PLACE %s bouts=%d wins=%d (%.1f%%) rounds_won=%d/%d (%.1f%%) ex_won=%d/%d (%.1f%%) first_ex_r2+_off=%d/%d all_ex_off=%d/%d" % [
			arm, t["bouts"], t["wins"], 100.0 * t["wins"] / maxf(1, t["bouts"]), t["rounds_won"], t["rounds"],
			100.0 * t["rounds_won"] / maxf(1, t["rounds"]), t["ex_won"], t["ex"], 100.0 * t["ex_won"] / maxf(1, t["ex"]),
			t["first_off"], t["first"], t["all_off"], t["all"]])


func _marks(n: int, from: int) -> void:
	var t := {"bouts": 0, "rec": [0, 0], "beats": [0, 0], "ex": 0, "ex_off": 0, "ex_more": 0, "ex_fewer": 0,
		"off_clinch": 0, "off_read": 0, "off_setup": 0, "off_perk": 0}
	var heads := {"sd": {}, "map": {}, "matched": {}, "tile": {}}
	var sums := {"map": {}, "matched": {}, "old_energy": {}}
	var dmg_sum := 0.0
	var dmgs: Array = []
	var by_out := {}
	var scaled := {}
	var agree := 0
	var day := from
	while int(t["bouts"]) < n:
		day += 1
		var cf := _setup(day)
		if cf.is_empty():
			continue
		var c: Career = cf[0]
		var f: Dictionary = cf[1]
		var m := _fight(c, f, "base")
		t["bouts"] += 1
		var maps := _replay(c, f, m["rounds"], t)
		var old := _old_energy(m["rounds"])
		var map_old: Dictionary = _replay(c, f, old, {})["map"]
		for p in BodyMap.PLACES:
			_add(sums["map"], p, BodyMap.value(maps["map"], "a", p))
			_add(sums["matched"], p, BodyMap.value(maps["matched"], "a", p))
			_add(sums["old_energy"], p, BodyMap.value(map_old, "a", p))
		var same := true
		for p in BodyMap.PLACES:
			same = same and absf(BodyMap.value(maps["map"], "a", p) - BodyMap.value(m.get("body_map", BodyMap.fresh()), "a", p)) < 0.001
		agree += int(same)
		var sd: Dictionary = f.get("stand_down", {})
		_add(heads["sd"], str(sd.get("band", "stopped")), 1.0)
		_add(heads["map"], BodyMap.band(BodyMap.value(maps["map"], "a", "head")), 1.0)
		_add(heads["matched"], BodyMap.band(BodyMap.value(maps["matched"], "a", "head")), 1.0)
		var dmg := float((m.get("damage", {}) as Dictionary).get("a", 0.0))
		dmg_sum += dmg
		dmgs.append(dmg)
		var won := str(m["outcome"]) == "win"
		var el: Dictionary = (m["rounds"] as Array)[-1].get("energy", {})   # fix 1's toll option: the true bell tank
		var stop_l := str(m.get("stopped", "")) != "" and not won
		var t_old := Aftermath.toll(20.0, float(el.get("a_end_calls", el.get("a_end", 100.0))), stop_l)
		var t_new := Aftermath.toll(20.0, float(el.get("a_end", 100.0)), stop_l)
		_add(by_out, "toll_old", t_old)
		_add(by_out, "toll_new", t_new)
		_add(by_out, "rest_old", Aftermath.rest_days(t_old))
		_add(by_out, "rest_new", Aftermath.rest_days(t_new))
		_add(by_out, "spent_old", float(t_old >= 80.0))
		_add(by_out, "spent_new", float(t_new >= 80.0))
		_add(by_out, "win" if won else "loss", dmg)
		_add(by_out, "n_win" if won else "n_loss", 1.0)
		if not sd.is_empty():
			for k in [0.6, 0.8, 1.0, 1.2, 1.6, 2.2]:
				_add(scaled, "x%.1f %s" % [k, StandDown.band(clampf(100.0 - dmg * k, 0.0, 100.0))], 1.0)
		for tile in m.get("aftermath", []):
			if str(tile["id"]) == "damage":
				_add(heads["tile"], str(tile["big"]).get_slice(" ", 0) if str(tile["big"]) != "Nothing lasting" else "Nothing lasting", 1.0)
	var b := float(t["bouts"])
	print("MARKS bouts=%d replay==m.body_map in %d" % [int(b), agree])
	print("MARKS landed per bout: records %.1f v %.1f, beats %.1f v %.1f" % [t["rec"][0] / b, t["rec"][1] / b, t["beats"][0] / b, t["beats"][1] / b])
	print("MARKS exchanges off %d of %d (beats more %d, fewer %d); off with a clinch hit %d, a read %d, a set-up %d, a perk %d" % [
		t["ex_off"], t["ex"], t["ex_more"], t["ex_fewer"], t["off_clinch"], t["off_read"], t["off_setup"], t["off_perk"]])
	for k in ["map", "matched", "old_energy"]:
		var row: PackedStringArray = []
		for p in BodyMap.PLACES:
			row.append("%s %.1f" % [p, float(sums[k][p]) / b])
		print("MARKS ours mean at the last bell (%s): %s" % [k, ", ".join(row)])
	print("MARKS head: StandDown bands %s (mean damage %.1f -> head place %.1f); map head bands %s; matched map head bands %s; damage tile %s" % [
		str(heads["sd"]), dmg_sum / b, StandDown.head_place(dmg_sum / b), str(heads["map"]), str(heads["matched"]), str(heads["tile"])])
	dmgs.sort()
	print("MARKS head damage p10 %.1f p25 %.1f p50 %.1f p75 %.1f p90 %.1f; mean in a win %.1f (%d), in a loss %.1f (%d)" % [
		dmgs[int(dmgs.size() * 0.1)], dmgs[int(dmgs.size() * 0.25)], dmgs[int(dmgs.size() * 0.5)], dmgs[int(dmgs.size() * 0.75)],
		dmgs[int(dmgs.size() * 0.9)], float(by_out.get("win", 0.0)) / maxf(1.0, by_out.get("n_win", 0.0)), int(by_out.get("n_win", 0.0)),
		float(by_out.get("loss", 0.0)) / maxf(1.0, by_out.get("n_loss", 0.0)), int(by_out.get("n_loss", 0.0))])
	print("MARKS toll (fresh 20 walking in): calls-only tank %.1f, %.2f rest days, Spent %d; true tank %.1f, %.2f rest days, Spent %d" % [
		by_out["toll_old"] / b, by_out["rest_old"] / b, int(by_out["spent_old"]), by_out["toll_new"] / b, by_out["rest_new"] / b, int(by_out["spent_new"])])
	var keys := scaled.keys()
	keys.sort()
	print("MARKS stand-down bands if HEAD_PER_DAMAGE were k (non-stopped bouts): %s" % ", ".join(PackedStringArray(keys.map(func(k): return "%s=%d" % [k, int(scaled[k])]))))


static func _add(d: Dictionary, k: String, v: float) -> void:
	d[k] = float(d.get(k, 0.0)) + v


## The rounds with the bell tanks as they were before fix 1 (calls only).
static func _old_energy(rounds: Array) -> Array:
	var out: Array = rounds.duplicate(true)
	for r in out:
		var e: Dictionary = r.get("energy", {})
		if e.has("a_end_calls"):
			e["a_end"] = e["a_end_calls"]
			e["b_end"] = e["b_end_calls"]
	return out


## BoutMarks.build's path, kept by hand so each exchange's beats can be counted and a count-matched copy built.
static func _replay(c: Career, f: Dictionary, rounds: Array, t: Dictionary) -> Dictionary:
	var map := BodyMap.fresh()
	var matched := BodyMap.fresh()
	var opp: Dictionary = f["bout"]["opp"]
	var south := {"a": str(f.get("stance", "")).to_lower() == "southpaw", "b": str(opp.get("stance", "")).to_lower() == "southpaw"}
	var profiles := {"a": RoundStyle.of_fighter(f), "b": RoundStyle.from_opponent(opp)}
	var won_last := false
	for i in rounds.size():
		var r: Dictionary = rounds[i]
		var ctx := {"n": i + 1, "plan": str(r.get("corner", "")), "a_style": str(f.get("style", "")),
			"b_style": str(opp.get("style", "")), "seed": c.day * 97 + i + 1, "profiles": profiles, "f": f, "opp": opp,
			"names": [str(f.get("first", "")), str(opp.get("first", opp.get("name", "")))], "day": c.day, "won_last": won_last}
		var e: Dictionary = r.get("energy", {})
		var exs: Array = r.get("exchanges", [])
		for k in exs.size():
			for side in ["a", "b"]:
				var e0 := float(e.get(side, 100.0))
				var e1 := float(e.get(side + "_end", e0))
				profiles[side]["energy"] = lerpf(e0, e1, float(k) / Exchanges.EXCHANGES)
				profiles[side]["energy_end"] = lerpf(e0, e1, float(k + 1) / Exchanges.EXCHANGES)
			var x: Dictionary = exs[k]
			var beats := ExchangeBeats.build(x, k, r if k == exs.size() - 1 else {}, ctx)
			BodyMap.add_beats(map, beats, south)
			var got := [_landed(beats, "a").size(), _landed(beats, "b").size()]
			var want: Array = x.get("landed", [0, 0])
			if not t.is_empty():
				t["ex"] += 1
				for s in 2:
					t["rec"][s] += int(want[s])
					t["beats"][s] += int(got[s])
				if got[0] != int(want[0]) or got[1] != int(want[1]):
					t["ex_off"] += 1
					t["ex_more"] += int(got[0] + got[1] > int(want[0]) + int(want[1]))
					t["ex_fewer"] += int(got[0] + got[1] < int(want[0]) + int(want[1]))
					t["off_clinch"] += int(bool((x.get("clinch", {}) as Dictionary).get("hit", false)))
					t["off_read"] += int(not (x.get("read", {}) as Dictionary).is_empty())
					t["off_setup"] += int(str(x.get("setup", "")) != "")
					t["off_perk"] += int(not (x.get("perks", []) as Array).is_empty())
			BodyMap.add_beats(matched, _match(beats, want), south)
		BodyMap.end_round(map)
		BodyMap.end_round(matched)
		won_last = bool(r.get("won", false))
	return {"map": map, "matched": matched}


static func _landed(beats: Array, who: String) -> Array:
	return beats.filter(func(b): return str(b["who"]) == who and str(b["result"]) == "lands" and BodyMap.PUNCHES.has(str(b["move"])))


## The beats with each side's landed punches cut or padded to the record's count: the last extra landed punches miss,
## a short side lands its last landed punch again (a jab when it landed none).
static func _match(beats: Array, want: Array) -> Array:
	var out: Array = beats.duplicate(true)
	for s in 2:
		var who := "a" if s == 0 else "b"
		var mine := _landed(out, who)
		var need := int(want[s])
		var j := mine.size() - 1
		while mine.size() > need and j >= 0:
			(mine[j] as Dictionary)["result"] = "misses"
			mine.remove_at(j)
			j -= 1
		var extra := 0
		while mine.size() + extra < need:
			var src: Dictionary = (mine[-1] as Dictionary).duplicate() if not mine.is_empty() else {"who": who, "move": "jab", "result": "lands", "t": 1.0, "big": false}
			src["t"] = float(src["t"]) + 0.2 * (extra + 1)
			src["big"] = false
			out.append(src)
			extra += 1
	return out
