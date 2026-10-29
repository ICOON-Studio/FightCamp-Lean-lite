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

## Fidgets with the hands up (v4 / v5 drop the hands: between rounds, not in the fight).
const FIDGETS := ["pro_idle_fidget_v1", "pro_idle_fidget_v2", "pro_idle_fidget_v3", "pro_idle_fidget_v6",
	"pro_idle_fidget_v7", "pro_idle_fidget_v8"]
const TEMPO := [0.93, 1.08]          # each boxer's guard rate (never the same)
const QUIET_S := Vector2(0.4, 1.4)   # guard time before a fidget (the S302 film at 1-3 s, reset every beat: 4% fidgets)
const FIDGET_S := Vector2(1.2, 2.6)  # how long a fidget window lasts
const FOLLOW_S := Vector2(0.10, 0.28)  # the second boxer of a pair step starts this much later

var stage: Node
var rng := RandomNumberGenerator.new()
var _quiet := [0.0, 0.0]
var _fidget := [0.0, 0.0]            # seconds left in the fidget playing (0 = none)
var _last := ["", ""]
var _later: Array = []               # [{who, left, fn}]


func setup(owner: Node, seed: int) -> void:
	stage = owner
	rng.seed = seed
	for i in 2:
		_quiet[i] = rng.randf_range(QUIET_S.x, QUIET_S.y)


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
		if float(stage.boxers[who]["move_left"]) > 0.0:
			continue
		if _fidget[who] > 0.0:
			_fidget[who] -= delta
			if _fidget[who] <= 0.0 and FIDGETS.has(clip):
				stage.guard(who)
			continue
		if not BeatClips.GUARD.has(clip):
			continue
		_quiet[who] -= delta
		if _quiet[who] <= 0.0:
			_play_fidget(who, ap)


func _play_fidget(who: int, ap: AnimationPlayer) -> void:
	var pool := FIDGETS.filter(func(n): return ap.has_animation(n) and n != _last[who])
	if pool.is_empty():
		_quiet[who] = rng.randf_range(QUIET_S.x, QUIET_S.y)
		return
	var clip: String = pool[rng.randi() % pool.size()]
	var length := ap.get_animation(clip).length
	var window := minf(rng.randf_range(FIDGET_S.x, FIDGET_S.y), length)
	_last[who] = clip
	stage.play(who, clip, rng.randf_range(0.95, 1.1), rng.randf() * maxf(0.0, length - window))
	_fidget[who] = window


## Runs `fn` for boxer `who` after `delay` seconds (dropped if she starts something else first: cancel()).
func later(who: int, delay: float, fn: Callable) -> void:
	_later.append({"who": who, "left": delay, "fn": fn})


func follow_delay() -> float:
	return rng.randf_range(FOLLOW_S.x, FOLLOW_S.y)


func cancel(who: int) -> void:
	_fidget[who] = 0.0
	_later = _later.filter(func(j): return int(j["who"]) != who)
