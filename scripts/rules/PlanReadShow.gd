extends RefCounted
## S539 PLANREADSHOW1 (owner Q-S294-301, repeated combos get read): the rule is PlanRead.ADJUST (S396 "opponents adjust"); this
## file only SAYS it - no number here changes a fight. Words are game words and carry no names (names only in headers).
##   cut_pct(keep) -> int   feed_line(move_name) -> String   bite_text(bite) -> String   bites(rounds) -> Dictionary
##   lean_move(arrows) -> String   S540: tip_counter() / counter_line(move_name) / counter_text(row) say ComboCounter

const PlanRead := preload("res://scripts/rules/PlanRead.gd")
const ComboCounter := preload("res://scripts/rules/ComboCounter.gd")   # S540 COMBOCOUNTER1: the counter, said
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")

const TIP_BITE := "A right answer that keeps paying gets read: after %d uses in a round the opponent has it, and each further use pays 30%% less of its edge until the bell. To get it back: give the same moment a second answer, or drill the line sharper so its edge still pays when it is read."
const TIP_LEAN := "One answer covers most of the moments you expect. An opponent who sees it work again and again starts to read it, and it pays 30%% less on every use after the first %d in a round. Give one of those moments a different answer."
## S540 (owner C477): the chip said "after two uses" while the rule bites on the fourth right use (adjust(uses) cuts from
## uses = FREE_USES + 1 earlier right uses); every word now reads READ_AT.
const READ_AT := PlanRead.FREE_USES + 1
const LEAN_WORDS := "Leans on one answer: an opponent reads it after three uses a round"
## S540 COMBOCOUNTER1: every number below is read from ComboCounter (tip_counter fills them in).
const TIP_COUNTER := "The opponent also counts your plan's lines, round to round. After %d throws of the same line (%d against a sharp ring mind) he has it, and about %d in 100 of its further throws get countered: the exchange is his (%d in 100 for a counter-puncher). Each bell fades his count by one, and his camp has your last fight's favourite line on film. Give that moment a second answer."


static func tip_counter() -> String:
	return TIP_COUNTER % [ComboCounter.READ_AT, maxi(1, ComboCounter.READ_AT - 1), int(round(ComboCounter.CHANCE * 100.0)),
		int(round(ComboCounter.chance("Counter-puncher") * 100.0))]


## The tooltip for an exchange's live line: the counter's words on a counter, else the ADJUST bite's.
static func tip_for(x: Dictionary) -> String:
	return tip_counter() if bool((x.get("cc", {}) as Dictionary).get("countered", false)) else TIP_BITE % READ_AT


## The exchange's record of the combo counter: rec["cc"] when a throw met a read, the feed line on a counter.
static func say_counter(rec: Dictionary, cc: Dictionary, arrow: String) -> void:
	if bool(cc["fired"]):
		rec["cc"] = cc
	if bool(cc["countered"]):
		rec["read_line"] = counter_line(move_name(arrow))


## The live fight's line when a counter lands.
static func counter_line(move_name: String) -> String:
	return "They timed your %s: countered, the exchange is theirs." % move_name


## The result tab's words for a line's counters ({n, fired, round} from ComboCounter.counters).
static func counter_text(row: Dictionary) -> String:
	if int(row["n"]) == 0:
		return "read, %d throws into it, none countered" % int(row["fired"])
	return "countered %d of %d throws into the read (first in round %d)" % [int(row["n"]), int(row["fired"]), int(row["round"])]


## The percent of the edge a read took away (0 when nothing bit).
static func cut_pct(keep: float) -> int:
	return int(round((1.0 - keep) * 100.0)) if keep < 1.0 else 0


## The live fight's line on the first bite of a round.
static func feed_line(move_name: String) -> String:
	return "They have your %s now: it pays less this round." % move_name


## The record a bite leaves on its exchange (read only - the fight has already settled).
static func bite(move: String, uses_before: int, keep: float, round_n: int) -> Dictionary:
	return {"move": move, "uses": uses_before, "cut": cut_pct(keep), "round": round_n}


static func bite_text(b: Dictionary) -> String:
	return "read after %d uses in round %d: paid %d%% less" % [int(b["uses"]), int(b["round"]), int(b["cut"])]


## The first bite of each plan answer over the bout: {move: bite}.
static func bites(rounds: Array) -> Dictionary:
	var out := {}
	for r in rounds:
		for x in (r as Dictionary).get("exchanges", []):
			var b: Dictionary = (x as Dictionary).get("read_adj", {})
			if not b.is_empty() and not out.has(str(b["move"])):
				out[str(b["move"])] = b
	return out


## The one answer that covers most of the plan's lines (three lines or more, over half of them), or "".
static func lean_move(arrows: Array) -> String:
	var n := {}
	for a in arrows:
		var mv := str((a as Dictionary).get("move", ""))
		if mv != "":
			n[mv] = int(n.get(mv, 0)) + 1
	for mv in n:
		if int(n[mv]) >= 3 and int(n[mv]) * 2 > arrows.size():
			return str(mv)
	return ""


static func move_name(id: String) -> String:
	return str(StrikeMap.move(id).get("name", id))
