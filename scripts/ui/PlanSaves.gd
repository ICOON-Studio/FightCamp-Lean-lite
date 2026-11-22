extends RefCounted
## S538 PLANFLOW2 (owner Q-S294-301: "yes add those"): SAVE the plan on the chart under a name, LOAD a saved plan onto a
## boxer. The plans are kept with the career (Career.saved_plans, rows {name, arrows, by, day}; the main bet rides on its
## arrow, PlanBet), so every boxer of the gym can load one. A load keeps only the lines THAT boxer can fire (the moves
## learned, drilled to Usable, as many as the coach holds) and says which were dropped and why.
##   save(c, name, arrows, f) -> {ok, why, name}   remove(c, name)   fit(plan, f, limit) -> {arrows, dropped: [{move, name, why}]}
##   load_onto(gp, plan) -> String (what happened)   button(gp)   mount(gp)

const UI := preload("res://scripts/ui/UI.gd")
const SM := preload("res://scripts/rules/StrikeMap.gd")
const FireLevel := preload("res://scripts/rules/FireLevel.gd")
const PlanBet := preload("res://scripts/ui/PlanBet.gd")

const MAX := 12        # plans a gym keeps: the list stays one screen
const NAME_MAX := 28

static var open := false   # the Save / Load list is showing
static var said := ""      # what the last save or load did, shown in the list


## Keeps `arrows` under `name` (the same name is replaced). An empty name becomes "Plan N".
static func save(c: Career, name: String, arrows: Array, f: Dictionary) -> Dictionary:
	if arrows.is_empty():
		return {"ok": false, "why": "There is no line on the chart to save.", "name": ""}
	var nm := name.strip_edges().left(NAME_MAX)
	if nm == "":
		nm = "Plan %d" % (c.saved_plans.size() + 1)
	var row := {"name": nm, "arrows": PlanBet.stamp(arrows.duplicate(true), f.duplicate()), "by": str(f.get("first", "")), "day": c.day}
	for i in c.saved_plans.size():
		if str(c.saved_plans[i]["name"]) == nm:
			c.saved_plans[i] = row
			return {"ok": true, "why": "", "name": nm}
	if c.saved_plans.size() >= MAX:
		return {"ok": false, "why": "The gym keeps %d plans: delete one first." % MAX, "name": nm}
	c.saved_plans.append(row)
	return {"ok": true, "why": "", "name": nm}


static func remove(c: Career, name: String) -> void:
	c.saved_plans = c.saved_plans.filter(func(p): return str(p["name"]) != name)


## The saved plan as this boxer can fight it: its lines in order, each kept only when the boxer can fire it.
static func fit(plan: Dictionary, f: Dictionary, limit: int) -> Dictionary:
	var kept: Array = []
	var dropped: Array = []
	for a in plan.get("arrows", []):
		var id := str((a as Dictionary).get("move", ""))
		var row := SM.move(id)
		var why := ""
		if row.is_empty():
			why = "no longer on the move map"
		elif SM.grey_reason(row, f.get("moves", {})) != "":
			why = SM.grey_reason(row, f.get("moves", {})).to_lower()
		elif FireLevel.mastery_of(f, id) < FireLevel.USABLE_AT:
			why = "still learning it: pad work first"
		elif kept.size() >= limit:
			why = "this coach holds %d %s, and it is full" % [limit, "line" if limit == 1 else "lines"]
		if why == "":
			kept.append((a as Dictionary).duplicate(true))
		else:
			dropped.append({"move": id, "name": str(row.get("name", id)), "why": why})
	return {"arrows": kept, "dropped": dropped}


static func _dropped_words(dropped: Array) -> String:
	return "; ".join(PackedStringArray(dropped.map(func(d): return "%s (%s)" % [d["name"], d["why"]])))


## Puts a saved plan on the chart's boxer (through GamePlan._write, the one way a plan is saved) with its main bet.
static func load_onto(gp, plan: Dictionary) -> String:
	var r := fit(plan, gp.f, gp._limit())
	var kept: Array = r["arrows"]
	var total := (plan.get("arrows", []) as Array).size()
	if kept.is_empty():
		return "Nothing loaded from \"%s\": this boxer cannot fire any of its lines yet. %s." % [plan["name"], _dropped_words(r["dropped"])]
	gp.f.erase(PlanBet.KEY)
	for a in kept:
		if bool(a.get("bet", false)):
			gp.f[PlanBet.KEY] = PlanBet.key_of(a)
	gp._write(kept)
	var out := "Loaded \"%s\": %d of %d lines." % [plan["name"], kept.size(), total]
	if not (r["dropped"] as Array).is_empty():
		out += " Dropped: %s." % _dropped_words(r["dropped"])
	return out


## The button in the chart's top row.
static func button(gp) -> Control:
	var b := UI.button("Save / Load", "PillOn" if open else "Btn", func():
		open = not open
		said = ""
		gp._refresh())
	b.name = "SavesBtn"
	b.tooltip_text = "Keep this plan under a name, or put a kept plan on this boxer. A load brings only the lines this boxer can fire."
	return b


## The list under the top row, when open: name + Save, then every kept plan with Load and Delete.
static func mount(gp) -> void:
	if not open or gp.main == null or gp.main.get("career") == null:
		return
	var c: Career = gp.main.career
	var card := PanelContainer.new()
	card.name = "PlanSaves"
	card.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.GOLD, 10, 1, 16, 12))
	var v := UI.vbox(8)
	card.add_child(v)
	v.add_child(UI.caps("SAVED PLANS: KEPT WITH THE GYM, ANY BOXER CAN LOAD ONE"))
	var top := UI.hbox(8)
	var edit := LineEdit.new()
	edit.name = "SaveName"
	edit.placeholder_text = "Name this plan"
	edit.max_length = NAME_MAX
	edit.custom_minimum_size = Vector2(320, 0)
	edit.tooltip_text = "The name the plan is kept under. Saving again under the same name replaces the old one."
	top.add_child(edit)
	var sb := UI.button("Save this plan", "BtnSolid", func():
		var res := save(c, edit.text, gp.arrows, gp.f)
		said = ("Saved as \"%s\": %d lines." % [res["name"], gp.arrows.size()]) if bool(res["ok"]) else str(res["why"])
		gp._refresh(), gp.arrows.is_empty(), "There is no line on the chart to save.")
	sb.name = "SaveNow"
	if not sb.disabled:
		sb.tooltip_text = "Keeps the lines on the chart and the main bet with the gym, so this boxer or another can load them before a later bout."
	top.add_child(sb)
	v.add_child(top)
	if said != "":
		var sl := UI.label(said, UI.SMALL, UI.FG, "semi", true)
		sl.name = "SavesSaid"
		v.add_child(sl)
	if c.saved_plans.is_empty():
		v.add_child(UI.muted("Nothing saved yet.", UI.SMALL))
	for p in c.saved_plans:
		var plan: Dictionary = p
		var r := fit(plan, gp.f, gp._limit())
		var total := (plan["arrows"] as Array).size()
		var ready := (r["arrows"] as Array).size()
		var row := UI.hbox(10)
		row.name = "Saved_" + str(plan["name"]).validate_node_name().replace(" ", "_")
		var words := UI.vbox(0)
		words.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		words.add_child(UI.label(str(plan["name"]), UI.SMALL, UI.FG, "bold"))
		var fits := "every line is ready for this boxer" if ready == total else "%d of %d ready for this boxer" % [ready, total]
		words.add_child(UI.muted("%d %s, written for %s: %s" % [total, "line" if total == 1 else "lines", plan["by"], fits], UI.TINY, true))
		row.add_child(words)
		var lb := UI.button("Load", "Btn", func():
			said = load_onto(gp, plan)
			gp._refresh(), ready == 0, "This boxer cannot fire any of its lines yet: %s." % _dropped_words(r["dropped"]))
		lb.name = "Load"
		if not lb.disabled:
			lb.tooltip_text = "Replaces the plan on the chart. Every line of it is ready for this boxer." if ready == total else \
				"Replaces the plan on the chart with the %d ready lines. Left out: %s." % [ready, _dropped_words(r["dropped"])]
		row.add_child(lb)
		var del := UI.button("Delete", "BtnQuiet", func():
			remove(c, str(plan["name"]))
			said = "Deleted \"%s\"." % plan["name"]
			gp._refresh())
		del.name = "Delete"
		del.tooltip_text = "Takes it off the gym's list for good. The plan on the chart is not touched."
		row.add_child(del)
		v.add_child(row)
	gp.add_child(card)
