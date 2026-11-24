extends SceneTree
## BODYREACT2 (S547, ops/research/TASK_BODYREACT2.md step 1): THE FOLD OF EVERY GUT-SHOT TAKE, READ ONCE FROM ITS OWN KEYS
## and stored on its row of assets/data/clip_db.json - what ChoreoReact.react picks a landed body punch's reaction by.
## The census way (tools/clip_census.gd): the census body (mh_boxer_10), takes as bought, every fight layer off, the take
## sought key by key. The fold = the hips - neck line against upright in his own fore-aft plane (+ = bent toward the man
## who hit him), less the same line in THE GUARD THE FIGHT STANDS IN - the v2 player's waiting takes (Player2.WAITS, the
## mean of the two men's), the posture a reaction is joined from. NOT the bought guard pose (meta guard, pro_idle): that
## stands 1.9 deg BACK of upright, the waiting takes 3.7 and 6.6 deg forward, and the ruler's touch pictures read 5.3
## (men) and 6.9 (women) - over pro_idle three old takes "fold" 12-17 deg by 0.15 s while the pictures show 3-10.
##   fold_g        that fold, deg, CURVE_HZ times a second from the take's first key (as head_g / hips_g are stored)
##   fold_from_s   where the v2 player starts the take on the census body (ChoreoReact.start_s, a body punch)
##   fold_015_deg  the fold FOLD_S after that start - "does he bend on the blow?" (K51 lines 7, 81, 96: front-loaded)
##   fold_blow_deg what a PICTURE shows ChoreoReact.BODY_FOLD_S after that start (ChoreoReact.fold_shown: the fold then x
##                 the fold join's way out of the guard) - the number the pick reads, on the census body
##   fold_max_deg / fold_max_s   the deepest fold and when (take time)
## RE-RUN AFTER EVERY tools/clip_census.gd RUN: the census writes each row afresh and drops these keys
## (tests/body_react_test.gd goes red until this is run again).
##   <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/bodyreact2_bake.gd [-- dry]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const Orbit := preload("res://tools/clip_orbit.gd")
const Census := preload("res://scripts/fight3d/v2/ClipCensus.gd")
const React := preload("res://scripts/fight3d/v2/ChoreoReact.gd")
const Player2 := preload("res://scripts/fight3d/v2/Player2.gd")
const CURVE_HZ := 30.0
const FOLD_S := 0.15

var skel: Skeleton3D
var ap: AnimationPlayer
var fwd := Vector3.BACK
var hips := -1
var neck := -1


func _initialize() -> void:
	var dry := OS.get_cmdline_user_args().has("dry")
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(Census.DB_PATH))
	if not (parsed is Dictionary):
		print("BR2_BAKE FAIL the table does not read")
		quit(1)
		return
	var db: Dictionary = parsed
	var rows: Dictionary = db["rows"]
	var meta: Dictionary = db.get("meta", {})
	FightClips.as_bought = true
	var st: Node3D = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/%s.glb" % str(meta.get("body", "mh_boxer_10")), "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	await process_frame
	st.set_process(false)
	var bx: Dictionary = st.boxers[0]
	skel = bx["skel"]
	ap = bx["ap"]
	fwd = (bx["node"] as Node3D).global_transform.basis.z.normalized()
	print("BR2_BAKE layers off: ", ",".join(Orbit.strip_modifiers(skel)))
	hips = skel.find_bone("Hips")
	neck = skel.find_bone("Neck")
	var guards: Array = (Player2.WAITS as Array).filter(func(g): return ap.has_animation(str(g)))
	if guards.is_empty():
		guards = [str(meta.get("guard", "pro_idle"))]
	var guard_lean := 0.0
	for g in guards:
		var gn := maxi(2, int(ap.get_animation(str(g)).length * CURVE_HZ))
		var one := 0.0
		for i in gn:
			one += _lean(str(g), float(i) / CURVE_HZ) / float(gn)
		print("BR2_BAKE the fight's guard %s holds the hips - neck line %.1f deg forward of upright" % [g, one])
		guard_lean += one / float(guards.size())
	print("BR2_BAKE the fold is read over %.1f deg (the bought guard pose %s: %.1f)" % [guard_lean, str(meta.get("guard", "pro_idle")), _lean(str(meta.get("guard", "pro_idle")), 0.0)])
	var hz: float = float(meta.get("curve_hz", CURVE_HZ))
	var n := 0
	var names: Array = rows.keys()
	names.sort()
	for name in names:
		var row: Dictionary = rows[name]
		if str(row.get("kind", "")) != "reaction" or not str(name).contains("gutshot") or not ap.has_animation(str(name)):
			continue
		var length: float = ap.get_animation(str(name)).length
		var curve: Array = []
		var most := -INF
		var most_s := 0.0
		for i in int(length * CURVE_HZ) + 1:
			var f := _lean(str(name), minf(float(i) / CURVE_HZ, length)) - guard_lean
			curve.append(snappedf(f, 0.1))
			if f > most:
				most = f
				most_s = float(i) / CURVE_HZ
		var from: float = float(React.start_s(row, "body_hook", hz, 1.0)[0])
		row["fold_g"] = curve
		row["fold_from_s"] = snappedf(from, 0.001)
		row["fold_015_deg"] = snappedf(React.g_at(curve, from + FOLD_S, CURVE_HZ), 0.1)
		row["fold_blow_deg"] = snappedf(React.fold_shown(curve, from, React.BODY_FOLD_S, CURVE_HZ), 0.1)
		row["fold_max_deg"] = snappedf(most, 0.1)
		row["fold_max_s"] = snappedf(most_s, 0.001)
		n += 1
		print("BR2_BAKE %-30s starts %.3f s in; fold over the fight's guard: %5.1f deg on that key, a picture shows %5.1f deg %.3f s later (the pick's number), the keys %5.1f deg %.2f s later, deepest %5.1f deg at %.2f s" % [name, from,
			React.g_at(curve, from, CURVE_HZ), float(row["fold_blow_deg"]), React.BODY_FOLD_S, float(row["fold_015_deg"]), FOLD_S, most, most_s])
	for name in names:   # a number read back from JSON is a float: the census wrote this one whole (the file's other lines stay as they are)
		if (rows[name] as Dictionary).has("over_crown_frames"):
			rows[name]["over_crown_frames"] = int(rows[name]["over_crown_frames"])
	if not dry and n > 0:
		var fh := FileAccess.open(Census.DB_PATH, FileAccess.WRITE)
		fh.store_string(JSON.stringify(db, "\t", true))
		fh.close()
	print("BR2_BAKE %s %d gut-shot takes -> %s" % ["DRY" if dry else "DONE", n, Census.DB_PATH])
	quit(0)


## The hips - neck line against upright in his fore-aft plane on the take's own key at t, deg (+ = forward).
func _lean(clip: String, t: float) -> float:
	ap.play(clip)
	ap.seek(t, true)
	var w := skel.global_transform
	var line: Vector3 = w * skel.get_bone_global_pose(neck).origin - w * skel.get_bone_global_pose(hips).origin
	return rad_to_deg(atan2(line.dot(fwd), line.y))
