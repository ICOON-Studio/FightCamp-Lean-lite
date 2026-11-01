extends SceneTree
## S335 GrappleGraph: mount has moves in and out, a move's far end is a position, families are filled, editors' notes are
## cut from titles (S336: links too), and chaining works: a move's last keyframe laid onto by the next move's first (align) leaves less than
## 4 cm per joint on most links, while a move aligned onto an unrelated position stays far (the instrument can read worse).

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const Graph := preload("res://scripts/grapple/GrappleGraph.gd")

var failures := 0


func _initialize() -> void:
	var db: Array = DB.load_db()
	var g = Graph.new()
	_check(g.positions.size() == 601 and g.transitions.size() == 1485, "graph: %d positions, %d moves" % [g.positions.size(), g.transitions.size()])
	var mount: Dictionary = DB.find(db, "mount")
	var mid := db.find(mount)
	_check(g.outs(mid).size() >= 4 and g.ins(mid).size() >= 4, "mount: %d moves in, %d out" % [g.ins(mid).size(), g.outs(mid).size()])
	var empty := 0
	for f in Graph.FAMILIES:
		if g.family(str(f[1])).is_empty():
			empty += 1
			print("  empty family ", f[0])
	_check(empty == 0, "every family tab has positions")
	_check(Graph.clean("top gets underhook todo: wip") == "Top Gets Underhook", "editors' notes cut: '%s'" % Graph.clean("top gets underhook todo: wip"))
	var linked := "escape https://www.youtube.com/watch?v=jyRkYmoYb0 dean lister"
	_check(not Graph.clean(linked).to_lower().contains("http") and not Graph.clean(linked).contains("watch"), "links cut from titles: '%s'" % Graph.clean(linked))
	var titled := 0
	for seq in db:
		if Graph.clean(str(seq["title"])).to_lower().contains("http") or Graph.clean(str(seq["title"])).to_lower().contains("www"):
			titled += 1
	_check(titled == 0, "no title a player reads holds a link (%d)" % titled)
	# Chaining: for moves into mount, lay each move OUT of mount on the move-in's last keyframe.
	var good := 0
	var links := 0
	var far := 0
	var unrelated: Dictionary = DB.find(db, "full guard kimura")
	for mi in g.ins(mid):
		if bool(mi["reverse"]):
			continue
		var last: Array = (db[int(mi["t"]["id"])]["frames"] as Array).back()
		for mo in g.outs(mid):
			var seq: Dictionary = db[int(mo["t"]["id"])]
			var first: Array = (seq["frames"] as Array).back() if bool(mo["reverse"]) else (seq["frames"] as Array)[0]
			links += 1
			if float(Graph.align(last, first)["err"]) < 0.04:
				good += 1
		if float(Graph.align(last, (unrelated["frames"] as Array)[0])["err"]) > 0.15:
			far += 1
	_check(links > 0 and float(good) / links > 0.8, "moves chain through mount: %d of %d links under 4 cm a joint" % [good, links])
	_check(far == g.ins(mid).filter(func(m): return not bool(m["reverse"])).size(), "an unrelated position stays far (%d)" % far)
	print("FAIL %d" % failures if failures else "PASS grapple_graph_test")
	quit(1 if failures else 0)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1
