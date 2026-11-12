extends SceneTree
## RIBS1: ribs take damage on both sides, at a size that matters, and the ring keeps the body shots the fight settled.
## Path: LiveRound settles each exchange (the fight rules' body count) -> ExchangeBeats.build -> BodyMap.add_beats.
## The hooks counted below are the beats handed to add_beats, not a second tally.
## Population: Lucy Jackson (orthodox out-boxer, a step plan) vs Priya Nair (orthodox counter-puncher). They differ in
## stats, technique and plan. 200 seeds, 3-round amateur. Arms: default share 0.2, body plan share 0.5, head share 0.08.
## S439: the two rates that sit near their bars ("body plan target more-hit rib at or under 35", "S318 loser hurt") are
## judged on the MEAN of EIGHT disjoint 200-day windows (days 1000..2599; one window's sd is about 3 points), every
## window printed (RIB_WINDOW). The other checks read the first window (days 1000..1199) as before.

const Data := preload("res://scripts/state/Data.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const ExchangeBeats := preload("res://scripts/fight3d/ExchangeBeats.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const RoundScript := preload("res://scripts/rules/RoundScript.gd")

const SEEDS := 200
const WINDOWS := 8
const SOUTH := {"a": false, "b": false}

var failures := 0
var _base: Dictionary = {}
var _opp: Dictionary = {}
var _worst := 0
var _worst_where := ""
## Rounds where some exchange's settled body count cannot be reached by retagging free singles (too few of them, or more
## combination / big-shot body hooks than the count): the ring retags singles only, so those rounds may miss. Counted and printed apart (RIB_SHORT), not judged by 1b.
var _rounds := 0
var _short := 0
var _short_worst := 0
var _short_gap_sum := 0
var _day0 := 1000
var _quiet := false


func _initialize() -> void:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), 1000))
	_base = (c.fighter() as Dictionary).duplicate(true)
	_base["camp"] = {}
	_base["arrows"] = [{"move": "step_back"}, {"move": "pivot_out"}]
	_opp = (Data.OPPONENTS[1] as Dictionary).duplicate(true)
	_header()
	if OS.get_cmdline_user_args().has("probe"):
		_probe(c)
		quit(0)
		return
	var plain: Dictionary = _arm(c, "default", "", "")
	var body: Dictionary = _arm(c, "body", "body", "")
	var head: Dictionary = _arm(c, "head", "", "head")
	_emit(plain)
	_emit(body)
	_emit(head)
	var crit_w: Array = [float(body["critical_pct"])]
	var loser_w: Array = [float(plain["loser_hurt"])]
	print("RIB_WINDOW 0 days %d..%d body_crit=%.1f loser_hurt=%.1f" % [_day0, _day0 + SEEDS - 1, crit_w[0], loser_w[0]])
	var keep: Array = [_worst, _worst_where, _rounds, _short, _short_worst, _short_gap_sum]
	_quiet = true
	for w in range(1, WINDOWS):
		_day0 = 1000 + w * SEEDS
		var p2: Dictionary = _arm(c, "default", "", "")
		var b2: Dictionary = _arm(c, "body", "body", "")
		crit_w.append(float(b2["critical_pct"]))
		loser_w.append(float(p2["loser_hurt"]))
		print("RIB_WINDOW %d days %d..%d body_crit=%.1f loser_hurt=%.1f" % [w, _day0, _day0 + SEEDS - 1, crit_w[w], loser_w[w]])
	_quiet = false
	_day0 = 1000
	_worst = keep[0]
	_worst_where = keep[1]
	_rounds = keep[2]
	_short = keep[3]
	_short_worst = keep[4]
	_short_gap_sum = keep[5]
	_judge(plain, body, head, crit_w, loser_w)
	print("RIB_MATCH worst=%d %s" % [_worst, _worst_where])
	print("RIB_SHORT rounds=%d of %d worst_gap=%d mean_gap=%.2f (settled body count out of the free singles' reach; not judged)" % [
		_short, _rounds, _short_worst, float(_short_gap_sum) / float(maxi(_short, 1))])
	print("RIB_DAMAGE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _header() -> void:
	var st: Dictionary = _base["stats"]
	print("population: %s %s %s power %.1f technique %.1f plan step_back/pivot_out vs %s %s %s rating %.1f threat %s; %d seeds, 3-round amateur" % [
		str(_base["first"]), str(_base["stance"]), str(_base["style"]), float(st["power"]), float(st["technique"]),
		str(_opp["first"]), str(_opp["stance"]), str(_opp["style"]), float(_opp["rating"]), str(_opp["threat"]), SEEDS])


func _fresh(c: Career, day: int) -> Dictionary:
	c.day = day
	c.fighters[0] = _base.duplicate(true)
	var f: Dictionary = c.fighter()
	f["bout"] = {"opp": _opp.duplicate(true), "day": day, "weighed": true, "made": true, "done": false, "film": 3, "rounds": 3}
	return f


## One bout. Returns the map BodyMap built from the ring beats, plus the round tallies.
func _fight(c: Career, f: Dictionary, plan: String, aim: String, tag: String) -> Dictionary:
	BoutNight._peak(c, f)
	var m: Dictionary = {"fid": str(f["id"]), "step": "tape", "round": 0, "rounds": [], "total": 3, "type": "fight"}
	var map: Dictionary = BodyMap.fresh()
	var a_wins := 0
	var rounds_n := 0
	var shots := 0
	var shots_b := 0
	var won_last := false
	for n in range(1, 4):
		var energy: Dictionary = BoutNight._energy(f, n, plan)
		LiveRound.open(c, f, m, n, plan, energy)
		if aim != "":
			LiveRound.live(m)["aim"] = aim
		var closed: Dictionary = {}
		while not LiveRound.live(m).is_empty():
			var step: Dictionary = LiveRound.exchange(c, f, m, "")
			if not step.is_empty():
				closed = step
		if closed.is_empty():
			break
		(m["rounds"] as Array).append(closed)
		var pack: Dictionary = _beats(c, f, closed, plan, won_last)
		var beats: Array = pack["beats"]
		BodyMap.add_beats(map, beats, SOUTH)
		var got_a: int = int(pack["got_a"])
		var got_b: int = int(pack["got_b"])
		var want_a: int = int(pack["want_a"])
		var want_b: int = int(pack["want_b"])
		shots += got_a + got_b
		shots_b += got_b
		if tag == "probe":
			print("PROBE r%d a %d/%d b %d/%d %s" % [n, got_a, want_a, got_b, want_b, str(pack["rows"])])
		var gap: int = maxi(absi(got_a - want_a), absi(got_b - want_b))
		_rounds += 1
		if not bool(pack["fits"]):
			_short += 1
			_short_worst = maxi(_short_worst, gap)
			_short_gap_sum += gap
		elif gap > _worst:
			_worst = gap
			_worst_where = "%s day %d round %d a %d/%d (land %d free %d) b %d/%d (land %d free %d) [%s]" % [tag, c.day, n,
				got_a, want_a, int(pack["land_a"]), int(pack["free_a"]), got_b, want_b, int(pack["land_b"]), int(pack["free_b"]),
				str(pack["rows"])]
		if bool(closed["won"]):
			a_wins += 1
		rounds_n += 1
		won_last = bool(closed["won"])
	return {"map": map, "a_wins": a_wins, "rounds_n": rounds_n, "shots": shots, "shots_b": shots_b}


## ExchangeBeats for one closed round, as the ring builds it: empty round record until the last exchange.
## got_* is the landed body_hook count in the beats add_beats receives. want_* is the fight rules' body count.
func _beats(c: Career, f: Dictionary, r: Dictionary, plan: String, won_last: bool) -> Dictionary:
	var opp: Dictionary = f["bout"]["opp"]
	var n: int = int(r["n"])
	var profiles: Dictionary = {"a": RoundStyle.of_fighter(f), "b": RoundStyle.from_opponent(opp)}
	var ctx: Dictionary = {"n": n, "plan": plan, "a_style": str(f.get("style", "")), "b_style": str(opp.get("style", "")),
		"seed": c.day * 97 + n, "profiles": profiles, "f": f, "opp": opp,
		"names": [str(f["first"]), str(opp["first"])], "day": c.day, "won_last": won_last}
	var energy: Dictionary = r.get("energy", {})
	var exs: Array = r["exchanges"]
	var all: Array = []
	var got_a := 0
	var got_b := 0
	var want_a := 0
	var want_b := 0
	var rows: PackedStringArray = []
	var any_a := 0
	var any_b := 0
	var ribs_b := 0
	var short_a := 0
	var short_b := 0
	var short_ribs := 0
	var fits := true
	var e0a: float = float(energy.get("a", 100.0))
	var e1a: float = float(energy.get("a_end", e0a))
	var e0b: float = float(energy.get("b", 100.0))
	var e1b: float = float(energy.get("b_end", e0b))
	var den: float = float(Exchanges.EXCHANGES)
	for k in exs.size():
		profiles["a"]["energy"] = lerpf(e0a, e1a, float(k) / den)
		profiles["a"]["energy_end"] = lerpf(e0a, e1a, float(k + 1) / den)
		profiles["b"]["energy"] = lerpf(e0b, e1b, float(k) / den)
		profiles["b"]["energy_end"] = lerpf(e0b, e1b, float(k + 1) / den)
		var round_arg: Dictionary = r if k == exs.size() - 1 else {}
		var built: Array = ExchangeBeats.build(exs[k], k, round_arg, ctx)
		all.append_array(built)
		got_a += _hooks(built, "a")
		got_b += _hooks(built, "b")
		var body: Array = (exs[k] as Dictionary)["body"]
		if not _fits(built, "a", int(body[0])) or not _fits(built, "b", int(body[1])):
			fits = false
		want_a += int(body[0])
		want_b += int(body[1])
		rows.append("k%d a %d/%d land %d | b %d/%d land %d" % [k, _hooks(built, "a"), int(body[0]), _pool(built, "a", false),
			_hooks(built, "b"), int(body[1]), _pool(built, "b", false)])
		var la := _any_landed(built, "a")
		var lb := _any_landed(built, "b")
		any_a += la
		any_b += lb
		var rib := 0
		var cl: Dictionary = (exs[k] as Dictionary).get("clinch", {})
		if bool(cl.get("hit", false)):
			rib = int(cl.get("shots", 0)) - (1 if bool(cl.get("head", false)) else 0)
			ribs_b += rib
		short_a += maxi(0, int(body[0]) - la)
		short_b += maxi(0, int(body[1]) - lb)
		short_ribs += maxi(0, int(body[1]) - rib - lb)
	return {"beats": all, "fits": fits, "got_a": got_a, "got_b": got_b, "want_a": want_a, "want_b": want_b, "rows": " ".join(rows),
		"any_a": any_a, "any_b": any_b, "ribs_b": ribs_b, "short_a": short_a, "short_b": short_b, "short_ribs": short_ribs,
		"land_a": _pool(all, "a", false), "free_a": _pool(all, "a", true),
		"land_b": _pool(all, "b", false), "free_b": _pool(all, "b", true)}


func _probe(c: Career) -> void:
	var over_punch := 0
	var over_after_ribs := 0
	var max_punch := 0
	var max_after := 0
	var rounds := 0
	for s in SEEDS:
		var f: Dictionary = _fresh(c, 1000 + s)
		var bout: Dictionary = _gaps(c, f)
		rounds += int(bout["rounds"])
		over_punch += int(bout["over_punch"])
		over_after_ribs += int(bout["over_after"])
		max_punch = maxi(max_punch, int(bout["max_punch"]))
		max_after = maxi(max_after, int(bout["max_after"]))
	print("PROBE rounds=%d over_punch=%d max_punch=%d over_after_ribs=%d max_after=%d" % [rounds, over_punch, max_punch, over_after_ribs, max_after])


## One default bout: how far the settled body count sits above the landed punches the ring actually has.
func _gaps(c: Career, f: Dictionary) -> Dictionary:
	BoutNight._peak(c, f)
	var m: Dictionary = {"fid": str(f["id"]), "step": "tape", "round": 0, "rounds": [], "total": 3, "type": "fight"}
	var over_punch := 0
	var over_after := 0
	var max_punch := 0
	var max_after := 0
	var rounds := 0
	var won_last := false
	for n in range(1, 4):
		var energy: Dictionary = BoutNight._energy(f, n, "")
		LiveRound.open(c, f, m, n, "", energy)
		var closed: Dictionary = {}
		while not LiveRound.live(m).is_empty():
			var step: Dictionary = LiveRound.exchange(c, f, m, "")
			if not step.is_empty():
				closed = step
		if closed.is_empty():
			break
		(m["rounds"] as Array).append(closed)
		var pack: Dictionary = _beats(c, f, closed, "", won_last)
		var gap_side: int = maxi(int(pack["short_a"]), int(pack["short_b"]))
		var gap_ribs: int = maxi(int(pack["short_a"]), int(pack["short_ribs"]))
		over_punch += int(gap_side > 1)
		over_after += int(gap_ribs > 1)
		max_punch = maxi(max_punch, gap_side)
		max_after = maxi(max_after, gap_ribs)
		rounds += 1
		won_last = bool(closed["won"])
	return {"rounds": rounds, "over_punch": over_punch, "over_after": over_after, "max_punch": max_punch, "max_after": max_after}


func _any_landed(beats: Array, who: String) -> int:
	var n := 0
	for b in beats:
		if str(b["who"]) != who or str(b["result"]) != "lands":
			continue
		if RoundScript.NOT_PUNCH.has(str(b["move"])) or str(b["move"]) == "say":
			continue
		n += 1
	return n


## Can the ring's last body pass (singles only) reach the settled count for one side in this exchange? It retags free
## singles both ways, never a combination punch or a big shot: reachable when the body hooks it cannot touch are at most
## the count, and those plus the free singles are at least the count.
func _fits(beats: Array, who: String, want: int) -> bool:
	var fixed := 0
	var free_n := 0
	for b in beats:
		if str(b["who"]) != who or str(b["result"]) != "lands" or not RoundScript.PUNCHES.has(str(b["move"])):
			continue
		var free: bool = str(b.get("combo_id", "")) == "" and not bool(b.get("combo", false)) and not bool(b.get("big", false))
		if free:
			free_n += 1
		elif str(b["move"]) == "body_hook":
			fixed += 1
	return fixed <= want and want <= fixed + free_n


func _hooks(beats: Array, who: String) -> int:
	var n := 0
	for b in beats:
		if str(b["who"]) == who and str(b["result"]) == "lands" and str(b["move"]) == "body_hook":
			n += 1
	return n


## Landed punches for one side. free_only counts the singles the early pass is allowed to retag.
func _pool(beats: Array, who: String, free_only: bool) -> int:
	var n := 0
	for b in beats:
		if str(b["who"]) != who or str(b["result"]) != "lands":
			continue
		if not (str(b["move"]) in BodyMap.PUNCHES):
			continue
		if free_only and (str(b.get("combo_id", "")) != "" or bool(b.get("combo", false)) or bool(b.get("big", false))):
			continue
		n += 1
	return n


func _arm(c: Career, name: String, plan: String, aim: String) -> Dictionary:
	var liver_sum := 0.0
	var other_sum := 0.0
	var liver_loss := 0.0
	var other_loss := 0.0
	var places := 0
	var more_sum := 0.0
	var more_min := 100.0
	var tgt_liver := 0.0
	var tgt_other := 0.0
	var hurt_n := 0
	var crit_n := 0
	var any35 := 0
	var shots := 0
	var bouts := 0
	var loser_hurt := 0
	var doctor_n := 0
	var winner_fine := 0
	var short := 0
	for s in SEEDS:
		if s % 50 == 0 and not _quiet:
			print("RIB_PROGRESS %s %d" % [name, s])
		var f: Dictionary = _fresh(c, _day0 + s)
		var bout: Dictionary = _fight(c, f, plan, aim, name)
		if int(bout["rounds_n"]) != 3:
			short += 1
		var map: Dictionary = bout["map"]
		bouts += 1
		shots += int(bout["shots"])
		var low := 100.0
		var low_b := 100.0
		var rib35 := false
		for who in ["a", "b"]:
			var rv: float = BodyMap.value(map, who, "right_ribs")
			var lv: float = BodyMap.value(map, who, "left_ribs")
			liver_sum += rv
			other_sum += lv
			liver_loss += 100.0 - rv
			other_loss += 100.0 - lv
			places += 1
			low = minf(low, minf(rv, lv))
			if rv <= BodyMap.CRITICAL or lv <= BodyMap.CRITICAL:
				rib35 = true
			if who == "b":
				tgt_liver += rv
				tgt_other += lv
				low_b = minf(rv, lv)
		if rib35:
			any35 += 1
		var tracked: float = low if name == "default" else low_b
		more_sum += tracked
		more_min = minf(more_min, tracked)
		var under_hurt: bool = tracked < BodyMap.HURT if name == "default" else tracked <= BodyMap.HURT
		if under_hurt:
			hurt_n += 1
		if tracked <= BodyMap.CRITICAL:
			crit_n += 1
		var marks: Dictionary = _marks(map, int(bout["a_wins"]), int(bout["rounds_n"]))
		if bool(marks["hurt"]):
			loser_hurt += 1
		if bool(marks["doc"]):
			doctor_n += 1
		if bool(marks["fine"]):
			winner_fine += 1
	if not _quiet:
		_check(short == 0, "%s: every bout went 3 rounds (%d stopped early)" % [name, short])
	var bf: float = float(maxi(bouts, 1))
	var pf: float = float(maxi(places, 1))
	return {"name": name, "liver_mean": liver_sum / pf, "other_mean": other_sum / pf,
		"hurt_pct": float(hurt_n) / bf * 100.0, "critical_pct": float(crit_n) / bf * 100.0,
		"shots_mean": float(shots) / bf, "more_hit_mean": more_sum / bf, "more_min": more_min,
		"target_liver": tgt_liver / bf, "target_other": tgt_other / bf,
		"any35": float(any35) / bf * 100.0, "liver_loss": liver_loss, "other_loss": other_loss,
		"loser_hurt": float(loser_hurt) / bf * 100.0, "doctor": float(doctor_n) / bf * 100.0,
		"winner_fine": float(winner_fine) / bf * 100.0}


func _marks(map: Dictionary, a_wins: int, rounds_n: int) -> Dictionary:
	var winner := "a" if a_wins * 2 > rounds_n else "b"
	var loser := "b" if winner == "a" else "a"
	var hurt := false
	var doc := false
	var fine := true
	for place in BodyMap.PLACES:
		var lv: float = BodyMap.value(map, loser, place)
		var wv: float = BodyMap.value(map, winner, place)
		if BodyMap.band(lv) != "fine":
			hurt = true
		if BodyMap.band(lv) == "doctor" or BodyMap.band(wv) == "doctor":
			doc = true
		if BodyMap.band(wv) != "fine":
			fine = false
	return {"hurt": hurt, "doc": doc, "fine": fine}


func _emit(row: Dictionary) -> void:
	print("RIB_ARM %s liver_mean=%.1f other_mean=%.1f hurt_pct=%.1f critical_pct=%.1f shots_mean=%.1f" % [
		str(row["name"]), float(row["liver_mean"]), float(row["other_mean"]), float(row["hurt_pct"]),
		float(row["critical_pct"]), float(row["shots_mean"])])
	print("RIB_DETAIL %s more_hit=%.1f more_min=%.1f target_liver=%.1f target_other=%.1f any35=%.1f" % [
		str(row["name"]), float(row["more_hit_mean"]), float(row["more_min"]), float(row["target_liver"]),
		float(row["target_other"]), float(row["any35"])])


func _mean(xs: Array) -> float:
	var t := 0.0
	for x in xs:
		t += float(x)
	return t / float(maxi(xs.size(), 1))


func _judge(plain: Dictionary, body: Dictionary, head: Dictionary, crit_w: Array, loser_w: Array) -> void:
	var loss_l: float = float(plain["liver_loss"])
	var loss_o: float = float(plain["other_loss"])
	var loss_all: float = loss_l + loss_o
	var share: float = loss_l / loss_all if loss_all > 0.0 else 0.0
	_check(loss_l > 0.0 and loss_o > 0.0, "both rib sides take damage (liver loss %.1f, other loss %.1f)" % [loss_l, loss_o])
	_check(share >= 0.50 and share <= 0.70, "liver side is %.1f%% of rib damage (50-70)" % (share * 100.0))
	_check(_worst <= 1, "every round that fits the free singles, each side's body hooks match the settled count within 1 (worst %d, %d of %d rounds fit)" % [
		_worst, _rounds - _short, _rounds])
	var mh: float = float(plain["more_hit_mean"])
	_check(mh >= 62.0 and mh <= 82.0, "default more-hit rib averages %.1f (62-82)" % mh)
	_check(float(plain["hurt_pct"]) <= 15.0, "default more-hit rib under 55 in %.1f%% (at most 15)" % float(plain["hurt_pct"]))
	_check(float(body["hurt_pct"]) >= 60.0, "body plan target more-hit rib at or under 55 in %.1f%% (at least 60)" % float(body["hurt_pct"]))
	var cm: float = _mean(crit_w)
	_check(cm <= 20.0, "body plan target more-hit rib at or under 35 in %.1f%% (at most 20; mean of %d windows: %s)" % [cm, crit_w.size(),
		" ".join(PackedStringArray(crit_w.map(func(x): return "%.1f" % x)))])
	_check(float(head["target_liver"]) > 85.0 and float(head["target_other"]) > 85.0,
		"head-only target ribs average %.1f and %.1f (both above 85)" % [float(head["target_liver"]), float(head["target_other"])])
	var lm: float = _mean(loser_w)
	_check(lm >= 40.0 and lm <= 90.0, "S318 loser hurt %.1f%% (40-90; mean of %d windows: %s)" % [lm, loser_w.size(),
		" ".join(PackedStringArray(loser_w.map(func(x): return "%.1f" % x)))])
	_check(float(plain["doctor"]) <= 8.0, "S318 doctor %.1f%% (at most 8)" % float(plain["doctor"]))
	_check(float(plain["winner_fine"]) >= 50.0, "S318 winner fine %.1f%% (at least 50)" % float(plain["winner_fine"]))
	print("S318 loser_hurt=%.1f (first window; mean %.1f) doctor=%.1f winner_fine=%.1f" % [float(plain["loser_hurt"]), lm, float(plain["doctor"]), float(plain["winner_fine"])])
	print("RIB_INJURY default_any35=%.1f body_any35=%.1f" % [float(plain["any35"]), float(body["any35"])])


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
