extends RefCounted
## KDFIX1: one place decides "down" and the layers ask it. From the fall's first frame until the boxer is handed back
## to the guard, the layers that pose a standing boxer's trunk, neck and arms do not write on that boxer. The clip
## alone decides: a boxer playing a fall, countdown or knockout clip is down. The layers ease their weight to zero
## with a short ease, back with a short ease when the boxer stands again.
##   clip_of(ap) -> String   is_down(clip) -> bool

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")

## The clip on the body now. A finished clip clears current_animation and leaves the last pose held;
## assigned_animation still names that clip. While it is empty, the held clip is the one the body is in.
static func clip_of(ap: AnimationPlayer) -> String:
	if ap == null or not is_instance_valid(ap):
		return ""
	var playing := str(ap.current_animation)
	if playing != "":
		return playing
	return str(ap.assigned_animation)


## The clips that mean a boxer is down: the fall (react_hurt), the countdown clips, and the knockout clips.
## A boxer playing any of these is on the canvas or getting up from it.
static func is_down(clip: String) -> bool:
	if clip == "":
		return false
	for c in BeatClips.DOWN:
		if clip == c:
			return true
	for c in BeatClips.OUT:
		if clip == c:
			return true
	return false
