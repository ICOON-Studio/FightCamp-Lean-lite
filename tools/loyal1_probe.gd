extends SceneTree
## LOYAL1 probe (CLUBWEEK_MAP_V41_S432 section 8): 52 club weeks for the start squad of four
## (three boxers + one BJJ fighter, S428 scope: SCOPE_FOUR_FIGHTERS_S428.md).
## Measures SHORTWEEK1 (asked > owned 9/10 weeks; COACH: nobody short >2 running)
## and LOYAL1 (COACH: none under 50; STARVE: loses one; EVEN: all over 60).
## Pure: preloads ClubDeal and Loyalty only. 40 seeds per policy.

const ClubDeal := preload("res://scripts/rules/ClubDeal.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const Data := preload("res://scripts/state/Data.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")

const N_SEEDS := 40
const N_WEEKS := 52
const MORNING_SESSIONS := ["roadwork", "heavy_bag", "speed_bag", "slip_rope", "shadow", "strength", "neck"]

var _fails := 0


func _initialize() -> void:
	print("LOYAL1 probe: 52 weeks, 4 fighters, 4 policies x 40 seeds")
	print("fighters: Kira (60), Tess (66), Danny (58), Ana (60)")
	var policies := ["COACH", "EVEN", "STARVE", "CLASS"]
	var results := {}
	for pol in policies:
		results[pol] = _run_policy(str(pol))
	_print_results(results)
	_verdicts(results)
	print("LOYAL1 done")
	quit(_fails)


## --- Fighter setup ---

func _make_fighters() -> Array:
	var kira := _prospect("kira")
	var tess := _prospect("tess")
	var danny := _prospect("danny")
	var ana := NoGi.athlete()
	ana["personality"] = {"loyalty": 60.0}
	ana["bouts"] = 8
	return [kira, tess, danny, ana]


func _prospect(id: String) -> Dictionary:
	for pi in Data.PROSPECTS.size():
		var p: Dictionary = Data.PROSPECTS[pi]
		if str(p["id"]) == id:
			var f := p.duplicate(true)
			f["bouts"] = _initial_bouts(str(id))
			return f
	return {}


func _initial_bouts(id: String) -> int:
	match id:
		"kira": return 1
		"tess": return 10
		"danny": return 3
	return 0


## --- Bout calendar ---
## Staggered by seed: each fighter has bouts every 4-6 weeks, offset by fighter index.
## fight_week = bout within 2 weeks. Returns {bout_weeks, fight_weeks}.

func _gen_calendar(rng: RandomNumberGenerator, fighter_idx: int) -> Dictionary:
	var bout_weeks: Array = []
	var fight_weeks: Array = []
	var stagger := fighter_idx * 2
	var w := 3 + stagger
	while w < N_WEEKS:
		bout_weeks.append(w)
		if w - 1 >= 0:
			fight_weeks.append(w - 1)
		if w - 2 >= 0:
			fight_weeks.append(w - 2)
		w += 4 + rng.randi() % 3
	return {"bout_weeks": bout_weeks, "fight_weeks": fight_weeks}


## --- Morning assignment ---
## Each fighter asks 2 mornings. Chosen to create realistic sharing (some overlap).

func _morning_for(fighter_idx: int) -> Array:
	match fighter_idx:
		0: return ["roadwork", "heavy_bag"]
		1: return ["heavy_bag", "speed_bag"]
		2: return ["slip_rope", "shadow"]
		3: return ["shadow", "strength"]
	return []


## --- Build the week dict ---

func _build_week(fighters: Array, calendars: Array, week_idx: int, order: Array, holder: String,
		evenings: Array, short_last: Dictionary) -> Dictionary:
	var fw := []
	for fi in fighters.size():
		var f: Dictionary = fighters[fi]
		var cal: Dictionary = calendars[fi]
		var is_fw: bool = cal["fight_weeks"].has(week_idx)
		var pads_ask: int = ClubDeal.ASK["ordinary"] + (ClubDeal.ASK["fight_week_extra"] if is_fw else 0)
		var td := _next_bout_day(cal, week_idx)
		fw.append({"id": str(f["id"]), "pads": pads_ask, "mornings": _morning_for(fi),
			"loyal": Loyalty.can_hold_pads(f, int(f.get("bouts", 0))),
			"bouts": int(f.get("bouts", 0)), "first": false,
			"short_last_week": bool(short_last.get(str(f["id"]), false)),
			"fight_week": is_fw, "target_day": td})
	return {"fighters": fw, "evenings": evenings, "own_evening": "pads", "holder": holder,
		"cash": 1000, "net": -100}


func _next_bout_day(cal: Dictionary, week_idx: int) -> int:
	for bw in (cal as Dictionary)["bout_weeks"]:
		if int(bw) >= week_idx:
			return int(bw) * 7
	return -1


## --- Policy order functions ---

func _coach_order(week: Dictionary) -> Array:
	return ClubDeal.coach_order(week)


func _even_order(prev_order: Array) -> Array:
	if prev_order.is_empty():
		return ["kira", "tess", "danny", "ana"]
	var o := prev_order.duplicate()
	o.push_front(o.pop_back())
	return o


func _starve_order(fighters: Array, calendars: Array, week_idx: int) -> Array:
	var with_bout: Array = []
	var without: Array = []
	for fi in fighters.size():
		var fid := str(fighters[fi]["id"])
		var has_soon := false
		for bw in (calendars[fi] as Dictionary)["bout_weeks"]:
			if int(bw) >= week_idx and int(bw) <= week_idx + 4:
				has_soon = true
				break
		if has_soon:
			with_bout.append(fid)
		else:
			without.append(fid)
	var out: Array = []
	for fid in with_bout:
		out.append(fid)
	for fid in without:
		out.append(fid)
	return out


## --- Holder ---

func _find_holder(fighters: Array) -> String:
	for fi in fighters.size():
		var f: Dictionary = fighters[fi]
		if ClubDeal.can_hold(f):
			return str(f["id"])
	return ""


## --- Run one policy x 40 seeds ---

func _run_policy(policy: String) -> Dictionary:
	var total_short_over := 0
	var total_weeks := 0
	var max_run_all := 0
	var min_loyalty_all := 100
	var sum_loyalty_all := 0
	var count_loyalty_all := 0
	var total_lost := 0
	var total_class_cash := 0
	var coach_max_run := 0

	for seed in N_SEEDS:
		var rng := RandomNumberGenerator.new()
		rng.seed = seed * 31337 + 42
		var fighters := _make_fighters()
		var calendars: Array = []
		for fi in 4:
			calendars.append(_gen_calendar(rng, fi))
		var holder := _find_holder(fighters)
		var order: Array = ["kira", "tess", "danny", "ana"]
		var short_last := {}
		var runs := {"kira": 0, "tess": 0, "danny": 0, "ana": 0}
		var max_runs := {"kira": 0, "tess": 0, "danny": 0, "ana": 0}
		var loyalties := {}
		var lost := 0
		var class_cash_total := 0
		var left_fighters := {}
		for fi in fighters.size():
			var f: Dictionary = fighters[fi]
			loyalties[str(f["id"])] = Loyalty.value(f)
		for wk in N_WEEKS:
			var evenings: Array
			if policy == "CLASS":
				evenings = ["class", "pads", "pads"]
			else:
				evenings = ClubDeal.coach_evenings(1000, -100)
			match policy:
				"COACH":
					order = _coach_order(_build_week(fighters, calendars, wk, order, holder, evenings, short_last))
				"EVEN":
					order = _even_order(order)
				"STARVE":
					order = _starve_order(fighters, calendars, wk)
				"CLASS":
					order = _coach_order(_build_week(fighters, calendars, wk, order, holder, evenings, short_last))
			var week := _build_week(fighters, calendars, wk, order, holder, evenings, short_last)
			var result := ClubDeal.deal(week, order)
			var asked: int = int(result["pads"]["asked"])
			var owned: int = int(result["pads"]["owned"])
			if asked > owned:
				total_short_over += 1
			total_weeks += 1
			class_cash_total += int(result["cash"])
			var new_short := {}
			var rows: Array = result["rows"]
			for ri in rows.size():
				var row: Dictionary = rows[ri]
				var fid := str(row["id"])
				var is_short: bool = bool(row["short"])
				if is_short:
					runs[fid] = int(runs[fid]) + 1
					max_runs[fid] = maxi(int(max_runs[fid]), int(runs[fid]))
				else:
					runs[fid] = 0
				new_short[fid] = is_short
				var f: Dictionary = _fighter_by_id(fighters, fid)
				for cause in (row["causes"] as Array):
					Loyalty.apply(f, str(cause), wk * 7)
				if Loyalty.wants_word(f, wk * 7):
					Loyalty.apply(f, "word_card", wk * 7)
					Loyalty.apply(f, "talk_back", wk * 7)
					if policy == "STARVE" and not left_fighters.has(fid):
						if Loyalty.leaves(f, wk * 7):
							lost += 1
							left_fighters[fid] = wk
				loyalties[fid] = Loyalty.value(f)
			short_last = new_short
		for fid in runs:
			max_run_all = maxi(max_run_all, int(max_runs[fid]))
			if policy == "COACH":
				coach_max_run = maxi(coach_max_run, int(max_runs[fid]))
		for fid in loyalties:
			var v: int = int(loyalties[fid])
			min_loyalty_all = mini(min_loyalty_all, v)
			sum_loyalty_all += v
			count_loyalty_all += 1
		total_lost += lost
		total_class_cash += class_cash_total
	return {"short_over": total_short_over, "total_weeks": total_weeks,
		"max_run": max_run_all, "coach_max_run": coach_max_run,
		"min_loyalty": min_loyalty_all, "mean_loyalty": float(sum_loyalty_all) / maxi(1, count_loyalty_all),
		"lost": total_lost, "class_cash": total_class_cash, "policy": policy}


## --- Print results ---

func _print_results(results: Dictionary) -> void:
	for pol in ["COACH", "EVEN", "STARVE", "CLASS"]:
		var r: Dictionary = results[pol]
		var short_pct: float = 100.0 * float(int(r["short_over"])) / float(maxi(1, int(r["total_weeks"])))
		print("\n--- %s ---" % str(pol))
		print("  short: asked > owned in %d/%d weeks (%.0f%%)" % [int(r["short_over"]), int(r["total_weeks"]), short_pct])
		print("  max run short: %d" % int(r["max_run"]))
		if str(pol) == "COACH":
			print("  COACH max run: %d" % int(r["coach_max_run"]))
		print("  loyalty week 52: min=%d mean=%.1f" % [int(r["min_loyalty"]), float(r["mean_loyalty"])])
		print("  fighters lost: %d" % int(r["lost"]))
		print("  class cash (year): $%d" % int(r["class_cash"]))


## --- Verdicts ---

func _verdicts(results: Dictionary) -> void:
	print("\n=== VERDICTS ===")
	var coach: Dictionary = results["COACH"]
	var even: Dictionary = results["EVEN"]
	var starve: Dictionary = results["STARVE"]
	var sw1_asked := int(coach["short_over"]) >= int(36)
	var sw1_run := int(coach["coach_max_run"]) <= 2
	var shortweek1 := sw1_asked and sw1_run
	print("SHORTWEEK1: %s" % ("PASS" if shortweek1 else "FAIL"))
	if not sw1_asked:
		print("  asked > owned in %d/%d (need 36/40)" % [int(coach["short_over"]), int(coach["total_weeks"])])
	if not sw1_run:
		print("  COACH max run %d (need <=2)" % int(coach["coach_max_run"]))
	var l1_coach := int(coach["min_loyalty"]) >= 50
	var l1_starve := int(starve["lost"]) >= 1
	var l1_even := int(even["min_loyalty"]) > 60
	var loyal1 := l1_coach and l1_starve and l1_even
	print("LOYAL1: %s" % ("PASS" if loyal1 else "FAIL"))
	if not l1_coach:
		print("  COACH min loyalty %d (need >=50)" % int(coach["min_loyalty"]))
	if not l1_starve:
		print("  STARVE lost %d (need >=1)" % int(starve["lost"]))
	if not l1_even:
		print("  EVEN min loyalty %d (need >60)" % int(even["min_loyalty"]))
	if not shortweek1 or not loyal1:
		print("\nESTIMATES to move:")
		if not l1_coach:
			print("  Loyalty.MOVES['short'] (currently %d) -> less negative" % int(Loyalty.MOVES["short"]))
		if not l1_starve:
			print("  Loyalty.MOVES['short'] (currently %d) -> more negative, or LEAVES_UNDER (currently %d) -> higher" % [
				int(Loyalty.MOVES["short"]), int(Loyalty.LEAVES_UNDER)])
		if not l1_even:
			print("  Loyalty.MOVES['full_week'] (currently %d) -> more positive" % int(Loyalty.MOVES["full_week"]))


## --- Helpers ---

func _fighter_by_id(fighters: Array, fid: String) -> Dictionary:
	for fi in fighters.size():
		var f: Dictionary = fighters[fi]
		if str(f["id"]) == fid:
			return f
	return {}
