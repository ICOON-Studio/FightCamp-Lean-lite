extends RefCounted
## MOVEPICS1 (S381, operator on the Fight Camp screen's ink cards: "use the artstyle from fight camp still i liked that more
## of that art in the menus") - which clip, which instant, which partner and which camera for each Playbook move card
## (tools/bake_move_pics.gd). The boxing cards are the Moves book (MoveWords: StrikeMap's moves) + the Escapes list
## (Playbook.ESCAPES) + the single punches and defences they are made of; every clip is the one the fight plays for the
## move (MoveClips). The BJJ cards are Ana's syllabus (BeltRoad), each move's GrappleMap film (BjjFilm).
##   ids() -> boxing card ids, in book order   spec(id) -> the card's recipe   bjj_ids() -> [syllabus ids]
##   file(id) -> png file name
## S381 r2: the r1 stand-in positions for unfilmed BJJ moves are gone - the review found them showing OTHER moves; those
## cards are now a GrappleMap film found for them or a "card pending" name (tools/move_pic_bjj_cards.gd).

const SM := preload("res://scripts/rules/StrikeMap.gd")
const MoveWords := preload("res://scripts/rules/MoveWords.gd")
const MoveClips := preload("res://scripts/fight3d/MoveClips.gd")
const Playbook := preload("res://scripts/ui/areas/Playbook.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const IdleMatch := preload("res://scripts/fight3d/IdleMatch.gd")
const Poses := preload("res://tools/session_pic_poses.gd")

const LIFT_M := 0.05          # a foot this far off its start height is stepping
const STEP_WINDOW := 0.6      # s after the lift the step's end is looked for
const UPPERCUT_UNDER := 0.06  # m under her guard height the rising uppercut meets a chin
const FIST_WINDOW := 0.45     # s before contact the arrow's start is looked for (see wind_up)
const HOOK_DROP := 0.15       # m under the landing a hook's wind-up may start

## The vocabulary the combos are made of: one card each, so the book can show a punch on its own.
const SINGLES := {
	"jab": "pro_left_jab", "cross": "pro_right_cross", "lead_hook": "pro_left_hook", "rear_hook": "pro_right_hook",
	"lead_uppercut": "pro_left_uppercut", "rear_uppercut": "pro_right_uppercut", "body_hook": "body_hook",
	"slip": "slip", "roll": "pro_left_weave",
}
const PUNCHES := ["pro_left_jab", "pro_right_cross", "pro_left_hook", "pro_right_hook", "pro_left_uppercut",
	"pro_right_uppercut", "body_hook", "rear_uppercut"]
const BODY_SHOTS := ["body_hook"]
## The old game's baked punches carry no side in their name: "3b" is the lead (left) body hook, "6" the rear uppercut.
const CLIP_HAND := {"body_hook": "LeftHand", "rear_uppercut": "RightHand"}
## A defence clip -> the partner's punch it beats (that glove is drawn where her head was).
const DEFENCES := {"slip": "pro_right_cross", "pro_left_weave": "pro_left_hook", "pull": "pro_left_jab"}
## The partner takes the punch: the reaction clip just after its contact (her head starts to go, so the card reads as a
## punch that LANDED, and her guard has opened off the face it hits).
const HIT := {"pro_left_jab": "pro_hit_by_jab_v1", "pro_right_cross": "pro_hit_by_cross_v1",
	"pro_left_hook": "pro_hit_by_hook_v1", "pro_right_hook": "pro_hit_by_hook_v2", "pro_left_uppercut": "pro_hit_by_uppercut_v1",
	"pro_right_uppercut": "pro_hit_by_uppercut_v1", "rear_uppercut": "pro_hit_by_uppercut_v1", "body_hook": "pro_hit_by_gutshot_v1"}
const HIT_T := 0.08
const STEPS := ["advance", "retreat", "strafe_left", "strafe_right"]
## The camera round her (deg; -90 = her right side, profile): near-profile for anything thrown at the partner, so
## neither boxer faces away; the side steps a little more face-on so the sideways step reads.
## S381 look-dev (cards compared side by side): the inside punches - hooks, the rear uppercut, the body hook - and the
## roll are shot over her right shoulder (-122 / -138, a little higher): in profile the two bodies at hook range sit on
## top of each other and the hook's sweep runs straight at the eye.
## S381 r2 (review: rear hook / rear uppercut "crowded, partner hidden" over the shoulder): the rear-hand shots from her
## front-right (-60, swept -160..140 side by side): Maria's face and the glove on it both in view. S383: the rear
## uppercut from her right side (-96, swept -168..-90): from -60 Maria's guard sat on Lucy's head; in profile the fist's
## rise runs up between the two faces.
const AZ := {
	"pro_left_jab": -74.0, "pro_right_cross": -80.0, "pro_left_hook": -122.0, "pro_right_hook": -60.0,
	"pro_left_uppercut": -70.0, "pro_right_uppercut": -96.0, "body_hook": -96.0, "rear_uppercut": -122.0,
	"slip": -72.0, "pro_left_weave": -40.0, "pull": -84.0, "advance": -86.0, "retreat": -86.0,
	"strafe_left": -64.0, "strafe_right": -64.0, "clinch_att": -70.0,
}
const OVER_SHOULDER_ELEV := 10.0
const OUTSIDE_GAP := 1.65     # m pelvis to pelvis for "from outside" (the card's own 1.4-3.0 would shrink her)
const ROPE_GAP := 0.9         # MovePlayer.ROPE_RANGE_M
const CLINCH_GAP := 0.68      # Clinch.PAIR_GAP_M
const CLINCH_SPAN := Vector2(0.4, 3.6)
const ROPE_AZ_OPP := -135.0
const ROPE_AZ_OWN := -45.0
const SEQ_BACK := 0.26        # m each earlier punch of a combo stands behind the next (the combo walks in, in order)



static func ids() -> Array:
	var out: Array = SINGLES.keys()
	for g in MoveWords.groups():
		for id in g[2]:
			if not out.has(str(id)):
				out.append(str(id))
	for g in Playbook.ESCAPES:
		for id in g[2]:
			if not out.has(str(id)):
				out.append(str(id))
	return out


static func bjj_ids() -> Array:
	var out: Array = []
	for belt in BeltRoad.BELTS:
		for g in (BeltRoad.SYLLABUS.get(belt, {}) as Dictionary).get("groups", []):
			for id in g[1]:
				out.append(str(id))
	return out


## "slip 2-3@own_ropes" -> "slip_2-3_at_own_ropes.png"
static func file(id: String) -> String:
	return id.replace(" ", "_").replace("@", "_at_") + ".png"


## The card's recipe. kind: punch (she hits the partner) | defence (the partner's glove where her head was) |
## step (footwork, the partner at the card's range) | clinch (the pair clip).
##   finish/ghost: {clip, at} - at = "contact" | "start" | "away" | "stride" | "clinch" (resolved on the body)
##   arrow: fist | head | foot     partner: {clip, at}     gap: m     ropes: own | opp | corner | ""
static func spec(id: String) -> Dictionary:
	var clips: Array = [SINGLES[id]] if SINGLES.has(id) else MoveClips.clips(id)
	var mv := SM.move(id)
	var from := str(mv.get("from", "long"))
	var to := str(mv.get("to", "long"))
	var s := {"id": id, "ropes": _ropes(from, to)}
	var punches: Array = clips.filter(func(c): return PUNCHES.has(str(c)))
	if clips.has("clinch_att"):
		s.merge({"kind": "clinch", "finish": {"clip": "clinch_att", "at": "clinch"}, "arrow": "",
			"partner": {"clip": "clinch_vic", "at": "clinch"}, "gap": CLINCH_GAP})
	elif not punches.is_empty() and DEFENCES.has(str(clips[0])):
		# Slip, then counter: the slip is the ghost, the counter that comes out of it the solid figure.
		s.merge({"kind": "punch", "finish": {"clip": str(punches[0]), "at": "contact"},
			"ghosts": [{"clip": str(clips[0]), "at": "away"}], "arrow": "fist", "partner": {"clip": "pro_idle", "at": "start"}})
	elif not punches.is_empty():
		var last := str(punches[-1])
		s.merge({"kind": "punch", "finish": {"clip": last, "at": "contact"}, "arrow": "fist",
			"partner": {"clip": "pro_idle", "at": "start"}})
		if punches.size() >= 2:
			# S381 r2 (review: "1-1-2, 1-2-3-2 identical to other combos"): every earlier punch of the combo, landed, as a
			# faint figure - in order, each a step further back, so 1-1-2 shows two faint jabs and the cross.
			s["ghosts"] = []
			for i in punches.size() - 1:
				s["ghosts"].append({"clip": str(punches[i]), "at": "contact", "back": SEQ_BACK * (punches.size() - 1 - i)})
		elif id != "rear_uppercut":
			# S383 r3: no start figure for the rear uppercut - in its tight range the faint Lucy stood between the two
			# boxers and read as a third person in a clinch.
			s["ghosts"] = [{"clip": last, "at": "start"}]
	elif DEFENCES.has(str(clips[0])):
		# S383 r3 (review: "roll: no knee dip"): the roll at its lowest, under the hook.
		var deep := "low" if str(clips[0]) == "pro_left_weave" else "away"
		s.merge({"kind": "defence", "finish": {"clip": str(clips[0]), "at": deep},
			"ghosts": [{"clip": str(clips[0]), "at": "start"}], "arrow": "head",
			"partner": {"clip": str(DEFENCES[str(clips[0])]), "at": "contact"}})
	else:
		var step := "advance"
		for c in clips:
			if STEPS.has(str(c)):
				step = str(c)
				break
		s.merge({"kind": "step", "finish": {"clip": step, "at": "stride"}, "ghosts": [{"clip": step, "at": "start"}],
			"arrow": "foot", "partner": {"clip": "pro_idle", "at": "start"}})
	if not s.has("ghosts"):
		s["ghosts"] = []
	if not s.has("gap"):
		s["gap"] = _gap(from)
	if str(s["kind"]) == "punch":
		s["partner"] = {"clip": str(HIT.get(str(s["finish"]["clip"]), "pro_idle")), "at": "hit"}
	s["az"] = float(AZ.get(str(s["finish"]["clip"]), -74.0))
	if str(s["finish"]["clip"]).begins_with("strafe") and str(s["ropes"]) in ["opp", "corner"]:
		s["az"] = -112.0     # ropes behind the partner: the camera on her side of them, so they stay behind
	# S383 r3 (review: "the ropes are short floating sticks"): in profile the ropes at a back run straight at the camera.
	# A rope card is shot at 45 degrees to them - over her shoulder for the partner's ropes, from her front for her own -
	# so the ropes run long across the card behind the boxer on them.
	if str(s["ropes"]) in ["opp", "corner"]:
		s["az"] = ROPE_AZ_OPP
	elif str(s["ropes"]) == "own":
		s["az"] = ROPE_AZ_OWN
	s["elev"] = OVER_SHOULDER_ELEV if float(s["az"]) < -115.0 else 6.0
	s["body_shot"] = BODY_SHOTS.has(str(s["finish"]["clip"]))
	s["inside"] = str(s["kind"]) == "punch" and from == "inside"     # 3b-3@inside: heads close (move_pic_ideas2.inside)
	return s


static func _ropes(from: String, to: String) -> String:
	for place in [from, to]:
		if place == "own_ropes":
			return "own"
	if from == "corner" or to == "corner":
		return "corner"
	if from == "opp_ropes" or to == "opp_ropes":
		return "opp"
	return ""


static func _gap(from: String) -> float:
	if from == "outside":
		return OUTSIDE_GAP
	if from == "clinch":
		return CLINCH_GAP
	var r: Array = SM.card(from).get("range_m", [])
	if r.size() >= 2:
		return (float(r[0]) + float(r[1])) * 0.5
	return ROPE_GAP


# ---------------------------------------------------------------- the instant, read on the body -------------------------------------------------

## {clip, at} -> {clip, t, hand} (+ foot, travel for a step): the instant named, found on the body's own clip.
static func resolve(bx: Dictionary, r: Dictionary) -> Dictionary:
	var clip := str(r["clip"])
	var t := 0.0
	match str(r["at"]):
		"contact":
			t = contact(bx, clip)
		"away":
			t = head_away(bx, clip)
		"low":
			t = head_low(bx, clip)
		"stride":
			var st := stride(bx, clip)
			return {"clip": clip, "t": st[0], "hand": "LeftHand", "foot": st[1], "travel": st[2]}
		"hit":
			t = HIT_T
		"clinch":
			t = lerpf(CLINCH_SPAN.x, CLINCH_SPAN.y, 0.35)
	return {"clip": clip, "t": t, "hand": hand(bx, clip, t)}


static func clip_len(bx: Dictionary, clip: String) -> float:
	var ap: AnimationPlayer = bx["ap"]
	return ap.get_animation(clip).length if ap.has_animation(clip) else 0.0


## The punch's recorded contact (clip_contact.json); unmeasured (or measured at 0) -> the fist's furthest reach, and for
## an uppercut its highest point (a reach from the shoulder peaks before the fist comes up).
static func contact(bx: Dictionary, clip: String) -> float:
	var c := Poses.contact_s(clip)
	if c > 0.05:
		return c
	var h := hand(bx, clip, minf(0.5, clip_len(bx, clip)))
	if BODY_SHOTS.has(clip):
		# The body hook digs in and up: it lands where the fist is furthest in front of her (its widest reach from the
		# shoulder is the wind-up out to the side).
		var at := 0.0
		var front := -INF
		var u := 0.0
		while u <= minf(clip_len(bx, clip), 1.2):
			var z := IdleMatch.pose_point(bx, clip, u, h).z
			if z > front:
				front = z
				at = u
			u += 1.0 / Poses.RATE
		return at
	if not clip.contains("uppercut"):
		return Poses._max_reach(bx, clip, h)
	# An uppercut dips, then drives up through the chin: contact is where the fist is back up at its guard height on the
	# way up (its highest point is the follow-through over her own head).
	var guard_y := IdleMatch.pose_point(bx, clip, 0.0, h).y
	var dip := 0.0
	var low := INF
	var t := 0.0
	while t <= minf(clip_len(bx, clip), 1.2):
		var y := IdleMatch.pose_point(bx, clip, t, h).y
		if y < low:
			low = y
			dip = t
		t += 1.0 / Poses.RATE
	t = dip
	while t <= clip_len(bx, clip):
		if IdleMatch.pose_point(bx, clip, t, h).y >= guard_y - UPPERCUT_UNDER:
			return t
		t += 1.0 / Poses.RATE
	return dip


## Where the punch's drive starts: in the FIST_WINDOW before contact, the instant the fist is furthest from where it
## lands - the guard of a jab, the hook's wind-up out to the side, the uppercut's dip.
static func wind_up(bx: Dictionary, clip: String, h: String, t1: float) -> float:
	var hit := IdleMatch.pose_point(bx, clip, t1, h)
	var best := maxf(0.0, t1 - FIST_WINDOW)
	var far := -1.0
	var t := best
	var hook := clip.contains("hook") and not BODY_SHOTS.has(clip)
	while t < t1:
		var p := IdleMatch.pose_point(bx, clip, t, h)
		var d := p.distance_to(hit)
		# A hook winds up out to the side at its own height: a lower point is the hand dropping, not the hook.
		if d > far and (not hook or p.y >= hit.y - HOOK_DROP):
			far = d
			best = t
		t += 1.0 / Poses.RATE
	return best


## A defence's deepest instant: the head furthest from where it started.
static func head_away(bx: Dictionary, clip: String) -> float:
	var h0 := IdleMatch.pose_point(bx, clip, 0.0, "Head")
	var best := 0.0
	var far := -1.0
	var t := 0.0
	while t <= minf(clip_len(bx, clip), 1.6):
		var d := IdleMatch.pose_point(bx, clip, t, "Head").distance_to(h0)
		if d > far:
			far = d
			best = t
		t += 1.0 / Poses.RATE
	return best


## A roll's deepest instant: the head at its lowest.
static func head_low(bx: Dictionary, clip: String) -> float:
	var best := 0.0
	var low := INF
	var t := 0.0
	while t <= minf(clip_len(bx, clip), 1.6):
		var y := IdleMatch.pose_point(bx, clip, t, "Head").y
		if y < low:
			low = y
			best = t
		t += 1.0 / Poses.RATE
	return best


## The step: the footwork clips are loops in place (the hips hold still, the feet cycle), so the step is read off the
## feet. The first foot to lift is the stepping foot; the step ends where it has travelled furthest from its start
## (STEP_WINDOW after the lift). The other foot is planted, so in the ring the body travelled the opposite of how far it
## slid under her: [t, stepping foot, travel (m, xz)].
static func stride(bx: Dictionary, clip: String) -> Array:
	var length := clip_len(bx, clip)
	var p0 := {}
	for f in ["LeftFoot", "RightFoot"]:
		p0[f] = IdleMatch.pose_point(bx, clip, 0.0, f)
	var foot := ""
	var lift := 0.0
	var t := 0.0
	while foot == "" and t <= length * 0.75:
		for f in ["LeftFoot", "RightFoot"]:
			if foot == "" and IdleMatch.pose_point(bx, clip, t, f).y - (p0[f] as Vector3).y > LIFT_M:
				foot = f
				lift = t
		t += 1.0 / Poses.RATE
	if foot == "":
		foot = "LeftFoot"
	var best := lift
	var far := -1.0
	t = lift
	while t <= minf(length, lift + STEP_WINDOW):
		var d := IdleMatch.pose_point(bx, clip, t, foot) - (p0[foot] as Vector3)
		if Vector2(d.x, d.z).length() > far:
			far = Vector2(d.x, d.z).length()
			best = t
		t += 1.0 / Poses.RATE
	var other := "RightFoot" if foot == "LeftFoot" else "LeftFoot"
	var slide := IdleMatch.pose_point(bx, clip, best, other) - (p0[other] as Vector3)
	return [best, foot, Vector3(-slide.x, 0.0, -slide.z)]


## The striking hand: the clip's name says it (pro_left_*, pro_right_*), else the hand that went furthest FORWARD by
## `t` (the other one is pulled back to the chin, and can travel as far: S381 the left hook first read as the right).
static func hand(bx: Dictionary, clip: String, t: float) -> String:
	if CLIP_HAND.has(clip):
		return str(CLIP_HAND[clip])
	if clip.contains("left"):
		return "LeftHand"
	if clip.contains("right"):
		return "RightHand"
	var dl := IdleMatch.pose_point(bx, clip, t, "LeftHand").z - IdleMatch.pose_point(bx, clip, 0.0, "LeftHand").z
	var dr := IdleMatch.pose_point(bx, clip, t, "RightHand").z - IdleMatch.pose_point(bx, clip, 0.0, "RightHand").z
	return "LeftHand" if dl >= dr else "RightHand"
