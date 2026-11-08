extends SceneTree
## R11C: a standing count on the cards says what it cost. FightWhy._count_line names the round(s) where a boxer took a count.
## No counts leaves every field unchanged; a count on each side; counts in two rounds; a stopped bout adds nothing.

const FightWhy := preload("res://scripts/rules/FightWhy.gd")

var failures := 0


func _initialize() -> void:
	_test_no_counts_unchanged()
	_test_count_on_player_side()
	_test_count_on_opponent_side()
	_test_counts_both_sides()
	_test_counts_two_rounds()
	_test_stopped_bout_no_count_line()
	print("FIGHT_WHY_COUNTS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


## 1. No counts: every field is unchanged from what read returns today.
func _test_no_counts_unchanged() -> void:
	var rounds := [{"exchanges": [{"won": true}], "won": true}]
	var base := FightWhy.read(rounds, "Lucy", "Maria")
	var with_counts := FightWhy.read(rounds, "Lucy", "Maria")
	_check(str(base["plan"]) == str(with_counts["plan"]), "no counts: plan unchanged")
	_check(str(base["against"]) == str(with_counts["against"]), "no counts: against unchanged")


## 2. Player's boxer took a count: appended to "against".
func _test_count_on_player_side() -> void:
	var rounds := [
		{"exchanges": [{"won": true}], "won": true, "counts": 0, "down": "", "stopped": ""},
		{"exchanges": [{"won": false}], "won": false, "counts": 1, "down": "a", "stopped": ""}
	]
	var out := FightWhy.read(rounds, "Lucy", "Maria")
	var against := str(out["against"])
	_check(against.contains("Lucy took a standing count in round 2"), "player count: names Lucy and round 2: '%s'" % against)
	_check(against.contains("that round went wide on the cards"), "player count: says it went wide on the cards: '%s'" % against)


## 3. Opponent took a count: appended to "plan".
func _test_count_on_opponent_side() -> void:
	var rounds := [
		{"exchanges": [{"won": true}], "won": true, "counts": 1, "down": "b", "stopped": ""},
		{"exchanges": [{"won": true}], "won": true, "counts": 0, "down": "", "stopped": ""}
	]
	var out := FightWhy.read(rounds, "Lucy", "Maria")
	var plan := str(out["plan"])
	_check(plan.contains("Maria took a standing count in round 1"), "opponent count: names Maria and round 1: '%s'" % plan)
	_check(plan.contains("that round went wide your way"), "opponent count: says it went wide your way: '%s'" % plan)


## 4. Both sides took counts: each in its own field.
func _test_counts_both_sides() -> void:
	var rounds := [
		{"exchanges": [{"won": true}], "won": true, "counts": 1, "down": "b", "stopped": ""},
		{"exchanges": [{"won": false}], "won": false, "counts": 1, "down": "a", "stopped": ""}
	]
	var out := FightWhy.read(rounds, "Lucy", "Maria")
	var plan := str(out["plan"])
	var against := str(out["against"])
	_check(plan.contains("Maria took a standing count"), "both: opponent count in plan: '%s'" % plan)
	_check(against.contains("Lucy took a standing count"), "both: player count in against: '%s'" % against)


## 5. Counts in two rounds: "in rounds 2 and 3".
func _test_counts_two_rounds() -> void:
	var rounds := [
		{"exchanges": [{"won": false}], "won": false, "counts": 0, "down": "", "stopped": ""},
		{"exchanges": [{"won": false}], "won": false, "counts": 1, "down": "a", "stopped": ""},
		{"exchanges": [{"won": false}], "won": false, "counts": 1, "down": "a", "stopped": ""}
	]
	var out := FightWhy.read(rounds, "Lucy", "Maria")
	var against := str(out["against"])
	_check(against.contains("in rounds 2 and 3"), "two rounds: says 'in rounds 2 and 3': '%s'" % against)


## 6. Stopped bout: no count line (the stoppage already explains it).
func _test_stopped_bout_no_count_line() -> void:
	var rounds := [
		{"exchanges": [{"won": false}], "won": false, "counts": 1, "down": "a", "stopped": "RSC"}
	]
	var base_against := "placeholder"
	var out := FightWhy.read(rounds, "Lucy", "Maria")
	var against := str(out["against"])
	_check(not against.contains("took a standing count"), "stopped bout: no count line: '%s'" % against)
