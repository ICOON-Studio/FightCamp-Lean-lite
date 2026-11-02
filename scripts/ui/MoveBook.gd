extends VBoxContainer
## S359 a book of moves (operator: "escapes has nothing, is that intentional?", "the playbook/moves is still confusing to
## me"): moves grouped by the situation they answer, each card says in one line what it does and whether she can use it
## yet (lit, or grey with what she must learn first); a click plays it in the Playbook's player. No map, no route: the
## position graph stays on the Plans tab.
##   MoveBook.make(groups, words, mastery, on_pick) -> MoveBook   groups = [[title, line, [move ids]]], words = {id: line}
##   signal picked(id)

const UI := preload("res://scripts/ui/UI.gd")
const SM := preload("res://scripts/rules/StrikeMap.gd")

signal picked(id: String)

const CARD_W := 330.0
const CARD_H := 92.0

var _cards := {}   # id -> Button


static func make(groups: Array, words: Dictionary, mastery: Dictionary, on_pick: Callable) -> Control:
	var b := new()
	b.name = "MoveBook"
	b.add_theme_constant_override("separation", 18)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.picked.connect(on_pick)
	for g in groups:
		b._group(str(g[0]), str(g[1]), g[2], words, mastery)
	return b


func _group(title: String, line: String, ids: Array, words: Dictionary, mastery: Dictionary) -> void:
	var head := UI.vbox(2)
	head.add_child(UI.caps(title))
	head.add_child(UI.muted(line, UI.SMALL, true))
	add_child(head)
	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 10)
	flow.add_theme_constant_override("v_separation", 10)
	add_child(flow)
	for id in ids:
		var m := SM.move(str(id))
		if m.is_empty():
			continue
		var why := SM.grey_reason(m, mastery)
		var forced := str(m["kind"]) == "forced"
		var small := str(words.get(str(id), "")) + ("" if why == "" or forced else "\n" + why)
		# A forced move (the referee's break) still plays: it shows what is done to her.
		var card := UI.button2(str(m["name"]), small, "Choice", func(): select(str(id)), Vector2(CARD_W, CARD_H),
			UI.FG if why == "" or forced else UI.MUTED, UI.MUTED, false, UI.BODY, UI.SMALL)
		card.name = "Move_" + str(id).replace(" ", "_").replace("@", "_at_")
		card.tooltip_text = ""
		_cards[str(id)] = card
		flow.add_child(card)


## Plays the move and marks its card.
func select(id: String) -> void:
	for k in _cards:
		(_cards[k] as Button).theme_type_variation = "ChoiceOn" if k == id else "Choice"
	picked.emit(id)
