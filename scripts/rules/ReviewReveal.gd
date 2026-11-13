extends RefCounted
## S361 the week review as a reveal (Q-S294-86 "Yes, build them", Miro top-5 card 3; verdict Game/Godot/research/MIRO_TOP5_S357.md).
## The rows land one at a time and the week's biggest surprise lands LAST, alone, in big type: the payoff waits for the
## end, as a pack opening or a scoreboard count-up holds its best card back. This module only picks that surprise and
## its timing; WeekReview.gd draws it.
## Order (most game-changing first): a new injury (it changes the next weeks) > a new weapon (a move she can now use in a
## bout) > a peak camp > a ranking won or climbed > the biggest stat that ticked a whole point. A quiet week has none.

## Seconds between two rows landing; a two-fighter week goes a little faster so the whole review stays near 5 s.
const STEP := 0.12
const STEP_TWO := 0.08
## The pause before the headline (the beat that makes it land), and how long a row takes to fade in.
const HOLD := 0.45
const FADE := 0.25


## {kind, text}: kind is "injury", "weapon", "peak", "rank", "stat" or "" (a quiet week, no headline). `fr` is one
## fighter's report from Sim.end_week ({name, rows, new_weapon, rank_before, rank_after, div, peak, injury}).
static func headline(fr: Dictionary, labels: Dictionary) -> Dictionary:
	if str(fr.get("injury", "")) != "":
		return {"kind": "injury", "text": "Hurt: %s." % str(fr["injury"])}   # S448: the section's header has the name
	if str(fr.get("new_weapon", "")) != "":
		return {"kind": "weapon", "text": "NEW WEAPON: the %s." % str(fr["new_weapon"]).to_lower()}
	if str(fr.get("peak", "")).begins_with("Peak"):
		return {"kind": "peak", "text": str(fr["peak"])}
	var rb := int(fr.get("rank_before", 0))
	var ra := int(fr.get("rank_after", 0))
	if ra > 0 and (rb == 0 or ra < rb):
		return {"kind": "rank", "text": "Ranked %d in the %s rankings%s." % [ra, str(fr.get("div", "")),
			", a first ranking" if rb == 0 else " (up from %d)" % rb]}
	var best := ""
	var gain := 0.0
	for x in fr.get("rows", []):
		var before := float(x["before"])
		var after := float(x["after"])
		if floorf(after) > floorf(before) and after - before > gain:
			gain = after - before
			best = str(x["st"])
	if best != "":
		var row: Dictionary = (fr["rows"] as Array).filter(func(x): return str(x["st"]) == best)[0]
		return {"kind": "stat", "text": "%s up to %d." % [str(labels.get(best, best)), int(floorf(float(row["after"])))]}
	return {"kind": "", "text": ""}


## S363 the no-gi athlete's surprise (Grapplers.week_report row): a medal > a move that became a weapon > a stripe due.
static func grappler_headline(gr: Dictionary, move_name: String) -> Dictionary:
	var o: Dictionary = gr.get("open", {})
	if str(o.get("medal", "")) != "":
		return {"kind": "medal", "text": "%s at the %s." % [str(o["medal"]).to_upper(), str(o["name"])]}
	if bool(gr.get("owned", false)):
		return {"kind": "weapon", "text": "NEW WEAPON: the %s." % move_name.to_lower()}
	if int(gr.get("due", 0)) > 0 and int(gr.get("held", 0)) != int(gr.get("stripes", 0)) + 1:
		return {"kind": "stripe", "text": "Stripe %d is due: your call." % (int(gr.get("stripes", 0)) + 1)}
	return {"kind": "", "text": ""}
