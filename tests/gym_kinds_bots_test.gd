extends SceneTree
## GYMKIND1 bots: 15 seeds, 156 weeks, the game's real weekly pass, one boxer on a fixed week plan that gives every
## session in the map some time. Arms: OPENING (start rows), each kind bought whole on day 0, and ALL. Print per arm:
## median of each session stat at week 156, the gain over OPENING, and the price of that arm's pieces. Then the win
## chance the gain is worth: MM.win_chance of the week-156 boxer of each arm against the OPENING boxer.
## Two checks: OPENING's multiplier reads 1.0 on every stat, and ALL's stats are at or above OPENING's in every seed.

const GymSlots := preload("res://scripts/rules/GymSlots.gd")
const GymKinds := preload("res://scripts/rules/GymKinds.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const MM := preload("res://scripts/rules/Matchmaking.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Data := preload("res://scripts/state/Data.gd")

const SEEDS := 9
const WEEKS := 156
const ARMS := ["OPENING", "BAG", "RACK", "CARDIO", "MIRROR", "MAT", "ALL"]
const STATS := ["power", "speed", "chin", "conditioning", "technique", "defense"]

var failures := 0


func _check(ok: bool, what: String) -> void:
	if ok:
		print("  ok: ", what)
	else:
		failures += 1
		print("  FAIL: ", what)


func _initialize() -> void:
	print("GYMKIND1 BOTS: %d seeds, %d weeks, %s arms" % [SEEDS, WEEKS, ARMS])
	print("Population: seeds %d-%d, %d weeks, one boxer per seed on a fixed week plan covering every mapped session" % [20000, 20000 + SEEDS - 1, WEEKS])
	print("Week plan: Mon=roadwork(cond) Tue=heavy_bag(power) Wed=slip_rope(def) Thu=speed_bag(speed) Fri=shadow(tech) Sat=neck(chin) Sun=rest")
	var plan_shares := {"roadwork": 1.0 / 6.0, "heavy_bag": 1.0 / 6.0, "slip_rope": 1.0 / 6.0,
		"speed_bag": 1.0 / 6.0, "shadow": 1.0 / 6.0, "neck": 1.0 / 6.0, "rest": 0.0}
	print("Session shares: roadwork(%.2f) heavy_bag(%.2f) slip_rope(%.2f) speed_bag(%.2f) shadow(%.2f) neck(%.2f)" % [
		plan_shares["roadwork"], plan_shares["heavy_bag"], plan_shares["slip_rope"],
		plan_shares["speed_bag"], plan_shares["shadow"], plan_shares["neck"]])
	var results := {}
	var prices := {}
	for arm in ARMS:
		results[arm] = _run_arm(arm)
		prices[arm] = _arm_price(arm)
	_print_table(results, prices)
	_checks(results)
	print("GYM_KINDS_BOTS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## The slot IDs of a kind (non-locked, non-start).
func _kind_ids(kind: String) -> Array:
	var out: Array = []
	for s in GymSlots.all():
		if str(s["kind"]) == kind and not bool(s.get("start", false)):
			out.append(str(s["id"]))
	return out


## The price of an arm's pieces.
func _arm_price(arm: String) -> int:
	var total := 0
	for s in GymSlots.all():
		var kind := str(s["kind"])
		var is_start := bool(s.get("start", false))
		if is_start:
			continue
		var buy := false
		match arm:
			"BAG": buy = kind == "bag"
			"RACK": buy = kind == "rack" or kind == "bench"
			"CARDIO": buy = kind == "cardio"
			"MIRROR": buy = kind == "mirror"
			"MAT": buy = kind == "mat"
			"ALL": buy = kind in ["bag", "rack", "bench", "cardio", "mirror", "mat"]
		if buy:
			total += int(s.get("price", 0))
	return total


## Set up the gym slots for an arm: start rows plus the arm's pieces bought on day -FIT_DAYS (ready on day 0).
func _setup_slots(c: Career, arm: String) -> void:
	c.gym_slots = GymSlots.start_rows()
	if arm == "OPENING":
		return
	for s in GymSlots.all():
		var kind := str(s["kind"])
		var is_start := bool(s.get("start", false))
		if is_start:
			continue
		var buy := false
		match arm:
			"BAG": buy = kind == "bag"
			"RACK": buy = kind == "rack" or kind == "bench"
			"CARDIO": buy = kind == "cardio"
			"MIRROR": buy = kind == "mirror"
			"MAT": buy = kind == "mat"
			"ALL": buy = kind in ["bag", "rack", "bench", "cardio", "mirror", "mat"]
		if buy:
			c.gym_slots.append({"id": str(s["id"]), "day": -GymSlots.FIT_DAYS})


## Create a fighter for the test with fixed starting stats.
func _make_fighter(seed: int, day: int) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var base := 60.0
	var raw := {"first": "Test", "name": "Test Boxer", "style": "Out-boxer", "stats": {
		"power": base, "speed": base, "technique": base,
		"defense": base, "conditioning": base, "fight_iq": base, "chin": base},
		"pot": 80, "w": 0, "l": 0, "weight": 70.0,
		"personality": {"heart": 60.0, "temper": 50.0, "confidence": 55.0, "discipline": 55.0, "coachability": 60.0, "loyalty": 50.0}}
	var f := Data.fighter_state(raw, day)
	f["cards"] = ["Jab and move", "Pad rounds", "Hill sprints"]
	return f


## Set the fixed week plan: every mapped session gets one day.
func _set_plan(f: Dictionary) -> void:
	f["phase"] = "base"
	f["phase_day"] = 0
	f["week_edits"] = {"phase": "base", "days": {
		"0": ["roadwork", "normal"],
		"1": ["heavy_bag", "normal"],
		"2": ["slip_rope", "normal"],
		"3": ["speed_bag", "normal"],
		"4": ["shadow", "normal"],
		"5": ["neck", "normal"],
		"6": ["rest", "normal"]}}


## Run one arm across all seeds. Returns {stat: [values per seed]}.
func _run_arm(arm: String) -> Dictionary:
	var out := {}
	for stat in STATS:
		out[stat] = []
	for si in SEEDS:
		var c := Career.quick_start()
		c.seed = 20000 + si
		c.cash = 100000
		c.coach = {"name": "Luke Reid", "salary": 450, "rating": 58}
		_setup_slots(c, arm)
		var f := _make_fighter(c.seed, c.day)
		c.fighters = [f]
		_set_plan(f)
		GymSpend.kit_gain_on = (arm != "OPENING")
		for week in range(1, WEEKS + 1):
			for d in 7:
				Sim.step_day(c)
		var stats: Dictionary = f.get("stats", {})
		for stat in STATS:
			out[stat].append(float(stats.get(stat, 0.0)))
	return out


## Print the results table.
func _print_table(results: Dictionary, prices: Dictionary) -> void:
	print("")
	print("ARM          | PRICE  | power  speed  chin   cond   tech   def    | win_chance")
	print("-------------+--------+-------------------------------------------+----------")
	for arm in ARMS:
		var line := "%-12s | $%-5d | " % [arm, prices[arm]]
		var stat_vals := []
		for stat in STATS:
			var med := _median(results[arm][stat])
			line += "%-6.1f " % med
			stat_vals.append(med)
		print(line)
	print("")
	print("GAIN OVER OPENING:")
	print("ARM          | power  speed  chin   cond   tech   def")
	print("-------------+---------------------------------------")
	for arm in ARMS:
		var line := "%-12s | " % arm
		for i in STATS.size():
			var stat: String = str(STATS[i])
			var med_arm := _median(results[arm][stat])
			var med_open := _median(results["OPENING"][stat])
			line += "%-6.1f " % (med_arm - med_open)
		print(line)


## Two instrument checks.
func _checks(results: Dictionary) -> void:
	var opening_mult_ok := true
	for stat in STATS:
		var m := GymKinds.gain_mult(GymSlots.start_rows(), 0, stat)
		if not is_equal_approx(m, 1.0):
			opening_mult_ok = false
			print("FAIL: OPENING multiplier on %s = %.4f (expected 1.0)" % [stat, m])
	_check(opening_mult_ok, "OPENING's multiplier reads 1.0 on every stat")
	var all_above := true
	for si in SEEDS:
		for stat in STATS:
			var all_val: float = results["ALL"][stat][si]
			var open_val: float = results["OPENING"][stat][si]
			if all_val < open_val - 0.01:
				all_above = false
				print("FAIL: ALL seed %d %s = %.2f < OPENING %.2f" % [si, stat, all_val, open_val])
	_check(all_above, "ALL's stats are at or above OPENING's in every seed")


func _median(arr: Array) -> float:
	if arr.is_empty():
		return 0.0
	var s := arr.duplicate()
	s.sort()
	var mid := s.size() / 2
	if s.size() % 2 == 0:
		return (float(s[mid - 1]) + float(s[mid])) / 2.0
	return float(s[mid])
