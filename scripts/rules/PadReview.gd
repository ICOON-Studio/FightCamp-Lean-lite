extends RefCounted
## S382 CARDFLIP1 (TRAINING_SCREEN_S381.md 5.6, build order item 3): the week review's PADS row, from the night log the week
## ran (PadWeek.run_week's log, DrillWeek.run "pads"). One row per drill card: mastery before -> after, the nights it got
## (pads and sparring, Mon..Sun), and the tier it crossed this week - usable 30, sharp 60, signature 85 - with the night that
## did it (the card flips gold in the review on that night's line). Two tiers in one week: the higher one (the gold back
## names what she has now). The row shows at most ROW_MAX cards: the ones that crossed first, then the biggest gains.
##   rows(log, nights) -> [{card, before, after, pads: [dow], spar: [dow], cross: {tier, at, dow, station, before, after} or {}}]
##   shown(rows) -> rows in the review's order, at most ROW_MAX
##   nights_text(row) -> "Mon Wed pads, Thu spar"
## Pure static.

const TIERS := [[30.0, "usable"], [60.0, "sharp"], [85.0, "signature"]]
const DAY_WORDS := ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
const ROW_MAX := 4


static func rows(log: Array, nights: Dictionary) -> Array:
	var spar_days: Array = nights.get("spar", [])
	var out: Array = []
	var at := {}
	for e in log:
		var dow := int(e[0])
		var card := str(e[1])
		var before := float(e[2])
		var after := float(e[3])
		if not at.has(card):
			at[card] = out.size()
			out.append({"card": card, "before": before, "after": after, "pads": [], "spar": [], "cross": {}})
		var r: Dictionary = out[int(at[card])]
		var station := "spar" if spar_days.has(dow) else "pads"
		if not (r[station] as Array).has(dow):
			(r[station] as Array).append(dow)
		r["after"] = after
		for t in TIERS:
			if before < float(t[0]) and after >= float(t[0]):
				r["cross"] = {"tier": str(t[1]), "at": float(t[0]), "dow": dow, "station": station, "before": before, "after": after}
	return out


static func shown(all: Array) -> Array:
	var out := all.duplicate()
	out.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var ca := not (a["cross"] as Dictionary).is_empty()
		var cb := not (b["cross"] as Dictionary).is_empty()
		if ca != cb:
			return ca
		return float(a["after"]) - float(a["before"]) > float(b["after"]) - float(b["before"]))
	return out.slice(0, ROW_MAX)


static func nights_text(r: Dictionary) -> String:
	var parts: Array = []
	for st in ["pads", "spar"]:
		var days: Array = (r.get(st, []) as Array).duplicate()
		if days.is_empty():
			continue
		days.sort()
		parts.append("%s %s" % [" ".join(days.map(func(d): return DAY_WORDS[int(d)])), st])
	return ", ".join(parts)
