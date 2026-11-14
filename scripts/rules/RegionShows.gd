extends RefCounted
## S474 REGIONSHOWS1 (map DESIGN_AMATEURWEEK1_V8_REVISE_KALLI_KALLI section 2 "SLOTS BY CLASS"):
## The region's amateur club-show calendar and each show's bout slots by sex and weight class.
## Pure static functions, no class_name, no preload, no game state. Every draw is deterministic from
## hash() of a string key, so a save and a reload see the same calendar.
##
##   week_shows(monday)                      -> 1..2 Saturday shows: [{"show", "day", "bouts"}, ...]
##   slots(show)                             -> `bouts` slots matching BoutSheet's slot shape
##   offered(from_day, weeks_min, weeks_max) -> slots in [from_day+7*min, from_day+7*max], soonest
##   for_div(slot_list, div)                 -> slots of one class, soonest first
##   short_name(div)                         -> kg class label ("57 kg", "57.5 kg", ...)

## Real amateur clubs (fighters stay fictional).
const HOSTS := ["Fitzroy Lodge", "West Ham", "Repton", "Lynn AC", "Dale Youth", "All Stars"]
## The eight amateur weight-class ids in table order (women then men, matching Data.DIVISIONS).
const DIVS := ["wfw", "wlw", "www", "wmw", "mfw", "mlw", "mww", "mmw"]
const DIV_SEX := {
	"wfw": "f", "wlw": "f", "www": "f", "wmw": "f",
	"mfw": "m", "mlw": "m", "mww": "m", "mmw": "m",
}
const WOMEN_DIVS := ["wfw", "wlw", "www", "wmw"]
const MEN_DIVS := ["mfw", "mlw", "mww", "mmw"]
const SHORT_NAMES := {
	"wfw": "57 kg", "wlw": "60 kg", "www": "65 kg", "wmw": "75 kg",
	"mfw": "57.5 kg", "mlw": "60 kg", "mww": "70 kg", "mmw": "75 kg",
}
const SHOWS_PER_WEEK_MIN := 1
const SHOWS_PER_WEEK_MAX := 2
const BOUTS_MIN := 8
const BOUTS_MAX := 12
## About a third of a club card's bouts are women's (ESTIMATE).
const WOMEN_SHARE := 0.35
## Shows are on Saturday; day 0 is a Monday, so a show day is monday + 5.
const SHOW_DOW := 5
## About a quarter of slots name the host's own boxer (a "named" card that counts toward refusals).
const NAMED_SHARE := 0.25
const DAYS_PER_WEEK := 7
const NAMED_SCALE := 1000


## Non-negative deterministic int from hash(key), mixing upper bits so modulo 3/6 stays even.
static func _hash_int(key: String) -> int:
	var h := absi(hash(key))
	return absi(h ^ (h >> 16))


## Shows of the week starting on `monday` (multiple of 7): 1 or 2 shows (from hash("w%d" % monday)),
## each {"show": host name, "day": monday + SHOW_DOW, "bouts": BOUTS_MIN..BOUTS_MAX}.
## Two shows in one week never share a host.
static func week_shows(monday: int) -> Array:
	var show_span := SHOWS_PER_WEEK_MAX - SHOWS_PER_WEEK_MIN + 1
	var count := SHOWS_PER_WEEK_MIN + (_hash_int("w%d" % monday) % show_span)
	var bout_span := BOUTS_MAX - BOUTS_MIN + 1
	var pool: Array = HOSTS.duplicate()
	var show_day := monday + SHOW_DOW
	var out: Array = []
	for i in count:
		if pool.is_empty():
			break
		var pick := _hash_int("h%d:%d" % [monday, i]) % pool.size()
		var host: String = str(pool[pick])
		pool.remove_at(pick)
		var bouts := BOUTS_MIN + (_hash_int("b%d:%d" % [monday, i]) % bout_span)
		out.append({"show": host, "day": show_day, "bouts": bouts})
	return out


## Build one slot dictionary in the shape BoutSheet reads.
static func _make_slot(show_name: String, day: int, div: String, is_named: bool) -> Dictionary:
	var sex: String = str(DIV_SEX.get(div, ""))
	var opp := "%s %s boxer" % [show_name, short_name(div)]
	return {"show": show_name, "day": day, "sex": sex, "div": div, "named": is_named, "opp": opp}


## The show's slots: `bouts` entries, each {"show", "day", "sex", "div", "named", "opp"}.
## Women get roundi(bouts * WOMEN_SHARE) (at least 1), men the rest; classes cycle through that
## sex's four classes from an offset from hash(show.show + str(show.day)). `named` rolls about
## NAMED_SHARE per slot; `opp` is "%s %s boxer" % [show.show, short_name(div)] as a placeholder.
static func slots(show: Dictionary) -> Array:
	var bouts: int = int(show.get("bouts", 0))
	if bouts <= 0:
		return []
	var show_name: String = str(show.get("show", ""))
	var day: int = int(show.get("day", 0))
	var women := mini(bouts, maxi(1, roundi(float(bouts) * WOMEN_SHARE)))
	var men := bouts - women
	var base := _hash_int(show_name + str(day))
	var w_off := base % WOMEN_DIVS.size()
	var m_off := (base >> 2) % MEN_DIVS.size()
	var named_cut := roundi(NAMED_SHARE * float(NAMED_SCALE))
	var out: Array = []
	var idx := 0
	for i in women:
		var div: String = str(WOMEN_DIVS[(w_off + i) % WOMEN_DIVS.size()])
		var is_named := (_hash_int("n:%s:%d:%d" % [show_name, day, idx]) % NAMED_SCALE) < named_cut
		out.append(_make_slot(show_name, day, div, is_named))
		idx += 1
	for j in men:
		var div: String = str(MEN_DIVS[(m_off + j) % MEN_DIVS.size()])
		var is_named := (_hash_int("n:%s:%d:%d" % [show_name, day, idx]) % NAMED_SCALE) < named_cut
		out.append(_make_slot(show_name, day, div, is_named))
		idx += 1
	return out


## Every slot of every show whose day lies in [from_day + 7 * weeks_min, from_day + 7 * weeks_max]
## inclusive, soonest first (the 1-3 weeks amateur lead time).
static func offered(from_day: int, weeks_min: int = 1, weeks_max: int = 3) -> Array:
	var lo := from_day + DAYS_PER_WEEK * weeks_min
	var hi := from_day + DAYS_PER_WEEK * weeks_max
	if lo > hi:
		return []
	var first_base := lo - SHOW_DOW
	var mon := first_base - posmod(first_base, DAYS_PER_WEEK)
	if mon + SHOW_DOW < lo:
		mon += DAYS_PER_WEEK
	var out: Array = []
	while mon + SHOW_DOW <= hi:
		for item in week_shows(mon):
			var sh: Dictionary = item
			var show_day: int = int(sh.get("day", 0))
			if show_day >= lo and show_day <= hi:
				out.append_array(slots(sh))
		mon += DAYS_PER_WEEK
	return out


## The slots of one class, soonest first.
static func for_div(slot_list: Array, div: String) -> Array:
	var out: Array = []
	for item in slot_list:
		var slot: Dictionary = item
		if str(slot.get("div", "")) == div:
			out.append(slot)
	out.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return int(a.get("day", 0)) < int(b.get("day", 0))
	)
	return out


## Short weight-class label in kg ("57 kg", "57.5 kg", ...); "" for an unknown class id.
static func short_name(div: String) -> String:
	return str(SHORT_NAMES.get(div, ""))
