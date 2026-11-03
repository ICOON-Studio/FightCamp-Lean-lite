extends SceneTree
## S370 BODYREACT1 probe (operator S369: "hits on body still no reaction from the other fighter"): three LIVE rounds
## of fight night, the tools/fight3d_play.gd flow (fresh career -> fight night -> Begin fight, the shout bar answered
## every exchange, the corner minute between rounds), measuring every LANDED body shot on the bodies as SHOWN: the
## reaction clip the woman who took it played (AnimationPlayer.animation_started), her trunk curl in degrees at its
## deepest (hips->chest axis vs its pose at the contact), the time from contact to the first visible move (trunk >= 2 deg
## or a bone >= 3 cm), how long the fold stayed on her (first frame the trunk passes 9 deg, half the bar, to the last)
## and her hips' backward travel (m). Contacts = FightStage.hit_gaps (PunchRange.record inside HitImpact.hit); a punch
## cut off before its contact showed neither punch nor reaction: BODYREACT_NOT_SHOWN reports it, unscored (tools/
## hit_gap_probe.gd reads a cut punch the same way). The shout bar's AIM is the body every exchange. Bars (NEVER
## loosened): every SHOWN body shot reacts (none = 0), curl >= 18 deg, first move <= 0.15 s (G147), held >= 0.35 s;
## fewer than 6 = VOID. (The per-reaction-clip trunk scratch - kidney 4.7/12.7 deg against gutshot_v3's 16.0/28.4 -
## was not committed; docs/ziva/BODYREACT1_result.md holds its numbers.)
##   <godot.exe> --headless --audio-driver Dummy --path . --fixed-fps 30 --script res://tools/body_react_probe.gd -- show3d
## `-- film` (windowed on the hidden desktop under --write-movie) plays round 1 only (2x), stops at its bell: the film.

const Bouts := preload("res://scripts/state/Bouts.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")
const HitSnap := preload("res://scripts/fight3d/HitSnap.gd")
const PoseTap := preload("res://tools/pose_tap.gd")

const W := 1280
const H := 720
const ROUNDS := 3
const SHOTS_MIN := 6
const CURL_MIN_DEG := 18.0
const FIRST_MAX_S := 0.15
const HELD_MIN_S := 0.35
const HELD_AT_DEG := 9.0       # still visibly folded: half the curl bar
const VIS_M := 0.03            # a bone has visibly moved
const VIS_DEG := 2.0           # or the trunk has
const WIN_S := 1.4             # measured window after the contact (hit fold life ~1.3 s)
const START_WIN_F := 4         # the reaction's animation_started lands within this many frames of the contact
const KEEP_F := 150            # pose history per boxer (5 s)
const TAP_BONES := ["Head", "Chest", "Spine", "Hips", "LeftHand", "RightHand"]

var main: Node
var view: Node
var stage: Node3D
var taps: Array = []
var history: Array = [[], []]   # per boxer: {f, t, clip, Head, Chest, Spine, Hips, LeftHand, RightHand} (as shown)
var starts: Array = [[], []]    # per boxer: {f, clip} every animation_started
var shots: Array = []           # one record per landed body shot that SHOWED
var _cuts: Array = []           # landed body beats the game cut off before their contact (no hit, no reaction showed)
var picked := {}                # shout bars / corner minutes already answered (instance id)
var counts := {}                # round -> {all, body}
var _clock := 0.0
var _film := false
var _film_begin := -1
var _film_end := -1
var _film_sped := false
var _film_done := false
var _armed := false
var _playing_round := 0
var _rounds_done := 0
var _bout_over := false


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	_film = args.has("film")
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
	print("BODYREACT drive: offer %s, day %d, weigh-in today %s" % [str(offer.get("id", "")), int(c.day), str(Bouts.weigh_in_today(c, f))])
	main.act("weighin", str(f["id"]))
	main.act("doWeigh")
	main.run_to_stop()
	print("BODYREACT drive: after weigh-in, day %d, fighting today %s, weight %.1f" % [int(c.day), str(Bouts.fighting_today(c).get("name", "")), float(f.get("weight", 0.0))])
	main.act("fightnight")
	await _wait(4)
	if main.modal.is_empty() or str(main.modal.get("type", "")) != "fight":
		print("BODYREACT_FAIL no fight modal after fightnight: she is not fighting today")
		return
	main.act("fightstep", "start")
	view = main._fight_layer.get_child(0) if main._fight_layer.get_child_count() > 0 else null
	# S307: the intro plays first; skip it to the bell (tools/fight3d_play.gd does the same).
	await _wait(2)
	if view != null:
		for ch in view.get_children():
			if ch.has_method("cue_touch"):
				ch.finish()
	await _wait(2)
	print("BODYREACT check start: %s vs %s, %d rounds, film=%s" % [str(f["name"]), str(f["bout"]["opp"]["name"]), int(main.modal.get("total", 3)), str(_film)])


func _process(delta: float) -> bool:
	_clock += delta
	if main != null and (view == null or not is_instance_valid(view)):
		view = main._fight_layer.get_child(0) if main._fight_layer.get_child_count() > 0 else null
	if view == null:
		# S354: headless builds the fight view only when the 3D is enabled - without `show3d` there is nothing to measure.
		if _clock > 8.0:
			print("BODYREACT_FAIL no fight view after %.1f s: run with `-- show3d` (FightView.enabled)" % _clock)
			return true
		return false
	if view != null and view.get("stage") != null and not _armed:
		_arm()
	if _armed and is_instance_valid(stage):
		_sample()
		_catch_rows()
		_advance()
	_rounds()
	_drive()
	if _done():
		_report()
		return true
	return false


## The taps go last in each boxer's modifier stack: they record the pose the viewer is shown (tools/pose_tap.gd).
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
	print("BODYREACT armed: pose taps last in both stacks, listening for the victims' reaction clips")


func _on_started(clip: StringName, i: int) -> void:
	var s: Array = starts[i]
	s.append({"f": Engine.get_process_frames(), "clip": str(clip)})
	if s.size() > 600:
		s.pop_front()


func _sample() -> void:
	var f := Engine.get_process_frames()
	for i in 2:
		var shown: Dictionary = (taps[i] as SkeletonModifier3D).shown
		if shown.is_empty():
			continue
		var xf: Transform3D = (stage.boxers[i]["skel"] as Skeleton3D).global_transform
		var e := {"f": f, "t": _clock, "clip": str((stage.boxers[i]["ap"] as AnimationPlayer).assigned_animation)}
		for b in TAP_BONES:
			if shown.has(b):
				e[b] = xf * (shown[b] as Vector3)
		var h: Array = history[i]
		h.append(e)
		if h.size() > KEEP_F:
			h.pop_front()


## Every new landed contact the game recorded (FightStage.hit_gaps); body shots open a measurement.
func _catch_rows() -> void:
	for row in (stage.hit_gaps as Array):
		var d: Dictionary = row
		if d.has("_probe"):
			continue
		d["_probe"] = true
		var mv := str(d.get("move", ""))
		var body: bool = mv.contains("body") or str(d.get("clip", "")).contains("kidney")
		var rn := int(view.round_n) if view != null else 0
		counts[rn] = counts.get(rn, {"all": 0, "body": 0})
		counts[rn]["all"] = int(counts[rn]["all"]) + 1
		counts[rn]["body"] = int(counts[rn]["body"]) + (1 if body else 0)
		if body:
			var hitter := _hitter(d)
			var flier: String = _hitter_seq(d, hitter)
			if bool(d.get("cut", false)):
				_cuts.append({"t": _clock, "victim": 1 - hitter, "move": str(d["move"]), "round": rn, "hseq": flier})
			else:
				_open(d, hitter)


## Which boxer threw it: the armed punch's own reach first, then the land_f; the clip/speed are the rare fallback.
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
	# Her next beat can disarm the reach and re-arm land_f before this row is read; history still holds who played it.
	var arm := int(lf[0]) if lf.size() == 3 else int(row["now_f"]) - 10
	for i in 2:
		for e: Dictionary in (history[i] as Array):
			if int(e["f"]) >= arm and int(e["f"]) <= arm + 3 and str(e["clip"]) == clip:
				return i
	for i in 2:
		var ap: AnimationPlayer = stage.boxers[i]["ap"]
		if str(ap.assigned_animation) == clip and absf(ap.speed_scale - float(row.get("speed", 1.0))) < 0.01:
			return i
	return 0


func _open(row: Dictionary, hitter: int) -> void:
	# Backwards = along the line from the hitter to the victim at the contact: the hips' travel printed below.
	var hb := _nearest(hitter, int(row["now_f"]))
	var vb := _nearest(1 - hitter, int(row["now_f"]))
	var d0 := (vb["Hips"] as Vector3) - (hb["Hips"] as Vector3) if hb.has("Hips") and vb.has("Hips") else Vector3.ZERO
	var dir := Vector3(d0.x, 0.0, d0.z)
	dir = dir.normalized() if dir.length() > 1e-4 else Vector3.ZERO
	var snap: Node = stage.boxers[1 - hitter].get("snap")   # gain > 1.5 = HitImpact asked HitSnap for the fold (S370)
	var gain := float(snap.get("_gain")) if snap != null else -1.0
	shots.append({"f0": int(row["now_f"]), "victim": 1 - hitter, "move": str(row["move"]), "pclip": str(row.get("clip", "")),
		"round": int(view.round_n) if view != null else 0, "back_dir": dir, "held_from": -1.0, "held_to": -1.0,
		"done": false, "curl": 0.0, "first": -1.0, "held": 0.0, "hips_max": -99.0, "t0": 0.0, "t_deep": 0.0, "base": {}, "clip": "NONE", "played": false, "gain": gain})


## What the HITTER played between arming her punch and the hit's due contact: the clip that replaced a still-flying
## punch (her reach is disarmed by any new play on her own body - her next beat, or a reaction: she got hit first).
func _hitter_seq(row: Dictionary, hitter: int) -> String:
	var lf: Array = row.get("land_f", [])
	var from := int(lf[0]) if lf.size() == 3 else int(row["now_f"]) - 20
	var f0 := int(row["now_f"])
	var out: Array = []
	var last := ""
	for e: Dictionary in (history[hitter] as Array):
		if int(e["f"]) < from or int(e["f"]) > f0 or str(e["clip"]) == last:
			continue
		out.append("%s@%+df" % [str(e["clip"]), int(e["f"]) - f0])
		last = str(e["clip"])
	return ", ".join(out)


func _advance() -> void:
	for r in shots:
		if bool(r["done"]):
			continue
		var who: int = int(r["victim"])
		var base: Dictionary = r["base"]
		if base.is_empty():
			base = _nearest(who, int(r["f0"]))
			r["base"] = base
		if base.is_empty():
			continue
		var t0 := float(base["t"])
		r["t0"] = t0 if float(r["t0"]) <= 0.0 else float(r["t0"])
		var t_end := t0 + WIN_S
		for r2 in shots:   # the window stops where the victim's NEXT body shot lands (its fold is a new event)
			var b2 := _nearest(who, int(r2["f0"])) if r2 != r and int(r2["victim"]) == who else {}
			if not b2.is_empty() and float(b2["t"]) > t0 + 0.001:
				t_end = minf(t_end, float(b2["t"]))
		var last_t := t0
		for e: Dictionary in (history[who] as Array):
			var t := float(e["t"])
			if t <= t0 + 0.0001:
				continue
			if t > t_end + 0.0001:
				break
			last_t = t
			var curl := _curl(base, e)
			if curl > float(r["curl"]):
				r["curl"] = curl
				r["t_deep"] = t
			if float(r["first"]) < 0.0 and (curl >= VIS_DEG or _move(base, e) >= VIS_M):
				r["first"] = t - t0
			if curl >= HELD_AT_DEG:
				if float(r["held_from"]) < 0.0:
					r["held_from"] = t
				r["held_to"] = t
			r["held"] = maxf(0.0, float(r["held_to"]) - maxf(0.0, float(r["held_from"])))
			r["hips_max"] = maxf(float(r["hips_max"]), _back(r, base, e))
		if last_t >= t_end - 0.001 or _clock >= t0 + WIN_S + 0.5 or t_end <= t0:
			_finish_shot(r)


func _finish_shot(r: Dictionary) -> void:
	r["done"] = true
	var who: int = int(r["victim"])
	var f0 := int(r["f0"])
	for st: Dictionary in (starts[who] as Array):
		var f := int(st["f"])
		if f < f0 or f > f0 + START_WIN_F:
			continue
		var c := str(st["clip"])
		var react: bool = c.begins_with("pro_hit_by_") or c.begins_with("mc_hit_") or c.begins_with("react_")
		# A guard or fidget restart can land on the very same frame as the reaction: keep looking for the reaction.
		if not react and str(r["clip"]) != "NONE":
			continue
		r["clip"] = c
		if react:
			break
	var c2 := str(r["clip"])
	r["played"] = c2.begins_with("pro_hit_by_") or c2.begins_with("mc_hit_") or c2.begins_with("react_")
	if is_instance_valid(stage) and float(r["gain"]) < 0.0:   # the fold state, for the "asked vs shown" diagnostic
		var hs: Node = stage.boxers[who].get("snap")
		r["gain"] = float(hs.get("_gain")) if hs != null else -1.0


## The pose sample nearest to `f` (the contact frame) from the ring buffer; the oldest entry if none is that early.
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


## Degrees the trunk (hips -> chest) has turned off its pose at the contact.
func _curl(base: Dictionary, e: Dictionary) -> float:
	var a0: Vector3 = (base["Chest"] as Vector3) - (base["Hips"] as Vector3)
	var a1: Vector3 = (e["Chest"] as Vector3) - (e["Hips"] as Vector3)
	if a0.length() < 1e-4 or a1.length() < 1e-4:
		return 0.0
	return rad_to_deg(a0.normalized().angle_to(a1.normalized()))


## The furthest any watched bone has moved off its contact pose, metres.
func _move(base: Dictionary, e: Dictionary) -> float:
	var out := 0.0
	for b in TAP_BONES:
		if base.has(b) and e.has(b):
			out = maxf(out, (base[b] as Vector3).distance_to(e[b] as Vector3))
	return out


## The hips' travel along the contact's backwards direction (away from the hitter), metres.
func _back(r: Dictionary, base: Dictionary, e: Dictionary) -> float:
	var d: Vector3 = r["back_dir"]
	if d.length() < 1e-4 or not base.has("Hips") or not e.has("Hips"):
		return 0.0
	var v := (e["Hips"] as Vector3) - (base["Hips"] as Vector3)
	return Vector3(v.x, 0.0, v.z).dot(d)


## The round bookkeeping and the film's begin/end frames.
func _rounds() -> void:
	if view == null or not is_instance_valid(view):
		return
	if bool(view.playing):
		_playing_round = int(view.round_n)
		if _film and not _film_sped:
			FightView.fast = true   # S308: the flow's own 2x for the film, as tools/fight3d_play.gd turns it on.
			view._toggle_speed()
			view._toggle_speed()
			_film_sped = true
		if _film and _film_begin < 0 and _playing_round == 1:
			_film_begin = Engine.get_process_frames()
			print("FILM round 1 begins at frame %d" % _film_begin)
	elif _playing_round > 0:
		if _film and _playing_round == 1 and _film_begin >= 0 and _film_end < 0:
			_film_end = Engine.get_process_frames()
			print("FILM round 1 ends at frame %d (bell)" % _film_end)
			_film_done = true
		_rounds_done = maxi(_rounds_done, _playing_round)
		_bout_over = _bout_over or str(view.get("_stop")) != ""
		_playing_round = 0


## The shout bar answered the frame it opens (aim = the body), the corner minute between rounds.
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
	if _film:
		var past := _film_end >= 0 and Engine.get_process_frames() >= _film_end + 30   # a second past the bell
		return past or _film_done or _clock > 260.0
	if _clock < 750.0 and _rounds_done < ROUNDS and not _bout_over:
		return false
	for r in shots:
		if not bool(r["done"]):
			return false
	return true


func _report() -> void:
	if _film:
		print("BODYREACT film done: round 1 frames %d..%d" % [_film_begin, _film_end])
		return
	for c in _cuts:
		print("BODYREACT_NOT_SHOWN r%d t=%6.2f v%d %s: cut off before its contact - the hitter played [%s]; no hit, no reaction showed" % [int(c["round"]), float(c["t"]), int(c["victim"]), str(c["move"]), str(c["hseq"])])
	var n := shots.size()
	var voided := n < SHOTS_MIN
	var reacted := 0
	var curl_min := 999.0
	var first_max := -1.0
	var held_min := 999.0
	var landed := 0
	var body := 0
	for rn in counts:
		landed += int(counts[rn]["all"])
		body += int(counts[rn]["body"])
		print("  round %d: %d landed hits, %d of them to the body" % [int(rn), int(counts[rn]["all"]), int(counts[rn]["body"])])
	for r in shots:
		_print_shot(r)
		if bool(r["played"]):
			reacted += 1
		curl_min = minf(curl_min, float(r["curl"]))
		held_min = minf(held_min, float(r["held"]))
		var first := float(r["first"])
		first_max = maxf(first_max, first if first >= 0.0 else 99.0)
	var react_ok: bool = not voided and reacted == n
	var curl_ok: bool = not voided and curl_min >= CURL_MIN_DEG
	var first_ok: bool = not voided and first_max >= 0.0 and first_max <= FIRST_MAX_S
	var held_ok: bool = not voided and held_min >= HELD_MIN_S
	print("BODYREACT_SUMMARY shots=%d of %d landed (%d body, %d cut off before they showed, bar %d)   %s" % [n, landed, body, _cuts.size(), SHOTS_MIN, "VOID" if voided else "measured"])
	print("BODYREACT_SUMMARY react  %d/%d played a reaction (bar: none)          %s" % [reacted, n, "OK" if react_ok else "FAIL"])
	print("BODYREACT_SUMMARY curl   worst %.1f deg (bar %.0f)                   %s" % [curl_min if n > 0 else 0.0, CURL_MIN_DEG, "OK" if curl_ok else "FAIL"])
	print("BODYREACT_SUMMARY first  slowest %.2f s (bar %.2f)                    %s" % [first_max if n > 0 else 99.0, FIRST_MAX_S, "OK" if first_ok else "FAIL"])
	print("BODYREACT_SUMMARY held   shortest %.2f s (bar %.2f)                   %s" % [held_min if n > 0 else 0.0, HELD_MIN_S, "OK" if held_ok else "FAIL"])
	print("BODYREACT_SUMMARY %s%s" % ["VOID (%d shown, %d needed) - every line FAILS" % [n, SHOTS_MIN] if voided else "",
		"" if voided else ("PASS" if react_ok and curl_ok and first_ok and held_ok else "FAIL")])


func _print_shot(r: Dictionary) -> void:
	var played: bool = bool(r["played"])
	var react := str(r["clip"]) if played else "NONE(%s)" % ("nothing started" if str(r["clip"]) == "NONE" else "%s started, not a reaction" % str(r["clip"]))
	var first := float(r["first"])
	var ok: bool = played and float(r["curl"]) >= CURL_MIN_DEG and first >= 0.0 and first <= FIRST_MAX_S and float(r["held"]) >= HELD_MIN_S
	print("BODYREACT r%d t=%6.2f v%d %s (punch %s) react=%s | curl=%.1fdeg first=%s held=%.2fs hips=%+.2fm | %s" % [
		int(r["round"]), float(r["t0"]), int(r["victim"]), str(r["move"]), str(r["pclip"]), react, float(r["curl"]), ("%.2fs" % first) if first >= 0.0 else "never", float(r["held"]), float(r["hips_max"]), "OK" if ok else "FAIL"])
	var began: Array = []
	for st: Dictionary in (starts[int(r["victim"])] as Array):
		if absi(int(st["f"]) - int(r["f0"])) <= START_WIN_F + 2:
			began.append("%s@%+df" % [str(st["clip"]), int(st["f"]) - int(r["f0"])])
	var deep := float(r["t_deep"]) - float(r["t0"])
	var e := HitSnap.fold_envelope(deep) * float(r["gain"]) if float(r["gain"]) > 0.0 and float(r["t_deep"]) > 0.0 else 0.0
	var asked := sqrt(pow(9.0 * e, 2.0) + pow(6.0 * e, 2.0))
	print("  shot: victim's clips at the blow [%s] | HitSnap gain=%.1f -> fold asked %.1f deg, shown deepest %.1f deg" % [
		", ".join(began), float(r["gain"]), asked, float(r["curl"])])


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