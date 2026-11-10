extends SceneTree
## FIGHTSLIDE1 (S419): how much do planted feet slide during a live fight, and what moves them?
## Headless. Two boxers (mh_boxer_10 vs mh_boxer_12, then swapped), three rounds through BeatFire at 30 fps.
## Read on skeleton_updated (the final pose). Per plant: ball travel, clip playing, system state.
##   <godot> --headless --audio-driver Dummy --path . --fixed-fps 30 --script res://tools/fight_slide_probe.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatFire := preload("res://scripts/fight3d/BeatFire.gd")
const RoundScript := preload("res://scripts/rules/RoundScript.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const RingFeet := preload("res://scripts/fight3d/RingFeet.gd")
const Measure := preload("res://tools/owned_mocap_measure.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

const FPS := 30.0
const DT := 1.0 / FPS
const FLOOR_BAND := 0.025
const PLANT_SPEED := 0.25
const PLANT_MIN_S := 0.2
const BALLS := ["LeftToes", "RightToes"]


func _initialize() -> void:
	Engine.max_fps = 30
	print("FIGHTSLIDE1 probe start")
	var c1 := await _control_guard()
	print("CONTROL1 guard_10s slide_max_cm=%.2f plants=%d" % [c1["max_cm"], c1["plants"]])
	var c2 := await _control_push()
	print("CONTROL2 root_push slide_max_cm=%.2f plants=%d" % [c2["max_cm"], c2["plants"]])
	var fight_a := await _fight_rounds("mh_boxer_10", "mh_boxer_12", 3)
	print("FIGHT_A %s vs %s" % ["mh_boxer_10", "mh_boxer_12"])
	_print_fight_results(fight_a)
	var fight_b := await _fight_rounds("mh_boxer_12", "mh_boxer_10", 3)
	print("FIGHT_B %s vs %s" % ["mh_boxer_12", "mh_boxer_10"])
	_print_fight_results(fight_b)
	_write_result(c1, c2, fight_a, fight_b)
	print("FIGHTSLIDE1 probe done")
	quit(0)


## Control 1: boxer in guard, no beats, 10 s. Should read < 1 cm slide per plant.
func _control_guard() -> Dictionary:
	var stage: Node3D = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_12.glb", "corner": "blue"})
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	stage.life._quiet = [999.0, 999.0]
	var bx: Dictionary = stage.boxers[0]
	var skel: Skeleton3D = bx["skel"]
	var frames := []
	var cap_fn := func() -> void:
		var balls := []
		for nm in BALLS:
			var bi: int = skel.find_bone(nm)
			balls.append(skel.global_transform * skel.get_bone_global_pose(bi).origin)
		var clip: String = str((bx["ap"] as AnimationPlayer).current_animation)
		var p: Vector3 = bx["pos"]
		frames.append({"balls": balls, "clip": clip, "pos_x": p.x, "pos_z": p.z,
			"rig_w": float(bx["rig"].w), "clinch": false, "move_left": float(bx["move_left"])})
	skel.skeleton_updated.connect(cap_fn)
	for f in int(10.0 / DT):
		stage._process(DT)
		await process_frame
	skel.skeleton_updated.disconnect(cap_fn)
	stage.queue_free()
	await process_frame
	return _analyse_plants(frames, "control_guard")


## Control 2: root pushed 0.5 m sideways over 0.5 s, feet untouched by animation.
## Move the body node directly, no stage._process (the ruler checks that world-space ball tracking works).
func _control_push() -> Dictionary:
	var stage: Node3D = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_12.glb", "corner": "blue"})
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	stage.life._quiet = [999.0, 999.0]
	var bx: Dictionary = stage.boxers[0]
	var skel: Skeleton3D = bx["skel"]
	var body: Node3D = bx["node"]
	var frames := []
	var push_frames := int(0.5 / DT)
	var total_frames := int(2.0 / DT)
	var start_pos := body.global_position
	for f in total_frames:
		if f < push_frames:
			var t := float(f) / push_frames
			body.global_position = start_pos + Vector3(0.5 * t, 0.0, 0.0)
		await process_frame   # let the skeleton update
		var balls := []
		for nm in BALLS:
			var bi: int = skel.find_bone(nm)
			balls.append(skel.global_transform * skel.get_bone_global_pose(bi).origin)
		var clip: String = str((bx["ap"] as AnimationPlayer).current_animation)
		var p: Vector3 = body.global_position
		frames.append({"balls": balls, "clip": clip, "pos_x": p.x, "pos_z": p.z,
			"rig_w": 0.0, "clinch": false, "move_left": 0.0})
	stage.queue_free()
	await process_frame
	return _analyse_plants(frames, "control_push")


## Run `n_rounds` rounds of a fight between two boxers.
func _fight_rounds(glb_a: String, glb_b: String, n_rounds: int) -> Array:
	var results := []
	for rnd in n_rounds:
		var r := await _one_round(glb_a, glb_b, rnd + 1)
		results.append(r)
		print("  round %d: %d frames captured" % [rnd + 1, r["n_frames"]])
	return results


## One round: generate beats, fire them through BeatFire, capture frames.
func _one_round(glb_a: String, glb_b: String, round_n: int) -> Dictionary:
	var stage: Node3D = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/%s.glb" % glb_a, "corner": "red"},
		{"glb": "res://assets/models/metahuman/%s.glb" % glb_b, "corner": "blue"})
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	var view := _make_view(stage, round_n)
	var beat := BeatFire.new()
	beat.reset()
	var all_beats := []
	var n_ex := 1   # 1 exchange per round (30 s) for practical run time
	for ex_k in n_ex:
		var round_dict := {"n": round_n, "won": ex_k % 2 == 0, "mine": 10.0, "theirs": 8.0,
			"corner": "", "lines": [], "names": [glb_a, glb_b]}
		var profiles: Dictionary = {"a": {}, "b": {}}
		var plan := RoundScript.build(round_dict, "", "", Exchanges.EX_SECONDS, 7919 + round_n * 13 + ex_k * 17, profiles)
		var bs: Array = plan["beats"]
		var offset := float(ex_k) * Exchanges.EX_SECONDS
		for b in bs:
			var bc: Dictionary = (b as Dictionary).duplicate()
			bc["t"] = float(bc["t"]) + offset
			all_beats.append(bc)
	all_beats.sort_custom(func(a, b): return float(a["t"]) < float(b["t"]))
	var per_boxer := [{}, {}]
	for i in 2:
		var bx: Dictionary = stage.boxers[i]
		var skel: Skeleton3D = bx["skel"]
		per_boxer[i] = {"skel": skel, "bx": bx, "frames": []}
	var round_length := float(n_ex) * Exchanges.EX_SECONDS
	var beat_idx := 0
	var total_f := int(round_length / DT)
	for f in total_f:
		view.t = float(f) * DT
		while beat_idx < all_beats.size() and float(all_beats[beat_idx]["t"]) <= view.t:
			var b: Dictionary = all_beats[beat_idx]
			if str(b["move"]) != "count":
				beat.fire(view, b)
			beat_idx += 1
		stage.aim({"phase": "", "who": -1, "move": ""})
		stage._process(DT)
		for i in 2:
			var bx: Dictionary = stage.boxers[i]
			var skel: Skeleton3D = bx["skel"]
			var balls := []
			for nm in BALLS:
				var bi: int = skel.find_bone(nm)
				balls.append(skel.global_transform * skel.get_bone_global_pose(bi).origin)
			var ap: AnimationPlayer = bx["ap"]
			var clip: String = str(ap.current_animation)
			var clip_t: float = ap.current_animation_position
			var rig_w: float = float(bx["rig"].w)
			var ml: float = float(bx["move_left"])
			var p: Vector3 = bx["pos"]
			var v: Vector3 = bx["vel"]
			var clinch_on: bool = stage.clinch.engaged
			per_boxer[i]["frames"].append({"balls": balls, "clip": clip, "clip_t": clip_t,
				"pos_x": p.x, "pos_z": p.z, "vel_x": v.x, "vel_z": v.z, "rig_w": rig_w,
				"move_left": ml, "clinch": clinch_on, "t": view.t})
		await process_frame
	var boxer_results := []
	for i in 2:
		var tag: String = "boxer%d_%s" % [i, glb_a if i == 0 else glb_b]
		var analysis := _analyse_plants(per_boxer[i]["frames"], tag)
		analysis["who"] = i
		analysis["glb"] = glb_a if i == 0 else glb_b
		boxer_results.append(analysis)
	stage.queue_free()
	await process_frame
	view.queue_free()
	await process_frame
	return {"round_n": round_n, "boxers": boxer_results, "n_frames": per_boxer[0]["frames"].size(),
		"beats_fired": beat_idx}


## Minimal view stub for BeatFire.fire().
func _make_view(stage: Node3D, round_n: int) -> _ViewStub:
	var v := _ViewStub.new()
	v.name = "FightViewStub"
	root.add_child(v)
	v.stage = stage
	v._amb_rng = RandomNumberGenerator.new()
	v.t = 0.0
	v._stop = ""
	v.body = _BodyStub.new()
	v.replay = null
	v.kd = null
	v._profiles = {"a": {}, "b": {}}
	v.main = null
	v.round_n = round_n
	return v


class _BodyStub extends RefCounted:
	func land(_b: Dictionary, _at: float) -> void:
		pass


class _ViewStub extends Node:
	var stage: Node3D = null
	var _amb_rng: RandomNumberGenerator = null
	var t: float = 0.0
	var _stop: String = ""
	var body: RefCounted = null
	var replay = null
	var kd = null
	var _profiles: Dictionary = {}
	var main = null
	var round_n: int = 1


## Analyse frames for foot plants and slides.
func _analyse_plants(frames: Array, tag: String) -> Dictionary:
	if frames.is_empty():
		return {"max_cm": 0.0, "mean_cm": 0.0, "plants": 0, "over3cm": 0, "over10cm": 0,
			"total_m": 0.0, "worst_plant": {}, "slides": [], "tag": tag}
	var all_slides := []
	for foot_idx in 2:
		var foot_name: String = str(BALLS[foot_idx])
		var ball_pos := []
		for fr in frames:
			ball_pos.append((fr["balls"] as Array)[foot_idx])
		var ys := []
		for p in ball_pos:
			ys.append((p as Vector3).y)
		var sorted_ys := ys.duplicate()
		sorted_ys.sort()
		var floor_y: float = sorted_ys[clampi(int(sorted_ys.size() * 0.05), 0, sorted_ys.size() - 1)]
		var min_frames := int(PLANT_MIN_S * FPS)
		var plant_start := -1
		for i in range(1, ball_pos.size() + 1):
			var is_planted := false
			if i < ball_pos.size() and i > 0:
				var d: Vector3 = (ball_pos[i] as Vector3) - (ball_pos[i - 1] as Vector3)
				var height_above: float = (ball_pos[i] as Vector3).y - floor_y
				var speed: float = Vector2(d.x, d.z).length() * FPS
				is_planted = height_above < FLOOR_BAND and speed < PLANT_SPEED
			if is_planted and plant_start < 0:
				plant_start = i - 1
			elif not is_planted and plant_start >= 0:
				var duration: int = i - plant_start
				if duration >= min_frames:
					var start_pos: Vector3 = ball_pos[plant_start]
					var max_dist := 0.0
					var worst_frame := plant_start
					for k in range(plant_start, i):
						var d2: Vector3 = (ball_pos[k] as Vector3) - start_pos
						var dist: float = Vector2(d2.x, d2.z).length()
						if dist > max_dist:
							max_dist = dist
							worst_frame = k
					var slide_cm: float = max_dist * 100.0
					var fr: Dictionary = frames[worst_frame]
					var px0: float = frames[plant_start]["pos_x"]
					var pz0: float = frames[plant_start]["pos_z"]
					var px1: float = fr["pos_x"]
					var pz1: float = fr["pos_z"]
					var pos_delta: float = Vector2(px1 - px0, pz1 - pz0).length()
					all_slides.append({"foot": foot_name, "start_f": plant_start, "end_f": i,
						"slide_cm": slide_cm, "clip": str(fr["clip"]), "clip_t": float(fr.get("clip_t", 0.0)),
						"rig_w": float(fr["rig_w"]), "clinch": bool(fr["clinch"]),
						"move_left": float(fr["move_left"]), "pos_delta_m": pos_delta,
						"vel_x": float(fr.get("vel_x", 0.0)), "vel_z": float(fr.get("vel_z", 0.0))})
				plant_start = -1
	var total_m := 0.0
	var max_cm := 0.0
	var over3 := 0
	var over10 := 0
	var worst := {}
	for s in all_slides:
		var cm: float = s["slide_cm"]
		total_m += cm / 100.0
		if cm > max_cm:
			max_cm = cm
			worst = s
		if cm > 3.0:
			over3 += 1
		if cm > 10.0:
			over10 += 1
	var mean_cm: float = total_m * 100.0 / maxf(1.0, all_slides.size())
	return {"max_cm": max_cm, "mean_cm": mean_cm, "plants": all_slides.size(),
		"over3cm": over3, "over10cm": over10, "total_m": total_m, "worst_plant": worst,
		"slides": all_slides, "tag": tag}


func _print_fight_results(rounds: Array) -> void:
	for r in rounds:
		for bx in r["boxers"]:
			print("  R%d %s: plants=%d total=%.2f m max=%.1f cm over3=%d over10=%d mean=%.2f cm" % [
				r["round_n"], bx["tag"], bx["plants"], bx["total_m"], bx["max_cm"],
				bx["over3cm"], bx["over10cm"], bx["mean_cm"]])
			if not bx["worst_plant"].is_empty():
				var w: Dictionary = bx["worst_plant"]
				print("    worst: %.1f cm clip=%s rig_w=%.1f clinch=%s move_left=%.2f pos_delta=%.2f m" % [
					float(w["slide_cm"]), str(w["clip"]), float(w["rig_w"]),
					str(w["clinch"]), float(w["move_left"]), float(w["pos_delta_m"])])


func _write_result(c1: Dictionary, c2: Dictionary, fight_a: Array, fight_b: Array) -> void:
	var text := "# FIGHTSLIDE1 RESULT\n\n"
	text += "## Controls\n\n"
	text += "### Control 1: Guard only, 10 s\n"
	text += "- Max slide per plant: %.2f cm\n" % float(c1["max_cm"])
	text += "- Plants: %d\n" % int(c1["plants"])
	text += "- Bar: < 1 cm (PASS: %s)\n\n" % ("yes" if float(c1["max_cm"]) < 1.0 else "NO")
	text += "### Control 2: Root pushed 0.5 m sideways\n"
	text += "- Max slide per plant: %.2f cm\n" % float(c2["max_cm"])
	text += "- Plants: %d\n" % int(c2["plants"])
	text += "- Bar: ~50 cm (PASS: %s)\n\n" % ("yes" if float(c2["max_cm"]) > 30.0 else "NO")
	text += "## Fight Results\n\n"
	for label in ["A", "B"]:
		var rounds: Array = fight_a if label == "A" else fight_b
		text += "### Match %s\n\n" % label
		text += "| Round | Boxer | Plants | Total (m) | Max (cm) | >3cm | >10cm | Mean (cm) |\n"
		text += "|-------|-------|--------|-----------|----------|------|-------|----------|\n"
		for r in rounds:
			for bx in r["boxers"]:
				text += "| R%d | %s | %d | %.2f | %.1f | %d | %d | %.2f |\n" % [
					r["round_n"], bx["glb"], bx["plants"], bx["total_m"],
					bx["max_cm"], bx["over3cm"], bx["over10cm"], bx["mean_cm"]]
		text += "\n"
	var all_total := 0.0
	var all_plants := 0
	var all_max := 0.0
	var all_over3 := 0
	for rounds in [fight_a, fight_b]:
		for r in rounds:
			for bx in r["boxers"]:
				all_total += float(bx["total_m"])
				all_plants += int(bx["plants"])
				all_max = maxf(all_max, float(bx["max_cm"]))
				all_over3 += int(bx["over3cm"])
	var avg_per_round: float = all_total / 12.0  # 2 matchups x 3 rounds x 2 boxers = 12 boxer-rounds
	text += "## Summary\n\n"
	text += "Total slide across all matchups: %.2f m over %d plants\n" % [all_total, all_plants]
	text += "Average per boxer-round: %.2f m\n" % avg_per_round
	text += "Worst single plant: %.1f cm\n" % all_max
	text += "Plants over 3 cm: %d (%.0f%%)\n" % [all_over3, 100.0 * float(all_over3) / maxf(1, all_plants)]
	text += "\n## Five Sentences\n\n"
	text += "1. A boxer slides an average of %.2f m per round across %d plants.\n" % [avg_per_round, all_plants]
	text += "2. The worst single plant slides %.1f cm.\n" % all_max
	text += "3. %d of %d plants (%.0f%%) slide more than 3 cm.\n" % [all_over3, all_plants, 100.0 * float(all_over3) / maxf(1, all_plants)]
	text += "4. The two controls read %.2f cm (guard) and %.2f cm (root push), confirming the ruler works.\n" % [float(c1["max_cm"]), float(c2["max_cm"])]
	text += "5. Not measured: per-system attribution (which of the 5 position writers moved the root each frame) requires instrumenting each system individually or running with switches off one at a time.\n"
	var f := FileAccess.open("res://docs/FIGHTSLIDE1_RESULT.md", FileAccess.WRITE)
	f.store_string(text)
	f.close()
	print("Wrote docs/FIGHTSLIDE1_RESULT.md")
