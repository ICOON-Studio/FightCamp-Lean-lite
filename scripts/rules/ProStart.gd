extends RefCounted
## S543 TURNPRO17 step 1 (owner Q-S294-320 "Yes, build it", Q-S294-323 "Yes, build v17 now"; map
## ops/research/DESIGN_TURNPRO1_V17.md, numbers tuned by docs/TURNPROBE17_RESULT.md): the rules of turning pro.
## WHEN - the offer's "Not yet": three patience marks, hunger -15 a "Not yet", the offer back in 4 weeks; with no mark
##   left the next call is a rival gym's (turn pro now, or the boxer leaves).
## HOW - pro fights 1 to 6 each offer two bouts: SAFE (the promoter's tune-up, 75-90% to win, today's purse, name +1) and
##   RISKY (the step up, 40-55%, purse x1.75, name +3). The chance shown is the chance the fight uses.
## TWO BARS on the boxer, 0-100: CONFIDENCE (start 50) moves the win chance by at most 5 points either way; HUNGER
##   (start 70) at 0 = the boxer asks to leave: a warning at each of the next two bookings, gone at the third.
## Pure static: no state, no preloads. The state is one Dictionary kept on the fighter (f["pro_start"]).
##   new_state()  shift(conf)  shown(raw, kind, conf)  purse(base, kind)  name_gain(kind)
##   not_yet(s) -> false when no mark is left   can_wait(s)   after_fight(s, kind, outcome) -> what moved
##   rest(s, extra_weeks)   booking_check(s) -> "" | "warn" | "gone"   bar_line(before, after)

const KINDS := ["safe", "risky"]
const KIND_NAMES := {"safe": "Safe", "risky": "Risky"}
const KIND_IS := {"safe": "the promoter's tune-up", "risky": "the promoter's step up"}
const FIGHTS := 6                    ## pro fights 1-6 offer the two bouts; from fight 7 the normal booking
## WHEN
const PATIENCE := 3
const NOT_YET_WEEKS := 4
const NOT_YET_HUNGER := -15
## HOW
const SAFE_BAND := Vector2(0.75, 0.90)
const RISKY_BAND := Vector2(0.40, 0.55)
const NAME := {"safe": 1, "risky": 3}
const RISKY_PURSE := 1.75            ## probe-tuned from double: at x2 the risky bout is taken 81% of the time, at x1.5 the safe one 90%
## CONFIDENCE
const CONF_START := 50
const CONF := {"safe_win": 4, "risky_win": 12, "points_loss": -10, "ko_loss": -30}
const CONF_SHIFT_MAX := 0.05
## HUNGER
const HUNGER_START := 70
const HUNGER_SAFE_WIN := -10         ## probe-tuned from -8
const HUNGER_RISKY := 10             ## a risky fight, win or lose
const HUNGER_IDLE := -5              ## each full four weeks without a fight beyond the usual gap (the rest after a stoppage)
const IDLE_WEEKS := 4
const WARNINGS := 2
const OUTCOMES := ["win", "points", "ko"]


static func new_state() -> Dictionary:
	return {"conf": CONF_START, "hunger": HUNGER_START, "patience": PATIENCE, "warn": 0, "name": 0, "fights": 0}


## The points of win chance confidence moves: linear, 0 -> -0.05, 50 -> 0, 100 -> +0.05.
static func shift(conf: int) -> float:
	return clampf(float(conf - 50) / 50.0 * CONF_SHIFT_MAX, -CONF_SHIFT_MAX, CONF_SHIFT_MAX)


## The chance the booking prints and the fight uses: the game's read of the bout, kept inside the bout's band (the
## matchmaker finds an opponent in the band), then the boxer's confidence.
static func shown(raw: float, kind: String, conf: int) -> float:
	var b: Vector2 = RISKY_BAND if kind == "risky" else SAFE_BAND
	return clampf(clampf(raw, b.x, b.y) + shift(conf), 0.01, 0.99)


static func purse(base: int, kind: String) -> int:
	return roundi(base * RISKY_PURSE) if kind == "risky" else base


static func name_gain(kind: String) -> int:
	return int(NAME.get(kind, 0))


## A patience mark is left to spend on "Not yet". With none left the call is the rival gym's.
static func can_wait(s: Dictionary) -> bool:
	return int(s.get("patience", PATIENCE)) > 1


## "Not yet": a mark gone, hunger -15; the offer returns NOT_YET_WEEKS later. False (nothing changed) with no mark left.
static func not_yet(s: Dictionary) -> bool:
	if not can_wait(s):
		return false
	s["patience"] = int(s.get("patience", PATIENCE)) - 1
	s["hunger"] = clampi(int(s.get("hunger", HUNGER_START)) + NOT_YET_HUNGER, 0, 100)
	return true


## After a pro fight of the first six. kind "safe" | "risky"; outcome "win" | "points" (a loss on the cards) | "ko" (a
## stoppage loss). Moves the bars and the name; returns {conf, hunger, name}: what the fight did (the result line).
static func after_fight(s: Dictionary, kind: String, outcome: String) -> Dictionary:
	var c0 := int(s.get("conf", CONF_START))
	var h0 := int(s.get("hunger", HUNGER_START))
	var n0 := int(s.get("name", 0))
	var conf := c0
	var hunger := h0
	if outcome == "win":
		conf += int(CONF["risky_win" if kind == "risky" else "safe_win"])
		s["name"] = n0 + name_gain(kind)
		if kind != "risky":
			hunger += HUNGER_SAFE_WIN
	else:
		conf += int(CONF["ko_loss" if outcome == "ko" else "points_loss"])
	if kind == "risky":
		hunger += HUNGER_RISKY
	s["conf"] = clampi(conf, 0, 100)
	s["hunger"] = clampi(hunger, 0, 100)
	s["fights"] = int(s.get("fights", 0)) + 1
	return {"conf": int(s["conf"]) - c0, "hunger": int(s["hunger"]) - h0, "name": int(s["name"]) - n0}


## Weeks without a fight beyond the usual gap (the medical rest after a stoppage): -5 hunger each full four weeks.
static func rest(s: Dictionary, extra_weeks: int) -> int:
	var before := int(s.get("hunger", HUNGER_START))
	s["hunger"] = clampi(before + HUNGER_IDLE * int(maxi(0, extra_weeks) / IDLE_WEEKS), 0, 100)
	return int(s["hunger"]) - before


## Called at each booking of the first six (and the first one after): at 0 hunger the boxer asks to leave. "" nothing,
## "warn" a warning (shown on the card: s.warn of WARNINGS), "gone" the third booking at 0.
static func booking_check(s: Dictionary) -> String:
	if int(s.get("hunger", HUNGER_START)) > 0:
		return ""
	s["warn"] = int(s.get("warn", 0)) + 1
	return "gone" if int(s["warn"]) > WARNINGS else "warn"


## Whether the two-bout booking still applies (pro fights 1-6).
static func on(s: Dictionary) -> bool:
	return not s.is_empty() and int(s.get("fights", 0)) < FIGHTS


## The result page's one line: what the fight did to the two bars ("" when nothing moved).
static func bar_line(moved: Dictionary, s: Dictionary) -> String:
	var parts: Array = []
	for k in [["conf", "Confidence"], ["hunger", "Hunger"]]:
		var d := int(moved.get(k[0], 0))
		if d != 0:
			parts.append("%s %d → %d" % [k[1], int(s.get(k[0], 0)) - d, int(s.get(k[0], 0))])
	return ", ".join(parts)
