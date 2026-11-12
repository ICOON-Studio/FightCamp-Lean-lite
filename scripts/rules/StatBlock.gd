extends RefCounted
## S443 one set of numbers (ops/research/UX_AUDIT_S442.md finding 2, proposal A; operator Q-S294-195: "Stamina"): every
## screen that shows a fighter's numbers reads them here, so one boxer has the same names and the same overall everywhere.
## The one truth is the fighter page's: the attributes (Attrs.of) and their measured level (Attrs.overall), shown as a
## whole number the way the page shows every value (floor). Pure static.
##   overall(f) -> int   groups(f) -> [{key, name, value}]   ceiling(f, group) -> float   shown(v) -> int
##   week_rows(f, start) -> the week review's rows (WeekRead.stat reads them)

const Attrs := preload("res://scripts/rules/Attrs.gd")
const Recruit := preload("res://scripts/rules/Recruit.gd")
const WeekCause := preload("res://scripts/rules/WeekCause.gd")
const Data := preload("res://scripts/state/Data.gd")

## The short form: the fighter page's three groups (Attrs.GROUPS), in its order, with the same words on every screen.
const GROUPS := [["physical", "Body"], ["skill", "Boxing skills"], ["mind", "Mind"]]
## An old summary stat whose word is an attribute's: wherever a screen shows that word, it shows the attribute's own number
## (conditioning, the mean of Stamina and Recovery, is called Stamina; fight_iq, the mean of Fight IQ and Composure, is
## called Fight IQ). The other five are the attribute itself (Speed, Defence, Durability) or a word no attribute has
## (Power, Technique).
const SHOWN_AS := {"conditioning": "stamina", "fight_iq": "fight_iq"}


## A value as the fighter page prints it.
static func shown(v: float) -> int:
	return int(floorf(v))


## The one overall number: the fighter page's ring.
static func overall(f: Dictionary) -> int:
	return shown(Attrs.overall(Attrs.of(f)))


static func group_value(a: Dictionary, group: String) -> float:
	var keys: Array = Attrs.GROUPS[group]
	var s := 0.0
	for k in keys:
		s += float(a.get(k, 55.0))
	return s / float(keys.size())


static func groups(f: Dictionary) -> Array:
	var a := Attrs.of(f)
	var out: Array = []
	for g in GROUPS:
		out.append({"key": str(g[0]), "name": str(g[1]), "value": group_value(a, str(g[0]))})
	return out


## How high a group can go: the mean of its abilities' ceilings (Recruit.ceiling_of); heart is not trained, so its value.
static func ceiling(f: Dictionary, group: String) -> float:
	var a := Attrs.of(f)
	var keys: Array = Attrs.GROUPS[group]
	var s := 0.0
	for k in keys:
		s += float(a.get(k, 55.0)) if str(k) == "heart" else Recruit.ceiling_of(f, str(k))
	return s / float(keys.size())


## The week review's rows: the seven the week's read is made of, the two of SHOWN_AS on their attribute's own number (its
## value at the week's start is f["attrs_week"]; a first week without one steps back by the summary's own change).
static func week_rows(f: Dictionary, start: Dictionary) -> Array:
	var a := Attrs.of(f)
	var was: Dictionary = f.get("attrs_week", {})
	var src: Dictionary = f.get("week_src", {})
	var rows: Array = []
	for key in Data.STATS:
		var x := {"st": key, "before": float(start.get(key, f["stats"][key])), "after": float(f["stats"][key]),
			"why": WeekCause.words(src, key), "src": WeekCause.top(src, key)}
		if SHOWN_AS.has(key):
			var ab := str(SHOWN_AS[key])
			var now := float(a.get(ab, x["after"]))
			x["attr"] = ab
			x["before"] = float(was.get(ab, now - (float(x["after"]) - float(x["before"]))))
			x["after"] = now
		rows.append(x)
	return rows
