extends RefCounted
## R29JUDGES1 the three judges (FIGHT_LINK_MAP_S432.md M2): each card scores a round from what the exchanges record, on five
## parts, with a lean that doubles one of them; a standing count is 10-8 on every card; a running card and one reason a card.
## The judges are a READ of the exchanges, never a second fight model: no randomness in scoring (only the panel draw), no
## number from outside the round given. Pure static; zero preloads. Collected S443 (Qwen draft, review fixes:
## ops/research/R29JUDGES1_REVIEW_S443.md).

const PARTS := ["clean", "big", "ring", "initiative", "work"]
const AMATEUR_LEANS := ["clean", "ring", "initiative"]
const PRO_LEANS := ["clean", "ring", "work"]
## ESTIMATES from the map; probe JUDGES1 sets them. clean 1 a landed punch, big 2 a big shot, ring 1 an exchange kept,
## initiative 1 a forward exchange won, work 1 a point of (pace gap / 10).
const WEIGHTS := {"clean": 1.0, "big": 2.0, "ring": 1.0, "initiative": 1.0, "work": 1.0}
const LEAN_MULT := 2.0

## Duels.LONG / POCKET / INSIDE (scripts/rules/Duels.gd lines 9-11): a higher place is closer.
const LONG := 0
const POCKET := 1
const INSIDE := 2
const PLACE_WORDS := ["at range", "in the pocket", "inside"]   # Duels.PLACE_WORD


## The five parts of one round, [a, b] each, plus what the reasons and the last tie-break need:
## ring_at [[kept at long, pocket, inside] a, b], pace [a, b], last ("a" / "b" / "": who won the last exchange).
## round = {exs, counts [a, b], pace [a, b], start (optional, LiveRound's {hurt: [a, b]} at the bell that opened it)}.
static func parts(round: Dictionary) -> Dictionary:
	var exs: Array = round.get("exs", [])
	var pace: Array = round.get("pace", [0, 0])
	var clean := [0, 0]
	var big := [0, 0]
	var ring := [0, 0]
	var ring_at := [[0, 0, 0], [0, 0, 0]]
	var initiative := [0, 0]
	var work := [0.0, 0.0]
	var prev_place := LONG
	# A hurt carried over the bell (LiveRound keeps her_hurt into the next round) is not a fresh hurt in this round.
	var start_hurt: Array = (round.get("start", {}) as Dictionary).get("hurt", [false, false])
	var prev_hurt := [bool(start_hurt[0]), bool(start_hurt[1])]
	var last := ""
	for ex in exs:
		var e: Dictionary = ex
		var landed: Array = e.get("landed", [0, 0])
		clean[0] += int(landed[0])
		clean[1] += int(landed[1])
		var won: bool = bool(e.get("won", false))
		var place: int = clampi(int(e.get("place", LONG)), LONG, INSIDE)
		var wa: int = int(e.get("wa", LONG))
		var wb: int = int(e.get("wb", LONG))
		if won and place == wa:
			ring[0] += 1
			ring_at[0][place] += 1
		elif not won and place == wb:
			ring[1] += 1
			ring_at[1][place] += 1
		var rd: Dictionary = e.get("read", {})
		var perks: Array = e.get("perks", [])
		var hurt: Array = (e.get("after", {}) as Dictionary).get("hurt", [false, false])
		var hurt_a: bool = bool(hurt[0])
		var hurt_b: bool = bool(hurt[1])
		if str(e.get("setup", "")) == "landed" or str(rd.get("result", "")) == "landed" or perks.has("counter_sense") \
				or (hurt_b and not prev_hurt[1]):
			big[0] += 1
		if hurt_a and not prev_hurt[0]:
			big[1] += 1
		# A FORWARD exchange (closer than the one before; the first compares with LONG) goes to the side that wanted that
		# place and won it.
		if place > prev_place:
			if won and place == wa:
				initiative[0] += 1
			elif not won and place == wb:
				initiative[1] += 1
		prev_place = place
		prev_hurt = [hurt_a, hurt_b]
		last = "a" if won else "b"
	var gap: float = float(pace[0]) - float(pace[1])
	if gap > 0.0:
		work[0] = gap / 10.0
	elif gap < 0.0:
		work[1] = -gap / 10.0
	return {"clean": clean, "big": big, "ring": ring, "initiative": initiative, "work": work,
		"ring_at": ring_at, "pace": [int(pace[0]), int(pace[1])], "last": last}


## Three lean words, each judge drawn on its own from the set (repeats allowed).
static func panel(seed: int, pro: bool) -> Array:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var leans: Array = PRO_LEANS if pro else AMATEUR_LEANS
	var out: Array = []
	for i in 3:
		out.append(str(leans[rng.randi_range(0, leans.size() - 1)]))
	return out


## The parts this card counts: initiative only amateur, work only pro.
static func counted(pro: bool) -> Array:
	return PARTS.filter(func(p): return not (p == "initiative" and pro) and not (p == "work" and not pro))


## One part's weighted points [a, b] on a card with this lean.
static func points(p: Dictionary, part: String, lean: String) -> Array:
	var v: Array = p.get(part, [0, 0])
	var k: float = float(WEIGHTS[part]) * (LEAN_MULT if part == lean else 1.0)
	return [float(v[0]) * k, float(v[1]) * k]


## One round on one card: {a, b, reason, part, lean}. part = what decided it ("count", a PARTS word, "last").
static func score_round(p: Dictionary, lean: String, counts: Array, pro: bool, names: Array) -> Dictionary:
	var ta := 0.0
	var tb := 0.0
	for part in counted(pro):
		var pt: Array = points(p, part, lean)
		ta += float(pt[0])
		tb += float(pt[1])
	var side := ""
	var part_won := ""
	if not is_equal_approx(ta, tb):
		side = "a" if ta > tb else "b"
		part_won = _deciding(p, lean, pro, side)
	else:
		for tie in ([lean, "clean"] if counted(pro).has(lean) else ["clean"]):
			var v: Array = p.get(tie, [0, 0])
			if side == "" and not is_equal_approx(float(v[0]), float(v[1])):
				side = "a" if float(v[0]) > float(v[1]) else "b"
				part_won = tie
		if side == "":
			side = str(p.get("last", "a")) if str(p.get("last", "")) != "" else "a"
			part_won = "last"
	var sa := 10 if side == "a" else 9
	var sb := 10 if side == "b" else 9
	# Each count suffered takes one more point off that side on every card; counts on both sides cancel one for one.
	var ca: int = int(counts[0]) if counts.size() > 0 else 0
	var cb: int = int(counts[1]) if counts.size() > 1 else 0
	if ca != cb:
		var hit := 0 if ca > cb else 1
		var net := absi(ca - cb)
		if hit == 0:
			sa = 9 - net
			sb = 10
		else:
			sb = 9 - net
			sa = 10
		return {"a": sa, "b": sb, "part": "count", "lean": lean,
			"reason": "Count: %s took %s." % [_name(names, hit), "a count" if net == 1 else "%d counts" % net]}
	return {"a": sa, "b": sb, "part": part_won, "lean": lean, "reason": reason_of(part_won, p, names, side)}


## The part that gave the winner most of the margin on this card (ties: the lean, then the PARTS order).
static func _deciding(p: Dictionary, lean: String, pro: bool, side: String) -> String:
	var order: Array = [lean]
	for part in counted(pro):
		if part != lean:
			order.append(part)
	var best := ""
	var best_gap := 0.0
	for part in order:
		var pt: Array = points(p, part, lean)
		var g: float = (float(pt[0]) - float(pt[1])) * (1.0 if side == "a" else -1.0)
		if g > best_gap + 0.0001:
			best_gap = g
			best = part
	return best if best != "" else lean


## The round's reason in plain words, the winner's name first, no pronoun.
static func reason_of(part: String, p: Dictionary, names: Array, side: String) -> String:
	var i := 0 if side == "a" else 1
	var who := _name(names, i)
	var v: Array = p.get(part, [0, 0]) if PARTS.has(part) else [0, 0]
	match part:
		"clean":
			return "Clean: %s landed %d to %d." % [who, int(v[i]), int(v[1 - i])]
		"big":
			return "Big shots: %s landed %d to %d." % [who, int(v[i]), int(v[1 - i])]
		"ring":
			var at: Array = (p.get("ring_at", [[0, 0, 0], [0, 0, 0]]) as Array)[i]
			var top := 0
			for k in 3:
				if int(at[k]) > int(at[top]):
					top = k
			return "Ring: %s kept the fight %s, %d exchanges." % [who, PLACE_WORDS[top], int(v[i])]
		"initiative":
			return "Initiative: %s came forward and won %d exchanges to %d." % [who, int(v[i]), int(v[1 - i])]
		"work":
			var pace: Array = p.get("pace", [0, 0])
			return "Work: %s set the busier pace, %d to %d." % [who, int(pace[i]), int(pace[1 - i])]
		"last":
			return "Even round: %s won the last exchange." % who
	return "%s won the round." % who


static func _name(names: Array, i: int) -> String:
	return str(names[i]) if i < names.size() else ("Red" if i == 0 else "Blue")


## Every round on three cards: {cards [[a, b] x3], by_round [[{a, b, reason, part} x3] ...], running [[[a, b] x3] after each
## round], verdict "unanimous" / "split" / "majority" / "draw", winner "a" / "b" / ""}.
static func cards(rounds: Array, leans: Array, pro: bool, names: Array) -> Dictionary:
	var totals: Array = [[0, 0], [0, 0], [0, 0]]
	var by_round: Array = []
	var running: Array = []
	for r in rounds:
		var rnd: Dictionary = r
		var p := parts(rnd)
		var counts: Array = rnd.get("counts", [0, 0])
		var row: Array = []
		for j in 3:
			var sc := score_round(p, str(leans[j]), counts, pro, names)
			totals[j][0] += int(sc["a"])
			totals[j][1] += int(sc["b"])
			row.append(sc)
		by_round.append(row)
		running.append([[totals[0][0], totals[0][1]], [totals[1][0], totals[1][1]], [totals[2][0], totals[2][1]]])
	var a_cards := 0
	var b_cards := 0
	for c in totals:
		if int(c[0]) > int(c[1]):
			a_cards += 1
		elif int(c[1]) > int(c[0]):
			b_cards += 1
	var level := 3 - a_cards - b_cards
	var verdict := "draw"
	var winner := ""
	var top := maxi(a_cards, b_cards)
	if a_cards != b_cards and top >= 2:
		winner = "a" if a_cards > b_cards else "b"
		if top == 3:
			verdict = "unanimous"
		elif level == 1:
			verdict = "majority"   # two cards one way, the third level
		else:
			verdict = "split"
	# 1-0 with two level cards is a majority DRAW: verdict "draw", no winner.
	return {"cards": totals, "by_round": by_round, "running": running, "verdict": verdict, "winner": winner}


## The ONE reason for judge j's card (c = cards()): the part that moved most points to that card's winner over the rounds
## it gave them (a tie goes to the judge's lean, then the earlier round), said with the round where it moved most and the
## rounds it decided. "" for a level card.
static func card_reason(c: Dictionary, judge: int) -> String:
	var tot: Array = (c.get("cards", []) as Array)[judge] if judge < (c.get("cards", []) as Array).size() else [0, 0]
	if int(tot[0]) == int(tot[1]):
		return ""
	var side := "a" if int(tot[0]) > int(tot[1]) else "b"
	var moved := {}
	var best_round := {}
	var best_margin := {}
	var rounds_of := {}
	var by_round: Array = c.get("by_round", [])
	for ri in by_round.size():
		var sc: Dictionary = (by_round[ri] as Array)[judge]
		var margin: int = (int(sc["a"]) - int(sc["b"])) * (1 if side == "a" else -1)
		if margin <= 0:
			continue
		var part := str(sc.get("part", ""))
		moved[part] = int(moved.get(part, 0)) + margin
		(rounds_of.get_or_add(part, []) as Array).append(ri + 1)
		if margin > int(best_margin.get(part, 0)):
			best_margin[part] = margin
			best_round[part] = str(sc["reason"])
	var pick := ""
	var lean := ""
	if not by_round.is_empty():
		lean = str(((by_round[0] as Array)[judge] as Dictionary).get("lean", ""))
	for part in moved:
		if pick == "" or int(moved[part]) > int(moved[pick]) or (int(moved[part]) == int(moved[pick]) and part == lean):
			pick = part
	if pick == "":
		return ""
	var rs: Array = rounds_of[pick]
	var where := "round %d" % int(rs[0]) if rs.size() == 1 else "rounds " + ", ".join(rs.map(func(x): return str(x)))
	return "%s (%s)" % [str(best_round[pick]).trim_suffix("."), where]
