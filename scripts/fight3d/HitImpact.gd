extends RefCounted
## A landed punch and the clip pace around it (split out of FightStage S322): the hit reaction, the hit-stop, the head snap,
## and the Pro clip's fast recovery back to the guard.
##   hit(stage, who, clip, speed, hitter, move, big, punch_id)   hold(stage, delta)   recover(stage)

const PunchRange := preload("res://scripts/fight3d/PunchRange.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const HitStun := preload("res://scripts/fight3d/HitStun.gd")
const FightSfx := preload("res://scripts/audio/FightSfx.gd")
const PunchPace := preload("res://scripts/fight3d/PunchPace.gd")
const ReachLimit := preload("res://scripts/fight3d/ReachLimit.gd")
const RangeTable := preload("res://scripts/fight3d/RangeTable.gd")
## POWER1 step 4 (c): a graze's head snap, as a share of the clean hit's.
const GRAZE_SNAP := 0.35

## S302 impact (operator: "the punches feel like they have no power"; John J-GUARDPACE1: hit-stop 2-3 frames on a jab, 4-6
## on a power punch; the receiver's head snaps). Seconds both bodies hold at contact, head-snap degrees, camera nudge metres.
const HOLD_S := {"jab": 0.03, "power": 0.05, "big": 0.06}
const SNAP_DEG := {"jab": 11.0, "cross": 16.0, "hook": 19.0, "uppercut": 17.0}
const BIG_SNAP := 1.6   # S395 (blind review: a big shot in slow motion showed no head snap)

const SHAKE_M := {"jab": 0.0, "power": 0.025, "big": 0.06}
## S301: a Pro clip plays its recovery fast (BeatClips.recover_scale, from its measured contact) and hands over to the guard
## the moment it is back in guard, instead of standing on to the end of the take.
const RECOVER_RAMP_S := 0.05
const PAST_OK_S := 0.04   # clip seconds past the contact a punch may be on its hit frame (one frame at 2.4x)
const TAIL_HOLD_S := 0.06



## S302: `hitter`'s `move` lands on `who`: her hit reaction starts, both bodies hold for the hit-stop, her head snaps the
## way the glove drove it (not on a body shot), and a power shot nudges the camera.
static func hit(st: Node, who: int, clip: String, speed: float, hitter: int, move: String, big: bool, punch_id: int) -> void:
	var was_cut := PunchRange.cut_off(st, hitter, punch_id)
	var graze := false
	if not was_cut:
		var pr: Node = st.boxers[hitter].get("reach")
		var ap_h: AnimationPlayer = st.boxers[hitter]["ap"]
		if pr != null and str(pr.get("_clip")) != "" and str(ap_h.assigned_animation) == str(pr.get("_clip")):
			var c_t := float(pr.get("_contact"))
			# POWER1 step 3: the timer fires before this frame's step, and the hit-stop then holds the clip where it is: a
			# clip a hair short of its contact (under 0.01 s, not sought) froze on the frame before the hit (hit_carry_test:
			# the glove arrived at 0-15 % of its speed). It is put on its contact; a clip already a frame past its contact
			# carries on (seeking it back drew the glove going backwards on the hit frame).
			var past := ap_h.current_animation_position - c_t
			if PunchPace.on and past > 0.0 and past <= PAST_OK_S:
				pass
			elif absf(past) > 0.01 or (PunchPace.on and past < 0.0):
				ap_h.seek(c_t, true)
			pr._process_modification()
			# S445 (blind read: hard/hurt/big takes were never a graze, so clean hits drew 0.2-0.38 m off her): a glove that is
			# off her on the hit frame is a graze whatever the take. The result stands (settled before); only the show changes.
			graze = RangeTable.on and ReachLimit.miss(pr) > ReachLimit.GRAZE_M
	PunchRange.record(st, who, hitter, move, was_cut, graze)
	if was_cut:
		return   # S320: her punch was cut off before it arrived (a clinch, a reaction): no hit shows without a punch
	if graze:
		# POWER1 step 4 (c): the glove is still off her on the hit frame (out of the reach's cap): a glancing touch, never a
		# clean hit - the light sound, a small snap, no freeze, no shake, no reaction. The result stands (settled before).
		FightSfx.blocked()
		var gs: Node = st.boxers[who].get("snap")
		if gs != null and not move.contains("body"):
			gs.snap(st.target_point(who, false) - (st.boxers[hitter]["node"] as Node3D).global_position, 9.0 * GRAZE_SNAP)
		return
	FightSfx.landed(move, big)
	if big and st.has_node("RingSet") and st.get_node("RingSet").get("flashes") != null:
		st.get_node("RingSet").flashes.burst(9)   # S447: the press reacts to a big shot
	var boxers: Array = st.boxers
	# S305: fast to its peak, then the clip's own pace back to guard; locked in it until then (HitStun).
	var fast := BeatClips.react_fast(clip, speed)
	st.stun.clear(who)
	st.play(who, clip, fast)
	if str((boxers[who]["ap"] as AnimationPlayer).current_animation) == clip:
		# S311: a plain head shot snaps and lets her fight on; hurt, big and body shots keep the full reaction.
		var light := not move.contains("body") and not (BeatClips.REACT["hurt"] as Array).has(clip)
		var cut := HitStun.head_cut(clip, fast) if light else HitStun.react_cut(clip, speed, fast)
		st._cut[who] = cut if not cut.is_empty() else st._cut[who]
		st.stun.start(who, clip, speed, light)
	var kind := "big" if big else ("jab" if move == "jab" else "power")
	st._hold_left = float(HOLD_S[kind])
	for i in boxers.size():
		var sc: float = (boxers[i]["ap"] as AnimationPlayer).speed_scale
		if sc != 0.0:
			st._held_speed[i] = sc
	st.camera.shake(float(SHAKE_M[kind]))
	var snap: Node = boxers[who].get("snap")
	if snap == null:
		return
	if move.contains("body"):
		# S310: a landed body shot folds her over the side it hit (a lead hook from the hitter meets her other side).
		snap.fold(st.hand_of(hitter, "LeftHand") == "RightHand")
		return
	var deg := 9.0
	for key in SNAP_DEG:
		if move.contains(key):
			deg = float(SNAP_DEG[key])
	if big:
		deg *= BIG_SNAP
	var hand: String = st.hand_of(hitter, "LeftHand" if move in ["jab", "lead_hook", "lead_uppercut"] else "RightHand")
	var skel: Skeleton3D = boxers[hitter]["skel"]
	var shoulder := skel.global_transform * skel.get_bone_global_pose(skel.find_bone(hand.trim_suffix("Hand") + "UpperArm")).origin
	# S322 a burning arm (BodyBurn "power" per hand, 1.0 .. BodyLoad.POWER_MIN): its punches snap the head less.
	var power: Dictionary = boxers[hitter].get("power", {})
	var arm := "lead" if move in ["jab", "lead_hook", "lead_uppercut", "body_hook"] else "rear"
	snap.snap(st.target_point(who, false) - shoulder, deg * (1.5 if big else 1.0) * float(power.get(arm, 1.0)))


## The hit-stop: both AnimationPlayers stand still (whatever speed a move set is kept and given back after).
static func hold(st: Node, delta: float) -> void:
	if st._hold_left <= 0.0:
		return
	st._hold_left -= delta
	var boxers: Array = st.boxers
	for i in boxers.size():
		var ap: AnimationPlayer = boxers[i]["ap"]
		if st._hold_left > 0.0:
			if ap.speed_scale != 0.0:
				st._held_speed[i] = ap.speed_scale
				ap.speed_scale = 0.0
		elif ap.speed_scale == 0.0:
			ap.speed_scale = st._held_speed[i]


static func recover(st: Node) -> void:
	var boxers: Array = st.boxers
	var dt: float = st.get_process_delta_time()
	for who in boxers.size():
		var cut: Dictionary = st._cut[who]
		if cut.is_empty():
			continue
		var ap: AnimationPlayer = boxers[who]["ap"]
		if str(ap.current_animation) != str(cut["clip"]):
			st._cut[who] = {}
			continue
		var at := ap.current_animation_position
		if not bool(cut["fast"]) and float(cut["contact"]) >= 0.0 and at >= float(cut["contact"]):
			cut["fast"] = true
		# S316 smoothness: the recovery speeds up over RECOVER_RAMP_S, not in one frame (an instant x2-3 jumps the hand's
		# speed at contact - tools/smooth_probe.gd counted the hook and body-shot clips' kinks there).
		if bool(cut["fast"]) and not cut.has("hold") and ap.speed_scale < float(cut["scale"]):
			ap.speed_scale = minf(float(cut["scale"]), ap.speed_scale + float(cut["scale"]) * dt / RECOVER_RAMP_S)
		if float(cut["back"]) > 0.0 and at >= float(cut["back"]):
			# S318 smoothness (tools/smooth_probe.gd: pro_idle started 39x in 1.8 min and played a median 0.27 s before the
			# next move): back in guard, the punch's own tail (every Pro clip ends in its idle) plays on for up to TAIL_HOLD_S,
			# easing to normal speed, so a move that comes inside it is one clip change instead of two.
			# POWER1 step 4 (e), review round 1: a quick hand-back (BeatClips.QUICK_BACK_S, the lead uppercut) goes to the guard
			# at once - its tail is the glove rising over her own head, and the tail hold played it on (the film's f25-f27).
			var quick := BeatClips.quick_back and BeatClips.QUICK_BACK_S.has(str(cut["clip"]))
			var hold_s := float(cut.get("hold", 0.0 if quick else TAIL_HOLD_S)) - dt
			cut["hold"] = hold_s
			ap.speed_scale = maxf(1.0, ap.speed_scale - float(cut["scale"]) * dt / RECOVER_RAMP_S)
			if hold_s <= 0.0:
				st._cut[who] = {}
				boxers[who]["guard_home"] = quick   # IdleMatch.pick: her usual guard, not the frame nearest the rising glove
				if quick and boxers[who].get("js") != null:
					boxers[who]["js"].set("still", true)
				st.guard(who)
				boxers[who]["guard_home"] = false
