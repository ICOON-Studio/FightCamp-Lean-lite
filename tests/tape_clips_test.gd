extends SceneTree
## S343 the tape room's films (TapeClips; operator Q-S294-68 "the player watches the films and it unflods like in
## grappleflows , player has appropriate counters for each clip to make his plan"). Her file cut into 3-4 films, one tell
## each; each film a beat list for the ring and the flow it unfolds (nodes in order, the tell marked); three counters from
## the place the situation puts the fight - one answers her, one does not; the pick is a WHEN arrow in her plan.
## Population: Maria Ortega (pressure fighter, Data.OPPONENTS[0]) and Priya Nair (counter-puncher, [1]) - two different
## opponents; coverage over every opponent, rival and national-field style in the data.

const Data := preload("res://scripts/state/Data.gd")
const TapeClips := preload("res://scripts/rules/TapeClips.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const FightFlow := preload("res://scripts/rules/FightFlow.gd")
const NationalField := preload("res://scripts/state/NationalField.gd")

var failures := 0


func _initialize() -> void:
	# 1. Maria: her game, her weapon, the habit her weakness film does not show, her weakness - four films.
	var maria: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	var mc := TapeClips.clips(maria)
	var shapes: Array = mc.map(func(c): return str(c["shape"]))
	_check(shapes == ["press", "press_body", "hurt_body", "tiring"], "Maria's films: %s" % str(shapes))
	_check(str(mc[0]["title"]) == "Her game: she walks you down" and str(mc[0]["when"]) == "press", "film 1: her game, %s" % str(mc[0]["title"]))
	_check((mc[3]["opens"] as Array) == ["weakness", "habit:fades_late"], "her fading weakness film also opens the fades-late habit: %s" % str(mc[3]["opens"]))

	# 2. Priya: a different film set (a counter-puncher), first film her counters.
	var priya: Dictionary = (Data.OPPONENTS[1] as Dictionary).duplicate(true)
	var pc := TapeClips.clips(priya)
	_check(str(pc[0]["shape"]) == "counter" and str(pc[0]["when"]) == "counter", "Priya's first film: she waits to counter (%s)" % str(pc[0]["shape"]))
	_check(pc.map(func(c): return str(c["shape"])) != shapes, "two opponents, two different tapes")

	# 3. Every film in the data: beats in time order, inside the film, both women act, the tell is one of its nodes, the
	# nodes follow the beats; three counters, one that answers her and one that does not, all from the right place.
	var all: Array = []
	all.append_array(Data.OPPONENTS)
	all.append_array(Data.RIVALS)
	for st in NationalField.STYLES:
		all.append({"name": "Field " + str(st[0]), "style": st[0], "threat": st[1], "weak": st[2], "w": 3, "l": 1})
	var bad: Array = []
	var seen := {}
	for o in all:
		var cs := TapeClips.clips(o)
		if cs.size() < 2 or cs.size() > TapeClips.MAX_CLIPS:
			bad.append("%s: %d films" % [o.get("name", "?"), cs.size()])
		for c in cs:
			seen[str(c["shape"])] = true
			var ts: Array = (c["beats"] as Array).map(func(b): return float(b["t"]))
			var sorted := ts.duplicate()
			sorted.sort()
			if ts != sorted or float(ts[-1]) >= float(c["seconds"]):
				bad.append("%s %s: beats out of order or past the end" % [o.get("name", "?"), c["shape"]])
			var who := {}
			for b in c["beats"]:
				who[str(b["who"])] = true
			if not (who.has("a") and who.has("b")):
				bad.append("%s %s: one woman only" % [o.get("name", "?"), c["shape"]])
			var nodes: Array = c["nodes"]
			if nodes.size() < 3 or int(c["tell_node"]) >= nodes.size() or not bool(nodes[int(c["tell_node"])]["tell"]):
				bad.append("%s %s: %d nodes, tell %d" % [o.get("name", "?"), c["shape"], nodes.size(), int(c["tell_node"])])
			if nodes.filter(func(n): return bool(n["tell"])).size() != 1:
				bad.append("%s %s: not one tell" % [o.get("name", "?"), c["shape"]])
			var ks: Array = TapeClips.counters(str(c["when"]), TapeClips.habits_of(o))
			var fits: Array = ks.map(func(k): return str(k["fit"]))
			var card := str(PlanFight.GAME_CARD[str(c["when"])])
			if ks.size() != 3 or not fits.has("best") or fits.filter(func(f): return f != "best").is_empty():
				bad.append("%s %s: counters %s" % [o.get("name", "?"), c["when"], str(fits)])
			for k in ks:
				if str(StrikeMap.move(str(k["move"]))["from"]) != card or str(k["why"]) == "":
					bad.append("%s: %s not from %s or no why" % [c["when"], k["move"], card])
			if not FightFlow.WHEN_WORDS.has(str(c["when"])):
				bad.append("%s: when %s has no words" % [c["shape"], c["when"]])
	_check(bad.is_empty(), "every film plays, marks one tell and offers an answer and a wrong turn: %s" % str(bad.slice(0, 6)))
	_check(seen.size() >= 10, "the data uses %d different films" % seen.size())

	# 4. The counters: the answer is not always the first button; a hurt woman who hits back changes the answer
	# (PlanFight.refine hurt -> hurt_danger: the straight 1-2, not the walk to the corner).
	var firsts := {}
	for w in ["press", "range", "counter", "loadup", "tiring", "hurt"]:
		var ks: Array = TapeClips.counters(w)
		for i in ks.size():
			if str(ks[i]["fit"]) == "best":
				firsts[i] = true
				break
	_check(firsts.size() >= 2, "the answer moves between buttons: positions %s" % str(firsts.keys()))
	var plain := TapeClips.counters("hurt").map(func(k): return [str(k["move"]), str(k["fit"])])
	var danger := TapeClips.counters("hurt", ["digs_body_when_hurt"]).map(func(k): return [str(k["move"]), str(k["fit"])])
	_check(plain != danger, "a hurt woman who digs back reads differently: %s vs %s" % [str(plain), str(danger)])
	var undrilled: Array = TapeClips.counters("range", [], {"Jab": 60.0}).filter(func(k): return str(k["grey"]) != "")
	_check(not undrilled.is_empty(), "a combination she cannot throw yet is greyed with its reason")

	# 5. The pick: a WHEN arrow on her plan; a second pick for the same situation replaces it, the any-time arrow stays.
	var plan := PlanFight.starter()
	plan = TapeClips.pick(plan, "press", "step_back")
	_check(plan.size() == 5 and TapeClips.answer(plan, "press") == "step_back", "the pick is an arrow 'if she presses: Step back' (%s)" % str(plan))
	plan = TapeClips.pick(plan, "press", "slip 2-3")
	_check(plan.size() == 5 and TapeClips.answer(plan, "press") == "slip 2-3" and plan.any(func(a): return str(a["move"]) == "step_back" and str(a.get("when", "")) == ""),
		"a second pick replaces the first, the starter's any-time step back stays")
	_check(bool(PlanBoard.validate(plan, StrikeMap.MOVES, PlanBoard.arrow_limit(58.0), FightFlow.WHEN_WORDS)["ok"]), "the plan stays legal for a sessional coach")
	_check(TapeClips.answer(plan, "range") == "", "no arrow yet for 'if she boxes at range'")

	# 6. Watching a film opens what it shows in her file (and only once).
	var m2: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	var c2: Array = TapeClips.clips(m2)
	_check(not OppFile.known(m2, "weakness"), "her weakness is hidden before the tape")
	var opened := TapeClips.watched(m2, c2[3])
	_check(opened == ["weakness", "habit:fades_late"] and OppFile.known(m2, "weakness") and OppFile.known(m2, "habit:fades_late"), "the weakness film opens %s" % str(opened))
	_check(TapeClips.watched(m2, c2[3]).is_empty(), "watched again: nothing new")
	_check(OppFile.film_depth(m2) == 2, "two of four hidden tells found: film depth 2 (%d)" % OppFile.film_depth(m2))
	_check(TapeClips.watched(m2, c2[0]).is_empty(), "her game was free at booking: its film opens nothing new")

	# 7. SPOT (operator "wanna try also your idea ?"): three different choices with the film's own words among them; a right
	# call only inside her moment and with the right words; a top rival's moment is shorter than a novice's.
	var bad_spot: Array = []
	for o in all:
		for c in TapeClips.clips(o):
			var ch: Array = TapeClips.spot_choices(c)
			var uniq := {}
			for w in ch:
				uniq[str(w)] = true
			if ch.size() != 3 or uniq.size() != 3 or not ch.has(str(TapeClips.SPOT_WORDS[str(c["shape"])])):
				bad_spot.append("%s: %s" % [c["shape"], str(ch)])
	_check(bad_spot.is_empty(), "every film's SPOT list: three different, its own among them %s" % str(bad_spot.slice(0, 4)))
	var pres: Dictionary = mc[1]
	var w := TapeClips.spot_window(pres, maria)
	var right := str(TapeClips.SPOT_WORDS[str(pres["shape"])])
	var wrong: String = TapeClips.spot_choices(pres).filter(func(x): return x != right)[0]
	_check(TapeClips.spot_ok(pres, maria, (w.x + w.y) * 0.5, right), "SPOT in her moment with the right words: found")
	_check(not TapeClips.spot_ok(pres, maria, (w.x + w.y) * 0.5, wrong), "the wrong words: not found")
	_check(not TapeClips.spot_ok(pres, maria, w.x - 0.5, right) and not TapeClips.spot_ok(pres, maria, w.y + 0.5, right), "too early or too late: not found")
	var top := maria.duplicate(true)
	top["rating"] = 72.0
	var nov := maria.duplicate(true)
	nov["rating"] = 57.0
	var wt := TapeClips.spot_window(pres, top)
	var wn := TapeClips.spot_window(pres, nov)
	_check(wt.y - wt.x < wn.y - wn.x, "a top rival hides it better: %.1f s to spot vs %.1f s" % [wt.y - wt.x, wn.y - wn.x])
	_check(TapeClips.known(maria, mc[0]) and not TapeClips.known((Data.OPPONENTS[0] as Dictionary).duplicate(true), mc[1]), "her game is known at booking, her weapon is not")

	print("TAPE CLIPS %s (%d failures)" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
	print("%s  %s" % ["ok  " if ok else "FAIL", what])
