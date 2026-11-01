extends RefCounted
## S335 the GrappleMap database (operator Q-S294-58 "Build the prototype now"; public domain, assets/grapplemap/LICENSE).
## 601 two-man ground positions (one keyframe) and 1,485 transitions (2-22 keyframes) as 23 joints per man per keyframe.
## Format read from GrappleMap src/persistence.cpp: a sequence is its description lines (title, then `tags:` /
## `properties:` / `ref:`), then keyframes of 4 lines indented by 4 spaces = 276 base-62 digits = 2 men x 23 joints x 3
## coords, each coord two digits (d0*62+d1)/1000 m, x and z offset by -2. Y is up, as in Godot. Timing is not stored.
## Pure: no preloads, no scene. The prototype plays it outside the boxing game (Discipline: MMA, not the demo).

const PATH := "res://assets/grapplemap/GrappleMap.txt"
const JOINTS := ["LeftToe", "RightToe", "LeftHeel", "RightHeel", "LeftAnkle", "RightAnkle", "LeftKnee", "RightKnee",
	"LeftHip", "RightHip", "LeftShoulder", "RightShoulder", "LeftElbow", "RightElbow", "LeftWrist", "RightWrist",
	"LeftHand", "RightHand", "LeftFingers", "RightFingers", "Core", "Neck", "Head"]
const DIGITS := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
const FRAME_DIGITS := 276

## Limb lengths every frame keeps (players.hpp limbs(), metres): [joint a, joint b, length].
const LIMBS := [["LeftAnkle", "LeftKnee", 0.43], ["LeftKnee", "LeftHip", 0.43], ["RightAnkle", "RightKnee", 0.43],
	["RightKnee", "RightHip", 0.43], ["LeftShoulder", "LeftElbow", 0.29], ["RightShoulder", "RightElbow", 0.29],
	["LeftElbow", "LeftWrist", 0.26], ["RightElbow", "RightWrist", 0.27], ["Neck", "Head", 0.165]]


static func joint(name: String) -> int:
	return JOINTS.find(name)


## Every sequence in the file: {title, tags, props, ref, line, frames}. frames = Array of [man0, man1], each a
## PackedVector3Array of 23 joints in JOINTS order. A position has 1 frame, a transition 2 or more.
static func load_db(path: String = PATH) -> Array:
	return parse(FileAccess.get_file_as_string(path))


static func parse(text: String) -> Array:
	var out: Array = []
	var desc: PackedStringArray = []
	var digits := ""
	var cur: Dictionary = {}
	var line_nr := 0
	for raw in text.split("\n"):
		line_nr += 1
		var line := raw.trim_suffix("\r")
		if line.begins_with(" "):
			if not desc.is_empty():
				cur = _sequence(desc, line_nr - desc.size())
				out.append(cur)
				desc = []
			digits += line.strip_edges()
			if digits.length() >= FRAME_DIGITS:
				(cur["frames"] as Array).append(decode_frame(digits.substr(0, FRAME_DIGITS)))
				digits = digits.substr(FRAME_DIGITS)
		elif not line.is_empty():
			desc.append(line)
	return out


static func _sequence(desc: PackedStringArray, line_nr: int) -> Dictionary:
	var title: PackedStringArray = []
	var tags: PackedStringArray = []
	var props: PackedStringArray = []
	var ref := ""
	for d in desc:
		if d.begins_with("tags:"):
			tags.append_array(d.substr(5).split(" ", false))
		elif d.begins_with("properties:"):
			props.append_array(d.substr(11).split(" ", false))
		elif d.begins_with("ref:"):
			ref = d.substr(4).strip_edges()
		else:
			title.append(d.replace("\\n", " "))
	return {"title": " ".join(title).strip_edges(), "tags": tags, "props": props, "ref": ref, "line": line_nr, "frames": []}


## 276 digits -> [man0, man1] joint positions.
static func decode_frame(digits: String) -> Array:
	var men: Array = []
	var i := 0
	for _man in 2:
		var p := PackedVector3Array()
		p.resize(JOINTS.size())
		for j in JOINTS.size():
			var c: Array = []
			for _k in 3:
				c.append(float(DIGITS.find(digits[i]) * 62 + DIGITS.find(digits[i + 1])) / 1000.0)
				i += 2
			p[j] = Vector3(c[0] - 2.0, c[1], c[2] - 2.0)
		men.append(p)
	return men


static func is_transition(seq: Dictionary) -> bool:
	return (seq["frames"] as Array).size() > 1


## The first sequence whose title matches exactly (case-insensitive), else {}.
static func find(db: Array, title: String) -> Dictionary:
	for s in db:
		if str(s["title"]).to_lower() == title.to_lower():
			return s
	return {}


## Sequences carrying every tag in `tags`.
static func tagged(db: Array, tags: Array) -> Array:
	return db.filter(func(s): return tags.all(func(t): return (s["tags"] as PackedStringArray).has(t)))
