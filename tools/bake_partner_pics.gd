extends "res://tools/bake_session_pics.gd"
## S381 C229 stage 3 - the camp's Partner card picture: the southpaw mate from another club, drawn with the session-pics
## method (tools/bake_session_pics.gd: the same ink body, camera framing and card) from the shadow jab, then MIRRORED -
## a southpaw is the orthodox boxer in the mirror, the way the 3D draws one (MirrorClip): right foot and right hand lead,
## and the jab runs to the LEFT of the card, against every orthodox card on the modal.
##
##   python tools/hidden_desktop.py run --timeout=600 "<godot>" --path . --windowed --resolution 1280x720 \
##       --audio-driver Dummy --script res://tools/bake_partner_pics.gd [-- stems=mh_boxer_10,...]
##
##   Writes assets/ui/training/<stem>_southpaw.png for the partner bodies (CampMatch.PARTNER_STEMS). session_pics.json
##   keeps only the eight training sessions (tests/session_pics_test.gd reads it), so no row is added for these - but the
##   base driver re-writes it (whole numbers come back as 83.0): `git checkout assets/ui/training/session_pics.json` after.

const CampMatch := preload("res://scripts/ui/CampMatch.gd")


func _stems() -> Array:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("stems="):
			return super()
	var out: Array = []
	for sex in CampMatch.PARTNER_STEMS:
		out.append_array(CampMatch.PARTNER_STEMS[sex])
	return out


func _bake_stem(stem: String) -> void:
	_stem = stem
	var glb := MH_DIR.path_join(stem + ".glb")
	var body := MH.load_fighter(glb)
	if body == null:
		push_error("cannot load " + glb)
		return
	Kit.dress(body, glb, "boxing")
	var gloves := Gloves.new()
	gloves.name = "Gloves"
	body.add_child(gloves)
	gloves.mount(body, Stage.CORNERS["red"][0], Stage.CORNERS["red"][1])
	_vp.add_child(body)
	await process_frame
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var ap := body.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
	FightClips.load_into(ap, skel)
	var bx := {"node": body, "skel": skel, "ap": ap, "gloves": gloves}
	var mats := SPS.ink_materials()
	_fills = mats.values()
	_hulls = SPS.ink_body(body, mats)
	var had: Dictionary = _json.get(stem, {})
	_json[stem] = had.duplicate(true)
	await _bake_session("southpaw", bx)
	_json[stem] = had   # the training sessions' rows only
	if had.is_empty():
		_json.erase(stem)
	var path := ProjectSettings.globalize_path(OUT.path_join("%s_southpaw.png" % stem))
	var img := Image.load_from_file(path)
	img.flip_x()
	img.save_png(path)
	print("PARTNER_PIC %s (mirrored)" % path)
	body.queue_free()
	await process_frame
