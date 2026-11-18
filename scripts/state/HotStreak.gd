extends RefCounted
## S518 LADDERWIRE R6 (map ops/research/DESIGN_LADDER1_V6_DOLA.md R6): "your heat" - a boxer who has won her last 3 bouts
## and gained 15+ ladder points in the last 8 weeks is ON A RUN. A rival corner 0-8 points above her leans No (-20 on the
## yes score); such a No marks the rival DUCKED; two ducks inside 8 weeks make the next ask to that rival OWED (they must
## say yes - RivalOffer.owed / owed_answer). Reads c.results (newest first, BoutFinish), whose "pts" is the ladder points
## the bout moved for our boxer.
##   hot(c, f)                 -> bool
##   words(c, f)               -> "" or the chip line ("On a run: 3 wins, +17 points in 8 weeks.")
##   duck(c, f, opp_name)      records a duck (a No while hot, the rival 0-8 points above): f["ducks"][name] = [weeks]
##   is_owed(c, f, opp_name)   two ducks inside 8 weeks
##   ducks_of(c, f, opp_name)  ducks inside the window
##   clear(f, opp_name)        the owed bout is booked: the slate is clean

const RivalOffer := preload("res://scripts/rules/RivalOffer.gd")
const RankLine := preload("res://scripts/rules/RankLine.gd")
const WINS := 3
const POINTS := 8   # S519 STREAKPROBE1: 15 read ON A RUN 1.2% of active weeks; 8 reads 11.6%, 1.4 runs a season (target 10-30%)
const WEEKS := 8
const GAP := 8


## Her amateur results, newest first.
static func _mine(c: Career, f: Dictionary) -> Array:
	return c.results.filter(func(r): return str(r.get("fid", "")) == str(f["id"]) and not bool(r.get("pro", false)))


static func _read(c: Career, f: Dictionary) -> Dictionary:
	var mine := _mine(c, f)
	var run := 0
	for r in mine:
		if not bool(r.get("win", false)):
			break
		run += 1
	var pts := 0
	for r in mine:
		if c.day - int(r.get("d", 0)) > WEEKS * 7:
			break
		pts += int(r.get("pts", 0))
	return {"run": run, "pts": pts}


static func hot(c: Career, f: Dictionary) -> bool:
	var r := _read(c, f)
	return int(r["run"]) >= WINS and int(r["pts"]) >= POINTS


static func words(c: Career, f: Dictionary) -> String:
	if not hot(c, f):
		return ""
	var r := _read(c, f)
	return "On a run: %d wins, +%d points in %d weeks." % [int(r["run"]), int(r["pts"]), WEEKS]


## Does a No from this rival count as a duck? She is 0-8 ladder points above our boxer and our boxer is on a run.
static func would_duck(c: Career, f: Dictionary, opp: Dictionary, said_no: bool) -> bool:
	return RivalOffer.ducked(RankLine.rep(opp) - RankLine.rep(f), said_no, hot(c, f))


static func ducks_of(c: Career, f: Dictionary, opp_name: String) -> Array:
	var week := int(c.day / 7)
	return ((f.get("ducks", {}) as Dictionary).get(opp_name, []) as Array).filter(
		func(w): return week - int(w) >= 0 and week - int(w) < RivalOffer.DUCK_WINDOW)


static func duck(c: Career, f: Dictionary, opp_name: String) -> void:
	if not f.has("ducks"):
		f["ducks"] = {}
	var keep := ducks_of(c, f, opp_name)
	if keep.has(int(c.day / 7)):   # asking twice in one week is one duck, never an instant OWED
		return
	keep.append(int(c.day / 7))
	f["ducks"][opp_name] = keep


static func is_owed(c: Career, f: Dictionary, opp_name: String) -> bool:
	return RivalOffer.owed(ducks_of(c, f, opp_name), int(c.day / 7))


static func clear(f: Dictionary, opp_name: String) -> void:
	if f.has("ducks"):
		(f["ducks"] as Dictionary).erase(opp_name)
