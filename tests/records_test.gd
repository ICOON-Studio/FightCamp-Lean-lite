extends SceneTree
## S388 GYM > Records: only the gym's own events, tagged by who and what, with filters that work; goals show; rival news stays out.

const MAIN := preload("res://scenes/Main.tscn")
const Sim := preload("res://scripts/state/Sim.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const Records := preload("res://scripts/rules/Records.gd")
const RecordsPage := preload("res://scripts/ui/RecordsPage.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	main = MAIN.instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	var c: Career = main.career
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	Sim.hire(c, "reid")
	FirstWeek.ana_joins(c)
	c.add_news("Sam Grant stops Priya Nair at the Leicester show.", false)
	c.add_news("Lucy passed the Bronze award: a medal and a certificate on the gym wall.", false, true)
	c.add_news("Lucy Jackson beats Maria Ortega on points (3-0). 3 locals sign up.")
	c.add_news("Lucy is hurt in the ribs: a bruise.")
	c.add_news("Month-end bill paid: $1,800 for wages and upkeep.")
	c.add_news("Lucy Jackson moved up to number 5 in the London rankings.")
	c.add_news("Lucy's new goal: Next bout inside a month.")
	c.fighter()["history"] = [{"title": "next bout inside a month", "met": true, "d": c.day}, {"title": "next bout inside a month", "met": false, "d": c.day}]
	var all := Records.rows(c)
	_check(not all.any(func(r): return str(r["t"]).contains("Sam Grant")), "the world's news stays out")
	_check(_has(all, "passed the Bronze", "Honours"), "an award is an honour, though it lights no Mail")
	_check(_has(all, "beats Maria", "Fights"), "a win is a fight")
	_check(_has(all, "is hurt", "Health"), "an injury is health")
	_check(_has(all, "Month-end", "Money"), "a bill is money")
	_check(_has(all, "met the goal", "Honours"), "a goal met is an honour")
	_check(_has(all, "missed the goal", "Training"), "a goal missed is training, though its title says bout")
	_check(_has(all, "new goal", "Training"), "a new goal is training")
	_check(_has(all, "moved up", "Honours"), "a ranking move is an honour")
	_check(_has(all, "joins as", "People"), "the coach's hire is people")
	var lucy := str(c.fighter()["id"])
	_check(Records.pick(all, lucy, "").all(func(r): return (r["who"] as Array).has(lucy)), "WHO keeps the one fighter")
	_check(Records.pick(all, Records.COACH, "").size() >= 1, "the coach has a history")
	_check(Records.pick(all, "ana", "").size() >= 1, "Ana has a history")
	_check(Records.pick(all, lucy, "Health").size() == 1, "both filters together")
	_check(Records.who_of(c, "Banana bread at the gym.") == [Records.GYM], "a name inside a word is not that fighter")
	c.news.push_front({"d": c.day, "t": "Sam Grant wins the Leicester show."})
	_check(not Records.rows(c).any(func(r): return str(r["t"]).contains("wins the Leicester")), "an old save's world news stays out")
	main.act("go", "gym:4")
	await process_frame
	_check(main.find_child("RecordsList", true, false) != null, "GYM has the Records tab")
	_check(main.find_child("WhoFilter", true, false).get_child_count() == 6, "WHO lists All, Lucy, Ana, Coach and Gym")
	for b in main.find_child("WhatFilter", true, false).get_children():
		if b is Button and (b as Button).text == "Health":
			(b as Button).pressed.emit()
	await process_frame
	var list: Node = main.find_child("RecordsList", true, false)
	_check(RecordsPage.kind == "Health" and list.get_child_count() == 1, "pressing Health leaves the one injury")
	RecordsPage.kind = ""
	print("RECORDS failures=%d" % failures)
	print("PASS records_test" if failures == 0 else "FAIL records_test")
	quit(failures)


func _has(all: Array, words: String, kind: String) -> bool:
	return all.any(func(r): return str(r["t"]).contains(words) and str(r["kind"]) == kind)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
	print(("  ok: " if ok else "  FAIL: ") + label)
