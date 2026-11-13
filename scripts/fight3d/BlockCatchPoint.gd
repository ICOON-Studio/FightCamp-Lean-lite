extends RefCounted
## BLOCKLOOK4 (owner marks 1-3: "the arm looks shorter", "90 degrees angle ? wtf is that move ?"; Claude S450: move the
## CATCH, not the punch): where the catching glove meets a blocked punch. The punch is armed as today (FightStage.arm_block
## carries its front onto this glove), so the glove goes out to the point where the puncher's arm is at REACH_SHARE of its
## landed reach: a straight on the line from her punching shoulder to the blocker's face, a hook on its own arc (the hand's
## way round from that shoulder, at the hook's elbow). The glove's centre sits the glove front and the punch's stop
## (FightStage.BLOCK_SURFACE_M) further on toward the face, so the front stops on it. Kept inside the blocker's own arm.

const REACH_SHARE := 0.95      # of the landed twin's reach (the bar: 0.90); the landed straight is near its full arm
const STRAIGHT_ARM := 0.97     # a landed straight's hand at this share of the arm (block_catch: 0.48-0.53 m of ~0.53)
const HOOK_ELBOW_DEG := 97.0   # a landed hook's elbow (block_catch: 92-99 deg) - its reach on the arc
const SURFACE_M := 0.045       # FightStage.BLOCK_SURFACE_M: the punch's front stops this far off the glove's mount
const ARM_SHARE := 0.97        # the catching glove at most this share of HER arm from her shoulder
const FWD_MIN := 0.11          # the glove's centre at least this far in front of her face (block_catch CATCH 0.06-0.14, and the
const FWD_MAX := 0.135         # absorb's 3-5 cm knock must leave it >= 0.08 off her face) and at most this far: where the 90 %
                               # point is nearer her than FWD_MIN (the puncher stands inside his landed reach) it slides OUT
                               # along the punch's line, toward his shoulder, to FWD_MIN; never past FWD_MAX


## World point for the catching glove (its hand bone), or Vector3.INF when the puncher's arm cannot be read.
## `pst` the puncher's skeleton, `phand` its punching hand bone, `front_m` its glove front (metres, scaled), `face` her face
## point, `hook` a hook's arc, `her_sh` / `her_arm` the catching shoulder (world) and arm length.
static func point(pst: Skeleton3D, phand: String, front_m: float, face: Vector3, fwd: Vector3, hook: bool, her_sh: Vector3, her_arm: float) -> Vector3:
	var side := phand.trim_suffix("Hand")
	var u_i := pst.find_bone(side + "UpperArm")
	var l_i := pst.find_bone(side + "LowerArm")
	var h_i := pst.find_bone(phand)
	if u_i < 0 or l_i < 0 or h_i < 0:
		return Vector3.INF
	var xf := pst.global_transform
	var s: Vector3 = xf * pst.get_bone_global_pose(u_i).origin
	var e: Vector3 = xf * pst.get_bone_global_pose(l_i).origin
	var h: Vector3 = xf * pst.get_bone_global_pose(h_i).origin
	var l1 := s.distance_to(e)
	var l2 := e.distance_to(h)
	var reach := (l1 + l2) * STRAIGHT_ARM
	var u := (face - s).normalized()
	if hook:
		reach = sqrt(l1 * l1 + l2 * l2 - 2.0 * l1 * l2 * cos(deg_to_rad(HOOK_ELBOW_DEG)))
		var toh := h - s
		if toh.length() > 1e-3:
			u = toh.normalized()   # on its arc: the way the hand is going round from the shoulder
	var hand := s + u * reach * REACH_SHARE
	var v := (face - hand).normalized()
	var g := hand + v * (front_m + SURFACE_M)
	var back := s - g   # the punch's line, back toward his shoulder
	var f := (g - face).dot(fwd)
	var want := clampf(f, FWD_MIN, FWD_MAX)
	if absf(want - f) > 1e-4 and absf(back.dot(fwd)) > 1e-3:
		g += back * ((want - f) / back.dot(fwd))
	if g.distance_to(her_sh) > her_arm * ARM_SHARE:
		g = her_sh + (g - her_sh).normalized() * her_arm * ARM_SHARE
	return g
