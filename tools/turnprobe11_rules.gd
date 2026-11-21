extends RefCounted
## TURNPROBE11 (S534) GREYBOX - NOT GAME CODE. Map v11's proposed turning-pro numbers (ops/research/DESIGN_TURNPRO1_V11.md
## sections 3 to 5) as a LOCAL COPY for tools/turnprobe11.gd, so the map can be measured before any critic scores it and
## before anything under scripts/ is touched (S534 DEPTH METHOD). Every constant here is the MAP's proposal; the game's own
## rules (ProCall, DebutPick, BoutFinish) are the control arm and are called, never copied.

const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")
const DebutRead := preload("res://scripts/rules/DebutRead.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const ProOfferWire := preload("res://scripts/state/ProOfferWire.gd")
const Recruit := preload("res://scripts/rules/Recruit.gd")
const Roster := preload("res://scripts/state/Roster.gd")

const HF_PURSE := 1400          ## v11: the guarantee purse (today 1800)
const STYLE := {"bow": ["Pressure fighter", "Loads up when hit"], "hf": ["Out-boxer", "Backs onto the ropes"]}   ## each house's debutant
const WEEK_POINT := 0.01        ## the read counts the camp weeks: 1 point a week of debut_weeks
const GAP_MIN := -6.0
const GAP_MAX := 14.0
const PRICE_FEE := 270          ## own ticket price: off the purse before the split ($40 tickets, +15 seats as today)
const PRICE_TICKET := 40
const PRICE_SEATS := 15
const SOFTER_FEE := 300
const SOFTER_GAP := 1.0
const LATER_FEE := 150
const LATER_WEEKS := 2
const COSTS_FEE := 100
const COSTS_FLOOR := 500        ## the purse the costs ask must leave
const COSTS_LOYALTY := -6
const CROWD_BASE := 5           ## ticket house win crowd: 5 + 1 for every 10 seats sold on the night, 15 at most
const CROWD_PER := 10
const CROWD_TOP := 15
const PAY_OVER := 1000          ## +1 loyalty for every $150 of debut pay over $1,000, +4 at most
const PAY_STEP := 150
const PAY_TOP := 4
const WISH_MORALE := 5
const WISH_LOYALTY := -3


## The boxer's wish, read once at the call: "hf" (a day job wants the guaranteed purse), "bow" (the title goal wants the test), "".
static func wish(f: Dictionary) -> String:
	if bool(f.get("day_job", false)):
		return "hf"
	if Recruit.ambition(f).to_lower().contains("title"):
		return "bow"
	return ""


## The asks a house grants under v11 (no "won't" buttons). gate = the costs ask's cash crunch.
static func asks(house: String, gate: bool) -> Array:
	if house == "bow":
		return ["none", "price", "softer", "later2"]
	return ["none", "later2", "costs"] if gate else ["none", "later2"]


## The chance the v11 card shows: the game's read of the house's own debutant, plus a point a camp week.
static func card(f: Dictionary, t: Dictionary, coach: float) -> float:
	var house := str(t.get("key", ""))
	var opp: Dictionary = DebutOpp.make(f, float(t.get("opp_gap", 0.0)), int(t.get("opp_day", 0)), str(t.get("name", "")))
	if STYLE.has(house):
		opp["style"] = STYLE[house][0]
		opp["weak"] = STYLE[house][1]
	var fx: Dictionary = f.duplicate()
	fx["pro"] = true
	fx["bout"] = {"tank_ahead": 0.0, "pro": true, "rounds": DebutRead.ROUNDS}
	var out: Dictionary = BoutRead.CardOdds.result(BoutRead.round_edges(fx, opp, {"protocol": BoutRead.USUAL_CAMP}, coach), BoutRead.RingDuel.FORM_SD)
	return float(out["win"]) + WEEK_POINT * float(int(t.get("debut_weeks", 4)))


## DebutPick's search on the v11 card: the gap whose shown chance is nearest the house's target for this boxer.
static func repick(f: Dictionary, t: Dictionary, coach: float) -> float:
	var want := float(t.get("opp_target", 0.65))
	var lo := roundi(GAP_MIN * 10.0)
	var hi := roundi(GAP_MAX * 10.0)
	var t2: Dictionary = t.duplicate()
	while hi - lo > 1:
		var mid := (lo + hi) >> 1
		t2["opp_gap"] = float(mid) * 0.1
		if card(f, t2, coach) < want:
			lo = mid
		else:
			hi = mid
	t2["opp_gap"] = float(lo) * 0.1
	var r_lo := card(f, t2, coach)
	t2["opp_gap"] = float(hi) * 0.1
	var r_hi := card(f, t2, coach)
	return snappedf(float(hi if absf(r_hi - want) <= absf(r_lo - want) else lo) * 0.1, 0.1)


## Signs the house under v11: purse, re-picked debutant, one ask, the wish. Returns what the card showed and what was paid.
static func sign(c: Career, f: Dictionary, house: String, ask: String, hf_purse: int, wish_on: bool) -> Dictionary:
	var o: Dictionary = c.pro_offer
	var coach := float(c.coach.get("rating", 0.0))
	var t: Dictionary = ProOfferWire.offer(o, house).duplicate()
	if house == "hf":
		t["purse"] = int(round(float(hf_purse) * float(t.get("factor", 1.0))))
	t["opp_gap"] = repick(f, t, coach)
	var plain := card(f, t, coach)
	var covered := 0
	match ask:
		"price":
			t["purse"] = maxi(0, int(t["purse"]) - PRICE_FEE)
			t["price"] = PRICE_TICKET
			t["extra_tickets"] = PRICE_SEATS
		"softer":
			t["purse"] = maxi(0, int(t["purse"]) - SOFTER_FEE)
			t["opp_gap"] = float(t["opp_gap"]) + SOFTER_GAP
		"later2":
			t["purse"] = maxi(0, int(t["purse"]) - LATER_FEE)
			t["debut_weeks"] = int(t["debut_weeks"]) + LATER_WEEKS
		"costs":
			var costs := int(Roster.debut_sheet(c, f, 1.0)["costs"])
			covered = clampi(int(t["purse"]) - COSTS_FEE - COSTS_FLOOR, 0, costs)
			t["purse"] = int(t["purse"]) - covered - COSTS_FEE
			Loyalty.commit(f, COSTS_LOYALTY, "probe_costs_ask", c.day)   # before the share is read
	var shown := card(f, t, coach)
	var list: Array = o["offers"]
	for i in list.size():
		if str(list[i]["key"]) == house:
			list[i] = t
	var w := wish(f) if wish_on else ""
	Roster.turn_pro(c, house)
	if covered > 0:
		c.pay(covered, "PROBE v11: the promoter covers part of the signing costs")
	if STYLE.has(house):
		f["bout"]["opp"]["style"] = STYLE[house][0]
		f["bout"]["opp"]["weak"] = STYLE[house][1]
	if w != "":
		f["morale"] = clampf(float(f.get("morale", 50.0)) + (WISH_MORALE if w == house else -WISH_MORALE), 0.0, 100.0)
		if w != house:
			Loyalty.commit(f, WISH_LOYALTY, "probe_wish_refused", c.day)
	return {"gap": float(t["opp_gap"]), "plain": plain, "shown": shown, "covered": covered, "wish": w}


## The night's lasting effects under v11, applied after the game's own result. b = {members, rep, morale} before the bell.
static func after_debut(c: Career, f: Dictionary, house: String, b: Dictionary, sold: int, her: int, outcome: String) -> Dictionary:
	var out := {"crowd": BoutRules.WIN_MEMBERS if outcome == "win" else 0, "pay_loyalty": 0}
	if house == "bow" and outcome == "win":
		var crowd := mini(CROWD_TOP, CROWD_BASE + int(sold / CROWD_PER))
		c.members += crowd - BoutRules.WIN_MEMBERS
		out["crowd"] = crowd
	elif house == "bow" and outcome == "loss":   # the test's loss is forgiven: no member leaves, half the reputation and morale cost
		c.members = maxi(c.members, int(b["members"]))
		c.reputation += int((int(b["rep"]) - c.reputation) / 2)
		f["morale"] = float(f.get("morale", 50.0)) + maxf(0.0, float(b["morale"]) - float(f.get("morale", 50.0))) / 2.0
	var n := clampi(int((her - PAY_OVER) / PAY_STEP), 0, PAY_TOP)
	if n > 0:
		Loyalty.commit(f, n, "probe_debut_pay", c.day)
	out["pay_loyalty"] = n
	return out
