extends RefCounted
## S379 the Grappling theatre's chains (operator: "a tool where i can see the real sequence happening to understand how
## natural the transitions etc look maybe like a documentary style or movie prop"). Eight real BJJ chains, each a path
## through the GrappleMap graph (assets/grapplemap/graph.json; a step = one recorded transition, the next step starts on
## the position the last one landed on). Picked from the community chains in ops/research/grappleflows_moves_S379.json
## (facts only: Front Headlock -> Back Take, Back Control -> Rear Naked Choke, Side Control -> Knee On Belly, Single Leg X
## -> Heel Hook, Arm Drag -> Back Control, Triangle <-> Armbar ...) and walked by hand in the graph S379. GrappleMap has no
## armbar from mount, so the hip-bump chain ends in the mounted triangle and the armbar closes the knee-cut chain instead.
## Captions are ours (plain words, one line); `name` follows the GrappleMap title or its tags.
##   chains() -> Array of {id, title, sub, key, steps: [{id, rev, name, line}]}
##   resolve(graph, chain) -> {ok, errors, path: [{id, from, to}]}   (a valid path = each step starts where the last landed)
##   reel(db, chain) -> {frames, steps: [{name, line, title, k0, k1}], joins: [{k, err, dropped}]}   one straight sequence
## Pure: preloads the GrappleMap reader and graph helpers only.

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const Graph := preload("res://scripts/grapple/GrappleGraph.gd")
## Two recordings of the same position closer than this (mean joint distance, metres) are one keyframe: the next move's
## first frame is dropped and the chain runs on without a join gap.
const SAME_M := 0.02

const CHAINS := [
	{"id": "hip_bump", "title": "Hip bump to mounted triangle", "sub": "closed guard, sweep, mount, triangle", "key": 3,
		"steps": [
			{"id": 695, "name": "Hip bump", "line": "From closed guard: sit up and drive the hips into the top player."},
			{"id": 736, "name": "Sweep finish", "line": "The bump rolls the top woman over: the bottom one comes up in mount."},
			{"id": 719, "name": "Posture up", "line": "In mount: sit up tall and free both arms."},
			{"id": 720, "name": "Mounted triangle", "line": "A knee slides up; head and arm are trapped between the legs."}]},
	{"id": "guard_pull", "title": "Guard pull to butterfly sweep", "sub": "collar tie, pull guard, butterfly, sweep", "key": 2,
		"steps": [
			{"id": 1463, "name": "Collar tie and tricep", "line": "Standing: one hand holds the neck, the other grabs the tricep."},
			{"id": 1293, "name": "Pull guard", "line": "Sit down and pull the partner onto the butterfly hooks."},
			{"id": 1202, "name": "Sit up", "line": "From the back: sit up into seated butterfly with an underhook."},
			{"id": 1203, "name": "Butterfly sweep", "line": "A hook under the thigh lifts and turns the partner; the sweeper lands on top."}]},
	{"id": "front_headlock", "title": "Front headlock to rear naked choke", "sub": "snapdown, back take, choke", "key": 4,
		"steps": [
			{"id": 986, "name": "Snapdown", "line": "Pull the head down and sprawl into a front headlock."},
			{"id": 1385, "name": "Cartwheel to the back", "line": "A spin over the turtle lands on the back with a seatbelt."},
			{"id": 1830, "name": "Wrist control", "line": "On the back: pin the wrists so the arms cannot defend the neck."},
			{"id": 1832, "name": "Flatten", "line": "Stretch the partner out flat on the mat."},
			{"id": 1924, "name": "Rear naked choke", "line": "Arm under the chin and squeeze: the choke from the back."}]},
	{"id": "fifty_fifty", "title": "Single leg X to 50/50 heel hook", "sub": "ankle tie, single leg X, ashi, 50/50", "key": 3,
		"steps": [
			{"id": 1547, "name": "Ankle to ankle", "line": "Seated: a foot hooks behind the standing player's ankle."},
			{"id": 1549, "name": "Single leg X", "line": "Both legs thread around one leg: single leg X guard."},
			{"id": 1468, "name": "Single leg X sweep", "line": "Kick the leg out; the partner sits down into ashi garami."},
			{"id": 1235, "name": "To 50/50", "line": "The legs tangle the same way on both sides; the heel is open for the heel hook."}]},
	{"id": "knee_cut", "title": "Knee cut pass to armbar", "sub": "half guard pass, side control, knee on belly, armbar", "key": 3,
		"steps": [
			{"id": 1007, "name": "Knee inside", "line": "From half guard: drive a knee between the partner's legs."},
			{"id": 1008, "name": "Knee cut pass", "line": "The knee slices over the thigh and settles into side control."},
			{"id": 866, "name": "Bottom turns away", "line": "The bottom player turns to the side to escape the pin."},
			{"id": 1061, "name": "Knee on belly", "line": "Pop up and drive a knee into the belly."},
			{"id": 1059, "name": "Armbar", "line": "Step over the head and straighten the arm across the hips."}]},
	{"id": "double_leg", "title": "Double leg to the pass", "sub": "duck under, double leg, chest pass, side control", "key": 2,
		"steps": [
			{"id": 2015, "name": "Duck under", "line": "Duck under the arm and come up at the partner's side."},
			{"id": 2016, "name": "Double leg", "line": "Drop the level and grab both legs."},
			{"id": 1038, "name": "Takedown", "line": "Drive through and down: both land on the mat, the shooter on top."},
			{"id": 1062, "name": "Chest pass", "line": "The bottom player fights; the legs get smashed and the chest passes."},
			{"id": 666, "name": "Side control", "line": "The pass is done: settled behind with both arms under."}]},
	{"id": "armbar_triangle", "title": "Armbar to triangle", "sub": "closed guard armbar, arm pulled out, triangle", "key": 2,
		"steps": [
			{"id": 693, "name": "Armbar", "line": "From closed guard: a leg swings over the head and stretches the arm."},
			{"id": 694, "name": "Arm pulled out", "line": "The partner pulls the arm free; one leg stays over the shoulder."},
			{"id": 679, "name": "Triangle lock", "line": "The legs lock around head and arm: the triangle choke."}]},
	{"id": "arm_drag", "title": "Arm drag to the back", "sub": "arm drag, body lock, seated back, choke", "key": 4,
		"steps": [
			{"id": 945, "name": "Arm drag", "line": "Pull the arm across the body and step to the side."},
			{"id": 946, "name": "To the back", "line": "Slip behind and lock the hands around the waist."},
			{"id": 1041, "name": "Posture up", "line": "The partner stands tall and fights the grip."},
			{"id": 1042, "name": "Seated back take", "line": "Sit down behind, feet in behind the knees, keep the seatbelt."},
			{"id": 1237, "name": "Arm trap choke", "line": "Trap an arm and finish the rear naked choke."}]},
]


static func chains() -> Array:
	return CHAINS


static func ids() -> Array:
	return CHAINS.map(func(c): return str(c["id"]))


static func chain(id: String) -> Dictionary:
	for c in CHAINS:
		if str(c["id"]) == id:
			return c
	return {}


## The chain as graph positions: a step starts on (to if reversed, else from) and lands on the other end; each step must
## start where the last one landed, every end must be a matched position, and every id a transition (2+ keyframes).
static func resolve(graph: RefCounted, c: Dictionary) -> Dictionary:
	var errors: PackedStringArray = []
	var path: Array = []
	var last: Variant = null
	for i in (c["steps"] as Array).size():
		var s: Dictionary = c["steps"][i]
		var t: Dictionary = graph.get_entry(int(s["id"]))
		if t.is_empty() or not t.has("frames"):
			errors.append("step %d: %d is not a GrappleMap transition" % [i, int(s["id"])])
			last = null
			continue
		var rev := bool(s.get("rev", false))
		if rev and not bool(t["bidirectional"]):
			errors.append("step %d: %d is one-way, cannot play it backwards" % [i, int(s["id"])])
		var from: Variant = t["to"] if rev else t["from"]
		var to: Variant = t["from"] if rev else t["to"]
		if from == null or to == null:
			errors.append("step %d: %d has an end on no position" % [i, int(s["id"])])
		elif i > 0 and last != null and int(from) != int(last):
			errors.append("step %d: %d starts on %d, the last step landed on %d" % [i, int(s["id"]), int(from), int(last)])
		path.append({"id": int(s["id"]), "from": from, "to": to})
		last = to
	return {"ok": errors.is_empty(), "errors": errors, "path": path}


## The chain as ONE straight keyframe sequence, the recorded data and nothing on top: each move laid on the last
## keyframe of the one before (GrappleGraph.align: men relabelled, turned about the vertical and moved on the mat - the
## browser's chaining), its keyframes appended. A first keyframe that repeats the last one (SAME_M) is dropped; otherwise
## the join is one short gap the player curves through (GrappleTiming paces it like any other gap).
## steps[i]: k0 = the keyframe it starts on (the last one's end), k1 = its own last keyframe. joins[i-1] = the join
## into step i: k (= steps[i].k0), err (align's mean joint distance, metres), dropped.
static func reel(db: Array, c: Dictionary) -> Dictionary:
	var frames: Array = []
	var steps: Array = []
	var joins: Array = []
	for i in (c["steps"] as Array).size():
		var s: Dictionary = c["steps"][i]
		var src: Array = db[int(s["id"])]["frames"]
		var rev := bool(s.get("rev", false))
		var how := {"swap": false, "mirror": false, "xform": Transform3D.IDENTITY, "err": 0.0}
		if not frames.is_empty():
			how = Graph.align(frames.back(), src.back() if rev else src[0])
		var placed: Array = Graph.placed(src, how, rev)
		var k0 := maxi(frames.size() - 1, 0)
		if not frames.is_empty():
			var dropped := mean_gap(frames.back(), placed[0]) < SAME_M
			if dropped:
				placed.remove_at(0)
			joins.append({"k": k0, "err": float(how["err"]), "dropped": dropped})
		frames.append_array(placed)
		steps.append({"name": str(s["name"]), "line": str(s["line"]), "id": int(s["id"]),
			"title": Graph.clean(str(db[int(s["id"])]["title"])), "k0": k0, "k1": frames.size() - 1})
	return {"frames": frames, "steps": steps, "joins": joins}


## Mean distance between two keyframes' joints (both men), metres.
static func mean_gap(a: Array, b: Array) -> float:
	var sum := 0.0
	var n := 0
	for m in 2:
		for j in DB.JOINTS.size():
			sum += (a[m] as PackedVector3Array)[j].distance_to((b[m] as PackedVector3Array)[j])
			n += 1
	return sum / maxf(1.0, n)
