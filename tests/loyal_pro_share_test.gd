extends SceneTree
## S485 CLUBWEEK1 (his Q-244 "Yes, they can leave"): turning pro under 50 loyalty = an outside manager, the club keeps 10%
## (the trainer's share) instead of 25%. Control arm: a Settled fighter keeps the usual 25%.

const Data := preload("res://scripts/state/Data.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _signed(loyal: int) -> Dictionary:
	var c := Career.quick_start()
	c.seed = 7
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	f["w"] = 9
	f["l"] = 1
	f["offers"] = []
	f["loyalty"] = loyal
	Roster.check_pro(c)
	_check(not c.pro_offer.is_empty(), "loyalty %d: a promoter offers a pro contract at 9-1" % loyal)
	var before := Roster.signing_share(f)
	if not c.pro_offer.is_empty():
		Roster.turn_pro(c)
	return {"before": before, "after": Roster.share_of(f), "news": "\n".join(c.news.map(func(n): return str(n.get("t", "")) if n is Dictionary else str(n)))}


func _initialize() -> void:
	var low := _signed(40)
	_check(is_equal_approx(float(low["before"]), 0.10), "loyalty 40: the offer shows 10%% (%.2f)" % float(low["before"]))
	_check(is_equal_approx(float(low["after"]), 0.10), "loyalty 40: the club keeps 10%% of her purses (%.2f)" % float(low["after"]))
	_check(str(low["news"]).contains("outside manager"), "loyalty 40: the news says an outside manager signs her")
	var ok := _signed(62)
	_check(is_equal_approx(float(ok["after"]), Roster.GYM_SHARE), "loyalty 62: the club keeps the usual %.2f (%.2f)" % [Roster.GYM_SHARE, float(ok["after"])])
	_check(not str(ok["news"]).contains("outside manager"), "loyalty 62: no outside manager")
	var modal: GDScript = load("res://scripts/ui/modals/ProOffer.gd")
	_check(modal != null and modal.can_instantiate(), "the pro offer screen's script loads (it shows the 10% line)")
	print("LOYAL_PRO_SHARE %s fails=%d" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(0 if failures == 0 else 1)
