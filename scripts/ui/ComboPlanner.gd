extends RefCounted
## S375 COMBOPLAN1 the combo planner on the fighter's Training tab (operator S375: "a planner should be in each fighters
## profile to plan his training combos (grappleflow format) 1-1 / step in / hook etc"). His own combinations (OwnCombos,
## built in PLAYBOOK > Combos - one builder, never a second one) as flows of move nodes, each with its pad mastery to the
## signature line, how often it lands whole, its gas a throw and the rounds his tank still throws it whole; Drill this week
## puts the week's pad time on it. Build a combination opens the builder for him.
##   ComboPlanner.make(main, fighter) -> PanelContainer

const UI := preload("res://scripts/ui/UI.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const ComboWords := preload("res://scripts/rules/ComboWords.gd")
const ComboBuilder := preload("res://scripts/ui/ComboBuilder.gd")
const Playbook := preload("res://scripts/ui/areas/Playbook.gd")


static func make(main: Node, f: Dictionary) -> PanelContainer:
	var parts := UI.card("COMBO PLANNER - %s'S OWN COMBINATIONS" % str(f["first"]).to_upper())
	var p: PanelContainer = parts[0]
	p.name = "ComboPlanner"
	var v: VBoxContainer = parts[1]
	var drilling := str(f.get("combo_learning", ""))
	var own := OwnCombos.entries(f)
	if own.is_empty():
		v.add_child(UI.muted("No combinations of the fighter's own yet. Build one move by move - punches, slips, steps - and drill it on the pads.", UI.BODY, true))
	for e in own:
		v.add_child(_row(main, f, e, drilling))
	if not drilling.begins_with("own:") and drilling != "":
		v.add_child(UI.muted("On the pads now: the book's %s (the coach's pick until an own combination is drilled)." % drilling, UI.SMALL, true))
	var foot := UI.hbox(8)
	var build := UI.button("Build a combination", "BtnSolid", func():
		Playbook.pick = str(f["id"])
		ComboBuilder.chain = []
		main.act("go", "playbook:2"))
	build.name = "BuildCombo"
	foot.add_child(build)
	foot.add_child(UI.muted("Drilling makes a signature (%d on the pads): it lands whole more often and, fresh, runs one punch past the hand-speed limit. Longer chains take longer to own and cost more gas a throw." % int(ComboWords.SIGNATURE_AT), UI.TINY, true))
	v.add_child(foot)
	return p


static func _row(main: Node, f: Dictionary, e: Dictionary, drilling: String) -> Control:
	var id := str(e["id"])
	var box := UI.vbox(4)
	box.name = "Own_" + id.replace(":", "_")
	var top := UI.hbox(8)
	top.add_child(UI.label(str(e["name"]).capitalize(), UI.BODY, UI.FG, "bold"))
	var need := OwnCombos.missing(f, e)
	var m := OwnCombos.mastery(f, id)
	var state := ""
	var kind := ""
	if need != "":
		state = "needs the %s" % need.to_lower()
		kind = "amber"
	elif OwnCombos.signature(f, e):
		state = "SIGNATURE"
		kind = "gold"
	elif OwnCombos.usable(f, e):
		state = "in fights"
		kind = "green"
	else:
		state = "on the pads" if drilling == id else "not drilled"
	top.add_child(UI.chip(state, kind))
	if drilling == id:
		top.add_child(UI.chip("drilling this week", "green"))
	top.add_child(UI.spacer())
	var drill := UI.button("Drilling" if drilling == id else "Drill this week", "Btn", func():
		main.act("combo", "%s|%s" % [f["id"], id])
		main.toast("%s drills the %s on the pads." % [f["first"], str(e["name"])]), drilling == id or need != "",
		"Every punch in it must be a weapon first (%d on the pads)." % int(Combos.LEARN_AT) if need != "" else "")
	drill.name = "Drill_" + id.replace(":", "_")
	top.add_child(drill)
	top.add_child(UI.button("Edit", "Btn", func():
		Playbook.pick = str(f["id"])
		ComboBuilder.chain = (e["chain"] as Array).duplicate()
		main.act("go", "playbook:2")))
	box.add_child(top)
	box.add_child(_flow(e["chain"]))
	var bar := UI.stat_row("Pad mastery - signature at %d" % int(ComboWords.SIGNATURE_AT), m, m >= Combos.LEARN_AT, UI.FG,
		"  " + ("signature" if m >= ComboWords.SIGNATURE_AT else ("usable" if m >= Combos.LEARN_AT else "learning")))
	(bar.get_meta("bar") as Control).set("frac", m / 100.0)
	box.add_child(bar)
	var facts := UI.hbox(10)
	facts.add_child(UI.label("Lands whole %d%%" % roundi(100.0 * OwnCombos.lands_whole(f, e)) if OwnCombos.usable(f, e) else "Not in fights yet",
		UI.SMALL, UI.FG if OwnCombos.usable(f, e) else UI.MUTED, "semi"))
	facts.add_child(UI.label("%.1f gas a throw" % OwnCombos.gas(f, e), UI.SMALL, UI.FG, "semi"))
	facts.add_child(UI.muted("Thrown whole in:", UI.SMALL))
	var rounds := OwnCombos.whole_by_round(f, e)
	for r in rounds.size():
		var c := UI.chip("R%d" % (r + 1), "green" if bool(rounds[r]) else "red")
		c.tooltip_text = "Round %d: %s" % [r + 1, "the tank still throws it whole mid-round" if bool(rounds[r]) else "too tired, or too long for the hand speed: it comes out shorter"]
		facts.add_child(c)
	box.add_child(facts)
	box.add_child(UI.sep())
	return box


## The chain as a flow of nodes, GrappleFlow style: Jab -> Jab -> Step in -> Lead hook (punches gold, the rest muted).
static func _flow(chain: Array) -> Control:
	var h := HFlowContainer.new()
	h.add_theme_constant_override("h_separation", 6)
	for i in chain.size():
		var mv := str(chain[i])
		var name := str(ComboBuilder.entry(mv).get("name", mv))
		var punch := OwnCombos.PUNCH_OF.has(mv)
		var node := PanelContainer.new()
		node.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.GOLD if punch else UI.LINE, 8, 2 if punch else 1, 10, 4))
		node.add_child(UI.label(name, UI.SMALL, UI.FG if punch else UI.MUTED, "bold" if punch else "body"))
		h.add_child(node)
		if i < chain.size() - 1:
			h.add_child(UI.label("->", UI.SMALL, UI.MUTED, "bold"))
	return h
