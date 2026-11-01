extends RefCounted
## S310 the corner minute's other jobs on the card (CornerJobs; plan approved Q-S294-20), the same in 3D and in words:
##   RECOVER  3 points: water / ice on the ribs / clear her head (when hurt) - "+" and "-" per job, points left shown
##   SET-UP   one of her combinations x a gap the corner waits for; no combinations = a line pointing at the pads
##   TALK     calm her / fire her up / the truth
##   PLAN     S339: how her arrows did this round, and ONE change to the coach's plan for the next (PlanFight)
## sel = {rec: {water, ice, head}, setup: {combo, gap}, talk, arrow: {i, move}} is the caller's dict; every change calls
## on_change().
##   menu(f, r) -> {...}   defaults(menu) -> sel   build(menu, sel, names, on_change) -> VBoxContainer   suffix(sel) -> String

const UI := preload("res://scripts/ui/UI.gd")
const CornerJobs := preload("res://scripts/rules/CornerJobs.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")


## What the corner can do after round r (the closed round): her state at the bell and her combinations.
static func menu(f: Dictionary, r: Dictionary) -> Dictionary:
	var exs: Array = r.get("exchanges", [])
	var after: Dictionary = (exs[-1] as Dictionary).get("after", {}) if not exs.is_empty() else {}
	var energy := float(after.get("a", 100.0))
	var body := int((f.get("bout", {}).get("body", {}) as Dictionary).get("a", 0))
	var hurt := bool(r.get("hurt_at_bell", false))
	var opp: Dictionary = f.get("bout", {}).get("opp", {})
	var arrows: Array = (f.get("bout", {}).get("arrows", []) as Array).duplicate(true)
	var limit := int(f.get("bout", {}).get("arrow_limit", PlanBoard.NEW_COACH))
	return {"recover": CornerJobs.recover_options(energy, body, hurt), "energy": energy, "body": body, "hurt": hurt,
		"arrows": arrows, "tally": r.get("arrows", {}), "limit": limit,
		"changes": PlanFight.corner_options(arrows, f.get("moves", {}), limit, PlanFight.fought_cards(exs)),
		"setups": CornerJobs.setups(f.get("combos", {}), Combos.LEARN_AT), "combos": f.get("combos", {}),
		"gaps": CornerJobs.gaps(Exchanges.STYLE_MODES.get(str(opp.get("style", "")), Exchanges.STYLE_MODES["Boxer-puncher"]))}


## The second's own spend when you leave it to him: clear her head if hurt, ice if the ribs took 6+, the rest water.
static func defaults(mn: Dictionary) -> Dictionary:
	var rec := {"water": 0, "ice": 0, "head": 0}
	var left := CornerJobs.RECOVER_POINTS
	if bool(mn["hurt"]):
		rec["head"] = 1
		left -= 1
	if int(mn["body"]) >= 6:
		rec["ice"] = 1
		left -= 1
	rec["water"] = left
	return {"rec": rec, "setup": {}, "talk": "", "arrow": {}}


static func build(mn: Dictionary, sel: Dictionary, names: Array, on_change: Callable) -> VBoxContainer:
	var v := UI.vbox(4)
	# RECOVER
	var rec: Dictionary = sel["rec"]
	var used := int(rec.get("water", 0)) + int(rec.get("ice", 0)) + int(rec.get("head", 0))
	var r_row := UI.hbox(8)
	r_row.add_child(_tag("RECOVER %d/%d" % [used, CornerJobs.RECOVER_POINTS], UI.GREEN))
	for o in mn["recover"]:
		var id := str(o["id"])
		var n := int(rec.get(id, 0))
		var chip := UI.hbox(2)
		var minus := UI.button("-", "BtnQuiet", func():
			rec[id] = maxi(0, int(rec.get(id, 0)) - 1)
			on_change.call(), n == 0)
		minus.name = "Rec_minus_" + id
		chip.add_child(minus)
		chip.add_child(UI.label("%s %d" % [str(o["label"]), n], UI.SMALL, UI.FG if n > 0 else UI.MUTED))
		var plus := UI.button("+", "BtnQuiet", func():
			rec[id] = int(rec.get(id, 0)) + 1
			on_change.call(), used >= CornerJobs.RECOVER_POINTS or n >= int(o["max"]))
		plus.name = "Rec_plus_" + id
		chip.add_child(plus)
		chip.tooltip_text = str(o["line"])
		r_row.add_child(chip)
	v.add_child(r_row)
	# SET-UP
	var s_row := UI.hbox(6)
	s_row.add_child(_tag("SET-UP", UI.AMBER))
	var setups: Array = mn["setups"]
	if setups.is_empty():
		s_row.add_child(UI.muted("%s has no combination yet - drill one on the pads in the gym to set it up here." % names[0], UI.SMALL))
	else:
		var su: Dictionary = sel["setup"]
		for k in setups.slice(0, 3):
			var on := str(su.get("combo", "")) == str(k)
			var b := UI.button(_words(str(k)), "ChoiceOn" if on else "Choice", func():
				if on:
					sel["setup"] = {}
				else:
					sel["setup"] = {"combo": str(k), "gap": str(su.get("gap", mn["gaps"][0]))}
				on_change.call())
			b.name = "Setup_" + str(k)
			b.tooltip_text = "Mastery %d" % int(float(mn["combos"].get(k, 0.0)))
			s_row.add_child(b)
		if not su.is_empty():
			s_row.add_child(UI.muted("for", UI.SMALL))
			for g in mn["gaps"]:
				var gon := str(su.get("gap", "")) == str(g)
				var gb := UI.button(str(CornerJobs.GAP_WORDS.get(g, g)).replace("she", names[1]), "ChoiceOn" if gon else "Choice", func():
					su["gap"] = str(g)
					on_change.call())
				gb.name = "Gap_" + str(g)
				s_row.add_child(gb)
	v.add_child(s_row)
	# TALK
	var t_row := UI.hbox(6)
	t_row.add_child(_tag("TALK", UI.AMBER))
	for k in CornerJobs.TALKS.keys():
		var on := str(sel.get("talk", "")) == str(k)
		var tb := UI.button(str(CornerJobs.TALKS[k]["label"]), "ChoiceOn" if on else "Choice", func():
			sel["talk"] = "" if on else str(k)
			on_change.call())
		tb.name = "Talk_" + str(k)
		t_row.add_child(tb)
	v.add_child(t_row)
	v.add_child(_plan_row(mn, sel, names, on_change))
	return v


## S339 PLAN: the round's arrows that worked, and one change for the next round (or "Keep the plan").
static func _plan_row(mn: Dictionary, sel: Dictionary, names: Array, on_change: Callable) -> VBoxContainer:
	var box := UI.vbox(2)
	var p_row := UI.hbox(6)
	p_row.add_child(_tag("PLAN", UI.GREEN))
	var t: Dictionary = mn.get("tally", {})
	var arrows: Array = mn.get("arrows", [])
	if arrows.is_empty():
		p_row.add_child(UI.muted("No plan: %s fights her own way. Add one arrow:" % names[0], UI.SMALL))
	else:
		p_row.add_child(UI.muted("%d of %d arrows worked. Change one:" % [int(t.get("worked", 0)), int(t.get("used", 0))], UI.SMALL))
	var changes: Array = mn.get("changes", [])
	var ob := OptionButton.new()
	ob.name = "PlanChange"
	ob.add_item("Keep the plan" if not arrows.is_empty() else "No arrow")
	var pick := 0
	var cur: Dictionary = sel.get("arrow", {})
	for k in changes.size():
		var o: Dictionary = changes[k]
		ob.add_item(change_words(o))
		if not cur.is_empty() and int(cur["i"]) == int(o["i"]) and str(cur["move"]) == str(o["move"]):
			pick = k + 1
	ob.select(pick)
	ob.disabled = changes.is_empty()
	ob.item_selected.connect(func(k):
		sel["arrow"] = {} if k == 0 else {"i": int(changes[k - 1]["i"]), "move": str(changes[k - 1]["move"])}
		on_change.call())
	p_row.add_child(ob)
	box.add_child(p_row)
	var per := PackedStringArray()
	for id in (t.get("moves", {}) as Dictionary).keys():
		var wu: Array = t["moves"][id]
		per.append("%s %d/%d" % [str(StrikeMap.move(str(id)).get("name", id)), int(wu[0]), int(wu[1])])
	if not per.is_empty():
		box.add_child(UI.muted("    " + ",  ".join(per), UI.TINY))
	return box


## "Mid range: Step back -> Slip, cross, check hook" / "Inside: + Tie up".
static func change_words(o: Dictionary) -> String:
	var card := str(StrikeMap.card(str(o["from"])).get("name", o["from"]))
	var to := str(StrikeMap.move(str(o["move"])).get("name", o["move"]))
	if str(o.get("was", "")) == "":
		return "%s: + %s" % [card, to]
	return "%s: %s -> %s" % [card, str(StrikeMap.move(str(o["was"])).get("name", o["was"])), to]


## The corner action's job parts for Bouts.corner_jobs.
static func suffix(sel: Dictionary) -> String:
	var out := ""
	var su: Dictionary = sel.get("setup", {})
	if not su.is_empty():
		out += "|setup=%s@%s" % [su["combo"], su["gap"]]
	if str(sel.get("talk", "")) != "":
		out += "|talk=" + str(sel["talk"])
	var ar: Dictionary = sel.get("arrow", {})
	if not ar.is_empty():
		out += "|arrow=%d:%s" % [int(ar["i"]), str(ar["move"])]
	var rec: Dictionary = sel.get("rec", {})
	var parts: Array = []
	for k in ["water", "ice", "head"]:
		if int(rec.get(k, 0)) > 0:
			parts.append("%s:%d" % [k, int(rec[k])])
	if not parts.is_empty():
		out += "|rec=" + ",".join(PackedStringArray(parts))
	return out


static func _words(id: String) -> String:
	return "-".join(PackedStringArray((Combos.row(id).get("moves", [id]) as Array).map(func(x): return str(x))))


static func _tag(text: String, color: Color) -> Label:
	var t := UI.caps(text)
	t.custom_minimum_size = Vector2(120, 0)
	t.add_theme_color_override("font_color", color)
	return t
