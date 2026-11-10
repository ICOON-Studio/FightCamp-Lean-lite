extends SceneTree
## One tale of the tape (TapeRows): one order, "?" when the opponent's fact is missing, better on record, height and
## reach, and the four screens that show it ask for the same labels.

const TapeRows := preload("res://scripts/rules/TapeRows.gd")
const VersusPanel := preload("res://scripts/ui/VersusPanel.gd")
const TapeVersus := preload("res://scripts/ui/TapeVersus.gd")
const FightPrep := preload("res://scripts/ui/FightPrep.gd")
const TapeCard := preload("res://scripts/fight3d/TapeCard.gd")

var failures := 0


func _initialize() -> void:
	var f := {"name": "Lou Blake", "w": 8, "l": 1, "age": 24, "weight": 59.4, "height": 172.0, "reach": 174.0,
		"stance": "orthodox", "style": "Out-boxer", "limit": 60.0}
	var opp := {"name": "Ned Cole", "w": 3, "l": 2, "age": 27, "weight": 60.0, "height": 165.0, "reach": 166.0,
		"stance": "southpaw", "style": "Pressure fighter"}
	var rows: Array = TapeRows.rows(f, opp, 169.0)
	_check(_labels(rows) == ["Record", "Age", "Weight", "Height", "Reach", "Stance", "Style"], "order is Record, Age, Weight, Height, Reach, Stance, Style")
	var by := _by(rows)
	_check(str(by["Record"]["better"]) == "left", "the longer record is better (8-1 over 3-2)")
	_check(str(by["Height"]["better"]) == "left" and str(by["Height"]["left"]) == "172 cm", "the taller boxer is better on height")
	_check(str(by["Reach"]["better"]) == "left", "the longer reach is better")
	_check(str(by["Age"]["better"]) == "" and str(by["Weight"]["better"]) == "", "age and weight name no better side")

	var short := f.duplicate(true)
	short["w"] = 2
	short["l"] = 6
	short["height"] = 160.0
	short["reach"] = 158.0
	var tall := opp.duplicate(true)
	tall["w"] = 9
	tall["l"] = 0
	tall["height"] = 180.0
	tall["reach"] = 182.0
	var rev := _by(TapeRows.rows(short, tall, 160.0))
	_check(str(rev["Record"]["better"]) == "right" and str(rev["Height"]["better"]) == "right" and str(rev["Reach"]["better"]) == "right",
		"record, height and reach mark the right-hand boxer when that side leads")
	var even := f.duplicate(true)
	even["w"] = 4
	even["l"] = 1
	var tie := opp.duplicate(true)
	tie["w"] = 4
	tie["l"] = 1
	tie["height"] = 172.0
	tie["reach"] = 174.0
	var tied := _by(TapeRows.rows(even, tie, 172.0))
	_check(str(tied["Record"]["better"]) == "" and str(tied["Height"]["better"]) == "" and str(tied["Reach"]["better"]) == "",
		"an equal record, height and reach have no better side")
	var losses := f.duplicate(true)
	losses["w"] = 4
	losses["l"] = 3
	var cleaner := opp.duplicate(true)
	cleaner["w"] = 4
	cleaner["l"] = 1
	_check(str(_by(TapeRows.rows(losses, cleaner, 172.0))["Record"]["better"]) == "right", "same wins: fewer losses is the better record")

	var blind := opp.duplicate(true)
	blind.erase("height")
	blind.erase("weight")
	blind.erase("reach")
	blind.erase("w")
	blind.erase("l")
	var hidden: Array = TapeRows.rows(f, blind, 172.0)
	var hb := _by(hidden)
	_check(not _labels(hidden).has("Reach"), "reach is left out when the opponent's reach is unknown")
	_check(str(hb["Height"]["right"]) == "?" and str(hb["Height"]["why"]) == "not on tape" and str(hb["Height"]["better"]) == "",
		"an unknown height is ? with the reason, and no better side")
	# S420: an opponent with no weight of her own makes weight 0.2 to 0.8 kg under the limit, the same every time.
	var ow := TapeRows.opp_weight(blind, 60.0)
	_check(ow >= 59.2 and ow <= 59.8 and is_equal_approx(ow, TapeRows.opp_weight(blind, 60.0)), "her weigh-in is 0.2 to 0.8 under the limit (%.1f)" % ow)
	_check(str(hb["Weight"]["right"]) == "%.1f kg" % ow and str(hb["Weight"]["why"]) == "", "the weight row shows her weigh-in (%s)" % str(hb["Weight"]["right"]))
	var nolimit := f.duplicate(true)
	nolimit.erase("limit")
	var hn := _by(TapeRows.rows(nolimit, blind, 172.0))
	_check(str(hn["Weight"]["right"]) == "?" and str(hn["Weight"]["why"]) == "not on tape", "no weight and no limit: ? with the reason")
	_check(str(hb["Record"]["right"]) == "?" and str(hb["Record"]["why"]) == "not on tape", "an unknown record is ? with the reason")

	_same(f, opp, 169.0)
	_same(f, blind, 172.0)
	var card := TapeCard.build(TapeRows.rows(f, opp, 169.0), ["Lou Blake", "Ned Cole"])
	_check(_card_labels(card) == _labels(TapeRows.rows(f, opp, 169.0)), "the in-ring card draws the TapeRows labels in that order")
	var legacy := [["CLUB", "Anvil", "Other"], ["STYLE", "Out-boxer", "Pressure fighter"], ["AGE", "24", "27"],
		["REACH", "-", "166 cm"], ["WEIGHT", "59.4 kg", "60.0 kg"], ["RECORD", "8-1", "3-2"],
		["STANCE", "Orthodox", "Southpaw"], ["HEIGHT", "172 cm", "165 cm"]]
	var from_old := TapeCard.build(legacy, ["Lou Blake", "Ned Cole"])
	_check(_card_labels(from_old) == ["Record", "Age", "Weight", "Height", "Stance", "Style"],
		"an older pair list is relabelled into TapeRows order, without club or an unknown reach")

	print("TAPE_ROWS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _same(f: Dictionary, opp: Dictionary, cm: float) -> void:
	var want: Array = _labels(TapeRows.rows(f, opp, cm))
	var got := {
		"VersusPanel": _labels(VersusPanel.tape_rows(f, opp, cm)),
		"TapeVersus": _labels(TapeVersus.tape_rows(f, opp, cm)),
		"FightPrep": _labels(FightPrep.tape_rows(f, opp, cm)),
		"TapeCard": _labels(TapeCard.tape_rows(f, opp, cm)),
	}
	for who in got:
		_check(got[who] == want, "%s asks TapeRows for the same labels (%s)" % [who, str(got[who])])


func _labels(rows: Array) -> Array:
	var out: Array = []
	for r in rows:
		out.append(str(r["label"]))
	return out


func _by(rows: Array) -> Dictionary:
	var out := {}
	for r in rows:
		out[str(r["label"])] = r
	return out


func _card_labels(card: Control) -> Array:
	var out: Array = []
	var grid: Node = card.get_child(0).get_child(1)
	var i := 0
	for c in grid.get_children():
		if i % 3 == 1 and i >= 3 and c is Label:
			out.append((c as Label).text)
		i += 1
	return out


func _check(ok: bool, label: String) -> void:
	if ok:
		print("  ok: " + label)
	else:
		failures += 1
		print("  FAIL: " + label)
