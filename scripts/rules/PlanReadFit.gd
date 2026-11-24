extends RefCounted
## PLANREAD2 (S547, docs/PLANREAD2_RESULT.md): the read's plan term, out of BoutRead (at its 500-line limit), read the way the
## ring fights a plan today. BoutRead._round_edges opens the counter's counts once a bout (open), adds chain() to every
## round and takes the countered share off her exchange odds (countered), then fades the counts at the bell (bell).
## Before S547 the read priced her own-trouble line on the "inside" card at PLAN_REACH x PLAN_CARRY with no fire share and
## had no term for the S540 combo counter: 8.4 points read for one line the bout paid 1.8 (60 cells, 30,000 bouts a count).
## Pure static. The probe's switch `off` (empty in the game) drops a part to measure it (tools/planread2_probe.gd):
## "chain" the whole term, "tired" her own trouble's edge, "tiring" the opponent's, "counter" the counter.

const PlanChain := preload("res://scripts/rules/PlanChain.gd")
const PlanFile := preload("res://scripts/rules/PlanFile.gd")
const LineGrade := preload("res://scripts/rules/LineGrade.gd")
const ComboCounter := preload("res://scripts/rules/ComboCounter.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

## S434 share of a plan's edge in her own trouble. Unused since S547 (her trouble walks the chain at its fire share); kept
## for the TELLPLAY1 tools that quote it.
const PLAN_REACH := 0.75
## S397 what rides on a plan's answers past their own exchange (PlanRead's reads, PlanPressure's pressure and tank ceiling).
## S434 PUNCHSTART1 round 2 fit: 22 arms x 1,000 real bouts (Lucy, no plan to four arrows) worst 0.033, rms 0.017.
## S547 PLANREAD2 checked it on the ring's own records (LiveRound rec plan_edge and read_edge, 60 type x style cells, plans
## of 1 to 5 lines, 500 bouts a cell): (plan_edge + read_edge) / plan_edge = 1.945 - kept, not refitted.
const PLAN_CARRY := 1.9

static var off := {}


## The counter's counts at the first bell: the film line half-read (ComboCounter.open_round), as expected throws.
static func open(f: Dictionary, opp: Dictionary) -> Dictionary:
	if not ComboCounter.on or off.has("counter"):
		return {}
	var out := {}
	var film := ComboCounter.film_start(str(f.get("cc_film", "")), ComboCounter.read_at(float(opp.get("rating", 60.0))))
	for k in film:
		out[k] = float(film[k])
	return out


## The bell: every count fades by ComboCounter.FADE.
static func bell(cc: Dictionary) -> Dictionary:
	var out := {}
	for k in cc:
		out[k] = maxf(0.0, float(cc[k]) - float(ComboCounter.FADE))
	return out


## Round n's plan term: [edge per exchange (x PLAN_CARRY), countered share per exchange]. The lines of round n (PlanFile
## phase lines, as LiveRound), her grade, every situation on the chain.
static func chain(fx: Dictionary, opp: Dictionary, steps: Array, p_win: float, cc: Dictionary, n: int, rounds: int) -> Array:
	if off.has("chain"):
		return [0.0, 0.0]
	var skip: Array = []
	if off.has("tired"): skip.append("she_tired")
	if off.has("tiring"): skip.append("tiring")
	var on := ComboCounter.on and not off.has("counter")
	var arrows := PlanFile.arrows_for(fx.get("arrows", []), fx.get("late", {}), n, rounds)
	var got := PlanChain.walk_ring(arrows, fx.get("moves", {}), fx.get("combos", {}), steps, p_win, fx.get("steps", {}), LineGrade.attrs_for(fx),
		cc, ComboCounter.read_at(float(opp.get("rating", 60.0))), ComboCounter.chance(str(opp.get("style", ""))) if on else 0.0, skip)
	return [PLAN_CARRY * float(got[0]), float(got[1])]


## The round edge whose exchange odds are her odds at e with `kappa` of the exchanges countered (lost): win_odds inverted.
static func countered(e: float, kappa: float) -> float:
	if kappa <= 0.0:
		return e
	var p := _odds(e) * (1.0 - clampf(kappa, 0.0, 1.0))
	var x := sqrt(2.0 * (1.0 - p)) - 1.0 if p >= 0.5 else 1.0 - sqrt(2.0 * p)
	return -x * Exchanges.EX_SPREAD


## ComboOdds.win_odds (copied: ComboOdds preloads BoutRead's neighbours).
static func _odds(d: float) -> float:
	var x := clampf(-d / Exchanges.EX_SPREAD, -1.0, 1.0)
	return 1.0 - (1.0 + x) * (1.0 + x) / 2.0 if x <= 0.0 else (1.0 - x) * (1.0 - x) / 2.0
