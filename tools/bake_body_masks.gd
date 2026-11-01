extends SceneTree
## S324 (operator C149 on the body view: "looks terrible needs to be bigger and look like a human stop doing cube things as
## limbs"): bakes a part mask beside each body portrait so BodyFigure colours her OWN body pixels part by part (tyre-temperature
## style) instead of drawing round-ended strokes over her. Each opaque body pixel goes to the nearest track stroke, distance
## measured in stroke widths (a thick stroke like the core claims more); the head and neck stay her own colours.
##   <godot.exe> --headless --path . --script res://tools/bake_body_masks.gd
## Writes assets/ui/body/<stem>_mask.png (L8: part index * MASK_STEP, 0 = untinted). Index order = BodyFigure.MASK_KEYS.

const DIR := "res://assets/ui/body"
const KEYS := ["core", "left_shoulder", "right_shoulder", "left_arm", "right_arm", "legs"]
const MASK_STEP := 32
const OPAQUE := 0.1
const NECK_GAP := 0.012   # fraction of the height above the shoulder strokes that stays her own colours


func _initialize() -> void:
	var n := 0
	for f in DirAccess.get_files_at(DIR):
		if not f.ends_with(".json"):
			continue
		var stem := f.get_basename()
		var png := DIR.path_join(stem + "_red.png")
		var anchors = JSON.parse_string(FileAccess.get_file_as_string(DIR.path_join(f)))
		if not anchors is Dictionary or not (anchors as Dictionary).has("track") or not FileAccess.file_exists(png):
			continue
		var img := Image.load_from_file(ProjectSettings.globalize_path(png))
		var out := _mask(img, anchors["track"])
		var path := ProjectSettings.globalize_path(DIR.path_join(stem + "_mask.png"))
		out.save_png(path)
		print("MASK %s %dx%d -> %s" % [stem, out.get_width(), out.get_height(), path])
		n += 1
	print("MASKS baked=%d" % n)
	quit(0 if n > 0 else 1)


func _mask(img: Image, track: Dictionary) -> Image:
	return mask_of(img, track)


## Static so tools/bake_body_turn.gd masks each turn frame the same way.
static func mask_of(img: Image, track: Dictionary) -> Image:
	var w := img.get_width()
	var h := img.get_height()
	var segs := []   # [a, b, half width, index] in pixels
	var neck_y := float(h)
	for place in track:
		var key := "legs" if str(place).begins_with("legs") else str(place)
		var idx := KEYS.find(key) + 1
		if idx == 0:
			continue
		var st: Dictionary = track[place]
		var pts: Array = st["pts"]
		var hw: float = maxf(1.0, float(st["w"]) * w * 0.5)
		for i in pts.size() - 1:
			var a := Vector2(float(pts[i][0]) * w, float(pts[i][1]) * h)
			var b := Vector2(float(pts[i + 1][0]) * w, float(pts[i + 1][1]) * h)
			segs.append([a, b, hw, idx])
		if key.ends_with("shoulder"):
			for q in pts:
				neck_y = minf(neck_y, float(q[1]) * h)
	neck_y -= NECK_GAP * h
	var out := Image.create(w, h, false, Image.FORMAT_L8)
	for y in h:
		if float(y) < neck_y:
			continue
		for x in w:
			if img.get_pixel(x, y).a < OPAQUE:
				continue
			var p := Vector2(x + 0.5, y + 0.5)
			var best := INF
			var bi := 0
			for s in segs:
				var d: float = Geometry2D.get_closest_point_to_segment(p, s[0], s[1]).distance_to(p) / float(s[2])
				if d < best:
					best = d
					bi = int(s[3])
			out.set_pixel(x, y, Color8(bi * MASK_STEP, bi * MASK_STEP, bi * MASK_STEP))
	return out
