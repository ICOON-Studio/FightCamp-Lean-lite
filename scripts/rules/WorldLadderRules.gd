extends RefCounted
## The World rankings page's pure counts (MENUWORLD1). No new fight maths: reach is Matchmaking.ask, the
## climb uses that same band, and an unranked fighter's route starts at entering.
##   pick(rows, limit) -> the top `limit` by rank, plus the player's row if it was outside them
##   in_reach(entry, opp) -> the promoter would make this fight
##   row_ask(entry, opp, booked) -> {show, on, why}
##   title_route(rank) -> {steps, wins, line}   amateur_route(wins, min_wins, rank) -> the same shape
##   chip_state(flags) -> one of the kit's fighter states
##   marks(boxer, challenger_id, next_name) -> icon ids
##   trend(boxer) -> "up", "down", or "" when the record has no move

const MM := preload("res://scripts/rules/Matchmaking.gd")
const WR := preload("res://scripts/world/WorldRank.gd")


## Ranks 1..limit in order, then the player's row when it is unranked or below the cut.
static func pick(rows: Array, limit: int = 10) -> Array:
	var top: Array = []
	var player: Dictionary = {}
	var seen := false
	for r in rows:
		var row: Dictionary = r
		if bool(row.get("ours", false)):
			player = row
		var rank := int(row.get("rank", 0))
		if rank >= 1 and rank <= limit:
			top.append(row)
	top.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return int(a["rank"]) < int(b["rank"]))
	for r in top:
		if bool((r as Dictionary).get("ours", false)):
			seen = true
	if not player.is_empty() and not seen:
		top.append(player)
	return top


static func in_reach(entry: Dictionary, opp: Dictionary) -> bool:
	return bool(MM.ask(entry, opp)["ok"])


## show: the row draws Ask. on: it can be pressed. A booked fighter still shows Ask inside the band, grey.
static func row_ask(entry: Dictionary, opp: Dictionary, booked: bool) -> Dictionary:
	var answer: Dictionary = MM.ask(entry, opp)
	if not bool(answer["ok"]):
		return {"show": false, "on": false, "why": str(answer["reason"])}
	if booked:
		return {"show": true, "on": false, "why": "Booked"}
	return {"show": true, "on": true, "why": ""}


## Places a full step up the promoter's band lands on, from outside the table. 0 is entering.
static func _marks() -> Array:
	var out: Array = [0]
	var place := MM.UNRANKED_REACH
	out.append(place)
	var guard := 0
	while place > 1 and guard < 12:
		var nxt := maxi(1, place - MM.BAND_UP)
		if nxt >= place:
			break
		place = nxt
		out.append(place)
		guard += 1
	return out


## Wins to #1 if every win takes the best place the promoter allows. Unranked spends the first on entering.
static func wins_to_title(rank: int) -> int:
	if rank == 1:
		return 0
	var place := MM.UNRANKED_REACH if rank <= 0 else rank
	var n := 1 if rank <= 0 else 0
	var guard := 0
	while place > 1 and guard < 12:
		var nxt := maxi(1, place - MM.BAND_UP)
		if nxt >= place:
			break
		place = nxt
		n += 1
		guard += 1
	return n


static func _line(rank: int) -> String:
	var wins := wins_to_title(rank)
	if rank <= 0:
		return "One win to enter at #%d, then %d more to #1." % [MM.UNRANKED_REACH, wins_to_title(MM.UNRANKED_REACH)]
	if rank == 1:
		return "Number 1: the champions have to face you."
	return "Beat anyone from #%d up. %s to #1." % [maxi(1, rank - MM.BAND_UP), _more(wins)]


static func _more(n: int) -> String:
	return "1 more win" if n == 1 else "%d more wins" % n


## Pro table. Rank 0: the first step is entering, and it is the step now.
static func title_route(rank: int) -> Dictionary:
	var steps: Array = []
	var now_set := false
	for m in _marks():
		var place := int(m)
		var entering := place == 0
		var done := rank > 0 and (entering or rank <= place)
		var now := false
		if not done and not now_set:
			now = true
			now_set = true
		steps.append({"id": "entering" if entering else "r%d" % place, "label": "Enter" if entering else "#%d" % place,
			"done": done, "now": now})
	if not now_set and not steps.is_empty():
		var last: Dictionary = steps[steps.size() - 1]
		last["now"] = true
		last["done"] = true
	return {"steps": steps, "wins": wins_to_title(rank), "line": _line(rank)}


## Amateur regional table. Rank 0: entering, at the real wins line (the caller passes Region.RANK_MIN_WINS).
static func amateur_route(wins: int, min_wins: int, rank: int) -> Dictionary:
	var in_table := rank > 0
	var steps: Array = [
		{"id": "entering", "label": "Enter", "done": in_table, "now": not in_table},
		{"id": "table", "label": "#%d" % rank if in_table else "Table", "done": false, "now": in_table},
	]
	var line := "Enters the regional table at %d wins (%d so far)." % [min_wins, wins]
	if in_table:
		line = "Ranked #%d in the region. The title road is on Championships." % rank
	return {"steps": steps, "line": line, "wins": maxi(0, min_wins - wins)}


## One state icon. Injury, then an open contract talk, a camp, a booking, an offer, else free.
static func chip_state(flags: Dictionary) -> String:
	if bool(flags.get("injured", false)):
		return "injured"
	if bool(flags.get("talks", false)):
		return "contract"
	if bool(flags.get("camp", false)):
		return "camp"
	if bool(flags.get("booked", false)):
		return "booked"
	if bool(flags.get("offer", false)):
		return "offer"
	return "free"


## Champion (world belt), challenger (the mandatory), next opponent. A world champion is not also the challenger.
static func marks(boxer: Dictionary, challenger_id: int, next_name: String) -> Array:
	var out: Array = []
	if next_name != "" and str(boxer.get("name", "")) == next_name:
		out.append("next_opp")
	var belt := str(boxer.get("belt", ""))
	if belt != "" and WR.level_of(belt) == "world":
		out.append("champion")
	elif challenger_id >= 0 and int(boxer.get("id", -1)) == challenger_id and not bool(boxer.get("player", false)):
		out.append("challenger")
	if bool(boxer.get("new_face", false)):   # S443 R85: arrived at the last year end (ProLadder.year_end, WorldNews.marks)
		out.append("new_face")
	return out


## The last logged rank move, or "" when this boxer has no log (drawn as a steady dash, not a guessed arrow).
static func trend(boxer: Dictionary) -> String:
	var log: Array = boxer.get("log", [])
	if log.is_empty():
		return ""
	var last: Dictionary = log[log.size() - 1]
	var before := int(last.get("rank_before", 0))
	var after := int(last.get("rank_after", 0))
	if after > 0 and (before == 0 or after < before):
		return "up"
	if before > 0 and (after == 0 or after > before):
		return "down"
	return ""
