extends "res://scripts/fight3d/FootPlant.gd"
## FIGHTPLAYER2 (S528, the owner on film 5, C434: "why the fighter do not walk ?"): THE FEET BELONG TO THE TAKE.
## FootPlant holds a foot until the pose has carried it 10 cm away and then runs after it with a step of its own - so it
## chased every step a take was captured with (late, 0.26 s, 5 cm high) and dragged the feet after any body the plan
## moved. This layer reads WHEN from the take instead (assets/data/foot_db.json, tools/step_census.gd: for every take the
## times each foot stands on the canvas):
##   - while the take STANDS on a foot, the foot is pinned to the canvas where it landed: nothing slides it - not the
##     plan moving the body, not a join from another stance, not a step take played shorter than it was captured;
##     It is pinned by its BALL, not its ankle: a standing foot turns and rolls on its ball (the heel lifts, the boxer
##     pivots), so an ankle held still swung the toes about it (S528 first run: 2 m of the guard's 2.6 m of slip was
##     toes moving round a still ankle);
##   - while the take has the foot IN THE AIR, the foot goes where the take puts it, with the take's own lift and timing;
##     what the pin had held it off by is eased out over the swing, so it lands exactly under the pose (a step take the
##     plan plays at half its length makes a half-length step: the legs close, no foot slides).
## A take that never lifts a foot (the guard) while the plan moves the body, or a foot left far behind with no step of
## the take coming: FootPlant's own step, as before. The leg IK, the reach limit and the knee's plane are FootPlant's.
## `-- fp2plant` = FootPlant alone (the control arm).
##   add(skel, ap, after, feet_db, south) -> FootTake | null

const HOLD_M := 0.17          # a standing foot this far from its pose, with no step of the take coming, steps on its own
const SOON_S := 0.40          # ... "coming" = the take lifts it within this long

var feet_db: Dictionary = {}  # take -> {"L": [[from_s, to_s], ...], "R": [...]} (the times it stands)
var south := false            # a southpaw's library is mirrored: his left foot plays the take's right
var _lift: Array = [{}, {}]   # per foot: {} or {"o": Vector3, "k0": float} - a swing the take itself makes
var _ball: Array = [-1, -1]   # per foot: its toes bone
var _boff: Array = [Vector3.ZERO, Vector3.ZERO]   # per foot: ankle -> ball this frame (world, flat)
var _pin: Array = [null, null]                    # per foot: where its ball is pinned (world), null = not pinned by a table
var _state: Array = ["", ""]  # per foot: what ruled it this frame (probes)
var _shown: Array = [null, null]
var tally := {}               # probes: metres a low foot's ball moved, by what ruled it
var took := 0                 # steps shown from a take (probes)
var own := 0                  # FootPlant's own steps while a table ruled (probes)


static func add(skel: Skeleton3D, ap: AnimationPlayer, after: Node, db: Dictionary, is_south: bool) -> Node:
	var ft := new()
	ft.name = "FootTake"
	if not ft.setup(skel, ap):
		ft.free()
		return null
	ft.feet_db = db
	ft.south = is_south
	ft._ball = [skel.find_bone("LeftToes"), skel.find_bone("RightToes")]
	skel.add_child(ft)
	if after != null:
		skel.move_child(ft, after.get_index() + 1)
	return ft


## The swing boxer's foot `key` is in at take time `t`: (from_s, to_s), or (-1, how long until the next one) standing.
static func swing_at(stands: Array, t: float, length: float) -> Vector2:
	var was := 0.0
	for s in stands:
		var a := float(s[0])
		var b := float(s[1])
		if t < a:
			return Vector2(was, a) if a - was > 0.02 else Vector2(-1.0, 0.0)
		if t <= b:
			# standing: when does it lift next?
			return Vector2(-1.0, b - t if b < length - 0.02 else INF)
		was = b
	return Vector2(was, length) if length - was > 0.02 and t < length else Vector2(-1.0, INF)


func step(skel: Skeleton3D, dt: float, free: bool = false) -> void:
	var xf := skel.global_transform
	for i in 2:
		var d: Vector3 = xf.basis * (skel.get_bone_global_pose(int(_ball[i])).origin - skel.get_bone_global_pose(_bones[i][2]).origin) if int(_ball[i]) >= 0 else Vector3.ZERO
		_boff[i] = Vector3(d.x, 0.0, d.z)
	var was: Array = _state.duplicate()
	super(skel, dt, free)
	# probes: what moved a low foot's ball this frame
	for i in 2:
		var ball: Vector3 = (last_target[i] as Vector3) + (_boff[i] as Vector3)
		if _shown[i] != null and _ground[i] != null and (last_target[i] as Vector3).y - float(_ground[i]) < 0.03:
			var d := _flat(ball - (_shown[i] as Vector3))
			if d / dt > 0.15:
				var key: String = (str(_state[i]) if str(was[i]) == str(_state[i]) else "%s -> %s" % [str(was[i]), str(_state[i])]) + " in " + ("the guard" if _ap.current_animation == &"pro_idle" else ("a step take" if str(_ap.current_animation).begins_with("st_") else "another take")) + (" (leg at its reach)" if _out[i] != null and ((_out[i] as Vector3) - (last_target[i] as Vector3)).length() > 0.004 else "")
				tally[key] = snappedf(float(tally.get(key, 0.0)) + d, 0.01)
		_shown[i] = ball


func _target(i: int, anim: Vector3, vel: Vector3, delta: float, hip: Vector3, leg: float) -> Vector3:
	var clip := str(_ap.current_animation) if _ap != null else ""
	var row: Variant = feet_db.get(clip)
	var off: Vector3 = _boff[i]
	if not (row is Dictionary):
		_lift[i] = {}
		_pin[i] = null
		_state[i] = "no table"
		return super(i, anim, vel, delta, hip, leg)
	var key: String = ("RL" if south else "LR")[i]
	var t := _ap.current_animation_position
	var sw := swing_at((row as Dictionary).get(key, []), t, _ap.current_animation_length)
	var floor_y := float(_ground[i])
	if sw.x < 0.0:
		if not (_lift[i] as Dictionary).is_empty():
			# the take has just put it down: it stands where it is SHOWN (a take cut while its foot was still in the air
			# - a punch out of a step - has not eased the foot onto its pose yet: pinning the pose there snapped the leg)
			_lift[i] = {}
			var shown: Vector3 = _out[i] if _out[i] != null else anim
			_plant[i] = Vector3(shown.x, anim.y, shown.z)
			_pin[i] = (_plant[i] as Vector3) + off
		if not (_swing[i] as Dictionary).is_empty():
			_pin[i] = null
			_state[i] = "FootPlant's step"
			return super(i, anim, vel, delta, hip, leg)   # a step of FootPlant's own finishes
		if _pin[i] == null:
			_pin[i] = (_plant[i] as Vector3) + off
		var b: Vector3 = _pin[i]
		var p := Vector3(b.x - off.x, anim.y, b.z - off.z)   # the ankle that keeps the ball there
		_plant[i] = p
		if _flat(anim - p) > HOLD_M and sw.y > SOON_S:
			own += 1
			_pin[i] = null
			_state[i] = "FootPlant's step"
			return super(i, anim, vel, delta, hip, leg)   # left behind and the take is not about to lift it
		_state[i] = "pinned"
		return Vector3(p.x, maxf(anim.y, floor_y), p.z)
	# the take has this foot in the air
	var u := clampf((t - sw.x) / maxf(sw.y - sw.x, 0.02), 0.0, 1.0)
	var k := 1.0 - u * u * (3.0 - 2.0 * u)
	var l: Dictionary = _lift[i]
	if l.is_empty():
		var from: Vector3 = _out[i] if _out[i] != null else _plant[i]   # where it is shown now
		_swing[i] = {}
		l = {"o": Vector3(from.x - anim.x, 0.0, from.z - anim.z), "k0": maxf(k, 0.05)}
		_lift[i] = l
		took += 1
	var at: Vector3 = anim + (l["o"] as Vector3) * minf(k / float(l["k0"]), 1.0)
	_plant[i] = Vector3(at.x, anim.y, at.z)
	_pin[i] = null
	_state[i] = "the take's step"
	return Vector3(at.x, maxf(anim.y, floor_y), at.z)


## StepPlay: the plan is about to move his body under the take he is in - foot i steps now (FootPlant's own step: it
## lands under the pose as the body arrives) instead of when it has been left behind. Not while its take has it in the
## air, nor while a step of either foot is under way.
func kick(i: int) -> void:
	if i < 0 or i >= _swing.size() or _plant[i] == null or not (_lift[i] as Dictionary).is_empty():
		return
	if not (_swing[0] as Dictionary).is_empty() or not (_swing[1] as Dictionary).is_empty():
		return
	_swing[i] = {"from": _plant[i], "t": 0.0}
	_pin[i] = null
	own += 1


func _wake() -> void:
	super()
	_lift = [{}, {}]
	_pin = [null, null]
	_shown = [null, null]


func _save() -> Dictionary:
	var st := super()
	st["lift"] = [(_lift[0] as Dictionary).duplicate(), (_lift[1] as Dictionary).duplicate()]
	st["pin"] = _pin.duplicate()
	return st


func _load(st: Dictionary) -> void:
	super(st)
	if st.has("lift"):
		_lift = [(st["lift"][0] as Dictionary).duplicate(), (st["lift"][1] as Dictionary).duplicate()]
		_pin = (st["pin"] as Array).duplicate()
