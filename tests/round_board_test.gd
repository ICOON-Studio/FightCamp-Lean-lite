extends SceneTree
## S427 the live round board on the corner bar (scripts/fight3d/RoundBoard.gd): its three reads of the round's exchanges.

const RoundBoard := preload("res://scripts/fight3d/RoundBoard.gd")

var failures := 0


func _initialize() -> void:
	var ex := [
		{"sit": "press", "call": "long", "won": true, "landed": [3, 1], "body": [1, 0]},
		{"sit": "press", "call": "", "won": false, "landed": [1, 2], "body": [0, 1]},
		{"sit": "loadup", "call": "long", "won": false, "landed": [0, 3], "body": [0, 0]},
		{"sit": "press", "call": "hands", "won": true, "landed": [2, 0], "body": [1, 0]},
	]
	var t := RoundBoard.tally(ex)
	_check(t["landed"] == [6, 6], "landed adds both sides %s" % [t["landed"]])
	_check(t["body"] == [2, 1], "body shots add both sides %s" % [t["body"]])
	var g := RoundBoard.games(ex)
	_check(g.size() == 2 and str(g[0]["sit"]) == "press" and int(g[0]["n"]) == 3, "her most shown game is first %s" % [g])
	var c := RoundBoard.calls(ex)
	_check(c.size() == 2 and str(c[0]["call"]) == "hands", "the latest call is first, said-nothing is left out %s" % [c])
	_check(c[1]["wins"] == [true, false], "a call's uses run oldest to newest %s" % [c[1]["wins"]])
	_check(RoundBoard.tally([])["landed"] == [0, 0] and RoundBoard.calls([]).is_empty(), "an empty round reads as zeros")
	var board := RoundBoard.build(ex, "loadup", ["Lucy", "Maria"], 738.0, 150.0)
	root.add_child(board)
	var mine := board.find_child("LandedMine", true, false) as Label
	_check(mine != null and mine.text == "6", "the board shows her punches landed")
	_check(board.find_child("GameNow", true, false) == null, "the now column is gone (the chip and the panel say it)")
	_check(board.find_child("Used_hands", true, false) != null and board.find_child("LandedMine", true, false) != null,
		"the landed column and the calls column keep the width")
	for n in board.find_children("*", "Label", true, false):
		var l := n as Label
		_check(l.get_theme_font_size("font_size") >= 20, "no text under 20 px (%s)" % l.text)
		_check(l.position.x + l.size.x <= 738.0 + 0.5 and l.position.y + l.size.y <= 150.0 + 0.5 or l.get_parent() != board,
			"'%s' stays inside the board" % l.text)
	var empty := RoundBoard.build([], "", ["Lucy", "Maria"], 738.0, 150.0)
	root.add_child(empty)
	_check(empty.find_child("NoCalls", true, false) != null, "before any call it says so")
	print("ROUND_BOARD failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
