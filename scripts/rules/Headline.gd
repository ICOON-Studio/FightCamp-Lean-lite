extends RefCounted
## S442 LOOP drawing 3 (owner: "All three"): the headline card between the last bell and the result page, in words.
## Built ONLY from what the bout booked (AfterFight.night_facts writes the facts into the result modal as m["night"]):
##   headline(facts) -> {title, tone, cause, milestone: {kind, words} | {}, night, rec: [ours, theirs], rank: [ours, theirs]}
## facts: first, opp_first, outcome (win|loss|draw), stopped (""|KO|RSC), pro, rounds (booked), cards, won [bool a round],
## won_n [exchanges won a round], flip (BoutRules.flip_round), per_round, against (FightWhy.read "against"), date, weight,
## rec_before / rec_after / opp_rec_before / opp_rec_after [w, l, d], rank_before / rank_after / opp_rank_before /
## opp_rank_after (Region places, 0 = unranked or not on the table).
## Milestones the game can tell today: entering the amateur rankings (unranked before, ranked after) and a first win
## (a first pro win on a pro night). Pure static; no preloads, no pronouns.

const ARROW := " → "


static func headline(f: Dictionary) -> Dictionary:
	var outcome := str(f.get("outcome", "loss"))
	return {"title": title(f), "tone": outcome, "cause": cause(f), "milestone": milestone(f), "night": night(f),
		"rec": [_moved(_rec(f.get("rec_before", [])), _rec(f.get("rec_after", []))),
			_moved(_rec(f.get("opp_rec_before", [])), _rec(f.get("opp_rec_after", [])))],
		"rank": ["", ""] if bool(f.get("pro", false)) else [_rank_line(int(f.get("rank_before", 0)), int(f.get("rank_after", 0)), true),
			_rank_line(int(f.get("opp_rank_before", 0)), int(f.get("opp_rank_after", 0)), false)]}


## "Lucy loses on a split, 2-1" / "Lucy wins by knockout in round 2" / "Lucy and Priya draw".
static func title(f: Dictionary) -> String:
	var who := str(f.get("first", ""))
	var outcome := str(f.get("outcome", "loss"))
	if outcome == "draw":
		return "%s and %s draw" % [who, str(f.get("opp_first", ""))]
	var verb := "wins" if outcome == "win" else "loses"
	var stop := str(f.get("stopped", ""))
	if stop != "":
		return "%s %s by %s in round %d" % [who, verb, "knockout" if stop == "KO" else "stoppage", (f.get("won", []) as Array).size()]
	var n := _judges(f.get("cards", []))
	var mine: int = int(n[0]) if outcome == "win" else int(n[1])
	var other: int = int(n[1]) if outcome == "win" else int(n[0])
	if other == 0 and int(n[2]) == 0:
		return "%s %s on points, %d-0" % [who, verb, mine]
	if other == 0:
		return "%s %s on a majority, %d-0" % [who, verb, mine]
	return "%s %s on a split, %d-%d" % [who, verb, mine, other]


## ONE line on why: a loss or a draw gives FightWhy's against line (its first sentence); a win names the round that
## decided it (the stoppage round, the split's flipped round, else the clearest round won). "" when the bout holds none.
static func cause(f: Dictionary) -> String:
	if str(f.get("outcome", "loss")) != "win":
		var against := str(f.get("against", "")).strip_edges()
		if against == "":
			return ""
		var first := against.get_slice(". ", 0)
		return first if first.ends_with(".") else first + "."
	var who := "your boxer"   # S448 operator: the names are in the title; the cause says the roles
	var opp := "the opponent"
	var won: Array = f.get("won", [])
	var won_n: Array = f.get("won_n", [])
	var per := int(f.get("per_round", 6))
	var stop := str(f.get("stopped", ""))
	if stop != "":
		return "Round %d decided it: %s." % [won.size(), "%s did not beat the count" % opp if stop == "KO" else "the referee stopped it"]
	var flip := int(f.get("flip", -1))
	var cards: Array = f.get("cards", [])
	if flip >= 0 and flip < won_n.size() and cards.size() >= 3 and str(cards[2]) != str(cards[0]):
		return "Round %d decided it: %s won %d of %d exchanges; judge 3 gave it to %s." % [flip + 1, who, int(won_n[flip]), per, opp]
	var best := -1
	for i in mini(won.size(), won_n.size()):
		if bool(won[i]) and (best < 0 or int(won_n[i]) >= int(won_n[best])):
			best = i
	if best < 0:
		return ""
	return "Round %d was the clearest: %s won %d of %d exchanges." % [best + 1, who, int(won_n[best]), per]


## {kind, words} when the bout did something the game can tell: entering the rankings, a first (pro) win. {} otherwise.
static func milestone(f: Dictionary) -> Dictionary:
	if str(f.get("outcome", "")) != "win":
		return {}
	var pro := bool(f.get("pro", false))
	if not pro and int(f.get("rank_before", 0)) == 0 and int(f.get("rank_after", 0)) > 0:
		return {"kind": "ranked", "words": "Enters the rankings"}
	var before: Array = f.get("rec_before", [])
	if not before.is_empty() and int(before[0]) == 0:
		return {"kind": "first_win", "words": "First pro win" if pro else "First win"}
	return {}


## "Fight night · Sat 7 Mar · Lightweight · 3 rounds" (the game holds no show or venue name).
static func night(f: Dictionary) -> String:
	var parts := PackedStringArray(["Pro night" if bool(f.get("pro", false)) else "Fight night"])
	for k in ["date", "weight"]:
		if str(f.get(k, "")) != "":
			parts.append(str(f[k]))
	parts.append("%d rounds" % int(f.get("rounds", 3)))
	return " · ".join(parts)


## [for, against, level] judges from our side.
static func _judges(cards: Array) -> Array:
	var n := [0, 0, 0]
	for c in cards:
		var p := str(c).split("-")
		if p.size() < 2:
			continue
		var i := 0 if int(p[0]) > int(p[1]) else (1 if int(p[0]) < int(p[1]) else 2)
		n[i] = int(n[i]) + 1
	return n


static func _rec(r: Array) -> String:
	if r.size() < 2:
		return ""
	var s := "%d-%d" % [int(r[0]), int(r[1])]
	return s + ("-%d" % int(r[2]) if r.size() > 2 and int(r[2]) > 0 else "")


static func _moved(a: String, b: String) -> String:
	if b == "" or a == b:
		return b if b != "" else a
	return a + ARROW + b if a != "" else b


## Ours: "Unranked", "Unranked → No. 7", "No. 4 → No. 3", "No. 4". Theirs: "" when not on the table either side.
static func _rank_line(was: int, now: int, ours: bool) -> String:
	if was == 0 and now == 0:
		return "Unranked" if ours else ""
	var a := "No. %d" % was if was > 0 else "Unranked"
	var b := "No. %d" % now if now > 0 else "Unranked"
	return a if a == b else a + ARROW + b
