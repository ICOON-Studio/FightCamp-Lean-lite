extends "res://tools/body_react_probe.gd"
## S393 PUNCH INTERRUPTED probe: three live rounds. Every hit reaction that starts: was its boxer's own punch in flight the frame
## before (armed, before its contact)? And every landed punch cut off before it arrived: a hit the sim counted that never showed.
##   <godot.exe> --headless --audio-driver Dummy --path . --fixed-fps 30 --script res://tools/interrupt_probe.gd -- show3d [arms]

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")

var _flying := [false, false]
var _flying_at := [0.0, 0.0]
var _flying_clip := ["", ""]
var _reactions := 0
var _stopped := 0
var _left_s: Array = []
var _by_clip := {}


func _sample() -> void:
	super._sample()
	for i in 2:
		# S393: read the clip, not the reach: only a landing punch arms the reach, so a blocked or missed one was invisible.
		var ap: AnimationPlayer = stage.boxers[i]["ap"]
		var clip := str(ap.assigned_animation)
		var contact := BeatClips.contact(clip, 0.4)
		var on := _is_punch(clip) and ap.is_playing() and ap.current_animation_position < contact
		_flying[i] = on
		_flying_at[i] = contact - ap.current_animation_position if on else 0.0
		_flying_clip[i] = clip


func _on_started(clip: StringName, i: int) -> void:
	super._on_started(clip, i)
	if not (str(clip).contains("hit_by") or str(clip).begins_with("react_") or str(clip).begins_with("mc_hit")):
		return
	_reactions += 1
	if bool(_flying[i]):
		_stopped += 1
		_left_s.append(float(_flying_at[i]))
		var c := str(_flying_clip[i])
		_by_clip[c] = int(_by_clip.get(c, 0)) + 1


func _is_punch(clip: String) -> bool:
	if not clip.begins_with("pro_") or clip.contains("hit_by"):
		return false
	for w in ["jab", "cross", "hook", "uppercut", "body_shot", "kidney"]:
		if clip.contains(w):
			return true
	return false


func _report() -> void:
	var cuts := 0
	var landed := 0
	for g in stage.hit_gaps:
		landed += 1
		cuts += 1 if bool(g.get("cut", false)) else 0
	_left_s.sort()
	var mid: float = float(_left_s[_left_s.size() / 2]) if not _left_s.is_empty() else 0.0
	var seen := _left_s.filter(func(x): return float(x) <= 0.25).size()
	print("INTERRUPT visible stops (arm well out, 0.25 s or less from contact): %d" % seen)
	var line := "INTERRUPT reactions %d, with her own punch in flight %d (median %.2f s before its contact) | landed contacts kept %d, cut off %d | by clip %s" % [_reactions, _stopped, mid, landed, cuts, str(_by_clip)]
	print(line)
	var fh := FileAccess.open("E:/FightCamp/tmp/s393/interrupt_last.txt", FileAccess.WRITE)
	if fh != null:
		fh.store_line(line)
	super._report()
