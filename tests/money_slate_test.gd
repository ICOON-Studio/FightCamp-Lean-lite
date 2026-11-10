extends SceneTree
## S418 Club > Money on the wood and slate look. The whiteboard and the cream cards are gone: the books and the
## right-hand column are framed slates, the tags and small cards are see-through with a chalk outline, and the
## five tiles stay dark. Words in the paper inks turn chalk on the dark surface.
##   Godot_v4.7.2-stable_win64.exe --headless --audio-driver Dummy --path . --script res://tests/money_slate_test.gd

const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const SlateWalk := preload("res://tests/slate_walk.gd")

const PANELS := ["BooksPage", "CashbookPage", "InWeek", "OutWeek", "PriceTags", "FightersMoney", "ContractTalks", "CoachesPanel", "BillsPanel", "SponsorsPanel", "StaffPanel", "DuesBoard", "KitBoard", "CashChart", "PageCash", "BooksTab", "CashbookTab"]
const ACTIONS := ["Deal_ironclad", "MovePremises", "Dues_cheap", "Dues_standard", "Dues_premium", "EveningAdd", "Buy_mats", "Buy_strength", "Buy_fitkit", "Buy_youth", "Kit_low", "Kit_standard", "Kit_good", "GrantBid", "BookShow", "Repair_bags"]
const TILES := ["CASH", "MEMBERS", "MONEY LASTS", "NET A WEEK", "BILLS"]
const GHOSTS := ["FightersMoney", "ContractTalks", "BillsPanel", "DuesBoard", "KitBoard"]

var failures := 0
var main: Node


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(2)
	root.mode = Window.MODE_WINDOWED
	root.size = Vector2i(1920, 1080)
	main.act("quick")
	main.act("go", "money:0")
	await _settle(6)
	var board := main.find_child("BooksBoard", true, false) as Control
	_check(board != null, "the books draw")
	if board == null:
		_done()
		return
	var page := board.get_parent() as Node
	WoodKit.ink(page)
	await _settle(3)
	for fault in SlateWalk.faults(page):
		_check(false, str(fault))
	_names()
	_look(board)
	_edges(board)
	_done()


func _names() -> void:
	for n in PANELS:
		_check(main.find_child(n, true, false) != null, "panel " + n)
	for n in ACTIONS:
		_check(main.find_child(n, true, false) is Button, "action " + n)
	var tiles := main.find_child("MoneyTiles", true, false)
	_check(tiles != null and tiles.get_child_count() == TILES.size(), "five tiles (%d)" % (tiles.get_child_count() if tiles != null else 0))
	if tiles != null:
		for i in mini(tiles.get_child_count(), TILES.size()):
			var words := ""
			for lab in tiles.get_child(i).find_children("*", "Label", true, false):
				words += (lab as Label).text + " "
			_check(words.to_upper().find(TILES[i]) >= 0, "tile %d reads %s (%s)" % [i, TILES[i], words.strip_edges()])
	var chart := main.find_child("CashChart", true, false)
	_check(chart != null, "the chart")
	var tags := main.find_child("PriceTags", true, false)
	var ntags := tags.get_child_count() if tags != null else 0
	print("MONEY_SLATE price tags %d" % ntags)
	_check(ntags >= 6, "at least six price tags (%d)" % ntags)


func _look(board: Control) -> void:
	var side := main.find_child("BooksSide", true, false) as Control
	print("MONEY_SLATE BooksBoard skin %s" % _skin(board))
	print("MONEY_SLATE BooksSide skin %s" % _skin(side))
	_check(_framed(board), "BooksBoard is a framed slate (%s)" % _skin(board))
	_check(side != null and _framed(side), "BooksSide is a framed slate (%s)" % _skin(side))
	var tags := main.find_child("PriceTags", true, false)
	if tags != null and tags.get_child_count() > 0:
		_ghost(tags.get_child(0), "price tag")
	for n in GHOSTS:
		var card := main.find_child(n, true, false) as Control
		_ghost(card, n)
	var tiles := main.find_child("MoneyTiles", true, false)
	if tiles == null:
		return
	for i in tiles.get_child_count():
		var tile := tiles.get_child(i) as Control
		var sb := tile.get_theme_stylebox("panel")
		if not (sb is StyleBoxFlat):
			_check(false, "tile %d is a flat plate" % i)
			continue
		var flat := sb as StyleBoxFlat
		var lum := flat.bg_color.get_luminance()
		print("MONEY_SLATE tile %d lum %.2f border %d" % [i, lum, flat.border_width_left])
		_check(flat.bg_color.a >= 0.5 and lum < 0.45, "tile %d stays dark (lum %.2f)" % [i, lum])
		_check(flat.border_width_left >= 1 and flat.border_color.a > 0.2, "tile %d has a chalk outline (width %d)" % [i, flat.border_width_left])


func _edges(board: Control) -> void:
	var side := main.find_child("BooksSide", true, false) as Control
	var bottom := board.get_global_rect().end.y
	var right := board.get_global_rect().end.x
	print("MONEY_SLATE BooksBoard size %.0f x %.0f, min %.0f x %.0f" % [board.size.x, board.size.y, board.get_combined_minimum_size().x, board.get_combined_minimum_size().y])
	if side != null:
		bottom = maxf(bottom, side.get_global_rect().end.y)
		right = maxf(right, side.get_global_rect().end.x)
		print("MONEY_SLATE BooksSide size %.0f x %.0f, min %.0f x %.0f" % [side.size.x, side.size.y, side.get_combined_minimum_size().x, side.get_combined_minimum_size().y])
	print("MONEY_SLATE the books end at x %.0f, y %.0f" % [right, bottom])
	_check(bottom <= 1080.0, "the books end at or above 1080 (%.0f)" % bottom)
	_check(right <= 1920.0, "the books end at or left of 1920 (%.0f)" % right)


func _ghost(node: Node, what: String) -> void:
	if node == null:
		_check(false, what + " is missing")
		return
	var panel := node as Control
	if not (node is PanelContainer):
		panel = null
		for c in node.get_children():
			if c is PanelContainer:
				panel = c
				break
	if panel == null:
		_check(false, what + " has no plate")
		return
	var sb := panel.get_theme_stylebox("panel")
	var alpha := -1.0
	if sb is StyleBoxFlat:
		alpha = (sb as StyleBoxFlat).bg_color.a
	print("MONEY_SLATE %s fill alpha %.2f" % [what, alpha])
	_check(sb is StyleBoxFlat and alpha < 0.5, "%s is see-through (alpha %.2f)" % [what, alpha])


func _framed(panel: Control) -> bool:
	return _skin(panel).ends_with("wood/panel.png")


func _skin(panel: Control) -> String:
	if panel == null:
		return "missing"
	var sb := panel.get_theme_stylebox("panel")
	if sb is StyleBoxTexture and (sb as StyleBoxTexture).texture != null:
		return str((sb as StyleBoxTexture).texture.resource_path)
	return sb.get_class() if sb != null else "none"


func _settle(frames: int) -> void:
	for i in frames:
		await process_frame


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)


func _done() -> void:
	print("MONEY_SLATE failures=%d" % failures)
	quit(1 if failures > 0 else 0)
