extends RefCounted
## WeekReview's planned-vs-actual block (S355 CORE3 step 2), split out of WeekReview.gd in S524 (497 lines).

const UI := preload("res://scripts/ui/UI.gd")


## S355 CORE3 step 2 (WeekActual): Monday's plan against the week she ran, the reason, and the coach's one change.
## S387 only what went off plan gets a row: a week on plan says so in the heading (six rows of decimals told nothing).
static func build(fr: Dictionary, plan: Dictionary) -> VBoxContainer:
	var box := UI.vbox(4)
	box.name = "Plan_" + str(fr["id"])
	var tw := str(plan.get("twist", ""))
	var off: Array = (plan["rows"] as Array).filter(func(r): return not bool(r["ok"]))
	box.add_child(UI.caps("PLANNED VS ACTUAL: " + ("ALL %d ON PLAN" % (plan["rows"] as Array).size() if off.is_empty() else "%d OFF PLAN" % off.size())
		+ ("   (THE TWIST: %s)" % tw.to_upper() if tw != "" else "")))
	if not off.is_empty():
		var g := GridContainer.new()
		g.columns = 4
		g.add_theme_constant_override("h_separation", 28)
		for r in off:
			g.add_child(UI.label(str(r["label"]), UI.BODY, UI.FG, "bold"))
			g.add_child(UI.label("planned " + num(r, float(r["plan"])), UI.BODY, UI.MUTED, "mono"))
			g.add_child(UI.label("actual " + num(r, float(r["actual"])), UI.BODY, UI.AMBER, "mono"))
			g.add_child(UI.label("off plan", UI.SMALL, UI.AMBER, "body"))
		box.add_child(g)
	box.add_child(UI.label(str(plan["reason"]), UI.SMALL, UI.MUTED, "body", true))
	box.add_child(UI.label("Coach: \"%s\"" % str(plan["change"]), UI.SMALL, UI.GOLD, "italic", true))
	return box


static func num(r: Dictionary, x: float) -> String:
	match str(r["unit"]):
		"kg":
			return "%+.2f kg" % x
		"fatigue":
			return "%d" % int(round(x))
	return "%+.2f" % x
