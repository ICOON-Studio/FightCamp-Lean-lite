extends RefCounted
## S389 BJJWIRE: a bout of an open fought live - the 3D belt match over the career screen, its result back to Grapplers.

const UI := preload("res://scripts/ui/UI.gd")
const Grapplers := preload("res://scripts/state/Grapplers.gd")
const BjjOpen := preload("res://scripts/rules/BjjOpen.gd")
const BROWSER := "res://scenes/dev/GrappleBrowser.tscn"


static func start(main: Node, layer: Control, f: Dictionary) -> void:
	var c: Career = main.career
	var run: Dictionary = f["open_run"]
	var b: Control = load(BROWSER).instantiate()
	b.theme = UI.theme()
	b.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	b.set("career_match", {"athlete": f, "opp": BjjOpen.match_opp(Grapplers.next_opp(c, f)),
		"seed": hash("%d|%s|%d|%d" % [c.seed, f["id"], int(run["d"]), (run["rows"] as Array).size()]),
		"on_end": func(res: Dictionary): _ended(res, main, b, f)})
	layer.add_child(b)


static func _ended(res: Dictionary, main: Node, b: Control, f: Dictionary) -> void:
	b.queue_free()
	Grapplers.live_bout(main.career, f, res)
	main.redraw_modal()
