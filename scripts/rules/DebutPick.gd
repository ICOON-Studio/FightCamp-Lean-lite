extends RefCounted
## DEBUTPICK1 (S533, owner Q-286 "Pick to each boxer"): the promoter picks the debut opponent to fit THIS boxer. Each house
## has a TARGET win chance for its debut instead of one fixed gap (TURNPRO6: at one gap the same debut won 30 to 90 in 100
## by boxer). The pick searches the gap through the read the offer shows (DebutRead.card: the same opponent rule and the
## same walk of the bout - never a second model of the fight) until that read sits on the house's target. A matchmaker
## misjudges: the target moves a few points either way, seeded by the boxer, the house and the day (same seed, same pick),
## never by more than NOISE. Pure static; the offer carries the pick (ProOfferWire.make), so a save keeps it.
##   target(key, f, day) -> 0.56..0.79    pick(f, t, day, coach) -> {gap, target, read}
##   apply(f, t, day, coach) -> the terms with opp_gap picked    line(t) / tip(t) -> the offer's words

const DebutRead := preload("res://scripts/rules/DebutRead.gd")

## The win chance each house aims its debut at (docs/TURNPRO6_RESULT.md section 6: the bigger gate 55-65, the safer house
## 70-80 in 100; the measured means at the old fixed gaps were 60.1 and 74.9).
const AIM := {"bow": 0.60, "hf": 0.75}
const AIM_OTHER := 0.65   ## a house this table does not know
const NOISE := 0.04       ## the matchmaker's misjudgement: at most this far either side of the aim
## The gaps a matchmaker can find a debutant at: from 6 rating points over the boxer to 14 under.
const GAP_MIN := -6.0
const GAP_MAX := 14.0
const STEP := 0.1         ## DebutOpp snaps the rating to 0.1

static var _cache: Dictionary = {}


static func clear_cache() -> void: _cache = {}


static func aim(key: String) -> float:
	return float(AIM.get(key, AIM_OTHER))


## The house's aim for this boxer on this day: the aim and the misjudgement, the same for the same boxer, house and day.
static func target(key: String, f: Dictionary, day: int) -> float:
	var u := float(posmod(hash("%s|%s|%d|debutpick" % [str(f.get("id", f.get("name", ""))), key, day]), 10001)) / 10000.0
	return aim(key) + (u * 2.0 - 1.0) * NOISE


## The read the offer would show at this gap (DebutRead.card: the bout as it will be fought).
static func read_at(f: Dictionary, t: Dictionary, gap: float, day: int, coach: float) -> float:
	var t2 := t.duplicate()
	t2["opp_gap"] = gap
	return float(DebutRead.card(f, t2, day, coach)["win"])


## The gap whose read is nearest the house's target for this boxer. t = the house's terms (key, name); coach = his rating.
## The read rises with the gap, so the search halves the range (8 reads) and then takes the nearer of the two neighbours.
static func pick(f: Dictionary, t: Dictionary, day: int, coach: float) -> Dictionary:
	var key := str(t.get("key", ""))
	var ck := "%s|%s|%d|%s|%s|%s" % [str(f.get("id", f.get("name", ""))), key, day, str(f.get("stats")), str(coach), str(f.get("perks")) + str(f.get("moves")) + str(f.get("style"))]
	if _cache.has(ck):
		return (_cache[ck] as Dictionary).duplicate()
	var want := target(key, f, day)
	var lo := roundi(GAP_MIN / STEP)
	var hi := roundi(GAP_MAX / STEP)
	while hi - lo > 1:
		var mid := (lo + hi) >> 1
		if read_at(f, t, float(mid) * STEP, day, coach) < want:
			lo = mid
		else:
			hi = mid
	var r_lo := read_at(f, t, float(lo) * STEP, day, coach)
	var r_hi := read_at(f, t, float(hi) * STEP, day, coach)
	var take_hi := absf(r_hi - want) <= absf(r_lo - want)
	var out := {"gap": snappedf(float(hi if take_hi else lo) * STEP, STEP), "target": want, "read": r_hi if take_hi else r_lo}
	_cache[ck] = out
	return out.duplicate()


## The house's terms with the opponent picked for this boxer. opp_gap is what Roster.turn_pro books and the asks move.
static func apply(f: Dictionary, t: Dictionary, day: int, coach: float) -> Dictionary:
	var p := pick(f, t, day, coach)
	var out := t.duplicate()
	out["opp_gap"] = float(p["gap"])
	out["opp_target"] = float(p["target"])
	out["opp_picked"] = true
	out["opp_day"] = day   # the debutant is the one picked on the offer's day, whenever the offer is read or signed (DebutRead, Roster.turn_pro)
	return out


## Whether this house aims for a safe first night (the safer house) or a test (the bigger gate).
static func safe(t: Dictionary) -> bool:
	return aim(str(t.get("key", ""))) >= 0.70


## The offer's line on a picked opponent, after the debutant's name ("" = an old offer with a fixed gap: the screen keeps its
## old words). S534 (owner C442 "what opponent was picked"): the card names the debutant, this says why the house chose them.
static func line(t: Dictionary) -> String:
	if not bool(t.get("opp_picked", false)):
		return ""
	return "picked as a winnable first night" if safe(t) else "picked to test your boxer"


## The hover card on the opponent row (Tip.explain: what it is, what it brings, what the player can do; 25 words). S534 (owner
## C443 "can he do anything about them?"): no aim, no rating - only what the player can act on.
static func tip(_t: Dictionary) -> Dictionary:
	return {"title": "The debut opponent",
		"what": "A first-time pro the promoter picked to fit your boxer.",
		"now": "%s, %s." % [DebutRead.DebutOpp.THREAT, DebutRead.DebutOpp.WEAK.to_lower()],
		"do": "Spend the ask on a softer opponent."}
