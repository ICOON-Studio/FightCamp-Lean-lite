extends "res://scripts/fight3d/v2/PunchAim.gd"
## FIGHTPLAYER2 (S531, the owner on film 11: "the guard is supposed to protect the head , your fighters holding their
## hands away from their heads and they look like robots"; then, asked "fix the free hand during punches ...?": "Yes, do
## both"). The wait and the walking steps carry a tight guard since the bake (tools/step_bake.gd _guard_up); the punch
## takes are the Punch PRO actor's own long guard: while one hand punches the other wrist rides 26-30 cm from the head
## (tools/fight_persist_rulers.py FREE HAND: 21 punches of 31 over the bar on film 12), and every critic of eight films
## wrote "the other hand drops". This holds the hand that is NOT working at the face:
##   - a punch, a paw or a feint: the free hand;      - a fidget take: both hands.
## Its wrist goes to the guard's own place in front of the face (AT, below), the arm
## solved again (two-bone IK, the elbow in its own plane), eased in and out over EASE_S so nothing snaps. The punching
## arm, a reaction, a defence and the baked takes are left alone.
##   add(skel, player, i, after) -> GuardHold

## S531 b (the owner on film 12: "you put the blues hands way to back now"): the held wrist goes to its place IN FRONT
## of the face (the research's orthodox classic, tools/step_bake.gd GUARD_AT: [in front, out to its own side, up] from
## the head bone), not toward the head bone (the back of the skull).
const AT := {"lead": Vector3(0.21, 0.06, -0.11), "rear": Vector3(0.15, 0.08, -0.13)}
const EASE_S := 0.10
const HELD := {"punch": 1, "feint": 1, "fidget": 2}   # 1 = the free hand, 2 = both
static var hold_on: bool = not OS.get_cmdline_user_args().has("fp2nohold")

var p: Node = null            # Player2
var who := 0
var w: Array = [0.0, 0.0]     # per side (left, right): how much of the hold is on
var _arms: Array = []
var _head := -1


static func add(skel: Skeleton3D, player: Node, i: int, after: Node) -> Node:
	var m := new()
	m.name = "GuardHold"
	m.p = player
	m.who = i
	m._head = skel.find_bone("Head")
	for side in ["Left", "Right"]:
		m._arms.append([skel.find_bone(side + "UpperArm"), skel.find_bone(side + "LowerArm"), skel.find_bone(side + "Hand")])
	skel.add_child(m)
	skel.move_child(m, (after.get_index() + 1) if after != null else 0)
	return m


func _process_modification() -> void:
	if p == null or _head < 0 or not hold_on:
		return
	var take: Dictionary = p._take[who]
	var mode: int = int(HELD.get(str(take.get("kind", "")), 0))
	var want := [0.0, 0.0]
	if mode == 2:
		want = [1.0, 1.0]
	elif mode == 1:
		var row: Dictionary = (p.db.get("rows", {}) as Dictionary).get(str(take.get("clip", "")), {})
		var hand: String = p.st.hand_of(who, str(row.get("hand", "LeftHand")))
		want = [0.0, 1.0] if hand == "LeftHand" else [1.0, 0.0]
	var step := get_process_delta_time() / EASE_S
	var skel := get_skeleton()
	var head := skel.get_bone_global_pose(_head).origin
	# in front = toward the other man (his body's forward), in the skeleton's space
	var node: Node3D = p.st.boxers[who]["node"]
	var fwd: Vector3 = (skel.global_transform.basis.inverse() * node.global_transform.basis.z).normalized()
	var right := fwd.cross(Vector3.UP)
	var lead: String = p.st.hand_of(who, "LeftHand")
	for s in 2:
		w[s] = move_toward(float(w[s]), float(want[s]), step)
		var k := float(w[s])
		if k < 0.01 or (_arms[s] as Array).has(-1):
			continue
		k = k * k * (3.0 - 2.0 * k)
		var pa := skel.get_bone_global_pose(int(_arms[s][0]))
		var pb := skel.get_bone_global_pose(int(_arms[s][1]))
		var pc := skel.get_bone_global_pose(int(_arms[s][2]))
		var hand := "LeftHand" if s == 0 else "RightHand"
		var at: Vector3 = AT["lead"] if hand == lead else AT["rear"]   # skeleton space: the body's own size is the node's
		var to := head + fwd * at.x + right * at.y * (-1.0 if s == 0 else 1.0) + Vector3.UP * at.z
		var got: Array = _solve(pa, pb, pc, pc.origin.lerp(to, k))
		if got.is_empty():
			continue
		skel.set_bone_global_pose(int(_arms[s][0]), got[0])
		skel.set_bone_global_pose(int(_arms[s][1]), got[1])
