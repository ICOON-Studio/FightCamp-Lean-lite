extends "res://tools/pics2d_set.gd"
## RINGANIM1 (S552, task ops/research/TASK_RINGANIM1.md). The owner on Ring Switches (S551): "we need to work on the
## visuals of the fight so the player can understand the actions by seeing every card being executed by the fighters".
## A FRAME RUN for every picture of the still set: the pair is placed exactly as the still tool places it (the range
## FOUND, tools/pics2d_gate.gd), then the take is played again from its start, once for each frame, and stopped at a
## fixed time before or after the contact. The other man plays his own answer in step: the hit reaction (landed), his
## block or cover-up (blocked), his pull or duck (missed). The camera is fixed on the contact for the whole run.
## Nothing is layered over a take and nothing under scripts/ is changed: this records what the v2 player plays.
##   python tools/hidden_desktop.py run --timeout=3000 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_anim.gd -- <out_dir> art=toon set=m \
##       [only=<prefix> | only=*<part>] [offs=-0.3,-0.2,...] [take=<clip>]
## Writes <out_dir>/<run>_<k>.png and <out_dir>/frames.json; prints PICS2D_ANIM runs=<n> frames=<n> refused=<n> gate_failed=<n>.

const R := preload("res://scripts/fight3d/v2/ChoreoRules.gd")
const MirrorClip := preload("res://scripts/fight3d/MirrorClip.gd")
const HOLD_DIR := "res://assets/anim/baked/holds/"
## s from the contact. The task's first guess (-0.30 .. +0.12) left the hand out at the end of the strip and started
## an uppercut after its dip: the way in from -0.42, the hand home by +0.30 (arm_home_s + the home join's 0.22).
const OFFS := [-0.42, -0.30, -0.20, -0.13, -0.08, -0.04, 0.0, 0.06, 0.12, 0.20, 0.30]
const EPS := 0.008

var offs: Array = OFFS
var runs := {}
## S562 (owner: "the distance between fighters is not consistant when clips play, it gets reset when some clip animations
## play", and "i select hold your ground yet the animation showed my fighter moving"): a punch run stood the puncher on
## the spot his glove needs for the whole run (the jab at Mid, the hooks between Mid and Inside), so on the page the men
## jumped to that gap and back at every punch. range=<1|2|3>: the run is made at the page's range (Long 3 = the plain
## name, Mid _r2, Inside _r1): the puncher starts and ends on his spot at that range (one step of 0.355 m in a range, as
## the hold and step pictures stand) and moves into the punch's own spot on the way in, back out after the contact.
## The contact pose (and the gate on it) is the same as before. range=0 (no arg): the old runs.
## INSIDE1 (S562, owner on the Inside hold: "the distance looks wrong to me"): ONE table of the page's ranges, metres in
## from the guard spots, read by every picture tool (pics2d_anim_more RANGE_IN, pics2d_head, pics2d_kick) and kept the
## same in proto/twohands/ring_ui.js RANGE_M. Mid is one step take (0.355 m); Inside was two (0.71: the men 0.69 m apart,
## the clinch's tie-up gap) and is now where the holds pass the picture gate (docs/INSIDE1_RESULT.md).
const RANGE_LONG_M := 0.0
const RANGE_MID_M := 0.355
const RANGE_INSIDE_M := 0.55   # INSIDE1 S564: the probe (docs/INSIDE1_RESULT.md) - holds pass the ring bars, feet midpoints 0.80 m
const RANGE_M := {3: RANGE_LONG_M, 2: RANGE_MID_M, 1: RANGE_INSIDE_M}
var RANGE_AT := 0
## short=1 (with range=): the punch FALLS SHORT - thrown from the puncher's spot at that range, he never moves into it, the
## other man stands (no dodge): the page plays it for a punch thrown from further than it reaches. Runs <fam>_short[_r<n>].
var SHORT := false
const GLIDE_IN_TO := -0.10   # in the punch's spot this long before the contact
const GLIDE_OUT_FROM := 0.06   # and leaves it after this
var glide_a := -INF   # S564: the run's first DRAWN offset (a run whose punch starts late draws from offs[first], not offs[0])


func _run() -> void:
	RANGE_AT = int(_arg("range", "0"))
	SHORT = _arg("short", "0") == "1"
	if _arg("offs", "") != "":
		offs = []
		for s in _arg("offs", "").split(","):
			offs.append(float(s))
	for who in 2:
		for fam in FAMILIES:
			for res in (["missed"] if SHORT else RESULTS):
				var name := "%s_%s_%s" % [["red", "blue"][who], fam, "short" if SHORT else res] + ("_r%d" % RANGE_AT if RANGE_AT in [1, 2] else "")
				if _want(name):
					await _punch_run(who, str(fam), str(res), name)
	_finish()


## An authored held-hand take (HOLDTAKES1, assets/anim/baked/holds) put on a boxer's player; a mirrored man gets it mirrored.
## LOWCOVER1 (S557): a blocked body punch is met by the lead forearm held low on the ribs - the page's own rule ("the
## lead hand held low blocks body punches") and J50 row 2 ("low block / elbow-down body guard"). Until now it met the
## shell take, whose elbows stay 0.44-0.47 m over the rib target, so a blocked body punch was drawn at chest height.
func _add_hold(who: int, clip: String) -> void:
	var ap: AnimationPlayer = stage.boxers[who]["ap"]
	var skel: Skeleton3D = stage.boxers[who]["skel"]
	if ap.has_animation(clip):
		return
	FightClips._add_baked(ap.get_animation_library(""), skel, str(ap.get_node(ap.root_node).get_path_to(skel)), clip, HOLD_DIR + clip + ".res")
	if ap.has_animation(clip) and bool(stage.boxers[who].get("south", false)):   # a mirrored man: his lead is his right
		var lib: AnimationLibrary = ap.get_animation_library("")
		var m: Animation = MirrorClip.mirror(lib.get_animation(clip), skel, MirrorClip._plane(skel))
		if m != null:
			lib.remove_animation(clip)
			lib.add_animation(clip, m)


## only=a,b,c: several names (each as the still tool reads one: a prefix, or *part).
func _want(name: String) -> bool:
	if not only.contains(","):
		return super._want(name)
	for part in only.split(","):
		if name.begins_with(part) or (part.begins_with("*") and name.contains(part.substr(1))):
			return true
	return false


func _save() -> void:   # after every run: a render that is cut short keeps what it made
	var fh := FileAccess.open(out_dir.path_join("frames.json"), FileAccess.WRITE)
	var doc := {"runs": runs}
	if bool(camv.get("ring", false)):   # RINGCAM1: one camera for every run; a metre along red -> blue is this many px
		doc["camera"] = {"ring": true, "px_per_m": SIZE / cam.size, "axis_px": [snappedf((_px(axis) - _px(Vector3.ZERO)).x, 0.01), snappedf((_px(axis) - _px(Vector3.ZERO)).y, 0.01)], "size_m": cam.size}
	fh.store_string(JSON.stringify(doc, "  "))
	fh.close()


func _finish() -> void:
	_save()
	print("PICS2D_ANIM runs=%d frames=%d refused=%d gate_failed=%d %s" % [runs.size(), wrote, refused, failed.size(), " ".join(PackedStringArray(failed))])
	quit(0 if refused == 0 and failed.is_empty() else 1)


## The still tool's own search (pics2d_set._punch), returning what it found instead of taking the picture:
## {clip, cover, step, side, hand, cs, fails}. Empty when the boxer has no take of the family.
func _find(who: int, fam: String, res: String) -> Dictionary:
	var takes := _takes(who, fam)
	var body: bool = FAMILIES[fam][1]
	if res == "blocked" and body:
		_add_hold(1 - who, COVER[0])
	var covers: Array = Array(_arg("cover", "").split(",")) if _arg("cover", "") != "" else COVER   # cover=mc_to_block,mc_block: the S556 cover-ups again (the before numbers)
	var dirv := axis * (1.0 if who == 0 else -1.0)
	var best := {}
	var tries: Array = []
	for clip in takes:
		for cv in (covers + [""] if res == "blocked" and body else [""]):
			tries.append([clip, cv])
	for tr in tries:
		var clip: String = tr[0]
		cover = tr[1]
		var row: Dictionary = stage.v2.db["rows"][clip]
		var cs := float(row.get("contact_s", 0.3))
		var hand: String = stage.hand_of(who, str(row.get("hand", "LeftHand")))
		await _home_guard()
		stage.v2._play(who, clip, 0.0, "punch", false)
		await _to_contact(who, clip, cs)
		var step: float = (stage.v2.target(1 - who, body) - stage.glove_front(who, hand)).dot(dirv) - (0.10 if res == "blocked" else 0.0)
		var side := Vector3.ZERO
		for attempt in 6:
			await _pose(who, clip, fam, res, cs, hand, body, step, side)
			var m: Dictionary = Gate.punch(stage, who, hand, res, body, dirv, _px, SIZE / cam.size, _view())
			m["clip"] = clip
			if best.is_empty() or (m["fails"] as Array).size() < (best["fails"] as Array).size():
				best = m.merged({"step": step, "side": side, "hand": hand, "cs": cs, "cover": cover})
			if (m["fails"] as Array).is_empty():
				break
			var back := maxf(maxf(Gate.APART_MIN_M - float(m["apart_m"]), Gate.FEET_MIN_M - float(m["feet_m"])), Gate.HEAD_CLEAR_M - float(m["head_clear_m"]))
			if back > 0.0:
				step -= back + 0.02
				continue
			var gl: Vector3 = stage.glove_front(who, hand)
			var goal: Vector3 = stage.v2.target(1 - who, body) if res == "landed" else _block_point(who, hand, body)
			if res == "missed" or not goal.is_finite():
				break
			var r := goal - gl
			step += r.dot(dirv)
			side += Vector3(r.x, 0.0, r.z) - dirv * r.dot(dirv)
		if (best["fails"] as Array).is_empty():
			break
	return best


func _punch_run(who: int, fam: String, res: String, name: String) -> void:
	var b := await _find(who, fam, res)
	if b.is_empty():
		print("PICS2D_ANIM no %s take on %s" % [fam, name])
		refused += 1
		return
	var clip: String = b["clip"]
	var cs := float(b["cs"])
	var body: bool = FAMILIES[fam][1]
	var d := 1 - who
	cover = b["cover"]
	if RANGE_AT in [1, 2, 3]:
		b["glide_from"] = float(RANGE_M[RANGE_AT])
	# The still's own pose once more: the camera is fixed on it, and how far the other man gave ground (a miss) is read
	# from it, so he stands there from the first frame on (the punch is out of range all the way, not at the end only).
	await _pose(who, clip, fam, res, cs, b["hand"], body, float(b["step"]), b["side"])
	var give: Vector3 = Vector3.ZERO if SHORT else _node(d).global_position - home_t[d].origin   # S562: out of reach, he gives no ground
	_aim([0, 1])
	var pl := _plan(who, b, fam, res)
	if SHORT:   # he is out of reach: nothing to dodge
		pl["ans"] = ""
		pl["ans_t"] = INF
		pl["weave"] = false
		pl["t0"] = float(pl["punch_t"])
	# Everything is played LIVE here (the still froze each man where it wanted him): the contact is posed and measured
	# once more, and the pair is moved by what the gate still misses - the still tool's own rule (pics2d_set._punch):
	# bodies, feet or heads too close step the puncher back; a miss too near gives the other man more ground; a glove
	# short of its block or its target steps the puncher in by what is left.
	var dirv := axis * (1.0 if who == 0 else -1.0)
	var near := res == "missed" and bool(pl.get("weave", false))   # C508: a hook that misses is a NEAR miss
	if near:
		# The weave at its deepest takes the head 0.25 m under the glove, and the first staging also gave ground on top.
		# Searched instead: the SHALLOWEST duck (the take entered so its deepest point comes after the contact) and the
		# LEAST ground given at which the glove still clears his face and his gloves on the picture. The take itself is
		# not changed and nothing is layered on it.
		var best := {}
		var best_roomy := {}
		for depth in [1.0, 0.8, 0.64]:   # under 0.6 he is hardly ducking and the glove lands on his guard on the picture (seen S554)
			_dodge_at(pl, float(depth))
			pl["t0"] = minf(float(pl["punch_t"]), float(pl["ans_t"]))
			for g in [0.0, 0.05, 0.10, 0.15, 0.20, 0.25]:
				var gv: Vector3 = dirv * float(g)
				await _pose_at(who, b, pl, gv, 0.0)
				await process_frame
				var m: Dictionary = Gate.punch(stage, who, b["hand"], res, body, dirv, _px, SIZE / cam.size, _view())
				var back_n := maxf(maxf(Gate.APART_MIN_M - float(m["apart_m"]), Gate.FEET_MIN_M - float(m["feet_m"])), Gate.HEAD_CLEAR_M - float(m["head_clear_m"]))
				if back_n > 0.0 and best.is_empty():
					b["step"] = float(b["step"]) - back_n - 0.02
					await _pose_at(who, b, pl, gv, 0.0)
					await process_frame
					m = Gate.punch(stage, who, b["hand"], res, body, dirv, _px, SIZE / cam.size, _view())
				if not _near_fails(m).is_empty():
					continue   # too near his face or his gloves, or the bodies meet: more ground
				var clear := float(m.get("clear_m", 1.0))
				var roomy := float(m.get("clear_hand_m", 1.0)) >= Gate.MISS_NEAR_HAND_M   # the two gloves do not overlap on the picture
				if roomy and (best_roomy.is_empty() or clear < float(best_roomy["clear"])):
					best_roomy = {"clear": clear, "depth": float(depth), "give": gv}
				if best.is_empty() or clear < float(best["clear"]):
					best = {"clear": clear, "depth": float(depth), "give": gv}
				if roomy:
					break   # more ground only takes the glove further away
			if not best_roomy.is_empty() and float(best_roomy["clear"]) <= Gate.MISS_NEAR_GOOD_M:
				break
		if not best_roomy.is_empty():
			best = best_roomy   # a miss whose glove is clear of his gloves is taken before a nearer one that is not: glove on glove reads as a block (seen S554)
		if best.is_empty():
			best = {"clear": -1.0, "depth": 1.0, "give": give}
		give = best["give"]
		_dodge_at(pl, float(best["depth"]))
		pl["t0"] = minf(float(pl["punch_t"]), float(pl["ans_t"]))
		print("MISS_FIT %s: the duck at %.0f%% of its depth on the contact, ground given %.2f m, glove %.3f m from his face on the picture" % [name, 100.0 * float(best["depth"]), (give as Vector3).length(), float(best["clear"])])
	for attempt in (0 if near or SHORT else 4):
		await _pose_at(who, b, pl, give, 0.0)
		await process_frame
		var m: Dictionary = Gate.punch(stage, who, b["hand"], res, body, dirv, _px, SIZE / cam.size, _view())
		if (m["fails"] as Array).is_empty():
			break
		var back := maxf(maxf(Gate.APART_MIN_M - float(m["apart_m"]), Gate.FEET_MIN_M - float(m["feet_m"])), Gate.HEAD_CLEAR_M - float(m["head_clear_m"]))
		if back > 0.0:
			b["step"] = float(b["step"]) - back - 0.02
		elif res == "missed":
			give += dirv * (maxf(Gate.MISS_PX_M - float(m.get("clear_m", 1.0)), Gate.MISS_HAND_M - float(m.get("clear_hand_m", 1.0))) + 0.04)
		elif res == "blocked":
			b["step"] = float(b["step"]) + float(m.get("block_m", 0.0)) - 0.02
		else:
			b["step"] = float(b["step"]) + float(m.get("hit_m", 0.0)) - 0.01
	var first := 0 # the offsets before anything starts are all the guard: keep the last of them only
	for k in offs.size():
		if float(offs[k]) <= float(pl["t0"]):
			first = k
	glide_a = float(offs[first])
	var files: Array = []
	var times: Array = []
	var gate_fails: Array = []
	var hit_at: Array = []   # C509: where the glove is on the contact picture, as a share of its width and height
	var ok := true
	for k in range(first, offs.size()):
		var off := float(offs[k])
		await _pose_at(who, b, pl, give, off)
		var f := "%s_%d" % [name, files.size()]
		if not await _frame(f):
			ok = false
			break
		if is_zero_approx(off):   # measured on the pose that was drawn
			var m: Dictionary = Gate.punch(stage, who, b["hand"], res, body, axis * (1.0 if who == 0 else -1.0), _px, SIZE / cam.size, _view())
			gate_fails = m["fails"]
			if m.has("body_up_m"):
				print("BODY_UP %s: the glove's front %.3f m over the body target (bar %.2f), stopped by %s, cover %s" % [name, float(m["body_up_m"]), Gate.BODY_UP_M, str(m.get("block_on", "?")), cover if cover != "" else "none"])
			var gp: Vector2 = _px(stage.glove_front(who, b["hand"]))
			hit_at = [snappedf(gp.x / SIZE, 0.001), snappedf(gp.y / SIZE, 0.001)]
			if near:
				gate_fails = _near_fails(m)
				if float(m.get("clear_m", 0.0)) > Gate.MISS_NEAR_MAX_M + 0.03:   # said, not failed: his own gloves are in the way of anything nearer
					print("MISS_WIDE %s: glove %.3f m from his face (a near miss is %.2f at most) - nearer would put it on his gloves" % [name, float(m["clear_m"]), Gate.MISS_NEAR_MAX_M])
		files.append(f + ".png")
		times.append(off)
	if not ok:
		refused += 1
		return
	if not gate_fails.is_empty():
		print("PICS_GATE FAIL %s (contact frame): %s" % [name, "; ".join(PackedStringArray(gate_fails))])
		failed.append(name)
	runs[name] = {"files": files, "offs": times, "contact": times.find(0.0), "clip": clip, "cover": cover, "answer": pl["ans"],
		"step": snappedf(float(b["step"]), 0.001), "gate_fails": gate_fails, "hit": hit_at, "range": RANGE_AT, "glide_from": snappedf(float(b.get("glide_from", -1.0)), 0.001)}
	print("PICS2D_ANIM %s = %s%s, answer %s, %d frames, step %.2f m" % [name, clip, " cover " + cover if cover != "" else "", pl["ans"], files.size(), float(b["step"])])
	_save()


## S562: 0 on the range's spot, 1 on the punch's spot - smooth in from the run's first offset to GLIDE_IN_TO, smooth out
## from GLIDE_OUT_FROM to its last.
func _glide_w(off: float) -> float:
	if SHORT:
		return 0.0
	var a := maxf(float(offs[0]), glide_a)   # S564: 0 on the first picture drawn (it was 0.3 in on the crosses: 13-22 px)
	var z := float(offs[offs.size() - 1])
	if off <= GLIDE_IN_TO:
		return smoothstep(a, GLIDE_IN_TO, off)
	if off >= GLIDE_OUT_FROM:
		return 1.0 - smoothstep(GLIDE_OUT_FROM, z, off)
	return 1.0


## WHEN each thing of the run starts, in seconds from the contact, as the v2 player times it (Choreographer, Player2):
## the punch from its take's start_s; a landed punch's reaction one picture after the glove arrives, part-way into its
## take so the head is furthest ChoreoRules.react_peak_s later; a block or a dodge so that it is where the still has it
## on the contact; the punching arm home ChoreoRules.arm_home_s after the contact (the guard, through Player2.JOIN_HOME).
func _plan(who: int, b: Dictionary, fam: String, res: String) -> Dictionary:
	var clip: String = b["clip"]
	var cs := float(b["cs"])
	var body: bool = FAMILIES[fam][1]
	var rows: Dictionary = stage.v2.db["rows"]
	var dap: AnimationPlayer = stage.boxers[1 - who]["ap"]
	var from_s := clampf(float((rows[clip] as Dictionary).get("start_s", 0.0)), 0.0, cs - 0.05)
	var pl := {"fam": fam, "res": res, "from_s": from_s, "punch_t": from_s - cs, "home_t": R.arm_home_s(fam), "ans": "", "ans_kind": "reaction", "ans_t": INF, "ans_from": 0.0}
	if res == "landed":
		pl["ans"] = str(REACT.get(fam, ""))
		var peak := float((rows.get(pl["ans"], {}) as Dictionary).get("head_peak_s", 0.3))
		pl["ans_t"] = 1.0 / 60.0
		pl["ans_from"] = maxf(0.0, peak - R.react_peak_s(fam))
	elif res == "blocked":
		if body and cover != "" and dap.has_animation(cover):
			pl["ans"] = cover
			pl["ans_kind"] = "block"
			pl["ans_t"] = -minf(COVER_AT, dap.get_animation(cover).length - 0.02)
	else:
		var kind := "weave" if fam in ["lead_hook", "rear_hook"] else "pull"
		pl["ans"] = BeatClips.defence(kind, fam, str(b["hand"]) == "LeftHand", false, func(c: String) -> bool: return dap.has_animation(c))
		pl["ans_kind"] = "defence"
		if pl["ans"] != "":   # Choreographer: a dodge starts min(its head's peak, DEF_LEAD_S) before the contact, that far before its peak
			var dpeak := float((rows.get(pl["ans"], {}) as Dictionary).get("head_peak_s", dap.get_animation(pl["ans"]).length * 0.42))
			pl["dpeak"] = dpeak
			pl["weave"] = kind == "weave"
			_dodge_at(pl, 1.0)
	if pl["ans"] == "" or not dap.has_animation(pl["ans"]):
		pl["ans"] = ""
		pl["ans_t"] = INF
	pl["t0"] = minf(float(pl["punch_t"]), float(pl["ans_t"]))
	return pl


## A hook that misses is a NEAR miss (C508): the gate's 0.20 m clear of the face becomes MISS_NEAR_MIN_M for it.
func _near_fails(m: Dictionary) -> Array:
	var out: Array = []
	for f in (m["fails"] as Array):
		if str(f).begins_with("clear_m") and float(m.get("clear_m", 0.0)) >= Gate.MISS_NEAR_MIN_M - 0.005:
			continue
		out.append(f)
	return out


## Where the dodge is ON THE CONTACT: f = 1 at its deepest (the Choreographer's timing), less = still on its way down.
## C508 (owner S553 on the missed lead hook: "hook aims too high i think and too far away from the head"): the weave was
## at its deepest on the contact and the man stood ducked from the first frame, so the hook swept 0.3 m over him. The
## take is not changed and nothing is layered on it: it is entered so that the head is just under the glove as it passes.
func _dodge_at(pl: Dictionary, f: float) -> void:
	var x := float(pl["dpeak"]) * f
	var lead_in := minf(x, R.DEF_LEAD_S)
	pl["ans_t"] = -lead_in
	pl["ans_from"] = x - lead_in
	pl["depth"] = f


## One frame of the run: the pair on the found spots, everything played from the run's start in real time and stopped
## `off` s from the contact.
func _pose_at(who: int, b: Dictionary, pl: Dictionary, give: Vector3, off: float) -> void:
	var clip: String = b["clip"]
	var cs := float(b["cs"])
	var hand: String = b["hand"]
	var fam: String = pl["fam"]
	var res: String = pl["res"]
	var body: bool = FAMILIES[fam][1]
	var d := 1 - who
	var w := _glide_w(off) if b.has("glide_from") else 1.0
	await _home_guard(lerpf(float(b.get("glide_from", 0.0)), float(b["step"]), w), who)
	_node(who).global_position += b["side"] * w
	_node(d).global_position += give * w   # S564: the ground a miss gives eases in and out with the glide (it stood moved on the run's ends: 27-37 px)
	var hips0 := (Gate.world(stage, who, "Hips") - _node(who).global_position) * Vector3(1, 0, 1)   # the guard's hips from his root
	var hips_d0 := (Gate.world(stage, d, "Hips") - _node(d).global_position) * Vector3(1, 0, 1)
	if off <= float(pl["t0"]):
		return   # the guard, before anything starts
	var todo: Array = [
		[float(pl["punch_t"]), func() -> void:
			if res == "landed":
				stage.v2._arm(who, clip, body)
			elif res == "blocked":
				_aim_block(who, clip, fam, cs, hand, body, cs - float(pl["from_s"]))
			stage.v2._play(who, clip, float(pl["from_s"]), "punch", false)],
		[float(pl["ans_t"]), func() -> void:
			if res == "landed" and body:
				stage.v2._join_next = Player2.JOIN_FOLD
			stage.v2._play(d, pl["ans"], float(pl["ans_from"]), pl["ans_kind"], false)],
		[float(pl["home_t"]), func() -> void:
			stage.v2._join_next = Player2.JOIN_HOME
			stage.v2.guard(who)]]
	var t := float(pl["t0"])
	while true:
		for e in todo:
			if e.size() == 2 and t >= float(e[0]) - EPS:
				(e[1] as Callable).call()
				e.append(true)
		if t >= off - EPS:
			break
		await process_frame
		t += 1.0 / 60.0
	if b.has("glide_from") and w < 1.0:   # S564: his BODY (not his root) on the range's spot at the run's ends - a take whose first pose stands the hips off the root (the cross: 13-22 px)
		_node(who).global_position += (hips0 - (Gate.world(stage, who, "Hips") - _node(who).global_position) * Vector3(1, 0, 1)) * (1.0 - w)
		if res == "missed":   # S564: a miss's pull back carries him away in its take (red's jab: blue's toes out of the picture); his body too
			_node(d).global_position += (hips_d0 - (Gate.world(stage, d, "Hips") - _node(d).global_position) * Vector3(1, 0, 1)) * (1.0 - w)
	# Frozen HERE and drawn in this same frame (pics2d_anim._frame): a wait would let the layers that run on the clock
	# (the join smoother, PunchAim, BlockCatch) go on while the takes stand still - the first strips had the arm home
	# 0.05 s early because of three such frames.
	_freeze(who)
	_freeze(d)


## A blocked punch, armed at the punch's start (pics2d_set._arm_block's rule with the block timed to the real contact):
## a head punch meets her BlockCatch glove, `contact_in` s from now; the glove's finish is aimed at her block (her
## glove's padding, or her forearm for a body punch - the cover-up itself is played by the run, in step).
func _aim_block(who: int, clip: String, fam: String, cs: float, hand: String, body: bool, contact_in: float) -> void:
	if not body:
		BlockCatch.block(stage, who, clip, fam, cs, 1.0, contact_in)
	var node: Node3D = _node(who)
	var front: Vector3 = stage.v2._fronts[who][clip]
	var tgt := func() -> Vector3: return _block_point(who, hand, body)
	(stage.v2._aim[who] as Node).arm(clip, hand, cs, func() -> Vector3: return tgt.call() - node.global_transform * front,
		(stage.v2._rels[who] as Dictionary).get(clip, Vector3.ZERO), tgt)


## Saves the picture as the camera stands (never re-aimed inside a run). False when a boxer is not whole in it.
func _frame(name: String, who: Array = [0, 1]) -> bool:
	var bad := Gate.framed(stage, cam, who, SIZE)
	if not bad.is_empty():
		print("STILL_FRAMING FAIL %s: %s" % [name, "; ".join(PackedStringArray(bad))])
		return false
	await RenderingServer.frame_post_draw
	sv.get_texture().get_image().save_png(out_dir.path_join(name + ".png"))
	wrote += 1
	return true
