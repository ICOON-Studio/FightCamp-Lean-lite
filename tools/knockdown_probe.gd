extends SceneTree
## KDFIX4 probe: chest side travel in two windows, for a knockdown and a knockout.
## Settle is 0-0.5 s (the fall and the layers easing off). Sway is 0.5-5 s (what reads as a body rocking on the canvas).
## Rows: all layers on, then FighterLife, GuardWeave and TiredSag off one at a time, then all three off (the clip alone).
## The all-on rows print each layer's weight every frame, so a layer that is still writing after 0.5 s is visible.
##   python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/knockdown_probe.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")

const BOXER_A := "mh_boxer_10"
const BOXER_B := "mh_boxer_12"
const FALL_CLIP := "react_hurt"
const KO_CLIP := "pro_knockout_v1"
const SAMPLE_S := 5.0
const SPLIT_S := 0.5
const LAYERS := ["FighterLife", "GuardWeave", "TiredSag"]


func _initialize() -> void:
	Engine.max_fps = 30
	print("KNOCKDOWN_PROBE")
	var stage := await _make_stage()
	var bx: Dictionary = stage.boxers[0]
	var skel: Skeleton3D = bx["skel"]
	var ap: AnimationPlayer = bx["ap"]
	var hip_attach := _attach(skel, "Hips")
	var chest_attach := _attach(skel, "Chest")
	for clip in [FALL_CLIP, KO_CLIP]:
		var length := 0.0
		if ap.has_animation(clip):
			length = ap.get_animation(clip).length
		print("clip %s length %.3f s" % [clip, length])
	var rows: Array = [
		["knockdown", FALL_CLIP, "all on", []],
		["knockdown", FALL_CLIP, "FighterLife off", ["FighterLife"]],
		["knockdown", FALL_CLIP, "GuardWeave off", ["GuardWeave"]],
		["knockdown", FALL_CLIP, "TiredSag off", ["TiredSag"]],
		["knockdown", FALL_CLIP, "all off", LAYERS.duplicate()],
		["knockout", KO_CLIP, "all on", []],
		["knockout", KO_CLIP, "FighterLife off", ["FighterLife"]],
		["knockout", KO_CLIP, "GuardWeave off", ["GuardWeave"]],
		["knockout", KO_CLIP, "TiredSag off", ["TiredSag"]],
		["knockout", KO_CLIP, "all off", LAYERS.duplicate()],
	]
	var results: Array = []
	for row in rows:
		var label := str(row[0])
		var clip := str(row[1])
		var layers := str(row[2])
		var drop: Array = row[3]
		var trace := layers == "all on"
		if trace:
			print("")
			print("WEIGHT %s %s each frame (t, current, assigned, calm, gw, pos, sag_w)" % [label, clip])
		var m: Dictionary = await _measure(stage, 0, clip, drop, hip_attach, chest_attach, trace)
		results.append({"label": label, "layers": layers, "settle": m["settle"], "sway": m["sway"],
			"calm_after": m["calm_after"], "gw_after": m["gw_after"], "sag_after": m["sag_after"]})
		print("ROW %s | %s | settle %.3f cm | sway %.3f cm | after0.5 max calm %.3f gw %.3f sag %.3f" % [
			label, layers, m["settle"], m["sway"], m["calm_after"], m["gw_after"], m["sag_after"]])
	print("")
	print("TABLE clip | layers | settle_0.0_0.5_cm | sway_0.5_5_cm")
	for r in results:
		print("TABLE %s | %s | %.3f | %.3f" % [r["label"], r["layers"], r["settle"], r["sway"]])
	print("KNOCKDOWN_PROBE done")
	quit(0)


func _make_stage() -> Node3D:
	var stg: Node3D = Stage.new()
	root.add_child(stg)
	stg.set_process(false)
	await process_frame
	stg.setup({"glb": "res://assets/models/metahuman/%s.glb" % BOXER_A, "corner": "red"},
		{"glb": "res://assets/models/metahuman/%s.glb" % BOXER_B, "corner": "blue"})
	stg.set_process(true)
	for i in 3:
		await process_frame
	return stg


func _attach(skel: Skeleton3D, bone: String) -> BoneAttachment3D:
	var nm := "probe_" + bone
	var n: Node = skel.get_node_or_null(nm)
	if n != null and n is BoneAttachment3D:
		return n as BoneAttachment3D
	var ba := BoneAttachment3D.new()
	ba.name = nm
	ba.bone_name = bone
	skel.add_child(ba)
	return ba


func _chest_side_pos(hip_attach: BoneAttachment3D, chest_attach: BoneAttachment3D) -> float:
	if hip_attach == null or chest_attach == null:
		return 0.0
	var hips_pos: Vector3 = hip_attach.global_transform.origin
	var chest_pos: Vector3 = chest_attach.global_transform.origin
	var hips_to_chest: Vector3 = chest_pos - hips_pos
	var hips_basis: Basis = hip_attach.global_transform.basis
	var hips_left: Vector3 = hips_basis.x.normalized()
	var hips_up: Vector3 = hips_basis.y.normalized()
	var side_in_hips: Vector3 = hips_left - hips_up * hips_left.dot(hips_up)
	if side_in_hips.length() < 0.001:
		return 0.0
	return hips_to_chest.dot(side_in_hips.normalized())


## One play of `clip`. `drop` layers are taken off the skeleton for the play and put back at the same index.
## The boxer's move_left stays high so a finished clip does not hand the body back to the guard mid-sample.
func _measure(stage: Node3D, who: int, clip: String, drop: Array, hip_attach: BoneAttachment3D, chest_attach: BoneAttachment3D, trace: bool) -> Dictionary:
	var bx: Dictionary = stage.boxers[who]
	var skel: Skeleton3D = bx["skel"]
	var ap: AnimationPlayer = bx["ap"]
	var empty := {"settle": 0.0, "sway": 0.0, "calm_after": 0.0, "gw_after": 0.0, "sag_after": 0.0}
	if not ap.has_animation(clip):
		print("  missing clip %s" % clip)
		return empty
	bx["move_left"] = 99.0
	# A fixed idle, not stage.guard(): that picks a random captured guard and the later rows stop matching.
	var idle := "pro_idle" if ap.has_animation("pro_idle") else "idle"
	if ap.has_animation(idle):
		ap.play(idle, 0.0, 1.0)
		ap.seek(0.0, true)
	for i in 12:
		await process_frame
	var removed := _drop(skel, drop)
	ap.play(clip, 0.0, 1.0)
	var elapsed := 0.0
	var settle_min := 999.0
	var settle_max := -999.0
	var sway_min := 999.0
	var sway_max := -999.0
	var settle_n := 0
	var sway_n := 0
	var calm_after := 0.0
	var gw_after := 0.0
	var sag_after := 0.0
	var frames := 0
	while elapsed < SAMPLE_S and frames < 240:
		await process_frame
		var dt: float = stage.get_process_delta_time()
		elapsed += dt
		frames += 1
		var side: float = _chest_side_pos(hip_attach, chest_attach)
		if elapsed < SPLIT_S:
			settle_min = minf(settle_min, side)
			settle_max = maxf(settle_max, side)
			settle_n += 1
		else:
			sway_min = minf(sway_min, side)
			sway_max = maxf(sway_max, side)
			sway_n += 1
			calm_after = maxf(calm_after, _layer_num(skel, "FighterLife", "calm"))
			gw_after = maxf(gw_after, _layer_num(skel, "GuardWeave", "weight"))
			sag_after = maxf(sag_after, _layer_num(skel, "TiredSag", "_w"))
		if trace:
			print("W t=%.3f current=%s assigned=%s calm=%.3f gw=%.3f pos=%s sag_w=%.3f" % [
				elapsed, str(ap.current_animation), str(ap.assigned_animation),
				_layer_num(skel, "FighterLife", "calm"), _layer_num(skel, "GuardWeave", "weight"),
				str(_layer_vec(skel)), _layer_num(skel, "TiredSag", "_w")])
	_restore(skel, removed)
	bx["move_left"] = 0.0
	return {"settle": _span(settle_min, settle_max, settle_n), "sway": _span(sway_min, sway_max, sway_n),
		"calm_after": calm_after, "gw_after": gw_after, "sag_after": sag_after}


func _span(lo: float, hi: float, n: int) -> float:
	if n <= 0:
		return 0.0
	return (hi - lo) * 100.0


func _drop(skel: Skeleton3D, names: Array) -> Array:
	var found: Array = []
	for layer_name in names:
		var layer: Node = skel.get_node_or_null(str(layer_name))
		if layer != null:
			found.append(layer)
	found.sort_custom(func(a: Node, b: Node) -> bool: return a.get_index() > b.get_index())
	var removed: Array = []
	for layer in found:
		var idx := (layer as Node).get_index()
		skel.remove_child(layer)
		removed.append({"n": layer, "i": idx})
	return removed


func _restore(skel: Skeleton3D, removed: Array) -> void:
	var back: Array = removed.duplicate()
	back.reverse()
	for item in back:
		var layer: Node = item["n"]
		skel.add_child(layer)
		skel.move_child(layer, mini(int(item["i"]), skel.get_child_count() - 1))


func _layer_num(skel: Skeleton3D, layer_name: String, prop: String) -> float:
	var layer: Node = skel.get_node_or_null(layer_name)
	if layer == null:
		return 0.0
	return float(layer.get(prop))


func _layer_vec(skel: Skeleton3D) -> Vector2:
	var layer: Node = skel.get_node_or_null("GuardWeave")
	if layer == null:
		return Vector2.ZERO
	return layer.get("pos") as Vector2
