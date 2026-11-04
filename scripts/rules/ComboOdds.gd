extends RefCounted
## S355 CORE3 step 3, the combo lab's hit rates (CORE3_DESIGN_S354.md: each combination "shows how often it lands whole
## against the next opponent's game and against other games ... Numbers come from the fight model (ComboFlow /
## Exchanges), so the lab never promises what the ring will not do"). A combination thrown in an exchange lands whole when
## she wins that exchange, so its hit rate is Exchanges.settle's own dice on her edge: her strength gap to the opponent
## (LiveRound.open's base) + the combination's worth in that game (PlanFight.value: its fit x her pad time x Fast hands).
## The corner's calls and her habits move a real exchange on top; the lab shows the combination's own part. Pure static.
##   win_odds(d) -> 0..1   move_of(combo_id) -> StrikeMap id   gap(f, opp) -> power points
##   table(combo_id, f, opp) -> {move, gap, base, drilled, main, rows: [{sit, label, fit, odds}]}
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const PerkFight := preload("res://scripts/rules/PerkFight.gd")
const FilmEdge := preload("res://scripts/rules/FilmEdge.gd")

## The opponent's games a combination is thrown into (her own trouble - she_tired / she_hurt - is not a plan's).
const GAMES := ["press", "range", "counter", "loadup", "tiring"]


## The chance she wins an exchange with edge d: settle's margin = d + (roll_a - roll_b) x EX_SPREAD, two uniform rolls.
static func win_odds(d: float) -> float:
	var x := clampf(-d / Exchanges.EX_SPREAD, -1.0, 1.0)
	return 1.0 - (1.0 + x) * (1.0 + x) / 2.0 if x <= 0.0 else (1.0 - x) * (1.0 - x) / 2.0


## The fight model's move for a book combination ("" when none).
static func move_of(combo_id: String) -> String:
	for m in StrikeMap.MOVES:
		if str(m["kind"]) == "combo" and str(m["combo"]) == combo_id:
			return str(m["id"])
	return ""


## Her strength gap in power points to this opponent, as the bout opens it (LiveRound.open); no opponent = an even one.
static func gap(f: Dictionary, opp: Dictionary) -> float:
	if opp.is_empty():
		return 0.0
	return BoutRules.fight_power(f["stats"], f.get("camp", {}), FilmEdge.answered(f), "") \
		+ BoutRules.weapons_edge(BoutRules.weapons(f.get("moves", {}))) - float(opp.get("rating", 60.0))


## The lab's table for one book combination against one opponent ({} = an even opponent; {} back when no such move).
## base = her odds in an exchange with no combination edge; main = the opponent's main game (her style's favourite).
static func table(combo_id: String, f: Dictionary, opp: Dictionary) -> Dictionary:
	var mv := move_of(combo_id)
	if mv == "":
		return {}
	var g := gap(f, opp)
	var rate := PlanFight.rate(mv, f.get("combos", {})) * PerkFight.combo_rate(f, mv)
	var rows: Array = []
	for sit in GAMES:
		rows.append({"sit": sit, "label": str(Exchanges.MODES[sit]["label"]), "fit": PlanFight.fit(mv, sit),
			"odds": win_odds(g + PlanFight.value(mv, sit, rate))})
	return {"move": mv, "gap": g, "base": win_odds(g), "drilled": PlanFight.rate(mv, f.get("combos", {})) >= 1.0,
		"main": "" if opp.is_empty() else Exchanges.favourite(str(opp.get("style", ""))), "rows": rows}
