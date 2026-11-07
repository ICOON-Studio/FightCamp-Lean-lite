extends RefCounted
## S397 money bites (ops/research/MONEY_BITES_S397.md 7.1, STRUCTURE_DESIGN_S395 5.3b "stars earn less for the gym as they
## grow"): a pro's management contract is renegotiated at two moments - the first time the boxer enters the top 10, and the
## first belt. The gym keeps its share for a signing bonus, or takes a lower one; a share never slides by itself (round 1:
## a silent slide reads as a penalty for winning). A ranked pro's camp also has a bill the gym pays.
## Real anchors: filed manager contracts ~18%, caps 33 1/3%; prospects accept more, established boxers push to 10-15%;
## camp costs often fall on the manager (G71). The gym's start share 25% (manager 15% + trainer 10%, J-PRODEBUT1).
## GAME values: the steps, the bonuses and the 6% camp bill, sized so the gym's net a bout still rises with rank.

const START := 0.25
const STEPS := {"top10": {"share": 0.20, "bonus": 2500, "words": "the top 10"}, "belt": {"share": 0.17, "bonus": 5000, "words": "a belt"}}
## S397 round 2 (critic A: "talks always end the same way"): after the first talks the contract comes up EVERY YEAR; the
## bigger firm's ask is a share of what the pro earned the gym in the last year, or the share drops two points (not below
## FLOOR, the trainer's 10% plus a little management).
const YEAR_DAYS := 364
const YEAR_BONUS := 0.4
const YEAR_STEP := 0.02
const FLOOR := 0.12
const CAMP_SHARE := 0.06
const STRENGTH_CAMP := 0.5


static func share(f: Dictionary) -> float:
	return float(f.get("gym_share", START))


## The renegotiation now due for this pro ("" none): top10 at rank 1-10, belt once a belt is held.
static func due(f: Dictionary, rank: int, belt: String, day: int = 0) -> String:
	var done: Array = f.get("renewed", [])
	if belt != "" and not done.has("belt"):
		return "belt"
	if rank > 0 and rank <= 10 and not done.has("top10"):
		return "top10"
	if not done.is_empty() and day >= int(f.get("talks_day", 0)) + YEAR_DAYS:
		return "year"
	return ""


## The two answers: keep the share for the bonus, or take the step's lower share (never above the current one). `take` =
## what the pro earned the gym in the last year (the yearly talks' ask).
static func terms(f: Dictionary, step: String, take: int = 0) -> Dictionary:
	if step == "year":
		return {"keep": share(f), "bonus": maxi(500, roundi(float(take) * YEAR_BONUS / 100.0) * 100),
			"lower": maxf(FLOOR, share(f) - YEAR_STEP), "words": "another year on the contract"}
	var s: Dictionary = STEPS[step]
	return {"keep": share(f), "bonus": int(s["bonus"]), "lower": minf(share(f), float(s["share"])), "words": s["words"]}


static func camp_bill(purse: int, strength_coach: bool) -> int:
	return roundi(float(purse) * CAMP_SHARE * (STRENGTH_CAMP if strength_coach else 1.0))


## The gym's net from one ranked pro bout: its share of purse and tickets, less the camp bill.
static func gym_net(purse: int, tickets: int, gym_share: float, strength_coach: bool = false) -> int:
	return roundi(float(purse + tickets) * gym_share) - camp_bill(purse, strength_coach)
