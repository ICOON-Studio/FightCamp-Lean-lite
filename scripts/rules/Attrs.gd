extends RefCounted
## The fighter's attributes (S404): 10 primary, the same in every sport, and 5 boxing skills. Punches are moves
## (mastery), not attributes. The old seven stay a summary (LEGACY) so screens and saves still read them: a change to an
## old stat is shared among its children (absorb), and the summary is rewritten from the attributes (sync).
## Pure static; zero preloads. Numbers are game values unless a comment cites a source.

const PRIMARY: Array[String] = ["strength", "explosiveness", "speed", "stamina", "recovery", "flexibility", "durability",
	"fight_iq", "composure", "heart"]
const SKILLS: Array[String] = ["accuracy", "timing", "defence", "footwork", "inside"]
## Heart is a primary but it is not trained and not part of the measured level (it stays on the personality).
const ABILITIES: Array[String] = ["strength", "explosiveness", "speed", "stamina", "recovery", "flexibility", "durability",
	"fight_iq", "composure", "accuracy", "timing", "defence", "footwork", "inside"]
const PUNCHES: Array[String] = ["jab", "straight", "hooks", "uppercuts"]
const GROUPS := {
	"physical": ["strength", "explosiveness", "speed", "stamina", "recovery", "flexibility", "durability"],
	"skill": ["accuracy", "timing", "defence", "footwork", "inside"],
	"mind": ["fight_iq", "composure", "heart"],
}
const LABEL := {"strength": "Strength", "explosiveness": "Explosiveness", "speed": "Speed", "stamina": "Stamina",
	"recovery": "Recovery", "flexibility": "Flexibility", "durability": "Durability", "fight_iq": "Fight IQ",
	"composure": "Composure", "heart": "Heart", "accuracy": "Accuracy", "timing": "Timing", "defence": "Defence",
	"footwork": "Footwork", "inside": "Inside fighting", "pace": "Pace", "forward": "Forward"}
## Measured value of +10 on each ability against the reference field. A table level is this weighted mean.
const VALUE := {"strength": 0.040, "explosiveness": 0.070, "speed": 0.080, "stamina": 0.040, "recovery": 0.020,
	"flexibility": 0.015, "durability": 0.055, "fight_iq": 0.025, "composure": 0.020, "accuracy": 0.030,
	"timing": 0.060, "defence": 0.090, "footwork": 0.085, "inside": 0.055}
## Measured value of +10 on a punch, same field. A generated shape centres its punches on this so a hook
## is a shape, not free level. Archetype tilts keep the punch they were written with.
const PUNCH_VALUE := {"jab": 0.038, "straight": 0.027, "hooks": 0.035, "uppercuts": 0.012}
## Old stat -> its children. The mean of the children is the old stat, exact at migration.
const LEGACY := {"power": ["strength", "explosiveness"], "speed": ["speed"], "technique": ["accuracy", "timing"],
	"defense": ["defence"], "conditioning": ["stamina", "recovery"], "fight_iq": ["fight_iq", "composure"],
	"chin": ["durability"]}
const LO := 1.0
const HI := 99.0
const SPREAD := 2.5
const STYLE_SHARE := 0.4
const NAMED_MAX := 2.0
const OUTSIDE_SHARE := 0.5
const STOP_DROP := 2.0
const SPIKE_AT := 6.0
const HIGH_WORD := {"strength": "strong", "explosiveness": "explosive", "speed": "fast", "stamina": "a big engine",
	"recovery": "recovers fast", "flexibility": "loose and rangy", "durability": "hard to hurt", "fight_iq": "reads a fight",
	"composure": "never panics", "heart": "big heart", "accuracy": "accurate", "timing": "great timing",
	"defence": "hard to hit", "footwork": "clever feet", "inside": "busy inside"}
const LOW_WORD := {"strength": "pushed around", "explosiveness": "slow to explode", "speed": "slow", "stamina": "fades late",
	"recovery": "slow to recover", "flexibility": "stiff", "durability": "a thin chin", "fight_iq": "predictable",
	"composure": "panics when hit", "heart": "folds when behind", "accuracy": "wild", "timing": "poor timing",
	"defence": "easy to hit", "footwork": "caught on the ropes", "inside": "lost inside"}
## How often a bout really rebuilds a fighter. The speed test reads these; a clean read does not increment them.
static var n_of_full := 0
static var n_migrate := 0
static var n_alias := 0
static var n_moves := 0


static func of(f: Dictionary) -> Dictionary:
	if _clean(f):
		return f["attrs"]
	n_of_full += 1
	if not f.has("attrs") or (f["attrs"] as Dictionary).is_empty():
		n_migrate += 1
		f["attrs"] = from_stats(f.get("stats", {}), float(f.get("footwork", -1.0)), str(f.get("style", "")),
			f.get("personality", {}), hash(str(f.get("id", f.get("name", "")))))
		_seen(f)
	else:
		# A past-stats read (Sim._as_of) is a shallow copy: it shares this dict and pairs it with an older
		# stats snapshot. Absorb would pull the live fighter back to that week. Write a private copy.
		f["attrs"] = (f["attrs"] as Dictionary).duplicate()
	absorb(f)
	var a: Dictionary = f["attrs"]
	_punches(a, f.get("moves", {}), float((f.get("stats", {}) as Dictionary).get("technique", 55.0)))
	if f.has("durability_cap"):
		a["durability"] = minf(float(a.get("durability", 55.0)), float(f["durability_cap"]))
	a["heart"] = float((f.get("personality", {}) as Dictionary).get("heart", a.get("heart", 55.0)))
	var dials: Dictionary = f.get("style_dials", {})
	a["pace"] = float(dials.get("work_rate", a.get("pace", 55.0)))
	a["forward"] = float(dials.get("pressure", a.get("forward", 50.0)))
	_alias(a)
	sync(f)
	return a


## True when the stored attributes already match every input of() would rewrite. A punch then reads them as they are.
static func _clean(f: Dictionary) -> bool:
	if not f.has("attrs") or (f["attrs"] as Dictionary).is_empty() or not f.has("stats_seen"):
		return false
	var a: Dictionary = f["attrs"]
	var seen: Dictionary = f["stats_seen"]
	var st: Dictionary = f.get("stats", {})
	for k in LEGACY:
		if not st.has(k) or not seen.has(k) or absf(float(st[k]) - float(seen[k])) > 0.0001:
			return false
	if absf(float(f.get("footwork", a.get("footwork", 55.0))) - float(seen.get("_footwork", -999.0))) > 0.0001:
		return false
	var heart := float((f.get("personality", {}) as Dictionary).get("heart", a.get("heart", 55.0)))
	if absf(heart - float(a.get("heart", heart))) > 0.0001:
		return false
	var dials: Dictionary = f.get("style_dials", {})
	if dials.has("work_rate") and absf(float(dials["work_rate"]) - float(a.get("pace", 55.0))) > 0.0001:
		return false
	if dials.has("pressure") and absf(float(dials["pressure"]) - float(a.get("forward", 50.0))) > 0.0001:
		return false
	if f.has("durability_cap") and float(a.get("durability", 55.0)) > float(f["durability_cap"]) + 0.0001:
		return false
	return _punches_match(a, f.get("moves", {}), float(st.get("technique", 55.0)))


static func _punches_match(a: Dictionary, moves: Dictionary, fallback: float) -> bool:
	if moves.is_empty():
		for k in PUNCHES:
			if not a.has(k):
				return false
		return true
	# A drill may sit a punch a little above its mastery. Below mastery, the moves have moved on.
	if float(a.get("jab", -1.0)) + 0.0001 < clampf(float(moves.get("Jab", fallback)), LO, HI):
		return false
	if float(a.get("straight", -1.0)) + 0.0001 < clampf(float(moves.get("Cross", fallback)), LO, HI):
		return false
	if float(a.get("uppercuts", -1.0)) + 0.0001 < clampf(float(moves.get("Uppercut", fallback)), LO, HI):
		return false
	var n := 0
	var s := 0.0
	for name in ["Lead hook", "Body hook"]:
		if moves.has(name):
			s += float(moves[name])
			n += 1
	var hooks := clampf(s / float(n) if n > 0 else fallback, LO, HI)
	return float(a.get("hooks", -1.0)) + 0.0001 >= hooks


## A stoppage loss lowers the durability ceiling. Training cannot push it back past the new cap.
static func wear_stoppage(f: Dictionary) -> void:
	f["durability_cap"] = maxf(20.0, float(f.get("durability_cap", HI)) - STOP_DROP)
	of(f)


## The attributes from the old seven. Each group's children re-centre on the parent, so the seven read back exact.
## No stored footwork: start from the old mean of speed and defence once; after that the number is its own.
static func from_stats(stats: Dictionary, footwork: float, style: String, personality: Dictionary, seed_value: int) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var tilt: Dictionary = style_tilt(style)
	var a := {}
	for k in LEGACY:
		var parent := float(stats.get(k, 55.0))
		var kids: Array = LEGACY[k]
		var offs: Array = []
		var mean := 0.0
		for c in kids:
			var o := 0.0 if kids.size() == 1 else float(tilt.get(c, 0.0)) * STYLE_SHARE + rng.randf_range(-SPREAD, SPREAD)
			if c == "composure":
				o += (55.0 - float(personality.get("temper", 55.0))) * 0.2
			offs.append(o)
			mean += o / float(kids.size())
		for i in kids.size():
			a[kids[i]] = clampf(parent + float(offs[i]) - mean, LO, HI)
	# Mean unchanged. Stamina starts under the old number and recovery over it, so roadwork (stamina only)
	# does not open Second wind before the engine as a whole has earned it.
	var st := float(a["stamina"]) - 5.0
	var rc := float(a["recovery"]) + 5.0
	if st >= LO and rc <= HI:
		a["stamina"] = st
		a["recovery"] = rc
	var tech := float(stats.get("technique", 55.0))
	var power := float(stats.get("power", 55.0))
	a["inside"] = clampf((tech + power) * 0.5 + float(tilt.get("inside", 0.0)) * STYLE_SHARE, LO, HI)
	a["flexibility"] = 55.0
	a["footwork"] = clampf(footwork if footwork >= 0.0 else (float(stats.get("speed", 55.0)) + float(stats.get("defense", 55.0))) * 0.5, LO, HI)
	return a


static func style_tilt(style: String) -> Dictionary:
	var gen: GDScript = load("res://scripts/rules/AttrGen.gd")
	return gen.tilt_of(style)


static func absorb(f: Dictionary) -> void:
	var a: Dictionary = f["attrs"]
	var st: Dictionary = f.get("stats", {})
	var seen: Dictionary = f.get("stats_seen", {})
	for k in LEGACY:
		if not st.has(k) or not seen.has(k):
			continue
		var d := float(st[k]) - float(seen[k])
		if absf(d) > 0.0001:
			for c in LEGACY[k]:
				a[c] = clampf(float(a.get(c, 55.0)) + d, LO, HI)
	if f.has("footwork") and seen.has("_footwork"):
		var dw := float(f["footwork"]) - float(seen["_footwork"])
		if absf(dw) > 0.0001:
			a["footwork"] = clampf(float(a.get("footwork", 55.0)) + dw, LO, HI)
	sync(f)


static func sync(f: Dictionary) -> void:
	var a: Dictionary = f["attrs"]
	if f.has("durability_cap"):
		a["durability"] = minf(float(a.get("durability", 55.0)), float(f["durability_cap"]))
	if not f.has("stats"):
		f["stats"] = {}
	for k in LEGACY:
		f["stats"][k] = legacy_of(a, k)
	f["footwork"] = float(a.get("footwork", 55.0))
	_alias(a)
	_seen(f)


static func _seen(f: Dictionary) -> void:
	var seen: Dictionary = (f.get("stats", {}) as Dictionary).duplicate()
	seen["_footwork"] = float(f.get("footwork", (f["attrs"] as Dictionary).get("footwork", 55.0)))
	f["stats_seen"] = seen


static func legacy_of(a: Dictionary, k: String) -> float:
	var kids: Array = LEGACY.get(k, [])
	if kids.is_empty():
		return 55.0
	var s := 0.0
	for c in kids:
		s += float(a.get(c, 55.0))
	return s / float(kids.size())


static func legacy(a: Dictionary) -> Dictionary:
	var out := {}
	for k in LEGACY:
		out[k] = legacy_of(a, k)
	return out


## Punch levels on the same 0-100 scale as mastery. `levels` already on that scale (a generated boxer, or empty).
static func lay(a: Dictionary, levels: Dictionary) -> void:
	for k in PUNCHES:
		if levels.has(k):
			a[k] = clampf(float(levels[k]), LO, HI)
	_alias(a)


static func _punches(a: Dictionary, moves: Dictionary, fallback: float) -> void:
	n_moves += 1
	if moves.is_empty():
		for k in PUNCHES:
			if not a.has(k):
				a[k] = clampf(fallback, LO, HI)
		return
	_keep_punch(a, "jab", clampf(float(moves.get("Jab", fallback)), LO, HI))
	_keep_punch(a, "straight", clampf(float(moves.get("Cross", fallback)), LO, HI))
	var n := 0
	var s := 0.0
	for name in ["Lead hook", "Body hook"]:
		if moves.has(name):
			s += float(moves[name])
			n += 1
	_keep_punch(a, "hooks", clampf(s / float(n) if n > 0 else fallback, LO, HI))
	_keep_punch(a, "uppercuts", clampf(float(moves.get("Uppercut", fallback)), LO, HI))


## Mastery catches a punch up. A drill's extra above mastery stays.
static func _keep_punch(a: Dictionary, k: String, from_moves: float) -> void:
	a[k] = maxf(float(a.get(k, from_moves)), from_moves)


## Keys the fight still asks for by the old names, written from the real attributes so a call or a duel reads one number.
static func _alias(a: Dictionary) -> void:
	n_alias += 1
	a["hand_speed"] = float(a.get("speed", 55.0))
	a["foot_speed"] = float(a.get("speed", 55.0))
	a["engine"] = float(a.get("stamina", 55.0))
	a["chin"] = float(a.get("durability", 55.0))
	a["body"] = float(a.get("durability", 55.0))
	a["ring_iq"] = float(a.get("fight_iq", 55.0))
	a["guard"] = float(a.get("defence", 55.0))
	var defence := float(a.get("defence", 55.0))
	a["head_movement"] = 0.65 * defence + 0.35 * float(a.get("flexibility", defence))
	var strength := float(a.get("strength", 55.0))
	a["power"] = 0.5 * strength + 0.5 * float(a.get("explosiveness", strength))


const SESSION_ATTRS := {"roadwork": ["stamina"], "intervals": ["stamina"], "heavy_bag": ["strength", "explosiveness"],
	"strength": ["strength"], "speed_bag": ["speed"], "slip_rope": ["defence"], "shadow": ["footwork", "accuracy"],
	"neck": ["durability"], "rest": ["recovery"], "mobility": ["flexibility"], "pads": ["accuracy", "timing"],
	"sparring": ["timing", "defence", "inside", "fight_iq", "composure"]}
## The punch the drill improves. Not accuracy or timing: those are the old technique stat, and the week's plan
## does not contain the drill. A punch above its mastery is kept (_keep_punch).
const MOVE_ATTR := {"Jab": "jab", "Cross": "straight", "Lead hook": "hooks", "Body hook": "hooks",
	"Uppercut": "uppercuts", "Check hook": "hooks"}
const MOVE_SHARE := 0.05


static func drill(f: Dictionary, move: String, dm: float) -> float:
	var k := str(MOVE_ATTR.get(move, ""))
	if k == "" or dm <= 0.0:
		return 0.0
	var a := of(f)
	var was := float(a.get(k, 55.0))
	a[k] = clampf(was + dm * MOVE_SHARE, LO, HI)
	sync(f)
	return float(a[k]) - was


## The morning or evening `sid` trains its named attributes. `stat` is the old stat the card still moves ("" for rest
## and mobility). A camp that overrides the stat spreads the gain across that stat's children, as before.
static func apply_session(f: Dictionary, sid: String, stat: String, gain: float) -> Dictionary:
	if gain <= 0.0:
		return {}
	var named: Array = SESSION_ATTRS.get(sid, []) if stat == _declared(sid) else []
	if stat != "" and not (f.get("stats", {}) as Dictionary).has(stat):
		return {}
	if stat == "" and named.is_empty():
		return {}
	return train(f, stat, gain, named)


static func _declared(sid: String) -> String:
	var wp: GDScript = load("res://scripts/rules/WeekPlan.gd")
	var row: Dictionary = wp.SESSIONS.get(sid, wp.EVENINGS.get(sid, {}))
	return str(row.get("stat", ""))


static func train(f: Dictionary, stat: String, gain: float, names: Array = []) -> Dictionary:
	var a := of(f)
	var kids: Array = LEGACY.get(stat, [])
	var out := {}
	var inside: Array = names.filter(func(n): return kids.has(n))
	if kids.is_empty():
		for n in names:
			out[n] = gain
		# Rest trains recovery and must not move conditioning, the mean of stamina and recovery (WeekPlan leaves the
		# old stat at 0 on a rest day). The same points come off stamina.
		if float(out.get("recovery", 0.0)) > 0.0 and not out.has("stamina"):
			out["stamina"] = -float(out["recovery"])
	elif inside.is_empty():
		for c in kids:
			out[c] = gain
	else:
		var total := gain * float(kids.size())
		var each := minf(total / float(inside.size()), gain * NAMED_MAX)
		var rest := total - each * float(inside.size())
		var others: Array = kids.filter(func(c): return not inside.has(c))
		for c in inside:
			out[c] = each
		for c in others:
			out[c] = rest / float(maxi(1, others.size()))
	for n in names:
		if not kids.has(n) and not out.has(n) and ABILITIES.has(n):
			out[n] = gain * OUTSIDE_SHARE
	for k in out:
		var was := float(a.get(k, 55.0))
		a[k] = clampf(was + float(out[k]), LO, HI)
		out[k] = float(a[k]) - was
	sync(f)
	return out


static func weighted(a: Dictionary, missing: float = 55.0) -> float:
	var s := 0.0
	var total := 0.0
	for k in ABILITIES:
		var w := float(VALUE[k])
		s += float(a.get(k, missing)) * w
		total += w
	return s / total


## Value-weighted mean of punch offsets. Missing punches count as 0: a shape that never mentions them has no punch level.
static func punch_mean(a: Dictionary) -> float:
	var s := 0.0
	var total := 0.0
	for k in PUNCHES:
		var w := float(PUNCH_VALUE[k])
		s += float(a.get(k, 0.0)) * w
		total += w
	return s / total


static func overall(a: Dictionary) -> float:
	return weighted(a)


static func spikes(a: Dictionary) -> Array:
	var mean := overall(a)
	var rows: Array = []
	for k in ABILITIES + ["heart"]:
		if a.has(k):
			rows.append([k, float(a[k]) - mean])
	rows.sort_custom(func(x, y): return absf(float(x[1])) > absf(float(y[1])))
	return rows


static func signature(a: Dictionary) -> String:
	var up: Array = []
	var down := ""
	for r in spikes(a):
		if float(r[1]) >= SPIKE_AT and up.size() < 2:
			up.append(str(HIGH_WORD.get(r[0], r[0])))
		elif float(r[1]) <= -SPIKE_AT and down == "":
			down = str(LOW_WORD.get(r[0], r[0]))
	var line := ", ".join(PackedStringArray(up))
	if down != "":
		line = (line + " - " + down) if line != "" else down
	return line.substr(0, 1).to_upper() + line.substr(1) if line != "" else ""


static func wants_words(a: Dictionary) -> String:
	var fw := float(a.get("forward", 50.0))
	var pace := float(a.get("pace", 55.0))
	var where := "Walks forward" if fw >= 65.0 else ("Stays at range" if fw <= 35.0 else "Boxes mid-ring")
	var how := "busy, tires faster" if pace >= 70.0 else ("patient, picks shots" \
		if pace <= 35.0 else "steady pace")
	return "%s, %s" % [where, how]
