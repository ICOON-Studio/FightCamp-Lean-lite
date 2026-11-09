extends SceneTree
## GYMBUY1: does buying equipment change a club's results? Three bots (NEVER, BUYER, WHOLE) run across
## reputations and premises tiers. The BUYER buys the cheapest available piece each week when the floor binds,
## keeping 8 weeks of costs in reserve. Prints one line per cell and two instrument checks.

const GymSlots := preload("res://scripts/rules/GymSlots.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Data := preload("res://scripts/state/Data.gd")

const SEEDS := 15
const WEEKS := 156
const REPS := [10, 30, 50, 80]
const TIERS := [0, 1]
const BOTS := ["NEVER", "BUYER", "WHOLE"]
const CHECKPOINTS := [26, 52, 104, 156]

var failures := 0


func _initialize() -> void:
	print("GYMBUY1: %d seeds, %d weeks, %s reps, %s tiers" % [SEEDS, WEEKS, REPS, TIERS])
	var all_results := {}
	for bot in BOTS:
		for rep in REPS:
			for tier in TIERS:
				var cell := _run_cell(bot, rep, tier)
				all_results["%s_%d_%d" % [bot, rep, tier]] = cell
				var line := "%s rep=%d tier=%d | med members w26=%d w52=%d w104=%d w156=%d | cash156=%d | closed=%d/%d" % [
					bot, rep, tier,
					_median(cell["mem_26"]), _median(cell["mem_52"]),
					_median(cell["mem_104"]), _median(cell["mem_156"]),
					_median(cell["cash_156"]),
					cell["closed"], SEEDS]
				if bot == "BUYER":
					line += " | pieces=%d spent=%d | top: %s" % [
						_median(cell["pieces_bought"]), _median(cell["money_spent"]),
						_top_pieces(cell["piece_names"], 3)]
				line += " | first_equip=%s equip_wk=%s coach_wk=%s premises_wk=%s" % [
					_med_str(cell["first_equip"]),
					_median(cell["equip_wks"]),
					_median(cell["coach_wks"]),
					_median(cell["premises_wks"])]
				print(line)
	_checks(all_results)
	print("GYM_BUY failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _run_cell(bot: String, rep: int, tier: int) -> Dictionary:
	var mem_26: Array = []
	var mem_52: Array = []
	var mem_104: Array = []
	var mem_156: Array = []
	var cash_156: Array = []
	var closed: int = 0
	var first_equip: Array = []
	var equip_wks: Array = []
	var coach_wks: Array = []
	var premises_wks: Array = []
	var pieces_bought: Array = []
	var money_spent: Array = []
	var piece_names: Array = []
	for si in SEEDS:
		var c := Career.quick_start()
		c.seed = 2000 + si
		c.reputation = rep
		c.premises = tier
		c.coach = {"name": "Luke Reid", "salary": 450, "rating": 58}
		GymSpend.set_dues(c, "standard")
		if bot == "WHOLE":
			c.gym_slots = []
		var cell_first_equip := -1
		var cell_equip := 0
		var cell_coach := 0
		var cell_premises := 0
		var cell_pieces := 0
		var cell_spent := 0
		var cell_piece_names: Array = []
		for week in range(1, WEEKS + 1):
			c.day += 7
			Sim.end_week(c)
			if week == 26:
				mem_26.append(c.members)
			if week == 52:
				mem_52.append(c.members)
			if week == 104:
				mem_104.append(c.members)
			if week == 156:
				mem_156.append(c.members)
			var lim := GymSpend.member_limit(c)
			if lim == "equipment":
				cell_equip += 1
				if cell_first_equip < 0:
					cell_first_equip = week
			elif lim == "coaches":
				cell_coach += 1
			elif lim == "premises":
				cell_premises += 1
			if bot == "BUYER" and lim == "equipment":
				var bought := _buyer_buy(c)
				for b in bought:
					cell_pieces += 1
					cell_spent += int(b["price"])
					cell_piece_names.append(str(b["name"]))
		cash_156.append(c.cash)
		if c.closed:
			closed += 1
		if cell_first_equip >= 0:
			first_equip.append(cell_first_equip)
		equip_wks.append(cell_equip)
		coach_wks.append(cell_coach)
		premises_wks.append(cell_premises)
		pieces_bought.append(cell_pieces)
		money_spent.append(cell_spent)
		piece_names.append_array(cell_piece_names)
	return {"mem_26": mem_26, "mem_52": mem_52, "mem_104": mem_104, "mem_156": mem_156,
		"cash_156": cash_156, "closed": closed, "first_equip": first_equip,
		"equip_wks": equip_wks, "coach_wks": coach_wks, "premises_wks": premises_wks,
		"pieces_bought": pieces_bought, "money_spent": money_spent, "piece_names": piece_names}


## The BUYER: buy the cheapest available piece (by price/places ratio) that is not blocked,
## keeping at least 8 weeks of costs in the bank. Returns the list of pieces bought this week.
func _buyer_buy(c: Career) -> Array:
	var weekly := int(Sim.weekly_costs(c)["total"])
	var reserve := weekly * 8
	var bought: Array = []
	var all_slots := GymSlots.all()
	var owned_ids: Array = c.gym_slots.map(func(r): return str(r["id"]))
	var candidates: Array = []
	for s in all_slots:
		var sid := str(s["id"])
		if owned_ids.has(sid):
			continue
		if int(s.get("places", 0)) <= 0:
			continue
		var why := GymSlots.blocked(sid, c.gym_slots, c.cash)
		if why != "":
			continue
		candidates.append(s)
	candidates.sort_custom(func(a, b):
		var pa := maxf(1.0, float(int(a["places"])))
		var pb := maxf(1.0, float(int(b["places"])))
		return float(int(a["price"])) / pa < float(int(b["price"])) / pb)
	for s in candidates:
		var price := int(s["price"])
		if c.cash - price < reserve:
			continue
		var why := GymSlots.blocked(str(s["id"]), c.gym_slots, c.cash)
		if why != "":
			continue
		var err := GymSpend.buy_slot(c, str(s["id"]))
		if err == "":
			bought.append(s)
			break
	return bought


func _checks(all: Dictionary) -> void:
	for rep in REPS:
		for tier in TIERS:
			var wk := "%s_%d_%d" % ["WHOLE", rep, tier]
			var nk := "%s_%d_%d" % ["NEVER", rep, tier]
			var w: Dictionary = all[wk]
			var n: Dictionary = all[nk]
			for cp in CHECKPOINTS:
				var key := "mem_%d" % cp
				var w_med: int = _median(w[key])
				var n_med: int = _median(n[key])
				if w_med < n_med:
					failures += 1
					print("FAIL: WHOLE rep=%d tier=%d w%d members %d < NEVER %d" % [rep, tier, cp, w_med, n_med])
	var any_greater := false
	for rep in REPS:
		for tier in TIERS:
			var wk := "%s_%d_%d" % ["WHOLE", rep, tier]
			var nk := "%s_%d_%d" % ["NEVER", rep, tier]
			var w_med: int = _median(all[wk]["mem_156"])
			var n_med: int = _median(all[nk]["mem_156"])
			if w_med > n_med:
				any_greater = true
	if not any_greater:
		failures += 1
		print("FAIL: WHOLE never ends with more members than NEVER in any cell")


func _median(arr: Array) -> int:
	if arr.is_empty():
		return 0
	var s := arr.duplicate()
	s.sort()
	var mid := s.size() / 2
	if s.size() % 2 == 0:
		return (int(s[mid - 1]) + int(s[mid])) / 2
	return int(s[mid])


func _med_str(arr: Array) -> String:
	if arr.is_empty():
		return "never"
	return str(_median(arr))


func _top_pieces(names: Array, n: int) -> String:
	if names.is_empty():
		return "none"
	var counts := {}
	for nm in names:
		counts[nm] = counts.get(nm, 0) + 1
	var sorted_keys := counts.keys()
	sorted_keys.sort_custom(func(a, b): return counts[a] > counts[b])
	var out: Array = []
	for i in mini(n, sorted_keys.size()):
		out.append("%s x%d" % [sorted_keys[i], counts[sorted_keys[i]]])
	return ", ".join(out)
