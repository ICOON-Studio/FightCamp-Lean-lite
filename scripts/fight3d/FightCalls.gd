extends PanelContainer
## S395 the TV lower third and the big-shot moment (operator: "display the hits that land or add a tv panel describing the
## action", "significant strikes to be in slow-mo for a sec and camera zoomin in as it happens"). BodyLive calls landed() at
## each punch's contact, and big_coming() just before a big one. The panel names who landed what, with a run of unanswered
## shots. A big shot also slows the ring for
## HOLD_S and pushes the lens in on the head that took it, at most MOST_A_ROUND times a round and APART_S apart, so it stays
## an event. Runs after the stage (process_priority), so its offsets ride on the lens's own shake.
##   attach(view)   landed(beat)   line(move, big)   envelope(t)   allowed(used, since)

const UI := preload("res://scripts/ui/TV.gd")
const Arc := preload("res://scripts/fight3d/HudArc.gd")
const CornerCard := preload("res://scripts/rules/CornerCard.gd")
const CornerShots := preload("res://scripts/fight3d/CornerShots.gd")

const LEAD_S := 0.2          # the moment starts this long before the contact, so the blow itself plays slow
const SHOW_S := 1.6          # real seconds a line stays up
const FADE_S := 0.2
const RUN_GAP_S := 1.5       # shots this close by one boxer are a run
const SLOW := 0.3            # of the ring's pace during the moment
const HOLD_S := 1.0          # real seconds of it
const IN_S := 0.14           # the lens goes in this fast, on the blow
const OUT_S := 0.45          # and comes back after the slow part
const ZOOM := 0.62           # of the shot's field of view at the closest
const CENTRE := 0.75         # how far the push slides the head towards the middle of the frame
const MOST_A_ROUND := 2
const APART_S := 8.0

var view: Control
var _who: Label
var _shot: Label
var _strip: ColorRect
var _left := 0.0
var _clock := 0.0            # real seconds since this node started
var _run := [0, -1, -99.0]   # shots in a row, by whom, when the last one landed
var _round := -1
var _used := 0
var _last := -99.0
var _t := -1.0               # seconds into the moment; < 0: none
var _slow := false
var _base_fov := 0.0
var _set_fov := 0.0
var _aim := Vector2.ZERO


static func attach(v: Control, pin: Callable) -> Node:
	var c: PanelContainer = new()
	c.name = "FightCalls"
	c.view = v
	v.add_child(c)
	pin.call(c, Vector4(0, 1, 0, 1), Vector4(96, -158, 700, -104))
	c._build()
	return c


## "RIGHT HOOK", "BIG HOOK TO THE BODY".
static func line(move: String, big: bool) -> String:
	var word := str(CornerCard.WORD.get(move, move.replace("_", " "))).to_upper()
	return "BIG " + word if big else word


## How far in the lens is, 0..1, t seconds into the moment.
static func envelope(t: float) -> float:
	if t < 0.0 or t >= HOLD_S + OUT_S:
		return 0.0
	if t < IN_S:
		return t / IN_S
	return 1.0 if t < HOLD_S else 1.0 - (t - HOLD_S) / OUT_S


static func allowed(used: int, since: float) -> bool:
	return used < MOST_A_ROUND and since >= APART_S


func _build() -> void:
	process_priority = 100
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_theme_stylebox_override("panel", UI.box(Color(0.04, 0.03, 0.03, 0.82), Color(0, 0, 0, 0), 4, 0, 14, 8))
	var row := UI.hbox(12)
	add_child(row)
	_strip = ColorRect.new()
	_strip.custom_minimum_size = Vector2(6, 0)
	row.add_child(_strip)
	_who = UI.label("", 24, UI.FG, "bold")
	row.add_child(_who)
	_shot = UI.label("", 24, UI.FG, "bold")
	row.add_child(_shot)
	visible = false


## A punch reached the other boxer.
func landed(b: Dictionary) -> void:
	if not bool(view.playing):
		return
	var side := 0 if str(b["who"]) == "a" else 1
	var big := bool(b.get("big", false))
	_run = [int(_run[0]) + 1 if int(_run[1]) == side and _clock - float(_run[2]) <= RUN_GAP_S else 1, side, _clock]
	var col: Color = Arc.SIDE_COLOUR[side]
	_strip.color = col
	_who.text = str(view._names[side]).get_slice(" ", 0).to_upper()
	_who.add_theme_color_override("font_color", col)
	_shot.text = line(str(b["move"]), big) + ("   %d IN A ROW" % int(_run[0]) if int(_run[0]) >= 3 else "")
	_shot.add_theme_color_override("font_color", UI.GOLD if big else UI.FG)
	_left = SHOW_S
	modulate.a = 1.0
	visible = true


## A big shot is LEAD_S from landing (BodyLive.land).
func big_coming(b: Dictionary) -> void:
	if bool(view.playing):
		_moment(1 if str(b["who"]) == "a" else 0)


func _moment(hurt: int) -> void:
	if int(view.round_n) != _round:
		_round = int(view.round_n)
		_used = 0
	if view._shouting != null or _t >= 0.0 or not allowed(_used, _clock - _last):
		return
	_used += 1
	_last = _clock
	var cam: Camera3D = view.stage.camera
	var to := cam.global_transform.affine_inverse() * CornerShots.bone(view.stage.boxers[hurt], "Head")
	_aim = Vector2(to.x, to.y) * CENTRE
	_base_fov = cam.fov
	_set_fov = cam.fov
	_t = 0.0
	_slow = true
	Engine.time_scale = SLOW * view.pace()


func _back() -> void:
	_slow = false
	if bool(view.playing):
		Engine.time_scale = (view.SHOUT_PACE if view._shouting != null else 1.0) * view.pace()


func _process(delta: float) -> void:
	var real := delta / maxf(Engine.time_scale, 0.05)
	_clock += real
	if visible:
		_left -= real
		modulate.a = clampf(_left / FADE_S, 0.0, 1.0)
		visible = _left > 0.0 and bool(view.playing)
	if _t < 0.0:
		return
	_t += real
	if _slow and (_t >= HOLD_S or not bool(view.playing)):
		_back()
	var cam: Camera3D = view.stage.camera
	if absf(cam.fov - _set_fov) > 0.01:
		_base_fov = cam.fov   # the director cut while the lens was in
	var k := envelope(_t) if bool(view.playing) else 0.0
	_set_fov = _base_fov * lerpf(1.0, ZOOM, k)
	cam.fov = _set_fov
	cam.h_offset += _aim.x * k
	cam.v_offset += _aim.y * k
	if k <= 0.0 and _t > 0.0:
		_t = -1.0
