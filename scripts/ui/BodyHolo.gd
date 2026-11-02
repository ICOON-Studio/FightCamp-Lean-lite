extends RefCounted
## S353 (operator on the kit figure: "stop doing tubes and shit", "use a real muscular holo"; "holo looks fine"): every
## boxer's body view is the muscle holo - a bought female ecorche (CGTrader #6489289, royalty-free; the raw model stays outside
## the repo) rendered by tools/holo_render_blender.py and baked by tools/bake_holo_figure.py. No kit, no circles: BodyFigure
## lights each part and hurt place on the muscles. Her face rides along for the HEAD close-up (BodyCallouts), so it stays her.

const HOLO := "res://assets/ui/body/holo_f"
const FACES := "res://assets/ui/face"
const PLATE := Color(0.035, 0.06, 0.09, 0.92)
const PLATE_EDGE := Color(0.25, 0.75, 1.0, 0.35)


static func has() -> bool:
	return ResourceLoader.exists(HOLO + ".png") and FileAccess.file_exists(HOLO + ".json")


## {"tex", "anchors", "mask", "holo": true, "face"} for the boxer with this model stem.
static func portrait(stem: String) -> Dictionary:
	var a = JSON.parse_string(FileAccess.get_file_as_string(HOLO + ".json"))
	var face := FACES.path_join(stem + ".jpg")
	return {"tex": load(HOLO + ".png"), "anchors": a if a is Dictionary else {}, "holo": true,
		"mask": load(HOLO + "_mask.png") if ResourceLoader.exists(HOLO + "_mask.png") else null,
		"face": load(face) if ResourceLoader.exists(face) else null}


## The dark scanner plate behind the holo, so it reads the same on the white training board and the dark fight panel.
static func plate() -> Panel:
	var p := Panel.new()
	p.name = "Plate"
	p.show_behind_parent = true
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var sb := StyleBoxFlat.new()
	sb.bg_color = PLATE
	sb.border_color = PLATE_EDGE
	sb.set_border_width_all(1)
	sb.set_corner_radius_all(10)
	p.add_theme_stylebox_override("panel", sb)
	return p
