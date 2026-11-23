extends SceneTree
## FIGHTPLAYER2 phase 3: the v2 player's rulers, headless (no picture needed: clips, bones and the kept layers run).
## Two DIFFERENT bodies play real RoundScript exchanges through Player2 at 60 frames a second; every frame is read AS
## DRAWN (after every modifier). Bars from the scope (section 5 + 8) and the r14 critics:
##   LANDS    a landed punch's glove front is within ON_M of the face (ribs) on its contact frame (median, worst)
##   SHORT    a missed punch's glove is NOT on him; a blocked one does not pass his guard line
##   JUMPS    no head moves more than 12 cm in 1/30 s outside a contact
##   SLIDE    a standing foot travels under 1 m in a 30 s exchange
##   FLOOR    no ball or ankle goes more than SINK_M under where it stands in his guard (S540 MOTIONRULERS1: human_feet_test's
##            bar, carried here when that ruler of the old player left the nightly list)
##   REST     with no punch within 1.5 s the pelvises are at the edge of range (ChoreoRules.REST_M - 0.22 .. + 0.3: past the longest jab's 1.04 m)
##   APART    no head inside the other man's head or chest
##   COUNTS   the plan lands what the round landed
##   HANDS    while a man is hit his wrists stay near their guard distance to his head (the guard goes with the head)
##   GAZE     on every cross take v2 plays, blue's face is within GAZE_DEG of red's head around the contact (FP2POSE1)
##   FEET     ... and his feet never cross: the left foot stays FEET_M to the left of the right, across the fight's line
##   HEEL     ... and at the contact his rear heel is up: the rear ankle rides HEEL_M higher over the ball of the foot
##            than in his guard, on every take (FP2POSE2; `-- fp2nocrosslegs` = the takes as bought: red). FP2POSE3: the
##            rear hooks and rear uppercuts v2 plays are read too (the actor's own heel: they are not re-baked)
##   KNEE     ... and the rear knee goes with the hips: at the contact it points KNEE_IN_DEG or more INSIDE its own toes
##            and is under KNEE_OUT_M further out of the hip-foot line than in his guard (FP2POSE3, the owner: "twists knee
##            unnaturally outwards"; the captured crosses hold it 24-51 deg inside; `-- fp2nocrosslegs` reads the actor's)
##   STANCE   in his guard each man stands STANCE_MIN_M..STANCE_MAX_M long along the line to the other (ankle to ankle), his
##            chest within CHEST_M of over his hips (FP2POSE3, owner C458; `-- fp2nostance` = the actor's short stance: red)
##   DRIVE    ... and the punch is DRIVEN: by the contact his hips are DRIVE_M or more toward the other man than in his
##            guard (cross, rear hook, rear uppercut) and the rear knee has straightened DRIVE_KNEE_DEG from its deepest
##            in the load on a cross, DRIVE_KNEE_REAR_DEG on a rear hook or uppercut (FP2POSE4; `-- fp2nodrive`: red)
##   KNEEMATCH  (S537 KNEEROOT1, owner C462 "the original clip is fine") on the plain cross, once the join is over, each
##            knee is within KNEE_MATCH_M of where the take ALONE puts it (off its hip-ankle line; every layer off = the
##            bought take as baked). `-- fp2pinpunch` = the feet pinned through the punch as before: red (8-10 cm)
##   GLOVEMATCH (C464, C466 "reds gloves move on their own") over 4 s of the waiting guard each glove stays on its own
##            forearm's line: it swings GLOVE_SWING_DEG at most (with the move off the face it swung 14-34 deg: the control)
## A bar v2 does not hold YET prints as DEBT with its number and fails only past a guard (it may not get worse).
## Run: <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/player2_test.gd [-- seed=7 rounds=2 show]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const RS := preload("res://scripts/rules/RoundScript.gd")
const R := preload("res://scripts/fight3d/v2/ChoreoRules.gd")
const Player2 := preload("res://scripts/fight3d/v2/Player2.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const RootPath := preload("res://scripts/fight3d/v2/RootPath.gd")
const Match := preload("res://tests/player2_match.gd")
const HZ := 60.0
const ON_M := 0.12
const SINK_M := 0.03
const SINK_BONES := ["LeftToes", "RightToes", "LeftFoot", "RightFoot"]
const HANDS_M := 0.12        # a hit man's wrist may be this much further from his head than in his guard
## FP2POSE1 (owner C454: "where the fuck is he looking at"): a boxer's eyes stay on the target through a cross, the chin
## behind the punching shoulder - the face a few degrees off the other man, not riding the shoulders (the raw take: 76).
const GAZE_DEG := 25.0
const FEET_M := 0.10
## FP2POSE2 (owner C454: "wtf is that legs doing"): a cross is driven off the ball of the rear foot - the heel comes up
## and the foot turns in with the hips. As bought the rear ankle rises 0-3 cm at the contact (the actor is flat-footed).
const HEEL_M := 0.025
## FP2POSE3 (owner S537 on the FP2POSE2 film: "blue fighter twists knee unnaturally outwards when he throws", "the power
## does not come from twisting the knee"): in every captured cross with a leg drive the knee stays inside the toes
## (Mixamo Cross_Punch -41 deg, Cross_Punch__A -24, our own plain take -51) and comes IN toward the hip-foot line
## (19.6 -> 11.5 cm, 18.7 -> 1.3). The FP2POSE2 bake left it +1 to +14 deg OUTSIDE the toes on 6 of 9 takes.
## FP2POSE3 (owner C458: "looks like a weak 12 year old kid"): a boxing stance is 1 to 1.5 shoulder widths long, 45-65 cm
## on our bodies (K46 section 6: Dempsey's rear heel ~46 cm behind the lead heel at 5'10"); the Punch PRO actor's is 37-38.
const STANCE_MIN_M := 0.45
const STANCE_MAX_M := 0.65
const CHEST_M := 0.06
const KNEE_IN_DEG := 8.0
const KNEE_OUT_M := 0.07      # (as drawn: the actor's own 1.5-6.9 cm, the FP2POSE2 bake 2.5-10.2 with 5 takes over 7, the captured-rule bake 3.0-6.3)
## FP2POSE4 (owner S537: "the power does not come from twisting the knee use our research/clips"): a real cross is pushed
## off the rear foot - hips 27.8 +- 6 cm forward by the impact, the rear knee extending ~25 deg through the drive (Cheraghi
## 2014); CROSS_POWER_S439 fix 3 asks 10-18 cm. As bought: hips 0-3 cm, the knee BENDS 1-16 deg into the contact.
const DRIVE_M := 0.10
const DRIVE_KNEE_DEG := 15.0
const DRIVE_KNEE_REAR_DEG := 5.0   # rear hooks and uppercuts: no study gives theirs; the bar is "it straightens, never bends, into the contact" (as bought 3-32)
const BONES := ["Hips", "Head", "Chest", "LeftToes", "RightToes", "LeftHand", "RightHand", "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot", "LeftUpperLeg", "RightUpperLeg", "UpperChest", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm"]

var failures := 0
var st: Node3D
var shown: Array = [{}, {}]
var heads: Array = [Basis.IDENTITY, Basis.IDENTITY]   # each head as drawn (skeleton space)


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
	print(("PASS " if ok else "FAIL ") + what)


func _debt(ok: bool, guard: bool, what: String) -> void:
	if not guard:
		failures += 1
	print(("PASS " if ok else ("DEBT " if guard else "FAIL ")) + what)


func _w(i: int, bone: String) -> Vector3:
	return (st.boxers[i]["skel"] as Skeleton3D).global_transform * (shown[i].get(bone, Vector3.ZERO) as Vector3)


## The face (the lower face: mouth and chin, where a punch is aimed) and the ribs of boxer i, as drawn.
func _target(i: int, body: bool) -> Vector3:
	var fwd: Vector3 = (st.boxers[i]["node"] as Node3D).global_transform.basis.z.normalized()
	var s: float = (st.boxers[i]["node"] as Node3D).scale.x
	if body:
		return _w(i, "Chest") + (fwd * 0.11 + Vector3.DOWN * 0.14) * s
	return _w(i, "Head") + (fwd * 0.09 + Vector3.UP * 0.02) * s


## The rear knee of boxer i as drawn, seen from above: [how far it is out of the hip-foot line, away from the other leg
## along his hip line (m, his own size), where it points against his own toes (deg, - = inside them)].
func _knee(i: int, rear: String) -> Array:
	var lead := "Left" if rear == "Right" else "Right"
	var h := _w(i, rear + "UpperLeg")
	var k := _w(i, rear + "LowerLeg")
	var a := _w(i, rear + "Foot")
	var outw := h - _w(i, lead + "UpperLeg")
	outw = Vector3(outw.x, 0.0, outw.z).normalized()
	var on_line := h + (a - h) * clampf((k.y - h.y) / minf(a.y - h.y, -0.01), 0.0, 1.0)   # the hip-foot line at the knee's height
	var ax := (a - h).normalized()
	var pole := (k - h) - ax * (k - h).dot(ax)
	var toe := _w(i, rear + "Toes") - a
	toe = Vector3(toe.x, 0.0, toe.z)
	var s := 1.0 if toe.signed_angle_to(outw, Vector3.UP) >= 0.0 else -1.0
	return [outw.dot(k - on_line) / (st.boxers[i]["node"] as Node3D).scale.x, s * rad_to_deg(toe.signed_angle_to(Vector3(pole.x, 0.0, pole.z), Vector3.UP))]


func _bend(i: int, side: String) -> float:
	var k := _w(i, side + "LowerLeg")
	return rad_to_deg((_w(i, side + "UpperLeg") - k).angle_to(_w(i, side + "Foot") - k))


## Boxer i's stance as drawn: [its length along the line to the other man (ankle to ankle, m, his own size), how far
## his chest is ahead of his hips along it (m)].
func _stance(i: int) -> Array:
	var axis: Vector3 = (st.boxers[1 - i]["node"] as Node3D).global_position - (st.boxers[i]["node"] as Node3D).global_position
	axis = Vector3(axis.x, 0.0, axis.z).normalized()
	var s: float = (st.boxers[i]["node"] as Node3D).scale.x
	return [absf(axis.dot(_w(i, "LeftFoot") - _w(i, "RightFoot"))) / s, axis.dot(_w(i, "UpperChest") - _w(i, "Hips")) / s]


## GAZE and FEET: blue throws every cross take v2 plays, alone, from his guard (no plan: the take as the player shows it).
func _pose(p2: Node) -> void:
	var rows: Dictionary = p2.db.get("rows", {})
	var ap: AnimationPlayer = st.boxers[1]["ap"]
	var sk: Skeleton3D = st.boxers[1]["skel"]
	var node: Node3D = st.boxers[1]["node"]
	var sb := sk.global_transform.basis.orthonormalized()
	var rest_inv := sk.get_bone_global_rest(sk.find_bone("Head")).basis.orthonormalized().inverse()
	var rl: Vector3 = sb * (sk.get_bone_global_rest(sk.find_bone("LeftFoot")).origin - sk.get_bone_global_rest(sk.find_bone("RightFoot")).origin)
	var sgn := 1.0 if rl.dot(node.global_transform.basis.x) >= 0.0 else -1.0
	var worst := 0.0
	var worst_take := ""
	var feet := 9.0
	var feet_take := ""
	var heel := 9.0
	var heel_take := ""
	var heel_n := 0
	var knee_in := -999.0       # the least inside its toes the rear knee is at a contact (deg, - = inside)
	var knee_in_take := ""
	var knee_out := -9.0        # the most the rear knee is further out of the hip-foot line than in the guard (m)
	var knee_out_take := ""
	var dr := [9.0, "", 999.0, "", 999.0, ""]   # DRIVE: least hips forward, least knee extension on a cross, on the others
	var lens: Array = [_stance(0)[0]]     # every guard read: red's as the bout opens, blue's before each cross
	var chest := absf(float(_stance(0)[1]))
	var n := 0
	var mark: Vector3 = p2._home[1]
	for name in rows:
		var r: Dictionary = rows[name]
		var fam := str(r.get("family", ""))
		if not fam in ["cross", "rear_hook", "rear_uppercut"] or not bool(r.get("played", false)) or not (r.get("drop", []) as Array).is_empty() or not ap.has_animation(str(name)):
			continue
		n += 1 if fam == "cross" else 0
		p2.guard(1)
		for f in 70:                # (a driven take leaves him 10-19 cm on and no plan walks it off here: back to his mark)
			p2._home[1] = (p2._home[1] as Vector3).lerp(mark, 0.2)
			await process_frame
		var to0: Vector3 = (st.boxers[0]["node"] as Node3D).global_position - node.global_position
		var rear := "Right" if to0.dot(_w(1, "RightFoot") - _w(1, "LeftFoot")) < 0.0 else "Left"
		var flat_h := _w(1, rear + "Foot").y - _w(1, rear + "Toes").y
		var up := -9.0
		var k0 := _knee(1, rear)
		var hips_g := _w(1, "Hips")
		var bend := [999.0, 0.0]    # the rear knee at its deepest up to the contact, and at the contact
		var fw := -9.0
		if fam == "cross":
			lens.append(_stance(1)[0])
		if OS.get_cmdline_user_args().has("show") and fam == "cross":
			print("  guard before %-26s %.0f cm long (red opened %.0f), chest %+.0f cm ahead of the hips" % [name, float(lens[-1]) * 100.0, float(lens[0]) * 100.0, float(_stance(1)[1]) * 100.0])
		chest = maxf(chest, absf(float(_stance(1)[1])))
		var kin := 999.0
		var kout := 9.0
		p2._play(1, str(name), 0.0, "punch", fam == "cross")   # (a hook that steps is read in place: its travel would leave him inside red as the bout opens)
		var cs := float(r.get("contact_s", 0.3))
		var own := Vector3.ZERO     # a take read in place: what it travels itself by the contact counts
		if fam != "cross":
			var rp := RootPath.of(ap.get_animation(str(name)))
			own = RootPath.world(sk.global_transform.basis, RootPath.at(rp, cs) - RootPath.at(rp, 0.0))
		for f in int((cs + 0.2) * HZ):
			await process_frame
			if str(ap.current_animation) != str(name):
				break
			var tt := ap.current_animation_position
			var axis: Vector3 = (st.boxers[0]["node"] as Node3D).global_position - node.global_position
			axis = Vector3(axis.x, 0.0, axis.z).normalized()
			var across := sgn * Vector3.UP.cross(axis).dot(_w(1, "LeftFoot") - _w(1, "RightFoot"))
			if tt <= cs + 0.04:
				bend[0] = minf(float(bend[0]), _bend(1, rear))
			if absf(tt - cs) <= 0.04:
				bend[1] = maxf(float(bend[1]), _bend(1, rear))
				fw = maxf(fw, axis.dot(_w(1, "Hips") + own - hips_g) / node.scale.x)
			if across < feet and fam == "cross":
				feet = across
				feet_take = str(name)
			if absf(tt - cs) <= 0.04:
				up = maxf(up, (_w(1, rear + "Foot").y - _w(1, rear + "Toes").y - flat_h) / node.scale.x)
				var kc := _knee(1, rear)
				kin = minf(kin, float(kc[1]))
				kout = minf(kout, float(kc[0]) - float(k0[0]))
			if tt < cs - 0.10 or tt > cs + 0.05 or fam != "cross":
				continue
			sb = sk.global_transform.basis.orthonormalized()
			var face: Vector3 = sb * ((heads[1] as Basis) * rest_inv * (sb.inverse() * node.global_transform.basis.orthonormalized().z))
			var to := _w(0, "Head") - _w(1, "Head")
			var off := absf(rad_to_deg(Vector3(to.x, 0.0, to.z).signed_angle_to(Vector3(face.x, 0.0, face.z), Vector3.UP)))
			if off > worst:
				worst = off
				worst_take = str(name)
		if up < heel:
			heel = up
			heel_take = str(name)
		heel_n += 1
		if kin > knee_in and fam == "cross":
			knee_in = kin
			knee_in_take = str(name)
		if kout > knee_out and fam == "cross":
			knee_out = kout
			knee_out_take = str(name)
		var ext := float(bend[1]) - float(bend[0])
		if fw < float(dr[0]):
			dr[0] = fw
			dr[1] = str(name)
		var di := 2 if fam == "cross" else 4
		if ext < float(dr[di]):
			dr[di] = ext
			dr[di + 1] = str(name)
		if OS.get_cmdline_user_args().has("show"):
			print("  drive %-26s hips %+.1f cm forward by the contact, rear knee %.0f at its deepest -> %.0f at the contact (%+.0f deg)" % [name, fw * 100.0, bend[0], bend[1], ext])
			print("  pose %-26s heel %+.1f cm, rear knee %+.0f deg from its toes, %+.1f cm out of the hip-foot line against the guard's %.1f" % [name, up * 100.0, kin, kout * 100.0, float(k0[0]) * 100.0])
	p2.guard(1)
	for f in 70:
		p2._home[1] = (p2._home[1] as Vector3).lerp(mark, 0.2)
		await process_frame
	_layer(not load("res://scripts/fight3d/v2/Stance.gd").off, n > 0 and float(lens.min()) >= STANCE_MIN_M and float(lens.max()) <= STANCE_MAX_M and chest <= CHEST_M, "STANCE in the guard a man stands %.0f-%.0f cm long along the line (%.0f..%.0f cm over %d guards), his chest within %.0f cm of over his hips (%.0f cm at most)" % [STANCE_MIN_M * 100.0, STANCE_MAX_M * 100.0, float(lens.min()) * 100.0, float(lens.max()) * 100.0, lens.size(), CHEST_M * 100.0, chest * 100.0])
	_check(n > 0 and worst <= GAZE_DEG, "GAZE on a cross blue's face stays within %.0f deg of red's head around the contact (worst %.0f deg, %s; %d takes)" % [GAZE_DEG, worst, worst_take, n])
	_check(n > 0 and feet >= FEET_M, "FEET on a cross blue's feet never cross: the left stays %.0f cm to the left of the right (least %.0f cm, %s)" % [FEET_M * 100.0, feet * 100.0, feet_take])
	_layer(not load("res://scripts/fight3d/v2/CrossLegs.gd").off, n > 0 and knee_in <= -KNEE_IN_DEG and knee_out <= KNEE_OUT_M, "KNEE on a cross blue's rear knee goes with his hips: %.0f deg or more inside its toes at the contact (least %+.0f deg, %s) and under %.0f cm further out of the hip-foot line than in his guard (most %+.1f cm, %s)" % [KNEE_IN_DEG, knee_in, knee_in_take, KNEE_OUT_M * 100.0, knee_out * 100.0, knee_out_take])
	_layer(not load("res://scripts/fight3d/v2/Drive.gd").off, n > 0 and float(dr[0]) >= DRIVE_M and float(dr[2]) >= DRIVE_KNEE_DEG and float(dr[4]) >= DRIVE_KNEE_REAR_DEG, "DRIVE a cross, a rear hook and a rear uppercut are driven: blue's hips %.0f cm or more toward red by the contact (least %+.1f cm, %s), his rear knee straightening %.0f deg from its deepest on a cross (least %+.0f, %s), %.0f on the others (least %+.0f, %s)" % [DRIVE_M * 100.0, float(dr[0]) * 100.0, dr[1], DRIVE_KNEE_DEG, float(dr[2]), dr[3], DRIVE_KNEE_REAR_DEG, float(dr[4]), dr[5]])
	_layer(not load("res://scripts/fight3d/v2/CrossLegs.gd").off, n > 0 and heel >= HEEL_M, "HEEL on a cross, a rear hook and a rear uppercut blue's rear heel is up at the contact: the ankle %.1f cm or more higher over the ball than in his guard (least %.1f cm, %s; %d takes)" % [HEEL_M * 100.0, heel * 100.0, heel_take, heel_n])


func _initialize() -> void:
	Engine.max_fps = int(HZ)
	var sd := 7
	var rounds := 2
	var show := OS.get_cmdline_user_args().has("show")
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("seed="):
			sd = int(str(a).substr(5))
		if str(a).begins_with("rounds="):
			rounds = int(str(a).substr(7))
	Player2.force = true
	FightClips.untouched = true
	st = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_12.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_07.glb", "corner": "blue"})
	if st.v2 == null:
		print("PLAYER2 the v2 player was not built")
		print("PLAYER2 failures=1")
		quit(1)
		return
	for i in 2:
		var sk: Skeleton3D = st.boxers[i]["skel"]
		var ids: Array = BONES.map(func(b): return sk.find_bone(str(b)))
		var d: Dictionary = shown[i]
		sk.skeleton_updated.connect(func():
			heads[i] = sk.get_bone_global_pose(sk.find_bone("Head")).basis.orthonormalized()
			for k in BONES.size():
				d[BONES[k]] = sk.get_bone_global_pose(int(ids[k])).origin)
		var names: Array = []
		for c in sk.get_children():
			if c is SkeletonModifier3D and (c as SkeletonModifier3D).active:
				names.append(str(c.name))
		print("PLAYER2 boxer %d layers on: %s" % [i, " ".join(names)])
	for i in 30:
		await process_frame
	var p2: Node = st.v2
	await _pose(p2)
	await load("res://tests/player2_match.gd").run(self, p2)   # KNEEMATCH, GLOVEMATCH
	var miss: Array = []        # landed: glove front to target (m)
	var straight: Array = []    # landed jabs and crosses: how straight the punching arm is on the contact picture (0..1)
	var short_on := 0           # missed punches whose glove is on him
	var short_n := 0
	var jumps := 0
	var slide := [0.0, 0.0]
	var rest: Array = []
	var inside := 0
	var landed_plan := 0
	var landed_want := 0
	var frames := 0
	var seen := 0
	var pend: Array = []
	var glove_at: Array = [{"LeftHand": Vector3.ZERO, "RightHand": Vector3.ZERO}, {"LeftHand": Vector3.ZERO, "RightHand": Vector3.ZERO}]
	var slide_by := {}
	var glove_was: Array = [{"LeftHand": [9.0, 9.0], "RightHand": [9.0, 9.0]}, {"LeftHand": [9.0, 9.0], "RightHand": [9.0, 9.0]}]
	var prev_head: Array = [[], []]
	var prev_ball: Array = [[null, null], [null, null]]
	var floor_y := [[0.0, 0.0], [0.0, 0.0]]
	var sink_y := [[], []]
	var deep := [0.0, "", 0]   # the deepest joint under its guard height: metres, where, frames past SINK_M
	var guard_d: Array = [{"LeftHand": [], "RightHand": []}, {"LeftHand": [], "RightHand": []}]   # wrist to head in the guard
	var react_d: Array = []     # [boxer, hand, take, wrist to head, seconds into the reaction]
	for i in 2:
		var sk2: Skeleton3D = st.boxers[i]["skel"]
		for k in 2:
			floor_y[i][k] = _w(i, ["LeftToes", "RightToes"][k]).y   # the ball as it stands in the guard (FloorStand puts it on the canvas)
		for bn in SINK_BONES:
			sink_y[i].append(_w(i, bn).y)
	for rn in rounds:
		var round := {"n": 1, "won": rn % 2 == 0, "mine": 60.0, "theirs": 55.0, "corner": "", "lines": []}
		var beats: Array = RS.build(round, "Slugger", "Boxer", 30.0, sd + rn)["beats"]
		var t0 := float(rn) * 30.0
		for b in beats:
			b["t"] = float(b["t"]) + t0
			if str(b["result"]) == "lands" and R.is_punch(str(b["move"])):
				landed_want += 1
		p2.queue(beats, t0, t0 + 30.0)
		for side in ["a", "b"]:
			landed_plan += int(p2.plan["counts"][side]["landed"])
		var cts: Array = (p2.plan["beats"] as Array).filter(func(b): return R.is_punch(str(b["move"])) and not bool(b["cut"])).map(func(b): return float(b["contact_t"]))
		var t := t0
		while t < t0 + 30.0:
			p2.clock(t, true)
			await process_frame
			t += 1.0 / HZ
			frames += 1
			var near := false
			var at_contact := false
			for c in cts:
				near = near or absf(float(c) - t) < 1.5
				at_contact = at_contact or absf(float(c) - t) < 0.12
			while seen < (p2.contacts as Array).size():
				var c0: Dictionary = p2.contacts[seen]
				seen += 1
				var hitter := 0 if str(c0["who"]) == "a" else 1
				var row: Dictionary = p2.db["rows"].get(str(c0["take"]), {})
				var hand: String = st.hand_of(hitter, str(row.get("hand", "LeftHand")))
				var body := str(c0["move"]) == "body_hook"
				var c: Dictionary = c0
				var off0: float = minf(st.glove_front(hitter, hand).distance_to(_target(1 - hitter, body)), float(glove_was[hitter][hand][1 if body else 0]))
				pend.append([3, c, hitter, hand, body, off0])
			for pd in pend:
				pd[0] = int(pd[0]) - 1
				if int(pd[0]) == 2 and str(pd[1]["result"]) == "lands" and R.is_straight(str(pd[1]["move"])):
					straight.append(Match.straight(self, int(pd[2]), str(pd[3])))   # the picture of the contact
				var tg: Vector3 = _target(1 - int(pd[2]), bool(pd[4]))
				var g1: Vector3 = st.glove_front(int(pd[2]), str(pd[3]))
				var g0: Vector3 = glove_at[int(pd[2])][str(pd[3])]
				var vec: Vector3 = tg - Geometry3D.get_closest_point_to_segment(tg, g0, g1)   # a hook's glove covers 20 cm a frame: read its path
				if vec.length() <= float(pd[5]) + 0.0001:
					pd[5] = vec.length()
					var nb: Basis = (st.boxers[int(pd[2])]["node"] as Node3D).global_transform.basis.orthonormalized()
					pd.resize(7)
					pd[6] = "fwd %+.2f side %+.2f up %+.2f f%d" % [vec.dot(nb.z), vec.dot(nb.x), vec.y, 3 - int(pd[0])]
			while not pend.is_empty() and int(pend[0][0]) <= 0:
				var pd0: Array = pend.pop_front()
				var c: Dictionary = pd0[1]
				var off: float = float(pd0[5])
				if str(c["result"]) == "lands":
					miss.append(off)
				elif str(c["result"]) == "misses":
					short_n += 1
					short_on += 1 if off < 0.05 else 0
				if show:
					print("  contact %6.2f %s %-13s %-8s %-26s gap %.2f glove off %.2f aim %.2f" % [float(c["t"]), c["who"], c["move"], c["result"], c["take"], float(c["gap"]), off, float(p2._aim[int(pd0[2])].last_m)], " left %.2f late %+.3f " % [float(p2._aim[int(pd0[2])].left_m), float(c.get("late_s", 0.0))], pd0[6] if pd0.size() > 6 else "before")
			for i in 2:
				for hand in ["LeftHand", "RightHand"]:   # the gloves of last frame (the contact falls between two frames)
					glove_at[i][hand] = st.glove_front(i, hand)
					glove_was[i][hand] = [st.glove_front(i, hand).distance_to(_target(1 - i, false)), st.glove_front(i, hand).distance_to(_target(1 - i, true))]
			for i in 2:
				var tk: Dictionary = p2._take[i]
				for hand in ["LeftHand", "RightHand"]:
					var dh: float = (shown[i][hand] as Vector3).distance_to(shown[i]["Head"])
					if str(tk.get("kind", "")) == "guard":
						(guard_d[i][hand] as Array).append(dh)
					elif str(tk.get("kind", "")) == "reaction":
						react_d.append([i, hand, str(tk.get("clip", "")), dh, t - float(tk.get("at", t))])
			for i in 2:
				var head := _w(i, "Head")
				var hist: Array = prev_head[i]
				hist.append(head)
				if hist.size() > 3:
					hist.pop_front()
				if hist.size() == 3 and (hist[2] as Vector3).distance_to(hist[0]) > 0.12 and not at_contact:
					jumps += 1
					if show:
						print("  head jump %6.2f boxer %d %.2f m clip %s" % [t, i, (hist[2] as Vector3).distance_to(hist[0]), (st.boxers[i]["ap"] as AnimationPlayer).current_animation])
				for k in SINK_BONES.size():
					var under: float = float(sink_y[i][k]) - _w(i, SINK_BONES[k]).y
					deep[2] = int(deep[2]) + (1 if under > SINK_M else 0)
					if under > float(deep[0]):
						deep = [under, "boxer %d %s in %s at %.2f s" % [i, SINK_BONES[k], (st.boxers[i]["ap"] as AnimationPlayer).current_animation, t], deep[2]]
				var slips: Array = []   # the stiller foot that stands is the support foot: what IT travels is slide
				for k in 2:
					var ball := _w(i, ["LeftToes", "RightToes"][k])
					var last: Variant = prev_ball[i][k]
					if last != null and ball.y < float(floor_y[i][k]) + 0.008 and (last as Vector3).y < float(floor_y[i][k]) + 0.008:
						slips.append(Vector2(ball.x - (last as Vector3).x, ball.z - (last as Vector3).z).length())
					prev_ball[i][k] = ball
				if not slips.is_empty():
					slide[i] = float(slide[i]) + float(slips.min())
					var ck := str((st.boxers[i]["ap"] as AnimationPlayer).current_animation)
					slide_by[ck] = float(slide_by.get(ck, 0.0)) + float(slips.min())
				var oh := _w(1 - i, "Head")
				var oc := _w(1 - i, "Chest")
				if head.distance_to(oh) < 0.16 or head.distance_to(oc) < 0.18:
					inside += 1
			if not near:
				rest.append(Vector2(_w(0, "Hips").x - _w(1, "Hips").x, _w(0, "Hips").z - _w(1, "Hips").z).length())
	miss.sort()
	rest.sort()
	if show:
		var keys: Array = slide_by.keys()
		keys.sort_custom(func(x, y): return float(slide_by[x]) > float(slide_by[y]))
		for k in keys.slice(0, 12):
			print("  slide %-30s %.2f m" % [k, float(slide_by[k])])
	# HANDS (owner C435 on film 15: "reds hands are not moving with the reaction"): while a man is hit each wrist stays
	# within HANDS_M of where his guard keeps it from his head - the guard goes with the head that was hit.
	var away_worst := 0.0
	var away_n := 0
	var away_by := {}
	for i in 2:
		for hand in ["LeftHand", "RightHand"]:
			(guard_d[i][hand] as Array).sort()
	for rd in react_d:
		var gd: Array = guard_d[int(rd[0])][str(rd[1])]
		var away: float = float(rd[3]) - (float(gd[gd.size() / 2]) if not gd.is_empty() else 0.25)
		away_worst = maxf(away_worst, away)
		away_n += 1 if away > HANDS_M else 0
		away_by[str(rd[2])] = maxf(float(away_by.get(str(rd[2]), 0.0)), away)
	if show:
		for k in away_by:
			print("  hands %-30s a wrist up to %+.2f m further from the head than in the guard" % [k, float(away_by[k])])
		for i in 2:
			for hand in ["LeftHand", "RightHand"]:
				var gd2: Array = guard_d[i][hand]
				print("  guard boxer %d %s wrist to head %.2f m (median of %d frames)" % [i, hand, float(gd2[gd2.size() / 2]) if not gd2.is_empty() else 0.0, gd2.size()])
	var med: float = float(miss[miss.size() / 2]) if not miss.is_empty() else 9.0
	var on_n := miss.filter(func(m): return float(m) <= ON_M).size()
	print("PLAYER2 frames %d landed %d: glove off the target median %.3f m, worst %.3f m, within %.2f m %d of %d" % [frames, miss.size(), med, float(miss[-1]) if not miss.is_empty() else 9.0, ON_M, on_n, miss.size()])
	print("PLAYER2 misses %d (glove on him anyway %d) head jumps %d foot slide %.2f / %.2f m per %d s rest %.2f..%.2f m (%d frames) heads inside %d frames" % [short_n, short_on, jumps,
		float(slide[0]), float(slide[1]), rounds * 30, float(rest[0]) if not rest.is_empty() else 0.0, float(rest[-1]) if not rest.is_empty() else 0.0, rest.size(), inside])
	_check(landed_plan == landed_want, "COUNTS the plan lands what the round landed (%d of %d)" % [landed_plan, landed_want])
	_check(miss.size() >= landed_want * 0.9, "LANDS at least 9 landed punches in 10 reach their contact uncut (%d of %d)" % [miss.size(), landed_want])
	_check(med <= ON_M, "LANDS the median landed glove is within %.2f m of its target (%.3f)" % [ON_M, med])
	_debt(on_n >= miss.size() * 0.9, on_n >= miss.size() * 0.7, "LANDS 9 landed gloves in 10 are within %.2f m (%d of %d; guard 7 in 10)" % [ON_M, on_n, miss.size()])
	straight.sort()
	_check(not straight.is_empty() and float(straight[straight.size() / 2]) >= Match.STRAIGHT_MIN, "ARMSTRAIGHT a landed jab or cross arrives with its arm out: the median is at least %.0f%% straight (%.0f%%, least %.0f%%, %d punches)" % [Match.STRAIGHT_MIN * 100.0, (float(straight[straight.size() / 2]) if not straight.is_empty() else 0.0) * 100.0, (float(straight[0]) if not straight.is_empty() else 0.0) * 100.0, straight.size()])
	_check(short_on == 0, "SHORT no missed punch has its glove on him (%d of %d)" % [short_on, short_n])
	_debt(jumps == 0, jumps <= 6 * rounds, "JUMPS no head moves over 12 cm in 1/30 s outside a contact (%d; guard %d)" % [jumps, 6 * rounds])
	_debt(float(slide[0]) <= 1.0 * rounds and float(slide[1]) <= 1.0 * rounds, maxf(float(slide[0]), float(slide[1])) <= 6.0 * rounds, "SLIDE a standing foot travels under 1 m an exchange (%.2f / %.2f over %d; guard 6 m: 5 until S537 KNEEROOT1 gave a punch its own feet back, docs/KNEEROOT1_RESULT.md)" % [float(slide[0]), float(slide[1]), rounds])
	_check(float(deep[0]) <= SINK_M, "FLOOR no ball or ankle goes more than %.0f cm under where it stands in his guard (deepest %.1f cm, %s; %d frames over)" % [SINK_M * 100.0, float(deep[0]) * 100.0, deep[1], int(deep[2])])
	_check(not rest.is_empty() and float(rest[0]) >= R.REST_M - 0.35 and float(rest[-1]) <= R.REST_M + 0.3, "REST out of reach between bursts (%.2f..%.2f m)" % [float(rest[0]) if not rest.is_empty() else 0.0, float(rest[-1]) if not rest.is_empty() else 0.0])
	_check(not react_d.is_empty() and away_n == 0, "HANDS a hit man's wrists stay within %.2f m of their guard distance to his head (%d of %d frames over, worst %+.2f m)" % [HANDS_M, away_n, react_d.size(), away_worst])
	_check(inside == 0, "APART no head inside the other man (%d frames)" % inside)
	print("PLAYER2 failures=%d" % failures)
	quit(0 if failures == 0 else 1)


## S537 owner "ok switch off" (C461): STANCE / KNEE / DRIVE / HEEL test the leg bakes; with a bake off the legs play as
## recorded and its check is skipped (said, not hidden). FEET and GAZE still run.
func _layer(on: bool, ok: bool, msg: String) -> void:
	if on:
		_check(ok, msg)
	else:
		print("SKIP %s (leg bake off: legs as recorded, owner S537)" % msg.get_slice(" ", 0))
