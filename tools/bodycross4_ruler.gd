extends "res://tools/pics2d_bodycross_stage.gd"
## BODYCROSS4 (S548, ops/research/TASK_BODYCROSS4.md step 0): IS THE REAR STRAIGHT TO THE BODY THROWN IN THE 3D FIGHT,
## AND DOES IT READ AS A PUNCH? Built on tools/bodyreact2_ruler.gd (the exchange, the fold, the crowding, the floor) and
## on tools/pics2d_bodycross_stage.gd (every pose and glove read on skeleton_updated, as drawn; the hit man's trunk SKIN).
## A landed body punch is asked of THE v2 PLAYER ITSELF - Player2.queue -> Choreographer.plan -> the player's events,
## joins and layers - SEEDS times a size (normal, big), each exchange its own seed by the player's own seed rule. The
## beat is the settled one the bout counts, a "body_hook", carrying the damage map's own key for the ribs it hurts
## ("side", BodyMap._punch_hits: a carried side wins): move=cross asks for the ribs on the far side from the puncher's
## lead hand - the rear hand's side, which RoundScript.shown names a body cross - move=hook for the lead hand's side.
## Every picture (60 a second) is read as a FIXED SIDE CAMERA sees it: the camera looks across the line between the
## two pelvises on the touch picture and does not move for the exchange.
## Bars (the brief's; K52 lines 10, 42, 46-47 the elbow; K51 lines 7, 81, 96 and K48 the bend):
##   THROWN       the punch the plan shows is the move asked for, with a take of that family
##   ON THE BODY  on the touch picture the glove front is ON_M or less from his trunk skin (belt to chest), and not
##                more than IN_M under it (the glove's own padding)
##   THE ELBOW    the punching arm AS SEEN is bent under ELBOW_MAX deg on the picture before the touch and opens from
##                that picture into the touch pictures (the touch to 3 after)
##   HE BENDS     BODYREACT2's ON TIME: FOLD_SHOWN deg or more on FOLD_PICS pictures inside FOLD_S of the touch
##   APART        no head inside the other man on any picture (head to head 0.16, head to chest 0.18: player2_test)
##   FLOOR        no ball more than SINK_M under where it stands in his guard (the canvas), no ankle more than SINK_M
##                nearer the canvas than a flat foot has it (the skeleton's rest pose). BODYREACT2 read the ankle against
##                its own guard height: the guard stands heels up, so a foot PLANTED flat read as 3 cm sunk
## Printed beside them, a punch take (step 5: "there is no punching on this clip"): the glove's travel TO THE TRUNK in
## the last TRAVEL_S before the touch (how much nearer his skin it got) and the heads' crowding measure on the touch
## picture; a take that touches with the heads under HEADS_MIN_M or the travel under TRAVEL_MIN_M does not read as a punch.
## thrown=<n>: instead, n rounds planned as tests/choreographer_test.gd R14 plans them (Slugger v Slugger, seed = the
##   round's number): rounds with a landed body cross (bar: 1 in 6), body hooks beside them, and a boxer's two
##   punches running that are both body crosses (bar: none).
##   <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/bodycross4_ruler.gd -- <out_dir> fightplayer2 set=m|w [move=cross|hook] [seeds=60] [tag=<t>] [thrown=<n>] [show]
## Prints BC4 lines, one line a bar, BODYCROSS4_RULER GREEN|RED; writes <out_dir>/bc4_<set>_<move>_<tag>.json. Exit 0 either way.

const RS := preload("res://scripts/rules/RoundScript.gd")
const R := preload("res://scripts/fight3d/v2/ChoreoRules.gd")
const Choreo := preload("res://scripts/fight3d/v2/Choreographer.gd")
const Census := preload("res://scripts/fight3d/v2/ClipCensus.gd")
const THROWS := {"w": 0, "m": 1}   # the films: women, red throws; men, blue throws
const HZ := 60.0
const SLOT_S := 6
const HIT_AT_S := 1.5
const ON_M := 0.06
const IN_M := 0.02
const ELBOW_MAX := 150.0
const FOLD_S := 0.15
const FOLD_SHOWN := 10.0
const FOLD_PICS := 3
const SINK_M := 0.03
const INSIDE_HEAD_M := 0.16
const INSIDE_CHEST_M := 0.18
const TRAVEL_S := 0.15
const TRAVEL_MIN_M := 0.25
const HEADS_MIN_M := 0.45
const SHEET_BEFORE := 3
const SHEET_AFTER := 8
const HEADS_F := 60
const FEET_BONES := ["LeftToes", "RightToes", "LeftFoot", "RightFoot"]
const BARS := ["THROWN: the plan shows the move asked for", "ON THE BODY: the glove on his trunk skin on the touch picture", "THE ELBOW: bent before the touch, opening into it",
	"HE BENDS: 10 deg or more on 3 pictures inside 0.15 s", "APART: no head inside the other man", "FLOOR: no ball or heel over 3 cm under the canvas"]

var p2: Node
var set_name := "m"
var thr := 1
var slot_n := 0
var want := "body_cross"
var guard_y: Array = [{}, {}]
var flat: Array = [{}, {}]
var verbose := false


static func _flat(v: Vector3) -> Vector3:
	return Vector3(v.x, 0.0, v.z)


## An angle at k between a and b as the side camera sees it (the part along the camera's line of sight dropped).
static func _seen(a: Vector3, k: Vector3, b: Vector3, view: Vector3) -> float:
	var u := a - k
	var v := b - k
	u -= view * u.dot(view)
	v -= view * v.dot(view)
	return rad_to_deg(u.angle_to(v))


## The hit man's hips - neck line against upright on the screen, deg (+ = toward the puncher).
func _fold_lean(s: Dictionary, d: int, dirv: Vector3) -> float:
	var t := _at(s, d, "Neck") - _at(s, d, "Hips")
	return rad_to_deg(atan2(t.dot(-dirv), t.y))


func _initialize() -> void:
	Engine.max_fps = int(HZ)
	var args := OS.get_cmdline_user_args()
	if not args.is_empty() and not str(args[0]).contains("="):
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	set_name = _arg("set", "m")
	thr = int(_arg("who", str(THROWS[set_name])))
	want = "body_hook" if _arg("move", "cross") == "hook" else "body_cross"
	verbose = args.has("show")
	if _arg("thrown", "") != "":
		_thrown(int(_arg("thrown", "240")))
		quit(0)
		return
	Player2.force = true
	FightClips.untouched = true
	stage = Stage.new()
	root.add_child(stage)
	await process_frame
	var pair: Array = SETS[set_name]
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % pair[0], "corner": "red", "stance": "orthodox"},
		{"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % pair[1], "corner": "blue", "stance": "orthodox"})
	if stage.v2 == null:
		print("BODYCROSS4_RULER RED the v2 player was not built")
		quit(0)
		return
	p2 = stage.v2
	_watch()
	# where each ball and ankle stands in his guard: the lowest it gets over 1.5 s of the wait (the wait bounces: one
	# picture of it reads a heel in the air)
	for f in 90:
		await process_frame
		for i in 2:
			for b in FEET_BONES:
				guard_y[i][b] = minf(float(guard_y[i].get(b, INF)), _at(snap[i], i, str(b)).y)
	_surf_build(1 - thr)
	# a flat foot's ankle over its ball, from the skeleton's rest pose: an ankle lower than that over the canvas is a heel
	# UNDER it (the guard stands on the balls, heels 3 cm up: against the guard's own ankle a planted foot read as sunk)
	for i in 2:
		var sk: Skeleton3D = stage.boxers[i]["skel"]
		for s in ["Left", "Right"]:
			flat[i][s] = (sk.get_bone_global_rest(sk.find_bone(s + "Foot")).origin.y - sk.get_bone_global_rest(sk.find_bone(s + "Toes")).origin.y) * sk.global_transform.basis.get_scale().y
	print("BC4 set %s bodies %s; boxer %d throws; asked for: %s; sizes against the census body %.3f / %.3f" % [set_name, pair, thr, want, float(p2.pair.size(0)), float(p2.pair.size(1))])
	var seeds := int(_arg("seeds", "60"))
	var runs: Array = []
	for big in [false, true]:
		for k in seeds:
			runs.append(await _exchange(bool(big)))
	_report(runs, seeds)
	quit(0)


## One exchange through the player: the settled body punch, landed, planned and played by Player2 as in a fight.
func _exchange(big: bool) -> Dictionary:
	var t0 := float(slot_n * SLOT_S)
	slot_n += 1
	var ws := "a" if thr == 0 else "b"
	var os := "b" if thr == 0 else "a"
	var d := 1 - thr
	var side := "left" if want == "body_cross" else "right"   # orthodox pairs: his rear hand lands on the other man's left ribs
	var beats: Array = [{"t": t0 + HIT_AT_S, "who": ws, "move": "body_hook", "side": side, "result": "lands", "def": "", "big": big}]
	if _arg("after", "") != "":   # after=jab: second in a combination (the pair cannot always get to the take's distance in time)
		beats.push_front({"t": t0 + HIT_AT_S - RS.COMBO_GAP_S, "who": ws, "move": _arg("after", "jab"), "result": "lands", "def": "", "big": false})
	p2.queue(beats, t0, t0 + float(SLOT_S))
	var ev := {}
	for e in p2.plan["tracks"][os]:
		if str(e.get("kind", "")) == "reaction":
			ev = e
	var pe := {}
	for e2 in p2.plan["tracks"][ws]:
		if str(e2.get("kind", "")) == "punch" and R.is_body(str(e2.get("move", ""))):
			pe = e2
	var off_m := 0.0
	for l in p2.plan["log"]:
		if str(l).begins_with("misfit") and str(l).contains(" body_"):
			off_m = float(str(l).get_slice(" is ", 1).get_slice(" ", 0))
	var clip := str(pe.get("clip", ""))
	var row: Dictionary = (p2.db["rows"] as Dictionary).get(clip, {})
	var hand: String = stage.hand_of(thr, str(row.get("hand", "LeftHand")))
	var arm := hand.trim_suffix("Hand")
	var seen_n: int = (p2.contacts as Array).size()
	var fr: Array = []   # a picture: [the puncher as drawn, the hit man as drawn]
	var ci := -1
	var t := t0
	for f in int(SLOT_S * HZ):
		p2.clock(t, true)
		await process_frame
		t += 1.0 / HZ
		if ci < 0 or fr.size() <= ci + AFTER_F:
			fr.append([snap[thr], snap[d]])
		if ci < 0 and (p2.contacts as Array).size() > seen_n:
			if R.is_body(str((p2.contacts as Array)[-1]["move"])):
				ci = fr.size() - 1
			seen_n = (p2.contacts as Array).size()
	var run := {"big": big, "seed": int(t0) * 131 + beats.size(), "off_m": off_m, "punch": clip, "move": str(pe.get("move", "")), "react": str(ev.get("clip", "")), "touched": ci >= 0,
		"bars": [str(pe.get("move", "")) == want and str(row.get("family", "")) == want, false, false, false, false, false], "pass": false}
	if ci < 0:
		print("BC4 seed %d: the punch never reached its contact (cut)" % int(run["seed"]))
		return run
	var a0: Dictionary = fr[ci][0]
	var b0: Dictionary = fr[ci][1]
	var dirv := _flat(_at(b0, d, "Hips") - _at(a0, thr, "Hips")).normalized()
	var view := Vector3.UP.cross(dirv)
	var kb := maxi(ci - int(round(TRAVEL_S * HZ)), 0)
	var g0: Array = _surf_dist(_surf_pose(b0), a0["gl"][hand])
	var gb: Array = _surf_dist(_surf_pose(fr[kb][1]), fr[kb][0]["gl"][hand])
	var q: Vector3 = g0[1]
	var on_trunk: bool = q.y >= _at(b0, d, "Hips").y - 0.05 and q.y <= _at(b0, d, "UpperChest").y + 0.02
	var closing: float = float(gb[0]) - float(g0[0])
	var lean0 := _fold_lean(b0, d, dirv)
	var first := not sheets.has("%s %s" % ["big" if big else "normal", clip])
	var rows: Array = []
	var elbow := {}
	var shown_n := 0
	var most := 0.0
	var most_s := 0.0
	var heads := INF
	var inside := 0
	var sink := 0.0
	var sink_at := ""
	var old_sink := 0.0   # BODYREACT2's reading: against the joint's own height in the guard
	for k in range(maxi(ci - SHEET_BEFORE, 0), fr.size()):
		var f := k - ci
		var a: Dictionary = fr[k][0]
		var b: Dictionary = fr[k][1]
		var fold := _fold_lean(b, d, dirv) - lean0
		if f > 0:
			if fold > most:
				most = fold
				most_s = float(f) / HZ
			if float(f) / HZ <= FOLD_S + 1e-6 and fold >= FOLD_SHOWN:
				shown_n += 1
		if f >= 0:
			for pr in [[a, thr], [b, d]]:
				for bone in FEET_BONES:
					var canvas: float = float(guard_y[int(pr[1])][str(bone).replace("Foot", "Toes")])   # where this foot's ball stands in his guard
					var under: float = canvas + (float(flat[int(pr[1])][str(bone).trim_suffix("Foot")]) if str(bone).ends_with("Foot") else 0.0) - _at(pr[0], int(pr[1]), str(bone)).y
					old_sink = maxf(old_sink, float(guard_y[int(pr[1])][bone]) - _at(pr[0], int(pr[1]), str(bone)).y)
					if under > sink:
						sink = under
						sink_at = "%s %s %+d (stands %.3f)" % ["puncher" if int(pr[1]) == thr else "hit man", bone, f, float(guard_y[int(pr[1])][bone])]
		var hd := _heads(a, b, thr)
		if f <= HEADS_F:
			heads = minf(heads, hd)
			if _at(a, thr, "Head").distance_to(_at(b, d, "Head")) < INSIDE_HEAD_M or _at(a, thr, "Head").distance_to(_at(b, d, "Chest")) < INSIDE_CHEST_M or _at(b, d, "Head").distance_to(_at(a, thr, "Chest")) < INSIDE_CHEST_M:
				inside += 1
		if f <= SHEET_AFTER:
			var el := _seen(_at(a, thr, arm + "UpperArm"), _at(a, thr, arm + "LowerArm"), _at(a, thr, arm + "Hand"), view)
			elbow[f] = el
			if first:
				rows.append({"pic": rows.size() + 1, "f": f, "elbow_deg": snappedf(el, 0.1), "glove_m": snappedf(float(_surf_dist(_surf_pose(b), a["gl"][hand])[0]), 0.001),
					"fold_deg": snappedf(fold, 0.1), "heads_m": snappedf(hd, 0.001)})
	var el_before: float = float(elbow.get(-1, 180.0))
	var el_after := 0.0
	for f2 in range(0, 4):
		el_after = maxf(el_after, float(elbow.get(f2, 0.0)))
	var deep: float = float(g0[0])   # the deepest the glove front gets under his skin as drawn, the touch to 4 pictures after
	for f3 in range(1, 5):
		if ci + f3 < fr.size():
			deep = minf(deep, float(_surf_dist(_surf_pose(fr[ci + f3][1]), fr[ci + f3][0]["gl"][hand])[0]))
	run["glove_deep_m"] = snappedf(deep, 0.001)
	var bars: Array = run["bars"]
	bars[1] = on_trunk and float(g0[0]) <= ON_M and float(g0[0]) >= -IN_M
	bars[2] = el_before < ELBOW_MAX and el_after > el_before
	bars[3] = shown_n >= FOLD_PICS
	bars[4] = inside == 0
	bars[5] = sink <= SINK_M
	run.merge({"gap_touch_m": snappedf(_flat(_at(b0, d, "Hips") - _at(a0, thr, "Hips")).length(), 0.001), "glove_m": snappedf(float(g0[0]), 0.001), "on_trunk": on_trunk,
		"closing_m": snappedf(closing, 0.001), "glove_moved_m": snappedf((fr[kb][0]["gl"][hand] as Vector3).distance_to(a0["gl"][hand]), 0.001),
		"elbow_before_deg": snappedf(el_before, 0.1), "elbow_touch_deg": snappedf(float(elbow.get(0, 0.0)), 0.1), "elbow_after_deg": snappedf(el_after, 0.1),
		"fold_pics": shown_n, "deepest_deg": snappedf(most, 0.1), "deepest_s": snappedf(most_s, 0.001), "heads_touch_m": snappedf(_heads(a0, b0, thr), 0.001), "heads_m": snappedf(heads, 0.001),
		"head_to_head_m": snappedf(_at(a0, thr, "Head").distance_to(_at(b0, d, "Head")), 0.001), "inside_frames": inside, "sink_m": snappedf(sink, 0.001), "sink_at": sink_at, "sink_guard_m": snappedf(old_sink, 0.001),
		"reads": float(_heads(a0, b0, thr)) >= HEADS_MIN_M and closing >= TRAVEL_MIN_M, "pass": not bars.has(false)}, true)
	if first:
		sheets["%s %s" % ["big" if big else "normal", clip]] = {"seed": run["seed"], "react": run["react"], "rows": rows}
	if verbose:
		print("BC4 %s seed %6d  %-18s (%s) gap %.2f | glove %+.3f m%s, nearer by %.2f m in %.2f s (moved %.2f) | elbow %5.1f -> %5.1f -> %5.1f | he: %s, %d pics, deepest %4.1f at %.2f s | heads %.2f (touch %.2f) sink %.3f | %s" % ["big" if big else "nrm", int(run["seed"]), clip, run["move"],
			float(run["gap_touch_m"]), float(g0[0]), "" if on_trunk else " OFF THE TRUNK", closing, TRAVEL_S, float(run["glove_moved_m"]), el_before, float(elbow.get(0, 0.0)), el_after, run["react"], shown_n, most, most_s, heads, float(run["heads_touch_m"]), sink, sink_at + " | " + ("pass" if bool(run["pass"]) else "FAIL")])
	return run


var sheets := {}


func _report(runs: Array, seeds: int) -> void:
	var out := {"set": set_name, "who": thr, "asked": want, "seeds": seeds, "sizes": {}, "takes": {}, "runs": runs, "sheets": sheets}
	var red_all := 0
	for big in [false, true]:
		var mine: Array = runs.filter(func(r): return bool(r["big"]) == bool(big))
		var size := "big" if big else "normal"
		var bar_n := [0, 0, 0, 0, 0, 0]
		var cut := 0
		for r in mine:
			cut += 0 if bool(r["touched"]) else 1
			for b in BARS.size():
				bar_n[b] = int(bar_n[b]) + (1 if bool(r["bars"][b]) else 0)
		print("BC4 --- set %s, %s, asked for %s, %d seeds (%d never reached the contact)" % [set_name, size, want, mine.size(), cut])
		var red := 0
		var bar_out: Array = []
		for b in BARS.size():
			var ok: bool = int(bar_n[b]) == mine.size()
			red += 0 if ok else 1
			print("BC4_BAR %s  %s: %d of %d exchanges" % ["PASS" if ok else "FAIL", BARS[b], int(bar_n[b]), mine.size()])
			bar_out.append({"bar": BARS[b], "pass": ok, "n": int(bar_n[b]), "of": mine.size()})
		red_all += red
		print("BODYCROSS4_RULER %s set %s %s %s (%d of %d bars failed)" % ["GREEN" if red == 0 else "RED", set_name, size, want, red, BARS.size()])
		out["sizes"][size] = {"bars": bar_out, "verdict": "GREEN" if red == 0 else "RED"}
	# by the punch take: what the pictures read, and does it read as a punch (step 5)
	var by := {}
	for r in runs:
		if not bool(r["touched"]):
			continue
		var key := str(r["punch"])
		if not by.has(key):
			by[key] = {"n": 0, "reads": 0, "v": {}}
		by[key]["n"] = int(by[key]["n"]) + 1
		by[key]["reads"] = int(by[key]["reads"]) + (1 if bool(r["reads"]) else 0)
		for f in ["sink_guard_m", "off_m", "glove_deep_m", "gap_touch_m", "glove_m", "closing_m", "glove_moved_m", "elbow_before_deg", "elbow_touch_deg", "elbow_after_deg", "fold_pics", "deepest_deg", "heads_touch_m", "heads_m", "head_to_head_m", "sink_m"]:
			if not (by[key]["v"] as Dictionary).has(f):
				by[key]["v"][f] = []
			(by[key]["v"][f] as Array).append(float(r[f]))
	for key in by:
		var v: Dictionary = by[key]["v"]
		var spans := {}
		for f in v:
			var arr: Array = v[f]
			arr.sort()
			spans[f] = [arr[0], arr[arr.size() / 2], arr[-1]]
		out["takes"][key] = {"n": by[key]["n"], "reads_as_a_punch": by[key]["reads"], "least_median_most": spans}
		print("BC4_TAKE %-18s the glove front at its deepest under his skin (the touch to 4 pictures after) %s m; deepest ball or heel under the canvas %s m (a joint under its own guard height, BODYREACT2's reading: %s m)" % [key, _txt(spans["glove_deep_m"], 3), _txt(spans["sink_m"], 3), _txt(spans["sink_guard_m"], 3)])
		print("BC4_TAKE %-18s %3d exchanges: hips apart %s m | glove to his skin %s m, nearer by %s m in the last %.2f s (moved %s) | elbow before %s, touch %s, after %s deg | his bend: %s pictures, deepest %s deg | heads on the touch %s m (head to head %s), nearest %s m | reads as a punch (heads %.2f or more, nearer by %.2f or more): %d of %d" % [
			key, int(by[key]["n"]), _txt(spans["gap_touch_m"], 2), _txt(spans["glove_m"], 3), _txt(spans["closing_m"], 2), TRAVEL_S, _txt(spans["glove_moved_m"], 2), _txt(spans["elbow_before_deg"], 0), _txt(spans["elbow_touch_deg"], 0), _txt(spans["elbow_after_deg"], 0),
			_txt(spans["fold_pics"], 0), _txt(spans["deepest_deg"], 1), _txt(spans["heads_touch_m"], 2), _txt(spans["head_to_head_m"], 2), _txt(spans["heads_m"], 2), HEADS_MIN_M, TRAVEL_MIN_M, int(by[key]["reads"]), int(by[key]["n"])])
	out["verdict"] = "GREEN" if red_all == 0 else "RED"
	print("BODYCROSS4_RULER %s set %s %s (%d bars failed over both sizes)" % [out["verdict"], set_name, want, red_all])
	var fh := FileAccess.open(out_dir.path_join("bc4_%s_%s_%s.json" % [set_name, _arg("move", "cross"), _arg("tag", "now")]), FileAccess.WRITE)
	fh.store_string(JSON.stringify(out, " "))
	fh.close()


static func _txt(v: Array, digits: int) -> String:
	var f := "%." + str(digits) + "f"
	return (f + " / " + f + " / " + f) % [float(v[0]), float(v[1]), float(v[2])]


## THROWN: n rounds planned as choreographer_test R14 plans them. A body cross is a punch event the plan shows as one.
func _thrown(n: int) -> void:
	var db: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(Census.DB_PATH))
	var with := 0
	var crosses := 0
	var hooks := 0
	var thrown_x := 0
	var thrown_h := 0
	var twice := 0
	var settled := 0
	var punches := 0
	var cut := 0
	var misfit := 0
	var takes := {}
	var offs: Array = []
	var named := 0
	var by_hand := 0
	for sd in n:
		var round := {"n": 1, "won": true, "mine": 60.0, "theirs": 55.0, "corner": "", "lines": []}
		var beats: Array = RS.build(round, "Slugger", "Slugger", 30.0, sd)["beats"]
		for b in beats:
			if str(b["move"]) == "body_hook" and str(b["result"]) == "lands":
				settled += 1
		var plan: Dictionary = Choreo.plan(beats, db, {"t0": 0.0, "t1": 30.0, "gap0": R.REST_M, "seed": sd, "south": {"a": false, "b": false}})
		var got := 0
		for l in plan["log"]:
			if str(l).begins_with("misfit") and str(l).contains(" body_"):
				misfit += 1
				offs.append(str(l).get_slice(" ", 3).trim_prefix("pro_").left(6) + " " + str(l).get_slice(" is ", 1).get_slice(" ", 0))
		for b in beats:
			named += 1 if RS.shown(b, false) == "body_cross" else 0
		var sh: Array = RS.show(beats, {})
		for k in beats.size():
			if str(sh[k]) == "body_cross" and str(beats[k]["result"]) == "lands" and RS.shown(beats[k], false) != "body_cross":
				by_hand += 1
		for side in ["a", "b"]:
			punches += int(plan["counts"][side]["thrown"])
			cut += int(plan["counts"][side]["cut"])
			var last := ""
			for e in plan["tracks"][side]:
				if str(e.get("kind", "")) != "punch":
					continue
				var mv := str(e.get("move", ""))
				thrown_x += 1 if mv == "body_cross" else 0
				thrown_h += 1 if mv == "body_hook" else 0
				if mv.begins_with("body_"):
					takes[str(e.get("clip", ""))] = int(takes.get(str(e.get("clip", "")), 0)) + 1
				if str(e.get("result", "")) == "lands":
					crosses += 1 if mv == "body_cross" else 0
					hooks += 1 if mv == "body_hook" else 0
					got += 1 if mv == "body_cross" else 0
				twice += 1 if mv == "body_cross" and last == "body_cross" else 0
				last = mv
		with += 1 if got > 0 else 0
	var ok: bool = with * 6 >= n and twice == 0
	print("BC4_THROWN %d rounds, %d punches shown: the bout settled %d landed body punches; the plan shows %d landed body crosses in %d rounds (bar: %d) and %d landed body hooks; thrown in all: %d body crosses, %d body hooks; a boxer's two punches running both body crosses: %d (bar: 0)" % [
		n, punches, settled, crosses, with, int(ceil(n / 6.0)), hooks, thrown_x, thrown_h, twice])
	offs.sort()
	print("BC4_THROWN the takes of every body punch thrown: %s; the ribs' side names %d body crosses (of the landed crosses %d are the rear hand by the combination's hands alone); body punches the plan could not put at their take's distance: %d (%s); punches cut: %d" % [str(takes), named, by_hand, misfit, " ".join(PackedStringArray(offs)), cut])
	print("BODYCROSS4_RULER %s thrown (%d of %d rounds land a body cross)" % ["GREEN" if ok else "RED", with, n])
