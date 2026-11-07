extends RefCounted
## S397 money bites (ops/research/MONEY_BITES_S397.md 5): how the career harness's two players spend, through Main.act like
## a player. Sensible keeps two months of costs in the bank and buys in an order that pays; careless with the `spender`
## habit buys whatever the cash covers, books every show and keeps every share; careless without it never spends.
##   sensible  the fitness classes + an assistant coach first (they earn), then the floor, the youth section, the strength
##             corner; S&C once two people train, a physio after the first injury, a cutman once a fighter is pro; a show
##             when even a bad night loses little; a move when the gym is full; keep a share when the bonus leaves 3 months;
##             in a bad stretch (under a month of costs) lets the physio and S&C go and drops the kit to Low; the best amateur
##             keeps the club stipend, the others take a day job unless the bank holds 3 months

const Sim := preload("res://scripts/state/Sim.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const GymUpgrades := preload("res://scripts/rules/GymUpgrades.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const ClubShow := preload("res://scripts/rules/ClubShow.gd")
const StarDeal := preload("res://scripts/rules/StarDeal.gd")
const Grants := preload("res://scripts/rules/Grants.gd")

const ORDER := ["fitkit", "mats", "youth", "strength"]
const KEEP_MONTHS := 2.0


static func month(c: Career) -> float:
	return float(Sim.weekly_costs(c)["total"]) * GymBills.WEEKS_A_MONTH


static func spare(c: Career, months: float = KEEP_MONTHS) -> int:
	return c.cash - roundi(month(c) * months)


static func decide(main: Node, c: Career, sensible: bool, spender: bool) -> void:
	if sensible:
		_sensible(main, c)
	elif spender:
		_spender(main, c)


static func _sensible(main: Node, c: Career) -> void:
	for f in c.fighters:
		var t: Dictionary = f.get("talks", {})
		if not t.is_empty():
			var bonus := int(StarDeal.terms(f, str(t["step"]), int(t.get("take", 0)))["bonus"])
			main.act("talks", "%s|%s" % [f["id"], "keep" if spare(c, 3.0) >= bonus else "lower"])
	_stipends(main, c)
	if c.cash < roundi(month(c)):
		for r in ["physio", "strength"]:
			if c.staff_roles.has(r):
				main.act("letgorole", r)
				return
		if c.kit_level != "low":
			main.act("kitbudget", "low")
		return
	if c.kit_level == "low" and spare(c, 3.0) > 0:
		main.act("kitbudget", "standard")
	for id in ORDER:
		if GymUpgrades.has(c.upgrades, id):
			continue
		var price := int(GymUpgrades.item(id)["price"])
		if spare(c) >= price + (1200 if id == "fitkit" else 0):
			main.act("buyup", id)
			if id == "fitkit" and not c.staff_roles.has("assistant"):
				main.act("hirerole", "assistant")
		break   # one purchase in order: the next waits for its cash
	var people := c.fighters.size() + c.grapplers.size()
	if people >= 2 and not c.staff_roles.has("strength") and spare(c) > 2000:
		main.act("hirerole", "strength")
	var hurt := c.news.any(func(x): return str(x["t"]).contains(" is hurt "))
	if hurt and not c.staff_roles.has("physio") and spare(c) > 2000:
		main.act("hirerole", "physio")
	if c.fighters.any(func(f): return bool(f.get("pro", false))) and not c.staff_roles.has("cutman"):
		main.act("hirerole", "cutman")
	if c.members >= GymSpend.member_cap(c) - 2 and c.premises < GymUpgrades.PREMISES.size() - 1:
		var mv := int(GymUpgrades.premises(c.premises + 1)["move"])
		if spare(c, 3.0) >= mv:
			main.act("movepremises", "")
	# Round 2: coaches carry members; dues up when the place is full; a grant bid when it can go in.
	var lim := GymSpend.member_limit(c)
	if lim == "coaches" and spare(c) > 2000:
		main.act("hirerole" if not c.staff_roles.has("assistant") else "eveningcoach", "assistant" if not c.staff_roles.has("assistant") else "add")
	if lim == "premises" and c.dues_band == "standard":
		main.act("dues", "premium")
	if Grants.blocked(c.day, c.grant, GymSpend.youth_on(c), c.staff_roles.has("assistant") or c.extra_coaches > 0) == "":
		main.act("grantbid", "")
	var pv := GymSpend.show_preview(c)
	if int(pv["net_lo"]) > -800 and spare(c) >= ClubShow.COST and ClubShow.can_book(c.day, int(c.show.get("day", -1)), int(c.show.get("last", -1))):
		main.act("bookshow", "")


## The best amateur keeps the stipend; the others take a day job unless the bank holds 3 months of costs.
static func _stipends(main: Node, c: Career) -> void:
	var ams := c.fighters.filter(func(f): return not bool(f.get("pro", false)))
	ams.sort_custom(func(a, b): return _rating(a) > _rating(b))
	for i in ams.size():
		var f: Dictionary = ams[i]
		var want := i == 0 or spare(c, 3.0) > 0
		if want == bool(f.get("day_job", false)):
			main.act("stipend", "%s|%s" % [f["id"], "on" if want else "off"])


static func _rating(f: Dictionary) -> float:
	var t := 0.0
	for k in f["stats"]:
		t += float(f["stats"][k])
	return t


static func _spender(main: Node, c: Career) -> void:
	for f in c.fighters:
		if not (f.get("talks", {}) as Dictionary).is_empty():
			main.act("talks", "%s|keep" % f["id"])
	if c.kit_level != "good":
		main.act("kitbudget", "good")
	for id in ORDER:
		if not GymUpgrades.has(c.upgrades, id) and c.cash >= int(GymUpgrades.item(id)["price"]):
			main.act("buyup", id)
	for r in ["assistant", "strength", "physio", "cutman"]:
		if not c.staff_roles.has(r):
			main.act("hirerole", r)
	if GymUpgrades.move_blocked(c.premises, c.cash) == "":
		main.act("movepremises", "")
	if GymSpend.member_limit(c) == "coaches" and c.cash > 2000:
		main.act("eveningcoach", "add")
	if ClubShow.can_book(c.day, int(c.show.get("day", -1)), int(c.show.get("last", -1))) and c.cash >= ClubShow.COST:
		main.act("bookshow", "")
