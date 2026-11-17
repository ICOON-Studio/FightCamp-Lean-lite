extends RefCounted
## S510 FIGHTFILM1 slice 1: "Watch it yourself" on the fight week's film evening (owner Q-S294-256 "Yes, build it"; map
## ops/research/FIGHTFILM1_MAP_V3_S495.md 3.1-3.6). The FIGHT ANALYSIS page (scripts/ui/FightAnalysis.gd) runs the night;
## this module gives it the opponent's films and tonight's checks, and does what a check and a filing do:
##   films(c, f) -> FilmBout films of her past bouts, newest first (ModeTells.films of her record, at most 3)
##   night(c, f) -> {checks_left, opp_checks_left, cost_words, marked}
##   check(f, claim, films_seen) -> FilmCount.check (the coach's count on the films watched so far); spends one check on her
##   file(f, claim, word, n_films) -> the filed claim {when, then, words, word, pct, tell}; a real tell (FilmPattern.matches)
##     filed on a pass opens in her file (OppFile.open), so the plan, the corner read and FilmEdge use it as before; a
##     noise claim is filed too and stays a false lead (the corner minute clears it: slice 2)
## State on the opponent: opp["film_checks_used"] (int, all nights), opp["filed"] (Array of filed claims).

const FilmBout := preload("res://scripts/rules/FilmBout.gd")
const FilmCount := preload("res://scripts/rules/FilmCount.gd")
const FilmPattern := preload("res://scripts/rules/FilmPattern.gd")
const PriorBouts := preload("res://scripts/rules/PriorBouts.gd")
const ModeTells := preload("res://scripts/rules/ModeTells.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const FilmTruth := preload("res://scripts/rules/FilmTruth.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")

const OPP_CHECK_CAP := 6   # map 7b.7: at most 6 checks an opponent across every night
## A claim's moment -> the plan situation that answers it, when its words name no habit (a weakness or noise).
const SIT_OF_WHEN := {"jab": "range", "cross": "range", "hook": "range", "combo": "tiring", "hurt": "hurt",
	"last_min": "tiring", "round1": "tiring", "after_body": "range", "walked": "range"}


static func _opp(f: Dictionary) -> Dictionary:
	return (f.get("bout", {}) as Dictionary).get("opp", {})


## Her film copy: the opponent with her ring habits listed (FilmBout reads opp["habits"]).
static func _film_opp(opp: Dictionary) -> Dictionary:
	var o := opp.duplicate()
	o["habits"] = RoundStyle.opponent_habits(opp)
	return o


static func films(c: Career, f: Dictionary) -> Array:
	var opp := _opp(f)
	var w := int(opp.get("w", 0))
	var l := int(opp.get("l", 0))
	var n := ModeTells.films(w + l)
	if n <= 0:
		return []
	var rows := PriorBouts.list(opp, w, l, c.day)
	var fo := _film_opp(opp)
	var out: Array = []
	for i in n:
		var r: Dictionary = rows[rows.size() - 1 - i]   # newest first
		var m := str(r["method"])   # PriorBouts words -> FilmBout's ("on points, 2-1" / "stopped in round 2")
		var how := m if m.begins_with("stopped") else ("on points, 2-1" if m.ends_with("split") else "on points, 3-0")
		var row := {"d": c.day - PriorBouts.GAP * (i + 1), "vs": str(r["opp"]), "vs_club": str(r["club"]),
			"win": bool(r["win"]), "how": how}
		var film: Dictionary = FilmBout.build(fo, row)
		film["row"] = row
		out.append(film)
	return out


static func night(c: Career, f: Dictionary, n_films: int) -> Dictionary:
	var opp := _opp(f)
	var used := int(opp.get("film_checks_used", 0))
	var left := FilmPattern.checks(int(float(c.coach.get("rating", 50.0))), not c.coach.is_empty(), used, n_films)
	var opp_left := maxi(0, OPP_CHECK_CAP - used)
	return {"checks_left": mini(left, opp_left), "opp_checks_left": opp_left,
		"cost_words": "Costs tonight: the evening's pads", "marked": (opp.get("filed", []) as Array).duplicate(true)}


static func check(f: Dictionary, claim: Dictionary, films_seen: Array) -> Dictionary:
	var opp := _opp(f)
	opp["film_checks_used"] = int(opp.get("film_checks_used", 0)) + 1
	return FilmCount.check(films_seen, claim)


## The figure a filing carries (map 3.4): a pass on one film 70%, on two or more 85%; a maybe 30% (one film) / 20% (pooled).
static func pct(word: String, n_films: int) -> int:
	if word == "pass":
		return roundi(100.0 * (FilmPattern.TWO_FILMS if n_films >= 2 else FilmPattern.ONE_FILM))
	if word == "maybe":
		return roundi(100.0 * (FilmPattern.MAYBE_POOLED if n_films >= 2 else FilmPattern.MAYBE_ONE))
	return 0


## Fight prep's WHAT YOUR PLAN SHOULD ANSWER (map 6): one [claim words, figure or state, state] per filed claim, strongest
## first. state "" = filed (its figure), "confirmed" / "cleared" once the corner minute has seen it (FilmTruth).
static func prep_rows(f: Dictionary) -> Array:
	return rows_of(_opp(f))


## The same rows for an opponent (her file card: rival file, bout offer, Camp, fight night).
static func rows_of(opp: Dictionary) -> Array:
	var filed: Array = (opp.get("filed", []) as Array).duplicate()
	filed.sort_custom(func(a, b): return int(a.get("pct", 0)) > int(b.get("pct", 0)))
	var out: Array = []
	for e in filed:
		var st := str(e.get("state", ""))
		var val := "CONFIRMED in the ring" if st == "confirmed" else ("CLEARED: it was not there - change this line" if st == "cleared" \
			else "%d%% sure from %d film%s - put a line on it" % [int(e.get("pct", 0)), int(e.get("films", 1)), "" if int(e.get("films", 1)) == 1 else "s"])
		out.append([str(e.get("words", "")), val, st])
	return out


## Did the claim's situation come up in this round (r = the closed round, its "exchanges")? A habit after the jab or a
## combination comes up every round; "hurt" when the opponent was hurt; "after_body" when a body shot landed; "walked"
## when your boxer walked them down (mode press); round 1 / last minute are fade checks (FilmTruth reads them at round 2).
static func came_up(when: String, r: Dictionary) -> bool:
	var exs: Array = r.get("exchanges", [])
	match when:
		"hurt":
			return exs.any(func(e): return bool(((e.get("after", {}) as Dictionary).get("hurt", [false, false]) as Array)[1]))
		"after_body":
			return exs.any(func(e): return bool(e.get("body", false)) and bool(e.get("won", false)))
		"walked":
			return exs.any(func(e): return str(e.get("mode", "")) == "press")
	return not exs.is_empty()


## The corner minute after round_no (map 6 "Corner minute", FilmTruth.check_minute): each filed claim still open whose
## situation came up is CONFIRMED (a real tell) or CLEARED (noise). Returns [{words, state}] for the corner card.
static func minute(f: Dictionary, r: Dictionary, round_no: int) -> Array:
	var out: Array = []
	for e in (_opp(f).get("filed", []) as Array):
		if str(e.get("state", "")) != "":
			continue
		var w := str(e.get("when", ""))
		var tell := {"fade": w == "round1" or w == "last_min", "sure": float(e.get("pct", 0)) / 100.0}
		var res := FilmTruth.check_minute(tell, str(e.get("tell", "")) != "", came_up(w, r), round_no)
		if res == "":
			continue
		e["state"] = "confirmed" if res == "confirmed" else "cleared"
		out.append({"words": str(e.get("words", "")), "state": e["state"]})
	return out


static func file(f: Dictionary, claim: Dictionary, word: String, n_films: int) -> Dictionary:
	var opp := _opp(f)
	var tell := FilmPattern.matches(RoundStyle.opponent_habits(opp), str(opp.get("weak", "")), claim)
	var entry := {"when": str(claim.get("when", "")), "then": str(claim.get("then", "")),
		"words": str(claim.get("words", "")), "word": word, "pct": pct(word, n_films), "tell": tell, "films": n_films}
	if not opp.has("filed"):
		opp["filed"] = []
	var filed: Array = opp["filed"]
	for i in filed.size():
		var old: Dictionary = filed[i]
		if str(old["when"]) == entry["when"] and str(old["then"]) == entry["then"]:
			filed.remove_at(i)
			break
	filed.append(entry)
	if word == "pass" and tell != "":
		OppFile.open(opp, tell)
	return entry


## S511 Playbook > Game plan (map 6, 3.5): the plan situation a filed claim rests on - the habit its words name
## (PlanLines.HABIT_SITS, real or not), else its moment (SIT_OF_WHEN).
static func sit_of(e: Dictionary) -> String:
	var t := FilmPattern.matches(FighterProfile.HABITS, "", e)
	if t.begins_with("habit:"):
		return str(PlanLines.HABIT_SITS.get(t.trim_prefix("habit:"), ""))
	return str(SIT_OF_WHEN.get(str(e.get("when", "")), ""))


## The filed claim a plan line on situation `sit` rests on: a confirmed one first, then the strongest still open, then a
## cleared one; {} when none.
static func claim_on(opp: Dictionary, sit: String) -> Dictionary:
	var best := {}
	var rank := {"confirmed": 3, "": 2, "cleared": 1}
	for e in (opp.get("filed", []) as Array):
		if sit == "" or sit_of(e) != sit:
			continue
		var r := int(rank.get(str(e.get("state", "")), 0)) * 1000 + int(e.get("pct", 0))
		if best.is_empty() or r > int(rank.get(str(best.get("state", "")), 0)) * 1000 + int(best.get("pct", 0)):
			best = e
	return best
