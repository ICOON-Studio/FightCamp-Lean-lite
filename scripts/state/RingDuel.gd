extends RefCounted
## S398 the fighter model inside the watched bout: each exchange LiveRound fights also has a PLACE (Duels' ladder) and a
## duel there, read from her attributes (Attrs) against the opponent's profile (AttrGen), tired, hurt and the form on the
## night. The corner's call steers her want; the opponent's game steers theirs. BoutRead walks the same maths in expectation
## (mean_edges). Pure static on the career dicts; zero state outside f["bout"] and the live round.

const Attrs := preload("res://scripts/rules/Attrs.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const Duels := preload("res://scripts/rules/Duels.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const ClinchRest := preload("res://scripts/rules/ClinchRest.gd")
const PaceAim := preload("res://scripts/rules/PaceAim.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const WorldBout := preload("res://scripts/world/WorldBout.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const TheRead := preload("res://scripts/rules/TheRead.gd")

## Form on the night (GV). Narrower than WorldBout's: the wide off-night was swallowing a good plan.
const FORM_SD := 5.0   # watched bout. World bouts stay at 8 so a big gap is never a sure win.
## The place a corner call asks for: only the calls about distance (Jab and move, Go to the body, Tie up); every other
## call leaves the place to her own choice (measured S398: forcing the pocket on "Draw the lead" made a right answer cost
## more than silence, exchanges_test).
const CALL_PLACE := {"long": 0, "lead": 0, "body": 2, "tie": 2}   # "Draw the lead": feints from range
## The place the opponent's game wants.
const MODE_PLACE := {"press": 2, "range": 0, "counter": 1, "loadup": 1, "tiring": 0, "hurt": 2}
## The opponent's games by the place they belong to (best-response bias on Exchanges.next_mode, systems critic round 2).
const PLACE_MODES := [["range"], ["counter", "loadup"], ["press"]]
const BIAS := 1.0


## Stats and footwork to the nearest point, so a day's training reuses the page's last read of the same fighter.
static func stat_bucket(f: Dictionary) -> String:
	var s := ""
	var stats: Dictionary = f.get("stats", {})
	for k in stats:
		s += "%s%d" % [str(k), int(round(float(stats[k])))]
	return s + "f%d" % int(round(float(f.get("footwork", 0.0))))


## The opponent's attributes (level = rating, shape from the file's words or the world's own shape).
static func opp(o: Dictionary) -> Dictionary:
	return AttrGen.attrs_of(o)


## Body facts between her and the opponent.
static func facts(f: Dictionary, o: Dictionary) -> Dictionary:
	return Duels.facts(f, o)


## The form both bring on the night, rolled once a bout (seeded by the career day and the fighter): [hers, theirs].
static func form(f: Dictionary, salt: int) -> Array:
	var fb: Dictionary = f["bout"]
	if not fb.has("form"):
		var rng := RandomNumberGenerator.new()
		rng.seed = salt * 7919 + 398
		fb["form"] = [rng.randfn(0.0, FORM_SD), rng.randfn(0.0, FORM_SD)]
	return fb["form"]


## Multipliers on the opponent's game weights: the games of the place they do best at, by ring IQ.
static func mode_bias(f: Dictionary, o: Dictionary) -> Dictionary:
	var fb: Dictionary = f.get("bout", {})
	if fb.has("mode_bias"):
		return fb["mode_bias"]
	var a := Attrs.of(f)
	var b := opp(o)
	var best := Duels.best_place(b, a, Duels.flip(facts(f, o)))
	var out := {}
	for m in PLACE_MODES[best]:
		out[m] = 1.0 + BIAS * clampf(Duels.v(b, "ring_iq") / 100.0, 0.0, 1.0)
	if not fb.is_empty():
		fb["mode_bias"] = out
	return out


## Opens a round on the ladder. Round 1 is long; later rounds carry the place where the last bell ended.
static func open(lv: Dictionary) -> void:
	lv["place"] = int(lv.get("place", Duels.LONG))
	lv["pins"] = [0, 0]


## One exchange: where it is fought and her duel edge there. call = her call ("" = her own choice), mode = the opponent's
## game, energies now, hurt flags. Returns {edge, place, stepin, a_best, b_best, tie}.
static func step(f: Dictionary, o: Dictionary, lv: Dictionary, call: String, mode: String, ea: float, eb: float,
		rng: RandomNumberGenerator) -> Dictionary:
	var n := int(lv.get("n", 1))
	var a := Duels.effective(Attrs.of(f), ea, bool(lv.get("her_hurt", false)), n >= 3)
	var b := Duels.effective(opp(o), eb, bool(lv.get("opp_hurt", false)), n >= 3)
	var ctx := facts(f, o)
	var place := int(lv.get("place", Duels.LONG))
	var fa := int(CALL_PLACE.get(call, -1))
	var fb := int(MODE_PLACE.get(mode, -1))
	var pins: Array = lv.get("pins", [0, 0])
	var st := Duels.step(a, b, place, ctx, fa, fb, pins, rng.randf(), rng.randf(), rng.randf())
	lv["place"] = int(st["place"])
	lv["pins"] = [Duels.pin_next(int(pins[0]), int(st["wa"]), int(st["place"])), Duels.pin_next(int(pins[1]), int(st["wb"]), int(st["place"]))]
	var c := ctx.duplicate()
	c["stepin"] = int(st["stepin"])
	var d := Duels.at(a, b, int(st["place"]), c)
	var fm: Array = f["bout"].get("form", [0.0, 0.0])
	d["edge"] = float(d["edge"]) + float(fm[0]) - float(fm[1])
	d["place"] = int(st["place"])
	d["stepin"] = int(st["stepin"])
	d["pinned"] = int(lv["pins"][0]) >= Duels.PINNED_AFTER
	d["wa"] = int(st["wa"])
	d["wb"] = int(st["wb"])
	d["a_stance"] = str(f.get("stance", "orthodox"))
	d["b_stance"] = str(o.get("stance", "orthodox"))
	return d


## The knockdown side of a profile (WorldBout's): the punch, the chin, the heart.
static func side(a: Dictionary) -> Dictionary:
	return {"power": 0.7 * Duels.v(a, "power") + 0.3 * Duels.v(a, "accuracy"), "chin": Duels.v(a, "chin"), "heart": Duels.v(a, "heart")}


## The expected duel edge of each exchange of round n (BoutRead): her energies ea / theirs eb per exchange (Arrays of 6),
## her call's place (-1 = her choice), the opponent's place chances (from the game mix). Returns {edges, share}.
static func mean_edges(f: Dictionary, o: Dictionary, n: int, ea: Array, eb: Array, call: String, opp_wants: Array,
		start_states: Dictionary = {}) -> Dictionary:
	var a0 := Attrs.of(f)
	var b0 := opp(o)
	var ctx := facts(f, o)
	var reach := float(ctx.get("reach", 0.0))
	var height := float(ctx.get("height", 0.0))
	var south := int(ctx.get("southpaw", 0))
	var mid := 2
	var a := Duels.effective(a0, float(ea[mid]), false, n >= 3)
	var b := Duels.effective(b0, float(eb[mid]), false, n >= 3)
	var pa: Array = Duels.wants(a, b, ctx, int(CALL_PLACE.get(call, -1)))
	var per_b: bool = opp_wants.size() > 0 and opp_wants[0] is Array
	var pb: Array = opp_wants[mid] if per_b else opp_wants
	var v := [0.0, 0.0, 0.0]
	if start_states.is_empty():
		v[Duels.LONG] = 1.0
	else:
		for s in start_states:
			v[int(s.x)] += float(start_states[s])
	var ed := PackedFloat32Array()
	ed.resize(9)
	var have := PackedByteArray()
	have.resize(9)
	var trans: Array = [[0.0, 0.0, 0.0], [0.0, 0.0, 0.0], [0.0, 0.0, 0.0]]
	var ev := [0.0, 0.0, 0.0]
	for s0 in 3:
		for xa in 3:
			if float(pa[xa]) <= 0.0:
				continue
			for xb in 3:
				var pw := float(pa[xa]) * float(pb[xb])
				if pw <= 0.0:
					continue
				WorldBout._pour(a, b, s0, xa, xb, pw, ev, trans, ed, have, reach, height, south)
	var edges: Array = []
	var share := [0.0, 0.0, 0.0]
	var nn := float(Exchanges.EXCHANGES)
	for i in Exchanges.EXCHANGES:
		var e := float(v[0]) * float(ev[0]) + float(v[1]) * float(ev[1]) + float(v[2]) * float(ev[2])
		edges.append(e)
		for p in 3:
			share[p] += float(v[p]) / nn
		var nv := [0.0, 0.0, 0.0]
		for s0 in 3:
			for s1 in 3:
				nv[s1] += float(v[s0]) * float(trans[s0][s1])
		v = nv
	var states := {}
	for p in 3:
		if v[p] > 0.0:
			states[Vector3i(p, 0, 0)] = v[p]
	return {"edges": edges, "share": share, "states": states}


## The opponent's place chances from a mix of games ({mode: share}).
static func wants_of_mix(mix: Dictionary) -> Array:
	var out := [0.0, 0.0, 0.0]
	var total := 0.0
	for m in mix:
		var p := int(MODE_PLACE.get(str(m), 1))
		out[p] += float(mix[m])
		total += float(mix[m])
	if total <= 0.0:
		return [0.0, 1.0, 0.0]
	for p in 3:
		out[p] = float(out[p]) / total
	return out


## Her mean duel edge over a fresh round against this opponent, her own choice of place (the combination lab's gap).
static func mean_edge(f: Dictionary, o: Dictionary) -> float:
	var full: Array = []
	full.resize(Exchanges.EXCHANGES)
	full.fill(100.0)
	var mix: Dictionary = (Exchanges.STYLE_MODES.get(str(o.get("style", "")), Exchanges.STYLE_MODES["Boxer-puncher"]) as Dictionary)
	var ex := mean_edges(f, o, 1, full, full, "", wants_of_mix(mix))
	var s := 0.0
	for e in ex["edges"]:
		s += float(e) / float(Exchanges.EXCHANGES)
	return s


## The report's line for the deciding duel: "Lucy's jab against Maria's head movement", only when that duel decided it -
## the counterfactual (systems critic): without the place's edge the exchange flips or is cut to under half. "" otherwise.
static func duel_line(rec: Dictionary, names: Array) -> String:
	var won := bool(rec.get("won", false))
	var de := float(rec.get("duel_edge", 0.0))
	var m := float(rec.get("margin", 0.0))
	if (won and de <= 0.0) or (not won and de >= 0.0):
		return ""
	var without := m - de
	if signf(without) == signf(m) and absf(without) >= absf(m) * 0.5:
		return ""
	var stance := str(rec.get("a_stance" if won else "b_stance", "orthodox"))
	return Duels.duel_words(str(names[0 if won else 1]), str(names[1 if won else 0]),
		str(rec.get("a_best" if won else "b_best", "")), stance)


## The round report's two lines (boxing critic, round 1 item 5: who controlled the range, the duel that decided it):
## "Inside 4 of 6 (2 on the ropes): Maria walked Lucy down." and "The duel that decided it: Lucy's jab against Maria's head
## movement (3 of 6)." Either is left out when nothing stands out. names = [hers, the opponent's].
static func round_lines(exs: Array, names: Array) -> Array:
	if exs.is_empty() or not (exs[0] as Dictionary).has("place"):
		return []
	var at := [0, 0, 0]
	var pinned := 0
	var duels := {}
	for x in exs:
		at[int(x["place"])] += 1
		pinned += 1 if bool(x.get("pinned", false)) else 0
		var l := str(x.get("duel_line", ""))
		if l != "":
			duels[l] = int(duels.get(l, 0)) + 1
	var top := 0
	for p in 3:
		if int(at[p]) > int(at[top]):
			top = p
	var out: Array = []
	var where := "%s %d of %d" % [str(PLACE_WORD_CAP[top]), int(at[top]), exs.size()]
	if pinned > 0:
		where += " (%d on the ropes)" % pinned
	var who := ""
	if top == Duels.LONG:
		who = "%s kept it long." % _keeper(exs, names, Duels.LONG)
	elif top == Duels.INSIDE:
		who = "%s got inside." % _keeper(exs, names, Duels.INSIDE)
	else:
		who = "%s and %s stood and traded." % [str(names[0]), str(names[1])]
	if int(at[top]) * 2 > exs.size():
		out.append("%s: %s" % [where, who])
	var best := ""
	for l in duels:
		if best == "" or int(duels[l]) > int(duels[best]):
			best = str(l)
	if best != "" and int(duels[best]) >= 2:
		out.append("The duel that decided it: %s (%d of %d)." % [best, int(duels[best]), exs.size()])
	return out


const PLACE_WORD_CAP := ["At range", "In the pocket", "Inside"]


## Whose want the place was (blind reader S398: "Maria kept it long" went to a pressure fighter when it credited the
## winner): the side that asked for this place more often in the exchanges fought there; the winner when neither did.
static func _keeper(exs: Array, names: Array, place: int) -> String:
	var won := 0
	var n := 0
	var a_want := 0
	var b_want := 0
	for x in exs:
		if int(x["place"]) == place:
			n += 1
			won += 1 if bool(x["won"]) else 0
			a_want += 1 if int(x.get("wa", -1)) == place else 0
			b_want += 1 if int(x.get("wb", -1)) == place else 0
	if a_want != b_want:
		return str(names[0]) if a_want > b_want else str(names[1])
	return str(names[0]) if won * 2 >= n else str(names[1])


## [the place the opponent does best at against her, the place it does worst] (the tale of the tape's line).
static func wins_breaks(f: Dictionary, o: Dictionary) -> Array:
	var a := Attrs.of(f)
	var b := opp(o)
	var ctx := Duels.flip(facts(f, o))
	var best := 0
	var worst := 0
	var vals: Array = []
	for p in 3:
		vals.append(float(Duels.at(b, a, p, ctx)["edge"]))
	for p in 3:
		if float(vals[p]) > float(vals[best]):
			best = p
		if float(vals[p]) < float(vals[worst]):
			worst = p
	return [best, worst]


## Her energy as exchange i starts (the round's start -> bell, less what the calls spent and the body shots she took).
static func her_energy(lv: Dictionary, i: int) -> float:
	var e: Dictionary = lv["e"]
	return lerpf(float(e.get("a", 100.0)), float(e.get("a_end", 100.0)), float(i) / Exchanges.EXCHANGES) - float(lv["cost"]) \
		- float((lv.get("body", {}) as Dictionary).get("a", 0)) * float(lv.get("body_cost_a", Exchanges.BODY_COST))


static func opp_energy(lv: Dictionary, i: int) -> float:
	var e: Dictionary = lv["e"]
	return lerpf(float(e.get("b", 100.0)), float(e.get("b_end", 100.0)), float(i) / Exchanges.EXCHANGES) \
		- float((lv.get("body", {}) as Dictionary).get("b", 0)) * float(lv.get("body_cost_b", Exchanges.BODY_COST))


## What the fight display shows after i exchanges.
static func state(lv: Dictionary, i: int) -> Dictionary:
	var bt: Dictionary = lv.get("body", {})
	return {"a": maxf(0.0, her_energy(lv, i)), "b": maxf(0.0, opp_energy(lv, i)),
		"body": [int(bt.get("a", 0)), int(bt.get("b", 0))],
		"hurt": [bool(lv.get("her_hurt", false)), bool(lv.get("opp_hurt", false))]}


## End of an exchange: the clinch line, the tank, who is hurt, the opponent's next game. Updates lv and rec in place.
static func settle(lv: Dictionary, rec: Dictionary, s: Dictionary, rng: RandomNumberGenerator, vals: Dictionary,
		opp: Dictionary, f: Dictionary, call: String, pace: String, fire: bool, cl: Dictionary, st: Dictionary,
		n: int, i: int, perks: Array, names: Array, arrow: String, sit: String, rd: Dictionary) -> void:
	var exs: Array = lv["ex"]
	rec["clinch"] = cl
	rec["clinch_line"] = ClinchRest.line(cl, names, ClinchRest.why(str(opp.get("style", "")), float(opp.get("rating", 60.0)), float(vals.get("technique", 55.0))))
	rec["perks"] = perks
	rec["perk_line"] = "%s makes %s miss and counters - Counter sense." % names if perks.has("counter_sense") else ""
	lv["at"] = PlanFight.where_next(arrow, bool(s["won"]), sit)
	exs.append(rec)
	if call != "":
		lv["cost"] = float(lv["cost"]) + float(Exchanges.CALLS[call]["cost"])
	if not cl.is_empty():
		lv["cost"] = float(lv["cost"]) - ClinchRest.refill(call)
	var e0: Dictionary = lv["e"]
	var drop := maxf(0.0, float(e0.get("a", 100.0)) - float(e0.get("a_end", 100.0))) / Exchanges.EXCHANGES
	lv["cost"] = float(lv["cost"]) + drop * (PaceAim.spend(pace) - 1.0) - PaceAim.recover(pace)
	var su: Dictionary = lv.get("setup", {})
	lv["cost"] = float(lv["cost"]) + float((lv.get("talk", {}) as Dictionary).get("cost", 0.0)) \
		+ (Combos.combo_cost((Combos.row(str(su.get("combo", ""))).get("moves", []) as Array).size()) if fire else 0.0)
	var ks := side(Attrs.of(f))
	var ko := side(opp(opp))
	lv["opp_hurt"] = (float(s["margin"]) > Exchanges.HURT_AT and rng.randf() < clampf(0.3 + (float(ks["power"]) - float(ko["chin"])) / 100.0, 0.1, 0.6)) \
		or str(rec["setup"]) == "landed"
	lv["her_hurt"] = float(s["margin"]) < -Exchanges.HURT_AT and rng.randf() < clampf((0.3 + (float(ko["power"]) - float(ks["chin"])) / 100.0) \
		* float((lv.get("talk", {}) as Dictionary).get("hurt", 1.0)) * (1.6 if str(rec["setup"]) == "missed" or str(rd.get("result", "")) == "missed" else 1.0), 0.1, 0.8)
	rec["after"] = state(lv, i + 1)
	var run := 0
	for j in range(exs.size() - 1, -1, -1):
		if str((exs[j] as Dictionary)["mode"]) != str(lv["mode"]):
			break
		run += 1
	lv["mode"] = Exchanges.next_mode(str(opp.get("style", "")), str(opp.get("weak", "")), n, i + 1, str(lv["mode"]),
		opp_energy(lv, i + 1), bool(lv["opp_hurt"]), rng, run, mode_bias(f, opp))
	if TheRead.dropped(st, str(lv["mode"])):
		lv["mode"] = TheRead.swap(st, str(lv["mode"]), n + i)
