extends SceneTree
## S538 REPEATREAD1 greybox (owner Q-S294-301: "maybe add a penalty if some combos are repeated too often the have a bigger
## chance to be read by the opponent for a counter punch"; owner rule S534: probe a new mechanic on a greybox FIRST).
## Nothing under scripts/ is changed. The game's own bout is played (Bouts.fight_step "sim": the real plan pick, fire
## rule, dice); the greybox rule is then laid over the bout's recorded exchanges, ON against OFF on the same bouts:
##   - a planned line thrown more than FREE times in her last WINDOW exchanges can be READ: chance = (uses - FREE) * STEP
##     * iq (the opponent's rating: 0.5 at 55, 1.0 at 65, 1.5 at 75) * COUNTER_STYLE for a counter-puncher, capped at CAP;
##   - a read exchange is countered: its margin drops COUNTER power points (an exchange's dice span 66, a best answer is +9);
##   - the read fades when she switches: only the last WINDOW exchanges count (a round is 6).
## Greybox limits, said out loud: the penalty moves the exchange's own margin only (not the energy, hurt or ring position
## after it), and a bout the game stopped keeps its result in both arms. Rounds: most exchanges won (Exchanges.round_of).
## Population: 60 boxers made from Data.lucy, every one with different stats, style and drilled combinations (seeded),
## against six opponents of six styles (the first Pressure fighter, Counter-puncher, Volume puncher, Boxer-puncher,
## Out-boxer and Slugger in Data), NIGHTS nights each. Three plans a boxer:
##   SPAM   one line: the best answer to the opponent's main game, on the card that game is fought on;
##   WEAPON that line as the main weapon + the best line on every other card (variety away from the weapon);
##   SPREAD no any-time weapon on the main card: a different answer for each situation (press, range, counter, loadup).
## Bars, fixed before the run: (a) SPAM loses 5+ wins in 100 against the counter-puncher and 2+ overall, rule ON v OFF;
## (b) with the rule ON, WEAPON still beats SPREAD in at least one style; (c) each (a) effect is over 2 standard errors.
## Usage: godot --headless --script res://tools/repeatread_probe.gd -- [nights=3] [boxers=60] [out=docs/REPEATREAD1_RESULT.md]

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const SM := preload("res://scripts/rules/StrikeMap.gd")

const WINDOW := 6
const FREE := 2
const STEP := 0.12
const CAP := 0.6
const COUNTER_STYLE := 1.75
const COUNTER := 14.0
const STYLES := ["Out-boxer", "Pressure fighter", "Counter-puncher", "Volume puncher", "Boxer-puncher"]
const ARMS := ["SPAM", "WEAPON", "SPREAD"]
const COUNTS := ["planned", "thrown"]   # what the opponent counts: the plan's own lines only, or every move thrown

var _out: PackedStringArray = []


func _initialize() -> void:
	var args := {}
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=", true, 1)
		if kv.size() == 2:
			args[kv[0]] = kv[1]
	var nights := int(args.get("nights", "3"))
	var n_box := int(args.get("boxers", "60"))
	var opps := _opponents()
	var boxers: Array = []
	for i in n_box:
		boxers.append(_boxer(i))
	_say("# REPEATREAD1 greybox result (S538)")
	_say("")
	_say("Rule: window %d, free %d, step %.2f, cap %.2f, counter-puncher x%.2f, a read costs %.0f power points. %d boxers x %d opponents x %d nights = %d bouts a plan." % [
		WINDOW, FREE, STEP, CAP, COUNTER_STYLE, COUNTER, n_box, opps.size(), nights, n_box * opps.size() * nights])
	for count in COUNTS:
		_say("")
		_say("## Counting %s" % ("only the plan's own lines (a line that fired as planned)" if count == "planned" else "every move she throws (the plan's line or her instinct on that range)"))
		_say("")
		_say("| plan | opponent's style | bouts | wins OFF | wins ON | change | 2 x error | counted throws a bout (of 18) | reads a bout | top move's share |")
		_say("|---|---|---|---|---|---|---|---|---|---|")
		var cell := {}   # "ARM|style" -> stats
		for arm in ARMS:
			var total := _stats()
			for opp in opps:
				var st := _stats()
				for bi in boxers.size():
					for night in nights:
						_bout(boxers[bi], opp, str(arm), 40 + bi * 7 + night * 131, st, str(count))
				cell["%s|%s" % [arm, opp["style"]]] = st
				_row(str(arm), str(opp["style"]), st)
				for k in st:
					total[k] = total[k] + st[k]
			cell["%s|ALL" % arm] = total
			_row(str(arm), "ALL SIX", total)
		_say("")
		_bars(cell, opps)
	var path := str(args.get("out", "docs/REPEATREAD1_RESULT.md"))
	var fa := FileAccess.open("res://" + path, FileAccess.WRITE)
	fa.store_string("\n".join(_out) + "\n")
	fa.close()
	print("REPEATREAD_PROBE done -> %s" % path)
	quit(0)


func _say(line: String) -> void:
	_out.append(line)
	print(line)


static func _stats() -> Dictionary:
	return {"n": 0.0, "off": 0.0, "on": 0.0, "d": 0.0, "d2": 0.0, "reads": 0.0, "top": 0.0, "planned": 0.0}


func _row(arm: String, style: String, st: Dictionary) -> void:
	var n := maxf(1.0, st["n"])
	_say("| %s | %s | %d | %.1f%% | %.1f%% | %+.1f | %.1f | %.1f | %.2f | %.0f%% |" % [arm, style, int(n), 100.0 * st["off"] / n, 100.0 * st["on"] / n,
		_delta(st), 2.0 * _err(st), st["planned"] / n, st["reads"] / n, 100.0 * st["top"] / maxf(1.0, st["planned"])])


## Wins in 100, ON minus OFF, and its standard error (the same bouts in both arms: the per-bout difference's spread).
static func _delta(st: Dictionary) -> float:
	return 100.0 * st["d"] / maxf(1.0, st["n"])


static func _err(st: Dictionary) -> float:
	var n := maxf(2.0, st["n"])
	var mean: float = st["d"] / n
	return 100.0 * sqrt(maxf(0.0, st["d2"] / n - mean * mean) / n)


func _bars(cell: Dictionary, opps: Array) -> void:
	var cp: Dictionary = cell["SPAM|Counter-puncher"]
	var all: Dictionary = cell["SPAM|ALL"]
	var a_ok := _delta(cp) <= -5.0 and _delta(all) <= -2.0
	_say("- Bar (a) SPAM loses 5+ in 100 against the counter-puncher and 2+ overall: %+.1f and %+.1f -> %s" % [_delta(cp), _delta(all), "PASS" if a_ok else "FAIL"])
	var where: PackedStringArray = []
	for opp in opps:
		var w: Dictionary = cell["WEAPON|%s" % opp["style"]]
		var s: Dictionary = cell["SPREAD|%s" % opp["style"]]
		var gap: float = 100.0 * (w["on"] / maxf(1.0, w["n"]) - s["on"] / maxf(1.0, s["n"]))
		if gap > 0.0:
			where.append("%s %+.1f" % [opp["style"], gap])
	_say("- Bar (b) with the rule ON a plan with a main weapon still beats the even spread somewhere: %s -> %s" % [
		", ".join(where) if not where.is_empty() else "nowhere", "PASS" if not where.is_empty() else "FAIL"])
	var c_ok := absf(_delta(cp)) > 2.0 * _err(cp) and absf(_delta(all)) > 2.0 * _err(all)
	_say("- Bar (c) the effect is larger than the cell's error (2 standard errors): counter-puncher %.1f v %.1f, overall %.1f v %.1f -> %s" % [
		absf(_delta(cp)), 2.0 * _err(cp), absf(_delta(all)), 2.0 * _err(all), "PASS" if c_ok else "FAIL"])
	_say("")
	_say("VERDICT: %s" % ("PASS" if a_ok and c_ok and not where.is_empty() else "FAIL"))


## Six opponents, six styles: the first of each style in Data.OPPONENTS + Data.RIVALS.
static func _opponents() -> Array:
	var out: Array = []
	var seen := {}
	for o in Data.OPPONENTS + Data.RIVALS:
		if not seen.has(str(o["style"])):
			seen[str(o["style"])] = true
			out.append((o as Dictionary).duplicate(true))
	return out


## Boxer i: Lucy's sheet with her own stats (+-7 a stat), style and drilled combinations (35-85), all seeded.
static func _boxer(i: int) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = 538000 + i * 97
	var base: Dictionary = Data.lucy()
	base["id"] = "probe%d" % i
	base["style"] = STYLES[i % STYLES.size()]
	for k in (base["stats"] as Dictionary):
		base["stats"][k] = float(base["stats"][k]) + rng.randf_range(-7.0, 7.0)
	base["drill"] = rng.randf_range(35.0, 85.0)
	return base


## The three plans against this opponent (lines she can throw, the best fit first: PlanLines.options).
static func _plan(arm: String, f: Dictionary, opp: Dictionary) -> Array:
	var game := OppFile.main_game(opp)
	var card := str(PlanFight.GAME_CARD.get(game, "long"))
	var plan: Array = []
	var weapon := _best(card, game, f, [])
	if arm != "SPREAD" and weapon != "":
		plan.append({"move": weapon})
	if arm == "WEAPON":
		for p in PlanLines.PLACES:
			var id := _best(str(p), game, f, [weapon]) if str(p) != card else ""
			if id != "" and plan.size() < 4:
				plan.append({"move": id})
	if arm == "SPREAD":
		var used: Array = []
		for w in ["press", "range", "counter", "loadup"]:
			var id2 := _best(PlanLines.place_for(w), w, f, used)
			if id2 != "":
				used.append(id2)
				plan.append({"move": id2, "when": w})
	return plan


static func _best(place: String, sit: String, f: Dictionary, skip: Array) -> String:
	for o in PlanLines.options(place, sit, f.get("moves", {}), f.get("combos", {})):
		if str(o["why"]) == "" and not skip.has(str(o["id"])):
			return str(o["id"])
	return ""


func _bout(sheet: Dictionary, opp_row: Dictionary, arm: String, day: int, st: Dictionary, count_what: String) -> void:
	var c := Career.quick_start()
	c.seed = 538
	c.fighters.append(Data.fighter_state(sheet.duplicate(true), c.day))
	c.day = day
	c.coach = {}
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	var combos := {}
	for mv in SM.MOVES:
		if str(mv.get("kind", "")) == "combo":
			combos[str(mv["combo"])] = float(sheet["drill"])
	f["combos"] = combos
	for k in (f.get("steps", {}) as Dictionary):   # her steps and defences drilled like her combinations: a line she can fire
		f["steps"][k] = float(sheet["drill"])
	var opp: Dictionary = opp_row.duplicate(true)
	f["arrows"] = _plan(arm, f, opp)
	f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 0, "rounds": 3}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "sim")
	var rounds: Array = m["rounds"]
	var stopped := BoutNight.stopped(m) != ""
	var iq := clampf(0.5 + (float(opp.get("rating", 60.0)) - 55.0) / 20.0, 0.5, 1.5) * (COUNTER_STYLE if str(opp["style"]) == "Counter-puncher" else 1.0)
	var rng := RandomNumberGenerator.new()
	rng.seed = hash("%s|%s|%d|%s" % [sheet["id"], opp["name"], day, arm])
	var recent: Array = []   # her last WINDOW exchanges: the planned line thrown, or ""
	var count := {}
	var planned := 0
	var reads := 0
	var off_r := 0
	var on_r := 0
	for r in rounds:
		var on_exs: Array = []
		for x in r["exchanges"]:
			var e: Dictionary = (x as Dictionary).duplicate()
			var line := str(x.get("arrow", "")) if (count_what == "thrown" or bool(x.get("planned", false))) else ""
			var roll := rng.randf()
			if line != "":
				planned += 1
				count[line] = int(count.get(line, 0)) + 1
				var chance := minf(CAP, maxf(0.0, float(recent.count(line) - FREE)) * STEP * iq)
				if roll < chance:
					reads += 1
					e["margin"] = float(x["margin"]) - COUNTER
					e["won"] = float(e["margin"]) >= 0.0
			recent.append(line)
			if recent.size() > WINDOW:
				recent.pop_front()
			on_exs.append(e)
		off_r += int(bool(Exchanges.round_of(r["exchanges"])["won"]))
		on_r += int(bool(Exchanges.round_of(on_exs)["won"]))
	var real_win := str(m.get("outcome", "")) == "win"
	var off := float(real_win) if stopped else float(off_r * 2 > rounds.size())
	var on := float(real_win) if stopped else float(on_r * 2 > rounds.size())
	var top := 0
	for k in count:
		top = maxi(top, int(count[k]))
	st["n"] += 1.0
	st["off"] += off
	st["on"] += on
	st["d"] += on - off
	st["d2"] += (on - off) * (on - off)
	st["reads"] += float(reads)
	st["top"] += float(top)
	st["planned"] += float(planned)
