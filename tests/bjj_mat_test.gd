extends SceneTree
## S375 Ana's mat in the Playbook: every syllabus move BjjFilm films finds a real GrappleMap transition (two keyframes or
## more) in assets/grapplemap/GrappleMap.txt; an unfilmed move finds none (the Playbook says so); the player's pick
## ("move:<id>", Drill it) is what her classes drill until it is a signature, then the coach's pick takes over.

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const BjjFilm := preload("res://scripts/rules/BjjFilm.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const MatPlayer := preload("res://scripts/ui/MatPlayer.gd")
const Faces := preload("res://scripts/rules/Faces.gd")

var failures := 0


func _initialize() -> void:
	var db := DB.load_db()
	_check(db.size() > 100, "GrappleMap loads (%d sequences)" % db.size())
	var filmed := 0
	var missing: Array = []
	for belt in ["white", "blue", "purple"]:
		for id in BeltRoad.moves_for(belt):
			if BjjFilm.film(str(id)).is_empty():
				continue
			var i := BjjFilm.find(db, str(id))
			if i >= 0 and DB.is_transition(db[i]):
				filmed += 1
			else:
				missing.append(id)
	_check(missing.is_empty() and filmed >= 25, "every filmed syllabus move plays a real GrappleMap move (%d; missing %s)" % [filmed, str(missing)])
	_check(BjjFilm.find(db, "americana") == -1 and BjjFilm.film("americana").is_empty(), "an unfilmed move finds no film")
	var white: Array = BeltRoad.moves_for("white")
	_check(white.all(func(m): return not BjjFilm.film(str(m)).is_empty() or str(m) in ["americana", "scissor_sweep"]),
		"the white belt's moves are filmed but the americana and the scissor sweep (S376: GrappleMap's only scissor is a flying one)")

	var ana := NoGi.athlete()
	ana["bjj"]["kimura"] = 20.0
	_check(NoGi.drilling_for(ana, "move:kimura") == "kimura", "Drill it: her classes drill the kimura")
	ana["bjj"]["kimura"] = NoGi.SIGNATURE
	_check(NoGi.drilling_for(ana, "move:kimura") == NoGi.drilling_for(ana, "coach"), "a signature hands back to the coach's pick")
	_check(NoGi.drilling_for(ana, "move:berimbolo") == NoGi.drilling_for(ana, "coach"), "a move outside her belt is refused")

	# S382 MOVETIP1 round 2: a mat owns its World3D - two mats (the Playbook's and the hover card's) never share bodies.
	var stems := Faces.pair(ana, Faces.partner(ana))
	var mats: Array = []
	for i in 2:
		var m := MatPlayer.new()
		m.bodies = [Faces.glb(stems[0]), Faces.glb(stems[1])]
		m.custom_minimum_size = Vector2(320, 240)
		root.add_child(m)
		mats.append(m)
	for i in 3:
		await process_frame
	var worlds: Array = mats.map(func(m): return (m.find_children("*", "SubViewport", true, false)[0] as SubViewport).find_world_3d())
	_check(worlds[0] != root.find_world_3d() and worlds[1] != root.find_world_3d() and worlds[0] != worlds[1],
		"each mat draws its own World3D (not the root's, not the other mat's)")
	var per: Array = worlds.map(func(w): return root.find_children("*", "Skeleton3D", true, false).filter(
		func(s): return (s as Node3D).get_world_3d() == w).size())
	_check(per == [2, 2], "two bodies in each mat's world (%s)" % str(per))
	print("BJJ_MAT failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS " + label)
	else:
		failures += 1
		print("FAIL " + label)
