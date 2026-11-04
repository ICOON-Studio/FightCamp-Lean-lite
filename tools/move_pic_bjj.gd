extends RefCounted
## MOVEPICS1 (S381) - Ana's syllabus as ink move cards (driven by tools/bake_move_pics.gd, whose viewport, ink bodies,
## framing and card it uses): Ana in red and her partner in blue, as the Playbook's mat and the theatre cast them, posed by
## GrapplePose from the move's GrappleMap film (BjjFilm) at its key position - the film's last keyframe, where the sweep
## has landed or the lock is on. The camera is the one of twelve round the pair that keeps the two bodies most apart on
## the card; the gold arrow follows the part of Ana that travels furthest on the card into that last keyframe.
## S381 r2: the cards the art review rejected (tools/move_pic_bjj_cards.gd lists them) are drawn by tools/move_pic_bjj_r2.gd
## - a low camera on the keyframe that separates the two bodies best, tight on the contact - or as a "card pending" name.

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const Pose := preload("res://scripts/grapple/GrapplePose.gd")
const Player := preload("res://scripts/grapple/GrapplePlayer.gd")
const Grip := preload("res://scripts/grapple/GrappleGrip.gd")
const Graph := preload("res://scripts/grapple/GrappleGraph.gd")
const BjjFilm := preload("res://scripts/rules/BjjFilm.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const Specs := preload("res://tools/move_pic_specs.gd")
const SPS := preload("res://tools/session_pic_style.gd")
const SPC := preload("res://tools/session_pic_card.gd")
const Cards := preload("res://tools/move_pic_bjj_cards.gd")
const R2 := preload("res://tools/move_pic_bjj_r2.gd")

const ELEV := 32.0
const WALK_S := 0.05          # the film is walked up to its key at this step: GrapplePose keeps each bone's last roll
const ARROW_JOINTS := ["LeftHand", "RightHand", "LeftAnkle", "RightAnkle", "Head", "Core", "LeftKnee", "RightKnee"]


static func bake_all(t) -> void:
	# S383 r3 rollback: a card that failed both reviews is PENDING - no PNG ships (the Playbook shows its glyph) and its
	# row in moves_rows.json says "pending": true. A bake never draws one back; clear the row to retry the card.
	var todo: Array = Specs.bjj_ids().filter(func(id):
		return t.wanted(str(id)) and not bool((t._rows.get(str(id), {}) as Dictionary).get("pending", false)))
	if todo.is_empty():
		return
	var db := DB.load_db()
	var ana_f := NoGi.athlete()
	var stems := Faces.pair(ana_f, Faces.partner(ana_f))
	var ana: Dictionary = await t.load_body(stems[0], false, false)
	var par: Dictionary = await t.load_body(stems[1], true, false)
	var bodies := [ana, par]
	var poses: Array = []
	var legs: Array = []
	for bx in bodies:
		var skel: Skeleton3D = bx["skel"]
		poses.append(Pose.attach(skel))
		var sw := skel.global_transform
		legs.append((sw * skel.get_bone_global_rest(skel.find_bone("LeftUpperLeg")).origin).distance_to(
			sw * skel.get_bone_global_rest(skel.find_bone("LeftFoot")).origin))
	for i in 2:
		Grip.attach(bodies[i]["skel"], poses[i], poses[1 - i])
	var player: Node = Player.new()
	t._vp.add_child(player)
	player.men = poses
	player.scale = Player.pair_scale(legs)
	t._props.visible = false
	for id in todo:
		if Cards.has(str(id)):
			await R2.bake(t, db, player, str(id), stems)
		else:
			await _bake(t, db, player, str(id), stems)
	player.queue_free()
	for bx in bodies:
		(bx["node"] as Node3D).queue_free()
	await t.process_frame


## The film of a syllabus move; {} when there is none.
static func sequence(db: Array, id: String) -> Dictionary:
	var i := BjjFilm.find(db, id)
	return db[i] if i >= 0 else {}


static func _bake(t, db: Array, player: Node, id: String, stems: Array) -> void:
	var seq := sequence(db, id)
	if seq.is_empty():
		print("MOVE_PIC_MISSING %s: no GrappleMap film" % id)
		return
	player.play(seq, player.men, player.scale, Transform3D.IDENTITY)
	player.paused = true
	var keys: PackedFloat32Array = player.key_times()
	var tk: float = keys[keys.size() - 1]
	var now := 0.0
	while now < tk:
		now = minf(now + WALK_S, tk)
		player.seek(now)
		await t.process_frame
	var js: Array = player.joints_at(tk)
	var az := best_az(js)
	_aim(t, js, az)
	var pair: Dictionary = await t.frame(func(size: int) -> Dictionary:
		var img: Image = await t._render(size)
		return {"img": img, "box": img.get_used_rect()})
	var data := SPC.bg_data().duplicate()
	SPC._over(data, t.blue_layer(SPC.ink_layer(pair["img"])).get_data(), 1.0)
	var img := Image.create_from_data(SPS.PX, SPS.PX, false, Image.FORMAT_RGBA8, data)
	var path: Array = []
	var joint := ""
	var drawn := 0.0
	if keys.size() >= 2:
		# Ana's part that travels furthest ON THE CARD into the last keyframe (a limb swung in from off the frame
		# drew its arrow from the card's edge: S381 arm drag, north-south).
		t._img_size = Vector2(SPS.PX, SPS.PX)
		var best := 0.0
		for j in ARROW_JOINTS:
			var pts: Array = []
			var u: float = keys[keys.size() - 2]
			while true:
				var p: PackedVector3Array = player.joints_at(u)[0]
				pts.append(t._px(p[DB.joint(j)] + Vector3(0.0, 0.05, 0.0)))
				if u >= tk:
					break
				u = minf(u + WALK_S, tk)
			var seen: Array = t.on_card(pts)
			var n: float = t._path_len(seen)
			if seen.size() == pts.size() and n > best:     # the whole stretch on the card, start and end
				best = n
				joint = j
				path = pts
		drawn = t.path_arrow(img, path)
	var lo := INF
	for p in js:
		for v in (p as PackedVector3Array):
			lo = minf(lo, v.y)
	var row := {"kind": "bjj", "film": str(seq["title"]), "key_t": snappedf(tk, 0.001), "keys": keys.size(), "az": az,
		"bodies": stems, "arrow": joint, "arrow_px": snappedf(drawn, 0.1), "lowest_joint_y": snappedf(lo, 0.003),
		"margin": t._margin(pair["box"], t.BIG)}
	t.store(id, img, row)


## Of twelve cameras round the pair (ELEV above it), the one that shows the two cores furthest apart for the drawing's
## size, with a nearly square drawing as the tie-break (the card is square).
static func best_az(js: Array) -> float:
	var best := 0.0
	var top := -INF
	for k in 12:
		var az := k * 30.0
		var b := _view(az)
		var lo := Vector2.INF
		var hi := -Vector2.INF
		for p in js:
			for v in (p as PackedVector3Array):
				var q := Vector2(v.dot(b.x), v.dot(b.y))
				lo = lo.min(q)
				hi = hi.max(q)
		var ext := hi - lo
		var big := maxf(ext.x, ext.y)
		var c0: Vector3 = (js[0] as PackedVector3Array)[DB.joint("Core")]
		var c1: Vector3 = (js[1] as PackedVector3Array)[DB.joint("Core")]
		var sep := Vector2((c1 - c0).dot(b.x), (c1 - c0).dot(b.y)).length()
		var score := sep / maxf(big, 0.1) + 0.35 * minf(ext.x, ext.y) / maxf(big, 0.1)
		if score > top:
			top = score
			best = az
	return best


## The camera's right and up for an azimuth round the pair.
static func _view(az: float) -> Basis:
	var d := _dir(az)
	var right := (-d).cross(Vector3.UP).normalized()
	return Basis(right, right.cross(-d).normalized(), d)


static func _dir(az: float) -> Vector3:
	var a := deg_to_rad(az)
	var e := deg_to_rad(ELEV)
	return Vector3(sin(a) * cos(e), sin(e), cos(a) * cos(e)).normalized()


static func _aim(t, js: Array, az: float) -> void:
	var lo := Vector3.INF
	var hi := -Vector3.INF
	for p in js:
		for v in (p as PackedVector3Array):
			lo = lo.min(v)
			hi = hi.max(v)
	var focus := (lo + hi) * 0.5
	t._cam.position = focus + _dir(az) * t.CAM_DIST
	t._cam.look_at(focus, Vector3.UP)
	t._cam.size = maxf((hi - lo).length(), 1.0) * 1.1

