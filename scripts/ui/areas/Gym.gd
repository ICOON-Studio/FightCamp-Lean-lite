extends VBoxContainer
## GYM: Floor, Staff (hire a coach), Members, Facilities.

const UI := preload("res://scripts/ui/UI.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const Data := preload("res://scripts/state/Data.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Region := preload("res://scripts/state/Region.gd")


func build(main: Node) -> void:
	add_theme_constant_override("separation", 14)
	var c: Career = main.career
	AreaHead.add(self, main, "gym")
	match int(main.route["tab"]):
		0:
			var card := UI.card("THE FLOOR")
			var n := UI.note("The 3D gym lives here: members training, your fighter on the bags, the ring.\nIt comes after the menus feel right.")
			n.custom_minimum_size = Vector2(0, 140)
			card[1].add_child(n)
			add_child(card[0])
		1:
			_staff(main, c)
		2:
			_members(c)
		3:
			_facilities(main, c)


func _members(c: Career) -> void:
	var card := UI.card("MEMBERS")
	var target := Membership.natural_members(c.reputation)
	var drift := "steady" if target == c.members else ("growing toward %d" % target if target > c.members else "falling toward %d" % target)
	UI.add_rows(card[1], [
		UI.kv("On the books", str(c.members), UI.FG, "mono"),
		UI.kv("What the gym can carry now", "%d (%s)" % [target, drift], UI.FG, "mono"),
		UI.kv("Reputation", str(c.reputation), UI.FG, "mono"),
		UI.kv("Dues", "%s a month each" % UI.money(Membership.weekly_rate()), UI.FG, "mono"),
		UI.kv("Evening classes", ("3 a week, +%s" % UI.money(GameMoney.CLASSES_WITH_COACH)) if not c.coach.is_empty() else "need a coach"),
	])
	card[1].add_child(UI.muted("Reputation grows with your fighters' wins (+%d each) and a well-kept gym; the count walks toward what the gym can carry, a few a week." % BoutRules.WIN_REPUTATION, UI.SMALL, true))
	add_child(card[0])
	var why := UI.card("WHY THEY JOIN")
	var rows: Array = []
	for line in Region.why_join(c):
		rows.append(UI.label("\"%s\"" % line, UI.BODY, UI.FG, "italic", true))
	UI.add_rows(why[1], rows)
	add_child(why[0])


func _facilities(main: Node, c: Career) -> void:
	var card := UI.card("FACILITIES")
	var rows: Array = []
	for f in c.facilities:
		var right: Array = []
		if str(f["state"]) == "worn":
			right.append(UI.chip("worn", "amber"))
			var b := UI.button("Repair, %s" % UI.money(int(f["repair"])), "Btn", main.act.bind("repair", f["id"]))
			b.name = "Repair_" + str(f["id"])
			right.append(b)
		else:
			right.append(UI.chip("good", "green"))
		rows.append(UI.row(f["name"], "", Color(0, 0, 0, 0), right))
	UI.add_rows(card[1], rows)
	card[1].add_child(UI.muted("Building and placing equipment comes with the 3D gym.", UI.SMALL, true))
	add_child(card[0])


func _staff(main: Node, c: Career) -> void:
	var card := UI.card("STAFF")
	add_child(card[0])
	var rows: Array = []
	if not c.coach.is_empty():
		rows.append(UI.row("%s, %s" % [c.coach["name"], str(c.coach["kind"]).to_lower()],
			"%s, rating %d, %s a week" % [c.coach["spec"], c.coach["rating"], UI.money(int(c.coach["salary"]))], UI.GREEN))
	else:
		rows.append(UI.muted("No coach yet. Two are available.", UI.BODY))
		for coach in Data.COACHES:
			rows.append(UI.row("%s, %s" % [coach["name"], str(coach["kind"]).to_lower()],
				"%s, rating %d, %s, %s a week + %s to sign" % [coach["spec"], coach["rating"], coach["note"],
					UI.money(int(coach["salary"])), UI.money(GameMoney.COACH_SIGNING_FEE)],
				Color(0, 0, 0, 0), [UI.button("Hire", "Btn", main.act.bind("hire", coach["id"]))]))
	UI.add_rows(card[1], rows)
