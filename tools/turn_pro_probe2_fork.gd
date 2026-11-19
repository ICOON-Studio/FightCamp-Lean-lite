extends RefCounted
## TURNPROBE2 fork helper: for one offer snapshot, play the career forward once per ask to the week after debut.
## Returns {best_ask, totals: {ask_kind: {gym_cash, boxer_purse, total}}, sanity: {no_ask_1, no_ask_2}}.

const Bouts := preload("res://scripts/state/Bouts.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const ProCall := preload("res://scripts/rules/ProCall.gd")
const ProDebut := preload("res://scripts/rules/ProDebut.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const ProOfferWire := preload("res://scripts/state/ProOfferWire.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Sim := preload("res://scripts/state/Sim.gd")

const ASK_KINDS := ["no_ask", "later2", "later4", "softer", "split", "price", "costs"]
const MAX_DAYS := 120


static func run_forks(snap: Dictionary, offer: Dictionary, _seed_n: int, _offer_day: int) -> Dictionary:
	var totals := {}
	for kind in ASK_KINDS:
		var r := _one_fork(snap, offer, kind)
		totals[kind] = r
	var best_ask := "no_ask"
	var best_total := -999999
	for kind in ASK_KINDS:
		var t: int = int((totals[kind] as Dictionary).get("total", 0))
		if t > best_total:
			best_total = t; best_ask = kind
	return {"best_ask": best_ask, "totals": totals}


static func _one_fork(snap: Dictionary, offer: Dictionary, ask_kind: String) -> Dictionary:
	var c: Career = snap["career"].duplicate(true)
	var fid: String = str(snap["fighter_id"])
	var f: Dictionary = c.fighter_by_id(fid)
	if f.is_empty():
		return {"gym_cash": 0, "boxer_purse": 0, "total": 0, "debut_done": -1}
	c.pro_offer = offer.duplicate(true)
	var key := str((offer.get("offers", [{}]) as Array)[0].get("key", ""))
	if offer.get("offers", []).size() > 1:
		var costs: int = int(Roster.debut_sheet(c, f, 1.0)["costs"])
		var share: float = Roster.signing_share(f)
		var best_key := ""; var best_bd := -999999
		for t in offer.get("offers", []):
			var m: Dictionary = ProOfferWire.money(c, f, t, costs, share)
			var bd: int = int(m.get("by_debut", 0))
			if bd > best_bd:
				best_bd = bd; best_key = str(t["key"])
		key = best_key
	if ask_kind != "no_ask":
		var runway: int = GymBills.runway_weeks(c.cash, 0)
		ProOfferWire.ask(c, key, ask_kind, runway)
	Roster.turn_pro(c, key)
	var purse: int = int(f.get("purse", 0))
	var guard := 0
	var debut_done := false
	while c.day < snap["day"] + MAX_DAYS and not c.closed and guard < 2000 and not debut_done:
		guard += 1
		_answer_open(c, f)
		Sim.step_day(c)
		var bout: Dictionary = f.get("bout", {})
		if not bout.is_empty() and bool(bout.get("done", false)):
			debut_done = true
	var gym_cash: int = c.cash
	var deal: Dictionary = f.get("bout", {}).get("deal", {})
	var share_rate: float = Roster.share_of(f)
	var sold: int = mini(ProDebut.TICKETS, ProOfferWire.forecast(c, f, Roster.titles(f)))
	var night_m: Dictionary = ProOfferWire.night(f, deal, sold, share_rate)
	var boxer_purse: int = int(night_m.get("her", 0))
	return {"gym_cash": gym_cash, "boxer_purse": boxer_purse, "total": gym_cash + boxer_purse,
		"debut_done": c.day if debut_done else -1}


static func _answer_open(c: Career, f: Dictionary) -> void:
	for o2 in (f["offers"] as Array).duplicate():
		if bool(o2["answered"]) or bool(o2["mismatch"]):
			continue
		if not (f["bout"] as Dictionary).is_empty():
			Bouts.decline(c, str(o2["id"]))
		else:
			Bouts.accept(c, str(o2["id"]))
	for o2 in (f["offers"] as Array).duplicate():
		if not bool(o2["answered"]):
			Bouts.decline(c, str(o2["id"]))
	if Bouts.camp_due(c, f):
		Bouts.start_camp(c, f, Sim.focus_of(c, f), 2, OppFile.has_tape((f["bout"] as Dictionary).get("opp", {})), false)
	if Bouts.weigh_in_today(c, f):
		Bouts.weigh(c, f)
	if Bouts.fight_day(c, f):
		Bouts.fight_step(c, f, Bouts.fight_modal(f), "sim")
		Bouts.after_fight(c, f)
	if bool(f.get("goal_talk", false)):
		Bouts.set_goal(c, f, "five_round_engine")
	if bool(f.get("pro", false)) and ProLadder.on_ladder(c, f) and (f["bout"] as Dictionary).is_empty():
		var rows := ProLadder.offer_rows(c, f)
		for kind in ["above", "tune", "payday"]:
			var pick := rows.filter(func(r): return str(r["kind"]) == kind)
			if not pick.is_empty():
				ProLadder.book(c, f, int(pick[0]["opp"]["id"]), false)
				break
