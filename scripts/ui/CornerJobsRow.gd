extends RefCounted
## S310 the corner minute's other jobs on the card (CornerJobs; plan approved Q-S294-20), the same in 3D and in words:
##   RECOVER  3 points: water / ice on the ribs / clear her head (when hurt) - "+" and "-" per job, points left shown
##   SET-UP   one of her combinations x a gap the corner waits for; no combinations = a line pointing at the pads
##   TALK     calm her / fire her up / the truth
## sel = {rec: {water, ice, head}, setup: {combo, gap}, talk} is the caller's dict; every change calls on_change().
##   menu(f, r) -> {...}   defaults(menu) -> sel   build(menu, sel, names, on_change) -> VBoxContainer   suffix(sel) -> String

const UI := preload("res://scripts/ui/UI.gd")
const CornerJobs := preload("res://scripts/rules/CornerJobs.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")


## What the corner can do after round r (the closed round): her state at the bell and her combinations.
static func menu(f: Dictionary, r: Dictionary) -> Dictionary:
	var exs: Array = r.get("exchanges", [])
	var after: Dictionary = (exs[-1] as Dictionary).get("after", {}) if not exs.is_empty() else {}
	var energy := float(after.get("a", 100.0))
	var body := int((f.get("bout", {}).get("body", {}) as Dictionary).get("a", 0))
	var hurt := bool(r.get("hurt_at_bell", false))
	var opp: Dictionary = f.get("bout", {}).get("opp", {})
	return {"recover": CornerJobs.recover_options(energy, body, hurt), "energy": energy, "body": body, "hurt": hurt,
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
	return {"rec": rec, "setup": {}, "talk": ""}


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
	return v


## The corner action's job parts for Bouts.corner_jobs.
static func suffix(sel: Dictionary) -> String:
	var out := ""
	var su: Dictionary = sel.get("setup", {})
	if not su.is_empty():
		out += "|setup=%s@%s" % [su["combo"], su["gap"]]
	if str(sel.get("talk", "")) != "":
		out += "|talk=" + str(sel["talk"])
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
