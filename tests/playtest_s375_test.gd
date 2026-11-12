extends SceneTree
## S376 the operator's S375 exe playtest findings, fixed:
##   1. the named boxers' personalities read differently (Danny's read like Lucy's: both rolled heart high, temper hot);
##   2. Ana is a row with her face on the Roster (S396 RosterTable), and it leads to her mat;
##   3. Scouting is face cards, and the scouted ranges stay on a card after the invite;
##   4. a fighter's own combination has a Drill it in PLAYBOOK > Combos (YOUR OWN), not only on the Training tab.
## (Danny's Fight camps photo is his own since S372's male bodies - tools/s376_findings_still.gd 2_camps.png.)

const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const Data := preload("res://scripts/state/Data.gd")
const Recruit := preload("res://scripts/rules/Recruit.gd")
const Playbook := preload("res://scripts/ui/areas/Playbook.gd")

var failures := 0


func _initialize() -> void:
	# 1. Every named boxer reads as a different pair of traits.
	var seen: Dictionary = {}
	for p in Data.PROSPECTS:
		var tr := Recruit.traits(p["personality"])
		var pair := "%s / %s" % [tr[0][0], tr[1][0]]
		_check(not seen.has(pair), "%s reads %s (no one else does)" % [p["first"], pair])
		seen[pair] = true
	root.size = Vector2i(1920, 1080)
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for i in 4:
		await process_frame
	main.act("quick")
	main.act("guideskip")
	main.close_modal()
	FirstWeek.ana_joins(main.career)
	main.act("interview")   # the walk-in signs Lucy (TestJump's own steps)
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	var c: Career = main.career
	var lt := Recruit.traits(c.fighters[0].get("personality", {}))
	_check(not seen.has("%s / %s" % [lt[0][0], lt[1][0]]), "Lucy's pair (%s / %s) is hers alone" % [lt[0][0], lt[1][0]])

	# 2. Ana on the Roster (S396 RosterTable): a row with her face; the row opens her page, whose Playbook is her mat.
	main.act("go", "fighters:0")
	await _frames()
	var ana: Control = main.find_child("Row_ana", true, false)
	_check(ana != null and ana.find_children("*", "TextureRect", true, false).size() > 0, "Ana is a row with her face on the Roster")
	if ana != null:   # S440 the painted row opens the athlete's page on a left click
		var click := InputEventMouseButton.new()
		click.button_index = MOUSE_BUTTON_LEFT
		click.pressed = true
		ana.gui_input.emit(click)
		await _frames()
		main.act("ftab", "7")
		await _frames()
	_check(main.find_child("MatPlayer", true, false) != null and main.find_child("MatBook", true, false) != null, "her row opens her page, and its Playbook is her mat")

	# 3. Scouting: face cards; Kira's ranges stay after the invite.
	main.act("go", "fighters:3")
	await _frames()
	var kira := main.find_child("Prospect_kira", true, false)
	_check(kira != null and kira.find_child("Face", true, false) != null, "Kira is a face card on Scouting")
	# S443 one set of numbers: the card shows the short form (Body / Boxing skills / Mind), each a scouted range
	var rng := _body_range(main)
	_check(_has_text(kira, rng), "her scouted Body range shows (%s)" % rng)
	main.act("invite", "kira")
	main.act("go", "fighters:3")
	await _frames()
	kira = main.find_child("Prospect_kira", true, false)
	_check(_has_text(kira, rng) and _has_text(kira, "trial"), "after the invite the card keeps the ranges and shows the trial")

	# 4. PLAYBOOK > Combos: an own combination has Drill it.
	var f: Dictionary = c.fighters[0]
	f["book"] = [{"name": "jab, jab, cross", "chain": ["jab", "jab", "cross"], "score": 72}]
	Playbook.pick = str(f["id"])
	main.act("go", "playbook:2")
	await _frames()
	var d := main.find_child("DrillOwn_own_1", true, false) as Button
	_check(d != null, "YOUR OWN lists Drill it beside the jab, jab, cross")
	if d != null and not d.disabled:
		d.emit_signal("pressed")
		_check(str(f.get("combo_learning", "")) == "own:1", "Drill it puts the week's pad time on it (%s)" % str(f.get("combo_learning", "")))
	print("PLAYTEST_S375 failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _frames() -> void:
	for i in 3:
		await process_frame


## Kira's Body range as the card prints it: the group read the reception reads (StatBlock on Data.fighter_state), +- the spread.
func _body_range(main: Node) -> String:
	var Data = load("res://scripts/state/Data.gd")
	var SB = load("res://scripts/rules/StatBlock.gd")
	for p in main.career.prospects:
		if str(p["id"]) == "kira":
			var mid: int = SB.shown(float(SB.groups(Data.fighter_state(p.duplicate(true), main.career.day))[0]["value"]))
			return "%d-%d" % [mid - Data.SCOUT_SPREAD, mid + Data.SCOUT_SPREAD]
	return "no kira"


func _has_text(n: Node, t: String) -> bool:
	if n == null:
		return false
	for l in n.find_children("*", "Label", true, false):
		if (l as Label).text.contains(t):
			return true
	for p in n.find_children("*", "PanelContainer", true, false):
		for l in p.find_children("*", "Label", true, false):
			if (l as Label).text.contains(t):
				return true
	return false


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS " + label)
	else:
		failures += 1
		print("FAIL " + label)
