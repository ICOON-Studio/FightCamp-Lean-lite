extends SceneTree
## S417 the wood and slate look (WoodKit): every card and wooden button comes from the kit's pieces, and words take the
## chalk inks on a dark surface and keep the paper inks on a light one.
##   Godot_v4.7.2-stable_win64.exe --headless --audio-driver Dummy --path . --script res://tests/wood_kit_test.gd

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)


func _initialize() -> void:
	_check(UI.FG == WoodKit.DARK_INK and UI.MUTED == WoodKit.PAPER_MUTED and UI.GOLD == WoodKit.PAPER_BLUE,
		"the kit's paper inks equal UI.FG, UI.MUTED and UI.GOLD")
	for piece in ["panel", "bar", "tab", "tab_on", "plank", "plank_on", "red"]:
		_check(WoodKit.tex(piece) != null, "piece %s loads" % piece)
	for name in WoodKit.PIECE:
		_check(WoodKit.tex(str(WoodKit.PIECE[name][0])) != null, "button %s has its piece" % name)
	var t := UI.theme()
	_check(t.get_stylebox("panel", "Card") is StyleBoxTexture, "a card is the framed slate")
	_check(t.get_stylebox("panel", "TopBar") is StyleBoxTexture, "the top bar is the plank")
	for name in ["Tab", "TabOn", "Btn", "BtnSolid", "Rail", "RailOn"]:
		_check(t.get_stylebox("normal", name) is StyleBoxTexture, "%s is a wooden plate" % name)
	_check(t.get_color("font_color", "Tab") == WoodKit.INK and t.get_color("font_color", "TabOn") == WoodKit.DARK_INK,
		"a dark plank takes chalk words, the light one ink")

	var page := Control.new()
	page.theme = t
	root.add_child(page)
	var card: Array = UI.card("TITLE")
	page.add_child(card[0])
	var plain := UI.label("plain")
	var soft := UI.muted("soft")
	var blue := UI.label("blue", UI.BODY, UI.GOLD)
	var red := UI.label("red", UI.BODY, UI.RED)
	for l in [plain, soft, blue, red]:
		card[1].add_child(l)
	var note := UI.note("inside a note")
	card[1].add_child(note)
	var sticky := PanelContainer.new()
	sticky.theme_type_variation = "Sticky"
	var on_sticky := UI.label("on a sticky")
	sticky.add_child(on_sticky)
	card[1].add_child(sticky)
	var chip := UI.chip("tag", "")
	card[1].add_child(chip)
	var dark_btn := UI.button("", "Choice", func(): pass)
	var in_dark := UI.label("in a dark button")
	dark_btn.add_child(in_dark)
	card[1].add_child(dark_btn)
	var light_btn := UI.button("", "TabOn", func(): pass)
	var in_light := UI.label("in a light button")
	light_btn.add_child(in_light)
	card[1].add_child(light_btn)
	var link := UI.button("link", "Link", func(): pass)
	card[1].add_child(link)
	var paper := PanelContainer.new()
	paper.add_theme_stylebox_override("panel", UI.box(UI.PANEL))
	var on_paper := UI.label("on paper")
	paper.add_child(on_paper)
	page.add_child(paper)
	var wall := UI.label("on the wall")
	page.add_child(wall)
	await process_frame

	WoodKit.ink(page)
	_check(plain.get_theme_color("font_color") == WoodKit.INK, "a plain word on a slate is chalk")
	_check(soft.get_theme_color("font_color") == WoodKit.SOFT, "a quiet word on a slate is the quiet chalk")
	_check(blue.get_theme_color("font_color") == WoodKit.BLUE, "a blue word on a slate is the light blue")
	_check(red.get_theme_color("font_color") == UI.RED, "a coloured word keeps its colour")
	_check((note.get_child(0) as Label).get_theme_color("font_color") == WoodKit.SOFT, "a note on a slate is see-through: chalk")
	_check(on_sticky.get_theme_color("font_color") == UI.FG, "a word on a sticky keeps its ink")
	# S420: since df7fe37a (S419, operator "the white in the picture doesn blend") a tag is see-through on a slate, so its
	# quiet word turns the quiet chalk like any other (it read UI.MUTED while tags were cream).
	_check((chip.get_child(0) as Label).get_theme_color("font_color") == WoodKit.SOFT, "a tag on a slate is the quiet chalk")
	_check(in_dark.get_theme_color("font_color") == WoodKit.INK, "a word laid in a dark plank is chalk")
	_check(in_light.get_theme_color("font_color") == UI.FG, "a word laid in the light plank keeps its ink")
	_check(link.get_theme_color("font_color") == WoodKit.BLUE, "a link on a slate is the light blue")
	_check(on_paper.get_theme_color("font_color") == UI.FG, "a word on a paper panel keeps its ink")
	_check(wall.get_theme_color("font_color") == UI.FG, "this pass leaves a word on the wall alone")
	_check(WoodKit.on_dark(plain) and not WoodKit.on_dark(on_sticky) and not WoodKit.on_dark(on_paper),
		"a drawn control reads the surface behind it")
	_check(WoodKit.fg(plain) == WoodKit.INK and WoodKit.fg(on_paper) == UI.FG, "and takes its ink from it")

	print("WOOD_KIT failures=%d" % failures)
	quit(1 if failures > 0 else 0)
