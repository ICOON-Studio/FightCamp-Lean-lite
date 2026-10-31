extends Resource
class_name Career
## The one career: plain data, no rules. Rules live in scripts/rules and scripts/state/Sim.gd; time in Clock.gd.

const Data := preload("res://scripts/state/Data.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")

@export var gym_name: String = "Anvil Street Gym"
@export var city: String = "London"
@export var day: int = 0
@export var cash: int = 25000   # a new career starts with start_cash() (S324); 25000 is only an old save's default
@export var members: int = Membership.OPENING_MEMBERS
@export var reputation: int = 10
@export var coach: Dictionary = {}
@export var fighters: Array = []
@export var applicant: Dictionary = {}
@export var news: Array = []
@export var unread: int = 0
@export var review_pending: bool = false
@export var last_report: Dictionary = {}
@export var week_money: Dictionary = {"in": 0, "out": 0}
@export var accrued: int = 0
@export var cash_history: Array = []
## Past results across the roster. (Since week 4 each fighter carries her own offers, bout, camp and office talk.)
@export var results: Array = []
## Week 3: the region's other amateurs (records move at club shows), sponsors, the kit, one-off money, her ranking.
@export var rivals: Array = []
@export var deals: Array = []
@export var facilities: Array = []
@export var ledger: Array = []
## Week 4: the prospects scouting knows (state scout | invited | trial | signed | passed).
@export var prospects: Array = []
## Week 4: a promoter's offer to turn a fighter pro ({} when none).
@export var pro_offer: Dictionary = {}
## S324 update 27 money that bites (GymBills): weeks in a row the cash ended a week below $0; at CLOSE_AFTER_WEEKS the gym
## closes (closed = the career is over: a summary, then load or a new career).
@export var weeks_below: int = 0
@export var closed: bool = false


static func quick_start(name: String = "Anvil Street Gym", town: String = "London") -> Career:
	var c := Career.new()
	c.gym_name = name if name.strip_edges() != "" else "Anvil Street Gym"
	c.city = town
	c.cash = start_cash()
	c.applicant = Data.lucy()
	c.cash_history = [{"w": 1, "c": c.cash}]
	for r in Data.OPPONENTS + [Data.MISMATCH] + Data.RIVALS:
		c.rivals.append((r as Dictionary).merged({"div": "wlw"}))
	for r in Data.DIVISION_RIVALS:
		c.rivals.append((r as Dictionary).duplicate(true))
	for p in Data.PROSPECTS:
		c.prospects.append((p as Dictionary).merged({"state": "scout", "trial_day": -1}, false).duplicate(true))
	for d in Data.DEALS:
		c.deals.append((d as Dictionary).merged({"state": "locked" if bool(d["after_win"]) else "offer"}))
	for f in Data.FACILITIES:
		c.facilities.append((f as Dictionary).duplicate())
	c.add_news("%s opens its doors in %s with %d members on the books." % [c.gym_name, c.city, c.members])
	return c


## Start cash: GymBills.START_MONTHS months of a first-year gym's costs - rent and fees, the first sessional coach and
## one fighter's stipend (S324: was $25,000, ~8 months of costs, so money never forced a decision).
static func start_cash() -> int:
	var bills: Dictionary = GymBills.week({"members": Membership.OPENING_MEMBERS, "coaches": 1, "boxers": 1})
	var week := int(bills["rent"]) + int(bills["fees"]) + int(Data.coach("reid")["salary"]) + GameMoney.FIGHTER_STIPEND
	return roundi(float(week) * GymBills.WEEKS_A_MONTH * float(GymBills.START_MONTHS) / 100.0) * 100


## The first fighter signed (Lucy in a quick start), {} before anyone signs.
func fighter() -> Dictionary:
	return fighters[0] if not fighters.is_empty() else {}


func fighter_by_id(id: String) -> Dictionary:
	for f in fighters:
		if str(f["id"]) == id:
			return f
	return {}


## mail = false for the world's own news (rival results, shows): it goes in the feed without lighting the Mail badge.
func add_news(text: String, mail: bool = true) -> void:
	news.push_front({"d": day, "t": text})
	if mail:
		unread += 1


## A one-off payment in (+) or out (-), for MONEY's Income and Bills. Moves the cash too.
func pay(amount: int, what: String) -> void:
	cash += amount
	ledger.push_front({"d": day, "t": what, "amount": amount})
	if amount > 0:
		week_money["in"] = int(week_money["in"]) + amount
	else:
		week_money["out"] = int(week_money["out"]) - amount


func rival(name: String) -> Dictionary:
	for r in rivals:
		if str(r["name"]) == name:
			return r
	return {}
