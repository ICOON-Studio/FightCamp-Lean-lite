extends RefCounted
## S398 Week v8: what the two popovers hold (WeekCards.pop frames them, WeekBoard places them beside their card).
## Morning: Light | Normal | Hard on top, then every session and Rest, each with its gain and its tiredness from the same
## WeekPlan.day the week runs. Evening: Rest | Pads | Sparring on top; on a pads night the drill cards to put on it and
## "Take the drill off". Hovering a choice ghosts the week (THIS CAMP's lines) the way the old picker did.
##   morning(i, current, ctx, start, on_pick, ghost) -> VBox   evening(f, i, kind, entries, cards, rows, on_kind, on_drill, on_clear)

const UI := preload("res://scripts/ui/UI.gd")
const WeekCards := preload("res://scripts/ui/WeekCards.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const PadEdit := preload("res://scripts/rules/PadEdit.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")

const LEVELS := ["light", "normal", "hard"]
const LEVEL_WORDS := ["Light", "Normal", "Hard"]


static func morning(i: int, current: Array, ctx: Dictionary, start: float, on_pick: Callable, ghost := Callable(), goal_key := "") -> VBoxContainer:
	var v := UI.vbox(6)
	v.name = "Picker"
	var rest := str(current[0]) == "rest"
	var level := "normal" if rest else str(current[1])
	var gh := Callable()
	if ghost.is_valid():
		gh = func(k: String) -> void: ghost.call(i, [str(current[0]), k] if k != "" and k != level else [])
	v.add_child(WeekCards.segments("Level", LEVEL_WORDS, LEVELS, level, func(k: String): on_pick.call(i, [str(current[0]), k]), gh, rest))
	for s in WeekPhase.SESSIONS + ["rest"]:
		var card: Array = [s, "normal" if s == "rest" else level]
		var r := WeekPlan.day(str(s), str(card[1]), ctx, start)
		var key := str(r["stat"])
		var gain := WeekCards.gain_words(key, float(r["gain"])) if key != "" else "recovers"
		var on: bool = str(current[0]) == str(s)
		var g2 := Callable()
		if ghost.is_valid():
			g2 = func(over: bool) -> void: ghost.call(i, card if over and not on else [])
		v.add_child(WeekCards.pop_row("Pick_%s" % s, key, str(WeekPlan.session(str(s))["name"]), gain,
			WeekCards.tired_words(float(r["load"]) / WeekPlan.LOAD_PER_FATIGUE), on, func(): on_pick.call(i, card), g2, goal_key))
	return v


## kind: the night's kind now; entries: [{card, share}] on it; cards: the tray's drillable cards; rows: PadEdit.night_rows.
static func evening(f: Dictionary, i: int, kind: String, entries: Array, cards: Array, share: float, on_kind: Callable,
		on_drill: Callable, on_clear: Callable) -> VBoxContainer:
	var v := UI.vbox(6)
	v.name = "EvePicker"
	v.add_child(WeekCards.segments("Eve", ["Rest", "Pads", "Sparring"], ["rest", "pads", "sparring"], kind,
		func(k: String): on_kind.call(i, k)))
	var pads := float((WeekPlan.EVENINGS["pads"] as Dictionary)["rpe"]) * float((WeekPlan.EVENINGS["pads"] as Dictionary)["min"]) * share / WeekPlan.LOAD_PER_FATIGUE
	var spar := float((WeekPlan.EVENINGS["sparring"] as Dictionary)["rpe"]) * float((WeekPlan.EVENINGS["sparring"] as Dictionary)["min"]) / WeekPlan.LOAD_PER_FATIGUE
	v.add_child(UI.label("Pads %s  -  Sparring %s  -  Rest recovers" % [WeekCards.tired_words(pads), WeekCards.tired_words(spar)], 13, UI.MUTED, "body"))
	if kind != "pads":
		return v
	v.add_child(UI.caps("DRILL ON THIS NIGHT"))
	var on_now: Array = entries.map(func(e): return str(e["card"]))
	for c in cards:
		var card := str(c)
		if not PadWeek.drillable(f, card):
			continue
		var m := PadWeek.mastery(f, card)
		v.add_child(WeekCards.pop_row("EveDrill_%s" % card.replace(":", "_").replace(" ", "_"), "pads", PadEdit.title(f, card),
			"mastery %d" % roundi(m), "on this night" if on_now.has(card) else "", on_now.has(card), func(): on_drill.call(i, card)))
	if not entries.is_empty():
		var off := UI.button("Take the drill off", "BtnQuiet", func(): on_clear.call(i))
		off.name = "DrillOff"
		v.add_child(off)
	return v
