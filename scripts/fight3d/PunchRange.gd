extends RefCounted
## S320 (operator: "some hits seem to register even when opponent is way to far"; tools/hit_gap_probe.gd before the fix:
## the striking glove 0.21 m off its target at contact (p50), 66 % of landed punches past 0.15 m, up to 0.98 m - punches
## landed from a 1.6 m gap). FightStage.land works out how much closer her body must be by the contact; this carries her
## in and records every landed contact's miss for the probe.
##   close_in(stage, who, m, at_s)   record(stage, who, hitter, move, cut)

## The fastest a step in with a punch carries her body, m/s (a step-jab covers ~0.5-0.7 m in ~0.25 s).
const STEP_IN_MAX := 3.0
const KEEP := 400


## Her body carries `m` closer by the contact `at_s` (an aimed step: no step clip, the punch plays on); a step away the
## other was taking stops - she is caught on the way out.
static func close_in(stage: Node, who: int, m: float, at_s: float) -> void:
	var bx: Dictionary = stage.boxers[who]
	var t := maxf(at_s, m / STEP_IN_MAX)
	var to: Vector3 = (stage.boxers[1 - who]["pos"] as Vector3) - (bx["pos"] as Vector3)
	to.y = 0.0
	if to.length() < 0.01:
		return
	bx["vel"] = to.normalized() * (m / t)
	bx["move_left"] = t
	bx["move_total"] = t
	bx["aim_m"] = to.length() - m
	bx["aim_dir"] = 1.0
	bx["hold_m"] = 0.0
	var other: Dictionary = stage.boxers[1 - who]
	if float(other["move_left"]) > 0.0 and float(other.get("aim_dir", 0.0)) < 0.0:
		other["move_left"] = 0.0


## At a landed contact: how far the striking glove is from where it lands (m), the pelvis gap and the range phase.
static func record(stage: Node, who: int, hitter: int, move: String, cut := false) -> void:
	var pr: Node = stage.boxers[hitter].get("reach")
	if pr == null or str(pr.get("_hand")) == "":
		return
	var g: Vector3 = stage.glove_front(hitter, str(pr.get("_hand")))
	var tp: Vector3 = stage.target_point(who, move.contains("body"))
	# The miss in the hitter's frame: + ahead = the glove went past the target, + left, + up.
	var basis: Basis = (stage.boxers[hitter]["node"] as Node3D).global_transform.basis.orthonormalized()
	var d: Vector3 = basis.inverse() * (g - tp)
	var gc: Node = stage.boxers[hitter].get("gclear")
	var gaps: Array = stage.hit_gaps
	gaps.append({"miss": g.distance_to(tp), "gap": stage._gap(), "move": move, "phase": stage.feet.phase(),
		"fwd": d.z, "side": d.x, "up": d.y, "w": float(pr.get("last_weight")), "cut": cut, "clip": str(pr.get("_clip")), "contact": float(pr.get("_contact")),
		"pos": (stage.boxers[hitter]["ap"] as AnimationPlayer).current_animation_position, "speed": (stage.boxers[hitter]["ap"] as AnimationPlayer).speed_scale, "push": int(gc.get("pushes")) if gc != null else -1})
	if gaps.size() > KEEP:
		gaps.pop_front()


## True when the hitter's punch is no longer on screen at its contact (its clip was replaced - the clinch took the pair,
## a reaction or another move started): hit_gap_probe found 3 of 35 landed punches arriving that way, the reach off.
## S321 punch_id: the play_id her punch started with (-1 = it never started: she was locked in a hit reaction); a later
## start - even of the same clip - means this punch was replaced. -2 = not checked.
static func cut_off(stage: Node, hitter: int, punch_id: int = -2) -> bool:
	if punch_id != -2 and punch_id != int(stage.boxers[hitter].get("play_id", 0)):
		return true
	var pr: Node = stage.boxers[hitter].get("reach")
	if pr == null:
		return false
	var clip := str(pr.get("_clip"))
	return clip == "" or str((stage.boxers[hitter]["ap"] as AnimationPlayer).assigned_animation) != clip
