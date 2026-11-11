extends RefCounted
## HUMANFIGHT1 - a body never moves a hand's width in one frame. The fight decides WHERE she stands (bx["pos"]) and several
## writers move that place at once: a side step committed at the return to guard (SideStep), a captured clip's feet laid
## over hers (RkJoin.align), the pair pushed back to their floor gap, a hand-over between the rig's feet and her place.
## RingPlace then shows her there in the same frame: on main her hips jump more than 8 cm in one frame ~90 times a round,
## up to 26 cm, feet and all (tools/human_fight_report.py "pops"). Standard root inertialization: a jump - a change of her
## shown place this frame that her own motion last frame does not explain by more than JUMP_M - is not shown at once. It
## goes into an offset that eases out (half-life HALF_S), so she covers it over ~0.3 s; FootLock steps her feet after her.
## Only the picture: bx["pos"], the gap and every fight rule read the real place. A cut (more than CUT_M: setup, a scene's
## end) is shown at once. `-- nosmoothroot` = the control arm.
##   ShownRoot.smooth(stage, delta)   after RingPlace has placed both bodies

const JUMP_M := 0.045        # ~1.4 m/s of sudden speed at 30 frames a second: a step-in's start passes, a teleport does not
const HALF_S := 0.09
const CUT_M := 1.2
static var on: bool = not OS.get_cmdline_user_args().has("nosmoothroot")


static func smooth(st: Node, delta: float) -> void:
	if not on or delta <= 0.0:
		return
	for bx in st.boxers:
		var n: Node3D = bx["node"]
		var want := n.position
		var prev: Variant = bx.get("root_want")
		var off: Vector3 = bx.get("root_off", Vector3.ZERO)
		if prev != null:
			var step: Vector3 = want - (prev as Vector3)
			step.y = 0.0
			var jump: Vector3 = step - (bx.get("root_step", Vector3.ZERO) as Vector3)
			if step.length() > CUT_M:
				off = Vector3.ZERO
				step = Vector3.ZERO
			elif jump.length() > JUMP_M:
				var take := jump - jump.normalized() * JUMP_M
				off -= take
				step -= take   # the jump is not her motion: the next frame is measured against what was left of it
			bx["root_step"] = step
		off *= exp(-delta * 0.693 / HALF_S)
		if off.length() < 0.001:
			off = Vector3.ZERO
		bx["root_want"] = want
		bx["root_off"] = off
		n.position = want + off


## A scene took the boxers (directors place the bodies): nothing is carried over.
static func reset(st: Node) -> void:
	for bx in st.boxers:
		bx.erase("root_want")
		bx["root_off"] = Vector3.ZERO
		bx["root_step"] = Vector3.ZERO
