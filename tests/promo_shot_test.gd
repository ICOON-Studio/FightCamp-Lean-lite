extends SceneTree
## S387 PromoShot: every promo shot frames head and shoulders - both eyes in the upper half, the frame ending above the crossed arms
## (hands start at about 0.70 of a shot) - inside the picture, with a shader that gets its region.

const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const HANDS_AT := 0.70

var failures := 0


func _initialize() -> void:
	var all = JSON.parse_string(FileAccess.get_file_as_string("res://assets/ui/face/promo_face.json"))
	_check(all is Dictionary and (all as Dictionary).size() >= 19, "the marks load")
	for stem in all:
		var r := PromoShot.region(stem)
		var e := float(all[stem]["eye_l"][1])
		_check(r.end.y <= HANDS_AT, "%s ends above the hands (%.2f)" % [stem, r.end.y])
		_check(r.position.x >= 0.0 and r.end.x <= 1.0 and r.position.y >= 0.0, "%s stays inside the shot" % stem)
		_check((e - r.position.y) / r.size.y < 0.5, "%s has the eyes in the upper half" % stem)
	_check(PromoShot.region("no_such_body") == Rect2(), "a body with no marks keeps its whole shot")
	var tex: Texture2D = load("res://assets/ui/face/mh_boxer_11.jpg")
	var cropped := PromoShot.crop(tex, "mh_boxer_11")
	_check(cropped is AtlasTexture, "a shot crops to an atlas")
	var rect := TextureRect.new()
	rect.texture = cropped
	PromoShot.live(rect)
	_check(rect.material is ShaderMaterial, "live sets the breath")
	var want := (cropped as AtlasTexture).region.position.y / tex.get_size().y
	_check(absf((rect.material as ShaderMaterial).get_shader_parameter("region").y - want) < 0.001, "the shader knows the crop")
	rect.free()
	print("PROMO_SHOT failures=%d" % failures)
	print("PASS promo_shot_test" if failures == 0 else "FAIL promo_shot_test")
	quit(failures)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + label)
