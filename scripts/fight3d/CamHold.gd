extends RefCounted
## CAMHOLD1: the camera never cuts while a punch is in flight. A TV director holds the shot through an exchange and cuts
## on the reset, unless the lens is blocked. This pure module decides when a cut may proceed.

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")

## The shot also holds this long after a punch's contact (the head's answer).
const AFTER_HIT_S := 0.35

## True for "start", "jump" and "emergency" always (a blocked lens must still be left at once); for every other reason
## only when `punching` is false.
static func may_cut(why: String, punching: bool) -> bool:
	if OS.get_cmdline_user_args().has("nocamhold"):
		return true
	if why == "start" or why == "jump" or why == "emergency":
		return true
	return not punching

## True when `clip` is a punch clip that has not yet passed its contact by AFTER_HIT_S; false for "" and for a clip with
## no contact.
static func punching(clip: String, at_s: float, contact_s: float) -> bool:
	if clip == "" or contact_s < 0.0:
		return false
	return at_s <= contact_s + AFTER_HIT_S

## Reads `bx["ap"]` (AnimationPlayer): its current_animation, current_animation_position, and BeatClips.contact only when
## BeatClips.contact_row is not empty; false on an empty Dictionary or a missing player.
static func boxer_punching(bx: Dictionary) -> bool:
	if bx.is_empty() or not bx.has("ap"):
		return false
	var ap: AnimationPlayer = bx["ap"]
	if ap == null:
		return false
	var clip: String = ap.current_animation
	if clip == "":
		return false
	var row: Dictionary = BeatClips.contact_row(clip)
	if row.is_empty():
		return false
	var contact_s: float = BeatClips.contact(clip, -1.0)
	return punching(clip, ap.current_animation_position, contact_s)
