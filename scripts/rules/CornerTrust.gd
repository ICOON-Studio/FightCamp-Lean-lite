extends RefCounted
## S401 CornerTrust: a wrong corner call she followed costs her trust; a Low fighter stops listening.
## Pure static functions; the only preload is FighterProfile for morale and mood. No randomness.
## A fighter who hears a bad instruction and gets hit for following it trusts the corner less next
## time; one who has stopped trusting the corner fights her own fight and ignores the shouting.

const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")


## False when her mood is Low (morale < 30): she stops taking in the corner's word.
static func lands(f: Dictionary) -> bool:
	return FighterProfile.mood(float(f.get("morale", 60.0))) != "Low"


## The corner shouted but it did not land (she is Low or the call was invalid).
static func ignored(b: Dictionary) -> void:
	b["calls_ignored"] = int(b.get("calls_ignored", 0)) + 1


## Count the round's shouted exchanges: wrong-and-lost -> calls_wrong; best-or-ok and won -> calls_right.
## Everything else counts for nothing: a right call she lost, a wrong call she won anyway, fit "none",
## and any exchange with no shout. Saying nothing is always free.
## S442 RESULTDEFECTS1: calls_said counts every shout taken in, so the result page says "worked of said" with the same
## numbers as the round lines (LiveRound.close "worked" of "calls"), never right of right + wrong.
static func tally(b: Dictionary, exs: Array) -> void:
	for x in exs:
		if not bool(x.get("shout", false)):
			continue
		b["calls_said"] = int(b.get("calls_said", 0)) + 1
		var fit: String = str(x.get("fit", "none"))
		var won: bool = bool(x.get("won", false))
		if fit == "wrong" and not won:
			b["calls_wrong"] = int(b.get("calls_wrong", 0)) + 1
		elif (fit == "best" or fit == "ok") and won:
			b["calls_right"] = int(b.get("calls_right", 0)) + 1


## Once per bout: apply morale for the calls counted. At most 3 of each kind. Her trust does not
## change inside a fight, so a bad call cannot spiral inside the same bout. It carries to the next.
## Returns {wrong, right (the first call: as counted for morale, at most 3; a later call: all), ignored, worked (every call that worked), said (every
## shout taken in), wrong_all (every call that went wrong)} - the result page shows worked of said.
static func settle(f: Dictionary, opp_name: String) -> Dictionary:
	var fb: Dictionary = f.get("bout", {})
	var seen := {"worked": int(fb.get("calls_right", 0)), "said": int(fb.get("calls_said", 0)), "wrong_all": int(fb.get("calls_wrong", 0))}
	if bool(fb.get("calls_settled", false)):
		return {"wrong": int(fb.get("calls_wrong", 0)), "right": int(fb.get("calls_right", 0)),
			"ignored": int(fb.get("calls_ignored", 0))}.merged(seen)
	fb["calls_settled"] = true
	var wrong: int = mini(int(fb.get("calls_wrong", 0)), 3)
	var right: int = mini(int(fb.get("calls_right", 0)), 3)
	for _i in wrong:
		FighterProfile.apply_morale(f, "call_wrong", "Corner calls went wrong against %s" % opp_name)
	for _i in right:
		FighterProfile.apply_morale(f, "call_right", "Corner calls worked against %s" % opp_name)
	return {"wrong": wrong, "right": right, "ignored": int(fb.get("calls_ignored", 0))}.merged(seen)
