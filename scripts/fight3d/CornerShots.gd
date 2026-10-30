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
			# Medium from outside the ropes, low, the ropes in the foreground: she sits.
			var seat: Vector3 = red["seat"]
			# Between the middle and top ropes (0.85 / 1.25 m), level with her face, so no rope crosses it.
			var p := seat + l * 2.3 + d * 0.7 + Vector3.UP * 1.0
			var look := seat + Vector3.UP * 0.82
			return {"pos": p, "look": look, "fov": 30.0, "focus": p.distance_to(look), "drift": d * 0.18}
		"water":
			# Close insert from her front-right: the bottle at her lips, the coach's arm coming in from the far side.
			var p := face + (Basis(Vector3.UP, -0.8) * d) * 0.85 + Vector3.UP * 0.02
			return {"pos": p, "look": face + Vector3.DOWN * 0.05, "fov": 28.0, "focus": p.distance_to(face), "drift": -l * 0.05}
		"ice":
			# Close insert from behind her left shoulder: the ice on the back of her neck.
			var neck := bone(her, "Neck")
			var p := neck + l * 0.62 - d * 0.12 + Vector3.UP * 0.16
			return {"pos": p, "look": neck, "fov": 30.0, "focus": p.distance_to(neck), "drift": d * 0.05}
		"ots":
			# Over the coach's right shoulder onto her face: just behind and above his shoulder joint, so the line to her
			# face passes beside his head (his shoulder and ear soft in the foreground), never through his hunched back.
			var coach: Dictionary = ctx["coach"]
			var sh := bone(coach, "RightUpperArm")
			var dir := (sh - face).normalized()
			var p := sh + dir * 0.32 + Vector3.UP * 0.12 - side(coach) * 0.06
			return {"pos": p, "look": face, "fov": 30.0, "focus": p.distance_to(face), "drift": -side(coach) * 0.04}
		"reverse":
			# The reverse: over her shoulder onto the coach as he speaks, looking up at her (three-quarter, never long straight-on).
			var coach: Dictionary = ctx["coach"]
			var cf := bone(coach, "Head") + fwd(coach) * 0.09 + Vector3.UP * 0.03
			var dir := Vector3(face.x - cf.x, 0, face.z - cf.z).normalized()
			var p := face + dir * 0.42 + l * 0.24 + Vector3.UP * 0.02
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


## A bone's world position on an actor ({skel}).
static func bone(a: Dictionary, name: String) -> Vector3:
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
