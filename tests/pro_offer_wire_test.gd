extends SceneTree
## S523 TURNPRO1B (ProCall wired into the game), cut to v17 by S543 TURNPROBUILD17 (map DESIGN_TURNPRO1_V17.md: one
## promoter, one offer, no asks, no 14-day window). Deleted with their rules: who calls by the ticket forecast (two houses
## side by side, the ticket house alone), the one ask (won't / counter / Back to the plain offer), signing with the
## guarantee house, Stay amateur's same house next time, the window running out, the debut night at the deal's own price
## (docs/TURNPROBUILD17_RESULT.md lists each). Kept: one offer on the old keys, the club show's followers on the forecast,
## no first call at 32, signing pays the costs, the History milestone, the signing week's buzz, an old save's offer signs.

const Data := preload("res://scripts/state/Data.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const ProOfferWire := preload("res://scripts/state/ProOfferWire.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _career(members: int, age: int) -> Career:
	var c := Career.quick_start()
	c.seed = 11
	c.members = members
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	f["w"] = 9
	f["l"] = 1
	f["offers"] = []
	f["age"] = age
	f["loyalty"] = 60
	return c


func _initialize() -> void:
	# 1. One promoter, one offer, on the old keys the screens read.
	var c := _career(60, 24)
	var f: Dictionary = c.fighter()
	Roster.check_pro(c)
	_check(str(c.pro_offer.get("promoter", "")) == Roster.PROMOTER and int(c.pro_offer.get("purse", 0)) == 1500 and not c.pro_offer.has("offers"),
		"one promoter, one offer: %s, $%d" % [c.pro_offer.get("promoter", "?"), int(c.pro_offer.get("purse", 0))])
	# 2. Sign: the gym pays the costs; the History tab shows the milestone; the signing week brings two more people in.
	var cash := c.cash
	var sheet := Roster.debut_sheet(c, f, 1.0)
	Roster.turn_pro(c)
	_check(c.cash == cash - int(sheet["costs"]), "the gym paid the signing costs")
	var hist: Control = load("res://scripts/ui/BoutHistory.gd").make(null, c, f)
	var mile: Node = hist.find_child("TurnedPro", true, false)
	_check(mile != null and str(mile.text).contains(Roster.PROMOTER.to_upper()), "History shows the milestone: %s" % (str(mile.text) if mile != null else "none"))
	hist.free()
	var GP: GDScript = load("res://scripts/rules/GymPeople.gd")
	_check(GP.buzz_members(c.fighters, c.day) == 10 and GP.buzz_members(c.fighters, c.day + 7) == 0,
		"the signing week: two more people on the gym floor, gone a week later (map M19)")
	# 3. Topping our own club show: +10 ticket followers on the debut forecast (map M9).
	var c6 := _career(60, 24)
	var f6: Dictionary = c6.fighter()
	var before6 := ProOfferWire.forecast(c6, f6, 0)
	load("res://scripts/state/HomeBout.gd").boxed(c6, f6)
	_check(ProOfferWire.forecast(c6, f6, 0) == before6 + 10, "topping our club show: debut forecast %d -> %d" % [before6, ProOfferWire.forecast(c6, f6, 0)])
	# 4. Age: no first call at 32.
	var c4 := _career(60, 32)
	Roster.check_pro(c4)
	_check(c4.pro_offer.is_empty(), "age 32: no first call")
	# 5. Control: an old save's offer (no pairs, no rival key) still signs; the debut is the pair.
	var c5 := _career(60, 24)
	var f5: Dictionary = c5.fighter()
	c5.pro_offer = {"fid": f5["id"], "promoter": "Bow Lane Promotions", "purse": 1500, "terms": 1.0, "step": 500, "top": 3000}
	Roster.turn_pro(c5)
	_check(bool(f5.get("pro", false)) and int(f5["pro_due"]) == Roster.debut_day(c5.day) and (f5.get("pro_pair", {}) as Dictionary).has("risky"),
		"an old save's offer signs; the debut is picked from two bouts")
	var modal: GDScript = load("res://scripts/ui/modals/ProOffer.gd")
	_check(modal != null and modal.can_instantiate(), "the offer screen's script loads")
	print("PRO_OFFER_WIRE %s failures=%d" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(0 if failures == 0 else 1)
