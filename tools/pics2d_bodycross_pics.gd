extends "res://tools/pics2d_bodycross_stage.gd"
## BODYCROSS2 (S545, ops/research/TASK_BODYCROSS2.md step 6): THE TWELVE BODY-CROSS PICTURES with the re-authored take.
## The picture set's own tool (tools/pics2d_set.gd) with one change, for the LANDED body cross only: the picture is the
## film's own frame SUNK_F pictures after the contact key - the take on its own keys (no finish: PunchAim eases the
## glove to a stop on the rib POINT, which floats 5-7 cm in front of his skin - what the owner saw as "does not reach"),
## the puncher where the take's glove meets his body, the glove at its deepest, the hit man starting to give by the v2
## player's own reaction route. Its gate reads the glove against his body SURFACE as drawn (hit_m: 0 = on or in it),
## never deeper than SUNK_MAX_M, plus the set gate's own torso / feet / head measures. Blocked and missed: the set
## tool's own route, unchanged, with the new take.
##   python tools/hidden_desktop.py run --timeout=900 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_bodycross_pics.gd -- <out_dir> art=toon set=w|m only=*body_cross

const SUNK_F := 2
const SUNK_MAX_M := 0.09


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
	var run := await _play_out(who, clip, true, "game", Callable(), SUNK_F)
	var hand: String = run["hand"]
	var dirv: Vector3 = run["dirv"]
	var gate := func() -> Dictionary:
		var gl: Vector3 = snap[who]["gl"][hand]
		var got := _surf_dist(_surf_pose(snap[d]), gl)
		var m: Dictionary = Gate.punch(stage, who, hand, "landed", true, dirv, _px, SIZE / cam.size, _view())
		var fails: Array = (m["fails"] as Array).filter(func(f): return not str(f).begins_with("hit_m"))
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
	print("PICS2D_SET %s = %s on its own keys, %d pictures after the contact key; step %.2f m; the hit man %s" % [name, clip, SUNK_F, float((run["stage"] as Dictionary)["step"]), str((run["react"] as Dictionary).get("clip", ""))])
	await _shot(name, {"clip": clip, "result": res, "cover": ""}, [0, 1], gate)
	var aim: Node = stage.v2._aim[who]
	if aim != null:
		aim.disarm()
