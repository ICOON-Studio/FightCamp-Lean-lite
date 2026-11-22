extends RefCounted
## S537 STEPPAY3 (docs/STEPPAY2_PHASE4.md "what is left" 1): THE FIVE STEPS' MOMENTS.
## STEPPAY2 measured that five steps sit under the band because the fight never gave them their moment (herd fired 0.15 a
## bout, push off was never "best", roll out was best in 9% of its fires, step in 7-34%, step out only in your own trouble).
## A moment is a situation inside the opponent's game, dealt at a real rate (never every exchange), where ONE step is the
## answer. PlanFight.ANSWERS holds its row (graded like every other situation: fit, ride, levers); this file is only WHEN the
## fight deals it and WHERE it is fought. One rule per step, boxing-true (ops/research/topics/footwork.md; the brief's coach:
## "step out after you land, roll under the hooks on the ropes, push off when he smothers you, herd him back to the ropes,
## step in when his jab falls short"):
##   short   (step in)   - she boxes at range and her jab falls short: fought from outside her reach.
##   landed  (step out)  - your boxer won the last exchange at long or mid range against a presser / a loader: she is at the
##                         end of her punches (fought at long range) and the return is coming.
##   flurry  (roll out)  - on your own ropes against a presser / a loader: she steps in close with hooks (fought inside).
##   smother (push off)  - a presser walks chest to chest at mid range or inside: fought in the clinch.
##   drift   (herd)      - your boxer won the last exchange against a mover (range, counter): she is on the ropes, sliding
##                         off to the open side.
## Her own trouble (tired, hurt) and a tiring / hurt opponent deal no moment: those situations keep their own answers.
## RATE = the chance an exchange that qualifies becomes the moment. Sized by tools/step_fire_fit_probe.gd and the STEPPAY2
## gate (docs/STEPPAY3_RESULT.md), never guessed. Pure static, zero preloads. `on` false = the control arm (the game before).

const RATE := {"short": 0.25, "landed": 0.25, "flurry": 0.25, "smother": 0.5, "drift": 0.5}
## The card a moment is fought on: the card its step starts from.
const CARD := {"short": "outside", "landed": "long", "flurry": "inside", "smother": "clinch", "drift": "opp_ropes"}
## The step each moment is for (PlanFight.ANSWERS[moment].best holds it).
const STEP := {"short": "step_in", "landed": "step_out", "flurry": "roll_out", "smother": "push_off", "drift": "herd"}
static var on: bool = true
## MEASUREMENT ONLY (tools/step_fire_fit_probe.gd `rate=short:0.2,...`): another rate for a moment.
static var probe_rate: Dictionary = {}


static func rate(id: String) -> float:
	return float(probe_rate.get(id, RATE.get(id, 0.0)))


## The moments this exchange qualifies for, in roll order. sit = Exchanges.situation (the opponent's game, or your boxer's
## own trouble); at = the card she stands on; prev_won = your boxer won the round's last exchange (false at the bell).
static func open_to(sit: String, at: String, prev_won: bool) -> Array:
	var out: Array = []
	match sit:
		"range":
			if at == "long" or at == "outside":
				out.append("short")
			if prev_won and (at == "long" or at == "mid"):
				out.append("drift")
		"counter":
			if prev_won and (at == "long" or at == "mid" or at == "outside"):
				out.append("drift")
		"press", "loadup":
			if prev_won and (at == "long" or at == "mid"):
				out.append("landed")
			if at == "own_ropes":
				out.append("flurry")
			if sit == "press" and (at == "mid" or at == "inside"):
				out.append("smother")
	return out


## {} = no moment; else {id, at}: the moment and the card this exchange is fought on. roll = its own dice (0..1).
static func deal(sit: String, at: String, prev_won: bool, roll: float) -> Dictionary:
	if not on:
		return {}
	var r := roll
	for id in open_to(sit, at, prev_won):
		var p := rate(str(id))
		if r < p:
			return {"id": str(id), "at": str(CARD.get(id, at))}
		r -= p
	return {}


## The live round's call: deals from the card on lv["at"] and moves the exchange onto the moment's card.
static func deal_on(lv: Dictionary, sit: String, prev_won: bool, roll: float) -> Dictionary:
	var mo := deal(sit, str(lv.get("at", "")), prev_won, roll)
	if not mo.is_empty():
		lv["at"] = str(mo["at"])
	return mo
