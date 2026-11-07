extends RefCounted
## Where both boxers stand each frame (split out of FightStage S322): each moves only by her own stepping velocity; both
## always face each other. S311: the gap is no longer held - it follows want_m (RangeBreath). A circling boxer keeps the
## distance she started at (a strafe round a point would open it); an aimed step in or out stops where it was aimed; nobody
## closes inside MIN_GAP_M. When the gap is outside its band, a boxer standing in her guard steps to it: the attacker lunges
## in, otherwise one steps out.
## S391: with the footwork rig on, `pos` is where the fight says she stands; RingFeet moves her feet there and she is shown
## over them (RingFeet.shown).
##   compose(stage, delta)

const RingFeet := preload("res://scripts/fight3d/RingFeet.gd")

## S320 a glide step's speed eases in and out over this (Footwork.glide).
const STEP_RAMP_S := 0.07
## S311: nobody closes inside this pelvis gap (gloves in guard would meet).
const MIN_GAP_M := 0.62
## S314: in an inside spell the heads pass each other's shoulder (Footwork.offset), so they may close to this.
const INSIDE_FLOOR_M := 0.6   # S392: 0.48 sat under the 0.64 inside range (RangeBreath) and let the chests in
## S392 (two blind judges: "they walk through each other", chests merged, lead boots jammed; ring_feet_probe men: inside range shown
## down to 0.35 m, chests 0.23 m apart, though the fight's place held 0.58): the floors above guard `pos`, not the body as shown,
## and the feet's lag and a lunge carried it through. Shown bodies keep this far apart, each giving half; a lunge stops here too.
## `-- nobodykeep` = the control arm.
const BODY_KEEP_M := 0.6
static var body_keep: bool = not OS.get_cmdline_user_args().has("nobodykeep")
## S393 (two blind judges: "her face stays sunk in the other's torso"; fold_probe: 111 of 123 sunk frames were the gut-shot
## reactions): a boxer folding over a body shot needs room, or her head goes into the other's trunk. While one folds, the
## bodies keep this much further apart. `-- nofoldroom` = the control arm.
const FOLD_ROOM_M := 0.22
static var fold_room: bool = not OS.get_cmdline_user_args().has("nofoldroom")
## S311: the pair's middle stays this far inside the ropes (was 0.9: nobody ever reached them), and a boxer's pelvis
## at least ROPE_LEAN_M (backed onto the ropes she leans on them).
const MID_IN_M := 0.55
const ROPE_LEAN_M := 0.06
## S306: the turn to face her opponent eases over this (a committed side step turned both bodies ~10 degrees in one frame).
const FACE_S := 0.08


static func compose(st: Node, delta: float) -> void:
	var boxers: Array = st.boxers
	var feet: RefCounted = st.feet
	for i in boxers.size():
		var bx: Dictionary = boxers[i]
		if float(bx["move_left"]) > 0.0:
			# S320 glide steps: the body eases into and out of its step speed (no clip carries it any more).
			var ramp := 1.0
			if feet.glide:
				var el := float(bx.get("move_total", 0.0)) - float(bx["move_left"])
				ramp = clampf(minf(el, float(bx["move_left"])) / STEP_RAMP_S, 0.25, 1.0)
			bx["pos"] = (bx["pos"] as Vector3) + (bx["vel"] as Vector3) * delta * ramp
			bx["move_left"] = float(bx["move_left"]) - delta
			if float(bx["move_left"]) <= 0.0:
				feet.stop(i)
		elif float(bx.get("step_grace", 0.0)) > 0.0:
			# S316: a finished step's clip slows while it waits for the next step; none came - back to the guard.
			var ap: AnimationPlayer = bx["ap"]
			ap.speed_scale = move_toward(ap.speed_scale, feet.GRACE_SPEED, delta * 4.0)
			bx["step_grace"] = float(bx["step_grace"]) - delta
			if float(bx["step_grace"]) <= 0.0 and feet.STRIDE.has(str(ap.current_animation)):
				st.guard(i)
	var a: Vector3 = boxers[0]["pos"]
	var b: Vector3 = boxers[1]["pos"]
	var dist := a.distance_to(b)
	var axis := (b - a).normalized() if dist > 0.01 else Vector3.BACK
	var moving := [float(boxers[0]["move_left"]) > 0.0, float(boxers[1]["move_left"]) > 0.0]
	var pin := [moving[0] and float(boxers[0]["hold_m"]) > 0.0, moving[1] and float(boxers[1]["hold_m"]) > 0.0]
	if (moving[0] and float(boxers[0]["aim_dir"]) != 0.0) or (moving[1] and float(boxers[1]["aim_dir"]) != 0.0):
		pin = [false, false]    # an aimed step changes the range; a circle beside it does not hold it
	var keep := dist
	if pin[0] or pin[1]:
		keep = float(boxers[0 if pin[0] else 1]["hold_m"])
	keep = maxf(keep, st.clinch.floor_m(lerpf(MIN_GAP_M, INSIDE_FLOOR_M, feet.inside_w)))
	if absf(dist - keep) > 0.001:
		var err := dist - keep
		var share := [0.5, 0.5] if pin[0] == pin[1] else ([1.0, 0.0] if pin[0] else [0.0, 1.0])
		boxers[0]["pos"] = a + axis * err * float(share[0])
		boxers[1]["pos"] = b - axis * err * float(share[1])
	for i in boxers.size():
		var bx: Dictionary = boxers[i]
		if moving[i] and float(bx["aim_dir"]) != 0.0 and (keep - float(bx["aim_m"])) * float(bx["aim_dir"]) <= 0.0:
			feet.stop(i)
	if delta > 0.0:
		feet.aim_step(keep, a.length() > b.length())
		feet.rhythm(delta, keep)
	_place(st, delta)


## Keeps the pair inside the ropes and puts each body where it is shown (lunge, clinch, inside offsets), facing the other.
## S392 where `me` is shown when she stands closer to `other` than `keep_m`: she gives half of what is missing, straight back
## (the other gives the other half on her own turn). It grows from 0 with the shortfall, so nothing pops.
static func kept(me: Vector3, other: Vector3, keep_m: float) -> Vector3:
	var away := Vector3(me.x - other.x, 0.0, me.z - other.z)
	var short := keep_m - away.length()
	if short <= 0.0 or away.length() < 0.001:
		return me
	return me + away.normalized() * short * 0.5


static func _fold(bx: Dictionary) -> float:
	return float(bx["snap"].fold_w()) if bx.get("snap") != null else 0.0


## S393 the extra keep for the pair, from how far each is folded (0..1).
static func room(fold_a: float, fold_b: float) -> float:
	return FOLD_ROOM_M * clampf(maxf(fold_a, fold_b), 0.0, 1.0) if fold_room else 0.0


## S392 a lunge carries her in only as far as `keep_m` from the other. `dist` = the gap before it.
static func lunge_room(lunge_m: float, dist: float, keep_m: float) -> float:
	return clampf(lunge_m, 0.0, maxf(dist - keep_m, 0.0))


static func _place(st: Node, delta: float) -> void:
	var boxers: Array = st.boxers
	var feet: RefCounted = st.feet
	var ring: float = st.RING_M
	var a: Vector3 = boxers[0]["pos"]
	var b: Vector3 = boxers[1]["pos"]
	var mid := (a + b) * 0.5
	var limit := ring * 0.5 - MID_IN_M
	var shift := Vector3(clampf(mid.x, -limit, limit) - mid.x, 0, clampf(mid.z, -limit, limit) - mid.z)
	# S311: each boxer may reach the ropes (her pelvis ROPE_LEAN_M inside them: her hips lean on the middle rope, which
	# bows - RingRopes), never through them.
	var edge := ring * 0.5 - ROPE_LEAN_M
	for i in boxers.size():
		var bx: Dictionary = boxers[i]
		var at: Vector3 = (bx["pos"] as Vector3) + shift
		bx["pos"] = Vector3(clampf(at.x, -edge, edge), at.y, clampf(at.z, -edge, edge))
		RingFeet.tick(st, i, delta)
		var me := RingFeet.shown(st, bx)
		var other := RingFeet.shown(st, boxers[1 - i])
		var n: Node3D = bx["node"]
		var keep_m: float = st.clinch.floor_m(BODY_KEEP_M + room(_fold(bx), _fold(boxers[1 - i]))) if body_keep else 0.0
		me = kept(me, other, keep_m)
		var to := other - me
		# S302: a landed punch carries her in (shown only; her place on the canvas stays).
		var pr: Node = bx.get("reach")
		var lunge := lunge_room(float(pr.lunge()), to.length(), keep_m) if pr != null else 0.0
		# S392: the rig's feet already stand off the line (RingFeet.tick); only a body the rig has let go of takes the shift here.
		var side: Vector3 = feet.offset(to) * (1.0 - float(bx["rig"].w) if RingFeet.on(st, bx) else 1.0)
		n.position = me + (to.normalized() * lunge if to.length() > 0.01 else Vector3.ZERO) + st.clinch.offset(i, to) + side
		if bx.get("snap") != null:
			bx["snap"].sway = feet.inside_w   # S315 small head sways inside
		if bx.get("tuck") != null and not st._no_inguard:
			bx["tuck"].inner = feet.inside_w   # S315 the inside guard: elbows on the ribs, gloves at the cheeks
		# S399: a captured step clip (RkLoco) carries her in its own frame - she turns to face once it is done, not mid-step
		if to.length() > 0.01 and not str((bx["ap"] as AnimationPlayer).current_animation).begins_with("rk_loc_"):
			var yaw := atan2(to.x, to.z)
			n.rotation = Vector3(0.0, yaw if delta <= 0.0 else lerp_angle(n.rotation.y, yaw, 1.0 - exp(-delta / FACE_S)), 0.0)
