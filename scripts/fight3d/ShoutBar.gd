extends PanelContainer
## S308: the shout bar at each 30 seconds of a 3D round. The fight slows (FightView), the clue line shows the game the corner
## reads, and the three calls that fit it + Say nothing wait SHOW_S real seconds; no pick = say nothing.
##   setup(preview, round_n)   signal picked(call)   ("" = say nothing)

const UI := preload("res://scripts/ui/UI.gd")
const CallButtons := preload("res://scripts/ui/CallButtons.gd")

signal picked(call: String)

const SHOW_S := 8.0

var _left := SHOW_S
var _count: Label
var _done := false


func setup(pv: Dictionary, round_n: int) -> void:
	name = "ShoutBar"
	add_theme_stylebox_override("panel", UI.box(Color(0.05, 0.04, 0.04, 0.9), UI.LINE, 6, 1, 18, 12))
	anchor_left = 0.0
	anchor_right = 1.0
	anchor_top = 1.0
	anchor_bottom = 1.0
	offset_left = 28
	offset_right = -28
	offset_top = -196
	offset_bottom = -16
	var v := UI.vbox(8)
	add_child(v)
	var head := UI.hbox(12)
	var left := 180 - int(pv.get("at", 30))
	var names: Array = pv.get("names", ["Your fighter", "Her opponent"])
	head.add_child(UI.caps("ROUND %d   %d:%02d LEFT   WHAT DO YOU SHOUT TO %s?" % [round_n, left / 60, left % 60, str(names[0]).to_upper()]))
	head.add_child(UI.spacer())
	# S309 wording: she takes in two shouts a round in full (Exchanges.FULL_SHOUTS), the rest at half.
	var shouts := int(pv.get("shouts", 0))
	head.add_child(UI.muted(shout_note(shouts, str(names[0])), UI.SMALL))
	_count = UI.mono("", UI.BODY, UI.AMBER)
	head.add_child(_count)
	v.add_child(head)
	var clue := UI.label("You see: " + str(pv.get("clue", "")), 24, UI.AMBER, "bold", true)
	clue.name = "Clue"
	v.add_child(clue)
	v.add_child(CallButtons.shout_row(pv.get("offers", []), pv.get("grades", {}), str(pv.get("coach", "")), names, _pick))
	_tick()


## How many more of your shouts she takes in fully this round.
static func shout_note(shouts: int, her: String) -> String:
	if shouts >= 2:
		return "%s has heard 2 shouts this round: she takes in only half of the next" % her
	return "%s takes in %d more shout%s this round" % [her, 2 - shouts, "" if shouts == 1 else "s"]


func _process(delta: float) -> void:
	if _done:
		return
	# Real seconds: the ring runs slowed under the bar.
	_left -= delta / maxf(0.05, Engine.time_scale)
	_tick()
	if _left <= 0.0:
		_pick("")


func _tick() -> void:
	_count.text = "%d s" % int(ceilf(maxf(0.0, _left)))


func _pick(call: String) -> void:
	if _done:
		return
	_done = true
	picked.emit(call)
