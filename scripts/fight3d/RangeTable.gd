extends RefCounted
## POWER1 step 4 (owner S439: "the uppercut i think it aims too short, check it again an opponent how close the have to be
## to connect"; ops/research/UPPERCUT_RANGE_S439.md and REFERENCE_DISTANCES_S439.md). Every punch was thrown from one
## spacing, the jab's (0.93-0.98 m pelvis to pelvis): the jabs and crosses only straighten at 0.91-1.11 m, so they landed
## with the elbow folded (median 76 deg); the uppercuts only reach at 0.61-0.70 m, so they landed locked straight (165).
## A shipped game works at 1.05-1.35 m centre to centre; another picks a short- or long-range take per punch and lets the
## arm add at most 0.30 m.
## Here each punch gets its own distance, per boxer pair, from the clip itself: where her shoulder is at the clip's contact
## (with the hips' own travel and a landed cross or hook's carry, PunchWeight), how long her arm and glove are, and where
## the other's face stands (her chin for an uppercut, CHIN_DOWN_M under the face point): the pelvis gap at which the
## reach meets it with the elbow at ELBOW_DEG - straights nearly straight, hooks bent, uppercuts bent under the chin.
## No distance is closer than UPPER_M.x (UpperRoom keeps the bodies apart there). Review round 1: uppercuts are no longer
## clamped to UPPER_M; as drawn they need 0.83-0.90 m (RangeLive adds the drawn bodies' offsets to every distance here).
## The footwork steps to the move's distance (RangeBreath.want_m: the longest of its takes, plus PAD_M - its band), and a
## shorter take's landing reach carries the body the rest of the way in (FightStage.land). It shows; it decides nothing.
## `-- nopunchrange` = the control arm (one spacing for every punch, as before step 4).
##   build(stage)   clip_m(stage, who, clip)   moves(stage, ph)   kind(clip)   aim(stage, i, body, clip)

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const IdleMatch := preload("res://scripts/fight3d/IdleMatch.gd")
const PunchWeight := preload("res://scripts/fight3d/PunchWeight.gd")
const RangeLive := preload("res://scripts/fight3d/RangeLive.gd")

const ELBOW_DEG := {"straight": 162.0, "hook": 100.0, "uppercut": 105.0}
const UPPER_M := Vector2(0.70, 0.74)
const CHIN_DOWN_M := 0.12
## The share of a landed cross or hook's carry already there at the hit (PunchWeight.curve at the contact).
const CARRY_AT_HIT := 0.8
## The footwork stands this far past the move's longest take: its step band is +-0.06 m, and a gap a little long is taken
## up by the reach's lunge, a gap short folds the arm.
const PAD_M := 0.03
## The carry stops following the pair this long (clip seconds) before the contact: the glove's last frames land as aimed.
const RELUNGE_STOP_S := 0.03
const VARIANTS := ["", "_a", "_b", "_c", "_v2", "_hard", "_hurt", "_ft", "_hard_ft", "_hurt_ft", "_special", "_miss"]
const PLAIN := ["", "_a", "_b", "_c", "_v2"]

static var on: bool = not OS.get_cmdline_user_args().has("nopunchrange")


static func kind(clip: String) -> String:
	if clip.contains("uppercut"):
		return "uppercut"
	if clip.contains("body") or clip.contains("kidney"):
		return "body"
	if clip.contains("hook"):
		return "hook"
	return "straight" if clip.contains("jab") or clip.contains("cross") else "body"


## Every Pro punch take on each boxer: bx["ranges"] {clip: metres} and bx["move_ranges"] {move: metres}.
static func build(st: Node) -> void:
	if not on:
		return
	for i in st.boxers.size():
		var bx: Dictionary = st.boxers[i]
		var ap: AnimationPlayer = bx["ap"]
		var was := str(ap.current_animation)
		bx["guard_parts"] = _guard(st, i)
		var ranges := {}
		var moves := {}
		var sides := {}
		for move in BeatClips.PUNCH:
			var stem := "pro_" + str(BeatClips.PUNCH[move][0])
			var longest := -1.0
			for v in VARIANTS:
				var clip := stem + str(v)
				if not ap.has_animation(clip) or kind(clip) == "body":
					continue
				ranges[clip] = _clip_m(st, i, clip)
				if PLAIN.has(v) and not BeatClips.OFF_TAKES.has(clip) and float(ranges[clip]) > longest:
					longest = float(ranges[clip])
					sides[move] = kind(clip)
			if longest > 0.0:
				moves[move] = longest + PAD_M
		bx["ranges"] = ranges
		bx["move_ranges"] = moves
		bx["move_kinds"] = sides
		if was != "":
			ap.play(was)
	RangeLive.attach(st)


## The pelvis gap at which `who`'s `clip` meets the other with its elbow at ELBOW_DEG, as the two stand drawn (RangeLive);
## the jab gap when not measured.
static func clip_m(st: Node, who: int, clip: String) -> float:
	var bx: Dictionary = st.boxers[who]
	if not (bx.get("ranges", {}) as Dictionary).has(clip):
		return st.gap_m
	return _floor(clip, float(bx["ranges"][clip]) + RangeLive.off(st, who, kind(clip)))


## The distances the footwork keeps for each move in phase `ph` (its boxer's; both boxers' longest when it names none).
## Review round 1: a landed punch's body carry (PunchReach.lunge_m, set once when it fired: FightStage.land) follows the
## pair until just before the contact - the footwork may still be stepping when she lets it go. Once a frame (UpperRoom.tick).
## Read off the place and the table only (not her arm), so the weight test's two arms get the same carry.
static func relunge(st: Node) -> void:
	if not on:
		return
	for i in st.boxers.size():
		var pr: Node = st.boxers[i].get("reach")
		var clip := str(pr.get("_clip")) if pr != null else ""
		var ap: AnimationPlayer = st.boxers[i]["ap"]
		if clip == "" or kind(clip) == "body" or float(pr.get("_thru")) <= 0.0 or str(ap.assigned_animation) != clip:
			continue
		if ap.current_animation_position < float(pr.get("_contact")) - RELUNGE_STOP_S:
			pr.set("lunge_m", clampf(float(st._gap_shown()) - clip_m(st, i, clip), 0.0, float(st.LUNGE_MAX_M)))


## A punch in the air (ph "clip", RangeBreath) keeps its own take's distance until it lands.
static func moves(st: Node, ph: Dictionary) -> Dictionary:
	if not on:
		return {}
	var who := int(ph.get("who", -1))
	var out := _moves(st, who) if who >= 0 else _moves(st, 0)
	if who < 0:
		var b := _moves(st, 1)
		for m in b:
			out[m] = maxf(float(out.get(m, 0.0)), float(b[m]))
	if who >= 0 and str(ph.get("clip", "")) != "" and (st.boxers[who].get("ranges", {}) as Dictionary).has(str(ph["clip"])):
		out[str(ph["next"]) if str(ph.get("next", "")) != "" else str(ph["move"])] = clip_m(st, who, str(ph["clip"])) + PAD_M
	return out


static func _moves(st: Node, who: int) -> Dictionary:
	var bx: Dictionary = st.boxers[who]
	var out := {}
	var kinds: Dictionary = bx.get("move_kinds", {})
	for m in bx.get("move_ranges", {}):
		out[m] = _floor(str(m), float(bx["move_ranges"][m]) + RangeLive.off(st, who, str(kinds.get(m, "straight"))))
	return out


## Never closer than the uppercut's floor (UpperRoom keeps the bodies apart there).
static func _floor(clip: String, m: float) -> float:
	return maxf(m, UPPER_M.x)


## Where `clip` lands on boxer i (world): FightStage.target_point, and for an uppercut her chin, under the face point.
static func aim(st: Node, i: int, body: bool, clip: String) -> Vector3:
	var p: Vector3 = st.target_point(i, body)
	if on and not body and kind(clip) == "uppercut":
		p += Vector3.DOWN * CHIN_DOWN_M * float(st._scale(i))
	return p


static func _clip_m(st: Node, who: int, clip: String) -> float:
	var bx: Dictionary = st.boxers[who]
	var o: Dictionary = st.boxers[1 - who]
	var k := kind(clip)
	var row := BeatClips.contact_row(clip)
	var t := BeatClips.contact(clip, float(row.get("contact_s", 0.3)))
	var side := str(st.hand_of(who, str(row.get("hand", "LeftHand" if clip.contains("left_") else "RightHand")))).trim_suffix("Hand")
	var sc := float(st._scale(who))
	var so := float(st._scale(1 - who))
	var s := IdleMatch.pose_point(bx, clip, t, side + "UpperArm") * sc
	var e := IdleMatch.pose_point(bx, clip, t, side + "LowerArm") * sc
	var w := IdleMatch.pose_point(bx, clip, t, side + "Hand") * sc
	var l1 := s.distance_to(e)
	var l2 := e.distance_to(w)
	var f := float(bx["front"]) * sc
	# Her shoulder at the hit: the hips' own travel (PunchWeight's layer 1) and a landed cross or hook's carry (layer 2).
	var fwd := _hips_fwd(bx, clip, t)
	var carry := 0.0
	if bx.get("weight") != null and (k == "straight" and clip.contains("cross") or k == "hook"):
		carry = maxf(0.0, float(PunchWeight.CARRY_TO_M["cross" if clip.contains("cross") else "hook"]) - fwd) * CARRY_AT_HIT
	s.z += fwd + carry
	# The other's face (her chin for an uppercut) in her guard, in her own frame; she faces back along -z.
	var face := IdleMatch.pose_point(o, "pro_left_jab" if (o["ap"] as AnimationPlayer).has_animation("pro_left_jab") else "jab", 0.0, "Head") * so
	var consts: Dictionary = (st.get_script() as GDScript).get_script_constant_map()
	face += Vector3(0.0, float(consts["FACE_UP_M"]), float(consts["FACE_FWD_M"])) * so
	if k == "uppercut":
		face.y -= CHIN_DOWN_M * so
	var r := glove_reach(l1, l2, f, k)
	var dx := -face.x - s.x
	var dy := face.y - s.y
	var dz := sqrt(maxf(r * r - dx * dx - dy * dy, 0.0025))
	var gap := s.z + dz + face.z
	# For probes (tests/punch_range_test.gd): the model's parts, to set against the live arm at the hit.
	var parts: Dictionary = bx.get("range_parts", {})
	parts[clip] = {"s_fwd": s.z, "face_fwd": face.z, "side": dx, "up": dy, "reach": r, "fwd": fwd, "carry": carry, "hand": side}
	bx["range_parts"] = parts
	return clampf(gap, 0.6, 1.5)


## Boxer i's shoulders and face (metres in front of her body, along her front) in the clip's guard: what RangeLive compares
## the drawn body against.
static func _guard(st: Node, i: int) -> Dictionary:
	var bx: Dictionary = st.boxers[i]
	var g := "pro_left_jab" if (bx["ap"] as AnimationPlayer).has_animation("pro_left_jab") else "jab"
	var sc := float(st._scale(i))
	var consts: Dictionary = (st.get_script() as GDScript).get_script_constant_map()
	return {"Left": IdleMatch.pose_point(bx, g, 0.0, "LeftUpperArm").z * sc, "Right": IdleMatch.pose_point(bx, g, 0.0, "RightUpperArm").z * sc,
		"face": (IdleMatch.pose_point(bx, g, 0.0, "Head").z + float(consts["FACE_FWD_M"])) * sc}


## The glove front's distance from the shoulder with the elbow at ELBOW_DEG[kind]: the wrist at d, the glove's axis along
## the forearm (upper arm l1, forearm l2, glove front f).
static func glove_reach(l1: float, l2: float, f: float, k: String) -> float:
	var th := deg_to_rad(float(ELBOW_DEG.get(k, 160.0)))
	var d := sqrt(maxf(0.0, l1 * l1 + l2 * l2 - 2.0 * l1 * l2 * cos(th)))
	var cg := clampf((l2 * l2 + d * d - l1 * l1) / maxf(2.0 * l2 * d, 1e-4), -1.0, 1.0)
	return sqrt(d * d + f * f + 2.0 * d * f * cg)


## The hips' own forward travel at clip time t (metres), as PunchWeight plays it back.
static func _hips_fwd(bx: Dictionary, clip: String, t: float) -> float:
	var pw: Node = bx.get("weight")
	if pw == null or not PunchWeight.on:
		return 0.0
	var path: PackedVector3Array = pw.call("travel", clip)
	if path.size() < 2:
		return 0.0
	var fi := clampf(t * PunchWeight.RATE, 0.0, float(path.size() - 1))
	var i := mini(int(fi), path.size() - 2)
	var v: Vector3 = path[i].lerp(path[i + 1], fi - float(i))
	var skel: Skeleton3D = bx["skel"]
	return ((pw.get("_to_parent") as Basis).inverse() * v).z * skel.global_transform.basis.get_scale().x
