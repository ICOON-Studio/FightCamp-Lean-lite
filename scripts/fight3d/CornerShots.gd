extends RefCounted
## S307 the corner minute's camera (docs/FIGHT_NIGHT_SCRIPT.md v2 "film look"): each shot of the shot list as a framing -
## {pos, look, fov, focus (metres, the sharp distance; 0 = broadcast lens), drift (metres the lens travels over the shot),
## track (true: re-framed every frame on moving bodies)}. Framed from where the bodies are when the shot starts, so the
## picture follows what the scene really did. Pure apart from reading bone positions; zero preloads.
##   frame(shot, ctx) -> Dictionary     ctx = {her, opp, coach, blue_coach, red, blue, cam}  (actors, corners, Camera3D)


static func frame(shot: String, ctx: Dictionary) -> Dictionary:
	var her: Dictionary = ctx["her"]
	var red: Dictionary = ctx["red"]
	var d: Vector3 = red["d"]
	var l: Vector3 = red["l"]
	var head := bone(her, "Head")
	var face := head + fwd(her) * 0.09 * _sc(her) + Vector3.UP * 0.03
	match shot:
		"part":
			# The bell: the broadcast lens pulls back and widens as they part.
			var cam: Camera3D = ctx["cam"]
			var mid := (pos(her) + pos(ctx["opp"])) * 0.5
			var away := Vector3(cam.position.x - mid.x, 0, cam.position.z - mid.z).normalized()
			return {"pos": cam.position, "look": mid + Vector3(0, 1.0, 0), "fov": 38.0, "focus": 0.0, "drift": away * 1.2 + Vector3.UP * 0.3}
		"behind":
			# From the ring's middle behind her, dollying in as she walks into her corner (the corner team waiting there).
			var seat: Vector3 = red["seat"]
			return {"pos": seat + d * 3.7 + l * 0.9 + Vector3.UP * 1.6, "look": seat + Vector3.UP * 0.85, "fov": 34.0, "focus": 3.2,
				"drift": -d * 0.9}
		"low_out":
			# Medium, low, from the ring in front of her left: she sits. S380 (operator on a still of the corner through the
			# ropes: "i thought you fixed the ropes, why old problems appear again?"): this shot stood 0.8 m OUTSIDE the
			# ropes ("the ropes in the foreground", S307) - the S347 rule is every lens inside them, the ropes only behind.
			var seat: Vector3 = red["seat"]
			var p := seat + d * 1.9 + l * 1.0 + Vector3.UP * 1.0
			# S396 (blind review: "crops her head off, only her torso and gloves"): the cut comes while she still stands, so
			# the lens aims between the seat and her face - her head stays in standing, she sits into the middle.
			var look := (Vector3(seat.x, 0.82, seat.z)).lerp(face, 0.5)
			return {"pos": p, "look": look, "fov": 30.0, "focus": p.distance_to(look), "drift": d * 0.18}
		"water":
			# Close insert from just left of straight on: the bottle at her lips, the coach's arm coming in from the far side
			# (S401: he is on the apron on her right; from further left the second filled the frame).
			var p := face + (Basis(Vector3.UP, 0.25) * d) * 0.85 + Vector3.UP * 0.02
			return {"pos": p, "look": face + Vector3.DOWN * 0.05, "fov": 28.0, "focus": p.distance_to(face), "drift": -l * 0.05}
		"ice":
			# Close insert from behind her left shoulder: the ice on the back of her neck.
			var neck := bone(her, "Neck")
			var p := neck + l * 0.62 - d * 0.12 + Vector3.UP * 0.16
			return {"pos": p, "look": neck, "fov": 30.0, "focus": p.distance_to(neck), "drift": d * 0.05}
		"ots":
			# Her face as she listens, from her front-right inside the ropes. S401: with the coach on the apron a lens over his
			# shoulder stands outside the ropes, and it held on his arm filling a third of the frame for 7 s.
			var p := face + (Basis(Vector3.UP, -0.5) * d) * 0.95 + Vector3.UP * 0.1
			return {"pos": p, "look": face, "fov": 30.0, "focus": p.distance_to(face), "drift": -l * 0.05}
		"side2":
			# Both in profile: the coach leaning over the rope, talking down to her on the stool. S401: square to the line between
			# their heads, on the ring side (from her front-left he stood straight behind her).
			var coach: Dictionary = ctx["coach"]
			var cf := bone(coach, "Head")
			var mid := (face + cf) * 0.5
			var across := Vector3(cf.x - face.x, 0, cf.z - face.z).normalized().cross(Vector3.UP)
			# Square alone runs along the rope and leaves the ring, so it is turned toward the ring's middle.
			var p := mid + ((across if across.dot(d) > 0.0 else -across) * 0.6 + d * 0.8).normalized() * 1.9 + Vector3.UP * 0.12
			return {"pos": p, "look": mid, "fov": 32.0, "focus": p.distance_to(mid), "drift": d * 0.12}
		"corner_wide":
			# The whole corner from the ring's middle: her on the stool, the coach in front, the second on the apron.
			var seat: Vector3 = red["seat"]
			var p := seat + d * 3.4 - l * 0.9 + Vector3.UP * 1.45
			var look := seat + d * 0.4 + Vector3.UP * 1.0   # S396: the second on the apron kept his head (was 0.8, fov 30)
			return {"pos": p, "look": look, "fov": 35.0, "focus": p.distance_to(look), "drift": -l * 0.25}
		"reverse":
			# The reverse: the coach as he speaks, from the ring's side, his head between the top two ropes. S401: over her
			# shoulder the lens left the ring with him on the apron and came back aimed at the crowd.
			var coach: Dictionary = ctx["coach"]
			var cf := bone(coach, "Head") + fwd(coach) * 0.09 + Vector3.UP * 0.03
			var p := cf + d * 1.3 + Vector3.UP * 0.02
			return {"pos": p, "look": cf, "fov": 30.0, "focus": p.distance_to(cf), "drift": l * 0.04}
		"cutman":
			# Close on her face from her front-right: the cutman's fingers on her far cheekbone.
			var p := face + (Basis(Vector3.UP, -0.5) * d) * 0.85 + Vector3.UP * 0.05
			return {"pos": p, "look": face, "fov": 28.0, "focus": p.distance_to(face), "drift": -l * 0.05}
		"other":
			# Cut-away: the other corner from across the ring, long lens, three-quarter on their coach and boxer.
			var blue: Dictionary = ctx["blue"]
			var bs: Vector3 = blue["seat"]
			var look := bs + (blue["d"] as Vector3) * 0.45 + Vector3.UP * 0.95
			var p := bs + ((blue["d"] as Vector3) + (blue["l"] as Vector3) * 0.8).normalized() * 4.6 + Vector3.UP * 1.45
			return {"pos": p, "look": look, "fov": 17.0, "focus": p.distance_to(look), "drift": (blue["l"] as Vector3) * 0.2}
		"push":
			# "Seconds out": a slow push in on her face as she stands.
			var p := face + d * 2.3 + Vector3.UP * 0.05
			return {"pos": p, "look": face, "fov": 30.0, "focus": 1.9, "drift": -d * 0.8, "track": true}
	return {}


## S350 C197: the look point that puts `look` at screen x (0 = left edge, 0.5 = centre) on a 16:9 frame, `fov` vertical -
## the corner card covers the right of the frame, so the shot pans until her face sits in the open part on the left.
static func frame_at(pos: Vector3, look: Vector3, fov: float, x: float) -> Vector3:
	var d := look - pos
	var right := d.cross(Vector3.UP)
	if right.length() < 1e-4:
		return look
	var half_w := tan(deg_to_rad(fov) * 0.5) * 16.0 / 9.0
	return look + right.normalized() * d.length() * half_w * (1.0 - 2.0 * x)


## S380 every corner lens inside the ropes (S347's rule; RingCamera.IN_M): a shot whose lens - at its start or at the end
## of its drift - is past HALF_M on either axis moves toward its look point until it is inside, and its fov widens by the
## distance it lost so the framing holds; a drift that would leave the ring is cut short. Returns the framing.
const HALF_M := 2.75 - 0.25   # FightStage.RING_M * 0.5, less a rope's reach

## S386 CORNERLENS1: the corner minute's lens never sits inside a body.
const KEEP_M := 0.45


## S386: collect Head/Neck/UpperChest/LeftShoulder/RightShoulder for every person near the lens.
static func body_points(ctx: Dictionary) -> Array:
	var pts: Array = []
	var bones := ["Head", "Neck", "UpperChest", "LeftShoulder", "RightShoulder"]
	for key in ["her", "coach", "blue_coach"]:
		if ctx.has(key) and ctx[key] != null:
			var actor: Dictionary = ctx[key]
			for b in bones:
				var bp: Vector3 = bone(actor, b)
				if bp != Vector3.INF:
					pts.append(bp)
	return pts


## S386 CORNERLENS1: if the lens pos (or pos + drift) is closer than KEEP_M to any body point, move the lens AWAY from
## that point along the look->pos line (back off from the look point) until every point is >= KEEP_M, staying inside the
## ropes. Narrow fov by the distance gained so the framing holds (inverse of inside()'s widen formula; clamp 15-70 deg).
## Update focus if > 0. If no position on that line satisfies both, keep the nearest-to-valid one and set blocked = true.
static func keep_out(fr: Dictionary, bodies: Array) -> Dictionary:
	if fr.is_empty() or not fr.has("pos") or bodies.is_empty():
		return fr
	var p: Vector3 = fr["pos"]
	var look: Vector3 = fr["look"]
	var dir := (p - look).normalized()
	if dir.length() < 0.01:
		return fr
	var d0 := p.distance_to(look)
	var move := 0.0
	for bp in bodies:
		var body_pt: Vector3 = bp
		var dist := p.distance_to(body_pt)
		if dist < KEEP_M:
			var need := KEEP_M - dist
			var away := (p - body_pt).normalized()
			var proj: float = away.dot(dir)
			if proj > 0.01:
				move = maxf(move, need / proj)
			else:
				move = maxf(move, need * 2.0)
	if move > 0.0:
		var new_p := p + dir * move
		var blocked := false
		if not _in(new_p):
			var q: Vector3 = p
			var found := false
			for i in 40:
				var t := float(i + 1) / 40.0
				var candidate := p.lerp(new_p, t)
				if not _in(candidate):
					q = p.lerp(new_p, float(i) / 40.0)
					blocked = true
					found = true
					break
			if not found:
				q = new_p
			fr["pos"] = q
		else:
			fr["pos"] = new_p
		if blocked:
			fr["blocked"] = true
		var final_p: Vector3 = fr["pos"]
		var d1 := final_p.distance_to(look)
		var fov0: float = float(fr.get("fov", 0.0))
		if fov0 > 0.0 and d1 > 0.2 and d0 > 0.01:
			var fov1 := rad_to_deg(2.0 * atan(tan(deg_to_rad(fov0) * 0.5) * d0 / d1))
			fr["fov"] = clampf(fov1, 15.0, 70.0)
		if float(fr.get("focus", 0.0)) > 0.0:
			fr["focus"] = d1
	var final_p: Vector3 = fr["pos"]
	var dr: Vector3 = fr.get("drift", Vector3.ZERO)
	for i in 10:
		if _in(final_p + dr) and _drift_clear(final_p + dr, bodies):
			break
		dr *= 0.6
	fr["drift"] = dr if (_in(final_p + dr) and _drift_clear(final_p + dr, bodies)) else Vector3.ZERO
	return fr


## S386: true if the drift end is >= KEEP_M from every body point.
static func _drift_clear(end_p: Vector3, bodies: Array) -> bool:
	for bp in bodies:
		if end_p.distance_to(bp) < KEEP_M:
			return false
	return true


static func _in(p: Vector3) -> bool:
	return absf(p.x) <= HALF_M and absf(p.z) <= HALF_M


static func inside(fr: Dictionary, bodies: Array = []) -> Dictionary:
	if fr.is_empty() or not fr.has("pos"):
		return fr
	var p: Vector3 = fr["pos"]
	var look: Vector3 = fr["look"]
	if not _in(p):
		var d0 := p.distance_to(look)
		var q := p
		for i in 40:   # walk toward the look point
			q = p.lerp(look, float(i + 1) / 40.0 * 0.9)
			if _in(q):
				break
		if d0 > 0.01 and float(fr.get("fov", 0.0)) > 0.0:
			fr["fov"] = minf(70.0, rad_to_deg(2.0 * atan(tan(deg_to_rad(float(fr["fov"])) * 0.5) * d0 / maxf(0.2, q.distance_to(look)))))
		if float(fr.get("focus", 0.0)) > 0.0:
			fr["focus"] = q.distance_to(look)
		fr["pos"] = q
		p = q
	var dr: Vector3 = fr.get("drift", Vector3.ZERO)
	for i in 10:
		if _in(p + dr):
			break
		dr *= 0.6
	fr["drift"] = dr if _in(p + dr) else Vector3.ZERO
	if not bodies.is_empty():
		fr = keep_out(fr, bodies)
	return fr


## A bone's world position on an actor ({skel}). The head as shown when the actor's CornerIK has turned it (S309: a look
## moves the head, and an outside read gets the clip's pose).
static func bone(a: Dictionary, name: String) -> Vector3:
	var ik: Object = a.get("ik")
	if name == "Head" and ik != null and ik.head_world != Vector3.INF:
		return ik.head_world
	var skel: Skeleton3D = a["skel"]
	return skel.global_transform * skel.get_bone_global_pose(skel.find_bone(name)).origin


static func pos(a: Dictionary) -> Vector3:
	return (a["node"] as Node3D).global_position


static func fwd(a: Dictionary) -> Vector3:
	return (a["node"] as Node3D).global_transform.basis.z.normalized()


## The actor's own left.
static func side(a: Dictionary) -> Vector3:
	return Vector3.UP.cross(fwd(a)).normalized()


static func _sc(a: Dictionary) -> float:
	return (a["node"] as Node3D).scale.x


## S399: where a glove with no job rests in the intro - in front of her chest, off her face. LOW: forward, down from the
## chest bone, out to that hand's side (m, scaled with her).
const LOW := Vector3(0.22, -0.10, 0.12)   # S399 still: -0.06 under the chest bone read at her hip


static func low_glove(a: Dictionary, hand: String) -> Vector3:
	var s: float = (a["node"] as Node3D).scale.x
	var out := 1.0 if hand == "Left" else -1.0   # side() is her own left
	return bone(a, "Chest") + (fwd(a) * LOW.x - Vector3.UP * LOW.y + side(a) * out * LOW.z) * s


## The glove touch: boxer i's lead glove where the two meet between their chests (S391 pad: her glove's front, less `lean`
## when she stands leaned in her stance).
static func touch_at(boxers: Array, i: int, lean: float) -> Vector3:
	var a: Dictionary = boxers[i]
	var mid := (bone(boxers[0], "Chest") + bone(boxers[1], "Chest")) * 0.5 + Vector3.UP * 0.05
	var toward := (pos(boxers[1 - i]) - pos(a)).normalized()
	var pad := maxf(0.16, float(a.get("front", 0.16)) * (a["node"] as Node3D).scale.x + 0.015) - lean
	return mid - toward * pad

