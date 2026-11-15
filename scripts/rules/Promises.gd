extends RefCounted
## PROMISE1 (R58, S486): promises to a fighter - made, listed only when they bind, kept or broken, and what they lock.
## Spec: ops/research/TASK_PROMISE1.md. Map: ops/research/R58_MAP_S439.md section 4 M5 (the promise list) and M4
## (PROMISE: OUR SHOW); Loyalty.gd MOVES promise_kept / promise_broken carry the loyalty numbers (KEPT / BROKEN here).
## A promise is a Dictionary {fid, kind, by_day, wclass, state, made_day}; the list is an Array of those (the caller
## keeps it in the save). wclass is "" unless kind is no_signing. state is "open" / "kept" / "broken".
## Pure static; NO preload, NO class_name. The caller passes plain dictionaries; this module reads no game state.
##   listed(kind, v) make(list, fid, kind, by_day, day, wclass) open_for(list, fid) blocks_offer(list, fid, day)
##   can_decline_pro(list, fid) can_invite(list, wclass, day) resolve(p, v) line(p, date_text)

const SHOW_TOP := "show_top"
const TURN_PRO := "turn_pro"
const NO_SIGNING := "no_signing"
const KEPT := 10
const BROKEN := -12
const MADE := 4
const PRO_NEAR := 2


## The promise is offered only when it binds something TODAY. v: {can_book, bouts_open, wins_to_pro, scouted_in_class}.
## show_top needs a bookable show and a legal bout; turn_pro needs the fighter within PRO_NEAR wins of a pro offer;
## no_signing needs a scouted trial in the class. Unknown kind -> false.
static func listed(kind: String, v: Dictionary) -> bool:
	if kind == SHOW_TOP:
		return bool(v.get("can_book", false)) and int(v.get("bouts_open", 0)) > 0
	if kind == TURN_PRO:
		var wins: int = int(v.get("wins_to_pro", -1))
		return wins >= 0 and wins <= PRO_NEAR
	if kind == NO_SIGNING:
		return bool(v.get("scouted_in_class", false))
	return false


## Makes a promise. Returns {ok, why, list (a NEW array; the input is not changed), promise}.
## Refused when the fighter already has an OPEN promise of the same kind ("already promised"), or by_day <= day
## for show_top / no_signing ("the date has passed"). turn_pro takes by_day -1 (no date) and is exempt from the date check.
static func make(list: Array, fid: String, kind: String, by_day: int, day: int, wclass := "") -> Dictionary:
	for e in list:
		var p: Dictionary = e
		if str(p.get("fid", "")) == fid and str(p.get("kind", "")) == kind and str(p.get("state", "")) == "open":
			return {"ok": false, "why": "already promised", "list": list.duplicate(true), "promise": {}}
	if (kind == SHOW_TOP or kind == NO_SIGNING) and by_day <= day:
		return {"ok": false, "why": "the date has passed", "list": list.duplicate(true), "promise": {}}
	var stored_wclass: String = wclass if kind == NO_SIGNING else ""
	var promise: Dictionary = {"fid": fid, "kind": kind, "by_day": by_day, "wclass": stored_wclass,
		"state": "open", "made_day": day}
	var out: Array = list.duplicate(true)
	out.append(promise)
	return {"ok": true, "why": "", "list": out, "promise": promise}


## The fighter's open promises, in list order.
static func open_for(list: Array, fid: String) -> Array:
	var out: Array = []
	for e in list:
		var p: Dictionary = e
		if str(p.get("fid", "")) == fid and str(p.get("state", "")) == "open":
			out.append(p)
	return out


## True while the fighter has an open show_top with by_day >= day (the show is the next bout; outside offers are not shown).
static func blocks_offer(list: Array, fid: String, day: int) -> bool:
	for e in list:
		var p: Dictionary = e
		if str(p.get("fid", "")) == fid and str(p.get("kind", "")) == SHOW_TOP \
				and str(p.get("state", "")) == "open" and int(p.get("by_day", 0)) >= day:
			return true
	return false


## False while an open turn_pro exists for the fighter (declining the pro offer is locked).
static func can_decline_pro(list: Array, fid: String) -> bool:
	for e in list:
		var p: Dictionary = e
		if str(p.get("fid", "")) == fid and str(p.get("kind", "")) == TURN_PRO and str(p.get("state", "")) == "open":
			return false
	return true


## False while ANY open no_signing in that wclass has by_day > day (the trial in that class is hidden).
static func can_invite(list: Array, wclass: String, day: int) -> bool:
	for e in list:
		var p: Dictionary = e
		if str(p.get("kind", "")) == NO_SIGNING and str(p.get("state", "")) == "open" \
				and str(p.get("wclass", "")) == wclass and int(p.get("by_day", 0)) > day:
			return false
	return true


## One promise on a given day. v: {day, fit, made_weight, boxed, turned_pro, signed_in_class}.
## Returns {state, loyalty, leaves, line}. Only an "open" promise changes; anything else returns its own state with loyalty 0.
## show_top on day == by_day (on or after, so a late call still resolves): fit and made_weight and boxed -> kept +KEPT,
## otherwise broken BROKEN and leaves (unfit on the night = leaves the Monday after). Before by_day: stays open, 0.
## turn_pro: turned_pro -> kept +KEPT; otherwise open. no_signing: signed_in_class before by_day -> broken BROKEN
## (leaves false); day >= by_day and not signed -> kept +KEPT (a signing on or after the date does not break it).
static func resolve(p: Dictionary, v: Dictionary) -> Dictionary:
	var state: String = str(p.get("state", "open"))
	if state != "open":
		return {"state": state, "loyalty": 0, "leaves": false, "line": ""}
	var kind: String = str(p.get("kind", ""))
	var by_day: int = int(p.get("by_day", 0))
	var day: int = int(v.get("day", 0))
	if kind == SHOW_TOP:
		if day < by_day:
			return {"state": "open", "loyalty": 0, "leaves": false, "line": ""}
		if bool(v.get("fit", false)) and bool(v.get("made_weight", false)) and bool(v.get("boxed", false)):
			return {"state": "kept", "loyalty": KEPT, "leaves": false, "line": "kept: top of our show"}
		return {"state": "broken", "loyalty": BROKEN, "leaves": true, "line": "broken: missed our show"}
	if kind == TURN_PRO:
		if bool(v.get("turned_pro", false)):
			return {"state": "kept", "loyalty": KEPT, "leaves": false, "line": "kept: turned pro"}
		return {"state": "open", "loyalty": 0, "leaves": false, "line": ""}
	if kind == NO_SIGNING:
		if bool(v.get("signed_in_class", false)) and day < by_day:
			return {"state": "broken", "loyalty": BROKEN, "leaves": false, "line": "broken: signed in your class"}
		if day >= by_day:
			return {"state": "kept", "loyalty": KEPT, "leaves": false, "line": "kept: no signing in your class"}
		return {"state": "open", "loyalty": 0, "leaves": false, "line": ""}
	return {"state": state, "loyalty": 0, "leaves": false, "line": ""}


## The PROMISES OPEN row with no names (names live in headers).
static func line(p: Dictionary, date_text: String) -> String:
	var kind: String = str(p.get("kind", ""))
	if kind == SHOW_TOP:
		return "Top of our show on " + date_text
	if kind == TURN_PRO:
		return "Turn pro when the offer comes"
	if kind == NO_SIGNING:
		return "No signing in your class before " + date_text
	return ""


## S488 APPROACHUI2: Club > People's PROMISES OPEN rows, soonest first: [{fid, name, line, by_day}] (the name is the row's header).
static func open_rows(c) -> Array:
	var out: Array = []
	for p in c.promises:
		if str(p.get("state", "")) != "open":
			continue
		var f: Dictionary = c.fighter_by_id(str(p["fid"]))
		if f.is_empty():
			continue
		var when: String = load("res://scripts/state/Clock.gd").fmt(int(p.get("by_day", 0)))
		out.append({"fid": str(p["fid"]), "name": str(f["name"]), "line": line(p, when), "by_day": int(p.get("by_day", 0))})
	out.sort_custom(func(a, b): return int(a["by_day"]) < int(b["by_day"]))
	return out
