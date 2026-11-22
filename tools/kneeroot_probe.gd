extends SceneTree
## KNEEROOT1 (S537, owner C462-C466: "why you twist and bend the knee ... the original clip is fine", "reds gloves move
## on their own"): the BOUGHT take beside the game, frame by frame, headless, read AS DRAWN.
##   SOURCE  the bought FBX on its own skeleton (read at run time with FBXDocument: nothing is imported)
##   BAKED   the same take as baked onto our body, every pose layer off
##   GAME    the v2 player as drawn; then with one stage off at a time (the bisect)
## Per leg: valgus (the knee off the hip-ankle line toward the other leg, cm on OUR leg length), flex (deg), foot yaw
## (deg out from the facing), twist (the knee's bend direction against its own toes, deg, + = knee inside the toes),
## and the stance (width across / length along the facing, cm).
## Gloves (4 s of the waiting take): how far each wrist wanders from the chest and from the head (cm, box diagonal and
## path), and how far the GLOVE moves on its own hand (cm / deg; 0 = it is rigid on the hand).
##   <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/kneeroot_probe.gd -- [red=02 blue=01]
##       [take=pro_right_cross] [only=knee|glove] [who=1] [arms=game,-FootTake,...]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Player2 := preload("res://scripts/fight3d/v2/Player2.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const PairPlace := preload("res://scripts/fight3d/v2/PairPlace.gd")
const KR := preload("res://tools/kneeroot_lib.gd")
const PRO_FBX := "E:/FightCamp/packs/mocaponline_punch_pro/Boxing_01_v2/FBX/"
const MIX_FBX := "E:/FightCamp/packs/mixamo_steps/"
const WAIT_SRC := {"st_wait": "Bouncing_Boxing_Idle", "st_wait_g": "Bouncing_Fight_Idle_With_Guard_Up"}

var st: Node3D
var drawn: Array = [{}, {}]
var glove_xf: Array = [{}, {}]


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _initialize() -> void:
	Engine.max_fps = 60
	Player2.force = true
	FightClips.untouched = true
	st = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % _arg("red", "02"), "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % _arg("blue", "01"), "corner": "blue"})
	if st.v2 == null:
		print("KNEEROOT FAIL the v2 player was not built")
		quit(1)
		return
	for i in 2:
		var sk: Skeleton3D = st.boxers[i]["skel"]
		var ids := {}
		for b in KR.GAME_BONES:
			ids[b] = sk.find_bone(str(KR.GAME_BONES[b]))
		var d: Dictionary = drawn[i]
		var gx: Dictionary = glove_xf[i]
		var gl: Node = st.boxers[i]["gloves"]
		sk.skeleton_updated.connect(func() -> void:
			for b in ids:
				d[b] = sk.global_transform * sk.get_bone_global_pose(int(ids[b]))
			for side in gl.gloves:
				gx[side] = (gl.gloves[side] as Node3D).global_transform)
		var names: Array = []
		for c in sk.get_children():
			if c is SkeletonModifier3D:
				names.append("%s%s" % [str(c.name), "" if (c as SkeletonModifier3D).active else "(off)"])
		print("KNEEROOT %s layers: %s | scale %.3f south %s" % [_who(i), ", ".join(PackedStringArray(names)), (st.boxers[i]["node"] as Node3D).scale.x, str(st.boxers[i].get("south", false))])
	for f in 90:
		await process_frame
	var only := _arg("only", "")
	if only != "glove":
		for who in (_arg("who", "1,0").split(",", false)):
			await _knee(int(who), _arg("take", "pro_right_cross"))
	if only != "knee":
		for who in [0, 1]:
			await _glove(who)
	print("KNEEROOT done")
	quit(0)


func _who(i: int) -> String:
	return "%s mh_boxer_%s" % ["red" if i == 0 else "blue", _arg("red" if i == 0 else "blue", "02" if i == 0 else "01")]


func _mods(i: int) -> Array:
	var out: Array = []
	for c in (st.boxers[i]["skel"] as Skeleton3D).get_children():
		if c is SkeletonModifier3D:
			out.append(c)
	return out


## The world points of boxer i as drawn, in the shape KR.legs() reads.
func _pts(i: int) -> Dictionary:
	var out := {}
	for b in drawn[i]:
		out[b] = (drawn[i][b] as Transform3D).origin
	var z: Vector3 = (st.boxers[i]["node"] as Node3D).global_transform.basis.z
	out["fwd"] = Vector3(z.x, 0.0, z.z).normalized()
	return out


# ---------------------------------------------------------------- the knee
func _knee(who: int, take: String) -> void:
	var p2: Node = st.v2
	var ap: AnimationPlayer = st.boxers[who]["ap"]
	var sk: Skeleton3D = st.boxers[who]["skel"]
	var south := bool(st.boxers[who].get("south", false))
	if not ap.has_animation(take):
		print("KNEEROOT no take %s" % take)
		return
	var cs := float((p2.db["rows"].get(take, {}) as Dictionary).get("contact_s", 0.3))
	var stem := "Box1_M3_" + "_".join(PackedStringArray(Array(take.trim_prefix("pro_").split("_")).map(func(w): return str(w).to_upper() if str(w).length() <= 2 else str(w).capitalize())))
	var src := KR.load_fbx(root, PRO_FBX + stem + ".fbx")
	if src.is_empty():
		print("KNEEROOT no source %s" % stem)
		return
	var leg: float = KR.leg_len(_pts(who))
	var times: Array = []
	var k := 0
	while float(k) / 60.0 <= cs + 0.10:
		times.append(float(k) / 60.0)
		k += 1
	# SOURCE: the bought take on its own skeleton, scaled to our leg
	var rows := {}
	var src_rows: Array = []
	for t in times:
		src_rows.append(KR.legs(KR.src_pts(src, float(t)), leg, false))
	rows["SOURCE"] = src_rows
	# BAKED: the take on our body, every layer off, the clip alone
	var mods := _mods(who)
	var was: Array = mods.map(func(m): return (m as SkeletonModifier3D).active)
	for m in mods:
		(m as SkeletonModifier3D).active = false
	ap.speed_scale = 0.0
	ap.play(take)
	var baked: Array = []
	for t in times:
		ap.seek(float(t), true)
		await process_frame
		await process_frame
		baked.append(KR.legs(_pts(who), leg, south))
	rows["BAKED (layers off)"] = baked
	for n in mods.size():
		(mods[n] as SkeletonModifier3D).active = bool(was[n])
	ap.speed_scale = 1.0
	p2.guard(who)
	for f in 90:
		await process_frame
	# GAME, and the bisect
	var arms: Array = ["game"]
	for m in mods:
		if bool(was[mods.find(m)]):
			arms.append("-" + str(m.name))
	arms += ["from_pro_idle", "no_travel", "no_circle", "held", "game_again"]
	var pick := _arg("arms", "")
	if pick != "":
		arms = Array(pick.split(",", false))
	for arm in arms:
		var name := str(arm)
		var off: SkeletonModifier3D = null
		if name.begins_with("-"):
			for m in mods:
				if str(m.name) == name.substr(1):
					off = m
			if off == null:
				continue
			off.active = false
		var circ: bool = PairPlace.circle_on
		if name == "no_circle":
			PairPlace.circle_on = false
		ap.speed_scale = 1.0
		if name == "from_pro_idle":
			p2._play(who, "pro_idle", 0.0, "guard", false)
		else:
			p2.guard(who)
		for f in 90:
			await process_frame
		p2._play(who, take, 0.0, "punch", name != "no_travel")
		var got: Array = []
		got.resize(times.size())
		for f in 240:
			await process_frame
			if str(ap.current_animation) != take:
				break
			var pos := ap.current_animation_position
			var idx := int(round(pos * 60.0))
			if idx >= 0 and idx < times.size():
				got[idx] = KR.legs(_pts(who), leg, south)
			if name == "held" and pos >= cs - 0.008:
				ap.speed_scale = 0.0   # the stills' way: frozen on the contact, read 14 pictures later
				for g in 14:
					await process_frame
				got[int(round(cs * 60.0))] = KR.legs(_pts(who), leg, south)
				break
			if pos >= cs + 0.10:
				break
		rows["GAME" if name == "game" else "GAME " + name] = got
		if off != null:
			off.active = true
		PairPlace.circle_on = circ
		ap.speed_scale = 1.0
		p2.guard(who)
		for f in 60:
			await process_frame
	var ci := int(round(cs * 60.0))
	print("KNEEROOT ==== %s | %s (source %s) contact %.2f s | leg %.1f cm | lead = %s leg" % [_who(who), take, stem, cs, leg * 100.0, "RIGHT (southpaw, mirrored)" if south else "left"])
	for name in rows:
		var r: Array = rows[name]
		if r[ci] == null:
			print("KNEEROOT %-28s never reached the contact" % name)
			continue
		print("KNEEROOT %-28s AT CONTACT %s" % [name, KR.line(r[ci])])
	print("KNEEROOT ---- against the SOURCE: at the contact, and the worst picture from the start to the contact + 0.1 s")
	for name in rows:
		if name == "SOURCE":
			continue
		print("KNEEROOT %-28s %s" % [name, KR.diff_line(rows[name], src_rows, ci)])
	if _arg("show", "") != "":
		for name in rows:
			if not (name in ["SOURCE", "BAKED (layers off)", "GAME"]):
				continue
			for n in range(0, times.size(), 3):
				if (rows[name] as Array)[n] != null:
					print("KNEEROOT   %-20s %.2f s %s" % [name, float(times[n]), KR.line((rows[name] as Array)[n])])
	(src["scene"] as Node).queue_free()


# ---------------------------------------------------------------- the gloves
func _glove(who: int) -> void:
	var p2: Node = st.v2
	var ap: AnimationPlayer = st.boxers[who]["ap"]
	p2.guard(who)
	for f in 60:
		await process_frame
	var wait := str(ap.current_animation)
	var mods := _mods(who)
	var was: Array = mods.map(func(m): return (m as SkeletonModifier3D).active)
	print("KNEEROOT ==== %s | the gloves over 4 s of his waiting take %s (speed %.2f)" % [_who(who), wait, ap.speed_scale])
	# SOURCE: the bought takes on their own skeletons
	for pair in [[wait, MIX_FBX + str(WAIT_SRC.get(wait, "")) + ".fbx"], ["pro_idle", PRO_FBX + "Box1_M3_Idle.fbx"]]:
		var src := KR.load_fbx(root, str(pair[1]))
		if src.is_empty():
			continue
		var tr := KR.Trail.new()
		var length: float = (src["anim"] as Animation).length
		for k in 240:
			tr.add(KR.src_hands(src, fmod(float(k) / 60.0 * ap.speed_scale, length)), {})
		print("KNEEROOT %-34s %s" % ["SOURCE of %s" % str(pair[0]), tr.line(KR.src_scale(src))])
		(src["scene"] as Node).queue_free()
	var arms: Array = ["game"]
	for m in mods:
		if bool(was[mods.find(m)]):
			arms.append("-" + str(m.name))
	arms += ["baked", "pro_idle", "pro_idle baked", "no_face", "no_face baked", "game_again"]
	if _arg("garms", "") != "":
		arms = Array(_arg("garms", "").split(",", false))
	var gl: Node = st.boxers[who]["gloves"]
	var face: Variant = gl.get("_face")
	for arm in arms:
		var name := str(arm)
		var off: Array = []
		gl.set("_face", PackedVector3Array() if name.begins_with("no_face") else face)   # no_face: the glove is not kept off his own face (Gloves._off_face)
		if name.begins_with("-"):
			off = mods.filter(func(m): return str(m.name) == name.substr(1))
		elif name.ends_with("baked"):
			off = mods.filter(func(m): return bool(was[mods.find(m)]))
		for m in off:
			(m as SkeletonModifier3D).active = false
		if name.begins_with("pro_idle"):
			p2._play(who, "pro_idle", 0.0, "guard", false)
		else:
			p2.guard(who)
		for f in 60:
			await process_frame
		var tr := KR.Trail.new()
		var kn := [0.0, 0.0, 0.0, 0.0]
		for f in 240:
			await process_frame
			tr.add(drawn[who], glove_xf[who])
			var lg := KR.legs(_pts(who), KR.leg_len(_pts(who)), bool(st.boxers[who].get("south", false)))
			for q in 4:
				kn[q] += float(lg[["lead", "rear", "lead", "rear"][q]][["valgus", "valgus", "flex", "flex"][q]]) / 240.0
		print("KNEEROOT %-34s guard knees (mean): lead in %+.1f cm flex %.0f | rear in %+.1f cm flex %.0f" % ["GAME" if name == "game" else "GAME " + name, kn[0], kn[2], kn[1], kn[3]])
		print("KNEEROOT %-34s %s" % ["GAME" if name == "game" else "GAME " + name, tr.line(0.87 / KR.leg_len(_pts(who)))])
		if _arg("series", "") != "":
			print("KNEEROOT   %s R glove off its forearm's line every 0.1 s: %s" % [name, " ".join(PackedStringArray(range(0, 240, 6).map(func(n): return "%.0f" % float((tr.lean["R"] as Array)[n]))))])
		for m in off:
			(m as SkeletonModifier3D).active = true
	gl.set("_face", face)
	p2.guard(who)
