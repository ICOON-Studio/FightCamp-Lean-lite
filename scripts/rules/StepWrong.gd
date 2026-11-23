extends RefCounted
## S538 STEPPAY4 (docs/STEPPAY3_RESULT.md "Not done" 1): THE WRONG STYLE PUNISHES THE STEP.
## Measured first (tools/step_fire_fit_probe.gd `wrong`, docs/STEPPAY4_RESULT.md): five steps read >= 0 against the style
## that should punish them because they never MEET their wrong situation - the plan's other lines take those exchanges
## (step in was wanted 0.00 times a bout in the Pressure fighter's "press", step out 0.00 in the Out-boxer's "range"), so
## the wrong grade (PlanFight.ANSWERS) and StepWire.WRONG_COST had nothing to bite on. The cost of those steps is not in
## the exchange they are taken in: it is WHERE THEY LEAVE YOUR BOXER (ops/research/topics/footwork.md; the coach: "never
## step straight in on a pressure fighter, he meets you; never back off an out-boxer, you hand him his range").
## One rule, a row a step: a planned step that came off GIVES the opponent one of her games (GIVES):
##   step in, herd                  -> "press": she meets you / she comes anyway and your boxer is flat-footed
##   step out, step back, pivot out -> "range": she has the distance she wants - free jabs, the round slips away
## Only a style that LIVES on that game takes it (LIVES: at least half her fight in Exchanges.STYLE_MODES - the Pressure
## fighter's press 0.55, the Out-boxer's range 0.6, the Swarmer's and the Stalker's press); for every other style the step
## is what it was. She keeps it for the rest of the round, until your boxer wins an exchange without such a step. While
## she has it (a) she plays that game (PULL on its weight in Exchanges.next_mode) and (b) every exchange she plays it in
## is hers by COST x that game's share of her fight. So the step stays the right answer where it was (step back from a
## presser), and the one style that lives on the game it gives makes it a mistake - in its moment too (StepMoment: a
## presser whose jab fell short still meets the step in; an out-boxer you just hit still takes the range you give back).
## (c) THE STEP IS ONLY A STEP (bare): against that style no punch goes with it (StepWire.ride - the step costs its
## exchange): out where she wants your boxer there is nothing to throw; walking in on a presser she throws first.
## Measured: (a) + (b) alone left step out at +1.4 against the Out-boxer (its lines fire when she is tired or hurt, when she
## cannot take the range, and half of them carried a punch) - the punch that rode with the step was the pay.
## THE LINE OF THE LOADED SHOT (LINE): a step straight back keeps your boxer on the line of a puncher's big shot. Against
## a boxer whose MAIN game is the loaded shot (the Slugger), in an exchange she loads up, step back is only a step too:
## your boxer gets away, with nothing to throw back (roll out, tie up and the slip are the answers that keep their pay).
## (d) SHE MEETS THE STEP (meet): the exchange the step is taken in is hers by the same price - the brief's own words
## ("he meets you, you lose the exchange"; "free jabs"). Measured: (a) (b) (c) left step out at +1.2 against the Out-boxer.
## Sizes by the STEPPAY gate's own cells (docs/STEPPAY4_RESULT.md), not guessed twice. Pure static, zero preloads.
## `on` false = the control arm (the game before). The live round's wire is state/RingDuel.gd (step, step_bias, settle).

const GIVES := {"step_in": "press", "herd": "press", "step_out": "range", "step_back": "range", "pivot_out": "range"}
const LINE := {"step_back": "loadup"}   ## the step that stays on the line of this game's shot
const LIVES := 0.5   ## the share of her fight a game must be for her to take it
const PULL := 6.0    ## her game's weight x this while she has it
const COST := 30.0   ## x her style's weight of the game = the power points an exchange of it is hers by (16.5 / 18 / 13.5; a best corner call is 17)
static var on: bool = true
## MEASUREMENT ONLY (tools/step_fire_fit_probe.gd `trap=cost:8,pull:1.5`).
static var probe: Dictionary = {}


static func cost() -> float:
	return float(probe.get("cost", COST))


static func pull() -> float:
	return float(probe.get("pull", PULL))


## The game a step hands the opponent ("" = none). "herd@corner" reads as "herd".
static func gives(step: String) -> String:
	return str(GIVES.get(step.get_slice("@", 0), ""))


## Whether the step is only a step this exchange (no punch rides with it): she lives on the game it gives, or it keeps
## your boxer on the line of her main game's shot while she plays it (weights = her style's row of Exchanges.STYLE_MODES,
## mode = her game now). `trap=bare:0` in the probe = this part off (measurement only).
static func bare(step: String, weights: Dictionary, mode: String) -> bool:
	if not on or float(probe.get("bare", 1.0)) <= 0.0:
		return false
	var id := step.get_slice("@", 0)
	var g := gives(id)
	if g != "" and float(weights.get(g, 0.0)) >= LIVES:
		return true
	var l := str(LINE.get(id, ""))
	return l != "" and mode == l and main(weights) == l


## Her main game: the heaviest of her style's row ("" for an empty row).
static func main(weights: Dictionary) -> String:
	var top := ""
	for k in weights:
		if top == "" or float(weights[k]) > float(weights[top]):
			top = str(k)
	return top


## End of an exchange (lv = the round's state): a planned step that came off leaves its mark; an exchange your boxer wins
## without such a step takes the ring back. A held or unplanned step marks nothing.
static func after(lv: Dictionary, arrow: String, planned: bool, won: bool) -> void:
	var g := gives(arrow) if on and planned else ""
	if g != "":
		lv["gave"] = g
		lv["gave_left"] = int(probe.get("keep", 0.0))   # MEASUREMENT ONLY: keep:n = she keeps it n exchanges (0 = the round)
	elif won:
		lv.erase("gave")
	elif int(lv.get("gave_left", 0)) > 0:
		lv["gave_left"] = int(lv["gave_left"]) - 1
		if int(lv["gave_left"]) <= 0:
			lv.erase("gave")


## The power points this exchange costs your boxer: she is playing the game the step gave her (mode = her game now,
## weight = that game's share of her style's fight, 0..1; under LIVES she has nothing to punish with).
static func edge(lv: Dictionary, mode: String, weight: float) -> float:
	return -cost() * clampf(weight, 0.0, 1.0) if on and mode != "" and weight >= LIVES and str(lv.get("gave", "")) == mode else 0.0


## SHE MEETS THE STEP: the power points the exchange a planned step is taken in costs your boxer, against a boxer who
## lives on the game it gives (step = the planned line that came off this exchange, "" = none or held). Same price as an
## exchange of the game she was given: walk in on a presser and she throws first; back off an out-boxer and the jab follows;
## back straight off a slugger who is loading up and the big shot finds your boxer on its line (LINE, by her loadup share).
## The fight grades that step WRONG in the record (RingDuel.settle: arrow_fit), so the result page and the Why say so.
static func meet(step: String, weights: Dictionary, mode := "") -> float:
	return -cost() * float(probe.get("meet", 1.0)) * clampf(float(weights.get(met_game(step, weights, mode), 0.0)), 0.0, 1.0) if on else 0.0


## The game she meets the step with ("" = she does not): the game it gives, if she lives on it; else the game whose loaded
## shot the step stays on the line of (LINE), while she plays it as her main game (mode = her game this exchange).
static func met_game(step: String, weights: Dictionary, mode := "") -> String:
	var id := step.get_slice("@", 0)
	var g := gives(id)
	if g != "" and float(weights.get(g, 0.0)) >= LIVES:
		return g
	var l := str(LINE.get(id, ""))
	return l if l != "" and mode == l and main(weights) == l else ""


## S539 STEPPAY5 (STEPPAY4 gate: cut_off +6.25 against the Out-boxer, over the band): A BOXER WHO LIVES ON THE RANGE
## SLIDES OFF THE FIRST CUT. Cutting the ring on a mover is slow work: the first cut of a round takes her room (StepWire's
## ring_cut) but she slides along the ropes and out - the step is only a step, nothing rides with it. Once the ring is cut
## (lv.ring_cut, set by that first cut) she is trapped and the next cut rides as before. Only a style that lives on the game
## the step takes away (SLIDES; LIVES) slides; against every other style the cut is what it was. `trap=slide:0` = off.
const SLIDES := {"cut_off": "range"}


static func slides(step: String, weights: Dictionary, lv: Dictionary) -> bool:
	var g := str(SLIDES.get(step.get_slice("@", 0), ""))
	return on and float(probe.get("slide", 1.0)) > 0.0 and g != "" and float(weights.get(g, 0.0)) >= LIVES and float(lv.get("ring_cut", 0.0)) <= 0.0


## The bias on her next game (Exchanges.next_mode): the game she was given, PULL times as likely - if she lives on it
## (weights = her style's row of Exchanges.STYLE_MODES). Never edits `b`.
static func bias(b: Dictionary, lv: Dictionary, weights: Dictionary) -> Dictionary:
	var g := str(lv.get("gave", ""))
	if not on or g == "" or float(weights.get(g, 0.0)) < LIVES:
		return b
	var out := b.duplicate()
	out[g] = float(out.get(g, 1.0)) * pull()
	return out
