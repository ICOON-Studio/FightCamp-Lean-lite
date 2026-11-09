extends VBoxContainer
## CLUB: People (hire a coach, the staff jobs, the members), Facilities, Records. S411 the People
## tab is painted cards: what each coach is good at, and what the boxer gets from it.

const UI := preload("res://scripts/ui/UI.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const Tips := preload("res://scripts/ui/Tips.gd")
const TopCards := preload("res://scripts/ui/TopCards.gd")
const RecordsPage := preload("res://scripts/ui/RecordsPage.gd")
const StaffCard := preload("res://scripts/ui/StaffCard.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const RosterCards := preload("res://scripts/ui/RosterCards.gd")


func build(main: Node) -> void:
	add_theme_constant_override("separation", 12)
	var c: Career = main.career
	match int(main.route["tab"]):
		0, 1, 2:
			MenuFx.set_wall(main, RosterCards.BACKDROP)
			StaffCard.page(self, main, c)
		3:
			AreaHead.add(self, main, "gym")
			_facilities(main, c)
		4:
			AreaHead.add(self, main, "gym")
			add_child(RecordsPage.build(main, c))


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
		Tips.card(kit_row, func(): return TopCards.kit(c, f))
		rows.append(kit_row)
	UI.add_rows(card[1], rows)
	add_child(card[0])
