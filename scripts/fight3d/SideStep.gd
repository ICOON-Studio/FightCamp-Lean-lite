extends RefCounted
## S306 side steps that stay (operator S305: "i can see sidestep but doesnt make sense since it returns back to the same
## point"). Every Pro dodge / weave is exported in place: the hips never move (tools/raw_hips.gd, even in the raw .res).
## tools/sidestep_probe.gd read the feet: a dodge steps the lead foot out, the trailing foot follows and both stand planted
## (pro_left_dodge ~0.73 s), then the clip walks both feet back to the start. So the dodge is cut where both feet first
## stand still after the step: her place on the canvas takes the step (the middle of the two feet's travel) and the guard
## joins from there (JoinSmoother.carry starts the hips where the viewer saw them). A weave rolls the head with the feet
## still: once it is back in guard she steps off the line toward the side she rolled with that side's dodge step, cut
## the same way (the game's short strafe slid her planted feet 2.3 m in 0.6 s, 4 m/s: tools/sidestep_probe.gd), so she
## ends at a new angle. Measured per boxer at setup (a southpaw's mirrored clips step the other way by themselves).
##   setup(stage)  arm(who, clip)  tick() -> commits; plan(who) for probes

const IdleMatch := preload("res://scripts/fight3d/IdleMatch.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")

const DODGES := ["pro_left_dodge", "pro_right_dodge"]
const WEAVES := ["pro_left_weave", "pro_right_weave", "pro_quick_weave"]
const HZ := 30.0
const FROM_S := 0.25        # the step is never done before this (clip time)
const GROUND_M := 0.03      # a foot within this of its guard height is down
const STILL_MPS := 0.8      # and this slow is planted (the source's planted feet drift ~0.6 m/s: pro_left_dodge 0.70-0.80 s)
const MIN_STEP_M := 0.08    # a smaller travel is not a step
const ROLL_MIN_M := 0.10    # a weave whose head moves less sideways than this steps nowhere

var stage: Node
var _plan: Array = []       # per boxer: clip -> {"cut": s, "d": Vector3 body frame unscaled} | {"cut": s, "then": dodge clip}
var _armed: Array = [{}, {}]


func setup(owner: Node) -> void:
	stage = owner
	_plan = []
	for bx in stage.boxers:
		_plan.append(measure(bx))


func plan(who: int) -> Dictionary:
	return _plan[who] if who < _plan.size() else {}


## The cut of each dodge and weave on boxer `bx` ({ap, skel, node}). Plays clips: call before the fight starts.
static func measure(bx: Dictionary) -> Dictionary:
	var ap: AnimationPlayer = bx["ap"]
	var idle := BeatClips.first(BeatClips.GUARD, ap.has_animation)
	var out := {}
	if idle == "":
		return out
	var l0 := IdleMatch.pose_point(bx, idle, 0.0, "LeftFoot")
	var r0 := IdleMatch.pose_point(bx, idle, 0.0, "RightFoot")
	for clip in DODGES:
		if not ap.has_animation(clip):
			continue
		var back := BeatClips.recovery(clip).y
		var end := back if back > 0.0 else ap.get_animation(clip).length
		var lp := l0
		var rp := r0
		var best := {}
		for k in range(int(FROM_S * HZ) - 1, int(end * HZ) + 1):
			var t := float(k) / HZ
			var l := IdleMatch.pose_point(bx, clip, t, "LeftFoot")
			var r := IdleMatch.pose_point(bx, clip, t, "RightFoot")
			var planted := l.y - l0.y < GROUND_M and r.y - r0.y < GROUND_M and (l - lp).length() * HZ < STILL_MPS \
				and (r - rp).length() * HZ < STILL_MPS
			lp = l
			rp = r
			if t < FROM_S:
				continue
			var dx := ((l.x - l0.x) + (r.x - r0.x)) * 0.5
			if planted and absf(dx) >= MIN_STEP_M:
				if best.is_empty() or absf(dx) > absf((best["d"] as Vector3).x):
					best = {"cut": t, "d": Vector3(dx, 0.0, 0.0)}
			elif not best.is_empty():
				break   # the first planted stance after the step, not the walk back
		if not best.is_empty():
			out[clip] = best
	for clip in WEAVES:
		var pk := BeatClips.peak(clip)
		var back := BeatClips.recovery(clip).y
		if not ap.has_animation(clip) or pk <= 0.0 or back <= 0.0:
			continue
		var hx := IdleMatch.pose_point(bx, clip, pk, "Head").x - IdleMatch.pose_point(bx, idle, 0.0, "Head").x
		if absf(hx) < ROLL_MIN_M:
			continue
		for dodge in DODGES:
			if out.has(dodge) and signf((out[dodge]["d"] as Vector3).x) == signf(hx):
				out[clip] = {"cut": back, "then": dodge}
	return out


## `clip` just started on boxer `who` (anything else disarms her).
func arm(who: int, clip: String) -> void:
	var p := plan(who)
	_armed[who] = {"clip": clip, "row": p[clip]} if p.has(clip) else {}


## Every frame, before the recovery cut: a dodge past its cut commits the step, a weave back in guard steps off.
func tick() -> void:
	for who in stage.boxers.size():
		var a: Dictionary = _armed[who]
		if a.is_empty():
			continue
		var bx: Dictionary = stage.boxers[who]
		var ap: AnimationPlayer = bx["ap"]
		if str(ap.current_animation) != str(a["clip"]):
			_armed[who] = {}
			continue
		var row: Dictionary = a["row"]
		if ap.current_animation_position < float(row["cut"]):
			continue
		_armed[who] = {}
		if row.has("then"):
			stage.play(who, str(row["then"]), BeatClips.speed(str(row["then"]), ""))
			continue
		var node: Node3D = bx["node"]
		var d: Vector3 = node.global_transform.basis * (row["d"] as Vector3)
		d.y = 0.0
		if bx.get("js") != null:
			(bx["js"] as Node).carry((bx["skel"] as Skeleton3D).global_transform)
		bx["pos"] = (bx["pos"] as Vector3) + d
		stage.guard(who)
