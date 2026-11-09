extends VBoxContainer
## WORLD: News, Rankings (the ladder, the title route, a rival side by side), Championships.
## Search folded onto Rankings (Routes). The grappler's belt stays a link on Rankings.

const NameLinks := preload("res://scripts/ui/NameLinks.gd")
const MatOpens := preload("res://scripts/ui/MatOpens.gd")
const UI := preload("res://scripts/ui/UI.gd")
const Fixtures := preload("res://scripts/ui/Fixtures.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const NationalsView := preload("res://scripts/ui/NationalsView.gd")
const WorldLadder := preload("res://scripts/ui/WorldLadder.gd")
const WarmKit := preload("res://scripts/ui/WarmKit.gd")

var _main: Node


func build(main: Node) -> void:
	_main = main
	var wall := WarmKit.wall()   # as Money: the page's holder carries the plaster, behind everything
	var holder := get_parent()
	if holder != null:
		holder.add_child(wall)
		holder.move_child(wall, 0)
	add_theme_constant_override("separation", 4)
	var c: Career = main.career
	AreaHead.add(self, main, "world")
	match int(main.route["tab"]):
		0:
			_news(main, c)
		2:
			NationalsView.build(self, main, c)
		_:
			_rankings(main, c)


## The world's news, beside the one fixture list.
func _news(main: Node, c: Career) -> void:
	var card := UI.card("AROUND THE REGION")
	var rows: Array = []
	for x in c.news:
		if bool(x.get("own", true)):
			continue
		var line := UI.hbox(12)
		line.add_child(NameLinks.label(main, c, str(x["t"])))
		line.add_child(UI.muted(Clock.fmt(int(x["d"])), UI.SMALL))
		rows.append(line)
	if rows.is_empty():
		rows.append(UI.muted("Nothing from the other clubs yet.", UI.BODY))
	UI.add_rows(card[1], rows)
	var cols := UI.hbox(16)
	cols.name = "NewsCols"
	card[0].size_flags_stretch_ratio = 3.0
	cols.add_child(card[0])
	add_child(cols)
	var fix := Fixtures.card(c)
	fix[0].size_flags_stretch_ratio = 2.0
	fix[0].size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	cols.add_child(fix[0])


func _rankings(main: Node, c: Career) -> void:
	add_child(WorldLadder.build(main, c))
	for g in c.grapplers:
		add_child(MatOpens.link(main, c, g, "No-gi has no ranking table: the belt is the ladder."))
