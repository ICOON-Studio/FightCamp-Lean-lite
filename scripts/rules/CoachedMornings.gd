extends RefCounted
## Coached mornings and the weak spot: pure club-week rules (MORNINGS1).
## Owner Q-S294-241: "Yes, build it after the fight week".
## Map: DESIGN_CLUBWEEK1_V9_REVISE_KALLI_KALLI.md sections 3.5 and 3.3 (WEAK SPOT).
## Multipliers and morning pads rate are ESTIMATE design values for the probe to check.
## owned(coach_kind): count the week's player-owned and coach-owned mornings.
## mult(use, on_weak): multiply a normal stat morning's gain.
## pads_rate(): rate of a morning pad turn, separate from stat gain.
## weak_spot(stats): lowest fight ability at least three below the six-ability mean.
## weak_line(stats): describe that hole and the opponents who find it.
## deal(asks, coach_kind): allocate mornings in priority order, pairing shared drills.
## added(dealt): total extra stat gain in morning-equivalents.

const SOLO := 1.25
const SOLO_WEAK := 1.4
const SHARED := 1.15
const MORNING_PADS := 0.8
const NOT_COACHED := 1.0
const YOU_OWNED := 4
const COACH_OWNED := {"sessional": 2, "full_time": 3, "none": 0}
const FIGHT_ABILITIES := ["power", "speed", "technique", "defense", "conditioning", "fight_iq"]
const WEAK_GAP := 3.0
const FINDS := {
	"defense": "pressure fighters", "conditioning": "volume punchers",
	"fight_iq": "counter-punchers", "speed": "out-boxers",
	"power": "sluggers", "technique": "counter-punchers",
}
const WORDS := {
	"power": "Power", "speed": "Speed", "technique": "Technique",
	"defense": "Defence", "conditioning": "Stamina", "fight_iq": "Fight IQ",   # S486 one vocabulary (Data.LABEL, S443)
}


static func owned(coach_kind: String) -> int:
	return YOU_OWNED + int(COACH_OWNED.get(coach_kind, 0))


static func mult(use: String, on_weak: bool) -> float:
	match use:
		"solo":
			return SOLO_WEAK if on_weak else SOLO
		"shared":
			return SHARED
	return NOT_COACHED


static func pads_rate() -> float:
	return MORNING_PADS


static func weak_spot(stats: Dictionary) -> String:
	var total := 0.0
	var lowest := INF
	var lowest_id := ""
	for ability in FIGHT_ABILITIES:
		var value := float(stats.get(ability, 0.0))
		total += value
		if value < lowest:
			lowest = value
			lowest_id = ability
	return lowest_id if total / FIGHT_ABILITIES.size() - lowest >= WEAK_GAP else ""


static func weak_line(stats: Dictionary) -> String:
	var ability := weak_spot(stats)
	if ability == "":
		return ""
	return "Low %s: %s find it" % [WORDS[ability], FINDS[ability]]


static func deal(asks: Array, coach_kind: String) -> Array:
	var left := owned(coach_kind)
	var paired := {}
	var dealt: Array = []
	for i in range(asks.size()):
		var ask: Dictionary = asks[i]
		var ability := str(ask.get("ability", ""))
		var use := "none"
		# A reserved partner is already paid for, even if the budget is now empty.
		if paired.has(i):
			use = "shared"
		elif left > 0:
			var requested := str(ask.get("use", "none"))
			if requested == "shared":
				use = "solo"
				for j in range(i + 1, asks.size()):
					var candidate: Dictionary = asks[j]
					if not paired.has(j) and str(candidate.get("use", "")) == "shared" and str(candidate.get("ability", "")) == ability:
						paired[j] = true
						use = "shared"
						break
			elif requested == "solo" or requested == "pads":
				use = requested
			if use != "none":
				left -= 1
		var gain := pads_rate() if use == "pads" else mult(use, bool(ask.get("weak", false)))
		dealt.append({"id": str(ask.get("id", "")), "ability": ability, "use": use, "mult": gain})
	return dealt


static func added(dealt: Array) -> float:
	var extra := 0.0
	for row in dealt:
		if row.get("use", "none") in ["solo", "shared"]:
			extra += float(row.get("mult", NOT_COACHED)) - 1.0
	return extra


## S519 club week v11 3.3 (his Q-S294-272 "Yes, build it"): the ONE ability two boxers both rank lowest. Each ability's
## rank inside each boxer's own six (0 = her lowest); the pair's focus is the lowest summed rank, ties by the lower
## summed value. {ability, a, b} (a and b = each boxer's value), {} when either has no stats.
static func shared_focus(stats_a: Dictionary, stats_b: Dictionary, among: Array = FIGHT_ABILITIES) -> Dictionary:
	if stats_a.is_empty() or stats_b.is_empty():
		return {}
	var ra := _ranks(stats_a, among)
	var rb := _ranks(stats_b, among)
	var best := ""
	var best_key := Vector2(INF, INF)
	for ab in among:
		var key := Vector2(float(ra[ab] + rb[ab]), float(stats_a.get(ab, 0.0)) + float(stats_b.get(ab, 0.0)))
		if key.x < best_key.x or (key.x == best_key.x and key.y < best_key.y):
			best_key = key
			best = str(ab)
	return {"ability": best, "a": float(stats_a.get(best, 0.0)), "b": float(stats_b.get(best, 0.0))}


static func _ranks(stats: Dictionary, among: Array) -> Dictionary:
	var order: Array = among.duplicate()
	order.sort_custom(func(x, y): return float(stats.get(x, 0.0)) < float(stats.get(y, 0.0)))
	var out := {}
	for i in order.size():
		out[order[i]] = i
	return out


## S519 the coach's deal of the club's coached mornings for one week (2+ boxers; one boxer = {} and nothing changes, v11
## section 2). rows (deal order, fight-week boxers first) = [{id, stats, days: 7 x [ability or ""]}] where an ability is the
## stat that morning's session trains ("" = rest, work, mobility). Shared first: on a day two boxers train the same ability,
## the pair whose ability is nearest their shared focus takes ONE slot (SHARED each). Then solo round the order, one a boxer
## a turn, on her lowest-ranked trained morning (SOLO_WEAK when it is her weak spot). Returns {id: {dow: {use, mult,
## ability, mate}}} with dow as a String key (a save keeps it).
static func week_deal(rows: Array, coach_kind: String) -> Dictionary:
	var out := {}
	for r in rows:
		out[str(r["id"])] = {}
	if rows.size() < 2:
		return {}
	var left := owned(coach_kind)
	var pairs: Array = []
	for i in rows.size():
		for j in range(i + 1, rows.size()):
			var a: Dictionary = rows[i]
			var b: Dictionary = rows[j]
			var focus := str(shared_focus(a.get("stats", {}), b.get("stats", {})).get("ability", ""))
			var ra := _ranks(a.get("stats", {}), FIGHT_ABILITIES)
			var rb := _ranks(b.get("stats", {}), FIGHT_ABILITIES)
			for dow in 7:
				var ab := str((a["days"] as Array)[dow])
				if ab != "" and ab == str((b["days"] as Array)[dow]) and ra.has(ab):
					pairs.append({"i": i, "j": j, "dow": dow, "ability": ab,
						"key": (0 if ab == focus else 100) + int(ra[ab]) + int(rb[ab]) + i + j})
	pairs.sort_custom(func(x, y): return int(x["key"]) < int(y["key"]) or (int(x["key"]) == int(y["key"]) and int(x["dow"]) < int(y["dow"])))
	var used := {}   # "id:dow" taken
	var shared_n := {}
	for p in pairs:
		if left <= 0:
			break
		var ia := str(rows[int(p["i"])]["id"])
		var ib := str(rows[int(p["j"])]["id"])
		var dk := str(p["dow"])
		# one shared morning a boxer a week, so one pair cannot take every slot
		if used.has(ia + ":" + dk) or used.has(ib + ":" + dk) or shared_n.has(ia) or shared_n.has(ib):
			continue
		out[ia][dk] = {"use": "shared", "mult": SHARED, "ability": str(p["ability"]), "mate": ib}
		out[ib][dk] = {"use": "shared", "mult": SHARED, "ability": str(p["ability"]), "mate": ia}
		used[ia + ":" + dk] = true
		used[ib + ":" + dk] = true
		shared_n[ia] = true
		shared_n[ib] = true
		left -= 1
	var dealt := true
	while left > 0 and dealt:
		dealt = false
		for r in rows:
			if left <= 0:
				break
			var fid := str(r["id"])
			var st: Dictionary = r.get("stats", {})
			var rk := _ranks(st, FIGHT_ABILITIES)
			var weak := weak_spot(st)
			var best := -1
			for dow in 7:
				var ab := str((r["days"] as Array)[dow])
				if ab == "" or not rk.has(ab) or used.has(fid + ":" + str(dow)):
					continue
				if best < 0 or int(rk[ab]) < int(rk[str((r["days"] as Array)[best])]):
					best = dow
			if best < 0:
				continue
			var ab2 := str((r["days"] as Array)[best])
			out[fid][str(best)] = {"use": "solo", "mult": mult("solo", ab2 == weak), "ability": ab2, "mate": ""}
			used[fid + ":" + str(best)] = true
			left -= 1
			dealt = true
	return out


## The multiplier a dealt morning puts on that morning's stat gain: 1.0 unless the deal coached this day on this ability.
static func day_mult(coached: Dictionary, dow: int, ability: String) -> float:
	var m: Dictionary = coached.get(str(dow), {})
	if m.is_empty() or str(m.get("ability", "")) != ability:
		return 1.0
	return float(m.get("mult", 1.0))


## Plain words for one dealt morning: "Coached 1-to-1: Power (x1.25)" / "Shared: Stamina (x1.15)".
static func tile_word(m: Dictionary) -> String:
	if m.is_empty():
		return ""
	var w := str(WORDS.get(str(m.get("ability", "")), str(m.get("ability", ""))))
	if str(m.get("use", "")) == "shared":
		return "Shared: %s (x%.2f)" % [w, float(m["mult"])]
	return "Coached 1-to-1: %s (x%.2f)" % [w, float(m["mult"])]
