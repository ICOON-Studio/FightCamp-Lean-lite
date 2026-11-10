extends SceneTree
## FIGHTDISPLAY2: the two side panels on a live round. Left energy matches the live tank, the opponent's
## legs are "?" until film study, the habit count is how often that game has been played, and each panel
## holds its holo.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")
const FightIntro := preload("res://scripts/fight3d/FightIntro.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const SidePanel := preload("res://scripts/fight3d/SidePanel.gd")

const RED := Color("#e2483d")

var failures := 0
var main: Node
var view: Node


func _initialize() -> void:
	print("SIDE_PANEL boot")
	Engine.max_fps = 30
	FightView.force3d = true
	FightIntro.from_corners = true
	get_root().size = Vector2i(1920, 1080)
	if not await _boot():
		_finish()
		return
	await _panels()
	_finish()


func _finish() -> void:
	print("SIDE_PANEL failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _boot() -> bool:
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _frames(4)
	if not TestJump.run(main, "fight_nofilm"):
		_fail("boot: the fight jump did not reach fight night")
		return false
	main.act("fightstep", "start")
	await _frames(6)
	if main._fight_layer.get_child_count() == 0:
		_fail("boot: no fight view")
		return false
	view = main._fight_layer.get_child(0)
	for ch in view.get_children():
		if ch.has_method("cue_touch"):
			ch.finish()
	if not await _until(func(): return bool(view.playing) and view.get("_shouting") == null and float(view.t) < 5.0):
		_fail("boot: the round never played (playing %s t %.1f)" % [view.playing, float(view.t)])
		return false
	await _frames(4)
	return true


func _panels() -> void:
	var left := view.find_child("SidePanel0", true, false) as Control
	var right := view.find_child("SidePanel1", true, false) as Control
	_check(left != null and right != null, "two SidePanel nodes")
	if left == null or right == null:
		return
	var lr := left.get_global_rect()
	var rr := right.get_global_rect()
	_check(lr.position.x < 400.0 and lr.end.x <= 400.0, "left panel inside x < 400 (%s)" % lr)
	_check(rr.position.x > 1520.0, "right panel inside x > 1520 (%s)" % rr)
	_energy(left)
	_stamina()
	await _legs(right)
	_lines(left, right)
	_habit(right)
	_heard(left)
	_holo(left, right)
	await _tag(left)
	_overlap(left)
	_overlap(right)
	_icons(left)
	_icons(right)
	_type(left)
	_type(right)
	_dump(left)
	_dump(right)


func _energy(left: Control) -> void:
	var lv: Dictionary = LiveRound.live(main.modal)
	var exs: Array = lv.get("ex", [])
	var idx := mini(int(float(view.t) / Exchanges.EX_SECONDS), exs.size())
	var want := int(round(LiveRound.her_energy(lv, idx)))
	var lab := left.find_child("EnergyNum", true, false) as Label
	_check(lab != null and lab.text == str(want),
		"left energy is the live tank for this exchange (%s, want %d)" % ["" if lab == null else lab.text, want])


func _legs(right: Control) -> void:
	var f: Dictionary = main.career.fighter_by_id(str(view.fid))
	if int(f["bout"].get("film", 0)) >= BoutRules.FILM_DEPTH_WITH_STUDY:
		f["bout"]["film"] = BoutRules.FILM_DEPTH_DEFAULT
		await _frames(3)
	var legs := right.find_child("LegsNum", true, false) as Label
	_check(legs != null and legs.text == "?",
		"no film study: the opponent's legs read ? (%s)" % ("" if legs == null else legs.text))
	var chip := right.find_child("HabitChip", true, false) as Label
	var opp: Dictionary = (f.get("bout", {}) as Dictionary).get("opp", {})
	_check(chip != null and chip.text == SidePanel.opp_line(opp, int(f["bout"].get("film", 0))),
		"no tape yet: the line under her name is her record (%s)" % ("" if chip == null else chip.text))
	f["bout"]["film"] = BoutRules.FILM_DEPTH_WITH_STUDY
	await _frames(4)
	_check(legs != null and legs.text.is_valid_int(),
		"full study: the opponent's legs are a number (%s)" % ("" if legs == null else legs.text))


func _stamina() -> void:
	# The real FightView's bars (SidePanel's host). A stub with its own stamina() would not be this node.
	_check(view.bars != null and view.bars.get_script() == SidePanel.Host and view.bars.has_method("stamina"),
		"bars.stamina is the live host on the real FightView (%s)" % ("" if view.bars == null else str(view.bars.get_class())))
	if view.bars == null or not view.bars.has_method("stamina"):
		return
	var lv: Dictionary = LiveRound.live(main.modal)
	var exs: Array = lv.get("ex", [])
	var idx := mini(int(float(view.t) / Exchanges.EX_SECONDS), exs.size())
	var hers: float = view.bars.stamina(0)
	var opp: float = view.bars.stamina(1)
	_check(absf(hers - LiveRound.her_energy(lv, idx)) < 0.05,
		"her stamina is the tank the view is showing (%.1f, want %.1f)" % [hers, LiveRound.her_energy(lv, idx)])
	_check(hers >= 0.0 and absf(opp - LiveRound.opp_energy(lv, idx)) < 0.05,
		"the opponent stamina reads too (%.1f, want %.1f)" % [opp, LiveRound.opp_energy(lv, idx)])


func _lines(left: Control, right: Control) -> void:
	var lv: Dictionary = LiveRound.live(main.modal)
	var f: Dictionary = main.career.fighter_by_id(str(view.fid))
	var opp: Dictionary = (f.get("bout", {}) as Dictionary).get("opp", {})
	var film := int((f.get("bout", {}) as Dictionary).get("film", 0))
	var mine := left.find_child("PlanChip", true, false) as Label
	var hers := right.find_child("HabitChip", true, false) as Label
	var record := SidePanel.opp_line(opp, 0)
	_check(mine != null and mine.text == SidePanel.own_line(lv) and not mine.text.begins_with("Plan:"),
		"his line is the plan in game words (%s)" % ("" if mine == null else mine.text))
	_check(record.contains("win") and record.contains("loss"), "without tape the line is her record (%s)" % record)
	_check(hers != null and hers.text == SidePanel.opp_line(opp, film),
		"her line is the record or the tape (%s)" % ("" if hers == null else hers.text))


func _habit(right: Control) -> void:
	var lv: Dictionary = LiveRound.live(main.modal)
	var exs: Array = lv.get("ex", [])
	var mode := str((exs[-1] as Dictionary).get("mode", "")) if not exs.is_empty() else ""
	var n := 0
	for item in exs:
		if str((item as Dictionary).get("mode", "")) == mode:
			n += 1
	var word := str((Exchanges.MODES.get(mode, {}) as Dictionary).get("label", mode))
	var unit := "time" if n == 1 else "times"
	var count := right.find_child("HabitCount", true, false) as Label
	_check(count != null and count.text == "%s, %d %s" % [word, n, unit],
		"habit reads as words and a count (%s, want %s, %d %s)" % ["" if count == null else count.text, word, n, unit])
	_check(right.find_child("HabitIcon", true, false) == null and right.find_child("HabitGlove", true, false) == null,
		"the habit card has no target, arrow or fist")


func _heard(left: Control) -> void:
	var lab := left.find_child("Heard", true, false) as Label
	_check(lab != null and lab.text.begins_with("Heard ") and lab.text.ends_with(" of 3"),
		"the dots say how many she heard (%s)" % ("" if lab == null else lab.text))


func _holo(left: Control, right: Control) -> void:
	var a := left.find_child("BodyPanel0", true, false)
	var b := right.find_child("BodyPanel1", true, false)
	_check(a != null and a.get_parent() == left, "the left holo is a child of the left panel")
	_check(b != null and b.get_parent() == right, "the right holo is a child of the right panel")


func _tag(left: Control) -> void:
	var live: Node = view.get("body")
	var tag := left.find_child("WorstTag", true, false) as Label
	var vals := {}
	for p in BodyMap.PLACES:
		vals[p] = BodyMap.value(live.map, "a", p)
	var place := SidePanel.worst_place(vals)
	var want := SidePanel.tag_text(place, BodyMap.band(float(vals[place])))
	_check(tag != null and tag.text == want, "the tag names the worst place (%s, want %s)" % ["" if tag == null else tag.text, want])
	live.map["a"]["places"]["nose"] = 30.0
	await _frames(3)
	_check(tag != null and tag.text == "NOSE", "a critical nose is tagged NOSE (%s)" % ("" if tag == null else tag.text))
	if tag != null:
		_check(_same(tag.get_theme_color("font_color"), RED), "a critical place is red (%s)" % tag.get_theme_color("font_color"))


func _overlap(panel: Control) -> void:
	var labs: Array = []
	for n in panel.find_children("*", "Label", true, false):
		var l := n as Label
		if l.visible and l.is_visible_in_tree() and l.text.strip_edges() != "" and not _under_holo(l):
			labs.append(l)
	var hit := ""
	for i in labs.size():
		for j in range(i + 1, labs.size()):
			var a: Label = labs[i]
			var b: Label = labs[j]
			if a.get_global_rect().intersects(b.get_global_rect()):
				hit = "%s '%s' and %s '%s'" % [a.name, a.text, b.name, b.text]
				break
		if hit != "":
			break
	_check(hit == "", "no two labels overlap in %s%s" % [panel.name, "" if hit == "" else " (" + hit + ")"])


func _under_holo(n: Node) -> bool:
	var p := n.get_parent()
	while p != null:
		if str(p.name).begins_with("BodyPanel"):
			return true
		p = p.get_parent()
	return false


func _icons(panel: Control) -> void:
	for n in panel.find_children("*", "TextureRect", true, false):
		if _under_holo(n):
			continue
		_check(_has_words(n), "icon %s has a label or a tooltip" % n.name)
	for n in panel.find_children("*", "", true, false):
		var nm := str(n.name)
		if nm == "Ear" or nm.begins_with("Pip"):
			_check(_has_words(n), "icon %s has a label or a tooltip" % nm)


func _has_words(c: Node) -> bool:
	if str(c.get("tooltip_text")).strip_edges() != "":
		return true
	var p := c.get_parent()
	if p == null:
		return false
	for s in p.get_children():
		if s is Label and str((s as Label).text).strip_edges() != "":
			return true
	return false


func _dump(panel: Control) -> void:
	print("PANEL %s %s" % [panel.name, panel.get_global_rect()])
	for n in panel.find_children("*", "Label", true, false):
		var l := n as Label
		if l.visible and not _under_holo(l):
			print("RECT %s %s \"%s\" %s" % [panel.name, l.name, l.text, l.get_global_rect()])


func _type(panel: Control) -> void:
	for n in panel.find_children("*", "Label", true, false):
		var l := n as Label
		if not l.visible:
			continue
		var px := l.get_theme_font_size("font_size")
		_check(px >= 20, "label %s is %d px" % [l.name, px])
		_check(not _clipped(l), "label %s is not clipped (%s)" % [l.name, l.text])


func _clipped(l: Label) -> bool:
	if l.text.strip_edges() == "":
		return false
	if l.size.x < 2.0 or l.size.y < 2.0:
		return true
	if l.autowrap_mode != TextServer.AUTOWRAP_OFF:
		return l.get_visible_line_count() < l.get_line_count()
	return l.get_minimum_size().x > l.size.x + 2.0 or l.get_minimum_size().y > l.size.y + 2.0


func _same(a: Color, b: Color) -> bool:
	return absf(a.r - b.r) < 0.02 and absf(a.g - b.g) < 0.02 and absf(a.b - b.b) < 0.02


func _check(cond: bool, label: String) -> void:
	print(("OK  " if cond else "FAIL ") + label)
	if not cond:
		failures += 1


func _fail(label: String) -> void:
	_check(false, label)


func _frames(n: int) -> void:
	for i in n:
		await process_frame


func _until(cond: Callable, cap: int = 240) -> bool:
	for i in cap:
		if cond.call():
			return true
		await process_frame
	return cond.call()
