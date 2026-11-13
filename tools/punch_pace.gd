extends SceneTree
## POWER1 step 3: measures every punch clip the fight throws, as it is played (from its start at its pace, BeatClips.speed,
## 60 frames a second, the real arm solve of a landed punch), and writes assets/data/punch_pace.json:
##   start_s  where a lone punch starts: KEEP_S of screen time before the hand moves (counting back from the glove's top
##            speed up to the contact, the frame after the last one under MOVE_SHARE of it: CROSS_POWER_S439.md's rule).
##            The critics' "a cross loads in 1 to 2 tiles" (67-133 ms): the KEEP_S kept is that load. Never into a load
##            under way: the start goes back while the chest moves at LOAD_SHARE or more of its top speed (to the contact).
##   drive_v  jabs, crosses, hooks: the speed (screen m/s) the landing reach drives the glove onto the face at (ReachDrive;
##            the arm alone, the body keeps its pace): of ENDS, the one whose glove top on screen (read as the ruler reads
##            it) comes nearest the middle of its band (jab 7, cross and hooks 8 m/s), the hand starting no later than the
##            undriven punch's (or FIRST_S) counted first; 0 (no drive) for a glove already in its band (jab 6, cross and
##            hooks 7 m/s or more) and for the rest.
## Also kept per row (read only by people): the glove's top on screen (undriven, driven, and the clip alone), where the hand
## and the chest start to move (clip s), and how fast the chest already moves at the new start (share of its top).
## Run (headless; nothing is drawn): <godot> --headless --audio-driver Dummy --path . --script res://tools/punch_pace.gd
##   [-- scan] prints the glove top at every drive tried.

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const PR := preload("res://scripts/fight3d/PunchReach.gd")
const PunchPace := preload("res://scripts/fight3d/PunchPace.gd")
const OUT := "res://assets/data/punch_pace.json"
const HZ := 60.0
const KEEP_S := 0.10
const MOVE_SHARE := 0.15
## Review round 2 (blind review: starts at 0.42-0.49 of the trunk's top speed "arguably cut a real load"): 0.5 -> 0.25.
const LOAD_SHARE := 0.25
## The drive's end speeds tried (screen m/s at the contact).
const ENDS := [7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0]
const FIRST_S := 0.13
const KEEP_F := 6        # KEEP_S in screen frames
const MID := {"jab": 7.0, "cross": 8.0, "lead_hook": 8.0, "rear_hook": 8.0}
const LOW := {"jab": 6.0, "cross": 7.0, "lead_hook": 7.0, "rear_hook": 7.0}   # a glove already this fast is not sped
const ROLLS := [0.0, 0.3, 0.55, 0.8, 0.99]

var st: Node3D
var skel: Skeleton3D
var ap: AnimationPlayer
var reach: Node
var pw: Node
var front := 0.15


func _glove(ids: Array) -> Vector3:
	var g := skel.global_transform
	var wrist: Vector3 = g * skel.get_bone_global_pose(int(ids[2])).origin
	var a: Vector3 = (g * skel.get_bone_global_pose(int(ids[3])).origin - wrist).normalized()
	var arm: Vector3 = (wrist - g * skel.get_bone_global_pose(int(ids[1])).origin).normalized()
	if PR.STRAIGHT > 0.0 and a.angle_to(arm) > 1e-3:
		a = a.slerp(arm, PR.STRAIGHT).normalized()
	return wrist + a * front * g.basis.get_scale().x


## [glove speeds, chest speeds, clip times] per screen frame from `start` to the contact, the reach armed when `armed`,
## played at the pace `sp`, the glove driven onto the face at `v` m/s on screen (ReachDrive; 0 = not driven).
func _series(clip: String, move: String, c: float, sp: float, armed: bool, start: float = 0.0, v: float = 0.0) -> Array:
	var body := move == "body_hook" or clip.contains("kidney") or clip.contains("body")
	var hand: String = st.hand_of(0, str(BeatClips.contact_row(clip).get("hand", "RightHand")))
	var ids := []
	for n in ["UpperArm", "LowerArm", "Hand", "MiddleProximal"]:
		ids.append(skel.find_bone(hand.trim_suffix("Hand") + n))
	var chest := skel.find_bone("Chest")
	ap.play(clip, 0.0, 1.0)
	ap.seek(start, true)
	if pw != null:
		pw.arm(clip)
	reach.set("drive_for", [clip, v / sp, PunchPace.DRIVE_S * sp])
	if armed:
		st.land(0, clip, body, 0.0, c)
	var gp: Array = []
	var cp: Array = []
	var ts: Array = []
	var t := start
	var last := false
	while not last:
		last = t >= c - 1e-6   # up to and including the first frame at or past the contact, as the ruler reads it
		ap.seek(t, true)
		if pw != null:
			pw._process_modification()
		if armed:
			reach.reach_at(t)
			reach.settle()
		gp.append(_glove(ids))
		cp.append(skel.global_transform * skel.get_bone_global_pose(chest).origin)
		ts.append(t)
		t += sp / HZ
	reach.disarm()
	reach.set("drive_for", [])
	reach.set("_fades", {})
	return [_speeds(gp), _speeds(cp), ts]


## Speed into each frame: what the point covered over the last two frames, a second (tests/punch_speed_test.gd reads the
## same way: a one-frame read alternates by 1-2 m/s as the reach solve lands).
func _speeds(g: Array) -> Array:
	var out: Array = [0.0]
	for i in range(1, g.size()):
		var k := mini(i, 2)
		out.append((g[i] as Vector3).distance_to(g[i - k]) * HZ / k)
	return out


## Counting back from the top of `v`, the frame after the last one under MOVE_SHARE of it: [index, top, top index].
func _start(v: Array) -> Array:
	var top := 0.0
	var top_i := 0
	for i in range(1, v.size()):
		if float(v[i]) > top:
			top = float(v[i])
			top_i = i
	var first := 1
	for i in range(top_i, 0, -1):
		if float(v[i]) < MOVE_SHARE * top:
			first = i + 1
			break
	return [first, top, top_i]


## One clip's row.
func _row(clip: String, move: String, scan: bool) -> Dictionary:
	var c := BeatClips.contact(clip, float(Stage.CONTACT.get(move, Stage.CONTACT_S)))
	var sp := BeatClips.speed(clip, move)
	var base := _series(clip, move, c, sp, true)
	var bare := _series(clip, move, c, sp, false)
	var hs := _start(base[0])
	var ls := _start(base[1])
	var top := float(hs[1])
	var ts: Array = base[2]
	var move_s := float(ts[int(hs[0]) - 1])   # the frame the hand's first fast step leaves from
	var load_s := float(ts[int(ls[0]) - 1])
	var si := maxi(0, int(hs[0]) - 1 - KEEP_F)
	# Never into a real load: where the chest already moves at LOAD_SHARE of its top speed (a stepping take's step in, a
	# turn under way), the start goes back a frame at a time until it does not.
	while si > 0 and float((base[1] as Array)[si]) >= LOAD_SHARE * float(ls[1]):
		si -= 1
	var start := minf(float(ts[si]), maxf(0.0, c - 0.15))
	var chest_share := float((base[1] as Array)[si]) / maxf(1e-6, float(ls[1]))
	var drive := 0.0
	var plain := _start(_series(clip, move, c, sp, true, start)[0])
	var driven := float(plain[1])
	var first_bar := maxf(FIRST_S, (int(plain[0]) - 1) / HZ)
	if MID.has(move) and driven > 0.0 and driven < float(LOW[move]):
		var best := absf(driven - float(MID[move]))
		for v in ENDS:
			var r := _start(_series(clip, move, c, sp, true, start, float(v))[0])
			var tx := float(r[1])
			var first_s := (int(r[0]) - 1) / HZ
			if scan:
				print("  SCAN %s end %.0f m/s: top %.2f m/s, hand moves %.3f s" % [clip, float(v), tx, first_s])
			# The hand starting later than the undriven punch's counts as 2 m/s off the band's middle.
			var score := absf(tx - float(MID[move])) + (2.0 if first_s > first_bar + 1e-4 else 0.0)
			if score < best - 0.05:
				best = score
				drive = float(v)
				driven = tx
	print("PACE %s (%s): pace %.2fx contact %.3f, hand moves %.3f, chest %.3f -> start %.3f (chest at %.0f%%), top %.2f shown / %.2f clip -> drive onto the face %.0f m/s, %.2f driven" % [
		clip, move, sp, c, move_s, load_s, start, 100.0 * chest_share, top, float(_start(bare[0])[1]), drive, driven])
	return {"start_s": snappedf(start, 0.001), "drive_v": snappedf(drive, 0.1),
		"top_shown": snappedf(top, 0.01), "top_driven": snappedf(driven, 0.01), "top_clip": snappedf(float(_start(bare[0])[1]), 0.01),
		"move_s": snappedf(move_s, 0.001), "load_s": snappedf(load_s, 0.001), "chest_at_start": snappedf(chest_share, 0.01),
		"contact_s": snappedf(c, 0.001), "pace": snappedf(sp, 0.01), "move": move}


func _initialize() -> void:
	st = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_02.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_03.glb", "corner": "blue"})
	for b in st.boxers:
		var apb: AnimationPlayer = b["ap"]
		apb.seek(0.0, true)
		apb.pause()
	for i in 60:
		await process_frame
	st.set_process(false)
	await process_frame
	var bx: Dictionary = st.boxers[0]
	skel = bx["skel"]
	ap = bx["ap"]
	reach = bx.get("reach")
	pw = bx.get("weight")
	front = float(bx.get("front", 0.15))
	var scan := OS.get_cmdline_user_args().has("scan")
	var table := {}
	for move in BeatClips.PUNCH:
		for big in [false, true]:
			for tired in [false, true]:
				for step in [false, true]:
					for roll in ROLLS:
						var clip := BeatClips.punch(str(move), {"big": big, "tired": tired, "step": step, "roll": roll}, st.has_move)
						if clip.begins_with("pro_") and not table.has(clip):
							table[clip] = _row(clip, str(move), scan)
	var keys := table.keys()
	keys.sort()
	var ordered := {}
	for k in keys:
		ordered[k] = table[k]
	if OS.get_cmdline_user_args().has("dry"):
		print("PUNCH_PACE dry run: %d clips, nothing written" % ordered.size())
		quit(0)
		return
	var f := FileAccess.open(OUT, FileAccess.WRITE)
	f.store_string(JSON.stringify(ordered, "  ", false) + "\n")
	f.close()
	print("PUNCH_PACE wrote %d clips to %s" % [ordered.size(), OUT])
	quit(0)
