extends SceneTree
## FIGHTDISPLAY4: the ring stays clear. Bars sit in the two top strips, the figures stand free at the
## edges, the heard pips and the habit card sit in the bottom bar, and no chip covers the scoreboard.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")
const FightIntro := preload("res://scripts/fight3d/FightIntro.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const SidePanel := preload("res://scripts/fight3d/SidePanel.gd")

const RED := Color("#e2483d")
const ZONE := Rect2(0, 240, 1920, 650)
const OURS := Rect2(20, 20, 600, 180)
const THEIRS := Rect2(1300, 20, 600, 180)
const BOARD := Rect2(640, 0, 640, 240)
const HOME := [Rect2(20, 350, 320, 540), Rect2(1580, 350, 320, 540)]

var failures := 0
var main: Node
var view: Node


func _initialize() -> void:
	print("SIDE_PANEL boot")
	_pure()
	Engine.max_fps = 30
	FightView.force3d = true
	FightIntro.from_corners = true
	root.mode = Window.MODE_WINDOWED
	root.size = Vector2i(1920, 1080)
	if not await _boot():
		_finish()
		return
	await _screen()
	_finish()


func _finish() -> void:
	print("SIDE_PANEL failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _pure() -> void:
	var vals := {"head": 80.0, "left_eye": 40.0, "right_eye": 90.0, "nose": 30.0, "left_ribs": 70.0, "right_ribs": 60.0}
	_check(SidePanel.worst_place(vals) == "nose", "worst_place picks the lowest band (%s)" % SidePanel.worst_place(vals))
	_check(SidePanel.tag_text("nose", "critical") == "NOSE", "tag_text names the place")
	_check(SidePanel.tag_text("left_eye", "doctor") == "EYE x", "tag_text marks a bad eye")
	_check(SidePanel.energy_range(94.0, true) == "91-97", "energy_range scouted (%s)" % SidePanel.energy_range(94.0, true))
	_check(SidePanel.energy_range(94.0, false) == "86-100", "energy_range wide (%s)" % SidePanel.energy_range(94.0, false))
	_check(SidePanel.forecast_line(0, 1) == "lasts to R3", "a full tank reads lasts to R3")
	var box := Control.new()
	root.add_child(box)
	var src: Dictionary = SidePanel.meter_src(box, 0, 80.0)
	_check(is_equal_approx(float(src.get("energy", -1.0)), 80.0), "meter_src keeps the tank it was given")


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
	await _frames(6)
	return true


func _screen() -> void:
	_opaque()
	_bars()
	_figures()
	_bottom()
	_labels()
	await _numbers()
	_dump()
	await _chips()


func _opaque() -> void:
	var bad := ""
	for n in view.find_children("*", "Control", true, false):
		var c := n as Control
		if not _draws_opaque(c):
			continue
		var hit := c.get_global_rect().intersection(ZONE)
		var area := hit.size.x * hit.size.y
		if area > 2000.0:
			bad = "%s %s area %.0f" % [c.get_path(), c.get_global_rect(), area]
			break
	_check(bad == "", "no opaque plate over the ring%s" % ("" if bad == "" else " (" + bad + ")"))


func _draws_opaque(c: Control) -> bool:
	if c == null or not c.visible or not c.is_visible_in_tree():
		return false
	if _under(c, "BodyPanel") or _under(c, "IntentChip"):
		return false
	if c is TextureRect:
		return true
	if c is ColorRect:
		return (c as ColorRect).color.a > 0.5
	if c is Panel or c is PanelContainer:
		var sb := c.get_theme_stylebox("panel")
		if sb == null or sb is StyleBoxEmpty:
			return false
		if sb is StyleBoxFlat:
			return (sb as StyleBoxFlat).bg_color.a > 0.5
		return true
	return false


func _bars() -> void:
	for side in 2:
		var home: Rect2 = OURS if side == 0 else THEIRS
		var panel := view.find_child("SidePanel%d" % side, true, false) as Control
		_check(panel != null, "SidePanel%d exists" % side)
		if panel == null:
			continue
		for word in ["Energy", "Legs", "Guard"]:
			var bar := panel.find_child(word + "Bar", true, false) as Control
			var r := Rect2() if bar == null else bar.get_global_rect()
			var inside := home.encloses(r) if bar != null else false
			_check(bar != null and inside and r.size.x > r.size.y + 1.0,
				"%sBar on side %d is a wide bar inside the top strip (%s)" % [word, side, r])


func _figures() -> void:
	for side in 2:
		var fig := view.find_child("BodyPanel%d" % side, true, false) as Control
		var home: Rect2 = HOME[side]
		var r := Rect2() if fig == null else fig.get_global_rect()
		_check(fig != null and home.encloses(r), "figure %d stands inside %s (got %s)" % [side, home, r])
		_check(fig != null and not _panel_behind(fig), "figure %d has no plate behind it" % side)


func _panel_behind(n: Node) -> bool:
	var p := n.get_parent()
	while p != null and p != view:
		if (p is Panel or p is PanelContainer) and _draws_opaque(p as Control):
			return true
		p = p.get_parent()
	return false


func _bottom() -> void:
	var bar := view.find_child("CornerBar", true, false) as Control
	_check(bar != null, "the bottom bar exists")
	if bar == null:
		return
	var br := bar.get_global_rect()
	for nm in ["Ear", "Pip0", "Pip1", "Pip2", "HabitCard"]:
		var n := view.find_child(nm, true, false) as Control
		var r := Rect2() if n == null else n.get_global_rect()
		_check(n != null and n.is_visible_in_tree() and r.position.y > 900.0 and br.encloses(r),
			"%s sits in the bottom bar (%s, bar %s)" % [nm, r, br])


func _labels() -> void:
	var homes: Array[Control] = []
	for nm in ["SidePanel0", "SidePanel1", "CornerBar"]:
		var n := view.find_child(nm, true, false) as Control
		if n != null:
			homes.append(n)
	var labs: Array[Label] = []
	for home in homes:
		for n in home.find_children("*", "Label", true, false):
			var l := n as Label
			if l.visible and l.is_visible_in_tree() and l.text.strip_edges() != "" and not _under(l, "BodyPanel"):
				labs.append(l)
	var hit := ""
	for i in labs.size():
		for j in range(i + 1, labs.size()):
			var a: Rect2 = labs[i].get_global_rect()
			var b: Rect2 = labs[j].get_global_rect()
			var overlap := a.intersection(b)
			if overlap.size.x > 4.0 and overlap.size.y > 4.0:
				hit = "%s '%s' and %s '%s'" % [labs[i].name, labs[i].text, labs[j].name, labs[j].text]
				break
		if hit != "":
			break
	_check(hit == "", "no two labels overlap in the strips or the bar%s" % ("" if hit == "" else " (" + hit + ")"))


func _chips() -> void:
	var hit := ""
	var t0 := float(view.t)
	for i in 20:
		view.t = t0 + float(i) * 0.35
		await _frames(1)
		for n in view.find_children("IntentChip*", "Control", true, false):
			var c := n as Control
			if str(c.name).begins_with("IntentChip") and c.visible and c.get_global_rect().intersects(BOARD):
				hit = "%s at t %.0f %s" % [c.name, float(view.t), c.get_global_rect()]
				break
		if hit != "":
			break
	_check(hit == "", "no chip covers the scoreboard%s" % ("" if hit == "" else " (" + hit + ")"))


func _numbers() -> void:
	var left := view.find_child("SidePanel0", true, false) as Control
	var right := view.find_child("SidePanel1", true, false) as Control
	if left == null or right == null:
		return
	var lv: Dictionary = LiveRound.live(main.modal)
	var exs: Array = lv.get("ex", [])
	var idx := mini(int(float(view.t) / Exchanges.EX_SECONDS), exs.size())
	var want := int(round(LiveRound.her_energy(lv, idx)))
	var lab := left.find_child("EnergyNum", true, false) as Label
	_check(lab != null and lab.text == str(want), "left energy is the live tank (%s, want %d)" % ["" if lab == null else lab.text, want])
	var f: Dictionary = main.career.fighter_by_id(str(view.fid))
	if int(f["bout"].get("film", 0)) >= BoutRules.FILM_DEPTH_WITH_STUDY:
		f["bout"]["film"] = BoutRules.FILM_DEPTH_DEFAULT
		await _frames(3)
	var legs := right.find_child("LegsNum", true, false) as Label
	_check(legs != null and legs.text == "?", "no film study: legs read ? (%s)" % ("" if legs == null else legs.text))
	var heard := view.find_child("Heard", true, false) as Label
	_check(heard != null and heard.text.begins_with("Heard ") and heard.text.ends_with(" of 3"),
		"heard reads as a count (%s)" % ("" if heard == null else heard.text))
	var count := view.find_child("HabitCount", true, false) as Label
	_check(count != null and (count.text.contains("time")), "the habit card names the game and a count (%s)" % ("" if count == null else count.text))
	var live: Node = view.get("body")
	var tag := left.find_child("WorstTag", true, false) as Label
	if live != null and tag != null:
		var vals := {}
		for p in BodyMap.PLACES:
			vals[p] = BodyMap.value(live.map, "a", p)
		var place := SidePanel.worst_place(vals)
		_check(tag.text == SidePanel.tag_text(place, BodyMap.band(float(vals[place]))), "the tag names the worst place (%s)" % tag.text)
	_check(view.bars != null and view.bars.has_method("stamina"), "the live host still answers stamina")
	for word in ["energy", "legs", "guard"]:
		var w := left.find_child(word.capitalize() + "Word", true, false) as Label
		_check(w != null and w.get_theme_font_size("font_size") >= 22, "%s is 22 px or more" % word)


func _dump() -> void:
	for nm in ["SidePanel0", "SidePanel1", "BodyPanel0", "BodyPanel1", "CornerBar"]:
		var n := view.find_child(nm, true, false) as Control
		if n != null:
			print("RECT %s %s" % [nm, n.get_global_rect()])
	for side_nm in ["SidePanel0", "SidePanel1"]:
		var panel := view.find_child(side_nm, true, false) as Control
		if panel == null:
			continue
		for word in ["Energy", "Legs", "Guard"]:
			var bar := panel.find_child(word + "Bar", true, false) as Control
			if bar != null:
				print("RECT %s %s %s" % [side_nm, bar.name, bar.get_global_rect()])


func _under(n: Node, prefix: String) -> bool:
	var p := n
	while p != null:
		if str(p.name).begins_with(prefix):
			return true
		p = p.get_parent()
	return false


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
