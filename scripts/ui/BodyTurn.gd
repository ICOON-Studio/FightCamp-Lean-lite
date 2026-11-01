extends Node
## S334 (operator C153 on the fight's body view: "still needs to be bigger maybe slightly autorotating"): turns a
## BodyFigure slowly from side to side - her baked turn strip (tools/bake_body_turn.gd, 13 views over -30..+30 degrees),
## two skins cross-fading between neighbouring views so the turn reads smooth, the part colours and hurt spots on each.
##   BodyTurn.attach(figure, glb, corner) -> true when she turns (else the caller sets the still portrait)

const PORTRAITS := "res://assets/ui/body"
const CYCLE_S := 12.0   # one swing there and back: slow, it should not pull the eye off the fight

var fig: Control
var frames: Array = []
var n := 1
var _atlas: Array = []
var _second: TextureRect
var _t := 0.0


## {"tex": strip, "mask": mask strip, "frames": [...]} for her body and corner colours; {} when never baked.
static func data_for(glb: String, corner: String) -> Dictionary:
	var stem := glb.get_file().get_basename()
	var png := PORTRAITS.path_join("%s_turn_%s.png" % [stem, corner])
	var mask := PORTRAITS.path_join(stem + "_turn_mask.png")
	var js := PORTRAITS.path_join(stem + "_turn.json")
	if stem == "" or not ResourceLoader.exists(png) or not ResourceLoader.exists(mask) or not FileAccess.file_exists(js):
		return {}
	var d = JSON.parse_string(FileAccess.get_file_as_string(js))
	if not d is Dictionary or (d.get("frames", []) as Array).is_empty():
		return {}
	return {"tex": load(png), "mask": load(mask), "frames": d["frames"]}


static func attach(f: Control, glb: String, corner: String) -> bool:
	var d := data_for(glb, corner)
	if d.is_empty():
		return false
	var bt := new()
	bt.name = "BodyTurn"
	bt.fig = f
	bt.frames = d["frames"]
	bt.n = bt.frames.size()
	var strip: Texture2D = d["tex"]
	var fw := strip.get_width() / float(bt.n)
	for k in bt.n:
		var a := AtlasTexture.new()
		a.atlas = strip
		a.region = Rect2(k * fw, 0, fw, strip.get_height())
		bt._atlas.append(a)
	var mid := bt.n / 2
	f.set_portrait({"tex": bt._atlas[mid], "anchors": bt.frames[mid], "mask": d["mask"]})
	bt._second = f._skin.duplicate() as TextureRect
	bt._second.name = "Skin2"
	bt._second.material = f._skin.material.duplicate()
	f.add_child(bt._second)
	f.add_child(bt)
	bt.show_at(float(mid))
	return true


func _process(delta: float) -> void:
	_t += delta
	show_at((n - 1) * 0.5 * (1.0 + sin(TAU * _t / CYCLE_S)))


## Her body at view `pos` (0 .. n-1, fractions cross-fade the two nearest views).
func show_at(pos: float) -> void:
	var i0 := clampi(floori(pos), 0, n - 1)
	var i1 := mini(i0 + 1, n - 1)
	var near := clampi(roundi(pos), 0, n - 1)
	fig._tex = _atlas[near]
	fig._anchors = frames[near]
	fig._skin.texture = _atlas[i0]
	_second.texture = _atlas[i1]
	_second.modulate.a = clampf(pos - i0, 0.0, 1.0)
	fig.layers_for_paint = [{"skin": fig._skin, "uv": _uv(i0), "anchors": frames[i0]},
		{"skin": _second, "uv": _uv(i1), "anchors": frames[i1]}]
	fig._paint_skin()
	fig.queue_redraw()


func _uv(k: int) -> Rect2:
	return Rect2(float(k) / n, 0.0, 1.0 / n, 1.0)
