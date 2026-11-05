extends RefCounted
## S387 MENUREVIEW1: the week review's read rows (WeekRead): each stat with its cause or its next point, and the GOAL, RANK
## and RUNWAY lines. Rows only: WeekReview lands them and grows their bars (meta "bar", "to").

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")
const WeekRead := preload("res://scripts/rules/WeekRead.gd")

const HEAD_W := 86.0
const WORD_W := 92.0
const CHIPS := {"met": "gold", "on_pace": "green", "tight": "amber", "behind": "red", "missed": "red",
	"up": "green", "first": "green", "down": "amber", "out": "amber", "same": "", "none": "",
	"ok": "green", "warn": "amber", "red": "red", "closed": "red"}
const RANK_WORDS := {"up": "UP", "first": "NEW", "down": "DOWN", "out": "OUT", "same": "HELD", "none": "NONE"}


## One stat: name | bar to the next point | whole number, and its read beside the bar (under it when two fighters share the
## width). Meta: "bar", "to" (the bar's end), "tick" (crossed a point).
static func stat(x: Dictionary, two_up: bool) -> Control:
	var before := float(x["before"])
	var after := float(x["after"])
	var rd: Dictionary = x.get("read", WeekRead.stat(x, [], str(Data.LABEL[x["st"]])))   # a report saved before S387
	var tick := bool(rd["tick"])
	var moved := after - before >= 0.005
	var suffix := " +%d" % int(rd["gain"]) if tick else (" %d%%" % int(TrainingPreview.progress_to_next(after) * 100.0) if moved else "")
	var row := UI.stat_row(Data.LABEL[x["st"]], after, tick, UI.GOLD if tick else UI.FG, suffix)
	var bar: Control = row.get_meta("bar")
	bar.frac = 0.0 if tick else TrainingPreview.progress_to_next(before)
	var text := str(rd["text"])
	if not tick and moved and str(rd["why"]) != "":
		text += ": " + str(rd["why"])
	var why := UI.label(text, UI.TINY if two_up else UI.SMALL, UI.GOLD if tick else (UI.FG if moved else UI.MUTED), "body", two_up)
	why.name = "Why_%s" % str(x["st"])
	var cell: Control
	if two_up:
		cell = UI.vbox(0)
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cell.add_child(row)
		cell.add_child(why)
	else:
		cell = row
		why.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cell.add_child(why)
	cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cell.set_meta("bar", bar)
	cell.set_meta("to", TrainingPreview.progress_to_next(after))
	cell.set_meta("tick", tick)
	return cell


## GOAL | ON PACE | the climb so far | the title, how far ahead or behind, the days left.
static func goal(id: String, g: Dictionary) -> Control:
	var state := str(g["state"])
	var text := "%s. %s" % [str(g["title"]), str(g["text"])]
	return _line("Goal_" + id, "GOAL", str(g["word"]), str(CHIPS[state]), text, float(g["was"]), float(g["share"]))


## RANK | UP | the move, in the division's rankings.
static func rank(id: String, rk: Dictionary) -> Control:
	var kind := str(rk["kind"])
	return _line("Rank_" + id, "RANK", str(RANK_WORDS[kind]), str(CHIPS[kind]), str(rk["text"]), -1.0, -1.0)


## RUNWAY | SAFE | the weeks of cash left | the weekly balance against the close rule.
static func runway(rw: Dictionary) -> Control:
	var state := str(rw["state"])
	return _line("Runway", "RUNWAY", str(rw["word"]), str(CHIPS[state]), str(rw["text"]), 0.0, float(rw["frac"]))


## A read row. A `to` below 0 draws no bar, and the text takes its place.
static func _line(id: String, head: String, word: String, colour: String, text: String, from: float, to: float) -> Control:
	var h := UI.hbox(12)
	h.name = id
	var cap := UI.caps(head)
	cap.custom_minimum_size = Vector2(HEAD_W, 0)
	h.add_child(cap)
	var slot := UI.hbox(0)
	slot.custom_minimum_size = Vector2(WORD_W, 0)
	slot.add_child(UI.chip(word, colour))
	h.add_child(slot)
	if to >= 0.0:
		var bar := UI.meter(from, {"green": UI.GREEN, "amber": UI.AMBER, "red": UI.RED, "gold": UI.GOLD}.get(colour, UI.GREEN), [], 120.0)
		h.add_child(bar)
		h.set_meta("bar", bar)
		h.set_meta("to", to)
	var l := UI.label(text, UI.SMALL, UI.FG, "body", true)
	l.name = id + "_text"
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(l)
	return h
