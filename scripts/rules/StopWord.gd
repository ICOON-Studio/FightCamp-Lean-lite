extends RefCounted
## STOPWORD1 (S513): the Ask card's stoppage word. The card says the chance IN WORDS ONLY - "unlikely / possible / a real
## risk" - never a number the player can sort by (ops/research/ASKFIGHT_MAP_S441.md s4). gap = the opponent's rating minus
## our boxer's fight power (BoutRules.fight_power), the same gap AskFlow.teach_word reads. Pure: no preload, no career.
## why: the rating edges are read off docs/STOPWORD1_RESULT.md (960 real bouts of the TEST CLUB's three boxers, seed 4421).

## The chance edges the brief sets, on OUR boxer being stopped (not on either side being stopped).
const CHANCE_POSSIBLE := 0.08
const CHANCE_RISK := 0.20
## The rating edges read off that table's MONOTONE BLOCKS (2.5-point bins, adjacent violators pooled: one 60-bout row is
## noisy and the three chins differ). Under 0 the blocks stop our boxer 1.7-5.3 % of the time, 0 to 7.5 they stop it 9.2 %,
## 10 to 12.5 they stop it 41.7 %. The 8 % edge falls between the measured -0.17 and +0.57 (midpoint +0.20), the 20 % edge
## in the hole between +5.57 and +10.58 (midpoint +8.08); each is rounded to the nearest half point and still separates
## every block. A bigger gap never reads safer.
const POSSIBLE_GAP := 0.0
const RISK_GAP := 8.0


## The stoppage word for a rating gap: a bigger gap never reads safer.
static func word(gap: float) -> String:
	if gap < POSSIBLE_GAP:
		return "unlikely"
	if gap < RISK_GAP:
		return "possible"
	return "a real risk"
