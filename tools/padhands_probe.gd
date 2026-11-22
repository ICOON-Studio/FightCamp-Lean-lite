extends SceneTree
## S537 PADHANDS1 greybox (DEPTH35 change 3, "the coach's hands as the club's currency"), measured BEFORE the critics.
## The rule under test (ops/research/DESIGN_PADHANDS1.md): every boxer keeps her full pad nights (owner Q-S294-242 "No, never
## short", Q-S294-260 "full pads, no sharing"); ON TOP the coach has ONE_TO_ONES extra one-to-one sessions a week, each
## ONE_TO_ONE drill units on one card of one boxer. The pick = who gets them.
## Greybox: the week's drilling is the game's own PadWeek.run_week + PadWeek.drill, the answer to an opponent is the game's
## own table (PlanFight.ANSWERS for OppFile.main_game), the bout is the game's own Bouts.fight_step "sim" (FireLevel on:
## under Usable a line never fires, Usable 1 in 2, Sharp 3 in 4). No game file is changed.
## POPULATION: 4 club boxers who all differ (Lucy wlw, Kira wfw, Samira www, Tess wmw: Data.lucy + Data.PROSPECTS), each
## with her own two book combinations, start mastery and punches; opponents of her own division (Data.OPPONENTS + RIVALS
## for wlw, Data.DIVISION_RIVALS for the rest, rating under 70); 10 cells = 10 seeded calendars (WEEKS weeks, a bout every
## 3-5 weeks each, known 2-4 weeks ahead) with seeded start mastery; DICE bouts per fight, the same dice in every arm.
## Usage: godot --headless --script res://tools/padhands_probe.gd -- [dice] [curve] [log] [lead=1-2]   (ends with PADHANDS_DONE)

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")

const IDS := ["lucy", "kira", "samira", "tess"]
const PLANS := {"lucy": ["1-1", "1-2"], "kira": ["1-2", "1-1-2"], "samira": ["2-3", "3b-3"], "tess": ["1-2-3b", "1-1"]}
const START := {"lucy": [52.0, 34.0], "kira": [24.0, 40.0], "samira": [46.0, 28.0], "tess": [56.0, 44.0]}
const TIERS := [30.0, 60.0, 85.0]
const WEEKS := 10
const ONE_TO_ONES := 2          # the coach's one-to-one sessions a week (the lever's size, a design number)
const ONE_TO_ONE := 120.0       # drill units each = half a pad night (PadWeek.PAD_NIGHT_MINUTES 240)
const COACH := 74.0             # Luke Reid's pads rating (Data.COACHES)
const PICKS := ["coach", "even", "star", "gap", "bell", "under"]
const ARMS := ["none", "all", "coach", "even", "star", "gap", "bell", "under"]

var _dice := 60
var _cache := {}
var _bouts_run := 0
var _log := false
var _lead := [2, 4]   # AmateurBooking.LEAD_WEEKS_MIN..MAX; "lead=1-2" = the S428 scope's fight week 1 to 2 weeks out


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() > 0 and int(args[0]) > 0:
		_dice = int(args[0])
	_log = args.has("log")
	for a in args:
		if str(a).begins_with("lead="):
			var bits := str(a).trim_prefix("lead=").split("-")
			_lead = [int(bits[0]), int(bits[1])]
	print("LEAD: a bout is known %d to %d weeks ahead" % [int(_lead[0]), int(_lead[1])])
	print("POPULATION: boxers %s (all differ: Data.lucy + Data.PROSPECTS), books %s, opponents by division, %d cells x %d weeks, %d paired dice a bout" % [IDS, PLANS, 10, WEEKS, _dice])
	print("RULE: full pad nights for everyone (3 pads + 1 spar, Standard between fights) + %d one-to-ones a week of %d units; coach pads %d" % [ONE_TO_ONES, int(ONE_TO_ONE), int(COACH)])
	if args.has("curve"):
		_curve()
		print("PADHANDS_DONE")
		quit(0)
		return
	var t0 := Time.get_ticks_msec()
	var table := {}   # arm -> [per cell wins in 100]
	for arm in ARMS:
		table[arm] = []
	for cell in 10:
		var cal := _calendar(cell)
		var line := "CELL %d bouts %d |" % [cell, _count(cal)]
		for arm in ARMS:
			var w := _club(cell, cal, str(arm))
			(table[arm] as Array).append(w)
			line += " %s %.1f" % [arm, w]
		print(line)
	_verdict(table)
	print("bouts simulated %d, %d s" % [_bouts_run, (Time.get_ticks_msec() - t0) / 1000])
	print("PADHANDS_DONE")
	quit(0)


## --- the population -------------------------------------------------------------------------------------------------

func _base(id: String) -> Dictionary:
	if id == "lucy":
		return Data.lucy()
	for p in Data.PROSPECTS:
		if str(p["id"]) == id:
			var d: Dictionary = (p as Dictionary).duplicate(true)
			for k in ["state", "trial_day", "note"]:
				d.erase(k)
			return d
	return {}


## A club boxer: her six punches learned (seeded 55-72, her own), her two book combinations at her own start mastery.
func _fighter(id: String, cell: int) -> Dictionary:
	var f: Dictionary = Data.fighter_state(_base(id), 40)
	f["id"] = id
	var rng := RandomNumberGenerator.new()
	rng.seed = hash("padhands %s %d" % [id, cell])
	for mv in Data.MOVES:
		f["moves"][mv] = rng.randf_range(55.0, 72.0)
	var plan: Array = PLANS[id]
	f["combos"] = {}
	for i in plan.size():
		f["combos"][plan[i]] = clampf(float(START[id][i]) + rng.randf_range(-8.0, 8.0), 5.0, 95.0)
	f["camp"] = {}
	return f


func _opps(id: String) -> Array:
	var div := str(_base(id).get("div", "wlw"))
	var out: Array = []
	if div == "wlw":
		out.append_array(Data.OPPONENTS)
		out.append_array(Data.RIVALS)
	else:
		for r in Data.DIVISION_RIVALS:
			if str(r["div"]) == div and float(r["rating"]) < 70.0:
				out.append(r)
	return out


## cal[i] = [[week, opp dict, lead weeks], ...] for boxer i: a first bout in weeks 2..5, then every 3-5 weeks; each bout is
## known `lead` weeks ahead (AmateurBooking.LEAD_WEEKS_MIN..MAX = 2..4).
func _calendar(cell: int) -> Array:
	var rng := RandomNumberGenerator.new()
	rng.seed = 7000 + cell
	var cal: Array = []
	for i in IDS.size():
		var opps := _opps(str(IDS[i]))
		var rows: Array = []
		var w := rng.randi_range(2, 5)
		var k := 0
		while w < WEEKS:
			rows.append([w, (opps[(cell + i + k) % opps.size()] as Dictionary).duplicate(true), rng.randi_range(int(_lead[0]), int(_lead[1]))])
			w += rng.randi_range(3, 5)
			k += 1
		cal.append(rows)
	return cal


func _count(cal: Array) -> int:
	var n := 0
	for rows in cal:
		n += (rows as Array).size()
	return n


## The combination the coach teaches for this opponent: the best answer to her main game (PlanFight.ANSWERS best list) that
## the boxer holds highest; when she holds none at Usable, the first on the list. "" = the game has no combination answer.
func _answer(f: Dictionary, opp: Dictionary) -> String:
	var game := OppFile.main_game(opp)
	var first := ""
	var held := ""
	for id in (PlanFight.ANSWERS.get(game, {}) as Dictionary).get("best", []):
		if str(StrikeMap.move(str(id)).get("kind", "")) != "combo":
			continue
		if first == "":
			first = str(id)
		var m := float(f["combos"].get(str(id), 0.0))
		if m >= 30.0 and (held == "" or m > float(f["combos"].get(held, 0.0))):
			held = str(id)
	return held if held != "" else first


## The cards on her three pad nights this week: with a known bout the answer on two and her best other line that does not
## walk into the opponent's game on one (PlanCards.coach_week: the plan's cards on the nights in order); else her book.
func _cards(f: Dictionary, id: String, nk: Array) -> Array:
	var plan: Array = PLANS[id]
	if int(nk[0]) >= 99:
		return ["combo:" + str(plan[0]), "combo:" + str(plan[1]), "combo:" + str(plan[0])]
	var opp: Dictionary = nk[1]
	var game := OppFile.main_game(opp)
	var ans := _answer(f, opp)
	var other := ""
	for cid in plan:
		if str(cid) != ans and PlanFight.fit(str(cid), game) != "wrong" and (other == "" or float(f["combos"][cid]) > float(f["combos"][other])):
			other = str(cid)
	if ans == "":
		ans = other if other != "" else str(plan[0])
	if other == "":
		other = ans
	return ["combo:" + ans, "combo:" + other, "combo:" + ans]


## Her plan on the night: every combination in her hands (30+) that does not walk into the opponent's game, and two steps
## that do not either. A line under 30 never fires (FireLevel), so a late answer is simply not there.
func _plan(f: Dictionary, opp: Dictionary) -> Array:
	var game := OppFile.main_game(opp)
	var out: Array = []
	for cid in (f["combos"] as Dictionary).keys():
		if float(f["combos"][cid]) >= 30.0 and PlanFight.fit(str(cid), game) != "wrong":
			out.append({"move": str(cid)})
	var feet := 0
	for s in ["step_back", "pivot_out", "step_in"]:
		if feet < 2 and PlanFight.fit(s, game) != "wrong":
			out.append({"move": s})
			feet += 1
	return out


## --- one club, one arm: WEEKS weeks of drilling and the bouts on the calendar; returns wins in 100 bouts ---------------

func _club(cell: int, cal: Array, arm: String) -> float:
	var fs: Array = []
	for id in IDS:
		fs.append(_fighter(str(id), cell))
	var nights := PadWeek.nights_for(1, false)
	var days: Array = nights["pads"]
	var won := 0.0
	var n := 0
	for w in WEEKS:
		var cards: Array = []
		for i in fs.size():
			cards.append(_cards(fs[i], str(IDS[i]), _next_known(cal[i], w)))
		var deal := _deal(arm, w, fs, cal, cards)
		for i in fs.size():
			var f: Dictionary = fs[i]
			var week := {}
			for d in days.size():
				week[PadWeek.DAYS[days[d]]] = [{"card": str(cards[i][d]), "share": 1.0}]
			var fight_week := int(_next_known(cal[i], w)[0]) == 0
			PadWeek.run_week(f, nights, week, COACH, PadWeek.STATION_TIER, {"combo": 0.5} if fight_week else {})   # a light fight week: half the pads stick
			for k in deal.count(i):
				PadWeek.drill(f, _card(f, cards[i]), ONE_TO_ONE, COACH, PadWeek.STATION_TIER, PadWeek.PAD_STATION)
			for row in cal[i]:
				if int(row[0]) == w:
					var g := f.duplicate(true)
					g["arrows"] = _plan(g, row[1])
					if _log:
						var ans := _answer(f, row[1])
						print("  LOG cell %d %s w%d %s vs %s (%s, lead %d): answer %s %.0f, plan %s" % [cell, arm, w, IDS[i], row[1]["name"], OppFile.main_game(row[1]), int(row[2]), ans, float(f["combos"].get(ans, 0.0)), (g["arrows"] as Array).map(func(a): return a["move"])])
					won += _won(g, row[1])
					n += 1
	return 100.0 * won / maxf(1.0, n)


## Her card for a one-to-one: this week's card nearest under a tier line it can still reach; else her lowest.
func _card(f: Dictionary, cards: Array) -> String:
	var best := ""
	var best_gap := 999.0
	var low := ""
	for card in cards:
		var m := PadWeek.mastery(f, str(card))
		if low == "" or m < PadWeek.mastery(f, low):
			low = str(card)
		var g := _gap(f, str(card))
		if g < best_gap:
			best_gap = g
			best = str(card)
	return best if best != "" else low


## Points to the next tier line she can reach on this card (999 = none).
func _gap(f: Dictionary, card: String) -> float:
	var m := PadWeek.mastery(f, card)
	var cap := PadWeek.cap(f, card)
	for t in TIERS:
		if m < float(t) and float(t) <= cap:
			return float(t) - m
	return 999.0


func _best_gap(f: Dictionary, cards: Array) -> float:
	var g := 999.0
	for card in cards:
		g = minf(g, _gap(f, str(card)))
	return g


func _rating(f: Dictionary) -> float:
	var s := 0.0
	for k in Data.STATS:
		s += float(f["stats"][k])
	return s / float(Data.STATS.size())


## Weeks to her next KNOWN bout (inside its lead), 99 = none known.
func _next_known(cal_i: Array, w: int) -> Array:
	for row in cal_i:
		if int(row[0]) >= w and int(row[0]) - w <= int(row[2]):
			return [int(row[0]) - w, row[1]]
	return [99, {}]


## Who gets this week's one-to-ones: boxer indexes, one per session.
func _deal(arm: String, w: int, fs: Array, cal: Array, cards: Array) -> Array:
	var idx: Array = range(fs.size())
	match arm:
		"none":
			return []
		"all":   # control, the upper bound: every boxer gets every session
			var out: Array = []
			for i in idx:
				for k in ONE_TO_ONES:
					out.append(i)
			return out
		"even":
			return [(ONE_TO_ONES * w) % fs.size(), (ONE_TO_ONES * w + 1) % fs.size()]
		"coach":   # the laziest: the coach's own order (ClubDeal.coach_order: fight week, nearest bout, then the roster)
			idx.sort_custom(func(a, b):
				var ka := int(_next_known(cal[a], w)[0])
				var kb := int(_next_known(cal[b], w)[0])
				return ka < kb if ka != kb else a < b)
		"star":   # the best boxer, always
			idx.sort_custom(func(a, b): return _rating(fs[a]) > _rating(fs[b]) if _rating(fs[a]) != _rating(fs[b]) else a < b)
		"gap":   # the cheapest tier line in the club, whoever fights
			idx.sort_custom(func(a, b):
				var ga := _best_gap(fs[a], cards[a])
				var gb := _best_gap(fs[b], cards[b])
				return ga < gb if ga != gb else a < b)
		"bell":   # a boxer with a known bout whose line can still land before the bell (8 points a week); else the gap
			idx.sort_custom(func(a, b):
				var na := int(_next_known(cal[a], w)[0])
				var nb := int(_next_known(cal[b], w)[0])
				var ga := _best_gap(fs[a], cards[a])
				var gb := _best_gap(fs[b], cards[b])
				var ra := na < 99 and ga <= 8.0 * float(na + 1)
				var rb := nb < 99 and gb <= 8.0 * float(nb + 1)
				if ra != rb:
					return ra
				return ga < gb if ga != gb else a < b)
		"under":   # the boxer who is the bigger underdog in a known bout; none known = the lowest rated
			idx.sort_custom(func(a, b):
				var oa := _odds(fs[a], cal[a], w)
				var ob := _odds(fs[b], cal[b], w)
				return oa < ob if oa != ob else a < b)
	var both: Array = []
	for k in ONE_TO_ONES:
		both.append(idx[0])
	return both


func _odds(f: Dictionary, cal_i: Array, w: int) -> float:
	var nk := _next_known(cal_i, w)
	if int(nk[0]) >= 99:
		return 100.0 + _rating(f)
	return _rating(f) - float((nk[1] as Dictionary).get("rating", 60.0))


## --- the bout: the game's own, DICE times on the same days (paired across arms); cached on her whole state ------------

func _won(f: Dictionary, opp: Dictionary) -> float:
	var key := "%d|%s" % [f.hash(), str(opp["name"])]
	if _cache.has(key):
		return float(_cache[key])
	var won := 0
	for j in _dice:
		var c := Career.quick_start()
		c.fighters.append(f.duplicate(true))
		c.day = 40 + j
		var g: Dictionary = c.fighter()
		g["bout"] = {"opp": opp.duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 0, "rounds": 3}
		var m := {"fid": g["id"], "step": "tape", "total": 3}
		Bouts.fight_step(c, g, m, "sim")
		won += int(str(m.get("outcome", "")) == "win")
		_bouts_run += 1
	var share := float(won) / float(_dice)
	_cache[key] = share
	return share


## --- controls first: for each boxer against her first opponent, what the answer is worth on the night (not there / Usable
## / Sharp) and how many weeks of pads, with and without both one-to-ones, bring a new answer to Usable -----------------

func _curve() -> void:
	var t0 := Time.get_ticks_msec()
	for id in IDS:
		var opps := _opps(str(id))
		for oi in mini(3, opps.size()):
			var opp: Dictionary = opps[oi]
			var f := _fighter(str(id), 0)
			var ans := _answer(f, opp)
			var card := "combo:" + ans
			var line := "CONTROL %s (%.1f) vs %s (%.1f, %s): answer %s holds %.0f cap %.0f |" % [id, _rating(f), opp["name"], float(opp["rating"]), OppFile.main_game(opp), ans, float(f["combos"].get(ans, 0.0)), PadWeek.cap(f, card)]
			for m in [0.0, 35.0, 65.0]:
				var g := f.duplicate(true)
				g["combos"][ans] = m
				g["arrows"] = _plan(g, opp)
				line += " answer at %d won %.1f" % [int(m), 100.0 * _won(g, opp)]
			var bare := f.duplicate(true)
			bare["arrows"] = []
			line += " | no plan %.1f" % (100.0 * _won(bare, opp))
			for extra in [0, ONE_TO_ONES]:
				var h := f.duplicate(true)
				h["combos"][ans] = 0.0
				var nights := PadWeek.nights_for(1, false)
				var days: Array = nights["pads"]
				var cards := ["combo:" + ans, "combo:" + str(PLANS[id][0]), "combo:" + ans]
				var at := -1
				var path := ""
				for w in 5:
					var week := {}
					for d in days.size():
						week[PadWeek.DAYS[days[d]]] = [{"card": str(cards[d]), "share": 1.0}]
					PadWeek.run_week(h, nights, week, COACH, PadWeek.STATION_TIER)
					for k in extra:
						PadWeek.drill(h, card, ONE_TO_ONE, COACH, PadWeek.STATION_TIER, PadWeek.PAD_STATION)
					path += " %.0f" % float(h["combos"][ans])
					if at < 0 and float(h["combos"][ans]) >= 30.0:
						at = w + 1
				line += " | from 0 with %d one-to-ones:%s (usable week %d)" % [extra, path, at]
			print(line)
	print("controls: %d bouts in %d s" % [_bouts_run, (Time.get_ticks_msec() - t0) / 1000])


## --- the three bars ---------------------------------------------------------------------------------------------------

func _verdict(table: Dictionary) -> void:
	var mean := {}
	for arm in ARMS:
		var s := 0.0
		for v in table[arm]:
			s += float(v)
		mean[arm] = s / 10.0
	var line := "MEAN |"
	for arm in ARMS:
		line += " %s %.2f" % [arm, float(mean[arm])]
	print(line)
	var best_in := {}
	var top_gain := 0.0
	for cell in 10:
		var top := -1.0
		for p in PICKS:
			top = maxf(top, float(table[p][cell]))
		var names: Array = []
		for p in PICKS:
			if float(table[p][cell]) >= top - 0.05:
				names.append(p)
				best_in[p] = int(best_in.get(p, 0)) + 1
		top_gain += top - float(table["coach"][cell])
		print("BEST cell %d: %s %.1f (coach %.1f, none %.1f, all %.1f)" % [cell, names, top, float(table["coach"][cell]), float(table["none"][cell]), float(table["all"][cell])])
	var best_pick := ""
	var most := 0
	for p in PICKS:
		if best_pick == "" or float(mean[p]) > float(mean[best_pick]):
			best_pick = p
		most = maxi(most, int(best_in.get(p, 0)))
	var moves := float(mean["all"]) - float(mean["none"])
	var worth := float(mean[best_pick]) - float(mean["coach"])
	print("BAR 1 moves the result: all - none = %.2f wins in 100 (best pick %s - none = %.2f) -> %s" % [moves, best_pick, float(mean[best_pick]) - float(mean["none"]), "pass" if moves >= 3.0 else "FAIL"])
	print("BAR 2 no pick best in more than 6 of 10 cells: %s -> %s" % [best_in, "pass" if most <= 6 else "FAIL"])
	print("BAR 3 best vs laziest: %s - coach = %.2f wins in 100 (the best pick of each cell - coach = %.2f) -> %s" % [best_pick, worth, top_gain / 10.0, "pass" if worth >= 3.0 else "FAIL"])
	print("VERDICT PADHANDS1 = %s" % ("PASS" if moves >= 3.0 and most <= 6 and worth >= 3.0 else "FAIL"))
