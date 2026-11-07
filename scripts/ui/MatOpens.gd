extends RefCounted
## S396 menus to 8 (blind round 2: "Ana is missing from Fights, Rankings and Championships"): the no-gi athlete's card for
## those pages - her belt and stripes, her record in opens, the next two opens with Enter, the road to the next belt. Opens
## have no ranking table in the game; the belt is her ladder, and the card says so.
##   MatOpens.card(main, c, g, title) -> Control

const UI := preload("res://scripts/ui/UI.gd")
const Clock := preload("res://scripts/state/Clock.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")


static func card(main: Node, c: Career, g: Dictionary, title: String = "") -> Control:
	var cd := UI.card(title if title != "" else "%s, NO-GI" % str(g["name"]).to_upper())
	cd[0].name = "MatOpens_" + str(g["id"])
	var v: Container = cd[1]
	var belt := str(g.get("belt", "white"))
	var r := BeltRoad.readiness(g, g.get("bjj", {}), c.day)
	var nxt := BeltRoad.next_belt(belt)
	var head := UI.hbox(14)
	var who := UI.button("%s  %d-%d in opens" % [g["name"], int(g.get("w", 0)), int(g.get("l", 0))], "Link", main.act.bind("fighter", str(g["id"])))
	head.add_child(who)
	head.add_child(UI.chip("%s BELT, %d STRIPE%s" % [belt.to_upper(), int(g.get("stripes", 0)), "" if int(g.get("stripes", 0)) == 1 else "S"], "gold"))
	v.add_child(head)
	if nxt != "":
		v.add_child(UI.muted("The belt is her ladder: %s belt %d%% of the way (classes %d of %d, moves %d of %d)." % [nxt.capitalize(),
			int(round(float(r["share"]) * 100.0)), int(r["mat"][0]), int(r["mat"][1]), int(r["moves"][0]), int(r["moves"][1])], UI.SMALL, true))
	var entered: Array = g.get("entered", [])
	for o in NoGi.opens_after(c.day + 1, 2):
		var d := int(o["d"])
		var row := UI.hbox(12)
		var l := UI.label("%s  %s, entry %s" % [Clock.fmt(d), o["name"], UI.money(int(o["fee"]))], UI.BODY)
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(l)
		if entered.has(d):
			row.add_child(UI.label("Entered", UI.SMALL, UI.GREEN, "bold"))
		else:
			var b := UI.button("Enter %s" % g["first"], "Btn", main.act.bind("genter", "%s|%d" % [g["id"], d]),
				c.cash < int(o["fee"]), "Not enough cash for the entry")
			b.name = "Enter_%s_%d" % [g["id"], d]
			row.add_child(b)
		v.add_child(row)
	return cd[0]
