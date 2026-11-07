extends RefCounted
## S396 Steam release (docs/STEAM_RELEASE_PLAN.md section 2): the credits every shipped licence asks for - the CC BY gloves,
## the CMU credit line, Lucide (ISC), the OFL and Apache fonts, the MIT addons and the Godot Engine's own licence text.
## The lines live in an open file: assets/data/credits.json {sections: [{title, lines, engine_licence?}]}.

const UI := preload("res://scripts/ui/UI.gd")

const PATH := "res://assets/data/credits.json"


static func sections() -> Array:
	if not FileAccess.file_exists(PATH):
		return []
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(PATH))
	if not (parsed is Dictionary):
		return []
	return ((parsed as Dictionary).get("sections", []) as Array).filter(func(s): return s is Dictionary)


static func build(_main: Node) -> ScrollContainer:
	var scroll := ScrollContainer.new()
	scroll.name = "CreditsPanel"
	scroll.custom_minimum_size = Vector2(860, 480)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	var v := UI.vbox(14)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(v)
	for s in sections():
		v.add_child(UI.caps(str(s.get("title", ""))))
		for line in s.get("lines", []):
			v.add_child(UI.label(str(line), UI.SMALL, UI.FG, "body", true))
		if bool(s.get("engine_licence", false)):
			var lic := UI.label(Engine.get_license_text(), UI.TINY, UI.MUTED, "body", true)
			lic.name = "EngineLicence"
			v.add_child(lic)
	return scroll
