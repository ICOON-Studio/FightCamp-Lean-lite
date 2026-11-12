extends SceneTree
## NEXTOFFER (S440, PAGES2B round 3): NextOffer.day names the day the game's own day loop brings a boxer her next bout
## offer. Every check steps the real days (Sim.step_day) and asserts the offers arrive on that day and not one day sooner,
## never against a typed number. -1 while she is booked or an offer is still open.
##   python ops/Tools/godot_slot.py run --who claude -- <godot.exe> --headless --audio-driver Dummy --path .
##       --script res://tests/next_offer_test.gd

const MAIN := preload("res://scenes/Main.tscn")
const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Data := preload("res://scripts/state/Data.gd")
const NextOffer := preload("res://scripts/rules/NextOffer.gd")

var failures := 0


func _initialize() -> void:
	var main: Node = MAIN.instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	var c: Career = main.career
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	var f: Dictionary = c.fighters[c.fighters.size() - 1]
	f["offers"] = []
	f["bout"] = {}

	# A fresh signing: nothing booked, nothing to answer - the day is the one the day loop rolls her pair on.
	var d := NextOffer.day(c, f)
	_check(d > c.day, "a fresh signing has an offer day ahead (%d, today %d)" % [d, c.day])
	_check(_arrives_on(c, f, d), "the pair of offers arrives on that day, not before (day %d)" % d)

	# An offer open: no next day until it is answered.
	_check(NextOffer.day(c, f) == -1, "an offer still open: no next offer day (%d)" % NextOffer.day(c, f))

	# Declined: the day moves by the game's own wait, and the day loop keeps it.
	for o in f["offers"]:
		if not bool(o["mismatch"]):
			Bouts.decline(c, str(o["id"]))
	for o in f["offers"]:
		o["answered"] = true
	var after := NextOffer.day(c, f)
	_check(after > c.day, "after a decline the next offer day is ahead (%d)" % after)
	_check(_arrives_on(c, f, after), "after a decline the offers arrive on that day (day %d)" % after)

	# A day already due (next_offer_day passed while an offer stood): the next step is the day.
	for o in f["offers"]:
		o["answered"] = true
	f["next_offer_day"] = c.day - 3
	_check(NextOffer.day(c, f) == c.day + 1, "a day already due reads as tomorrow (%d)" % NextOffer.day(c, f))
	_check(_arrives_on(c, f, c.day + 1), "and the offers come tomorrow")

	# Booked: no next offer day.
	f["bout"] = {"day": c.day + 20, "opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true)}
	_check(NextOffer.day(c, f) == -1, "booked: no next offer day")
	f["bout"] = {}

	# The no-gi athlete never gets a boxing offer.
	_check(NextOffer.day(c, {"sport": "bjj", "bout": {}, "offers": []}) == -1, "no-gi: no boxing offer day")

	print("NEXT_OFFER failures=%d" % failures)
	print("PASS next_offer_test" if failures == 0 else "FAIL next_offer_test")
	quit(1 if failures > 0 else 0)


## Steps the real days to `d`: no open offer the day before, an open one on the day.
func _arrives_on(c: Career, f: Dictionary, d: int) -> bool:
	if d <= c.day:
		return false
	while c.day < d - 1:
		Sim.step_day(c)
		if _open(f):
			print("    offer came early on day %d" % c.day)
			return false
	Sim.step_day(c)
	return c.day == d and _open(f)


func _open(f: Dictionary) -> bool:
	for o in f.get("offers", []):
		if not bool(o["answered"]) and not bool(o["mismatch"]):
			return true
	return false


func _check(ok: bool, what: String) -> void:
	if ok:
		print("  ok: " + what)
	else:
		failures += 1
		print("  FAIL: " + what)
