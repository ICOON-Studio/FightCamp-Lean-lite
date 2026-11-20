extends SceneTree
## S532 GUIDETIPS1 measurement (no game change): walks the main screens like a player and reads every tooltip on show against
## ops/research/GUIDETIPS1_STANDARD.md section 2e. Prints one TIPFAULT line per broken tooltip and a TIPCENSUS line per page.
##   Godot_v4.7.2-stable_win64.exe --headless --audio-driver Dummy --path . --script res://tools/tooltip_census.gd
## Faults: repeat (says its label again), short (under 6 words), wide (a line over WIDE_CHARS letters with no wrap, the
## engine's plain tooltip never wraps), piled (3+ numbers in one sentence), name (a signed boxer's or coach's name).
## NONUM = labels showing a number with no tooltip on them or on any parent (the standard: every number has a card).

const Bouts := preload("res://scripts/state/Bouts.gd")
const WIDE_CHARS := 52   # about 330 px of body text

var main: Node
var seen := {}
var totals := {"tips": 0, "repeat": 0, "short": 0, "wide": 0, "piled": 0, "name": 0, "nonum": 0, "numbers": 0}


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle()
	main.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	main.size = Vector2(1920, 1080)
	main.act("newcareer")
	main.act("quick")
	await _page("home_start")
	main.act("interview")
	main.act("pickcard", "signature")
	await _page("reception")
	main.act("sign")
	main.act("go", "gym:1")
	await _page("club_staff")
	main.act("hire", "reid")
	await process_frame
	main.act("go", "fighters:0")
	await _page("fighters_roster")
	main.act("go", "fighters:1")
	await _page("training")
	main.on_go()
	main.on_go()
	main.run_to_stop()
	main.act("area", "home")
	await _page("home_week1")
	var c: Career = main.career
	var fid := str(c.fighter()["id"])
	for i in 8:
		main.act("fighter", fid)
		main.act("ftab", str(i))
		await _page("fighter_tab%d" % i)
	for i in 12:
		if not (c.fighter()["offers"] as Array).is_empty():
			break
		if c.review_pending:
			main.act("review")
			main.act("close")
		main.run_to_stop()
	main.act("go", "fights:0")
	await _page("fights_offers")
	for o in c.fighter()["offers"]:
		if not bool(o.get("mismatch", false)):
			main.act("openBout", str(o["id"]))
			await _page("bout_offer")
			main.act("accept", str(o["id"]))
			main.act("close")
			break
	main.act("fighter", fid)
	main.act("ftab", "5")
	await _page("fight_prep_booked")
	for i in 4:
		main.act("go", "money:%d" % i)
		await _page("money_%d" % i)
	for i in 5:
		main.act("go", "gym:%d" % i)
		await _page("club_%d" % i)
	for i in 4:
		main.act("go", "playbook:%d" % i)
		await _page("playbook_%d" % i)
	for i in 3:
		main.act("go", "world:%d" % i)
		await _page("world_%d" % i)
	print("TIPTOTAL ", JSON.stringify(totals))
	quit(0)


func _settle(frames: int = 4) -> void:
	for i in frames:
		await process_frame


func _names() -> Array:
	var out: Array = []
	var c: Career = main.career
	if c == null:
		return out
	for f in c.fighters:
		for k in ["first", "name"]:
			if str(f.get(k, "")).length() > 2:
				out.append(str(f[k]))
	if str(c.coach.get("name", "")).length() > 2:
		out.append_array(str(c.coach["name"]).split(" "))
	return out


func _label_of(c: Control) -> String:
	if c is Button or c is Label:
		return str(c.get("text"))
	var words: Array = []
	for l in c.find_children("*", "Label", true, false):
		words.append(str((l as Label).text))
	return " ".join(words)


func _norm(s: String) -> String:
	var r := RegEx.create_from_string("[^a-z ]")
	return " ".join(r.sub(s.to_lower(), "", true).split(" ", false))


func _page(page: String) -> void:
	await _settle(6)
	var names := _names()
	var num := RegEx.create_from_string("\\d+")
	var p := {"tips": 0, "faults": 0, "nonum": 0, "numbers": 0}
	for n in main.find_children("*", "Control", true, false):
		var c := n as Control
		if not c.is_visible_in_tree():
			continue
		var tip := c.tooltip_text.strip_edges()
		var key := "%s|%s" % [c.get_path(), str(c.get("text"))]
		if c is Label and num.search(str((c as Label).text)) != null and not seen.has(key):
			seen[key] = true
			p["numbers"] += 1
			if not _has_tip(c):
				p["nonum"] += 1
		if tip == "" or seen.has(tip):
			continue
		seen[tip] = true
		p["tips"] += 1
		var faults: Array = []
		var label := _norm(_label_of(c))
		var t := _norm(tip)
		if label != "" and (t == label or (t.length() > 3 and label.contains(t)) or (label.length() > 8 and t.begins_with(label) and t.length() < label.length() + 12)):
			faults.append("repeat")
		if tip.split(" ", false).size() < 6:
			faults.append("short")
		for line in tip.split("\n"):
			if line.length() > WIDE_CHARS:
				faults.append("wide")
				break
		for s in tip.split(". "):
			if num.search_all(s).size() >= 3:
				faults.append("piled")
				break
		for nm in names:
			if tip.contains(nm):
				faults.append("name")
				break
		for f in faults:
			totals[f] += 1
		if not faults.is_empty():
			p["faults"] += 1
			print("TIPFAULT %s [%s] label=\"%s\" tip=\"%s\"" % [page, ",".join(faults), _label_of(c).left(40).replace("\n", " "), tip.left(170).replace("\n", " / ")])
	totals["tips"] += int(p["tips"])
	totals["nonum"] += int(p["nonum"])
	totals["numbers"] += int(p["numbers"])
	print("TIPCENSUS %s route=%s modal=%s new_tips=%d broken=%d new_numbers=%d numbers_with_no_tip=%d" % [page, str(main.route), str((main.modal as Dictionary).get("kind", (main.modal as Dictionary).keys())), p["tips"], p["faults"], p["numbers"], p["nonum"]])


## A tooltip on the control or any parent, or a hover card (Tips / MoveTip connect mouse_entered).
func _has_tip(c: Control) -> bool:
	var n: Node = c
	while n != null and n is Control:
		if (n as Control).tooltip_text != "" or not (n as Control).mouse_entered.get_connections().is_empty():
			return true
		n = n.get_parent()
	return false
