extends RefCounted
## S396 truth pass (P15; mock-up docs/STRUCTURE_MOCKUPS_S395.html#handbook): every game word in one place, searchable, in
## groups, each with "Show me" to the screen where you meet it. The words live in an open file (P16):
## assets/data/handbook.json [{id, name, def, why, group, area, src}]; without it, the Glossary's terms.

const UI := preload("res://scripts/ui/UI.gd")
const Glossary := preload("res://scripts/rules/Glossary.gd")

const PATH := "res://assets/data/handbook.json"
const GROUPS := ["All", "Words", "The week", "The plan", "Fight night", "Money"]
const AREA_NAMES := {"home": "Home", "fighters": "Fighters", "fights": "Fights", "club": "Club", "world": "World"}


static func terms() -> Array:
	var out: Array = []
	if FileAccess.file_exists(PATH):
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(PATH))
		if parsed is Array:
			out = (parsed as Array).filter(func(t): return t is Dictionary and str(t.get("name", "")) != "")
	if out.is_empty():
		for id in Glossary.TERMS:
			var t: Dictionary = (Glossary.TERMS[id] as Dictionary).duplicate()
			t["id"] = id
			t["group"] = "Words"
			out.append(t)
	# S396 blind review ("Belt comes first in a boxing game"): by group in the game's order, then by name.
	out.sort_custom(func(a, b):
		var ga := GROUPS.find(str(a.get("group", "Words")))
		var gb := GROUPS.find(str(b.get("group", "Words")))
		return ga < gb if ga != gb else str(a["name"]).naturalnocasecmp_to(str(b["name"])) < 0)
	return out


## The terms matching a search word (name or definition) and a group ("All" = every group).
static func find(all: Array, word: String, group: String) -> Array:
	var w := word.strip_edges().to_lower()
	return all.filter(func(t): return (group == "All" or str(t.get("group", "")) == group) and (w == ""
		or str(t["name"]).to_lower().contains(w) or str(t.get("def", "")).to_lower().contains(w)))


static func build(main: Node) -> VBoxContainer:
	var all := terms()
	var v := UI.vbox(10)
	v.name = "HandbookPanel"
	var state := {"word": "", "group": "All"}
	var search := LineEdit.new()
	search.name = "Search"
	search.placeholder_text = "Search a word"
	search.custom_minimum_size = Vector2(0, 40)
	v.add_child(search)
	var tabs := UI.hbox(6)
	v.add_child(tabs)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(860, 460)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	v.add_child(scroll)
	var list := UI.vbox(12)
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(list)
	var group_buttons: Array = []
	var redraw := func():
		for b in group_buttons:
			(b as Button).theme_type_variation = "BtnSolid" if (b as Button).text == str(state["group"]) else "Btn"
		UI.clear(list)
		var shown := find(all, str(state["word"]), str(state["group"]))
		if shown.is_empty():
			list.add_child(UI.label("No word matches.", UI.BODY, UI.MUTED))
		for t in shown:
			list.add_child(_entry(main, t))
	for g in GROUPS:
		var b := UI.button(str(g), "Btn", func(): state["group"] = g; redraw.call())
		b.name = "Group_" + str(g).replace(" ", "_")
		tabs.add_child(b)
		group_buttons.append(b)
	search.text_changed.connect(func(s): state["word"] = s; redraw.call())
	redraw.call()
	v.add_child(UI.label("Every word here is also the hover text on the screen where you meet it.", UI.SMALL, UI.MUTED))
	return v


static func _entry(main: Node, t: Dictionary) -> Control:
	var h := UI.hbox(14)
	var col := UI.vbox(2)
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var name_row := UI.hbox(8)
	name_row.add_child(UI.label(str(t["name"]), UI.BODY, UI.FG, "bold"))
	var def := UI.label(str(t.get("def", "")), UI.BODY, UI.FG, "body", true)
	def.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_row.add_child(def)
	col.add_child(name_row)
	if str(t.get("why", "")) != "":
		col.add_child(UI.label(str(t["why"]), UI.SMALL, UI.MUTED, "body", true))
	h.add_child(col)
	var area := str(t.get("area", ""))
	if AREA_NAMES.has(area):
		var b := UI.button("%s ›" % AREA_NAMES[area], "Link", func(): main.close_modal(); main.nav({"area": area, "tab": 0}))   # S397: a quiet link, not a button per row
		b.custom_minimum_size = Vector2(150, 0)   # one width, so the column lines up
		b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(b)
	return h
