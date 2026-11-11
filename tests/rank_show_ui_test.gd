extends SceneTree
## RANKSHOWUI: the rank a fight earned, on the Why panel and on the fighter's card.
## Builds the real nodes and reads them. One amateur bout goes through the result modal.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const AfterFight := preload("res://scripts/state/AfterFight.gd")
const RankLine := preload("res://scripts/rules/RankLine.gd")
const Region := preload("res://scripts/state/Region.gd")
const WhyCard := preload("res://scripts/ui/WhyCard.gd")
const FighterCard := preload("res://scripts/ui/FighterCard.gd")
const FightNight := preload("res://scripts/ui/modals/FightNight.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")

const WHY_WORDS := "Now number 3, up from 5; she passed Dana Mills."

var failures := 0
var asserts := 0


func _initialize() -> void:
	_why()
	_cards()
	_result_path()
	print("RANK_SHOW_UI asserts=%d" % asserts)
	print("RANK_SHOW_UI failures=%d" % failures)
	quit(failures)


func _why() -> void:
	var shown: Control = WhyCard.build([{"exchanges": [{"won": true}]}], "Lucy", "Maria", WHY_WORDS)
	var rank: Label = shown.find_child("WhyRank", true, false) as Label
	_check(rank != null, "rank words add a WhyRank node")
	if rank != null:
		print("CASE why: %s" % rank.text)
		_check(rank.text == WHY_WORDS, "WhyRank holds the rank words")
		var head: Label = rank.get_parent().get_child(0) as Label
		_check(head != null and head.text == "RANKING", "the row head is RANKING")
		_check(head != null and head.custom_minimum_size.x == 150.0, "the RANKING head is 150 wide")
		var plan: Label = shown.find_child("Why_plan", true, false) as Label
		_check(plan != null and rank.get_theme_font_size("font_size") == plan.get_theme_font_size("font_size"), "WhyRank uses the same size as the other rows")
		_check(plan != null and rank.get_theme_color("font_color") == plan.get_theme_color("font_color"), "WhyRank uses the same colour as the other rows")
	_check(shown.get_child_count() == 5, "title plus four rows when the rank words are set")
	var empty: Control = WhyCard.build([{"exchanges": [{"won": true}]}], "Lucy", "Maria", "")
	_check(empty.find_child("WhyRank", true, false) == null, "empty rank words leave no WhyRank node")
	var bare: Control = WhyCard.build([{"exchanges": [{"won": true}]}], "Lucy", "Maria")
	_check(bare.find_child("WhyRank", true, false) == null, "a call with no rank words leaves no WhyRank node")
	shown.free()
	empty.free()
	bare.free()


func _cards() -> void:
	var desk := Desk.new()
	root.add_child(desk)
	var plain: Array = _amateur(1, 0, 0)
	desk.career = plain[0]
	var unranked: Control = _mount(desk, plain[1])
	var urow: Label = unranked.find_child("RankRow", true, false) as Label
	var uwords: String = str(RankLine.before(AfterFight.rows(plain[0], plain[1]), str(plain[1]["name"]), Region.RANK_MIN_WINS)["words"])
	_check(urow != null, "an amateur with 1 win has a RankRow")
	if urow != null:
		print("CASE unranked: %s" % urow.text)
		print("RANK_ROW min_width unranked=%.2f" % urow.get_minimum_size().x)
		_check(urow.text == "Unranked: 3 wins from entering.", "1 win reads three wins from entering")
		_check(urow.text == uwords, "the unranked card shows RankLine.before and computes nothing itself")
		_check(urow.clip_text and urow.autowrap_mode == TextServer.AUTOWRAP_OFF, "the unranked row is one line: clip on, autowrap off")
	var third: Array = _amateur(0, 0, 0)
	_place_third(third[0], third[1])
	desk.career = third[0]
	var ranked: Control = _mount(desk, third[1])
	var rrow: Label = ranked.find_child("RankRow", true, false) as Label
	var rwords: String = str(RankLine.before(AfterFight.rows(third[0], third[1]), str(third[1]["name"]), Region.RANK_MIN_WINS)["words"])
	_check(rrow != null, "a ranked amateur has a RankRow")
	if rrow != null:
		print("CASE ranked: %s" % rrow.text)
		print("RANK_ROW min_width ranked=%.2f" % rrow.get_minimum_size().x)
		_check(rrow.text == "Number 3.", "rank 3 reads Number 3.")
		_check(rrow.text == rwords, "the ranked card shows RankLine.before and computes nothing itself")
		_check(rrow.clip_text and rrow.autowrap_mode == TextServer.AUTOWRAP_OFF, "the ranked row is one line: clip on, autowrap off")
	_check(_chip(ranked).contains("IN THE REGION"), "the gold chip is still on a ranked card (%s)" % _chip(ranked))
	var turned: Array = _amateur(8, 1, 1)
	turned[1]["pro"] = true
	desk.career = turned[0]
	var pro: Control = _mount(desk, turned[1])
	var prow: Node = pro.find_child("RankRow", true, false)
	print("CASE pro: %s" % ("none" if prow == null else (prow as Label).text))
	_check(prow == null, "a pro has no RankRow")
	desk.career = plain[0]
	var mat: Control = _mount(desk, NoGi.athlete())
	_check(mat.find_child("RankRow", true, false) == null, "a no-gi athlete has no boxing rank row")


func _result_path() -> void:
	var played: Array = _bout()
	var c: Career = played[0]
	var f: Dictionary = played[1]
	var m: Dictionary = played[2]
	_check(str(m.get("step", "")) == "result", "the bout reaches the result")
	_check(m.has("aftermath"), "the result carries the aftermath tiles")
	var desk := Desk.new()
	desk.career = c
	root.add_child(desk)
	var night := FightNight.new()
	root.add_child(night)
	night.build(desk, m)
	var why: Label = night.find_child("WhyRank", true, false) as Label
	var tile: Node = night.find_child("After_rank", true, false)
	_check(why != null, "the result modal holds WhyRank")
	_check(tile != null, "the result modal holds the rank tile")
	if why != null and tile != null:
		var small: Label = tile.find_child("Small", true, false) as Label
		var first := ""
		if small != null:
			first = small.text
		print("CASE result: %s" % why.text)
		_check(small != null and why.text == first, "WhyRank matches the rank tile's first line ('%s')" % why.text)
		var tip: PackedStringArray = tile.tooltip_text.split("\n")
		_check(tip.size() > 0 and why.text == str(tip[0]), "WhyRank matches the rank tile tooltip's first line")
		_check(why.text == str(m.get("rank_words", "")), "WhyRank is the rank words the bout booked")
		_check(why.text != "", "an amateur bout has rank words to show")


## The same amateur bout fight_why_test plays, taken through to the result.
func _bout() -> Array:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	c.day = 40
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["combos"] = {"1-1": 50.0, "1-2": 50.0}
	f["arrows"] = [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]
	f["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false,
		"film": 0, "rounds": 3}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "sim")
	return [c, f, m]


func _amateur(wins: int, losses: int, stored: int) -> Array:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	f["w"] = wins
	f["l"] = losses
	f["rank"] = stored
	f["pro"] = false
	return [c, f]


## Two rivals stay above Lucy; everyone else in the division is short of the table. Lucy is number 3.
func _place_third(c: Career, f: Dictionary) -> void:
	var above := 0
	for r in c.rivals:
		if str(r.get("div", "")) != str(f["div"]):
			continue
		if above < 2:
			r["w"] = 12 - above
			r["l"] = 0
			above += 1
		else:
			r["w"] = 0
			r["l"] = 0
	f["w"] = 5
	f["l"] = 0
	f["rank"] = 3
	f["pro"] = false


func _mount(desk: Desk, f: Dictionary) -> Control:
	var built: Array = FighterCard.build(desk, f, "Show")
	var card: Control = built[0]
	root.add_child(card)
	return card


func _chip(card: Node) -> String:
	var text := ""
	for n in card.find_children("*", "Label", true, false):
		var lab: Label = n as Label
		if lab.text.contains("IN THE REGION"):
			text = lab.text
	return text


func _check(ok: bool, label: String) -> void:
	asserts += 1
	if not ok:
		failures += 1
	print(("  ok: " if ok else "  FAIL: ") + label)


class Desk extends Node:
	var career: Career
	func act(_what: String, _arg: String = "") -> void:
		pass
