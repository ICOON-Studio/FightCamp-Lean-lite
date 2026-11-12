extends RefCounted
## S442 owner: "add some effects on critical decisions buttons like slowly expand and shrink to draw players eyes".
## Pulse.breathe(control): a slow scale loop about the control's centre, 1.00 -> 1.04 -> 1.00 over 1.6 s, sine eased.
## Scale only (never size, so no layout moves); back to exactly 1.0 when it stops, so text is sharp at rest.
## It pauses on hover, stops for good on press, and does not run on a disabled or hidden control. Pulse.stop(control)
## ends it. ONE pulsing button per screen: the decision the player must make there now (list: ops/research/UX_AUDIT_S442.md).
## No reduced-motion setting exists in Settings.gd today; when one is added, check it in _allowed().

const PEAK := 1.04
const HALF_S := 0.8
const TWEEN := "pulse_tween"
const ON := "pulse_on"


static func breathe(c: Control) -> void:
	if c == null or not is_instance_valid(c):
		return
	c.set_meta(ON, true)
	if not bool(c.get_meta("pulse_wired", false)):
		c.set_meta("pulse_wired", true)
		c.resized.connect(func(): c.pivot_offset = c.size / 2.0)
		c.tree_entered.connect(func(): _start(c))
		c.visibility_changed.connect(func(): _start(c))   # _start halts first and starts only when shown
		c.mouse_entered.connect(func(): _halt(c))
		c.mouse_exited.connect(func(): _start(c))
		if c is BaseButton:
			(c as BaseButton).button_down.connect(func(): stop(c))
	_start(c)


static func stop(c: Control) -> void:
	if c == null or not is_instance_valid(c):
		return
	c.set_meta(ON, false)
	_halt(c)


static func running(c: Control) -> bool:
	var tw = c.get_meta(TWEEN) if c.has_meta(TWEEN) else null
	return tw is Tween and (tw as Tween).is_valid() and (tw as Tween).is_running()


static func _allowed(c: Control) -> bool:
	if not bool(c.get_meta(ON, false)) or not c.is_inside_tree() or not c.is_visible_in_tree():
		return false
	return not (c is BaseButton and (c as BaseButton).disabled)


static func _start(c: Control) -> void:
	_halt(c)   # never two tweens on one control
	if not _allowed(c):
		return
	c.pivot_offset = c.size / 2.0
	var tw := c.create_tween().set_loops()
	tw.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(c, "scale", Vector2(PEAK, PEAK), HALF_S)
	tw.tween_property(c, "scale", Vector2.ONE, HALF_S)
	tw.loop_finished.connect(func(_n: int): _check(c))   # disabled since the last breath
	c.set_meta(TWEEN, tw)


static func _halt(c: Control) -> void:
	var tw = c.get_meta(TWEEN) if c.has_meta(TWEEN) else null
	if tw is Tween and (tw as Tween).is_valid():
		(tw as Tween).kill()
	c.remove_meta(TWEEN)
	c.scale = Vector2.ONE


static func _check(c: Control) -> void:
	if is_instance_valid(c) and not _allowed(c):
		_halt(c)
