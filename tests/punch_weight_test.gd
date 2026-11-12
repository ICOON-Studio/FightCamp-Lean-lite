extends SceneTree
## POWER1 (owner S439: "the torso needs to follow the hands movemnt to show thepower behind the shot", "the punches do not
## feellike the y have power"). The ruler: does the body go into the punch, on the clips the game loads, as the stage
## plays them (FightStage.play / land, two DIFFERENT bodies - the second a southpaw, whose clips play mirrored - the
## footwork rig on as in the fight)?
##   HIPS     the drawn hips' travel toward the other boxer by the punch's contact, read as how far further they stand
##            over her planted feet than in the control arm (today's pinned hips: no travel). A punch thrown (not
##            landed) carries the hips as far as its own source file does (forward kinematics on the baked clip's keys
##            over this body's rest - the clip as captured, before FightClips pins its hips): within SRC_LOW_M under and
##            SRC_HIGH_M over that. A landed cross or hook carries them into a shipped game's body-travel band for its
##            long-range and power takes, 0.07-0.16 m (ops/research/REFERENCE_DISTANCES_S439.md, Undisputed R2 / power).
##   FEET     each standing foot's travel on the canvas over the punch: never more than the control arm's (today's code,
##            `PunchWeight.on = false` in the same run) plus SLIDE_PAD_M.
##   GAP      the pair's place (bx.pos) and the shown bodies after the punch: the same gap as before, within GAP_M.
##   HEEL     a landed cross lifts the rear heel: at contact the rear ankle stands at least HEEL_M over its standing
##            height (half the 6.1 cm the library's own rear uppercut lifts it, CROSS_POWER_S439.md).
## The fight's own range steps are paused (Footwork._pause) so only the punch moves anyone.
## Run: <godot> --headless --fixed-fps 30 --audio-driver Dummy --path . --script res://tests/punch_weight_test.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const WEIGHT_PATH := "res://scripts/fight3d/PunchWeight.gd"
const DT := 1.0 / 30.0
const SRC_LOW_M := 0.02
const SRC_HIGH_M := 0.03
const BAND := Vector2(0.07, 0.16)
const SLIDE_PAD_M := 0.005
const GAP_M := 0.02
const HEEL_M := 0.03
const LOW_M := 0.015
## [boxer, clip, beat move, landed]
const CASES := [
	[0, "pro_left_jab", "jab", false], [1, "pro_right_cross", "cross", false], [0, "pro_right_cross_c", "cross", false],
	[1, "pro_right_uppercut", "rear_uppercut", false], [0, "pro_left_hook", "lead_hook", false],
	[1, "pro_right_cross", "cross", true], [0, "pro_right_cross_a", "cross", true], [1, "pro_right_cross_b", "cross", true],
	[0, "pro_right_cross_c", "cross", true], [1, "pro_left_hook", "lead_hook", true], [0, "pro_right_hook", "rear_hook", true],
]
const FEET := [["LeftToes", "LeftFoot"], ["RightToes", "RightFoot"]]

var failures := 0
var stage: Node3D
var seen: Array = [{}, {}]
var floor_y: Array = []
var weight: GDScript = null


func _initialize() -> void:
	if not OS.get_cmdline_args().has("--fixed-fps"):
		Engine.max_fps = 30
	if ResourceLoader.exists(WEIGHT_PATH):
		weight = load(WEIGHT_PATH)
	stage = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_02.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_03.glb", "corner": "blue", "stance": "southpaw"})   # her clips play mirrored
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	for i in 2:
		var bx: Dictionary = stage.boxers[i]
		var skel: Skeleton3D = bx["skel"]
		var sc: float = (bx["node"] as Node3D).scale.x
		var fl: Array = []
		for foot in FEET:
			fl.append([skel.get_bone_global_rest(skel.find_bone(foot[0])).origin.y * sc, skel.get_bone_global_rest(skel.find_bone(foot[1])).origin.y * sc])
		floor_y.append(fl)
		skel.skeleton_updated.connect(_shown.bind(i))
	await _frames(1.5)
	_check(bool(stage.feet.rig_on), "the footwork rig is on (as in the fight)")
	print("PUNCH_WEIGHT the layer is %s" % ("there" if weight != null else "MISSING (today's code: both arms are the same)"))
	for c in CASES:
		var who := int(c[0])
		var clip := str(c[1])
		if not (stage.boxers[who]["ap"] as AnimationPlayer).has_animation(clip):
			_check(false, "%s is in the library" % clip)
			continue
		var src := _source_fwd(who, clip)
		var off := await _throw(who, clip, str(c[2]), bool(c[3]), false)
		var on := await _throw(who, clip, str(c[2]), bool(c[3]), true)
		var name := "boxer %d %s%s" % [who, clip, " LANDED" if bool(c[3]) else ""]
		print("PUNCH_WEIGHT %s | source hips %+.3f m by contact | hips to target: off %+.3f on %+.3f m | head off %+.3f on %+.3f | feet slid off %.3f on %.3f m | gap change off %+.3f/%+.3f on %+.3f/%+.3f m (place/shown) | rear heel up off %.3f on %.3f m | hips over feet at contact off %+.3f on %+.3f" % [
			name, src, off["hips"], on["hips"], off["head"], on["head"], off["slide"], on["slide"], off["gap"], off["gap_shown"], on["gap"], on["gap_shown"], off["heel"], on["heel"], off["over"], on["over"]])
		# The body's travel into the punch = how much further her hips stand over her planted feet at the contact than in
		# the control arm, whose hips are pinned (0 travel: CROSS_POWER_S439.md). Read against the feet, not the punch's
		# start: the guard's own weave and sway at the start move that reading 5-7 cm between two identical throws.
		var went := float(on["over"]) - float(off["over"])
		if bool(c[3]):
			_check(went >= BAND.x and went <= BAND.y, "%s: the hips carry %.3f m into the punch by contact (band %.2f-%.2f)" % [name, went, BAND.x, BAND.y])
			if clip.contains("cross"):
				_check(float(on["heel"]) >= HEEL_M, "%s: the rear heel is up %.3f m at contact (at least %.2f)" % [name, on["heel"], HEEL_M])
		else:
			_check(went >= src - SRC_LOW_M and went <= src + SRC_HIGH_M,
				"%s: the hips travel %.3f m by contact, as its source file does (%.3f, -%.2f/+%.2f)" % [name, went, src, SRC_LOW_M, SRC_HIGH_M])
		_check(float(on["slide"]) <= float(off["slide"]) + SLIDE_PAD_M, "%s: the standing feet slide %.3f m, no more than today (%.3f)" % [name, on["slide"], off["slide"]])
		_check(absf(float(on["gap"])) <= GAP_M and absf(float(on["gap_shown"])) <= GAP_M, "%s: the pair's gap is back where it was (%+.3f place, %+.3f shown)" % [name, on["gap"], on["gap_shown"]])
	print("PUNCH_WEIGHT_TEST failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## One punch from a set stance; returns {hips, head, slide, gap, gap_shown, heel}.
func _throw(who: int, clip: String, move: String, landed: bool, layer_on: bool) -> Dictionary:
	if weight != null:
		weight.set("on", layer_on)
	var o := 1 - who
	stage.aim({"phase": "pocket", "who": -1, "move": move})
	var a: Vector3 = stage.boxers[0]["pos"]
	var b: Vector3 = stage.boxers[1]["pos"]
	var mid := Vector3((a.x + b.x) * 0.5, 0.0, (a.z + b.z) * 0.5)
	var axis := Vector3(b.x - a.x, 0.0, b.z - a.z).normalized()
	stage.boxers[0]["pos"] = mid - axis * float(stage.feet.want_m) * 0.5
	stage.boxers[1]["pos"] = mid + axis * float(stage.feet.want_m) * 0.5
	for k in 2:
		stage.guard(k)
	await _frames(1.4)
	var bx: Dictionary = stage.boxers[who]
	var ap: AnimationPlayer = bx["ap"]
	var dir: Vector3 = (stage.boxers[o]["pos"] as Vector3) - (bx["pos"] as Vector3)
	dir.y = 0.0
	dir = dir.normalized()
	var gap0 := _gap()
	var shown0 := _shown_gap()
	var hips0: Vector3 = seen[who]["Hips"]
	var head0: Vector3 = seen[who]["Head"]
	var rear := 1 if not bool(bx.get("south", false)) else 0
	var sp := BeatClips.speed(clip, move)
	var contact := BeatClips.contact(clip, 0.4)
	stage.play(who, clip, sp)
	if landed:
		stage.land(who, clip, false, contact / sp, contact)
	var out := {"hips": 0.0, "head": 0.0, "slide": 0.0, "heel": 0.0, "over": 0.0}
	var prev: Array = [seen[who][FEET[0][0]], seen[who][FEET[1][0]]]
	var hit := false
	var frames := 0
	while frames < 200 and str(ap.assigned_animation) == clip:
		await _frames(DT)
		frames += 1
		_slide(who, prev, out)
		var t := ap.current_animation_position
		if not hit and t >= contact:
			hit = true
			out["hips"] = ((seen[who]["Hips"] as Vector3) - hips0).dot(dir)
			var feet_mid: Vector3 = ((seen[who][FEET[0][0]] as Vector3) + (seen[who][FEET[1][0]] as Vector3)) * 0.5
			out["over"] = ((seen[who]["Hips"] as Vector3) - feet_mid).dot(dir)
			out["heel"] = (seen[who][FEET[rear][1]] as Vector3).y - float(floor_y[who][rear][1])
			out["head"] = ((seen[who]["Head"] as Vector3) - head0).dot(dir)
	for f in 30:   # back in her guard
		await _frames(DT)
		_slide(who, prev, out)
	out["gap"] = _gap() - gap0
	out["gap_shown"] = _shown_gap() - shown0
	return out


func _slide(who: int, prev: Array, out: Dictionary) -> void:
	for k in 2:
		var ball: Vector3 = seen[who][FEET[k][0]]
		var was: Vector3 = prev[k]
		if ball.y - float(floor_y[who][k][0]) < LOW_M and was.y - float(floor_y[who][k][0]) < LOW_M:
			out["slide"] = float(out["slide"]) + Vector2(ball.x - was.x, ball.z - was.z).length()
		prev[k] = ball


## The hips' forward travel by contact in the clip's SOURCE file (before FightClips pins them), on boxer i's body.
func _source_fwd(i: int, clip: String) -> float:
	var stem := ""
	for s in FightClips.pro_stems():
		if FightClips.pro_name(str(s)) == clip:
			stem = str(s)
	var anim: Animation = load(FightClips.BAKED_DIR + stem + ".res")
	var skel: Skeleton3D = stage.boxers[i]["skel"]
	var hips := skel.find_bone("Hips")
	var tr := -1
	for t in anim.get_track_count():
		if anim.track_get_type(t) == Animation.TYPE_POSITION_3D and str(anim.track_get_path(t)).get_slice(":", 1) == "Hips":
			tr = t
	if tr < 0:
		return 0.0
	var p := skel.get_bone_parent(hips)
	var to_skel: Basis = skel.get_bone_global_rest(p).basis if p >= 0 else Basis.IDENTITY
	var d: Vector3 = anim.position_track_interpolate(tr, BeatClips.contact(clip, 0.4)) - anim.position_track_interpolate(tr, 0.0)
	return (to_skel * d).z * (stage.boxers[i]["node"] as Node3D).scale.x   # skeleton +Z = her front


func _gap() -> float:
	var a: Vector3 = stage.boxers[0]["pos"]
	var b: Vector3 = stage.boxers[1]["pos"]
	return Vector2(a.x - b.x, a.z - b.z).length()


func _shown_gap() -> float:
	var a: Vector3 = (stage.boxers[0]["node"] as Node3D).position
	var b: Vector3 = (stage.boxers[1]["node"] as Node3D).position
	return Vector2(a.x - b.x, a.z - b.z).length()


func _shown(i: int) -> void:
	var skel: Skeleton3D = stage.boxers[i]["skel"]
	var xf := skel.global_transform
	for b in ["Hips", "Head", "LeftToes", "LeftFoot", "RightToes", "RightFoot"]:
		seen[i][b] = xf * skel.get_bone_global_pose(skel.find_bone(str(b))).origin


func _frames(secs: float) -> void:
	for f in maxi(1, int(round(secs / DT))):
		stage.feet._pause = [1e9, 1e9]   # no range steps: only the punch moves anyone
		stage._process(DT)
		await process_frame


func _check(ok: bool, what: String) -> void:
	print("  %s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1
