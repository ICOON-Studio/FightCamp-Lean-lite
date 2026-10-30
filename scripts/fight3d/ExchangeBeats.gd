extends RefCounted
## S308: the 3D beats of one 30-second exchange (LiveRound settled it), placed at its slot in the 3:00 round. RoundScript
## builds them from the exchange's winner and band; the corner's shout opens it as a caption and the call's verdict closes
## it. Habits fire in exchanges 2 and 5 (HabitBeats caps two a pass); only the round's last exchange (or a dominant one)
## keeps its big-shot close-up. The view never decides anything.

const RoundScript := preload("res://scripts/rules/RoundScript.gd")
const HabitBeats := preload("res://scripts/rules/HabitBeats.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const ComboWords := preload("res://scripts/rules/ComboWords.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const HABITS_PATH := "res://assets/data/fight_habits.json"
## RoundScript.margin reads |mine - theirs| on the round's scale: these land each band in RoundScript's own band.
const BAND_MINE := {"close": 3.0, "clear": 10.0, "dominant": 20.0}

static var _ring_lines: Dictionary = {}


## x = the exchange record (LiveRound), k its index, r = the closed round (only after the sixth, for counts / stoppage).
## ctx = {n, plan, a_style, b_style, seed, profiles, f, opp, names, day, won_last}. Returns beats with absolute times.
static func build(x: Dictionary, k: int, r: Dictionary, ctx: Dictionary) -> Array:
	var band := Exchanges.band(float(x["margin"]))
	var rl := {"n": int(ctx["n"]), "won": bool(x["won"]), "mine": BAND_MINE[band], "theirs": 0.0,
		"corner": str(ctx["plan"]) if k == 0 else "", "lines": []}
	if k == Exchanges.EXCHANGES - 1 and not r.is_empty():
		rl["counts"] = int(r.get("counts", 0))
		rl["stopped"] = str(r.get("stopped", ""))
	var plan := RoundScript.build(rl, str(ctx["a_style"]), str(ctx["b_style"]), Exchanges.EX_SECONDS, int(ctx["seed"]) + k * 13, ctx["profiles"])
	if k == 1 or k == 4:
		_habits(plan, ctx, k, str(x.get("fix", "")))
	var f: Dictionary = ctx["f"]
	ComboWords.caption(plan["beats"], {"a": f.get("combos", {}), "b": (ctx["profiles"]["b"] as Dictionary).get("combos", {})}, ctx["names"], int(ctx["day"]) + k * 17)
	_show_game(plan["beats"], str(x["sit"]), int(ctx["seed"]) + k * 29)
	var at := k * Exchanges.EX_SECONDS
	var out: Array = []
	for b in plan["beats"]:
		if bool(b.get("big", false)) and k < Exchanges.EXCHANGES - 1 and band != "dominant":
			b["big"] = false
		b["t"] = float(b["t"]) + at
		out.append(b)
	if bool(x.get("shout", false)):
		out.insert(0, {"t": at + 0.4, "who": "a", "move": "say", "result": "none", "caption": "Corner: \"%s\"" % Exchanges.CALLS[str(x["call"])]["shout"]})
	# S309: a habit punished (or the corner's fix holding) gets its own caption before the verdict.
	if str(x.get("habit_line", "")) != "":
		out.append({"t": at + Exchanges.EX_SECONDS - 6.0, "who": "a", "move": "say", "result": "none", "caption": str(x["habit_line"])})
	out.append({"t": at + Exchanges.EX_SECONDS - 2.4, "who": "a", "move": "say", "result": "none", "caption": str(x["verdict"])})
	out.sort_custom(func(a, b): return float(a["t"]) < float(b["t"]))
	return out


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
			extra = ["clinch", "tired", "clinch"]
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


## Her single punches (not part of a combination) become one of `moves`, share `odds`.
static func _swap(beats: Array, who: String, moves: Array, odds: float, rng: RandomNumberGenerator) -> void:
	for b in beats:
		if str(b["who"]) != who or str(b.get("combo_id", "")) != "" or bool(b.get("combo", false)):
			continue
		if not RoundScript.NOT_PUNCH.has(str(b["move"])) and str(b["move"]) != "say" and rng.randf() < odds:
			b["move"] = str(moves[rng.randi_range(0, moves.size() - 1)])


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
