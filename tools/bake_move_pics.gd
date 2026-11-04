extends "res://tools/bake_session_pics.gd"
## MOVEPICS1 (S381) - the Playbook's move cards in the Fight Camp screen's ink look (operator: "use the artstyle from fight
## camp still i liked that more of that art in the menus"). Same render path as the session cards (this script extends
## tools/bake_session_pics.gd: its viewport, camera framing, ink bodies and 2D card), one card per move:
##   boxing - Lucy (red) at the move's most readable instant, the partner (Maria, blue) at the target or at the card's
##            range, faint figures for what came before (a combo's earlier punches, in order, further back), a gold arrow
##            along the real fist / head / foot path of the clip; the footwork escapes are their own pictures
##            (tools/move_pic_ideas.gd: the feint's flinch, the cut-off line, the pivot's arc, the push);
##   BJJ    - Ana (red) and her partner (blue) at the GrappleMap move's key position (tools/move_pic_bjj.gd).
##
##   python tools/hidden_desktop.py run --timeout=1500 "<godot>" --path . --windowed --resolution 1280x720 \
##       --audio-driver Dummy --script res://tools/bake_move_pics.gd -- [only=jab,1-2] [boxing=0] [bjj=0] \
##       [azs=60,100 out=<dir>] [top=4]   (look-dev: each boxing card once per camera, each BJJ card's `top` best
##       shots, written to <dir> only)
##
##   Writes assets/ui/moves/<file>.png (256 px, opaque charcoal tile) and moves.json {id: res path} (+ moves_rows.json,
##   what each card measured: clip, instant, glove gap, feet).

const Specs := preload("res://tools/move_pic_specs.gd")
const BjjCards := preload("res://tools/move_pic_bjj.gd")
const Ideas := preload("res://tools/move_pic_ideas.gd")
const Ideas2 := preload("res://tools/move_pic_ideas2.gd")
const Ideas3 := preload("res://tools/move_pic_ideas3.gd")
const Land := preload("res://tools/move_pic_land.gd")
const Arrow := preload("res://tools/move_pic_arrow.gd")

const MOVES_OUT := "res://assets/ui/moves"
const HER := "mh_boxer_11"        # Lucy Jackson, the camp screen's boxer
const SPAR := "mh_boxer_13"       # Maria Ortega, the Playbook's sparring partner for a woman (Faces.partner)
## The partner's kit is drawn cool so SessionPicCard snaps it onto PROP_DARK (no move card hangs a mitt), and the card
## then paints that tone BLUE: her red and the partner's blue never meet in the snap.
const KIT_LIT := Color(0.20, 0.30, 0.78)
const KIT_DARK := Color(0.12, 0.20, 0.55)
const BLUE := Color(0.16, 0.33, 0.78)
const HEAD_R := 0.07              # m from the glove's face to the point of the face it lands on
const BODY_R := 0.11              # m from the glove's face to the liver point (S381 r2: the glove ON the liver)
const MIN_PELVIS := 0.55          # m: closer than this the two bodies pass through each other
const ROPE_H := [0.50, 0.88, 1.26]
const STEP_DT := 1.0 / 30.0
const FOOT_ARROW_Y := 0.05
const HOOK_BOW := 0.32

var _her: Dictionary = {}
var _spar: Dictionary = {}
var _files: Dictionary = {}
var _rows: Dictionary = {}
var _only: Array = []
var _view: Dictionary = {}
var _azs: Array = []
var _out_dir := ""
var _arrow_end := Vector3.ZERO    # the last fist / head / foot arrow's tip, in the world (r4: measured on its target)


func _initialize() -> void:
	_setup_view(MOVES_OUT)
	await process_frame
	var do_box := true
	var do_bjj := true
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("only="):
			_only = Array(s.trim_prefix("only=").split(","))
		elif s == "boxing=0":
			do_box = false
		elif s.begins_with("az=") or s.begins_with("elev=") or s.begins_with("top=") or s.begins_with("free="):
			_view[s.get_slice("=", 0)] = float(s.get_slice("=", 1))   # a look-dev override of every card's camera
		elif s.begins_with("azs="):
			_azs = Array(s.trim_prefix("azs=").split(","))
		elif s.begins_with("out="):
			_out_dir = s.trim_prefix("out=")
		elif s == "bjj=0":
			do_bjj = false
	for name in ["moves.json", "moves_rows.json"]:
		var old: Variant = JSON.parse_string(FileAccess.get_file_as_string(MOVES_OUT.path_join(name)))
		if old is Dictionary:
			(_files if name == "moves.json" else _rows).merge(old, true)
	if do_box:
		await _bake_boxing()
	if do_bjj:
		await BjjCards.bake_all(self)
	if _out_dir == "":
		_save_json("moves.json", _files)
		_save_json("moves_rows.json", _rows)
	print("MOVE_PICS_JSON %s" % MOVES_OUT.path_join("moves.json"))
	quit(0)


func wanted(id: String) -> bool:
	return _only.is_empty() or _only.has(id)


func _save_json(name: String, d: Dictionary) -> void:
	var f := FileAccess.open(MOVES_OUT.path_join(name), FileAccess.WRITE)
	f.store_string(JSON.stringify(d, "\t"))
	f.close()


## A finished card: saved, listed in moves.json, its measures in moves_rows.json (a look-dev run writes to out= only).
func store(id: String, img: Image, row: Dictionary) -> void:
	if _out_dir != "":
		var tag := ("_az%s" % _view["az"]) if _view.has("az") else ""
		img.save_png(_out_dir.path_join(Specs.file(id).trim_suffix(".png") + tag + ".png"))
		print("MOVE_PIC_LOOK %s%s %s" % [id, tag, JSON.stringify(row)])
		return
	var file := MOVES_OUT.path_join(Specs.file(id))
	img.save_png(ProjectSettings.globalize_path(file))
	_files[id] = file
	_rows[id] = row
	print("MOVE_PIC %s %s" % [id, JSON.stringify(row)])


# ---------------------------------------------------------------- bodies -------------------------------------------------

## One MetaHuman in ink. `blue` = the partner's kit; `boxing` = boots, gloves and the fight's clip library.
func load_body(stem: String, blue: bool, boxing: bool) -> Dictionary:
	var glb := MH_DIR.path_join(stem + ".glb")
	var body := MH.load_fighter(glb)
	var gloves: Gloves = null
	if boxing:
		Kit.dress(body, glb, "boxing")
		gloves = Gloves.new()
		gloves.name = "Gloves"
		body.add_child(gloves)
		var corner: Array = Stage.CORNERS["blue" if blue else "red"]
		gloves.mount(body, corner[0], corner[1])
	_vp.add_child(body)
	await process_frame
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var aps := body.find_children("*", "AnimationPlayer", true, false)
	var ap: AnimationPlayer = aps[0] if not aps.is_empty() else null
	if boxing:
		FightClips.load_into(ap, skel)
	var mats := SPS.ink_materials()
	if blue:
		mats["kit"] = SPS._mat(load(SPS.INK_SHADER) as Shader, KIT_LIT, KIT_LIT, KIT_DARK)
	_fills.append_array(mats.values())
	_hulls.append_array(SPS.ink_body(body, mats))
	return {"node": body, "skel": skel, "ap": ap, "gloves": gloves}


## The partner's layer: her cool kit (snapped onto PROP_DARK) painted the blue corner's colour.
func blue_layer(img: Image) -> Image:
	var d := img.get_data()
	var k: Color = SPS.PROP_DARK
	var want := [SPC._b(k.r), SPC._b(k.g), SPC._b(k.b)]
	for i in d.size() / 4:
		var o := i * 4
		if d[o + 3] > 0 and d[o] == want[0] and d[o + 1] == want[1] and d[o + 2] == want[2]:
			d[o] = SPC._b(BLUE.r)
			d[o + 1] = SPC._b(BLUE.g)
			d[o + 2] = SPC._b(BLUE.b)
	return Image.create_from_data(img.get_width(), img.get_height(), false, Image.FORMAT_RGBA8, d)


## A pose may carry an arm reach (pose["ik"] = {hand, tip}): the clip's arm bent so the glove's face is on `tip` -
## the body hook's lunge digs in under the liver, the card puts the glove on it (S381 r2).
func _pose(bx: Dictionary, pose: Dictionary, offset: Vector3) -> void:
	super._pose(bx, pose, offset)
	if pose.has("ik"):
		for r in (pose["ik"] if pose["ik"] is Array else [pose["ik"]]):
			Ideas.reach(self, bx, str(r["hand"]), r["tip"], int(r.get("passes", 2)))


# ---------------------------------------------------------------- boxing -------------------------------------------------

func _bake_boxing() -> void:
	_her = await load_body(HER, false, true)
	_spar = await load_body(SPAR, true, true)
	for id in Specs.ids():
		# S383 r4: a boxing card that failed the coach review is PENDING too - a bake never draws one back.
		if not wanted(str(id)) or bool((_rows.get(str(id), {}) as Dictionary).get("pending", false)):
			continue
		if _azs.is_empty():
			await _bake_box(str(id))
			continue
		for az in _azs:
			_view["az"] = float(az)
			await _bake_box(str(id))
	for bx in [_her, _spar]:
		(bx["node"] as Node3D).queue_free()
	await process_frame


func _bake_box(id: String) -> void:
	var s := Specs.spec(id)
	(_spar["node"] as Node3D).rotation.y = PI     # she faces +Z, the partner faces her
	(_her["node"] as Node3D).rotation.y = 0.0
	_clear_props()
	var shot: Dictionary = Ideas3.shot(self, id, s) if Ideas3.has(id) else Ideas.shot(self, id, s) if Ideas.has(id) 		else Ideas2.shot(self, id, s) if Ideas2.has(id) else _standard_shot(s)
	Ideas2.ropes(self, str(shot["ropes"]), shot["ppos"], float(shot.get("rope_z", NAN)))
	_aim_at(s, shot["focus"])
	var pair := await frame(_shots.bind(shot))
	var data := SPC.bg_data().duplicate()
	for i in (shot["layers"] as Array).size():
		var ly: Dictionary = shot["layers"][i]
		var ink := SPC.ink_layer(pair["layers"][i])
		SPC._over(data, (blue_layer(ink) if ly["who"] == "spar" else ink).get_data(), float(ly.get("alpha", 1.0)))
	var img := Image.create_from_data(CARD, CARD, false, Image.FORMAT_RGBA8, data)
	var drawn := 0.0
	for arrow in shot["arrows"]:
		var pts: Array = await (arrow as Callable).call()
		# S383 r3 (review: "rear_hook's straight arrow reads as a cross"): the hook's path bowed into its arc.
		drawn = maxf(drawn, path_arrow(img, Arrow.bow(pts, HOOK_BOW) if id == "rear_hook" else pts))
	var row: Dictionary = shot["row"].call()
	row["margin"] = _margin(pair["box"], BIG)
	row["arrow_px"] = snappedf(drawn, 0.1)
	_reset_bodies(true)
	store(id, img, row)


## Both bodies back to their marks' facing (and the partner to her own height once the card is done).
func _reset_bodies(full: bool) -> void:
	(_her["node"] as Node3D).rotation.y = 0.0
	(_spar["node"] as Node3D).rotation.y = PI
	if full:
		(_spar["node"] as Node3D).scale = Vector3.ONE


## The card as the clip gives it: the partner (hit, or at the card's range), the faint earlier figures, her finish.
func _standard_shot(s: Dictionary) -> Dictionary:
	var fin := Specs.resolve(_her, s["finish"])
	var ghosts: Array = []
	for g in s["ghosts"]:
		var gp := Specs.resolve(_her, g)
		ghosts.append({"pose": gp, "off": Vector3(0.0, 0.0, -float(g.get("back", 0.0)))})
	if fin.has("travel") and not ghosts.is_empty():
		ghosts[-1]["off"] = -(fin["travel"] as Vector3)     # the planted foot stays on its mark: the start stands back
	var gh: Dictionary = ghosts[-1]["pose"] if not ghosts.is_empty() else {}
	var gh_off: Vector3 = ghosts[-1]["off"] if not ghosts.is_empty() else Vector3.ZERO
	var part := Specs.resolve(_spar, s["partner"])
	var ppos := _place_partner(s, fin, gh, gh_off, part)
	if bool(s.get("inside", false)):
		var ins: Array = Ideas2.inside(self, fin, ghosts, part, ppos)
		ppos = ins[0]
		fin = ins[1]
	if bool(s["body_shot"]):
		fin = _on_the_liver(fin, part, ppos)
	# S383 r4: the reviewed combo and rope cards - faint punches landed, ropes on the pinned back, their own camera.
	var land := Land.has(str(s["id"]))
	var meas := {}
	if land:
		Land.camera(str(s["id"]), s)
		Land.place(self, str(s["id"]), ghosts, part, ppos)
	var layers: Array = Ideas2.rope_layer(str(s["ropes"])) + [{"who": "spar", "pose": part, "pos": ppos,
		"scale": (_spar["node"] as Node3D).scale.x}]
	for i in ghosts.size():
		# The oldest punch the faintest: the combo reads left to right, in the order it is thrown.
		var a := Ideas2.ghost_alpha(ghosts[i]["pose"], SPS.GHOST * (0.62 + 0.38 * float(i + 1) / float(ghosts.size())))
		layers.append({"who": "her", "pose": ghosts[i]["pose"], "pos": ghosts[i]["off"], "alpha": a})
	layers.append({"who": "her", "pose": fin, "pos": Vector3.ZERO})
	_pose(_her, fin, Vector3.ZERO)
	var hips := _bone_world(_her, "Hips")
	var shot := {"layers": layers, "ropes": s["ropes"], "ppos": ppos,
		"focus": Vector3((hips.x + ppos.x) * 0.5, 0.92, (hips.z + ppos.z) * 0.5)}
	shot["arrows"] = [func() -> Array: return Land.from_furthest(_arrow_path(s, fin, gh, gh_off)) if land 		else _arrow_path(s, fin, gh, gh_off)] + (Land.ghost_arrows(self, ghosts, meas, part, ppos) if land else Ideas2.ghost_arrows(self, ghosts))
	shot["row"] = func() -> Dictionary:
		var r := _measure_box(s, fin, gh, part, ppos, ghosts.size())
		if land:
			r.merge(Land.measure(self, s, fin, ghosts, part, ppos, meas), true)
		return r
	if land:
		shot["rope_z"] = Land.rope_z(self, s, fin, ghosts, part, ppos)
	return shot


## The body hook lands ON the liver: the partner stands where the glove's line meets her ribs, and the arm is bent the
## few centimetres up the clip's deep lunge leaves it short (S381 r2: the card had the glove 0.16 m under the liver).
func _on_the_liver(fin: Dictionary, part: Dictionary, ppos: Vector3) -> Dictionary:
	_pose(_spar, part, ppos)
	_pose(_her, fin, Vector3.ZERO)
	var gm := _glove_motion(_her, fin, Vector3.ZERO)
	var dir := Vector3((gm[1] as Vector3).x, 0.0, (gm[1] as Vector3).z).normalized()
	var out := fin.duplicate()
	out["ik"] = {"hand": str(fin["hand"]), "tip": _target(_spar, true) - dir * BODY_R}
	return out


## The layers at `size`, each body alone (the ropes ride with the partner's solid figure), and their merged box.
func _shots(size: int, shot: Dictionary) -> Dictionary:
	var out := {"layers": []}
	var box := Rect2i()
	var bodies := {"her": _her, "spar": _spar}
	for ly in shot["layers"]:
		if ly["who"] == "ropes":
			# The ropes alone, under everything: rendered by themselves and never part of the framing (S383 r3).
			for k in bodies:
				(bodies[k]["node"] as Node3D).visible = false
			_props.visible = true
			(out["layers"] as Array).append(await _render(size))
			continue
		var bx: Dictionary = bodies[ly["who"]]
		for k in bodies:
			(bodies[k]["node"] as Node3D).visible = k == ly["who"]
		_props.visible = bool(ly.get("props", false))
		var node := bx["node"] as Node3D
		node.rotation.y = float(ly.get("rot", 0.0 if ly["who"] == "her" else PI))
		node.scale = Vector3.ONE * float(ly.get("scale", 1.0))
		_pose(bx, ly["pose"], ly["pos"])
		var img := await _render(size)
		(out["layers"] as Array).append(img)
		var r := img.get_used_rect()
		if r.size.x > 0:
			box = r if box.size.x == 0 else box.merge(r)
	for k in bodies:
		(bodies[k]["node"] as Node3D).visible = true
	_props.visible = true
	_reset_bodies(false)
	out["box"] = box
	return out


## The session cards' framing on whatever `shoot(size)` renders (it returns the layers and their "box"): a cheap
## measuring pass, the exact orthographic correction, the card render, one more correction only if it did not land.
func frame(shoot: Callable) -> Dictionary:
	var pair: Dictionary = await shoot.call(MEASURE)
	for i in 3:
		if _inside(pair["box"], MEASURE):
			break
		_cam.size *= 1.25
		pair = await shoot.call(MEASURE)
	_correct(pair["box"], MEASURE, CARD - 2 * SPS.MARGIN - 6)
	pair = await shoot.call(BIG)
	if not _fits(pair["box"], BIG, SPS.MARGIN):
		if _inside(pair["box"], BIG):
			_correct(pair["box"], BIG)
		else:
			_cam.size *= 1.06
		pair = await shoot.call(BIG)
	return pair


## The middle of a head (the Head bone is the skull's base) or the ribs a body shot lands on.
func _target(bx: Dictionary, body_shot: bool) -> Vector3:
	var b := (bx["node"] as Node3D).global_transform.basis
	if body_shot:
		return _bone_world(bx, "Hips") + b * Vector3(-0.07, 0.17, 0.06)     # the liver: her right side, under the ribs
	return _bone_world(bx, "Head") + b * Vector3(0.0, 0.04, 0.05)     # the face: mouth and chin


## The glove's face and the way it is travelling at the pose's instant.
func _glove_motion(bx: Dictionary, p: Dictionary, off: Vector3) -> Array:
	super._pose(bx, {"clip": p["clip"], "t": maxf(0.0, float(p["t"]) - STEP_DT)}, off)
	var a := _glove_tip(bx, str(p["hand"]))
	super._pose(bx, p, off)
	var b := _glove_tip(bx, str(p["hand"]))
	var v := b - a
	if v.length() < 0.005:
		v = _glove_dir(bx, str(p["hand"]))
	return [b, v.normalized()]


## Where the partner stands (her own facing is fixed: towards her): her head on Lucy's glove, his glove where Lucy's
## head was, or at the card's range. A body shot keeps her own height: the arm reaches the liver (_on_the_liver).
func _place_partner(s: Dictionary, fin: Dictionary, gh: Dictionary, gh_off: Vector3, part: Dictionary) -> Vector3:
	var p := Vector3.ZERO
	var spar: Node3D = _spar["node"]
	spar.scale = Vector3.ONE
	match str(s["kind"]):
		"punch":
			var gm := _glove_motion(_her, fin, Vector3.ZERO)
			_pose(_spar, part, Vector3.ZERO)
			var body := bool(s["body_shot"])
			var r := BODY_R if body else HEAD_R
			var aim := (gm[0] as Vector3) + (gm[1] as Vector3) * r
			if not body:
				# A partner a little shorter or taller, so the glove meets the head at its own height (bodies differ; the
				# clip throws at the thrower's own chin line). Feet stay on the floor.
				var k := clampf(aim.y / maxf(_target(_spar, false).y, 0.5), 0.92, 1.06)
				spar.scale = Vector3.ONE * k
				_pose(_spar, part, Vector3.ZERO)
			p = aim - _target(_spar, body)
		"defence":
			_pose(_her, gh, gh_off)
			var head := _target(_her, false)
			var gm2 := _glove_motion(_spar, part, Vector3.ZERO)
			p = head - (gm2[1] as Vector3) * HEAD_R - (gm2[0] as Vector3)
		"step":
			_pose(_her, gh, gh_off)
			p = Vector3(_bone_world(_her, "Hips").x, 0.0, _bone_world(_her, "Hips").z + float(s["gap"]))
		_:
			p = Vector3(0.0, 0.0, float(s["gap"]))
	p.y = 0.0
	# Never through her: the pelvis gap keeps a body's width.
	_pose(_her, fin, Vector3.ZERO)
	var hz := _bone_world(_her, "Hips").z
	_pose(_spar, part, p)
	var gap := _bone_world(_spar, "Hips").z - hz
	if gap < MIN_PELVIS and str(s["kind"]) != "clinch":
		p.z += MIN_PELVIS - gap
	return p


## The camera on the pair's middle, a little above it; the measured framing does the rest.
func _aim_at(s: Dictionary, focus: Vector3) -> void:
	var az := deg_to_rad(float(_view.get("az", s["az"])))
	var el := deg_to_rad(float(_view.get("elev", s.get("elev", 6.0))))
	_cam.position = focus + Vector3(sin(az) * cos(el), sin(el), cos(az) * cos(el)).normalized() * CAM_DIST
	_cam.look_at(focus, Vector3.UP)
	_cam.size = 2.6


# ---------------------------------------------------------------- the arrow -------------------------------------------------

## The real path in card pixels: the striking glove's face from the guard to the contact, the head through a defence
## (lifted over the hair, as the session card's slip), the stepping foot.
func _arrow_path(s: Dictionary, fin: Dictionary, gh: Dictionary, gh_off: Vector3) -> Array:
	var pts: Array = []
	var what := str(s["arrow"])
	if what == "":
		return pts
	var clip := str(fin["clip"])
	var t1 := float(fin["t"])
	var bone := str(fin["hand"])
	var t0 := Specs.wind_up(_her, clip, bone, t1)
	if what != "fist":
		t0 = float(gh.get("t", 0.0)) if str(gh.get("clip", "")) == clip else 0.0
		bone = "Head" if what == "head" else str(fin["foot"])
	var plant := "RightFoot" if bone == "LeftFoot" else "LeftFoot"
	var p0 := IdleMatch.pose_point(_her, clip, t0, plant)
	# A reached glove (the body hook on the liver) ends where the reach put it: the path bends in over its last stretch.
	var ik_end := Vector3.ZERO
	if what == "fist" and fin.has("ik"):
		super._pose(_her, fin, Vector3.ZERO)
		ik_end = (fin["ik"]["tip"] as Vector3) - _glove_tip(_her, bone)
	_img_size = Vector2(CARD, CARD)
	var t := t0
	while true:
		var off := Vector3.ZERO
		if what == "foot":
			# In the ring the planted foot stays put: the body goes from the start figure's mark to the solid one's.
			var slide := IdleMatch.pose_point(_her, clip, t, plant) - p0
			off = gh_off - Vector3(slide.x, 0.0, slide.z)
		super._pose(_her, {"clip": clip, "t": t}, off)
		var w: Vector3 = _glove_tip(_her, bone) if what == "fist" else _bone_world(_her, bone) + ARROW_LIFT.get(bone, Vector3.ZERO)
		if what == "foot":
			w.y = FOOT_ARROW_Y     # along the floor: the lift of the foot made the path loop (S381 pivot_out)
		w += ik_end * smoothstep(t0, t1, t) if t1 > t0 else ik_end
		_arrow_end = w
		pts.append(_px(w))
		if t >= t1:
			break
		t = minf(t + STEP_DT, t1)
	_pose(_her, fin, Vector3.ZERO)
	if what == "foot" and pts.size() >= 2:
		return [pts[0], pts[-1]]     # a step reads as one straight line along the floor (the strafes' paths zig-zag)
	return pts


## The gold arrow (tools/move_pic_arrow.gd): its length, the stretch on the card, and the drawn arrow.
static func _path_len(pts: Array) -> float:
	return Arrow.length(pts)


static func on_card(all: Array) -> Array:
	return Arrow.on_card(all)


static func path_arrow(img: Image, all: Array) -> float:
	return Arrow.draw(img, all)


# ---------------------------------------------------------------- what the card measured -------------------------------------------------

func _measure_box(s: Dictionary, fin: Dictionary, gh: Dictionary, part: Dictionary, ppos: Vector3, n_ghosts: int) -> Dictionary:
	_pose(_her, fin, Vector3.ZERO)
	_pose(_spar, part, ppos)
	var row := {"kind": s["kind"], "clip": fin["clip"], "t": snappedf(float(fin["t"]), 0.001), "az": _view.get("az", s["az"]),
		"ropes": s["ropes"], "partner": "%s@%.3f" % [part["clip"], float(part["t"])]}
	if not gh.is_empty():
		row["ghost"] = "%s@%.3f" % [gh["clip"], float(gh["t"])]
		row["ghosts"] = n_ghosts
	row["pelvis_gap"] = snappedf(_bone_world(_spar, "Hips").distance_to(_bone_world(_her, "Hips")), 0.001)
	row["her_feet_y"] = snappedf(minf(_bone_world(_her, "LeftFoot").y, _bone_world(_her, "RightFoot").y), 0.001)
	row["spar_feet_y"] = snappedf(minf(_bone_world(_spar, "LeftFoot").y, _bone_world(_spar, "RightFoot").y), 0.001)
	if str(s["kind"]) == "punch":
		var r := BODY_R if bool(s["body_shot"]) else HEAD_R
		row["glove_gap"] = snappedf(_glove_tip(_her, str(fin["hand"])).distance_to(_target(_spar, bool(s["body_shot"]))) - r, 0.001)
		row["hand"] = fin["hand"]
		row["spar_scale"] = snappedf((_spar["node"] as Node3D).scale.x, 0.01)
		if fin.has("ik"):
			row["arm_reach"] = true
	elif str(s["kind"]) == "defence":
		var head := _target(_her, false)
		row["glove_to_head_now"] = snappedf(_glove_tip(_spar, str(part["hand"])).distance_to(head), 0.001)
	return row
