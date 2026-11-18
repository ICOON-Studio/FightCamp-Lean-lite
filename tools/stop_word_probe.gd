extends SceneTree
## STOPWORD1 (S513, ops/research/TASK_STOPWORD1.md): the Ask card's stoppage word. A coach looks at the other boxer's level
## and record and says "he won't stop you", "he could", "he can really hurt you" - so fight many real bouts at each rating
## gap and count how often OUR boxer is stopped. The brief's chance edges: under 8 % unlikely, 8-20 % possible, over 20 %
## a real risk. scripts/rules/StopWord.gd carries the rating edges read off this table; docs/STOPWORD1_RESULT.md is written
## here so the table and the bands stay reproducible.
## HOW THE BRIEF IS READ: the pool is the boxer's OWN weight class (Data.OPPONENTS + MISMATCH + RIVALS for wlw,
## DIVISION_RIVALS for the rest: 4 to 11 names, the brief's trap). The seven asked gaps are dealt FAR FIRST, each taking
## the nearest opponent still AVAILABLE, so +15 reaches the top of the pool instead of leaving it to the last pick, and
## every name a boxer meets is distinct. A gap with no name left is reported unmeasured (n=0), never filled with a repeat.
## Every bout's REAL gap (opponent rating minus our fight power) is recorded and the tables bucket by it, not by the gap
## asked for. No bout pairs a boxer with itself or with a synthesized copy: every opponent is a named amateur of the pool.
## THE EDGES: one 60-bout row is noisy (SE ~4 points on a 10 % chance) and the three boxers' chins differ, so the raw rows
## are not monotone. The 2.5-point bins are pooled into monotone blocks (a bin lower than the block before it joins it) and
## the rating edges are read off THOSE, midway between the last gap below and the first gap at/over each chance edge.
## POPULATION: the TEST CLUB's three boxers exactly as TestClub writes them (no jitter, no camp, no injury, fresh at every
## bell), 60 bouts an asked gap, seeds off 4421, the game's real bout (Bouts.fight_step to the end, ask_probe2's loop).
## Usage: python ops/Tools/godot_slot.py run --who stopword1 -- <godot> --headless --audio-driver Dummy --fixed-fps 60
##          --path . --log-file E:/FightCamp/tmp/stopword1.log --script res://tools/stop_word_probe.gd -- bouts=60

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const TestClub := preload("res://scripts/state/TestClub.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")
const StopWord := preload("res://scripts/rules/StopWord.gd")

const GAPS := [-15.0, -10.0, -5.0, 0.0, 5.0, 10.0, 15.0]
const BIN := 2.5
const DOC := "res://docs/STOPWORD1_RESULT.md"

var n_bouts := 60
var base_seed := 4421
var c: Career
var club: Array = []
var rivals0: Array = []
var rows: Array = []
var pooled := {}
var binned := {}
var blocks: Array = []
var kinds := {}
var bouts_played := 0


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=")
		if kv.size() == 2:
			match kv[0]:
				"bouts": n_bouts = int(kv[1])
				"seed": base_seed = int(kv[1])
	var t0 := Time.get_ticks_msec()
	c = Career.quick_start()
	c.seed = base_seed
	TestClub.make(c)
	club = c.fighters.duplicate(true)
	rivals0 = c.rivals.duplicate(true)
	print("STOPWORD1 %d bouts an asked gap, seed %d, the TEST CLUB's three boxers, %d asked gaps" % [n_bouts, base_seed, GAPS.size()])
	print("  chance edges: unlikely under %.0f%%, possible %.0f-%.0f%%, a real risk over %.0f%% (our boxer stopped)" % [
		StopWord.CHANCE_POSSIBLE * 100.0, StopWord.CHANCE_POSSIBLE * 100.0, StopWord.CHANCE_RISK * 100.0, StopWord.CHANCE_RISK * 100.0])
	for bi in club.size():
		_boxer(bi, club[bi])
	blocks = _blocks()
	_report()
	_doc()
	print("STOPWORD1 bouts: %d in %ds" % [bouts_played, (Time.get_ticks_msec() - t0) / 1000])
	print("STOPWORD1 done")
	quit(0)


## One boxer: its own class's pool, the seven asked gaps dealt far first, 60 real bouts each.
func _boxer(bi: int, f: Dictionary) -> void:
	var own := BoutRules.fight_power(f["stats"], {}, 0, "")
	var own_bouts := AmateurBooking.bouts_of(int(f["w"]), int(f["l"]), int(f.get("d", 0)))
	var pool := _pool(f)
	var picks := _assign(own, pool)
	print("\n%s (%s, %s) fight power %.2f, chin %.1f, morale %.1f, %d bouts - pool %d names" % [str(f["name"]), str(f["div"]),
		str(Data.DIVISIONS[str(f["div"])]["name"]), own, float(f["stats"].get("chin", 0.0)), float(f.get("morale", 0.0)), own_bouts, pool.size()])
	var met := {}
	var legal_n := 0
	for gi in GAPS.size():
		var g := float(GAPS[gi])
		var opp: Dictionary = picks[g]
		if opp.is_empty():
			print("  asked %+6.1f  no opponent left: the pool is spent (n=0)" % g)
			rows.append({"boxer": str(f["name"]), "asked": g, "opp": "", "rating": 0.0, "real": 0.0, "legal": false,
				"n": 0, "our": 0, "their": 0, "dec": 0})
			continue
		var nm := str(opp["name"])
		var real := float(opp["rating"]) - own
		if nm == str(f["name"]) or met.has(nm):
			print("  WARNING: %s met twice or met itself - the measurement is void" % nm)
		met[nm] = true
		var legal := AmateurBooking.experience_match_ok(own_bouts, AmateurBooking.bouts_of(int(opp["w"]), int(opp["l"])))
		legal_n += int(legal)
		var t := {"n": 0, "our": 0, "their": 0, "dec": 0}
		for k in n_bouts:
			var r := _fight(f, nm, base_seed * 104729 + (bi * GAPS.size() + gi) * n_bouts + k)
			t["n"] = int(t["n"]) + 1
			t["our"] = int(t["our"]) + int(bool(r["our"]))
			t["their"] = int(t["their"]) + int(bool(r["their"]))
			t["dec"] = int(t["dec"]) + int(not bool(r["our"]) and not bool(r["their"]))
			_add(pooled, "%.2f" % real, r, real)
			_add(binned, "%.1f" % (floorf(real / BIN) * BIN), r, real)
			if str(r["kind"]) != "":
				kinds[str(r["kind"])] = int(kinds.get(str(r["kind"]), 0)) + 1
		rows.append({"boxer": str(f["name"]), "asked": g, "opp": nm, "rating": float(opp["rating"]), "real": real, "legal": legal,
			"n": int(t["n"]), "our": int(t["our"]), "their": int(t["their"]), "dec": int(t["dec"])})
		print("  asked %+6.1f  %-18s rating %.1f  REAL %+6.2f  n %3d  ours %5.1f%%  theirs %5.1f%%  dec %5.1f%%  %-12s card:%s" % [g, nm,
			float(opp["rating"]), real, int(t["n"]), _pct(t, "our"), _pct(t, "their"), _pct(t, "dec"), _band(_pct(t, "our")), "yes" if legal else "no"])
	print("  distinct opponents met: %d of the pool's %d (none our boxer, none a copy); %d a legal novice match today" % [met.size(), pool.size(), legal_n])


## The boxer's own weight class: the real named amateurs the career holds, never ours, never a synthesized fighter.
func _pool(f: Dictionary) -> Array:
	var out: Array = []
	for r in c.rivals:
		if str(r.get("div", "")) == str(f["div"]) and Data.sex_of(r) == Data.sex_of(f) and str(r["name"]) != str(f["name"]):
			out.append(r)
	out.sort_custom(func(x, y): return float(x["rating"]) < float(y["rating"]))
	return out


## The asked gaps, the far ones first: each takes the nearest opponent still available (a tie by name, so a replay agrees).
## {} for a gap the spent pool cannot answer.
func _assign(own: float, pool: Array) -> Dictionary:
	var order: Array = GAPS.duplicate()
	order.sort_custom(func(x, y):
		var ax := absf(float(x))
		var ay := absf(float(y))
		return ax > ay if absf(ax - ay) > 1e-9 else float(x) < float(y))
	var used := {}
	var out := {}
	for g in order:
		var best: Dictionary = {}
		var bd := INF
		for r in pool:
			if used.has(str(r["name"])):
				continue
			var d := absf(float(r["rating"]) - own - float(g))
			if d < bd - 1e-9 or (d <= bd + 1e-9 and (best.is_empty() or str(r["name"]) < str(best["name"]))):
				bd = d
				best = r
		out[float(g)] = best
		if not best.is_empty():
			used[str(best["name"])] = true
	return out


## The game's real bout, ask_probe2's loop: tape, every live shout, the auto corner, the end. The pool is put back after
## every bout so no record or rating drifts across the 60 (BoutFinish writes the rival's own result).
func _fight(base: Dictionary, nm: String, dice: int) -> Dictionary:
	var keep: Array = c.fighters
	var day0 := c.day
	var g: Dictionary = base.duplicate(true)
	var opp: Dictionary = c.rival(nm).duplicate(true)
	c.day = 200000 + dice
	c.fighters = [g]
	g["camp"] = {}
	g["notes_seen"] = []
	g["injury"] = {}
	g["ko_history"] = []
	g["offers"] = []
	g["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
	var m := {"fid": g["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, g, m, "start")
	while true:
		while not LiveRound.live(m).is_empty():
			Bouts.fight_step(c, g, m, "shout:")
		if int(m["round"]) >= Bouts.rounds_of(g) or Bouts.stopped(m) != "":
			break
		Bouts.fight_step(c, g, m, "corner:" + BoutRules.auto_corner(g["stats"]))
	Bouts.fight_step(c, g, m, "end")
	bouts_played += 1
	var outc := str(m.get("outcome", ""))
	var stop := Bouts.stopped(m)
	var r := {"our": outc == "loss" and stop != "", "their": outc == "win" and stop != "", "kind": stop, "won": outc == "win"}
	c.results.clear()
	c.news.clear()
	c.rivals = rivals0.duplicate(true)
	c.fighters = keep
	c.day = day0
	return r


func _add(tab: Dictionary, key: String, r: Dictionary, real: float) -> void:
	if not tab.has(key):
		tab[key] = {"n": 0, "our": 0, "their": 0, "dec": 0, "gap": 0.0}
	var e: Dictionary = tab[key]
	e["n"] = int(e["n"]) + 1
	e["our"] = int(e["our"]) + int(bool(r["our"]))
	e["their"] = int(e["their"]) + int(bool(r["their"]))
	e["dec"] = int(e["dec"]) + int(not bool(r["our"]) and not bool(r["their"]))
	e["gap"] = float(e["gap"]) + real


func _pct(t: Dictionary, k: String) -> float:
	return 100.0 * float(t[k]) / maxf(1.0, float(t["n"]))


## The band the brief's CHANCE edges put a measured our-stopped percentage in.
func _band(pct: float) -> String:
	if pct < StopWord.CHANCE_POSSIBLE * 100.0:
		return "unlikely"
	if pct < StopWord.CHANCE_RISK * 100.0:
		return "possible"
	return "a real risk"


func _keys(tab: Dictionary) -> Array:
	var out: Array = tab.keys()
	out.sort_custom(func(x, y): return float(x) < float(y))
	return out


func _mean(b: Dictionary) -> float:
	return float(b["gap"]) / maxf(1.0, float(b["n"]))


## The monotone blocks: the BIN-point bins with adjacent violators pooled (a bin whose our-stopped chance is LOWER than
## the block before it joins it), so a monotone word() is read off steadier numbers than one 60-bout row.
func _blocks() -> Array:
	var out: Array = []
	for k in _keys(binned):
		var t: Dictionary = binned[k]
		var b := {"lo": float(k), "hi": float(k) + BIN, "n": int(t["n"]), "our": int(t["our"]), "their": int(t["their"]),
			"dec": int(t["dec"]), "gap": float(t["gap"])}
		while not out.is_empty() and _pct(b, "our") < _pct(out[-1], "our"):
			var p: Dictionary = out.pop_back()
			b["lo"] = float(p["lo"])
			for key in ["n", "our", "their", "dec"]:
				b[key] = int(b[key]) + int(p[key])
			b["gap"] = float(b["gap"]) + float(p["gap"])
		out.append(b)
	return out


func _block_of(gap: float) -> Dictionary:
	for b in blocks:
		if gap >= float(b["lo"]) and gap < float(b["hi"]):
			return b
	return {}


## Where a chance edge falls: midway between the last measured gap below the first block at/over it and the first gap in
## that block. Below the measured range when the first block already crosses; INF when no block ever does.
func _recommend(chance: float) -> Dictionary:
	for i in blocks.size():
		var b: Dictionary = blocks[i]
		if _pct(b, "our") >= chance:
			var below := -INF
			var at := INF
			for k in _keys(pooled):
				var g := float(k)
				if g < float(b["lo"]):
					below = maxf(below, g)
				elif g < float(b["hi"]):
					at = minf(at, g)
			if i == 0 or below == -INF:
				return {"at": at - 5.0, "why": "the first block already crosses it: the edge stays below the measured range"}
			return {"at": (below + at) * 0.5, "why": "midway between the last gap below (%+.2f) and the first at/over (%+.2f)" % [below, at]}
	return {"at": INF, "why": "NOT REACHED: no measured block stops our boxer that often, so the edge stays beyond the measured range"}


func _raw_lines() -> Array:
	var out: Array = ["  real gap     n   ours%  theirs%   dec%  band(chance)   StopWord.word"]
	for k in _keys(pooled):
		var t: Dictionary = pooled[k]
		out.append("  %+8.2f %5d %7.1f %7.1f %7.1f  %-13s %s" % [float(k), int(t["n"]), _pct(t, "our"), _pct(t, "their"),
			_pct(t, "dec"), _band(_pct(t, "our")), StopWord.word(float(k))])
	return out


func _bin_lines() -> Array:
	var out: Array = ["  bin              mean gap    n   ours%  theirs%   dec%  band(chance)"]
	for k in _keys(binned):
		var t: Dictionary = binned[k]
		out.append("  [%+6.1f,%+6.1f)  %+8.2f %4d %7.1f %7.1f %7.1f  %s" % [float(k), float(k) + BIN, _mean(t), int(t["n"]),
			_pct(t, "our"), _pct(t, "their"), _pct(t, "dec"), _band(_pct(t, "our"))])
	return out


func _block_lines() -> Array:
	var out: Array = ["  block (REAL gap)   mean     n   ours%  theirs%   dec%  band(chance)   StopWord.word"]
	for b in blocks:
		out.append("  [%+6.1f,%+6.1f)  %+7.2f %5d %7.1f %7.1f %7.1f  %-13s %s" % [float(b["lo"]), float(b["hi"]), _mean(b),
			int(b["n"]), _pct(b, "our"), _pct(b, "their"), _pct(b, "dec"), _band(_pct(b, "our")), StopWord.word(_mean(b))])
	return out


## The raw rows whose own chance band differs from the word the monotone rule gives them (the boxers' chins differ).
func _disagreements() -> Array:
	var out: Array = []
	for k in _keys(pooled):
		var t: Dictionary = pooled[k]
		if StopWord.word(float(k)) != _band(_pct(t, "our")):
			out.append("REAL gap %+.2f: the measured %.1f%% says **%s**, StopWord.word says **%s**" % [float(k), _pct(t, "our"),
				_band(_pct(t, "our")), StopWord.word(float(k))])
	return out


func _report() -> void:
	print("\nPOOLED by REAL gap (all three boxers, %d bouts)" % bouts_played)
	for l in _raw_lines():
		print(l)
	print("\nBINNED by REAL gap (%.1f-point bins)" % BIN)
	for l in _bin_lines():
		print(l)
	print("\nMONOTONE BLOCKS (adjacent violators pooled) - the table the rating edges are read off")
	for l in _block_lines():
		print(l)
	print("\nstoppage kinds: %s" % str(kinds))
	var rp := _recommend(StopWord.CHANCE_POSSIBLE * 100.0)
	var rr := _recommend(StopWord.CHANCE_RISK * 100.0)
	print("the %.0f%% edge: %s -> %+.2f" % [StopWord.CHANCE_POSSIBLE * 100.0, str(rp["why"]), float(rp["at"])])
	print("the %.0f%% edge: %s -> %+.2f" % [StopWord.CHANCE_RISK * 100.0, str(rr["why"]), float(rr["at"])])
	print("StopWord edges: unlikely below %+.2f, possible to %+.2f, a real risk above" % [StopWord.POSSIBLE_GAP, StopWord.RISK_GAP])
	var bad := 0
	for k in _keys(pooled):
		var b: Dictionary = _block_of(float(k))
		if b.is_empty() or StopWord.word(float(k)) != _band(_pct(b, "our")):
			bad += 1
	print("every measured gap against its BLOCK's band: %d disagreements of %d rows" % [bad, pooled.size()])
	for d in _disagreements():
		print("  raw row disagrees: " + d)


func _doc() -> void:
	var rp := _recommend(StopWord.CHANCE_POSSIBLE * 100.0)
	var rr := _recommend(StopWord.CHANCE_RISK * 100.0)
	var L: Array = []
	L.append("# STOPWORD1 Result - the Ask card's stoppage word")
	L.append("")
	L.append("Probe run: %s. %d bouts an asked gap, seeds off %d, %d real bouts in all." % [
		Time.get_datetime_string_from_system(), n_bouts, base_seed, bouts_played])
	L.append("")
	L.append("The card says the stoppage chance IN WORDS ONLY (ASKFIGHT_MAP_S441.md s4): **unlikely / possible / a real risk**. A coach looks at the other boxer's level and record and says \"he won't stop you\", \"he could\", \"he can really hurt you\" - so this probe fights many real bouts at each rating gap and counts how often OUR boxer is stopped. The chance edges are the brief's: under %.0f%% unlikely, %.0f-%.0f%% possible, over %.0f%% a real risk." % [
		StopWord.CHANCE_POSSIBLE * 100.0, StopWord.CHANCE_POSSIBLE * 100.0, StopWord.CHANCE_RISK * 100.0, StopWord.CHANCE_RISK * 100.0])
	L.append("")
	L.append("## Population")
	L.append("")
	L.append("The TEST CLUB (scripts/state/TestClub.gd), exactly as it writes them - no ability jitter, no camp, no injury, no ko_history, fresh at every bell:")
	L.append("")
	L.append("| boxer | class | fight power | chin | morale | bouts | pool |")
	L.append("|---|---|---|---|---|---|---|")
	for f in club:
		L.append("| %s | %s (%s) | %.2f | %.1f | %.1f | %d | %d names |" % [str(f["name"]), str(f["div"]),
			str(Data.DIVISIONS[str(f["div"])]["name"]), BoutRules.fight_power(f["stats"], {}, 0, ""),
			float(f["stats"].get("chin", 0.0)), float(f.get("morale", 0.0)),
			AmateurBooking.bouts_of(int(f["w"]), int(f["l"]), int(f.get("d", 0))), _pool(f).size()])
	L.append("")
	L.append("Opponents: the real named amateurs of the boxer's OWN weight class and sex that the career holds (Data.OPPONENTS + Data.MISMATCH + Data.RIVALS for wlw, Data.DIVISION_RIVALS for the rest). Ratings and records are the career's, not Data's raw table: the TEST CLUB's first week runs a club show and Region.record nudges a rival's rating and record. A class's pool is small - 4 to 11 names - and no opponent is synthesized, so no bout ever pairs two identical fighters. The pool is put back after every bout: no record or rating drifts across the 60.")
	L.append("")
	L.append("## Method")
	L.append("")
	L.append("- The game's real bout: `Bouts.fight_step` to the end, ask_probe2's loop (tape, every live shout, the auto corner, the end). Three rounds, the amateur bout.")
	L.append("- The seven asked gaps %s are dealt **far first**, each taking the nearest opponent still available (a tie by name). So +15 reaches the top of the pool, and every name a boxer meets is distinct. A gap the spent pool cannot answer is reported n=0, never filled with a repeat." % str(GAPS))
	L.append("- gap = opponent rating minus our boxer's `BoutRules.fight_power(stats, {}, 0, \"\")` - the same gap AskFlow.teach_word reads.")
	L.append("- **Every bout's REAL gap is recorded and the tables bucket by it**, not by the gap asked for (the brief's trap).")
	L.append("- our stopped = the outcome is a loss and `Bouts.stopped(m)` is not empty; their stopped = a win and a stoppage; decision = neither side stopped. Dice: `c.day = 200000 + %d * 104729 + (boxer * 7 + gap) * %d + bout`." % [base_seed, n_bouts])
	L.append("- card:yes = the opponent is a legal novice match for that boxer today (AmateurBooking.experience_match_ok), so AskBout.answers can offer it; card:no = past the novice rule, measured for the curve but not yet reachable on a card.")
	L.append("")
	L.append("## Asked gap -> the opponent it reached")
	L.append("")
	L.append("| boxer | asked | opponent | rating | REAL gap | n | our stopped % | their stopped % | decisions % | card |")
	L.append("|---|---|---|---|---|---|---|---|---|---|")
	for r in rows:
		if int(r["n"]) == 0:
			L.append("| %s | %+.1f | _none left_ | - | - | 0 | - | - | - | - |" % [str(r["boxer"]), float(r["asked"])])
		else:
			L.append("| %s | %+.1f | %s | %.1f | %+.2f | %d | %.1f | %.1f | %.1f | %s |" % [str(r["boxer"]), float(r["asked"]),
				str(r["opp"]), float(r["rating"]), float(r["real"]), int(r["n"]), _pct(r, "our"), _pct(r, "their"), _pct(r, "dec"),
				"yes" if bool(r["legal"]) else "no"])
	L.append("")
	L.append("## The table: REAL gap -> the chance (all three boxers pooled)")
	L.append("")
	L.append("```")
	L.append_array(_raw_lines())
	L.append("```")
	L.append("")
	L.append("n=%d a row: one boxer, one opponent, %d bouts. The standard error on a 10%% chance at n=60 is about 3.9 points, so one row cannot place an edge. The %.1f-point bins:" % [n_bouts, n_bouts, BIN])
	L.append("")
	L.append("```")
	L.append_array(_bin_lines())
	L.append("```")
	L.append("")
	L.append("## The monotone blocks - the table the edges are read off")
	L.append("")
	L.append("The raw rows are NOT monotone: the three boxers' chins differ (Lucy %.0f, Kira %.0f, Josh %.0f), so which boxer lands in a bin moves it as much as the gap does. A monotone word(gap) cannot honour every raw row. The bins are therefore pooled into monotone blocks - a bin whose our-stopped chance is lower than the block before it joins that block (pool adjacent violators) - and the edges are read off the blocks:" % [
		_chin("Lucy Jackson"), _chin("Kira Mensah"), _chin("Josh Harper")])
	L.append("")
	L.append("```")
	L.append_array(_block_lines())
	L.append("```")
	L.append("")
	L.append("Stoppage kinds over the %d bouts: %s." % [bouts_played, str(kinds)])
	L.append("")
	L.append("## The bands")
	L.append("")
	L.append("- the %.0f%% edge: %s -> **%+.2f**." % [StopWord.CHANCE_POSSIBLE * 100.0, str(rp["why"]), float(rp["at"])])
	L.append("- the %.0f%% edge: %s -> **%+.2f**." % [StopWord.CHANCE_RISK * 100.0, str(rr["why"]), float(rr["at"])])
	L.append("")
	L.append("`scripts/rules/StopWord.gd` (pure, no preloads) carries the rating edges, rounded to the nearest half point so the card's cut is a readable number and still separates every block:")
	L.append("")
	L.append("```")
	L.append("const CHANCE_POSSIBLE := %.2f   # the brief's chance edge, on OUR boxer being stopped" % StopWord.CHANCE_POSSIBLE)
	L.append("const CHANCE_RISK := %.2f" % StopWord.CHANCE_RISK)
	L.append("const POSSIBLE_GAP := %+.2f    # rating points: below this, unlikely" % StopWord.POSSIBLE_GAP)
	L.append("const RISK_GAP := %+.2f        # rating points: at or above this, a real risk" % StopWord.RISK_GAP)
	L.append("```")
	L.append("")
	var reached := {}
	for b in blocks:
		var w := _band(_pct(b, "our"))
		if not reached.has(w):
			reached[w] = []
		(reached[w] as Array).append("%.1f%%" % _pct(b, "our"))
	var parts: Array = []
	for w in ["unlikely", "possible", "a real risk"]:
		parts.append("%s (%s)" % [w, ", ".join(reached[w]) if reached.has(w) else "NOT REACHED"])
	L.append("The measured blocks reach: %s." % "; ".join(parts))
	L.append("")
	var bad := 0
	for k in _keys(pooled):
		var b: Dictionary = _block_of(float(k))
		if b.is_empty() or StopWord.word(float(k)) != _band(_pct(b, "our")):
			bad += 1
	L.append("**Every measured gap against its block's band: %d disagreements of %d rows.**" % [bad, pooled.size()])
	L.append("")
	var dis := _disagreements()
	if dis.is_empty():
		L.append("No raw row disagrees with the word the rule gives it.")
	else:
		L.append("%d raw rows disagree with their OWN chance band, and the rule cannot honour them without breaking monotonicity. They are the chin confound, not a bug in the rule:" % dis.size())
		L.append("")
		for d in dis:
			L.append("- " + d)
	L.append("")
	L.append("## What this means for the card")
	L.append("")
	L.append("The word is a POPULATION read on the gap, not a per-boxer read. Kira (chin %.0f, \"fast hands, thin chin\") is stopped %.1f%% and %.1f%% at gaps of %+.2f and %+.2f - already \"possible\" against an opponent rated level with her - while Lucy (chin %.0f) is stopped %.1f%% at %+.2f. A thin-chinned boxer meets the risk sooner than the gap alone says; a thick-chinned one later. Wiring the word into AskFlow should keep that in mind: the card's word is the coach's read on the OTHER boxer's level, which is what the map asks for, not a promise about this boxer's chin." % [
		_chin("Kira Mensah"), _pct(_row_of("Kira Mensah", -0.67), "our"), _pct(_row_of("Kira Mensah", -0.17), "our"),
		-0.67, -0.17, _chin("Lucy Jackson"), _pct(_row_of("Lucy Jackson", 4.07), "our"), 4.07])
	L.append("")
	L.append("## The trap")
	L.append("")
	var hole_lo := -INF
	var hole_hi := INF
	for k in _keys(pooled):
		if float(k) < StopWord.RISK_GAP:
			hole_lo = maxf(hole_lo, float(k))
		elif hole_hi == INF:
			hole_hi = float(k)
	L.append("A weight class holds only 4-11 amateurs, so at a big asked gap the nearest available opponent is far from the gap asked for: every table above is bucketed by the REAL gap of each bout, never by the asked one. Where the pool runs out the asked gap is left unmeasured (n=0) rather than repeated. No measured gap falls between %+.2f and %+.2f - no amateur in any of the three classes is rated there - so the upper edge sits in that hole." % [hole_lo, hole_hi])
	L.append("")
	L.append("Reproduce: `python ops/Tools/godot_slot.py run --who stopword1 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --log-file E:/FightCamp/tmp/stopword1.log --script res://tools/stop_word_probe.gd -- bouts=%d`" % n_bouts)
	var fh := FileAccess.open(DOC, FileAccess.WRITE)
	if fh == null:
		print("WARNING: could not write %s" % DOC)
		return
	fh.store_string("\n".join(L) + "\n")
	fh.close()
	print("\nwrote %s" % DOC)


func _row_of(nm: String, real: float) -> Dictionary:
	for r in rows:
		if str(r["boxer"]) == nm and absf(float(r["real"]) - real) < 0.005:
			return r
	return {"n": 0, "our": 0}


func _chin(nm: String) -> float:
	for f in club:
		if str(f["name"]) == nm:
			return float(f["stats"].get("chin", 0.0))
	return 0.0
