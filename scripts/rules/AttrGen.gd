extends RefCounted
## S398 everyone who is not the player's fighter: a level (the table rating, which results and age move) + a shape (an
## offset per attribute, mean 0) + dials + body facts (FIGHTER_MODEL_S397.md v2 section 7). Attributes = level + shape.
## generate() makes a new boxer's shape from three correlated base traits, an archetype tilt, a signature and a flaw
## (sports-sim critic); shape_of() gives any opponent dict its shape: the stored one, else one read from its style and
## scouting words with a spread seeded by its name, so a fixed opponent is the same person every time.
## Pure static; zero preloads. Numbers are game values (GV) unless cited.

const Attrs := preload("res://scripts/rules/Attrs.gd")

## Archetype tilts (boxing critic's table, round 1): attribute -> points. dials = {pace, forward}.
const TILTS := {
	"Out-boxer": {"footwork": 10, "speed": 8, "defence": 6, "timing": 3, "inside": -8, "strength": -6, "explosiveness": -6, "jab": 10},
	"Swarmer": {"inside": 10, "stamina": 10, "defence": 6, "durability": 6, "footwork": -4, "accuracy": -4, "hooks": 8, "jab": -8},
	"Pressure fighter": {"footwork": 6, "defence": 8, "explosiveness": 5, "stamina": 6, "speed": -6, "timing": -4, "hooks": 8, "jab": -6},
	"Stalker": {"footwork": 10, "explosiveness": 8, "defence": 8, "timing": 6, "speed": -5, "stamina": -4},
	"Slugger": {"explosiveness": 12, "durability": 8, "strength": 8, "speed": -7, "accuracy": -6, "footwork": -8, "hooks": 6},
	"Counter-puncher": {"timing": 12, "defence": 8, "fight_iq": 8, "accuracy": 6, "stamina": -4, "inside": -6, "jab": -2},
	"Volume puncher": {"stamina": 10, "speed": 8, "recovery": 4, "explosiveness": -8, "durability": -2, "timing": -4, "straight": 6},
	"Boxer-puncher": {"timing": 5, "explosiveness": 5, "fight_iq": 3, "inside": -3, "jab": 5, "straight": 5},
	"Spoiler": {"strength": 8, "inside": 8, "defence": 8, "composure": 6, "explosiveness": -6, "speed": -4, "straight": -4},
}
const DIALS := {"Out-boxer": [50, 20], "Swarmer": [85, 85], "Pressure fighter": [65, 80], "Stalker": [45, 75],
	"Slugger": [40, 70], "Counter-puncher": [30, 35], "Volume puncher": [90, 60], "Boxer-puncher": [55, 50], "Spoiler": [35, 45]}
const ARCHETYPES := ["Out-boxer", "Swarmer", "Pressure fighter", "Stalker", "Slugger", "Counter-puncher", "Volume puncher",
	"Boxer-puncher", "Spoiler"]
## Which base trait each attribute leans on (sports-sim critic: athletic, skill, mind; correlated 0.2).
const BASE := {"strength": "ath", "explosiveness": "ath", "speed": "ath", "stamina": "ath", "recovery": "ath",
	"flexibility": "ath", "durability": "", "accuracy": "skill", "timing": "skill", "defence": "skill", "footwork": "skill",
	"inside": "skill", "fight_iq": "mind", "composure": "mind", "jab": "skill", "straight": "skill", "hooks": "skill",
	"uppercuts": "skill"}
const BASE_SD := 4.0
const NOISE_SD := 4.0
const SIGNATURE := 12.0
const FLAW := -12.0
const CORE_FLAWS := ["durability", "stamina", "defence", "footwork"]
const CORE_FLAW_CHANCE := 0.75
const SECOND_TILT := 0.15
const TILT_SCALE := 1.0
## Generated shapes only (tilt_of stays put, so the archetype bar does not move). The linear centre prices a
## point; it does not price the best tool. SHAPE_SCALE makes a typical opponent a style worth scouting, and
## the punch tax pays the best-tool bonus so the scouted read stays centred on the level.
const SHAPE_SCALE := 2.05
const PUNCH_TAX := 1.95
## Scouting words -> shape points (the scout's line is what the profile is).
const WORDS := [["body", {"hooks": 6, "inside": 3}], ["right", {"straight": 6}], ["cross", {"straight": 6}],
	["straight", {"straight": 5}], ["jab", {"jab": 6}], ["flurr", {"speed": 6, "stamina": 4}],
	["never stops", {"stamina": 8, "speed": 4}], ["combination", {"speed": 6}], ["counter", {"timing": 6}],
	["hook", {"hooks": 5}], ["overhand", {"explosiveness": 6, "accuracy": -4}], ["one big", {"explosiveness": 8, "speed": -4}],
	["stops people", {"explosiveness": 10}], ["end it", {"explosiveness": 8}], ["fast feet", {"speed": 8, "footwork": 4}],
	["long arms", {"jab": 4}], ["moves well", {"footwork": 8}], ["relentless", {"stamina": 6, "durability": 4}],
	["patient", {"fight_iq": 6, "accuracy": 4}], ["breaks the body", {"hooks": 6, "explosiveness": 4}]]
const WEAK_WORDS := [["fades", {"stamina": -14, "recovery": -8}], ["legs late", {"stamina": -8, "speed": -4}],
	["heavy legs", {"stamina": -8, "recovery": -4}], ["chin", {"durability": -10, "defence": -4}],
	["walks in straight", {"footwork": -8, "defence": -6}], ["straight lines", {"footwork": -8, "speed": -4}],
	["slow feet", {"speed": -8, "footwork": -4}], ["flat-footed", {"speed": -8, "footwork": -4}],
	["stands still", {"footwork": -4, "defence": -4}], ["backed up", {"strength": -6, "inside": -6}],
	["onto the ropes", {"footwork": -6, "composure": -4}], ["backs straight", {"footwork": -6}],
	["drops the right", {"defence": -6}], ["wide", {"defence": -4, "accuracy": -4}], ["loads up", {"accuracy": -6, "speed": -4}],
	["slow to start", {"fight_iq": -2}], ["rarely leads", {"jab": -4}], ["round 1", {"fight_iq": -2}]]
const SPREAD := 3.0
## Age shape, per year past the start (critics: speed first, then legs and recovery, then chin; ring IQ to 33; power last).
const AGE_RULES := [["speed", 29, -1.0], ["recovery", 31, -0.8], ["durability", 31, -0.8], ["explosiveness", 34, -0.5]]
const IQ_RISE := 0.5
const IQ_UNTIL := 33
const STOP_CHIN := 2.0
const OLD_FORWARD_FROM := 32
## Builds of a profile. A repeated read of the same boxer does not count. The speed test reads this.
static var n_build := 0
static var _built := {}


static func _stamp(b: Dictionary) -> String:
	var sh: Dictionary = b.get("shape", {})
	var shape_s := str(sh) if not sh.is_empty() else "w|%s|%s|%s" % [str(b.get("name", "")), str(b.get("threat", "")), str(b.get("weak", ""))]
	var stops := int((b.get("damage_ledger", {}) as Dictionary).get("stoppage_losses", 0))
	return "%s|%s|%.4f|%d|%d|%d|%.4f|%.4f|%.4f" % [shape_s, str(b.get("style", "")), float(b.get("rating", 60.0)),
		int(b.get("age", -1)), 1 if b.has("peak_age") else 0, stops,
		float(b.get("pace", -1.0)) if b.has("pace") else -1.0, float(b.get("forward", -1.0)) if b.has("forward") else -1.0,
		float(b.get("heart", 55.0))]


## The tilt for a style word, re-centred to measured value 0 over the abilities ({} for an unknown word).
static func tilt_of(style: String) -> Dictionary:
	var t: Dictionary = TILTS.get(style, {})
	return _centred(t)


static func _centred(t: Dictionary) -> Dictionary:
	if t.is_empty():
		return {}
	var mean := Attrs.weighted(t, 0.0)
	var out := {}
	for k in Attrs.ABILITIES:
		out[k] = float(t.get(k, 0.0)) - mean
	for k in Attrs.PUNCHES:
		out[k] = float(t.get(k, 0.0))
	return out


## A new boxer's profile: {shape, pace, forward, heart, style, signature, flaw}. archetype "" = one picked by the dice.
static func generate(rng: RandomNumberGenerator, archetype: String = "") -> Dictionary:
	var arch := archetype if TILTS.has(archetype) else str(ARCHETYPES[rng.randi_range(0, ARCHETYPES.size() - 1)])
	var common := rng.randfn(0.0, BASE_SD)
	var base := {"ath": 0.45 * common + rng.randfn(0.0, BASE_SD), "skill": 0.45 * common + rng.randfn(0.0, BASE_SD),
		"mind": 0.45 * common + rng.randfn(0.0, BASE_SD), "": 0.0}
	var raw := {}
	var tilt: Dictionary = TILTS[arch]
	var second := ""
	if rng.randf() < SECOND_TILT:
		second = str(ARCHETYPES[rng.randi_range(0, ARCHETYPES.size() - 1)])
	for k in Attrs.ABILITIES + Attrs.PUNCHES:
		raw[k] = float(base[str(BASE.get(k, "skill"))]) + rng.randfn(0.0, NOISE_SD) + float(tilt.get(k, 0.0)) * TILT_SCALE \
			+ (float((TILTS[second] as Dictionary).get(k, 0.0)) * 0.5 if second != "" and second != arch else 0.0)
	var sig := str(Attrs.ABILITIES[rng.randi_range(0, Attrs.ABILITIES.size() - 1)])
	var flaw_pool: Array = CORE_FLAWS if rng.randf() < CORE_FLAW_CHANCE else Attrs.ABILITIES
	var flaw := sig
	while flaw == sig:
		flaw = str(flaw_pool[rng.randi_range(0, flaw_pool.size() - 1)])
	raw[sig] = float(raw[sig]) + SIGNATURE
	raw[flaw] = float(raw[flaw]) + FLAW
	var dials: Array = DIALS[arch]
	var shape := _centred(raw)
	# Punches are not in the ability level. Centre them on their measured value, then widen the whole shape.
	# The tax pays the best-tool bonus a linear centre does not charge, so a scouted read stays on the level.
	var pmean := Attrs.punch_mean(shape)
	for k in Attrs.PUNCHES:
		shape[k] = float(shape[k]) - pmean
	for k in shape:
		shape[k] = float(shape[k]) * SHAPE_SCALE
	for k in Attrs.PUNCHES:
		shape[k] = float(shape[k]) - PUNCH_TAX
	return {"shape": shape, "pace": clampf(float(dials[0]) + rng.randfn(0.0, 8.0), 5.0, 95.0),
		"forward": clampf(float(dials[1]) + rng.randfn(0.0, 8.0), 5.0, 95.0), "heart": clampf(rng.randfn(60.0, 12.0), 20.0, 95.0),
		"archetype": arch, "signature": sig, "flaw": flaw}


## The shape an opponent fights with: its own (b["shape"]) or one read from its style and words, seeded by its name.
static func shape_of(b: Dictionary) -> Dictionary:
	if b.has("shape") and not (b["shape"] as Dictionary).is_empty():
		return b["shape"]
	var raw := {}
	var tilt: Dictionary = TILTS.get(str(b.get("style", "")), TILTS["Boxer-puncher"])
	var rng := RandomNumberGenerator.new()
	rng.seed = hash("shape|" + str(b.get("name", "")))
	for k in Attrs.ABILITIES + Attrs.PUNCHES:
		raw[k] = float(tilt.get(k, 0.0)) + rng.randf_range(-SPREAD, SPREAD)
	var threat := str(b.get("threat", "")).to_lower()
	var weak := str(b.get("weak", "")).to_lower()
	for pair in WORDS:
		if threat.contains(str(pair[0])):
			_add(raw, pair[1])
	for pair in WEAK_WORDS:
		if weak.contains(str(pair[0])):
			_add(raw, pair[1])
	return _centred(raw)


static func _add(raw: Dictionary, d: Dictionary) -> void:
	for k in d:
		raw[k] = float(raw.get(k, 0.0)) + float(d[k])


## The dials of an opponent dict: its own, else its style's.
static func dials_of(b: Dictionary) -> Array:
	var d: Array = DIALS.get(str(b.get("style", "")), DIALS["Boxer-puncher"])
	return [float(b.get("pace", d[0])), float(b.get("forward", d[1]))]


## What age has done to a boxer's shape (generated boxers only: the player's fighters age through training).
static func age_wear(b: Dictionary) -> Dictionary:
	var age := int(b.get("age", 25))
	var out := {}
	for r in AGE_RULES:
		var years := maxi(0, age - int(r[1]))
		if years > 0:
			out[r[0]] = float(r[2]) * float(years)
	out["fight_iq"] = IQ_RISE * float(clampi(mini(age, IQ_UNTIL) - 24, 0, 9))
	var stops := int((b.get("damage_ledger", {}) as Dictionary).get("stoppage_losses", 0))
	out["durability"] = float(out.get("durability", 0.0)) - STOP_CHIN * float(stops)
	# Age changes the shape, not the level: WorldAge moves the rating, so the wear is re-centred to mean 0.
	return _centred(out) if not out.is_empty() else out


## Any non-player boxer's attributes: level (its rating) + shape + age wear, with heart, pace, forward.
## The same boxer (same rating, shape, age, words) is built once and copied out, so a bout does not rebuild him per punch.
static func attrs_of(b: Dictionary) -> Dictionary:
	var stamp := _stamp(b)
	if _built.has(stamp):
		return (_built[stamp] as Dictionary).duplicate()
	n_build += 1
	var a := _attrs_build(b)
	_built[stamp] = a
	return a.duplicate()


static func _attrs_build(b: Dictionary) -> Dictionary:
	var lvl := float(b.get("rating", 60.0))
	var shape := shape_of(b)
	var wear := age_wear(b) if b.has("age") and b.has("peak_age") else {}
	var a := {}
	for k in Attrs.ABILITIES:
		a[k] = clampf(lvl + float(shape.get(k, 0.0)) + float(wear.get(k, 0.0)), Attrs.LO, Attrs.HI)
	var punches := {}
	for k in Attrs.PUNCHES:
		punches[k] = clampf(lvl + float(shape.get(k, 0.0)) + float(wear.get(k, 0.0)), Attrs.LO, Attrs.HI)
	Attrs.lay(a, punches)
	var d := dials_of(b)
	a["pace"] = d[0]
	# Dola (S398 designer round): an old fighter walks down instead of boxing off the back foot - forward +1 a year past 32.
	a["forward"] = clampf(float(d[1]) + float(maxi(0, int(b.get("age", 0)) - OLD_FORWARD_FROM)) if b.has("peak_age") else float(d[1]), 5.0, 95.0)
	a["heart"] = float(b.get("heart", 55.0))
	return a


## Height and reach for a division's weight limit (kg): men about 1.4 cm a kg over 172 at 60 kg (GV, from England Boxing
## class spans), women 8 cm shorter; reach = height + 3 cm +- 4 (sports-sim critic).
static func body(rng: RandomNumberGenerator, sex: String, limit_kg: float) -> Dictionary:
	var h := 172.0 + (limit_kg - 60.0) * 1.0 - (8.0 if sex != "men" and sex != "m" else 0.0) + rng.randfn(0.0, 4.0)
	return {"height": roundi(h), "reach": roundi(h + 3.0 + rng.randfn(0.0, 4.0))}


## The style word the profile itself reads as; the generation label never overrides what its dials and tools became.
static func style_word(p: Dictionary) -> String:
	var a: Dictionary = p.get("attrs", p.get("shape", {}))
	var pace := float(p.get("pace", a.get("pace", DIALS.get(str(p.get("archetype", "")), [55.0, 50.0])[0])))
	var forward := float(p.get("forward", a.get("forward", DIALS.get(str(p.get("archetype", "")), [55.0, 50.0])[1])))
	var val := func(k: String) -> float: return float(a.get(k, 0.0))
	# A generated shape is offsets around 0, widened by SHAPE_SCALE. A fighter's attributes sit near the rating, and the
	# old cutoffs still read those.
	var span := SHAPE_SCALE if absf(Attrs.weighted(a, 0.0)) < 25.0 else 1.0
	var tool := 10.0 * span
	var cluster := 18.0 * span
	var edge := 5.0 * span
	if forward <= 35.0 and val.call("jab") + val.call("footwork") + val.call("speed") > tool:
		return "Out-boxer"
	if pace >= 78.0 and forward >= 72.0:
		return "Swarmer"
	if pace >= 78.0:
		return "Volume puncher"
	if val.call("timing") + val.call("fight_iq") + val.call("defence") > cluster and forward <= 55.0:
		return "Counter-puncher"
	if val.call("strength") + val.call("inside") + val.call("defence") > cluster and pace <= 50.0:
		return "Spoiler"
	if val.call("explosiveness") >= maxf(val.call("jab"), maxf(val.call("timing"), val.call("stamina"))) + edge:
		return "Slugger"
	if forward >= 72.0:
		return "Stalker" if pace < 58.0 else "Pressure fighter"
	return "Boxer-puncher"
