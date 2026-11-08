extends SceneTree
## A still of the WarmKit pieces laid out like the approved Money page, to judge the kit in Godot before any screen moves onto it.
## Run on the hidden desktop with --resolution 1920x1080; the one argument after `--` is the PNG path.

const WarmKit := preload("res://scripts/ui/WarmKit.gd")
const UI := preload("res://scripts/ui/UI.gd")

var frames := 0


func _place(c: Control, x: float, y: float, w: float, h: float) -> void:
	c.position = Vector2(x, y)
	c.size = Vector2(w, h)
	root.add_child(c)


func _card(piece: String, title: String, body: String, ink: Color) -> PanelContainer:
	var p: PanelContainer = WarmKit.panel(piece)
	var v := VBoxContainer.new()
	v.add_child(UI.label(title, 30, ink, "marker"))
	v.add_child(UI.label(body, 19, ink, "body", true))
	p.add_child(v)
	return p


func _initialize() -> void:
	root.theme = UI.theme()
	root.add_child(WarmKit.wall())
	var board: PanelContainer = WarmKit.panel("board")
	var v := VBoxContainer.new()
	v.add_child(UI.label("The books - week 31", 52, UI.GOLD, "marker"))
	v.add_child(UI.label("Cash tin $14,820: 10 weeks of costs in hand.", 24, UI.FG, "hand"))
	board.add_child(v)
	_place(board, 200, 70, 1240, 930)
	var ink := Color("#22262e")
	for i in range(4):
		var x: float = 760.0 + float(i % 2) * 320.0
		var y: float = 250.0 + float(i / 2) * 230.0
		_place(_card("paper", ["Bigger unit", "Strength corner", "Youth section", "Evening coach"][i], "A price tag on cream paper.", ink), x, y, 300, 210)
		_place(WarmKit.magnet(30.0), x + 135.0, y - 12.0, 30, 30)
	_place(_card("chalk", "Dues", "Cheap, standard, premium.", Color("#efece2")), 760, 730, 300, 170)
	_place(_card("chalk", "Kit budget", "Low, standard, good.", Color("#efece2")), 1080, 730, 300, 170)
	var tray: TextureRect = WarmKit.tray(760.0)
	_place(tray, 460, 958, 760, 32)
	_place(_card("sticky", "Answer by Wed", "A sticky note for what needs you.", ink), 1470, 90, 420, 300)
	_place(_card("sticky", "The heavy bags", "Members notice. Repair them.", ink), 1470, 410, 420, 300)


func _process(_delta: float) -> bool:
	frames += 1
	if frames == 8:
		var img: Image = root.get_texture().get_image()
		var args := OS.get_cmdline_user_args()
		img.save_png(args[0])
		print("WARM_STILL saved ", args[0], " ", img.get_size())
		quit(0)
	return false
