extends SceneTree
## S512 ASKFIGHT1 wired (owner "Yes, build it"; map v4 s6-7 in ops/research/ASKFIGHT_CRITIC_S511_BRIEF.md):
##   1. a novice before the first bout: Ask is closed with the sheet's reason; after a bout and 10 days it opens;
##   2. the panel: two shows side by side (the soonest a fight week fits, the next one 14 days on), a step-up card with an
##      Ask button per date, the Wait line; the Fights page's free fighter card carries "Ask for a bout";
##   3. asking a step up books it through the sheet's accept path: the bout on that date, ask_kind step_up, Ask now closed;
##   4. fought: the result teaches every fight ability FightLearn's growth (x1.25 for a step up), the page's TAUGHT cell;
##   5. a ranked fighter's picked name: the host keeps the gate - club_cut 0 and the gate line;
##   6. one slot a show: a second fighter of ours sees the held night and cannot ask for it.
## godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/ask_wire_test.gd

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const AskFlow := preload("res://scripts/state/AskFlow.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const FightLearn := preload("res://scripts/rules/FightLearn.gd")
const Region := preload("res://scripts/state/Region.gd")
const ResultPage := preload("res://scripts/ui/ResultPage.gd")

var failures := 0
var main: Node


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _initialize() -> void:
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	main.career.seed = 7
	var c: Career = main.career
	c.applicant = {}
	c.fighters.clear()   # quick start may sign its own boxer: this test drives one fresh fighter
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighters[0]
	f["w"] = 0   # a novice before the first bout (Lucy's data starts 3-1)
	f["l"] = 0
	f.erase("last_bout_day")
	# 1. closed before the first bout, open after one and 10 days.
	var g := AskFlow.open(c, f)
	_check(not bool(g["open"]) and str(g["why"]).contains("first bout comes from the sheet"), "1a closed before the first bout (%s)" % g["why"])
	f["w"] = 1
	f["last_bout_day"] = c.day - 3
	g = AskFlow.open(c, f)
	_check(not bool(g["open"]) and int(g["opens_day"]) == c.day - 3 + Bouts.AFTER_FIGHT, "1b too soon after the last bout, opens on day+7 (%s, %d)" % [g["why"], int(g["opens_day"])])
	f["last_bout_day"] = c.day - Bouts.AFTER_FIGHT
	_check(bool(AskFlow.open(c, f)["open"]), "1c open 10 days after a bout")
	# 2. the panel.
	var shows := AskFlow.shows(c, f)
	_check(shows.size() == 2 and int(shows[0]["days_away"]) >= BoutRules.CAMP_MIN_DAYS
		and int(shows[1]["day"]) - int(shows[0]["day"]) == Data.SHOW_EVERY_DAYS, "2a two shows: the soonest a fight week fits, then the next (%s)" % str(shows.map(func(s): return s["days_away"])))
	var ans := AskFlow.answers(c, f)
	var step := {}
	for a in ans["cards"]:
		if str(a["kind"]) == "step_up":
			step = a
	_check(not step.is_empty() and str(step["card"]["label"]) == "Nearest better record", "2b an unranked fighter's step up is titled by what it is")
	main.nav({"area": "fights", "tab": 0})
	await process_frame
	_check(main._shell.find_child("AskFor_" + str(f["id"]), true, false) != null, "2c the Fights page's free fighter card has Ask for a bout")
	main.act("ask", str(f["id"]))
	await process_frame
	var panel: Node = main._shell
	_check(panel.find_child("AskDate0", true, false) != null and panel.find_child("AskDate1", true, false) != null, "2d the two dates side by side")
	var card: Node = panel.find_child("Ask_step_up_*", true, false)
	_check(card != null and card.find_child("AskBtn_%d" % int(shows[0]["day"]), true, false) != null
		and card.find_child("AskBtn_%d" % int(shows[1]["day"]), true, false) != null, "2e the step-up card has an Ask per date")
	_check(_has_text(panel, "Wait for the sheet"), "2f the Wait line")
	# 3. ask the step up for the far show.
	var opp_name := str(step["opp"]["name"])
	main.act("askbout", "%s|step_up|%s|%d" % [f["id"], opp_name, int(shows[1]["day"])])
	await process_frame
	var b: Dictionary = f["bout"]
	_check(int(b.get("day", -1)) == int(shows[1]["day"]) and str(b["opp"]["name"]) == opp_name and str(b.get("ask_kind", "")) == "step_up",
		"3a booked: the step up on the far show")
	_check(not bool(AskFlow.open(c, f)["open"]), "3b Ask closed while booked")
	# 4. fight it: the result teaches.
	var before := float(f["stats"]["technique"])
	var gap := float(b["opp"]["rating"]) - BoutRules.fight_power(f["stats"], {}, 0, "")
	var m := _fight(c, f)
	var won := str(m.get("outcome", "")) == "win"
	var stopped := not won and Bouts.stopped(m) != ""
	var want := maxf(0.0, FightLearn.teach_for("step_up", gap, won, stopped))
	_check(m.has("taught") and absf(float(m["taught"]["grow"]) - want) < 0.001, "4a the result's growth is FightLearn's x1.25 (%.3f vs %.3f)" % [float(m.get("taught", {}).get("grow", -1.0)), want])
	_check(absf(float(f["stats"]["technique"]) - before - want) < 0.001, "4b every fight ability grew by it (technique %.2f -> %.2f)" % [before, float(f["stats"]["technique"])])
	var foot := ResultPage.footer(main, m, f, b["opp"])
	_check(_has_text(foot, "WHAT IT TAUGHT"), "4c the result page shows WHAT IT TAUGHT")
	_check(int(m.get("club_cut", -1)) == BoutRules.TICKET_CUT, "4d a step up keeps the club's ticket cut")
	foot.free()
	# 5. a ranked fighter picks a name: the host keeps the gate.
	f["bout"] = {}
	f["w"] = 4   # on the ladder (4 wins) with names above to pick
	f["l"] = 3
	f["injury"] = {}
	f["last_bout_day"] = c.day - Bouts.AFTER_FIGHT
	var pick := {}
	for a in AskFlow.answers(c, f)["cards"]:
		if str(a["kind"]) == "name" and pick.is_empty():
			pick = a
	if pick.is_empty():
		_check(false, "5 a 4-3 on the ladder has a name to pick")
	else:
		var s2 := AskFlow.shows(c, f)
		_check(AskFlow.book(c, f, "name", str(pick["opp"]["name"]), int(s2[0]["day"])) and bool(f["bout"].get("host_gate", false)), "5a a picked name books with the host's gate")
		var m2 := _fight(c, f)
		_check(int(m2.get("club_cut", -1)) == 0 and str(m2.get("gate_line", "")).contains("host kept the gate"), "5b no ticket cut, the gate line")
	# 6. one slot a show: a second fighter of ours sees the held night.
	f["bout"] = {}
	f["last_bout_day"] = c.day - Bouts.AFTER_FIGHT
	var held := AskFlow.shows(c, f)
	AskFlow.book(c, f, "sheet", AskFlow.sheet_name(c, f), int(held[0]["day"]))
	var other := Data.fighter_state(Data.lucy(), c.day)
	other["id"] = "second"
	other["first"] = "Second"
	other["w"] = 1
	other["last_bout_day"] = c.day - Bouts.AFTER_FIGHT
	c.fighters.append(other)
	var os := AskFlow.shows(c, other)
	_check(str(os[0].get("holder", "")) == str(f["first"]) and not bool(os[0]["can_ask"]), "6 the night one of ours holds cannot be asked for")
	print("ASK_WIRE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## The bout on its night through the game's own steps (ask_probe2's loop), auto corner.
func _fight(c: Career, f: Dictionary) -> Dictionary:
	c.day = int(f["bout"]["day"])
	f["bout"]["weighed"] = true
	f["bout"]["made"] = true
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "start")
	while true:
		while not LiveRound.live(m).is_empty():
			Bouts.fight_step(c, f, m, "shout:")
		if int(m["round"]) >= Bouts.rounds_of(f) or Bouts.stopped(m) != "":
			break
		Bouts.fight_step(c, f, m, "corner:" + BoutRules.auto_corner(f["stats"]))
	Bouts.fight_step(c, f, m, "end")
	return m


func _has_text(n: Node, t: String) -> bool:
	for l in n.find_children("*", "Label", true, false):
		if (l as Label).text.contains(t):
			return true
	for b in n.find_children("*", "Button", true, false):
		if (b as Button).text.contains(t):
			return true
	return false
