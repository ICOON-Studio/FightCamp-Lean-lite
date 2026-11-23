extends RefCounted
## TURNPROBE15 (S537) GREYBOX - NOT GAME CODE. Map v15's proposed turning-pro rules (ops/research/DESIGN_TURNPRO1_V15.md
## sections 3 to 5) as a LOCAL COPY for tools/turnprobe15.gd, so the map is measured before any critic scores it and before
## anything under scripts/ is touched (S534 DEPTH METHOD). Every constant here is the MAP's proposal; the game's own rules
## (ProCall, DebutPick, BoutFinish, ProLadder, Matchmaking) are the control arm and are called, never copied.
## v15 = v14 with the three bars probe 14 failed fixed (docs/TURNPROBE14_RESULT.md): (a) THE FAVOUR IS THE SLOT ON THE CARD.
## Favour 8+ = top of the bill: the gym's ticket block (TOP_BLOCK, both houses), the guarantee house's +$300 purse, the
## ticket house's area title shot. Favour under 3 = bottom of the bill: the fight is dated BOTTOM_DAYS later. v14's "only
## the house's kind under 3" is CUT (it helped the rebel). (b) a tune-up win makes TUNE_NAME 1, not 2. (c) the card reads
## the boxer's own nights (card(), OWN_* below).

const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")
const DebutPick := preload("res://scripts/rules/DebutPick.gd")
const DebutRead := preload("res://scripts/rules/DebutRead.gd")
const MM := preload("res://scripts/rules/Matchmaking.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const ProLean := preload("res://scripts/state/ProLean.gd")
const ProOfferWire := preload("res://scripts/state/ProOfferWire.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const WR := preload("res://scripts/world/WorldRank.gd")

const AIMS := {"bow": {"test": 0.60, "build": 0.70}, "hf": {"build": 0.78, "test": 0.68}}   ## the card each debutant is picked to
const OWN := {"bow": "test", "hf": "build"}       ## the debutant each house would rather put up
const PREF := {"bow": "above", "hf": "tune"}      ## the kind each house prefers (mirrors ProLean.LEAN_KIND)
const WEEK_POINT := 0.01        ## the read counts the camp weeks PAST FOUR only: 1 point a week (probe 11, item 4)
const WEEKS_FREE := 4
const GAP_MIN := -6.0
const GAP_MAX := 14.0
const TUNE_NAME := 1            ## a tune-up win is worth this much reputation, not BoutRules.WIN_REPUTATION (5)
const WIN_NAME := 5             ## mirrors BoutRules.WIN_REPUTATION (a step up, a payday, a title fight, a rebuild fight)
const LATER_FEE := 150
const LATER_WEEKS := 2
const NAME_PER_SEATS := {"bow": 4, "hf": 8}   ## a TEST debut won: +1 reputation for this many seats sold on the night
const NAME_TOP := 20
const ROAD_FIGHTS := 6          ## the road: the debut and the five sets after it (ProLean.LEAN_FIGHTS counts the debut)
const TUNE_WIDE := Vector2(0.60, 0.97)   ## when the promoter's own band (0.70-0.93) holds nobody, the nearest it can find
const FAV_START := 5
const FAV_MAX := 10
const FAV_HIGH := 8             ## at this favour the house's door opens
const FAV_LOW := 3              ## under this the house brings only its own kind
const HF_PURSE := 300           ## the guarantee house at FAV_HIGH: this much more a purse
const TOP_BLOCK := 250           ## top of the bill (favour FAV_HIGH+), both houses: the gym's block of tickets, paid to the gym a fight
const BOTTOM_DAYS := 21         ## bottom of the bill (favour under FAV_LOW): the house dates the fight this much later
const TITLE_READ := 0.45        ## the keeper bot takes the title shot when it is read at least this
const TITLE_WINS := 4           ## the ticket house at FAV_HIGH: an area title shot once the boxer has this many pro wins


## The game's read of the game's own debutant (before the card's own terms).
static func read(f: Dictionary, t: Dictionary, coach: float) -> float:
	var opp: Dictionary = DebutOpp.make(f, float(t.get("opp_gap", 0.0)), int(t.get("opp_day", 0)), str(t.get("name", "")))
	var fx: Dictionary = f.duplicate()
	fx["pro"] = true
	fx["bout"] = {"tank_ahead": 0.0, "pro": true, "rounds": DebutRead.ROUNDS}
	var out: Dictionary = BoutRead.CardOdds.result(BoutRead.round_edges(fx, opp, {"protocol": BoutRead.USUAL_CAMP}, coach), BoutRead.RingDuel.FORM_SD)
	return float(out["win"])


## What the boxer's own nights add to a read of `raw`. own = [read 1, played less read 1, read 2, played less read 2]: two
## debutants of this house (an easier and a harder one), camped and played ahead on scratch nights by the probe; a straight
## line between them (and a little past them).
static func own_at(own: Array, raw: float) -> float:
	if own.size() < 4 or is_equal_approx(float(own[0]), float(own[2])):
		return 0.0
	var k := clampf((raw - float(own[0])) / (float(own[2]) - float(own[0])), -0.5, 1.5)
	return lerpf(float(own[1]), float(own[3]), k)


## The chance the v15 card shows: the read, plus what the boxer's OWN NIGHTS add to it (own_at; v14's flat "favourite's
## lift" is CUT), plus a point a camp week past four.
static func card(f: Dictionary, t: Dictionary, coach: float) -> float:
	var raw := read(f, t, coach)
	return raw + own_at(t.get("own", []), raw) + WEEK_POINT * float(maxi(0, int(t.get("debut_weeks", 4)) - WEEKS_FREE))


## DebutPick's search on the v15 card: the gap whose shown chance is nearest the aim of the debutant asked for ("build" or
## "test"). The house's misjudgement for this boxer (DebutPick.target less its aim) moves both debutants alike.
static func repick(f: Dictionary, t: Dictionary, coach: float, pick: String) -> float:
	var house := str(t.get("key", ""))
	# pick = "build" / "test", or a number: the plain read to find (the probe's own-nights debutants)
	var want := float(pick) if pick.is_valid_float() else float(t.get("opp_target", DebutPick.aim(house))) - DebutPick.aim(house) + float(AIMS[house][pick])
	var lo := roundi(GAP_MIN * 10.0)
	var hi := roundi(GAP_MAX * 10.0)
	var t2: Dictionary = t.duplicate()
	while hi - lo > 1:
		var mid := (lo + hi) >> 1
		t2["opp_gap"] = float(mid) * 0.1
		if card(f, t2, coach) < want:
			lo = mid
		else:
			hi = mid
	t2["opp_gap"] = float(lo) * 0.1
	var r_lo := card(f, t2, coach)
	t2["opp_gap"] = float(hi) * 0.1
	var r_hi := card(f, t2, coach)
	return snappedf(float(hi if absf(r_hi - want) <= absf(r_lo - want) else lo) * 0.1, 0.1)


## Signs the house under v15 with the debutant picked. The house's favour starts at 5: its own debutant +1, the other -1.
static func sign(c: Career, f: Dictionary, house: String, pick: String, ask: String, own: Array) -> Dictionary:
	var o: Dictionary = c.pro_offer
	var coach := float(c.coach.get("rating", 0.0))
	var t: Dictionary = ProOfferWire.offer(o, house).duplicate()
	t["own"] = own
	t["opp_gap"] = repick(f, t, coach, pick)
	var plain := card(f, t, coach)
	if ask == "later2":
		t["purse"] = maxi(0, int(t["purse"]) - LATER_FEE)
		t["debut_weeks"] = int(t["debut_weeks"]) + LATER_WEEKS
	var shown := card(f, t, coach)
	var list: Array = o["offers"]
	for i in list.size():
		if str(list[i]["key"]) == house:
			list[i] = t
	Roster.turn_pro(c, house)
	f["v15"] = {"house": house, "pick": pick, "fav": FAV_START + (1 if pick == str(OWN[house]) else -1)}
	return {"gap": float(t["opp_gap"]), "plain": plain, "shown": shown, "raw": read(f, t, coach), "own": own}


static func favour(f: Dictionary) -> int:
	return int((f.get("v15", {}) as Dictionary).get("fav", FAV_START))


## The night's lasting effects under v15, applied after the game's own result. A TEST debut won makes the name by the seats
## (the ticket house 1 a 4 seats, the guarantee house 1 a 8) and, at the ticket house, takes the table's last seat.
static func after_debut(c: Career, f: Dictionary, house: String, pick: String, sold: int, outcome: String, stopped: bool, gap: float) -> Dictionary:
	var out := {"name": 0, "seat": 0, "fans": 0, "rebuild": false}
	var e: Dictionary = ProLadder.entry(c, f)
	if e.is_empty():
		return out
	if outcome == "win":
		var fans := 1 + int(stopped) - int(-gap <= -MM.SOFT_GAP)
		e["fans"] = clampi(int(e.get("fans", 0)) + fans, MM.FANS_MIN, MM.FANS_MAX)
		out["fans"] = fans
		if pick == "test":
			var name_pts := mini(NAME_TOP, int(sold / int(NAME_PER_SEATS[house])))
			c.reputation += name_pts
			out["name"] = name_pts
			if house == "bow":
				out["seat"] = last_seat(c, f, e)
	elif outcome == "loss":
		var lost := MM.loss_fans(-gap)
		e["fans"] = clampi(int(e.get("fans", 0)) - lost, MM.FANS_MIN, MM.FANS_MAX)
		e["rebuild"] = true
		out["fans"] = -lost
		out["rebuild"] = true
	return out


## The table's last ranked seat goes to the boxer (the body of ProLadder._review_streak, without its 5-win gate).
static func last_seat(c: Career, f: Dictionary, e: Dictionary) -> int:
	if int(e.get("rank", 0)) > 0:
		return int(e["rank"])
	var last: Dictionary = {}
	for b in ProLadder.table(c, f):
		var r := int(b.get("rank", 0))
		if b != e and r > 0 and not b.get("retired", false) and (last.is_empty() or r > int(last["rank"])):
			last = b
	if last.is_empty():
		return 0
	e["rank"] = int(last["rank"])
	last["rank"] = 0
	return int(e["rank"])


static func _has(offers: Array, kind: String) -> bool:
	for o in offers:
		if str(o["kind"]) == kind:
			return true
	return false


## The nearest tune-up and step up the promoter could make today (ProLadder._make_offers' own search, its tune band widened).
static func _candidates(c: Career, f: Dictionary, e: Dictionary, taken: Array) -> Dictionary:
	var you := int(e.get("rank", 0))
	var reach: int = maxi(1, you - MM.BAND_UP) if you > 0 else MM.UNRANKED_REACH
	var tune := {}
	var step := {}
	for b in ProLadder.table(c, f):
		if b.get("player", false) or b.get("retired", false) or taken.has(int(b.get("id", 0))):
			continue
		var r := int(b.get("rank", 0))
		var mid := float(ProLadder.read(c, f, ProLadder.bout_opp(f, b, ProLadder.PUBLIC_TAPE))["mid"])
		var above: bool = r > 0 and (you == 0 or r < you)
		if not above:
			if mid >= TUNE_WIDE.x and mid <= TUNE_WIDE.y and (tune.is_empty() or absf(mid - ProLadder.TUNE_AIM) < absf(float(tune["mid"]) - ProLadder.TUNE_AIM)):
				tune = {"b": b, "mid": mid}
		elif r >= reach and bool(MM.ask(e, b)["ok"]):
			if step.is_empty() or absf(mid - ProLadder.STEP_READ) < absf(float(step["mid"]) - ProLadder.STEP_READ):
				step = {"b": b, "mid": mid}
	return {"tune": tune, "step": step}


static func _row(b: Dictionary, kind: String, until: int) -> Dictionary:
	return {"id": int(b["id"]), "kind": kind, "file_found": ProLadder.PUBLIC_TAPE.duplicate(), "scouted": false, "until": until, "v15": true}


## The set as v15 puts it on the table. On the road (the first ROAD_FIGHTS pro fights) every set carries a tune-up AND a
## step up; after a loss the tune-ups are REBUILD fights and there is no step up (the game's rule). fav_on = the favour's
## rules apply: under FAV_LOW only the house's kind; the ticket house at FAV_HIGH adds the area champion after TITLE_WINS.
## Returns what the set was: {road, rebuild, both, forced, title}.
static func road(c: Career, f: Dictionary, fav_on: bool) -> Dictionary:
	var info := {"road": false, "rebuild": false, "both": false, "forced": false, "title": false}
	var offers: Array = f.get("pro_offers", [])
	if offers.is_empty():
		return info
	var house := str(f.get("pro_house", ""))
	var e: Dictionary = ProLadder.entry(c, f)
	var rebuild := bool(e.get("rebuild", false))
	var until := int(offers[0].get("until", c.day + ProLadder.OFFER_DAYS))
	info["rebuild"] = rebuild
	if ProLean.pro_fights(f) < ROAD_FIGHTS:
		info["road"] = true
		e["ducks"] = 0   # on the road the favour is the promoter's patience, not the duck count
		var need_tune := not _has(offers, "tune")
		var need_step := not rebuild and not _has(offers, "above")
		if need_tune or need_step:
			var cand := _candidates(c, f, e, offers.map(func(o): return int(o["id"])))
			if need_tune and not (cand["tune"] as Dictionary).is_empty():
				offers.append(_row(cand["tune"]["b"], "tune", until))
			if need_step and not (cand["step"] as Dictionary).is_empty():
				offers.append(_row(cand["step"]["b"], "above", until))
	if rebuild:
		for o in offers:
			if str(o["kind"]) == "tune":
				o["kind"] = "rebuild"
	info["both"] = _has(offers, "tune") and _has(offers, "above")
	var fav := favour(f)
	if fav_on and PREF.has(house):
		if house == "bow" and fav >= FAV_HIGH and not rebuild and int(f.get("pro_w", 0)) >= TITLE_WINS and str(e.get("belt", "")) == "":
			var champ: Dictionary = WR.champion_of(ProLadder.table(c, f), "area")
			if not champ.is_empty() and not champ.get("player", false) and not champ.get("retired", false):
				offers = offers.filter(func(o): return int(o["id"]) != int(champ["id"]))
				offers.append(_row(champ, "title", until))
				info["title"] = true
	f["pro_offers"] = offers
	return info


## The bot's pick. name = the step up (the title when it is on the table); win = the tune-up; keeper = the house's kind until
## the favour is FAV_HIGH, then the other kind while the favour allows it; anything else = the row read nearest 65.
static func choose(rows: Array, bot: String, house: String, fav: int) -> Dictionary:
	var want := ""
	match bot:
		"name":
			want = "above"
		"win":
			want = "tune"
		"keeper":
			var pref := str(PREF.get(house, "tune"))
			want = pref if fav <= FAV_HIGH else ("tune" if pref == "above" else "above")
	for r in rows:
		if str(r["kind"]) == "title" and (bot == "name" or (bot == "keeper" and float((r["chance"] as Dictionary).get("mid", 0.5)) >= TITLE_READ)):
			return r
	var best := {}
	if want == "above":
		best = _best(rows, ["above"])
	elif want == "tune":
		best = _best(rows, ["tune", "rebuild"])
	if best.is_empty() and want != "":
		best = _best(rows, [])
	if best.is_empty():
		var best_d := 9.0
		for r in rows:
			var d := absf(float((r["chance"] as Dictionary).get("mid", 0.5)) - 0.65)
			if d < best_d:
				best_d = d
				best = r
	return best


## The row of these kinds with the best read (every row when kinds is empty).
static func _best(rows: Array, kinds: Array) -> Dictionary:
	var best := {}
	var best_m := -1.0
	for r in rows:
		if not kinds.is_empty() and not kinds.has(str(r["kind"])):
			continue
		var m := float((r["chance"] as Dictionary).get("mid", 0.5))
		if m > best_m:
			best_m = m
			best = r
	return best


## A fight was booked from the set: the favour moves (+1 the house's kind or the title, -1 the other kind when the house's
## was on the table; a rebuild fight and a payday move nothing) and the guarantee house's purse rises at FAV_HIGH.
static func booked(c: Career, f: Dictionary, kind: String, had_pref: bool, fav_on: bool) -> Dictionary:
	var v: Dictionary = f.get("v15", {})
	var house := str(v.get("house", ""))
	if not PREF.has(house):
		return {"d": 0, "bonus": 0, "block": 0, "late": false}
	var before := int(v.get("fav", FAV_START))
	var d := 0
	if kind == str(PREF[house]) or (kind == "title" and house == "bow"):
		d = 1
	elif (kind == "tune" or kind == "above") and had_pref:
		d = -1
	v["fav"] = clampi(before + d, 0, FAV_MAX)
	f["v15"] = v
	var bonus := 0
	var block := 0
	var late := false
	if fav_on and before >= FAV_HIGH:
		c.cash += TOP_BLOCK
		block = TOP_BLOCK
		if house == "hf":
			f["bout"]["purse"] = int(f["bout"]["purse"]) + HF_PURSE
			bonus = HF_PURSE
	elif fav_on and before < FAV_LOW:
		f["bout"]["day"] = int(f["bout"]["day"]) + BOTTOM_DAYS
		late = true
	return {"d": d, "bonus": bonus, "block": block, "late": late}


## The name a pro win makes: a TUNE-UP pays TUNE_NAME reputation, not the usual 5. Applied after the game's own result
## (BoutFinish paid 5). kind = the row the bout was booked from. A rebuild win, a step up, a payday and a title pay the 5.
static func after_fight(c: Career, kind: String, outcome: String) -> int:
	if outcome != "win" or kind != "tune":
		return 0
	var back := mini(c.reputation, WIN_NAME - TUNE_NAME)
	c.reputation -= back
	return back
