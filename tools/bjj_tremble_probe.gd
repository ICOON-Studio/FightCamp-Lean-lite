extends SceneTree
## S379 BJJ audit (operator on the round-10 film: "limbs are trembling, why it got so much worse? it was fine in the clip
## grapple_walk.mp4"): measures the two women AS DRAWN - every bone read on Skeleton3D.skeleton_updated, i.e. after
## GrapplePose's aim + roll + IK and GrappleGrip have run (outside the modifier pass get_bone_global_pose returns the
## un-modified pose - S307 trap; tools/knockdown_film.gd `_watch`).
##   JITTER per joint (wrists, elbows, ankles, knees, head, hips; both women): the jerk |p[n] - 3p[n-1] + 3p[n-2] - p[n-3]|
##     (the third difference at 30 fps, reported in m/s^3 = m/frame^3 x 27000) as p95 and max, and the velocity's direction
##     FLIPS per second (two consecutive frame steps over 0.5 mm pointing more than 90 deg apart - a smooth sway turns
##     with steps under that, a tremble reverses at speed).
##   OVERLAP per frame from capsules on the DRAWN bones (radii = bjj9_probe's mesh-true table): each woman's TORSO is her
##     pelvis (thigh roots, r 0.118) + twin trunk capsules Spine->Neck offset 0.035 along her hip line (r 0.12); the other's
##     parts (head sphere r 0.11, neck 0.07, shoulder line 0.085, upper arms 0.06, forearms 0.045, thighs 0.10, shins
##     0.065, feet 0.068, and her own pelvis + trunk) are tested against it: depth = r1 + r2 - segment distance. Reported
##     both ways (ANA's parts into KIM's torso, KIM's into ANA's) and as ANY (every part against every part).
##   JOINTS: the same any-part test on the joints handed to the poses (bjj9_probe's own table and space) - and how far
##     each drawn bone sits from its joint (our bone lengths: the push-out can clear joints the skeleton never reaches).
##   POP: the worst one-frame step of a tracked joint per phase (move / hold / miss = a feint / finish / verdict).
## Modes:
##   mode=match   BeltMatch seed 369, every call answered at once with offer 2 (not the HOLD rest) - the film's own
##                policy (tools/belt_match_film.gd), so the bout is the r10 film's; ends when BeltMatch ends.
##   mode=browser the S335 ground-move browser walking `moves=N` (default 10, the grapple_walk film's) GrappleMap
##                transitions from mount, its own rng seed 335; ends when the walk quits. `scene=res://...` measures
##                another browser scene (an older GrappleBrowser/GrapplePlayer pulled out of git, e.g. the S335 film's).
##   mode=theatre S379 the Grappling theatre (scenes/dev/GrappleTheatre.tscn) playing `chain=<id>` once at 1x, straight
##                (no push-out, no IK, no grips - the theatre's own setting); phases: move, join (0.6 s after a join
##                tick), hold (the held first and last position).
## S379 on main (claude/theatre): BeltMatch is not on main, so mode=match needs claude/bjj9base; main's GrapplePlayer
## reads none of the layer switches - there `nosep` sets the player's own `contact = false` (main's only show layer).
## Layer switches (user args, read by the game scripts): noidle nofloor nosep nocarry noblend noimpact noroute nofeint
## nofinish, `nolayers` = all; the probe itself reads `nogrip` (GrappleGrip modifiers inactive) and `noik` (GrapplePose.ik).
##   <godot.exe> --headless --audio-driver Dummy --path . --fixed-fps 30 --script res://tools/bjj_tremble_probe.gd -- show3d mode=match match=1 [switches]
##   ... -- show3d mode=browser [moves=10] [scene=res://...] [switches]
## Prints TREMBLE lines and one TREMBLE_JSON line (the bisect table reads it). Deterministic: a rerun prints the same.
## S379 first reading (r10 bout, seed 369): jerk p95 1312 m/s^3 pooled, 3.75 flips/s a joint; `noidle` 396 / 0.77; the
## S335 browser film's own code 44 / 0.05; drawn overlap peak 0.210 m while the joints read 0.045.

const NoGi := preload("res://scripts/rules/NoGi.gd")
const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const BELT_MATCH := "res://scripts/grapple/BeltMatch.gd"   # claude/bjj9base only (loaded, never preloaded)
const THEATRE := "res://scenes/dev/GrappleTheatre.tscn"

const FPS := 30.0
const SKIP_S := 0.6             # the scene's own setup (the first position laid) is not measured
const V_MIN := 0.0005           # m a frame: a step this small is stillness (a flip needs two steps over it)
const MATCH_MAX_S := 340.0
const BROWSER_MAX_S := 240.0
const NAMES := ["ANA", "KIM"]
const TRACK := [["wristL", "LeftHand"], ["wristR", "RightHand"], ["elbowL", "LeftLowerArm"], ["elbowR", "RightLowerArm"],
	["ankleL", "LeftFoot"], ["ankleR", "RightFoot"], ["kneeL", "LeftLowerLeg"], ["kneeR", "RightLowerLeg"],
	["head", "Head"], ["hips", "Hips"]]
const BONES := ["Hips", "Spine", "Neck", "Head", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm",
	"LeftHand", "RightHand", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot",
	"LeftToes", "RightToes"]
## Parts as [name, bone a, bone b, radius]; "torso" parts are the target set.
const LIMBS := [["neck", "Neck", "Head", 0.07], ["shoulders", "LeftUpperArm", "RightUpperArm", 0.085],
	["upperarmL", "LeftUpperArm", "LeftLowerArm", 0.06], ["upperarmR", "RightUpperArm", "RightLowerArm", 0.06],
	["forearmL", "LeftLowerArm", "LeftHand", 0.045], ["forearmR", "RightLowerArm", "RightHand", 0.045],
	["thighL", "LeftUpperLeg", "LeftLowerLeg", 0.10], ["thighR", "RightUpperLeg", "RightLowerLeg", 0.10],
	["shinL", "LeftLowerLeg", "LeftFoot", 0.065], ["shinR", "RightLowerLeg", "RightFoot", 0.065],
	["footL", "LeftFoot", "LeftToes", 0.068], ["footR", "RightFoot", "RightToes", 0.068]]

var mode := "match"
var b: Node
var m: Node
var _skels: Array = []
var _cache: Array = [{}, {}]        # the last drawn pose of each skeleton (bone -> world position)
var _updates := [0, 0]
var _clock := 0.0
var _done := false
var _pos: Array = []                 # per woman: per TRACK entry, PackedVector3Array over the frames
var _phase: PackedStringArray = []   # per frame
var _times := PackedFloat32Array()
var _ov := [PackedFloat32Array(), PackedFloat32Array(), PackedFloat32Array(), PackedFloat32Array()]   # ANA->KIM torso, KIM->ANA torso, ANY, JOINTS
var _ov_worst: Array = []
var _switches: PackedStringArray = []
var _moves := 10
var _scene := "res://scenes/dev/GrappleBrowser.tscn"
var _chain := "fifty_fifty"


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("mode="):
			mode = s.substr(5)
		elif s.begins_with("moves="):
			_moves = int(s.substr(6))
		elif s.begins_with("scene="):
			_scene = s.substr(6)
		elif s.begins_with("chain="):
			_chain = s.substr(6)
		elif s.begins_with("no"):
			_switches.append(s)
	root.size = Vector2i(1280, 720)
	if mode == "theatre":
		_scene = THEATRE
	b = load(_scene).instantiate()
	root.add_child(b)   # its _ready runs after _initialize: the rest is wired on the first frame (_setup)


var _wired := false


## The first frame (the browser's _ready has run): the mode, the probe's own switches, the watched skeletons.
func _setup() -> void:
	_wired = true
	if mode == "browser":
		b.set("_walk", _moves)
		b.set("_walking", true)
		(b.get("_rng") as RandomNumberGenerator).seed = 335
	elif mode == "theatre":
		b.call("load_chain", _chain)
		b.call("set_loop", false)
	elif not ResourceLoader.exists(BELT_MATCH):
		print("TREMBLE_FAIL mode=match needs BeltMatch (claude/bjj9base); this branch has none")
		_done = true
		quit(1)
		return
	elif b.get_node_or_null("BeltMatch") == null:
		# The same as the browser's own `-- match=1` (BeltMatch last under the browser, seed 369).
		var bm: Node = (load(BELT_MATCH) as GDScript).new()
		bm.name = "BeltMatch"
		b.add_child(bm)
		bm.setup(b, NoGi.athlete())
	var player: Node = b.get("player")
	var nolayers := _switches.has("nolayers")
	if (_switches.has("nosep") or nolayers) and player.get("contact") != null:
		player.set("contact", false)
	for i in 2:
		var pose: Node = (player.get("men") as Array)[i]
		var skel := pose.get_parent() as Skeleton3D
		_skels.append(skel)
		if _switches.has("noik") or nolayers:
			pose.set("ik", false)
		if _switches.has("nogrip") or nolayers:
			for g in skel.find_children("GrappleGrip", "", false, false):
				(g as SkeletonModifier3D).active = false
		_watch(skel, i)
		var per: Array = []
		for t in TRACK:
			per.append(PackedVector3Array())
		_pos.append(per)
	print("TREMBLE start mode=%s switches=%s" % [mode, ",".join(_switches) if not _switches.is_empty() else "none"])


func _watch(skel: Skeleton3D, who: int) -> void:
	var ids := {}
	for n in BONES:
		ids[n] = skel.find_bone(n)
	skel.skeleton_updated.connect(func() -> void:
		var d := {}
		var gt := skel.global_transform
		for n in BONES:
			var bi: int = ids[n]
			if bi >= 0:
				d[n] = gt * skel.get_bone_global_pose(bi).origin
		_cache[who] = d
		_updates[who] += 1)


func _process(delta: float) -> bool:
	if _done:
		return true
	if not _wired:
		_setup()
	_clock += delta
	if mode == "match":
		if m == null:
			m = b.get_node_or_null("BeltMatch")
		if m != null:
			_answer_calls()
	if _clock >= SKIP_S and not (_cache[0] as Dictionary).is_empty() and not (_cache[1] as Dictionary).is_empty():
		_sample()
	var over := false
	if mode == "match" and m != null:
		over = bool(m.get("_ended"))
	elif mode == "theatre":
		over = not bool(b.get("playing")) and float(b.get("clock")) >= float(b.get("total"))
	if over or _clock > (MATCH_MAX_S if mode == "match" else BROWSER_MAX_S):
		_report()
		_done = true
		quit(0)
		return true
	return false


## The browser's walk quits the tree by itself: the report runs on the way out.
func _finalize() -> void:
	if not _done:
		_report()
		_done = true


## The film's policy (belt_match_film.gd): a call is answered the frame after it opens, with offer 2 unless it is the
## HOLD rest.
func _answer_calls() -> void:
	var call: Array = m.get("_call")
	if call.is_empty():
		return
	var pick: Dictionary = call[mini(1, call.size() - 1)]
	if str(pick.get("kind", "")) == "hold" and call.size() > 1:
		pick = call[0]
	m.call("_act", 0, pick, true)


func _phase_now() -> String:
	if mode == "theatre":
		var c := float(b.get("clock"))
		var st: Array = b.get("steps")
		if st.is_empty() or c < float(st[0]["t0"]) or c > float(st.back()["t1"]):
			return "hold"
		for j in (b.get("joins") as Array):
			if c >= float(j) and c < float(j) + 0.6:
				return "join"
		return "move"
	var mv: Dictionary = b.get("moving")
	if not mv.is_empty():
		return "finish" if str(mv["t"]["title"]) == "Lock finish" else "move"
	if m != null:
		if bool(m.get("st")["over"]):
			return "verdict"
		if str(m.get("_last")).ends_with("missed"):
			return "miss"   # a feint (and the settle after it)
	return "hold"


func _sample() -> void:
	_phase.append(_phase_now())
	_times.append(_clock)
	for w in 2:
		var d: Dictionary = _cache[w]
		for k in TRACK.size():
			# Written back: a packed array read out of an Array with `as` is a copy.
			var track: PackedVector3Array = _pos[w][k]
			track.append(d[TRACK[k][1]])
			_pos[w][k] = track
	var parts := [_parts(_cache[0]), _parts(_cache[1])]
	var ak := _deepest(parts[0]["all"], parts[1]["torso"])
	var ka := _deepest(parts[1]["all"], parts[0]["torso"])
	var anyp := _deepest(parts[0]["all"], parts[1]["all"])
	_ov[0].append(float(ak["d"]))
	_ov[1].append(float(ka["d"]))
	_ov[2].append(float(anyp["d"]))
	_ov[3].append(_joint_overlap())
	_gap_sample()
	var worst := ak if float(ak["d"]) >= float(ka["d"]) else ka
	var way := "ANA %s into KIM %s" % [ak["a"], ak["b"]] if float(ak["d"]) >= float(ka["d"]) else "KIM %s into ANA %s" % [ka["a"], ka["b"]]
	_ov_worst.append({"d": float(worst["d"]), "t": _clock, "what": way, "ph": _phase[_phase.size() - 1]})
	_ov_worst.sort_custom(func(x, y): return float(x["d"]) > float(y["d"]))
	if _ov_worst.size() > 6:
		_ov_worst.resize(6)


## One woman's capsules off her drawn bones: {"torso": [...], "all": [...]}, each [name, a, b, r].
func _parts(d: Dictionary) -> Dictionary:
	var lat: Vector3 = ((d["RightUpperLeg"] as Vector3) - (d["LeftUpperLeg"] as Vector3)).normalized()
	var torso: Array = [["pelvis", d["LeftUpperLeg"], d["RightUpperLeg"], 0.118]]
	for s in [1.0, -1.0]:
		torso.append(["trunk", (d["Spine"] as Vector3) + lat * 0.035 * s, (d["Neck"] as Vector3) + lat * 0.035 * s, 0.12])
	var all: Array = torso.duplicate()
	var head: Vector3 = d["Head"]
	var hc := head + (head - (d["Neck"] as Vector3)).normalized() * 0.08
	all.append(["head", hc, hc, 0.11])
	for l in LIMBS:
		all.append([l[0], d[l[1]], d[l[2]], l[3]])
	return {"torso": torso, "all": all}


## How far the DRAWN skeleton sits from the joints handed to it (our bone lengths, only the hips placed from the data;
## IK lands the wrists and ankles, the elbows and knees go where our limbs reach): drawn bone origin vs its joint.
const GAP_PAIRS := [["knee", "LeftLowerLeg", "LeftKnee"], ["knee", "RightLowerLeg", "RightKnee"],
	["elbow", "LeftLowerArm", "LeftElbow"], ["elbow", "RightLowerArm", "RightElbow"],
	["wrist", "LeftHand", "LeftWrist"], ["wrist", "RightHand", "RightWrist"], ["ankle", "LeftFoot", "LeftAnkle"],
	["ankle", "RightFoot", "RightAnkle"], ["hip", "LeftUpperLeg", "LeftHip"], ["hip", "RightUpperLeg", "RightHip"],
	["shoulder", "LeftUpperArm", "LeftShoulder"], ["shoulder", "RightUpperArm", "RightShoulder"]]
var _gaps := {}


func _gap_sample() -> void:
	var player: Node = b.get("player")
	for w in 2:
		var j: PackedVector3Array = ((player.get("men") as Array)[w] as Node).get("joints")
		if j.size() != DB.JOINTS.size():
			return
		var d: Dictionary = _cache[w]
		for g in GAP_PAIRS:
			var arr: PackedFloat32Array = _gaps.get(g[0], PackedFloat32Array())
			arr.append((d[g[1]] as Vector3).distance_to(j[DB.joint(g[2])]))
			_gaps[g[0]] = arr


## The cross-check: the same any-part test on the JOINTS the player handed the poses (GrapplePose.joints, after its
## push-out) with bjj9_probe's mesh-true table - what that probe's overlap bars read. Read off the poses, never by
## calling GrapplePlayer.joints_at: a second same-time call re-applies the blend/impact onto the carried solution
## (it writes into _carry_out) and moved the r10 bout's finish jerk p95 3138 -> 3184.
const JOINT_CAPS := [["Neck", "Head", 0.07], ["LeftHip", "RightHip", 0.118], ["LeftShoulder", "RightShoulder", 0.085],
	["LeftHip", "LeftKnee", 0.10], ["RightHip", "RightKnee", 0.10], ["LeftKnee", "LeftAnkle", 0.065],
	["RightKnee", "RightAnkle", 0.065], ["LeftShoulder", "LeftElbow", 0.06], ["RightShoulder", "RightElbow", 0.06],
	["LeftElbow", "LeftWrist", 0.045], ["RightElbow", "RightWrist", 0.045], ["LeftAnkle", "LeftToe", 0.068],
	["RightAnkle", "RightToe", 0.068]]


func _joint_overlap() -> float:
	var player: Node = b.get("player")
	var sets: Array = []
	for w in 2:
		var j: PackedVector3Array = ((player.get("men") as Array)[w] as Node).get("joints")
		if j.size() != DB.JOINTS.size():
			return 0.0
		var lat := (j[DB.joint("RightHip")] - j[DB.joint("LeftHip")]).normalized()
		var one: Array = []
		for sd in [1.0, -1.0]:
			one.append(["trunk", j[DB.joint("Core")] + lat * 0.035 * sd, j[DB.joint("Neck")] + lat * 0.035 * sd, 0.12])
		one.append(["head", j[DB.joint("Head")], j[DB.joint("Head")], 0.11])
		for c in JOINT_CAPS:
			one.append(["", j[DB.joint(c[0])], j[DB.joint(c[1])], c[2]])
		sets.append(one)
	return float(_deepest(sets[0], sets[1])["d"])


static func _deepest(xs: Array, ys: Array) -> Dictionary:
	var best := {"d": 0.0, "a": "", "b": ""}
	for x in xs:
		for y in ys:
			var pts := Geometry3D.get_closest_points_between_segments(x[1], x[2], y[1], y[2])
			var dd: float = float(x[3]) + float(y[3]) - (pts[0] as Vector3).distance_to(pts[1])
			if dd > float(best["d"]):
				best = {"d": dd, "a": x[0], "b": y[0]}
	return best


static func _pct(v: PackedFloat32Array, q: float) -> float:
	if v.is_empty():
		return 0.0
	var s := v.duplicate()
	s.sort()
	return s[clampi(int(q * s.size()), 0, s.size() - 1)]


## Jerk (m/s^3) and flips of one joint's track over the frames whose phase is in `phases` (all when empty).
static func _jitter(p: PackedVector3Array, phase: PackedStringArray, phases: Array) -> Dictionary:
	var jerks := PackedFloat32Array()
	var flips := 0
	var frames := 0
	for n in range(3, p.size()):
		if not phases.is_empty() and not phases.has(phase[n]):
			continue
		frames += 1
		var jk := (p[n] - 3.0 * p[n - 1] + 3.0 * p[n - 2] - p[n - 3]).length() * FPS * FPS * FPS
		jerks.append(jk)
		var v1 := p[n] - p[n - 1]
		var v0 := p[n - 1] - p[n - 2]
		if v1.length() > V_MIN and v0.length() > V_MIN and v1.dot(v0) < 0.0:
			flips += 1
	var mx := 0.0
	for j in jerks:
		mx = maxf(mx, j)
	return {"p95": _pct(jerks, 0.95), "max": mx, "flips_s": flips / maxf(1.0 / FPS, frames / FPS), "frames": frames}


func _report() -> void:
	var n := _times.size()
	print("TREMBLE frames %d (%.1f s measured, skeleton updates %d / %d)" % [n, n / FPS, _updates[0], _updates[1]])
	if n < 10:
		print("TREMBLE_FAIL too few drawn frames")
		return
	var out := {"mode": mode, "switches": ",".join(_switches), "frames": n, "joints": {}, "phases": {}, "overlap": {}}
	var rows: Array = []
	for w in 2:
		for k in TRACK.size():
			var r := _jitter(_pos[w][k], _phase, [])
			rows.append({"name": "%s %s" % [NAMES[w], TRACK[k][0]], "p95": r["p95"], "max": r["max"], "flips": r["flips_s"]})
			out["joints"]["%s_%s" % [NAMES[w], TRACK[k][0]]] = [snappedf(r["p95"], 0.1), snappedf(r["max"], 0.1), snappedf(r["flips_s"], 0.01)]
	for r in rows:
		print("TREMBLE joint %-12s jerk p95 %7.1f m/s^3  max %8.1f  flips %5.2f /s" % [r["name"], r["p95"], r["max"], r["flips"]])
	rows.sort_custom(func(x, y): return float(x["p95"]) > float(y["p95"]))
	var worst_names: Array = []
	for r in rows.slice(0, 4):
		worst_names.append("%s %.0f" % [r["name"], r["p95"]])
	print("TREMBLE worst joints (jerk p95 m/s^3): %s" % ", ".join(worst_names))
	# Pooled over every tracked joint of both women, per phase.
	for ph in ["all", "move", "join", "hold", "miss", "finish", "verdict"]:
		var jerks := PackedFloat32Array()
		var flips := 0.0
		var frames := 0
		for w in 2:
			for k in TRACK.size():
				var r := _jitter(_pos[w][k], _phase, [] if ph == "all" else [ph])
				if int(r["frames"]) == 0:
					continue
				frames = int(r["frames"])
				flips += float(r["flips_s"])
				var p: PackedVector3Array = _pos[w][k]
				for i in range(3, p.size()):
					if ph == "all" or _phase[i] == ph:
						jerks.append((p[i] - 3.0 * p[i - 1] + 3.0 * p[i - 2] - p[i - 3]).length() * FPS * FPS * FPS)
		if frames == 0:
			continue
		var per_joint := flips / (2.0 * TRACK.size())
		print("TREMBLE phase %-7s %5.1f s: jerk p95 %7.1f m/s^3, p50 %6.1f, flips %.2f /s a joint" % [ph, frames / FPS,
			_pct(jerks, 0.95), _pct(jerks, 0.5), per_joint])
		out["phases"][ph] = [snappedf(frames / FPS, 0.1), snappedf(_pct(jerks, 0.95), 0.1), snappedf(_pct(jerks, 0.5), 0.1), snappedf(per_joint, 0.01)]
	var labels := ["ANA into KIM torso", "KIM into ANA torso", "ANY part into part", "JOINTS (bjj9 table)"]
	for i in 4:
		var v: PackedFloat32Array = _ov[i]
		var mean := 0.0
		var deep := 0
		var pk := 0.0
		for d in v:
			mean += d
			pk = maxf(pk, d)
			if d > 0.06:
				deep += 1
		mean /= maxf(1.0, v.size())
		var fin := 0.0
		for f in v.size():
			if _phase[f] == "finish" or _phase[f] == "verdict":
				fin = maxf(fin, v[f])
		print("TREMBLE overlap %-19s peak %.3f m, p95 %.3f, mean %.3f, frames > 6 cm %d, finish+verdict peak %.3f" % [
			labels[i], pk, _pct(v, 0.95), mean, deep, fin])
		out["overlap"][["ana_kim", "kim_ana", "any", "joints"][i]] = [snappedf(pk, 0.001), snappedf(_pct(v, 0.95), 0.001), snappedf(mean, 0.001), deep, snappedf(fin, 0.001)]
	var gl: Array = []
	for k in _gaps.keys():
		gl.append("%s p50 %.3f p95 %.3f" % [k, _pct(_gaps[k], 0.5), _pct(_gaps[k], 0.95)])
		out["overlap"]["gap_" + str(k)] = [snappedf(_pct(_gaps[k], 0.5), 0.001), snappedf(_pct(_gaps[k], 0.95), 0.001)]
	print("TREMBLE drawn bone vs its joint (m): %s" % ", ".join(gl))
	# The worst one-frame step of any tracked joint per phase (a pop reads as a snap on film).
	for ph in ["move", "join", "hold", "miss", "finish"]:
		var best := 0.0
		var at := 0.0
		var what := ""
		for w in 2:
			for k in TRACK.size():
				var p: PackedVector3Array = _pos[w][k]
				for i in range(1, p.size()):
					if _phase[i] == ph and p[i].distance_to(p[i - 1]) > best:
						best = p[i].distance_to(p[i - 1])
						at = _times[i]
						what = "%s %s" % [NAMES[w], TRACK[k][0]]
		if what != "":
			print("TREMBLE pop %-7s worst one-frame step %.3f m at %.1f s (%s)" % [ph, best, at, what])
			out["phases"]["pop_" + ph] = [snappedf(best, 0.001), snappedf(at, 0.1), what]
	for w in _ov_worst.slice(0, 4):
		print("TREMBLE overlap worst %.3f m at %5.1f s (%s) %s" % [float(w["d"]), float(w["t"]), str(w["ph"]), str(w["what"])])
	if m != null:
		out["end"] = "%s %s" % [str(m.get("st")["how"]), str(m.get("st")["pts"])]
		print("TREMBLE match end: %s at %.1f s" % [out["end"], _clock])
	print("TREMBLE_JSON " + JSON.stringify(out))
