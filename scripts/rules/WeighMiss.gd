extends RefCounted
## S539 owner "build the weigh-in miss answers for pro bouts" (after MMAEMPIRE1_COMPARE.md section 2, in our own words):
## a PRO boxer who misses weight no longer just loses the bout. The other corner answers, and the player decides.
## Real pro boxing: the bout often goes ahead with the boxer who missed giving up part of the purse to the opponent; a big
## miss and the other side walks. Pure rules; Bouts.weigh / WeighMissWire apply them.
##   over <= FIGHT_UP_TO          -> "fight": they take FORFEIT of the purse and box.
##   over >  WALK_OVER            -> "walk": too heavy to box safely; the bout is off, no choice.
##   in between                    -> "terms" (they want TERMS of the purse) or "walk"; a tough style walks half as often.
## The player then picks: box (pay the share, box drained: GuardWear "missed_weight") or pull out (today's empty-slot path).

const FORFEIT := 0.20
const TERMS := 0.35
const FIGHT_UP_TO := 0.5
const WALK_OVER := 2.5
## Styles that would rather box than wait for another date.
const TOUGH := ["Slugger", "Pressure fighter"]


## The other corner's answer. over = kg over the limit (> 0), roll in [0, 1).
static func answer(over: float, opp_style: String, roll: float) -> String:
	if over <= FIGHT_UP_TO:
		return "fight"
	if over > WALK_OVER:
		return "walk"
	var p_walk := (over - FIGHT_UP_TO) / (WALK_OVER - FIGHT_UP_TO)
	if TOUGH.has(opp_style):
		p_walk *= 0.5
	return "walk" if roll < p_walk else "terms"


## What boxing costs the boxer's purse (0 when the bout cannot go ahead).
static func price(ans: String, purse: int) -> int:
	match ans:
		"fight":
			return roundi(purse * FORFEIT)
		"terms":
			return roundi(purse * TERMS)
	return 0


## True when the player may still box.
static func can_box(ans: String) -> bool:
	return ans == "fight" or ans == "terms"


## The corner's answer in game words (no names in body text; the header carries them).
static func words(ans: String, over: float, cost: int) -> String:
	match ans:
		"fight":
			return "%.1f kg over. Their corner will still box - for %d%% of the purse ($%d)." % [over, roundi(FORFEIT * 100), cost]
		"terms":
			return "%.1f kg over. Their corner wants %d%% of the purse ($%d) to box at all." % [over, roundi(TERMS * 100), cost]
	return "%.1f kg over. Their corner walks: too heavy to box safely. The bout is off." % over


## Hover text: what each path costs and why it matters.
const TIP_BOX := "Box drained: the cut is not finished, so the guard wears faster all night (+18%). The share comes out of the boxer's purse, so the gym's cut shrinks with it."
const TIP_PULL := "Pull out: no purse, the gym pays for the empty slot and the next offer is a week away. The boxer stays fresh."
