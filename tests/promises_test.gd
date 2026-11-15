extends SceneTree
## PROMISE1 test: Promises.gd, promises to a fighter (ops/research/TASK_PROMISE1.md).
## Prints "  ok   <what>" / "  FAIL <what>" per check and ends with
##   PROMISES PASS fails=0 or PROMISES FAIL fails=<n>.
## Run: godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/promises_test.gd

const Promises := preload("res://scripts/rules/Promises.gd")

var failures := 0


func _initialize() -> void:
	_listed()
	_make()
	_resolve_show()
	_blocks()
	_turn_pro()
	_no_signing()
	_line()
	if failures == 0:
		print("PROMISES PASS fails=0")
	else:
		print("PROMISES FAIL fails=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("  ok   ", label)
	else:
		failures += 1
		print("  FAIL ", label)


func _listed() -> void:
	_check(Promises.SHOW_TOP == "show_top" and Promises.TURN_PRO == "turn_pro" and Promises.NO_SIGNING == "no_signing",
		"kinds are show_top / turn_pro / no_signing")
	_check(Promises.KEPT == 10 and Promises.BROKEN == -12 and Promises.MADE == 4 and Promises.PRO_NEAR == 2,
		"KEPT 10, BROKEN -12, MADE 4, PRO_NEAR 2")
	_check(Promises.listed(Promises.SHOW_TOP, {"can_book": true, "bouts_open": 2}) == true,
		"listed show_top can_book true bouts_open 2 -> true")
	_check(Promises.listed(Promises.SHOW_TOP, {"can_book": true, "bouts_open": 0}) == false,
		"listed show_top bouts_open 0 -> false")
	_check(Promises.listed(Promises.SHOW_TOP, {"can_book": false, "bouts_open": 2}) == false,
		"listed show_top can_book false -> false")
	_check(Promises.listed(Promises.TURN_PRO, {"wins_to_pro": 2}) == true,
		"listed turn_pro wins_to_pro 2 -> true")
	_check(Promises.listed(Promises.TURN_PRO, {"wins_to_pro": 3}) == false,
		"listed turn_pro wins_to_pro 3 -> false")
	_check(Promises.listed(Promises.NO_SIGNING, {"scouted_in_class": false}) == false,
		"listed no_signing scouted_in_class false -> false")
	_check(Promises.listed(Promises.NO_SIGNING, {"scouted_in_class": true}) == true,
		"listed no_signing scouted_in_class true -> true")
	_check(Promises.listed("unknown", {"can_book": true, "bouts_open": 2, "wins_to_pro": 0, "scouted_in_class": true}) == false,
		"listed unknown kind -> false")


func _make() -> void:
	var empty: Array = []
	var r1: Dictionary = Promises.make(empty, "danny", Promises.SHOW_TOP, 124, 91)
	_check(bool(r1["ok"]) == true, "make show_top danny by_day 124 on day 91 -> ok")
	_check(empty.size() == 0, "input list unchanged in size after make (new array came back)")
	var list1: Array = r1["list"]
	_check(list1.size() == 1, "new list has the one promise")
	var p1: Dictionary = list1[0]
	_check(str(p1["fid"]) == "danny" and str(p1["kind"]) == "show_top" and int(p1["by_day"]) == 124
		and str(p1["state"]) == "open" and int(p1["made_day"]) == 91 and str(p1["wclass"]) == "",
		"promise is danny show_top by_day 124 open made_day 91 wclass empty")
	_check(Promises.open_for(list1, "danny").size() == 1, "open_for danny has the one open promise")
	_check(Promises.open_for(list1, "lucy").size() == 0, "open_for lucy is empty")
	var r2: Dictionary = Promises.make(list1, "danny", Promises.SHOW_TOP, 124, 91)
	_check(bool(r2["ok"]) == false and str(r2["why"]) == "already promised",
		"second show_top for danny -> ok false already promised")
	_check(list1.size() == 1, "input list still size 1 after refused make")
	var r3: Dictionary = Promises.make([], "danny", Promises.SHOW_TOP, 90, 91)
	_check(bool(r3["ok"]) == false and str(r3["why"]) == "the date has passed",
		"by_day 90 on day 91 -> the date has passed")
	var r4: Dictionary = Promises.make([], "danny", Promises.NO_SIGNING, 90, 91, "60 kg")
	_check(bool(r4["ok"]) == false and str(r4["why"]) == "the date has passed",
		"no_signing by_day 90 on day 91 -> the date has passed")


func _show_list() -> Array:
	var r: Dictionary = Promises.make([], "danny", Promises.SHOW_TOP, 124, 91)
	var out: Array = r["list"]
	return out


func _resolve_show() -> void:
	var list1: Array = _show_list()
	var p: Dictionary = list1[0]
	var rb: Dictionary = Promises.resolve(p, {"day": 124, "fit": false, "made_weight": true, "boxed": true,
		"turned_pro": false, "signed_in_class": false})
	_check(str(rb["state"]) == "broken" and int(rb["loyalty"]) == -12 and bool(rb["leaves"]) == true
		and str(rb["line"]) == "broken: missed our show",
		"show day 124 fit false -> broken -12 leaves true")
	var rk: Dictionary = Promises.resolve(p, {"day": 124, "fit": true, "made_weight": true, "boxed": true,
		"turned_pro": false, "signed_in_class": false})
	_check(str(rk["state"]) == "kept" and int(rk["loyalty"]) == 10 and bool(rk["leaves"]) == false
		and str(rk["line"]) == "kept: top of our show",
		"show day 124 fit made_weight boxed -> kept +10 leaves false")
	var re: Dictionary = Promises.resolve(p, {"day": 120, "fit": true, "made_weight": true, "boxed": true,
		"turned_pro": false, "signed_in_class": false})
	_check(str(re["state"]) == "open" and int(re["loyalty"]) == 0 and bool(re["leaves"]) == false,
		"show day 120 -> still open 0")
	var kept_p: Dictionary = p.duplicate(true)
	kept_p["state"] = "kept"
	var rn: Dictionary = Promises.resolve(kept_p, {"day": 124, "fit": false, "made_weight": false, "boxed": false,
		"turned_pro": false, "signed_in_class": false})
	_check(str(rn["state"]) == "kept" and int(rn["loyalty"]) == 0,
		"resolve on a kept promise returns its own state with loyalty 0")


func _blocks() -> void:
	var list1: Array = _show_list()
	_check(Promises.blocks_offer(list1, "danny", 100) == true, "blocks_offer danny day 100 -> true")
	_check(Promises.blocks_offer(list1, "danny", 125) == false, "blocks_offer danny day 125 -> false")
	_check(Promises.blocks_offer(list1, "lucy", 100) == false, "blocks_offer lucy day 100 -> false")
	_check(Promises.blocks_offer(list1, "danny", 124) == true, "blocks_offer danny day 124 -> true")


func _turn_pro() -> void:
	var rt: Dictionary = Promises.make([], "danny", Promises.TURN_PRO, -1, 91)
	_check(bool(rt["ok"]) == true, "make turn_pro danny by_day -1 on day 91 -> ok")
	var tlist: Array = rt["list"]
	var tp: Dictionary = tlist[0]
	_check(int(tp["by_day"]) == -1 and str(tp["wclass"]) == "", "turn_pro promise has by_day -1 and no wclass")
	_check(Promises.can_decline_pro(tlist, "danny") == false, "turn_pro open -> can_decline_pro danny false")
	var rturn: Dictionary = Promises.resolve(tp, {"day": 100, "fit": true, "made_weight": true, "boxed": false,
		"turned_pro": true, "signed_in_class": false})
	_check(str(rturn["state"]) == "kept" and int(rturn["loyalty"]) == 10
		and str(rturn["line"]) == "kept: turned pro" and bool(rturn["leaves"]) == false,
		"resolve turned_pro -> kept +10")
	var kept_p: Dictionary = tp.duplicate(true)
	kept_p["state"] = "kept"
	var kept_list: Array = [kept_p]
	_check(Promises.can_decline_pro(kept_list, "danny") == true, "list with kept turn_pro -> can_decline_pro true")
	_check(Promises.can_decline_pro([], "danny") == true, "no promises -> can_decline_pro true")


func _no_signing() -> void:
	var rn: Dictionary = Promises.make([], "danny", Promises.NO_SIGNING, 150, 91, "60 kg")
	_check(bool(rn["ok"]) == true, "make no_signing 60 kg by_day 150 on day 91 -> ok")
	var nlist: Array = rn["list"]
	var np: Dictionary = nlist[0]
	_check(str(np["wclass"]) == "60 kg" and int(np["by_day"]) == 150, "no_signing promise carries wclass 60 kg by_day 150")
	_check(Promises.can_invite(nlist, "60 kg", 120) == false, "can_invite 60 kg day 120 -> false")
	_check(Promises.can_invite(nlist, "57 kg", 120) == true, "can_invite 57 kg day 120 -> true")
	_check(Promises.can_invite(nlist, "60 kg", 150) == true, "can_invite 60 kg day 150 -> true")
	var rsigned: Dictionary = Promises.resolve(np, {"day": 130, "fit": true, "made_weight": true, "boxed": false,
		"turned_pro": false, "signed_in_class": true})
	_check(str(rsigned["state"]) == "broken" and int(rsigned["loyalty"]) == -12 and bool(rsigned["leaves"]) == false
		and str(rsigned["line"]) == "broken: signed in your class",
		"no_signing signed day 130 -> broken leaves false")
	var rkept: Dictionary = Promises.resolve(np, {"day": 150, "fit": true, "made_weight": true, "boxed": false,
		"turned_pro": false, "signed_in_class": false})
	_check(str(rkept["state"]) == "kept" and int(rkept["loyalty"]) == 10
		and str(rkept["line"]) == "kept: no signing in your class",
		"no_signing day 150 not signed -> kept +10")


func _line() -> void:
	var show_p: Dictionary = {"fid": "danny", "kind": Promises.SHOW_TOP, "by_day": 124, "wclass": "",
		"state": "open", "made_day": 91}
	_check(Promises.line(show_p, "Sat 9 May") == "Top of our show on Sat 9 May",
		"line show_top Sat 9 May")
	var turn_p: Dictionary = {"fid": "danny", "kind": Promises.TURN_PRO, "by_day": -1, "wclass": "",
		"state": "open", "made_day": 91}
	_check(Promises.line(turn_p, "Sat 9 May") == "Turn pro when the offer comes",
		"line turn_pro")
	var no_p: Dictionary = {"fid": "danny", "kind": Promises.NO_SIGNING, "by_day": 150, "wclass": "60 kg",
		"state": "open", "made_day": 91}
	_check(Promises.line(no_p, "Sat 9 May") == "No signing in your class before Sat 9 May",
		"line no_signing Sat 9 May")
