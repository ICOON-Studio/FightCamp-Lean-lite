extends SceneTree
## S390: the one applying a submission is read from the bodies, never from who is higher (the film gave Ana a win Beth was applying).

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const Fin := preload("res://scripts/grapple/GrappleFinish.gd")
const Curated := preload("res://scripts/grapple/GrappleCurated.gd")
const M := preload("res://scripts/rules/BjjMatch.gd")

var fails := 0


func _check(ok: bool, what: String) -> void:
	print(("PASS " if ok else "FAIL ") + what)
	fails += 0 if ok else 1


func _under(db: Array, id: int) -> bool:
	var e: Dictionary = db[id]
	var f: Array = e["frames"][0]
	var a := Fin.attacker(e["tags"], f)
	return (f[a] as PackedVector3Array)[DB.joint("Core")].y < (f[1 - a] as PackedVector3Array)[DB.joint("Core")].y


func _initialize() -> void:
	var db: Array = DB.load_db()
	_check(_under(db, 240), "locked triangle: the woman underneath applies it")
	_check(_under(db, 263), "arm lock from guard: the woman underneath applies it")
	_check(_under(db, 215), "guillotine from guard: the woman underneath applies it")
	_check(_under(db, 198), "rear naked choke: the woman behind applies it, lower or not")
	_check(not _under(db, 206), "mounted arm triangle: the woman on top applies it")
	_check(Fin.attacker(["full_guard"], db[0]["frames"][0]) == -1, "no submission in the tags: nobody")
	# The rule uses it: a bottom woman may finish, a top woman may not take a submission applied to her.
	var st := {"skill": [50.0, 50.0], "gas": [1.0, 1.0], "strength": [50.0, 50.0]}
	var c := {"i": 1, "title": "Triangle", "tags": ["triangle"], "to_c": "guard", "top_after": 1, "sub_by": 0}
	var f := {"bjj": {"triangle": 40.0}}
	_check(M.offers(st, f, 0, "guard", 1, [c]).size() == 1, "a bottom woman is offered her triangle")
	_check(M.offers(st, f, 1, "guard", 1, [c]).is_empty(), "the woman inside it is not")
	_check(Curated.blocked(673), "a stack that stands a woman on her head is refused")
	var tap := Fin.tap_out(db[240]["frames"][0], 0)
	var moved: bool = (tap["frames"][2][0] as PackedVector3Array)[DB.joint("LeftWrist")] != (tap["frames"][0][0] as PackedVector3Array)[DB.joint("LeftWrist")] \
		or (tap["frames"][2][0] as PackedVector3Array)[DB.joint("RightWrist")] != (tap["frames"][0][0] as PackedVector3Array)[DB.joint("RightWrist")]
	_check(moved, "the tap is on the loser's hand")
	print("GRAPPLE_ATTACKER failures=%d" % fails)
	quit(1 if fails > 0 else 0)
