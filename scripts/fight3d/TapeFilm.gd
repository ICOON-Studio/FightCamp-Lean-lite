extends Control
## S343 the tape room's film (TapeClips; operator Q-S294-68 "the player watches the films"): one of her past bouts on our
## own 3D ring - she in the blue corner she wears against us, the woman she fought in red - played from the film's beat
## list by the fight's own beat switch (BeatFire), the broadcast camera. The tape room owns the clock: tick(t) fires every
## beat up to t; still() cuts the frame on screen for her flow's node (GrappleFlows: a node is a still of that moment).
##   var f := TapeFilm.new(); f.setup(opp, vs_name); parent.add_child(f); f.load_clip(clip); f.tick(t); f.still() -> Texture2D
## BeatFire reads the view's stage, clock, profiles, body map, rng, stop and pace: this film has each (the body map a stub).

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatFire := preload("res://scripts/fight3d/BeatFire.gd")
const RangeBreath := preload("res://scripts/fight3d/RangeBreath.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const Referee := preload("res://scripts/fight3d/Referee.gd")
const THUMB_W := 256
## S343 the tape's hard camera (the stills of the first cut: the ring's shot director cut to a lens behind HER shoulder, so
## her hands - the tell - were hidden). Side-on to the pair, a little toward the other woman so she faces it, both head to
## feet, never cutting: what a coach films from ringside. Metres from the pair's middle, lens height, look height, fov.
const CAM_DIST := 3.3
const CAM_BACK := 0.8
const CAM_H := 1.35
const CAM_LOOK_H := 0.95
const CAM_FOV := 42.0
const CAM_EASE := 4.0
## The lens stays inside the ropes (a see-through rope smeared across their shins when it stood outside): this far in from
## them at most, coming closer and widening (half the frame's height CAM_HALF_H m at the pair) when the pair is near them.
const CAM_IN_M := 0.3
const CAM_MIN := 1.9
const CAM_HALF_H := 1.2
## A node's still keeps this middle part of the frame (the pair), cut to THUMB_W wide.
const STILL_CROP := Rect2(0.17, 0.06, 0.66, 0.9)

## BeatFire's body map (BodyLive in the fight): the tape keeps no scorebug, so nothing to mark.
class NoBody:
	extends RefCounted
	func land(_b: Dictionary, _at: float) -> void:
		pass

var stage: Node3D
var t := 0.0
var _stop := ""
var _close_left := 0.0
var _profiles := {"a": {}, "b": {}}
var _amb_rng := RandomNumberGenerator.new()
var body := NoBody.new()
var _beat := BeatFire.new()
var _vp: SubViewport
var _beats: Array = []
var _next := 0
var _opp: Dictionary = {}
var _vs := ""
var _side := 1.0
var _cam_at := Vector3.ZERO


func setup(opp: Dictionary, vs_name: String) -> void:
	_opp = opp
	_vs = vs_name


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	process_priority = 10   # after the stage's own frame, so the hard camera is where the frame is drawn from
	var holder := SubViewportContainer.new()
	holder.stretch = true
	holder.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(holder)
	_vp = SubViewport.new()
	_vp.own_world_3d = true
	_vp.msaa_3d = Viewport.MSAA_4X
	holder.add_child(_vp)
	stage = Stage.new()
	_vp.add_child(stage)
	# The woman she fought is "a" (red), she is "b" (blue): never the same body (Faces.pair).
	var p := Faces.pair({"name": _vs}, _opp)
	var cm := float(_opp.get("height", 0.0))
	var her_scale := clampf((cm if cm > 0.0 else Faces.cm(p[1])) / Faces.cm(p[1]), 0.88, 1.12)
	stage.setup({"glb": Faces.glb(p[0]), "corner": "red", "scale": 1.0, "stance": "orthodox"},
		{"glb": Faces.glb(p[1]), "corner": "blue", "scale": her_scale, "stance": str(_opp.get("stance", "orthodox"))})
	Referee.build(stage)


## Back to the first frame of a film: both in guard at range, the broadcast camera on them.
func load_clip(clip: Dictionary) -> void:
	_beats = clip.get("beats", [])
	_next = 0
	t = 0.0
	_beat.reset()
	_amb_rng.seed = hash(str(clip.get("shape", "")))
	if stage != null and stage.is_inside_tree():
		for i in 2:
			stage.guard(i)
		stage.broadcast(true)
		# The ring's director stays off (its close-up flag); the lens takes the side nearer the ring's middle.
		stage.camera.close = true
		# The side with more room inside the ropes.
		_side = 1.0 if _room(1.0) >= _room(-1.0) else -1.0
		_cam_at = _lens(_side)


## How far from the pair the lens can stand on side s and stay inside the ropes.
func _room(s: float) -> float:
	var dist := CAM_DIST
	while dist > CAM_MIN and not _inside(_lens_at(s, dist)):
		dist -= 0.1
	return dist


func _inside(p: Vector3) -> bool:
	var half := Stage.RING_M * 0.5 - CAM_IN_M
	return absf(p.x) <= half and absf(p.z) <= half


## Where the lens sits for the pair as they stand now, on side s (as far out as the ropes allow).
func _lens(s: float) -> Vector3:
	return _lens_at(s, _room(s))


func _lens_at(s: float, dist: float) -> Vector3:
	var a: Vector3 = stage.boxers[0]["pos"]
	var b: Vector3 = stage.boxers[1]["pos"]
	var d := Vector3(b.x - a.x, 0.0, b.z - a.z).normalized()
	if d == Vector3.ZERO:
		d = Vector3.RIGHT
	var perp := Vector3(-d.z, 0.0, d.x) * s
	var mid := (a + b) * 0.5
	return Vector3(mid.x, CAM_H, mid.z) + perp * dist - d * CAM_BACK * dist / CAM_DIST


func _process(delta: float) -> void:
	if stage == null or stage.boxers.size() < 2 or not stage.camera.close:
		return
	var a: Vector3 = stage.boxers[0]["pos"]
	var b: Vector3 = stage.boxers[1]["pos"]
	_cam_at = _cam_at.lerp(_lens(_side), 1.0 - exp(-CAM_EASE * delta))
	var mid := (a + b) * 0.5
	stage.camera.global_position = _cam_at
	stage.camera.look_at(Vector3(mid.x, CAM_LOOK_H, mid.z), Vector3.UP)
	# Closer in, wider: both stay head to feet.
	var reach := Vector2(_cam_at.x - mid.x, _cam_at.z - mid.z).length()
	stage.camera.fov = maxf(CAM_FOV, rad_to_deg(2.0 * atan(CAM_HALF_H / maxf(reach, 0.5))))


## Fires every beat up to the tape room's clock.
func tick(now: float) -> void:
	if stage == null:
		return
	t = now
	while _next < _beats.size() and float(_beats[_next]["t"]) <= t:
		_beat.fire(self, _beats[_next])
		_next += 1
	stage.aim(RangeBreath.phase(_beats, _next, t))
	if _close_left > 0.0:
		_close_left = 0.0
		stage.camera.close = true


## BeatFire runs a big shot at half pace through this; the tape room's own speed stays.
func pace() -> float:
	return Engine.time_scale


## The frame on screen as a node's thumbnail (THUMB_W wide); null before the first frame is drawn.
func still() -> Texture2D:
	if _vp == null:
		return null
	var img := _vp.get_texture().get_image()
	if img == null or img.is_empty():
		return null
	var w := img.get_width()
	var h := img.get_height()
	img = img.get_region(Rect2i(int(w * STILL_CROP.position.x), int(h * STILL_CROP.position.y), int(w * STILL_CROP.size.x), int(h * STILL_CROP.size.y)))
	img.resize(THUMB_W, maxi(1, int(THUMB_W * float(img.get_height()) / float(img.get_width()))), Image.INTERPOLATE_BILINEAR)
	return ImageTexture.create_from_image(img)
