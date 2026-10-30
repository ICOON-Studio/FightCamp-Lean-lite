extends RefCounted
## What the 3D ring shows in one round, made from the round the words already settled (Kalli K-FIGHT3D1, verbatim in
## E:/FightCamp/Game/Godot/research/K_FIGHT3D1_KALLI.md). The view never decides anything: the winner, the margin and
## the corner call come in; beats come out.
##   build(round, a_style, b_style, seconds, seed) -> {n, winner, margin, seconds, end, beats: [{t, who, move, result, caption, big}]}
## round = Bouts' round {n, won, mine, theirs, corner, lines}; "a" is our fighter (red corner), "b" the opponent.
## Rules (Kalli): landed punches close 4-3, clear 5-2, dominant 6-1 (+ one knockback); 9 beats, the rest blocked, missed or
## footwork (the loser takes more of the blocked and missed); the winner steps in, the loser steps out (an out-boxer winner
## flips it); the winner lands last; in rounds 2+ the first two beats show the corner call; exchanges 1-5 s apart, the
## last beat at least 2 s before the bell. PURE (one pure preload).
## profiles (fight model step 3) = {"a": RoundStyle profile, "b": ...}: the counts above stay; WHAT each throws comes from
## her mastery, how a punch is stopped from the other's defense/footwork ("def" on the beat), combo length from speed,
## tired beats from conditioning, an extra step from footwork. A side with no profile keeps the generic mix.

const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const Combos := preload("res://scripts/rules/Combos.gd")

const SECONDS := 40.0
const BEATS := 9
## Blocked or missed punches a round, on top of the landed ones (about a third of what is thrown lands).
const WINNER_MISSES := 6
const LOSER_MISSES := 8
## S302 (operator: "still too slow"): punches in an exchange start 0.35 s apart, the real contact-to-contact time of
## alternating-hand combinations (Piorkowski, Lees & Barton 2011: 1.06 s for 1st -> 4th contact), and the view starts a
## follow-up part-way into its wind-up to land on that beat (BeatClips.COMBO_LAND_S). Only the resets between exchanges
## stretch to fill the round. (S300: 0.50, stretched up to 1.6x with the rest = 0.5-0.8 s between punches.)
const COMBO_GAP_S := 0.35
## Resets between exchanges stretch at most this much to fill the round.
const RESET_FIT_MAX := 2.0
const PUNCHES := ["jab", "cross", "lead_hook", "body_hook", "rear_uppercut"]
## Beats that are not a thrown punch.
const NOT_PUNCH := ["step_in", "step_out", "slip", "clinch", "tired", "count", "inside"]
## |mine - theirs| in BoutRules power points (ROUND_SPREAD 27): below CLOSE_DIFF a close round, from DOMINANT_DIFF dominant.
## S305 J-UPSETS1: scales with ROUND_SPREAD (0.25 * 27 = 6.75, 0.667 * 27 = 18.009 at spread 27; was 1.5 / 4.0 at spread 6).
const CLOSE_DIFF := 6.75
const DOMINANT_DIFF := 18.009
const LANDED := {"close": [4, 3], "clear": [5, 2], "dominant": [6, 1]}
## The two opening beats a corner call shows (round 2 on), thrown by our fighter.
const CALL_BEATS := {
	"long": [["jab", "lands"], ["jab", "blocked"]],
	"body": [["lead_hook", "lands"], ["cross", "blocked"]],
	"calm": [["step_out", "none"], ["jab", "lands"]],
}
## S310 "fix the wording": {her} = our fighter by name (round["names"]), never a bare "she" with two women in the ring.
const CALL_CAPTION := {"long": "Stay long: {her} starts behind the jab.", "body": "Go to the body: {her} digs one in early.",
	"calm": "Calm, breathe: {her} resets and jabs."}


static func margin(round: Dictionary) -> String:
	var d := absf(float(round.get("mine", 0.0)) - float(round.get("theirs", 0.0)))
	if d < CLOSE_DIFF:
		return "close"
	return "dominant" if d >= DOMINANT_DIFF else "clear"


static func build(round: Dictionary, a_style: String, b_style: String, seconds: float = SECONDS, seed: int = 0,
		profiles: Dictionary = {}) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var w := "a" if bool(round.get("won", true)) else "b"
	var l := "b" if w == "a" else "a"
	var m := margin(round)
	var lands: Array = LANDED[m]
	var need := {w: int(lands[0]), l: int(lands[1])}
	var beats: Array = []
	# Round 2 on: the call's two beats open the round (they count toward her punches).
	var call := str(round.get("corner", ""))
	if int(round.get("n", 1)) >= 2 and CALL_BEATS.has(call):
		for cb in CALL_BEATS[call]:
			beats.append(_beat("a", str(cb[0]), str(cb[1])))
			if str(cb[1]) == "lands":
				need["a"] = maxi(0, int(need["a"]) - 1)
	# Every punch of the round: the landed ones (Kalli's counts), then the blocked and missed ones. A real round connects about
	# a third of what is thrown (CompuBox ~30%); the loser throws more of the misses.
	var pool: Array = []
	for i in int(need[w]) - 1:
		pool.append(_beat(w, _punch_of(w, profiles, rng), "lands"))
	for i in int(need[l]):
		pool.append(_beat(l, _punch_of(l, profiles, rng), "lands"))
	for i in WINNER_MISSES:
		pool.append(_stopped(w, l, profiles, rng, 0.6))
	for i in LOSER_MISSES:
		pool.append(_stopped(l, w, profiles, rng, 0.55))
	_shuffle(pool, rng)
	var last_w := _beat(w, _punch_of(w, profiles, rng), "lands")
	last_w["big"] = true
	if m == "dominant":
		# One knockback on the loser: the winner's biggest landed punch rocks her.
		last_w["knockback"] = true
	# Exchanges: one boxer throws 1-3 punches 0.36 s apart, sometimes answered by a counter, then both reset. The winner
	# leads more exchanges; the round's footwork (the presser steps in, the other out) opens two of the resets.
	var w_out := _is_out_boxer(a_style if w == "a" else b_style)
	var steps: Array = [_beat(w, "step_out" if w_out else "step_in", "none"), _beat(l, "step_in" if w_out else "step_out", "none")]
	var groups: Array = []
	var pool_n := maxf(1.0, float(pool.size()))
	while not pool.is_empty():
		var lead := w if rng.randf() < 0.58 else l
		var lp: Dictionary = profiles.get(lead, {})
		# S303: her energy where this exchange falls in the round (the bell's start -> end, Bouts._energy).
		var e_now := energy_at(lp, 1.0 - float(pool.size()) / pool_n)
		var size := rng.randi_range(1, _max_len(lp, e_now))
		# S305 WORDSCONTRACT1: never pick a combo longer than her punches left in the pool (a run cut short by the pool
		# was captioned as landed whole).
		size = mini(size, _left(pool, lead))
		# S302 combos: a run of 2+ is one of HER combos (Combos.pick, her best most often); with none learned she throws
		# singles and the odd 2-punch run. Results stay as the sim settled them; only the punches change.
		var combo: Dictionary = {}
		var cut := false
		if size >= 2 and lp.has("combos"):
			combo = Combos.pick(lp["combos"], size, rng.randf())
			size = (combo["beats"] as Array).size() if not combo.is_empty() else mini(size, 2)
			# S303: tired, she starts it and leaves the last punch (Combos.cut_chance; Kalli's ring_tired line captions it).
			if not combo.is_empty() and Combos.cut_chance(e_now) > 0.0 and rng.randf() < Combos.cut_chance(e_now):
				cut = true
				size -= 1
		var g: Array = []
		for k in size:
			var at := _take(pool, lead)
			if at < 0:
				break
			var bt: Dictionary = pool.pop_at(at)
			if not combo.is_empty():
				bt["move"] = str(combo["beats"][k])
				bt["combo_id"] = str(combo["id"])
			g.append(bt)
		if g.is_empty():
			continue
		if cut:
			g[g.size() - 1]["combo_cut"] = true
		var other := l if lead == w else w
		if rng.randf() < 0.3:
			var c := _take(pool, other)
			if c >= 0:
				g.append(pool.pop_at(c))
		groups.append(g)
	var last_group: Array = [last_w]
	# Fight model step 2: the sim's standing count comes off the winner's big shot (the round's last beat). A stoppage
	# ends the round there.
	var counts := int(round.get("counts", 0))
	if counts > 0:
		last_w["knockback"] = true
		last_group.append(_beat(l, "count", "none"))
	groups.append(last_group)
	if groups.size() > 2:
		groups.insert(1, [steps[0]])
		groups.insert(groups.size() / 2 + 1, [steps[1]])
	else:
		groups.insert(0, steps)
	# Profiles: her footwork holds her range (one more step), her conditioning shows in tired beats from round 2.
	if not profiles.is_empty():
		var n := int(round.get("n", 1))
		for side in ["a", "b"]:
			var p: Dictionary = profiles.get(side, {})
			var out := _is_out_boxer(a_style if side == "a" else b_style)
			for k in RoundStyle.extra_steps(p):
				groups.insert(rng.randi_range(1, groups.size() - 1), [_beat(side, "step_out" if out else "step_in", "none")])
			# S303 energy: a boxer who ends the round under Combos.WEARY_AT shows one more tired beat.
			var low := 1 if energy_at(p, 1.0) < Combos.WEARY_AT else 0
			for k in RoundStyle.tired_beats(p, n) + low:
				groups.insert(rng.randi_range(groups.size() / 2, groups.size() - 1), [_beat(side, "tired", "none")])
	# Times: inside an exchange COMBO_GAP_S apart (a follow-up by the same boxer is marked "combo"); between exchanges
	# 1.0-2.4 s, and only those resets stretch to fit 2 s .. bell - 2.5 s (the last beat at least 2 s before the bell).
	var timed: Array = []
	var resets: Array = []
	var inner := 0.0
	for g in groups:
		for k in (g as Array).size():
			var bt: Dictionary = g[k]
			bt["t"] = COMBO_GAP_S * k
			var prev: Dictionary = g[k - 1] if k > 0 else {}
			var both_punch := not NOT_PUNCH.has(str(bt["move"])) and not NOT_PUNCH.has(str(prev.get("move", "")))
			bt["combo"] = k > 0 and str(bt["who"]) == str(prev["who"]) and both_punch
			bt["group"] = resets.size()
			timed.append(bt)
		inner += COMBO_GAP_S * maxf(0.0, (g as Array).size() - 1)
		resets.append(rng.randf_range(1.0, 2.4))
	var first := 2.0
	var lead_in := beats.size()
	for i in beats.size():
		beats[i]["t"] = first + 0.6 * i
	if lead_in > 0:
		first += 0.6 * lead_in + 0.8
	var reset_sum := 0.0
	for k in resets.size() - 1:
		reset_sum += float(resets[k])
	var fit := clampf((seconds - 2.5 - first - inner) / maxf(0.1, reset_sum), 0.3, RESET_FIT_MAX)
	var starts: Array = [first]
	for k in resets.size() - 1:
		var g: Array = groups[k]
		starts.append(float(starts[k]) + COMBO_GAP_S * (g.size() - 1) + float(resets[k]) * fit)
	for bt in timed:
		bt["t"] = snappedf(float(starts[int(bt["group"])]) + float(bt["t"]), 0.01)
		bt.erase("group")
	beats.append_array(timed)
	_captions(beats, round.get("lines", []), call if int(round.get("n", 1)) >= 2 else "", str((round.get("names", ["Your fighter"]) as Array)[0]))
	var end := "bell"
	if str(round.get("stopped", "")) != "":
		end = "stoppage"
	return {"n": int(round.get("n", 1)), "winner": w, "margin": m, "seconds": seconds, "end": end, "beats": beats}


## The longest run she throws: her speed cap (RoundStyle.combo_cap), shortened when her energy is low (Combos.max_len).
static func _max_len(p: Dictionary, energy: float) -> int:
	var cap := RoundStyle.combo_cap(p)
	if p.has("energy"):
		cap = Combos.max_len(energy, cap)
	return maxi(1, cap)


## Her energy at a point of the round (0 = bell to start, 1 = bell to end): profile "energy" -> "energy_end".
static func energy_at(p: Dictionary, frac: float) -> float:
	var e0 := float(p.get("energy", Combos.TANK))
	return lerpf(e0, float(p.get("energy_end", e0)), clampf(frac, 0.0, 1.0))


## How many landed punches each side has in a script: {"a": n, "b": n}.
static func landed(script: Dictionary) -> Dictionary:
	var out := {"a": 0, "b": 0}
	for b in script["beats"]:
		if str(b["result"]) == "lands":
			out[b["who"]] = int(out[b["who"]]) + 1
	return out


## The highlights cut: only the beats that land (plus the call's), each played back to back.
## S302: a landed punch inside one of her combos brings the whole combo, at its own rhythm.
static func highlights(script: Dictionary, gap_s: float = 1.6) -> Array:
	var out: Array = []
	var t := 1.0
	var beats: Array = script["beats"]
	var i := 0
	while i < beats.size():
		var b: Dictionary = beats[i]
		var run := [b]
		var cid := str(b.get("combo_id", ""))
		if cid != "":
			while i + run.size() < beats.size():
				var nb: Dictionary = beats[i + run.size()]
				if str(nb.get("combo_id", "")) != cid or str(nb["who"]) != str(b["who"]):
					break
				run.append(nb)
		if run.any(func(x): return str(x["result"]) == "lands" or str(x["caption"]) != "") or str(b["move"]) in ["step_in", "step_out"]:
			for k in run.size():
				var c: Dictionary = (run[k] as Dictionary).duplicate()
				c["t"] = t + COMBO_GAP_S * k
				out.append(c)
			t += gap_s + COMBO_GAP_S * (run.size() - 1)
		i += run.size()
	return out


static func _beat(who: String, move: String, result: String) -> Dictionary:
	return {"t": 0.0, "who": who, "move": move, "result": result, "caption": "", "big": false, "knockback": false, "def": ""}


static func _punch_of(who: String, profiles: Dictionary, rng: RandomNumberGenerator) -> String:
	return RoundStyle.punch(profiles[who], rng) if profiles.has(who) else _punch(rng)


## A punch that did not land. With the receiver's profile: her defence decides blocked or missed and names the response
## ("def"); without: blocked at the old odds.
static func _stopped(who: String, at: String, profiles: Dictionary, rng: RandomNumberGenerator, block_odds: float) -> Dictionary:
	if not profiles.has(at):
		return _beat(who, _punch_of(who, profiles, rng), "blocked" if rng.randf() < block_odds else "misses")
	var b := _beat(who, _punch_of(who, profiles, rng), "misses")
	b["def"] = RoundStyle.defend(profiles[at], profiles.get(who, {}), rng)
	if str(b["def"]) == "block":
		b["result"] = "blocked"
	return b


## The jab is half of what amateurs throw; then the cross, the hooks, the uppercut.
static func _punch(rng: RandomNumberGenerator) -> String:
	var r := rng.randf()
	if r < 0.45:
		return "jab"
	if r < 0.72:
		return "cross"
	if r < 0.86:
		return "lead_hook"
	return "body_hook" if r < 0.94 else "rear_uppercut"


## The first beat in `pool` thrown by `who`, or -1.
static func _take(pool: Array, who: String) -> int:
	for i in pool.size():
		if str(pool[i]["who"]) == who:
			return i
	return -1


static func _left(pool: Array, who: String) -> int:
	var n := 0
	for b in pool:
		if str(b["who"]) == who:
			n += 1
	return n


static func _is_out_boxer(style: String) -> bool:
	return style.to_lower().contains("out")


static func _shuffle(a: Array, rng: RandomNumberGenerator) -> void:
	for i in range(a.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var tmp = a[i]
		a[i] = a[j]
		a[j] = tmp


## The round's word lines ride the beats: the call's caption on the first beat (round 2 on), the first line on the
## opening punch, the last line on the winner's last punch, any line between on a landed beat in the middle.
static func _captions(beats: Array, lines: Array, call: String, her: String) -> void:
	var start := 0
	if call != "" and CALL_CAPTION.has(call):
		beats[0]["caption"] = str(CALL_CAPTION[call]).replace("{her}", her)
		start = 2
	if lines.is_empty():
		return
	beats[mini(start, beats.size() - 1)]["caption"] = str(lines[0])
	if lines.size() >= 2:
		beats[beats.size() - 1]["caption"] = str(lines[lines.size() - 1])
	var mids: Array = []
	for i in range(start + 1, beats.size() - 1):
		if str(beats[i]["result"]) == "lands" and str(beats[i]["caption"]) == "":
			mids.append(i)
	var between := lines.size() - 2
	for k in between:
		if mids.is_empty():
			break
		var at: int = mids[mini(mids.size() - 1, int(float(k + 1) * mids.size() / float(between + 1)))]
		beats[at]["caption"] = str(lines[k + 1])
