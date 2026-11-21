extends RefCounted
## ARMBUILD1 (S534, the owner: "the fighter's arms are too skiny , do they change according to power attributes ?" ->
## his pick "Follow Strength"): a boxer's arms and shoulders are as thick as his Strength says, in the 3D fight.
##   k(strength)        the thickness factor: 40 -> 1.00, 60 -> 1.12, 80 -> 1.24 (0.96 .. 1.30; owner S534 "make it stronger")
##   apply(skel, k)     sets it on one body, once (the takes carry rotations only: a pose scale stays, measured)
##   setup(stage)       both boxers of a built stage, each from his own Strength (Player2.setup calls it)
## WHICH BONES (measured on the MetaHuman rig): the bones that carry the limb - LeftUpperArm, LeftLowerArm, LeftHand,
## LeftShoulder - are NOT scaled. A scale on one of them is inherited by the next bone down, and once the elbow bends
## that stretches the forearm and moves the glove. The muscle and twist helpers that hang on them carry the skin of the
## arm and nothing else, so they take the scale: on the two axes across the limb, never along it. The arm's length, the
## reach, the guard, the punch targets, the arm finish and the gloves read exactly as before.
## The neck is left alone: it has no helper bone, and a scale on it would move the head, which is the punch target.
##   `-- armstr=40,80` sets the two Strengths by hand (a still pair); `force` does the same for a test.

const Attrs := preload("res://scripts/rules/Attrs.gd")

## Helper bone (the name before _l / _r) -> how much of the change it takes.
const BONES := {
	"upperarm_twist_01": 1.0, "upperarm_twist_02": 1.0, "upperarm_correctiveRoot": 1.0,
	"lowerarm_twist_02": 1.0, "lowerarm_correctiveRoot": 1.0,
	"lowerarm_twist_01": 0.5,          # next to the wrist: a wrist does not grow with muscle, and the glove's cuff sits on it
	"clavicle_out": 1.0, "clavicle_scap": 1.0,                # the shoulder: the deltoid and the trapezius side
	"clavicle_pec": 0.5, "spine_04_latissimus": 0.5,          # the upper chest and the back, a little
}

static var force: Array = []   # a test: [red's Strength, blue's Strength]; a number under 0 = none known


static func k(strength: float) -> float:
	return clampf(1.0 + (strength - 40.0) * 0.006, 0.96, 1.30)


## A man's Strength (0-100), or -1 when his data has none.
static func strength_of(who: Dictionary) -> float:
	var has_attrs: bool = who.get("attrs") is Dictionary and not (who["attrs"] as Dictionary).is_empty()
	var has_stats: bool = who.get("stats") is Dictionary and not (who["stats"] as Dictionary).is_empty()
	if not has_attrs and not has_stats:
		return -1.0
	return float((Attrs.of(who) as Dictionary).get("strength", -1.0))


## Sets thickness `factor` on one body. Returns how many bones took it (0 = not this rig: nothing changes).
static func apply(skel: Skeleton3D, factor: float) -> int:
	var done := 0
	for stem in BONES:
		var f := 1.0 + (factor - 1.0) * float(BONES[stem])
		for side in ["_l", "_r"]:
			var b := skel.find_bone(str(stem) + str(side))
			if b < 0:
				continue
			# The limb runs along the parent's X on this rig (every next joint's rest sits on it): the helper's own axis
			# nearest to that stays 1, the other two take the factor.
			var along: Vector3 = skel.get_bone_rest(b).basis.orthonormalized().inverse() * Vector3.RIGHT
			var s := Vector3(f, f, f)
			s[along.abs().max_axis_index()] = 1.0
			skel.set_bone_pose_scale(b, s)
			done += 1
	return done


## The two Strengths of the fight on screen: red (ours), blue (the opponent).
static func strengths(stage: Node) -> Array:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("armstr="):
			var p := str(a).substr(7).split(",")
			return [float(p[0]), float(p[p.size() - 1])]
	if force.size() == 2:
		return force
	var n: Node = stage.get_parent()
	while n != null:   # the fight view that built the stage knows who fights
		var main: Variant = n.get("main")
		if n.get("fid") != null and main is Object and (main as Object).get("career") != null:
			var f: Variant = ((main as Object).get("career") as Object).call("fighter_by_id", str(n.get("fid")))
			if f is Dictionary:
				var opp: Variant = ((f as Dictionary).get("bout", {}) as Dictionary).get("opp", {})
				return [strength_of(f), strength_of(opp if opp is Dictionary else {})]
		n = n.get_parent()
	return [-1.0, -1.0]


static func setup(stage: Node) -> void:
	var s := strengths(stage)
	for i in mini(2, (stage.get("boxers") as Array).size()):
		if float(s[i]) >= 0.0:
			apply(stage.get("boxers")[i]["skel"], k(float(s[i])))
