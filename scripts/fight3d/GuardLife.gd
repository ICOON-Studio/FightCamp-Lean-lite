extends RefCounted
## S302 (operator after the S302 film: "the boxing still feels robotic, and their movement is like synchronized, the
## fighters do not feel like they have fluid motion"). Measured on that film's frame log: in guard the two boxers' hip
## bounce correlated 0.92 (1.0 = lockstep), half of all clip changes fell within 0.1 s of the other's, and each boxer
## spent 70% of the fight in one 2-second guard loop restarted from its first frame. Here each boxer gets her own
## life: her own guard tempo and a random phase every time she settles, a Punch Pro fidget (bounce, glove pumps, pawing
## lead, a dip, a shoulder roll) every 1-3 s cut to a short window, and the second boxer of a pair step follows the
## first a beat later instead of in the same frame.
##   setup(stage, seed)  settle(who) -> [clip, speed, from_s]  tick(delta)  later(who, delay, fn)  cancel(who)

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const RkClips := preload("res://scripts/fight3d/RkClips.gd")

## Fidgets with the hands up plus active head-movement and bob-and-weave so boxers never stand staring in pro_idle.
const FIDGETS := ["pro_idle_fidget_v1", "pro_idle_fidget_v2", "pro_idle_fidget_v3", "pro_idle_fidget_v6",
	"pro_idle_fidget_v7", "pro_idle_fidget_v8", "mc_head_movement", "mc_bob_weave", "ow_bounce_idle", "ow_side_lean"]
const TEMPO := [0.93, 1.08]          # each boxer's guard rate (never the same)
const QUIET_S := Vector2(0.3, 1.0)   # guard time before an active fidget / head-movement
const FIDGET_S := Vector2(1.0, 2.1)  # how long a fidget window lasts
const FOLLOW_S := Vector2(0.10, 0.28)  # the second boxer of a pair step starts this much later
## S503 WAITING ALIVE (blind r9 animator, waiting 4/10: "No feints, no pawing jab ... nothing that says I am looking for
## an opening"; longest wait 5.8 s, bar 3 s; "a pawing lead hand (20-30 cm out and back, 6-8 frames) every 1.5-3 s, a feint
## (half jab, 4-6 frames) every 2-4 s"; "a pressure fighter and an out-boxer should wait differently"). Two wait beats on
## their own clocks while she stands in guard or a fidget: a PAW (her quick jab played slowly to about half its reach, then
## guard) and a FEINT (the same jab's first frames, fast: the shoulder and hand start, then guard). Each style scales the
## two clocks (x < 1 = more often). `-- nowaitbeats` = the control arm.
const WAIT_JAB := "pro_left_jab_b"   # contact 0.2 s, full reach 0.3 s (assets/data/clip_recovery.json)
## paw: to the jab's contact frame (~20 cm out, 6 frames; to 0.13 s at x0.75 read ~12 cm on the film), feint: 3-4 frames.
const BEAT := {"paw": {"every": Vector2(1.5, 3.0), "to_s": 0.2, "speed": 1.0},
	"feint": {"every": Vector2(2.0, 4.0), "to_s": 0.12, "speed": 1.2}}
const STYLE_EVERY := {   # [paw, feint] interval scale
	"Pressure fighter": [0.8, 1.4], "Volume puncher": [0.7, 1.1], "Out-boxer": [0.75, 0.9],
	"Counter-puncher": [1.6, 0.7], "Boxer-puncher": [1.0, 1.0]}

var stage: Node
var rng := RandomNumberGenerator.new()
var _quiet := [0.0, 0.0]
var _fidget := [0.0, 0.0]            # seconds left in the fidget playing (0 = none)
var _last := ["", ""]
var _later: Array = []               # [{who, left, fn}]
var _beat_in := [{}, {}]             # per boxer: {"paw": s, "feint": s} until the next beat
var _beat_left := [0.0, 0.0]         # seconds left of the beat playing (0 = none)
static var _beats_on := -1


static func beats_on() -> bool:
	if _beats_on < 0:
		_beats_on = 0 if OS.get_cmdline_user_args().has("nowaitbeats") else 1
	return _beats_on == 1


func setup(owner: Node, seed: int) -> void:
	stage = owner
	rng.seed = seed
	for i in 2:
		_quiet[i] = rng.randf_range(QUIET_S.x, QUIET_S.y)
		for b in BEAT:
			_beat_in[i][b] = rng.randf_range(0.3, 1.0) * float((BEAT[b] as Dictionary)["every"].y)


## The guard she settles into: her own tempo, from a random point of the loop.
func settle(who: int, idle: String, length: float) -> Array:
	# The quiet countdown carries on through punches and steps (a reset on every return to guard starved the fidgets).
	if _fidget[who] > 0.0 or _quiet[who] <= 0.0:
		_quiet[who] = rng.randf_range(QUIET_S.x, QUIET_S.y)
	_fidget[who] = 0.0
	return [idle, float(TEMPO[who % 2]) * rng.randf_range(0.97, 1.03), rng.randf() * length]


## Every frame: counts each boxer's quiet guard down to a fidget, a fidget down to her guard, and runs the delayed steps.
func tick(delta: float) -> void:
	for k in range(_later.size() - 1, -1, -1):
		var job: Dictionary = _later[k]
		job["left"] = float(job["left"]) - delta
		if float(job["left"]) <= 0.0:
			_later.remove_at(k)
			(job["fn"] as Callable).call()
	for who in stage.boxers.size():
		var ap: AnimationPlayer = stage.boxers[who]["ap"]
		var clip := str(ap.assigned_animation)
		if _beat_left[who] > 0.0:
			_beat_left[who] -= delta
			if _beat_left[who] <= 0.0 and clip == WAIT_JAB:
				stage.guard(who)
			continue
		if _tick_beats(who, ap, clip, delta):   # a paw or feint goes in while she steps too (the rig keeps her legs)
			continue
		if float(stage.boxers[who]["move_left"]) > 0.0:
			continue
		if _fidget[who] > 0.0:
			_fidget[who] -= delta
			if _fidget[who] <= 0.0 and FIDGETS.has(clip):
				stage.guard(who)
			continue
		if not BeatClips.GUARD.has(clip) or RkClips.CLIPS.has(clip):   # S399: the captured guard is the actor's own life - no fidget over it
			continue
		_quiet[who] -= delta
		if _quiet[who] <= 0.0 and not _joining(who):
			_play_fidget(who, ap)


func _play_fidget(who: int, ap: AnimationPlayer) -> void:
	var pool := FIDGETS.filter(func(n): return ap.has_animation(n) and n != _last[who] and (not RkClips.pro_on() or n in RkClips.PRO_FIDGETS))   # S399 proguard: only the re-baked Punch PRO fidgets, played pure
	if pool.is_empty():
		_quiet[who] = rng.randf_range(QUIET_S.x, QUIET_S.y)
		return
	var clip: String = pool[rng.randi() % pool.size()]
	var length := ap.get_animation(clip).length
	var window := minf(rng.randf_range(FIDGET_S.x, FIDGET_S.y), length)
	_last[who] = clip
	stage.play(who, clip, rng.randf_range(0.95, 1.1), rng.randf() * maxf(0.0, length - window))
	_fidget[who] = window


## S503: counts her paw and feint clocks down while she waits (guard or a fidget); plays the one that comes due.
func _tick_beats(who: int, ap: AnimationPlayer, clip: String, delta: float) -> bool:
	if not beats_on() or not ap.has_animation(WAIT_JAB):
		return false
	if not (BeatClips.GUARD.has(clip) or FIDGETS.has(clip)):
		return false
	var due := ""
	for b in BEAT:
		_beat_in[who][b] = float(_beat_in[who][b]) - delta
		if float(_beat_in[who][b]) <= 0.0 and due == "":
			due = b
	if due == "" or _joining(who):   # S509: a due beat waits (its clock stays run out) until her return to guard has eased in
		return false
	var row: Dictionary = BEAT[due]
	var scale: Array = STYLE_EVERY.get(str(stage.boxers[who].get("style", "")), [1.0, 1.0])
	var every: Vector2 = row["every"]
	_beat_in[who][due] = rng.randf_range(every.x, every.y) * float(scale[0 if due == "paw" else 1])
	var speed := float(row["speed"]) * rng.randf_range(0.92, 1.08)
	if not stage.play(who, WAIT_JAB, speed, 0.0):
		return false
	_fidget[who] = 0.0
	_beat_left[who] = float(row["to_s"]) / speed
	return true


## S509 (join_return, cross rep: a paw started 2 frames into the cross's ease back to guard; the quick join into the jab
## snapped the still-returning rear glove home, 0.33 m in one frame = 20 m/s): true while her join into the guard runs.
## `-- nojoinwait` = the control arm.
static var JOIN_WAIT: bool = not OS.get_cmdline_user_args().has("nojoinwait")
func _joining(who: int) -> bool:
	var js = stage.boxers[who].get("js")
	return JOIN_WAIT and js != null and (bool(js.get("_pending")) or float(js.get("_t")) >= 0.0)


## Runs `fn` for boxer `who` after `delay` seconds (dropped if she starts something else first: cancel()).
func later(who: int, delay: float, fn: Callable) -> void:
	_later.append({"who": who, "left": delay, "fn": fn})


func follow_delay() -> float:
	return rng.randf_range(FOLLOW_S.x, FOLLOW_S.y)


func cancel(who: int) -> void:
	_fidget[who] = 0.0
	_beat_left[who] = 0.0
	_later = _later.filter(func(j): return int(j["who"]) != who)
