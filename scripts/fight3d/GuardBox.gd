extends SkeletonModifier3D
## S510 ANIMATION LOOP (blind r11 AND r12, both critics: "blue's free glove shoots straight up above his head after
## punches", r12 ex1 #40-47, ex2 #27-30, ex4 #25-32, ex5 #35-36; animator: "the hand not punching stays inside a box: from
## the chin to 10 cm above the brow ... zero frames with a glove above the top of the head outside a punch"). The r12 log
## had the free wrist 8-14 cm OVER the head bone in rear crosses while GuardTuck's free hold aims it 4 cm under: layers
## after the hold (the glove clash push off the other's punching arm, the trunk cap turning the trunk under the arm) lift
## it, the forearm stands up and the glove's top clears the crown. This is the last arm word, after PopCap: while a punch
## plays, the hand that is NOT punching keeps its glove's top (wrist + TOP_ALONG_M along the forearm) under the head bone
## + TOP_M (about the crown); the excess over a soft knee pulls the wrist straight down, the arm re-solved as a two-bone
## chain with the hand's rotation kept. Eased in and out over EASE_S so a punch's start or end never pops the glove.
## `-- noguardbox` = the control arm.
##   attach(skel, ap, lead) -> the modifier, placed last before the twist bones   over_cm (probes: the cut this frame)

const PunchReach := preload("res://scripts/fight3d/PunchReach.gd")
const GuardTuck := preload("res://scripts/fight3d/GuardTuck.gd")

const TOP_M := 0.19        # head bone -> 10 cm over the brow (MetaHuman: the Head bone sits at the base of the skull; the crown is ~0.22)
const TOP_ALONG_M := 0.19  # wrist -> the glove's top along the forearm (Gloves.SIZE 1.2: 0.12 behind, 0.19 ahead)
const SOFT_M := 0.03       # a soft knee: the glove's top may show at most this over the line
const EASE_S := 0.08

static var on: bool = not OS.get_cmdline_user_args().has("noguardbox")

var ap: AnimationPlayer
var lead := "LeftHand"
var over_cm := 0.0
var _w := 0.0
var _hand := ""
var _arms := {}
var _head := -1


static func attach(skel: Skeleton3D, player: AnimationPlayer, lead_hand: String) -> Node:
	if not on or skel == null or player == null:
		return null
	var gb: SkeletonModifier3D = (load("res://scripts/fight3d/GuardBox.gd") as GDScript).new()
	gb.name = "GuardBox"
	gb.set("ap", player)
	gb.set("lead", lead_hand)
	if not gb.call("_setup", skel):
		gb.free()
		return null
	skel.add_child(gb)
	return gb


func _setup(skel: Skeleton3D) -> bool:
	_head = skel.find_bone("Head")
	for side in ["Left", "Right"]:
		var ids := [skel.find_bone(side + "UpperArm"), skel.find_bone(side + "LowerArm"), skel.find_bone(side + "Hand")]
		if ids.has(-1):
			return false
		_arms[side + "Hand"] = ids
	return _head >= 0


## How far (skeleton units) the glove's top may stay over the line when it is `over` past it: a soft knee, never SOFT_M.
static func keep(over: float, soft: float) -> float:
	if over <= 0.0:
		return over
	return soft * (1.0 - exp(-over / soft))


func _process_modification() -> void:
	over_cm = 0.0
	var skel := get_skeleton()
	if skel == null or ap == null:
		return
	var free := GuardTuck.free_of(str(ap.assigned_animation), lead)
	if free != "":
		_hand = free
	_w = move_toward(_w, 1.0 if free != "" else 0.0, get_process_delta_time() / EASE_S)
	if _w <= 0.0 or _hand == "":
		return
	var k := skel.global_transform.basis.get_scale().x
	var ids: Array = _arms[_hand]
	var g_la: Transform3D = skel.get_bone_global_pose(int(ids[1]))
	var g_hd: Transform3D = skel.get_bone_global_pose(int(ids[2]))
	var along := (g_hd.origin - g_la.origin).normalized()
	var top := g_hd.origin + along * TOP_ALONG_M / k
	var line := skel.get_bone_global_pose(_head).origin.y + TOP_M / k
	var over := top.y - line
	if over <= 0.0:
		return
	var cut := (over - keep(over, SOFT_M / k)) * _w * _w * (3.0 - 2.0 * _w)
	over_cm = cut * k * 100.0
	var s: Vector3 = skel.get_bone_global_pose(int(ids[0])).origin
	PunchReach.solve(skel, ids, s, g_hd.origin + Vector3.DOWN * cut, s.distance_to(g_la.origin), g_la.origin.distance_to(g_hd.origin), g_hd.basis)
