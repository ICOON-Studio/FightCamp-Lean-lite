extends Control
## S459 (operator C384 on the fight HUD, points 2-4: the two side holos "remove", "add one holo at the bottom panel common
## for both fighters and lines pointing to each side with the hit number", "put the common holo here and stats on each with
## a line connector to the head and to the body"): one holo figure in the corner bar's LANDED box. A line runs from its
## head and from its body to each side: your boxer's punches landed there on the left in her corner's colour, the
## opponent's on the right in theirs. The numbers count what the 3D has landed this round (FightSeam.landed_ex).
##   setup(holo_prefix, ours [head, body], theirs [head, body], ours_col, theirs_col)   drawn: [[text, position]] (tests)

const BodyHolo := preload("res://scripts/ui/BodyHolo.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")

var tex: Texture2D
var anchors := {}
var counts: Array = [[0, 0], [0, 0]]
var cols: Array = [Color.WHITE, Color.WHITE]
var drawn: Array = []
var bands: Array = [["fine", "fine"], ["fine", "fine"]]   # [ours, theirs] x [head, body]: BodyMap bands, worst place of each
const BAND_WORD := {"hurt": "hurt", "critical": "badly hurt", "doctor": "badly hurt"}
const BAND_COL := {"hurt": Color("#ff9a3c"), "critical": Color("#ff4d2e"), "doctor": Color("#ff4d2e")}


func setup(holo: String, ours: Array, theirs: Array, ours_col: Color, theirs_col: Color, hurt: Array = []) -> void:
	if hurt.size() == 2:
		bands = hurt
	if ResourceLoader.exists(holo + ".png"):
		tex = load(holo + ".png")
	var a = JSON.parse_string(FileAccess.get_file_as_string(holo + ".json")) if FileAccess.file_exists(holo + ".json") else null
	anchors = a if a is Dictionary else {}
	counts = [ours, theirs]
	cols = [ours_col, theirs_col]
	tooltip_text = "Punches landed this round, head and body.\nLeft: your boxer's, head %d, body %d.\nRight: the opponent's, head %d, body %d." % [
		int(ours[0]), int(ours[1]), int(theirs[0]), int(theirs[1])]
	mouse_filter = Control.MOUSE_FILTER_PASS
	queue_redraw()


func _point(key: String, fig: Rect2, fallback: Vector2) -> Vector2:
	var a: Array = anchors.get(key, [])
	if a.size() < 2:
		return fig.position + fallback * fig.size
	return fig.position + Vector2(float(a[0]), float(a[1])) * fig.size


func _draw() -> void:
	drawn.clear()
	var fh := size.y
	var fw := fh * (float(tex.get_width()) / float(tex.get_height())) if tex != null else fh * 0.6
	var fig := Rect2((size.x - fw) * 0.5, 0.0, fw, fh)
	if tex != null:
		draw_texture_rect(tex, fig, false)
	var head := _point("head", fig, Vector2(0.5, 0.068))
	var body := (_point("left_ribs", fig, Vector2(0.56, 0.305)) + _point("right_ribs", fig, Vector2(0.44, 0.305))) * 0.5
	var font := get_theme_default_font()
	var fs := 20
	for side in 2:
		var dir := -1.0 if side == 0 else 1.0
		var edge := fig.position.x - 8.0 if side == 0 else fig.end.x + 8.0
		for k in 2:
			var pt: Vector2 = head if k == 0 else body
			var text := ("head %d" if k == 0 else "body %d") % int(counts[side][k])
			var col: Color = cols[side]
			var band := str(bands[side][k])   # the side holos' "which place is hurt", kept on the label (word + colour)
			if BAND_WORD.has(band):
				text += " " + str(BAND_WORD[band])
			var ink: Color = BAND_COL.get(band, col)
			var end := Vector2(edge, pt.y)
			draw_line(pt, end, Color(0, 0, 0, 0.75), 4.0, true)
			draw_line(pt, end, col, 2.0, true)
			draw_circle(pt, 4.0, Color(0, 0, 0, 0.8))
			draw_circle(pt, 2.6, col)
			var tw := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
			var at := Vector2(end.x + 4.0 if dir > 0.0 else end.x - 4.0 - tw, pt.y + float(fs) * 0.35)
			draw_string_outline(font, at, text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, 4, Color(0, 0, 0, 0.85))
			draw_string(font, at, text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, ink)
			drawn.append([text, at])


## S459 C384: the shared holo's picture prefix, from our boxer's body (a man's body gets the male holo).
static func holo_of(view: Node) -> String:
	var bodies: Variant = view.get("bodies")
	var stem := str((bodies as Array)[0]).get_file().get_basename() if bodies is Array and not (bodies as Array).is_empty() else ""
	return BodyHolo.holo_for(stem) if BodyHolo.has() else ""


## [ours, theirs] x [head, body]: each fighter's worst head place and worst ribs as BodyMap bands (the side holos' colours).
static func hurt_of(view: Node) -> Array:
	var bl: Variant = view.get("body")
	var map: Variant = (bl as Object).get("map") if bl is Object else null
	if not map is Dictionary:
		return []
	var out: Array = []
	for who in ["a", "b"]:
		var row: Array = []
		for places in [["head", "left_eye", "right_eye", "nose"], ["left_ribs", "right_ribs"]]:
			var low := 100.0
			for p in places:
				low = minf(low, BodyMap.value(map, who, p))
			row.append(BodyMap.band(low))
		out.append(row)
	return out
