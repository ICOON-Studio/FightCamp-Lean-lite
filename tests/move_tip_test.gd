extends SceneTree
## S382 MOVETIP1: the one shared hover card (MoveTip). Hover a Playbook move card -> after ~0.25 s the card shows that
## move's name and chain, one 3D viewport playing it; leave -> hidden, the viewport stops drawing. The Combos tab's moves,
## Ana's mat rows (BJJ: the mat player replaces the boxing one - still one viewport) and the fighter page's move bars open
## the same card. A move with no clip shows its ink card, never a wrong clip.
## Population: a quick-start career, Lucy signed (the film tool's start), Ana on the mat.

const MoveTip := preload("res://scripts/ui/MoveTip.gd")
const Playbook := preload("res://scripts/ui/areas/Playbook.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const HeadsProbe := preload("res://tools/movetip_heads_probe.gd")
const HEAD_BAR_M := 0.25

var _fails := 0
var main: Node


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
	var f: Dictionary = c.fighters[0]

	# Pure: what the card says.
	var d := MoveTip.info("1-2", f)
	_check(str(d["name"]) == "One-two" and (d["glyphs"] as Array).map(func(g): return str(g[1])) == ["Jab", "Cross"],
		"the one-two's card: its name and its chain as glyphs (%s)" % str(d["glyphs"]))
	_check((d["clips"] as Array).size() == 2 and (d["lines"] as Array).size() <= 2 and not (d["leads"] as Array).is_empty(),
		"it plays two clips, says at most two lines (%s) and what it leads into (%s)" % [str(d["lines"]), str(d["leads"])])
	var jab := MoveTip.info("Jab", f)
	_check(str(jab["name"]) == "Jab" and str(jab["tier"]) in ["raw", "usable", "sharp", "signature"] and float(jab["gas"]) > 0.0,
		"a move bar's name finds the jab, her tier with it (%s) and its gas (%.1f%%)" % [jab["tier"], float(jab["gas"])])
	var check := MoveTip.info("Check hook", f)
	_check((check["clips"] as Array).is_empty(), "the check hook has no clip of its own: the ink card, never a wrong clip")

	# Hover a Moves-tab card.
	Playbook.pick = str(f["id"])
	main.act("go", "playbook:0")
	await _frames(6)
	var card := main.find_child("Move_1-2", true, false) as Control
	_check(card != null and card.has_meta("move_tip"), "the one-two's card carries the hover card")
	if card == null:
		_end()
		return
	var tip: Control = MoveTip.inst()
	await _secs(0.5)   # the page idles: the card warms its player (two bodies) before any hover
	_check(is_instance_valid(tip.get("player")), "an idle page warms the card's player before the first hover")
	card.mouse_entered.emit()
	var t0 := Time.get_ticks_msec()
	await _secs(0.1)
	_check(not tip.visible, "nothing opens before the hover delay")
	var open := await _until_open(tip)
	var after_ms := Time.get_ticks_msec() - t0
	_check(tip.visible and _text(tip, "TipName") == "One-two", "after the delay the card shows the one-two (%s)" % _text(tip, "TipName"))
	_check(after_ms <= 400 and open <= 100.0, "it opens %d ms after the hover (intent 250), its opening frame %.0f ms" % [after_ms, open])
	var cover := tip.find_child("TipCover", true, false) as Control
	_check(cover != null and cover.is_visible_in_tree() and cover.modulate.a > 0.99,
		"the clip box shows the move's ink card while the clip loads (alpha %.2f)" % (cover.modulate.a if cover else -1.0))
	await _secs(0.7)
	_check(cover != null and cover.modulate.a < 0.01, "then it cross-fades to the clip (alpha %.2f)" % (cover.modulate.a if cover else -1.0))
	_check(_has_label(tip.find_child("TipChain", true, false), "Jab") and _has_label(tip.find_child("TipChain", true, false), "Cross"),
		"its chain reads Jab > Cross")
	await _frames(4)
	_check(_viewports(tip) == 1, "one viewport in the card (%d)" % _viewports(tip))
	var p: Node = tip.get("player")
	_check(p != null and str(p.get("_move_id")) == "1-2", "the card's player plays the one-two (%s)" % (p.get("_move_id") if p else "none"))
	if p != null:
		# S382 round 2: a solid partner who reacts - the jab slipped or blocked, the cross taken.
		_check(float(p.ghost_alpha()) > 0.99, "the partner is solid, not a ghost (alpha %.2f)" % float(p.ghost_alpha()))
		_check(p.bodies_in_frame(), "both bodies head to feet in the studio camera")
		var seen := await _partner_clips(p, 3.0)
		_check(seen.any(func(c): return str(c).contains("dodge") or str(c).contains("block") or str(c) == "slip"),
			"the partner slips or blocks the jab (%s)" % str(seen))
		_check(seen.any(func(c): return str(c).contains("hit_by_cross") or str(c).contains("hit_jab") or str(c) == "react_head"),
			"and takes the cross (%s)" % str(seen))
	var r := card.get_global_rect()
	var tr := tip.get_global_rect()
	var screen := tip.get_viewport().get_visible_rect().size   # headless reports its own height; the card keeps to it
	_check(not r.intersects(tr) and tr.position.x >= 0.0 and tr.end.x <= screen.x and tr.end.y <= screen.y,
		"beside the card, on screen (%s vs %s; screen %s, min %s)" % [tr, r, tip.get_viewport().get_visible_rect().size,
		tip.get_combined_minimum_size()])
	card.mouse_exited.emit()
	await _frames(2)
	_check(not tip.visible, "leave and it hides")
	var vps: Array = p.find_children("*", "SubViewport", true, false) if p != null else []
	var vp: SubViewport = vps[0] if not vps.is_empty() else null
	_check(vp != null and vp.render_target_update_mode == SubViewport.UPDATE_DISABLED and p.process_mode == Node.PROCESS_MODE_DISABLED,
		"hidden, its viewport stops drawing and its player stops ticking")

	# A second card reuses the same player.
	var card2 := main.find_child("Move_1-2-3", true, false) as Control
	if card2 != null:
		card2.mouse_entered.emit()
		await _secs(0.35)
		_check(tip.visible and _text(tip, "TipName") == "One-two-hook" and tip.get("player") == p and _viewports(tip) == 1,
			"another card: same card, same player, still one viewport")
		card2.mouse_exited.emit()

	# Combos tab: the moves to try and the book chips.
	main.act("go", "playbook:2")
	await _frames(6)
	var t := main.find_child("Try_lead_hook", true, false) as Control
	var b := main.find_child("Book_1-2", true, false) as Control
	_check(t != null and t.has_meta("move_tip") and b != null and b.has_meta("move_tip"), "Combos: moves to try and the book chips carry it")
	if t != null:
		t.mouse_entered.emit()
		await _secs(0.35)
		_check(tip.visible and _text(tip, "TipName") == "Lead hook", "hover the lead hook: its card (%s)" % _text(tip, "TipName"))
		t.mouse_exited.emit()
		await _frames(2)
	var bh := main.find_child("Try_body_hook", true, false) as Control
	if bh != null:
		bh.mouse_entered.emit()
		await _until_open(tip)
		var seen := await _partner_clips(tip.get("player"), 2.5)
		_check(seen.any(func(c): return str(c).contains("gutshot") or str(c) == "react_body"), "a body hook folds him (%s)" % str(seen))
		bh.mouse_exited.emit()
		await _frames(2)

	# Fighter page move bars.
	main.act("fighter", str(f["id"]))
	main.act("ftab", "1")
	await _frames(4)
	var bars := main.find_children("*", "Control", true, false).filter(func(n): return n.has_meta("move_tip"))
	_check(bars.size() >= 6, "the fighter page's move and combination bars carry it (%d)" % bars.size())
	# A move with no clip: the compact card - no clip box, the height of its content.
	var ch: Control = null
	for n in bars:
		if str(n.get_meta("move_tip")) == "Check hook":
			ch = n
	_check(ch != null, "the check hook's bar carries it")
	if ch != null:
		ch.mouse_entered.emit()
		await _until_open(tip)
		await _frames(3)
		var box := tip.find_child("TipClip", true, false) as Control
		_check(tip.visible and box != null and not box.visible and tip.size.y < 300.0,
			"no clip: the compact card, no clip box (%s), %.0f px tall" % [box.visible if box else "none", tip.size.y])
		ch.mouse_exited.emit()
		await _frames(2)

	# BJJ: Ana's mat rows; the mat player replaces the boxing one.
	Playbook.pick = "ana"
	main.act("go", "playbook:0")
	await _frames(6)
	var mat := main.find_child("Mat_kimura", true, false)
	var nm: Control = null
	if mat != null:
		for k in mat.get_children():
			if k.has_meta("move_tip"):
				nm = k
	_check(nm != null, "Ana's kimura row carries the hover card")
	# S382 round 2 (skeptic: the tip's mat shared the ROOT World3D with the Playbook's mat - four bodies in both clips, and
	# they stayed after the tip hid). Every clip player owns its world; the Playbook's mat world never gains a body.
	var pb_mat := main.find_child("MatPlayer", true, false)
	var pw := _world_of(pb_mat)
	var before := _skels(pw)
	_check(pw != null and pw != root.find_world_3d() and before == 2,
		"the Playbook's mat owns its world, two bodies in it (%d)" % before)
	if nm != null:
		nm.mouse_entered.emit()
		await _secs(0.35)
		await _frames(4)
		_check(tip.visible and _text(tip, "TipName") == "Kimura", "hover the kimura: its card (%s)" % _text(tip, "TipName"))
		_check(_viewports(tip) == 1 and str(tip.get("player").get_script().resource_path).ends_with("MatPlayer.gd"),
			"the mat plays it - still one viewport (%d)" % _viewports(tip))
		var tw := _world_of(tip.get("player"))
		_check(tw != null and tw != pw and tw != root.find_world_3d(), "the tip's mat has its own world (not the Playbook's, not the root's)")
		_check(_skels(pw) == before and _skels(tw) == 2,
			"open: the Playbook's mat still shows %d bodies (%d), the tip's two (%d)" % [before, _skels(pw), _skels(tw)])
		nm.mouse_exited.emit()
		await _frames(2)
		_check(not tip.visible, "leave and it hides")
		_check(_skels(pw) == before and _skels(tw, true) == 0,
			"closed: the Playbook's mat %d bodies (%d), none of the tip's left showing (%d)" % [before, _skels(pw), _skels(tw, true)])

	# S382 round 3 (movetip_r2.mp4 0:19.45: on the body hook the folded partner's head went inside Danny's). Every frame of
	# each studio clip, on her pair and on Danny's (a man's body), the two heads - their centres riding with the heads -
	# stay at least HEAD_BAR_M apart.
	Roster.prospect(c, "danny")["state"] = "invited"
	var danny := Roster.sign_prospect(c, "danny", ["signature"])
	for who in [f, danny]:
		var hp: Control = HeadsProbe.player(self, who)
		await process_frame
		for id in ["jab", "1-2", "lead_hook", "body_hook"]:
			var hr: Dictionary = await HeadsProbe.heads(self, hp, MoveTip.info(id, who))
			_check(int(hr["n"]) >= 20 and float(hr["min"]) >= HEAD_BAR_M, "%s, %s: heads %.3f m apart at the closest (%.2f s, partner %s; %d frames)"
				% [str(who.get("name", "?")), id, float(hr["min"]), float(hr["at"]), hr["clip"], int(hr["n"])])
		hp.queue_free()
		await process_frame
	_end()


## Waits for the card to open (2 s at most); returns how long the frame it opened in took, ms.
func _until_open(tip: Control) -> float:
	var t0 := Time.get_ticks_usec()
	var last := t0
	while Time.get_ticks_usec() - t0 < 2000000:
		await process_frame
		var now := Time.get_ticks_usec()
		if tip.visible:
			return (now - last) / 1000.0
		last = now
	return 9999.0


## The clips the partner (boxer 1) plays over `s` seconds.
func _partner_clips(p: Node, s: float) -> Array:
	var seen: Array = []
	if p == null:
		return seen
	var ap: AnimationPlayer = p.get("_stage").boxers[1]["ap"]
	var t0 := Time.get_ticks_msec()
	while Time.get_ticks_msec() - t0 < int(s * 1000.0):
		await process_frame
		var c := str(ap.current_animation)
		if c != "" and not seen.has(c):
			seen.append(c)
	return seen


## The World3D a clip player draws (its SubViewport's own, else the one it inherits).
func _world_of(p: Node) -> World3D:
	if p == null:
		return null
	var vps := p.find_children("*", "SubViewport", true, false)
	return (vps[0] as SubViewport).find_world_3d() if not vps.is_empty() else null


## The skeletons (bodies) in world `w`, across the whole tree; `showing` = only those visible in the tree.
func _skels(w: World3D, showing := false) -> int:
	if w == null:
		return -1
	return root.find_children("*", "Skeleton3D", true, false).filter(func(s):
		return (s as Node3D).get_world_3d() == w and (not showing or (s as Node3D).is_visible_in_tree())).size()


func _end() -> void:
	print("MOVE_TIP %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _viewports(n: Node) -> int:
	return n.find_children("*", "SubViewport", true, false).size()


func _text(n: Node, child: String) -> String:
	var l := n.find_child(child, true, false) as Label
	return l.text if l != null else ""


func _has_label(n: Node, s: String) -> bool:
	if n == null:
		return false
	for l in n.find_children("*", "Label", true, false):
		if (l as Label).text == s:
			return true
	return false


func _frames(n: int) -> void:
	for i in n:
		await process_frame


func _secs(s: float) -> void:
	await create_timer(s).timeout


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
