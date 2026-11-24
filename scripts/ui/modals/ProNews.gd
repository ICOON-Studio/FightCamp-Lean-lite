extends PanelContainer
## S544 (owner on turning pro v17: "i click turn pro now , i expect to see what changed , bring up the players profile show
## me what is new"): the moment after the decision. The boxer's profile is already open behind this pop-up; the pop-up is
## the same scene as the call (ProScene.art: the boxer in the signing office) and says what the decision changed as
## before -> after tiles (WhatsNew, the result page's tile). Its main button is the one next action; the quiet one
## closes onto the profile, where the things that are new carry a NEW mark (ProBars.mark) until the next page.
## modal: {type: "pronews", fid, news} - news is WhatsNew.news_pro / news_wait, read once at the click.

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const ProScene := preload("res://scripts/ui/ProScene.gd")
const WhatsNew := preload("res://scripts/ui/WhatsNew.gd")
const ResultTiles := preload("res://scripts/ui/ResultTiles.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const Pulse := preload("res://scripts/ui/Pulse.gd")


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	var c: Career = main.career
	var f: Dictionary = c.fighter_by_id(str(m["fid"]))
	var news: Dictionary = m["news"]
	var pro := str(news["kind"]) == "pro"
	custom_minimum_size = Vector2(1400, 0)
	var row := UI.hbox(22)
	add_child(row)
	row.add_child(ProScene.art(f, "SIGNED TODAY" if pro else "THE PROMOTER WAITS", Vector2(400, 560), pro))
	var v := UI.vbox(14)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(v)
	var title := UI.display("A PRO FROM TODAY" if pro else "NOT YET", 54, Palette.HEADER if pro else Palette.TEXT)
	title.name = "NewsTitle"
	v.add_child(title)
	MenuFx.slam(title)
	v.add_child(UI.label(WhatsNew.line(news), UI.BODY + 2, Palette.TEXT, "semi", true))
	var grid := GridContainer.new()
	grid.name = "WhatsNewTiles"
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 14)
	grid.add_theme_constant_override("v_separation", 14)
	v.add_child(grid)
	var tiles: Array = []
	for t in WhatsNew.tiles(news):
		var tile := ResultTiles.tile(t)
		grid.add_child(tile)
		tiles.append(tile)
	MenuFx.arrive(tiles)
	var gap := UI.spacer()
	gap.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(gap)
	var foot := UI.hbox(12)
	foot.add_child(UI.spacer())
	var see := UI.button("See the profile", "BtnQuiet", main.act.bind("close", ""))
	see.name = "NewsClose"
	see.tooltip_text = "Closes this. What is new on the profile is marked NEW."
	see.custom_minimum_size.y = 54.0
	foot.add_child(see)
	var go := UI.button("Pick the first pro fight" if pro else "Find an amateur bout", "Go", main.act.bind("go", "fights:0"))
	go.name = "NewsGo"
	go.custom_minimum_size = Vector2(320, 54)
	Pulse.breathe(go)
	foot.add_child(go)
	v.add_child(foot)
