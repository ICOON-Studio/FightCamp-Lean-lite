extends SceneTree
## S442 LOOP drawing 3: the headline card between the last bell and the result page, in the real Main scene.
##   1. a bout simmed to the end opens on the headline (title, both sides, three cards, one cause, See the fight, which
##      breathes), never the result page first; See the fight opens today's result page.
##   2. Skip bout (the 3D view's "fightskip") still shows it; Enter opens the result page.
##   3. a result modal with no booked night (a bout not just fought) goes straight to the result page.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Pulse := preload("res://scripts/ui/Pulse.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	var c: Career = main.career
	c.seed = 1
	main.act("interview")   # sign Lucy, as the first hour does
	main.act("pickcard", "signature")
	main.act("sign")
	main.close_modal()

	# 1. Sim to result.
	var f := _book(c, 1)
	main.open_modal(Bouts.fight_modal(f))
	main.act("fightstep", "sim")
	await process_frame
	_check(str(main.modal.get("step", "")) == "result" and (main.modal.get("night", {}) as Dictionary).size() > 0, "the booking wrote the night's facts")
	var hc: Node = main.modal_node().find_child("Headline", true, false) if main.modal_node() != null else null
	_check(hc != null and main.modal_node().find_child("BackHome", true, false) == null, "the headline comes first, the result page waits")
	if hc != null:
		var title := hc.find_child("Title", true, false) as Label
		print("  headline: %s / %s" % [title.text if title != null else "-", (hc.find_child("Cause", true, false) as Label).text if hc.find_child("Cause", true, false) != null else "(no cause)"])
		_check(title != null and title.text.begins_with(str(f["first"]).to_upper()), "the title names the fighter (%s)" % (title.text if title != null else "-"))
		_check(hc.find_child("Side_red", true, false) != null and hc.find_child("Side_blue", true, false) != null, "both corners are on it")
		var cards := hc.find_child("Cards", true, false)
		_check(cards != null and (cards.get_child_count() == 3 or str(main.modal.get("stopped", "")) != ""), "the three cards (or the stoppage round)")
		var go := hc.find_child("HeadlineGo", true, false) as Button
		_check(go != null and Pulse.running(go) or DisplayServer.get_name() == "headless", "See the fight is the one gold button and breathes")
		_check(go != null and bool(go.get_meta(Pulse.ON, false)), "See the fight is marked to breathe")
		_check(main.modal_node().find_children("*", "Button", true, false).size() == 1, "one button on the card")
		var ms: Dictionary = (load("res://scripts/rules/Headline.gd").headline(main.modal["night"]) as Dictionary)["milestone"]
		_check(ms.is_empty() == (hc.find_child("Milestone", true, false) == null), "the ribbon shows only with a milestone (%s)" % str(ms))
		go.emit_signal("pressed")
		await process_frame
		_check(main.modal_node().find_child("Headline", true, false) == null and main.modal_node().find_child("BackHome", true, false) != null,
			"See the fight opens today's result page")
		main.redraw_modal()
		_check(main.modal_node().find_child("Headline", true, false) == null, "and the headline does not come back on a redraw")
	main.act("afterfight")

	# 2. Skip bout from round 1; Enter opens the result page.
	var f2 := _book(c, 2)
	main.open_modal(Bouts.fight_modal(f2))
	main.act("fightstep", "start")
	main.act("fightskip")
	await process_frame
	_check(str(main.modal.get("step", "")) == "result" and main.modal_node().find_child("Headline", true, false) != null, "Skip bout still shows the headline")
	var key := InputEventKey.new()
	key.keycode = KEY_ENTER
	key.pressed = true
	root.push_input(key)
	await process_frame
	_check(main.modal_node().find_child("BackHome", true, false) != null, "Enter opens the result page")

	# 3. A result with no booked night: straight to the result page.
	main.modal.erase("night")
	main.modal.erase("night_seen")
	main.redraw_modal()
	_check(main.modal_node().find_child("Headline", true, false) == null and main.modal_node().find_child("BackHome", true, false) != null,
		"no night booked: no headline")
	main.act("afterfight")
	print("HEADLINE_CARD failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## A booked amateur bout against Priya Nair for the career's first fighter (the opponent's file open, weighed in).
func _book(c: Career, n: int) -> Dictionary:
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["bout"] = {"opp": (Data.OPPONENTS[n % Data.OPPONENTS.size()] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true,
		"done": false, "film": 3, "arrows": []}
	return f


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + label)
	else:
		print("  ok: " + label)
