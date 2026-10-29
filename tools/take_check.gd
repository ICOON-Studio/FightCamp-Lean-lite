extends SceneTree
## S301: are the Pro stepping (_ft) and wide-miss (_miss) takes clean enough to play? S300's film saw _ft takes kick the
## back leg up while the ring holds her on her mark, and some _miss takes fling the rear arm back. For every _ft / _miss
## take and its plain take, on the game's body at 60 Hz (body frame, facing +Z, metres): the highest either foot lifts
## above where it stands in the guard, how far the hips travel forward / back, and how far behind the hips the rear (right)
## glove goes. A take is CLEAN when it lifts and flings no more than its plain take plus a margin. Headless:
##   <godot.exe> --headless --path . --script res://tools/take_check.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const HZ := 60.0
const LIFT_MARGIN_M := 0.08
const FLING_MARGIN_M := 0.10


func _initialize() -> void:
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	stage.set_process(false)
	var bx: Dictionary = stage.boxers[0]
	var ap: AnimationPlayer = bx["ap"]
	var guard := {}
	for b in ["LeftFoot", "RightFoot", "Hips"]:
		guard[b] = Stage.IdleMatch.pose_point(bx, "pro_idle", 0.0, b)
	var clean: Array = []
	for n in ap.get_animation_list():
		var name := str(n)
		if not name.begins_with("pro_") or not (name.ends_with("_ft") or name.ends_with("_miss")):
			continue
		var plain := name.trim_suffix("_ft").trim_suffix("_miss").trim_suffix("_hard").trim_suffix("_hurt")
		if not ap.has_animation(plain):
			continue
		var take := _measure(stage, bx, name, guard)
		var base := _measure(stage, bx, plain, guard)
		var ok: bool = take["lift"] <= base["lift"] + LIFT_MARGIN_M and take["fling"] <= base["fling"] + FLING_MARGIN_M
		if ok:
			clean.append(name)
		print("TAKE %-28s %s lift %.2f (plain %.2f) fling %.2f (plain %.2f) hips %+.2f..%+.2f" % [name, "CLEAN" if ok else "OFF  ",
			take["lift"], base["lift"], take["fling"], base["fling"], take["back"], take["fwd"]])
	print("TAKE CLEAN %d: %s" % [clean.size(), ", ".join(clean)])
	quit(0)


func _measure(stage: Node3D, bx: Dictionary, clip: String, guard: Dictionary) -> Dictionary:
	var length: float = (bx["ap"] as AnimationPlayer).get_animation(clip).length
	var out := {"lift": 0.0, "fling": 0.0, "fwd": 0.0, "back": 0.0}
	var t := 0.0
	while t <= length:
		var hips: Vector3 = Stage.IdleMatch.pose_point(bx, clip, t, "Hips")
		for f in ["LeftFoot", "RightFoot"]:
			out["lift"] = maxf(out["lift"], Stage.IdleMatch.pose_point(bx, clip, t, f).y - (guard[f] as Vector3).y)
		out["fling"] = maxf(out["fling"], hips.z - Stage.IdleMatch.pose_point(bx, clip, t, "RightHand").z)
		out["fwd"] = maxf(out["fwd"], hips.z - (guard["Hips"] as Vector3).z)
		out["back"] = minf(out["back"], hips.z - (guard["Hips"] as Vector3).z)
		t += 1.0 / HZ
	return out
