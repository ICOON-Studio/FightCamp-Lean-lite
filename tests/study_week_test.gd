extends SceneTree
## LEARNPICK1 (S463): the "what to learn next" pick end to end - the coach's cards, a step picked into the study slot,
## the pad weeks (DrillWeek.run, the game's week) raise it, at 30 the news says so and the slot frees; a punch pick
## becomes her pad move; a full slot refuses a second step; no pad nights = no gain.

const Data := preload("res://scripts/state/Data.gd")
const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const StudyWeek := preload("res://scripts/rules/StudyWeek.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")

var failures := 0


func _initialize() -> void:
	_check_pure()
	_check_week_path()
	print("STUDY_WEEK failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _fighter() -> Dictionary:
	var f: Dictionary = Data.fighter_state(Data.lucy(), 0)
	if not f.has("steps"):
		f["steps"] = MoveTree.day0_steps(55.0)
	return f


func _check_pure() -> void:
	var f := _fighter()
	var cards: Array = StudyWeek.cards(f)
	_check(cards.size() > 0 and cards.size() <= 3, "1-3 coach cards (%d)" % cards.size())
	for c in cards:
		_check(MoveTree.state(f, str(c["id"])) == "open", "card %s is open" % c["id"])
		_check((c["reasons"] as Array).size() > 0, "card %s says why" % c["id"])
	# a step into the slot, a second refused, gain scales with pad nights, none with no pads
	var open_steps: Array = MoveTree.open_nodes(f).filter(func(id): return not MoveTree.PUNCH_IDS.has(id))
	_check(open_steps.size() >= 2, "two open steps to try (%s)" % str(open_steps))
	if open_steps.size() < 2:
		return
	_check(StudyWeek.pick(f, str(open_steps[0])), "first step picked")
	_check(not StudyWeek.pick(f, str(open_steps[1])), "second step refused: one slot")
	_check(is_equal_approx(StudyWeek.gain(f, 6), 2.0 * StudyWeek.gain(f, 3)), "6 pad nights = twice 3")
	var m0 := MoveTree.mastery(f, str(open_steps[0]))
	_check(StudyWeek.week(f, 0).is_empty() or MoveTree.mastery(f, str(open_steps[0])) == m0, "no pad nights, no gain")
	# a punch pick sets her pad move, leaves the slot alone
	var g := _fighter()
	var open_punch: Array = MoveTree.open_nodes(g).filter(func(id): return MoveTree.PUNCH_IDS.has(id))
	if not open_punch.is_empty():
		_check(StudyWeek.pick(g, str(open_punch[0])) and str(g["learning"]) == str(open_punch[0]), "punch pick = her pad move")
		_check((g.get("learning_slots", []) as Array).is_empty(), "punch pick leaves the slot empty")
	_check(not StudyWeek.pick(g, "no_such_node"), "unknown node refused")


func _check_week_path() -> void:
	var c := Career.quick_start()
	c.fighters.append(_fighter())
	var f: Dictionary = c.fighters[c.fighters.size() - 1]
	var open_steps: Array = MoveTree.open_nodes(f).filter(func(id): return not MoveTree.PUNCH_IDS.has(id))
	if open_steps.is_empty():
		_check(false, "an open step on the game path")
		return
	var id := str(open_steps[0])
	_check(StudyWeek.pick(f, id), "game path: %s picked" % id)
	var before := MoveTree.mastery(f, id)
	var weeks := 0
	var last := before
	var news_seen := false
	while weeks < 30 and (f.get("learning_slots", []) as Array).has(id):
		var n0 := c.news.size()
		var r := DrillWeek.run(c, f)
		weeks += 1
		var now := MoveTree.mastery(f, id)
		_check(now >= last, "week %d: %s does not drop (%.1f -> %.1f)" % [weeks, id, last, now])
		last = now
		_check(r.has("study"), "DrillWeek returns the study rows")
		for i in c.news.size() - n0:   # add_news pushes to the front
			if str((c.news[i] as Dictionary).get("t", "")).find(StudyWeek.name_of(id).to_lower()) >= 0:
				news_seen = true
	print("STUDY %s %.1f -> %.1f in %d weeks" % [id, before, last, weeks])
	_check(last >= 30.0, "game path: %s reaches usable (%.1f)" % [id, last])
	_check(weeks >= 2 and weeks <= 12, "game path: 2-12 weeks to usable (%d)" % weeks)
	_check(not (f.get("learning_slots", []) as Array).has(id), "slot freed at usable")
	_check(news_seen, "the gym news says it")
	_check(MoveTree.state(f, id) == "known", "%s is known after" % id)


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)
