extends RefCounted
## S335 the GrappleMap graph for the position browser (operator: "a nice menu with in&outs like in the website for each
## position"): every position's moves IN and moves OUT, from assets/grapplemap/graph.json (tools/grapplemap_graph.py
## matched each move's first and last keyframe to a position: 2,703 of 2,970 ends). And the chaining: a move's first
## keyframe is its position turned / moved / mirrored / with the men swapped, so align() finds the relabel + turn about
## the vertical + shift that lays it on the pose on screen, and the next move starts where the last one ended.

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const GRAPH := "res://assets/grapplemap/graph.json"
## steady(): a keyframe gap this big (mean joint move, m) that a relabel cuts under RELABEL_LEFT of itself, and under
## RELABEL_FIT of what the pair turned and shifted alone leaves (the swap / mirror is what fits, not a real big move), is
## a relabel.
const RELABEL_GAP_M := 0.3
const RELABEL_LEFT := 0.5
const RELABEL_FIT := 0.65
## The families shown as the browser's tabs, each a tag set (GrappleMap's own tags).
const FAMILIES := [["Standing", "standing"], ["Guard", "full_guard"], ["Half guard", "half_guard"], ["Side control", "side_control"],
	["Mount", "mount"], ["Back", "back"], ["Turtle", "turtle"], ["Takedowns", "double_leg_takedown"], ["Submissions", "kimura"]]

var positions: Array = []
var transitions: Array = []
var _by_id := {}


func _init(path: String = GRAPH) -> void:
	var g: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	if not (g is Dictionary):
		return
	positions = (g as Dictionary)["positions"]
	transitions = (g as Dictionary)["transitions"]
	for p in positions:
		_by_id[int(p["id"])] = p
	for t in transitions:
		_by_id[int(t["id"])] = t


func get_entry(id: int) -> Dictionary:
	return _by_id.get(id, {})


## Moves that start here (and two-way moves that end here, played backwards).
func outs(pos_id: int) -> Array:
	var r: Array = []
	for t in transitions:
		if t["from"] != null and int(t["from"]) == pos_id:
			r.append({"t": t, "reverse": false})
		elif bool(t["bidirectional"]) and t["to"] != null and int(t["to"]) == pos_id:
			r.append({"t": t, "reverse": true})
	return r


## Moves that end here (and two-way moves that start here).
func ins(pos_id: int) -> Array:
	var r: Array = []
	for t in transitions:
		if t["to"] != null and int(t["to"]) == pos_id:
			r.append({"t": t, "reverse": false})
		elif bool(t["bidirectional"]) and t["from"] != null and int(t["from"]) == pos_id:
			r.append({"t": t, "reverse": true})
	return r


## A move's far end: where it lands (or where a reversed two-way move lands).
static func lands(move: Dictionary) -> Variant:
	return move["t"]["from"] if bool(move["reverse"]) else move["t"]["to"]


## Positions whose tags carry `tag`, linked ones first (the most moves out first).
func family(tag: String) -> Array:
	var r := positions.filter(func(p): return (p["tags"] as Array).has(tag))
	var count := {}
	for p in r:
		count[int(p["id"])] = outs(int(p["id"])).size() + ins(int(p["id"])).size()
	r.sort_custom(func(a, b): return int(count[int(a["id"])]) > int(count[int(b["id"])]))
	return r


func search(words: String) -> Array:
	var w := words.to_lower().strip_edges()
	if w.is_empty():
		return []
	return positions.filter(func(p): return clean(str(p["title"])).to_lower().contains(w))


## The title a player reads: GrappleMap's editors' notes ("todo: ...", "wip") and links (S336: "Escape Https://www.youtube.co
## watch?v=..." showed in the film) cut off.
static func clean(title: String) -> String:
	var t := RegEx.create_from_string("(https?://|www\\.)\\S*").sub(title, "", true)
	for cut in [" todo:", "todo:", " wip"]:
		var i := t.to_lower().find(cut)
		if i >= 0:
			t = t.substr(0, i)
	t = t.strip_edges()
	return t.capitalize() if t.length() > 0 else "Unnamed"


## The frame relabelled: men swapped and/or mirrored (x flipped, left and right joints exchanged).
static func relabel(frame: Array, swap: bool, mirror: bool) -> Array:
	var men: Array = [frame[1], frame[0]] if swap else [frame[0], frame[1]]
	if not mirror:
		return men
	var out: Array = []
	for m in men:
		var src: PackedVector3Array = m
		var p := PackedVector3Array()
		p.resize(src.size())
		for j in DB.JOINTS.size():
			var n: String = DB.JOINTS[j]
			var other := n.replace("Left", "#").replace("Right", "Left").replace("#", "Right")
			var v := src[DB.joint(other)]
			p[j] = Vector3(-v.x, v.y, v.z)
		out.append(p)
	return out


## How to lay `first` (a move's first keyframe) on `shown` (the keyframe on screen): {swap, mirror, xform, err}. err is
## the mean joint distance left over (metres); xform turns about the vertical and shifts on the mat.
static func align(shown: Array, first: Array) -> Dictionary:
	var best := {"swap": false, "mirror": false, "xform": Transform3D.IDENTITY, "err": INF}
	for swap in [false, true]:
		for mirror in [false, true]:
			var f := relabel(first, swap, mirror)
			var fit := _yaw_fit(f, shown)
			if float(fit["err"]) < float(best["err"]):
				best = {"swap": swap, "mirror": mirror, "xform": fit["xform"], "err": fit["err"]}
	return best


## The turn about Y + shift taking a's joints onto b's (least squares on the mat plane; heights are kept).
static func _yaw_fit(a: Array, b: Array) -> Dictionary:
	var ca := Vector3.ZERO
	var cb := Vector3.ZERO
	var n := 0
	for m in 2:
		for j in DB.JOINTS.size():
			ca += (a[m] as PackedVector3Array)[j]
			cb += (b[m] as PackedVector3Array)[j]
			n += 1
	ca /= n
	cb /= n
	var sx := 0.0
	var sy := 0.0
	for m in 2:
		for j in DB.JOINTS.size():
			var p: Vector3 = (a[m] as PackedVector3Array)[j] - ca
			var q: Vector3 = (b[m] as PackedVector3Array)[j] - cb
			sx += p.x * q.x + p.z * q.z
			sy += p.z * q.x - p.x * q.z
	var best := {"err": INF}
	for ang in [atan2(sy, sx), -atan2(sy, sx)]:
		var basis := Basis(Vector3.UP, ang)
		var xf := Transform3D(basis, Vector3(cb.x, 0.0, cb.z) - basis * Vector3(ca.x, 0.0, ca.z))
		var e := 0.0
		for m in 2:
			for j in DB.JOINTS.size():
				e += (xf * (a[m] as PackedVector3Array)[j]).distance_to((b[m] as PackedVector3Array)[j])
		e /= n
		if e < float(best["err"]):
			best = {"xform": xf, "err": e}
	return best


## Every keyframe of a sequence relabelled and moved by an align() result (and reversed for a backwards move), steady().
static func placed(frames: Array, how: Dictionary, reverse: bool = false) -> Array:
	var src := frames.duplicate()
	if reverse:
		src.reverse()
	var out: Array = []
	for f in src:
		out.append(lay(f, how))
	return steady(out)


## One keyframe relabelled and moved by an align() result.
static func lay(frame: Array, how: Dictionary) -> Array:
	var xf: Transform3D = how["xform"]
	var out: Array = []
	for m in relabel(frame, bool(how["swap"]), bool(how["mirror"])):
		var p := PackedVector3Array()
		for v in (m as PackedVector3Array):
			p.append(xf * v)
		out.append(p)
	return out


## S379 BJJ9R11 (operator on the theatre's 'To 50/50' at 0:14: "not sure what is this ??" - a piggyback, two heads
## stacked): a few recordings land a keyframe on its position the other way round, the men swapped and mirrored (a
## symmetric position such as 50/50 is stored one way). 'to 50/50' k7 -> k8 moves the joints 0.79 m on average, 0.10 m
## once relabelled, so played straight the two bodies flew through each other to trade places in one gap. Such a keyframe
## (RELABEL_GAP_M / RELABEL_LEFT / RELABEL_FIT) and every one after it are laid back on the keyframe before (align): the
## gap moves only what really moved. 8 gaps of GrappleMap's 6,237, all swapped + mirrored, left 12-39% of themselves.
static func steady(frames: Array) -> Array:
	var out: Array = []
	var hows: Array = []
	for f in frames:
		var cur: Array = f
		for how in hows:
			cur = lay(cur, how)
		if not out.is_empty():
			var raw := gap(out.back(), cur)
			if raw > RELABEL_GAP_M:
				var how := align(out.back(), cur)
				var turned := float(_yaw_fit(cur, out.back())["err"])
				if (bool(how["swap"]) or bool(how["mirror"])) and float(how["err"]) < raw * RELABEL_LEFT 						and float(how["err"]) < turned * RELABEL_FIT:
					hows.append(how)
					cur = lay(cur, how)
		out.append(cur)
	return out


## Mean distance between two keyframes' joints (both men), metres.
static func gap(a: Array, b: Array) -> float:
	var sum := 0.0
	for m in 2:
		for j in DB.JOINTS.size():
			sum += (a[m] as PackedVector3Array)[j].distance_to((b[m] as PackedVector3Array)[j])
	return sum / (2.0 * DB.JOINTS.size())
