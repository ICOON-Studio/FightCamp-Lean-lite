extends RefCounted
## S524 KNOWLEDGE1 build step 2 (design v3 s14): what the club has seen of each boxer, fed by the week and the bouts.
## f["know"] is Knowledge.gd's record. A boxer signed from now on starts fresh (Roster.sign_fighter); a boxer with no
## record (an old save, the quick start's boxer) reads all_seen - exact, as today (design s4 "old saves stay Exact").
## Exposure (design s4 "Sharpens by"): a morning narrows its session's group (1 point an edge per 3 focused mornings);
## a pad or sparring night narrows Skills by 1; a bout narrows Under fire by 4 and is the only read that finishes it;
## a goal met narrows its attributes by 3. Stale (design s6): a stoppage loss, a step up (pro debut, a championship),
## 12+ weeks without a bout. Ageing waits: our boxers' ages do not tick yet (WorldAge ages the world's only).
## Nothing shown changes yet: the bands on the screens are build step 3 and 5.

const K := preload("res://scripts/rules/Knowledge.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")

const LAYOFF_DAYS := 84   ## design s6: 12+ weeks without a bout


static func of(f: Dictionary) -> Dictionary:
	if not f.has("know"):
		f["know"] = K.all_seen()
	return f["know"]


## A newly signed boxer: nothing seen yet beyond day one.
static func start(f: Dictionary) -> void:
	f["know"] = K.fresh(absi(hash(str(f.get("id", f.get("name", ""))))))


## The group a morning session trains ("" = none: rest, film).
static func morning_group(sid: String) -> String:
	for a in Attrs.SESSION_ATTRS.get(sid, []):
		var g := K.group_of(str(a))
		if g == "body" or g == "skills":
			return g
	return ""


## One day of the week: the morning's session id and the evening's id (WeekPlan.full_day's "evening").
static func day(f: Dictionary, sid: String, evening: String, resting: bool) -> void:
	if resting:
		return
	var k := of(f)
	var g := morning_group(sid)
	if g != "":
		K.morning(k, g)
	if evening == "pads" or evening == "sparring":
		K.pad_night(k, 1)


## After a bout: under fire narrows; a stoppage loss and a step up widen it again with their cause.
static func bout(f: Dictionary, stopped_loss: bool, step_up: bool, day_n: int) -> void:
	var k := of(f)
	K.bout(k)
	if stopped_loss:
		K.stale(k, "stoppage")
	if step_up:
		K.stale(k, "step_up")
	k["last_bout"] = day_n


## A goal met narrows each attribute it named (old keys share among their children, Attrs.LEGACY).
static func goal_met(f: Dictionary, targets: Dictionary) -> void:
	var k := of(f)
	var seen := {}
	for key in targets:
		var attrs: Array = Attrs.LEGACY.get(str(key), [str(key)])
		for a in attrs:
			if not seen.has(a):
				seen[a] = true
				K.goal_met(k, str(a))


## Sunday: 12+ weeks without a bout widens under fire once per layoff.
static func week_end(f: Dictionary, day_n: int) -> void:
	var k := of(f)
	if bool(k.get("seen_all", false)) or not bool(k.get("under_fire_opened", false)):
		return
	var last := int(k.get("last_bout", day_n))
	if day_n - last >= LAYOFF_DAYS and int(k.get("layoff_from", -1)) != last:
		K.stale(k, "layoff")
		k["layoff_from"] = last
