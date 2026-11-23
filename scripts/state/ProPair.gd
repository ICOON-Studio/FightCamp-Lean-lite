extends RefCounted
## S543 TURNPROBUILD17 step 3 (turning pro v17, owner Q-S294-320 "Yes, build it", Q-S294-323 "Yes, build v17 now"; map
## ops/research/DESIGN_TURNPRO1_V17.md section 2): pro fights 1 to 6 offer TWO bouts side by side, SAFE (the promoter's
## tune-up, 75-90% to win) and RISKY (the step up, 40-55%, purse x1.75, name +3). The rules are ProStart; this file makes
## the two opponents, books the pick, settles the bars after the bell and opens the next booking.
## HOW THE MEN ARE FOUND: each sex has two fixed men per fight (TURNPROBE17's pools: rated so the sex's middle boxer reads
## ProLadder.TUNE_AIM 0.82 and STEP_READ 0.50 at the offer), each fight's men +0.3 rating. The game's read of the bout
## (the debut read's walk: BoutRead.round_edges on a 4-round card) gives the chance. When that read falls outside the bout's
## band the matchmaker finds another man: the rating gap is SEARCHED (DebutPick.search) until the read sits just inside
## the band. The printed number is never squeezed afterwards.
## CONFIDENCE moves the fight, not a printed number: bout["conf_edge"] (power points, every round) is read by the live
## round (LiveRound) and the read (BoutRead) alike, BoutRules.conf_edge. One fixed edge moved a near-even bout twice as far
## as a safe one (tools/conf_edge_probe.gd, ten boxers: at 2.0 points risky 8 points, safe 3-6), so the edge is SOLVED per
## bout (conf_edge_for): the power edge whose read moves by ProStart.shift(confidence), never past it - 0 -> -5 points,
## 100 -> +5. The chance printed is the read WITH that edge: the chance the fight is fought at.
## THE NEXT BOOKING: after a pair fight the booking opens the next day (day_events): ProStart.booking_check (a warning at
## hunger 0, gone at the third) and the next pair; after fight 6 the normal booking (ProLadder._make_offers) takes over.
## While the pair runs f["pro_next"] holds (HOLD) so ProLadder brings no offers beside it.
##   make(c, f, n, base, fx) -> {fight, safe, risky}   book(c, f, kind)   after_bout(c, f, kind, result) -> moved
##   day_events(c)   trained(c, f, weeks)   read(f, opp, coach, edge)   conf_edge_for(...)   warning_line(f)

const ProStart := preload("res://scripts/rules/ProStart.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")
const DebutPick := preload("res://scripts/rules/DebutPick.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")
const MM := preload("res://scripts/rules/Matchmaking.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")

const ROUNDS := 4                    ## pro fights 1-6 are four-rounders (Roster.PRO_ROUNDS, ProLadder.ROUNDS_UNRANKED)
const PROMOTER := "Bow Lane Promotions"   ## mirrors Roster.PROMOTER: one promoter (v17)
const POOL := {"f": {"safe": 43.0, "risky": 49.65}, "m": {"safe": 43.85, "risky": 50.95}}   ## TURNPROBE17's fixed men
const OPP_RISE := 0.3                ## each fight's men a little better (records climb)
const EDGE_LIMIT := 6.0              ## the most power points confidence may put on a round (the search's range)
const EDGE_STEPS := 14               ## halvings of that range: about 0.0004 power points
const EDGE_IN := 0.01                ## a searched man is aimed this far inside the band's edge
const LATER_WEEKS := 4               ## the pop-up's "four weeks on" read
const HOLD := 1 << 30                ## pro_next while the pair runs: ProLadder makes no offers
const NAMES_M := ["Callum Reyes", "Darren Platt", "Jamal Otieno", "Lewis Hardcastle", "Ryan Kettle", "Marcus Bello",
	"Sean Varley", "Tomas Novak", "Kieran Ashby", "Ade Okafor", "Liam Prentice", "Joel Marsh"]
const NAMES_F := ["Kayleigh Doran", "Stacey Mills", "Jodie Kerr", "Paige Whitlow", "Megan Royce", "Tasha Bright",
	"Ellie Strand", "Nadia Ferris", "Carly Wren", "Amira Hale", "Becky Thorne", "Lena Voss"]


static func state(f: Dictionary) -> Dictionary:
	if not f.has("pro_start"):
		f["pro_start"] = ProStart.new_state()
	return f["pro_start"]


## The power edge confidence puts on every round of this bout: the edge whose read moves raw by ProStart.shift(conf)
## (linear, 0 at confidence 50), kept on the side that never moves it further. The read rises with the edge.
static func conf_edge_for(f: Dictionary, opp: Dictionary, coach: float, raw: float, conf: int) -> float:
	var want := ProStart.shift(conf)
	if is_zero_approx(want):
		return 0.0
	var inner := 0.0
	var outer := EDGE_LIMIT * signf(want)
	for i in EDGE_STEPS:
		var mid := (inner + outer) * 0.5
		if absf(read(f, opp, coach, mid) - raw) <= absf(want):
			inner = mid
		else:
			outer = mid
	return snappedf(inner, 0.0001)


## The game's read of a pair bout: the debut read's walk (DebutRead.card) on a 4-round card, with the confidence edge.
static func read(f: Dictionary, opp: Dictionary, coach: float, edge: float) -> float:
	var fx := f.duplicate()
	fx["pro"] = true
	fx["bout"] = {"tank_ahead": 0.0, "pro": true, "rounds": ROUNDS, "conf_edge": edge}
	var edges := BoutRead.round_edges(fx, opp, {"protocol": BoutRead.USUAL_CAMP}, coach)
	return float(BoutRead.CardOdds.result(edges, BoutRead.RingDuel.FORM_SD)["win"])


## One opponent: the debut opponent's rule (DebutOpp.make) at this gap, named and recorded for the fight and the kind.
static func opp_for(f: Dictionary, n: int, kind: String, gap: float) -> Dictionary:
	var o := DebutOpp.make(f, gap, 0, PROMOTER)
	var names: Array = NAMES_M if str(f.get("sex", "f")) == "m" else NAMES_F
	var nm := str(names[((n - 1) * 2 + (1 if kind == "risky" else 0)) % names.size()])
	o["name"] = nm
	o["first"] = nm.split(" ")[0]
	o["w"] = n + 2 if kind == "risky" else n + 1   # the step up is unbeaten; the tune-up a journeyman with a losing record
	o["l"] = 0 if kind == "risky" else 2 * n + 3
	return o


## One bout of fight n for boxer f (fx = the boxer as read, e.g. four weeks on): the fixed man, searched into the band.
static func bout_for(f: Dictionary, n: int, kind: String, coach: float, conf: int, base: int) -> Dictionary:
	var sex := "m" if str(f.get("sex", "f")) == "m" else "f"
	var gap := DebutOpp.night(f["stats"]) - (float(POOL[sex][kind]) + OPP_RISE * float(n - 1))
	var read_of := func(gp: float) -> float: return read(f, opp_for(f, n, kind, gp), coach, 0.0)
	var raw := float(read_of.call(gap))
	var band: Vector2 = ProStart.RISKY_BAND if kind == "risky" else ProStart.SAFE_BAND
	if raw < band.x or raw > band.y:
		var found := DebutPick.search(read_of, clampf(raw, band.x + EDGE_IN, band.y - EDGE_IN))
		gap = float(found["gap"])
		raw = float(found["read"])
		for i in 20:   # the 0.1 grid can land a hair outside: one step at a time back in
			if raw >= band.x and raw <= band.y:
				break
			gap += DebutPick.STEP if raw < band.x else -DebutPick.STEP
			raw = float(read_of.call(gap))
	var opp := opp_for(f, n, kind, gap)
	var edge := conf_edge_for(f, opp, coach, raw, conf)
	var chance := raw if is_zero_approx(edge) else read(f, opp, coach, edge)
	return {"kind": kind, "opp": opp, "gap": snappedf(gap, 0.1), "raw": raw, "chance": chance, "edge": edge,
		"purse": ProStart.purse(base, kind), "name": ProStart.name_gain(kind)}


## The two bouts of pro fight n. base = the purse the safe bout pays; fx = the boxer to read (default: as today).
static func make(c: Career, f: Dictionary, n: int, base: int, fx: Dictionary = {}) -> Dictionary:
	var who: Dictionary = f if fx.is_empty() else fx
	var coach := float(c.coach.get("rating", 0.0))
	var conf := int(state(f)["conf"])
	var out := {"fight": n, "day": c.day, "conf": conf}
	for kind in ProStart.KINDS:
		out[kind] = bout_for(who, n, kind, coach, conf, base)
	return out


## The boxer after weeks of the club's training on the current focus (TrainingPreview.plan_gain, the gym's coach).
static func trained(c: Career, f: Dictionary, weeks: int) -> Dictionary:
	var g := f.duplicate()
	var st: Dictionary = (f["stats"] as Dictionary).duplicate()
	var coach := float(c.coach.get("rating", 0.0))
	for i in weeks:
		var gain := TrainingPreview.plan_gain(st, int(f.get("pot", 75)), str(f.get("focus", "conditioning")), coach)
		for k in gain:
			st[k] = float(st[k]) + float(gain[k])
	g["stats"] = st
	g.erase("attrs")
	return g


## Book the pick. The night is the fight's due day (the debut 4 weeks after signing, then 8 weeks apart, +8 after a
## stoppage), at least a week out; booking it later than due costs hunger like any idle month (ProStart.rest).
static func book(c: Career, f: Dictionary, kind: String) -> bool:
	var p: Dictionary = f.get("pro_pair", {})
	if p.is_empty() or not p.has(kind) or not (f.get("bout", {}) as Dictionary).is_empty():
		return false
	var b: Dictionary = p[kind]
	var due := int(f.get("pro_due", c.day))
	var day := maxi(due, c.day - posmod(c.day, 7) + 5 + 7)
	var late := int((day - due) / 7)
	if late >= ProStart.IDLE_WEEKS:
		ProStart.rest(state(f), late)
	f["bout"] = {"opp": (b["opp"] as Dictionary).duplicate(true), "day": day, "weighed": false, "made": false, "done": false,
		"film": BoutRules.FILM_DEPTH_DEFAULT, "pro": true, "rounds": ROUNDS, "purse": int(b["purse"]), "terms": 1.0,
		"tickets": int(p["fight"]) == 1, "pair_kind": kind, "pair_fight": int(p["fight"]), "conf_edge": float(b["edge"]),
		"chance": float(b["chance"])}
	f["booked_fight"] = true
	f["pro_pair"] = {}
	c.add_news("%s takes %s for pro fight %d (%s): %s, %d rounds." % [f["name"], b["opp"]["name"], int(p["fight"]),
		str(ProStart.KIND_IS[kind]), Clock.fmt(day), ROUNDS])
	return true


## After the bell of a pair bout: result "win" | "points" (lost on the cards, or a draw) | "ko" (stopped). The bars and
## the name move (ProStart.after_fight), the name is added to the club's reputation, a stoppage's medical rest costs
## hunger; the next booking opens tomorrow. Returns what moved {conf, hunger, name}.
static func after_bout(c: Career, f: Dictionary, kind: String, result: String) -> Dictionary:
	var s := state(f)
	var moved := ProStart.after_fight(s, kind, result)
	c.reputation += int(moved["name"])
	var rest := MM.STOP_REST_WEEKS if result == "ko" else 0
	if rest > 0:
		moved["hunger"] = int(moved["hunger"]) + ProStart.rest(s, rest)
	f["pro_due"] = c.day - posmod(c.day, 7) + 5 + (MM.NEXT_WEEKS + rest) * 7
	f["pro_open"] = c.day + 1
	f["pro_next"] = HOLD
	var e := ProLadder.entry(c, f)
	if not e.is_empty():   # the table keeps the record (a pair bout is not a ladder bout)
		for k in ["w", "l", "d"]:
			e[k] = int(f.get("pro_" + k, 0))
	return moved


## Once a day (Sim.step_day): a booking that opens today checks the hunger first (a warning, or gone at the third), then
## brings the next pair; after fight 6 it hands the fighter to the normal booking.
static func day_events(c: Career) -> void:
	for f in c.fighters.duplicate():
		if not f.has("pro_open") or c.day < int(f["pro_open"]) or not (f.get("bout", {}) as Dictionary).is_empty():
			continue
		f.erase("pro_open")
		var s := state(f)
		var said := ProStart.booking_check(s)
		if said == "gone":
			f["pro_next"] = c.day
			load("res://scripts/state/Leaving.gd").leave(c, str(f["id"]), "hunger")
			continue
		if said == "warn":
			c.add_news("%s has lost the hunger and asks to leave: warning %d of %d. A risky bout brings it back." % [
				f["name"], int(s["warn"]), ProStart.WARNINGS], true, true)
		if ProStart.on(s):
			f["pro_pair"] = make(c, f, int(s["fights"]) + 1, int(f.get("purse", 1500)))
			c.add_news("%s's promoter has two fights for pro fight %d: a tune-up and a step up (Fights)." % [f["first"], int(s["fights"]) + 1])
		else:
			f["pro_next"] = maxi(c.day, int(f.get("pro_due", c.day)) - ProLadder.LEAD_DAYS)


## The boxer card's line at hunger 0 ("" otherwise).
static func warning_line(f: Dictionary) -> String:
	var s: Dictionary = f.get("pro_start", {})
	if s.is_empty() or int(s.get("warn", 0)) <= 0 or int(s.get("hunger", 1)) > 0:
		return ""
	return "Warning %d of %d: the boxer has lost the hunger and asks to leave. A risky bout brings it back; a third booking at 0 and the boxer goes." % [
		int(s["warn"]), ProStart.WARNINGS]
