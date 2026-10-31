extends RefCounted
## S330 (MENULOOK1, after the operator's C150 "can be improved" on a page of rows): one fighter as a picture, for HOME and
## FIGHTERS > Roster - her name and record big, rank and mood as chips, then four rings: weight to her limit, condition,
## her goal, and the days to her next bout (red when she is out injured); her season line under them.

const UI := preload("res://scripts/ui/UI.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const NeedRing := preload("res://scripts/ui/NeedRing.gd")

## A bout this many days out shows an empty countdown ring; the ring fills as the day comes.
const COUNTDOWN_DAYS := 42


static func build(main: Node, c: Career, f: Dictionary) -> PanelContainer:
	var p := PanelContainer.new()
	p.theme_type_variation = "Card"
	p.name = "Tile_" + str(f["id"])
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var v := UI.vbox(10)
	p.add_child(v)
	var top := UI.hbox(12)
	var name := UI.button(f["name"], "Link", main.act.bind("fighter", f["id"]))
	name.add_theme_font_size_override("font_size", UI.BODY + 5)
	top.add_child(name)
	var pro := bool(f.get("pro", false))
	var record := "%d-%d PRO" % [int(f.get("pro_w", 0)), int(f.get("pro_l", 0))] if pro else "%d-%d AM" % [f["w"], f["l"]]
	top.add_child(UI.display(record, 34, UI.GOLD))
	top.add_child(UI.spacer())
	if int(f.get("rank", 0)) > 0:
		top.add_child(UI.chip("NUMBER %d" % int(f["rank"]), "gold"))
	var mood := UI.chip(mood_word(f).to_upper(), mood_colour(f))
	mood.name = "Mood_" + str(f["id"])
	mood.tooltip_text = str(f.get("mood_reason", ""))
	mood.mouse_filter = Control.MOUSE_FILTER_STOP
	top.add_child(mood)
	v.add_child(top)
	v.add_child(UI.muted("%s, %d, %s" % [f["wc"], int(f.get("age", 21)), f["stance"]], UI.SMALL))
	var rings := UI.hbox(10)
	rings.name = "Rings"
	var w := float(f["weight"])
	var lim := float(f["limit"])
	var over := w - lim
	rings.add_child(_ring("WEIGHT", "%.1f" % w, "limit %.1f kg" % lim if over <= 0.0 else "%.1f kg over" % over,
		1.0 if over <= 0.0 else clampf(1.0 - over / 3.0, 0.1, 0.95), UI.GREEN if over <= 0.0 else (UI.AMBER if over < 1.5 else UI.RED)))
	var fat := int(f["fatigue"])
	rings.add_child(_ring("CONDITION", "%d" % (100 - fat), "fresh" if fat < 30 else ("tired" if fat < 60 else "worn out"),
		(100.0 - fat) / 100.0, UI.GREEN if fat < 30 else (UI.AMBER if fat < 60 else UI.RED)))
	var g := Sim.goal_read(c, f)
	if g.is_empty():
		rings.add_child(_ring("GOAL", "-", "talk in the office" if bool(f.get("goal_talk", false)) else "none set", 0.0, UI.MUTED))
	else:
		var gc := {"green": UI.GREEN, "amber": UI.AMBER, "red": UI.RED}
		rings.add_child(_ring("GOAL", "%dd" % int(g["left"]), str(g["title"]), float(g["share"]), gc.get(str(g["cls"]), UI.MUTED)))
	var fb: Dictionary = f["bout"]
	if Injuries.out(c, f):
		rings.add_child(_ring("NEXT BOUT", "OUT", Injuries.line(c, f), 0.0, UI.RED))
	elif fb.is_empty():
		rings.add_child(_ring("NEXT BOUT", "-", "none booked", 0.0, UI.MUTED))
	else:
		var days := int(fb["day"]) - c.day
		rings.add_child(_ring("NEXT BOUT", "%dd" % days if days > 0 else "TODAY", "%s vs %s" % [Clock.fmt(int(fb["day"])), fb["opp"]["name"]],
			clampf(1.0 - float(days) / COUNTDOWN_DAYS, 0.05, 1.0), UI.GOLD))
	v.add_child(rings)
	var season := Champs.home_line(c, f)
	if season != "":
		var sl := UI.label(season, UI.SMALL, UI.GOLD if Champs.active(f) else UI.FG)
		sl.name = "Season_" + str(f["id"])
		sl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		v.add_child(sl)
	return p


static func mood_word(f: Dictionary) -> String:
	return FighterProfile.mood(float(f.get("morale", FighterProfile.MORALE_START)))


## The chip colour of her mood word (the roster's colours: Steady is plain).
static func mood_colour(f: Dictionary) -> String:
	return {"Fired up": "green", "Steady": "", "Flat": "amber", "Low": "red"}.get(mood_word(f), "")


static func _ring(head: String, big: String, sub: String, value: float, col: Color) -> Control:
	var box := UI.hbox(8)
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ring := NeedRing.new()
	ring.custom_minimum_size = Vector2(70, 70)
	ring.value = value
	ring.goal = 1.0
	ring.big = big
	ring.colour = col
	box.add_child(ring)
	var t := UI.vbox(2)
	t.alignment = BoxContainer.ALIGNMENT_CENTER
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	t.add_child(UI.caps(head))
	t.add_child(UI.label(sub, UI.SMALL, col if col != UI.MUTED else UI.FG, "bold", true))
	box.add_child(t)
	return box
