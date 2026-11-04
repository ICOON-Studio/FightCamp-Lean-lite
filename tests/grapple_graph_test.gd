extends SceneTree
## S335 GrappleGraph: mount has moves in and out, a move's far end is a position, families are filled, editors' notes are
## cut from titles (S336: links too), and chaining works: a move's last keyframe laid onto by the next move's first (align) leaves less than
## 4 cm per joint on most links, while a move aligned onto an unrelated position stays far (the instrument can read worse).
## S379: steady() lays back a recording's relabelled keyframe (the men swapped / mirrored mid-move).

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
	_steady(db)
	print("FAIL %d" % failures if failures else "PASS grapple_graph_test")
	quit(1 if failures else 0)


## S379 BJJ9R11 (the theatre's 'To 50/50', operator: "not sure what is this ??"): 'to 50/50' ends on its position the
## other way round (men swapped + mirrored), so its last gap flew both bodies through each other (0.79 m a joint).
## steady() lays that keyframe back on the one before; the gaps that are real moves, and every other recording, stay.
func _steady(db: Array) -> void:
	var ff: Array = db[1235]["frames"]
	var st := Graph.steady(ff)
	var same := true
	for i in ff.size() - 1:
		same = same and Graph.gap(ff[i], st[i]) < 1e-6
	var raw := Graph.gap(ff[ff.size() - 2], ff.back())
	var laid := Graph.gap(st[st.size() - 2], st.back())
	_check(str(db[1235]["title"]) == "to 50/50" and raw > 0.6 and laid < 0.15 and same,
		"'to 50/50' last gap: %.3f m a joint as recorded, %.3f m laid back (the 8 keyframes before untouched)" % [raw, laid])
	var changed := 0
	var kept := 0
	for seq in db:
		var fr: Array = seq["frames"]
		if fr.size() < 2:
			continue
		var out := Graph.steady(fr)
		var moved := false
		for i in fr.size():
			moved = moved or Graph.gap(fr[i], out[i]) > 1e-6
		if moved:
			changed += 1
		else:
			kept += 1
	_check(changed >= 1 and changed <= 10 and kept > 1400, "steady() lays back %d recordings, leaves %d as recorded" % [changed, kept])
	var placed := Graph.placed(ff, Graph.align(ff[0], ff[0]))
	_check(Graph.gap(placed[placed.size() - 2], placed.back()) < 0.15, "placed() (the browser's and theatre's chaining) steadies too")


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1
