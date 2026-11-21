extends SceneTree
## DEBUTPICK1 (S533) diagnostic: why the offer's read (DebutRead.card at the call) sits far under the fight-night read for
## a newcomer (Tess Reilly: 60 against 71) when the six stats grow only half a point. Plays one boxer to the pro offer,
## signs, plays to fight night, then re-reads the OFFER with one field at a time taken from the fight-night boxer.
## Args: who=<index in [lucy] + PROSPECTS> (default 3 = Tess). Population: one named boxer; a diagnostic, not a measurement.

const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const Data := preload("res://scripts/state/Data.gd")
const DebutRead := preload("res://scripts/rules/DebutRead.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Sim := preload("res://scripts/state/Sim.gd")


func _initialize() -> void:
	var idx := 3
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("who="):
			idx = int(str(a).substr(4))
	var people: Array = [Data.lucy()] + Data.PROSPECTS
	var c := Career.quick_start()
	c.seed = 7000; c.first_hour = {}; FirstWeek.skip(c)
	c.applicant = (people[idx] as Dictionary).duplicate(true)
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"]); Sim.hire(c, "reid")
	var f: Dictionary = c.fighter()
	f["ambition"] = "Turn pro as soon as the call comes"
	var guard := 0
	while c.pro_offer.is_empty() and guard < 5000:
		guard += 1
		_pre(c, f, true)
		Sim.step_day(c)
	var t: Dictionary = (c.pro_offer["offers"] as Array)[0]
	var coach := float(c.coach.get("rating", 0.0))
	var at_offer: Dictionary = f.duplicate(true)
	var base := float(DebutRead.card(at_offer, t, c.day, coach)["win"])
	print("WHO %s day %d house %s gap %.1f offer read %.3f" % [f["name"], c.day, t["key"], float(t["opp_gap"]), base])
	Roster.turn_pro(c, str(t["key"]))
	guard = 0
	while guard < 200 and not Bouts.fight_day(c, f):
		guard += 1
		_pre(c, f, false)
		Sim.step_day(c)
	var opp: Dictionary = f["bout"]["opp"]
	var night := BoutRead.CardOdds.win(BoutRead.round_edges(f, opp, f.get("camp", {}), coach), BoutRead.RingDuel.FORM_SD)
	var whole := float(DebutRead.card(f, t, 0, coach)["win"])
	print("NIGHT read %.3f (the booked bout, its camp %s) | the offer's rule on the fight-night boxer %.3f" % [night, str(f.get("camp", {})), whole])
	var keys := {}
	for k in at_offer.keys(): keys[k] = true
	for k in f.keys(): keys[k] = true
	for k in keys:
		if k in ["bout", "camp", "offers"]:
			continue
		var a: Variant = at_offer.get(k)
		var b: Variant = f.get(k)
		if str(a) == str(b):
			continue
		var fx: Dictionary = at_offer.duplicate(true)
		fx[k] = b.duplicate(true) if (b is Dictionary or b is Array) else b
		var r := float(DebutRead.card(fx, t, 0, coach)["win"])
		if absf(r - base) >= 0.003:
			print("FIELD %s moves the offer's read %.3f -> %.3f (%+.1f points)\n   call: %s\n   night: %s" % [k, base, r, (r - base) * 100.0, str(a).left(400), str(b).left(400)])
		else:
			print("field %s differs, read unmoved" % k)
	quit(0)


func _pre(c: Career, f: Dictionary, fight: bool) -> void:
	for o2 in (f["offers"] as Array).duplicate():
		if bool(o2["answered"]) or bool(o2["mismatch"]):
			continue
		if not (f["bout"] as Dictionary).is_empty():
			Bouts.decline(c, str(o2["id"]))
		else:
			Bouts.accept(c, str(o2["id"]))
	for o2 in (f["offers"] as Array).duplicate():
		if not bool(o2["answered"]):
			Bouts.decline(c, str(o2["id"]))
	if Bouts.camp_due(c, f):
		Bouts.start_camp(c, f, Sim.focus_of(c, f), 2, OppFile.has_tape((f["bout"] as Dictionary).get("opp", {})), false)
	if Bouts.weigh_in_today(c, f):
		Bouts.weigh(c, f)
	if fight and Bouts.fight_day(c, f):
		Bouts.fight_step(c, f, Bouts.fight_modal(f), "sim")
		Bouts.after_fight(c, f)
	if bool(f.get("goal_talk", false)):
		Bouts.set_goal(c, f, "five_round_engine")
