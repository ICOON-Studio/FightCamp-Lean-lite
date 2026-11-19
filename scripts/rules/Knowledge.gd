extends RefCounted
## KNOW2 - Knowledge v3, pure rules: groups, widths, reads, stale, hype, moments (issue #378, KNOWLEDGE1A).
## Pure static; preloads only Attrs.gd. No he/she (S412). No names in lines (S448).
## "The range never lies" - truth always inside [lo, hi].

const Attrs := preload("res://scripts/rules/Attrs.gd")

# --- Group membership (v3) ---
const BODY_ATTRS: Array[String] = ["strength", "explosiveness", "speed", "stamina", "recovery", "flexibility"]
const SKILLS_ATTRS: Array[String] = ["accuracy", "timing", "defence", "footwork", "inside", "fight_iq"]
const UNDER_FIRE_ATTRS: Array[String] = ["durability", "composure"]
const MIND_ATTRS: Array[String] = ["heart", "discipline", "confidence", "coachability", "temper", "loyalty"]
const GROUPS: Dictionary = {"body": BODY_ATTRS, "skills": SKILLS_ATTRS, "under_fire": UNDER_FIRE_ATTRS, "mind": MIND_ATTRS}
const FIRE_ATTRS: Array = UNDER_FIRE_ATTRS  # backward compat (heart moved to mind)

# --- Day-one half-widths (ESTIMATE) ---
const BODY_START := 8.0   ## ESTIMATE
const SKILLS_START := 12.0  ## ESTIMATE
const UNDER_FIRE_START := 15.0  ## ESTIMATE
const FIRE_START := 15.0  # backward compat

# --- Width formula ---
const FLOOR := 0.5  ## ESTIMATE
const HALF := 12.0  ## ESTIMATE
const FIRE_SPAR_CAP := 12.5  ## ESTIMATE

# --- Exposure (ESTIMATE) ---
const MORNING_PER3 := 1.0  ## ESTIMATE - 1 pt off each edge per 3 mornings
const PAD_NIGHT_PER := 1.0  ## ESTIMATE - 1 pt a night on skills
const HARD_SPAR_CLUB_FRAC := 0.5  ## ESTIMATE
const HARD_SPAR_OUTSIDE_FRAC := 0.75  ## ESTIMATE
const BOUT_FIRE_NARROW := 4.0  ## ESTIMATE - 4 pts off each edge
const GOAL_NARROW := 3.0  ## ESTIMATE

# --- Offset bounds ---
const OFFSET_LO := -0.6
const OFFSET_HI := 0.6
const HYPE_MAX_LIFT := 0.3
const HYPE_CEIL := 0.9

# --- Known thresholds ---
const KNOWN_SHARE := 0.6
const PIP_SHARES: Array[float] = [0.2, 0.4, 0.6, 0.75, 5.0 / 6.0]
const EPS := 0.0001

# --- Room word (ESTIMATE) ---
const ROOM_LOTS := 15.0  ## ESTIMATE
const ROOM_SOME := 5.0   ## ESTIMATE

# --- Width word (ESTIMATE) ---
const WORD_EXACT_HI := 2.0   ## ESTIMATE
const WORD_GOOD_LO := 3.0    ## ESTIMATE
const WORD_GOOD_HI := 8.0    ## ESTIMATE
const WORD_ROUGH_HI := 15.0  ## ESTIMATE

# --- Hype (ESTIMATE) ---
const HYPE_OFFSET_LO := 3.0  ## ESTIMATE
const HYPE_OFFSET_HI := 8.0  ## ESTIMATE
const HYPE_NORMAL_HI := 2.0  ## ESTIMATE

# --- Moment (ESTIMATE) ---
const MOMENT_THRESHOLD := 5.0  ## ESTIMATE

# --- Stale (ESTIMATE) ---
const STALE_STOPPAGE := 6.0  ## ESTIMATE
const STALE_LAYOFF := 3.0    ## ESTIMATE
const STALE_STEP_UP := 4.0   ## ESTIMATE
const STALE_AGE_BODY := 2.0   ## ESTIMATE

# --- Recheck (ESTIMATE) ---
const RECHECK_INTERVAL_DAYS := 21  ## ESTIMATE


static func fresh(seed: int) -> Dictionary:
	return {"seed": seed, "seen_all": false, "body": 0.0, "skills": 0.0, "fire_spar": 0.0,
		"fire_bout": 0.0, "under_fire_opened": false, "stale_fire": 0.0, "stale_body": 0.0,
		"stale_causes": [], "hyped": false, "last_bout_week": -1, "bout_count": 0}

static func all_seen() -> Dictionary:
	return {"seed": 0, "seen_all": true, "body": 0.0, "skills": 0.0, "fire_spar": 0.0,
		"fire_bout": 0.0, "under_fire_opened": true, "stale_fire": 0.0, "stale_body": 0.0,
		"stale_causes": [], "hyped": false, "last_bout_week": -1, "bout_count": 0}

static func group_of(attr: String) -> String:
	for g in GROUPS:
		if g == "mind":
			continue
		if (GROUPS[g] as Array).has(attr):
			return g
	return ""

## Half-width for a group. under_fire UNKNOWN (wide) until first hard spar.
static func width(k: Dictionary, group: String) -> float:
	if k.get("seen_all", false):
		return 0.0
	var g := _rg(group)
	if g == "" or g == "mind":
		return 0.0
	if g == "under_fire" and not k.get("under_fire_opened", false):
		return WORD_ROUGH_HI + 1.0  # Unknown
	var start: float = _start_of(g)
	if start <= 0.0:
		return 0.0
	var exposure: float = _effective_exposure(k, g)
	return FLOOR + (start - FLOOR) / (1.0 + exposure / HALF) + _stale_of(g, k)

# --- Exposure functions ---

static func morning(k: Dictionary, focus_group: String) -> void:
	if k.get("seen_all", false):
		return
	var g := _rg(focus_group)
	if g == "body":
		k["body"] = float(k.get("body", 0.0)) + MORNING_PER3 / 3.0
	elif g == "skills":
		k["skills"] = float(k.get("skills", 0.0)) + MORNING_PER3 / 3.0

static func pad_night(k: Dictionary, drilled: int) -> void:
	if k.get("seen_all", false) or drilled <= 0:
		return
	k["skills"] = float(k.get("skills", 0.0)) + float(drilled) * PAD_NIGHT_PER

static func hard_spar(k: Dictionary, outside: bool) -> void:
	if k.get("seen_all", false):
		return
	var frac: float = HARD_SPAR_OUTSIDE_FRAC if outside else HARD_SPAR_CLUB_FRAC
	if not k.get("under_fire_opened", false):
		k["under_fire_opened"] = true
		k["fire_spar"] = (UNDER_FIRE_START - FLOOR) * frac
	else:
		var target: float = (UNDER_FIRE_START - FLOOR) * frac
		if float(k.get("fire_spar", 0.0)) < target:
			k["fire_spar"] = target

static func bout(k: Dictionary) -> void:
	if k.get("seen_all", false):
		return
	if not k.get("under_fire_opened", false):
		k["under_fire_opened"] = true
	k["fire_bout"] = float(k.get("fire_bout", 0.0)) + BOUT_FIRE_NARROW
	k["bout_count"] = int(k.get("bout_count", 0)) + 1

static func goal_met(k: Dictionary, attr: String) -> void:
	if k.get("seen_all", false):
		return
	var g := group_of(attr)
	if g == "" or g == "mind":
		return
	if g == "body":
		k["body"] = float(k.get("body", 0.0)) + GOAL_NARROW
	elif g == "skills":
		k["skills"] = float(k.get("skills", 0.0)) + GOAL_NARROW
	elif g == "under_fire" and k.get("under_fire_opened", false):
		k["fire_bout"] = float(k.get("fire_bout", 0.0)) + GOAL_NARROW

## Legacy expose() for backward compat.
static func expose(k: Dictionary, group: String, amount: float, kind: String) -> void:
	if amount < 0.0:
		return
	var g := _rg(group)
	if g == "under_fire":
		if amount > 0.0 and (kind == "spar" or kind == "bout"):
			k["under_fire_opened"] = true  # a hard spar or a bout opens it (design s4; S524 fix)
		if kind == "spar":
			k["fire_spar"] = float(k.get("fire_spar", 0.0)) + amount
		elif kind == "bout":
			k["fire_bout"] = float(k.get("fire_bout", 0.0)) + amount
	elif g == "body" and (kind == "session" or kind == "test"):
		k["body"] = float(k.get("body", 0.0)) + amount
	elif g == "skills" and (kind == "session" or kind == "test" or kind == "spar"):
		k["skills"] = float(k.get("skills", 0.0)) + amount

static func range_of(k: Dictionary, attr: String, truth: float, hype: float = 0.0) -> Dictionary:
	var w: float = _attr_width(k, attr)
	if w <= 0.0:
		return {"lo": truth, "hi": truth, "centre": truth, "width": 0.0}
	var offset: float = _offset(k, attr)
	var lifted: float = minf(offset + clampf(hype, 0.0, 1.0) * HYPE_MAX_LIFT, HYPE_CEIL)
	var centre: float = truth + lifted * w
	var lo: float = clampf(truth + (lifted - 1.0) * w, 0.0, 100.0)
	var hi: float = clampf(truth + (lifted + 1.0) * w, 0.0, 100.0)
	return {"lo": lo, "hi": hi, "centre": centre, "width": w}

## Stale: widens under_fire or body, records cause.
static func stale(k: Dictionary, why: String) -> void:
	if k.get("seen_all", false):
		return
	var amount: float = 0.0
	var target: String = ""
	var cause: String = ""
	if why == "stoppage" or why == "knockout":
		amount = STALE_STOPPAGE; target = "under_fire"; cause = "Stoppage loss: under fire widened"
	elif why == "layoff":
		amount = STALE_LAYOFF; target = "under_fire"; cause = "12+ weeks without a bout: under fire widened"
	elif why == "step_up":
		amount = STALE_STEP_UP; target = "under_fire"; cause = "A step up: under fire widened"
	elif why == "ageing":
		amount = STALE_AGE_BODY; target = "body"; cause = "Age 30+: body widened"
	else:
		return
	if target == "under_fire":
		k["stale_fire"] = float(k.get("stale_fire", 0.0)) + amount
	elif target == "body":
		k["stale_body"] = float(k.get("stale_body", 0.0)) + amount
	var causes: Array = k.get("stale_causes", [])
	causes.append(cause)
	k["stale_causes"] = causes

static func stale_causes(k: Dictionary) -> Array:
	return k.get("stale_causes", [])

static func recheck(k: Dictionary) -> void:
	if k.get("seen_all", false):
		return
	k["stale_fire"] = float(k.get("stale_fire", 0.0)) * 0.5
	k["stale_body"] = float(k.get("stale_body", 0.0)) * 0.5

static func recheck_ready(k: Dictionary, day: int) -> bool:
	return (day - int(k.get("last_recheck_day", -999))) >= RECHECK_INTERVAL_DAYS

static func recheck_done(k: Dictionary, day: int) -> void:
	k["last_recheck_day"] = day

static func share_gone(k: Dictionary, group: String) -> float:
	var g := _rg(group)
	if g == "" or g == "mind" or _start_of(g) <= 0.0:
		return 0.0  # potential stays a Room to grow word, never known (design s4)
	if k.get("seen_all", false):
		return 1.0
	var start: float = _start_of(g)
	if start <= FLOOR:
		return 0.0
	var w: float = width(k, g)
	return clampf(1.0 - (w - FLOOR) / (start - FLOOR), 0.0, 1.0)

static func known(k: Dictionary, group: String) -> bool:
	return share_gone(k, group) >= KNOWN_SHARE - EPS

static func known_share(k: Dictionary) -> float:
	return (share_gone(k, "body") + share_gone(k, "skills") + share_gone(k, "under_fire")) / 3.0

static func pip_of(k: Dictionary) -> int:
	var ks: float = known_share(k)
	var count: int = 0
	for s in PIP_SHARES:
		if ks >= s - EPS:
			count += 1
	return count

static func shown(k: Dictionary, attr: String, truth: float, hype: float = 0.0) -> Dictionary:
	var g: String = group_of(attr)
	if g == "" or g == "mind":
		var r: Dictionary = range_of(k, attr, truth, hype)
		r["known"] = true
		return r
	if known(k, g):
		return {"lo": truth, "hi": truth, "centre": truth, "width": 0.0, "known": true}
	var r2: Dictionary = range_of(k, attr, truth, hype)
	r2["known"] = false
	return r2

## Room to grow: pot - stat -> "lots" / "some" / "little".
static func room_word(pot: float, stat: float) -> String:
	var gap: float = pot - stat
	if gap >= ROOM_LOTS:
		return "lots"
	elif gap >= ROOM_SOME:
		return "some"
	return "little"

## Width word: half_width -> "Unknown" / "Rough" / "Good read" / "Exact".
static func word(half_width: float) -> String:
	if half_width > WORD_ROUGH_HI:
		return "Unknown"
	elif half_width > WORD_GOOD_HI:
		return "Rough"
	elif half_width >= WORD_GOOD_LO:
		return "Good read"
	elif half_width > WORD_EXACT_HI:
		return "Good read"
	return "Exact"

## Hyped centre offset: 3-8 pts high for Hyped, <=2 otherwise.
static func hyped_centre_offset(seed: int, is_hyped: bool) -> float:
	var h: int = hash([seed, "hype_offset"])
	var bucket: int = absi(h) % 10001
	if is_hyped:
		return HYPE_OFFSET_LO + float(bucket) / 10000.0 * (HYPE_OFFSET_HI - HYPE_OFFSET_LO)
	return float(bucket) / 10000.0 * HYPE_NORMAL_HI

static func set_hyped(k: Dictionary, is_hyped: bool) -> void:
	k["hyped"] = is_hyped

static func clear_hype(k: Dictionary) -> void:
	k["hyped"] = false

static func is_hyped(k: Dictionary) -> bool:
	return k.get("hyped", false)

## Moment: true when width changed 5+ pts or under_fire opened for first time.
static func moment(before: Dictionary, after: Dictionary) -> bool:
	if after.get("under_fire_opened", false) and not before.get("under_fire_opened", false):
		return true
	for g in ["body", "skills", "under_fire"]:
		if g == "under_fire" and not after.get("under_fire_opened", false):
			continue
		if absf(width(before, g) - width(after, g)) >= MOMENT_THRESHOLD:
			return true
	return false

## Monday lines: at most 2 per boxer, no names (S448), no pronouns (S412).
static func monday_lines(changes: Array) -> Array:
	var lines: Array = []
	for c in changes:
		if lines.size() >= 2:
			break
		var label: String = Attrs.LABEL.get(str(c.get("attr", "")), str(c.get("attr", "")))
		var b_lo: float = float(c.get("before_lo", 0))
		var b_hi: float = float(c.get("before_hi", 0))
		var a_lo: float = float(c.get("after_lo", 0))
		var a_hi: float = float(c.get("after_hi", 0))
		var cb: float = float(c.get("centre_before", 0))
		var ca: float = float(c.get("centre_after", 0))
		var narrowed: float = (b_hi - b_lo) - (a_hi - a_lo)
		var delta: float = ca - cb
		var dir: String = "up" if delta > 0 else "down" if delta < 0 else "steady"
		lines.append("%s %d-%d, narrowed by %d, centre %s %d" % [
			label, int(round(a_lo)), int(round(a_hi)), int(round(narrowed)), dir, int(round(absf(delta)))])
	return lines

# --- internal ---

static func _rg(group: String) -> String:
	if group == "fire":
		return "under_fire"
	return group

static func _start_of(group: String) -> float:
	var g := _rg(group)
	if g == "body": return BODY_START
	if g == "skills": return SKILLS_START
	if g == "under_fire": return UNDER_FIRE_START
	return 0.0

static func _effective_exposure(k: Dictionary, group: String) -> float:
	var g := _rg(group)
	if g == "under_fire":
		return float(k.get("fire_bout", 0.0)) + minf(float(k.get("fire_spar", 0.0)), FIRE_SPAR_CAP)
	elif g == "body":
		return float(k.get("body", 0.0))
	elif g == "skills":
		return float(k.get("skills", 0.0))
	return 0.0

static func _stale_of(group: String, k: Dictionary) -> float:
	var g := _rg(group)
	if g == "under_fire":
		return float(k.get("stale_fire", 0.0))
	elif g == "body":
		return float(k.get("stale_body", 0.0))
	return 0.0

static func _attr_width(k: Dictionary, attr: String) -> float:
	var g: String = group_of(attr)
	if g == "" or g == "mind":
		return 0.0
	return width(k, g)

static func _offset(k: Dictionary, attr: String) -> float:
	var seed: int = int(k.get("seed", 0))
	var h: int = hash([seed, attr])
	var bucket: int = absi(h) % 10001
	return float(bucket) / 10000.0 * (OFFSET_HI - OFFSET_LO) + OFFSET_LO
