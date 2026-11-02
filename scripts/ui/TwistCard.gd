extends RefCounted
## S356 the week's twist card (WeekTwist) as the player meets it - on the week review (next week's card, drawn there) and
## at the top of the Training tab: the card, and for a choice its two answers with their price; the picked one lit. Until
## Monday runs the answer can change; then it is locked and says so. No answer = the coach's call (marked).

const UI := preload("res://scripts/ui/UI.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const COL_W := 520


static func build(main: Node, f: Dictionary, title: String) -> VBoxContainer:
	var box := UI.vbox(6)
	box.name = "Twist_" + str(f["id"])
	var t := WeekTwist.card_for(f)
	if t.is_empty():
		return box
	var first := str(f.get("first", ""))
	box.add_child(UI.label("%s - %s: %s" % [title, str(t["name"]).to_upper(), t["line"]], UI.BODY, UI.AMBER, "bold", true))
	if not t.has("a"):
		return box
	var locked := bool(f.get("twist_locked", false))
	var picked := str(f.get("twist_pick", ""))
	var shown := WeekTwist.answer(f)
	var row := UI.hbox(10)
	for a in ["a", "b"]:
		var opt: Dictionary = t[a]
		var col := UI.vbox(2)
		col.custom_minimum_size = Vector2(COL_W, 0)   # fixed: an expanding column ran the page off the right edge
		var words := str(opt["label"]) + ("   (coach's call)" if picked == "" and a == shown else "")
		var b := UI.button(words, "ChoiceOn" if a == shown else "Choice", main.act.bind("twistpick", "%s|%s" % [f["id"], a]))
		b.name = "TwistPick_" + a
		b.disabled = locked
		col.add_child(b)
		var said := UI.label(str(opt["line"]), UI.SMALL, UI.FG if a == shown else UI.MUTED, "body", true)
		said.custom_minimum_size = Vector2(COL_W, 0)
		col.add_child(said)
		row.add_child(col)
	box.add_child(row)
	if bool(t.get("ask", false)):   # S361 her ask: what her trust stands at, and what it does
		var mood := FighterProfile.mood(float(f.get("morale", FighterProfile.MORALE_START)))
		var tl := UI.label("%s's mood: %s (morale %d). Mood is trust: in a fight a Flat or Low fighter takes in less of the corner's calls." % [
			first, mood, roundi(float(f.get("morale", FighterProfile.MORALE_START)))], UI.SMALL, UI.MUTED, "body", true)
		tl.name = "AskTrust"
		box.add_child(tl)
	if locked:
		box.add_child(UI.muted("Answered: the week is running.", UI.SMALL))
	return box
