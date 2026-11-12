extends SceneTree
## S442 LOOP stills: the corner minute's swap cards (the words page and the 3D corner card) and the headline card (a bout
## as it came, then a milestone bout), from real bouts in the real Main scene. Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/loop_shots.gd -- <out_dir> no3d
## Writes <name>_real.png per moment; prints LOOP_SHOTS done / any control running off the 1920x1080 frame.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const CornerJobsRow := preload("res://scripts/ui/CornerJobsRow.gd")
const CornerOverlay := preload("res://scripts/fight3d/CornerOverlay.gd")
const CornerCard := preload("res://scripts/rules/CornerCard.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const Adaptation := preload("res://scripts/rules/Adaptation.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const Headline := preload("res://scripts/rules/Headline.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const ExchangeBeats := preload("res://scripts/fight3d/ExchangeBeats.gd")
const Combos := preload("res://scripts/rules/Combos.gd")

const PLAN := [{"move": "1-2"}, {"move": "step_back", "when": "press"}, {"move": "1-2-3", "when": "counter"}]

var main: Node
var out_dir := "user://loop"


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	DirAccess.remove_absolute(out_dir.path_join("rects.txt"))
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(6)
	main.act("quick")
	main.career.seed = 1
	main.close_modal()
	main.act("interview")   # sign Lucy, as the first hour does
	main.act("pickcard", "signature")
	main.act("sign")
	main.close_modal()
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	_book(f, (Data.OPPONENTS[1] as Dictionary).duplicate(true), c.day)
	main.open_modal(Bouts.fight_modal(f))
	main.act("fightstep", "start")
	main.act("fightstep", "round_out")
	main.act("fightwatched", "1")
	if (CornerJobsRow.menu(f, (main.modal["rounds"] as Array)[-1])["swap"] as Dictionary).is_empty():
		main.act("fightstep", "corner:lead")
		main.act("fightstep", "round_out")
		main.act("fightwatched", "2")
	print("LOOP_SHOTS corner after round %d, tally %s" % [int(main.modal["round"]), str(f["bout"].get("plan_tally", {}))])
	await _settle()
	var sw := main.find_child("SwapCards", true, false) as Control
	var sc := main.find_child("CornerScroll", true, false) as ScrollContainer
	if sw != null and sc != null:
		sc.scroll_vertical = int(sc.get_v_scroll_bar().max_value)
	await _shot("corner_2d")
	await _hover("corner_2d_hover")
	# The 3D corner card as CornerOverlay draws it over the ring (the ring itself left black here).
	main._modal_layer.visible = false
	var layer := CanvasLayer.new()
	layer.layer = 60
	root.add_child(layer)
	var bg := ColorRect.new()
	bg.color = Color("#2a2420")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(bg)
	# Today's card first (the PLAN row as the dropdown alone), for the height it had before the cards.
	var before: Control = CornerOverlay.new()
	layer.add_child(before)
	var card0 := _card3d(f, main.modal)
	card0["jobs_menu"]["swap"] = {}
	before.build(card0, [str(f["first"]), str(f["bout"]["opp"]["first"])])
	before._card.visible = true
	await _settle(8)
	_overflow(before._card, "corner_3d card BEFORE (no cards)")
	before.queue_free()
	var ov: Control = CornerOverlay.new()
	layer.add_child(ov)
	ov.build(_card3d(f, main.modal), [str(f["first"]), str(f["bout"]["opp"]["first"])])
	ov.clock(51.0, int(main.modal["round"]) + 1)
	ov._card.visible = true
	await _shot("corner_3d")
	_overflow(ov._card, "corner_3d card")
	await _hover("corner_3d_hover")
	layer.queue_free()
	main._modal_layer.visible = true
	# The headline of this bout, then the result page it opens.
	main.act("fightstep", "corner:lead")
	main.act("fightstep", "end")
	await _shot("headline")
	_overflow(main.find_child("HeadlineCard", true, false) as Control, "headline card")
	var go := main.find_child("HeadlineGo", true, false) as Button
	if go != null:
		go.emit_signal("pressed")
	await _shot("headline_then_result")
	main.act("afterfight")
	# A milestone night: three wins, the fourth enters the rankings (a softer opponent so it comes in a few tries).
	for t in 6:
		f = c.fighter()
		f["w"] = 3
		f["l"] = 1
		var soft := (Data.OPPONENTS[0] as Dictionary).duplicate(true)
		soft["rating"] = 40.0
		_book(f, soft, c.day)
		main.open_modal(Bouts.fight_modal(f))
		main.act("fightstep", "sim")
		var h := Headline.headline(main.modal.get("night", {}))
		print("LOOP_SHOTS milestone try %d: %s %s" % [t, str(h["title"]), str(h["milestone"])])
		if not (h["milestone"] as Dictionary).is_empty():
			await _shot("headline_milestone")
			_overflow(main.find_child("HeadlineCard", true, false) as Control, "milestone card")
			break
		main.act("afterfight")
		c.day += 1
	print("LOOP_SHOTS done")
	quit(0)


func _book(f: Dictionary, opp: Dictionary, day: int) -> void:
	f["camp"] = {}
	f["moves"] = {"Jab": 70.0, "Cross": 66.0, "Lead hook": 58.0, "Body hook": 50.0, "Uppercut": 10.0, "Check hook": 0.0}
	f["combos"] = {"1-2": 60.0, "1-2-3": 35.0}
	f["arrows"] = PLAN.duplicate(true)
	f["bout"] = {"opp": opp, "day": day, "weighed": true, "made": true, "done": false, "film": 3, "arrows": PLAN.duplicate(true)}


## The card FightCast.corner hands CornerOverlay (no body column: that needs the ring's body map).
func _card3d(f: Dictionary, m: Dictionary) -> Dictionary:
	var rounds: Array = m["rounds"]
	var r: Dictionary = rounds[-1]
	var names := [str(f["first"]), str(f["bout"]["opp"]["first"])]
	var en: Dictionary = r.get("energy", {})
	var card := CornerCard.card(r.get("card", CornerCard.summarize([])), float(en.get("a_end", 100.0)), names)
	card.merge(Exchanges.read(r["exchanges"], names), true)
	var grades := {}
	for k in Exchanges.CALLS.keys():
		grades[k] = Exchanges.grade(str(k), LiveRound.values(f))["word"]
	card["grades"] = grades
	card["fixes"] = LiveRound.fixes(f, r)
	card["adapts"] = Adaptation.offers(r.get("exchanges", []), float(r.get("fix_hold", 0.0)), "")
	card["jobs_menu"] = CornerJobsRow.menu(f, r)
	var won_a := rounds.filter(func(x): return bool((x as Dictionary).get("won", false))).size()
	card["stats"] = {"round": rounds.size(), "won": bool(r.get("won", false)), "score": [won_a, rounds.size() - won_a],
		"counts": int(r.get("counts", 0)), "tally": BodyMap.tally(_beats(f, m, r, names)), "energy": {"a": float(en.get("a_end", 100.0)), "b": float(en.get("b_end", 100.0))}}
	card["fight_rounds"] = rounds.duplicate()
	var t: Dictionary = card["stats"]["tally"]
	print("LOOP_SHOTS corner tally: landed %d of %d / %d of %d" % [int(t["a"]["landed"]["total"]), int(t["a"]["thrown"]["total"]),
		int(t["b"]["landed"]["total"]), int(t["b"]["thrown"]["total"])])
	return card


## S443 (the operator's still showed 0 of 0 for every punch line: this tool passed BodyMap.tally([]) as a stand-in): the
## round's beats as FightView._queue builds them from its exchanges, so the table counts what the ring would play.
func _beats(f: Dictionary, m: Dictionary, r: Dictionary, names: Array) -> Array:
	var opp: Dictionary = f["bout"]["opp"]
	var profiles := {"a": RoundStyle.of_fighter(f), "b": RoundStyle.from_opponent(opp)}
	var n := (m["rounds"] as Array).size()
	var ctx := {"n": n, "plan": "", "a_style": str(f.get("style", "")), "b_style": str(opp.get("style", "")),
		"seed": int(main.career.day) * 97 + n, "profiles": profiles, "f": f, "opp": opp, "names": names, "day": int(main.career.day),
		"won_last": false}
	var exs: Array = r.get("exchanges", [])
	var e: Dictionary = r.get("energy", {})
	var out: Array = []
	for k in exs.size():
		for side in ["a", "b"]:
			var e0 := float(e.get(side, Combos.TANK))
			var e1 := float(e.get(side + "_end", e0))
			profiles[side]["energy"] = lerpf(e0, e1, float(k) / Exchanges.EXCHANGES)
			profiles[side]["energy_end"] = lerpf(e0, e1, float(k + 1) / Exchanges.EXCHANGES)
		out.append_array(ExchangeBeats.build(exs[k], k, r, ctx))
	return out


func _hover(name: String) -> void:
	var cards := root.find_children("Swap_*", "Button", true, false).filter(func(b): return (b as Control).is_visible_in_tree())
	if cards.is_empty():
		print("LOOP_SHOTS no swap card to hover for ", name)
		return
	(cards[0] as Button).emit_signal("mouse_entered")
	await _shot(name)
	(cards[0] as Button).emit_signal("mouse_exited")


func _overflow(c: Control, what: String) -> void:
	if c == null:
		print("LOOP_SHOTS %s: not found" % what)
		return
	var r := c.get_global_rect()
	var line := "LOOP_SHOTS %s rect %s%s" % [what, str(r), "  OFF THE FRAME" if r.end.y > 1080.0 or r.end.x > 1920.0 or r.position.y < 0.0 else ""]
	print(line)
	var fa := FileAccess.open(out_dir.path_join("rects.txt"), FileAccess.READ_WRITE if FileAccess.file_exists(out_dir.path_join("rects.txt")) else FileAccess.WRITE)
	if fa != null:
		fa.seek_end()
		fa.store_line(line)


func _settle(frames: int = 4) -> void:
	for i in frames:
		await process_frame


func _shot(name: String) -> void:
	await _settle(8)
	if DisplayServer.get_name() == "headless":
		print("LOOP_SHOTS (headless) would shoot ", name)
		return
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name + "_real.png"))
	print("wrote ", out_dir.path_join(name + "_real.png"))
