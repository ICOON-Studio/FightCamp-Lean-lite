extends RefCounted
## The head of every area: big name, an optional extra, then its one row of tabs (S331: no job line - operator "remove these texts").

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")


static func add(parent: Container, main: Node, area_id: String, extra: Array = [], tabs_on: bool = true) -> void:
	var a := Data.area(area_id)
	var head := UI.hbox(16)
	var h1 := UI.display(a["name"], 52)
	head.add_child(h1)
	for e in extra:
		(e as Control).size_flags_vertical = Control.SIZE_SHRINK_CENTER
		head.add_child(e)
	parent.add_child(head)
	var tabs: Array = a["tabs"]
	if tabs.is_empty():
		return
	var row := UI.hbox(4)
	for i in tabs.size():
		var on: bool = tabs_on and int(main.route["tab"]) == i and str(main.route.get("fighter", "")) == ""
		row.add_child(UI.button(tabs[i], "TabOn" if on else "Tab", main.act.bind("tab", str(i))))
	parent.add_child(row)
	var line := ColorRect.new()
	line.color = UI.LINE
	line.custom_minimum_size = Vector2(0, 1)
	parent.add_child(line)


## "Comes in week N" placeholder card.
static func placeholder(parent: Container, title: String, text: String) -> void:
	var c := UI.card(title)
	c[1].add_child(UI.muted(text, UI.BODY, true))
	parent.add_child(c[0])
