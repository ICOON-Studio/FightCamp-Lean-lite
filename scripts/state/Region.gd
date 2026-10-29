extends RefCounted
## The boxing world around the gym: club shows every other Saturday where the region's rivals fight each other (their
## records move, so the rankings move), the women's lightweight rankings, and the news those make. The news lines come from
## assets/data/world_news.json when present (Kalli, K-WORLDNEWS1), else the built-in lines below.

const Data := preload("res://scripts/state/Data.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")
const FightWords := preload("res://scripts/state/FightWords.gd")

const NEWS_PATH := "res://assets/data/world_news.json"
## Bouts between rivals at each club show.
const SHOW_BOUTS := 2
## She enters the regional rankings at this many wins (the prototype's line).
const RANK_MIN_WINS := 4
const RANK_ROWS := 8
const ROUND_SPREAD := 6.0
## A clear win (score gap over this) is a stoppage on a low roll.
const STOPPAGE_GAP := 4.0
const STOPPAGE_ROLL := 0.4
## A show is announced this many days before; gym news every other week, on the Wednesday.
const SHOW_NOTICE_DAYS := 2
const GYM_NEWS_EVERY_DAYS := 14
const GYM_NEWS_DAY := 9
## Ratings drift with results, a little.
const WIN_RATING := 0.3
const LOSS_RATING := -0.2

const NEWS_FALLBACK := {
	"rival_win": ["{winner} ({winner_club}) beat {loser} on points at the {show}."],
	"rival_stop": ["{winner} stopped {loser} inside the distance at the {show}."],
	"show": ["The {show} is on this Saturday."],
	"ranking_in": ["{her} enters the London region rankings at number {rank}."],
	"ranking_up": ["{her} moves up to number {rank} in the London region."],
	"gym_life": ["{members} members on the books at {gym}."],
	"why_join": ["The coaching is proper and the people are friendly.", "A local fighter wins here.", "The kit is good and the dues are fair."],
}

static var _bank: Dictionary = {}


static func bank() -> Dictionary:
	if _bank.is_empty():
		_bank = NEWS_FALLBACK.duplicate(true)
		if FileAccess.file_exists(NEWS_PATH):
			var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(NEWS_PATH))
			if parsed is Dictionary:
				for k in (parsed as Dictionary).keys():
					if parsed[k] is Array and not (parsed[k] as Array).is_empty():
						_bank[k] = parsed[k]
	return _bank


static func line(kind: String, subs: Dictionary, seed_value: int) -> String:
	var pool: Array = bank().get(kind, [])
	if pool.is_empty():
		return ""
	return FightWords.fill(str(pool[absi(seed_value) % pool.size()]), subs)


## The names every news line may use, plus the line's own.
static func subs_for(c: Career, own: Dictionary) -> Dictionary:
	var f := c.fighter()
	var base := {"gym": c.gym_name, "city": c.city, "members": c.members,
		"her": f["name"] if not f.is_empty() else "one of our members", "rank": int(f.get("rank", 0))}
	return base.merged(own, true)


static func is_show_day(day: int) -> bool:
	return day >= Data.SHOW_FIRST_DAY and (day - Data.SHOW_FIRST_DAY) % Data.SHOW_EVERY_DAYS == 0


static func show_name(day: int) -> String:
	var i := int((day - Data.SHOW_FIRST_DAY) / float(Data.SHOW_EVERY_DAYS))
	return Data.SHOW_NAMES[posmod(i, Data.SHOW_NAMES.size())]


## The next n show days after `day` (strictly after).
static func next_shows(day: int, n: int) -> Array:
	var out: Array = []
	var d := Data.SHOW_FIRST_DAY
	if day >= d:
		d += (int((day - d) / float(Data.SHOW_EVERY_DAYS)) + 1) * Data.SHOW_EVERY_DAYS
	while out.size() < n:
		out.append(d)
		d += Data.SHOW_EVERY_DAYS
	return out


## After each day: on a show day the rivals fight. Sim.step_day calls it.
static func day_events(c: Career) -> void:
	if is_show_day(c.day + SHOW_NOTICE_DAYS):
		c.add_news(line("show", subs_for(c, {"show": show_name(c.day + SHOW_NOTICE_DAYS)}), c.day), false)
	if c.day > 0 and c.day % GYM_NEWS_EVERY_DAYS == GYM_NEWS_DAY:
		c.add_news(line("gym_life", subs_for(c, {}), int(c.day / 7.0)), false)
	if not is_show_day(c.day):
		return
	var rng := RandomNumberGenerator.new()
	rng.seed = c.day * 97 + 11
	var busy: Array = []
	var ours: Array = []
	for f in c.fighters:
		ours.append(str(f["div"]))
		if not (f["bout"] as Dictionary).is_empty():
			busy.append(str(f["bout"]["opp"]["name"]))
	var show := show_name(c.day)
	for div in Data.DIVISIONS.keys():
		var pool: Array = c.rivals.filter(func(r): return str(r["div"]) == div and not busy.has(str(r["name"])))
		for i in range(pool.size() - 1, 0, -1):
			var j := rng.randi_range(0, i)
			var t: Variant = pool[i]
			pool[i] = pool[j]
			pool[j] = t
		var fought := 0
		while pool.size() >= 2 and fought < SHOW_BOUTS:
			var a: Dictionary = pool.pop_front()
			var partner := -1
			for k in pool.size():
				if AmateurBooking.experience_match_ok(_bouts(a), _bouts(pool[k])) and AmateurBooking.experience_match_ok(_bouts(pool[k]), _bouts(a)):
					partner = k
					break
			if partner < 0:
				continue
			var b: Dictionary = pool.pop_at(partner)
			_rival_bout(c, a, b, show, rng, ours.has(div))
			fought += 1
	for f in c.fighters:
		update_rank(c, f)


static func _bouts(r: Dictionary) -> int:
	return AmateurBooking.bouts_of(int(r["w"]), int(r["l"]))


## told = whether the news says so (only divisions where the gym has a fighter make the feed).
static func _rival_bout(c: Career, a: Dictionary, b: Dictionary, show: String, rng: RandomNumberGenerator, told: bool) -> void:
	var sa := float(a["rating"]) + (rng.randf() - 0.5) * ROUND_SPREAD
	var sb := float(b["rating"]) + (rng.randf() - 0.5) * ROUND_SPREAD
	var winner := a if sa >= sb else b
	var loser := b if sa >= sb else a
	record(winner, true)
	record(loser, false)
	var stop := absf(sa - sb) > STOPPAGE_GAP and rng.randf() < STOPPAGE_ROLL
	if not told:
		return
	c.add_news(line("rival_stop" if stop else "rival_win", subs_for(c, {"winner": winner["name"], "loser": loser["name"],
		"winner_club": winner["club"], "loser_club": loser["club"], "show": show}), c.day + rng.randi_range(0, 99)), false)


## Books one result on a rival's record and nudges her rating.
static func record(r: Dictionary, won: bool) -> void:
	if won:
		r["w"] = int(r["w"]) + 1
		r["rating"] = float(r["rating"]) + WIN_RATING
	else:
		r["l"] = int(r["l"]) + 1
		r["rating"] = float(r["rating"]) + LOSS_RATING


## A division's amateurs, best first: net wins, then wins, then rating. Our amateur fighters in it are ranked from
## RANK_MIN_WINS wins (a pro leaves the amateur rankings). [{name, club, w, l, ours, fid}]
static func rankings(c: Career, div: String = "wlw") -> Array:
	var rows: Array = []
	for r in c.rivals:
		if str(r["div"]) == div:
			rows.append({"name": r["name"], "club": r["club"], "w": int(r["w"]), "l": int(r["l"]), "rating": float(r["rating"]),
				"ours": false, "fid": ""})
	for f in c.fighters:
		if str(f["div"]) == div and int(f["w"]) >= RANK_MIN_WINS and not bool(f.get("pro", false)):
			rows.append({"name": f["name"], "club": c.gym_name, "w": int(f["w"]), "l": int(f["l"]), "rating": 0.0, "ours": true,
				"fid": f["id"]})
	rows.sort_custom(func(x, y):
		var nx := int(x["w"]) - int(x["l"])
		var ny := int(y["w"]) - int(y["l"])
		if nx != ny:
			return nx > ny
		if int(x["w"]) != int(y["w"]):
			return int(x["w"]) > int(y["w"])
		return float(x["rating"]) > float(y["rating"]))
	return rows


## Her place (1-based) in her division, 0 when unranked.
static func our_rank(c: Career, f: Dictionary) -> int:
	var rows := rankings(c, str(f["div"]))
	for i in rows.size():
		if str(rows[i]["fid"]) == str(f["id"]):
			return i + 1
	return 0


## Updates her stored rank and says so in the news when she enters or climbs.
static func update_rank(c: Career, f: Dictionary) -> void:
	var now := our_rank(c, f)
	var was := int(f.get("rank", 0))
	if now > 0 and (was == 0 or now < was):
		c.add_news(line("ranking_in" if was == 0 else "ranking_up", subs_for(c, {"rank": now, "her": f["name"]}), c.day))
	f["rank"] = now


## Three reasons members give for joining, fixed per week.
static func why_join(c: Career) -> Array:
	var pool: Array = bank()["why_join"]
	var out: Array = []
	var start := Clock.week_of(c.day) * 3
	for i in mini(3, pool.size()):
		out.append(FightWords.fill(str(pool[(start + i) % pool.size()]), {"gym": c.gym_name, "city": c.city}))
	return out
