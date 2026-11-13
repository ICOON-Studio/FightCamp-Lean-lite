extends SceneTree
## POWER1 step 3, review round 2 (blind review of beeea8f2: "blocks are now set late"). A lone punch now starts past its
## dead wind-up (PunchPace start offsets) and stands in her guard first, so the time from the punch's start to its contact
## (`at`) can be shorter than the cover-up needs to get its gloves up (MoveStudio.BLOCK_SET_S, 0.25 s of the block clip at
## 1x). BeatFire clamped the block's timer at 0 and started it inside go(), after that guard wait: pro_right_cross_b's
## block was set 0.055 s after the glove arrived, pro_left_jab_hard's 0.107 s.
## This ruler plays BLOCKED punches through BeatFire.fire itself (the fight's own path: the beat, the guard wait, go(),
## the block's timer), the whole stage running at 60 frames a second, and reads the blocker on the first frame the punch's
## clip is at its contact (one frame short counts: the hit's timer leads it by PunchPace.LEAD_S):
##   SET   the blocker plays her block clip and it is at least BLOCK_SET_S - one frame into it (its gloves are up).
## Every punch the fight can block on a head line, fast ones first (the plain jab, jab hard, cross b). Two DIFFERENT
## bodies (mh_boxer_08 against mh_boxer_13). 3D only: no rule is read or changed.
## Run: <godot> --headless --audio-driver Dummy --path . --script res://tests/block_set_test.gd   [-- only=<clip>]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const BeatFire := preload("res://scripts/fight3d/BeatFire.gd")
const MoveStudio := preload("res://scripts/fight3d/MoveStudio.gd")
const HZ := 60.0
const MOVES := ["jab", "cross", "lead_hook", "rear_hook"]
const FAST := ["pro_left_jab", "pro_left_jab_hard", "pro_right_cross_b"]


class FakeBody extends RefCounted:
	func land(_b: Dictionary, _at: float) -> void:
		pass


## The few things BeatFire reads off the FightView.
class FakeView extends Node:
	var stage: Node3D
	var _amb_rng := RandomNumberGenerator.new()
	var t := 0.0
	var _profiles := {}
	var body := FakeBody.new()


var failures := 0
var st: Node3D


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
	print(("PASS " if ok else "FAIL ") + what)


## A seed whose first roll makes BeatClips.punch pick `clip` for `move` (a plain lone punch), or -1.
func _seed_for(move: String, clip: String) -> int:
	for s in 400:
		var r := RandomNumberGenerator.new()
		r.seed = s
		var ctx := {"big": false, "miss": false, "tired": false, "step": false, "roll": r.randf()}
		if BeatClips.punch(move, ctx, st.has_move) == clip:
			return s
	return -1


func _initialize() -> void:
	Engine.max_fps = int(HZ)
	st = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_08.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_13.glb", "corner": "blue"})
	for i in 30:
		await process_frame
	var v := FakeView.new()
	v.stage = st
	root.add_child(v)
	var home := [st.boxers[0]["pos"], st.boxers[1]["pos"]]
	var only := ""
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("only="):
			only = str(a).get_slice("=", 1)
	# The punches: the fast ones named by the review first, then every other plain take a lone punch can pick.
	var pairs: Array = []
	for clip in FAST:
		pairs.append([clip, "jab" if clip.contains("jab") else "cross"])
	for move in MOVES:
		for roll in [0.0, 0.3, 0.55, 0.8, 0.99]:
			var c := BeatClips.punch(str(move), {"big": false, "miss": false, "tired": false, "step": false, "roll": roll}, st.has_move)
			if c.begins_with("pro_") and not pairs.has([c, str(move)]):
				pairs.append([c, str(move)])
	var rate := BeatClips.OTHER_SPEED
	var bar := MoveStudio.BLOCK_SET_S - rate / HZ
	for pair in pairs:
		var clip := str(pair[0])
		var move := str(pair[1])
		if only != "" and clip != only:
			continue
		var sd := _seed_for(move, clip)
		if sd < 0:
			print("SKIP %s (%s): no lone-punch roll picks it" % [clip, move])
			continue
		for i in 2:
			st.boxers[i]["pos"] = home[i]
			st.boxers[i]["vel"] = Vector3.ZERO
			st.guard(i)
		for i in 60:
			await process_frame
		var bf := BeatFire.new()
		v._amb_rng.seed = sd
		v.t = 0.0
		var c := BeatClips.contact(clip, float(Stage.CONTACT.get(move, Stage.CONTACT_S)))
		var ap0: AnimationPlayer = st.boxers[0]["ap"]
		var ap1: AnimationPlayer = st.boxers[1]["ap"]
		bf.fire(v, {"who": "a", "move": move, "result": "blocked", "def": "block", "t": 0.0})
		var seen := false
		var block_pos := -1.0
		var block_clip := ""
		var started := false
		for f in int(2.5 * HZ):
			await process_frame
			if str(ap0.current_animation) == clip:
				started = true
				if ap0.current_animation_position >= c - BeatClips.speed(clip, move) / HZ - 1e-4:
					seen = true
					block_clip = str(ap1.current_animation)
					block_pos = ap1.current_animation_position if block_clip.contains("block") else -1.0
					break
		if not seen:
			_check(false, "SET %s: the punch never reached its contact (started %s)" % [clip, "yes" if started else "no"])
			continue
		print("ROW %s (%s): contact %.3f, the blocker plays %s at %.3f s" % [clip, move, c, block_clip, block_pos])
		_check(block_pos >= bar, "SET %s: when its glove arrives the block is %.3f s into its clip (bar: set, %.3f or more)" % [clip, block_pos, bar])
		for i in 60:
			await process_frame
	print("BLOCK_SET failures=%d" % failures)
	quit(1 if failures > 0 else 0)
