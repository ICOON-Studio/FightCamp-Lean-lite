extends "res://scripts/ui/FightAnalysis.gd"
## S511 FIGHTFILM1 (map ops/research/FIGHTFILM1_MAP_V3_S495.md section 6): the FIGHT ANALYSIS page on the opponent's tape,
## as the game opens it - the old Tape Room (S343, retired here: its films, its SPOT and its YOUR ANSWER live on this page).
##   film night (FightWeekActs): after File it, the button reads "Write the answer" and opens the Game plan over the page,
##     the line resting on the filed claim marked with its figure (GamePlanRows.film_tag); the night goes on under it.
##   Watch the tape (Fight prep, RosterActs "taperoom"): the films and the report, no checks and no filing, Close.
##   FightAnalysisTape.watch(main, c, f) -> the page added to main (null without films)

const FilmNight := preload("res://scripts/state/FilmNight.gd")
const PlanChart := preload("res://scripts/ui/PlanChart.gd")
const FightFlow := preload("res://scripts/rules/FightFlow.gd")

var main_ref: Node
var fighter: Dictionary = {}
var watch_only := false


## Fight prep's "Watch the tape": her films, the report and SHOW ME; filing waits for a film night in the fight week.
static func watch(main: Node, c: Career, f: Dictionary) -> Control:
	var films := FilmNight.films(c, f)
	if films.is_empty():
		return null
	var page := new()
	page.name = "FightAnalysis"
	page.main_ref = main
	page.fighter = f
	page.watch_only = true
	var opp: Dictionary = f["bout"]["opp"]
	page.for_tape(opp, films, {"checks_left": 0, "opp_checks_left": 0, "cost_words": "",
		"marked": (opp.get("filed", []) as Array).duplicate(true)}, Callable(), Callable(), Callable())
	main.add_child(page)
	return page


func _ready() -> void:
	super._ready()
	if watch_only:
		(header.find_child("Done", true, false) as Button).text = "Close"
		_pips.get_parent().visible = false
		coach_big.text = "Watching the tape: the coach checks and files on the film night of the fight week."


func _coach_idle() -> void:
	super._coach_idle()
	if watch_only:
		file_btn.text = "File it (film night)"


func _show_coach() -> void:
	super._show_coach()
	if bool(last.get("filed", false)) and main_ref != null:
		file_btn.text = "Write the answer"
		file_btn.disabled = false


func file_it() -> void:
	if bool(last.get("filed", false)) and main_ref != null:
		write_answer()
		return
	super.file_it()


## The Game plan over the page (the Playbook's chart), the line on the filed claim marked; Close goes back to the film.
func write_answer() -> Control:
	var over := PanelContainer.new()
	over.name = "WriteAnswer"
	over.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	over.add_theme_stylebox_override("panel", UI.box(Palette.PAGE, Palette.LINE, 0, 0, 24, 14))
	var v := UI.vbox(10)
	over.add_child(v)
	var top := UI.hbox(12)
	var claim: Dictionary = last.get("claim", {})
	var t := UI.label("WRITE THE ANSWER: %s" % str(claim.get("words", "")).to_upper(), 21, Palette.HEADER, "bold")
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(t)
	var close := UI.button("Back to the film", "Btn", func(): over.queue_free())
	close.name = "BackToFilm"
	top.add_child(close)
	v.add_child(top)
	var sit := FilmNight.sit_of(claim)
	if sit != "":
		v.add_child(UI.label("The answer is a line for when %s: + Add an IF, or change the line already there." % str(FightFlow.WHEN_WORDS.get(sit, sit)),
			TXT, Palette.TEXT, "semi", true))
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	var chart: Control = PlanChart.chart(main_ref, fighter, func(_id): pass)
	chart.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(chart)
	v.add_child(scroll)
	add_child(over)
	return over
