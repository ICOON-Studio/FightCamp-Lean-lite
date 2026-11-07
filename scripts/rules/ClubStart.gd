extends RefCounted
## S397 rank 5, P12 (docs/STRUCTURE_DESIGN_S395.md 5.8: "Pick a start: small club, in debt with one good boxer, or rich with
## big expectations. This doubles as difficulty"; operator Q-S294-121 "Yes"). Three starts, each a different first hour, not
## only different numbers (critics S397, ops/research/RANK5_FIRST_HOUR_S397.md section 8, point 6):
##   fresh   - three months of costs in the bank, 30 members, the walk-in as she is. Normal.
##   debt    - one month in the bank and a loan to repay; the walk-in is a better boxer who walks in 2.2 kg over. Hard.
##   backed  - six months in the bank, 40 members, bigger rooms (rent x1.5); the backers want the first show won, or
##             they take BACKERS_CLAWBACK back. Money is easy, the first night is not.
## Cash = months x the first year's weekly costs (GymBills + the first coach + one stipend), as Career.start_cash always did.
## Pure static; zero preloads.
##   ids()  card(id)  months(id)  members(id)  rent_mult(id)  loan(id) -> [per_week, weeks]  walkin(id, f) -> f changed

const LOAN_WEEK := 180
const LOAN_WEEKS := 26
## The debt start's boxer: a better prospect (potential, every stat) who has let the weight go.
const DEBT_POT := 90
const DEBT_STAT_BONUS := 4.0
const DEBT_WEIGHT_OVER := 2.2
## The backed start: what the backers take back if the first show is lost (about a sixth of their six months).
const BACKERS_CLAWBACK := 5000

const CARDS := [
	{"id": "fresh", "title": "Fresh doors", "level": "Normal", "months": 3, "members": 30, "rent": 1.0,
		"line": "Three months of bills in the bank, 30 members, one walk-in at reception.",
		"bite": "Keep the doors open while you find your feet."},
	{"id": "debt", "title": "In debt, one good boxer", "level": "Hard", "months": 1, "members": 24, "rent": 1.0,
		"line": "One month in the bank and a loan of $180 a week for 26 weeks. The walk-in is the best prospect in the area.",
		"bite": "The walk-in has let the weight go: 2.2 kg over for the first show."},
	{"id": "backed", "title": "Backed, big expectations", "level": "Risky", "months": 6, "members": 40, "rent": 1.5,
		"line": "Six months in the bank, 40 members and bigger rooms (rent x1.5), paid for by local backers.",
		"bite": "The backers want the first show won, or they take $5,000 back."},
]


static func ids() -> Array:
	return CARDS.map(func(c): return str(c["id"]))


static func card(id: String) -> Dictionary:
	for c in CARDS:
		if str(c["id"]) == id:
			return (c as Dictionary).duplicate()
	return (CARDS[0] as Dictionary).duplicate()


static func valid(id: String) -> String:
	return id if ids().has(id) else "fresh"


static func months(id: String) -> int:
	return int(card(id)["months"])


static func members(id: String) -> int:
	return int(card(id)["members"])


static func rent_mult(id: String) -> float:
	return float(card(id)["rent"])


## [per week, weeks] of the start's loan; [0, 0] without one.
static func loan(id: String) -> Array:
	return [LOAN_WEEK, LOAN_WEEKS] if id == "debt" else [0, 0]


static func backers(id: String) -> bool:
	return id == "backed"


## The walk-in for this start (a copy): the debt start's is better and heavier.
static func walkin(id: String, f: Dictionary) -> Dictionary:
	var g := f.duplicate(true)
	if id == "debt":
		g["pot"] = DEBT_POT
		for k in (g["stats"] as Dictionary).keys():
			g["stats"][k] = float(g["stats"][k]) + DEBT_STAT_BONUS
		g["weight"] = snappedf(float(g["limit"]) + DEBT_WEIGHT_OVER, 0.1)
	return g
