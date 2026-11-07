extends SceneTree
## S399 HITSELL5 probe: three LIVE rounds, the fight3d_play.gd flow. Every head punch that SHOWS (not cut off):
## defender's head bone rotation (deg) and travel (m) over 0.35 s from contact, peak time, reaction clip, HitSnap
## degrees asked, hit-stop held, gap. LANDED from hit_gaps; BLOCKED = defence clip within 0.5 s of attack, no hit.
## Bars (main must FAIL): landed turn >= 15 deg and >= 2.5x blocked; travel >= 0.04 m; blocked turn <= 6 deg;
## peak within 0.08 s; no frame > 30 deg.  --headless --audio-driver Dummy --path . --fixed-fps 30 --script res://tools/head_react_probe.gd -- show3d

const Bouts := preload("res://scripts/state/Bouts.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")
const HitSnap := preload("res://scripts/fight3d/HitSnap.gd")
const PoseTap := preload("res://tools/pose_tap.gd")

const W := 1280
const H := 720
const ROUNDS := 3
const WIN_S := 0.35
const SHOTS_MIN := 3
const TAP_BONES := ["Head", "Neck", "Chest", "Spine", "Hips"]
const KEEP_F := 150
const START_WIN_F := 6
const ATK_WITHIN_S := 0.5
const BLK_WINDOW_S := 0.5

var main: Node
var view: Node
var stage: Node3D
var taps: Array = []
var history: Array = [[], []]
var starts: Array = [[], []]
var shots: Array = []
var _cuts: Array = []
var picked := {}
var counts := {}
var _clock := 0.0
var _armed := false
var _playing_round := 0
var _rounds_done := 0
var _bout_over := false


func _initialize() -> void:
	root.size = Vector2i(W, H)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	f["arrows"] = [{"move": "1-1"}, {"move": "step_back"}, {"move": "tie_up"}, {"move": "pivot_out"}]
	for i in 60:
		if not (f["offers"] as Array).is_empty():
			break
		_tidy(c)
		main.run_to_stop()
	var offer: Dictionary = {}
	for o in f["offers"]:
		if not bool(o["mismatch"]):
			offer = o
	main.act("accept", str(offer["id"]))
	main.act("camp", str(f["id"]))
	main.act("startcamp")
	for i in 60:
		if Bouts.weigh_in_today(c, f):
			break
		_tidy(c)
		main.run_to_stop()
	print("HEAD_REACT drive: offer %s, day %d, weigh-in %s" % [str(offer.get("id", "")), int(c.day), str(Bouts.weigh_in_today(c, f))])
	main.act("weighin", str(f["id"]))
	main.act("doWeigh")
	main.run_to_stop()
	print("HEAD_REACT drive: after weigh-in, day %d, fighting %s" % [int(c.day), str(Bouts.fighting_today(c).get("name", ""))])
	main.act("fightnight")
	await _wait(4)
	if main.modal.is_empty() or str(main.modal.get("type", "")) != "fight":
		print("HEAD_REACT_FAIL no fight modal")
		return
	main.act("fightstep", "start")
	view = main._fight_layer.get_child(0) if main._fight_layer.get_child_count() > 0 else null
	await _wait(2)
	if view != null:
		for ch in view.get_children():
			if ch.has_method("cue_touch"):
				ch.finish()
	await _wait(2)
	print("HEAD_REACT start: %s vs %s, %d rounds" % [str(f["name"]), str(f["bout"]["opp"]["name"]), int(main.modal.get("total", 3))])


func _process(delta: float) -> bool:
	_clock += delta
	if main != null and (view == null or not is_instance_valid(view)):
		view = main._fight_layer.get_child(0) if main._fight_layer.get_child_count() > 0 else null
	if view == null:
		if _clock > 8.0:
			print("HEAD_REACT_FAIL no fight view after %.1f s: run with `-- show3d`" % _clock)
			return true
		return false
	if view != null and view.get("stage") != null and not _armed:
		_arm()
	if _armed and is_instance_valid(stage):
		_sample()
		_catch_landed()
		_catch_blocked()
		_advance_shots()
	_rounds()
	_drive()
	if _done():
		_report()
		return true
	return false


func _arm() -> void:
	stage = view.get("stage")
	if stage == null or (stage.boxers as Array).size() < 2:
		return
	for i in 2:
		var skel: Skeleton3D = stage.boxers[i]["skel"]
		var tap: SkeletonModifier3D = PoseTap.new()
		tap.setup(skel, TAP_BONES)
		skel.add_child(tap)
		taps.append(tap)
		(stage.boxers[i]["ap"] as AnimationPlayer).animation_started.connect(_on_started.bind(i))
	_armed = true
	print("HEAD_REACT armed: tracking head bones on both boxers")


func _on_started(clip: StringName, i: int) -> void:
	var s: Array = starts[i]
	s.append({"f": Engine.get_process_frames(), "t": _clock, "clip": str(clip)})
	if s.size() > 600:
		s.pop_front()


func _sample() -> void:
	var f := Engine.get_process_frames()
	for i in 2:
		var shown: Dictionary = (taps[i] as SkeletonModifier3D).shown
		if shown.is_empty():
			continue
		var xf: Transform3D = (stage.boxers[i]["skel"] as Skeleton3D).global_transform
		var e := {"f": f, "t": _clock}
		for b in TAP_BONES:
			if shown.has(b):
				e[b] = xf * (shown[b] as Vector3)
		var h: Array = history[i]
		h.append(e)
		if h.size() > KEEP_F:
			h.pop_front()


## Landed head punches from FightStage.hit_gaps (PunchRange.record at each contact).
func _catch_landed() -> void:
	for row in (stage.hit_gaps as Array):
		var d: Dictionary = row
		if d.has("_hrp"):
			continue
		d["_hrp"] = true
		var mv := str(d.get("move", ""))
		if mv.contains("body"):
			continue
		var hitter := _hitter(d)
		var rn := int(view.round_n) if view != null else 0
		counts[rn] = counts.get(rn, {"all": 0, "head": 0})
		counts[rn]["all"] = int(counts[rn]["all"]) + 1
		counts[rn]["head"] = int(counts[rn]["head"]) + 1
		if bool(d.get("cut", false)):
			_cuts.append({"t": _clock, "victim": 1 - hitter, "move": mv, "round": rn})
			continue
		var snap: Node = stage.boxers[1 - hitter].get("snap")
		var asked := float(snap.get("_last_deg")) if snap != null else 0.0
		var gain := float(snap.get("_gain")) if snap != null else -1.0
		shots.append({"f0": int(row["now_f"]), "victim": 1 - hitter, "move": mv,
			"pclip": str(row.get("clip", "")), "round": rn,
			"asked": asked, "gain": gain, "gap": float(d.get("gap", 0.0)),
			"done": false, "peak_turn": 0.0, "peak_travel": 0.0,
			"peak_t": -1.0, "t0": 0.0, "clip": "NONE", "played": false,
			"hold_s": -1.0, "max_frame": 0.0, "kind": "landed"})


## Blocked punches: a defence clip started within ATK_WITHIN_S of the other boxer's attack, no hit landed in its window.
func _catch_blocked() -> void:
	for i in 2:
		for st: Dictionary in (starts[i] as Array):
			var c := str(st["clip"])
			if not _is_defence(c):
				continue
			var key := "b%d_%d" % [i, int(st["f"])]
			if picked.has(key):
				continue
			picked[key] = true
			var other := 1 - i
			var attacked := false
			for st2: Dictionary in (starts[other] as Array):
				if _is_attack(str(st2["clip"])) and float(st2["t"]) >= float(st["t"]) - ATK_WITHIN_S and float(st2["t"]) <= float(st["t"]) + 0.1:
					attacked = true
					break
			if not attacked:
				continue
			var hit_landed := false
			for row in (stage.hit_gaps as Array):
				if absf(float(row.get("now_f", -999)) - float(st["f"])) <= BLK_WINDOW_S * 30:
					hit_landed = true
					break
			if hit_landed:
				continue
			var rn := int(view.round_n) if view != null else 0
			shots.append({"f0": int(st["f"]), "victim": i, "move": "blocked_head",
				"pclip": "", "round": rn,
				"asked": 0.0, "gain": 0.0, "gap": stage._gap() if is_instance_valid(stage) else 0.0,
				"done": false, "peak_turn": 0.0, "peak_travel": 0.0,
				"peak_t": -1.0, "t0": 0.0, "clip": c, "played": false,
				"hold_s": 0.0, "max_frame": 0.0, "kind": "blocked"})


func _is_attack(clip: String) -> bool:
	if clip == "": return false
	for prefix in ["pro_idle", "mc_idle", "pro_hit", "mc_hit", "react_", "pro_block", "pro_slip", "pro_weave", "pro_pull", "pro_advance", "pro_retreat", "pro_strafe"]:
		if clip.begins_with(prefix): return false
	return clip.begins_with("mc_") or clip.begins_with("pro_")

func _is_defence(clip: String) -> bool:
	return clip.begins_with("pro_block") or clip.begins_with("pro_slip") or clip.begins_with("pro_weave") or clip.begins_with("pro_pull")


func _hitter(row: Dictionary) -> int:
	var clip := str(row.get("clip", ""))
	var lf: Array = row.get("land_f", [])
	for i in 2:
		var pr: Node = stage.boxers[i].get("reach")
		if pr != null and clip != "" and str(pr.get("_clip")) == clip:
			return i
	for i in 2:
		if lf.size() == 3 and (stage.boxers[i].get("land_f", []) as Array) == lf:
			return i
	var arm := int(lf[0]) if lf.size() == 3 else int(row["now_f"]) - 10
	for i in 2:
		for e: Dictionary in (history[i] as Array):
			if int(e["f"]) >= arm and int(e["f"]) <= arm + 3 and str(e.get("clip", "")) == clip:
				return i
	return 0
func _nearest(who: int, f: int) -> Dictionary:
	var best: Dictionary = {}
	for e: Dictionary in (history[who] as Array):
		if int(e["f"]) <= f:
			best = e
		else:
			break
	if best.is_empty() and not (history[who] as Array).is_empty():
		best = (history[who] as Array)[0]
	return best
func _head_turn(base: Dictionary, e: Dictionary) -> float:
	var v0: Vector3 = (base["Head"] as Vector3) - (base["Chest"] as Vector3)
	var v1: Vector3 = (e["Head"] as Vector3) - (e["Chest"] as Vector3)
	if v0.length() < 1e-4 or v1.length() < 1e-4:
		return 0.0
	return rad_to_deg(v0.normalized().angle_to(v1.normalized()))
func _head_travel(base: Dictionary, e: Dictionary) -> float:
	if not base.has("Head") or not e.has("Head"):
		return 0.0
	return (base["Head"] as Vector3).distance_to(e["Head"] as Vector3)


func _max_frame_rot(r: Dictionary, base: Dictionary) -> float:
	var who := int(r["victim"])
	var t0 := float(r["t0"])
	var best := 0.0
	for e: Dictionary in (history[who] as Array):
		var t := float(e["t"])
		if t > t0 + 0.0001 and t <= t0 + WIN_S + 0.001:
			best = maxf(best, _head_turn(base, e))
	return best
func _advance_shots() -> void:
	for r in shots:
		if bool(r["done"]):
			continue
		var who := int(r["victim"])
		var base: Dictionary = _nearest(who, int(r["f0"]))
		if base.is_empty():
			continue
		var t0 := float(base["t"])
		r["t0"] = t0 if float(r["t0"]) <= 0.0 else float(r["t0"])
		var t_end := t0 + WIN_S
		for r2 in shots:
			if r2 == r:
				continue
			if int(r2["victim"]) != who:
				continue
			var b2 := _nearest(who, int(r2["f0"]))
			if not b2.is_empty() and float(b2["t"]) > t0 + 0.001:
				t_end = minf(t_end, float(b2["t"]))
		var last_t := t0
		for e: Dictionary in (history[who] as Array):
			var t := float(e["t"])
			if t <= t0 + 0.0001:
				continue
			if t > t_end + 0.001:
				break
			last_t = t
			var turn := _head_turn(base, e)
			var travel := _head_travel(base, e)
			if turn > float(r["peak_turn"]):
				r["peak_turn"] = turn
				r["peak_t"] = t
			r["peak_travel"] = maxf(float(r["peak_travel"]), travel)
		if last_t >= t_end - 0.001 or _clock >= t0 + WIN_S + 0.5 or t_end <= t0:
			_finish_shot(r)


func _finish_shot(r: Dictionary) -> void:
	r["done"] = true
	var who := int(r["victim"])
	var f0 := int(r["f0"])
	for st: Dictionary in (starts[who] as Array):
		var f := int(st["f"])
		if f < f0 or f > f0 + START_WIN_F:
			continue
		var c := str(st["clip"])
		var react: bool = c.begins_with("pro_hit_by_") or c.begins_with("mc_hit_") or c.begins_with("react_")
		if not react and str(r["clip"]) != "NONE":
			continue
		r["clip"] = c
		if react:
			break
	var c2 := str(r["clip"])
	r["played"] = c2.begins_with("pro_hit_by_") or c2.begins_with("mc_hit_") or c2.begins_with("react_")
	if is_instance_valid(stage) and float(r["gain"]) < 0.0:
		var hs: Node = stage.boxers[who].get("snap")
		if hs != null:
			r["gain"] = float(hs.get("_gain"))
			if float(r["asked"]) <= 0.0:
				r["asked"] = float(hs.get("_last_deg"))
	var base := _nearest(who, f0)
	if not base.is_empty():
		r["max_frame"] = _max_frame_rot(r, base)
	if float(r["peak_t"]) > 0.0:
		var fps := 30.0
		r["hold_s"] = (float(r["peak_t"]) - float(r["t0"])) if float(r["peak_t"]) > float(r["t0"]) else 0.0


func _rounds() -> void:
	if view == null or not is_instance_valid(view):
		return
	if bool(view.playing):
		_playing_round = int(view.round_n)
	elif _playing_round > 0:
		_rounds_done = maxi(_rounds_done, _playing_round)
		_bout_over = _bout_over or str(view.get("_stop")) != ""
		_playing_round = 0


func _drive() -> void:
	if view == null or not is_instance_valid(view) or not view.is_inside_tree():
		return
	var bar: Node = view.get("_shouting")
	if bar != null and is_instance_valid(bar):
		if not picked.has(bar.get_instance_id()):
			picked[bar.get_instance_id()] = true
			if bar.has_method("_set_aim"):
				bar.call("_set_aim", "body")
			bar.call("_pick", "body" if bar.find_child("Shout_body", true, false) != null else "")
		return
	if bool(view.playing):
		return
	for ch in view.get_children():
		if not ch.has_method("cue_walk_out"):
			continue
		if picked.has(ch.get_instance_id()):
			return
		var ui: Node = ch.get("ui")
		var card: Node = ui.get("_card") if ui != null else null
		if card == null or not bool(card.get("visible")):
			return
		picked[ch.get_instance_id()] = true
		ch.call("_pick", "body")
		ch.call("finish")


func _done() -> bool:
	if _clock < 750.0 and _rounds_done < ROUNDS and not _bout_over:
		return false
	for r in shots:
		if not bool(r["done"]):
			return false
	return true


func _report() -> void:
	for c in _cuts:
		print("HEAD_REACT_NOT_SHOWN r%d t=%6.2f v%d %s: cut off before contact" % [int(c["round"]), float(c["t"]), int(c["victim"]), str(c["move"])])
	var landed: Array = []
	var blocked: Array = []
	for r in shots:
		if str(r["kind"]) == "landed":
			landed.append(r)
		else:
			blocked.append(r)
	var n_l := landed.size()
	var n_b := blocked.size()
	var l_turns: Array = []
	var l_travels: Array = []
	var l_peaks: Array = []
	var l_max_frames: Array = []
	var l_asked_list: Array = []
	for r in landed:
		l_turns.append(float(r["peak_turn"]))
		l_travels.append(float(r["peak_travel"]))
		if float(r["peak_t"]) > 0.0:
			l_peaks.append(float(r["peak_t"]) - float(r["t0"]))
		l_max_frames.append(float(r["max_frame"]))
		if float(r["asked"]) > 0.0:
			l_asked_list.append(float(r["asked"]))
	var b_turns: Array = []
	var b_travels: Array = []
	for r in blocked:
		b_turns.append(float(r["peak_turn"]))
		b_travels.append(float(r["peak_travel"]))
	var lt_med := _median(l_turns)
	var lv_med := _median(l_travels)
	var bt_med := _median(b_turns)
	var bv_med := _median(b_travels)
	var rt := lt_med / maxf(bt_med, 0.01)
	var rv := lv_med / maxf(bv_med, 0.01)
	for rn in counts:
		print("  round %d: %d landed, %d head" % [int(rn), int(counts[rn]["all"]), int(counts[rn]["head"])])
	for r in shots:
		_print_shot(r)
	var voided := n_l < SHOTS_MIN
	var turn_ok := not voided and lt_med >= 15.0
	var ratio_ok := not voided and rt >= 2.5
	var travel_ok := not voided and lv_med >= 0.04
	var blk_ok := bt_med <= 6.0
	var peak_ok := true
	for p in l_peaks:
		if p > 0.08:
			peak_ok = false
			break
	var frame_ok := true
	for m in l_max_frames:
		if m > 30.0:
			frame_ok = false
			break
	print("HEAD_REACT landed n=%d turn_med=%.1f travel_med=%.3f | blocked n=%d turn_med=%.1f travel_med=%.3f | ratio_turn=%.1f ratio_travel=%.1f" % [n_l, lt_med, lv_med, n_b, bt_med, bv_med, rt, rv])
	print("HEAD_REACT bars: turn>=15:%s ratio>=2.5:%s travel>=0.04:%s blk_turn<=6:%s peak<=0.08s:%s frame<=30:%s" % [
		"ok" if turn_ok else "FAIL", "ok" if ratio_ok else "FAIL", "ok" if travel_ok else "FAIL",
		"ok" if blk_ok else "FAIL", "ok" if peak_ok else "FAIL", "ok" if frame_ok else "FAIL"])
	if not l_asked_list.is_empty():
		var asked_sorted := l_asked_list.duplicate(); asked_sorted.sort()
		var a_min := float(asked_sorted[0]); var a_max := float(asked_sorted[-1])
		print("HEAD_REACT asked: min=%.1f med=%.1f max=%.1f" % [a_min, _median(l_asked_list), a_max])
	print("HEAD_REACT %s" % ["VOID (%d landed, %d needed)" % [n_l, SHOTS_MIN] if voided else ("PASS" if turn_ok and ratio_ok and travel_ok and blk_ok and peak_ok and frame_ok else "FAIL")])


func _print_shot(r: Dictionary) -> void:
	var kind := str(r["kind"])
	var peak_dt := float(r["peak_t"]) - float(r["t0"]) if float(r["peak_t"]) > 0.0 else -1.0
	print("HEAD_REACT %s r%d t=%6.2f v%d %s (punch %s) react=%s | turn=%.1fdeg travel=%.3fm peak@%.2fs asked=%.1fdeg gap=%.2fm max_frame=%.1fdeg | %s" % [
		kind, int(r["round"]), float(r["t0"]), int(r["victim"]), str(r["move"]), str(r["pclip"]),
		str(r["clip"]) if bool(r["played"]) else "NONE",
		float(r["peak_turn"]), float(r["peak_travel"]),
		peak_dt if peak_dt >= 0.0 else -1.0,
		float(r["asked"]), float(r["gap"]), float(r["max_frame"]),
		"ok" if float(r["peak_turn"]) >= 15.0 else "weak"])


func _median(a: Array) -> float:
	if a.is_empty():
		return 0.0
	var s := a.duplicate()
	s.sort()
	var m := s.size() / 2
	return float(s[m]) if s.size() % 2 == 1 else (float(s[m - 1]) + float(s[m])) * 0.5
func _tidy(c: Career) -> void:
	if c.review_pending:
		main.act("review")
		main.act("close")
	for f in c.fighters:
		if bool(f["goal_talk"]):
			main.act("goaltalk", f["id"])
			main.act("pickgoal", "five_round_engine")
			main.act("setgoal")


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame
