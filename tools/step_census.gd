extends SceneTree
## FIGHTPLAYER2 (S528, the owner on film 5, C434: "why the fighter do not walk ?"): THE STEP CENSUS. Every take that
## could carry a boxer across the canvas (the Rokoko actor's own steps in guard, the Mixamo boxing side steps, the owned
## step cycles, the guard and its fidgets) measured AS BOUGHT on our body at 60 Hz, like tools/clip_census.gd:
##   where the hips go (forward / side in his own frame, the turn), how high they ride;
##   each foot's time on the canvas and every step it takes (when it leaves, when it lands, how far, how high);
##   how far the standing foot slides inside the take itself (the film's ruler: the stiller low foot over 0.15 m/s);
##   the stance the take starts and ends in (each foot from the hips, knees, hips height) against the guard's;
##   whether the hands stay by the head.
## Headless: <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/step_census.gd -- <out.json> [clip ...]
## `-- db` writes assets/data/foot_db.json: for EVERY fight take when each foot stands on the canvas ("feet": the v2 leg
## layer, FootTake, pins a foot while its take stands on it and lets the take's own steps through), and for the step
## takes where they go and when ("steps": the v2 player picks and times a step from it).

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const Orbit := preload("res://tools/clip_orbit.gd")
const HZ := 60.0
const LOW_M := 0.03           # a ball this close to its lowest is on the canvas (the film ruler's bar)
const STILL_MPS := 0.25       # ... and standing when it moves slower than this
const SLIP_MPS := 0.15
const DB_PATH := "res://assets/data/foot_db.json"
const SKIP := ["af_", "entry_", "clinch_", "cmu_", "rk_"]
const BONES := ["Hips", "Head", "LeftHand", "RightHand", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg",
	"LeftFoot", "RightFoot", "LeftToes", "RightToes"]

var skel: Skeleton3D
var ap: AnimationPlayer
var ids := {}
var fwd := Vector3.BACK
var side := Vector3.RIGHT


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var db := args.has("db")
	var out := DB_PATH if db else (str(args[0]) if args.size() > 0 else "user://step_census.json")
	FightClips.as_bought = true
	var st: Node3D = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	await process_frame
	st.set_process(false)
	var bx: Dictionary = st.boxers[0]
	skel = bx["skel"]
	ap = bx["ap"]
	fwd = (bx["node"] as Node3D).global_transform.basis.z.normalized()
	side = Vector3.UP.cross(fwd).normalized()
	Orbit.strip_modifiers(skel)
	for b in BONES:
		ids[b] = skel.find_bone(b)
	var names: Array = args.slice(1) if not db and args.size() > 1 else []
	if names.is_empty():
		for n in ap.get_animation_list():
			if not SKIP.any(func(p): return str(n).begins_with(str(p))) and (db or str(n).begins_with("st_") or str(n) == "pro_idle"):
				names.append(str(n))
		names.sort()
	var rows := {}
	var feet := {}
	var steps := {}
	for n in names:
		var name := str(n)
		if not ap.has_animation(name):
			print("STEPCENSUS MISSING ", name)
			continue
		var row := _measure(name)
		rows[name] = row
		feet[name] = {"L": row["feet"]["Left"]["stands_s"], "R": row["feet"]["Right"]["stands_s"]}
		if name.begins_with("st_"):
			steps[name] = {"length_s": row["length_s"], "travel": row["hips_end"], "turn_deg": row["turn_deg"], "move_s": row["move_s"],
				"hips_y": row["hips_y"], "slip_m": row["slip_m"]}
		if not db:
			print("STEPCENSUS %s %s" % [name, JSON.stringify(row)])
	var f := FileAccess.open(out, FileAccess.WRITE)
	f.store_string(JSON.stringify({"meta": {"tool": "tools/step_census.gd", "hz": HZ, "low_m": LOW_M, "still_mps": STILL_MPS},
		"steps": steps, "feet": feet} if db else {"hz": HZ, "rows": rows}, "	", true))
	f.close()
	print("STEPCENSUS DONE %d takes -> %s" % [rows.size(), out])
	quit(0)


func _pose(clip: String, t: float) -> Dictionary:
	ap.play(clip)
	ap.seek(t, true)
	var w := skel.global_transform
	var p := {}
	for b in BONES:
		p[b] = w * skel.get_bone_global_pose(int(ids[b])).origin
	var hb := (w * skel.get_bone_global_pose(int(ids["Hips"]))).basis.orthonormalized()
	p["yaw"] = atan2(hb.z.x, hb.z.z)
	return p


static func _r(v: float) -> float:
	return snappedf(v, 0.001)


func _fs(v: Vector3) -> Array:   # forward, side in his own frame
	return [_r(v.dot(fwd)), _r(v.dot(side))]


static func _knee(p: Dictionary, s: String) -> float:
	var k: Vector3 = p[s + "LowerLeg"]
	return snappedf(rad_to_deg(((p[s + "UpperLeg"] as Vector3) - k).angle_to((p[s + "Foot"] as Vector3) - k)), 0.1)


func _stance(p: Dictionary) -> Dictionary:
	var h: Vector3 = p["Hips"]
	return {"hips_y": _r(h.y), "left": _fs((p["LeftFoot"] as Vector3) - h), "right": _fs((p["RightFoot"] as Vector3) - h),
		"knee": [_knee(p, "Left"), _knee(p, "Right")],
		"hands": [_r((p["LeftHand"] as Vector3).distance_to(p["Head"])), _r((p["RightHand"] as Vector3).distance_to(p["Head"]))]}


func _measure(clip: String) -> Dictionary:
	var length: float = ap.get_animation(clip).length
	var n := maxi(2, int(floor(length * HZ)) + 1)
	var ps: Array = []
	for i in n:
		ps.append(_pose(clip, minf(i / HZ, length)))
	var p0: Dictionary = ps[0]
	var row := {"length_s": _r(length), "start": _stance(p0), "end": _stance(ps[n - 1])}
	var h0: Vector3 = p0["Hips"]
	row["hips_end"] = _fs((ps[n - 1]["Hips"] as Vector3) - h0)
	row["turn_deg"] = snappedf(rad_to_deg(angle_difference(float(p0["yaw"]), float(ps[n - 1]["yaw"]))), 0.1)
	var ys: Array = []
	var path: Array = []
	var hands := 0.0
	for i in n:
		var p: Dictionary = ps[i]
		ys.append((p["Hips"] as Vector3).y)
		if i % 6 == 0 or i == n - 1:
			path.append([_r(i / HZ)] + _fs((p["Hips"] as Vector3) - h0))
		hands = maxf(hands, maxf((p["LeftHand"] as Vector3).distance_to(p["Head"]), (p["RightHand"] as Vector3).distance_to(p["Head"])))
	# when the hips cover their ground: from 10 % to 90 % of the way to where the take ends
	var endv: Vector3 = (ps[n - 1]["Hips"] as Vector3) - h0
	endv.y = 0.0
	var move := [0.0, _r(length)]
	if endv.length() > 0.05:
		var got_a := false
		for i in n:
			var along := ((ps[i]["Hips"] as Vector3) - h0).dot(endv) / endv.length_squared()
			if not got_a and along >= 0.1:
				move[0] = _r(i / HZ)
				got_a = true
			if along >= 0.9:
				move[1] = _r(i / HZ)
				break
	row["move_s"] = move
	row["hips_y"] = [_r(ys.min()), _r(ys.max())]
	row["hips_path"] = path
	row["hands_max_m"] = _r(hands)
	# the feet: on the canvas (low and still) or in the air, and every step between two stands
	var slip := 0.0
	var feet := {}
	var low: Array = [[], []]
	var spd: Array = [[], []]
	for k in 2:
		var s: String = ["Left", "Right"][k]
		var floor_y := INF
		for p in ps:
			floor_y = minf(floor_y, (p[s + "Toes"] as Vector3).y)
		var down: Array = []
		for i in n:
			var b: Vector3 = ps[i][s + "Toes"]
			var was: Vector3 = ps[maxi(i - 1, 0)][s + "Toes"]
			var v := Vector2(b.x - was.x, b.z - was.z).length() * HZ
			(low[k] as Array).append(b.y - floor_y < LOW_M)
			(spd[k] as Array).append(v)
			down.append(b.y - floor_y < LOW_M and v < STILL_MPS)
		var stands: Array = []   # [from_i, to_i]
		var a := -1
		for i in n + 1:
			var on := i < n and bool(down[i])
			if on and a < 0:
				a = i
			elif not on and a >= 0:
				if i - a >= 4:
					stands.append([a, i - 1])
				a = -1
		var steps: Array = []
		for j in range(1, stands.size()):
			var from_i: int = stands[j - 1][1]
			var to_i: int = stands[j][0]
			var lift := 0.0
			for i in range(from_i, to_i + 1):
				lift = maxf(lift, (ps[i][s + "Toes"] as Vector3).y - floor_y)
			var d: Vector3 = (ps[to_i][s + "Toes"] as Vector3) - (ps[from_i][s + "Toes"] as Vector3)
			steps.append({"off_s": _r(from_i / HZ), "down_s": _r(to_i / HZ), "move": _fs(d), "lift_m": _r(lift)})
		feet[s] = {"stands_s": stands.map(func(x): return [_r(int(x[0]) / HZ), _r(int(x[1]) / HZ)]), "steps": steps}
	for i in range(1, n):
		var best := INF
		for k in 2:
			if bool(low[k][i]):
				best = minf(best, float(spd[k][i]))
		if best < INF and best > SLIP_MPS:
			slip += best / HZ
	row["feet"] = feet
	row["slip_m"] = _r(slip)
	return row
