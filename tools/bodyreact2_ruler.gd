extends SceneTree
## BODYREACT2 (S547, ops/research/TASK_BODYREACT2.md step 0): DOES A LANDED BODY PUNCH FOLD THE HIT BOXER IN THE 3D FIGHT?
## Owner C502: "the reaction should force the opponent to bend hisposture a bit"; S305 / S310 / S369 "body shots still
## have no reaction". BODYCROSS3 made the take that folds on time (pro_hit_by_gutshot_v3_fold) but read it played by
## hand; this ruler reads what THE v2 PLAYER ITSELF plays: a body hook (the body punch the 3D fight throws) is landed
## through the player's own route - Player2.queue -> Choreographer.plan -> ChoreoReact.react / start_s -> Player2's
## events, joins and layers - SEEDS times a size (normal, big), each exchange its own seed by the player's own seed rule.
## Every picture (60 a second) is read AS DRAWN (skeleton_updated, after every layer), as a FIXED SIDE CAMERA sees it:
## the camera looks across the line between the two pelvises on the touch picture and does not move for the exchange.
##   fold   the hit boxer's hips - neck line against upright on that screen (+ = bent toward the puncher), the change
##          since the touch picture (tools/bodycross3_ruler.gd's reading; K51 lines 7, 81, 96: front-loaded, on the blow)
## Bars, a landed body punch (the brief's; no study gives a body punch's flexion in degrees - K51 lines 12, 65-68):
##   ON TIME   FOLD_SHOWN deg or more on FOLD_PICS pictures inside FOLD_S of the touch
##   A BIT     the deepest fold is DEEP_MIN..DEEP_MAX deg (he asked for "a bit": not doubled over)
##   UPRIGHT   within UPRIGHT_DEG of his touch posture again inside UPRIGHT_S (K51 line 77, K48 line 12: reset 0.5-1 s)
##   APART     no head nearer than the picture set's HEAD_CLEAR_M to the other's trunk line and head (tools/pics2d_gate.gd)
##             and no head INSIDE the other man (player2_test's APART: head to head 0.16, head to chest 0.18).
##             The 0.60 half is a DEBT of the body hook itself (player2_test's way: printed with its numbers, it fails
##             only past its guard): pro_body_shot stands the heads 0.46-0.58 m apart ON THE TOUCH PICTURE, before any
##             reaction, on the shipped tree too (pics2d_gate.gd: "the crowded body hooks 0.45-0.60"). The line says
##             how many exchanges were under on the touch picture already and how much nearer the answer brings them;
##             the guard is the other half: a head inside the other man is a FAIL.
##   FLOOR     no ball or ankle of either man more than SINK_M under where it stands in his guard (player2_test's FLOOR)
## Prints which take was drawn, how often; BODYREACT2_RULER GREEN|RED a size and for the pair. Exit 0 either way.
## Also, every run: THE CONTROL ARM - the head reactions 400 seeds a size pick (ChoreoReact.react, each head punch, both
## bodies' sizes) are written to <out>/head_picks_<set>.json; control=<dir> compares them with an earlier run's.
## counts=<n> [play]: instead of the ruler, n rounds are planned (play: and played) and the punches shown are counted.
## waits=<n>: instead of the ruler, n rounds planned as tests/choreographer_test.gd R14 plans them (Slugger v Slugger,
##   seed = the round's number): the fidgets, paws and feints the plan holds, by kind - what a different body answer
##   moves in the quiet stretches after it.
##   <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/bodyreact2_ruler.gd -- <out_dir> fightplayer2 set=m|w [seeds=60] [who=0|1] [tag=<t>] [control=<dir>] [counts=<n> [play]] [waits=<n>] [show]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const RS := preload("res://scripts/rules/RoundScript.gd")
const R := preload("res://scripts/fight3d/v2/ChoreoRules.gd")
const React := preload("res://scripts/fight3d/v2/ChoreoReact.gd")
const Choreo := preload("res://scripts/fight3d/v2/Choreographer.gd")
const Player2 := preload("res://scripts/fight3d/v2/Player2.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const Gate := preload("res://tools/pics2d_gate.gd")
const SETS := {"w": ["11", "14"], "m": ["02", "01"]}   # the films' pairs (tools/pics2d_set.gd): Lucy v Priya; Isaiah v Victor
const THROWS := {"w": 0, "m": 1}                        # the films: women, red throws; men, blue throws
const HZ := 60.0
const FOLD_S := 0.15
const FOLD_SHOWN := 10.0
const FOLD_PICS := 3
const DEEP_MIN := 15.0
const DEEP_MAX := 25.0
const UPRIGHT_DEG := 5.0
const UPRIGHT_S := 0.8
const SINK_M := 0.03
const INSIDE_HEAD_M := 0.16
const INSIDE_CHEST_M := 0.18
const SHEET_BEFORE := 3
const SHEET_AFTER := 8
const AFTER_F := 96          # pictures read after the touch (1.6 s: his whole answer)
const HEADS_F := 60          # ... the crowding is read this long after the touch (1 s)
const SLOT_S := 6            # one exchange: the pair walks in, the hook lands at HIT_AT_S, he answers, both are back
const HIT_AT_S := 1.5
const HEAD_MOVES := ["jab", "cross", "lead_hook", "rear_hook", "lead_uppercut", "rear_uppercut"]
const CONTROL_SEEDS := 400
const BONES := ["Hips", "Spine", "Chest", "UpperChest", "Neck", "Head", "LeftToes", "RightToes", "LeftFoot", "RightFoot"]
const FEET := ["LeftToes", "RightToes", "LeftFoot", "RightFoot"]

var st: Node3D
var p2: Node
var shown: Array = [{}, {}]
var out_dir := "user://bodyreact2"
var set_name := "m"
var who := 1
var slot := 0
var guard_y: Array = [{}, {}]
var show := false


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _w(i: int, bone: String) -> Vector3:
	return (st.boxers[i]["skel"] as Skeleton3D).global_transform * (shown[i].get(bone, Vector3.ZERO) as Vector3)


## Both men as drawn on this picture: [{bone: where}, {bone: where}].
func _pic() -> Array:
	var out: Array = [{}, {}]
	for i in 2:
		for b in BONES:
			out[i][b] = _w(i, str(b))
	return out


static func _flat(v: Vector3) -> Vector3:
	return Vector3(v.x, 0.0, v.z)


## The hips - neck line against upright as the side camera sees it, deg (+ = toward the puncher; dirv: puncher -> him).
static func _lean(p: Dictionary, dirv: Vector3) -> float:
	var t: Vector3 = (p["Neck"] as Vector3) - (p["Hips"] as Vector3)
	return rad_to_deg(atan2(t.dot(-dirv), t.y))


## The picture set's crowding measure on one picture: the nearest a head bone is to the other's trunk line and head.
static func _heads(pic: Array) -> float:
	var best := INF
	for i in 2:
		var h: Vector3 = pic[i]["Head"]
		var line: Array = []
		for bone in Gate.TORSO + ["Head"]:
			line.append(pic[1 - i][bone])
		best = minf(best, Gate.chain_dist([h, h], line))
	return best


func _initialize() -> void:
	Engine.max_fps = int(HZ)
	var args := OS.get_cmdline_user_args()
	if not args.is_empty() and not str(args[0]).contains("="):
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	set_name = _arg("set", "m")
	who = int(_arg("who", str(THROWS[set_name])))
	show = args.has("show")
	Player2.force = true
	FightClips.untouched = true
	st = Stage.new()
	root.add_child(st)
	await process_frame
	var pair: Array = SETS[set_name]
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % pair[0], "corner": "red", "stance": "orthodox"},
		{"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % pair[1], "corner": "blue", "stance": "orthodox"})
	if st.v2 == null:
		print("BODYREACT2_RULER RED the v2 player was not built")
		quit(0)
		return
	p2 = st.v2
	for i in 2:
		var sk: Skeleton3D = st.boxers[i]["skel"]
		var ids: Array = BONES.map(func(b): return sk.find_bone(str(b)))
		var d: Dictionary = shown[i]
		sk.skeleton_updated.connect(func():
			for k in BONES.size():
				d[BONES[k]] = sk.get_bone_global_pose(int(ids[k])).origin)
	for f in 40:
		await process_frame
	for i in 2:
		for b in FEET:
			guard_y[i][b] = _w(i, str(b)).y
	print("BR2 set %s bodies %s; boxer %d throws the body hook; sizes against the census body %.3f / %.3f" % [set_name, pair, who, float(p2.pair.size(0)), float(p2.pair.size(1))])
	_control()
	if _arg("counts", "") != "":
		await _counts(int(_arg("counts", "10")), args.has("play"))
		quit(0)
		return
	if _arg("waits", "") != "":
		_waits(int(_arg("waits", "12")))
		quit(0)
		return
	var seeds := int(_arg("seeds", "60"))
	var runs: Array = []
	for big in [false, true]:
		for k in seeds:
			runs.append(await _exchange(bool(big)))
	_report(runs, seeds)
	quit(0)


## One exchange through the player: a body hook that lands, planned and played by Player2 as in a fight.
func _exchange(big: bool) -> Dictionary:
	var t0 := float(slot * SLOT_S)
	slot += 1
	var ws := "a" if who == 0 else "b"
	var os := "b" if who == 0 else "a"
	var d := 1 - who
	var beats: Array = [{"t": t0 + HIT_AT_S, "who": ws, "move": "body_hook", "result": "lands", "def": "", "big": big}]
	p2.queue(beats, t0, t0 + float(SLOT_S))
	var ev := {}
	for e in p2.plan["tracks"][os]:
		if str(e.get("kind", "")) == "reaction":
			ev = e
	var punch := ""
	for e2 in p2.plan["tracks"][ws]:
		if str(e2.get("kind", "")) == "punch":
			punch = str(e2.get("clip", ""))
	var seen: int = (p2.contacts as Array).size()
	var pics: Array = []
	var ci := -1
	var t := t0
	for f in int(SLOT_S * HZ):
		p2.clock(t, true)
		await process_frame
		t += 1.0 / HZ
		pics.append(_pic())
		if ci < 0 and (p2.contacts as Array).size() > seen:
			ci = pics.size() - 1
	var run := {"big": big, "seed": int(t0) * 131 + 1, "react": str(ev.get("clip", "")), "from_s": snappedf(float(ev.get("from_s", 0.0)), 0.001),
		"until_s": snappedf(float(ev.get("until_s", 0.0)), 0.001), "part": str(ev.get("part", "")), "punch": punch, "touched": ci >= 0, "pass": false, "bars": [false, false, false, false, false]}
	if ci < 0:
		print("BR2 seed %d: the hook never reached its contact (cut)" % int(run["seed"]))
		return run
	var dirv := _flat((pics[ci][d]["Hips"] as Vector3) - (pics[ci][who]["Hips"] as Vector3)).normalized()
	var lean0 := _lean(pics[ci][d], dirv)
	var h0: Vector3 = pics[ci][d]["Hips"]
	var shown_n := 0
	var fold_in := 0.0
	var fold_015 := 0.0
	var most := 0.0
	var most_s := 0.0
	var up_s := -1.0
	var heads := INF
	var inside := 0
	var sink := 0.0
	var hips_back := 0.0
	var rows: Array = []
	for k in range(maxi(ci - SHEET_BEFORE, 0), mini(ci + AFTER_F + 1, pics.size())):
		var f := k - ci
		var dt := float(f) / HZ
		var lean := _lean(pics[k][d], dirv)
		var fold := lean - lean0
		var hb := _flat((pics[k][d]["Hips"] as Vector3) - h0).dot(dirv)
		var hd := _heads(pics[k])
		if f > 0:
			if fold > most:
				most = fold
				most_s = dt
				up_s = -1.0
			elif up_s < 0.0 and most >= FOLD_SHOWN and fold <= UPRIGHT_DEG:
				up_s = dt
			hips_back = maxf(hips_back, hb)
			if dt <= FOLD_S + 1e-6:
				fold_in = maxf(fold_in, fold)
				shown_n += 1 if fold >= FOLD_SHOWN else 0
			if f == int(round(FOLD_S * HZ)):
				fold_015 = fold
		if f >= 0:
			for i in 2:
				for b in FEET:
					sink = maxf(sink, float(guard_y[i][b]) - (pics[k][i][b] as Vector3).y)
		if f <= HEADS_F:
			heads = minf(heads, hd)
			for i in 2:
				var head: Vector3 = pics[k][i]["Head"]
				if head.distance_to(pics[k][1 - i]["Head"]) < INSIDE_HEAD_M or head.distance_to(pics[k][1 - i]["Chest"]) < INSIDE_CHEST_M:
					inside += 1
		if f <= SHEET_AFTER:
			rows.append({"pic": rows.size() + 1, "f": f, "lean_deg": snappedf(lean, 0.1), "fold_deg": snappedf(fold, 0.1), "hips_back_m": snappedf(hb, 0.001), "heads_m": snappedf(hd, 0.001)})
	var bars: Array = [shown_n >= FOLD_PICS, most >= DEEP_MIN and most <= DEEP_MAX, most >= FOLD_SHOWN and up_s > 0.0 and up_s <= UPRIGHT_S,
		heads >= Gate.HEAD_CLEAR_M and inside == 0, sink <= SINK_M]
	run.merge({"gap_touch_m": snappedf(_flat((pics[ci][d]["Hips"] as Vector3) - (pics[ci][who]["Hips"] as Vector3)).length(), 0.001), "lean_touch_deg": snappedf(lean0, 0.1),
		"fold_pics": shown_n, "fold_in_deg": snappedf(fold_in, 0.1), "fold_015_deg": snappedf(fold_015, 0.1), "deepest_deg": snappedf(most, 0.1), "deepest_s": snappedf(most_s, 0.001),
		"upright_s": snappedf(up_s, 0.001), "heads_m": snappedf(heads, 0.001), "heads_touch_m": snappedf(_heads(pics[ci]), 0.001), "inside_frames": inside, "sink_m": snappedf(sink, 0.001), "hips_back_m": snappedf(hips_back, 0.001),
		"rows": rows, "bars": bars, "pass": bars[0] and bars[1] and bars[2] and bars[4] and inside == 0}, true)
	if show:
		print("BR2 %s seed %6d  %-28s from %.3f (%s)  punch %-22s gap %.2f | fold %4.1f in 0.15 s on %d pics, deepest %4.1f at %.2f s, upright %s | heads %.2f (touch %.2f) sink %.3f | %s" % ["big" if big else "nrm", int(run["seed"]), run["react"], float(run["from_s"]), run["part"], punch, float(run["gap_touch_m"]),
			fold_in, shown_n, most, most_s, ("%.2f s" % up_s) if up_s > 0.0 else "never", heads, float(run["heads_touch_m"]), sink, "pass" if bool(run["pass"]) else "FAIL"])
	return run


func _report(runs: Array, seeds: int) -> void:
	var names := ["ON TIME: %d deg or more on %d pictures inside %.2f s" % [int(FOLD_SHOWN), FOLD_PICS, FOLD_S], "A BIT: deepest %d-%d deg" % [int(DEEP_MIN), int(DEEP_MAX)],
		"UPRIGHT: within %d deg again inside %.1f s" % [int(UPRIGHT_DEG), UPRIGHT_S], "APART: no head under %.2f m of the other's trunk line and head, none inside him" % Gate.HEAD_CLEAR_M,
		"FLOOR: no ball or ankle over %d cm under its guard height" % int(SINK_M * 100.0)]
	var out := {"set": set_name, "who": who, "seeds": seeds, "sizes": {}, "runs": [], "sheets": {}}
	var red_all := 0
	for big in [false, true]:
		var mine: Array = runs.filter(func(r): return bool(r["big"]) == bool(big))
		var size := "big" if big else "normal"
		var takes := {}
		var bar_n := [0, 0, 0, 0, 0]
		var ok := 0
		var cut := 0
		for r in mine:
			cut += 0 if bool(r["touched"]) else 1
			ok += 1 if bool(r["pass"]) else 0
			for b in 5:
				bar_n[b] = int(bar_n[b]) + (1 if bool(r["bars"][b]) else 0)
			if not bool(r["touched"]):
				continue
			var key := str(r["react"])
			if not takes.has(key):
				takes[key] = {"n": 0, "from_s": [], "fold_015": [], "fold_in": [], "pics": [], "deep": [], "deep_s": [], "up": [], "heads": [], "sink": [], "hips": []}
				out["sheets"]["%s %s" % [size, key]] = {"seed": r["seed"], "from_s": r["from_s"], "punch": r["punch"], "rows": r["rows"]}
			var tk: Dictionary = takes[key]
			tk["n"] = int(tk["n"]) + 1
			if not (tk["from_s"] as Array).has(r["from_s"]):
				(tk["from_s"] as Array).append(r["from_s"])
			for pr in [["fold_015", "fold_015_deg"], ["fold_in", "fold_in_deg"], ["pics", "fold_pics"], ["deep", "deepest_deg"], ["deep_s", "deepest_s"], ["up", "upright_s"], ["heads", "heads_m"], ["sink", "sink_m"], ["hips", "hips_back_m"]]:
				(tk[pr[0]] as Array).append(float(r[pr[1]]))
		print("BR2 --- set %s, %s body hook, %d seeds (%d never reached the contact)" % [set_name, size, mine.size(), cut])
		var tsum := {}
		for key in takes:
			var tk2: Dictionary = takes[key]
			var up: Array = (tk2["up"] as Array).filter(func(v): return float(v) > 0.0)
			tsum[key] = {"n": tk2["n"], "from_s": tk2["from_s"], "fold_015_deg": _span(tk2["fold_015"]), "fold_in_deg": _span(tk2["fold_in"]), "fold_pics": _span(tk2["pics"]), "deepest_deg": _span(tk2["deep"]),
				"deepest_s": _span(tk2["deep_s"]), "upright_s": _span(up), "upright_never": (tk2["up"] as Array).size() - up.size(), "heads_m": _span(tk2["heads"]), "sink_m": _span(tk2["sink"]), "hips_back_m": _span(tk2["hips"])}
			print("BR2_TAKE %-30s drawn %2d of %d (from %s s): fold at +0.15 s %s deg (most inside 0.15 s %s, pictures at %d or more %s), deepest %s deg at %s s, upright again %s s (never: %d), hips back %s m, heads %s m, deepest foot %s m" % [
				key, int(tk2["n"]), mine.size(), str(tk2["from_s"]), _txt(tk2["fold_015"], 1), _txt(tk2["fold_in"], 1), int(FOLD_SHOWN), _txt(tk2["pics"], 0), _txt(tk2["deep"], 1), _txt(tk2["deep_s"], 2), _txt(up, 2),
				(tk2["up"] as Array).size() - up.size(), _txt(tk2["hips"], 3), _txt(tk2["heads"], 2), _txt(tk2["sink"], 3)])
		var red := 0
		var debt := 0
		var bar_out: Array = []
		var hit: Array = mine.filter(func(r): return bool(r["touched"]))
		var under: Array = hit.filter(func(r): return float(r["heads_m"]) < Gate.HEAD_CLEAR_M)
		var at_touch: int = under.filter(func(r): return float(r["heads_touch_m"]) < Gate.HEAD_CLEAR_M).size()
		var inside_n := 0
		var nearer: Array = []
		var nearest := INF
		for r in hit:
			inside_n += int(r["inside_frames"])
			nearer.append(float(r["heads_touch_m"]) - float(r["heads_m"]))
			nearest = minf(nearest, float(r["heads_m"]))
		nearer.sort()
		for b in 5:
			var pass_b: bool = int(bar_n[b]) == mine.size()
			var word := "PASS" if pass_b else "FAIL"
			var more := ""
			if b == 3:
				more = "; under %.2f m in %d, %d of them already on the touch picture (the punch's own range); the answer brings the heads %.2f m nearer (median, %.2f at most), nearest %.2f m; a head inside the other man on %d pictures" % [Gate.HEAD_CLEAR_M, under.size(), at_touch,
					float(nearer[nearer.size() / 2]) if not nearer.is_empty() else 0.0, float(nearer[-1]) if not nearer.is_empty() else 0.0, nearest, inside_n]
				if not pass_b and inside_n == 0 and hit.size() == mine.size():
					word = "DEBT"
			red += 1 if word == "FAIL" else 0
			debt += 1 if word == "DEBT" else 0
			print("BR2_BAR %s  %s: %d of %d exchanges%s" % [word, names[b], int(bar_n[b]), mine.size(), more])
			bar_out.append({"bar": names[b], "pass": pass_b, "word": word, "n": int(bar_n[b]), "of": mine.size(), "note": more})
		red_all += red
		var verdict := "RED" if red > 0 else ("GREEN" if debt == 0 else "GREEN WITH DEBT")
		print("BODYREACT2_RULER %s set %s %s body hook: %d of %d exchanges hold every bar but the debt (%d of 5 bars failed, %d in debt)" % [verdict, set_name, size, ok, mine.size(), red, debt])
		out["sizes"][size] = {"takes": tsum, "bars": bar_out, "pass": ok, "of": mine.size(), "verdict": verdict}
	for r in runs:
		var slim: Dictionary = (r as Dictionary).duplicate()
		slim.erase("rows")
		(out["runs"] as Array).append(slim)
	out["verdict"] = "GREEN" if red_all == 0 else "RED"
	print("BODYREACT2_RULER %s set %s (%d bars failed over both sizes; a bar in debt is printed above with its numbers)" % [out["verdict"], set_name, red_all])
	var fh := FileAccess.open(out_dir.path_join("ruler_%s_%s.json" % [set_name, _arg("tag", "now")]), FileAccess.WRITE)
	fh.store_string(JSON.stringify(out, "  "))
	fh.close()


static func _span(v: Array) -> Array:
	if v.is_empty():
		return []
	return [snappedf(float(v.min()), 0.001), snappedf(float(v.max()), 0.001)]


static func _txt(v: Array, digits: int) -> String:
	if v.is_empty():
		return "-"
	var f := "%." + str(digits) + "f"
	return (f % float(v.min())) if is_equal_approx(float(v.min()), float(v.max())) else (f + "..." + f) % [float(v.min()), float(v.max())]


## THE CONTROL ARM: what ChoreoReact picks for a landed HEAD punch, CONTROL_SEEDS seeds a size, each head punch, both
## bodies' sizes (a take shown in the last few is passed over as in an exchange: the list of shown takes is cleared
## every 5 seeds). The take and where it starts. The body rule may not change one of them.
func _control() -> void:
	var db: Dictionary = p2.db
	var rows: Dictionary = db["rows"]
	var hfh: float = float((db.get("meta", {}) as Dictionary).get("head_from_hips_m", 0.023))
	var hz: float = float((db.get("meta", {}) as Dictionary).get("curve_hz", 30.0))
	var out := {}
	var n := 0
	for sc in [float(p2.pair.size(0)), float(p2.pair.size(1))]:
		for move in HEAD_MOVES:
			for big in [false, true]:
				var picks: Array = []
				var used: Array = []
				for sd in CONTROL_SEEDS:
					if sd % 5 == 0:
						used.clear()
					var rng := RandomNumberGenerator.new()
					rng.seed = sd
					var ri: Array = React.react(db, rows, str(move), bool(big), R.is_left_hand(str(move)), rng, hfh, [], float(sc), used)
					var ss: Array = React.start_s(ri[1], str(move), hz, float(sc))
					picks.append("%s@%.3f%s" % [ri[0], float(ss[0]), "s" if bool(ss[1]) else ""])
					n += 1
				out["%s %s sc %.3f" % [move, "big" if big else "normal", float(sc)]] = picks
	var path := out_dir.path_join("head_picks_%s.json" % set_name)
	var was_dir := _arg("control", "")
	if was_dir != "":
		var was: Variant = JSON.parse_string(FileAccess.get_file_as_string(was_dir.path_join("head_picks_%s.json" % set_name)))
		var diff := 0
		var total := 0
		if was is Dictionary:
			for key in out:
				var a: Array = out[key]
				var b: Array = (was as Dictionary).get(key, [])
				for k in a.size():
					total += 1
					diff += 0 if k < b.size() and str(a[k]) == str(b[k]) else 1
		print("BR2_CONTROL %s head reactions: %d of %d picks (take and start) are the same as %s (%d differ)" % ["SAME" if was is Dictionary and diff == 0 and total == n else "CHANGED", total - diff, n, was_dir, diff])
	var fh := FileAccess.open(path, FileAccess.WRITE)
	fh.store_string(JSON.stringify(out, " "))
	fh.close()
	print("BR2_CONTROL wrote %d head picks (%d punches x 2 sizes x %d seeds x 2 bodies) to %s" % [n, HEAD_MOVES.size(), CONTROL_SEEDS, path])


## THE LOOP CHECK (the brief's Feedback loops): a longer or deeper body reaction may delay the hit boxer's next move
## and change what the plan plays next. n rounds as player2_test builds them: the punches the plan shows (thrown less
## cut), landed, and - play - the contacts the player really reached.
func _counts(n: int, play: bool) -> void:
	var out: Array = []
	for sd in n:
		var round := {"n": 1, "won": sd % 2 == 0, "mine": 60.0, "theirs": 55.0, "corner": "", "lines": []}
		var beats: Array = RS.build(round, "Slugger", "Boxer", 30.0, 100 + sd)["beats"]
		var t0 := float(sd) * 30.0
		var body_landed := 0
		for b in beats:
			b["t"] = float(b["t"]) + t0
			if str(b["move"]) == "body_hook" and str(b["result"]) == "lands":
				body_landed += 1
		p2.queue(beats, t0, t0 + 30.0)
		var c: Dictionary = p2.plan["counts"]
		var body := {}
		var reacts := 0
		for side in ["a", "b"]:
			for e in p2.plan["tracks"][side]:
				if str(e.get("kind", "")) == "reaction":
					reacts += 1
					if str(e.get("move", "")) == "body_hook":
						body[str(e["clip"])] = int(body.get(str(e["clip"]), 0)) + 1
		var seen: int = (p2.contacts as Array).size()
		if play:
			var t := t0
			while t < t0 + 30.0:
				p2.clock(t, true)
				await process_frame
				t += 1.0 / HZ
		var reached: int = (p2.contacts as Array).size() - seen
		var row := {"seed": 100 + sd, "thrown": int(c["a"]["thrown"]) + int(c["b"]["thrown"]), "landed": int(c["a"]["landed"]) + int(c["b"]["landed"]), "cut": int(c["a"]["cut"]) + int(c["b"]["cut"]),
			"reactions": reacts, "body_landed": body_landed, "body_takes": body, "reached": reached if play else -1}
		out.append(row)
		print("BR2_COUNTS seed %d: the plan shows %d punches (%d landed, %d cut), %d reactions; body hooks landed %d -> %s%s" % [int(row["seed"]), int(row["thrown"]), int(row["landed"]), int(row["cut"]), reacts, body_landed, str(body),
			("; played: %d contacts reached" % reached) if play else ""])
	var fh := FileAccess.open(out_dir.path_join("counts_%s_%s.json" % [set_name, _arg("tag", "now")]), FileAccess.WRITE)
	fh.store_string(JSON.stringify(out, "  "))
	fh.close()


## The wait things of n planned rounds, by kind (the first 12 seeds apart: choreographer_test R14's own sample).
func _waits(n: int) -> void:
	var all := {}
	var first := {}
	var punches := 0
	var body := 0
	for sd in n:
		var round := {"n": 1, "won": true, "mine": 60.0, "theirs": 55.0, "corner": "", "lines": []}
		var beats: Array = RS.build(round, "Slugger", "Slugger", 30.0, sd)["beats"]
		var plan: Dictionary = Choreo.plan(beats, p2.db, {"t0": 0.0, "t1": 30.0, "gap0": R.REST_M, "seed": sd, "south": {"a": false, "b": false}})
		for side in ["a", "b"]:
			punches += int(plan["counts"][side]["thrown"])
			for e in plan["tracks"][side]:
				var k := str(e["kind"])
				if k in ["fidget", "feint"]:
					var what := str(e.get("what", k))
					all[what] = int(all.get(what, 0)) + 1
					if sd < 12:
						first[what] = int(first.get(what, 0)) + 1
				elif k == "reaction" and str(e.get("move", "")) == "body_hook":
					body += 1
	print("BR2_WAITS %d rounds: %d punches shown, %d landed body hooks; wait things %s; the first 12 rounds (choreographer_test R14) %s" % [n, punches, body, str(all), str(first)])
