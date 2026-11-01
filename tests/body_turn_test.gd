extends SceneTree
## BodyTurn (S334 C153 "still needs to be bigger maybe slightly autorotating"): 4 tests.
## 1. Baked: every fight body has a turn in both corners, 13 views, each with her places and track.
## 2. Turn: across the views her head moves sideways in the picture (she really turns), the middle view is the front one.
## 3. Cross-fade: between views k and k+1 the second skin shows view k+1 at the fraction, the first view k; each skin's
##    hurt spots sit on its own view (uv inside that view's part of the strip).
## 4. Fallback: a body never baked does not attach (the caller keeps the still portrait).

const BF := preload("res://scripts/ui/BodyFigure.gd")
const BodyTurn := preload("res://scripts/ui/BodyTurn.gd")
const Faces := preload("res://scripts/rules/Faces.gd")

var failures := 0


func _initialize() -> void:
	_test1()
	_test2()
	_test3()
	_test4()
	print("BODY_TURN failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## 1. Baked.
func _test1() -> void:
	var ok := true
	for stem in Faces.CM:
		for corner in ["red", "blue"]:
			var d := BodyTurn.data_for(Faces.glb(stem), corner)
			if d.is_empty() or (d["frames"] as Array).size() != 13:
				print("  no turn %s %s" % [stem, corner])
				ok = false
				continue
			for fr in d["frames"]:
				if not (fr as Dictionary).has("head") or not (fr as Dictionary).has("track"):
					print("  %s: a view without places/track" % stem)
					ok = false
					break
	_check("1 every body has a 13-view turn in both corners", ok)


## 2. Turn.
func _test2() -> void:
	var ok := true
	for stem in Faces.CM:
		var fr: Array = BodyTurn.data_for(Faces.glb(stem), "red").get("frames", [])
		if fr.size() != 13:
			ok = false
			continue
		var xs: Array = fr.map(func(f): return float(f["left_eye"][0]) - float(f["head"][0]))
		# the eye moves across the head's centre as she turns: first and last views on opposite sides of the middle
		if not (signf(xs[0] - xs[6]) == -signf(xs[12] - xs[6]) and absf(xs[0] - xs[12]) > 0.01):
			print("  %s: eye offset %s" % [stem, str(xs)])
			ok = false
	_check("2 she turns: the eyes swing across her head from one end view to the other", ok)


## 3. Cross-fade.
func _test3() -> void:
	var fig: Control = BF.new()
	fig.size = Vector2(340, 420)
	get_root().add_child(fig)
	var ok := BodyTurn.attach(fig, Faces.glb("mh_boxer_11"), "red")
	var bt: Node = fig.get_node_or_null("BodyTurn")
	if not ok or bt == null:
		_check("3 cross-fade between neighbouring views", false)
		return
	bt.set_process(false)
	bt.show_at(4.25)
	var second := fig.get_node("Skin2") as TextureRect
	ok = absf(second.modulate.a - 0.25) < 0.001
	ok = ok and (fig._skin.texture as AtlasTexture) == bt._atlas[4] and (second.texture as AtlasTexture) == bt._atlas[5]
	for k in 2:
		var l: Dictionary = fig.layers_for_paint[k]
		var uv: Rect2 = l["uv"]
		ok = ok and absf(uv.position.x - float(4 + k) / 13.0) < 0.0001
		var h: Array = (l["anchors"] as Dictionary)["head"]
		var u := uv.position.x + float(h[0]) * uv.size.x
		ok = ok and u > uv.position.x and u < uv.end.x
	fig.set_values({"head": 20.0})   # a hurt face: both skins paint the spot inside their own view
	var boxes: Array = (second.material as ShaderMaterial).get_shader_parameter("spot_box")
	ok = ok and boxes.size() == 3 and (boxes[0] as Vector4).x > 5.0 / 13.0 and (boxes[0] as Vector4).x < 6.0 / 13.0
	fig.queue_free()
	_check("3 cross-fade: views 4/5 at 0.25, spots on each skin's own view", ok)


## 4. Fallback.
func _test4() -> void:
	var fig: Control = BF.new()
	get_root().add_child(fig)
	var ok := not BodyTurn.attach(fig, "res://assets/models/metahuman/mh_boxer_99.glb", "red") and fig.get_node_or_null("BodyTurn") == null
	fig.queue_free()
	_check("4 a body never baked does not turn", ok)


func _check(label: String, ok: bool) -> void:
	if ok:
		print("PASS ", label)
	else:
		print("FAIL ", label)
		failures += 1
