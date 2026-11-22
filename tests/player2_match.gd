extends RefCounted
## S537 KNEEROOT1: player2_test's KNEEMATCH and GLOVEMATCH (its own file: player2_test.gd is at the line limit).
## run(test, player2) reads the test's own stage as drawn (test._w) and reports through test._check.

const KR := preload("res://tools/kneeroot_lib.gd")
const GLOVE_SWING_DEG := 3.0  # rigid on the hand a glove reads 0-2 deg (the straightened wrist's share of the wrist's own bend)
const MATCH_TO_S := 0.40
const MATCH_FROM_S := 0.20    # the join into the punch is over (0.15 s) and the pin has let go (0.2 s)
const KNEE_MATCH_M := 0.02    # KNEEROOT1: the brief's bar
## S537 BOUGHTCLIP1: the bought jab and cross arrive 99% straight; a plan that stands the men too close for the body
## that punches makes the arm finish fold the arm (75-84% on a big body: tools/boughtclip_probe.gd).
const STRAIGHT_MIN := 0.90


## How straight boxer i's punching arm is as drawn: shoulder to wrist over upper arm + forearm.
static func straight(t: SceneTree, i: int, hand: String) -> float:
	var side := hand.trim_suffix("Hand")
	var sh: Vector3 = t._w(i, side + "UpperArm")
	var el: Vector3 = t._w(i, side + "LowerArm")
	var wr: Vector3 = t._w(i, hand)
	return sh.distance_to(wr) / maxf(sh.distance_to(el) + el.distance_to(wr), 0.001)


static func _pts(t: SceneTree, i: int) -> Dictionary:
	var out := {"fwd": Vector3((t.st.boxers[i]["node"] as Node3D).global_transform.basis.z.x, 0.0, (t.st.boxers[i]["node"] as Node3D).global_transform.basis.z.z).normalized()}
	for k in KR.GAME_BONES:
		out[k] = t._w(i, str(KR.GAME_BONES[k]))
	return out


## One run of blue's plain cross, the knees picture by picture (KR.legs); `alone` = the take with every layer off.
static func _cross_knees(t: SceneTree, p2: Node, alone: bool) -> Array:
	var ap: AnimationPlayer = t.st.boxers[1]["ap"]
	var mods: Array = (t.st.boxers[1]["skel"] as Skeleton3D).get_children().filter(func(c): return c is SkeletonModifier3D and (c as SkeletonModifier3D).active)
	p2.guard(1)
	for f in 70:
		await t.process_frame
	for m in (mods if alone else []):
		(m as SkeletonModifier3D).active = false
	p2._play(1, "pro_right_cross", 0.0, "punch", true)
	var rows: Array = []
	rows.resize(int(MATCH_TO_S * 60.0) + 1)
	for f in 60:
		await t.process_frame
		var n := int(round(ap.current_animation_position * 60.0))
		if str(ap.current_animation) == "pro_right_cross" and n >= int(MATCH_FROM_S * 60.0) and n < rows.size():
			rows[n] = KR.legs(_pts(t, 1), KR.leg_len(_pts(t, 1)), false)
	for m in (mods if alone else []):
		(m as SkeletonModifier3D).active = true
	return rows


static func run(t: SceneTree, p2: Node) -> void:
	var FT: GDScript = load("res://scripts/fight3d/v2/FootTake.gd")
	var alone: Array = await _cross_knees(t, p2, true)
	var now: float = KR.worst_valgus(await _cross_knees(t, p2, false), alone)
	var was: bool = FT.pin_punch
	FT.pin_punch = true
	var pinned: float = KR.worst_valgus(await _cross_knees(t, p2, false), alone)
	FT.pin_punch = was
	t._check(now <= KNEE_MATCH_M * 100.0 and pinned > now, "KNEEMATCH on the plain cross blue's knees are within %.0f cm of where the take alone puts them (worst %.1f cm; with the feet pinned through the punch %.1f cm)" % [KNEE_MATCH_M * 100.0, now, pinned])
	p2.guard(1)
	var swing := [0.0, 0.0]     # the widest a glove swings against its own forearm: as shipped, and with the move off the face
	for arm in 2:
		for i in 2:
			(t.st.boxers[i]["gloves"] as Node).set("face_clear", arm == 1)
		var lo := {}
		var hi := {}
		for f in 300:
			await t.process_frame
			for i in (2 if f >= 60 else 0):
				for side in ["Left", "Right"]:
					var g: Node3D = (t.st.boxers[i]["gloves"] as Node).gloves["l" if side == "Left" else "r"]
					var a := rad_to_deg(g.global_transform.basis.y.angle_to(t._w(i, side + "Hand") - t._w(i, side + "LowerArm")))
					lo[[i, side]] = minf(float(lo.get([i, side], 999.0)), a)
					hi[[i, side]] = maxf(float(hi.get([i, side], -999.0)), a)
		for k in lo:
			swing[arm] = maxf(float(swing[arm]), float(hi[k]) - float(lo[k]))
	for i in 2:
		(t.st.boxers[i]["gloves"] as Node).set("face_clear", false)
	t._check(float(swing[0]) <= GLOVE_SWING_DEG and float(swing[1]) > float(swing[0]), "GLOVEMATCH over 4 s of the waiting guard no glove swings more than %.0f deg against its own forearm (%.1f deg; with the move off the face %.1f)" % [GLOVE_SWING_DEG, swing[0], swing[1]])
