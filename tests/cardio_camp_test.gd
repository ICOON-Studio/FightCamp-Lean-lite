extends SceneTree
## S439 CARDIO1 round 3 (the S434 skeptic: "the Cardio camp card's Stamina end is derived from the mean's forecast"): the
## Cardio card's Stamina by fight night is the Stamina the bout reads on fight night. Population: the golden path's
## quick-start career (seed 1) - Lucy signed with three cards, Luke Reid hired, her first even offer accepted (as
## camp_cards_test). The Cardio camp's roadwork and intervals train Stamina by name (Attrs.SESSION_ATTRS), so Stamina moves
## more than the mean of Stamina and Recovery; a card that adds the mean's gain to Stamina understates fight night.
##   1. SET CAMP, the Cardio card: its bar's end, its face ("Stamina a -> b by fight night") and its caption's colour.
##   2. Start the camp with those picks, step the real days (Sim.step_day) to fight night, and read Stamina where the bout
##      reads it (Attrs.of(f), the number BoutRules.own_fade takes in LiveRound.open and BoutNight).
##   3. The card's end equals fight night's Stamina within 0.15 (camp_cards_test's tolerance for the power card: a twist
##      card drawn on a later Monday is not in the forecast), and the card's caption is gold exactly when that Stamina clears
##      the line.
## Red on the S434 branch tip b61377ea: the card printed Stamina now + the mean's gain.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const UI := preload("res://scripts/ui/UI.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var f := _book()
	_check(not f.is_empty(), "Lucy has an even bout booked")
	if f.is_empty():
		_done()
		return
	var c: Career = main.career
	main.act("camp", str(f["id"]))
	await _settle(0.1)
	var m: Node = main.modal_node()
	_check(m != null, "SET CAMP opens the camp modal")
	if m == null:
		_done()
		return
	var cardio := m.find_child("Focus_conditioning", true, false) as Button
	_check(cardio != null, "the Cardio card")
	if cardio != null:
		cardio.emit_signal("pressed")
	await _settle(0.8)
	m = main.modal_node()
	var card := m.find_child("Focus_conditioning", true, false)
	var bar := card.find_child("NightBar", true, false) if card != null else null
	var face := card.find_child("Forecast", true, false) as Label if card != null else null
	var cap := card.find_child("NightLine", true, false) as Label if card != null else null
	_check(bar != null and str(bar.get("stat")) == "stamina", "the Cardio card's bar runs on Stamina")
	var st_now := float(Attrs.of(f)["stamina"])
	var mean_now := float(f["stats"]["conditioning"])
	var card_end := float(bar.get("end")) if bar != null else -1.0
	var proto := int(main.modal.get("protocol", 0))
	print("  population: %s, Stamina %.2f, Recovery %.2f, conditioning (their mean) %.2f; Cardio camp, protocol %d, film %s, %d days" % [
		str(f["name"]), st_now, float(Attrs.of(f)["recovery"]), mean_now, proto, str(main.modal.get("film", false)),
		int(f["bout"]["day"]) - c.day])
	_press(m.find_child("StartCamp", true, false) as Button, "Start the camp")
	_check(str((f.get("camp", {}) as Dictionary).get("focus", "")) == "conditioning", "the camp is a Cardio camp")
	var bd := int(f["bout"]["day"])
	while c.day < bd:
		Sim.step_day(c)
	var st_night := float(Attrs.of(f)["stamina"])
	var mean_night := float(f["stats"]["conditioning"])
	print("  fight night: Stamina %.2f (%+.2f), conditioning %.2f (%+.2f); the card said Stamina %.2f" % [st_night, st_night - st_now,
		mean_night, mean_night - mean_now, card_end])
	_check(absf(card_end - st_night) < 0.15,
		"the Cardio card's Stamina by fight night is fight night's Stamina: card %.2f, fight night %.2f (gap %.2f)" % [card_end, st_night, card_end - st_night])
	_check(face != null and face.text.ends_with("-> %.1f by fight night" % card_end),
		"the card's face counts to the bar's end: %s" % (face.text if face != null else "?"))
	_check(cap != null and cap.get_theme_color("font_color") == (UI.GOLD if BoutRules.clears_night_line("stamina", st_night) else UI.MUTED),
		"the caption is gold exactly when fight night's Stamina %.2f clears the line %.0f" % [st_night, BoutRules.FADE_STAMINA])
	_done()


## The golden path's first weeks: quick start, Lucy signed with three cards, Luke Reid hired, her first even offer taken.
func _book() -> Dictionary:
	main.act("quick")
	var c: Career = main.career
	c.seed = 1
	c.first_hour = {}
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var f: Dictionary = c.fighter()
	for i in 60:
		if not (f["offers"] as Array).is_empty():
			break
		TestJump._tidy(main, c)
		main.run_to_stop()
	for o in f["offers"]:
		if not bool(o["mismatch"]):
			main.act("accept", str(o["id"]))
			return f
	return {}


func _press(b: Button, label: String) -> void:
	_check(b != null and not b.disabled, label)
	if b != null and not b.disabled:
		b.emit_signal("pressed")


func _settle(s: float) -> void:
	await create_timer(s).timeout
	await process_frame


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + label)
	else:
		print("  ok: " + label)


func _done() -> void:
	print("CARDIO_CAMP failures=%d" % failures)
	quit(1 if failures > 0 else 0)
