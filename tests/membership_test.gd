extends SceneTree
## R44 THE MEMBERSHIP, copied from E:\FightCamp\Game\Godot\tests\membership_test.gd and trimmed to the rules the lean game
## keeps (the walk, the dues, the natural count, the weekly settle). The GameState, ledger and market rows went with their code.

const Membership := preload("res://scripts/rules/Membership.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	_test_natural_count_follows_the_gym()
	_test_the_walk_is_gradual()
	_test_dues()
	_test_settle_week()
	print("MEMBERSHIP checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		print("  FAIL: %s" % label)


## Q4-Q6: the count answers to reputation, and is clamped.
func _test_natural_count_follows_the_gym() -> void:
	_check(Membership.natural_members(0) == Membership.BASE_MEMBERS, "Q4 a gym with no reputation carries the authored base")
	_check(Membership.natural_members(50) > Membership.natural_members(0), "Q5 reputation raises the count")
	_check(Membership.natural_members(100000) == Membership.MAX_MEMBERS, "Q6 the count is clamped at the authored ceiling")


## Q7-Q10c: the walk, and the freeze.
func _test_the_walk_is_gradual() -> void:
	_check(Membership.step_members(40, 40) == 40, "Q7 a count already at its target does not move")
	_check(Membership.step_members(40, 400) == 46, "Q8 growth walks a capped step, never the whole gap")
	_check(Membership.step_members(400, 40) == 394, "Q9 decline walks the same cap, in the other direction")
	_check(Membership.step_members(40, 41) == 41 and Membership.step_members(41, 40) == 40, "Q10 a one-member gap closes exactly, never past the target")
	_check(Membership.step_members(40, 400, 0.0) == 40 and Membership.step_members(400, 40, 0.0) == 400, "Q10a a zero drift fraction freezes the count in both directions")
	_check(Membership.step_members(40, 41, 0.0) == 40, "Q10b frozen means frozen - not even a one-member gap moves")
	_check(Membership.step_members(40, 400, 0.25, 0) == 40, "Q10c a zero weekly cap freezes it the same way")


## Q11: dues are the count at the authored rate ($22, S292).
func _test_dues() -> void:
	_check(Membership.weekly_rate() == 35, "Q11a the rate is the real $35 a month (S324 GymBills)")
	_check(Membership.weekly_dues(30) == 242, "Q11b 30 members pay $242 a week (30 x 35 / 4.33)")
	_check(Membership.weekly_dues(-4) == 0, "Q11c a negative count bills nothing")


## Q14-Q17: the weekly roll from the quick-start opening (30 members, reputation 10 -> target 54).
func _test_settle_week() -> void:
	var first: Dictionary = Membership.settle_week(Membership.OPENING_MEMBERS, 10)
	_check(int(first["target"]) == 54, "Q14 reputation 10 sets a target of 54")
	_check(int(first["members"]) == 36 and int(first["delta"]) == 6, "Q15 the first week walks the capped 6 (30 -> 36)")
	_check(int(first["dues"]) == Membership.weekly_dues(36), "Q16 the week bills the count after the step")
	var second: Dictionary = Membership.settle_week(int(first["members"]), 10)
	_check(int(second["members"]) == 41, "Q17 the second week closes a quarter of the 18 gap (36 -> 41)")
