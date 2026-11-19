extends SceneTree
## FIGHTPLAYER2 phase 1 (S512): THE CLIP CENSUS. Every owned fight take measured AS BOUGHT on our body - its own hip
## travel kept (FightClips.as_bought: no hold_root_xz, no fixed/ retime), every fight layer off (clip_orbit's
## strip_modifiers; only the skin's twist helpers run) - at 60 Hz, and written to assets/data/clip_db.json. The rules
## (which takes play, families, drop bars) are scripts/fight3d/v2/ClipCensus.gd; tests/clip_db_test.gd holds the table.
## Headless: <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/clip_census.gd [-- dry]
##
## THE FRAME. The thrower stands as the stage puts him, facing +Z (his node's basis.z); everything is measured from his
## hips on the take's first frame. The other man is the staged defender in the first frame of the guard: his face point
## (FightStage.target_point's rule on the raw head bone) and rib point relative to HIS hips are carried to any gap.
## PER TAKE: length, hips travel (forward/side at the furthest frame, at the end, the most), head travel, the most the
##   face tips up from the first frame, frames with a hand over the crown, the most the chest turns from the other man,
##   the mean knee angle (left, right).
## A PUNCH: contact_gap_m = the pelvis-to-pelvis gap this take is FOR: how deep the glove front gets while it is on the
##   target's line sideways (see _land), carried to the other man's face (ribs for a body shot); contact_s = when;
##   side_m / up_m = the glove front from the target point then (+ = to his left / above it; the face point is at eye
##   height, the chin 17 cm under it); miss_m = how far OUTSIDE the target zone that is (ClipCensus.zone_miss; 0 = on the
##   head / the trunk); glove_y_m / own_head_y_m = the glove's and his own head's height then; hips_at_contact_m = the
##   hips' forward travel then; head_fwd_m = his own head in front of his first-frame hips then (the choreographer's
##   heads-apart rule); start_s = where a lone punch may start (punch_pace.json's dead wind-up trim); home_s = from contact until the punching hand is back within HOME_M of where it started
##   (relative to the hips; -1 = never inside the take).
## A REACTION / DEFENCE / BLOCK: head_peak_m and head_peak_s (the head's furthest point from its first frame, with the
##   body's travel), head_dir [back, side, up] (unit, in his own frame: back = away from the puncher), head_rel_m (the
##   same without the hips' travel: the snap alone), back_s (when the head is back within HOME_M over the hips; -1 never).

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const PR := preload("res://scripts/fight3d/PunchReach.gd")
const Orbit := preload("res://tools/clip_orbit.gd")
const Census := preload("res://scripts/fight3d/v2/ClipCensus.gd")
const HZ := 60.0
const HOME_M := 0.08
## The strike: from STRIKE_BEFORE_S before the take's furthest point (clip_contact.json far_s, the reviewed anchor) to
## STRIKE_AFTER_S past it. A take with no row there: its furthest point = the glove's furthest from where it started,
## over the hips, in the first STRIKE_SHARE of the take (the reach, never the hand coming home).
const STRIKE_BEFORE_S := 0.30
const STRIKE_AFTER_S := 0.05
const STRIKE_SHARE := 0.75
const FINE_HZ := 240.0
const DRIVE_SHARE := 0.5
const LINE_M := 0.03
const ZONE_TIE_M := 0.02
## Not fight takes: the corner team, the ring entry, the clinch pair, the long corner warm-up bakes.
const SKIP := ["af_", "entry_", "clinch_", "cmu_", "rk_", "st_"]   # st_: the step takes have their own census (tools/step_census.gd)
const BONES := ["Hips", "Head", "Chest", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm",
	"RightUpperArm", "LeftMiddleProximal", "RightMiddleProximal", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg",
	"RightLowerLeg", "LeftFoot", "RightFoot"]

var skel: Skeleton3D
var ap: AnimationPlayer
var ids := {}
var fwd := Vector3.BACK
var side := Vector3.RIGHT
var scale := 1.0
var front := 0.15
var face_off := Vector3.ZERO   # the defender's face point from his hips (horizontal), and its height in .y
var ribs_off := Vector3.ZERO
var lat := Vector3.ZERO        # the staged pair's sideways offset, hips to hips
var contact_rows := {}
var head_fwd := 0.0            # the defender's head bone in front of his own hips, on the guard's first frame


func _initialize() -> void:
	var dry := OS.get_cmdline_user_args().has("dry")
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
	scale = (bx["node"] as Node3D).scale.x
	front = float(bx.get("front", 0.15))
	fwd = (bx["node"] as Node3D).global_transform.basis.z.normalized()
	side = Vector3.UP.cross(fwd).normalized()
	print("CENSUS layers off: ", ",".join(Orbit.strip_modifiers(skel)))
	for b in BONES:
		ids[b] = skel.find_bone(b)
		if int(ids[b]) < 0:
			print("CENSUS FAIL no bone ", b)
			quit(1)
			return
	_defender(st)
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(BeatClips.CONTACT_PATH))
	contact_rows = parsed if parsed is Dictionary else {}
	var guard := BeatClips.first(BeatClips.GUARD, ap.has_animation)
	var names: Array = []
	for n in ap.get_animation_list():
		if not SKIP.any(func(p): return str(n).begins_with(str(p))):
			names.append(str(n))
	names.sort()
	var played: Array = Census.played(func(n): return names.has(str(n)))
	var rows := {}
	var dropped := {}
	for name in names:
		var row := _measure(name)
		var why: Array = Census.drop_reasons(name, row)
		row["drop"] = why
		row["flags"] = Census.flags(row)
		row["played"] = played.has(name)
		rows[name] = row
		if not why.is_empty():
			dropped[name] = why
		print("CENSUS %s %s" % [name, JSON.stringify(row)])
	var db := {
		"meta": {"tool": "tools/clip_census.gd", "hz": HZ, "as_bought": true, "body": "mh_boxer_10", "guard": guard,
			"scale": snappedf(scale, 0.001), "glove_front_m": snappedf(front * scale, 0.001),
			"face_from_hips_m": [_r(face_off.dot(side)), _r(face_off.y), _r(face_off.dot(fwd))],
			"ribs_from_hips_m": [_r(ribs_off.dot(side)), _r(ribs_off.y), _r(ribs_off.dot(fwd))], "fit_m": Census.FIT_M,
			"head_from_hips_m": _r(head_fwd)},
		"names": names, "played": played, "dropped": dropped, "rows": rows,
	}
	var missing: Array = played.filter(func(n): return not rows.has(n))
	print("CENSUS %d takes measured, %d played, %d dropped (%d of them played), played without a row: %s" % [names.size(),
		played.size(), dropped.size(), played.filter(func(n): return dropped.has(n)).size(), str(missing)])
	if not dry:
		var f := FileAccess.open(Census.DB_PATH, FileAccess.WRITE)
		f.store_string(JSON.stringify(db, "\t", true))
		f.close()
		print("CENSUS DONE -> ", Census.DB_PATH)
	quit(0 if missing.is_empty() else 1)


static func _r(v: float) -> float:
	return snappedf(v, 0.001)


## The other man's face and rib points from his own hips, read on the guard's first frame with his layers off.
func _defender(st: Node3D) -> void:
	var d: Dictionary = st.boxers[1]
	var ds: Skeleton3D = d["skel"]
	var dap: AnimationPlayer = d["ap"]
	Orbit.strip_modifiers(ds)
	var guard := BeatClips.first(BeatClips.GUARD, dap.has_animation)
	dap.play(guard)
	dap.seek(0.0, true)
	ap.play(guard)
	ap.seek(0.0, true)
	var w := ds.global_transform
	var dfwd: Vector3 = (d["node"] as Node3D).global_transform.basis.z.normalized()
	var s: float = (d["node"] as Node3D).scale.x
	var hips: Vector3 = w * ds.get_bone_global_pose(ds.find_bone("Hips")).origin
	var head: Vector3 = w * ds.get_bone_global_pose(ds.find_bone("Head")).origin
	var chest: Vector3 = w * ds.get_bone_global_pose(ds.find_bone("Chest")).origin
	var face := head + (dfwd * Stage.FACE_FWD_M + Vector3.UP * Stage.FACE_UP_M) * s
	var ribs := chest + (dfwd * 0.11 + Vector3.DOWN * 0.14) * s
	face_off = Vector3(face.x - hips.x, face.y, face.z - hips.z)
	ribs_off = Vector3(ribs.x - hips.x, ribs.y, ribs.z - hips.z)
	head_fwd = (head - hips).dot(dfwd)
	var mine: Vector3 = skel.global_transform * skel.get_bone_global_pose(int(ids["Hips"])).origin
	var between := hips - mine
	lat = side * between.dot(side)
	print("CENSUS staged pair: hips %.3f m apart (%.3f to the side), face %.3f m up and %.3f m in front of his hips, ribs %.3f / %.3f" % [
		between.dot(fwd), between.dot(side), face.y, -face_off.dot(fwd), ribs.y, -ribs_off.dot(fwd)])


func _pose(clip: String, t: float) -> Dictionary:
	ap.play(clip)
	ap.seek(t, true)
	var w := skel.global_transform
	var p := {}
	for b in BONES:
		p[b] = w * skel.get_bone_global_pose(int(ids[b])).origin
	p["head_basis"] = (w * skel.get_bone_global_pose(int(ids["Head"]))).basis.orthonormalized()
	for s in ["Left", "Right"]:
		var axis: Vector3 = ((p[s + "MiddleProximal"] as Vector3) - (p[s + "Hand"] as Vector3)).normalized()
		var fore: Vector3 = ((p[s + "Hand"] as Vector3) - (p[s + "LowerArm"] as Vector3)).normalized()
		if PR.STRAIGHT > 0.0 and axis.angle_to(fore) > 1e-3:
			axis = axis.slerp(fore, PR.STRAIGHT).normalized()
		p[s + "Glove"] = (p[s + "Hand"] as Vector3) + axis * front * scale
	return p


static func _flat(v: Vector3) -> Vector3:
	return Vector3(v.x, 0.0, v.z)


static func _knee(p: Dictionary, s: String) -> float:
	var k: Vector3 = p[s + "LowerLeg"]
	return rad_to_deg(((p[s + "UpperLeg"] as Vector3) - k).angle_to((p[s + "Foot"] as Vector3) - k))


func _measure(clip: String) -> Dictionary:
	var length: float = ap.get_animation(clip).length
	var n := maxi(2, int(floor(length * HZ)) + 1)
	var ps: Array = []
	for i in n:
		ps.append(_pose(clip, minf(i / HZ, length)))
	var p0: Dictionary = ps[0]
	var face_local: Vector3 = (p0["head_basis"] as Basis).inverse() * fwd
	var hips_max := 0.0
	var hips_far := Vector3.ZERO
	var head_max := 0.0
	var head_i := 0
	var rel_max := 0.0
	var rels := PackedFloat32Array()   # S526: the head against the hips, frame by frame (head_rel_s)
	var face_up := 0.0
	var crown := 0
	var turn := 0.0
	var pelvis := 0.0
	var knee := Vector2.ZERO
	for i in n:
		var p: Dictionary = ps[i]
		var h: Vector3 = _flat((p["Hips"] as Vector3) - (p0["Hips"] as Vector3))
		if h.length() > hips_max:
			hips_max = h.length()
			hips_far = h
		var hd: Vector3 = (p["Head"] as Vector3) - (p0["Head"] as Vector3)
		if hd.length() > head_max:
			head_max = hd.length()
			head_i = i
		rels.append((hd - ((p["Hips"] as Vector3) - (p0["Hips"] as Vector3))).length())
		rel_max = maxf(rel_max, rels[i])
		face_up = maxf(face_up, rad_to_deg(asin(clampf(((p["head_basis"] as Basis) * face_local).normalized().y, -1.0, 1.0))))
		var top: float = (p["Head"] as Vector3).y + Census.OVER_CROWN_M * scale
		if (p["LeftHand"] as Vector3).y > top or (p["RightHand"] as Vector3).y > top:
			crown += 1
		var line: Vector3 = _flat((p["LeftUpperArm"] as Vector3) - (p["RightUpperArm"] as Vector3))
		if line.length() > 0.01:
			turn = maxf(turn, rad_to_deg(line.cross(Vector3.UP).normalized().angle_to(fwd)))
		var hl: Vector3 = _flat((p["LeftUpperLeg"] as Vector3) - (p["RightUpperLeg"] as Vector3))
		if hl.length() > 0.01:
			pelvis = maxf(pelvis, rad_to_deg(hl.cross(Vector3.UP).normalized().angle_to(fwd)))
		knee += Vector2(_knee(p, "Left"), _knee(p, "Right")) / float(n)
	var pe: Dictionary = ps[n - 1]
	var row := {
		"kind": Census.kind(clip), "length_s": _r(length), "hips_fwd_m": _r(hips_far.dot(fwd)), "hips_side_m": _r(hips_far.dot(side)),
		"hips_end_m": _r(_flat((pe["Hips"] as Vector3) - (p0["Hips"] as Vector3)).length()), "hips_max_m": _r(hips_max),
		"head_max_m": _r(head_max), "face_up_deg": snappedf(face_up, 0.1), "over_crown_frames": crown, "turn_deg": snappedf(turn, 0.1),
		"pelvis_turn_deg": snappedf(pelvis, 0.1),
		"knee_deg": [snappedf(knee.x, 0.1), snappedf(knee.y, 0.1)],
	}
	var fam: Array = Census.family(clip)
	if clip in BeatClips.PUNCH:
		fam = [clip, "native"]
	if row["kind"] == "punch":
		row["family"] = fam[0]
		row["form"] = fam[1]
		row.merge(_punch(clip, ps, str(fam[0])))
	elif row["kind"] in ["reaction", "defence", "block"]:
		var hd: Vector3 = (ps[head_i]["Head"] as Vector3) - (p0["Head"] as Vector3)
		var dir := hd.normalized() if hd.length() > 0.001 else Vector3.ZERO
		var back := -1.0
		for i in range(head_i, n):
			var p: Dictionary = ps[i]
			if (((p["Head"] as Vector3) - (p["Hips"] as Vector3)) - ((p0["Head"] as Vector3) - (p0["Hips"] as Vector3))).length() <= HOME_M:
				back = i / HZ
				break
		row.merge({"head_peak_m": _r(head_max), "head_peak_s": _r(head_i / HZ), "size": Census.react_size(head_max),
			"head_dir": [snappedf(-dir.dot(fwd), 0.01), snappedf(dir.dot(side), 0.01), snappedf(dir.y, 0.01)],
			"head_rel_m": _r(rel_max), "head_rel_s": _r(_first_peak(rels, rel_max) / HZ), "back_s": _r(back)})
	return row


## S526 the frame of the head's FIRST peak against the hips: the first frame within 85 % of the take's most, walked on
## to the top of that rise. (head_peak_s is the head's furthest point WITH the body's travel: on a gut shot that is the
## end of the stagger, 0.5-1 s after the fold; a reaction started there never shows the fold.)
func _first_peak(rels: PackedFloat32Array, most: float) -> int:
	var i := 0
	while i < rels.size() and rels[i] < most * 0.85:
		i += 1
	# ... to the top of that rise: on while anything in the next 0.15 s is higher (a 1-frame dip is not the top)
	var look := int(HZ * 0.15)
	var moved := true
	while moved:
		moved = false
		for k in range(i + 1, mini(i + look + 1, rels.size())):
			if rels[k] > rels[i]:
				i = k
				moved = true
				break
	return mini(i, maxi(rels.size() - 1, 0))


## The punch measures (see the header) for the hand the take throws: by its name, or the nearer of the two.
func _punch(clip: String, ps: Array, fam: String) -> Dictionary:
	var hands: Array = ["Left", "Right"]
	if clip.contains("left_") or clip.contains("kidney") or clip.contains("lead_") or clip == "mc_jab" or clip == "jab":
		hands = ["Left"]
	elif clip.contains("right_") or clip.contains("rear_") or clip.contains("cross"):
		hands = ["Right"]
	var body := fam == "body_hook" or clip.contains("body") or clip.contains("kidney")
	var off: Vector3 = ribs_off if body else face_off
	var p0: Dictionary = ps[0]
	var base: Vector3 = _flat(p0["Hips"]) + lat + _flat(off) + Vector3.UP * off.y
	var best := {}
	for hand in hands:
		var got := _land(clip, ps, str(hand), base, body, fam in Census.STRAIGHTS or fam == "")
		if best.is_empty() or float(got["miss_m"]) < float(best["miss_m"]):
			best = got
	var ci := clampi(int(round(float(best["contact_s"]) * HZ)), 0, ps.size() - 1)
	var hand := str(best["hand"]).trim_suffix("Hand")
	var start: Vector3 = (p0[hand + "Hand"] as Vector3) - (p0["Hips"] as Vector3)
	var home := -1.0
	for i in range(ci + 1, ps.size()):
		if (((ps[i][hand + "Hand"] as Vector3) - (ps[i]["Hips"] as Vector3)) - start).length() <= HOME_M:
			home = (i - ci) / HZ
			break
	best["hips_at_contact_m"] = _r(_flat((ps[ci]["Hips"] as Vector3) - (p0["Hips"] as Vector3)).dot(fwd))
	best["head_fwd_m"] = _r(_flat((ps[ci]["Head"] as Vector3) - (p0["Hips"] as Vector3)).dot(fwd))
	best["start_s"] = _r(minf(BeatClips.start_s(clip), maxf(0.0, float(best["contact_s"]) - 0.12)))
	best["home_s"] = _r(home)
	for k in ["contact_gap_m", "miss_m", "contact_s", "side_m", "up_m", "glove_y_m", "own_head_y_m"]:
		best[k] = _r(float(best[k]))
	return best


## One hand's landing. `base` = the target at gap 0 (the thrower's first-frame hips + the defender's offsets), so a glove
## front that is d metres past `base` along the thrower's front is ON the target's depth at a gap of d.
## The strike is re-sampled at FINE_HZ (a glove at 10 m/s moves 17 cm between two 60 Hz frames). The DRIVE = from the
## first fine frame at DRIVE_SHARE of the strike's top glove speed. Of the drive's frames, those where the glove is on
## the target's line sideways (within LINE_M of the nearest it comes) are the punch on its line; the DEEPEST of them is
## the contact: the gap this take is for. side_m / up_m = the glove front from the target then (+ = his left / above).
func _land(clip: String, ps: Array, hand: String, base: Vector3, body: bool, straight: bool) -> Dictionary:
	var n := ps.size()
	var length: float = ap.get_animation(clip).length
	var far := -1
	var crow: Dictionary = contact_rows.get(clip, {})
	if str(crow.get("hand", "")) == hand + "Hand":
		far = int(round(float(crow.get("far_s", -1.0)) * HZ))
	if far < 1 or far >= n:
		var start: Vector3 = (ps[0][hand + "Glove"] as Vector3) - (ps[0]["Hips"] as Vector3)
		var most := -1.0
		for i in range(1, int(STRIKE_SHARE * (n - 1)) + 1):
			var d := (((ps[i][hand + "Glove"] as Vector3) - (ps[i]["Hips"] as Vector3)) - start).length()
			if d > most:
				most = d
				far = i
	var t0 := maxf(0.0, far / HZ - STRIKE_BEFORE_S)
	var t1 := minf(length, far / HZ + STRIKE_AFTER_S)
	var g: Array = []
	var heads: Array = []
	var k := 0
	while t0 + k / FINE_HZ <= t1 + 1e-6:
		var p := _pose(clip, t0 + k / FINE_HZ)
		g.append(p[hand + "Glove"])
		heads.append((p["Head"] as Vector3).y)
		k += 1
	var top := 0.0
	for i in range(1, g.size()):
		top = maxf(top, (g[i] as Vector3).distance_to(g[i - 1]))
	var from := g.size() - 1
	for i in range(1, g.size()):
		if (g[i] as Vector3).distance_to(g[i - 1]) >= DRIVE_SHARE * top:
			from = i
			break
	var near := INF
	for i in range(from, g.size()):
		near = minf(near, absf(((g[i] as Vector3) - base).dot(side)))
	# A hook, an uppercut or a body shot lands where its clip puts it: of the frames on the line, those nearest the target
	# zone in height (within ZONE_TIE_M of the best) - an uppercut is deepest while its glove is still low. A straight is
	# finished by the arm IK: its deepest frame on the line, whatever its height.
	var line := near + LINE_M
	if not straight:
		line = maxf(line, float((Census.BODY_ZONE if body else Census.HEAD_ZONE)["side"]))   # anywhere across the target's width
	var zone := INF
	if not straight:
		for i in range(from, g.size()):
			var d0: Vector3 = (g[i] as Vector3) - base
			if absf(d0.dot(side)) <= line:
				zone = minf(zone, Census.zone_miss(d0.dot(side), d0.y, body))
	var at := from
	var deep := -INF
	for i in range(from, g.size()):
		var d: Vector3 = (g[i] as Vector3) - base
		if absf(d.dot(side)) > line or (not straight and Census.zone_miss(d.dot(side), d.y, body) > zone + ZONE_TIE_M):
			continue
		if d.dot(fwd) > deep:
			deep = d.dot(fwd)
			at = i
	var off: Vector3 = (g[at] as Vector3) - base
	return {"hand": hand + "Hand", "contact_gap_m": deep, "contact_s": t0 + at / FINE_HZ, "side_m": off.dot(side), "up_m": off.y,
		"miss_m": Census.zone_miss(off.dot(side), off.y, body), "glove_y_m": (g[at] as Vector3).y, "own_head_y_m": float(heads[at])}
