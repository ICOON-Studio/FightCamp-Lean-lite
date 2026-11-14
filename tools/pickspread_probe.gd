extends SceneTree
## PICKSPREAD1: is one of the coach's three "what to learn next" cards nearly always the best pick?
## 60 generated fighters x first 5 picks x the cards LearnSlots returns (up to 3); each card studied 6 weeks,
## then 16 bouts against each of 4 styles. A pick with fewer than three open cards is printed as returned, never padded.
## Setup copied from tools/treevalue_probe.gd (fighters, OPPS, PLAN, calibration, bout loop); no game script is changed.
## Usage: godot --headless --audio-driver Dummy --path . --script res://tools/pickspread_probe.gd

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const FireLevel := preload("res://scripts/rules/FireLevel.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const LearnSlots := preload("res://scripts/rules/LearnSlots.gd")
const StudyWeek := preload("res://scripts/rules/StudyWeek.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")

## Four opponents of different styles (treevalue_probe.gd).
const OPPS := [
	{"name": "Maria Ortega", "style": "Pressure fighter"},
	{"name": "Priya Nair", "style": "Counter-puncher"},
	{"name": "Erin Doyle", "style": "Volume puncher"},
	{"name": "Dana Whitfield", "style": "Boxer-puncher"},
]
## Plan: arrows covering every punch via combos, plus every step/defence in the situation table (treevalue_probe.gd).
const PLAN := [
	{"move": "step_back"},
	{"move": "pivot_out"},
	{"move": "tie_up"},
	{"move": "roll_out", "when": "loadup"},
	{"move": "push_off", "when": "press"},
	{"move": "1-1-2", "when": "press"},
	{"move": "2-3", "when": "range"},
	{"move": "1-2-3b", "when": "range"},
	{"move": "1-6-3", "when": "counter"},
	{"move": "slip 2-3", "when": "loadup"},
	{"move": "3b-3", "when": "tiring"},
	{"move": "step_in", "when": "range"},
	{"move": "feint", "when": "counter"},
	{"move": "cut_off", "when": "tiring"},
	{"move": "herd", "when": "hurt"},
	{"move": "step_out", "when": "she_tired"},
]
const BASE_VAL := 45.0
const N_FIGHTERS := 60
const SEED_START := 7100
const PICKS := 5
const WEEKS := 6
## 16 bouts per opponent = 64 per card: one bout is 1/64 = 1.5625 percentage points of the recorded four-style share (<2).
const N_BOUTS := 16

var opp_rating := {}
var bout_career: Career
var bout_count := 0


func _find_opp(name: String) -> Dictionary:
	for opp in Data.OPPONENTS:
		if str(opp["name"]) == name:
			return (opp as Dictionary).duplicate(true)
	if Data.MISMATCH["name"] == name:
		return (Data.MISMATCH as Dictionary).duplicate(true)
	return {}


## Generate a varied fighter from a seed (treevalue_probe.gd). Returns a fighter_state dict with day-0 moves/steps.
func _make_fighter(seed_val: int) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_val
	var prof := AttrGen.generate(rng)
	var style_name: String = AttrGen.style_word(prof)
	var first_names := ["Alex", "Sam", "Jordan", "Taylor", "Morgan", "Casey", "Riley", "Quinn", "Avery", "Skyler",
		"Jamie", "Drew", "Blake", "Cameron", "Dakota", "Emerson", "Finley", "Harper", "Hayden", "Jesse",
		"Kai", "Lane", "Logan", "Parker", "Reese", "Rowan", "Sage", "Spencer", "Tatum", "Winter"]
	var last_names := ["Smith", "Jones", "Brown", "Wilson", "Taylor", "Davies", "Evans", "Thomas", "Roberts", "Johnson",
		"Walker", "Wright", "Robinson", "White", "Thompson", "Moore", "Clark", "Lewis", "Hall", "Young",
		"King", "Baker", "Lee", "Green", "Adams", "Nelson", "Mitchell", "Harris", "Turner", "Fox"]
	var first: String = str(first_names[rng.randi_range(0, first_names.size() - 1)])
	var last: String = str(last_names[rng.randi_range(0, last_names.size() - 1)])
	var technique := clampf(50.0 + prof["shape"].get("accuracy", 0.0) * 0.5 + rng.randf_range(-5.0, 5.0), 30.0, 80.0)
	var fight_iq := clampf(50.0 + prof["shape"].get("fight_iq", 0.0) * 0.5 + rng.randf_range(-5.0, 5.0), 30.0, 80.0)
	var footwork := clampf(50.0 + prof["shape"].get("footwork", 0.0) * 0.5 + rng.randf_range(-5.0, 5.0), 30.0, 80.0)
	var f := {
		"id": "tv_%d" % seed_val,
		"name": "%s %s" % [first, last],
		"first": first,
		"sex": "f",
		"age": 22 + rng.randi_range(-3, 5),
		"wc": "Lightweight",
		"limit": 60.0,
		"weight": 60.0 + rng.randf_range(-1.0, 1.0),
		"stance": "orthodox" if rng.randf() < 0.7 else "southpaw",
		"style": style_name,
		"w": 3 + rng.randi_range(0, 5),
		"l": 1 + rng.randi_range(0, 3),
		"pot": 70 + rng.randi_range(-10, 15),
		"cards": [],
		"focus": "conditioning",
		"div": "wlw",
		"diet": "hold",
		"fatigue": 8,
		"weekly_salary": 250,
		"booked_fight": false,
		"history": [],
		"stats": {
			"power": clampf(55.0 + rng.randf_range(-10.0, 10.0), 35.0, 80.0),
			"speed": clampf(55.0 + rng.randf_range(-10.0, 10.0), 35.0, 80.0),
			"technique": technique,
			"defense": clampf(55.0 + rng.randf_range(-10.0, 10.0), 35.0, 80.0),
			"conditioning": clampf(55.0 + rng.randf_range(-10.0, 10.0), 35.0, 80.0),
			"fight_iq": fight_iq,
			"chin": clampf(55.0 + rng.randf_range(-10.0, 10.0), 35.0, 80.0),
		},
		"goal": {},
		"shape": prof["shape"],
		"pace": float(prof["pace"]),
		"forward": float(prof["forward"]),
		"heart": float(prof["heart"]),
		"footwork": footwork,
	}
	return Data.fighter_state(f, 40 + (seed_val - SEED_START))


func _base_dict() -> Dictionary:
	var moves := {}; var steps := {}; var combos := {}
	for k in Data.MOVES:
		moves[k] = BASE_VAL
	for k in MoveTree.STEP_IDS + MoveTree.DEFENCE_IDS:
		steps[k] = BASE_VAL
	for k in MoveTree.COMBO_PUNCHES:
		combos[k] = BASE_VAL
	return {"moves": moves, "steps": steps, "combos": combos}


## TREEVALUE's bout setup and loop, with the career fixture reused and the verdict read before career bookkeeping.
## The fighter dict is copied; the same seed_offset is used for all three cards of a pick (paired dice).
func _run_bout(seed_offset: int, opp_name: String, fighter: Dictionary) -> Dictionary:
	var c := bout_career
	c.fighters = [fighter.duplicate(true)]
	c.day = 40 + seed_offset
	c.coach = {}
	c.results = []
	c.news = []
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["morale"] = 60.0
	f["arrows"] = PLAN.duplicate(true)
	var opp: Dictionary = _find_opp(opp_name)
	if opp_rating.has(opp_name):
		opp["rating"] = float(opp_rating[opp_name])
	f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 0, "rounds": 3}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "start")
	while true:
		while not LiveRound.live(m).is_empty():
			Bouts.fight_step(c, f, m, "shout:")
		if int(m["round"]) >= Bouts.rounds_of(f) or Bouts.stopped(m) != "":
			break
		Bouts.fight_step(c, f, m, "corner:" + BoutRules.auto_corner(f["stats"]))
	bout_count += 1
	return {"outcome": BoutNight.outcome_of(f, m)}


func _run_cell(opp_name: String, moves: Dictionary, steps: Dictionary, combos: Dictionary, n: int) -> Dictionary:
	var wins := 0
	for i in n * N_FIGHTERS:
		var f := _make_fighter(SEED_START + (i % N_FIGHTERS))
		f["moves"] = moves.duplicate()
		f["steps"] = steps.duplicate()
		f["combos"] = combos.duplicate()
		var r := _run_bout(i, opp_name, f)
		wins += int(str(r["outcome"]) == "win")
	return {"wins": wins}


## Six weeks of pad-night gain on the picked node. Steps/defences use the wired StudyWeek.week; punches use the
## existing pad route PadWeek.drill on the usual three pad nights (no coach bonus, as treevalue's coach is {}).
func _pad_week(f: Dictionary, id: String) -> void:
	if MoveTree.PUNCH_IDS.has(id):
		PadWeek.drill(f, "move:" + id, PadWeek.PAD_NIGHT_MINUTES * StudyWeek.USUAL_PADS, 0.0,
			PadWeek.STATION_TIER, PadWeek.PAD_STATION)
	else:
		StudyWeek.week(f, int(StudyWeek.USUAL_PADS))


func _study_six_weeks(f: Dictionary, id: String) -> Dictionary:
	var out := f.duplicate(true)
	if not LearnSlots.pick(out, id, LearnSlots.slots(-1.0)):
		push_error("PICKSPREAD could not pick open card %s" % id)
		quit(2)
		return {}
	if MoveTree.PUNCH_IDS.has(id):
		out["learning"] = id
	for _w in WEEKS:
		_pad_week(out, id)
	LearnSlots.drop(out, id)
	return out


func _card_win_share(f: Dictionary, seed_base: int) -> Dictionary:
	var wins := 0
	var per_opp: Array = []
	for oi in OPPS.size():
		var ow := 0
		for r in N_BOUTS:
			var res := _run_bout(seed_base + oi * N_BOUTS + r, str(OPPS[oi]["name"]), f)
			ow += int(str(res["outcome"]) == "win")
		per_opp.append(ow)
		wins += ow
	return {"share": float(wins) / float(OPPS.size() * N_BOUTS), "wins": wins, "per_opp": per_opp}


func _initialize() -> void:
	seed(SEED_START)
	FireLevel.probe_off = false
	bout_career = Career.quick_start()
	var t0 := Time.get_ticks_msec()
	print("=== PICKSPREAD1: is one learn-next card nearly always best? ===")
	print("Fighters=%d picks=%d cards=3 weeks=%d bouts_per_opponent=%d fire_level=%s" % [
		N_FIGHTERS, PICKS, WEEKS, N_BOUTS, str(FireLevel.GAME_SHARES)])
	var base := _base_dict()
	print("--- CALIBRATE: TREEVALUE BASE (all nodes 45) wins about half, 7 bisection steps ---")
	for opp in OPPS:
		var on: String = str(opp["name"])
		var lo := 30.0
		var hi := float(_find_opp(on)["rating"])
		for _k in 7:
			opp_rating[on] = (lo + hi) / 2.0
			var w := int(_run_cell(on, base["moves"], base["steps"], base["combos"], 1)["wins"])
			if w > N_FIGHTERS / 2:
				lo = float(opp_rating[on])
			else:
				hi = float(opp_rating[on])
		print("  %s (%s): shipped %.1f -> calibrated %.8f" % [on, str(opp["style"]), float(_find_opp(on)["rating"]), float(opp_rating[on])])
	var pos_credit := [0.0, 0.0, 0.0]
	var coach_credit := 0.0
	var node_shown := {}
	var node_best := {}
	var pick_rows := []
	var total_cards := 0
	var pick_count := 0
	var short_picks := 0
	for fi in N_FIGHTERS:
		var f := _make_fighter(SEED_START + fi)
		f["combos"] = (base["combos"] as Dictionary).duplicate()
		f["learning_slots"] = []
		f["camp"] = {}
		f["morale"] = 60.0
		var opp_style: String = str(OPPS[fi % OPPS.size()]["style"])
		for n in PICKS:
			var cards: Array = LearnSlots.cards(f, opp_style, {})
			if cards.is_empty():
				push_error("PICKSPREAD fighter=%d n=%d has no open card" % [fi, n + 1])
				quit(2)
				return
			if cards.size() < 3:
				short_picks += 1
			var ids: Array = []
			var shares: Array = []
			var trained: Array = []
			for p in cards.size():
				var id: String = str(cards[p]["id"])
				ids.append(id)
				node_shown[id] = int(node_shown.get(id, 0)) + 1
				total_cards += 1
				var cf := _study_six_weeks(f, id)
				trained.append(cf)
				var seed_base := fi * PICKS * OPPS.size() * N_BOUTS + n * OPPS.size() * N_BOUTS
				shares.append(float(_card_win_share(cf, seed_base)["share"]))
			var best_share := float(shares[0])
			for s in shares:
				best_share = maxf(best_share, float(s))
			var tied: Array = []
			for p in shares.size():
				if absf(float(shares[p]) - best_share) < 0.0000001:
					tied.append(p)
			var credit := 1.0 / float(tied.size())
			for p in tied:
				pos_credit[int(p)] += credit
				var id: String = str(ids[int(p)])
				node_best[id] = float(node_best.get(id, 0.0)) + credit
			if tied.has(0):
				coach_credit += credit
			pick_count += 1
			pick_rows.append({"fighter": fi, "n": n + 1, "ids": ids, "shares": shares, "best": int(tied[0]), "ties": tied.size()})
			var win_strs: PackedStringArray = []
			for s in shares:
				win_strs.append("%.4f" % float(s))
			print("PICK fighter=%d n=%d cards=%s win=%s best=%d" % [fi, n + 1, ",".join(ids), ",".join(win_strs), int(tied[0])])
			f = trained[0]
	var pos_shares: Array = []
	for v in pos_credit:
		pos_shares.append(float(v) / float(pick_count))
	var coach_share := coach_credit / float(pick_count)
	var node_max_id := ""
	var node_max_share := -1.0
	for id in node_best:
		var s := float(node_best[id]) / float(node_shown[id])
		if s > node_max_share:
			node_max_share = s
			node_max_id = str(id)
	var pivot_share := float(node_shown.get("pivot_out", 0)) / float(total_cards)
	var failed: Array = []
	for p in 3:
		if float(pos_credit[p]) * 10.0 > float(pick_count) * 6.0 + 0.0000001:
			failed.append("position_%d_best>0.6" % p)
	if coach_credit * 10.0 >= float(pick_count) * 5.0 - 0.0000001:
		failed.append("coach_first_best>=0.5")
	if node_max_id != "" and float(node_best[node_max_id]) * 10.0 > float(node_shown[node_max_id]) * 4.0 + 0.0000001:
		failed.append("node_best_max>0.4")
	var pass_int := 0 if not failed.is_empty() else 1
	var why := ",".join(failed) if not failed.is_empty() else "none"
	print("PICKSPREAD position_best=%.4f,%.4f,%.4f coach_first_best=%.4f node_best_max=%s:%.4f pivot_share=%.4f" % [
		float(pos_shares[0]), float(pos_shares[1]), float(pos_shares[2]), coach_share, node_max_id, node_max_share, pivot_share])
	print("PICKSPREAD pass=%d why=%s" % [pass_int, why])
	var seconds := float(Time.get_ticks_msec() - t0) / 1000.0
	print("PICKSPREAD picks=%d pick_lines=%d cards_shown=%d short_picks=%d bouts=%d seconds=%.1f" % [pick_count, pick_rows.size(), total_cards, short_picks, bout_count, seconds])
	_write_result_doc(pos_shares, coach_share, node_max_id, node_max_share, pivot_share, node_shown, node_best, pick_count, total_cards, pass_int, why, seconds)
	print("RESULT: tools/pickspread_probe.gd -> PICKSPREAD pass=%d picks=%d bouts=%d seconds=%.1f" % [pass_int, pick_count, bout_count, seconds])
	quit(0 if pass_int == 1 else 1)


func _write_result_doc(pos_shares: Array, coach_share: float, node_max_id: String, node_max_share: float,
		pivot_share: float, node_shown: Dictionary, node_best: Dictionary, pick_count: int, total_cards: int,
		pass_int: int, why: String, seconds: float) -> void:
	var f := FileAccess.open("res://docs/PICKSPREAD1_RESULT.md", FileAccess.WRITE)
	if f == null:
		push_error("PICKSPREAD could not write docs/PICKSPREAD1_RESULT.md")
		return
	f.store_line("# PICKSPREAD1 Result")
	f.store_line("")
	f.store_line("Probe run: %s. Godot 4.7.2 headless. %d fighters x %d picks = %d PICK lines; %d cards shown; %d bouts; %.1f s." % [
		Time.get_datetime_string_from_system(), N_FIGHTERS, PICKS, pick_count, total_cards, bout_count, seconds])
	f.store_line("")
	f.store_line("## Method")
	f.store_line("")
	f.store_line("Fighters are TREEVALUE's AttrGen seeds 7100-7159 at their generated day-0 moves/steps (the all-45 sweep fixture has no open cards). Combos start at TREEVALUE's 45. Opponent ratings are calibrated by TREEVALUE's 7-step bisection against the all-45 BASE: %s." % str(opp_rating))
	f.store_line("Each pick asks LearnSlots.cards(f, opp_style, {}); opp_style rotates through the four OPPS styles by fighter. LearnSlots returns up to three open cards; a shorter list is measured as returned, never padded with a phantom card. Each card is copied, picked with LearnSlots.pick, studied six weeks, then fought %d bouts against each OPPS (%d per card). Steps/defences use StudyWeek.week; punches use PadWeek.drill on the usual three pad nights. The career continues down card 0. FireLevel is on (GAME_SHARES)." % [N_BOUTS, OPPS.size() * N_BOUTS])
	f.store_line("One bout is 1/%d = %.4f percentage points of a card's four-style win share (<2). Equal win shares split best credit equally; the PICK line prints the first tied position. Gates: no position best >0.6; coach first best <0.5; no node best >0.4 of the picks it appears in." % [OPPS.size() * N_BOUTS, 100.0 / float(OPPS.size() * N_BOUTS)])
	f.store_line("")
	f.store_line("## Shares")
	f.store_line("")
	f.store_line("| Measure | Share | Gate |")
	f.store_line("|---|---:|---|")
	for p in 3:
		f.store_line("| Position %d best | %.4f | <= 0.6 |" % [p, float(pos_shares[p])])
	f.store_line("| Coach first card best | %.4f | < 0.5 |" % coach_share)
	f.store_line("| Max node best (%s) | %.4f | <= 0.4 |" % [node_max_id, node_max_share])
	f.store_line("| Pivot shown among all cards | %.4f | report |" % pivot_share)
	f.store_line("")
	f.store_line("| Node | Shown | Best credit | Best share |")
	f.store_line("|---|---:|---:|---:|")
	var ids: Array = node_shown.keys()
	ids.sort_custom(func(a, b): return float(node_best.get(b, 0.0)) / float(node_shown[b]) > float(node_best.get(a, 0.0)) / float(node_shown[a]))
	for id in ids:
		var sid := str(id)
		f.store_line("| %s | %d | %.3f | %.4f |" % [sid, int(node_shown[sid]), float(node_best.get(sid, 0.0)), float(node_best.get(sid, 0.0)) / float(node_shown[sid])])
	f.store_line("")
	f.store_line("**PICKSPREAD pass=%d why=%s**" % [pass_int, why])
	f.store_line("")
	var verdict := "a real choice" if pass_int == 1 else "not a real choice yet"
	var signal_text := "No card position, coach-first card, or single node crosses the dominance gates." if pass_int == 1 else "The failed gate is %s; the strongest node signal is %s at %.4f of its appearances." % [why, node_max_id, node_max_share]
	f.store_line("The pick is %s on these %d six-week roads. %s LearnSlots gives +3 for answering the opponent's style, +2 for completing a style set, and up to +2 for opening other nodes; equal scores fall back to the tree's order, and weeks-to-Usable is only a label. It never scores expected wins, so a card can look sensible and still not be the road that wins more; punches also change the weapons the bout reads, while a step mainly changes whether its planned line fires." % [verdict, pick_count, signal_text])
	f.close()
	print("Result doc written to docs/PICKSPREAD1_RESULT.md")
