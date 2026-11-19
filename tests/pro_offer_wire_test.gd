extends SceneTree
## S523 TURNPRO1B: ProCall (Goose #376) wired into the game - who calls by the ticket forecast (both houses side by side
## within 15 of break-even, one alone outside it), no first call at 32+, the one ask (a counter, a won't, Back to the plain
## offer), signing with the guarantee house (6-week debut, the 1.5-under opponent, the costs from the purse), the debut
## night paying the purse cut as well as the tickets, Stay amateur (the same house next time), the 14-day window running out.
## Control arms: a forecast far over break-even calls the ticket house alone; an old save's offer (no "offers") still signs.

const Data := preload("res://scripts/state/Data.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const ProCall := preload("res://scripts/rules/ProCall.gd")
const ProDebut := preload("res://scripts/rules/ProDebut.gd")
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


func _keys(c: Career) -> Array:
	return (c.pro_offer.get("offers", []) as Array).map(func(t): return str(t["key"]))


func _initialize() -> void:
	# 1. Within 15 of the ticket house's break-even: both houses, side by side.
	var c := _career(60, 24)
	var f: Dictionary = c.fighter()
	Roster.check_pro(c)
	var fc := ProDebut.tickets_sold(60, 9, 0)
	_check(_keys(c) == ["bow", "hf"], "forecast %d (break-even %d): both houses call (%s)" % [fc, ProDebut.BREAK_EVEN, str(_keys(c))])
	_check(str(c.pro_offer.get("promoter", "")) == "Bow Lane Promotions" and int(c.pro_offer.get("purse", 0)) == 1500,
		"the old keys follow the first house (screens that read them keep working)")
	_check(int(c.pro_offer.get("expires", 0)) == c.day + ProCall.WINDOW_DAYS, "the offer stands 14 days")
	# 2. The one ask: a won't is not spent; the costs counter is taken; Back to the plain offer keeps it spent.
	var said := ProOfferWire.ask(c, "hf", "price", 20)
	_check(said.contains("will not") and not (c.pro_offer["asked"] as Dictionary).has("hf"), "a won't answer changes nothing and the ask is not spent")
	said = ProOfferWire.ask(c, "hf", "costs", 20)
	_check(bool(ProOfferWire.offer(c.pro_offer, "hf").get("costs_covered", false)) and said.contains("counters"), "the costs counter is taken: %s" % said)
	_check(ProOfferWire.ask(c, "hf", "later2", 20) == "", "one ask per offer: a second ask on the same house is refused")
	ProOfferWire.back_to_plain(c, "hf")
	_check(not bool(ProOfferWire.offer(c.pro_offer, "hf").get("costs_covered", false)) and ProOfferWire.ask(c, "hf", "softer", 20) == "",
		"Back to the plain offer: the plain terms, the ask still spent")
	_check(ProOfferWire.ask(c, "bow", "later4", 20).contains("+4 weeks"), "the other house keeps its own ask")
	# 3. Sign with the guarantee house: its terms reach the bout.
	var cash := c.cash
	var sheet := Roster.debut_sheet(c, f, 1.0)
	Roster.turn_pro(c, "hf")
	var bout: Dictionary = f["bout"]
	_check(str(f.get("promoter", "")) == "Harrow & Finch Boxing" and int(f["purse"]) == 1800, "signed with Harrow & Finch: $1,800")
	_check(int(bout["day"]) == Roster.debut_day(c.day, 6), "the guarantee house's debut is 6 weeks out")
	_check(c.cash == cash - int(sheet["costs"]), "the gym paid the signing costs (no costs ask on the plain offer)")
	var night := Roster.debut_night(c, f)
	_check(int(night["purse"]) == 1800 and int(night["gym"]) >= int(round(1800 * Roster.share_of(f))),
		"the debut night pays the purse cut too: gym %d of a %d purse" % [int(night["gym"]), int(night["purse"])])
	_check(Roster.debut_words(f, night).contains("Harrow & Finch"), "the debut news names the house's break-even")
	var hist: Control = load("res://scripts/ui/BoutHistory.gd").make(null, c, f)
	var mile: Node = hist.find_child("TurnedPro", true, false)
	_check(mile != null and str(mile.text).contains("HARROW & FINCH"), "History shows the milestone: %s" % (str(mile.text) if mile != null else "none"))
	hist.free()
	var GP: GDScript = load("res://scripts/rules/GymPeople.gd")
	_check(GP.buzz_members(c.fighters, c.day) == 10 and GP.buzz_members(c.fighters, c.day + 7) == 0,
		"the signing week: two more people on the gym floor, gone a week later (map M19)")
	# 4. The ticket house alone when the forecast is far over its break-even.
	var c2 := _career(150, 24)
	Roster.check_pro(c2)
	_check(_keys(c2) == ["bow"], "forecast %d: the ticket house alone" % ProDebut.tickets_sold(150, 9, 0))
	# 5. Stay amateur: the same house next time, and morale reads the ambition.
	var f2: Dictionary = c2.fighter()
	Roster.decline_pro(c2)
	_check(str(f2.get("pro_last_house", "")) == "bow" and int(f2["pro_declines"]) == 1, "Stay amateur: Bow Lane is the one to call again")
	# 6. The window runs out: no decline counted, the promoter waits 2 more wins.
	var c3 := _career(60, 24)
	var f3: Dictionary = c3.fighter()
	Roster.check_pro(c3)
	c3.day += ProCall.WINDOW_DAYS
	Roster.check_pro(c3)
	_check(c3.pro_offer.is_empty() and int(f3.get("pro_declines", 0)) == 0 and int(f3.get("pro_wait_w", 0)) == 11,
		"14 days with no answer: the offer goes, no decline, the next call after 2 more wins")
	Roster.check_pro(c3)
	_check(c3.pro_offer.is_empty(), "no new call before those wins")
	f3["w"] = 11
	Roster.check_pro(c3)
	_check(not c3.pro_offer.is_empty(), "the call comes back at 11 wins")
	# 6b. Topping our own club show: +10 ticket followers on the debut forecast (map M9).
	var c6 := _career(60, 24)
	var f6: Dictionary = c6.fighter()
	var before6 := ProOfferWire.forecast(c6, f6, 0)
	load("res://scripts/state/HomeBout.gd").boxed(c6, f6)
	_check(ProOfferWire.forecast(c6, f6, 0) == before6 + 10, "topping our club show: debut forecast %d -> %d" % [before6, ProOfferWire.forecast(c6, f6, 0)])
	# 7. Age: no first call at 32.
	var c4 := _career(60, 32)
	Roster.check_pro(c4)
	_check(c4.pro_offer.is_empty(), "age 32: no first call")
	# 8. Control: an old save's offer (no offers list) still signs on the S329 terms.
	var c5 := _career(60, 24)
	var f5: Dictionary = c5.fighter()
	c5.pro_offer = {"fid": f5["id"], "promoter": "Bow Lane Promotions", "purse": 1500, "terms": 1.0, "step": 500, "top": 3000}
	Roster.turn_pro(c5)
	_check(bool(f5.get("pro", false)) and int(f5["bout"]["day"]) == Roster.debut_day(c5.day) and (f5["bout"]["deal"] as Dictionary).is_empty(),
		"an old save's offer signs on the old terms")
	var modal: GDScript = load("res://scripts/ui/modals/ProOffer.gd")
	_check(modal != null and modal.can_instantiate(), "the offer screen's script loads")
	print("PRO_OFFER_WIRE %s failures=%d" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(0 if failures == 0 else 1)
