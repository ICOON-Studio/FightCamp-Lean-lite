extends SceneTree
## POWER1 step 4 (owner S439: "the uppercut i think it aims too short, check it again an opponent how close the have to be
## to connect"; ops/research/UPPERCUT_RANGE_S439.md: every punch was thrown from one 0.93 m spacing, so jabs and crosses
## landed with the elbow folded (median 76 deg) and uppercuts with the arm locked straight (165 deg)). The ruler, in the
## PLAYED fight (the real game to fight night, FightView's own beats, the whole stage at 60 frames a second), seeded so the
## same bout plays on every run. On every landed punch the hit is shown on (HitImpact.hit, PunchRange.record), read on the
## frame as drawn:
##   ELBOW  the punching arm's elbow (180 = straight) in its band: straights (jab, cross) 140-175, hooks 80-120,
##          uppercuts 80-125 (body shots have no band).
##   MISS   a clean hit's glove front within 0.08 m of the point its reach latched on her at the contact (her face; her chin
##          for an uppercut once step 4 aims there); a hit shown as a graze is not clean.
##   CORR   the glove as drawn no more than 0.30 m from the clip's own glove on the hit frame (a shipped game's cap).
## And every drawn frame outside a clinch:
##   HEADS  the two heads at least 0.45 m apart (each dip under it is one failure).
##   TOES   the lead toes never cross each other on the line between them (each crossing is one failure).
## `mix` (on unless mix=0): uppercuts and right hooks are rare in a plain bout (one landed uppercut in the S439 bout), so
## of the landed jabs, crosses and lead hooks not yet thrown, every fifth goes to a lead uppercut, a rear uppercut and a
## right hook in turn (moves the fight's own RoundStyle throws). The 3D fight only: nothing is decided here.
## Real pictures only - run it windowed on the never-shown desktop (through godot_slot):
##   python tools/hidden_desktop.py run --timeout=900 <godot.exe> --path . --windowed --resolution 960x540 --audio-driver Dummy \
##       --fixed-fps 60 --script res://tests/punch_range_test.gd -- [seed=4242] [secs=200] [mix=0] [<control flags>]
## Prints PUNCH_RANGE lines and PUNCH_RANGE failures=<n>.

const Bouts := preload("res://scripts/state/Bouts.gd")
const RangeTable := preload("res://scripts/fight3d/RangeTable.gd")
const BANDS := {"straight": Vector2(140.0, 175.0), "hook": Vector2(80.0, 120.0), "uppercut": Vector2(80.0, 125.0)}
const MISS_M := 0.08
const CORR_M := 0.30
const HEADS_M := 0.45
const MIX := ["", "", "lead_uppercut", "rear_uppercut", "rear_hook"]

var main: Node
var view: Node
var stage: Node3D
var secs := 200.0
var mix := true
var failures := 0
var seen := 0
var pending: Array = []
var rows: Array = []
var mix_n := 0
var picked := {}
var _clock := 0.0
var _go := false
var _heads_low := false
var _toes_x := false
var heads_min := 9.0
var heads_dips := 0
var toe_cross := 0
var frames := 0
var hist: Array = [{}, {}]
var last: Array = [{}, {}]
var watched_f := -1
var close_frames := 0
var close_heads := 9.0
var close_toes := 0
const DRAWN := ["LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand", "Head", "Hips", "Chest",
	"LeftToes", "RightToes"]


func _initialize() -> void:
	var sd := 4242
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("seed="):
			sd = int(s.get_slice("=", 1))
		elif s.begins_with("secs="):
			secs = float(s.get_slice("=", 1))
		elif s == "mix=0":
			mix = false
	seed(sd)
	print("PUNCH_RANGE seed %d mix %s args %s" % [sd, mix, OS.get_cmdline_user_args()])
	root.size = Vector2i(960, 540)
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
	main.act("weighin", str(f["id"]))
	main.act("doWeigh")
	main.run_to_stop()
	main.act("fightnight")
	await _wait(4)
	if main.modal.is_empty() or str(main.modal.get("type", "")) != "fight":
		print("PUNCH_RANGE failures=1 (no fight modal)")
		quit(1)
		return
	main.act("fightstep", "start")
	await _wait(2)
	view = main._fight_layer.get_child(0) if main._fight_layer.get_child_count() > 0 else null
	if view != null:
		for ch in view.get_children():
			if ch.has_method("cue_touch"):
				ch.finish()
	print("PUNCH_RANGE bout: %s vs %s" % [str(f["name"]), str(f["bout"]["opp"]["name"])])
	_go = true


func _process(delta: float) -> bool:
	if not _go:
		return false
	_clock += delta
	if view == null or not is_instance_valid(view):
		view = main._fight_layer.get_child(0) if main._fight_layer.get_child_count() > 0 else null
		if _clock > secs:
			_finish()
			return true
		return false
	if stage == null:
		stage = view.get("stage")
		if stage == null:
			return false
		seen = (stage.hit_gaps as Array).size()
		for i in 2:
			(stage.boxers[i]["skel"] as Skeleton3D).skeleton_updated.connect(_drawn.bind(i))
	_drive()
	if mix:
		_mix()
	_measure()
	_watch_bodies()
	if _clock > secs:
		_finish()
		return true
	return false


## Of the landed jabs, crosses and lead hooks not yet fired, every fifth goes to MIX's moves in turn (see the header).
func _mix() -> void:
	var beats: Array = view.beats
	for i in range(int(view.next), beats.size()):
		var b: Dictionary = beats[i]
		if b.has("_pr_mix"):
			continue
		b["_pr_mix"] = true
		if str(b.get("move", "")) in ["jab", "cross", "lead_hook"] and str(b.get("result", "")) == "lands" and not bool(b.get("big", false)):
			var to := str(MIX[mix_n % MIX.size()])
			mix_n += 1
			if to != "":
				b["move"] = to
				b.erase("tell")


## A landed contact written last frame (HitImpact.hit -> PunchRange.record): read the frame as it was drawn.
func _measure() -> void:
	var gaps: Array = stage.hit_gaps
	while seen < gaps.size():
		pending.append(gaps[seen])
		seen += 1
	var later: Array = []
	for g in pending:
		if Engine.get_process_frames() <= int(g.get("now_f", 0)):
			later.append(g)
			continue
		if not bool(g.get("cut", false)):
			_row(g)
	pending = later


func _row(g: Dictionary) -> void:
	var who := int(g.get("hitter", -1))
	if who < 0:
		return
	var pr: Node = stage.boxers[who].get("reach")
	var clip := str(g.get("clip", ""))
	if pr == null or str(pr.get("_hand")) == "" or str(pr.get("_clip")) != clip:
		print("PUNCH_RANGE skip %s (the reach moved on before the frame was read)" % clip)
		return
	# The hit frame AS DRAWN (Skeleton3D.skeleton_updated, after every modifier): read from _process, the skeleton gives the
	# clip's pose without the stack (the reach, the weight, the head clearance).
	var d: Dictionary = (hist[who] as Dictionary).get(int(g.get("now_f", -1)), {})
	if d.is_empty():
		print("PUNCH_RANGE skip %s (its hit frame %d was not drawn: %s, now %d)" % [clip, int(g.get("now_f", -1)), str((hist[who] as Dictionary).keys()), Engine.get_process_frames()])
		return
	var hand := str(pr.get("_hand"))
	var side := hand.trim_suffix("Hand")
	var sh: Vector3 = d[side + "UpperArm"]
	var el: Vector3 = d[side + "LowerArm"]
	var wr: Vector3 = d[hand]
	var elbow := rad_to_deg((sh - el).angle_to(wr - el))
	var glove: Vector3 = d["glove_" + side]
	var aim: Vector3 = pr.get("hit_face") if pr.get("hit_face") != null else pr.get("_hit_w")
	# The clip's own glove on the drawn hit frame: the arm before the reach solved it, on the stack's last solve of that frame
	# (PunchReach -> ReachLimit, both arms).
	var clip_g: Vector3 = d.get("cg_w", Vector3.INF)
	var miss := glove.distance_to(aim) if aim.is_finite() else -1.0
	var corr := clip_g.distance_to(glove) if clip_g.is_finite() else -1.0
	var kind := "uppercut" if clip.contains("uppercut") else ("hook" if clip.contains("hook") and not clip.contains("body") else (
		"straight" if clip.contains("jab") or clip.contains("cross") else "body"))
	var graze := bool(g.get("graze", false))
	var why := PackedStringArray()
	if BANDS.has(kind):
		var band: Vector2 = BANDS[kind]
		if elbow < band.x or elbow > band.y:
			why.append("ELBOW %.0f not in %.0f-%.0f" % [elbow, band.x, band.y])
	if graze:
		why.append("GRAZE %.3f m off: a landed punch shown as a touch" % miss)
	elif miss < 0.0 or miss > MISS_M:
		why.append("MISS %.3f m > %.2f" % [miss, MISS_M])
	var od: Dictionary = (hist[1 - who] as Dictionary).get(int(g.get("now_f", -1)), {})
	var heads := (d["Head"] as Vector3).distance_to(od["Head"]) if not od.is_empty() else -1.0
	if heads >= 0.0 and heads < HEADS_M and not str(g.get("phase", "")) == "clinch":
		why.append("HEADS %.3f m at the hit" % heads)
	if corr > CORR_M:
		why.append("CORR %.3f m > %.2f" % [corr, CORR_M])
	failures += why.size()
	rows.append({"kind": kind, "clip": clip, "elbow": elbow, "miss": miss, "corr": corr, "gap": float(g.get("gap", 0.0)), "heads": heads,
		"phase": str(g.get("phase", "")), "graze": graze, "bad": why.size()})
	var own := float((stage.boxers[who].get("ranges", {}) as Dictionary).get(clip, -1.0))
	if aim.is_finite():
		_probe(who, clip, kind, sh, el, wr, glove, aim, pr, d, (hist[1 - who] as Dictionary).get(int(g.get("now_f", -1)), {}))
	print("PUNCH_RANGE hit %s %s by %d phase %s gap %.3f shown %.3f want at the hit %.3f own %.3f elbow %.0f miss %.3f corr %.3f%s %s" % [kind,
		clip, who, str(g.get("phase", "")), float(g.get("gap", 0.0)), float(stage._gap_shown()), float(g.get("want", -1.0)), own, elbow, miss, corr, " graze" if graze else "", ("FAIL " + "; ".join(why)) if not why.is_empty() else "ok"])


## The probe behind the ELBOW column: the live arm on the hit frame against RangeTable's model of it (both in metres,
## along the line from her body to the other's). live_need = the body-to-body distance at which THIS arm, as it stands now,
## would meet the point with the elbow at its band's middle; model = RangeTable's distance for the clip. A gap between them
## says which part of the model is off: her shoulder (s_fwd), the point on the other (face_fwd), the side or height offsets.
func _probe(who: int, clip: String, kind: String, sh: Vector3, el: Vector3, wr: Vector3, glove: Vector3, aim: Vector3, pr: Node, d: Dictionary, od: Dictionary) -> void:
	if od.is_empty():
		return
	var hn: Vector3 = d["node"]
	var on: Vector3 = od["node"]
	var dir := Vector3(on.x - hn.x, 0.0, on.z - hn.z)
	var ng := dir.length()
	dir = dir.normalized()
	var lat := dir.cross(Vector3.UP)
	var s_fwd := (sh - hn).dot(dir)
	var f_fwd := (aim - on).dot(-dir)
	var side := (aim - sh).dot(lat)
	var up := aim.y - sh.y
	var front := float(pr.get("_front")) * float(stage._scale(who))
	var r := RangeTable.glove_reach(sh.distance_to(el), el.distance_to(wr), front, kind)
	var need := s_fwd + sqrt(maxf(r * r - side * side - up * up, 0.0025)) + f_fwd
	var m: Dictionary = (stage.boxers[who].get("range_parts", {}) as Dictionary).get(clip, {})
	var mdz := sqrt(maxf(float(m.get("reach", 0.0)) ** 2 - float(m.get("side", 0.0)) ** 2 - float(m.get("up", 0.0)) ** 2, 0.0025))
	var pw: Node = stage.boxers[who].get("weight")
	print("PUNCH_RANGE probe %s %s | node gap %.3f live_need %.3f | s_fwd live %.3f model %.3f (hips %.3f carry %.3f) | face_fwd live %.3f model %.3f | side live %.3f model %.3f | up live %.3f model %.3f | reach live %.3f model %.3f | depth live %.3f model %.3f | lunge %.3f (lunge_m %.3f table now %.3f carry %.3f) glove-shoulder %.3f" % [
		kind, clip, ng, need, s_fwd, float(m.get("s_fwd", -9.0)), float(m.get("fwd", 0.0)), float(m.get("carry", 0.0)), f_fwd,
		float(m.get("face_fwd", -9.0)), side, float(m.get("side", -9.0)), up, float(m.get("up", -9.0)), r, float(m.get("reach", -9.0)),
		sqrt(maxf(r * r - side * side - up * up, 0.0025)), mdz, float(pr.call("lunge")), float(pr.get("lunge_m")),
		RangeTable.clip_m(stage, who, clip), float(pw.get("carry_now")) if pw != null else -1.0,
		glove.distance_to(sh)])
	var cg: Vector3 = (stage.boxers[who]["skel"] as Skeleton3D).global_transform * (pr.get_meta("cg", Vector3.INF) as Vector3) if pr.has_meta("cg") else Vector3.INF
	print("PUNCH_RANGE probe3 glove to the cap's centre %.3f | cap centre now to the hit frame's %.3f | glove to hit_face %.3f | _hit_w to hit_face %.3f | hit_s %s" % [
		glove.distance_to(cg) if cg.is_finite() else -1.0, cg.distance_to(d.get("cg_w", Vector3.INF)) if cg.is_finite() else -1.0, glove.distance_to(aim),
		(pr.get("_hit_w") as Vector3).distance_to(aim) if (pr.get("_hit_w") as Vector3).is_finite() else -1.0, str(pr.get("hit_s"))])
	print("PUNCH_RANGE probe2 other head fwd %.3f | other hips fwd %.3f | other clip %s | her hips fwd %.3f chest fwd %.3f" % [
		(od["Head"] - on).dot(-dir), (od["Hips"] - on).dot(-dir), _anim(1 - who), (d["Hips"] - hn).dot(dir), (d["Chest"] - hn).dot(dir)])


## Every drawn frame outside a clinch: the heads and the lead toes.
func _watch_bodies() -> void:
	if str(stage.feet.phase()) == "clinch":
		_heads_low = false
		_toes_x = false
		return
	var a: Dictionary = last[0]
	var b: Dictionary = last[1]
	if a.is_empty() or b.is_empty() or int(a["f"]) == watched_f:
		return
	watched_f = int(a["f"])
	frames += 1
	var h0: Vector3 = a["Head"]
	var h1: Vector3 = b["Head"]
	var hd := h0.distance_to(h1)
	heads_min = minf(heads_min, hd)
	var gp := float(stage._gap())
	if gp >= 0.70 and gp <= 0.74:   # the uppercut's floor (UpperRoom): how the bodies stand there
		close_frames += 1
		close_heads = minf(close_heads, hd)
	if hd < HEADS_M and not _heads_low:
		heads_dips += 1
		failures += 1
		print("PUNCH_RANGE FAIL HEADS %.3f m at t %.2f (phase %s, gap %.3f, clips %s / %s)" % [hd, float(view.t), stage.feet.phase(),
			float(stage._gap()), _anim(0), _anim(1)])
	_heads_low = hd < HEADS_M
	var p0: Vector3 = stage.boxers[0]["pos"]
	var p1: Vector3 = stage.boxers[1]["pos"]
	var axis := Vector3(p1.x - p0.x, 0.0, p1.z - p0.z)
	if axis.length() < 0.01:
		return
	axis = axis.normalized()
	var t0: float = (a["lead_toes"] - p0).dot(axis)
	var t1: float = (b["lead_toes"] - p0).dot(axis)
	var crossed := t0 >= t1
	if crossed and not _toes_x:
		toe_cross += 1
		failures += 1
		if gp >= 0.70 and gp <= 0.74:
			close_toes += 1
		print("PUNCH_RANGE FAIL TOES crossed by %.3f m at t %.2f (phase %s, gap %.3f, clips %s / %s)" % [t0 - t1, float(view.t),
			stage.feet.phase(), float(stage._gap()), _anim(0), _anim(1)])
	_toes_x = crossed


## Boxer i's skeleton as drawn this frame (Skeleton3D.skeleton_updated: after every modifier), kept a few frames by frame.
func _drawn(i: int) -> void:
	var skel: Skeleton3D = stage.boxers[i]["skel"]
	var f := Engine.get_process_frames()
	var d := {"f": f, "node": (stage.boxers[i]["node"] as Node3D).global_position}
	for n in DRAWN:
		d[n] = _bone(skel, str(n))
	d["lead_toes"] = d[str(stage.hand_of(i, "LeftHand")).trim_suffix("Hand") + "Toes"]
	for side in ["Left", "Right"]:
		d["glove_" + side] = stage.glove_front(i, side + "Hand")   # Gloves follow the skeleton on this same signal, first
	var pr: Node = stage.boxers[i].get("reach")
	if pr != null and pr.has_meta("cg_w"):
		d["cg_w"] = pr.get_meta("cg_w")
	var h: Dictionary = hist[i]
	h[f] = d
	h.erase(f - 6)
	last[i] = d


func _anim(i: int) -> String:
	return str((stage.boxers[i]["ap"] as AnimationPlayer).current_animation)


func _bone(skel: Skeleton3D, name: String) -> Vector3:
	return skel.global_transform * skel.get_bone_global_pose(skel.find_bone(name)).origin


func _finish() -> void:
	for kind in ["straight", "hook", "uppercut", "body"]:
		var rs := rows.filter(func(r): return str(r["kind"]) == kind)
		if rs.is_empty():
			print("PUNCH_RANGE %s: none landed" % kind)
			continue
		var el: Array = rs.map(func(r): return float(r["elbow"]))
		var ms: Array = rs.filter(func(r): return float(r["miss"]) >= 0.0).map(func(r): return float(r["miss"]))
		var cs: Array = rs.filter(func(r): return float(r["corr"]) >= 0.0).map(func(r): return float(r["corr"]))
		var gp: Array = rs.map(func(r): return float(r["gap"]))
		var inb := rs.filter(func(r): return not BANDS.has(kind) or (float(r["elbow"]) >= (BANDS[kind] as Vector2).x and float(r["elbow"]) <= (BANDS[kind] as Vector2).y)).size()
		print("PUNCH_RANGE %s: %d landed, elbow median %.0f (%.0f-%.0f), in band %d of %d | miss median %.3f max %.3f | corr max %.3f | gap median %.3f (%.3f-%.3f) | grazes %d | heads at the hit closest %.3f" % [
			kind, rs.size(), _med(el), _lo(el), _hi(el), inb, rs.size(), _med(ms), _hi(ms), _hi(cs), _med(gp), _lo(gp), _hi(gp),
			rs.filter(func(r): return bool(r["graze"])).size(), _lo(rs.filter(func(r): return float(r["heads"]) >= 0.0).map(func(r): return float(r["heads"])))])
	print("PUNCH_RANGE bodies: %d frames outside clinches, heads closest %.3f m, dips under %.2f: %d, lead toes crossed: %d" % [
		frames, heads_min, HEADS_M, heads_dips, toe_cross])
	print("PUNCH_RANGE at the uppercut floor (gap 0.70-0.74 m): %d frames, heads closest %.3f m, lead toes crossed %d" % [close_frames,
		close_heads, close_toes])
	for i in 2:
		print("PUNCH_RANGE live %d: %s" % [i, str(stage.boxers[i].get("live", {}))])
	print("PUNCH_RANGE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _med(a: Array) -> float:
	if a.is_empty():
		return -1.0
	var s := a.duplicate()
	s.sort()
	return float(s[s.size() / 2])


func _lo(a: Array) -> float:
	return float(a.min()) if not a.is_empty() else -1.0


func _hi(a: Array) -> float:
	return float(a.max()) if not a.is_empty() else -1.0


## The corner's shout bar and the corner minute: picked as a player would, so the rounds run on.
func _drive() -> void:
	if bool(view.playing):   # S459 FIGHTSEAM1: no shout bar; the body call armed whenever the bar offers it, as picked before
		view.set_meta("armed", "body" if view.find_child("Call_body", true, false) != null else "")
	if bool(view.playing):
		return
	for ch in view.get_children():
		if not ch.has_method("cue_walk_out") or picked.has(ch.get_instance_id()):
			continue
		var ui: Node = ch.get("ui")
		var card: Node = ui.get("_card") if ui != null else null
		if card == null or not bool(card.get("visible")):
			return
		picked[ch.get_instance_id()] = true
		ch.call("_pick", "body")
		ch.call("finish")


func _tidy(c: Career) -> void:
	if c.review_pending:
		main.act("review")
		main.act("close")
	for f in c.fighters:
		if bool(f["goal_talk"]):
			main.act("goaltalk", f["id"])
			main.act("pickgoal", "five_round_engine")
			main.act("setgoal")


func _wait(n: int) -> void:
	for k in n:
		await process_frame
