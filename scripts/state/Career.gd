extends Resource
class_name Career
## The one career: plain data, no rules. Rules live in scripts/rules and scripts/state/Sim.gd; time in Clock.gd.

const Data := preload("res://scripts/state/Data.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const RivalPast := preload("res://scripts/rules/RivalPast.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const BjjSide := preload("res://scripts/rules/BjjSide.gd")
const ClubStart := preload("res://scripts/rules/ClubStart.gd")
const HeadCoach := preload("res://scripts/rules/HeadCoach.gd")

@export var gym_name: String = "Anvil Street Gym"
@export var city: String = "London"
@export var day: int = 0
@export var cash: int = 25000   # a new career starts with start_cash() (S324); 25000 is only an old save's default
@export var members: int = Membership.OPENING_MEMBERS
@export var reputation: int = 10
@export var coach: Dictionary = {}
@export var fighters: Array = []
@export var grapplers: Array = []   # S362 the no-gi athletes (NoGi, the belt road)
@export var bjj_side: Dictionary = {}   # S365 the no-gi classes as a business (BjjSide: members, churn); {} = its start
@export var applicant: Dictionary = {}
@export var guide: String = ""   # S387 FirstWeek: "sign" | "coach" | "week" | "go"; "" = no first-week guide
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
@export var world: Dictionary = {}   # S397 the WORLD1 pro tables (ProLadder); {} until a fighter turns pro
## S324 update 27 money that bites (GymBills): weeks in a row the cash ended a week below $0; at CLOSE_AFTER_WEEKS the gym
## closes (closed = the career is over: a summary, then load or a new career).
@export var weeks_below: int = 0
@export var closed: bool = false
## S325 the career's own dice for what should differ career to career (injuries); 0 on a save from before update 28.
@export var seed: int = 0
## S397 money bites (GymSpend, MONEY_BITES_S397 7.1): upgrades bought ({id, day}), staff roles beside the coach (ids), the
## premises tier, the kit budget a week, and the club show ({day: booked night or -1, last: the last night, night: result}).
@export var upgrades: Array = []
@export var staff_roles: Array = []
@export var premises: int = 0
@export var kit_level: String = "standard"
@export var show: Dictionary = {"day": -1, "last": -1}
## S397 round 2: the dues band (Membership.DUES), evening coaches beyond the staff jobs (each carries more members), and
## the year's grant bid ({} none; {due, amount} waiting for the answer; "last": the day of the last bid).
@export var dues_band: String = "standard"
@export var extra_coaches: int = 0
@export var grant: Dictionary = {}
## S397 rank 5 (ops/research/RANK5_FIRST_HOUR_S397.md): the player as head coach (HeadCoach: {name, bg}; {} = an old save, no
## edge), the start picked (ClubStart id; "" = an old save, read as "fresh"), the start's loan weeks left, and the first
## hour's own facts (FirstHour: the show, the second walk-in, the tasks; {} = no first hour).
@export var head: Dictionary = {}
@export var start: String = ""
@export var loan_weeks: int = 0
@export var first_hour: Dictionary = {}
## S399 the arranged overdraft (Overdraft): the player switches it on after 12 weeks of trading, the bank charges
## 16 % a year on the drawn balance weekly and pulls the facility after 12 consecutive weeks in the red.
@export var overdraft_on: bool = false
@export var overdraft_drawn_weeks: int = 0
@export var income_history: Array = []


static func quick_start(name: String = "Anvil Street Gym", town: String = "London", start_id: String = "fresh",
		head_coach: Dictionary = {}) -> Career:
	var c := Career.new()
	c.gym_name = name if name.strip_edges() != "" else "Anvil Street Gym"
	c.city = town
	c.seed = randi()
	c.start = ClubStart.valid(start_id)
	c.head = head_coach.duplicate()
	c.members = ClubStart.members(c.start)
	c.loan_weeks = int(ClubStart.loan(c.start)[1])
	c.cash = start_cash(c.start)
	c.applicant = ClubStart.walkin(c.start, Data.lucy())
	# S387 FirstWeek: the career opens on the boxer alone; Ana joins the mat at the end of week 1.
	c.bjj_side = BjjSide.start()
	c.cash_history = [{"w": 1, "c": c.cash}]
	for r in Data.OPPONENTS + [Data.MISMATCH] + Data.RIVALS:
		c.rivals.append((r as Dictionary).merged({"div": "wlw"}))
	for r in Data.DIVISION_RIVALS:
		c.rivals.append((r as Dictionary).duplicate(true))
	# S341 every rival's record bout by bout: an invented past that matches her W-L (RivalPast).
	for r in c.rivals:
		var others: Array = c.rivals.filter(func(o): return str(o.get("div", "")) == str(r.get("div", ""))).map(func(o): return [o["name"], o["club"]])
		r["bouts"] = RivalPast.seed(r, others, c.seed, c.day)
	for p in Data.PROSPECTS:
		c.prospects.append((p as Dictionary).merged({"state": "scout", "trial_day": -1}, false).duplicate(true))
	for d in Data.DEALS:
		c.deals.append((d as Dictionary).merged({"state": "locked" if bool(d["after_win"]) else "offer"}))
	for f in Data.FACILITIES:
		c.facilities.append((f as Dictionary).duplicate())
	c.add_news("%s opens its doors in %s with %d members on the books." % [c.gym_name, c.city, c.members])
	return c


## S397 rank 5: a new career from the create screen's picks (Main.create: name, coach, start); {} = Quick start's defaults.
static func from_create(create: Dictionary, name: String, town: String) -> Career:
	return quick_start(name, town, str(create.get("start", "fresh")), HeadCoach.make(str(create.get("name", "")), str(create.get("coach", ""))))


## Start cash: GymBills.START_MONTHS months of a first-year gym's costs - rent and fees, the first sessional coach and
## one fighter's stipend (S324: was $25,000, ~8 months of costs, so money never forced a decision).
## S397 rank 5: the start sets the months in the bank and the rent (ClubStart); "fresh" is the S324 three months.
## S397 money bites: the costs now include January's heating and power, insurance and the Standard kit budget.
static func start_cash(start_id: String = "fresh") -> int:
	var bills: Dictionary = GymBills.week({"members": ClubStart.members(start_id), "coaches": 1, "boxers": 1,
		"rent_mult": ClubStart.rent_mult(start_id), "month": 1})
	var week := int(bills["rent"]) + int(bills["fees"]) + int(bills["power"]) + int(bills["insurance"]) + 		int(GymBills.KIT_BUDGET["standard"]["week"]) + int(Data.coach("reid")["salary"]) + GameMoney.FIGHTER_STIPEND
	return roundi(float(week) * GymBills.WEEKS_A_MONTH * float(ClubStart.months(start_id)) / 100.0) * 100


## The first fighter signed (Lucy in a quick start), {} before anyone signs.
func fighter() -> Dictionary:
	return fighters[0] if not fighters.is_empty() else {}


func grappler_by_id(id: String) -> Dictionary:
	for f in grapplers:
		if str(f["id"]) == id:
			return f
	return {}


## The BJJ classes run while the gym has a no-gi athlete; true when one of them teaches the beginners' class.
func bjj_on() -> bool:
	return not grapplers.is_empty()


func bjj_teaches() -> bool:
	return grapplers.any(func(f): return bool(f.get("teaches", false)))


func fighter_by_id(id: String) -> Dictionary:
	for f in fighters:
		if str(f["id"]) == id:
			return f
	return {}


## mail = false for the world's own news (rival results, shows): it goes in the feed without lighting the Mail badge.
## own = the gym's own event for GYM > Records even when it lights no Mail badge (S388; a world story has neither).
func add_news(text: String, mail: bool = true, own: bool = false) -> void:
	news.push_front({"d": day, "t": text, "own": mail or own})
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
		(week_money.get_or_add("items", []) as Array).append(what)   # S352 the week review names what was paid


func rival(name: String) -> Dictionary:
	for r in rivals:
		if str(r["name"]) == name:
			return r
	return {}
