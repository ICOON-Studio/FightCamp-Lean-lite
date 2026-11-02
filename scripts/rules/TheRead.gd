extends RefCounted
## S333 THE READ (operator S332 "Yes, build it"; asks: "how fast a fighter can read opponent pattern needs to be a factor",
## "every fighter needs a different trigger/threshold for the perfect move execution"). Per opponent habit (an Exchanges
## MODE she keeps playing) our fighter fills a read meter; she throws the counter when the read passes her trigger;
## the counter lands on read x mastery; punished twice, the opponent drops the habit.
## Real basis (Godot/research/J50_HOW_A_DEFENDER_DEFENDS.md s6 in the old repo): with one attack repeated every four
## actions, experts picked the pattern up after the 5th repetition and novices did not (Milazzo et al., J Sports Sci
## 2016); experts' edge is reading, not faster nerves (Mori 2002; Zhang 2022 meta-analysis); elite boxers bite on fakes
## more because they commit early (Ripoll 1995, via Gueldenpenning 2017) - the gambler. Pure static; zero preloads.

## Looks at a habit she needs to read it: the expert's 5 (Milazzo) at Ring IQ IQ_HIGH, LOOKS_NOVICE at IQ_LOW and below.
const LOOKS_EXPERT := 5.0
const LOOKS_NOVICE := 16.0
const IQ_LOW := 40.0
const IQ_HIGH := 85.0
## A 30-second exchange shows a habit about three times (~12 of her punches, one habit every four actions).
const LOOKS_PER_EXCHANGE := 3.0
## Film study: a fifth fewer looks needed, and her main habit starts part-read.
const FILM_LOOKS := 0.8
const FILM_HEAD_START := 0.2
## The trigger: the read she waits for. Discipline pulls it up, temper + confidence pull it down.
const TRIGGER_MID := 0.72
const TRIGGER_SWING := 0.004
const TRIGGER_MIN := 0.4
const TRIGGER_MAX := 0.95
const PATIENT_AT := 0.82
const GAMBLER_AT := 0.6
## "Wait for it" raises the trigger by this much.
const WAIT_SHIFT := 0.15
## A counter's landing chance: the read, times 0.5 + half her mastery of the counter (0-100).
const MASTERY_FLOOR := 0.5
## Counters landed on a habit before the opponent drops it ("Don't repeat yourself").
const DROP_AFTER := 2
## The opponent's games (Exchanges.MODES) that are habits to read, and the counter that punishes each: the pull/pivot
## hook on a presser, the right hand over a range jab, the check hook on a counter-puncher who follows her in, and the
## straight right down the middle of a wide loaded shot (Marquez on Pacquiao's right hand, J50 s6).
const COUNTER := {"press": "Lead hook", "range": "Cross", "counter": "Check hook", "loadup": "Cross"}
## A counter's worth in one exchange: one clean punch, about half a whole winning tactic (Exchanges.EDGE best 15); a miss
## a little under the wrong call's (EDGE wrong -7): she committed early and is open. Measured S333 (habit_fix_test,
## 400 even bouts): the read lifts an even bout 0.60 -> 0.62-0.65; LiveRound holds the counter back while her own unfixed
## habit is being punished, so fixing it still pays +0.05.
const EDGE_LANDED := 7.0
const EDGE_MISSED := -5.0
const DAMAGE := 0.0


## Looks she needs to read a habit, from her Ring IQ (fight_iq) and film study.
static func looks_needed(fight_iq: float, film: bool) -> float:
	var k := clampf((fight_iq - IQ_LOW) / (IQ_HIGH - IQ_LOW), 0.0, 1.0)
	var looks := lerpf(LOOKS_NOVICE, LOOKS_EXPERT, k)
	return looks * (FILM_LOOKS if film else 1.0)


## A fresh read for a bout. reads: an old state's meters to carry ({} for none); film_mode: the habit the tapes show most
## ("" without film study).
static func start(reads: Dictionary, film_mode: String) -> Dictionary:
	var st := {"read": reads.duplicate(), "punished": {}, "dropped": []}
	if film_mode != "":
		st["read"][film_mode] = maxf(float(st["read"].get(film_mode, 0.0)), FILM_HEAD_START)
	return st


## One exchange in which the opponent played this habit: the meter fills by the looks it showed.
static func watch(st: Dictionary, mode: String, fight_iq: float, film: bool) -> void:
	if (st["dropped"] as Array).has(mode):
		return
	var add := LOOKS_PER_EXCHANGE / looks_needed(fight_iq, film)
	st["read"][mode] = minf(1.0, float(st["read"].get(mode, 0.0)) + add)


static func read(st: Dictionary, mode: String) -> float:
	return float(st["read"].get(mode, 0.0))


## Her own trigger from her personality (FighterProfile traits 30-85): the read she waits for before the counter.
static func trigger(f: Dictionary) -> float:
	var p: Dictionary = f.get("personality", {})
	var patience := float(p.get("discipline", 50.0)) - (float(p.get("temper", 50.0)) + float(p.get("confidence", 50.0))) * 0.5
	return clampf(TRIGGER_MID + patience * TRIGGER_SWING, TRIGGER_MIN, TRIGGER_MAX)


## "patient" / "steady" / "gambler" for the card and the tale of the tape.
static func temperament(f: Dictionary) -> String:
	var t := trigger(f)
	return "patient" if t >= PATIENT_AT else ("gambler" if t <= GAMBLER_AT else "steady")


## The trigger after the corner's call: "wait" (Wait for it) raises it, "now" (Take it now) drops it to the read she has.
static func called(trig: float, call: String, now_read: float) -> float:
	if call == "wait":
		return minf(TRIGGER_MAX + WAIT_SHIFT, trig + WAIT_SHIFT)
	if call == "now":
		return minf(trig, now_read)
	return trig


static func fires(now_read: float, trig: float) -> bool:
	return now_read > 0.0 and now_read >= trig


## The chance the counter lands: how well she has read it x how well she throws it (MoveMastery 0-100).
static func land_chance(now_read: float, mastery: float) -> float:
	return clampf(now_read, 0.0, 1.0) * (MASTERY_FLOOR + (1.0 - MASTERY_FLOOR) * clampf(mastery, 0.0, 100.0) / 100.0)


## A counter landed on this habit; after DROP_AFTER she drops it and the read on it is gone.
static func punish(st: Dictionary, mode: String) -> void:
	var n := int(st["punished"].get(mode, 0)) + 1
	st["punished"][mode] = n
	if n >= DROP_AFTER and not (st["dropped"] as Array).has(mode):
		(st["dropped"] as Array).append(mode)
		st["read"][mode] = 0.0


static func dropped(st: Dictionary, mode: String) -> bool:
	return (st["dropped"] as Array).has(mode)


## The game she plays instead of a dropped one: the next habit in COUNTER's order she has not dropped (k rotates the
## start); the dropped game itself when she has dropped them all.
static func swap(st: Dictionary, mode: String, k: int) -> String:
	var games := COUNTER.keys()
	for j in games.size():
		var g := str(games[(k + j) % games.size()])
		if g != mode and not dropped(st, g):
			return g
	return mode


## "Read 60% of her Pressing - she goes at 80%" for the corner card.
static func line(now_read: float, trig: float, label: String) -> String:
	return "Read %d%% of the %s - goes at %d%%" % [roundi(now_read * 100.0), label, roundi(minf(trig, 1.0) * 100.0)]
