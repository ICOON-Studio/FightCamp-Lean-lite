extends RefCounted
## S429 what a person does at a piece of kit, and where the club's fighters stand today. Pure: no nodes, no art.
##   clips_for(kind) -> the strips someone cycles there
##   pick(kind, person_id, minute) -> the strip for this 20-40 s block
##   station_for(session) -> kit kind, "" when that session is out of the building
##   fighters_today(fighters, day) -> [{id, stem, kind, clip, spot}] for fighters whose session is inside
## A block is 20 to 40 seconds, chosen from the person id. One block in five is a rest. The same strip never runs three
## blocks in a row when the station has two or more working strips. Desk, rack and treadmill have one strip (stand).

const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const Faces := preload("res://scripts/rules/Faces.gd")

const CLIPS := {
	"bag": ["jab_back", "bag_combo", "bag_body", "bag_upper"],
	"mat": ["shadow", "guard_move", "stretch"],
	"bench": ["rest_drink", "rest_talk"],
	"sofa": ["rest_drink", "rest_talk"],
	"desk": ["stand"],
	"office_desk": ["stand"],
	"rack": ["stand"],
	"cardio": ["stand"],
	"lockers": ["stand"],
	"treatment": ["stand"],
	"ring": ["stand"],
}
## The breather. About one block in five, and never one of the working strips above.
const REST := {
	"bag": "idle_back", "mat": "idle", "floor": "idle", "bench": "idle", "sofa": "idle",
	"desk": "stand", "office_desk": "stand", "rack": "stand", "cardio": "stand",
	"lockers": "stand", "treatment": "stand", "ring": "stand",
}
## Morning sessions (WeekPhase.SESSIONS) and the evening kinds. Roadwork and intervals leave the building.
## Speed-bag hands and a skip rope are not clips we own: those sessions use the nearest station.
const STATION := {
	"roadwork": "", "intervals": "",
	"heavy_bag": "bag", "strength": "rack", "speed_bag": "bag", "slip_rope": "mat",
	"shadow": "mat", "neck": "mat",
	"pads": "mat", "sparring": "mat", "film": "bench", "rest": "bench",
}


static func kinds() -> Array:
	return CLIPS.keys()


static func clips_for(kind: String) -> Array:
	var key := "mat" if kind == "floor" else kind
	if not CLIPS.has(key):
		return ["stand"]
	return (CLIPS[key] as Array).duplicate()


static func rest_clip(kind: String) -> String:
	var key := "mat" if kind == "floor" else kind
	return str(REST.get(key, "idle"))


## Seconds in block `index` for this person. Always 20 to 40.
static func block_seconds(person_id: String, index: int) -> float:
	return 20.0 + float(absi(hash("%s#%d" % [person_id, index])) % 21)


## Which block `minute` (minutes from an arbitrary zero) falls in.
static func block_index(person_id: String, minute: float) -> int:
	var t := maxf(minute, 0.0) * 60.0
	var i := 0
	var acc := 0.0
	while i < 100000:
		var w := block_seconds(person_id, i)
		if acc + w > t:
			return i
		acc += w
		i += 1
	return i


static func pick(kind: String, person_id: String, minute: float) -> String:
	var work := _work(kind)
	if work.size() <= 1:
		return str(work[0])
	var idx := block_index(person_id, minute)
	var salt := absi(hash(person_id + "|" + kind))
	if posmod(idx + salt, 5) == 0:
		return rest_clip(kind)
	return str(work[posmod(idx + salt, work.size())])


static func station_for(session: String) -> String:
	return str(STATION.get(session, ""))


## The morning on `day` (WeekPlan.days_of). A session with no station is left out, so roadwork is not on the floor.
## spot is unique per call: two fighters on bags are bag#0 and bag#1.
static func fighters_today(fighters: Array, day: int) -> Array:
	var out: Array = []
	var n_at := {}
	for f in fighters:
		if not (f is Dictionary):
			continue
		var sid := _morning(f, day)
		var kind := station_for(sid)
		if kind == "":
			continue
		var id := str(f.get("id", f.get("name", "fighter")))
		var n := int(n_at.get(kind, 0))
		n_at[kind] = n + 1
		out.append({"id": id, "stem": Faces.stem(f), "kind": kind, "clip": pick(kind, id, 0.0), "spot": "%s#%d" % [kind, n]})
	return out


static func _work(kind: String) -> Array:
	var rest := rest_clip(kind)
	var out: Array = []
	for c in clips_for(kind):
		if str(c) != rest:
			out.append(str(c))
	if out.is_empty():
		out.append(rest)
	return out


static func _morning(f: Dictionary, day: int) -> String:
	var days: Array = WeekPlan.days_of(f)
	if days.is_empty():
		return "rest"
	var row: Array = days[posmod(day, 7)]
	return str(row[0]) if not row.is_empty() else "rest"
