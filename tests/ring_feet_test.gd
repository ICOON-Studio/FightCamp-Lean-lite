extends SceneTree
## S391 the footwork rig in the ring (RingFeet.gd) on a real boxer, driven frame by frame through FightStage._process:
## a stage that only poses stills never takes the rig; at rest and at punching range she steps; the body rides on the feet and
## stays near her place; a planted ball holds the canvas; feet never cross; falls, the clinch, the win and scenes hand the legs
## back (the rig lets go in under 0.3 s and shows her at her place); a director's walk arrives on its mark in her guard, no af_walk.

const RkClips := preload("res://scripts/fight3d/RkClips.gd")
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const RingFeet := preload("res://scripts/fight3d/RingFeet.gd")
const DT := 1.0 / 30.0

var failures := 0
var stage: Node3D


func _initialize() -> void:
	stage = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(stage)
	await process_frame
	# S399: the rig on the Punch PRO guard - the captured Rokoko guard owns her legs (tests/rokoko_clips_test.gd)
	RkClips.enabled = false
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_01.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_02.glb", "corner": "blue", "stance": "southpaw"})
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	var bx: Array = stage.boxers
	_check(bx[0].get("rig") != null and bx[1].get("rig") != null, "both boxers carry the rig")
	for k in 4:
		await process_frame
	_check(float(bx[0]["rig"].w) == 0.0, "a stage nobody plays (stills) leaves the rig let go")
	await _phase("rest", 8.0)
	await _phase("pocket", 6.0)
	await _drawn_feet()
	await _free_clip()
	await _clinch()
	await _scene_walk()
	print("RING_FEET_TEST failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## `secs` in a range phase: steps go in, planted balls hold, the feet stay on their own sides, the body stays over them.
func _phase(ph: String, secs: float) -> void:
	var bx: Array = stage.boxers
	var pairs := [(bx[0]["rig"].plan.done_pairs as Array).size(), (bx[1]["rig"].plan.done_pairs as Array).size()]
	var slip := 0.0
	var cross := INF
	var off := 0.0
	var was: Array = [{}, {}]
	for f in int(secs / DT):
		stage.aim({"phase": ph, "who": -1, "move": "jab"})
		stage._process(DT)
		for i in 2:
			var plan: RefCounted = bx[i]["rig"].plan
			var rel: Vector2 = plan.unrot((plan.feet[0]["at"] as Vector2) - (plan.feet[1]["at"] as Vector2), float(plan.yaw))
			cross = minf(cross, rel.x * float(plan.side))
			var sh: Vector3 = RingFeet.shown(stage, bx[i])
			off = maxf(off, Vector2(sh.x - bx[i]["pos"].x, sh.z - bx[i]["pos"].z).length())
			for k in 2:
				var ft: Dictionary = plan.feet[k]
				if (ft["swing"] as Dictionary).is_empty() and was[i].has(k):
					slip = maxf(slip, (ft["at"] as Vector2).distance_to(was[i][k]))
				if (ft["swing"] as Dictionary).is_empty():
					was[i][k] = ft["at"]
				else:
					was[i].erase(k)
		await process_frame
	var d0: int = (bx[0]["rig"].plan.done_pairs as Array).size() - int(pairs[0])
	var d1: int = (bx[1]["rig"].plan.done_pairs as Array).size() - int(pairs[1])
	_check(float(bx[0]["rig"].w) >= 1.0, "%s: the rig has her legs" % ph)
	_check(d0 >= int(secs) / 2 and d1 >= int(secs) / 2, "%s: both step (%d, %d pairs in %.0f s)" % [ph, d0, d1, secs])
	_check(slip < 0.001, "%s: a planted ball holds the canvas (%.4f m)" % [ph, slip])
	_check(cross > 0.1, "%s: feet stay on their own sides (%.2f m)" % [ph, cross])
	_check(off < 0.75, "%s: shown within a lunge of her place (%.2f m)" % [ph, off])


## On the drawn skeleton (after every modifier), orthodox and southpaw: each ball stands where the plan puts it, the plan's lead
## foot is the left leg on an orthodox and the right on a southpaw.
func _drawn_feet() -> void:
	var worst := [-1.0, -1.0]   # stays negative if no frame was read
	for i in 2:
		var bx: Dictionary = stage.boxers[i]
		var skel: Skeleton3D = bx["skel"]
		var read := func() -> void:
			var plan: RefCounted = bx["rig"].plan
			var legs := ["LeftToes", "RightToes"] if float(plan.side) > 0.0 else ["RightToes", "LeftToes"]
			for k in 2:
				var at: Vector3 = skel.global_transform * skel.get_bone_global_pose(skel.find_bone(legs[k])).origin
				if (plan.feet[k]["swing"] as Dictionary).is_empty():
					worst[i] = maxf(float(worst[i]), Vector2(at.x, at.z).distance_to(plan.feet[k]["at"]))
		skel.skeleton_updated.connect(read)
		await _frames(1.5)
		skel.skeleton_updated.disconnect(read)
	_check(float(worst[0]) >= 0.0 and float(worst[0]) < 0.03, "orthodox: the drawn balls stand on the plan (%.3f m)" % float(worst[0]))
	_check(float(worst[1]) >= 0.0 and float(worst[1]) < 0.03, "southpaw: the drawn balls stand on the plan (%.3f m)" % float(worst[1]))


func _free_clip() -> void:
	var bx: Dictionary = stage.boxers[0]
	var ap: AnimationPlayer = bx["ap"]
	for clip in ["pro_knockout_v1", "pro_win_v1"]:
		_check(ap.has_animation(clip), "%s exists" % clip)
		ap.play(clip)
		await _frames(0.3)
		_check(float(bx["rig"].w) <= 0.0, "%s plays free (rig w %.2f)" % [clip, float(bx["rig"].w)])
		var sh: Vector3 = RingFeet.shown(stage, bx)
		_check(sh.distance_to(bx["pos"]) < 0.001, "%s: shown at her place" % clip)
	stage.guard(0)
	await _frames(0.4)
	_check(float(bx["rig"].w) >= 1.0, "back in her guard the rig has her again")


func _clinch() -> void:
	var bx: Dictionary = stage.boxers[1]
	stage.clinch.engaged = true
	await _frames(0.3)
	_check(float(bx["rig"].w) <= 0.0, "the clinch plays free")
	stage.clinch.engaged = false
	await _frames(0.4)
	_check(float(bx["rig"].w) >= 1.0, "after the clinch the rig has her again")


func _scene_walk() -> void:
	var bx: Dictionary = stage.boxers[0]
	stage.scene_mode(true)
	await _frames(0.3)
	_check(float(bx["rig"].w) <= 0.0, "a scene takes the rig off")
	var n: Node3D = bx["node"]
	var to: Vector3 = n.position + Vector3(1.2, 0.0, 0.9)
	stage.guard(0)   # S407: as CornerCrew does. Without it a fidget still playing ends mid-walk and RingFeet.scene lets go of her legs.
	RingFeet.hold(stage, 0)
	var left := 900   # S405: a wait, not a bar: a loaded CI runner needs more frames for the same walk
	var done := false
	while left > 0 and not done:
		done = RingFeet.walking(bx, to, 0.7, DT)
		stage._process(DT)
		await process_frame
		left -= 1
	# S406: red on CI only, with 0 frames left while "on its mark" passes. These numbers say which half of RingFeet.arrived holds it.
	var mid_off: float = (Vector2(to.x, to.z) - bx["rig"].mid() - (bx["rig"].plan.centre() as Vector2)).length()
	var aim_off: float = Vector3(to.x - bx["walk_at"].x, 0.0, to.z - bx["walk_at"].z).length()
	_check(done, "a director's walk arrives (%d frames left; step in the air %s, feet %.3f m off, allowed %.3f; aim %.3f m off)" % [
		left, str(not (bx["rig"].plan.pair as Dictionary).is_empty()), mid_off, RingFeet.ARRIVE_M * 1.5, aim_off])
	_check(Vector2(n.position.x - to.x, n.position.z - to.z).length() < 0.06, "... on its mark")
	_check(str((bx["ap"] as AnimationPlayer).current_animation) != "af_walk", "... with no casual walk")
	stage.scene_mode(false)
	await _frames(0.3)
	_check(Vector2(n.position.x - to.x, n.position.z - to.z).length() < 0.4, "the fight takes her back where she stands")


func _frames(secs: float) -> void:
	for f in int(secs / DT):
		stage._process(DT)
		await process_frame


func _check(ok: bool, what: String) -> void:
	print("  %s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1
