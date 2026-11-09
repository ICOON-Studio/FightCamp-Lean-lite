extends RefCounted
## S409 the people in the gym, as data: where someone can stand and work, how they walk there, and how many are in.
## Same floor rules as GymPlan, so a figure can never walk through a wall or stand on a bag. Pure: no nodes, no art.
##   spots(plan) -> [{at: Vector2i, act: String, kind: String, flip: bool}]
##   route(plan, a, b) -> [Vector2i, ...] from a to b, [] when there is no way
##   crowd(members, fighter_stems, premises) -> body stems, fighters first; premises caps how many are in at once

const GymPlan := preload("res://scripts/rules/GymPlan.gd")

## Item kind -> what a person does beside it (the figure strip's name).
const JOB := {"bag": "jab_back", "mat": "idle", "rack": "stand", "bench": "stand", "desk": "stand", "sofa": "stand",
	"office_desk": "stand", "lockers": "stand", "treatment": "stand"}
const MIN_PEOPLE := 2
const MAX_PEOPLE := 12
## S416 operator: "having 40+ doesnt mean they all go to the gym at the same, limit the number ... scale for the various tiers".
## The most people in the building at once, by premises: the unit, the bigger unit, the club building (game values).
const ON_THE_FLOOR := [6, 9, 12]
const MEMBERS_EACH := 5       # one more person in the building for every five members
## The bodies that come in as ordinary members.
const MEMBER_STEMS := ["mh_boxer_03", "mh_boxer_11", "mh_boxer_07", "mh_boxer_17", "mh_boxer_08", "mh_boxer_13", "mh_boxer_19", "mh_boxer_21",
	"mh_boxer_16", "mh_boxer_22", "mh_boxer_01", "mh_boxer_23"]


## Places to stand: the floor in front of each piece of equipment, on the viewer's side so she is not drawn behind it.
## Only spots a person can walk to from the front door.
static func spots(plan: Dictionary) -> Array:
	var blocked := GymPlan.taken(plan)
	var reach := _reachable(plan, blocked)
	var out: Array = []
	var used := {}
	for it in GymPlan.expand(plan):
		var kind := str(it["kind"])
		if not JOB.has(kind):
			continue
		var x := int(it["x"])
		var y := int(it["y"])
		var w := int(it["w"])
		var h := int(it["h"])
		# Standing on the +y side she faces up the screen to the right (a flipped strip); on the +x side, to the left.
		for side in [[Vector2i(x + w / 2, y + h), true], [Vector2i(x + w, y + h / 2), false]]:
			var at: Vector2i = side[0]
			if reach.has(at) and not used.has(at):
				used[at] = true
				out.append({"at": at, "act": str(JOB[kind]), "kind": kind, "flip": bool(side[1])})
				break
	return out


## The shortest walk from a to b, both ends included; [] when there is no way.
static func route(plan: Dictionary, a: Vector2i, b: Vector2i) -> Array:
	var blocked := GymPlan.taken(plan)
	if blocked.has(a) or blocked.has(b):
		return []
	var came := {a: a}
	var queue: Array = [a]
	var head := 0
	while head < queue.size():
		var t: Vector2i = queue[head]
		head += 1
		if t == b:
			break
		for d in [Vector2i.DOWN, Vector2i.RIGHT, Vector2i.UP, Vector2i.LEFT]:
			var n: Vector2i = t + d
			if not came.has(n) and GymPlan.can_walk(plan, blocked, t, n):
				came[n] = t
				queue.append(n)
	if not came.has(b):
		return []
	var path: Array = [b]
	while path[0] != a:
		path.push_front(came[path[0]])
	return path


## Who is in: the club's own fighters first, then members; a bigger club is a busier gym.
static func crowd(members: int, fighter_stems: Array, premises := -1) -> Array:
	var most: int = MAX_PEOPLE if premises < 0 else int(ON_THE_FLOOR[clampi(premises, 0, ON_THE_FLOOR.size() - 1)])
	var n := clampi(MIN_PEOPLE + members / MEMBERS_EACH, MIN_PEOPLE, most)
	var out: Array = []
	for s in fighter_stems:
		if out.size() < n and not out.has(s):
			out.append(s)
	for s in MEMBER_STEMS:
		if out.size() < n and not out.has(s):
			out.append(s)
	return out


static func _reachable(plan: Dictionary, blocked: Dictionary) -> Dictionary:
	var start := Vector2i(int(plan["door"][0]), int(plan["door"][1]))
	var seen := {start: true}
	var queue: Array = [start]
	while not queue.is_empty():
		var a: Vector2i = queue.pop_back()
		for d in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
			var b: Vector2i = a + d
			if not seen.has(b) and GymPlan.can_walk(plan, blocked, a, b):
				seen[b] = true
				queue.append(b)
	return seen
