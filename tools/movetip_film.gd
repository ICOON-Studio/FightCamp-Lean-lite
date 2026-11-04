extends SceneTree
## S382 MOVETIP1 film: the hover card (MoveTip) as the player meets it. Quick start, Danny Osei signed (a man: his own
## male body, bare-chested), PLAYBOOK: the mouse rests on the jab (Combos), the one-two (Moves), the lead hook and the
## body hook (Combos), the check hook's bar on his page (no clip: the compact card), then Ana's kimura beside her own mat.
## Round 2 (S382): the partner reacts, the studio camera, the ink card's cross-fade, the tip's own World3D. A drawn cursor shows where the mouse is; the hover is a real mouse
## motion through the GUI (a direct mouse_entered only if the GUI did not see it).
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 30 --write-movie <out>/movetip.avi --script res://tools/movetip_film.gd
## Prints MOVETIP_FILM failures=<n>.

const MoveTip := preload("res://scripts/ui/MoveTip.gd")
const Playbook := preload("res://scripts/ui/areas/Playbook.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const HOLD_S := 4.0

var main: Node
var failures := 0
var _cursor: Polygon2D
var _at := Vector2(960, 540)


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _frames(4)
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	var c: Career = main.career
	Roster.prospect(c, "danny")["state"] = "invited"
	var danny := Roster.sign_prospect(c, "danny", ["signature"])
	_check(str(danny.get("sex", "")) == "m", "Danny Osei signed (a man)")
	_add_cursor()
	Playbook.pick = str(danny["id"])
	main.act("go", "playbook:2")
	await _secs(1.5)   # the page idles: the card warms its player
	await _hover("Try_jab", "Jab")
	main.act("go", "playbook:0")
	await _secs(1.0)
	await _hover("Move_1-2", "One-two")
	main.act("go", "playbook:2")
	await _secs(1.0)
	await _hover("Try_lead_hook", "Lead hook")
	await _hover("Try_body_hook", "Body hook")
	# S382 round 2: a move with no clip - the compact card (the check hook's bar on his page).
	main.act("fighter", str(danny["id"]))
	main.act("ftab", "1")
	await _secs(1.0)
	var ch: Control = null
	for n in main.find_children("*", "Control", true, false):
		if n.has_meta("move_tip") and str(n.get_meta("move_tip")) == "Check hook":
			ch = n
	var up: Node = ch.get_parent() if ch != null else null
	while up != null and not up is ScrollContainer:
		up = up.get_parent()
	if up != null:
		(up as ScrollContainer).ensure_control_visible(ch)   # the move bars sit below the perk road
		await _secs(0.5)
	await _hover_node(ch, "Check hook", 2.5)
	Playbook.pick = "ana"
	main.act("go", "playbook:0")
	await _secs(0.8)
	var mat := main.find_child("Mat_kimura", true, false)
	var nm: Control = null
	if mat != null:
		for k in mat.get_children():
			if k.has_meta("move_tip"):
				nm = k
	await _hover_node(nm, "Kimura", 5.5)
	await _move_to(Vector2(1800, 1000))
	await _secs(0.6)
	_check(not MoveTip.inst().visible, "off the cards, the hover card is gone")
	print("MOVETIP_FILM failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _hover(child: String, want: String) -> void:
	await _hover_node(main.find_child(child, true, false) as Control, want, HOLD_S)


func _hover_node(n: Control, want: String, hold: float) -> void:
	if n == null:
		_check(false, "%s on the page" % want)
		return
	var r := n.get_global_rect()
	await _move_to(r.position + Vector2(minf(r.size.x * 0.4, 120.0), r.size.y * 0.5))
	await _secs(0.5)
	var tip: Control = MoveTip.inst()
	if not tip.visible:   # the GUI did not take the motion as a hover (a hidden desktop has no real pointer)
		n.mouse_entered.emit()
		await _secs(0.35)
	_check(tip.visible and (tip.find_child("TipName", true, false) as Label).text == want, "hover %s: its card" % want)
	await _secs(hold)


## Glides the drawn cursor there and sends the motion through the GUI.
func _move_to(to: Vector2) -> void:
	var from := _at
	var steps := 12
	for i in range(1, steps + 1):
		_at = from.lerp(to, float(i) / steps)
		_cursor.position = _at
		var ev := InputEventMouseMotion.new()
		ev.position = _at
		ev.global_position = _at
		ev.relative = (to - from) / steps
		root.push_input(ev, true)   # canvas coordinates, the same as the cards' rects
		await process_frame


func _add_cursor() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 120
	root.add_child(layer)
	var edge := Polygon2D.new()
	edge.polygon = PackedVector2Array([Vector2(-2, -3), Vector2(-2, 27), Vector2(6, 20), Vector2(12, 32), Vector2(18, 29),
		Vector2(12, 17), Vector2(22, 17)])
	edge.color = Color.WHITE
	_cursor = Polygon2D.new()
	_cursor.polygon = PackedVector2Array([Vector2(0, 0), Vector2(0, 23), Vector2(6, 17), Vector2(11, 28), Vector2(15, 26),
		Vector2(10, 15), Vector2(18, 15)])
	_cursor.color = Color("#22262e")
	_cursor.add_child(edge)
	edge.show_behind_parent = true
	layer.add_child(_cursor)


func _frames(n: int) -> void:
	for i in n:
		await process_frame


func _secs(s: float) -> void:
	await create_timer(s).timeout


func _check(ok: bool, what: String) -> void:
	print(("OK   " if ok else "FAIL ") + what)
	if not ok:
		failures += 1
