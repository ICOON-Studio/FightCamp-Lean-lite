extends SceneTree
## S548 MATCHBOTS2 probe: why the bot that scouts is stopped more since S535 DMGCLASS2. The four bots are the test's own
## (tests/matchmaking_bots_test.gd, preloaded, never pasted); only the bout call is swapped for a COPY of MM.fight /
## WorldBout.fast with the pro flag chosen by the arm. Nothing in WorldBout, Knockdowns or Matchmaking changes.
##   -- arm=head      the game's own MM.fight (pro bouts: no four-count limit)
##   -- arm=copy_pro  the copy with the pro flag as the game sets it (must print the same lines as head: the copy is faithful)
##   -- arm=amlimit   the copy with the four-count limit back (rounds >= PRO_FROM forced false)
##   careers=<n> bots=easy,hard,smart,blind rows=<csv path> look=0|1 (S559 NIGHTREDS2: the scout looks at the fight it signs) (one row per bout of every bot: the facts before the bell)
## Prints the test's lines and bars for the arm, then MB2_DONE.

const BotTest := preload("res://tests/matchmaking_bots_test.gd")
const MM := preload("res://scripts/rules/Matchmaking.gd")
const WB := preload("res://scripts/world/WorldBout.gd")
const Knockdowns := preload("res://scripts/rules/Knockdowns.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

var arm := "head"
var rows: Array = []
var pre := {}
var look := true   # look=0: the scout signs on the level read once its two looks are spent (the bot before NIGHTREDS2)


func _initialize() -> void:
	var careers := BotTest.CAREERS
	var bots := ["easy", "hard", "smart", "blind"]
	var out := ""
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=", true, 1)
		if kv.size() < 2:
			continue
		match kv[0]:
			"arm": arm = kv[1]
			"careers": careers = int(kv[1])
			"bots": bots = Array(kv[1].split(","))
			"rows": out = kv[1]
			"look": look = kv[1] != "0"
	var t = BotTest.new()
	t.careers = careers
	t.sign_look = look
	if arm != "head":
		t.bout_fn = _fight.bind(arm == "copy_pro")
	else:
		t.bout_fn = _head
	t.on_bout = _log
	var res := {}
	for bot in bots:
		res[bot] = t._run(bot)
		var r: Dictionary = res[bot]
		print("%s %-5s end place median %4.1f  top-10 %2d/%d  rating +%.1f  gym money $%d  record %.1f-%.1f  stopped %.2f  belts %d" % [
			arm, bot, r["place"], r["top10"], careers, r["grow"], r["money"], r["w"], r["l"], r["stopped"], r["belts"]])
	if res.has("smart") and res.has("hard"):
		print("%s bar smart beats hard by >= %.0f: %+.1f" % [arm, BotTest.HARD_MARGIN, float(res["hard"]["place"]) - float(res["smart"]["place"])])
	if res.has("smart") and res.has("easy"):
		print("%s bar smart beats easy by >= %.0f: %+.1f" % [arm, BotTest.EASY_MARGIN, float(res["easy"]["place"]) - float(res["smart"]["place"])])
	if res.has("smart") and res.has("blind"):
		print("%s bar scouting top-10 >= %d: %+d   stopped < 0: %+.2f" % [arm, BotTest.SCOUT_TOP10,
			int(res["smart"]["top10"]) - int(res["blind"]["top10"]), float(res["smart"]["stopped"]) - float(res["blind"]["stopped"])])
	if out != "":
		var fa := FileAccess.open(out, FileAccess.WRITE)
		fa.store_line("arm,bot,career,month_bout,opp_rank,opp_rating,gap,opp_power,opp_ko,opp_w,our_chin,our_heart,screen_stop,scouted,read_mid,shown_mid,kind,won,stop")
		for r in rows:
			fa.store_line(",".join(PackedStringArray(r.map(func(x): return str(x)))))
		fa.close()
	t.free()
	print("MB2_DONE rows=%d" % rows.size())
	quit(0)


## The facts before the bell (the bout changes the record), kept for _log.
func _facts(p: Dictionary, opp: Dictionary) -> void:
	var so: Dictionary = WB._side(WB.profile(opp))
	var sp: Dictionary = WB._side(WB.profile(p))
	pre = {"opp_rank": int(opp.get("rank", 0)), "opp_rating": float(opp["rating"]), "gap": float(opp["rating"]) - float(p["rating"]),
		"opp_power": float(so["power"]), "opp_ko": int(opp.get("ko", 0)), "opp_w": int(opp.get("w", 0)), "our_chin": float(sp["chin"]),
		"our_heart": float(sp["heart"])}


func _head(p: Dictionary, opp: Dictionary, boxers: Array, rng: RandomNumberGenerator) -> Dictionary:
	_facts(p, opp)
	return MM.fight(p, opp, boxers, rng)


func _log(bot: String, c: int, p: Dictionary, opp: Dictionary, read: Dictionary, line: Dictionary) -> void:
	var mid := float(read.get("shown", -1.0))
	rows.append([arm, bot, c, (p["log"] as Array).size(), pre["opp_rank"], snappedf(pre["opp_rating"], 0.1), snappedf(pre["gap"], 0.1),
		snappedf(pre["opp_power"], 0.1), pre["opp_ko"], pre["opp_w"], snappedf(pre["our_chin"], 0.1), snappedf(pre["our_heart"], 0.1),
		snappedf(_screen_stop(mid, pre), 0.001) if mid >= 0.0 else -1, int(bool(read.get("scouted", false))),
		snappedf(float(read.get("mid", -1.0)), 0.001), snappedf(mid, 0.001), str(read.get("kind", "")), int(bool(line["won"])), int(bool(line["stop"]))])


## MM.stop_chance on the record as it stood before the bell (what the pro row's "Stopped: N% chance" line showed).
func _screen_stop(mid: float, f: Dictionary) -> float:
	var wins := int(f["opp_w"])
	var ko_share := maxf(0.1, float(f["opp_ko"]) / float(wins)) if wins > 0 else 0.25
	return clampf((1.0 - mid) * ko_share, 0.0, 1.0)


## A copy of MM.fight with the bout below.
func _fight(p: Dictionary, opp: Dictionary, boxers: Array, rng: RandomNumberGenerator, pro: bool) -> Dictionary:
	_facts(p, opp)
	var r := _fast(p, opp, MM.ROUNDS, rng, pro)
	var won := str(r["winner"]) == "a" or (str(r["winner"]) == "" and rng.randf() < 0.5)
	var stop := bool(r["stopped"])
	var line := MM.apply_result(p, opp, boxers, won, stop)
	p["money"] = int(p["money"]) + int(round(float(int(line["purse"]) + int(line["tickets"])) * MM.GYM_SHARE))
	return line


## A copy of WorldBout.fast; the one difference is the pro flag handed to Knockdowns.round_counts (the arm's).
func _fast(x: Dictionary, y: Dictionary, rounds: int, rng: RandomNumberGenerator, pro: bool) -> Dictionary:
	var c := WB.cached(x, y, rounds)
	var rws: Array = c["rows"]
	var sides: Dictionary = c.get("sides", {})
	if sides.is_empty():
		sides = {"a": WB._side(WB.profile(x)), "b": WB._side(WB.profile(y))}
	var form := rng.randfn(0.0, WB.FORM_SD) - rng.randfn(0.0, WB.FORM_SD) + float(c["extra"])
	var won := [0, 0]
	var counts := {"a": 0, "b": 0}
	var damage := {"a": 0.0, "b": 0.0}
	for n in rounds:
		var sum := 0.0
		var wn := 0
		for i in Exchanges.EXCHANGES:
			var margin := float(rws[n][i]) + form + (rng.randf() - 0.5) * Exchanges.EX_SPREAD - (rng.randf() - 0.5) * Exchanges.EX_SPREAD
			sum += margin
			wn += 1 if margin >= 0.0 else 0
		var a_round := wn * 2 > Exchanges.EXCHANGES or (wn * 2 == Exchanges.EXCHANGES and sum >= 0.0)
		won[0 if a_round else 1] += 1
		var loser := "b" if a_round else "a"
		var k := Knockdowns.round_counts(Exchanges.band(sum / float(Exchanges.EXCHANGES)), loser, sides, damage, counts, rng, pro)
		damage = k["damage"]
		counts[loser] = int(counts[loser]) + int(k["counts"])
		if bool(k["stopped"]):
			return WB._out("a" if loser == "b" else "b", true, str(k["how"]), n + 1, won, counts, [0, 0, 0], {})
		var winner := "a" if loser == "b" else "b"
		var kc := Knockdowns.puncher_chance(winner, sides, damage, counts, rng)
		counts[winner] = int(counts[winner]) + int(kc["counts"])
		if bool(kc["stopped"]):
			return WB._out(loser, true, str(kc["how"]), n + 1, won, counts, [0, 0, 0], {})
	var w := "a" if won[0] > won[1] else ("b" if won[1] > won[0] else "")
	return WB._out(w, false, "", rounds, won, counts, [0, 0, 0], {})
