extends Node
## BODYLOOK1 (S492, operator on the S490 build: "their shoulders look weird and their walking too"). The corner-to-centre
## walk is a captured walk (ow_walk, CMU 07_01) and a captured take plays pure (RkPure's rule for the rk_ takes) - but
## this one never did: FootPlant, built to hold a planted fighting stance, stayed on under it. Measured on the real
## stage (tools/bodylook_walk.gd, the walk as the scenes play it): it folded her knees in up to 3.4 cm (1.4 in the take)
## and held her standing foot 2.5-9 cm off the canvas (1.9-5 in the take: a heel that lifts, as a step does).
## While a walk clip plays, FootPlant fades out through its `influence` (as RkPure fades a layer: no layer's own file
## changes) and back in after it; FootPlant wakes on the feet as they are shown (its own HUMANFIGHT1 rule).
##   WalkPure.attach(skel, ap, foot_plant) -> WalkPure | null

const CLIPS := ["ow_walk"]
const FADE_S := 0.15

var _ap: AnimationPlayer
var _layer: SkeletonModifier3D
var _held := false   # this node lowered the layer and has not handed it back yet


static func attach(skel: Skeleton3D, ap: AnimationPlayer, layer: Node) -> Node:
	if not layer is SkeletonModifier3D or OS.get_cmdline_user_args().has("nowalkpure"):
		return null
	var w := new()
	w.name = "WalkPure"
	w._ap = ap
	w._layer = layer as SkeletonModifier3D
	skel.add_child(w)
	return w


func _process(delta: float) -> void:
	if not is_instance_valid(_layer) or not is_instance_valid(_ap):
		return
	var walking := str(_ap.current_animation) in CLIPS
	if not walking and not _held:
		return   # nobody else's fade is touched (RkPure has the layer in a captured take)
	_held = true
	_layer.influence = move_toward(_layer.influence, 0.0 if walking else 1.0, maxf(delta, 1e-4) / FADE_S)
	if not walking and _layer.influence >= 1.0:
		_held = false
