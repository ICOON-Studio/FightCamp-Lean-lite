extends RefCounted
## S488 HOMEBOUT1 (R58 map section 8): the promised top of our club show is a real bout. PROMISE: OUR SHOW books the
## boxer a legal novice (Bouts.legal_index, England Boxing's novice rule) on the show's night; the gate is ours, so the
## club takes no ticket cut; the bout is fought like any club-show bout (weigh-in, fight week, the fight). The promise is
## kept by boxing it (BoutFinish calls boxed); missed weight, a pull-out or no bout on the night breaks it.
##   reason(c, f)       "" when the boxer can be put on our show, else why not (the card greys the answer with it)
##   book(c, f, day)    the bout booked for the show's day; f["bout"]["home"] = true
##   is_home(f)         the booked bout is our show's
##   boxed(c, f)        the night's fight is over: the boxer's open show_top promise is kept (+loyalty)
##   sweep(c)           an open show_top promise whose night has passed with no bout boxed is broken (the boxer leaves)
## Bouts is loaded at run time (Bouts -> BoutNight -> BoutFinish preloads this file: a preload back would be a cycle).

const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")
const Promises := preload("res://scripts/rules/Promises.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const Newcomers := preload("res://scripts/state/Newcomers.gd")   # S517 the sheet refills with novices
const Data := preload("res://scripts/state/Data.gd")

const BOUTS := "res://scripts/state/Bouts.gd"


## The legal novice for our show from the boxer's division, or {} when nobody in it may meet the boxer.
static func opponent(c: Career, f: Dictionary) -> Dictionary:
	if not Data.DIVISIONS.has(str(f.get("div", ""))):
		return {}
	var names: Array = Newcomers.sheet(c, str(f["div"]))
	if names.is_empty():
		return {}
	var own := AmateurBooking.bouts_of(int(f["w"]), int(f["l"]))
	var i: int = load(BOUTS).legal_index(c, names, int(f.get("opp_index", 0)), own)
	var r := c.rival(str(names[i]))
	if r.is_empty() or not AmateurBooking.experience_match_ok(own, AmateurBooking.bouts_of(int(r["w"]), int(r["l"]))):
		return {}
	return r


static func reason(c: Career, f: Dictionary) -> String:
	if bool(f.get("pro", false)):
		return "a pro does not box on a club show"
	if not (f.get("bout", {}) as Dictionary).is_empty():
		return "a bout is already booked"
	if opponent(c, f).is_empty():
		return "no legal novice in the class for our show"
	return ""


## Books the show's bout through the ordinary offer and accept (fight week, the coach's read, the news); "" when booked.
static func book(c: Career, f: Dictionary, day: int) -> String:
	var why := reason(c, f)
	if why != "":
		return why
	var bouts: GDScript = load(BOUTS)
	var id := "%s:h%d" % [f["id"], c.day]
	var own := AmateurBooking.bouts_of(int(f["w"]), int(f["l"]))
	f["offers"] = [bouts._offer(id, opponent(c, f).duplicate(true), day, c.day, own)]
	if not bouts.accept(c, id):
		return "the bout could not be booked"
	f["bout"]["home"] = true
	return ""


static func is_home(f: Dictionary) -> bool:
	return bool((f.get("bout", {}) as Dictionary).get("home", false))


## The night's bout is over: the promise for tonight is kept (a boxed bout is fit and made weight by definition).
static func boxed(c: Career, f: Dictionary) -> void:
	_resolve(c, f, {"day": c.day, "fit": true, "made_weight": true, "boxed": true})


## Open show_top promises whose night is behind us were not boxed: broken (Promises.resolve: the boxer leaves).
static func sweep(c: Career) -> void:
	for p in c.promises.duplicate():
		if str(p["kind"]) == Promises.SHOW_TOP and str(p["state"]) == "open" and int(p["by_day"]) < c.day:
			_resolve(c, c.fighter_by_id(str(p["fid"])), {"day": c.day, "fit": false, "made_weight": false, "boxed": false}, str(p["fid"]))


## Resolves the boxer's open show_top promise due by today; the loyalty, the leaving and the news as ApproachWire.show_night.
static func _resolve(c: Career, f: Dictionary, v: Dictionary, fid: String = "") -> void:
	var id := fid if fid != "" else str(f.get("id", ""))
	for p in c.promises:
		if str(p["kind"]) != Promises.SHOW_TOP or str(p["state"]) != "open" or str(p["fid"]) != id or int(p["by_day"]) > c.day:
			continue
		var r := Promises.resolve(p, v)
		if str(r["state"]) == "open":
			continue
		p["state"] = r["state"]
		if f.is_empty():
			continue
		Loyalty.commit(f, int(r["loyalty"]), "promise_" + str(r["state"]), c.day)
		f.erase("ticks_wait_until")
		if bool(r["leaves"]):
			f["leaves_after"] = c.day
			f["leaves_why"] = "promise"
		c.add_news("%s: %s." % [f["first"], str(r["line"])])
