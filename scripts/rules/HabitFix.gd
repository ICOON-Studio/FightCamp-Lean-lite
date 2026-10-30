extends RefCounted
## S309 the corner minute's "one fix for a habit" (S308 plan point 5, approved "Build it, full 3:00"; old repo
## Godot/research/S308_FIGHT_TACTICS_PLAN.md). Her habits (FighterProfile.HABITS, Kalli's fight_habits.json) cost her in an
## exchange whose situation punishes them - Kalli's "punish" line names who: "A counter-puncher times the jab and lands a
## lead hook over it" -> drops_right_after_jab is punished when the opponent waits to counter. A habit punished in a round
## goes into the coach's notebook at the bell (he saw it happen); the corner can then fix ONE habit for the next round, the
## second of the two instructions a real corner gets through in the minute (J55), and it holds as far as she takes it in
## (Exchanges.uptake of her coachability). Pure static; zero preloads. HABIT_COST is a game-design value (a wrong call
## costs Exchanges.EDGE wrong 7), tuned with tools/exchange_balance.gd.

## Power points a punished habit costs her in one exchange.
const HABIT_COST := 6.0

## The situations (Exchanges.MODES keys) that punish each habit, from Kalli's punish lines. Habits that help her
## (digs_body_when_hurt) are never punished; slow_starter and fades_late go by the clock instead (EARLY / LATE).
const PUNISHED_BY := {
	"drops_right_after_jab": ["counter"],      # a counter-puncher lands the lead hook over the jab
	"freezes_on_ropes": ["press"],             # a volume puncher pins her there
	"switches_stance_under_pressure": ["press"],
	"talks_when_ahead": ["counter"],           # a calm opponent jabs while she talks
	"loads_up_when_hurt": ["she_hurt"],        # the wild hook is slipped and countered
	"covers_up_when_hurt": ["she_hurt"],       # the opponent keeps throwing and steals it on output
	"wide_hook_tell": ["counter", "range"],    # a straight cross beats the slow hook
	"retreats_straight_back": ["press"],       # walked straight into the corner
	"admires_her_work": ["counter"],
	"lunges_with_jab": ["range"],              # an out-boxer steps back and counters
	"head_down_inside": ["press"],             # the uppercut inside
	"clinches_when_tired": ["she_tired"],      # the body as she comes in to hold
	"bites_on_feints": ["counter"],
	"low_lead_hand": ["loadup"],               # the big right over the low left
	"one_and_done": ["press"],                 # out-thrown
	"chases_stoppage": ["hurt"],               # swarms onto the counter when the opponent is hurt
	"waits_too_long": ["range"],               # a busy opponent jabs her way to it
}
## Clock habits: slow_starter costs in round 1's first EARLY exchanges; fades_late in the bout's last round from LATE on.
const EARLY := 2
const LATE := 3


## The habit of hers this exchange punishes ("" = none; the first in her list wins). n = the round, i = the exchange
## (0..5), last = the bout's last round.
static func punished(habits: Array, sit: String, n: int, i: int, last: bool) -> String:
	for h in habits:
		var id := str(h)
		if id == "slow_starter" and n == 1 and i < EARLY:
			return id
		if id == "fades_late" and last and i >= LATE:
			return id
		if (PUNISHED_BY.get(id, []) as Array).has(sit):
			return id
	return ""


## Power points the punished habit costs this exchange (<= 0). hold = how much of the fix she took in (0..1).
static func cost(habit: String, fix: String, hold: float) -> float:
	if habit == "":
		return 0.0
	return -HABIT_COST * ((1.0 - clampf(hold, 0.0, 1.0)) if habit == fix else 1.0)


## A habit the corner can work on: one that can cost her after a corner (slow_starter costs only before the first one).
static func fixable(id: String) -> bool:
	return PUNISHED_BY.has(id) or id == "fades_late"


## The habits the corner can fix now: hers, seen by the coach (notes_seen "habit:<id>"), that can cost her.
static func offers(habits: Array, seen: Array) -> Array:
	var out: Array = []
	for h in habits:
		if fixable(str(h)) and seen.has("habit:" + str(h)):
			out.append(str(h))
	return out


## The line after an exchange in which a habit was punished. name = the habit's name from the bank ("Drops the right
## after the jab"); names = [hers, the opponent's]; held = the corner fixed it this round.
static func line(name: String, names: Array, held: bool) -> String:
	var what := name.substr(0, 1).to_lower() + name.substr(1)
	if held:
		return "The fix held: %s caught herself (%s)." % [str(names[0]), what]
	return "%s made %s pay for a habit: %s." % [str(names[1]), str(names[0]), what]
