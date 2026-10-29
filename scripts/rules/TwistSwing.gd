extends RefCounted
## S264 MHTWIST1 - RigLogic's TWIST/SWING joint layer as a PURE module.
##
## The MetaHuman body's DNA carries eight twist joints (forearm / upper-arm / thigh / calf twists per side) whose rotation
## is a fixed fraction of their driver's twist about its own axis. Unreal evaluates them with RigLogic's
## TwistSwingJointsEvaluator; Godot imports the joints but nothing drives them, and MetaHumanTwist.gd drives them by
## hand-picked fractions. This module is Epic's evaluator ported LINE FOR LINE, so Claude can extract the DNA's setups to
## JSON and play them back exactly.
##
## Source (UE 5.8, Epic's own code):
##   Engine/Plugins/Animation/RigLogic/Source/RigLogicLib/Private/riglogic/joints/cpu/twistswing/TwistSwingJointsEvaluator.h
##   Engine/Plugins/Animation/RigLogic/Source/RigLogicLib/Public/tdm/Computations.h    (slerp, inverse)
## Quaternions are (x, y, z, w) and `*` is the Hamilton product - identical to Godot's Quaternion * Quaternion, so the
## port needs no axis or sign conversion. Nothing is "improved" and nothing is "fixed": both Epic quirks are reproduced
## on purpose (below).
##
## PURE: zero preloads, no autoload, no Node and no scene access, no file or network access; every input is passed in and
## no input dictionary is ever written to. The same arguments always give the same result.
##
## A SETUP (a Dictionary - exactly what a DNA extraction writes out as JSON):
##   twist_axis:    int            0 = X, 1 = Y, 2 = Z - the driver's own twist axis for the twist half
##   twist_input:   String         key into `inputs` (the driver joint's local rotation); missing/"" = no twist half
##   twist_weights: Array[float]   one per twist output (0 = the full twist, 1 = identity)
##   twist_outputs: Array[String]  joints written
##   swing_axis:    int            axis the SWING half separates its twist on
##   swing_input:   String         key into `inputs`; missing/"" = no swing half
##   swing_weights: Array[float]
##   swing_outputs: Array[String]
##
## EVALUATION of one setup (TwistSwingJointsEvaluator::evaluate):
##   inv_twist = IDENTITY
##   if setup has swing_input:
##       q = inputs[swing_input]
##       twist = separate_twist(q, swing_axis)
##       inv_twist = rl_inverse(twist)
##       swing = q * inv_twist
##       inv_swing = rl_inverse(swing)
##       for i: out[swing_outputs[i]] = inv_twist * rl_slerp(inv_swing, IDENTITY, swing_weights[i])
##   if setup has twist_input and NOT swing_input:
##       q = inputs[twist_input]
##       inv_twist = separate_twist(q, twist_axis)      # Epic: "No actual inversion is needed here"
##   for i: out[twist_outputs[i]] = rl_slerp(inv_twist, IDENTITY, twist_weights[i])
##
## THE TWO QUIRKS, kept exactly as Epic wrote them:
##   1. a MERGED setup (swing and twist on the same driver) feeds its twist outputs the INVERSE twist the swing half
##      computed, so at weight 0 the twist joint counter-rotates the driver;
##   2. a TWIST-ONLY setup feeds its twist outputs the twist itself, so at weight 0 the twist joint follows the driver.
## In both cases a weight of 1 gives IDENTITY and a weight of 0 gives the full (inverse) twist.
##
## Nothing in the game calls this module yet: MetaHumanTwist.gd still drives the eight twists by hand-picked fractions.

## tdm::slerp's epsilon (FLT_EPSILON, UE 5.8 tdm/Computations.h): above 1 - this the two quaternions are close enough
## to interpolate linearly instead of taking acos()/sin().
const FLT_EPSILON: float = 1.1920929e-07


## RigLogic's separateTwist: the twist part of `q` about `axis` (0 = X, 1 = Y, 2 = Z), normalised.
## t = (q.x, 0, 0, q.w) / (0, q.y, 0, q.w) / (0, 0, q.z, q.w); a ZERO projection returns IDENTITY (a driver rotated
## 180 deg about a different axis has no twist about this one). Any other axis returns IDENTITY too - validate() rejects
## it, Epic's caller never passes one.
static func separate_twist(q: Quaternion, axis: int) -> Quaternion:
	var t: Quaternion
	match axis:
		0:
			t = Quaternion(q.x, 0.0, 0.0, q.w)
		1:
			t = Quaternion(0.0, q.y, 0.0, q.w)
		2:
			t = Quaternion(0.0, 0.0, q.z, q.w)
		_:
			return Quaternion.IDENTITY
	if t.length_squared() == 0.0:
		return Quaternion.IDENTITY
	return t.normalized()


## tdm's quaternion inverse: conjugate(q) * (1 / |q|^2). The zero quaternion has no inverse, so IDENTITY is returned
## instead of Epic's division by zero - unreachable for a rotation read off a bone.
static func rl_inverse(q: Quaternion) -> Quaternion:
	var len_sq: float = q.length_squared()
	if len_sq == 0.0:
		return Quaternion.IDENTITY
	return Quaternion(-q.x, -q.y, -q.z, q.w) * (1.0 / len_sq)


## tdm::slerp, ported exactly: the shortest path (q and -q are the same rotation) and the linear branch when the inputs
## are within FLT_EPSILON of each other - the branch that keeps a duplicated pose from giving sin(0)/0 = NaN.
## NOT Godot's Quaternion.slerp(): the same epsilon as Epic and NO normalisation at the end, component-wise result.
static func rl_slerp(q1: Quaternion, q2: Quaternion, t: float) -> Quaternion:
	var c: float = q1.dot(q2)
	var tmp: Quaternion = q2
	if c < 0.0:
		tmp = -tmp
		c = -c
	var t1: float
	var t2: float
	if c > 1.0 - FLT_EPSILON:
		t1 = 1.0 - t
		t2 = t
	else:
		var th: float = acos(c)
		var s: float = sin(th)
		t1 = sin((1.0 - t) * th) / s
		t2 = sin(t * th) / s
	return Quaternion(q1.x * t1 + tmp.x * t2, q1.y * t1 + tmp.y * t2,
		q1.z * t1 + tmp.z * t2, q1.w * t1 + tmp.w * t2)


## One setup -> output joint name to local Quaternion (a fresh Dictionary the caller owns).
## Inside a setup the order is Epic's: swing outputs first, then twist outputs, so a setup naming one joint in both
## halves leaves the twist value in the result. A driver the caller did not pass (its name is not in `inputs`) is an
## error in the CALLER, not in validate(): push_error and write nothing for this setup rather than evaluate a zero
## quaternion.
static func evaluate(setup: Dictionary, inputs: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	var inv_twist: Quaternion = Quaternion.IDENTITY
	var swing_input: String = _declared_input(setup, "swing_input")
	var twist_input: String = _declared_input(setup, "twist_input")
	if not swing_input.is_empty():
		if not inputs.has(swing_input):
			push_error("TwistSwing.evaluate: swing_input '%s' is not in inputs" % swing_input)
			return {}
		var swing_driver: Quaternion = inputs[swing_input]
		var swing_weights: Array = setup.get("swing_weights", [])
		var swing_outputs: Array = setup.get("swing_outputs", [])
		var twist: Quaternion = separate_twist(swing_driver, int(setup.get("swing_axis", 0)))
		inv_twist = rl_inverse(twist)
		var swing: Quaternion = swing_driver * inv_twist
		var inv_swing: Quaternion = rl_inverse(swing)
		for s in mini(swing_weights.size(), swing_outputs.size()):
			out[str(swing_outputs[s])] = inv_twist * rl_slerp(inv_swing, Quaternion.IDENTITY, float(swing_weights[s]))
	if not twist_input.is_empty() and swing_input.is_empty():
		if not inputs.has(twist_input):
			push_error("TwistSwing.evaluate: twist_input '%s' is not in inputs" % twist_input)
			return {}
		var twist_driver: Quaternion = inputs[twist_input]
		# Epic: "No actual inversion is needed here."
		inv_twist = separate_twist(twist_driver, int(setup.get("twist_axis", 0)))
	var twist_weights: Array = setup.get("twist_weights", [])
	var twist_outputs: Array = setup.get("twist_outputs", [])
	for w in mini(twist_weights.size(), twist_outputs.size()):
		out[str(twist_outputs[w])] = rl_slerp(inv_twist, Quaternion.IDENTITY, float(twist_weights[w]))
	return out


## Every setup in order into ONE output buffer: a later setup overwrites an earlier setup's joint, as RigLogic writes
## the same buffer in order. Non-Dictionary entries are skipped (a half-extracted DNA table must not take the game down).
static func evaluate_all(setups: Array, inputs: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	for raw in setups:
		if typeof(raw) != TYPE_DICTIONARY:
			continue
		var setup: Dictionary = raw
		var part: Dictionary = evaluate(setup, inputs)
		for joint in part:
			out[joint] = part[joint]
	return out


## Every problem that would make a setup evaluate wrongly, as human-readable strings; [] means valid.
## Checked per DECLARED half (a half with an empty input is absent): the axis is 0..2, and weights and outputs are the
## same length. A half that declares weights or outputs but no input is dead - nothing would ever be written - and is
## reported too. Whether the input exists in the caller's `inputs` is evaluate()'s business, not validate()'s.
static func validate(setup: Dictionary) -> Array:
	var errors: Array = []
	_check_half(setup, "swing", errors)
	_check_half(setup, "twist", errors)
	return errors


## One half of validate(): axis, and weights against outputs.
static func _check_half(setup: Dictionary, prefix: String, errors: Array) -> void:
	var axis_key: String = prefix + "_axis"
	var weights_key: String = prefix + "_weights"
	var outputs_key: String = prefix + "_outputs"
	var input_name: String = _declared_input(setup, prefix + "_input")
	var weights: Array = setup.get(weights_key, [])
	var outputs: Array = setup.get(outputs_key, [])
	if input_name.is_empty():
		if not weights.is_empty() or not outputs.is_empty():
			errors.append("%s and %s are given without a %s_input" % [weights_key, outputs_key, prefix])
		return
	var axis: int = int(setup.get(axis_key, 0))
	if axis < 0 or axis > 2:
		errors.append("%s is %d, expected 0 (X), 1 (Y) or 2 (Z)" % [axis_key, axis])
	if weights.size() != outputs.size():
		errors.append("%s has %d weights but %s has %d outputs" % [weights_key, weights.size(), outputs_key, outputs.size()])


## The driver key a half declares. An absent, empty or non-String value means the half is absent (a JSON null from a
## DNA extraction lands here).
static func _declared_input(setup: Dictionary, key: String) -> String:
	var name: String = ""
	if setup.get(key) is String:
		name = setup[key]
	return name
