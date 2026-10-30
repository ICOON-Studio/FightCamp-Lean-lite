extends SceneTree
## S310 (operator: "why don't you map all 165 clips we purchased?"): the hit reactions, counts, knockouts, wins and tired
## idles are picked from every Punch Pro take by the beat's roll (BeatClips.pick), not the first one every time.

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")

var failures := 0


func _initialize() -> void:
	var all := func(n: String) -> bool: return true
	var jabs := {}
	for i in 20:
		jabs[BeatClips.react("jab", false, all, i / 20.0)] = true
	_check(jabs.size() >= 5, "a jab to the head plays %d different reactions (was 1)" % jabs.size())
	_check(BeatClips.BIG_REACT.has(BeatClips.react("lead_hook", false, all, 0.5, true)), "the big shot plays a big snap")
	_check(BeatClips.react("body_hook", false, all, 0.5, true) in BeatClips.REACT["body_hook"], "a big body shot keeps a body reaction")
	for pool in [BeatClips.WIN, BeatClips.OUT, BeatClips.DOWN, BeatClips.TIRED]:
		var seen := {}
		for i in 20:
			seen[BeatClips.pick(pool, all, i / 20.0)] = true
		_check(seen.size() >= 3, "%s varies (%d takes)" % [str(pool[0]), seen.size()])
	var none := func(n: String) -> bool: return n == "react_head"
	_check(BeatClips.react("jab", false, none, 0.7) == "react_head", "no Pro take on this body: the fallback plays")
	print("BEATCLIPS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
