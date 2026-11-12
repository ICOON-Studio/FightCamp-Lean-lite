extends RefCounted
## S308: the 3D beats of one 30-second exchange (LiveRound settled it), placed at its slot in the 3:00 round. RoundScript
## builds them from the exchange's winner and band; the corner's shout opens it as a caption and the call's verdict closes
## it. Habits fire in exchanges 2 and 5 (HabitBeats caps two a pass); only the round's last exchange (or a dominant one)
## keeps its big-shot close-up. The view never decides anything.

const RoundScript := preload("res://scripts/rules/RoundScript.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const HabitBeats := preload("res://scripts/rules/HabitBeats.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const ComboWords := preload("res://scripts/rules/ComboWords.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const ClinchBeats := preload("res://scripts/rules/ClinchBeats.gd")
const BurstShape := preload("res://scripts/rules/BurstShape.gd")
const InsideBeats := preload("res://scripts/rules/InsideBeats.gd")
const InsideExits := preload("res://scripts/rules/InsideExits.gd")
const CounterCut := preload("res://scripts/rules/CounterCut.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const Bubbles := preload("res://scripts/fight3d/ReactionBubbles.gd")   # S442 BUBBLES: tags the three bubble beats
const HABITS_PATH := "res://assets/data/fight_habits.json"
## RoundScript.margin reads |mine - theirs| on the round's scale: these land each band in RoundScript's own band.
const BAND_MINE := {"close": 3.0, "clear": 10.0, "dominant": 20.0}
## The call's verdict caption comes this long before the exchange's 30 s line (FightView counts the exchange won then).
const VERDICT_LEAD_S := 2.4

static var _ring_lines: Dictionary = {}


## x = the exchange record (LiveRound), k its index, r = the closed round (only after the sixth, for counts / stoppage).
## ctx = {n, plan, a_style, b_style, seed, profiles, f, opp, names, day, won_last}. Returns beats with absolute times.
static func build(x: Dictionary, k: int, r: Dictionary, ctx: Dictionary) -> Array:
	var band := Exchanges.band(float(x["margin"]))
	var rl := {"n": int(ctx["n"]), "won": bool(x["won"]), "mine": BAND_MINE[band], "theirs": 0.0,
		"corner": str(ctx["plan"]) if k == 0 else "", "lines": [], "names": ctx["names"]}
	if k == Exchanges.EXCHANGES - 1 and not r.is_empty():
		rl["counts"] = int(r.get("counts", 0))
		rl["stopped"] = str(r.get("stopped", ""))
		if int(rl["counts"]) > 0 and str(r.get("down", "")) != "":
			# S377: the count goes to the boxer the sim put down (BoutNight: the round's loser), not the loser of this
			# exchange - a round won 4-2 with the last exchange lost knocked the round's winner down and KO'd him.
			rl["won"] = str(r["down"]) == "b"
	var plan := RoundScript.build(rl, str(ctx["a_style"]), str(ctx["b_style"]), Exchanges.EX_SECONDS, int(ctx["seed"]) + k * 13, ctx["profiles"])
	if k == 1 or k == 4:
		_habits(plan, ctx, k, str(x.get("fix", "")))
	var f: Dictionary = ctx["f"]
	ComboWords.caption(plan["beats"], {"a": f.get("combos", {}), "b": (ctx["profiles"]["b"] as Dictionary).get("combos", {})}, ctx["names"], int(ctx["day"]) + k * 17)
	_setup(plan["beats"], str(x.get("setup", "")), str(x.get("setup_combo", "")))
	_arrow(plan["beats"], x)
	_body(plan["beats"], x.get("body", []))
	# S313 real-fight gap 6: bursts of 2-5 punches and quiet spells at range (who lands what is unchanged; only when).
	# Before the game's extras and the clinches, which go into the quiet spells it opens.
	var brng := RandomNumberGenerator.new()
	brng.seed = int(ctx["seed"]) + k * 37
	BurstShape.apply(plan["beats"], brng)
	_show_game(plan["beats"], str(x["sit"]), int(ctx["seed"]) + k * 29)
	# S314 inside range (real 17-31 % of a round, ours 5 %): some bursts are fought inside, hooks and uppercuts there;
	# before the clinches, so a clinch can end a spell (who lands what is unchanged).
	var irng := RandomNumberGenerator.new()
	irng.seed = int(ctx["seed"]) + k * 41
	InsideBeats.apply(plan["beats"], {"sit": str(x["sit"])}, irng)
	_clinches(plan["beats"], x, ctx, int(ctx["seed"]) + k * 31)
	# S315: how each inside spell ends - a pivot behind a check hook, a tie-up until Break, or a step back.
	irng.seed = int(ctx["seed"]) + k * 43
	InsideExits.apply(plan["beats"], irng)
	if not OS.get_cmdline_user_args().has("nocut"):   # `nocut` = the control arm
		CounterCut.apply(plan["beats"], irng)   # S393: a punch stopped mid-throw by the other's landed shot
	var at := k * Exchanges.EX_SECONDS
	var out: Array = []
	for b in plan["beats"]:
		if bool(b.get("big", false)) and k < Exchanges.EXCHANGES - 1 and band != "dominant" and str(x.get("setup", "")) != "landed":
			b["big"] = false
		b["t"] = float(b["t"]) + at
		if b.has("break_t"):
			b["break_t"] = float(b["break_t"]) + at
		if b.has("end_t"):
			b["end_t"] = float(b["end_t"]) + at   # S314 an inside spell's end
		if b.has("pivot_t"):
			b["pivot_t"] = float(b["pivot_t"]) + at   # S315 its pivot out
		out.append(b)
	# RIBS1: _habits runs before the first _body and can turn a body dig back into a head hook; _show_game runs
	# after it and swaps body hooks into jabs and head hooks. Match the fight rules' body count once more, after
	# every punch type is final (the smaller change: one call, _show_game keeps its own dice). Singles only, as the
	# first pass: who lands and how many land stay as the round settled it; a combination or a big shot is never
	# retagged, so an exchange without enough free singles stays short. The clinch's rib digs are not applied by the
	# game (BodyLive takes punches only), so the full count goes to the punches.
	_body(out, x.get("body", []))
	# S310 the set-up fired: the corner's NOW and her combination, lands or not, with its own caption.
	if str(x.get("setup", "")) != "":
		var opp_name := str(ctx["names"][1])
		var how := "%s walks into the set-up!" % opp_name if str(x["setup"]) == "landed" else "%s saw it coming" % opp_name
		out.insert(0, {"t": at + 0.4, "who": "a", "move": "say", "result": "none", "caption": "Corner: \"NOW!\" - " + how})
	_read(out, x.get("read", {}), at, ctx["names"])
	if bool(x.get("shout", false)):
		out.insert(0, Bubbles.mark({"t": at + 0.4, "who": "a", "move": "say", "result": "none", "shout_call": str(x["call"]),
			"caption": "Corner: \"%s\"" % Exchanges.CALLS[str(x["call"])]["shout"]}, "shout", x, ctx))
	elif str(x.get("said", "")) != "":   # S442 BUBBLES: a shout she did not take in shows as Not heard (no caption, as before)
		out.insert(0, Bubbles.mark({"t": at + 0.4, "who": "a", "move": "say", "result": "none", "caption": ""}, "shout", x, ctx))
	# S339 the coach's arrow she throws in this 30 s, named (the broadcast's "which arrow she just used").
	if bool(x.get("planned", false)):
		out.append(Bubbles.mark({"t": at + 1.6, "who": "a", "move": "say", "result": "none",
			"caption": "Plan: %s" % str(StrikeMap.move(str(x["arrow"])).get("name", x["arrow"]))}, "plan", x, ctx))
		# S375 SCOUTPLAN1: the same line at the exchange's end - won or lost, and its tally over the bout so far.
		if plan_tally_caption(x) != "":
			out.append(Bubbles.mark({"t": at + Exchanges.EX_SECONDS - 2.5, "who": "a", "move": "say", "result": "none", "caption": plan_tally_caption(x)}, "plan_end", x, ctx))
	# S309: a habit punished (or the corner's fix holding) gets its own caption before the verdict.
	if str(x.get("habit_line", "")) != "":
		out.append({"t": at + Exchanges.EX_SECONDS - 6.0, "who": "a", "move": "say", "result": "none", "caption": str(x["habit_line"])})
	elif str(x.get("perk_line", "")) != "":   # S355 Counter sense: the free counter gets its caption
		out.append({"t": at + Exchanges.EX_SECONDS - 6.0, "who": "a", "move": "say", "result": "none", "caption": str(x["perk_line"])})
	out.append(Bubbles.mark({"t": at + Exchanges.EX_SECONDS - VERDICT_LEAD_S, "who": "a", "move": "say", "result": "none", "caption": str(x["verdict"])}, "coach", x, ctx))
	out.sort_custom(func(a, b): return float(a["t"]) < float(b["t"]))
	return out


## S333 THE READ fired: halfway through the exchange the opponent shows her habit once more and our fighter is already
## throwing the counter - landed, a big shot with the close-up and "READ IT!"; missed, she guessed early and is open.
const READ_LEAD := {"press": "step_in", "range": "jab", "counter": "cross", "loadup": "cross"}
const READ_MOVE := {"Lead hook": "lead_hook", "Cross": "cross", "Check hook": "lead_hook"}


## S375 SCOUTPLAN1 "PLAN: DOUBLE JAB - won it  (4/5 won)": a planned exchange's end, with the arrow's tally over the bout.
static func plan_tally_caption(x: Dictionary) -> String:
	var tl: Array = x.get("plan_tally", [])
	if not bool(x.get("planned", false)) or tl.size() != 2:
		return ""
	return "PLAN: %s - %s  (%d/%d won)" % [str(StrikeMap.move(str(x["arrow"])).get("name", x["arrow"])).to_upper(),
		"won it" if bool(x.get("won", false)) else "lost it", int(tl[0]), int(tl[1])]


static func _read(out: Array, rd: Dictionary, at: float, names: Array) -> void:
	if rd.is_empty():
		return
	var t := at + Exchanges.EX_SECONDS * 0.5
	var landed := str(rd["result"]) == "landed"
	var lead := str(READ_LEAD.get(str(rd["game"]), "jab"))
	out.append({"t": t, "who": "b", "move": lead, "result": "misses" if lead != "step_in" else "none", "caption": "",
		"big": false, "knockback": false, "def": ""})
	var cap := "READ IT! %s saw it coming - %s" % [names[0], str(rd["move"]).to_lower()] if landed 		else "%s went early - %s makes %s pay" % [names[0], names[1], names[0]]
	out.append({"t": t + 0.35, "who": "a", "move": str(READ_MOVE.get(str(rd["move"]), "cross")),
		"result": "lands" if landed else "misses", "caption": cap, "big": landed, "knockback": landed, "def": "", "read": true})


## The clue has to be what the ring shows: the game this exchange is fought in reshapes the beats (who lands how many is
## unchanged). Pressing: she steps in on the other; at range: her punches are jabs and she steps back out; loading up:
## single big rights; tiring or hurt: tired beats and holding. Our fighter tired or hurt shows the same on her.
static func _show_game(beats: Array, sit: String, seed: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var who := "a" if sit.begins_with("she_") else "b"
	var extra: Array = []
	match sit:
		"press":
			extra = ["step_in", "step_in", "step_in"]
		"range":
			extra = ["step_out", "step_out"]
			_swap(beats, who, ["jab"], 0.7, rng)
		"counter":
			extra = ["step_out"]
		"loadup":
			_swap(beats, who, ["cross", "lead_hook"], 0.8, rng)
		"tiring", "she_tired":
			extra = ["tired", "tired"]
		"hurt", "she_hurt":
			extra = ["tired"]   # S313: the holding comes from ClinchBeats
	# Into the quiet gaps (1.6 s or more between beats), one per gap.
	var gaps: Array = []
	for i in range(1, beats.size()):
		if float(beats[i]["t"]) - float(beats[i - 1]["t"]) >= 1.6:
			gaps.append(i)
	for i in range(gaps.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var tmp: int = gaps[i]
		gaps[i] = gaps[j]
		gaps[j] = tmp
	var adds: Array = []
	for j in mini(extra.size(), gaps.size()):
		var i: int = gaps[j]
		var t0 := (float(beats[i - 1]["t"]) + float(beats[i]["t"])) * 0.5
		adds.append({"t": snappedf(t0, 0.01), "who": who, "move": extra[j], "result": "none", "caption": "", "combo": false})
	beats.append_array(adds)
	beats.sort_custom(func(a, b): return float(a["t"]) < float(b["t"]))


## S313 real-fight gap 4: the exchange's clinches and the referee's breaks (ClinchBeats: 2.5 -> 4.8 a round as they tire,
## more when hurt or pressing; the tired one with the "clinches_when_tired" habit holds more).
static func _clinches(beats: Array, x: Dictionary, ctx: Dictionary, seed: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var pr: Dictionary = ctx["profiles"]
	ClinchBeats.apply(beats, {"n": int(ctx["n"]), "sit": str(x["sit"]),
		"energy": {"a": float((pr["a"] as Dictionary).get("energy", 100.0)), "b": float((pr["b"] as Dictionary).get("energy", 100.0))},
		"habits": {"a": (ctx["f"] as Dictionary).get("habits", []), "b": RoundStyle.opponent_habits(ctx["opp"])},
		"tie": x.get("clinch", {})}, rng)


## Her single punches (not part of a combination) become one of `moves`, share `odds`.
static func _swap(beats: Array, who: String, moves: Array, odds: float, rng: RandomNumberGenerator) -> void:
	for b in beats:
		if str(b["who"]) != who or str(b.get("combo_id", "")) != "" or bool(b.get("combo", false)):
			continue
		if not RoundScript.NOT_PUNCH.has(str(b["move"])) and str(b["move"]) != "say" and rng.randf() < odds:
			b["move"] = str(moves[rng.randi_range(0, moves.size() - 1)])


## S310 the set-up fired this exchange: her first punches become the combination - landed ones when it landed (the last
## is the big shot: close-up, big reaction), missed or blocked ones when it did not. Who landed how many is unchanged.
## S339 the plan's arrow in the ring: a combination arrow - her first punches of the exchange are that combination (unless
## the corner's set-up already took them); a step or a defence - the exchange opens with it (PlanFight.STEP_BEAT).
static func _arrow(beats: Array, x: Dictionary) -> void:
	if not bool(x.get("planned", false)):
		return
	var row := StrikeMap.move(str(x["arrow"]))
	if str(row.get("kind", "")) == "combo":
		if beats.any(func(b): return str(b.get("combo_id", "")) != ""):
			return
		var moves: Array = Combos.row(str(row["combo"])).get("beats", [])
		var j := 0
		for b in beats:
			if j >= moves.size():
				break
			if str(b["who"]) == "a" and RoundScript.PUNCHES.has(str(b["move"])):
				b["move"] = str(moves[j])
				b["combo"] = true
				b["combo_id"] = str(row["combo"])
				j += 1
		return
	var step := str(PlanFight.STEP_BEAT.get(PlanFight.base_id(str(x["arrow"])), ""))
	if step != "":
		var t0 := 0.6
		for b in beats:
			t0 = minf(t0, float(b["t"]))
		var sb := RoundScript._beat("a", step, "none")   # every beat carries the keys FightView reads (caption, ...)
		sb["t"] = maxf(0.0, t0 - 0.1)
		beats.push_front(sb)


static func _setup(beats: Array, how: String, combo: String) -> void:
	if how == "" or combo == "":
		return
	var moves: Array = Combos.row(combo).get("beats", [])
	var want := "lands" if how == "landed" else ""
	var mine: Array = []
	for b in beats:
		if str(b["who"]) != "a" or not RoundScript.PUNCHES.has(str(b["move"])):
			continue
		if (str(b["result"]) == "lands") == (want == "lands"):
			mine.append(b)
	for j in mini(moves.size(), mine.size()):
		var b: Dictionary = mine[j]
		b["move"] = str(moves[j])
		b["combo"] = true
		b["combo_id"] = combo
		if want == "lands" and j == mini(moves.size(), mine.size()) - 1:
			b["big"] = true


## S310: the ring lands the body shots the exchange counted (LiveRound rec "body" [hers, theirs]; the fight display counts
## them). Single landed punches (never a combo's) turn into body hooks, or back into lead hooks, until each side matches.
static func _body(beats: Array, want: Array) -> void:
	if want.size() < 2:
		return
	for side in 2:
		var who := "a" if side == 0 else "b"
		var landed := beats.filter(func(b): return str(b["who"]) == who and str(b["result"]) == "lands" and RoundScript.PUNCHES.has(str(b["move"])))
		var have := landed.filter(func(b): return str(b["move"]) == "body_hook").size()
		var free := landed.filter(func(b): return str(b.get("combo_id", "")) == "" and not bool(b.get("combo", false)) and not bool(b.get("big", false)))
		for b in free:
			if have < int(want[side]) and str(b["move"]) != "body_hook":
				b["move"] = "body_hook"
				have += 1
			elif have > int(want[side]) and str(b["move"]) == "body_hook":
				b["move"] = "lead_hook"
				have -= 1


## Fight model step 5 (S301): both boxers' habits show; Kalli's ring line captions a habit's first fire. fix = the habit
## the corner fixed this round (S309): she does not show it.
static func _habits(plan: Dictionary, ctx: Dictionary, k: int, fix: String = "") -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = int(ctx["day"]) * 53 + int(ctx["n"]) * 7 + k
	var won_last := bool(ctx.get("won_last", false))
	var mine: Array = ((ctx["f"] as Dictionary).get("habits", []) as Array).filter(func(h): return str(h) != fix)
	var fires := HabitBeats.apply(plan, {"a": mine, "b": RoundStyle.opponent_habits(ctx["opp"])},
		{"won_last": {"a": won_last, "b": int(ctx["n"]) >= 2 and not won_last}}, rng)
	var lines := ring_lines()
	var said := {}
	for fire in fires:
		var id := str(fire["habit"])
		if said.has(id) or not lines.has(id):
			continue
		for b in plan["beats"]:
			if str(b.get("habit", "")) == id and str(b["caption"]) == "":
				b["caption"] = str(lines[id]).replace("{name}", str(ctx["names"][0 if str(fire["who"]) == "a" else 1]))
				said[id] = true
				break


static func ring_lines() -> Dictionary:
	if _ring_lines.is_empty() and FileAccess.file_exists(HABITS_PATH):
		var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(HABITS_PATH))
		for row in (data as Dictionary).get("ring_lines", []) if data is Dictionary else []:
			var when := str(row.get("when", ""))
			if when.contains(" fires"):
				_ring_lines[when.get_slice(" fires", 0)] = str(row.get("line", ""))
	return _ring_lines
