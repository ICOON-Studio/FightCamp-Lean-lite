extends RefCounted
## S490 LIVEROUNDSPLIT1: what the corner sees between exchanges (moved out of LiveRound.gd, which was over its 470-line
## limit). LiveRound keeps one-line delegates, so every caller still asks LiveRound. No preload of LiveRound (it preloads this).

const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const HabitFix := preload("res://scripts/rules/HabitFix.gd")
const CornerJobs := preload("res://scripts/rules/CornerJobs.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const PaceAim := preload("res://scripts/rules/PaceAim.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const LiveRead := preload("res://scripts/state/LiveRead.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")
const HABITS_PATH := "res://assets/data/fight_habits.json"


## Her values a call is done with: the fight stats, her footwork and her personality.
static func values(f: Dictionary) -> Dictionary:
	var v: Dictionary = (f.get("stats", {}) as Dictionary).duplicate()
	v.merge(f.get("personality", {}) as Dictionary)
	v["footwork"] = float(f.get("footwork", v.get("speed", 55.0)))
	v.merge(Attrs.of(f), true)   # S398 the attributes a call is done with (Exchanges.CALLS needs)
	return v


## What the corner sees before the next exchange: {sit, clue, offers, coach, mark, grades {call: word}, at (seconds into
## the round)}. With full film study (depth 3) the corner reads her NEXT game; without, the one she just showed. Our own
## fighter's state is always seen. coach = the best call for what the corner sees (the clue's answer); mark = the call the
## shout bar marks "coach's pick" (S310: the mark on every shout gave the answer away). Without film study there is no
## mark - the player reads the clue. With it the coach marks the answer to the game her tapes show most
## (Exchanges.favourite) or to our own fighter's state: right while she fights her usual way, wrong when she switches -
## the clue, which shows what she does now, beats following the mark blindly.
static func preview(f: Dictionary, m: Dictionary) -> Dictionary:
	var lv: Dictionary = m.get("live", {})
	if lv.is_empty():
		return {}
	var i := (lv["ex"] as Array).size()
	var opp: Dictionary = f["bout"]["opp"]
	var seen := str(lv["mode"])
	if int(f["bout"]["film"]) < BoutRules.FILM_DEPTH_WITH_STUDY and i > 0:
		seen = str((lv["ex"][i - 1] as Dictionary)["mode"])
	var sit := Exchanges.situation(seen, RingDuel.her_energy(lv, i), bool(lv["her_hurt"]))
	var names := [str(f["first"]), str(opp["first"])]
	var vals := values(f)
	var coach := str(Exchanges.MODES[sit]["best"])
	var mark := ""
	if int(f["bout"]["film"]) >= BoutRules.FILM_DEPTH_WITH_STUDY:
		var fav := Exchanges.favourite(str(opp.get("style", "")))
		mark = str(Exchanges.MODES[Exchanges.situation(fav, RingDuel.her_energy(lv, i), bool(lv["her_hurt"]))]["best"])
	var grades := {}
	for k in Exchanges.CALLS.keys():
		grades[k] = Exchanges.grade(str(k), vals)["word"]
	return {"sit": sit, "clue": Exchanges.clue(sit, names, i + int(lv["n"]) * 3), "offers": Exchanges.offers(sit),
		"coach": coach, "mark": mark, "grades": grades, "at": i * Exchanges.EX_SECONDS, "i": i,
		"shouts": int(lv["shouts"]), "names": names, "now": now_offer(lv, sit), "read": LiveRead.read_view(f, seen),
		"read_call": str(lv.get("read_call", "")),
		"pace": str(lv.get("pace", "steady")), "aim": str(lv.get("aim", "")), "aims": PaceAim.offers(PaceAim.opp_hurt(lv, str(f.get("stance", "orthodox"))))}


## S310 the set-up's NOW button: {combo, gap, line} when the corner SEES the gap it waits for (seen = with film study her
## next game, without it the one she just showed - so without film it can fire into a game she has left), else {}.
static func now_offer(lv: Dictionary, sit_seen: String) -> Dictionary:
	var su: Dictionary = lv.get("setup", {})
	if su.is_empty() or str(su.get("used", "")) != "" or not CornerJobs.fits(str(su["gap"]), sit_seen):
		return {}
	return {"combo": str(su["combo"]), "gap": str(su["gap"]), "line": "NOW! %s!" % combo_words(str(su["combo"]))}


## "Jab-Cross-Lead hook" for a combination id.
static func combo_words(id: String) -> String:
	return "-".join(PackedStringArray((Combos.row(id).get("moves", [id]) as Array).map(func(x): return str(x))))


## The habits the corner can fix before the next round: [{id, name, paid (times this round)}]. r = the closed round.
static func fixes(f: Dictionary, r: Dictionary) -> Array:
	var out: Array = []
	var paid: Dictionary = r.get("habits_paid", {})
	for h in HabitFix.offers(f.get("habits", []), f.get("notes_seen", [])):
		out.append({"id": h, "name": habit_name(h), "paid": int(paid.get(h, 0))})
	return out


static var _names := {}


## A habit's name from Kalli's bank ("Drops the right after the jab"); the id when the bank lacks it.
static func habit_name(id: String) -> String:
	if _names.is_empty() and FileAccess.file_exists(HABITS_PATH):
		var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(HABITS_PATH))
		for row in (data as Dictionary).get("habits", []) if data is Dictionary else []:
			_names[str(row.get("id", ""))] = str(row.get("name", ""))
	return str(_names.get(id, id.replace("_", " ").capitalize()))
