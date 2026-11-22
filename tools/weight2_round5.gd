extends RefCounted
## S536 WEIGHT2R5 - round 5's own questions for the WEIGHT2 probe (tools/weight2_probe.gd calls these; the model is
## tools/weight2_model.gd). policy = the critic's item 1 (the same kilos by DIET / WATER / MIX / UP), frame = item 2,
## field = item 3 (the field's cut, and a plan that reads it off the tape), scales = item 4. Nothing here is in scripts/.

const Model := preload("res://tools/weight2_model.gd")
const Data := preload("res://scripts/state/Data.gd")

const OVERS := [3.0, 4.0, 5.0, 6.0]

static func _lead_text(best: String, ties: Array) -> String:
	return best if ties.is_empty() else "%s (= %s)" % [best, ", ".join(ties)]

## A change between two cells: each one's best is outside the other's leading group.
static func _flip(a: Array, b: Array) -> bool:
	return not b.has(a[0]) and not a.has(b[0])

## Item 1. The same kilos, four ways, for every boxer 3 / 4 / 5 / 6 % over his line, on each scale. Returns the bar.
static func policy(M: Model, seeds: int, bouts: int) -> bool:
	var P: Array = Model.POLICIES
	M.say(["## 5. Item 1: the same kilos by DIET, by WATER, MIXED or carried UP (%d seeds a cell, %d bout slots)" % [seeds, bouts], "",
		"Every boxer is put 3, 4, 5 and 6 % over his own class line (his Data walking weight is not used here) and the same kilos come off four ways. In all four the first 2 % is water (free).",
		"DIET = a Lean diet takes what it can of the rest (up to 2.5 % of body, at 0.7 % a week, training gain x (1 - 0.12 per 1 % held)), water the remainder. WATER = no diet (Hold), all of it by water in fight week.",
		"MIX = half the rest by diet, half by water. UP = nothing comes off: the class above (one rung, a smaller man there, a shorter one), or at a club show his own class when he is still inside the gap of a class opponent (WeighGap: 2.5 kg to 65, 5 kg over).",
		"Nobody is asked here (no refusal): the table prices the kilos, not his answer. Two missed scales still move him up.", "",
		"### 5.1 What each policy is (the 60 kg man's sums; the shares are the same for every boxer, only the club show's gap differs by class)", "",
		"| Scale | Over | Policy | Class | Diet | Weeks | Training kept | Water | Stamina, day 1 | Stamina, day 3 | Scale missed (Discipline 34 / 80) | Size gap |", "| :--- | ---: | :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |"])
	var ex: Dictionary = Model.BOXERS[4]
	var t_lo := Model.person("samira"); var t_hi := Model.person("josh")
	for sc in Model.SCALES:
		for x in OVERS:
			for pol in P:
				var cell := {"b": ex, "sc": sc, "x": x, "id": "x"}
				var pl := Model.plan_policy(cell, pol)
				var te := Model.person(str(ex["who"]))
				var su: Dictionary = M.night(te, pl, sc, "")
				var d3: Dictionary = M.night(te, pl, sc, "", -1.0, int(sc["days"]) - 1)
				M.say("| %s | +%.0f %% | %s | %.0f%s | %.1f %% | %.1f | %.0f %% | %.1f %% | -%.1f %% | %s | %.0f / %.0f in 100 | %+.1f %% |" % [sc["id"], x, pol, su["limit"], " (carried)" if bool(pl["carried"]) else "", su["diet"], su["weeks"],
					float(su["keep"]) * 100.0, su["water"], su["cond_pct"], ("-%.1f %%" % float(d3["cond_pct"])) if int(sc["days"]) > 1 else "-",
					float(M.night(t_lo, pl, sc, "")["p_miss"]) * 100.0, float(M.night(t_hi, pl, sc, "")["p_miss"]) * 100.0, su["gap"]])
	M.say("")
	var ok := false
	var note: Array = []
	for sc in Model.SCALES:
		var sid := str(sc["id"])
		M.say(["### 5.%d %s: ladder place at the end (lower is better; +- one standard error)" % [2 + Model.SCALES.find(sc), sc["name"]], "",
			"| Boxer (Stamina, Discipline) | Over | DIET | WATER | MIX | UP | Best | CUT a rule? |", "| :--- | ---: | ---: | ---: | ---: | ---: | :--- | :--- |"])
		var leads := {}     # who -> over -> leading group
		var count := {"DIET": 0, "WATER": 0, "MIX": 0, "UP": 0}
		for b in Model.BOXERS:
			var t := Model.person(str(b["who"]))
			leads[b["who"]] = {}
			for x in OVERS:
				var cell := {"b": b, "sc": sc, "x": x, "id": "%s / %s / +%.0f" % [b["shape"], sid, x]}
				var by := {}; var ag := {}
				for pol in P:
					var runs: Array = []
					var pl := M.plans_policy(cell, pol)
					for s in seeds:
						runs.append(M.run(cell, pl, s, bouts, ""))
					by[pol] = runs
					ag[pol] = Model.agg(runs)
				var best := Model.best(ag, P)
				var ties: Array = Model.ties(by, best, P)
				leads[b["who"]][x] = [best] + ties
				count[best] += 1
				var up: Dictionary = Model.plan_policy(cell, "UP")
				M.say("| %s (%.0f, %.0f) | +%.0f %% | %.2f +- %.2f | %.2f +- %.2f | %.2f +- %.2f | %.2f +- %.2f | %s | %s |" % [b["shape"], t["stats"]["conditioning"], t["personality"]["discipline"], x,
					ag["DIET"]["rung"], ag["DIET"]["se"], ag["WATER"]["rung"], ag["WATER"]["se"], ag["MIX"]["rung"], ag["MIX"]["se"], ag["UP"]["rung"], ag["UP"]["se"], _lead_text(best, ties),
					"UP = carried, own class" if bool(up["carried"]) else "UP = the class above"])
			print("policy %s / %s done, %d bouts, %.0f s" % [sid, b["shape"], M.n_bouts, M.secs()])
		var by_over: Array = []; var by_boxer: Array = []; var stam := 0; var disc := 0
		for b in Model.BOXERS:
			for i in OVERS.size():
				for j in range(i + 1, OVERS.size()):
					var a: Array = leads[b["who"]][OVERS[i]]; var c: Array = leads[b["who"]][OVERS[j]]
					if _flip(a, c):
						by_over.append("%s +%.0f %% %s -> +%.0f %% %s" % [b["shape"], OVERS[i], a[0], OVERS[j], c[0]])
		for x in OVERS:
			for i in Model.BOXERS.size():
				for j in range(i + 1, Model.BOXERS.size()):
					var bi: Dictionary = Model.BOXERS[i]; var bj: Dictionary = Model.BOXERS[j]
					var a: Array = leads[bi["who"]][x]; var c: Array = leads[bj["who"]][x]
					if _flip(a, c):
						by_boxer.append("+%.0f %%: %s %s, %s %s" % [x, bi["shape"], a[0], bj["shape"], c[0]])
						var si := float(Model.person(str(bi["who"]))["stats"]["conditioning"]); var sj := float(Model.person(str(bj["who"]))["stats"]["conditioning"])
						if (si > 60.0) != (sj > 60.0): stam += 1
						if [str(bi["who"]), str(bj["who"])] == ["samira", "josh"]: disc += 1
		var top := 0
		for pol in P:
			top = maxi(top, int(count[pol]))
		var holds := not by_over.is_empty() and not by_boxer.is_empty()
		ok = ok or holds
		note.append("%s: %s" % [sid, "both changes" if holds else ("one policy best in all 20 cells: a rule" if top == 20 else "not both changes")])
		M.say(["", "Best counts: %s." % str(count),
			"The best policy changes with how far over he is (same boxer): %d pairs%s." % [by_over.size(), "" if by_over.is_empty() else " - " + "; ".join(by_over.slice(0, 8)) + (" ..." if by_over.size() > 8 else "")],
			"The best policy changes with the boxer (same %% over): %d pairs%s." % [by_boxer.size(), "" if by_boxer.is_empty() else " - " + "; ".join(by_boxer.slice(0, 8)) + (" ..." if by_boxer.size() > 8 else "")],
			"Of those boxer pairs, %d sit on opposite sides of Stamina 60 (the fade line: big chin 64 and volume 65 over it; puncher 60, cutter 58 and boxer-puncher 57 not), and %d are the Discipline 34 against the Discipline 80 boxer." % [stam, disc],
			"Bar on this scale (both kinds of change): %s." % ("MET" if holds else "not met"), ""])
	M.say(["Item 1's bar (inside ONE scale the best policy changes with how far over he is AND with the boxer): **%s** (%s)." % ["MET" if ok else "NOT MET", "; ".join(note)], ""])
	return ok

## Item 2. Frame is on in every table above; this reads round 4's class choices for it. Returns the bar.
static func frame(M: Model, cells: Array, main: Dictionary, lead: Dictionary, aggs: Dictionary) -> bool:
	M.say(["## 6. Item 2: frame back on", "",
		"Every opponent above has a height and a reach drawn from the class boxed at (AttrGen.body: 172 cm at 60 kg, 1 cm a kg, women 8 cm shorter, reach = height + 3, each +- 4), from that division's own sheet.",
		"So moving DOWN meets shorter men with shorter arms, moving UP taller ones; the game reads reach on the long jab (Duels.REACH_PER_CM) and height inside (Duels.HEIGHT_PER_CM). The lever table (section 4, frame) is the control arm.", "",
		"| Boxer | Style | Reach against his own class | against the class below | against the class above | DOWN: place behind the cell's best (club / champ / pro) | UP: place behind the best (club / champ / pro) |", "| :--- | :--- | ---: | ---: | ---: | :--- | :--- |"])
	var jab: Array = []; var chin := ""; var chin_reach := 999.0
	var down_ok: Array = []; var up_ok: Array = []
	for b in Model.BOXERS:
		var t := Model.person(str(b["who"]))
		var f := Data.fighter_state(t.duplicate(true), Model.DAY0)
		var sx := str(t["sex"])
		var r_own := float(f["reach"]) - float(Model.class_frame(sx, Model.limit0(t))[1])
		if str(t["style"]) == "Out-boxer" or str(t["style"]) == "Boxer-puncher":
			jab.append(str(b["shape"]))
		if float(t["stats"]["chin"]) >= 64.0 and r_own < chin_reach:
			chin = str(b["shape"]); chin_reach = r_own
		var dn: Array = []; var up: Array = []
		for cell in cells:
			if cell["b"] != b:
				continue
			var id := str(cell["id"])
			var ag: Dictionary = aggs[id]
			var top := float(ag[lead[id][0]]["rung"])
			for pair in [["DOWN", dn], ["UP", up]]:
				var ch := str(pair[0])
				var inl: bool = (lead[id] as Array).has(ch)
				(pair[1] as Array).append("%+.2f%s" % [float(ag[ch]["rung"]) - top, " (best)" if lead[id][0] == ch else (" (tied)" if inl else "")])
		M.say("| %s | %s | %+.0f cm | %+.0f cm | %+.0f cm | %s | %s |" % [b["shape"], t["style"], r_own, float(f["reach"]) - float(Model.class_frame(sx, Model.class_step(t, -1))[1]),
			float(f["reach"]) - float(Model.class_frame(sx, Model.class_step(t, 1))[1]), " / ".join(dn), " / ".join(up)])
	for cell in cells:
		var id := str(cell["id"])
		if jab.has(str(cell["b"]["shape"])) and (lead[id] as Array).has("DOWN"):
			down_ok.append(id)
		if str(cell["b"]["shape"]) == chin and (lead[id] as Array).has("UP"):
			up_ok.append(id)
	var ok := not down_ok.is_empty() and not up_ok.is_empty()
	M.say(["", "The boxers who work off the jab (Out-boxer, Boxer-puncher): %s. Moving DOWN is best or tied for them in: %s." % [", ".join(jab), ", ".join(down_ok) if not down_ok.is_empty() else "no cell"],
		"The chin with no reach (Chin 64 or more, the least reach against the class): %s (%+.0f cm). Moving UP is best or tied in: %s." % [chin, chin_reach, ", ".join(up_ok) if not up_ok.is_empty() else "no cell"],
		"Item 2's bar (DOWN best or tied for a jabber, UP for the chin with no reach): **%s**." % ("MET" if ok else "NOT MET"), ""])
	return ok

## Item 3. What the field pays for its cut, whether it shows late, and whether a plan that reads the cut off the tape gains.
static func field(M: Model, cells: Array, main: Dictionary, seeds: int, bouts: int) -> void:
	M.say(["## 7. Item 3: the field cuts too", "",
		"Each night's opponent took off one of the scale's cuts (drawn evenly) and pays John's table for it: the cost comes off his rating as the mean of the six stats, except that a cut worth 15 % of Stamina or more",
		"makes him a fader on the game's own word (\"Fades\": AttrGen takes 14 off his Stamina, he tires from round 3, BoutRules.OPP_FADE), so a hard cut shows late and not in round 1. On a championship's later days the cost carries, for him as for us.", "",
		"| Scale | He took off | Rings over the line | Stamina | Power | Reading | Off his rating | Fades late |", "| :--- | ---: | ---: | ---: | ---: | ---: | ---: | :--- |"])
	var te := Model.person("danny")
	for sc in Model.SCALES:
		for c in sc["opp_cut"]:
			for d in ([0, int(sc["days"]) - 1] if int(sc["days"]) > 1 else [0]):
				var dm := 1.0
				for i in d:
					dm = 1.0 + float(Model.MODEL["carry"]) * dm
				var oc := Model.cost(sc, float(c), dm)
				var ni: Dictionary = M.night(te, Model.plan_choice({"b": Model.BOXERS[4], "sc": sc}, "STAY"), sc, "", -1.0, d, float(c))
				M.say("| %s%s | %.0f %% | %+.1f %% | -%.1f %% | -%.1f %% | -%.1f %% | %.2f points | %s |" % [sc["id"], "" if d == 0 else ", day %d" % (d + 1), float(c), (float(ni["opp_ring"]) / float(ni["limit"]) - 1.0) * 100.0,
					oc["cond"], oc["power"], oc["read"], ni["drop"], "yes" if bool(ni["fade"]) else "no"])
	M.say(["", "The refit of the field is in section 0. On the tape the cut is a RANGE (Knowledge): the read is his true cut +- %.1f %%. The plan can use it: when the read says %.0f %% or more," % [float(Model.MODEL["read_width"]), float(Model.MODEL["read_hard"])],
		"the corner calls \"Let your hands go\" from round 3 (the best call against a tiring man, Exchanges.MODES) instead of its own pick. Three arms on the pro scale, STAY, %d seeds, the same nights:" % seeds,
		"blind (the game's corner, as everywhere above), the ranged read, and an exact read. Hard cutters = the nights he took off 9 or 10 % (two in five).", "",
		"| Boxer | Arm | Win, all bouts | Win against the hard cutters | Late rounds won against the hard cutters | against the rest | Place |", "| :--- | :--- | ---: | ---: | ---: | ---: | ---: |"])
	var tot := {}
	for cell in cells:
		if str(cell["sc"]["id"]) != "pro":
			continue
		var pl := M.plans_choice(cell, "STAY", "")
		for arm in ["blind", "range", "exact"]:
			var runs: Array = []
			if arm == "blind":
				runs = (main[cell["id"]]["STAY"] as Array).slice(0, seeds)
			else:
				for s in seeds:
					runs.append(M.run(cell, pl, s, bouts, "", arm))
			var ag := Model.agg(runs)
			var sm: Dictionary = ag["sum"]
			if not tot.has(arm):
				tot[arm] = {"w": 0.0, "n": 0.0, "hw": 0.0, "hn": 0.0, "hlw": 0.0, "hln": 0.0, "lw": 0.0, "ln": 0.0, "rung": 0.0, "runs": []}
			var tt: Dictionary = tot[arm]
			tt["w"] += float(sm["wins"]); tt["n"] += float(sm["fought"]); tt["hw"] += float(sm["hard_w"]); tt["hn"] += float(sm["hard_n"])
			tt["hlw"] += float(sm["hard_lw"]); tt["hln"] += float(sm["hard_ln"]); tt["lw"] += float(sm["late_w"]); tt["ln"] += float(sm["late_n"])
			(tt["runs"] as Array).append_array(runs)
			M.say("| %s | %s | %.0f %% | %.0f %% (%d bouts) | %.0f %% | %.0f %% | %.2f +- %.2f |" % [cell["b"]["shape"], arm, float(ag["win"]) * 100.0, float(sm["hard_w"]) / maxf(1.0, float(sm["hard_n"])) * 100.0, int(sm["hard_n"]),
				float(sm["hard_lw"]) / maxf(1.0, float(sm["hard_ln"])) * 100.0, (float(sm["late_w"]) - float(sm["hard_lw"])) / maxf(1.0, float(sm["late_n"]) - float(sm["hard_ln"])) * 100.0, ag["rung"], ag["se"]])
		print("read %s done, %d bouts, %.0f s" % [cell["id"], M.n_bouts, M.secs()])
	M.say("")
	for arm in ["blind", "range", "exact"]:
		var tt: Dictionary = tot[arm]
		var d: Array = Model.diff(tt["runs"], tot["blind"]["runs"])
		M.say("All five, %s: win %.1f %%; against the hard cutters %.1f %% (%d bouts); late rounds won against them %.1f %%, against the rest %.1f %%; place against blind %+.2f +- %.2f rungs." % [arm, tt["w"] / maxf(1.0, tt["n"]) * 100.0,
			tt["hw"] / maxf(1.0, tt["hn"]) * 100.0, int(tt["hn"]), tt["hlw"] / maxf(1.0, tt["hln"]) * 100.0, (tt["lw"] - tt["hlw"]) / maxf(1.0, tt["ln"] - tt["hln"]) * 100.0, d[0], d[1]])
	M.say(["", "Read it as: the first number pair says whether the field's cut has teeth (a hard cutter should be easier to beat late than the rest); the place against blind says whether reading it off the tape is worth anything to the plan.", ""])

## Item 4. The three scales side by side, from the cell tables.
static func scales(M: Model, cells: Array, main: Dictionary, lead: Dictionary) -> void:
	M.say(["## 8. Item 4: the design's three scales, side by side", "",
		"| Scale | A missed scale is | Best choice, cell by cell (boxer order: puncher, volume, big chin, cutter, boxer-puncher) | Scales missed a run (STAY / CUT) | Bouts lost to the scale a run (STAY / CUT) | Bouts boxed a run (STAY) |", "| :--- | :--- | :--- | ---: | ---: | ---: |"])
	var words := {"gap": "the gap rule: on if still inside the gap, else re-matched 1 in 3, else off and $300; nothing on the record", "walkover": "a walkover loss and out of the draw; two move him up", "fine": "a fine, he boxes on; two move him up"}
	for sc in Model.SCALES:
		var bests: Array = []
		var ms := 0.0; var mc := 0.0; var vs := 0.0; var vc := 0.0; var fo := 0.0; var n := 0.0; var nc := 0.0
		for cell in cells:
			if cell["sc"] != sc:
				continue
			var id := str(cell["id"])
			bests.append(_lead_text(str(lead[id][0]), (lead[id] as Array).slice(1)))
			var st := Model.agg(main[id]["STAY"])
			ms += float(st["missed"]); vs += float(st["void"]); fo += float(st["fought"]); n += 1.0
			if (main[id] as Dictionary).has("CUT"):
				var cu := Model.agg(main[id]["CUT"])
				mc += float(cu["missed"]); vc += float(cu["void"]); nc += 1.0
		M.say("| %s | %s | %s | %.2f / %.2f | %.2f / %.2f | %.1f |" % [sc["name"], words[str(sc["miss"])], "; ".join(bests), ms / n, mc / maxf(1.0, nc), vs / n, vc / maxf(1.0, nc), fo / n])
	M.say(["", "The championship's second and third days are where a cut past the free 2 %% is paid again: section 5.1 prints the Stamina cost on day 1 and on day 3 (x %.2f by the third day at a carry of %.2f a day)." % [1.0 + float(Model.MODEL["carry"]) * (1.0 + float(Model.MODEL["carry"])), float(Model.MODEL["carry"])], ""])
