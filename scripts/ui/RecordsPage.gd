extends RefCounted
## S388 GYM > Records: the gym's own history (rules/Records.gd), newest first, with two rows of filters: who and what.

const NameLinks := preload("res://scripts/ui/NameLinks.gd")
const UI := preload("res://scripts/ui/UI.gd")
const Records := preload("res://scripts/rules/Records.gd")

const TAB := "4"
const SHOWN := 300
const DATE_W := 130.0
const CHIP := {"Honours": "gold", "Fights": "", "Training": "green", "Health": "amber", "People": "", "Money": "green", "Gym": ""}

static var who := ""
static var kind := ""


static func build(main: Node, c: Career) -> Control:
	var card := UI.card("RECORDS")
	var v: VBoxContainer = card[1]
	var people := _people(c)
	if not people.any(func(p): return p[1] == who):
		who = ""
	v.add_child(_filter("WHO", "WhoFilter", people, who, func(id): who = id, main))
	var kinds: Array = [["All", ""]]
	for k in Records.KINDS:
		kinds.append([k, k])
	v.add_child(_filter("WHAT", "WhatFilter", kinds, kind, func(id): kind = id, main))
	var all := Records.rows(c)
	var rows := Records.pick(all, who, kind)
	var count := UI.muted("%d of %d events" % [rows.size(), all.size()], UI.SMALL)
	count.name = "RecordsCount"
	v.add_child(count)
	var list := UI.vbox(6)
	list.name = "RecordsList"
	v.add_child(list)
	if rows.is_empty():
		list.add_child(UI.muted("Nothing here yet.", UI.BODY))
	for r in rows.slice(0, SHOWN):
		list.add_child(_row(r, main, c))
	if rows.size() > SHOWN:
		v.add_child(UI.muted("Showing the newest %d. Use the filters to reach older events." % SHOWN, UI.SMALL))
	return card[0]


## [label, id] for the WHO row: everyone in the gym, then the coach and the gym.
static func _people(c: Career) -> Array:
	var out: Array = [["All", ""]]
	for f in c.fighters + c.grapplers:
		out.append([str(f["first"]), str(f["id"])])
	if not c.coach.is_empty():
		out.append(["Coach", Records.COACH])
	out.append(["Gym", Records.GYM])
	return out


static func _filter(head: String, name: String, items: Array, on: String, set_to: Callable, main: Node) -> Control:
	var h := UI.hbox(6)
	h.name = name
	var cap := UI.caps(head)
	cap.custom_minimum_size = Vector2(70, 0)
	cap.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(cap)
	for it in items:
		var id := str(it[1])
		h.add_child(UI.button(str(it[0]), "TabOn" if id == on else "Tab", func():
			set_to.call(id)
			main.act("tab", TAB)))
	return h


static func _row(r: Dictionary, main: Node, c: Career) -> Control:
	var h := UI.hbox(12)
	var date := UI.muted(Clock.fmt(int(r["d"])), UI.SMALL)
	date.custom_minimum_size = Vector2(DATE_W, 0)
	h.add_child(date)
	var chip := UI.chip(str(r["kind"]), str(CHIP.get(str(r["kind"]), "")))
	chip.custom_minimum_size = Vector2(96, 0)
	chip.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	h.add_child(chip)
	h.add_child(NameLinks.label(main, c, str(r["t"])))   # S396 every name is a link
	return h
