extends SceneTree
## S442 LOOP drawing 1: the corner minute's PLAN row as swap cards (CornerSwapCards via CornerJobsRow), built from a real
## bout: Lucy against Priya Nair (counter-puncher) on a plan whose line C (One-two-hook, when the opponent counters) is
## the wrong answer, fought round by round until a planned line has lost.
##   1. the row: the lost-most strip, 1-2 cards, Keep the plan, Other changes (today's full list), the ring strip.
##   2. a card's click writes the same arrow the dropdown writes; the next round plays the plan LineSwap.apply builds.
##   3. hovering a card names the swap on the lost line's place and draws the link.
##   4. no planned line lost: no cards, today's dropdown as before.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const CornerJobsRow := preload("res://scripts/ui/CornerJobsRow.gd")
const LineSwap := preload("res://scripts/rules/LineSwap.gd")

const PLAN := [{"move": "1-2"}, {"move": "step_back", "when": "press"}, {"move": "1-2-3", "when": "counter"}]

var failures := 0


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighters[-1]
	f["camp"] = {}
	f["moves"] = {"Jab": 70.0, "Cross": 66.0, "Lead hook": 58.0, "Body hook": 50.0, "Uppercut": 10.0, "Check hook": 0.0}
	f["combos"] = {"1-2": 60.0, "1-2-3": 35.0}
	f["arrows"] = PLAN.duplicate(true)   # round 1 copies the fighter's own plan onto the bout (LiveRound.open)
	var opp: Dictionary = (Data.OPPONENTS[1] as Dictionary).duplicate(true)
	f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 3, "arrows": PLAN.duplicate(true)}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "start")
	_box(c, f, m)
	var mn := CornerJobsRow.menu(f, (m["rounds"] as Array)[-1])
	if (mn["swap"] as Dictionary).is_empty():   # no planned line lost in round 1 (line C fires only on a counter): one more round
		Bouts.fight_step(c, f, m, "corner:lead")
		_box(c, f, m)
		mn = CornerJobsRow.menu(f, (m["rounds"] as Array)[-1])
	var sw: Dictionary = mn["swap"]
	print("  plan tally after round %d: %s" % [int(m["round"]), str(f["bout"].get("plan_tally", {}))])
	_check(not sw.is_empty(), "a planned line lost by round %d: the corner has a row (%s)" % [int(m["round"]), str(sw.get("lost", {}))])
	if sw.is_empty():
		_end()
		return
	var lost: Dictionary = sw["lost"]
	var opts: Array = sw["options"]
	var real := LineSwap.lost_most(_bout_exs(m))
	_check(str(real.get("move", "")) == str(lost["move"]) and str(real.get("tally", "")) == str(lost["tally"]),
		"the bout's running tally names the same line as every exchange fought (%s)" % str(lost["tally"]))

	# 1. The row on the 3D card's palette (tv), as CornerOverlay builds it.
	var sel := CornerJobsRow.defaults(mn)
	var calls := [0]
	var host := Control.new()
	root.add_child(host)
	var ui := CornerJobsRow.build(mn, sel, ["Lucy", "Priya"], func(): calls[0] = int(calls[0]) + 1, true)
	host.add_child(ui)
	_check(ui.find_child("SwapCards", true, false) != null and ui.find_child("LostMost", true, false) != null, "the PLAN row is the swap cards with the lost-most strip")
	var cards := ui.find_children("Swap_*", "Button", true, false)
	_check(cards.size() == opts.size() and cards.size() <= 2, "one card a rated option, two at most (%d)" % cards.size())
	_check(ui.find_child("KeepPlan", true, false) != null, "Keep the plan is there")
	var other := ui.find_child("PlanChange", true, false) as OptionButton
	_check(other != null and other.get_item_text(0) == "Other changes" and other.item_count == (mn["changes"] as Array).size() + 1,
		"Other changes holds today's whole list (%d)" % (other.item_count if other != null else -1))
	var strip := ui.find_child("LinesFire", true, false)
	_check(strip != null and strip.find_children("Fire_*", "", true, false).size() == 8, "the ring strip shows StrikeMap's eight places")
	var lost_i := LineSwap._plan_index(mn["arrows"], str(lost["move"]))
	var letter := char(65 + lost_i)
	var place := strip.find_child("Fire_" + str(lost["at"]), true, false) if strip != null else null
	_check(place != null and place.find_child("Pin_" + letter, true, false) != null, "the lost line's letter %s sits on its place (%s)" % [letter, str(lost["at"])])
	if opts.is_empty():
		_check(true, "no option beats the lost line here: the cards row holds Keep the plan and Other changes only")
		_end()
		return

	# 3. Hover: the place opens "C → <move>".
	var first := cards[0] as Button
	first.emit_signal("mouse_entered")
	var said := place.find_child("Said", true, false) as Label
	_check(said != null and said.visible and said.text == "%s → %s" % [letter, str(opts[0]["name"])], "hover names the swap on its place (%s)" % (said.text if said != null else "-"))
	first.emit_signal("mouse_exited")
	_check(said != null and not said.visible, "and closes it on leaving")

	# 2. One click: the same arrow the dropdown writes, and the next round plays LineSwap.apply's plan.
	var want := LineSwap.apply(mn["arrows"], opts[0], int(mn["limit"]))
	first.emit_signal("pressed")
	_check(int(calls[0]) == 1 and (sel["arrow"] as Dictionary) == {"i": int(opts[0]["i"]), "move": str(opts[0]["move"])},
		"the card's click sets the arrow (%s)" % str(sel["arrow"]))
	var suffix := CornerJobsRow.suffix(sel)
	_check(suffix.contains("|arrow=%d:%s" % [int(opts[0]["i"]), str(opts[0]["move"])]), "the corner action carries it (%s)" % suffix)
	_check(want != mn["arrows"], "LineSwap.apply changes the plan (%s)" % str(want))
	Bouts.fight_step(c, f, m, "corner:lead" + suffix)
	_check(f["bout"]["arrows"] == want and bool((LiveRound.live(m).get("arrow_change", {}) as Dictionary).get("ok", false)),
		"the next round is fought on exactly LineSwap.apply's plan (%s)" % str(f["bout"]["arrows"]))

	# 4. No planned line lost: no cards, today's dropdown.
	var f2: Dictionary = f.duplicate(true)
	f2["bout"]["plan_tally"] = {"1-2": [2, 2]}
	var mn2 := CornerJobsRow.menu(f2, (m["rounds"] as Array)[-1])
	_check((mn2["swap"] as Dictionary).is_empty(), "every planned line won: LineSwap.row is {}")
	var ui2 := CornerJobsRow.build(mn2, CornerJobsRow.defaults(mn2), ["Lucy", "Priya"], func(): pass, true)
	host.add_child(ui2)
	var ob2 := ui2.find_child("PlanChange", true, false) as OptionButton
	_check(ui2.find_child("SwapCards", true, false) == null and ob2 != null and ob2.get_item_text(0) == "Keep the plan", "no cards: today's dropdown, Keep the plan first")
	_end()


func _end() -> void:
	print("CORNER_SWAP_CARDS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _box(c: Career, f: Dictionary, m: Dictionary) -> void:
	while not LiveRound.live(m).is_empty():
		Bouts.fight_step(c, f, m, "shout:")


func _bout_exs(m: Dictionary) -> Array:
	var out: Array = []
	for r in m["rounds"]:
		out.append_array((r as Dictionary).get("exchanges", []))
	return out


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + label)
	else:
		print("  ok: " + label)
