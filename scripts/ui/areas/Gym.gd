extends VBoxContainer
## The gym's Staff page (hire a coach, the staff jobs, the members), Facilities, Records. S411 the Staff
## page is painted cards: what each coach is good at, and what the boxer gets from it.
## S546 (owner on the S545 build: "i do not understand whatis club and what is gym, this screen is terrible"): Staff and
## Records are windows of the office computer (Office.host), the way Fights is. No CLUB header, no tab strip of their own:
## the computer's dock is the way between them. The routes stay gym:1 and gym:4.

const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/UI.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const Tips := preload("res://scripts/ui/Tips.gd")
const TopCards := preload("res://scripts/ui/TopCards.gd")
const RecordsPage := preload("res://scripts/ui/RecordsPage.gd")
const StaffDesk := preload("res://scripts/ui/StaffDesk.gd")   # S547 STAFFCARDS1: the Staff window as cards
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const RosterCards := preload("res://scripts/ui/RosterCards.gd")
const OFFICE := preload("res://scenes/areas/Office.tscn")


func build(main: Node) -> void:
	add_theme_constant_override("separation", 12)
	var c: Career = main.career
	match int(main.route["tab"]):
		0, 1, 2:
			StaffDesk.page(_window(main, "staff"), main, c)
		3:
			AreaHead.add(self, main, "gym")
			_facilities(main, c)
		4:
			_window(main, "records").add_child(RecordsPage.build(main, c))


## The office computer with this page as its window: where the page's cards go.
func _window(main: Node, what: String) -> Container:
	add_theme_constant_override("separation", 0)
	var desk := OFFICE.instantiate()
	add_child(desk)
	return desk.host(main, what)


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
		var kit_row := UI.row(f["name"], "", Color(Palette.PAGE, 0), right)
		kit_row.name = "Kit_" + str(f["id"])
		Tips.card(kit_row, func(): return TopCards.kit(c, f))
		rows.append(kit_row)
	UI.add_rows(card[1], rows)
	add_child(card[0])
