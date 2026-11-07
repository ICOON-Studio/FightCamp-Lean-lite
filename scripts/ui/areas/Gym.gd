extends VBoxContainer
## CLUB: Staff (hire a coach), Members, Facilities, Records (S388), beside Money (AreaHead joins the two). S394 the Floor tab went, PLAYER_PATH 6.

const UI := preload("res://scripts/ui/UI.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const Data := preload("res://scripts/state/Data.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Region := preload("res://scripts/state/Region.gd")
const Tips := preload("res://scripts/ui/Tips.gd")
const TopCards := preload("res://scripts/ui/TopCards.gd")
const RecordsPage := preload("res://scripts/ui/RecordsPage.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const BjjSide := preload("res://scripts/rules/BjjSide.gd")


func build(main: Node) -> void:
	add_theme_constant_override("separation", 14)
	var c: Career = main.career
	AreaHead.add(self, main, "gym")
	match int(main.route["tab"]):
		0, 1, 2:
			# S396 screen cut: People = the staff and the members (Routes.gd).
			_staff(main, c)
			_members(c)
			# S396 blind round 2 (labels and values 1,600 px apart): the two cards side by side.
			var cols := UI.hbox(16)
			cols.name = "PeopleCols"
			var n := get_child_count()   # staff, members, then the members' "why they join" card
			var two := [get_child(n - 3), get_child(n - 2)]
			for ch in two:
				remove_child(ch)
				cols.add_child(ch)
			add_child(cols)
			move_child(cols, get_child_count() - 2)
		3:
			_facilities(main, c)
		4:
			add_child(RecordsPage.build(main, c))


func _members(c: Career) -> void:
	var card := UI.card("MEMBERS")
	var target := Membership.natural_members(c.reputation)
	# S396 blind review ("57 (growing toward 57)" read as debug): the count says where it is heading, the cap says only itself.
	var drift := "steady" if target == c.members else ("growing toward %d" % target if target > c.members else "falling toward %d" % target)
	var books := UI.kv("On the books", "%d, %s" % [c.members, drift], UI.FG, "mono")
	books.name = "Members"
	Tips.card(books, func(): return TopCards.members(c))   # S362 J90 6g
	UI.add_rows(card[1], [
		books,
		UI.kv("What the gym can carry now", str(target), UI.FG, "mono"),
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
		var kit_row := UI.row(f["name"], "", Color(0, 0, 0, 0), right)
		kit_row.name = "Kit_" + str(f["id"])
		Tips.card(kit_row, func(): return TopCards.kit(c, f))   # S362 J90 6g
		rows.append(kit_row)
	UI.add_rows(card[1], rows)
	add_child(card[0])


func _staff(main: Node, c: Career) -> void:
	var card := UI.card("STAFF")
	add_child(card[0])
	var rows: Array = []
	if not c.coach.is_empty():
		rows.append(UI.row("%s, %s" % [c.coach["name"], str(c.coach["kind"]).to_lower()],
			"%s, rating %d, %s a week" % [c.coach["spec"], c.coach["rating"], UI.money(int(c.coach["salary"]))], UI.GREEN))
	# S396 blind review: Money paid a BJJ coach Staff never named. The no-gi classes' coach is paid by the class.
	if not c.grapplers.is_empty():
		var bjj := Sim.bjj_money(c)
		rows.append(UI.row("No-gi classes' coach, by the class", "%s a class, %s a week" % [UI.money(BjjSide.COACH_CLASS), UI.money(int(bjj["coach"]))], UI.GREEN))
	if c.coach.is_empty():
		rows.append(UI.muted("No coach yet. Two are available.", UI.BODY))
		for coach in Data.COACHES:
			rows.append(UI.row("%s, %s" % [coach["name"], str(coach["kind"]).to_lower()],
				"%s, rating %d, %s, %s a week + %s to sign" % [coach["spec"], coach["rating"], coach["note"],
					UI.money(int(coach["salary"])), UI.money(GameMoney.COACH_SIGNING_FEE)],
				Color(0, 0, 0, 0), [UI.button("Hire", "Btn", main.act.bind("hire", coach["id"]))]))
	UI.add_rows(card[1], rows)
