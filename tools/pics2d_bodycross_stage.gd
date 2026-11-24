extends "res://tools/pics2d_set.gd"
## BODYCROSS2 (S545, ops/research/TASK_BODYCROSS2.md): the staging the body-cross ruler and film share. Owner C500 on the
## S542 film: "the punch in the stomach does not reach opponent and the motion reads more like he is trying to touch
## hime rather than punch him and hurt him". Two ways to stage the same pair on the pictures' fixed side camera:
##   as=filmed  what the S542 film showed: the game's finish armed (Player2._arm -> PunchAim, which eases the glove ONTO
##              the rib point and holds it there), the range found by what the armed glove leaves, the hit man's take
##              started from its first key on the contact and played on the spot (his take's own step back never shown).
##   as=own     the take's own keys and nothing else: no finish; the puncher stands where the take's glove front meets
##              the other man's BODY SURFACE (his skinned mesh) on the take's contact key; both bodies travel as their
##              takes travel (the v2 player's own PairPlace.place); the hit man answers by the v2 player's own route for
##              a landed body punch (ChoreoReact.react / start_s, one picture after the contact, the fold join).
## Nothing in scripts/fight3d is changed or added to (FIGHTPLAYER2 method line): this file only calls what is there.
## Every pose is read on skeleton_updated (after the modifiers, as drawn), never between frames.

const ChoreoReact := preload("res://scripts/fight3d/v2/ChoreoReact.gd")
const ChoreoRules := preload("res://scripts/fight3d/v2/ChoreoRules.gd")
const TORSO_BONES := ["Hips", "Spine", "spine_02", "Chest", "spine_04", "UpperChest", "spine_04_latissimus_l", "spine_04_latissimus_r", "clavicle_pec_l", "clavicle_pec_r"]
const TORSO_SHARE := 0.6      # a vertex is trunk when this much of its skin weight is on the trunk's bones
const LEAD_F := 18
const AFTER_F := 96           # pictures recorded after the contact (1.6 s: the hit man's whole answer)
const FILM_REACT := "pro_hit_by_gutshot_v2_short"
const MIN_APART_M := 0.40     # the S542 film's own bar (pics2d_set.gd had it until PICSFIX1 found the range by its gate)

var clock := 0.0
var snap: Array = [{}, {}]    # per boxer: the last pose drawn {xf, poses, gl}
var t_v := PackedVector3Array()   # the hit man's trunk: rest vertices
var t_b := PackedInt32Array()     # ... four skin binds a vertex
var t_w := PackedFloat32Array()
var t_tris := PackedInt32Array()
var t_binds: Array = []
var t_bones := PackedInt32Array()
var t_flip := 1.0
var t_for := -1                # whose trunk is read
var react_from := -1.0         # BODYCROSS3: >= 0 = the hit man's take starts from this key (from=<s>), not the plan's


func _watch() -> void:
	for i in 2:
		(stage.boxers[i]["skel"] as Skeleton3D).skeleton_updated.connect(_snap.bind(i))


func _snap(i: int) -> void:
	var sk: Skeleton3D = stage.boxers[i]["skel"]
	var poses: Array = []
	poses.resize(sk.get_bone_count())
	for b in sk.get_bone_count():
		poses[b] = sk.get_bone_global_pose(b)
	(stage.boxers[i]["gloves"] as Node)._follow()
	snap[i] = {"xf": sk.global_transform, "poses": poses, "gl": {"LeftHand": stage.glove_front(i, "LeftHand"), "RightHand": stage.glove_front(i, "RightHand")}}


## A bone's world point in a snapshot.
func _at(s: Dictionary, i: int, bone: String) -> Vector3:
	return (s["xf"] as Transform3D) * ((s["poses"] as Array)[(stage.boxers[i]["skel"] as Skeleton3D).find_bone(bone)] as Transform3D).origin


## The set gate's crowding measure AS DRAWN, on two recorded poses: the nearest a head bone is to the other's trunk
## line and head (tools/pics2d_gate.gd reads the bones between frames - the take's own key, before the join smoother).
func _heads(a: Dictionary, b: Dictionary, who: int) -> float:
	var best := INF
	for pair in [[a, who, b, 1 - who], [b, 1 - who, a, who]]:
		var h := _at(pair[0], pair[1], "Head")
		var line: Array = []
		for bone in Gate.TORSO + ["Head"]:
			line.append(_at(pair[2], pair[3], bone))
		best = minf(best, Gate.chain_dist([h, h], line))
	return best


## The hit man's trunk skin, read once: the vertices mostly weighted to the trunk's bones and the triangles between them.
func _surf_build(d: int) -> void:
	var sk: Skeleton3D = stage.boxers[d]["skel"]
	var mi := sk.find_child("MH_Body", true, false) as MeshInstance3D
	var tor := {}
	for b in TORSO_BONES:
		tor[sk.find_bone(str(b))] = true
	t_binds = []
	t_bones = PackedInt32Array()
	for j in mi.skin.get_bind_count():
		var bn := str(mi.skin.get_bind_name(j))
		t_bones.append(sk.find_bone(bn) if bn != "" else mi.skin.get_bind_bone(j))
		t_binds.append(mi.skin.get_bind_pose(j))
	t_v = PackedVector3Array()
	t_b = PackedInt32Array()
	t_w = PackedFloat32Array()
	t_tris = PackedInt32Array()
	for s in mi.mesh.get_surface_count():
		var arr := mi.mesh.surface_get_arrays(s)
		var pv: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
		var pb: PackedInt32Array = arr[Mesh.ARRAY_BONES]
		var pw: PackedFloat32Array = PackedFloat32Array(arr[Mesh.ARRAY_WEIGHTS])
		var idx: PackedInt32Array = arr[Mesh.ARRAY_INDEX]
		var per := pb.size() / maxi(pv.size(), 1)
		var map := PackedInt32Array()
		map.resize(pv.size())
		map.fill(-1)
		for k in pv.size():
			var order: Array = []
			var share := 0.0
			for q in per:
				order.append([pw[k * per + q], pb[k * per + q]])
				if tor.has(t_bones[pb[k * per + q]]):
					share += pw[k * per + q]
			if share < TORSO_SHARE:
				continue
			order.sort_custom(func(x, y): return float(x[0]) > float(y[0]))
			var sum := 0.0
			for q in 4:
				sum += float(order[q][0])
			map[k] = t_v.size()
			t_v.append(pv[k])
			for q in 4:
				t_b.append(int(order[q][1]))
				t_w.append(float(order[q][0]) / maxf(sum, 1e-6))
		for k in range(0, idx.size(), 3):
			if map[idx[k]] >= 0 and map[idx[k + 1]] >= 0 and map[idx[k + 2]] >= 0:
				t_tris.append(map[idx[k]])
				t_tris.append(map[idx[k + 1]])
				t_tris.append(map[idx[k + 2]])
	# which side of a triangle is outside: a point on the spine line is inside
	t_flip = 1.0
	var pts := _surf_pose(snap[d])
	var got := _surf_dist(pts, _at(snap[d], d, "Chest"))
	if float(got[0]) > 0.0:
		t_flip = -1.0
	print("BC2_STAGE the hit man's trunk skin: %d vertices, %d triangles (spine line %.3f m inside)" % [t_v.size(), t_tris.size() / 3, absf(float(got[0]))])


## The trunk's vertices as drawn in snapshot s (world).
func _surf_pose(s: Dictionary) -> PackedVector3Array:
	var m: Array = []
	m.resize(t_binds.size())
	var xf: Transform3D = s["xf"]
	var poses: Array = s["poses"]
	var out := PackedVector3Array()
	out.resize(t_v.size())
	for k in t_v.size():
		var p := Vector3.ZERO
		for q in 4:
			var w := t_w[k * 4 + q]
			if w <= 0.0:
				continue
			var j := t_b[k * 4 + q]
			if m[j] == null:
				m[j] = xf * (poses[t_bones[j]] as Transform3D) * (t_binds[j] as Transform3D)
			p += ((m[j] as Transform3D) * t_v[k]) * w
		out[k] = p
	return out


## [signed distance from g to the trunk's surface (under 0 = inside it), the nearest surface point].
func _surf_dist(pts: PackedVector3Array, g: Vector3) -> Array:
	var near := INF
	for p in pts:
		near = minf(near, p.distance_squared_to(g))
	var cut := pow(sqrt(near) + 0.10, 2.0)
	var best := INF
	var bq := g
	var bn := Vector3.UP
	for k in range(0, t_tris.size(), 3):
		var a := pts[t_tris[k]]
		if a.distance_squared_to(g) > cut:
			continue
		var b := pts[t_tris[k + 1]]
		var c := pts[t_tris[k + 2]]
		var q := _tri_closest(g, a, b, c)
		var d2 := q.distance_squared_to(g)
		if d2 < best:
			best = d2
			bq = q
			bn = (b - a).cross(c - a)
	var sign := 1.0 if (g - bq).dot(bn) * t_flip >= 0.0 else -1.0
	return [sqrt(best) * sign, bq]


static func _tri_closest(p: Vector3, a: Vector3, b: Vector3, c: Vector3) -> Vector3:
	var ab := b - a
	var ac := c - a
	var pa := p - a
	var d1 := ab.dot(pa)
	var d2 := ac.dot(pa)
	if d1 <= 0.0 and d2 <= 0.0:
		return a
	var pb := p - b
	var d3 := ab.dot(pb)
	var d4 := ac.dot(pb)
	if d3 >= 0.0 and d4 <= d3:
		return b
	var vc := d1 * d4 - d3 * d2
	if vc <= 0.0 and d1 >= 0.0 and d3 <= 0.0:
		return a + ab * (d1 / (d1 - d3))
	var pc := p - c
	var d5 := ab.dot(pc)
	var d6 := ac.dot(pc)
	if d6 >= 0.0 and d5 <= d6:
		return c
	var vb := d5 * d2 - d1 * d6
	if vb <= 0.0 and d2 >= 0.0 and d6 <= 0.0:
		return a + ac * (d2 / (d2 - d6))
	var va := d3 * d6 - d5 * d4
	if va <= 0.0 and (d4 - d3) >= 0.0 and (d5 - d6) >= 0.0:
		return b + (c - b) * ((d4 - d3) / ((d4 - d3) + (d5 - d6)))
	var den := 1.0 / (va + vb + vc)
	return a + ab * (vb * den) + ac * (vc * den)


## One frame of the tools' own clock; own: the bodies stand where their takes have carried them (PairPlace.place).
func _step(own: bool) -> void:
	await process_frame
	clock += 1.0 / 60.0
	stage.v2.t = clock
	if own:
		stage.v2.pair.place()


## The pair on its spots for a throw, the tools' clock at zero (the guard loop's phase reads the clock: every pass
## then meets the same guard pose on the contact), then the lead-in pictures.
func _stand(who: int, step: float, extra: Vector3) -> void:
	clock = 0.0
	stage.v2.t = 0.0
	await _home_guard(step, who)
	_node(who).global_position += extra
	stage.v2._settle(who)


func _throw(who: int, clip: String, own: bool) -> void:
	if not own:
		stage.v2._arm(who, clip, true)
	stage.v2._play(who, clip, 0.0, "punch", own)


## Plays the take to its contact key and holds the puncher there.
func _run_to(who: int, clip: String, cs: float, own: bool) -> void:
	var ap: AnimationPlayer = stage.boxers[who]["ap"]
	for f in 240:
		await _step(own)
		if str(ap.current_animation) != clip or ap.current_animation_position >= cs - 0.008:
			break
	_freeze(who)
	await process_frame


## Where the puncher stands: {step (m in along the line), extra (across), gap (glove front to the surface there)}.
func _range(who: int, clip: String, cs: float, hand: String, own: bool) -> Dictionary:
	var dirv := axis * (1.0 if who == 0 else -1.0)
	var d := 1 - who
	var step := 0.0
	var extra := Vector3.ZERO
	var left := 0.0
	if not own:   # the S542 film's way, to the letter (tools/pics2d_bodycross_film.gd as committed in 49121faa6)
		await _home_guard()
		stage.v2._play(who, clip, 0.0, "punch", false)
		await _to_contact(who, clip, cs)
		var short: float = (stage.v2.target(d, true) - stage.glove_front(who, hand)).dot(dirv)
		var room: float = (_node(d).global_position - _node(who).global_position).dot(dirv) - MIN_APART_M
		step = minf(short, room)
		for attempt in 3:
			await _home_guard(step, who)
			_node(who).global_position += extra
			_throw(who, clip, false)
			await _to_contact(who, clip, cs)
			for f in 8:
				await process_frame
			var r: Vector3 = stage.v2.target(d, true) - stage.glove_front(who, hand)
			left = r.length()
			if left <= 0.04:
				break
			extra += Vector3(r.x, 0.0, r.z) + dirv * maxf(0.0, -r.y) * 0.6
			extra -= dirv * maxf(0.0, (step + extra.dot(dirv)) - room)
		return {"step": step, "extra": extra, "gap": left}
	for attempt in 10:
		await _stand(who, step, extra)
		for f in LEAD_F:
			await _step(false)
		_throw(who, clip, true)
		await _run_to(who, clip, cs, true)
		var gl: Vector3 = snap[who]["gl"][hand]
		var got := _surf_dist(_surf_pose(snap[d]), gl)
		left = float(got[0])
		var r2: Vector3 = stage.v2.target(d, true) - gl
		var across := Vector3(r2.x, 0.0, r2.z)
		across -= dirv * across.dot(dirv)
		if absf(left) <= 0.004 and across.length() <= 0.01:
			break
		step += left
		extra += across
	return {"step": step, "extra": extra, "gap": left}


## The hit man's answer by the v2 player's own route for a landed body punch (Choreographer's reaction entry).
func _react_plan(d: int, forced: String = "") -> Dictionary:
	if forced != "" and not (stage.v2.db["rows"] as Dictionary).has(forced):
		return {"clip": forced, "from_s": maxf(react_from, 0.0), "until_s": 9.0, "picked": ""}
	var db: Dictionary = stage.v2.db
	var rows: Dictionary = db["rows"]
	var sc: float = stage.v2.pair.size(d)
	var rng := RandomNumberGenerator.new()
	rng.seed = 545
	var ri: Array = ChoreoReact.react(db, rows, "body_hook", false, true, rng, 0.0, [], sc, [])
	var clip := str(ri[0]) if forced == "" else forced
	var row: Dictionary = rows.get(clip, {})
	var st: Array = ChoreoReact.start_s(row, "body_hook", float((db.get("meta", {}) as Dictionary).get("curve_hz", 30.0)), sc)
	var r_peak := float(row.get("head_peak_s", 0.0))
	var r_at := minf(r_peak, float(row.get("head_rel_s", r_peak)))
	var until := minf(minf(r_peak + 0.15, r_at + ChoreoRules.REACT_STAGGER_S), float(row.get("length_s", 9.0)))
	return {"clip": clip, "from_s": float(st[0]) if react_from < 0.0 else react_from, "until_s": until, "picked": str(ri[0])}


## An earlier version of a take beside the shipped one, on both bodies (the before side of a film or a ruler): its
## file, its clip_db row, its glove front at the contact (what Player2._sample reads for every take it knows).
func _adopt(path: String, row_path: String, old_name: String, new_name: String) -> bool:
	var row: Variant = JSON.parse_string(FileAccess.get_file_as_string(row_path))
	if not ResourceLoader.exists(path) or not (row is Dictionary):
		print("BC2_STAGE no old take at %s / %s" % [path, row_path])
		return false
	stage.v2.db["rows"][old_name] = row
	for i in 2:
		var bx: Dictionary = stage.boxers[i]
		var ap: AnimationPlayer = bx["ap"]
		var skel: Skeleton3D = bx["skel"]
		var prefix := str(ap.get_animation(new_name).track_get_path(0)).get_slice(":", 0)
		for ln in ap.get_animation_library_list():
			var lib := ap.get_animation_library(ln)
			if lib.has_animation(new_name):
				FightClips._add_baked(lib, skel, prefix, old_name, path)
		if not ap.has_animation(old_name):
			return false
		var hand: String = stage.hand_of(i, str(row.get("hand", "RightHand")))
		ap.play(old_name)
		ap.seek(float(row.get("contact_s", 0.3)), true)
		(bx["gloves"] as Node)._follow()
		stage.v2._fronts[i][old_name] = (bx["node"] as Node3D).global_transform.affine_inverse() * (stage.glove_front(i, hand) as Vector3)
		var hp := skel.get_bone_global_pose(skel.find_bone(hand))
		stage.v2._rels[i][old_name] = (skel.global_transform.basis * hp.basis).inverse() * ((stage.glove_front(i, hand) as Vector3) - skel.global_transform * hp.origin)
		stage.v2.guard(i)
	return true


## Plays the staged punch whole from the guard; frame(k, info) is called once a picture (a coroutine may draw it).
## Returns {frames: [{pos, live, thr, def}], kc (the picture of the take's contact key), stage, react}.
## hold_after >= 0: both are frozen that many pictures after the contact key and the play stops there (a still).
func _play_out(who: int, clip: String, own: bool, react: String, frame: Callable = Callable(), hold_after: int = -1) -> Dictionary:
	var d := 1 - who
	var ap: AnimationPlayer = stage.boxers[who]["ap"]
	var row: Dictionary = stage.v2.db["rows"][clip]
	var cs := float(row.get("contact_s", 0.3))
	var hand: String = stage.hand_of(who, str(row.get("hand", "RightHand")))
	if t_for != d:
		await _home_guard()
		await process_frame
		_surf_build(d)
		t_for = d
	var rg := await _range(who, clip, cs, hand, own)
	var plan := {} if react == "film" else _react_plan(d, "" if react == "game" else react)
	await _stand(who, float(rg["step"]), rg["extra"])
	_aim([0, 1])
	var frames: Array = []
	for f in LEAD_F:
		await _step(false)
		frames.append({"pos": -1.0, "live": false, "thr": snap[who], "def": snap[d]})
		if frame.is_valid():
			await frame.call(frames.size() - 1, {})
	_throw(who, clip, own)
	var kc := -1
	var react_at := -1.0
	var back := false
	for f in 600:
		await _step(own or react != "film")
		var live := str(ap.current_animation) == clip and ap.is_playing()
		frames.append({"pos": ap.current_animation_position if live else -1.0, "live": live, "thr": snap[who], "def": snap[d]})
		var info := {}
		if kc < 0 and (not live or ap.current_animation_position >= cs - 0.008):
			kc = frames.size() - 1
			info["contact"] = true
			react_at = clock
			if react == "film":
				stage.v2._play(d, FILM_REACT, 0.0, "reaction", false)
			else:   # one picture after the contact, as far into its take; a body shot's fold join (Player2._event)
				stage.v2._join_next = Player2.JOIN_FOLD
				stage.v2._play(d, str(plan["clip"]), float(plan["from_s"]) + 1.0 / 60.0, "reaction", true)
		if kc >= 0 and react != "film" and not back and clock >= react_at + maxf(float(plan["until_s"]) - float(plan["from_s"]), 0.2):
			back = true
			stage.v2.guard(d)
		if frame.is_valid():
			await frame.call(frames.size() - 1, info)
		if kc >= 0 and hold_after >= 0 and frames.size() - 1 - kc >= hold_after:
			_freeze(0)
			_freeze(1)
			break
		if kc >= 0 and frames.size() - 1 - kc >= AFTER_F and not live:
			break
	var aim: Node = stage.v2._aim[who]
	if aim != null and hold_after < 0:
		aim.disarm()
	return {"frames": frames, "kc": kc, "hand": hand, "cs": cs, "stage": rg, "react": plan, "dirv": axis * (1.0 if who == 0 else -1.0)}
