extends RefCounted
## SCORESHEET1 the official scorecard sheet as data (pure rule module). One static function: build(j, meta) -> Dictionary.
## j = Judges.cards() output. meta = bout metadata (date, venue, corners, stoppage...). Returns {header, judges[3], result}.
## RED is the red corner whoever it is: when a_corner == "blue", the player's scores go in the BLUE column.
## No preloads, no names in result words (S448: names only in headers).

## Fictional judge names: UK club boxing flavour, mixed sexes, no real officials. 24 first x 24 last = 576 combos.
const FIRST := ["Albert", "Brenda", "Colin", "Deirdre", "Eamon", "Fiona", "Gerald", "Hazel", "Ivor", "Jackie",
	"Kevin", "Lena", "Malachy", "Nora", "Owen", "Pauline", "Quinn", "Rita", "Seamus", "Teresa", "Ulric", "Vera",
	"Walter", "Yvonne"]
const LAST := ["Brogan", "Callahan", "Donnelly", "Fitzpatrick", "Gallagher", "Harrington", "Kavanagh", "Lavelle",
	"Maloney", "O'Sullivan", "Quinn", "Rafferty", "Shannon", "Tierney", "Walsh", "Brennan", "Campbell", "Doherty",
	"Flynn", "Higgins", "Keane", "Lynch", "Murray", "Reilly"]


## S503: today's cards as the sheet's input. The judges' own model (Judges.cards) decides nothing until JudgeNight.DECIDES
## (held since S443 on a taste call, docs/JUDGES1_RESULT.md); the verdict comes from BoutRules.cards_of: every round 10-9
## to its winner on all three cards, the third judge scoring round `flip` (BoutRules.flip_round, -1 = none) the other way.
## This builds the Judges.cards() shape from those rounds, so the sheet always agrees with the announced result.
## rounds: [{won: bool (the player's boxer won it)}, ...] -> {cards, by_round, verdict, winner}; [] -> {}.
static func from_rounds(rounds: Array, flip: int) -> Dictionary:
	if rounds.is_empty():
		return {}
	var by_round: Array = []
	var cards := [[0, 0], [0, 0], [0, 0]]
	for ri in rounds.size():
		var won := bool((rounds[ri] as Dictionary).get("won", false))
		var row: Array = []
		for ji in 3:
			var a_wins := won if not (ji == 2 and ri == flip) else not won
			var sc := {"a": 10 if a_wins else 9, "b": 9 if a_wins else 10, "reason": "", "part": ""}
			row.append(sc)
			cards[ji][0] += int(sc["a"])
			cards[ji][1] += int(sc["b"])
		by_round.append(row)
	var a_n := 0
	var b_n := 0
	for c in cards:
		if int(c[0]) > int(c[1]):
			a_n += 1
		elif int(c[1]) > int(c[0]):
			b_n += 1
	var level := 3 - a_n - b_n
	var winner := ""
	var verdict := "draw"
	if a_n >= 2 or b_n >= 2:
		winner = "a" if a_n >= 2 else "b"
		var w_n: int = maxi(a_n, b_n)
		verdict = "unanimous" if w_n == 3 else ("majority" if level == 1 else "split")
	return {"cards": cards, "by_round": by_round, "running": [], "verdict": verdict, "winner": winner}


## The sheet: header, three judge rows, result. Empty {} when j is malformed (no by_round).
static func build(j: Dictionary, meta: Dictionary) -> Dictionary:
	var by_round: Array = j.get("by_round", [])
	if by_round.is_empty():
		return {}
	var cards_arr: Array = j.get("cards", [])
	if cards_arr.is_empty():
		return {}
	var a_corner: String = str(meta.get("a_corner", "red"))
	var stopped: bool = bool(meta.get("stopped", false))
	var stop_round: int = int(meta.get("stop_round", 0))
	var stop_time: String = str(meta.get("stop_time", ""))
	var stop_winner: String = str(meta.get("stop_winner", ""))
	var rounds_scheduled: int = int(meta.get("rounds_scheduled", by_round.size()))
	var deductions: Array = meta.get("deductions", [])
	var judge_seed: int = int(meta.get("judge_seed", 0))
	var leans: Array = meta.get("leans", [])
	var names := _judge_names(judge_seed)
	var header := {
		"date": str(meta.get("date", "")),
		"venue": str(meta.get("venue", "")),
		"weight_class": str(meta.get("weight_class", "")),
		"referee": str(meta.get("referee", "")),
		"bout_no": int(meta.get("bout_no", 0)),
		"rounds_scheduled": rounds_scheduled,
	}
	var judges: Array = []
	for ji in 3:
		var card_total: Array = cards_arr[ji] if ji < cards_arr.size() else [0, 0]
		var card_a: int = int(card_total[0])
		var card_b: int = int(card_total[1])
		var lean_word := str(leans[ji]) if ji < leans.size() else ""
		var rows: Array = []
		var sum_red := 0
		var sum_blue := 0
		var round_count := by_round.size()
		if stopped and stop_round > 0 and stop_round < round_count:
			round_count = stop_round
		for ri in round_count:
			var row_arr: Array = by_round[ri]
			var sc: Dictionary = row_arr[ji] if ji < row_arr.size() else {}
			var raw_a: int = int(sc.get("a", 0))
			var raw_b: int = int(sc.get("b", 0))
			var ded_a := 0
			var ded_b := 0
			if deductions.size() > ri:
				var ded_row: Array = deductions[ri]
				if ded_row is Array and ded_row.size() >= 2:
					ded_a = int(ded_row[0])
					ded_b = int(ded_row[1])
			var show_a: int = raw_a - ded_a
			var show_b: int = raw_b - ded_b
			var red_score: int
			var blue_score: int
			var red_ded: int
			var blue_ded: int
			if a_corner == "blue":
				red_score = show_b
				blue_score = show_a
				red_ded = ded_b
				blue_ded = ded_a
			else:
				red_score = show_a
				blue_score = show_b
				red_ded = ded_a
				blue_ded = ded_b
			rows.append({"round": ri + 1, "red": red_score, "blue": blue_score, "red_ded": red_ded, "blue_ded": blue_ded})
			sum_red += red_score
			sum_blue += blue_score
		var card_winner := "even"
		if sum_red > sum_blue:
			card_winner = "red"
		elif sum_blue > sum_red:
			card_winner = "blue"
		judges.append({"name": names[ji], "lean": lean_word, "rows": rows,
			"total_red": sum_red, "total_blue": sum_blue, "card_winner": card_winner})
	var result := _build_result(j, stopped, stop_round, stop_time, stop_winner, a_corner)
	return {"header": header, "judges": judges, "result": result}


## The result line: kind, words, winner. No names in words (S448).
static func _build_result(j: Dictionary, stopped: bool, stop_round: int, stop_time: String, stop_winner: String, a_corner: String) -> Dictionary:
	# S503 collect: "a" is the player's boxer, in whichever corner she fights from
	var a_side := "blue" if a_corner == "blue" else "red"
	var b_side := "red" if a_side == "blue" else "blue"
	if stopped:
		var sw := a_side if stop_winner == "a" else b_side if stop_winner == "b" else ""
		var words := "Winner by stoppage, round %d (%s)" % [stop_round, stop_time]
		return {"kind": "stoppage", "words": words, "winner": sw}
	var verdict: String = str(j.get("verdict", "draw"))
	var winner_ab: String = str(j.get("winner", ""))
	var winner_corner := ""
	if winner_ab == "a":
		winner_corner = a_side
	elif winner_ab == "b":
		winner_corner = b_side
	if verdict == "draw":
		var cards_arr: Array = j.get("cards", [])
		var level_count := 0
		for c in cards_arr:
			if int(c[0]) == int(c[1]):
				level_count += 1
		if level_count == 3:
			return {"kind": "draw", "words": "Draw", "winner": ""}
		var a_cards := 0
		var b_cards := 0
		for c in cards_arr:
			if int(c[0]) > int(c[1]):
				a_cards += 1
			elif int(c[1]) > int(c[0]):
				b_cards += 1
		if a_cards == 1 and b_cards == 1:
			return {"kind": "draw", "words": "Draw (split)", "winner": ""}
		return {"kind": "draw", "words": "Draw (majority)", "winner": ""}
	var words := ""
	match verdict:
		"unanimous":
			words = "Winner by unanimous decision"
		"split":
			words = "Winner by split decision"
		"majority":
			words = "Winner by majority decision"
		_:
			words = "Winner by decision"
	return {"kind": "decision", "words": words, "winner": winner_corner}


## Three DIFFERENT fictional judge names from the built-in list, seeded deterministically.
static func _judge_names(seed: int) -> Array:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var out: Array = []
	var used := {}
	var attempts := 0
	while out.size() < 3 and attempts < 100:
		var fi: int = rng.randi_range(0, FIRST.size() - 1)
		var li: int = rng.randi_range(0, LAST.size() - 1)
		var full: String = FIRST[fi] + " " + LAST[li]
		if not used.has(full):
			used[full] = true
			out.append(full)
		attempts += 1
	while out.size() < 3:
		out.append("Judge %d" % (out.size() + 1))
	return out
