extends RefCounted
## S468 (owner markup C394 on the rear uppercut film, four boxes, each "still clipping"): the ruler for gloves and forearms
## passing through each other. Read from the bodies AS DRAWN (the glove nodes follow the skeleton after every modifier; the
## elbows through BoneAttachment3D nodes), never from GloveClear's own numbers, so it can read worse than the fix believes.
## Shapes, from the mounted glove mesh (assets/models/gloves/boxing_glove.glb at Gloves.SIZE 1.2: 0.17 m wide and deep,
## from 0.12 m behind the wrist to 0.19 m ahead of it): the glove is a capsule along its long axis from G0 to G1 ahead of
## the wrist, radius GR; the forearm a capsule elbow to wrist, radius FR. Times the body's own scale.
##   worst(stage) -> {depth: metres the deepest pair is inside each other (<= 0 = clear), pair: "0l glove x 1r forearm"}

const G0 := 0.04
const G1 := 0.115
const GR := 0.075
const FR := 0.04


## Boxer i's arms as drawn: [{side, glove: [a, b, r], fore: [elbow, wrist, r]}].
static func arms(stage: Node, i: int) -> Array:
	var out := []
	var skel: Skeleton3D = stage.boxers[i]["skel"]
	var gl: Node = stage.boxers[i].get("gloves")
	if gl == null:
		return out
	for side in ["l", "r"]:
		var g: Node3D = (gl.get("gloves") as Dictionary).get(side)
		if g == null:
			continue
		var xf := g.global_transform
		var k := xf.basis.y.length()
		var along := xf.basis.y / maxf(k, 1e-5)
		var elbow := _attach(skel, ("Left" if side == "l" else "Right") + "LowerArm").global_position
		out.append({"side": side, "glove": [xf.origin + along * G0 * k, xf.origin + along * G1 * k, GR * k], "fore": [elbow, xf.origin, FR * k]})
	return out


static func worst(stage: Node) -> Dictionary:
	var a := arms(stage, 0)
	var b := arms(stage, 1)
	var best := {"depth": -9.0, "pair": ""}
	for x in a:
		for y in b:
			for pair in [["glove", "glove"], ["glove", "fore"], ["fore", "glove"]]:
				var d := depth(x[pair[0]], y[pair[1]])
				if d > float(best["depth"]):
					best = {"depth": d, "pair": "0%s %s x 1%s %s (ranks %d %d)" % [x["side"], pair[0], y["side"], pair[1], _rank(stage, 0, x["side"]), _rank(stage, 1, y["side"])]}
	best["drift"] = drift(stage)
	for i in 2:
		var gc: Node = stage.boxers[i].get("gclear")
		if gc != null:
			gc.set("dbg_on", true)
			best["dbg%d" % i] = str(gc.get("dbg"))
	return best


## How far two capsules [a, b, r] are inside each other (metres; <= 0 = apart).
static func depth(c1: Array, c2: Array) -> float:
	var pts := Geometry3D.get_closest_points_between_segments(c1[0], c1[1], c2[0], c2[1])
	return float(c1[2]) + float(c2[2]) - (pts[0] as Vector3).distance_to(pts[1])


## Diagnosis: how far the wrists and elbows as GloveClear left them (its shown_arms, mid-stack) are from the drawn ones
## (after every later modifier), the worst of both boxers, metres. Large = a later layer moves the arms after the clearance.
static func drift(stage: Node) -> Vector2:
	var out := Vector2.ZERO   # x the wrists, y the elbows
	for i in 2:
		var gc: Node = stage.boxers[i].get("gclear")
		if gc == null:
			continue
		var seen: Dictionary = gc.get("shown_arms")
		for arm in arms(stage, i):
			var key := "Left" if arm["side"] == "l" else "Right"
			if seen.has(key) and (seen[key] as Array).size() >= 2:
				out.x = maxf(out.x, ((seen[key][1] as Vector3)).distance_to(arm["fore"][1]))
				out.y = maxf(out.y, ((seen[key][0] as Vector3)).distance_to(arm["fore"][0]))
	return out


## The hand's right of way as GloveClear holds it (2 a live punch, 1 going home, 0 a guard hand; -1 = no clearance on her).
static func _rank(stage: Node, i: int, side: String) -> int:
	var gc: Node = stage.boxers[i].get("gclear")
	return int(gc.call("_rank", "Left" if side == "l" else "Right")) if gc != null and gc.has_method("_rank") else -1


static func _attach(skel: Skeleton3D, bone: String) -> BoneAttachment3D:
	var nm := "clash_" + bone
	var n := skel.get_node_or_null(nm)
	if n == null:
		n = BoneAttachment3D.new()
		n.name = nm
		n.bone_name = bone
		skel.add_child(n)
	return n
