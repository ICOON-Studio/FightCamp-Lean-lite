extends "res://tools/pics2d_bodycross_stage.gd"
## BODYCROSS2 (S545, ops/research/TASK_BODYCROSS2.md step 2): THE BODY-CROSS RULER. Reads what the owner saw on the S542
## film and BODYCROSS1 never measured (C500: "does not reach opponent ... trying to touch hime rather than punch him and
## hurt him"), on the film's own pair and side camera, from 6 pictures before the contact to 10 after:
##   reach   the glove front to the nearest point of the hit man's trunk SURFACE (his skinned mesh as drawn, not the rib
##           point), and how far the glove goes PAST where that surface was on the picture before the contact;
##   speed   the glove front on screen (m/s, 60 pictures a second) at the contact picture, the take's top, when the top is;
##   time    first move to contact: from the first picture after the throw starts on which his glove or his hips move
##           (over MOVE_MPS) - the studies' INIT / ACTION -> CONTACT (G75 line 112) - and, beside it, the fist alone
##           (the last picture under 15 % of top speed counting back from the top: CROSS_POWER_S439's rule);
##   the hit man  his hips' travel away, his trunk's fold (neck over hips), and when his posture is back.
## Bars (each beside its study in docs/BODYCROSS2_RESULT.md):
##   reach    the glove meets the surface (within TOUCH_M) and goes PAST_MIN_M..PAST_MAX_M past where it was (G75: Atha 110 mm follow-through)
##   speed    at the contact >= AT_MIN_MPS (G75: Whiting contact 5.9-8.2) and >= AT_SHARE of the top; top >= TOP_MIN_MPS (G75 cross 6-11.5)
##   time     FIRST_MIN_S..FIRST_MAX_S (G75's readable floor 230 ms .. BODYCROSS1's own contact 0.36 s)
##   hurt     hips back or trunk folded HURT_M within HURT_S of the contact; posture not back sooner than BACK_MIN_S
##   <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/bodycross2_ruler.gd -- <out_dir> set=m|w [who=0|1] [take=pro_body_cross] [as=filmed|own] [react=film|game|<take>]
## Prints BC2 rows, one line a bar and BODYCROSS2_RULER GREEN|RED; writes <out_dir>/ruler_<set>_<as>.json. Exit 0 either way.

const TOUCH_M := 0.01
const PAST_MIN_M := 0.04
const PAST_MAX_M := 0.10
const AT_MIN_MPS := 6.0
const AT_SHARE := 0.70
const TOP_MIN_MPS := 8.0
const FIRST_MIN_S := 0.23
const FIRST_MAX_S := 0.36
const MOVE_MPS := 0.3         # a glove or hips faster than this has started moving
const HURT_M := 0.05
const HURT_S := 0.15
const BACK_MIN_S := 0.40
const BACK_POSE_M := 0.04     # his neck over his hips within this of where it was at the contact = his posture is back
const BEFORE_F := 6
const AFTER_ROWS := 10


func _initialize() -> void:
	if not await _setup():
		return
	_watch()
	var set_name := _arg("set", "w")
	var who := int(_arg("who", "1" if set_name == "m" else "0"))   # the S542 films: men, blue throws; women, red throws
	var clip := _arg("take", "pro_body_cross")
	var own := _arg("as", "filmed") == "own"
	var react := _arg("react", "game" if own else "film")
	if not (stage.boxers[who]["ap"] as AnimationPlayer).has_animation(clip):
		print("BODYCROSS2_RULER RED no take %s" % clip)
		quit(0)
		return
	var run := await _play_out(who, clip, own, react)
	var m := _measure(who, run)
	m["set"] = set_name
	m["take"] = clip
	m["as"] = "own" if own else "filmed"
	m["react"] = react if react == "film" else str((run["react"] as Dictionary).get("clip", react))
	m["react_from_s"] = float((run["react"] as Dictionary).get("from_s", 0.0))
	_say(m)
	var fh := FileAccess.open(out_dir.path_join("ruler_%s_%s.json" % [set_name, _arg("tag", m["as"])]), FileAccess.WRITE)
	fh.store_string(JSON.stringify(m, "  "))
	fh.close()
	quit(0)


static func _r3(v: float) -> float:
	return snappedf(v, 0.001)


func _measure(who: int, run: Dictionary) -> Dictionary:
	var d := 1 - who
	var fr: Array = run["frames"]
	var kc: int = run["kc"]
	var hand: String = run["hand"]
	var side := hand.trim_suffix("Hand")
	var dirv: Vector3 = run["dirv"]
	var view := _view()
	var n := fr.size()
	var gl: Array = []
	for f in fr:
		gl.append((f["thr"] as Dictionary)["gl"][hand])
	var speed: Array = [0.0]   # on screen: the part of the glove's step the side camera sees
	for k in range(1, n):
		var dv: Vector3 = (gl[k] as Vector3) - (gl[k - 1] as Vector3)
		speed.append((dv - view * dv.dot(view)).length() * 60.0)
	# the contact: the first picture the glove front is on (or in) the trunk as drawn; else the nearest it comes
	var gap := {}
	var near := INF
	var near_k := kc
	var ci := -1
	for k in range(maxi(kc - 14, LEAD_F), mini(kc + 14, n)):
		var got := _surf_dist(_surf_pose(fr[k]["def"]), gl[k])
		gap[k] = got
		if float(got[0]) < near:
			near = float(got[0])
			near_k = k
		if ci < 0 and float(got[0]) <= TOUCH_M:
			ci = k
	var touched := ci >= 0
	if not touched:
		ci = near_k
	# past where the surface was: the surface point of the picture before the contact, along the glove's way in
	var way: Vector3 = ((gl[ci] as Vector3) - (gl[maxi(ci - 2, 0)] as Vector3))
	way = dirv if way.length() < 0.01 else way.normalized()
	var was: Vector3 = _surf_dist(_surf_pose(fr[ci - 1]["def"]), gl[ci])[1]
	var past := -INF
	for k in range(ci, mini(ci + AFTER_ROWS + 1, n)):
		past = maxf(past, ((gl[k] as Vector3) - was).dot(way))
	var top := 0.0
	var top_k := LEAD_F
	for k in range(LEAD_F, mini(ci + 4, n)):
		if float(speed[k]) > top:
			top = float(speed[k])
			top_k = k
	var fist := LEAD_F
	for k in range(top_k, LEAD_F - 1, -1):
		if float(speed[k]) < 0.15 * top:
			fist = k
			break
	var first := ci
	for k in range(LEAD_F + 1, ci):
		var hv: float = (_at(fr[k]["thr"], who, "Hips") - _at(fr[k - 1]["thr"], who, "Hips")).length() * 60.0
		if float(speed[k]) > MOVE_MPS or hv > MOVE_MPS:
			first = k - 1
			break
	# the hit man, against where he was on the contact picture
	var h0 := _at(fr[ci]["def"], d, "Hips")
	var t0 := _at(fr[ci]["def"], d, "Neck") - h0
	var hips_back := 0.0
	var fold := 0.0
	var fold_deg := 0.0
	var moved := 0.0
	var back_s := -1.0
	var rows: Array = []
	for k in range(ci - BEFORE_F, n):
		var h := _at(fr[k]["def"], d, "Hips")
		var tr := _at(fr[k]["def"], d, "Neck") - h
		var hb := ((h - h0) * Vector3(1, 0, 1)).dot(dirv)
		var fo := (tr - t0).length()
		var dt := float(k - ci) / 60.0
		if k > ci and dt <= HURT_S + 1e-6:
			hips_back = maxf(hips_back, hb)
			if fo > fold:
				fold = fo
				fold_deg = rad_to_deg(tr.angle_to(t0))
		if k > ci:
			if fo > moved:
				moved = fo
				back_s = -1.0
			elif back_s < 0.0 and moved > BACK_POSE_M and fo <= BACK_POSE_M:
				back_s = dt
		if k <= ci + AFTER_ROWS and gap.has(k):
			var c := _at(fr[k]["def"], d, "Chest") - _at(fr[ci]["def"], d, "Chest")
			rows.append({"f": k - ci, "take_s": _r3(float(fr[k]["pos"])), "gap_m": _r3(float(gap[k][0])), "speed_mps": snappedf(float(speed[k]), 0.01),
				"past_m": _r3(((gl[k] as Vector3) - was).dot(way)), "chest_m": _r3(c.length()), "hips_back_m": _r3(hb), "fold_m": _r3(fo), "fold_deg": snappedf(rad_to_deg(tr.angle_to(t0)), 0.1)})
	# the puncher on the contact picture, against the picture the throw starts on
	var a: Dictionary = fr[LEAD_F]["thr"]
	var b: Dictionary = fr[ci]["thr"]
	var elbow := rad_to_deg((_at(b, who, side + "UpperArm") - _at(b, who, side + "LowerArm")).angle_to(_at(b, who, side + "Hand") - _at(b, who, side + "LowerArm")))
	var heel := 0.0
	var fwd_most := 0.0
	for k in range(LEAD_F, mini(ci + 6, n)):
		heel = maxf(heel, _at(fr[k]["thr"], who, side + "Foot").y - _at(a, who, side + "Foot").y)
		fwd_most = maxf(fwd_most, (_at(fr[k]["thr"], who, "Hips") - _at(a, who, "Hips")).dot(dirv))
	var st: Dictionary = run["stage"]
	return {"touched": touched, "contact_take_s": _r3(float(fr[ci]["pos"])), "key_take_s": _r3(float(run["cs"])), "nearest_m": _r3(near), "past_m": _r3(past),
		"at_mps": snappedf(float(speed[ci]), 0.01), "top_mps": snappedf(top, 0.01), "top_before_s": _r3(float(ci - top_k) / 60.0), "first_s": _r3(float(ci - first) / 60.0), "fist_s": _r3(float(ci - fist) / 60.0),
		"hips_back_m": _r3(hips_back), "fold_m": _r3(fold), "fold_deg": snappedf(fold_deg, 0.1), "moved_most_m": _r3(moved), "back_s": _r3(back_s),
		"elbow_deg": snappedf(elbow, 0.1), "hip_turn_deg": snappedf(_turn(a, b, who, "UpperLeg"), 0.1), "shoulder_turn_deg": snappedf(_turn(a, b, who, "UpperArm"), 0.1),
		"hips_fwd_m": _r3((_at(b, who, "Hips") - _at(a, who, "Hips")).dot(dirv)), "hips_fwd_most_m": _r3(fwd_most), "rear_heel_up_m": _r3(heel),
		"pair_hips_m": _r3(((_at(fr[LEAD_F]["def"], d, "Hips") - _at(a, who, "Hips")) * Vector3(1, 0, 1)).length()), "step_m": _r3(float(st["step"])),
		"staged_left_m": _r3(float(st["gap"])), "rows": rows,
		# where on him it lands: the glove's height on the contact picture against his rib point (the game's body target) and his hip joints
		"glove_y_m": _r3((gl[ci] as Vector3).y), "his_ribs_y_m": _r3(_at(fr[ci - 1]["def"], d, "Chest").y - 0.14 * float(stage.v2._scale(d))),
		"his_hips_y_m": _r3(_at(fr[ci - 1]["def"], d, "Hips").y), "his_chest_y_m": _r3(_at(fr[ci - 1]["def"], d, "Chest").y)}


## How far the line between the left and right joint has turned (deg, about the upright) between two snapshots.
func _turn(a: Dictionary, b: Dictionary, i: int, joint: String) -> float:
	var la := (_at(a, i, "Right" + joint) - _at(a, i, "Left" + joint)) * Vector3(1, 0, 1)
	var lb := (_at(b, i, "Right" + joint) - _at(b, i, "Left" + joint)) * Vector3(1, 0, 1)
	return rad_to_deg(la.angle_to(lb))


func _say(m: Dictionary) -> void:
	print("BC2 %s set %s, as %s, the hit man plays %s from %.3f s; hips %.3f m apart in the guard; puncher stepped %.3f m" % [m["take"], m["set"], m["as"], m["react"], m["react_from_s"], m["pair_hips_m"], m["step_m"]])
	print("BC2  pic  take_s  glove-to-surface  speed  past-the-surface  his chest  hips back  fold")
	for r in m["rows"]:
		print("BC2 %4d  %6.3f  %8.3f m  %6.2f m/s  %7.3f m  %6.3f m  %6.3f m  %5.3f m %5.1f deg" % [r["f"], r["take_s"], r["gap_m"], r["speed_mps"], r["past_m"], r["chest_m"], r["hips_back_m"], r["fold_m"], r["fold_deg"]])
	var bars: Array = [
		["reach: the glove meets his body", bool(m["touched"]), "nearest %.3f m from the surface (contact at take %.3f s, the row's key %.3f s)" % [m["nearest_m"], m["contact_take_s"], m["key_take_s"]]],
		["reach: goes %.2f-%.2f m past where the surface was" % [PAST_MIN_M, PAST_MAX_M], bool(m["touched"]) and float(m["past_m"]) >= PAST_MIN_M and float(m["past_m"]) <= PAST_MAX_M, "%.3f m" % m["past_m"]],
		["speed at the contact >= %.0f m/s" % AT_MIN_MPS, float(m["at_mps"]) >= AT_MIN_MPS, "%.2f m/s" % m["at_mps"]],
		["speed at the contact >= %d %% of the top" % int(AT_SHARE * 100.0), float(m["at_mps"]) >= AT_SHARE * float(m["top_mps"]), "%d %% (top %.3f s before)" % [int(round(100.0 * float(m["at_mps"]) / maxf(float(m["top_mps"]), 0.01))), m["top_before_s"]]],
		["top speed >= %.0f m/s" % TOP_MIN_MPS, float(m["top_mps"]) >= TOP_MIN_MPS, "%.2f m/s" % m["top_mps"]],
		["first move to contact %.2f-%.2f s" % [FIRST_MIN_S, FIRST_MAX_S], float(m["first_s"]) >= FIRST_MIN_S - 1e-6 and float(m["first_s"]) <= FIRST_MAX_S + 0.5 / 60.0, "%.3f s (the fist alone, from 15 %% of its top speed: %.3f s)" % [m["first_s"], m["fist_s"]]],
		["the hit man moves %.2f m within %.2f s (hips back or trunk folded)" % [HURT_M, HURT_S], maxf(float(m["hips_back_m"]), float(m["fold_m"])) >= HURT_M, "hips back %.3f m, fold %.3f m (%.1f deg)" % [m["hips_back_m"], m["fold_m"], m["fold_deg"]]],
		["he is not back in his stance before %.1f s" % BACK_MIN_S, float(m["moved_most_m"]) > BACK_POSE_M and (float(m["back_s"]) < 0.0 or float(m["back_s"]) >= BACK_MIN_S), ("never moved (most %.3f m)" % m["moved_most_m"]) if float(m["moved_most_m"]) <= BACK_POSE_M else ("not back in %.1f s" % (AFTER_F / 60.0) if float(m["back_s"]) < 0.0 else "back after %.3f s" % m["back_s"])],
	]
	var red: Array = []
	var out: Array = []
	for b in bars:
		print("BC2_BAR %s  %s: %s" % ["PASS" if b[1] else "FAIL", b[0], b[2]])
		out.append({"bar": b[0], "pass": b[1], "read": b[2]})
		if not b[1]:
			red.append(b[0])
	m["bars"] = out
	print("BC2 the puncher at the contact: elbow %.1f deg, hip line turned %.1f deg, shoulder line %.1f deg, hips forward %.3f m (most %.3f), rear heel up %.3f m" % [m["elbow_deg"], m["hip_turn_deg"], m["shoulder_turn_deg"], m["hips_fwd_m"], m["hips_fwd_most_m"], m["rear_heel_up_m"]])
	print("BC2 where it lands: the glove %.3f m up; his rib point %.3f m, his hip joints %.3f m (the glove %.3f m under the rib point, %.3f m over the hips)" % [m["glove_y_m"], m["his_ribs_y_m"], m["his_hips_y_m"], float(m["his_ribs_y_m"]) - float(m["glove_y_m"]), float(m["glove_y_m"]) - float(m["his_hips_y_m"])])
	m["verdict"] = "GREEN" if red.is_empty() else "RED"
	print("BODYCROSS2_RULER %s %s set %s as %s (%d of %d bars failed)" % [m["verdict"], m["take"], m["set"], m["as"], red.size(), bars.size()])
