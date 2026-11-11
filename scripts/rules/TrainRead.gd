extends RefCounted
## TRAINREAD1 - The coach's read: which training each fighter needs, from the numbers and the style.
## Pure static. Looks at a fighter's stats, style, fatigue and bout, returns one of five reads.
## Order: fight, rest, weakness, weapon, craft.

const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")
const Recruit := preload("res://scripts/rules/Recruit.gd")
const WeekCoach := preload("res://scripts/rules/WeekCoach.gd")

const FIGHT_DAYS := 14
const REST_FATIGUE := 70.0
const WEAK_GAP := 6.0
const WEAK_PACE := 1.0
const WEAPON_PACE := 0.5
const MAX_WORDS := 11

const TRAINABLE := ["conditioning", "power", "speed", "defense", "technique", "chin"]

const STAT_WORDS := {
	"power": "power", "speed": "speed", "technique": "technique",
	"defense": "defence", "conditioning": "stamina", "chin": "the chin",
}


static func read(f: Dictionary, day: int, hurt: bool = false) -> Dictionary:
	var first: String = str(f.get("first", "Boxer"))
	var style: String = str(f.get("style", ""))
	var pot: int = int(f.get("pot", 70))
	var stats: Dictionary = f.get("stats", {})
	var fatigue: float = float(f.get("fatigue", 0.0))
	var bout: Dictionary = f.get("bout", {})

	# 1. fight: bout within FIGHT_DAYS
	var bout_day: int = int(bout.get("day", -1))
	var days_until: int = bout_day - day
	if not bout.is_empty() and days_until >= 0 and days_until <= FIGHT_DAYS:
		var say_f: String = _say_fight(first, days_until)
		var why_f: String = "Bout in %d days: no building now." % days_until
		return {"kind": "fight", "stat": "", "session": "", "session_name": "",
			"say": say_f, "why": why_f, "pace": 0.0, "alt": {}}

	# 2. rest: hurt or fatigue >= REST_FATIGUE
	if hurt or fatigue >= REST_FATIGUE:
		var say_r: String = "%s is worn out. A rest morning first." % first
		var why_r: String = "Tiredness %d: rest before more work." % roundi(fatigue)
		return {"kind": "rest", "stat": "", "session": "", "session_name": "",
			"say": say_r, "why": why_r, "pace": 0.0, "alt": {}}

	# Compute mean of ALL stats
	var stat_sum: float = 0.0
	var stat_count: int = 0
	for key in stats.keys():
		stat_sum += float(stats[key])
		stat_count += 1
	var mean: float = stat_sum / float(stat_count) if stat_count > 0 else 0.0

	# 3. weakness: lowest trainable stat, if gap >= WEAK_GAP and headroom >= WEAK_PACE
	var weak_stat: String = ""
	var weak_val: float = 999.0
	for s in TRAINABLE:
		if stats.has(s):
			var v: float = float(stats[s])
			if v < weak_val:
				weak_val = v
				weak_stat = s
	if weak_stat != "":
		var gap: float = mean - weak_val
		var hd: float = TrainingPreview.headroom(pot, weak_val)
		if gap >= WEAK_GAP and hd >= WEAK_PACE:
			var sess: String = str(WeekCoach.BUILDS[weak_stat][0])
			var sess_name: String = _cap(str(WeekCoach.BUILDER[weak_stat]))
			var say_h: String = "%s's weakness: %s. %s first." % [first, STAT_WORDS[weak_stat], sess_name]
			var alt_h: Dictionary = _best_other(stats, pot, weak_stat)
			var why_h: String = _why_line(sess_name, weak_stat, hd, alt_h)
			return {"kind": "weakness", "stat": weak_stat, "session": sess, "session_name": sess_name,
				"say": say_h, "why": why_h, "pace": hd, "alt": alt_h}

	# 4. weapon: style's built-on stat, if TRAINABLE and headroom >= WEAPON_PACE
	var weapon_stat: String = ""
	var classes: Array = Recruit.CLASSES.get(style, [])
	if classes.size() >= 3:
		weapon_stat = str(classes[2])
	if weapon_stat == "" or not TRAINABLE.has(weapon_stat) or not stats.has(weapon_stat):
		# Unknown style or built-on not trainable: use highest trainable stat
		weapon_stat = _highest_trainable(stats)
	if weapon_stat != "":
		var wval: float = float(stats[weapon_stat])
		var whd: float = TrainingPreview.headroom(pot, wval)
		if whd >= WEAPON_PACE:
			var wsess: String = str(WeekCoach.BUILDS[weapon_stat][0])
			var wsess_name: String = _cap(str(WeekCoach.BUILDER[weapon_stat]))
			var say_w: String = "%s wins on %s. Sharpen it: %s." % [first, STAT_WORDS[weapon_stat], wsess_name]
			var alt_w: Dictionary = _best_other(stats, pot, weapon_stat)
			var why_w: String = _why_line(wsess_name, weapon_stat, whd, alt_w)
			return {"kind": "weapon", "stat": weapon_stat, "session": wsess, "session_name": wsess_name,
				"say": say_w, "why": why_w, "pace": whd, "alt": alt_w}

	# 5. craft: pads, a new punch
	var alt_c: Dictionary = _best_other(stats, pot, "")
	var say_c: String = "%s is what the numbers say. Teach a new punch." % first
	var why_c: String = _why_craft(alt_c)
	return {"kind": "craft", "stat": "", "session": "pads", "session_name": "Pads",
		"say": say_c, "why": why_c, "pace": 0.0, "alt": alt_c}


static func kinds() -> Array:
	return ["fight", "rest", "weakness", "weapon", "craft"]


static func _say_fight(first: String, n: int) -> String:
	if n == 0:
		return "%s fights today. Keep the legs fresh." % first
	if n == 1:
		return "%s fights tomorrow. Keep the legs fresh." % first
	return "%s fights in %d days. Keep the legs fresh." % [first, n]


static func _cap(s: String) -> String:
	if s.is_empty():
		return s
	return s.left(1).to_upper() + s.substr(1)


static func _highest_trainable(stats: Dictionary) -> String:
	var best: String = ""
	var best_val: float = -1.0
	for s in TRAINABLE:
		if stats.has(s):
			var v: float = float(stats[s])
			if v > best_val:
				best_val = v
				best = s
	return best


static func _best_other(stats: Dictionary, pot: int, exclude: String) -> Dictionary:
	var best: String = ""
	var best_hd: float = -1.0
	for s in TRAINABLE:
		if s == exclude or not stats.has(s):
			continue
		var hd: float = TrainingPreview.headroom(pot, float(stats[s]))
		if hd > best_hd:
			best_hd = hd
			best = s
	if best == "":
		return {}
	var sess: String = str(WeekCoach.BUILDS[best][0])
	return {"stat": best, "session": sess, "pace": best_hd}


static func _why_line(sess_name: String, stat: String, pace: float, alt: Dictionary) -> String:
	var sw: String = str(STAT_WORDS.get(stat, ""))
	var line1: String = "%s: %s +%.2f a week." % [sess_name, sw, pace]
	if alt.is_empty():
		return line1
	var alt_sess: String = _cap(str(WeekCoach.BUILDER.get(str(alt["stat"]), "")))
	var alt_sw: String = str(STAT_WORDS.get(str(alt["stat"]), ""))
	var line2: String = "%s: %s +%.2f a week." % [alt_sess, alt_sw, float(alt["pace"])]
	return line1 + "\n" + line2


static func _why_craft(alt: Dictionary) -> String:
	var line1: String = "Pads: a new punch."
	if alt.is_empty():
		return line1
	var alt_sess: String = _cap(str(WeekCoach.BUILDER.get(str(alt["stat"]), "")))
	var alt_sw: String = str(STAT_WORDS.get(str(alt["stat"]), ""))
	var line2: String = "%s: %s +%.2f a week." % [alt_sess, alt_sw, float(alt["pace"])]
	return line1 + "\n" + line2
