extends "res://tools/pics2d_bodycross_stage.gd"
## BODYCROSS2 (S545, ops/research/TASK_BODYCROSS2.md step 6): THE TWELVE BODY-CROSS PICTURES with the re-authored take.
## BODYCROSS3 (S546): the take now steps in and lands with a bent arm; the hit man plays FOLD_REACT (the fold on the blow).
## The picture set's own tool (tools/pics2d_set.gd) with one change, for the LANDED body cross only: the picture is the
## film's own frame a few pictures (SUNK_TRY) after the contact key - the take on its own keys (no finish: PunchAim eases the
## glove to a stop on the rib POINT, which floats 5-7 cm in front of his skin - what the owner saw as "does not reach"),
## the puncher where the take's glove meets his body, the glove at its deepest, the hit man starting to give by the v2
## player's own reaction route. Its gate reads the glove against his body SURFACE as drawn (hit_m: 0 = on or in it),
## never deeper than SUNK_MAX_M, plus the set gate's own torso / feet / head measures. Blocked and missed: the set
## tool's own route, unchanged, with the new take.
##   python tools/hidden_desktop.py run --timeout=900 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_bodycross_pics.gd -- <out_dir> art=toon set=w|m only=*body_cross

const SUNK_TRY := [4, 3, 2, 1]   # BODYCROSS3: the latest of these pictures after the contact key on which the glove is still on or in him and the set's gate passes
const ON_M := 0.01
const SUNK_MAX_M := 0.09
const FOLD_REACT := "pro_hit_by_gutshot_v3_fold"   # BODYCROSS3: the gut-shot take that folds on the blow (tools/pics2d_gutfold_bake.gd)


func _initialize() -> void:
	if not await _setup():
		return
	_watch()
	await _run()


func _punch(who: int, fam: String, res: String, name: String) -> void:
	if fam != "body_cross" or res != "landed":
		await super._punch(who, fam, res, name)
		return
	var takes := _takes(who, fam)
	if takes.is_empty():
		print("PICS2D_SET no %s take on %s" % [fam, name])
		refused += 1
		return
	var clip := str(takes[0])
	var d := 1 - who
	# BODYCROSS3 (owner C502: "the reaction should force the opponent to bend hisposture a bit"): the hit man gives
	# ground as he folds, so the glove is off his body again 4-5 pictures after the touch, and a bent arm stands the two
	# 8-10 cm nearer than a straight one. The picture is the LATEST one on which the glove is still on or in him and
	# the set's own gate passes (no head in the other body): the bent arm in his body, his bend begun. It is THE FILM'S
	# OWN FRAME: the tree is paused on it, so the join into his take does not run on while the picture is checked and
	# saved (run on, it puts him on his take's own key: 5-6 cm more of his head toward the puncher than the film shows).
	var run := {}
	var sunk_f := 0
	for f in SUNK_TRY:
		sunk_f = int(f)
		paused = false
		run = await _play_out(who, clip, true, FOLD_REACT, Callable(), sunk_f)
		paused = true
		var m0: Dictionary = Gate.punch(stage, who, str(run["hand"]), "landed", true, run["dirv"], _px, SIZE / cam.size, _view())
		var clean: bool = (m0["fails"] as Array).filter(func(x): return not str(x).begins_with("hit_m") and not str(x).begins_with("head_clear_m")).is_empty()
		if clean and _heads(snap[who], snap[d], who) >= Gate.HEAD_CLEAR_M and float(_surf_dist(_surf_pose(snap[d]), snap[who]["gl"][str(run["hand"])])[0]) <= ON_M:
			break
	var hand: String = run["hand"]
	var dirv: Vector3 = run["dirv"]
	var gate := func() -> Dictionary:
		var gl: Vector3 = snap[who]["gl"][hand]
		var got := _surf_dist(_surf_pose(snap[d]), gl)
		var m: Dictionary = Gate.punch(stage, who, hand, "landed", true, dirv, _px, SIZE / cam.size, _view())
		var fails: Array = (m["fails"] as Array).filter(func(f): return not str(f).begins_with("hit_m") and not str(f).begins_with("head_clear_m"))
		m["head_clear_m"] = snappedf(_heads(snap[who], snap[d], who), 0.001)   # as drawn, like the glove's reading
		if float(m["head_clear_m"]) < Gate.HEAD_CLEAR_M:
			fails.append("head_clear_m %.3f < %.2f (a head in the other body, as drawn)" % [m["head_clear_m"], Gate.HEAD_CLEAR_M])
		m["hit_m"] = snappedf(maxf(float(got[0]), 0.0), 0.001)
		m["sunk_m"] = snappedf(maxf(-float(got[0]), 0.0), 0.001)
		if float(m["hit_m"]) > Gate.LAND_M:
			fails.append("hit_m %.3f > %.2f (the glove short of his body)" % [m["hit_m"], Gate.LAND_M])
		if float(m["sunk_m"]) > SUNK_MAX_M:
			fails.append("sunk_m %.3f > %.2f (the glove through his body)" % [m["sunk_m"], SUNK_MAX_M])
		m["fails"] = fails
		m["glove"] = _xy(gl)
		m["target"] = _xy(got[1])
		return m
	print("PICS2D_SET %s = %s on its own keys, %d pictures after the contact key; step %.2f m; the hit man %s" % [name, clip, sunk_f, float((run["stage"] as Dictionary)["step"]), str((run["react"] as Dictionary).get("clip", ""))])
	await _shot(name, {"clip": clip, "result": res, "cover": "", "after_contact_f": sunk_f, "react": FOLD_REACT}, [0, 1], gate)
	paused = false
	var aim: Node = stage.v2._aim[who]
	if aim != null:
		aim.disarm()
