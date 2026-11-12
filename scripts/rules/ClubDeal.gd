extends RefCounted
## ClubDeal: the club week's coach hours - pad places, coached mornings, Coach's evenings as pads or a class,
## and who goes short. Pure rule module, static functions only.
## Every counter is FIGHTER-SESSIONS (asked, covered, short), never nights or hours.
## A shared morning is 2 covered, not 1. Covered pads never exceed owned.
## R73DEAL1: no screen, no wiring, no loyalty change - returns causes only.

const DuesLevers := preload("res://scripts/rules/DuesLevers.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")

## How many each fighter ASKS (CLUBWEEK 3.1).
const ASK := {"ordinary": 3, "fight_week_extra": 2, "trial": 1, "film": 2, "talk": 1}

## A boxer's 4th and 5th pad place still pay at 0.7 and 0.5; a 6th is never dealt.
const NTH_VALUE := [1.0, 1.0, 1.0, 0.7, 0.5]

## Coached mornings: You 4, Coach 2 = 6 slots. Two fighters on the same session share one at SHARED_VALUE each.
const MORNING_SLOTS := 6
const SHARED_VALUE := 0.8
## The held pad place (a Loyal holder, can_hold) is worth this to whoever takes it.
const HELD_VALUE := 0.7


## Can this fighter hold pads (add 1 to the pool)? Loyal and 6+ bouts.
static func can_hold(f: Dictionary) -> bool:
	return bool(f.get("loyal", false)) and int(f.get("bouts", 0)) >= 6


## Class income for n class nights: n x round(CLASS_WEEKLY / 3.0) = n x $117.
static func class_cash(n: int) -> int:
	return n * roundi(float(DuesLevers.CLASS_WEEKLY) / 3.0)


## New members every 4 weeks from n class nights: n x 0.25 (ESTIMATE, MONEYFOUR2).
static func class_members_4w(n: int) -> float:
	return float(n) * 0.25


## Coach's deal order: first fighters; then short last week; then fight weeks;
## then nearest target_day; then id.
## REVIEW3: one cascading key, so each tier also orders the fighters inside the tier above it (two fight-week boxers go
## by the nearer target day, not by id).
static func coach_order(week: Dictionary) -> Array:
	var fighters: Array = (week["fighters"] as Array).duplicate()
	fighters.sort_custom(func(fa: Dictionary, fb: Dictionary) -> bool:
		for key in ["first", "short_last_week", "fight_week"]:
			var ka: bool = bool(fa.get(key, false))
			var kb: bool = bool(fb.get(key, false))
			if ka != kb:
				return ka
		var ta: int = int(fa.get("target_day", -1))
		var tb: int = int(fb.get("target_day", -1))
		if ta != tb:
			if ta == -1 or tb == -1:
				return tb == -1
			return ta < tb
		return str(fa["id"]) < str(fb["id"]))
	var out: Array = []
	for f in fighters:
		out.append(str(f["id"]))
	return out


## Deal pads then mornings in order (Coach's when empty), one place at a time round the order.
## Returns {pads, mornings, cash, members_4w, rows}. Every counter is in fighter-sessions; asked is what was asked (a 6th
## pad place asked and never dealt counts short). REVIEW3: the held place is the LAST place of the pool, worth HELD_VALUE
## to whoever takes it (never the holder, who spends the evening holding); covered is never clamped to owned, so the
## 200-week check in the test can fail.
static func deal(week: Dictionary, order: Array = []) -> Dictionary:
	if order.is_empty():
		order = coach_order(week)
	var fighters: Array = week["fighters"]
	var evenings: Array = week["evenings"]
	var own_ev: String = str(week.get("own_evening", "pads"))
	var holder_id: String = str(week.get("holder", ""))
	var pad_evenings: int = evenings.count("pads") + (1 if own_ev == "pads" else 0)
	var class_nights: int = evenings.count("class") + (1 if own_ev == "class" else 0)
	var holder_valid: bool = holder_id != "" and can_hold(_fighter_by_id(fighters, holder_id))
	var pad_owned: int = 2 * pad_evenings + (1 if holder_valid else 0)
	var cap: Dictionary = {}
	var morn_asks: Dictionary = {}
	var pad_total_asked := 0
	for f in fighters:
		var fid: String = str(f["id"])
		cap[fid] = mini(int(f.get("pads", 0)), NTH_VALUE.size())
		pad_total_asked += int(f.get("pads", 0))
		morn_asks[fid] = (f.get("mornings", []) as Array).duplicate()
	var pad_got: Dictionary = {}
	var pad_val: Dictionary = {}
	for fid in order:
		pad_got[fid] = 0
		pad_val[fid] = 0.0
	var left := pad_owned
	var idx := 0
	var misses := 0
	while left > 0 and not order.is_empty() and misses < order.size():
		var fid: String = str(order[idx % order.size()])
		idx += 1
		var held: bool = holder_valid and left == 1
		if pad_got.has(fid) and int(pad_got[fid]) < int(cap.get(fid, 0)) and not (held and fid == holder_id):
			pad_val[fid] = float(pad_val[fid]) + (HELD_VALUE if held else float(NTH_VALUE[int(pad_got[fid])]))
			pad_got[fid] = int(pad_got[fid]) + 1
			left -= 1
			misses = 0
		else:
			misses += 1
	var pad_covered := 0
	for fid in pad_got:
		pad_covered += int(pad_got[fid])
	var morn_result := _deal_mornings(order, morn_asks)
	var rows: Array = []
	for f in fighters:
		var fid: String = str(f["id"])
		var pg: int = int(pad_got.get(fid, 0))
		var mg: int = int((morn_result["got"] as Dictionary).get(fid, 0))
		var is_short: bool = pg < int(f.get("pads", 0)) or mg < (morn_asks[fid] as Array).size()
		var holding: bool = holder_valid and fid == holder_id
		var causes: Array = ["short" if is_short else "full_week"]
		if holding:
			causes.append("held_pads")
		rows.append({"id": fid, "pads_got": pg, "pads_value": float(pad_val.get(fid, 0.0)), "mornings_got": mg,
			"mornings_value": float((morn_result["value"] as Dictionary).get(fid, 0.0)), "short": is_short,
			"holding": holding, "causes": causes})
	return {"pads": {"owned": pad_owned, "asked": pad_total_asked, "covered": pad_covered,
			"short": maxi(0, pad_total_asked - pad_covered)},
		"mornings": {"owned": MORNING_SLOTS, "asked": morn_result["asked"], "covered": morn_result["covered"],
			"short": morn_result["short"]},
		"cash": class_cash(class_nights), "members_4w": class_members_4w(class_nights), "rows": rows}


## Mornings (REVIEW3): same-session asks of two DIFFERENT fighters are paired first (one slot, SHARED_VALUE each, 2
## covered), dealt one slot at a time round the order; then the unpaired asks, one slot at a time round the order.
static func _deal_mornings(order: Array, morn_asks: Dictionary) -> Dictionary:
	var total_asked := 0
	for fid in morn_asks:
		total_asked += (morn_asks[fid] as Array).size()
	var by_session: Dictionary = {}
	for fid in order:
		for s in morn_asks.get(fid, []):
			if not by_session.has(str(s)):
				by_session[str(s)] = []
			(by_session[str(s)] as Array).append(str(fid))
	var pairs: Dictionary = {}
	var singles: Dictionary = {}
	for fid in order:
		pairs[fid] = []
		singles[fid] = 0
	for s in by_session:
		var q: Array = (by_session[s] as Array).duplicate()
		while not q.is_empty():
			var a: String = str(q.pop_front())
			var j := -1
			for i in q.size():
				if str(q[i]) != a:
					j = i
					break
			if j < 0:
				singles[a] = int(singles[a]) + 1
				continue
			(pairs[a] as Array).append(str(q[j]))
			q.remove_at(j)
	var got: Dictionary = {}
	var value: Dictionary = {}
	for fid in order:
		got[fid] = 0
		value[fid] = 0.0
	var slots := MORNING_SLOTS
	var dealt := true
	while slots > 0 and dealt:
		dealt = false
		for fid in order:
			if slots > 0 and not (pairs[fid] as Array).is_empty():
				var mate: String = str((pairs[fid] as Array).pop_front())
				for x in [str(fid), mate]:
					got[x] = int(got[x]) + 1
					value[x] = float(value[x]) + SHARED_VALUE
				slots -= 1
				dealt = true
	dealt = true
	while slots > 0 and dealt:
		dealt = false
		for fid in order:
			if slots > 0 and int(singles[fid]) > 0:
				singles[fid] = int(singles[fid]) - 1
				got[fid] = int(got[fid]) + 1
				value[fid] = float(value[fid]) + 1.0
				slots -= 1
				dealt = true
	var covered := 0
	for fid in got:
		covered += int(got[fid])
	return {"got": got, "value": value, "asked": total_asked, "covered": covered, "short": maxi(0, total_asked - covered)}


## Coach's evenings: keeps all three on "pads" unless runway < 8, then first is "class".
static func coach_evenings(cash: int, net: int) -> Array:
	var rw: int = GymBills.runway_weeks(cash, net)
	if rw >= 8:
		return ["pads", "pads", "pads"]
	return ["class", "pads", "pads"]


## Summary line: "Pad places: 10 asked, 8 covered, 2 short".
static func words(result: Dictionary) -> String:
	var p: Dictionary = result["pads"]
	return "Pad places: %d asked, %d covered, %d short" % [int(p["asked"]), int(p["covered"]), int(p["short"])]


static func _fighter_by_id(fighters: Array, fid: String) -> Dictionary:
	for f in fighters:
		if str(f["id"]) == fid:
			return f
	return {}
