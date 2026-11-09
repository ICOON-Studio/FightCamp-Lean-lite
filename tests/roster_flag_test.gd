extends SceneTree
## S410 the corner flag on a roster card: the most urgent answerable thing, one at a time.

const RosterFlag := preload("res://scripts/rules/RosterFlag.gd")

var failures := 0


func _row(key: String, word: String, state: String, act := "ftab", arg := "0") -> Dictionary:
	return {"key": key, "label": key, "word": word, "state": state, "act": act, "arg": arg}


func _initialize() -> void:
	var calm := [_row("fit", "fresh", "ok"), _row("weight", "on the limit", "ok"), _row("mood", "steady", "ok"),
		_row("fight", "none booked", "warn", "go", "fights:0"), _row("camp", "after a booking", "off", "", "")]
	_check(RosterFlag.pick(calm).is_empty(), "nothing wrong: no flag (a plain 'none booked' is not a flag)")
	var low := [_row("mood", "low", "bad")]
	_check(str(RosterFlag.pick(low)["word"]) == "MOOD LOW" and bool(RosterFlag.pick(low)["red"]), "low mood flags red")
	var offer := [_row("mood", "low", "bad"), _row("fight", "offer to answer", "warn", "openBout", "o7")]
	var got := RosterFlag.pick(offer)
	_check(str(got["word"]) == "OFFER" and not bool(got["red"]), "an offer outranks a low mood, and is not red")
	_check(str(got["act"]) == "openBout" and str(got["arg"]) == "o7", "the flag goes where the offer is answered")
	var camp := [_row("fight", "offer to answer", "warn"), _row("camp", "not set", "bad", "camp", "lucy")]
	_check(str(RosterFlag.pick(camp)["word"]) == "SET CAMP", "a camp that is due outranks everything")
	_check(RosterFlag.pick([_row("weight", "1.0 kg over, no bout yet", "warn")]).is_empty(), "over the limit with no bout: no flag yet")
	_check(str(RosterFlag.pick([_row("weight", "2.0 kg over on the day", "bad")])["word"]) == "WEIGHT", "over on the day: flagged")
	print("ROSTER_FLAG failures=%d" % failures)
	print("PASS roster_flag_test" if failures == 0 else "FAIL roster_flag_test")
	quit(failures)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
	print(("  ok: " if ok else "  FAIL: ") + label)
