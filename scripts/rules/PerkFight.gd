extends RefCounted
## S355 the perks' fight effects: each perk on the perk road (PerkRoad, Kalli KALLI_RECEPTION_RPG_S354.md) that she has
## opened (f["perks"], recorded by PerkRoad.newly_open) changes one thing in the settled fight. A fight without a perk plays
## exactly as before (Counter sense rolls its own dice). Pure static.
## Hooks: BoutNight._counts (Iron chin, Finisher), BoutNight._energy (Second wind), LiveRound.open (Body snatcher),
## LiveRound.exchange (Stiff jab, Ring general, Counter sense, Fast hands). Numbers are game-design values; the measured
## effect of each is printed by tests/perk_fight_test.gd (the perk vs the same fighter without it).
const Knockdowns := preload("res://scripts/rules/Knockdowns.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")

## Second wind: energy back at the bell of this round (a tenth of the tank).
const SECOND_WIND := 10.0
const SECOND_WIND_ROUND := 3
## Stiff jab: power points in every exchange the opponent presses (a fifth of a best call's Exchanges.EDGE 15).
const STIFF_JAB := 3.0
## Ring general: a corner call that helps (a positive edge) is worth this much more.
const RING_GENERAL := 1.25
## Counter sense: an exchange she wins while the opponent attacks gives a free counter this often - one more punch landed
## head damage for the knockdown roll (half a landed set-up's CornerJobs.SETUP_DAMAGE 30) and margin on the exchange (so a
## clean counter can leave the opponent hurt, Exchanges.HURT_AT). Damage 8 and no margin measured 1 more counted bout in 160.
const COUNTER_ODDS := 0.3
const COUNTER_DAMAGE := 15.0
const COUNTER_MARGIN := 12.0
const COUNTER_SITS := ["press", "loadup"]
## Body snatcher: each body shot she lands costs the opponent this much more energy.
const BODY_SNATCHER := 1.15
## Finisher: the referee's stoppage odds once the opponent has taken a count.
const FINISHER := 1.5
## Fast hands: a combination's edge (a combination arrow of her plan, the corner's set-up) when it helps. x1.1 measured
## +3 rounds won in 480 (tests/perk_fight_test.gd) - too small to feel beside Stiff jab; x1.25 puts a best-fit combination
## (PlanFight.EDGE 9) at +2.25, near Stiff jab's +3.
const FAST_HANDS := 1.40
## The fight lines' names.
const NAMES := {"iron_chin": "Iron chin", "stiff_jab": "Stiff jab", "second_wind": "Second wind", "ring_general": "Ring general",
	"counter_sense": "Counter sense", "body_snatcher": "Body snatcher", "finisher": "Finisher", "hand_speed": "Fast hands"}


static func has(f: Dictionary, id: String) -> bool:
	return (f.get("perks", {}) as Dictionary).has(id)


## Iron chin: the first count she takes in a bout is only a stagger - she stays up. k = Knockdowns.round_counts with her
## the loser; so_far = her counts before this round. Returns k with one count fewer, "stagger" true and the stoppage worked
## out again on what is left (a count she still takes can still be waved off).
static func iron_chin(k: Dictionary, so_far: int) -> Dictionary:
	var out := k.duplicate(true)
	var n := int(k.get("counts", 0))
	if n == 0:
		return out
	n -= 1
	out["counts"] = n
	out["stagger"] = true
	out["up_at"] = (k.get("up_at", []) as Array).slice(1)
	var rsc := n > 0 and (n >= Knockdowns.COUNTS_ROUND_STOP or so_far + n >= Knockdowns.COUNTS_BOUT_STOP or bool(k.get("waved", false)))
	var ko := n > 0 and not rsc and bool(k.get("ko", false))
	out["how"] = "RSC" if rsc else ("KO" if ko else "")
	out["stopped"] = rsc or ko
	return out


## Finisher: the multiplier on the referee's stoppage odds for her opponent (Knockdowns reads sides[loser]["stop_mult"]).
static func stop_mult(f: Dictionary) -> float:
	return FINISHER if has(f, "finisher") else 1.0


## Second wind: her energy at the bell of round n (capped at the full tank).
static func second_wind(f: Dictionary, n: int, energy: float) -> float:
	if n != SECOND_WIND_ROUND or not has(f, "second_wind"):
		return energy
	return minf(Combos.TANK, energy + SECOND_WIND)


## Stiff jab: power points this exchange (sit = Exchanges.situation).
static func jab_edge(f: Dictionary, sit: String) -> float:
	return STIFF_JAB if sit == "press" and has(f, "stiff_jab") else 0.0


## Ring general: the corner call's edge (Exchanges.call_edge) with the perk.
static func call_edge(f: Dictionary, edge: float) -> float:
	return edge * RING_GENERAL if edge > 0.0 and has(f, "ring_general") else edge


## Counter sense: whether this exchange gives her a free counter. roll in [0, 1).
static func counters(f: Dictionary, sit: String, won: bool, roll: float) -> bool:
	return won and COUNTER_SITS.has(sit) and has(f, "counter_sense") and roll < COUNTER_ODDS


## Body snatcher: the energy each body shot she lands costs the opponent (Exchanges.BODY_COST without the perk).
static func body_cost(f: Dictionary) -> float:
	return Exchanges.BODY_COST * (BODY_SNATCHER if has(f, "body_snatcher") else 1.0)


## Fast hands: the rate multiplier for a move of her plan (a combination only).
static func combo_rate(f: Dictionary, move_id: String) -> float:
	if not has(f, "hand_speed") or str(StrikeMap.move(move_id).get("kind", "")) != "combo":
		return 1.0
	return FAST_HANDS


## Fast hands on the corner's set-up (a combination): its edge when it helps.
static func setup_edge(f: Dictionary, edge: float) -> float:
	return edge * FAST_HANDS if edge > 0.0 and has(f, "hand_speed") else edge


## The round's "Perks at work" line from its exchanges' "perks" lists ("" when none fired). name = her first name.
static func round_line(exs: Array, name: String) -> String:
	var n := {}
	for x in exs:
		for id in (x as Dictionary).get("perks", []):
			n[id] = int(n.get(id, 0)) + 1
	if n.is_empty():
		return ""
	var parts := PackedStringArray()
	for id in NAMES.keys():
		if n.has(id):
			parts.append("%s x%d" % [NAMES[id], int(n[id])])
	return "%s's perks at work: %s." % [name, ", ".join(parts)]
