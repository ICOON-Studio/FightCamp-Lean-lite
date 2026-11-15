extends RefCounted
## FilmSeats - who watches film with the coach in a fight week, who watches alone.
## Film session: one coach evening of tape and plan, on the FILM counter, never a turn.
## Map: ops/research/DESIGN_CLUBWEEK1_V9_REVISE_KALLI_KALLI.md 3.4: "Film session: one coach
## evening of tape and plan... Owned: You 2 a week, plus 1 with a full-time coach. Over the count,
## the boxer watches alone: the session opens no tell."
## Build plan: ops/research/CLUBWEEK1_BUILD_S485.md, item 4 (Film over on the bout page).
## Pure static; no preload, no class_name, no game state.
##   owned(coach_kind) -> int   deal(boxers, coach_kind) -> Array   alone_count(dealt) -> int
##   opens_tell(seat) -> bool   line(dealt, coach_kind) -> String   seat_of(dealt, id) -> String

const YOU_SEATS := 2
const FULL_TIME_EXTRA := 1
const COACHED := "coached"
const ALONE := "alone"


static func owned(coach_kind: String) -> int:
	return YOU_SEATS + (FULL_TIME_EXTRA if coach_kind == "full_time" else 0)


static func deal(boxers: Array, coach_kind: String) -> Array:
	if boxers.is_empty():
		return []
	var owned_seats: int = owned(coach_kind)
	var enriched: Array = []
	for i in range(boxers.size()):
		var b: Dictionary = boxers[i]
		var bid: String = str(b.get("id", ""))
		var fday: int = int(b.get("fight_day", 0))
		enriched.append({"id": bid, "fight_day": fday, "idx": i})
	enriched.sort_custom(func(a, b) -> bool:
		var da: int = int(a["fight_day"])
		var db: int = int(b["fight_day"])
		if da != db:
			return da < db
		var ia: int = int(a["idx"])
		var ib: int = int(b["idx"])
		return ia < ib
	)
	var out: Array = []
	for i in range(enriched.size()):
		var e: Dictionary = enriched[i]
		var seat: String = COACHED if i < owned_seats else ALONE
		out.append({"id": str(e["id"]), "fight_day": int(e["fight_day"]), "seat": seat})
	return out


static func alone_count(dealt: Array) -> int:
	var n: int = 0
	for i in range(dealt.size()):
		var row: Dictionary = dealt[i]
		if str(row.get("seat", "")) == ALONE:
			n += 1
	return n


static func opens_tell(seat: String) -> bool:
	return seat == COACHED


static func line(dealt: Array, coach_kind: String) -> String:
	var ac: int = alone_count(dealt)
	if ac == 0:
		return ""
	var tail: String = ""
	if ac == 1:
		tail = "one watches alone"
	else:
		tail = "%d watch alone" % ac
	return "Film: %d boxers, %d seats - %s" % [dealt.size(), owned(coach_kind), tail]


static func seat_of(dealt: Array, id: String) -> String:
	for i in range(dealt.size()):
		var row: Dictionary = dealt[i]
		if str(row.get("id", "")) == id:
			return str(row.get("seat", ""))
	return ""
