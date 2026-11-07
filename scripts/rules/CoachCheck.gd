extends RefCounted
## S387 (operator: "a screen ... like a checklist of what a coach needs to know about each fighter"): the coach's checklist on the
## Roster row. Eight checks, each from the rule that owns it: fitness, weight, mood, goal, next fight, camp, opponent file, game plan.
## rows(c, f) -> [{key, label, word, state, act, arg}], state "ok" | "warn" | "bad" | "off" (not due yet); act/arg open the place to
## fix it. Pure read: nothing here changes the career.

const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")

## FighterPage tab numbers the checks open.
const WB_KIT := preload("res://scripts/ui/WhiteboardKit.gd")
const BODY_TAB := "2"
const CAMP_TAB := "5"
const GOAL_TAB := "6"


static func rows(c: Career, f: Dictionary) -> Array:
	return [_fit(c, f), _weight(c, f), _mood(f), _goal(c, f), _fight(c, f), _camp(c, f), _file(f), _plan(f)]


## How many of the checks that are due are green: [ok, due].
static func score(rows_in: Array) -> Array:
	var due := rows_in.filter(func(r): return str(r["state"]) != "off")
	return [due.filter(func(r): return str(r["state"]) == "ok").size(), due.size()]


static func _row(key: String, label: String, word: String, state: String, act: String, arg: String) -> Dictionary:
	return {"key": key, "label": label, "word": word, "state": state, "act": act, "arg": arg}


static func _booked(f: Dictionary) -> bool:
	return (f.get("bout", {}) as Dictionary).has("day")


static func _fit(c: Career, f: Dictionary) -> Dictionary:
	if Injuries.out(c, f):
		return _row("fit", "Fit", Injuries.line(c, f), "bad", "ftab", BODY_TAB)
	# S396 truth pass: the whiteboard's scale (WhiteboardKit.fatigue_word: fresh under 50, ok, tired from 70, overcooked from
	# 80). The checklist used 30 and 60, so a fighter read "fresh" on her ring and "tired" here.
	var word: Array = WB_KIT.fatigue_word(FighterProfile.fatigue(f), false)
	var w := str(word[0]).to_lower()
	return _row("fit", "Fit", w, "bad" if w == "overcooked" else ("warn" if w == "tired" else "ok"), "ftab", BODY_TAB)


static func _weight(c: Career, f: Dictionary) -> Dictionary:
	var over := float(f["weight"]) - float(f["limit"])
	if _booked(f):
		var wf := Sim.weigh_forecast(c, f, int(f["bout"]["day"]))
		if bool(wf["ok"]):
			return _row("weight", "Weight", "%.1f kg on the day" % float(wf["day"]), "ok", "ftab", BODY_TAB)
		return _row("weight", "Weight", "%.1f kg over on the day" % float(wf["over"]), "bad", "ftab", BODY_TAB)
	if over <= 0.0:
		return _row("weight", "Weight", "on the limit", "ok", "ftab", BODY_TAB)
	return _row("weight", "Weight", "%.1f kg over, no bout yet" % over, "warn", "ftab", BODY_TAB)


static func _mood(f: Dictionary) -> Dictionary:
	var m := FighterProfile.mood(float(f.get("morale", FighterProfile.MORALE_START)))
	var state: String = {"Fired up": "ok", "Steady": "ok", "Flat": "warn", "Low": "bad"}.get(m, "ok")
	return _row("mood", "Mood", m.to_lower(), state, "ftab", "0")


static func _goal(c: Career, f: Dictionary) -> Dictionary:
	var g := Sim.goal_read(c, f)
	if g.is_empty():
		if bool(f.get("goal_talk", false)):
			return _row("goal", "Goal", "talk in the office", "warn", "goaltalk", str(f["id"]))
		return _row("goal", "Goal", "none set", "warn", "ftab", GOAL_TAB)
	var state: String = {"green": "ok", "amber": "warn"}.get(str(g["cls"]), "bad")
	return _row("goal", "Goal", "%s, %d days" % [str(g["status"]).to_lower(), int(g["left"])], state, "ftab", GOAL_TAB)


static func _fight(c: Career, f: Dictionary) -> Dictionary:
	if _booked(f):
		var days := int(f["bout"]["day"]) - c.day
		return _row("fight", "Next fight", "%s in %d days" % [f["bout"]["opp"]["name"], days], "ok", "go", "fights:1")
	for o in f["offers"]:
		if not bool(o["answered"]) and not bool(o["mismatch"]):
			return _row("fight", "Next fight", "offer to answer", "warn", "openBout", str(o["id"]))
	return _row("fight", "Next fight", "none booked", "warn", "go", "fights:0")


static func _camp(c: Career, f: Dictionary) -> Dictionary:
	if not _booked(f):
		return _row("camp", "Camp", "after a booking", "off", "", "")
	if Bouts.camp_due(c, f):
		return _row("camp", "Camp", "not set", "bad", "camp", str(f["id"]))
	if (f["camp"] as Dictionary).is_empty():
		return _row("camp", "Camp", "no time for one", "warn", "ftab", CAMP_TAB)
	return _row("camp", "Camp", "running", "ok", "ftab", CAMP_TAB)


static func _file(f: Dictionary) -> Dictionary:
	if not _booked(f):
		return _row("file", "Opponent file", "after a booking", "off", "", "")
	var opp: Dictionary = f["bout"]["opp"]
	var have := OppFile.found(opp).size()
	var all := have + OppFile.hidden(opp).size()
	return _row("file", "Opponent file", "%d of %d found" % [have, all], "ok" if have == all else "warn", "ftab", CAMP_TAB)


static func _plan(f: Dictionary) -> Dictionary:
	var lines := (f.get("arrows", []) as Array).size()
	if lines > 0:
		return _row("plan", "Game plan", "%d %s" % [lines, "line" if lines == 1 else "lines"], "ok", "go", "playbook:1")
	return _row("plan", "Game plan", "nothing written", "off" if not _booked(f) else "warn", "go", "playbook:1")
