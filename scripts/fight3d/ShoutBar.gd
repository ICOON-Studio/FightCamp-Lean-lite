extends PanelContainer
## S308: the shout bar at each 30 seconds of a 3D round. The fight slows (FightView), the clue line shows the game the corner
## reads, and the three calls that fit it + Say nothing wait SHOW_S real seconds; no pick = say nothing. The coach's pick is marked only
## with film study (LiveRound.preview "mark", S310).
##   setup(preview, round_n)   signal picked(call)   ("" = say nothing)

const UI := preload("res://scripts/ui/TV.gd")  # S333: fight graphics keep the dark TV look
const ReadPanel := preload("res://scripts/ui/ReadPanel.gd")
const CallButtons := preload("res://scripts/ui/CallButtons.gd")
const PaceAim := preload("res://scripts/rules/PaceAim.gd")

signal picked(call: String)

## S310: 10 s (was 8). With no "coach's pick" mark the clue and the three calls are read before a pick: ~22 words (clue +
## labels) at 238 words a minute (Brysbaert 2019 silent reading) ~5.5 s, a 4-way choice + the mouse ~2 s; 8 s left no slack.
const SHOW_S := 10.0

var _left := SHOW_S
var _count: Label
var _done := false
## S323 the driver mode (the body is the track): her pace and where she aims, kept from shout to shout; the pick carries
## them ("<call>|pace=..|aim=..", LiveRound.exchange).
var pace := "steady"
var aim := ""
var _drive: HBoxContainer
var _aims: Array = []
var _her := ""
const PACE_COST := {"push": "wins more exchanges, burns the tank faster", "steady": "own rhythm",
	"save": "gives exchanges away, gets the breath back"}
const PACE_LABEL := {"push": "Push", "steady": "Steady", "save": "Save"}
const AIM_LABEL := {"": "Own game", "head": "Head", "body": "Body", "left_ribs": "Left ribs", "right_ribs": "Right ribs", "head_hurt": "The hurt head"}


func setup(pv: Dictionary, round_n: int) -> void:
	name = "ShoutBar"
	add_theme_stylebox_override("panel", UI.box(Color(0.05, 0.04, 0.04, 0.9), UI.LINE, 6, 1, 18, 12))
	anchor_left = 0.0
	anchor_right = 1.0
	anchor_top = 1.0
	anchor_bottom = 1.0
	offset_left = 28
	offset_right = -28
	offset_top = -330
	offset_bottom = -16
	var v := UI.vbox(8)
	add_child(v)
	var head := UI.hbox(12)
	var left := 180 - int(pv.get("at", 30))
	var names: Array = pv.get("names", ["Your fighter", "The opponent"])
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
	# S333 THE READ: the meter on the habit the corner sees, WAIT FOR IT / TAKE IT NOW.
	if not (pv.get("read", {}) as Dictionary).is_empty():
		v.add_child(ReadPanel.build(pv["read"], str(pv.get("read_call", "")), names, _pick))
	var row := CallButtons.shout_row(pv.get("offers", []), pv.get("grades", {}), str(pv.get("mark", "")), names, _pick)
	# S310 the set-up's NOW, first in the row, when the corner sees the gap.
	var now := CallButtons.now_button(pv.get("now", {}), names, _pick)
	if now != null:
		row.add_child(now)
		row.move_child(now, 0)
	v.add_child(row)
	pace = str(pv.get("pace", "steady"))
	aim = str(pv.get("aim", ""))
	_aims = pv.get("aims", ["", "head", "body"])
	_her = str(names[0])
	_drive = UI.hbox(8)
	v.add_child(_drive)
	_draw_drive()
	_tick()


## PACE  [Push] [Steady] [Save]      AIM  [Her own game] [Head] [Body] (+ a hurt place): the chosen one gold.
func _draw_drive() -> void:
	UI.clear(_drive)
	_drive.add_child(UI.caps("PACE"))
	for p in PaceAim.PACES:
		var b := UI.button(str(PACE_LABEL[p]), "ChoiceOn" if p == pace else "Choice", _set_pace.bind(str(p)))
		b.name = "Pace_" + str(p)
		b.tooltip_text = PaceAim.pace_word(str(p))
		_drive.add_child(b)
	# S323 playtest ("PACE has no visible cost"): what the chosen pace buys and costs, in a line.
	_drive.add_child(UI.muted(str(PACE_COST[pace]), UI.SMALL))
	_drive.add_child(UI.spacer())
	_drive.add_child(UI.caps("AIM"))
	for a in _aims:
		var b := UI.button(str(AIM_LABEL.get(a, a)), "ChoiceOn" if str(a) == aim else "Choice", _set_aim.bind(str(a)))
		b.name = "Aim_" + (str(a) if str(a) != "" else "own")
		_drive.add_child(b)


func _set_pace(p: String) -> void:
	pace = p
	_draw_drive()


func _set_aim(a: String) -> void:
	aim = a
	_draw_drive()


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
	picked.emit("%s|pace=%s|aim=%s" % [call, pace, aim])
