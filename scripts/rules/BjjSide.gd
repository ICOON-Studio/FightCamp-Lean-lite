extends RefCounted
## BjjSide - the gym's no-gi classes as a business (S365, Kalli K-BELTROAD1 part 4, Game/Godot/research/K_BELTROAD1_KALLI.md):
## its own members on their own dues, a hired coach for each class, and Ana's road as its sales pitch. Boxing gives the big
## nights; the BJJ side gives monthly members who stay.
## Real numbers (S365 search, posted club prices, GBP x 1.25 like GymBills):
## - Adult unlimited BJJ at small UK clubs GBP 75-120 a month (Cherry Blossom 75, Legacy London 87.50, Grow 98, EKBJJ 120;
##   London premium 135-179). Median of the four small clubs ~GBP 88 -> FEE_MONTH $110, about 3x the boxing club's GBP 28.
## - A jiu-jitsu instructor in the UK ~GBP 26-27 an hour (aggregator, London/Bristol) -> COACH_CLASS $34 a one-hour class.
##   Blue/purple belts assist with beginners at most academies (PushPress hiring guide), so Ana may take it from blue.
## - Gym churn 30-40% a year (general fitness; no BJJ-only source) -> CHURN_YEAR 0.35, leaving in whole members.
## GAME RULES, no source: START_MEMBERS 8 (Kalli), members per medal and per blue belt (no evidence that medals bring members
## was found; Kalli's numbers), and teaching costing her one of her own classes a week.
## Pure static; preloads only BeltRoad.
##   BjjSide.start() -> {members, churn}   week(side, ana_teaches) -> {dues, coach, net, left, ...}
##   medal(side, medal) / promoted(side, belt) -> members joined   can_teach(f) -> "" or why not

const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")

const FEE_MONTH := 110
const COACH_CLASS := 34
const ADULT_CLASSES := 3
const BEGINNER_CLASSES := 2
const WEEKS_A_MONTH := 4.33
const START_MEMBERS := 8
const CHURN_YEAR := 0.35
const MEDAL_MEMBERS := {"gold": 2, "silver": 1}
const BLUE_MEMBERS := 3
## Teaching the beginners' class takes one of her own evenings: she trains this many classes fewer a week.
const TEACH_CLASSES := 1
const TEACH_FROM := "blue"


static func start() -> Dictionary:
	return {"members": START_MEMBERS, "churn": 0.0}


static func dues_week(members: int) -> int:
	return roundi(float(maxi(0, members)) * float(FEE_MONTH) / WEEKS_A_MONTH)


## The hired coach's classes a week: the adult classes always, the beginners' class unless Ana teaches it.
static func coach_week(ana_teaches: bool) -> int:
	return COACH_CLASS * (ADULT_CLASSES + (0 if ana_teaches else BEGINNER_CLASSES))


## What teaching saves a week.
static func teach_saves() -> int:
	return COACH_CLASS * BEGINNER_CLASSES


## The week's money and churn, before the members leave: {dues, coach, net, members}. Pure: no change to `side`.
static func money(side: Dictionary, ana_teaches: bool) -> Dictionary:
	var m := int(side.get("members", START_MEMBERS))
	var d := dues_week(m)
	var co := coach_week(ana_teaches)
	return {"dues": d, "coach": co, "net": d - co, "members": m}


## One week: churn builds a member's worth at a time; whole members leave. Returns money() plus {"left"}.
static func week(side: Dictionary, ana_teaches: bool) -> Dictionary:
	var out := money(side, ana_teaches)
	var ch := float(side.get("churn", 0.0)) + float(out["members"]) * CHURN_YEAR / 52.0
	var left := int(floor(ch))
	side["churn"] = ch - left
	side["members"] = maxi(0, int(out["members"]) - left)
	out["left"] = left
	return out


## Members who join after a medal at an open ("gold", "silver", "bronze" or "").
static func medal(side: Dictionary, m: String) -> int:
	return join(side, int(MEDAL_MEMBERS.get(m, 0)))


## Members who join once when she is promoted to blue.
static func promoted(side: Dictionary, belt: String) -> int:
	return join(side, BLUE_MEMBERS if belt == "blue" else 0)


static func join(side: Dictionary, n: int) -> int:
	side["members"] = maxi(0, int(side.get("members", START_MEMBERS)) + n)
	return n


## "" when she may take the beginners' class, else why not.
static func can_teach(f: Dictionary) -> String:
	if BeltRoad.rank(str(f.get("belt", "white"))) < BeltRoad.rank(TEACH_FROM):
		return "%s can teach the beginners from %s belt." % [str(f.get("first", "The fighter")), TEACH_FROM]
	return ""
