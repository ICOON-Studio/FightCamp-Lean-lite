extends RefCounted
## S397 menus round 3 (blind critic: "History is one row while she is 4-1"): the amateur bouts a fighter brought with her
## before she joined the club, made from her id so every visit shows the same ones. Her record holds only the count
## (f["w"], f["l"] less her club bouts); these give each one an opponent, a club, a method and a month. Fictional
## names and clubs only.
##   PriorBouts.list(f, wins, losses, joined_day) -> [{opp, club, win, method, when}]   oldest first

const NationalField := preload("res://scripts/state/NationalField.gd")

const CLUBS := ["Bow Lane ABC", "Kestrel ABC", "Riverside BC", "Eastgate ABC", "Northfield Lads ABC", "Saint Jude's ABC",
	"Holloway Road BC", "Marsh Street ABC"]
## Days between her old bouts (amateurs box about every six weeks).
const GAP := 42


static func list(f: Dictionary, wins: int, losses: int, joined_day: int) -> Array:
	var n := maxi(0, wins) + maxi(0, losses)
	if n == 0:
		return []
	var rng := RandomNumberGenerator.new()
	rng.seed = absi(hash("prior:" + str(f.get("id", f.get("name", "")))))
	# Her losses fall among the bouts, not all at the end.
	var results: Array = []
	for i in wins:
		results.append(true)
	for i in losses:
		results.append(false)
	for i in range(results.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var t: bool = results[i]
		results[i] = results[j]
		results[j] = t
	var out: Array = []
	for i in n:
		var win: bool = results[i]
		var opp := "%s %s" % [NationalField.FIRST[rng.randi_range(0, NationalField.FIRST.size() - 1)],
			NationalField.LAST[rng.randi_range(0, NationalField.LAST.size() - 1)]]
		var roll := rng.randf()
		var method := "points, unanimous" if roll < 0.55 else ("points, split" if roll < 0.8 else "stopped in round %d" % rng.randi_range(2, 3))
		out.append({"opp": opp, "club": CLUBS[rng.randi_range(0, CLUBS.size() - 1)], "win": win, "method": method,
			"when": month(joined_day - GAP * (n - i))})
	return out


## "Nov 2025" for a game day (day 0 = Mon 5 Jan 2026; earlier days are before the career).
static func month(day: int) -> String:
	var base := int(Time.get_unix_time_from_datetime_dict({"year": 2026, "month": 1, "day": 5, "hour": 12}))
	var d := Time.get_datetime_dict_from_unix_time(base + day * 86400)
	return "%s %d" % [["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][int(d["month"]) - 1], int(d["year"])]
