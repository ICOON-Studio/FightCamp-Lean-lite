extends "res://tools/judge_film.gd"
## S390 (judge: "pops upright, headless, for 2 frames" on the replay's return): the downed boxer frame by frame around the end of the replay.

var _rp: Node
var _was := false
var _left := -1


func _process(delta: float) -> bool:
	var done := false
	if _rp == null:
		_rp = root.find_child("KnockdownReplay", true, false)
	if _rp == null:
		return done
	var on: bool = _rp.active()
	if _was and not on:
		_left = 14
	if on and float(_rp.get("_t")) >= float(_rp.get("_end")) - 0.12:
		_print("end")
	if _left > 0:
		_left -= 1
		_print("after")
	_was = on
	return done


func _print(tag: String) -> void:
	var view: Node = _rp.get("view")
	var who := int(_rp.get("_who"))
	var bx: Dictionary = view.stage.boxers[who]
	var skel: Skeleton3D = bx["skel"]
	var ap: AnimationPlayer = bx["ap"]
	var head := skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Head")).origin
	var hips := skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Hips")).origin
	print("RPX %s head_y=%.2f hips_y=%.2f root=%s clip=%s t=%.2f playing=%s phase=%s" % [tag, head.y, hips.y, str((bx["node"] as Node3D).global_position), ap.current_animation if ap.current_animation != "" else ap.assigned_animation, ap.current_animation_position if ap.is_playing() else -1.0, ap.is_playing(), str(view.kd.phase)])
