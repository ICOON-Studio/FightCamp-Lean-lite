extends SceneTree
## BOUGHTCLIP1 (S537, owner C468 "show me the bought clip", C469 "Cross can only reach shoulder?", C471 "too much
## twisting or bending. Maybe the foot needs to move a bit"): the cross AS BOUGHT against our body, in numbers, headless.
##   SOURCE  the bought FBX on its own skeleton (read at run time: nothing is imported), lengths scaled to our leg
##   BAKED   the same take on our body, every pose layer off, the take's own travel on the body
##   GAME    a LANDED cross of a planned exchange (the other man in range, the arm finish on): what the game shows
## Per picture: the punching arm (how straight, where the wrist is), the heights, both legs, and the rear foot through
## the whole take (does it turn on its ball?). GAME also: the glove against the other man's nose, chin and shoulders.
##   <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/boughtclip_probe.gd -- [red=02 blue=01] [seed=7]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Player2 := preload("res://scripts/fight3d/v2/Player2.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const RS := preload("res://scripts/rules/RoundScript.gd")
const KR := preload("res://tools/kneeroot_lib.gd")
const PRO_FBX := "E:/FightCamp/packs/mocaponline_punch_pro/Boxing_01_v2/FBX/"
const TAKE := "pro_right_cross"
const EXTRA_GAME := {"arm_L": "LeftUpperArm", "arm_R": "RightUpperArm", "neck": "Neck"}
const EXTRA_SRC := {"arm_L": "LeftArm", "arm_R": "RightArm", "neck": "Neck"}
const NOSE_REST := Vector3(0.0, 1.578, 0.118)   # FighterFace.SCAR_AT: the nose tip in the body's rest space
const CHIN_UNDER_NOSE_M := 0.08                 # nose tip to the point of the chin on a grown man (not read off the mesh)

var st: Node3D
var drawn: Array = [{}, {}]


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
		print("BOUGHT FAIL the v2 player was not built")
		quit(1)
		return
	var all: Dictionary = KR.GAME_BONES.merged(EXTRA_GAME)
	for i in 2:
		var sk: Skeleton3D = st.boxers[i]["skel"]
		var ids := {}
		for b in all:
			ids[b] = sk.find_bone(str(all[b]))
		var d: Dictionary = drawn[i]
		sk.skeleton_updated.connect(func() -> void:
			for b in ids:
				d[b] = sk.global_transform * sk.get_bone_global_pose(int(ids[b]))
			if i == 1:   # the glove as drawn: read while the layers' pose is on the skeleton (Player2._measure does the same)
				(st.boxers[1]["gloves"] as Node)._follow()
				d["glove"] = Transform3D(Basis.IDENTITY, st.glove_front(1, "RightHand")))
	for f in 90:
		await process_frame
	var p2: Node = st.v2
	var cs := float(p2.db["rows"][TAKE].get("contact_s", 0.3))
	var length: float = (st.boxers[1]["ap"] as AnimationPlayer).get_animation(TAKE).length
	var leg: float = KR.leg_len(_pts(1))
	print("BOUGHT take %s contact %.2f s length %.2f s | blue scale %.3f red scale %.3f | blue southpaw %s | our leg %.1f cm" % [TAKE, cs, length,
		(st.boxers[1]["node"] as Node3D).scale.x, (st.boxers[0]["node"] as Node3D).scale.x, str(st.boxers[1].get("south", false)), leg * 100.0])
	# ---- SOURCE
	var src := KR.load_fbx(root, PRO_FBX + "Box1_M3_Right_Cross.fbx")
	if src.is_empty():
		print("BOUGHT FAIL no source file")
		quit(1)
		return
	_tree(src["scene"], 0)
	var sskel: Skeleton3D = src["skel"]
	var xid := {}
	for b in EXTRA_SRC:
		xid[b] = sskel.find_bone(str(EXTRA_SRC[b]))
	var s0 := _src_pts(src, xid, 0.0)
	var k: float = leg / KR.leg_len(s0)
	var sfloor: float = minf((s0["toe_L"] as Vector3).y, (s0["toe_R"] as Vector3).y)
	print("BOUGHT source: %d bones, take %.2f s, size x%.4f to our leg, its toe joints stand at y %.3f (own units), skeleton scale %s" % [
		sskel.get_bone_count(), (src["anim"] as Animation).length, k, sfloor, str(sskel.global_transform.basis.get_scale())])
	var src_rows: Array = []
	var n_pics := int(length * 60.0) + 1
	for n in n_pics:
		src_rows.append(_scaled(_src_pts(src, xid, float(n) / 60.0), k, sfloor))
	# ---- BAKED: the take alone on our body
	var ap: AnimationPlayer = st.boxers[1]["ap"]
	var mods: Array = (st.boxers[1]["skel"] as Skeleton3D).get_children().filter(func(c): return c is SkeletonModifier3D and (c as SkeletonModifier3D).active)
	p2.guard(1)
	for f in 70:
		await process_frame
	for m in mods:
		(m as SkeletonModifier3D).active = false
	p2._play(1, TAKE, 0.0, "punch", true)
	var baked: Array = []
	baked.resize(n_pics)
	var baked_glove := Vector3.ZERO
	for f in 80:
		await process_frame
		if str(ap.current_animation) != TAKE:
			break
		var idx := int(round(ap.current_animation_position * 60.0))
		if idx < n_pics:
			baked[idx] = _scaled(_pts(1), 1.0, 0.0)
			if idx == int(round(cs * 60.0)):
				baked_glove = (drawn[1]["glove"] as Transform3D).origin
				var bn: Node3D = st.boxers[1]["node"]
				var bf: Vector3 = _pts(1)["fwd"]
				print("BOUGHT BAKED alone at the contact: glove front %.1f cm ahead of his body's place, wrist %.1f, hips %.1f; the take has carried his place %.1f cm on" % [(baked_glove - bn.position).dot(bf) * 100.0,
					((_pts(1)["hand_R"] as Vector3) - bn.position).dot(bf) * 100.0, ((_pts(1)["hips"] as Vector3) - bn.position).dot(bf) * 100.0, (bn.position - (p2._take[1].get("origin", bn.position) as Vector3)).dot(bf) * 100.0])
	for m in mods:
		(m as SkeletonModifier3D).active = true
	p2.guard(1)
	for f in 70:
		await process_frame
	# ---- GAME: landed crosses of a planned exchange
	var games: Array = await _game(p2, cs, n_pics)
	var ci := int(round(cs * 60.0))
	print("BOUGHT ==== sizes, both on a %.1f cm leg (source scaled): source / ours, cm" % [leg * 100.0])
	print("BOUGHT   %s" % _sizes(src_rows[0], baked[_first(baked)]))
	print("BOUGHT ==== AT THE CONTACT (%.2f s)" % cs)
	print("BOUGHT SOURCE (as bought)     %s" % _line(src_rows[ci]))
	print("BOUGHT BAKED (take alone)     %s" % _line(baked[ci]))
	for g in games:
		print("BOUGHT GAME landed t %.2f s  %s" % [float(g["t"]), _line(g["rows"][ci]) if g["rows"][ci] != null else "never reached the contact"])
	print("BOUGHT ---- legs at the contact")
	print("BOUGHT SOURCE                 %s" % KR.line(KR.legs(src_rows[ci], leg, false)))
	print("BOUGHT BAKED                  %s" % KR.line(KR.legs(baked[ci], leg, false)))
	for g in games:
		if g["rows"][ci] != null:
			print("BOUGHT GAME t %.2f             %s" % [float(g["t"]), KR.line(KR.legs(g["rows"][ci], leg, false))])
	print("BOUGHT ---- the glove front at the contact: baked take alone y %.3f m" % baked_glove.y)
	for g in games:
		print("BOUGHT GAME t %.2f %s" % [float(g["t"]), str(g["reach"])])
	print("BOUGHT ==== THE REAR (right) FOOT through the take: turn out from his facing (deg) | heel (ankle) above its start (cm) | ball moved on the floor (cm) | rear knee bend (deg)")
	for n in range(0, n_pics, 3):
		var parts: Array = ["%.2f s" % (float(n) / 60.0)]
		for pair in [["SOURCE", src_rows], ["BAKED", baked]] + ([["GAME", games[0]["rows"]]] if not games.is_empty() else []):
			var rows: Array = pair[1]
			var z := _first(rows)
			if rows[n] == null or z < 0:
				parts.append("%s -" % str(pair[0]))
				continue
			parts.append("%s %s" % [str(pair[0]), _foot(rows[n], rows[z], leg)])
		print("BOUGHT   %s" % "  ||  ".join(PackedStringArray(parts)))
	print("BOUGHT done")
	quit(0)


func _first(rows: Array) -> int:
	for n in rows.size():
		if rows[n] != null:
			return n
	return -1


func _tree(n: Node, depth: int) -> void:
	if depth > 3:
		return
	var extra := ""
	if n is MeshInstance3D:
		var mi := n as MeshInstance3D
		extra = " MESH %d surfaces, skin %s, box %s" % [mi.mesh.get_surface_count() if mi.mesh != null else 0, str(mi.skin != null), str(mi.get_aabb().size)]
	print("BOUGHT tree %s%s (%s)%s" % ["  ".repeat(depth), n.name, n.get_class(), extra])
	for c in n.get_children():
		_tree(c, depth + 1)


## Blue or red as drawn: world points in KR's shape (+ shoulders and neck).
func _pts(i: int) -> Dictionary:
	var out := {}
	for b in drawn[i]:
		out[b] = (drawn[i][b] as Transform3D).origin
	var z: Vector3 = (st.boxers[i]["node"] as Node3D).global_transform.basis.z
	out["fwd"] = Vector3(z.x, 0.0, z.z).normalized()
	return out


func _src_pts(src: Dictionary, xid: Dictionary, t: float) -> Dictionary:
	var p: Dictionary = KR.src_pts(src, t)
	var sk: Skeleton3D = src["skel"]
	for b in xid:
		p[b] = sk.global_transform * sk.get_bone_global_pose(int(xid[b])).origin
	return p



## Points scaled by k about the floor (y - floor), so heights read in metres on our body.
func _scaled(p: Dictionary, k: float, floor_y: float) -> Dictionary:
	var out := {}
	for b in p:
		if b == "fwd":
			out[b] = p[b]
		else:
			var v: Vector3 = p[b]
			out[b] = Vector3(v.x * k, (v.y - floor_y) * k, v.z * k)
	return out


func _sizes(s: Dictionary, o: Dictionary) -> String:
	var parts: Array = []
	for d in [["thigh", "hip_R", "knee_R"], ["shin", "knee_R", "ankle_R"], ["foot (ankle-ball)", "ankle_R", "toe_R"], ["upper arm", "arm_R", "elbow_R"], ["forearm", "elbow_R", "hand_R"],
			["shoulders across", "arm_L", "arm_R"], ["hips across", "hip_L", "hip_R"], ["hips to neck", "hips", "neck"], ["neck to head joint", "neck", "head"]]:
		parts.append("%s %.1f / %.1f" % [d[0], ((s[d[1]] as Vector3) - (s[d[2]] as Vector3)).length() * 100.0, ((o[d[1]] as Vector3) - (o[d[2]] as Vector3)).length() * 100.0])
	return "; ".join(PackedStringArray(parts))


## The punching (right) arm and the heights of one picture.
func _line(p: Dictionary) -> String:
	var sh: Vector3 = p["arm_R"]
	var el: Vector3 = p["elbow_R"]
	var wr: Vector3 = p["hand_R"]
	var fwd: Vector3 = p["fwd"]
	var ext := (wr - sh).length() / maxf((el - sh).length() + (wr - el).length(), 1e-4) * 100.0
	var arm := wr - sh
	var pitch := rad_to_deg(atan2(arm.y, Vector2(arm.x, arm.z).length()))
	return "arm %.0f%% straight, pointing %+.0f deg (up +) | heights m: wrist %.2f, right shoulder %.2f, neck %.2f, head joint %.2f, hips %.2f | wrist ahead of hips %.0f cm, of the lead toe %.0f cm | trunk: neck ahead of hips %.0f cm" % [
		ext, pitch, wr.y, sh.y, (p["neck"] as Vector3).y, (p["head"] as Vector3).y, (p["hips"] as Vector3).y, (wr - (p["hips"] as Vector3)).dot(fwd) * 100.0,
		(wr - (p["toe_L"] as Vector3)).dot(fwd) * 100.0, ((p["neck"] as Vector3) - (p["hips"] as Vector3)).dot(fwd) * 100.0]


func _foot(p: Dictionary, p0: Dictionary, leg: float) -> String:
	var l: Dictionary = KR.legs(p, leg, false)
	var ball: Vector3 = (p["toe_R"] as Vector3) - (p0["toe_R"] as Vector3)
	return "turn %+4.0f | heel %+5.1f | ball %4.1f | knee %3.0f" % [float(l["rear"]["yaw"]), ((p["ankle_R"] as Vector3).y - (p0["ankle_R"] as Vector3).y) * 100.0,
		Vector2(ball.x, ball.z).length() * 100.0, float(l["rear"]["flex"])]


## Plays planned exchanges until blue has landed the plain cross (up to three of them): each one's pictures by take time.
func _game(p2: Node, cs: float, n_pics: int) -> Array:
	var out: Array = []
	var ap: AnimationPlayer = st.boxers[1]["ap"]
	var sd := int(_arg("seed", "7"))
	var t0 := 0.0
	for attempt in 40:
		if out.size() >= 3:
			break
		var round := {"n": 1, "won": attempt % 2 == 1, "mine": 60.0, "theirs": 55.0, "corner": "", "lines": []}
		var beats: Array = RS.build(round, ["Boxer", "Slugger"][attempt % 2], ["Slugger", "Boxer"][(attempt / 2) % 2], 30.0, sd + attempt)["beats"]
		for b in beats:
			b["t"] = float(b["t"]) + t0
		p2.queue(beats, t0, t0 + 30.0)
		var want: Array = (p2.plan["tracks"]["b"] as Array).filter(func(e): return str(e["kind"]) == "punch" and str(e["clip"]) == TAKE and str(e.get("result", "")) == "lands")
		print("BOUGHT plan seed %d: blue lands the plain cross %d times%s" % [sd + attempt, want.size(), "" if want.is_empty() else " (first at %.2f s, contact %.2f s)" % [float(want[0]["t"]), float(want[0]["contact_t"])]])
		if want.is_empty():
			continue
		var until: float = float(want[mini(want.size(), 3 - out.size()) - 1]["contact_t"]) + 0.8
		var t := t0
		var cur := {}
		while t < until:
			p2.clock(t, true)
			await process_frame
			t += 1.0 / 60.0
			if str(ap.current_animation) != TAKE or str(p2._take[1].get("kind", "")) != "punch":
				cur = {}
				continue
			var born := float(p2._take[1].get("at", -1.0))
			var mine: Array = want.filter(func(e): return absf(float(e["t"]) - born) < 0.05)
			if mine.is_empty():
				continue
			if cur.is_empty() or float(cur["t"]) != born:
				var rows: Array = []
				rows.resize(n_pics)
				cur = {"t": born, "rows": rows, "reach": "no contact picture"}
				out.append(cur)
			var idx := int(round(ap.current_animation_position * 60.0))
			if idx < n_pics:
				cur["rows"][idx] = _scaled(_pts(1), 1.0, 0.0)
			if idx == int(round(cs * 60.0)):
				cur["reach"] = _reach(p2)
		p2.clock(t, false)
		t0 += 60.0
		for f in 30:
			await process_frame
	return out


## The landed cross on its contact picture: the glove against the other man.
func _reach(p2: Node) -> String:
	var g: Vector3 = (drawn[1]["glove"] as Transform3D).origin
	var red: Dictionary = _pts(0)
	var blue: Dictionary = _pts(1)
	var rsk: Skeleton3D = st.boxers[0]["skel"]
	var head_rest := rsk.get_bone_global_rest(rsk.find_bone("Head"))
	var head_now: Transform3D = drawn[0]["head"]
	var nose: Vector3 = head_now * (head_rest.affine_inverse() * NOSE_REST)
	var s: float = (st.boxers[0]["node"] as Node3D).scale.x
	var chin := nose - head_now.basis.y.normalized() * CHIN_UNDER_NOSE_M * s
	var sh: float = ((red["arm_L"] as Vector3).y + (red["arm_R"] as Vector3).y) * 0.5
	var tp: Vector3 = p2.target(0, false)
	var aim: Node = p2._aim[1]
	var moved: Vector3 = (st.boxers[1]["skel"] as Skeleton3D).global_transform.basis * (aim.get("_closed") as Vector3)
	var hips := (red["hips"] as Vector3) - (blue["hips"] as Vector3)
	return "glove front y %.3f m | red: nose %.3f, chin %.3f, shoulders %.3f, head joint %.3f, the aimed point %.3f | glove is %+.0f cm against his chin, %+.0f against his shoulders, %.1f cm from the aimed point | the arm finish moved the glove %.0f cm (up %+.0f, forward %+.0f), left %.1f cm unclosed | hips apart %.2f m, gap %.2f m | blue head joint %.3f, shoulder %.3f; red standing head joint %.3f | along the line: glove front %+.0f cm past his nose tip, his head joint %.0f cm ahead of his own hips, blue's place %.0f cm on from where the punch began | places apart %.1f cm; his aimed point %.1f cm ahead of his place, his head joint %.1f, his hips %.1f; blue's hips %.1f cm ahead of blue's place, wrist %.1f" % [
		g.y, nose.y, chin.y, sh, (red["head"] as Vector3).y, tp.y, (g.y - chin.y) * 100.0, (g.y - sh) * 100.0, g.distance_to(tp) * 100.0,
		moved.length() * 100.0, moved.y * 100.0, moved.dot(blue["fwd"]) * 100.0, float(aim.left_m) * 100.0,
		Vector2(hips.x, hips.z).length(), float(p2.pair.gap()), (blue["head"] as Vector3).y, (blue["arm_R"] as Vector3).y, head_rest.origin.y * s,
		(g - nose).dot(blue["fwd"]) * 100.0, ((red["hips"] as Vector3) - (red["head"] as Vector3)).dot(blue["fwd"]) * 100.0,
		(((st.boxers[1]["node"] as Node3D).position - (p2._take[1].get("origin", Vector3.ZERO) as Vector3)) as Vector3).length() * 100.0,
		float(p2.pair.node_gap()) * 100.0, (tp - (st.boxers[0]["node"] as Node3D).position).dot(-(blue["fwd"] as Vector3)) * 100.0,
		((red["head"] as Vector3) - (st.boxers[0]["node"] as Node3D).position).dot(-(blue["fwd"] as Vector3)) * 100.0,
		((red["hips"] as Vector3) - (st.boxers[0]["node"] as Node3D).position).dot(-(blue["fwd"] as Vector3)) * 100.0,
		((blue["hips"] as Vector3) - (st.boxers[1]["node"] as Node3D).position).dot(blue["fwd"]) * 100.0,
		((blue["hand_R"] as Vector3) - (st.boxers[1]["node"] as Node3D).position).dot(blue["fwd"]) * 100.0]
